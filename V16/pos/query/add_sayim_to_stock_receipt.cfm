<cfset attributes.fis_type = 114>
<cfquery name="GET_PROCESS_TYPES" datasource="#DSN3#">
	SELECT IS_STOCK_ACTION FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<!--- kontroller  & tanimlamalar --->
<cf_papers paper_type="STOCK_FIS">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset attributes.fis_no = system_paper_no >
<cf_date tarih = 'attributes.fis_date'>
<cfquery name="GET_MONEY_FIS" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
</cfquery>
<cfquery name="GET_FIS_NO" datasource="#dsn2#">
	SELECT FIS_NUMBER FROM STOCK_FIS WHERE FIS_NUMBER = '#attributes.fis_no#'
</cfquery>

<cfif get_fis_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='143.Fiş Numaranız Kullanılmaktadır'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_sayim_row" datasource="#dsn2#">
	SELECT 
		SS.*,
		SY.EXTRA_COLUMNS,
        SY.RECORD_DATE,
		S.STOCK_CODE,
		P.MANUFACT_CODE,
		S.STOCK_CODE_2,
		P.TAX_PURCHASE,
		PU.PRODUCT_UNIT_ID,
		PU.ADD_UNIT,
		S.IS_PRODUCTION,
		S.IS_PROTOTYPE,
		(SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC) SPECT_NEW
	FROM
		SAYIMLAR SY,
		SAYIM_SATIRLAR SS,
		#dsn3_alias#.PRODUCT P,
		#dsn3_alias#.STOCKS AS S,
		#dsn3_alias#.PRODUCT_UNIT AS PU
	WHERE 
		SY.GIRIS_ID = SS.SAYIM_ID AND 
		SAYIM_ID = #attributes.file_id# AND
		S.STOCK_ID = SS.STOCK_ID AND
		P.PRODUCT_ID = SS.PRODUCT_ID AND
		PU.IS_MAIN = 1 AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		PU.PRODUCT_ID = P.PRODUCT_ID
	ORDER BY
		S.STOCK_CODE
</cfquery>
<cfquery name="get_discount" datasource="#dsn3#">
	SELECT
		PRODUCT_ID,
		DISCOUNT1,
		DISCOUNT2,
		DISCOUNT3,
		DISCOUNT4,
		DISCOUNT5,
		RECORD_DATE		
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE 
		RECORD_DATE < #attributes.fis_date# AND PRODUCT_ID IN (#valuelist(get_sayim_row.product_id)#)
</cfquery>
<cfif session.ep.our_company_info.is_cost eq 1 ><!--- maliyet takip ediliyorsa baksın bu tablolara --->
	<cfquery name="GET_COST_ALL_" datasource="#dsn1#">
		SELECT
			PRODUCT_COST_ID,
			PRODUCT_ID,
			PURCHASE_NET_SYSTEM,
			PURCHASE_EXTRA_COST_SYSTEM,
			START_DATE,
			RECORD_DATE,
			SPECT_MAIN_ID,
			IS_SPEC
		FROM
			PRODUCT_COST
		WHERE 
			PRODUCT_ID IN (#valuelist(get_sayim_row.product_id)#)
			AND START_DATE <= #attributes.fis_date#
	</cfquery>
</cfif>
<cfset all_loop_count = 0>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
	<cfset loop_count = ceiling(get_sayim_row.recordcount/100)>
    <cfset attributes.file_import_total_all = ''>
    <cfloop from="1" to="#loop_count#" index="kkk">
            <cfquery name="get_rows_last" dbtype="query" maxrows="100">
				SELECT 
					*
				FROM 
					get_sayim_row
				<cfif isdefined("attributes.file_import_total_all") and len(attributes.file_import_total_all)>
					WHERE 
						SATIR_ID NOT IN(#attributes.file_import_total_all#)
				</cfif>
			</cfquery>
			<cfset attributes.file_import_total = valuelist(get_rows_last.SATIR_ID)>
			<cfset attributes.file_import_total_all = listappend(attributes.file_import_total_all,attributes.file_import_total)>
			<cfset attributes.islem_tarihi = dateformat(get_sayim_row.RECORD_DATE,dateformat_style)>
             <cfquery name="get_gen_paper" datasource="#DSN2#">
                SELECT STOCK_FIS_NUMBER, STOCK_FIS_NO FROM #dsn3_alias#.GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
            </cfquery>
            <cfset paper_code = evaluate('get_gen_paper.STOCK_FIS_NO')>
            <cfset paper_number = evaluate('get_gen_paper.STOCK_FIS_NUMBER') +1>
            <cfset paper_full = '#paper_code#-#paper_number#'>
             <cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
                UPDATE #dsn3_alias#.GENERAL_PAPERS SET STOCK_FIS_NUMBER = STOCK_FIS_NUMBER + 1 WHERE PAPER_TYPE IS NULL
            </cfquery>
			<cfset all_loop_count = all_loop_count + 1>
			<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#" result="MAX_ID">
                INSERT INTO
                    STOCK_FIS
                    (
                        FIS_TYPE,
                        PROCESS_CAT,
                        FIS_NUMBER,
                        DEPARTMENT_IN,
                        LOCATION_IN,
                        EMPLOYEE_ID,
                        FIS_DATE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #attributes.fis_type#,
                        #attributes.process_cat#,
                        '#paper_full#',
                        #attributes.department_in#,
                        #attributes.location_in#,
                        #session.ep.userid#,
                        #attributes.fis_date#,
                        #session.ep.userid#,
                        #now()#,
                        '#cgi.remote_addr#'
                    )
           </cfquery>
			<cfif len(session.ep.money2)>
                <cfset is_selected_money = session.ep.money2>
            <cfelse>
                <cfset is_selected_money = session.ep.money>
            </cfif>
            <cfoutput query="GET_MONEY_FIS">
                <cfquery name="ADD_FIS_MONEY" datasource="#dsn2#">
                    INSERT INTO
                        STOCK_FIS_MONEY
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            #MAX_ID.IDENTITYCOL#,
                            '#GET_MONEY_FIS.MONEY#',
                            #GET_MONEY_FIS.RATE2#,
                            #GET_MONEY_FIS.RATE1#,
                            <cfif GET_MONEY_FIS.MONEY eq is_selected_money>1<cfelse>0</cfif>
                        )
                </cfquery>
            </cfoutput>
            <cfoutput query="get_rows_last">
                <cfquery name="get_discount_record" dbtype="query" maxrows="1">
                    SELECT * FROM get_discount WHERE PRODUCT_ID = #product_id# ORDER BY RECORD_DATE DESC
                </cfquery>
                <cfif session.ep.our_company_info.is_cost eq 1><!--- maliyet takip ediliyorsa baksın bu tablolara --->
                    <cfquery name="GET_COST_" dbtype="query" maxrows="1">
                        SELECT 
                            PRODUCT_COST_ID,
                            PURCHASE_NET_SYSTEM,
                            PURCHASE_EXTRA_COST_SYSTEM
                        FROM 
                            GET_COST_ALL_ 
                        WHERE 
                            PRODUCT_ID=#product_id# AND
                            START_DATE <= #attributes.fis_date# AND
                            <cfif len(spect_main_id)>
                                SPECT_MAIN_ID=#spect_main_id#
                            <cfelse>
                                IS_SPEC = 0
                            </cfif>
                        ORDER BY 
                            START_DATE DESC,
                            RECORD_DATE DESC
                    </cfquery>
                </cfif>
				<cfscript>
                    if(isdefined("get_discount_record.discount1") and len(get_discount_record.discount1)) discount1=get_discount_record.discount1;else discount1=0;
                    if(isdefined("get_discount_record.discount2") and len(get_discount_record.discount2)) discount2=get_discount_record.discount2;else discount2=0;
                    if(isdefined("get_discount_record.discount3") and len(get_discount_record.discount3)) discount3=get_discount_record.discount3;else discount3=0;
                    if(isdefined("get_discount_record.discount4") and len(get_discount_record.discount4)) discount4=get_discount_record.discount4;else discount4=0;
                    if(isdefined("get_discount_record.discount5") and len(get_discount_record.discount5)) discount5=get_discount_record.discount5;else discount5=0;										
                    indirim_carpan = (100-discount1) * (100-discount2) * (100-discount3) * (100-discount4) * (100-discount5);
                    satir_toplam = miktar * standart_alis;
                    ship_fis_discount_ = (satir_toplam*(10000000000-indirim_carpan)) / 10000000000;
                    satir_toplam_net = satir_toplam - ship_fis_discount_;
                    kdv_toplam = (satir_toplam_net *tax_purchase)/100;
                    //standart_alis = (standart_alis*indirim_carpan) / 10000000000;
                    spec='';
                    if(len(spect_main_id))
                        row_spect_id = spect_main_id;
                    else if(is_production eq 1 and is_prototype eq 0 and len(spect_new))
                        row_spect_id = spect_new;
                    else
                        row_spect_id = '';
                    if(len(row_spect_id))
                    {
                        spec=specer(
                            dsn_type:dsn2,
                            spec_type:session.ep.our_company_info.spect_type,
                            main_spec_id:row_spect_id,
                            add_to_main_spec:1
                        );
                    }
                    
                    if(len(COST_PRICE) or len(EXTRA_COST))
                    {  
                        if(len(COST_PRICE)) cost_price_=COST_PRICE; else cost_price_=0;
                        if(len(EXTRA_COST))  extra_cost_price_=EXTRA_COST; else extra_cost_price_=0;
                    }
                    else if(session.ep.our_company_info.is_cost eq 1 and GET_COST_.RECORDCOUNT and len(GET_COST_.PRODUCT_COST_ID))
                    {
                        if(len(GET_COST_.PURCHASE_NET_SYSTEM))cost_price_=GET_COST_.PURCHASE_NET_SYSTEM; else cost_price_=0;
                        if(len(GET_COST_.PURCHASE_EXTRA_COST_SYSTEM)) extra_cost_price_=GET_COST_.PURCHASE_EXTRA_COST_SYSTEM; else extra_cost_price_=0;
                    }else
                    {
                        cost_price_=standart_alis;
                        extra_cost_price_=0;
                    }
                    GET_COST_.RECORDCOUNT=0;
                </cfscript>
                <cfquery name="add_stock_row" datasource="#DSN2#">
                    INSERT INTO 
                    STOCK_FIS_ROW
                    (
                        FIS_ID,
                        FIS_NUMBER,
                        STOCK_ID,
                        AMOUNT,
                        UNIT,
                        UNIT_ID,							
                        PRICE,
                        OTHER_MONEY,
                        TAX,
                        DISCOUNT1,
                        DISCOUNT2,
                        DISCOUNT3,
                        DISCOUNT4,
                        DISCOUNT5,				
                        TOTAL,
                        <!--- DISCOUNT, --->
                        TOTAL_TAX,
                        NET_TOTAL,
                        SPECT_VAR_ID,
                        SPECT_VAR_NAME,
                        COST_PRICE,
                        EXTRA_COST,
                        SHELF_NUMBER,
                        DELIVER_DATE,<!--- son kullanma tarihi--->
                        DUE_DATE,<!--- FİZİKSEL YAŞ GUNOLARAK GİRİLİYOR --->
                        RESERVE_DATE<!--- finansal yaş --->
                        ,LOT_NO
                    )
                    VALUES
                    (
                        #MAX_ID.IDENTITYCOL#,
                        '#attributes.fis_no#',							
                        #stock_id#,
                        #miktar#,
                        '#add_unit#',
                        #product_unit_id#,							
                        #standart_alis#,
                        '#other_money#',
                        #tax_purchase#,
                        #discount1#,
                        #discount2#,
                        #discount3#,
                        #discount4#,
                        #discount5#,
                        #satir_toplam#,
                        <!--- #ship_fis_discount_#, --->
                        #kdv_toplam#,
                        #satir_toplam_net#,
                        <cfif isDefined("spec") and listlen(spec,',')>
                            #listgetat(spec,2,',')#,
                            '#listgetat(spec,3,',')#',
                        <cfelse>
                            NULL,
                            NULL,
                        </cfif>
                        #cost_price_#,
                        #extra_cost_price_#,
                        <cfif len(SHELF_NUMBER)>#SHELF_NUMBER#<cfelse>NULL</cfif>,
                        <cfif len(DELIVER_DATE)>#createodbcdate(DELIVER_DATE)#<cfelse>NULL</cfif>,
                        <cfif len(PHYSICAL_AGE)>#PHYSICAL_AGE#<cfelse>NULL</cfif>,
                        <cfif len(FINANCE_DATE)>#createodbcdate(FINANCE_DATE)#<cfelse>NULL</cfif>
                        ,<cfif len(LOT_NO)>'#LOT_NO#'<cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfif GET_PROCESS_TYPES.IS_STOCK_ACTION>
                    <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                        INSERT INTO
                        STOCKS_ROW
                        (
                            UPD_ID,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROCESS_TYPE,
                            STOCK_IN,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE,
                            SPECT_VAR_ID,
                            SHELF_NUMBER,
                            DELIVER_DATE,
                            LOT_NO
                        )
                        VALUES
                        (
                            #MAX_ID.IDENTITYCOL#,
                            #product_id#,
                            #stock_id#,
                            114,
                            #miktar#,
                            #attributes.department_in#,
                            #attributes.location_in#,
                            #attributes.fis_date#,
                            <cfif  isDefined("spec") and listlen(spec,',')>#listgetat(spec,1,',')#<cfelse>NULL</cfif>,
                            <cfif len(SHELF_NUMBER)>#SHELF_NUMBER#<cfelse>NULL</cfif>,
                            <cfif len(DELIVER_DATE)>#createodbcdate(DELIVER_DATE)#<cfelse>NULL</cfif>
                            ,<cfif len(LOT_NO)>'#LOT_NO#'<cfelse>NULL</cfif>
                        )
                    </cfquery>	
                </cfif>
            </cfoutput>
		</cfloop>
</cftransaction>
</cflock>
<cfif isdefined("all_loop_count") and all_loop_count gt 0>
	<script type="text/javascript">
        alert("<cfoutput>#all_loop_count#</cfoutput> Adet Stok Fişi Oluşturuldu !");
    </script>
<cfelse>
    <script type="text/javascript">
        alert("<cf_get_lang no ='40.Stok Fişi Oluşturulacak Belge Bulunamadı !'>");
    </script>
</cfif>
<cfquery name="UPD_SAYIMLAR" datasource="#DSN2#">
	UPDATE 
		SAYIMLAR 
	SET
		FIS_ID = #MAX_ID.IDENTITYCOL# ,
        FIS_PROCESS_TYPE = #attributes.process_cat# 
	WHERE 
		GIRIS_ID = #attributes.file_id#
</cfquery>
<!--- NOT: eger sirket bir onceki donemde workcube den maliyet takibi yaptı ise bu durumda maliyetlerin devir olmasına gerek yoktur işlem kategorisinde maliyet işlemi seçilmeye billir 
 sirket maliyet takibi yapıyorsa --->
<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:MAX_ID.IDENTITYCOL,query_type:1);</cfscript>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
