<!--- Bu sayfada yapılacak ciddi yapısal degisikilikler TAT Metal Entegrasyon sistemine de yansitilmali --->
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("	<cf_get_lang_main no='815.Ürün Seçmelisiniz'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isDefined("session.ep")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cfif isDefined("session.pda")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset ship_due_date = date_add("d",attributes.basket_due_value,attributes.ship_date)>
<cfelse>
	<cfset ship_due_date = "">
</cfif>
<cfquery name="GET_PURCHASE" datasource="#DSN2#">
	SELECT
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM
		SHIP
	WHERE 
		PURCHASE_SALES = 0 AND 
		SHIP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number#">
	  	<cfif len(attributes.company_id)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
	  	<cfelse>
	  		AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	  	</cfif>
</cfquery>
<cfif get_purchase.recordcount>
	<script type="text/javascript">
		alert("	<cf_get_lang no ='518.Girdiğiniz İrsaliye Numarası Seçilen Cari Adına Kullanılmış Lütfen Tekrar Giriniz'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PURCHASE" datasource="#DSN2#" result="MAX_ID">
			INSERT INTO
				SHIP
                (
                    WRK_ID,
                    PURCHASE_SALES,
                    SHIP_NUMBER,
                    SHIP_TYPE,
                    PROCESS_CAT,
                    DUE_DATE ,
                    PAYMETHOD_ID, 
                    <cfif isDefined("attributes.ship_method") and len(attributes.ship_method)>SHIP_METHOD,</cfif>
                    SHIP_DATE,
                    <cfif len(attributes.company_id)>
                        COMPANY_ID,
                        PARTNER_ID,
                    <cfelse>
                        CONSUMER_ID,
                    </cfif>
                    DELIVER_DATE,
                    DELIVER_EMP,
                    DELIVER_EMP_ID,
                    DELIVER_PAR_ID,
                    DISCOUNTTOTAL,
                    NETTOTAL,
                    GROSSTOTAL,
                    TAXTOTAL,
                    OTV_TOTAL,
                    OTHER_MONEY,
                    OTHER_MONEY_VALUE,
                    DEPARTMENT_IN,
                    LOCATION_IN,
                    RECORD_DATE,
                    IS_WITH_SHIP,
                    RECORD_EMP,
                    REF_NO,
                    CARD_PAYMETHOD_ID,
                    CARD_PAYMETHOD_RATE,
                    PROJECT_ID,
                    SHIP_DETAIL,
                    CITY_ID,
                    COUNTY_ID,
                    SHIP_ADDRESS_ID,
                    ORDER_ID,
                    ADDRESS
                )
                VALUES
                (
                    '#wrk_id#',
                    0,
                    '#ship_number#',
                    #get_process_type.process_type#,
                    #attributes.process_cat#,
                    <cfif isdefined("ship_due_date") and len(ship_due_date)>#ship_due_date#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.ship_method") and len(attributes.ship_method)>
                        #attributes.ship_method#,
                    </cfif>
                    #attributes.ship_date#,
                    <cfif len(attributes.company_id) >
                        #attributes.company_id#,
                        <cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
                    <cfelse>
                        #attributes.consumer_id#,
                    </cfif>
                    <cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)>'#LEFT(TRIM(attributes.deliver_get),50)#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id) and attributes.deliver_member_type eq "employee">#attributes.deliver_get_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id) and attributes.deliver_member_type eq "partner">#attributes.deliver_get_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.basket_discount_total")>#attributes.basket_discount_total#,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
                    '#attributes.basket_money#',
                    #((attributes.basket_net_total*attributes.basket_rate1)/attributes.basket_rate2)#,
                    #attributes.department_id#,
                    #attributes.location_id#,
                    #now()#,
                    0,
                    <cfif isDefined("session.pda")>#session.pda.userid#,<cfelse>#session.ep.userid#,</cfif><!--- pda den gelen kayıtlar için --->
                    <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                        #attributes.card_paymethod_id#,
                        <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
                            #attributes.commission_rate#,
                        <cfelse>
                            NULL,
                        </cfif>
                    <cfelse>
                        NULL,
                        NULL,
                    </cfif>
                    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>#attributes.order_id_listesi#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)>'#attributes.ship_address#'<cfelse>NULL</cfif>
                )
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
        	<cfif evaluate('attributes.row_kontrol#i#')>
			<cfif isDefined("session.ep")>
				<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
					<cfset dsn_type=DSN2>
					<cfinclude template="../../objects/query/add_basket_spec.cfm">
				</cfif>
			</cfif>
			<cf_date tarih = 'attributes.deliver_date#i#'><!--- satırdaki teslim tarihi burada formatlanıyor, fakat stocks_row'a kayıt atılırken de aynı degerler kullanılıyor --->
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
				INSERT INTO
					SHIP_ROW
                    (
                        NAME_PRODUCT,
                        PAYMETHOD_ID, 
                        SHIP_ID,
                        STOCK_ID,
                        PRODUCT_ID,
                        AMOUNT,
                        UNIT,
                        UNIT_ID,				
                        TAX,
						<cfif len(evaluate("attributes.price#i#"))>
                            PRICE,
                        </cfif>
                        PURCHASE_SALES,
                        DISCOUNT,
                        DISCOUNT2,
                        DISCOUNT3,
                        DISCOUNT4,
                        DISCOUNT5,
                        DISCOUNT6,
                        DISCOUNT7,
                        DISCOUNT8,
                        DISCOUNT9,
                        DISCOUNT10,
                        DISCOUNTTOTAL,
                        GROSSTOTAL,
                        NETTOTAL,
                        TAXTOTAL,
                        DELIVER_DATE,				
                        DELIVER_DEPT,
                        DELIVER_LOC,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                            SPECT_VAR_ID,
                            SPECT_VAR_NAME,
                        </cfif>
                        LOT_NO,
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE,				
                        PRICE_OTHER,
                        OTHER_MONEY_GROSS_TOTAL,
						<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
                            COST_PRICE,
                        </cfif>
                        EXTRA_COST,
                        ROW_ORDER_ID,
						<cfif listfind('75,77',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
                            RELATED_SHIP_ID,
                            RELATED_SHIP_PERIOD,
                        </cfif>
                        DARA,
                        DARALI,
                        IS_PROMOTION,
                        DISCOUNT_COST,
                        UNIQUE_RELATION_ID,
                        PROM_RELATION_ID,
                        PRODUCT_NAME2,
                        AMOUNT2,
                        UNIT2,
                        EXTRA_PRICE,
                        EK_TUTAR_PRICE,<!--- iscilik birim maliyet --->
                        EXTRA_PRICE_TOTAL,
                        EXTRA_PRICE_OTHER_TOTAL,
                        SHELF_NUMBER,
                        PRODUCT_MANUFACT_CODE,
                        BASKET_EXTRA_INFO_ID,
                        SELECT_INFO_EXTRA,
                        DETAIL_INFO_EXTRA,
                        BASKET_EMPLOYEE_ID,
                        LIST_PRICE,
                        PRICE_CAT,
                        CATALOG_ID,
                        NUMBER_OF_INSTALLMENT,
                        DUE_DATE,
                        KARMA_PRODUCT_ID,
                        OTV_ORAN,
                        OTVTOTAL,
                        SERVICE_ID,
                        WRK_ROW_ID,
                        WRK_ROW_RELATION_ID,
                        WIDTH_VALUE,
                        DEPTH_VALUE,
                        HEIGHT_VALUE,
                        ROW_PROJECT_ID
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),250)#">,
                        <cfif isdefined("attributes.paymethod_id#i#") and  len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
                        #MAX_ID.IDENTITYCOL#,
                        #evaluate("attributes.stock_id#i#")#,
                        #evaluate("attributes.product_id#i#")#,
                        #evaluate("attributes.amount#i#")#,
                        '#evaluate("attributes.unit#i#")#',
                        <cfif isdefined("attributes.unit_id#i#") and len(evaluate("attributes.unit_id#i#"))>#evaluate("attributes.unit_id#i#")#,<cfelse>NULL,</cfif>
                        #evaluate("attributes.tax#i#")#,
                        <cfif len(evaluate("attributes.price#i#"))>
                        #evaluate("attributes.price#i#")#,
                        </cfif>
                        0,
                        #indirim1#,
                        #indirim2#,
                        #indirim3#,
                        #indirim4#,
                        #indirim5#,
                        #indirim6#,
                        #indirim7#,
                        #indirim8#,
                        #indirim9#,
                        #indirim10#,
                        #discount_amount#,
                        #evaluate("attributes.row_lasttotal#i#")#,
                        #evaluate("attributes.row_nettotal#i#")#,
                        #evaluate("attributes.row_taxtotal#i#")#,
                        <cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                        #attributes.department_id#,
                        #attributes.location_id#,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                            #evaluate('attributes.spect_id#i#')#,
                            '#evaluate('attributes.spect_name#i#')#',
                        </cfif>
                        <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#evaluate('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.other_money_#i#')>'#evaluate('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
						<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
                            <!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
                            <cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                        </cfif>
                            <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                            #order_id#,
                        <cfif listfind('75,77',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
                            <cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
                            <cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listlast(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
                        </cfif>
                        <cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#,<cfelse>NULL,</cfif>
                        <cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#,<cfelse>NULL,</cfif>
                        0,
                        <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#evaluate('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))>'#evaluate('attributes.prom_relation_id#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#evaluate('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#evaluate('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#evaluate('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                        <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>#evaluate('attributes.otv_oran#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.service_id') and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#evaluate('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#evaluate('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
                    )
			</cfquery>
            </cfif>
		</cfloop>
		<cfscript>
			if(get_process_type.is_stock_action eq 1)//Stok hareketi yapılsın
			{
				sr_product_id_list ="";
				sr_stock_id_list ="";
				sr_unit_list ="";
				sr_amount_list ="";
				sr_spec_id_list ="";
				sr_lot_no_list ="";
				sr_shelf_number_list ="";
				sr_manufact_code_list ="";
				sr_amount_other_list ="";
				sr_unit_other_list ="";
				sr_deliver_date_list ="";
				if(isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm))
					sr_process_date_=attributes.deliver_date_frm;
				else
					sr_process_date_=attributes.ship_date;				
				for(_ind_=1;_ind_ lte attributes.rows_;_ind_=_ind_+1)
				{
					if(evaluate('attributes.row_kontrol#_ind_#') and evaluate('attributes.is_inventory#_ind_#') eq 1) //urun envantere dahilse stock hareketi yapar
					{	
						sr_product_id_list = ListAppend(sr_product_id_list,Evaluate('attributes.product_id#_ind_#'),',');
						sr_stock_id_list = ListAppend(sr_stock_id_list,Evaluate('attributes.stock_id#_ind_#'),',');
						sr_unit_list = ListAppend(sr_unit_list,Evaluate('attributes.unit#_ind_#'),',');
						sr_amount_list = ListAppend(sr_amount_list,Evaluate('attributes.amount#_ind_#'),',');
						if(isdefined('attributes.spect_id#_ind_#') and len(Evaluate('attributes.spect_id#_ind_#')) )
							sr_spec_id_list = ListAppend(sr_spec_id_list,Evaluate('attributes.spect_id#_ind_#'),',');
						else
							sr_spec_id_list = ListAppend(sr_spec_id_list,0,',');
						if(isdefined('attributes.lot_no#_ind_#') and len(Evaluate('attributes.lot_no#_ind_#')) )
							sr_lot_no_list = ListAppend(sr_lot_no_list,Evaluate('attributes.lot_no#_ind_#'),',');
						else
							sr_lot_no_list = ListAppend(sr_lot_no_list,0,',');
						
						if(isdefined('attributes.shelf_number#_ind_#') and len(Evaluate('attributes.shelf_number#_ind_#')) )
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,Evaluate('attributes.shelf_number#_ind_#'),',');
						else
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,0,',');
						
						if(isdefined('attributes.manufact_code#_ind_#') and len(Evaluate('attributes.manufact_code#_ind_#')) )
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,Evaluate('attributes.manufact_code#_ind_#'),',');
						else
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,0,',');
						
						if(isdefined('attributes.amount_other#_ind_#') and len(Evaluate('attributes.amount_other#_ind_#')) )
							sr_amount_other_list = ListAppend(sr_amount_other_list,Evaluate('attributes.amount_other#_ind_#'),',');
						else
							sr_amount_other_list = ListAppend(sr_amount_other_list,0,',');
						
						if(isdefined('attributes.unit_other#_ind_#') and len(Evaluate('attributes.unit_other#_ind_#')) )
							sr_unit_other_list = ListAppend(sr_unit_other_list,Evaluate('attributes.unit_other#_ind_#'),',');
						else
							sr_unit_other_list = ListAppend(sr_unit_other_list,0,',');
						if(isdefined('attributes.deliver_date#_ind_#') and isdate(Evaluate('attributes.deliver_date#_ind_#')) )
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,Evaluate('attributes.deliver_date#_ind_#'),',');
						else
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,0,',');
					}
				}
				if(len(sr_product_id_list) and len(sr_stock_id_list))
				{
					include('add_stock_rows.cfm','\objects\functions');//sayfalar farklı modüllerden çağrıldıgı için buraya include edildi
					add_stock_rows(
						sr_is_purchase_sales : 0,
						sr_stock_row_count : listlen(sr_stock_id_list,','), //attributes.rows_,
						sr_max_id :MAX_ID.IDENTITYCOL,
						sr_department_id : attributes.department_id,
						sr_location_id : attributes.location_id,
						sr_process_date :sr_process_date_,
						sr_document_date : attributes.ship_date,
						sr_process_type : get_process_type.PROCESS_TYPE,
						sr_product_id_list: sr_product_id_list,
						sr_control_process_type : '73,74,75', // iade process type lar satıs ve alısa gore degisiyor, dikkat plz.
						sr_stock_id_list: sr_stock_id_list,
						sr_unit_list: sr_unit_list,
						sr_amount_list: sr_amount_list,
						sr_spec_id_list: sr_spec_id_list,
						sr_lot_no_list: sr_lot_no_list,
						sr_shelf_number_list:sr_shelf_number_list,
						sr_manufact_code_list:sr_manufact_code_list,
						sr_amount_other_list : sr_amount_other_list,
						sr_unit_other_list : sr_unit_other_list,
						sr_deliver_date_list :sr_deliver_date_list
					);
				}
			}
			if(isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)) //irsaliyeye cekilen konsinye irsaliye varsa
			{
				include('add_ship_row_relation.cfm','\objects\functions'); 
				add_ship_row_relation(
					to_related_process_id : MAX_ID.IDENTITYCOL,
					to_related_process_type : get_process_type.PROCESS_TYPE,
					ship_related_action_type:0,
					is_invoice_ship:1,
					process_db :dsn2
					);
			}
			
			if(isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)) //irsaliyeye cekilen siparis varsa
			{
				include('add_order_row_reserved_stock_pda.cfm','\objects\functions'); //siparis irsaliye iliskisini, siparis satır aşama ve rezerve tipini update ediyor
				add_reserve_row(
					reserve_order_id:attributes.order_id_listesi,
					related_process_id : MAX_ID.IDENTITYCOL,
					reserve_action_type:0,
					is_order_process:1,
					is_purchase_sales:0,
					is_stock_row_action : get_process_type.IS_STOCK_ACTION,
					process_db :dsn2
					);
			}
			//if(not isDefined("session.ep")) // pda den gelen kayıtlar için
				//include('get_basket_money_js.cfm','\objects\functions');
			basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);
		</cfscript>				
	</cftransaction>
</cflock>
<cfif isdefined('attributes.service_stock_id') and len(attributes.service_stock_id) and isdefined('attributes.service_serial_no') and len(attributes.service_serial_no)> <!--- servis basvuru eklemeden cagrılmıssa --->
	<cfquery name="GET_PRO_GUARANTY" datasource="#DSN3#">
		SELECT
			SGN.SALE_START_DATE,
			SGN.SALE_GUARANTY_CATID,
			(SELECT SGT.GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME SGT WHERE SGT.GUARANTYCAT_TIME_ID = SG.GUARANTYCAT_TIME) GUARANTYCAT_TIME
		FROM
			SERVICE_GUARANTY_NEW SGN,
			#dsn_alias#.SETUP_GUARANTY AS SG
		WHERE
			SGN.SALE_GUARANTY_CATID=SG.GUARANTYCAT_ID AND
			SGN.IS_SALE = 1 AND
			SGN.SALE_START_DATE IS NOT NULL AND
			SGN.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_stock_id#"> AND
			SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_serial_no#">
	</cfquery>
	<cfif get_pro_guaranty.recordcount>
		<cfinclude template="../../objects/functions/add_serial_no.cfm">
		<cfset attributes.serial_no_start_number1 = attributes.service_serial_no>
		<cfset attributes.stock_id1 = attributes.service_stock_id>
		<cfset attributes.guaranty_purchasesales1 = 0>
		<cfset attributes.guaranty_cat1 = get_pro_guaranty.sale_guaranty_catid>
		<cfset attributes.guaranty_startdate1 = get_pro_guaranty.sale_start_date>
		<cfset temp_start_date = get_pro_guaranty.sale_start_date>
		<cfif len(temp_start_date) and isdate(temp_start_date)>
			<cfset temp_date = date_add("m", get_pro_guaranty.guarantycat_time, temp_start_date)>
			<cf_date tarih="temp_start_date">
		</cfif>
		<cfscript>
			add_serial_no(
			session_row : 1,
			process_type : get_process_type.PROCESS_TYPE, 
			process_number : SHIP_NUMBER,
			process_id : MAX_ID.IDENTITYCOL,
			dpt_id : attributes.department_id,
			loc_id : attributes.location_id,
			par_id : attributes.partner_id,
			con_id : attributes.consumer_id,
			main_stock_id : '',
			comp_id : attributes.company_id
			);
		</cfscript>
	</cfif>
</cfif>
<cfif isdefined("attributes.return_row_ids")>
	<cfquery name="UPD_" datasource="#DSN3#">
		UPDATE 
			SERVICE_PROD_RETURN_ROWS 
		SET 
			IS_SHIP = 1,
			RETURN_SHIP_ID = #MAX_ID.IDENTITYCOL#,
			RETURN_SHIP_NO = '#attributes.SHIP_NUMBER#',
			RETURN_PERIOD_ID = #session.ep.period_id#
		WHERE
			RETURN_ROW_ID IN (#attributes.return_row_ids#)
	</cfquery>
</cfif>
