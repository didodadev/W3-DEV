<!--- Bu Sayfada Pda Uzerinden De Islem Yapilmaktadir, Yapilacak Degisikliklerde Dikkate Alinmalidir FBS 20111216 --->
<cfif isDefined("session.pda")>
	<cfset session_userid = session.pda.userid>
	<cfset session_period_year = session.pda.period_year>
	<cfset session_period_id = session.pda.period_id>
	<cfset session_company_id = session.pda.our_company_id>
	<cfset session_money = session.pda.money>
	<cfset session_money2 = session.pda.money2>
	<cfset session_our_company_info_spect_type = session.pda.our_company_info.spect_type>
	<cfset session_our_company_info_is_cost = 1>
<cfelse>
	<cfset session_userid = session.ep.userid>
	<cfset session_period_year = session.ep.period_year>
	<cfset session_period_id = session.ep.period_id>
	<cfset session_company_id = session.ep.company_id>
	<cfset session_money = session.ep.money>
	<cfset session_money2 = session.ep.money2>
	<cfset session_our_company_info_spect_type = session.ep.our_company_info.spect_type>
	<cfset session_our_company_info_is_cost = session.ep.our_company_info.is_cost>
</cfif>
<cf_get_lang_set module_name="prod">
<cfquery name="GET_ROW_RESULT" datasource="#DSN3#">
	SELECT
    (SELECT PROJECT_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">) PROJECT_ID,
		PRODUCTION_ORDER_RESULTS.ORDER_NO,
        PRODUCTION_ORDER_RESULTS.RESULT_NO,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_ORDER_NO,
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.PROCESS_ID,
		PRODUCTION_ORDER_RESULTS.FINISH_DATE,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
		PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID,
		PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID,
		PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
		PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
		PRODUCTION_ORDER_RESULTS.POSITION_ID,
		PRODUCTION_ORDER_RESULTS.LOT_NO,
		PRODUCTION_ORDER_RESULTS_ROW.TYPE,
		PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
		PRODUCTION_ORDER_RESULTS_ROW.LOT_NO ROW_LOT_NO,
        PRODUCTION_ORDER_RESULTS_ROW.EXPIRATION_DATE ROW_EXPIRATION_DATE,
		PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
		PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
		PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,
		PRODUCTION_ORDER_RESULTS_ROW.NAME_PRODUCT,
		PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.COST_ID,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM AMOUNT_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM_TOTAL TOTAL_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_MONEY OTHER_MONEY_CURRENCY,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET OTHER_MONEY,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_TOTAL OTHER_MONEY_TOTAL,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT_NAME,
		PRODUCTION_ORDER_RESULTS_ROW.SPECT_NAME,
		PRODUCTION_ORDER_RESULTS_ROW.IS_SEVKIYAT,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM PURCHASE_EXTRA_COST,
		PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS,
        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM, 
        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
        PRODUCTION_ORDER_RESULTS.EXPIRATION_DATE
	FROM
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDER_RESULTS_ROW,
		STOCKS S
	WHERE
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
		S.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
		S.IS_INVENTORY = 1
</cfquery>
<cfif get_row_result.is_stock_fis eq 1><!--- fis kesildi ise geri geldiginde tekrar kayıt yapmasın diye --->
    <cflocation url="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#" addtoken="no">
	<cfabort>
</cfif>
<cfif not len(get_row_result.production_dep_id) or not len(get_row_result.exit_dep_id)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='455.Sarf'> <cf_get_lang_main no='486.veya'> <cf_get_lang no='450.Üretim Depo'>");
		<cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
			history.go(-1);
		</cfif>
	</script>
	<cfabort>
</cfif>
<cfset new_finish_date = createdate(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date))>
<cfif (isdefined("session.ep.period_start_date") and (new_finish_date gt session.ep.period_finish_date or new_finish_date lt session.ep.period_start_date)) or (not isdefined("session.ep.period_start_date") and year(get_row_result.finish_date) neq session_period_year)>
	<script type="text/javascript">
		alert("Üretim Sonuç Bitiş Tarihi Döneminiz ile Aynı Değil !");
		<cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
			history.go(-1);
		</cfif>
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ROW" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 1
</cfquery>
<cfif not GET_ROW.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='490.Üretilen Ürünler Envantere Dahil Seçilmelidir.'>");
		<cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
			history.go(-1);
		</cfif>
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ROW_EXIT" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 2
</cfquery>
<cfquery name="GET_ROW_OUTAGE" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 3
</cfquery>
<cfquery name="GET_MONEY_FIS" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
</cfquery>
<cfscript>
	value_finish_date = createdatetime(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date),0,0,0);
	finish_date_time = createdatetime(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date),hour(get_row_result.finish_date),minute(get_row_result.finish_date),0);
</cfscript>
<cflock name="#CreateUUID()#" timeout="60">
  	<cftransaction>
		<cfquery name="GET_PROCESS_TYPE_URT" datasource="#DSN3#">
            SELECT 
                PROCESS_CAT_ID,
                PROCESS_TYPE,
                IS_STOCK_ACTION,
                IS_COST
             FROM 
                SETUP_PROCESS_CAT
            WHERE 
                PROCESS_TYPE = <cfif is_demontaj>119<cfelse>110</cfif>
                <cfif is_demontaj>
                    <cfif isdefined("attributes.process_type_119") and len(attributes.process_type_119)>
                        AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_119#">
                    </cfif>
                <cfelse>
                    <cfif isdefined("attributes.process_type_110") and len(attributes.process_type_110)>
                        AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_110#">
                    </cfif>
                </cfif>
        </cfquery>
        <cfif get_process_type_urt.recordcount eq 0>
            <script type="text/javascript">
                alert("<cf_get_lang no ='613.Lütfen Üretimden Giriş Fişi'><cfif is_demontaj eq 1>(<cf_get_lang no ='547.Demontaj'>)</cfif><cf_get_lang no ='614.için İşlem Kategorinizi Tanımlayınız '> !");
                <cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
                    history.go(-1);
                </cfif>
            </script>
            <cfabort>
        </cfif>

        <cfquery name="GET_PROCESS_TYPE_SARF" datasource="#DSN3#">
            SELECT 
                PROCESS_CAT_ID,
                PROCESS_TYPE,
                IS_STOCK_ACTION
             FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_TYPE = 111
                <cfif isdefined("attributes.process_type_111") and len(attributes.process_type_111)>
                    AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_111#">
                </cfif>
        </cfquery>
        <cfif get_process_type_sarf.recordcount eq 0>
            <script type="text/javascript">
                alert("<cf_get_lang no ='615.Lütfen Sarf Fişi Için İşlem Kategorinizi Tanimlayiniz'> !");
                <cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
                    history.go(-1);
                </cfif>
            </script>
            <cfabort>
        </cfif>
	
		<cfif get_row_outage.recordcount>
            <cfquery name="GET_PROCESS_TYPE_FIRE" datasource="#DSN3#">
                SELECT 
                    PROCESS_CAT_ID,
                    PROCESS_TYPE,
                    IS_STOCK_ACTION
                 FROM 
                    SETUP_PROCESS_CAT 
                WHERE 
                    PROCESS_TYPE = 112
                    <cfif isdefined("attributes.process_type_112") and len(attributes.process_type_112)>
                        AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_112#">
                    </cfif>
            </cfquery>
            <cfif get_process_type_fire.recordcount eq 0>
                <script type="text/javascript">
                    alert("<cf_get_lang no ='616.Lütfen Fire Fişi için İşlem Kategorinizi Tanımlayınız '>!");
                    <cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
                        history.go(-1);
                    </cfif>
                </script>
                <cfabort>
            </cfif>
        </cfif>
		<cfif len(get_row.production_dep_id) and len(get_row.enter_dep_id)>
            <cfquery name="GET_PROCESS_TYPE_DEP_ARASI" datasource="#DSN3#">
                SELECT 
                    PROCESS_CAT_ID,
                    PROCESS_TYPE,
                    IS_STOCK_ACTION
                 FROM 
                    SETUP_PROCESS_CAT 
                WHERE 
                    PROCESS_TYPE = 81
                    <cfif isdefined("attributes.process_type_81") and len(attributes.process_type_81)>
                        AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_81#">
                    </cfif>
            </cfquery>
            <cfif get_process_type_dep_arasi.recordcount eq 0>
                <script type="text/javascript">
                    alert("<cf_get_lang no ='617.Lütfen Depolararası Sevk için İşlem Kategorinizi Tanımlayınız'> !");
                    <cfif not isdefined('attributes.is_multi')><!--- Çoklu Sayfadan Geliyorsa Girmesin. --->
                        history.go(-1);
                    </cfif>
                </script>
                <cfabort>
            </cfif>
        </cfif>
		<!--- üretimden giriş --->
        <!--- Uretim --->
        <cfif get_row.recordcount>
            <cf_papers paper_type="stock_fis">
            <cfscript>
                attributes.system_paper_no = paper_code & '-' & paper_number;
                attributes.system_paper_no_add = paper_number;
                attributes.fis_no = attributes.system_paper_no;
                attributes.fis_type = get_process_type_urt.process_type;
            </cfscript>
            <cfquery name="GET_FIS_NUMBER_1" datasource="#DSN3#">
                SELECT 
                    *
                 FROM 
                    #dsn2_alias#.STOCK_FIS
                WHERE 
                	FIS_NUMBER = '#attributes.fis_no#'
            </cfquery>
            <cfif GET_FIS_NUMBER_1.recordcount>
                <script type="text/javascript">
                    alert("Aynı Belge Numaralı Stok Fişi Var!");                    
                    history.go(-1);                 
                </script>
                <cfabort>
            </cfif>
            <cfquery name="ADD_STOCK_FIS_1" datasource="#DSN3#">
                INSERT INTO 
                    #dsn2_alias#.STOCK_FIS
                (
                    FIS_TYPE,
                    PROCESS_CAT,
                    FIS_NUMBER,
                    DEPARTMENT_IN,
                    LOCATION_IN,
                    PROD_ORDER_RESULT_NUMBER,
                    PROD_ORDER_NUMBER,
                    EMPLOYEE_ID,
                    FIS_DATE,
                    DELIVER_DATE,
                    PROJECT_ID_IN,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    REF_NO
                )
                VALUES
                (
                    #attributes.fis_type#,
                    #get_process_type_urt.process_cat_id#,
                   '#attributes.fis_no#',
                    #get_row.production_dep_id#,
                    #get_row.production_loc_id#,
                    #get_row.pr_order_id#,
                    #get_row.p_order_id#,
                    <cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
                    #value_finish_date#,
                    #finish_date_time#,
                    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    #new_finish_date#,
                    #session_userid#,
                   '#cgi.remote_addr#',
                   '#get_row.order_no#'
                )
            </cfquery>
            
            <cfquery name="GET_ID" datasource="#DSN3#">
                SELECT
                    MAX(FIS_ID) MAX_ID
                FROM
                    #dsn2_alias#.STOCK_FIS STOCK_FIS
            </cfquery>
            <cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
                <cfquery name="ADD_FIS_MONEY" datasource="#DSN3#">
                    INSERT INTO
                        #dsn2_alias#.STOCK_FIS_MONEY
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            #get_id.max_id#,
                            '#get_money_fis.money#',
                            #get_money_fis.rate2#,
                            #get_money_fis.rate1#,
                            <cfif get_money_fis.money eq session_money>1<cfelse>0</cfif>
                        )
                </cfquery>
            </cfoutput>
            <cfoutput query="get_row">
                <cfscript>
				project_id = get_row.PROJECT_ID;
                    amount_rw = get_row.amount;
                    _form_products_id_ = get_row.product_id;
                    _form_stocks_id_ = get_row.stock_id;
                    form_spect_id = get_row.spect_id;
                    form_spect_name = get_row.spect_name;
                    form_spec_main_id = get_row.spec_main_id;
                    form_unit_id = get_row.unit_id;
                    form_unit2 =  get_row.unit2;
                    _form_amounts_ = get_row.amount;
                    form_amount2 = get_row.amount2;
                    form_amount_price = get_row.amount_price;
                    form_tax = get_row.kdv_price;
                    //form_total_price = get_row.total_price
                    form_other_money = get_row.other_money;
                    form_other_money_currency = get_row.other_money_currency;
                    form_cost = get_row.amount_price + get_row.purchase_extra_cost;
					form_extra_cost = get_row.labor_cost_system + get_row.station_reflection_cost_system;
                </cfscript>
                <cfquery name="GET_UNIT" datasource="#DSN3#">
                    SELECT 
                        ADD_UNIT,
                        MULTIPLIER,
                        MAIN_UNIT,
                        PRODUCT_UNIT_ID
                    FROM
                        PRODUCT_UNIT 
                    WHERE 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND
                        PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#">
                </cfquery>
                <cfif get_unit.recordcount and len(get_unit.multiplier)>
                    <cfset multi = get_unit.multiplier*amount_rw>
                <cfelse>
                    <cfset multi = amount_rw>
                </cfif>
                <cfif len(form_spec_main_id) and form_spec_main_id gt 0 and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
                    <cfscript>
                        //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                        main_to_spect = specer(
                                dsn_type:dsn3,
                                spec_type:1,
                                main_spec_id:form_spec_main_id,
                                add_to_main_spec:1
                        );
                    </cfscript>
                    <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                </cfif>
                <cfquery name="ADD_STOCK_FIS_ROW_1" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn2_alias#.STOCK_FIS_ROW
                    (
                        FIS_ID,
                        FIS_NUMBER,
                        STOCK_ID,
                        AMOUNT,
                        AMOUNT2,
                        UNIT,
                        UNIT2,					
                        UNIT_ID,
                        PRICE,
                        TAX,
                        TOTAL,
                        TOTAL_TAX,
                        NET_TOTAL,
                        SPECT_VAR_ID,
                        SPEC_MAIN_ID,
                        SPECT_VAR_NAME,
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,</cfif>
                        OTHER_MONEY,
                        PRICE_OTHER,
                        COST_PRICE,
                        EXTRA_COST,
                        ROW_PROJECT_ID,
                        DELIVER_DATE,
                        WRK_ROW_ID
                    )
                    VALUES
                    (
                        #get_id.max_id#,
                        '#attributes.fis_no#',						
                        #_form_stocks_id_#,
                        #amount_rw#,
                        <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
                        '#get_unit.main_unit#',
                        <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
                        #form_unit_id#,
                        #form_amount_price#,
                        #form_tax#,
                        #amount_rw*form_amount_price#,
                        #(amount_rw*form_amount_price*form_tax)/100#,
                        #amount_rw*form_amount_price#,																						
                        <cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0 >#form_spec_main_id#<cfelse>NULL</cfif>,
                        <cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>,
                        </cfif>
                        '#form_other_money_currency#',
                        #form_other_money#,
                        #form_cost#,
                        <cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>,
                        <cfif len(project_id)>#project_id#<CFELSE>NULL</cfif>,
                        <cfif len(GET_ROW_RESULT.EXPIRATION_DATE)>#createodbcdatetime(GET_ROW_RESULT.EXPIRATION_DATE)#<cfelse>NULL</cfif>
                        ,'#createUUID()#'
                    )
                </cfquery>
                <cfquery name="ADD_STOCK_ROW" datasource="#DSN3#">
                    INSERT INTO
                        #dsn2_alias#.STOCKS_ROW
                    (
                        UPD_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        PROCESS_TYPE,
                        STOCK_IN,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        PROCESS_TIME,
                        SPECT_VAR_ID
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
                    )
                    VALUES
                    (
                        #get_id.max_id#,
                        #_form_products_id_#,
                        #_form_stocks_id_#,
                        #attributes.fis_type#,
                        #multi#,
                        #get_row.production_dep_id#,
                        #get_row.production_loc_id#,
                        #value_finish_date#,
                        #finish_date_time#,
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            ,<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
                            ,<cfif len(GET_ROW_RESULT.EXPIRATION_DATE)>#createodbcdatetime(GET_ROW_RESULT.EXPIRATION_DATE)#<cfelse>NULL</cfif>
                        </cfif>
                    )
                </cfquery>
            </cfoutput>
            <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
                WHERE
                    STOCK_FIS_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
    
        <!--- sarf fisi--->
        <cfif get_row_exit.recordcount>
            <cf_papers paper_type="stock_fis">
            <cfscript>
                attributes.system_paper_no = paper_code & '-' & paper_number;
                attributes.system_paper_no_add = paper_number;
                attributes.fis_no = attributes.system_paper_no;
                attributes.fis_type = get_process_type_sarf.process_type;
            </cfscript>
            <cfquery name="GET_FIS_NUMBER_2" datasource="#DSN3#">
                SELECT 
                    *
                 FROM 
                    #dsn2_alias#.STOCK_FIS
                WHERE 
                	FIS_NUMBER = '#attributes.fis_no#'
            </cfquery>
            <cfif GET_FIS_NUMBER_2.recordcount>
                <script type="text/javascript">
                    alert("Aynı Belge Numaralı Stok Fişi Var!");                    
                    history.go(-1);                 
                </script>
                <cfabort>
            </cfif>
            <cfquery name="ADD_STOCK_FIS_2" datasource="#DSN3#">
                INSERT INTO 
                    #dsn2_alias#.STOCK_FIS
                (
                    FIS_TYPE,
                    PROCESS_CAT,
                    FIS_NUMBER,
                    DEPARTMENT_OUT,
                    LOCATION_OUT,
                    PROD_ORDER_RESULT_NUMBER,
                    PROD_ORDER_NUMBER,
                    EMPLOYEE_ID,
                    FIS_DATE,
                    DELIVER_DATE,
                    PROJECT_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    REF_NO
                )
                VALUES
                (
                    #attributes.fis_type#,
                    #get_process_type_sarf.process_cat_id#,
                   '#attributes.fis_no#',
                    #get_row.exit_dep_id#,
                    #get_row.exit_loc_id#,
                    #get_row.pr_order_id#,
                    #attributes.p_order_id#,
                    <cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
                    #value_finish_date#,
                    #finish_date_time#,
                    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    #now()#,
                    #session_userid#,
                   '#cgi.remote_addr#',
                   '#get_row.order_no#'
                )
            </cfquery>
            <cfquery name="GET_ID_EXIT" datasource="#DSN3#">
                SELECT
                    MAX(FIS_ID) MAX_ID
                FROM
                    #dsn2_alias#.STOCK_FIS STOCK_FIS
            </cfquery>
            <cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
                <cfquery name="ADD_FIS_MONEY" datasource="#DSN3#">
                    INSERT INTO
                        #dsn2_alias#.STOCK_FIS_MONEY
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            #get_id_exit.max_id#,
                            '#get_money_fis.money#',
                            #get_money_fis.rate2#,
                            #get_money_fis.rate1#,
                            <cfif get_money_fis.money eq session_money>1<cfelse>0</cfif>
                        )
                </cfquery>
            </cfoutput>
            <cfoutput query="get_row_exit">
                <cfscript>
				project_id = get_row_exit.PROJECT_ID;
                    amount_rw = get_row_exit.amount;
                    _form_products_id_ = get_row_exit.product_id;
                    _form_stocks_id_ = get_row_exit.stock_id;
                    form_spect_id = get_row_exit.spect_id;
                    form_spect_name = get_row_exit.spect_name;
                    form_spec_main_id = get_row_exit.spec_main_id;
                    form_unit_id = get_row_exit.unit_id;
                    form_unit2 = get_row_exit.unit2;
                    _form_amounts_ = get_row_exit.amount;
                    form_amount2 = get_row_exit.amount2;
                    form_amount_price = get_row_exit.amount_price;
                    form_tax = get_row_exit.kdv_price;
                    form_total_price = get_row_exit.total_price;
                    //form_kdv_price = get_row_exit.total_kdv;
                    form_other_money = get_row_exit.other_money;
                    form_other_money_currency = get_row_exit.other_money_currency;
                    form_extra_cost = get_row_exit.purchase_extra_cost;
                    form_cost_id = get_row_exit.COST_ID;
                </cfscript>
                <cfquery name="GET_UNIT" datasource="#DSN3#">
                    SELECT 
                        ADD_UNIT,
                        MULTIPLIER,
                        MAIN_UNIT,
                        PRODUCT_UNIT_ID
                    FROM
                        PRODUCT_UNIT 
                    WHERE 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND
                        PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#"> AND
                        PRODUCT_UNIT_STATUS = 1
                </cfquery>
                <cfif get_unit.recordcount and len(get_unit.multiplier)>
                    <cfset multi = get_unit.multiplier*amount_rw>
                <cfelse>
                    <cfset multi = amount_rw>
                </cfif>
                <cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
                    <cfscript>
                        //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                        main_to_spect = specer(
                                dsn_type:dsn3,
                                spec_type:1,
                                main_spec_id:form_spec_main_id,
                                add_to_main_spec:1
                        );
                    </cfscript>
                    <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                </cfif>
                <cfquery name="ADD_STOCK_FIS_ROW_2" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn2_alias#.STOCK_FIS_ROW
                    (
                        FIS_ID,
                        FIS_NUMBER,
                        STOCK_ID,
                        AMOUNT,
                        AMOUNT2,
                        UNIT,
                        UNIT2,
                        UNIT_ID,					
                        PRICE,
                        TAX,
                        TOTAL,
                        TOTAL_TAX,
                        NET_TOTAL,
                        SPECT_VAR_ID,
                        SPEC_MAIN_ID,
                        SPECT_VAR_NAME,
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,DELIVER_DATE,</cfif>
                        OTHER_MONEY,
                        PRICE_OTHER,
                        COST_PRICE,
                        EXTRA_COST,
                        ROW_PROJECT_ID,
                        WRK_ROW_ID
                    )
                    VALUES
                    (
                        #get_id_exit.max_id#,
                        '#attributes.fis_no#',							
                        #_form_stocks_id_#,
                        #amount_rw#,
                        <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
                        '#get_unit.main_unit#',
                        <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
                        #form_unit_id#,
                        #form_amount_price#,
                        #form_tax#,
                        #amount_rw*form_amount_price#,
                        #(amount_rw*form_amount_price*form_tax)/100#,
                        #amount_rw*form_amount_price#,																						
                        <cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>,
                        <cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
                        <!--- <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>, --->
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            <cfif Len(get_row_exit.row_lot_no)>'#get_row_exit.row_lot_no#'<cfelse>NULL</cfif>,
                            <cfif Len(get_row_exit.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_exit.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>,
                        </cfif>
                        '#form_other_money_currency#',
                        #form_other_money#,
                        #form_amount_price#,
                        <cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>
                        <!--- ,<cfif len(form_cost_id)>#form_cost_id#<cfelse>NULL</cfif> --->
                        ,
                   <cfif len(project_id)>#project_id#<CFELSE>NULL</cfif>
                   ,'#createUUID()#'
                    )
                </cfquery>
                
                <cfquery name="ADD_STOCK_ROW_2" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn2_alias#.STOCKS_ROW
                    (
                        UPD_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        PROCESS_TYPE,
                        STOCK_OUT,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        PROCESS_TIME,
                        SPECT_VAR_ID
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
                    )
                    VALUES
                    (
                        #get_id_exit.max_id#,
                        #_form_products_id_#,
                        #_form_stocks_id_#,
                        #attributes.fis_type#,
                        #multi#,
                        #get_row_exit.exit_dep_id#,
                        #get_row_exit.exit_loc_id#,
                        #value_finish_date#,
                        #finish_date_time#,
                        <cfif len(form_spec_main_id) and  form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            ,<cfif len(get_row_exit.row_lot_no)>'#get_row_exit.row_lot_no#'<cfelse>NULL</cfif>
                            ,<cfif len(get_row_exit.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_exit.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>
                        </cfif>
                    )
                </cfquery>
            </cfoutput>
        
            <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
                WHERE
                    STOCK_FIS_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
        
        <!---fire--->
        <cfif get_row_outage.recordcount>
            <cf_papers paper_type="stock_fis">
            <cfscript>
                attributes.system_paper_no = paper_code & '-' & paper_number;
                attributes.system_paper_no_add = paper_number;
                attributes.fis_no = attributes.system_paper_no;
                attributes.fis_type = get_process_type_fire.process_type;
            </cfscript>
            <cfquery name="GET_FIS_NUMBER_2" datasource="#DSN3#">
                SELECT 
                    *
                 FROM 
                    #dsn2_alias#.STOCK_FIS
                WHERE 
                	FIS_NUMBER = '#attributes.fis_no#'
            </cfquery>
            <cfif GET_FIS_NUMBER_2.recordcount>
                <script type="text/javascript">
                    alert("Aynı Belge Numaralı Stok Fişi Var!");                    
                    history.go(-1);                 
                </script>
                <cfabort>
            </cfif>
            <cfquery name="ADD_STOCK_FIS_2" datasource="#DSN3#">
                INSERT INTO 
                    #dsn2_alias#.STOCK_FIS
                (
                    FIS_TYPE,
                    PROCESS_CAT,
                    FIS_NUMBER,
                    DEPARTMENT_OUT,
                    LOCATION_OUT,
                    PROD_ORDER_RESULT_NUMBER,
                    PROD_ORDER_NUMBER,
                    EMPLOYEE_ID,
                    FIS_DATE,
                    DELIVER_DATE,
                    PROJECT_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    REF_NO
                )
                VALUES
                (
                    #attributes.fis_type#,
                    #get_process_type_fire.process_cat_id#,
                   '#attributes.fis_no#',
                    #get_row_outage.exit_dep_id#,
                    #get_row_outage.exit_loc_id#,
                    #get_row_outage.pr_order_id#,
                    #attributes.p_order_id#,
                    <cfif len(get_row_outage.position_id)>#get_row_outage.position_id#<cfelse>NULL</cfif>,
                    #value_finish_date#,
                    #finish_date_time#,
                    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    #now()#,
                    #session_userid#,
                   '#cgi.remote_addr#',
                   '#get_row.order_no#'
                )
            </cfquery>
            <cfquery name="GET_ID_OUTAGE" datasource="#DSN3#">
                SELECT
                    MAX(FIS_ID) MAX_ID
                FROM
                    #dsn2_alias#.STOCK_FIS STOCK_FIS
            </cfquery>
            <cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
                <cfquery name="ADD_FIS_MONEY" datasource="#DSN3#">
                    INSERT INTO
                        #dsn2_alias#.STOCK_FIS_MONEY
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            #get_id_outage.max_id#,
                            '#get_money_fis.money#',
                            #get_money_fis.rate2#,
                            #get_money_fis.rate1#,
                            <cfif get_money_fis.money eq session_money>1<cfelse>0</cfif>
                        )
                </cfquery>
            </cfoutput>
            <cfoutput query="get_row_outage">
                <!--- stok fisine spect id yaziliyor ancak stock_row tablosuna main spect yazilmali--->
                <cfset form_spect_main_id="">		
                <cfscript>
                    amount_rw = get_row_outage.amount;
                    _form_products_id_ = get_row_outage.product_id;
                    _form_stocks_id_ = get_row_outage.stock_id;
                    form_spect_id = get_row_outage.spect_id;
                    form_spec_main_id = get_row_outage.spec_main_id;
                    form_unit_id = get_row_outage.unit_id;
                    form_unit2 = get_row_outage.unit2;
                    _form_amounts_ = get_row_outage.amount;
                    form_amount2 = get_row_outage.amount2;
                    form_amount_price = get_row_outage.amount_price;
                    form_tax = get_row_outage.kdv_price;
                    form_total_price = get_row_outage.total_price;
                    form_spect_name = get_row_outage.spect_name;
                    form_other_money = get_row_outage.other_money;
                    form_other_money_currency = get_row_outage.other_money_currency;
                    form_extra_cost = get_row_outage.purchase_extra_cost;
                    form_cost_id = get_row_outage.cost_id;
                </cfscript>
                <cfquery name="GET_UNIT" datasource="#DSN3#">
                    SELECT 
                        ADD_UNIT,
                        MULTIPLIER,
                        MAIN_UNIT,
                        PRODUCT_UNIT_ID
                    FROM
                        PRODUCT_UNIT 
                    WHERE 
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND
                        PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#">
                </cfquery>
                <cfif get_unit.recordcount and len(get_unit.multiplier)>
                    <cfset multi = get_unit.multiplier*amount_rw>
                <cfelse>
                    <cfset multi = amount_rw>
                </cfif>
                <cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
                    <cfscript>
                        //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                        main_to_spect = specer(
                            dsn_type:dsn3,
                            spec_type:1,
                            main_spec_id:form_spec_main_id,
                            add_to_main_spec:1
                        );
                    </cfscript>
                    <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                </cfif>
    
                <cfquery name="ADD_STOCK_FIS_ROW_2" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn2_alias#.STOCK_FIS_ROW
                    (
                        FIS_ID,
                        FIS_NUMBER,
                        STOCK_ID,
                        AMOUNT,
                        AMOUNT2,
                        UNIT,
                        UNIT2,
                        UNIT_ID,					
                        PRICE,
                        TAX,
                        TOTAL,
                        TOTAL_TAX,
                        NET_TOTAL,
                        SPECT_VAR_ID,
                        SPEC_MAIN_ID,
                        SPECT_VAR_NAME,
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,DELIVER_DATE,</cfif>
                        OTHER_MONEY,
                        PRICE_OTHER,
                        COST_PRICE,
                        EXTRA_COST,
                        WRK_ROW_ID
                        <!--- ,COST_ID --->
                    )
                    VALUES
                    (
                        #get_id_outage.max_id#,
                        '#attributes.fis_no#',							
                        #_form_stocks_id_#,
                        #amount_rw#,
                        <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
                        '#get_unit.main_unit#',
                        <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
                        #form_unit_id#,
                        #form_amount_price#,
                        #form_tax#,
                        #amount_rw*form_amount_price#,
                        #(amount_rw*form_amount_price*form_tax)/100#,
                        #amount_rw*form_amount_price#,																						
                        <cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#,<cfelse>null,</cfif>
                        <cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
                        <!--- <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>, --->
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            <cfif len(get_row_outage.row_lot_no)>'#get_row_outage.row_lot_no#'<cfelse>NULL</cfif>,
                             <cfif len(get_row_outage.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_outage.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>,
                        </cfif>
                        '#form_other_money_currency#',
                        #form_other_money#,
                        #form_amount_price#,
                        #form_extra_cost#
                        ,'#createUUID()#'
                        <!--- ,<cfif len(form_cost_id)>#form_cost_id#<cfelse>NULL</cfif> --->
                    )
                </cfquery>
                
                <cfquery name="ADD_STOCK_ROW_2" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn2_alias#.STOCKS_ROW
                    (
                        UPD_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        PROCESS_TYPE,
                        STOCK_OUT,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        PROCESS_TIME,
                        SPECT_VAR_ID
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
                    )
                    VALUES
                    (
                        #get_id_outage.max_id#,
                        #_form_products_id_#,
                        #_form_stocks_id_#,
                        #attributes.fis_type#,
                        #multi#,
                        #get_row_outage.exit_dep_id#,
                        #get_row_outage.exit_loc_id#,
                        #value_finish_date#,
                        #finish_date_time#,
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>
                        <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                            ,<cfif len(get_row_outage.row_lot_no)>'#get_row_outage.row_lot_no#'<cfelse>NULL</cfif>
                            ,<cfif len(get_row_outage.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_outage.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>
                        </cfif>
                    )
                </cfquery>
            </cfoutput>
            
            <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
                WHERE
                    STOCK_FIS_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
	
		<!--- Sevkiyat --->
        <cfif len(get_row.production_dep_id) and len(get_row.enter_dep_id) and get_row.recordcount>
            <cfset sonuc_sira=''>
            <cfquery name="GET_ROW_RESULT_COUNT" datasource="#DSN3#">
                SELECT
                    PR_ORDER_ID
                FROM
                    PRODUCTION_ORDER_RESULTS
                WHERE
                    P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.p_order_id#">
                ORDER BY
                    PR_ORDER_ID
            </cfquery>
            <cfif get_row_result_count.recordcount gt 1>
                <cfloop query="get_row_result_count">
                    <cfif get_row_result_count.pr_order_id eq get_row.pr_order_id>
                        <cfset sonuc_sira='-#currentrow#'>
                    </cfif>
                </cfloop>
            </cfif>
			<!--- <cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
                SELECT 
                    PROCESS_CAT_ID,
                    PROCESS_TYPE,
                    IS_STOCK_ACTION
                 FROM 
                    SETUP_PROCESS_CAT 
                WHERE 
                    PROCESS_TYPE = 81
            </cfquery> --->
            <cfscript>
                basket_net_total = 0;
                basket_gross_total = 0;
                basket_tax_total = 0;
            </cfscript>
			<cfloop query="get_row">
				<cfscript>
					basket_net_total = basket_net_total + get_row.amount_price;
					basket_gross_total = basket_gross_total + get_row.total_price;
					basket_tax_total = basket_tax_total +((get_row.total_price*form_tax)/100);
				</cfscript>
			</cfloop>
			<cfif len(session_money2)>
				<cfquery name="GET_MONEY2" datasource="#DSN3#">
					SELECT 
                    	MONEY, 
                        RATE1, 
                        RATE2 
                    FROM 
                    	#dsn2_alias#.SETUP_MONEY 
                    WHERE 
                    	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#"> AND 
                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_period_id#"> AND 
                        MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_money2#">
				</cfquery>
			<cfelse><!--- 2. parabirimi seçili olmayan şirket olursa diye --->
				<cfset get_money2.rate1=1>
				<cfset get_money2.rate2=1>
				<cfset get_money2.money=session_money>
			</cfif>
			<cfset irs_no='#get_row.production_order_no##sonuc_sira#'>
			<cfquery name="ADD_SALE" datasource="#DSN3#">
				INSERT 
					INTO 
					#dsn2_alias#.SHIP
					(
						PURCHASE_SALES,
						SHIP_NUMBER,
						SHIP_TYPE,
						PROCESS_CAT,
						SHIP_DATE,
						DELIVER_DATE,
						DISCOUNTTOTAL,
						NETTOTAL,
						GROSSTOTAL,
						TAXTOTAL,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						DELIVER_STORE_ID,
						LOCATION,
						DEPARTMENT_IN,
						LOCATION_IN,
						REF_NO,
						RECORD_DATE,
						RECORD_EMP,
						PROD_ORDER_NUMBER,
						PROD_ORDER_RESULT_NUMBER,
                        PROJECT_ID
					)
				VALUES
					(
						1,
						'#irs_no#',
						#get_process_type_dep_arasi.process_type#,
						#get_process_type_dep_arasi.process_cat_id#,
						#value_finish_date#,
						#value_finish_date#,
						0,
						#basket_net_total#,
						#basket_gross_total#,
						#basket_tax_total#,
						'#get_money2.money#',
						#((basket_net_total*get_money2.rate1)/get_money2.rate2)#,
						#get_row.production_dep_id#,
						#get_row.production_loc_id#,
						#get_row.enter_dep_id#,
						#get_row.enter_loc_id#,
						'#get_row.order_no#',
						#now()#,
						#session_userid#,
						#get_row.p_order_id#,
						#get_row.pr_order_id#,
                        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
					)
			</cfquery>	
			<cfquery name="GET_ID" datasource="#DSN3#">
				SELECT MAX(SHIP_ID) AS MAX_ID FROM #dsn2_alias#.SHIP
			</cfquery>
			<cfoutput query="get_row">
				<cfscript>
					_form_products_id_ = get_row.product_id;
					_form_stocks_id_ = get_row.stock_id;
					_form_amounts_ = get_row.amount;
					form_amount2 = get_row.amount2;
					form_name_product = get_row.name_product;
					form_unit_id = get_row.unit_id;
					form_unit_name = get_row.unit_name;
					form_spect_name = get_row.spect_name;
					form_kdv_price = get_row.kdv_price;
					form_amount_price = get_row.amount_price;
					form_total_price = get_row.total_price;
					//form_total_kdv = get_row.total_kdv;
					form_spect_id = get_row.spect_id;
					form_spec_main_id = get_row.spec_main_id;
					form_spect_name = get_row.spect_name;
					form_other_money_currency = get_row.other_money_currency;
					form_other_money = get_row.other_money;
					form_other_total_money = get_row.other_money_total;
					form_cost = get_row.amount_price + get_row.purchase_extra_cost;
					form_extra_cost = get_row.labor_cost_system + get_row.station_reflection_cost_system;
				</cfscript>
				<!--- <cfif not len(form_spec_main_id) and len(form_spect_id)><!--- Main spec yoksa ancak spect id varsa --->
					<cfquery name="GET_MAIN_SPECT" datasource="#DSN3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
					</cfquery>
				</cfif> --->
               <cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
					<cfscript>
						//Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
						main_to_spect = specer(
                                dsn_type:dsn3,
                                spec_type:1,
                                main_spec_id:form_spec_main_id,
                                add_to_main_spec:1
                        );
                    </cfscript>
                    <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                </cfif>
				<cfquery name="ADD_SHIP_ROW" datasource="#DSN3#">
					INSERT INTO
						#dsn2_alias#.SHIP_ROW
						(
							NAME_PRODUCT,
							SHIP_ID,
							STOCK_ID,
							PRODUCT_ID,
							AMOUNT,
                            AMOUNT2,
							UNIT,
                            UNIT2,
							UNIT_ID,
							TAX,
							PRICE,
							PURCHASE_SALES,
							DISCOUNTTOTAL,
							GROSSTOTAL,
							NETTOTAL,
							TAXTOTAL,
							DELIVER_DATE,
							DELIVER_DEPT,
							DELIVER_LOC,
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
							<cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,</cfif>
							OTHER_MONEY,
							PRICE_OTHER,
							OTHER_MONEY_VALUE,
							OTHER_MONEY_GROSS_TOTAL,
							IS_PROMOTION,
							COST_PRICE,
							EXTRA_COST,
                            WRK_ROW_ID
						)
					VALUES
						(
						   '#left(form_name_product,75)#',
							#get_id.max_id#,
							#_form_stocks_id_#,
							#_form_products_id_#,
							#_form_amounts_#,
                            <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
						   	'#form_unit_name#',
                           	<cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
							#form_unit_id#,
							#form_kdv_price#,
							#form_amount_price#,
							1,
							0,
							#form_total_price#,<!--- *form_amount --->
							#form_amount_price*_form_amounts_#,
							#(form_total_price*_form_amounts_)*form_kdv_price/100#,
							#value_finish_date#,
							#get_row.production_dep_id#,
							#get_row.production_loc_id#,
							<cfif len(form_spect_id)>#form_spect_id#,<cfelse>NULL,</cfif>
							<cfif len(form_spect_name)>'#form_spect_name#',<cfelse>NULL,</cfif>
						    <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                '#get_row.lot_no#',
                              <!---  <cfif len(get_row.EXPIRATION_DATE)>
                                    #createodbcdatetime(get_row.EXPIRATION_DATE)#,
                                <cfelse>
                                    NULL,
                                </cfif>--->
                            </cfif>
						   	'#form_other_money_currency#',
							#form_other_money#,
							#form_other_money*_form_amounts_#,
							#form_other_total_money#,<!--- *form_amount --->
							0,
							<cfif len(form_cost)>#form_cost#<cfelse>0</cfif>,
							<cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>,
                            '#createUUID()#'
						)
				</cfquery>
				<cfif get_process_type_dep_arasi.is_stock_action eq 1>
					<cfquery name="GET_UNIT" datasource="#DSN3#">
						SELECT ADD_UNIT, MULTIPLIER, MAIN_UNIT, PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#">
					</cfquery>
					<cfif get_unit.recordcount and len(get_unit.multiplier)>
						<cfset multi=get_unit.multiplier*_form_amounts_>
					<cfelse>
						<cfset multi=_form_amounts_>
					</cfif>
					<cfquery name="ADD_STOCK_ROW" datasource="#DSN3#">
						INSERT INTO
							#dsn2_alias#.STOCKS_ROW
							(
								UPD_ID,
								PRODUCT_ID,
								STOCK_ID,
								PROCESS_TYPE,
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
                                PROCESS_TIME,
								SPECT_VAR_ID
								<cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
							)
							VALUES
							(
								#get_id.max_id#,
								#_form_products_id_#,
								#_form_stocks_id_#,
								#get_process_type_dep_arasi.process_type#,
								#multi#,
								#get_row.production_dep_id#,
								#get_row.production_loc_id#,
								#value_finish_date#,
                                #finish_date_time#,
								<cfif len(form_spec_main_id)>#form_spec_main_id#<cfelse>NULL</cfif>
							    <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                    ,<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
                                    ,<cfif len(get_row.EXPIRATION_DATE)>#createodbcdatetime(get_row.EXPIRATION_DATE)#<cfelse>NULL</cfif>
								</cfif>
							)
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<!--- Eğer xml den operasyonlara sonuç girildi seçilmişse operasyon sonuçları kaydediliyor --->
        <cfif isdefined("attributes.x_is_add_operation_result") and attributes.x_is_add_operation_result eq 1>
            <cfquery name="CONTROL_RESULT" datasource="#DSN3#">
                SELECT P_ORDER_ID FROM PRODUCTION_OPERATION_RESULT WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_result.p_order_id#">
            </cfquery>
            <cfif control_result.recordcount eq 0><!--- Eğer hiç sonuç girilmemişse operasyon sonuçları kaydedilecek--->
                <cfquery name="GET_PRODUCTION_OPERATIONS" datasource="#DSN3#">
                    SELECT
                        PO.OPERATION_TYPE_ID,
                        (SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
                        ISNULL(O_MINUTE,0) AS O_MINUTE,
                        (SELECT STATION_NAME FROM WORKSTATIONS WS WHERE WS.STATION_ID = PO.STATION_ID) AS STATION_NAME,
                        PO.AMOUNT,
                        PO.P_OPERATION_ID,
                        PO.STATION_ID,
                        ISNULL((SELECT SUM(POR.REAL_AMOUNT) FROM PRODUCTION_OPERATION_RESULT POR WHERE POR.OPERATION_ID = PO.P_OPERATION_ID AND POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_result.p_order_id#">),0) RESULT_AMOUNT
                    FROM
                        PRODUCTION_OPERATION PO
                    WHERE
                        PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_result.p_order_id#">
                    ORDER BY
                        PO.P_OPERATION_ID DESC
                </cfquery>
                <cfoutput query="get_production_operations">
                    <cfquery name="ADD_RESULT" datasource="#DSN3#">
                        INSERT INTO
                            PRODUCTION_OPERATION_RESULT
                        (
                            P_ORDER_ID,
                            OPERATION_ID,
                            STATION_ID,
                            REAL_AMOUNT,
                            LOSS_AMOUNT,
                            REAL_TIME,
                            WAIT_TIME,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            #get_row_result.p_order_id#,
                            #get_production_operations.p_operation_id#,
                            <cfif len(get_production_operations.station_id)>#get_production_operations.station_id#<cfelse>NULL</cfif>,
                            #amount#,
                            0,
                            #get_production_operations.o_minute#,
                            0,
                            #session_userid#,
                            #NOW()#,
                            '#CGI.REMOTE_ADDR#'
                        )
                    </cfquery>
                </cfoutput>
            </cfif>
        </cfif>
        <!--- fis kayıt edildiği zaman IS_STOCK_FIS 1 set ediliyor --->
        <cfquery name="UPD_RESULT" datasource="#DSN3#">
            UPDATE
                PRODUCTION_ORDER_RESULTS
            SET
                IS_STOCK_FIS=1
            WHERE
                PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
        </cfquery>
        <cfquery name="UPD_RESULT" datasource="#DSN3#">
            UPDATE
                PRODUCTION_ORDER_RESULTS_ROW
            SET
                IS_STOCK_FIS=1
            WHERE
                PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
        </cfquery>
        <cfquery name="GET_RESULT_AMOUNT" datasource="#DSN3#">
            SELECT
                ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
            FROM
                PRODUCTION_ORDER_RESULTS_ROW POR_,
                PRODUCTION_ORDER_RESULTS POO
            WHERE
                POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                AND POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
                AND POR_.TYPE = 1
                AND POO.IS_STOCK_FIS = 1
                AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
        </cfquery>
        <cfquery name="UPD_PROD_ORDERS" datasource="#DSN3#">
        	UPDATE PRODUCTION_ORDERS SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
        </cfquery>
        <cf_workcube_process 
            is_upd='1' 
            process_stage='#attributes.process_stage#' 
            record_member='#session_userid#' 
            record_date='#now()#' 
            data_source='#dsn3#'
            action_page='#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#get_row_result.p_order_id#&pr_order_id=#get_row_result.pr_order_id#' 
            action_id='#get_row_result.pr_order_id#'
            action_table='PRODUCTION_ORDER_RESULTS'
            action_column='PR_ORDER_ID'
            old_process_line='#get_row_result.pr_order_id#' 
            warning_description = 'Üretim Sonucu : #get_row_result.RESULT_NO#'>
  	</cftransaction>
</cflock>

<!--- su ana kadar emire girilen sonuçlardan stok fisi kesilenler toplam emirdeki miktarı karsılıyorsa rezerveyi kaldırıyoruz --->
<cfquery name="GET_P_O_R" datasource="#DSN3#">
	SELECT 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT),
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDER_RESULTS_ROW
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID=PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID=#GET_ROW_RESULT.P_ORDER_ID# AND
		PRODUCTION_ORDERS.STOCK_ID=PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
		PRODUCTION_ORDER_RESULTS_ROW.TYPE=<cfif is_demontaj eq 0>1<cfelse>2</cfif> AND
		PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS=1
	GROUP BY
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	HAVING 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT)>=PRODUCTION_ORDERS.QUANTITY
</cfquery>
<cfif GET_P_O_R.RECORDCOUNT>
	<cfquery name="UPD_PROD_ORDER" datasource="#dsn3#">
		UPDATE 
			PRODUCTION_ORDERS
		SET
			IS_STOCK_RESERVED = 0,
            IS_STAGE = 2<!--- üRETİM sONUÇLANDIRILDI YANİ STOK FİŞLERİ KESİLDİ! BİTTİ --->
		WHERE
			P_ORDER_ID =  #GET_ROW_RESULT.P_ORDER_ID#
	</cfquery>
</cfif>

<cfif session_our_company_info_is_cost eq 1 and not isdefined("attributes.is_prod")><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>
    if(isdefined('attributes.is_multi'))
		cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:1,multi_cost_page:1);//çoklu sayfadan geliyorsa her sonuç için ayrı maliyet sayfası açılsın..
	else
		cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:1);
    </cfscript>
	<cfif not isdefined('attributes.is_multi')><!--- Çoklu sayfalardan geliyorsa bu bloğa girmesin! --->
		<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
			<script type="text/javascript">
				window.location.href="<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>";
			</script>
		</cfif>
    </cfif>
<cfelse>
	<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
		<cfif not isdefined('attributes.is_multi')><!--- Çoklu sayfalardan geliyorsa bu bloğa girmesin! --->
			<cflocation url="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#" addtoken="no">
		</cfif>
	</cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
