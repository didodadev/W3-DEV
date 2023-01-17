<cfcomponent>

    <cfproperty name="basket_data">

    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    </cfif>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_alias = dsn>
    <cfset dsn1 = "#dsn#_product">
    <cfset dsn2 = "#dsn#_#session_base.period_year#_#session_base.company_id#">
    <cfset dsn3 = "#dsn#_#session_base.company_id#">
    <cfset dsn1_alias = dsn1>
    <cfset dsn2_alias = dsn2>
    <cfset dsn3_alias = dsn3>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset index_folder = application.systemParam.systemParam().index_folder >
    <cfset getlang = application.functions.GETLANG>
    <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
    <cfset wrk_eval = application.functions.wrk_eval>
    <cfset wrk_round = application.functions.wrk_round>
    <cfset filternum = application.functions.filternum>
    <cfset cfquery = application.functions.cfquery>
    <cfset tlformat = application.functions.tlformat>
    <cfset get_product_account = application.functions.get_product_account>
    <cfset listdeleteduplicates = application.functions.listdeleteduplicates>
    <cfset date_add = application.functions.date_add>

    <cffunction name="check_invoice">
        
        <cfset this.basket_data.basket_check_status = "1">
        <cfset this.basket_data.basket_check_status_code = "">

        <!--- account type id bul --->
        <cfif isDefined("this.basket_data.employee_id") and listLen(this.basket_data.employee_id, '_') eq 2>
            <cfset this.basket_data.acc_type_id = listLast(this.basket_data.employee_id, '_')>
            <cfset this.basket_data.employee_id = listFirst(this.basket_data.employee_id, '_')>
        </cfif>

        <!--- basket rate 2 yi düzenle --->
        <cfset this.basket_data.bakset_rate2 = this.basket_data.basket_rate2 / this.basket_data.basket_rate1>

        <!--- satırlarda ürün varmı --->
        <cfif isDefined("this.basket_data.rows_") and this.basket_data.rows_ lte 0>
            <cfset this.basket_data.basket_check_status = 0>
            <cfset this.basket_data.basket_check_status_code = "product_not_found">
        </cfif>

        <!--- action file içinde fatura ekleme kullanıldığında sorun olabilme ihtimali var --->
        <cf_date tarih="this.basket_data.invoice_date">
        <cfif isDefined("this.basket_data.ship_date") and len(this.basket_data.ship_date)>
            <cf_date tarih="this.basket_data.ship_date">
        </cfif>
        <cfif isDefined("this.basket_data.deliver_date_frm") and isDate(this.basket_data.deliver_date_frm)>
            <cf_date tarih="this.basket_data.deliver_date_frm">
        </cfif>
        <cfif isDefined("this.basket_data.realization_date") and isDate(this.basket_data.realization_date)>
            <cf_date tarih="this.basket_data.realization_date">
        </cfif>
        <cfset this.basket_data.invoice_due_date = "">
        <cfset this.basket_data.invoice_number = trim(this.basket_data.invoice_number)>
        <cfif not isDefined("this.basket_data.new_dsn2_group")>
            <cfset this.basket_data.new_dsn2_group = dsn2>
        </cfif>
        <cfif not isDefined("this.basket_data.new_dsn3_group")>
            <cfset this.basket_data.new_dsn3_group = dsn3>
        </cfif>
        <cfif not isDefined("this.basket_data.xml_import") or isDefined("this.basket_data.is_form_ship_action")>
            <cfquery name="query_check_sale" datasource="#this.basket_data.new_dsn2_group#">
                SELECT
                    INVOICE_NUMBER,
                    PURCHASE_SALES
                FROM
                    INVOICE
                WHERE
                    PURCHASE_SALES = 1 AND 
                    INVOICE_NUMBER='#this.basket_data.invoice_number#'
            </cfquery>
            <cfif query_check_sale.recordcount>
                <cfset this.basket_data.basket_check_status = "0">
                <cfset this.basket_data.basket_check_status_code = "invoice_number_used">
                <cfreturn "">
            </cfif>
        </cfif>
        <!--- check taxes --->
        <cfquery name="GET_BASKET" datasource="#dsn3#">
            SELECT 
                SETUP_BASKET.OTV_CALC_TYPE
            FROM 
                SETUP_BASKET
            WHERE 
                SETUP_BASKET.BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.basket_data.basket_id#">
        </cfquery>
        <cfset this.basket_data.inventory_product_exists = 0 >
        <cfset temp_tax_list = "">
        <cfset kontrol_otv = 1>
        <cfset temp_otv_list = "">
        <cfset temp_bsmv_list= "">
        
        <cfloop from="1" to="#this.basket_data.rows_#" index="tax_i">
            <cfif isdefined("this.basket_data.tax#tax_i#") and  not listfind(temp_tax_list, evaluate("this.basket_data.tax#tax_i#"), ",")>
                <cfset temp_tax_list = ListAppend(temp_tax_list, evaluate("this.basket_data.tax#tax_i#"), ",")>
            </cfif>

            <cfif isdefined("this.basket_data.otv_oran#tax_i#") and len(evaluate("this.basket_data.otv_oran#tax_i#")) and evaluate("this.basket_data.otv_oran#tax_i#") neq 0 and  not listfind(temp_otv_list, evaluate("this.basket_data.otv_oran#tax_i#"), ",")>
                <cfset temp_otv_list = ListAppend(temp_otv_list, evaluate("this.basket_data.otv_oran#tax_i#"), ",")>
            </cfif>

            <cfif isdefined("this.basket_data.row_bsmv_rate#tax_i#") and len(evaluate("this.basket_data.row_bsmv_rate#tax_i#")) and evaluate("this.basket_data.row_bsmv_rate#tax_i#") neq 0 and  not listfind(temp_bsmv_list, evaluate("this.basket_data.row_bsmv_rate#tax_i#"), ",")>
                <cfset temp_bsmv_list = ListAppend(temp_bsmv_list, evaluate("this.basket_data.row_bsmv_rate#tax_i#"), ",")>
            </cfif>

            <cfif isdefined("this.basket_data.is_inventory#tax_i#") and evaluate("this.basket_data.is_inventory#tax_i#") eq 1>
                <cfset this.basket_data.inventory_product_exists = 1>
            </cfif>
        </cfloop>

        <cfif listlen(temp_tax_list)>
            <cfquery name="query_get_taxes" datasource="#this.basket_data.new_dsn2_group#">
                SELECT * FROM SETUP_TAX WHERE TAX IN (#temp_tax_list#)
            </cfquery>
            <cfset tax_list = valuelist(query_get_taxes.tax)>
            <cfif ListLen(temp_tax_list,",") neq query_get_taxes.recordcount>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "basket_tax_notdefined">
                <cfreturn "">
            </cfif>
        </cfif>

        <cfif listlen(temp_bsmv_list)>
            <cfquery name="query_get_taxes" datasource="#dsn3#">
                SELECT * FROM SETUP_BSMV WHERE TAX IN (#temp_bsmv_list#) AND PERIOD_ID = #session_base.PERIOD_ID#
            </cfquery>
            <cfset tax_list = valuelist(query_get_taxes.tax)>
            <cfif ListLen(temp_bsmv_list,",") neq query_get_taxes.recordcount>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "basket_tax_notdefined">
                <cfreturn "">
            </cfif>
        </cfif>

        <cfif len(temp_otv_list) and kontrol_otv eq 1 and not len(get_basket.OTV_CALC_TYPE)>
            <cfquery name="get_otv" datasource="#dsn3#">
                SELECT * FROM SETUP_OTV WHERE TAX IN (#temp_otv_list#) AND PERIOD_ID = #session_base.PERIOD_ID#
            </cfquery>
            <cfset otv_list = valuelist(get_otv.tax)>
            <cfif ListLen(temp_otv_list,",") neq get_otv.recordcount>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "basket_otv_notdefined">
                <cfreturn "">
            </cfif>
        <cfelse>
            <cfset get_otv.recordcount=0> <!--- faturanın muhasebe için include edilen dosyalarında kullanılıyor --->
        </cfif>

        <!--- irsaliye kontrolü --->
        <cfset this.basket_data.included_irs = 0>
        <cfset this.basket_data.ship_ids = "">
        <cfset pre_period_ships = "">
        <cfset old_period_row_ship_info = "">
        <!--- sepetden gelen fatura satırlarını loop ederek irsaliye ve period id ler alınır --->
        <cfif not (isdefined("this.basket_data.order_id") and len(this.basket_data.order_id)) and not (isdefined("this.basket_data.order_id_listesi") and len(this.basket_data.order_id_listesi))>
            <cfloop from="1" to="#this.basket_data.rows_#" index="i">
                <cfif isdefined("this.basket_data.row_ship_id#i#") and evaluate("listfirst(this.basket_data.row_ship_id#i#,';')")>
                    <cfset this.basket_data.included_irs = 1>
                </cfif>
                <!--- row_ship_id tek elemanlı ise, standart aktif donemdeki irsaliye id sini tutuyordur, 2 elemanlı ise fatura ekranlarında irsaliye seçimiyle oluşmustur ve hem irsaliye id hemde period id değerlerini tutar--->
                <cfif listlen(evaluate("this.basket_data.row_ship_id#i#"),';') eq 1 and not listfind(this.basket_data.ship_ids,evaluate("this.basket_data.row_ship_id#i#"))>
                    <cfset this.basket_data.ship_ids = listappend(this.basket_data.ship_ids,evaluate("listfirst(this.basket_data.row_ship_id#i#,';')"))>
                <cfelseif listlen(evaluate("this.basket_data.row_ship_id#i#"),';') eq 2 and evaluate("listlast(this.basket_data.row_ship_id#i#,';')") eq session_base.period_id and not listfind(this.basket_data.ship_ids,evaluate("listfirst(this.basket_data.row_ship_id#i#,';')"))>
                    <cfset this.basket_data.ship_ids = listappend(this.basket_data.ship_ids,evaluate("listfirst(this.basket_data.row_ship_id#i#,';')"))>
                <cfelseif listlen(evaluate("this.basket_data.row_ship_id#i#"),';') eq 2 and evaluate("listlast(this.basket_data.row_ship_id#i#,';')") neq session_base.period_id and not listfind(pre_period_ships,evaluate("listfirst(this.basket_data.row_ship_id#i#,';')"))>
                    <cfset pre_period_ships = listappend(pre_period_ships,evaluate("listfirst(this.basket_data.row_ship_id#i#,';')"))>
                    <cfset pre_period_id = evaluate("listlast(this.basket_data.row_ship_id#i#,';')")>
                    <cfset old_period_row_ship_info = ListAppend(old_period_row_ship_info,evaluate("this.basket_data.row_ship_id#i#"),",")>
                </cfif>
            </cfloop>
        </cfif>
        <cfif this.basket_data.included_irs>
            <!--- bulunan dönemden çekilen irsaliye bilgileri alınır --->
            <cfset this.basket_data.ship_ids = listsort(this.basket_data.ship_ids,'numeric','desc')>
            <cfif len(this.basket_data.ship_ids)>
                <cfquery name="query_get_irs" datasource="#dsn2#">
                    SELECT SHIP_NUMBER,SHIP_ID FROM SHIP WHERE SHIP_ID IN (#this.basket_data.ship_ids#) ORDER BY SHIP_ID
                </cfquery>
            </cfif>
            <!--- önceki dönemden çekilen irsaliye bilgileri alınır --->
            <cfset pre_period_ships = listsort(pre_period_ships,'numeric','desc')>
            <cfif len(pre_period_ships)>
                    <cfquery name="GET_PERIOD" datasource="#dsn2#">
                        SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #dsn#.SETUP_PERIOD WHERE PERIOD_ID = #pre_period_id# AND OUR_COMPANY_ID = #session_base.company_id#
                    </cfquery> 
                    <cfif GET_PERIOD.recordcount>
                        <cfset pre_period_dsn = '#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#'>
                        <cfquery name="query_get_irs2" datasource="#dsn2#">
                            SELECT SHIP_NUMBER,SHIP_ID FROM #pre_period_dsn#.SHIP WHERE SHIP_ID IN (#pre_period_ships#) ORDER BY SHIP_ID
                        </cfquery>
                    </cfif>
            </cfif>
        </cfif>

        <!--- metal sektörüyle ilgili kontroller kaldırıldı --->
        <cfif isdefined("this.basket_data.basket_due_value_date_") and isdate(this.basket_data.basket_due_value_date_)>
            <cf_date tarih="this.basket_data.basket_due_value_date_">
            <cfset this.basket_data.invoice_due_date = '#this.basket_data.basket_due_value_date_#'>
        </cfif>

        <cfif isdefined("this.basket_data.paper")>
            <cfset paper_num = this.basket_data.paper>
            <cfquery name="UPD_PAPERS" datasource="#dsn2#">
                UPDATE
                    #dsn3_alias#.GENERAL_PAPERS
                SET
                    CASHREGISTER_NUMBER = #paper_num#
                WHERE
                    CASHREGISTER_NUMBER IS NOT NULL
            </cfquery>
        </cfif>

        <cfquery name="get_process_type" datasource="#this.basket_data.new_dsn3_group#">
            SELECT 
                *
            FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = #this.basket_data.process_cat#
        </cfquery>

        <cfscript>
            this.basket_data.process_cat = this.basket_data.PROCESS_CAT;
            this.basket_data.process_type =  get_process_type.process_type;
            this.basket_data.is_dept_based_acc = get_process_type.IS_DEPT_BASED_ACC;
            this.basket_data.inv_profile_id = get_process_type.PROFILE_ID;
            this.basket_data.is_cari = get_process_type.IS_CARI;
            this.basket_data.is_account = get_process_type.IS_ACCOUNT;
            this.basket_data.is_account_group = get_process_type.IS_ACCOUNT_GROUP;
            this.basket_data.invoice_cat = get_process_type.PROCESS_TYPE;
            this.basket_data.is_discount = get_process_type.IS_DISCOUNT;
            this.basket_data.is_budget = get_process_type.IS_BUDGET;
            this.basket_data.is_project_based_acc=get_process_type.IS_PROJECT_BASED_ACC;
            this.basket_data.is_project_based_budget=get_process_type.IS_PROJECT_BASED_BUDGET;
            this.basket_data.is_due_date_based_cari=get_process_type.IS_DUE_DATE_BASED_CARI;
            this.basket_data.is_paymethod_based_cari=get_process_type.IS_PAYMETHOD_BASED_CARI;
            this.basket_data.is_prod_cost_acc_action=get_process_type.IS_PROD_COST_ACC_ACTION;
            this.basket_data.is_row_project_based_cari = get_process_type.IS_ROW_PROJECT_BASED_CARI;
            this.basket_data.is_expensing_tax = get_process_type.IS_EXPENSING_TAX;
            this.basket_data.is_export_registered = get_process_type.IS_EXPORT_REGISTERED;
            this.basket_data.is_export_product = get_process_type.IS_EXPORT_PRODUCT;
            this.basket_data.next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION;
            this.basket_data.accrual_budget_action = get_process_type.ACCRUAL_BUDGET_ACTION;
            this.basket_data.is_expensing_bsmv = get_process_type.IS_EXPENSING_BSMV;
            this.basket_data.is_budget_reserved = get_process_type.IS_BUDGET_RESERVED_CONTROL;
            this.basket_data.is_visible_tevkifat = get_process_type.IS_VISIBLE_TEVKIFAT;
            this.basket_data.is_stock_action = get_process_type.IS_STOCK_ACTION;
            this.basket_data.action_file_name = get_process_type.ACTION_FILE_NAME;
            this.basket_data.action_file_from_template = get_process_type.ACTION_FILE_FROM_TEMPLATE;
            this.basket_data.is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
        </cfscript>

        <cfif not isdefined("this.basket_data.project_id")><!--- faturalardaki proje seçeneği gelmedigi durumlarda actionlarda çakan yerler vardı onlar için eklendiAysenur20080201--->
            <cfset this.basket_data.project_id = "">
        </cfif>

        <cfif not this.basket_data.included_irs and not isdefined('this.basket_data.xml_import') and not isdefined("this.basket_data.is_from_zreport") and Listfind('52,53,531,62', this.basket_data.invoice_cat,',')>
            <cfquery name="GET_SALE_SHIP" datasource="#this.basket_data.new_dsn2_group#">
                SELECT SHIP_ID FROM SHIP WHERE PURCHASE_SALES = 1 AND SHIP_NUMBER = '#this.basket_data.invoice_number#'
            </cfquery>
            <cfif GET_SALE_SHIP.recordcount>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "ship_number_already_exists">
                <cfreturn "">
            </cfif>
        </cfif>

        <cfif isDefined("this.basket_data.company_id") and len(this.basket_data.company_id)>
            <cfquery name="query_get_customer_info" datasource="#this.basket_data.new_dsn2_group#">
                SELECT
                    SALES_COUNTY,
                    COMPANY_VALUE_ID AS CUSTOMER_VALUE_ID,
                    RESOURCE_ID,
                    IMS_CODE_ID,
                    PROFILE_ID
                FROM
                    #dsn#.COMPANY
                WHERE
                    COMPANY_ID=#this.basket_data.company_id#
            </cfquery>
            <cfif len(query_get_customer_info.profile_id) and not (this.basket_data.inv_profile_id is 'YOLCUBERABERFATURA' or this.basket_data.inv_profile_id is 'IHRACAT')>
                <cfset this.basket_data.inv_profile_id = query_get_customer_info.profile_id>
            </cfif>
        <cfelseif isdefined("this.basket_data.consumer_id") and len(this.basket_data.consumer_id)>
            <cfquery name="query_get_customer_info" datasource="#this.basket_data.new_dsn2_group#">
                SELECT
                    SALES_COUNTY,
                    CUSTOMER_VALUE_ID,
                    RESOURCE_ID,
                    IMS_CODE_ID,
                    PROFILE_ID
                FROM
                    #dsn#.CONSUMER
                WHERE
                    CONSUMER_ID=#this.basket_data.consumer_id#
            </cfquery>
            <cfif len(query_get_customer_info.profile_id) and not (this.basket_data.inv_profile_id is 'YOLCUBERABERFATURA' or this.basket_data.inv_profile_id is 'IHRACAT')>
                <cfset this.basket_data.inv_profile_id = query_get_customer_info.profile_id>
            </cfif>
        </cfif>
        <cfif isDefined("query_get_customer_info")>
            <cfset this.basket_data.query_get_customer_info = query_get_customer_info>
        </cfif>
        <!--- Satış çalışanının takımı alınıyor --->
        <cfif isdefined("this.basket_data.EMPO_ID") and len(this.basket_data.EMPO_ID) and len(this.basket_data.department_id)>
            <cfquery name="query_get_branch_id" datasource="#this.basket_data.new_dsn2_group#">
                SELECT BRANCH_ID FROM #dsn#.DEPARTMENT WHERE DEPARTMENT_ID = #this.basket_data.department_id#
            </cfquery>
            <cfquery name="get_team_id" datasource="#dsn#">
                SELECT 
                    SZTR.TEAM_ID 
                FROM 
                    #dsn#.SALES_ZONES_TEAM_ROLES SZTR,
                    #dsn#.SALES_ZONES_TEAM SZT
                WHERE 
                    SZTR.TEAM_ID = SZT.TEAM_ID
                    AND SZTR.POSITION_CODE IN(SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #this.basket_data.EMPO_ID#)
                    AND SZT.SALES_ZONES IN(SELECT SZ_ID FROM SALES_ZONES WHERE RESPONSIBLE_BRANCH_ID = #query_get_branch_id.branch_id#)
            </cfquery>
            <cfif get_team_id.recordcount>
                <cfset this.basket_data.emp_team_id = get_team_id.team_id>
            <cfelse>
                <cfset this.basket_data.emp_team_id = ''>
            </cfif>
        </cfif>

        <cfif this.basket_data.is_account>
            <!--- muhasebe fis baslangic no var mi --->
            <cfquery name="query_bill_control" datasource="#dsn2#">
                SELECT * FROM BILLS
            </cfquery>
            <cfif not query_bill_control.recordcount>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "account_fiche_number_undefined">
                <cfreturn "">
            </cfif>

            <cfquery name="query_GET_NO_" datasource="#this.basket_data.new_dsn2_group#">
                SELECT 
                    * 
                FROM
                <cfif this.basket_data.sale_product eq 1>
                    #this.basket_data.new_dsn3_group#.SETUP_INVOICE SETUP_INVOICE
                <cfelseif this.basket_data.sale_product eq 0>
                    #this.basket_data.new_dsn3_group#.SETUP_INVOICE_PURCHASE SETUP_INVOICE_PURCHASE
                </cfif> 
            </cfquery>

            <cfif not len(query_GET_NO_.A_DISC) and (isDefined("this.basket_data.basket_discount_total") and this.basket_data.basket_discount_total gt 0)>
                <cfset HATA=2>
            </cfif>
            <cfif not query_get_no_.recordcount>
                <cfset HATA=1>
            </cfif>
            <cfif isDefined("HATA")>
                <cfif HATA EQ 1>
                    <cfif this.basket_data.sale_product eq 1>
                        <cfset this.basket_data.basket_check_status = 0>
                        <cfset this.basket_data.basket_check_status_code = "satis_tanimlari_yap">
                        <cfreturn "">
                    <cfelseif this.basket_data.sale_product eq 0>
                        <cfset this.basket_data.basket_check_status = 0>
                        <cfset this.basket_data.basket_check_status_code = "alis_tanimlari_yap">
                        <cfreturn "">
                    </cfif>                   
                <cfelse>
                    <cfset this.basket_data.basket_check_status = 0>
                    <cfset this.basket_data.basket_check_status_code = "indirim_ayarlari_yap">
                    <cfreturn "">
                </cfif>
            </cfif>
        </cfif>

        <cfif isDefined("this.basket_data.company_id") and len(this.basket_data.company_id) and isDefined("this.basket_data.comp_name") and len(this.basket_data.comp_name)>
            <cfif not isdefined("this.basket_data.new_period_id")><cfset this.basket_data.new_period_id = session_base.period_id></cfif>
            <cfset fn_GET_COMPANY_PERIOD = application.functions.GET_COMPANY_PERIOD>
            <cfset this.basket_data.acc = fn_GET_COMPANY_PERIOD(company_id: this.basket_data.company_id, period_id: this.basket_data.new_period_id, acc_type_id: len(this.basket_data.is_account_type_id) ? this.basket_data.is_account_type_id : "")>
            
            <cfif this.basket_data.invoice_cat eq 52 and not len(this.basket_data.acc)>
                <cfset this.basket_data.acc = query_GET_NO_.HIZLI_F>
            </cfif>
       
            <cfif this.basket_data.invoice_cat eq 5311>
                <cfset this.basket_data.acc_type_id = -9>
                <cfset this.basket_data.acc_export = fn_GET_COMPANY_PERIOD(company_id:this.basket_data.company_id,acc_type_id:this.basket_data.acc_type_id)>
                <cfif not len(this.basket_data.acc_export)>
                    <cfset this.basket_data.basket_check_status = 0>
                    <cfset this.basket_data.basket_check_status_code = "company_havent_export_acc_code">
                    <cfreturn "">
                </cfif>
            </cfif>
        
            <cfif not len(this.basket_data.acc)>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "company_havent_acc_code">
                <cfreturn "">
            </cfif>
        <cfelseif isDefined("this.basket_data.consumer_id") and len(this.basket_data.consumer_id)>
            <cfset fn_GET_CONSUMER_PERIOD = application.functions.GET_CONSUMER_PERIOD>
            <cfset this.basket_data.acc = fn_GET_CONSUMER_PERIOD(consumer_id: this.basket_data.consumer_id, acc_type_id:len(this.basket_data.is_account_type_id) ? this.basket_data.is_account_type_id : "")>
            <cfif this.basket_data.invoice_cat eq 52 and not len(this.basket_data.acc)>
                <cfset this.basket_data.acc = GET_NO_.HIZLI_F>
            </cfif>
            <cfif this.basket_data.invoice_cat eq 5311>
                <cfset this.basket_data.acc_type_id = -9>
                <cfset this.basket_data.acc_export = fn_GET_CONSUMER_PERIOD(consumer_id: this.basket_data.consumer_id, acc_type_id: this.basket_data.acc_type_id)>
                <cfif not len(this.basket_data.acc_export)>
                    <cfset this.basket_data.basket_check_status = 0>
                    <cfset this.basket_data.basket_check_status_code = "company_havent_export_acc_code">
                    <cfreturn "">
                </cfif>
            </cfif>
            <cfif not len(this.basket_data.acc)>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "company_havent_acc_code">
                <cfreturn "">
            </cfif>
        <cfelseif isDefined("this.basket_data.employee_id") and len(this.basket_data.employee_id) and not isDefined('this.basket_data.is_from_zreport')>
            <cfif not isdefined("this.basket_data.acc_type_id")><cfset this.basket_data.acc_type_id = len(this.basket_data.is_account_type_id) ? this.basket_data.is_account_type_id : ""></cfif>
            <cfset fn_GET_EMPLOYEE_PERIOD = application.functions.GET_EMPLOYEE_PERIOD>
            <cfset this.basket_data.acc = fn_GET_EMPLOYEE_PERIOD(this.basket_data.employee_id, this.basket_data.acc_type_id)>
            <cfif this.basket_data.invoice_cat eq 52 and not len(this.basket_data.acc)>
                <cfset this.basket_data.acc = query_GET_NO_.HIZLI_F>
            </cfif>
            <cfif not len(this.basket_data.acc)>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "company_havent_acc_code">
                <cfreturn "">
            </cfif>
        <cfelseif this.basket_data.invoice_cat eq 52>
            <cfset this.basket_data.acc = query_GET_NO_.HIZLI_F>
            <cfif not len(this.basket_data.acc)>
                <cfset this.basket_data.basket_check_status = 0>
                <cfset this.basket_data.basket_check_status_code = "company_havent_acc_code">
                <cfreturn "">
            </cfif>
        </cfif>

        <cfif isDefined('this.basket_data.yuvarlama') and len(this.basket_data.yuvarlama) and  this.basket_data.sale_product eq 0>
            <!--- sadece alis faturada calisiyor ve yukaridaki GET_NO_ query si SETUP_INVOICE_PURCHASE e girmis olmali (yani sadece alis faturalari icin calisir)--->
            <cfif this.basket_data.yuvarlama lt 0 >
                <cfset this.basket_data.hesap_yuvarlama = query_GET_NO_.YUVARLAMA_GELIR >
            <cfelse>
                <cfset this.basket_data.hesap_yuvarlama = query_GET_NO_.YUVARLAMA_GIDER >	
            </cfif>
        </cfif>

        <!--- basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor--->
        <cfset this.basket_data.currency_multiplier = ''>
        <cfset bakset_data.paper_currency_multiplier = ''>
        <cfif isDefined('this.basket_data.kur_say') and len(this.basket_data.kur_say)>
            <cfloop from="1" to="#this.basket_data.kur_say#" index="mon">
                <cfif evaluate("this.basket_data.hidden_rd_money_#mon#") is session_base.money2>
                    <cfset this.basket_data.currency_multiplier = evaluate('this.basket_data.txt_rate2_#mon#/this.basket_data.txt_rate1_#mon#')>
                </cfif>
                <cfif evaluate("this.basket_data.hidden_rd_money_#mon#") is this.basket_data.basket_money>
                    <cfset this.basket_data.paper_currency_multiplier = evaluate('this.basket_data.txt_rate2_#mon#/this.basket_data.txt_rate1_#mon#')>
                </cfif>
            </cfloop>	
        </cfif>
        
        <cfreturn "">
    </cffunction>

    <cffunction name="add_company">
        <cfscript>
            list="',""";
            list2=" , ";
            this.basket_data.member_name=replacelist(trim(this.basket_data.member_name),list,list2);
            this.basket_data.member_surname=replacelist(trim(this.basket_data.member_surname),list,list2);
            a = "";
            this.basket_data.comp_name=replacelist(trim(this.basket_data.comp_name),list,list2);
        </cfscript>

        <cfquery name="query_get_comp" datasource="#dsn2#">
            SELECT 	
                COMPANY_ID 
            FROM 
                #dsn#.COMPANY 
            WHERE 
                FULLNAME = '#this.basket_data.comp_name#'
            <cfif isDefined("this.basket_data.company_code") and len(this.basket_data.company_code)>
                OR MEMBER_CODE = '#this.basket_data.member_code#'
            </cfif>
        </cfquery>
        <cfif query_get_comp.recordcount>
            <cfset this.basket_data.basket_check_status = 0>
            <cfset this.basket_data.basket_check_status_code = "company_already_exist">
            <cfreturn "">
        </cfif>

        <cfquery name="query_add_company" datasource="#dsn2#">
            INSERT INTO 
                #dsn#.COMPANY
            (
                COMPANY_STATUS,
                COMPANYCAT_ID,
                COMPANY_STATE,
                PERIOD_ID,
                MEMBER_CODE,
                <cfif isdefined('this.basket_data.member_special_code') and len(this.basket_data.member_special_code)>OZEL_KOD,</cfif>
                FULLNAME,
                NICKNAME,
                TAXOFFICE,
                TAXNO,
                COMPANY_EMAIL,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,												
                COMPANY_ADDRESS,
                COUNTY,
                CITY,
                COUNTRY,
                IS_SELLER,
                IS_BUYER,
                IMS_CODE_ID,
                MOBIL_CODE,
                MOBILTEL,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE,
                IS_PERSON
            )
            VALUES
            (
                1,
                <cfif isdefined("this.basket_data.comp_member_cat") and len(this.basket_data.comp_member_cat)>#this.basket_data.comp_member_cat#,<cfelse>#this.basket_data.company_cat_id#,</cfif>
                #this.basket_data.company_stage#,
                #session_base.period_id#,
                <cfif len(this.basket_data.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_code#"><cfelse>NULL</cfif>,
                <cfif isdefined('this.basket_data.member_special_code') and len(this.basket_data.member_special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_special_code#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#">,
                <cfif len(this.basket_data.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_office#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_num#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(this.basket_data.email)#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#"><cfelse>NULL</cfif>,				
                <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.county_id)>#this.basket_data.county_id#<cfelse>NULL</cfif>,
                <cfif len(this.basket_data.city)>#this.basket_data.city#<cfelse>NULL</cfif>,
                1,
                0,
                1,
                <cfif isdefined("this.basket_data.ims_code_id") and len(this.basket_data.ims_code_id)>#this.basket_data.ims_code_id#<cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.mobil_code") and len(this.basket_data.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.mobil_tel") and len(this.basket_data.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#"><cfelse>NULL</cfif>,
                #session_base.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                <cfif isdefined("this.basket_data.is_person")>1<cfelse>0</cfif>			
            )
        </cfquery>
        <cfquery name="get_max" datasource="#dsn2#">
            SELECT MAX(COMPANY_ID) MAX_COMPANY FROM #dsn#.COMPANY
        </cfquery>	
        <cfquery name="query_add_comp_period" datasource="#dsn2#">
            INSERT INTO
                #dsn#.COMPANY_PERIOD
            (
                COMPANY_ID,
                PERIOD_ID
            )
            VALUES
            (
                #get_max.max_company#,
                #session_base.period_id#
            )
        </cfquery>
        <cfquery name="query_add_partner" datasource="#dsn2#">
            INSERT INTO 
                #dsn#.COMPANY_PARTNER 
            (
                COMPANY_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                COMPANY_PARTNER_EMAIL,
                MOBIL_CODE,
                MOBILTEL,
                COMPANY_PARTNER_TELCODE,
                COMPANY_PARTNER_TEL,
                COMPANY_PARTNER_FAX,					
                MEMBER_TYPE,					
                COMPANY_PARTNER_ADDRESS,
                COUNTY,
                CITY,
                RECORD_DATE,
                RECORD_MEMBER,
                RECORD_IP,
                TC_IDENTITY	
            )
            VALUES
            (
                #get_max.max_company#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_surname#">,
                <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.email#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#">,
                <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#">,
                <cfif len(this.basket_data.county_id)>#this.basket_data.county_id#<cfelse>NULL</cfif>,
                <cfif len(this.basket_data.city)>#this.basket_data.city#<cfelse>NULL</cfif>,
                #now()#,
                #session_base.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif isdefined("this.basket_data.tc_num") and len(this.basket_data.tc_num)>'#this.basket_data.tc_num#'<cfelse>NULL</cfif>
            )
        </cfquery>
        <cfquery name="GET_MAX_PARTNER" datasource="#dsn2#">
            SELECT
                MAX(PARTNER_ID) MAX_PARTNER_ID
            FROM
                #dsn#.COMPANY_PARTNER
        </cfquery>
        <cfquery name="query_upd_member_code" datasource="#dsn2#">
            UPDATE
                #dsn#.COMPANY_PARTNER
            SET
                MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#get_max_partner.max_partner_id#">
            WHERE
                PARTNER_ID = #get_max_partner.max_partner_id#
        </cfquery>
        <cfquery name="query_add_company_partner_detail" datasource="#dsn2#">
            INSERT INTO
                #dsn#.COMPANY_PARTNER_DETAIL
            (
                PARTNER_ID
            )
            VALUES
            (
                #get_max_partner.max_partner_id#
            )
        </cfquery>
        <cfquery name="query_add_part_settings" datasource="#dsn2#">
            INSERT INTO 
                #dsn#.MY_SETTINGS_P 
            (
                PARTNER_ID,
                TIME_ZONE,
                MAXROWS,
                TIMEOUT_LIMIT
            )
            VALUES 
            (
                #get_max_partner.max_partner_id#,
                0,
                20,
                30
            )
        </cfquery>
        <cfquery name="query_upd_member_code" datasource="#dsn2#">
            UPDATE 
                #dsn#.COMPANY 
            SET		
            <cfif isdefined("this.basket_data.company_code") and len(this.basket_data.company_code)>
                MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.company_code#">
            <cfelse>
                MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="C#get_max.max_company#">
            </cfif>
            WHERE 
                COMPANY_ID = #get_max.max_company#
        </cfquery>
        <cfquery name="query_upd_manager_partner" datasource="#dsn2#">
            UPDATE
                #dsn#.COMPANY
            SET
                MANAGER_PARTNER_ID = #get_max_partner.max_partner_id#
            WHERE
                COMPANY_ID = #get_max.max_company#
        </cfquery>
        <cfquery name="query_add_branch_related" datasource="#dsn2#">
            INSERT INTO
                #dsn#.COMPANY_BRANCH_RELATED
            (
                COMPANY_ID,
                OUR_COMPANY_ID,
                BRANCH_ID,
                OPEN_DATE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session_base.user_location,2,'-')#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
        <cfif session_base.our_company_info.is_efatura and isdefined("this.basket_data.tax_num") and len(this.basket_data.tax_num)>
            <cfquery name="CHK_EINVOICE_METHOD" datasource="#dsn2#">
             SELECT EINVOICE_TYPE,EINVOICE_TEST_SYSTEM,EINVOICE_USER_NAME,EINVOICE_PASSWORD FROM #dsn#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
         </cfquery>
          <cfscript>
             ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"COMPANY",Action_id:get_max.max_company,VKN:this.basket_data.tax_num,TCKN:this.basket_data.tc_num,using_alias:dsn2);
         </cfscript> 
        </cfif>

        <cfset this.basket_data.consumer_id ="">
        <cfset this.basket_data.company_id = GET_MAX.MAX_COMPANY>
        <cfset this.basket_data.partner_id = GET_MAX_PARTNER.MAX_PARTNER_ID>

    </cffunction>

    <cffunction name="upd_company">
        <cfscript>
            list="',""";
            list2=" , ";
            this.basket_data.member_name=replacelist(trim(this.basket_data.member_name),list,list2);
            this.basket_data.member_surname=replacelist(trim(this.basket_data.member_surname),list,list2);
        </cfscript>
        <cfquery name="query_get_comp" datasource="#dsn2#">
            SELECT
                COMPANY_ID
            FROM
                #dsn#.COMPANY
            WHERE
                COMPANY_ID <> #this.basket_data.company_id# AND
                <cfif isdefined("this.basket_data.tax_office") and Len(this.basket_data.tax_office)>
                    TAXOFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_office#"> AND
                </cfif>
                <cfif isdefined("this.basket_data.tax_num") and Len(this.basket_data.tax_num)>
                    TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_num#"> AND
                </cfif>
                (
                    FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#">
                <cfif isdefined("this.basket_data.member_code") and len(this.basket_data.member_code)>
                    OR MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_code#">
                </cfif>
                )
        </cfquery>
        <cfif query_get_comp.recordcount>
            <cfset this.basket_data.basket_check_status = 0>
            <cfset this.basket_data.basket_check_status_code = "company_already_exist">
            <cfreturn "">
        </cfif>

        <cfquery name="query_upd_company" datasource="#dsn2#">
            UPDATE 
                #dsn#.COMPANY 
            SET
                MEMBER_CODE = <cfif len(this.basket_data.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.ozel_kod") and len(this.basket_data.ozel_kod)>
                    OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.ozel_kod#">,
                </cfif>
                PERIOD_ID = #session_base.period_id#,
                FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#">,
                NICKNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#">,
                <cfif isdefined("this.basket_data.comp_member_cat") and len(this.basket_data.comp_member_cat)>
                    COMPANYCAT_ID = #this.basket_data.comp_member_cat#,
                </cfif>
                TAXOFFICE = <cfif len(this.basket_data.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_office#"><cfelse>NULL</cfif>,
                TAXNO = <cfif len(this.basket_data.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_num#"><cfelse>NULL</cfif>,
                COMPANY_EMAIL = <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(this.basket_data.email)#"><cfelse>NULL</cfif>,
                COMPANY_TELCODE = <cfif len(this.basket_data.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#"><cfelse>NULL</cfif>,
                COMPANY_TEL1 = <cfif len(this.basket_data.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#"><cfelse>NULL</cfif>,
                COMPANY_FAX =  <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,
                COMPANY_ADDRESS = <cfif len(this.basket_data.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#"><cfelse>NULL</cfif>,
                COUNTRY = 1,
                <cfif isdefined("this.basket_data.county_id") and len(this.basket_data.county_id)> COUNTY = #this.basket_data.county_id#,</cfif>
                IMS_CODE_ID = <cfif isdefined("this.basket_data.ims_code_id") and len(this.basket_data.ims_code_id)>#this.basket_data.ims_code_id#<cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.city") and len(this.basket_data.city)> CITY = #this.basket_data.city#, </cfif>
                <cfif isdefined("this.basket_data.mobil_code") and len(this.basket_data.mobil_code)>MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#">,</cfif>
                <cfif isdefined("this.basket_data.mobil_tel") and len(this.basket_data.mobil_tel)>MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#">,</cfif>
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session_base.userid#,
                UPDATE_DATE = #now()#,
                IS_PERSON = <cfif isdefined("this.basket_data.is_person")>1<cfelse>0</cfif>	
            WHERE
                COMPANY_ID = #this.basket_data.company_id#
        </cfquery>

        <cfquery name="query_add_partner" datasource="#dsn2#">
            UPDATE
                #dsn#.COMPANY_PARTNER 
            SET 
                COMPANY_PARTNER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_name#">,
                COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_surname#">,
                COMPANY_PARTNER_EMAIL = <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.email#"><cfelse>NULL</cfif>,
                MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#">,
                MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#">,
                COMPANY_PARTNER_TELCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#">,
                COMPANY_PARTNER_TEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#">,
                COMPANY_PARTNER_FAX = <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,			
                MEMBER_TYPE = 1,			
                COMPANY_PARTNER_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#">,
                <cfif isdefined("this.basket_data.county_id") and len(this.basket_data.county_id)>COUNTY = #this.basket_data.county_id#</cfif>,
                <cfif isdefined("this.basket_data.city") and len(this.basket_data.city)>CITY = #this.basket_data.city#</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_MEMBER =  #session_base.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                TC_IDENTITY	= <cfif isdefined("this.basket_data.tc_num") and len(this.basket_data.tc_num)>'#this.basket_data.tc_num#'<cfelse>NULL</cfif>
            WHERE
            COMPANY_ID = #this.basket_data.company_id#
        </cfquery>

    </cffunction>

    <cffunction name="add_consumer">
        <cfscript>
            list="',""";
            list2=" , ";
            this.basket_data.member_name=replacelist(this.basket_data.member_name,list,list2);
            this.basket_data.member_surname=replacelist(this.basket_data.member_surname,list,list2);
        </cfscript>

        <cfif isDefined("this.basket_data.tc_num") and len(this.basket_data.tc_num) and not (isdefined("this.basket_data.xml_kontrol_tcnumber") and this.basket_data.xml_kontrol_tcnumber eq 0)>
            <cfquery name="query_get_consumer_tc_kontrol" datasource="#dsn2#">
                SELECT
                    CONSUMER_ID,
                    TERMINATE_DATE,
                    CONSUMER_STATUS
                FROM
                    #dsn#.CONSUMER
                WHERE
                    TC_IDENTY_NO = '#trim(this.basket_data.tc_num)#'
            </cfquery>
            <cfif query_get_consumer_tc_kontrol.recordcount gte 1>
                <cfif query_get_consumer_tc_kontrol.consumer_status eq 0>
                    <cfset this.basket_data.basket_check_status = 0>
                    <cfset this.basket_data.basket_check_status_code = "tc_num_already_exists">
                    <cfreturn "">
                <cfelse>
                    <cfset this.basket_data.basket_check_status = 0>
                    <cfset this.basket_data.basket_check_status_code = "tc_num_already_exists">
                    <cfreturn "">
                </cfif>
            </cfif>
        </cfif>

        <cfquery name="query_add_consumer" datasource="#dsn2#">
            INSERT INTO
                #dsn#.CONSUMER
            (
                IS_CARI,
                ISPOTANTIAL,
                <cfif isdefined("this.basket_data.member_special_code") and len(this.basket_data.member_special_code)>OZEL_KOD,</cfif>
                CONSUMER_CAT_ID,
                CONSUMER_STAGE,
                CONSUMER_EMAIL,
                CONSUMER_FAX,
                CONSUMER_FAXCODE,
                COMPANY,
                CONSUMER_NAME,
                CONSUMER_SURNAME,
                MOBIL_CODE,
                MOBILTEL,
                <cfif isdefined("this.basket_data.mobil_code_2")>MOBIL_CODE_2,</cfif>
                <cfif isdefined("this.basket_data.mobil_tel_2")>MOBILTEL_2,</cfif>
                TAX_OFFICE,
                TAX_NO,
                <cfif isdefined("this.basket_data.adres_type") and len(this.basket_data.adres_type)>
                    CONSUMER_HOMETEL,
                    CONSUMER_HOMETELCODE,
                    HOMEADDRESS,
                    HOME_COUNTY_ID,
                    HOME_CITY_ID,
                    HOME_COUNTRY_ID,
                <cfelse>
                    CONSUMER_WORKTEL,
                    CONSUMER_WORKTELCODE,
                    TAX_ADRESS,
                    TAX_COUNTY_ID,
                    TAX_CITY_ID,
                    TAX_COUNTRY_ID,
                </cfif>
                TC_IDENTY_NO,
                VOCATION_TYPE_ID,
                IMS_CODE_ID,
                PERIOD_ID,
                RECORD_IP,
                RECORD_MEMBER,
                RECORD_DATE
            )
            VALUES 	 
            (
                1,
                0,
                <cfif isdefined("this.basket_data.member_special_code") and len(this.basket_data.member_special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_special_code#">,</cfif>
                <cfif isdefined("this.basket_data.cons_member_cat") and len(this.basket_data.cons_member_cat)>#cons_member_cat#,<cfelse>#this.basket_data.consumer_cat_id#,</cfif>
                #this.basket_data.consumer_stage#,
                <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.email#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.faxcode") and len(this.basket_data.faxcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.faxcode#"><cfelse>NULL</cfif>,
                <cfif isDefined("this.basket_data.comp_name") and Len(this.basket_data.comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_surname#">,
                <cfif len(this.basket_data.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.mobil_code_2")><cfif len(this.basket_data.mobil_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code_2#"><cfelse>NULL</cfif>,</cfif>
                <cfif isdefined("this.basket_data.mobil_tel_2")><cfif len(this.basket_data.mobil_tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel_2#"><cfelse>NULL</cfif>,</cfif>
                <cfif len(this.basket_data.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_office#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_num#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#"><cfelse>NULL</cfif>,
                <cfif len(this.basket_data.county_id)>#this.basket_data.county_id#<cfelse>NULL</cfif>,
                <cfif len(this.basket_data.city)>#this.basket_data.city#<cfelse>NULL</cfif>,
                1,
                <cfif isdefined('this.basket_data.tc_num') and len(this.basket_data.tc_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tc_num#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.vocation_type") and len(this.basket_data.vocation_type)>#this.basket_data.vocation_type#<cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.ims_code_id") and len(this.basket_data.ims_code_id)>#this.basket_data.ims_code_id#<cfelse>NULL</cfif>,
                #session_base.period_id#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #session_base.userid#,
                #now()#
            )
        </cfquery>
        <cfquery name="GET_MAX_CONS" datasource="#dsn2#">
            SELECT 
                MAX(CONSUMER_ID) MAX_CONS 
            FROM 
                #dsn#.CONSUMER
        </cfquery>
        <cfquery name="query_upd_member_code" datasource="#dsn2#">
            UPDATE 
                #dsn#.CONSUMER 
            SET 
                <cfif isdefined("this.basket_data.member_code") and len(this.basket_data.member_code)>
                    MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(this.basket_data.member_code)#">
                <cfelse>
                    MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="B#get_max_cons.max_cons#">
                </cfif>
            WHERE 
                CONSUMER_ID = #get_max_cons.max_cons#
        </cfquery>
        <cfquery name="query_add_comp_period" datasource="#dsn2#">
            INSERT INTO
                #dsn#.CONSUMER_PERIOD
            (
                CONSUMER_ID,
                PERIOD_ID,
                ACCOUNT_CODE
            )
            VALUES
            (
                #get_max_cons.max_cons#,
                #session_base.period_id#,
                <cfif isdefined("this.basket_data.acc") and len(this.basket_data.acc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.acc#"><cfelse>NULL</cfif>
            )
        </cfquery>
        <cfquery name="query_add_branch_related" datasource="#dsn2#">
            INSERT INTO
                #dsn#.COMPANY_BRANCH_RELATED
            (
                CONSUMER_ID,
                OUR_COMPANY_ID,
                BRANCH_ID,
                OPEN_DATE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session_base.user_location,2,'-')#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>

        <cf_workcube_process is_upd='1' 
        data_source='#dsn2#'
        old_process_line='0'
        process_stage='#this.basket_data.consumer_stage#' 
        record_member='#session_base.userid#' 
        record_date='#now()#' 
        action_table='CONSUMER'
        action_column='CONSUMER_ID'
        action_id='#get_max_cons.max_cons#'
        action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#' 
        warning_description='Bireysel Üye : #this.basket_data.member_name# #this.basket_data.member_surname#'>

        <cfif session_base.our_company_info.is_efatura and isdefined("this.basket_data.tc_num") and len(this.basket_data.tc_num)>
            <cfquery name="query_chk_einvoice_method" datasource="#dsn2#">
                SELECT EINVOICE_TYPE,EINVOICE_TEST_SYSTEM,EINVOICE_COMPANY_CODE,EINVOICE_USER_NAME,EINVOICE_PASSWORD FROM #dsn#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
            </cfquery>
            <cfif query_chk_einvoice_method.einvoice_type eq 3>
                <cfif query_chk_einvoice_method.einvoice_test_system eq 1>
                    <cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
                <cfelse>
                    <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
                </cfif>

                <cfxml variable="ticket_data"><cfoutput>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:GetFormsAuthenticationTicket>
                            <tem:CorporateCode>#query_chk_einvoice_method.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                            <tem:LoginName>#query_chk_einvoice_method.EINVOICE_USER_NAME#</tem:LoginName>
                            <tem:Password><![CDATA[#query_chk_einvoice_method.EINVOICE_PASSWORD#]]></tem:Password>
                        </tem:GetFormsAuthenticationTicket>
                    </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfxml>

                <cfhttp url="#web_service_url#" method="post" result="httpResponse">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
                    <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
                </cfhttp>

                <cfset Ticket = xmlParse(httpResponse.filecontent)>
                <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            
                <cfsavecontent variable="xml_tc_identy"><cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                    <soapenv:Body>
                    <tem:CheckCustomerTaxId>
                        <tem:Ticket>#Ticket#</tem:Ticket>
                        <tem:TaxIdOrPersonalId>#this.basket_data.tc_num#</tem:TaxIdOrPersonalId>
                    </tem:CheckCustomerTaxId>
                    </soapenv:Body>
                </soapenv:Envelope></cfoutput>
                </cfsavecontent>

                <cfhttp url="#web_service_url#" method="post" result="httpResponse">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckCustomerTaxId">
                    <cfhttpparam type="header" name="content-length" value="#len(xml_tc_identy)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(xml_tc_identy)#">
                </cfhttp>

                <cfset is_exist = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.IsExist.XmlText>
                <cfset RegisterTime = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.RegisterTime.XmlText>
                <cfif is_exist eq 'true'>
                    <cfquery name="UPD_CONS" datasource="#DSN#">
                        UPDATE CONSUMER SET USE_EFATURA = 1,EFATURA_DATE = #CreateODBCDateTime(replace(RegisterTime,'T',' '))# WHERE CONSUMER_ID = #get_max_cons.max_cons#
                    </cfquery>
                </cfif>
            <cfelseif query_chk_einvoice_method.einvoice_type eq 6>
                <cfif query_chk_einvoice_method.einvoice_test_system eq 1>
                    <cfset web_service_url = 'http://178.251.43.49:8080/efatura/ws/connectorService?wsdl'>
                    <cfset is_test = 1>
                <cfelse>
                    <cfset web_service_url = 'https://connector.efinans.com.tr/connector/ws/connectorService?wsdl '>
                    <cfset is_test = 0>
                </cfif>  
                <cfset ef.lang = 'tr'>
                <cfset vkn = this.basket_data.tc_num>
                <cfscript>
                    objeFinans = createObject("component", "V16.add_options.cfc.efinans").init(query_chk_einvoice_method.EINVOICE_USER_NAME, query_chk_einvoice_method.EINVOICE_PASSWORD, ef.lang, is_test);
                    httpResponse = objeFinans.efaturaKullaniciBilgisi(vkn);
                </cfscript>
                <cfset soapResponse = xmlParse(httpResponse.fileContent) />
                <cfset responseNodes = xmlSearch(soapResponse, "//*[ local-name() = 'return' ]" ) />
                <cfif arraylen(responseNodes) gt 0>
                    <cfset RegisterTime = xmlparse(httpResponse.filecontent).Envelope.Body.efaturaKullaniciBilgisiResponse.return.kayitZamani.xmltext>
                     <cfscript>
                        year_ = mid(RegisterTime,1,4);
                        month_ = mid(RegisterTime,5,2);
                        day_ = mid(RegisterTime,7,2);
                        my_date = createdate(year_,month_,day_);
                    </cfscript>
                    <cfquery name="UPD_CONS" datasource="#DSN#">
                        UPDATE CONSUMER SET USE_EFATURA = 1,EFATURA_DATE = #my_date# WHERE CONSUMER_ID = #GET_MAX_CONS.MAX_CONS#
                    </cfquery>
                </cfif>
            </cfif>
        </cfif>

        <cfset this.basket_data.consumer_id = GET_MAX_CONS.MAX_CONS>
        <cfset this.basket_data.company_id = "">
        <cfset this.basket_data.partner_id = "">	

    </cffunction>

    <cffunction name="upd_consumer">
        <cfscript>
            list="',""";
            list2=" , ";
            this.basket_data.member_name=replacelist(this.basket_data.member_name,list,list2);
            this.basket_data.member_surname=replacelist(this.basket_data.member_surname,list,list2);
        </cfscript>

        <cfquery name="query_upd_consumer" datasource="#dsn2#">
            UPDATE
                #dsn#.CONSUMER 
            SET
                COMPANY = <cfif len(this.basket_data.comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.comp_name#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.cons_member_cat") and len(this.basket_data.cons_member_cat)>
                    CONSUMER_CAT_ID = #this.basket_data.cons_member_cat#,
                </cfif>
                <cfif isdefined("this.basket_data.email") and len(this.basket_data.email)>CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.email#">,</cfif>
                CONSUMER_FAX = <cfif isdefined("this.basket_data.fax_number") and len(this.basket_data.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.fax_number#"><cfelse>NULL</cfif>,
                CONSUMER_FAXCODE = <cfif isdefined("this.basket_data.faxcode") and len(this.basket_data.faxcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.faxcode#"><cfelse>NULL</cfif>,
                CONSUMER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_name#">,
                CONSUMER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.member_surname#">,
                MOBIL_CODE = <cfif isdefined("this.basket_data.mobil_code") and len(this.basket_data.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code#"><cfelse>NULL</cfif>,
                MOBILTEL = <cfif isdefined("this.basket_data.mobil_tel") and len(this.basket_data.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel#"><cfelse>NULL</cfif>,
                TAX_OFFICE = <cfif len(this.basket_data.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_office#"><cfelse>NULL</cfif>,	
                TAX_NO = <cfif len(this.basket_data.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tax_num#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.adres_type") and len(this.basket_data.adres_type)>
                    CONSUMER_HOMETEL = <cfif len(this.basket_data.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#"><cfelse>NULL</cfif>,
                    CONSUMER_HOMETELCODE = <cfif len(this.basket_data.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#"><cfelse>NULL</cfif>,
                    HOMEADDRESS = <cfif len(this.basket_data.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#"><cfelse>NULL</cfif>,
                    <cfif isdefined("this.basket_data.county_id") and len(this.basket_data.county_id)>HOME_COUNTY_ID = #this.basket_data.county_id#,</cfif>
                    <cfif isdefined("this.basket_data.city") and len(this.basket_data.city)> HOME_CITY_ID = #this.basket_data.city#,</cfif>
                <cfelse>
                    CONSUMER_WORKTEL = <cfif len(this.basket_data.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_number#"><cfelse>NULL</cfif>,
                    CONSUMER_WORKTELCODE = <cfif len(this.basket_data.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tel_code#"><cfelse>NULL</cfif>,
                    TAX_ADRESS = <cfif len(this.basket_data.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#"><cfelse>NULL</cfif>,
                    <cfif isdefined("this.basket_data.county_id") and len(this.basket_data.county_id)>TAX_COUNTY_ID = #this.basket_data.county_id#,</cfif>
                    <cfif len(this.basket_data.city)> TAX_CITY_ID = #this.basket_data.city#,</cfif>
                    TAX_COUNTRY_ID = 1,
                </cfif>
                MEMBER_CODE=<cfif len(this.basket_data.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(this.basket_data.member_code)#"><cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.ozel_kod") and len(this.basket_data.ozel_kod)>
                    OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.ozel_kod#">,
                </cfif>
                <cfif isdefined("this.basket_data.mobil_code_2")>
                    MOBIL_CODE_2 = <cfif len(this.basket_data.mobil_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_code_2#"><cfelse>NULL</cfif>,
                </cfif>
                <cfif isdefined("this.basket_data.mobil_tel_2")>
                    MOBILTEL_2 = <cfif len(this.basket_data.mobil_tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.mobil_tel_2#"><cfelse>NULL</cfif>,
                </cfif>
                TC_IDENTY_NO = <cfif len(this.basket_data.tc_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.tc_num#"><cfelse>NULL</cfif>,
                VOCATION_TYPE_ID= <cfif isdefined("this.basket_data.vocation_type") and len(this.basket_data.vocation_type)>#this.basket_data.vocation_type#<cfelse>NULL</cfif>,
                IMS_CODE_ID = <cfif isdefined("this.basket_data.ims_code_id") and len(this.basket_data.ims_code_id)>#this.basket_data.ims_code_id#<cfelse>NULL</cfif>,
                PERIOD_ID = #session_base.period_id#,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session_base.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE 
                CONSUMER_ID = #this.basket_data.consumer_id#
        </cfquery>
        <cfif isdefined("this.basket_data.acc") and len(this.basket_data.acc)>
            <cfquery name="UPD_COMP_PERIOD" datasource="#dsn2#">
                UPDATE
                    #dsn#.CONSUMER_PERIOD
                SET
                    ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.acc#">
                WHERE	
                    CONSUMER_ID = #this.basket_data.consumer_id#
                    AND PERIOD_ID = #session_base.period_id#
            </cfquery>		
        </cfif>

    </cffunction>

    <cffunction name="add_sale">
        <cfquery name="query_ADD_INVOICE_SALE" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO INVOICE
                (
            <cfif isdefined("this.basket_data.query_get_customer_info.SALES_COUNTY") and len(this.basket_data.query_get_customer_info.SALES_COUNTY)>
                ZONE_ID,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.RESOURCE_ID") and len(this.basket_data.query_get_customer_info.RESOURCE_ID)>
                RESOURCE_ID,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.IMS_CODE_ID") and len(this.basket_data.query_get_customer_info.IMS_CODE_ID)>
                IMS_CODE_ID,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.CUSTOMER_VALUE_ID") and len(this.basket_data.query_get_customer_info.CUSTOMER_VALUE_ID)>
                CUSTOMER_VALUE_ID,
            </cfif>
                WRK_ID,
                IS_CASH,
                PURCHASE_SALES,
                INVOICE_NUMBER,
                INVOICE_CAT,
                INVOICE_DATE,
                DUE_DATE,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
                NETTOTAL,
                GROSSTOTAL,
                TAXTOTAL,
                OTV_TOTAL,
                SA_DISCOUNT,
                NOTE,
                <cfif isDefined("this.basket_data.EMPO_ID") and len(this.basket_data.EMPO_ID)>
                    <cfif this.basket_data.EMPO_ID neq 0>SALE_EMP,<cfelse>SALE_PARTNER,</cfif>
                </cfif>
                DELIVER_EMP, 
                DEPARTMENT_ID,
                DEPARTMENT_LOCATION,
                RECORD_DATE,
                RECORD_EMP,
                SHIP_METHOD,
                UPD_STATUS,
                OTHER_MONEY,
                OTHER_MONEY_VALUE,
                IS_WITH_SHIP,
                TEVKIFAT,
                TEVKIFAT_ORAN,
                TEVKIFAT_ID,
                PROCESS_CAT,
                ASSETP_ID
                <cfif isdefined("session_base") and session_base.our_company_info.project_followup eq 1>
                    ,PROJECT_ID
                </cfif>
                <cfif isdefined("this.basket_data.from_whops") and isdefined("this.basket_data.pos_eq_id") and len(this.basket_data.pos_eq_id)>
                    ,POS_CASH_ID
                </cfif>
            )
            VALUES
            (
            <cfif isdefined("this.basket_data.query_get_customer_info.SALES_COUNTY") and len(this.basket_data.query_get_customer_info.SALES_COUNTY)>
                #this.basket_data.query_get_customer_info.SALES_COUNTY#,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.RESOURCE_ID") and len(this.basket_data.query_get_customer_info.RESOURCE_ID)>
                #this.basket_data.query_get_customer_info.RESOURCE_ID#,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.IMS_CODE_ID") and len(this.basket_data.query_get_customer_info.IMS_CODE_ID)>
                #this.basket_data.query_get_customer_info.IMS_CODE_ID#,
            </cfif>
            <cfif isdefined("this.basket_data.query_get_customer_info.CUSTOMER_VALUE_ID") and len(this.basket_data.query_get_customer_info.CUSTOMER_VALUE_ID)>
                #this.basket_data.query_get_customer_info.CUSTOMER_VALUE_ID#,
            </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.wrk_id#">,
                <cfif isDefined("this.basket_data.CASH")>#this.basket_data.cash#,<cfelse>NULL,</cfif>
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.INVOICE_NUMBER#">,
                #this.basket_data.invoice_cat#,
                #this.basket_data.invoice_date#,
                <cfif isdefined("this.basket_data.invoice_due_date") and len(this.basket_data.invoice_due_date)>#this.basket_data.invoice_due_date#<cfelse>NULL</cfif>,
                <cfif isdefined("this.basket_data.member_type") and this.basket_data.member_type eq 1>
                    <cfif len(this.basket_data.company_id)>#this.basket_data.company_id#<cfelse>NULL</cfif>,
                    <cfif len(this.basket_data.partner_id)>#this.basket_data.partner_id#<cfelse>NULL</cfif>,
                    NULL,
                <cfelse>
                    NULL,
                    NULL,
                    <cfif len(this.basket_data.consumer_id)>#this.basket_data.consumer_id#<cfelse>NULL</cfif>,
                </cfif>
                #this.basket_data.basket_net_total#,
                #this.basket_data.basket_gross_total#,
                #this.basket_data.basket_tax_total#,
                <cfif len(this.basket_data.basket_otv_total)>#this.basket_data.basket_otv_total#<cfelse>NULL</cfif>,
                #this.basket_data.genel_indirim#,
                <cfif isDefined("this.basket_data.NOTE") and len(this.basket_data.NOTE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.NOTE#"><cfelse>NULL</cfif>,
                <cfif isDefined("this.basket_data.EMPO_ID") and len(this.basket_data.EMPO_ID)>
                    <cfif this.basket_data.EMPO_ID neq 0>#this.basket_data.EMPO_ID#<cfelse>#this.basket_data.PARTO_ID#</cfif>,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(this.basket_data.DELIVER_GET),50)#">,
                #this.basket_data.department_id#,
                #this.basket_data.location_id#,
                #NOW()#,
                #session_base.USERID#,
                <cfif isdefined('this.basket_data.ship_method') and len(this.basket_data.ship_method)>#this.basket_data.ship_method#<cfelse>NULL</cfif>,
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.basket_money#">,
                #((this.basket_data.BASKET_NET_TOTAL*this.basket_data.BASKET_RATE1)/this.basket_data.BASKET_RATE2)#,
            <cfif (not this.basket_data.included_irs) and (this.basket_data.inventory_product_exists eq 1)>
                1,
            <cfelse>
                0,
            </cfif>
            <cfif isdefined("this.basket_data.tevkifat_box")>1<cfelse>0</cfif>,
            <cfif isdefined("this.basket_data.tevkifat_oran") and len(this.basket_data.tevkifat_oran)>#this.basket_data.tevkifat_oran#<cfelse>NULL</cfif>,
            <cfif isdefined("this.basket_data.tevkifat_id") and len(this.basket_data.tevkifat_id)>#this.basket_data.tevkifat_id#<cfelse>NULL</cfif>,
                #this.basket_data.PROCESS_CAT#,
            <cfif isdefined("this.basket_data.asset_id") and len(this.basket_data.asset_id) and len(this.basket_data.asset_name)>#this.basket_data.asset_id#<cfelse>NULL</cfif>
            <cfif isdefined("session_base") and session_base.our_company_info.project_followup eq 1>
                ,<cfif isdefined("this.basket_data.project_id") and len(this.basket_data.project_id) and isdefined("this.basket_data.project_head") and len(this.basket_data.project_head)>#this.basket_data.project_id#<cfelse>NULL</cfif>
            </cfif>
            <cfif isdefined("this.basket_data.from_whops") and isdefined("this.basket_data.pos_eq_id") and len(this.basket_data.pos_eq_id)>
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#this.basket_data.pos_eq_id#">
            </cfif>
            )
        </cfquery>
        <cfset this.basket_data.invoice_id = MAX_ID.IDENTITYCOL>
        <cfset this.basket_data.dagilim = false>
        <cfset this.basket_data.product_id_list="">
        <cfset this.basket_data.karma_product_list=""><!--- karma koli urunleri tutuyor --->

        <cfloop from="1" to="#this.basket_data.rows_#" index="i">
            <cf_date tarih='this.basket_data.deliver_date#i#'>
            <cfif session_base.our_company_info.spect_type and isdefined("this.basket_data.is_production#i#") and evaluate('this.basket_data.is_production#i#') eq 1 and not isdefined('this.basket_data.spect_id#i#') or not len(evaluate('this.basket_data.spect_id#i#'))>
                <cfset dsn_type=dsn2>
                
                <cfif not isdefined('this.basket_data.GET_TREE#i#.RECORDCOUNT') or evaluate('this.basket_data.GET_TREE#i#.RECORDCOUNT') eq 0 or (isDefined("this.basket_data.RetryEx") and this.basket_data.RetryEx eq 1)><!--- ozellikli spec degil veya ozellikli spec olsada urun ozelligi yoksa agaci varsa o kaydedilecek --->
                    <cfif not isdefined('dsn_type')>
                        <cfset dsn_type=dsn3>
                    </cfif>
                    <cfquery name="this.basket_data.GET_TREE#i#" datasource="#dsn_type#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor.aşağıdada bu main spec kullanılarak bir spec oluşturuluyor..ve baskete yansıtılıyor.. --->
                        SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("this.basket_data..stock_id#i#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
                    </cfquery>
                    
                </cfif>
                
                <!---
                <cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session_base.company_id)>
                    <cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
                <cfelse>
                    <cfset new_dsn3 = dsn3>
                </cfif>
                --->

                <cfscript>
                    if(not isdefined("this.basket_data.company_id")) this.basket_data.company_id = 0;
                    if(not isdefined('this.basket_data.consumer_id')) this.basket_data.consumer_id = 0;
                    if(evaluate('this.basket_data.GET_TREE#i#.RECORDCOUNT'))
                    {
                        specer = application.mmFunctions.specer;
                        'spec_info#i#' = specer(
                                dsn_type:dsn_type,
                                spec_type:1,
                                main_spec_id: evaluate('this.basket_data.GET_TREE#i#.SPECT_MAIN_ID'),
                                add_to_main_spec:1,
                                company_id: this.basket_data.company_id,
                                consumer_id: this.basket_data.consumer_id
                            );
                        if(isdefined('this.basket_data.is_spect_name_to_property') and this.basket_data.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
                            configure_spec_name = evaluate("this.basket_data.product_name#i#");
                            GetProductConf = application.mmFunctions.GetProductConf;
                            GetProductConf(listgetat(Evaluate('spec_info#i#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
                        }
                    }
                </cfscript>
                <cfif isdefined("this.basket_data.is_spect_name_to_property") and this.basket_data.is_spect_name_to_property eq 1 and isdefined('spec_info#i#')>
                    <cfquery name="UpdateSpecNameQuery" datasource="#new_dsn3#">
                        UPDATE SPECT_MAIN SET SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(configure_spec_name,499)#"> WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#i#'),1,',')#              
                    </cfquery>
                    <cfif len(listgetat(Evaluate('spec_info#i#'),1,',')) and listgetat(Evaluate('spec_info#i#'),1,',') gt 0>
                        <cfquery name="UpdateS_V_SpecNameQuery" datasource="#new_dsn3#">
                            UPDATE SPECTS SET SPECT_VAR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(configure_spec_name,499)#"> WHERE SPECT_VAR_ID = #listgetat(Evaluate('spec_info#i#'),2,',')#
                        </cfquery>
                    </cfif>
                </cfif>

                <!--- zaten bu dosya calisiyorsa spec agactan uretilecektir bu yuzden satir tutarlarını degistirmiyoz --->
                <cfif isdefined('spec_info#i#') and listlen(evaluate('spec_info#i#'),',')>

                    <cfset 'this.basket_data.spect_id#i#' = listgetat(evaluate('spec_info#i#'),2,',')>
                    <cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
                        <cfset 'this.basket_data.spect_name#i#' = listgetat(evaluate('spec_info#i#'),3,',')>
                    <cfelse>
                        <cfset 'this.basket_data.spect_name#i#' = evaluate("this.basket_data.product_name#i#")>
                    </cfif>
                </cfif>

            </cfif>

            <cfset this.basket_data.product_id_list = listappend(this.basket_data.product_id_list ,evaluate("this.basket_data.product_id#i#"))>

            <cfif isdefined('this.basket_data.row_ship_id#i#')><cfset ship_id = evaluate('this.basket_data.row_ship_id#i#')><cfelse><cfset ship_id = 0></cfif>
            <cfif isdefined('this.basket_data.indirim1#i#') and len(evaluate("this.basket_data.indirim1#i#")) ><cfset indirim1 = evaluate('this.basket_data.indirim1#i#')><cfelse><cfset indirim1 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim2#i#') and len(evaluate("this.basket_data.indirim2#i#")) ><cfset indirim2 = evaluate('this.basket_data.indirim2#i#')><cfelse><cfset indirim2 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim3#i#') and len(evaluate("this.basket_data.indirim3#i#")) ><cfset indirim3 = evaluate('this.basket_data.indirim3#i#')><cfelse><cfset indirim3 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim4#i#') and len(evaluate("this.basket_data.indirim4#i#")) ><cfset indirim4 = evaluate('this.basket_data.indirim4#i#')><cfelse><cfset indirim4 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim5#i#') and len(evaluate("this.basket_data.indirim5#i#")) ><cfset indirim5 = evaluate('this.basket_data.indirim5#i#')><cfelse><cfset indirim5 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim6#i#') and len(evaluate("this.basket_data.indirim6#i#")) ><cfset indirim6 = evaluate('this.basket_data.indirim6#i#')><cfelse><cfset indirim6 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim7#i#') and len(evaluate("this.basket_data.indirim7#i#")) ><cfset indirim7 = evaluate('this.basket_data.indirim7#i#')><cfelse><cfset indirim7 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim8#i#') and len(evaluate("this.basket_data.indirim8#i#")) ><cfset indirim8 = evaluate('this.basket_data.indirim8#i#')><cfelse><cfset indirim8 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim9#i#') and len(evaluate("this.basket_data.indirim9#i#")) ><cfset indirim9 = evaluate('this.basket_data.indirim9#i#')><cfelse><cfset indirim9 = 0></cfif>
            <cfif isdefined('this.basket_data.indirim10#i#') and len(evaluate("this.basket_data.indirim10#i#")) ><cfset indirim10 = evaluate('this.basket_data.indirim10#i#')><cfelse><cfset indirim10 = 0></cfif>
            <cfset indirim_carpan = 100000000000000000000 - ((100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5)*(100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)) >
            <cfif isdefined('this.basket_data.row_total#i#') and len(evaluate("this.basket_data.row_total#i#"))>
                <cfset discount_amount = evaluate("this.basket_data.row_total#i#")-evaluate("this.basket_data.row_nettotal#i#") >
            <cfelse>
                <cfset discount_amount = 0>
            </cfif>

            <cfif isdefined('this.basket_data.reason_code#i#') and len(evaluate('this.basket_data.reason_code#i#'))>
                <cfset reasonCode = Replace(evaluate('this.basket_data.reason_code#i#'),'--','*')>
            <cfelse>
                <cfset reasonCode = ''>
            </cfif>

            <cfquery name="query_ADD_SHIP_ROW" datasource="#dsn2#">
                INSERT INTO
                    INVOICE_ROW
                    (
                        PURCHASE_SALES,
                        PRODUCT_ID,
                        NAME_PRODUCT,
                        INVOICE_ID,
                        STOCK_ID,
                        AMOUNT,
                        UNIT,
                        UNIT_ID,				
                        PRICE,
                        DISCOUNTTOTAL,
                        GROSSTOTAL,
                        NETTOTAL,
                        TAXTOTAL,
                        TAX,
                        DUE_DATE,
                        DISCOUNT1,
                        DISCOUNT2,
                        DISCOUNT3,
                        DISCOUNT4,
                        DISCOUNT5,
                        DISCOUNT6,
                        DISCOUNT7,
                        DISCOUNT8,
                        DISCOUNT9,
                        DISCOUNT10,				
                        DELIVER_DATE,
                        DELIVER_DEPT,
                        DELIVER_LOC,
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE,
                    <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                        SPECT_VAR_ID,
                        SPECT_VAR_NAME,
                    </cfif>
                        LOT_NO,
                        PRICE_OTHER,
                        OTHER_MONEY_GROSS_TOTAL,
                        <!--- COST_ID, --->
                        COST_PRICE,
                        MARGIN,
                        SHIP_ID,
                        SHIP_PERIOD_ID,
                        DISCOUNT_COST,
                        IS_PROMOTION,
                        UNIQUE_RELATION_ID,
                        PROM_RELATION_ID,
                        PRODUCT_NAME2,
                        AMOUNT2,
                        UNIT2,
                        EXTRA_PRICE,
                        EXTRA_PRICE_TOTAL,
                        SHELF_NUMBER,
                        PRODUCT_MANUFACT_CODE,
                        BASKET_EXTRA_INFO_ID,
                        SELECT_INFO_EXTRA,
                        DETAIL_INFO_EXTRA,
                        BASKET_EMPLOYEE_ID,
                        OTV_ORAN,
                        OTVTOTAL,
                        PROM_ID,
                        PROM_COMISSION,
                        PROM_STOCK_ID,				
                        IS_COMMISSION,				
                        PRICE_CAT,
                        CATALOG_ID,
                        PROM_COST,
                        WRK_ROW_ID,
                        WRK_ROW_RELATION_ID,
                        WIDTH_VALUE,
                        DEPTH_VALUE,
                        HEIGHT_VALUE,
                        ROW_PROJECT_ID,
                        REASON_CODE,
                        REASON_NAME
                        <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,ROW_EXP_CENTER_ID</cfif>
                        <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,ROW_EXP_ITEM_ID</cfif>
                        <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                        <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,ROW_ACC_CODE</cfif>
                        <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
                        <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,ASSETP_ID</cfif>
                        <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                        <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
                        <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
                        <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                        <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
                        <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                        <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
                    )
                VALUES
                    (
                        1,
                        #evaluate("this.basket_data.product_id#i#")#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('this.basket_data.product_name#i#'),250)#">,
                        #MAX_ID.IDENTITYCOL#,
                        #evaluate("this.basket_data.stock_id#i#")#,
                        #evaluate("this.basket_data.amount#i#")#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit#i#')#">,
                        #evaluate("this.basket_data.unit_id#i#")#,
                        #evaluate("this.basket_data.price#i#")#,
                        #DISCOUNT_AMOUNT#,
                        #evaluate("this.basket_data.row_lasttotal#i#")#,
                        #evaluate("this.basket_data.row_nettotal#i#")#,
                        #evaluate("this.basket_data.row_taxtotal#i#")#,
                        #evaluate("this.basket_data.tax#i#")#,
                        <cfif isdefined("this.basket_data.duedate#i#") and len(Evaluate("this.basket_data.duedate#i#"))>#Evaluate("this.basket_data.duedate#i#")#<cfelse>0</cfif>,
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
                    <cfif isdefined('this.basket_data.deliver_date#i#') and isdate(evaluate('this.basket_data.deliver_date#i#'))>#evaluate('this.basket_data.deliver_date#i#')#,<cfelse>NULL,</cfif>
                    <cfif isdefined("this.basket_data.deliver_dept#i#") and len(trim(evaluate("this.basket_data.deliver_dept#i#"))) and len(listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                        #listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                    <cfelseif isdefined('this.basket_data.department_id') and len(this.basket_data.department_id)>
                        #this.basket_data.department_id#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif isdefined("this.basket_data.deliver_dept#i#") and listlen(trim(evaluate("this.basket_data.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                        #listlast(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                    <cfelseif isdefined('this.basket_data.location_id') and len(this.basket_data.location_id)>
                        #this.basket_data.location_id#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif isdefined('this.basket_data.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.other_money_#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined("this.basket_data.other_money_value_#i#") and len(evaluate("this.basket_data.other_money_value_#i#"))>#evaluate("this.basket_data.other_money_value_#i#")#<cfelse>NULL</cfif>,
                    <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                        #evaluate("this.basket_data.spect_id#i#")#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.spect_name#i#')#">,
                    </cfif>
                    <cfif isdefined("this.basket_data.lot_no#i#") and len(evaluate("this.basket_data.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.lot_no#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined("this.basket_data.price_other#i#") and len(evaluate("this.basket_data.price_other#i#"))>#evaluate("this.basket_data.price_other#i#")#<cfelse>0</cfif>,
                    <cfif isdefined("this.basket_data.other_money_gross_total#i#") and len(evaluate("this.basket_data.other_money_gross_total#i#"))>#evaluate("this.basket_data.other_money_gross_total#i#")#<cfelse>0</cfif>,
                    <!--- <cfif isdefined('this.basket_data.cost_id#i#') and len(evaluate('this.basket_data.cost_id#i#'))>#evaluate('this.basket_data.cost_id#i#')#<cfelse>NULL</cfif>, --->
                    <cfif isdefined('this.basket_data.net_maliyet#i#') and len(evaluate('this.basket_data.net_maliyet#i#'))>#evaluate('this.basket_data.net_maliyet#i#')#<cfelse>0</cfif>,
                    <cfif isdefined('this.basket_data.marj#i#') and len(evaluate('this.basket_data.marj#i#'))>#evaluate('this.basket_data.marj#i#')#<cfelse>NULL</cfif>,
                    #listfirst(ship_id,';')#,
                    <cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session_base.period_id#</cfif>,
                    <cfif isdefined('this.basket_data.iskonto_tutar#i#') and len(evaluate('this.basket_data.iskonto_tutar#i#'))>#evaluate('this.basket_data.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.is_promotion#i#') and len(evaluate('this.basket_data.is_promotion#i#'))>#evaluate('this.basket_data.is_promotion#i#')#<cfelse>0</cfif>,
                    <cfif isdefined('this.basket_data.row_unique_relation_id#i#') and len(evaluate('this.basket_data.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.prom_relation_id#i#') and len(evaluate('this.basket_data.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.product_name_other#i#') and len(evaluate('this.basket_data.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.product_name_other#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.amount_other#i#') and len(evaluate('this.basket_data.amount_other#i#'))>#evaluate('this.basket_data.amount_other#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.unit_other#i#') and len(evaluate('this.basket_data.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit_other#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.ek_tutar#i#') and len(evaluate('this.basket_data.ek_tutar#i#'))>#evaluate('this.basket_data.ek_tutar#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.ek_tutar_total#i#') and len(evaluate('this.basket_data.ek_tutar_total#i#'))>#evaluate('this.basket_data.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.shelf_number#i#') and len(evaluate('this.basket_data.shelf_number#i#'))>#evaluate('this.basket_data.shelf_number#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.manufact_code#i#') and len(evaluate('this.basket_data.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.manufact_code#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.basket_extra_info#i#') and len(evaluate('this.basket_data.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.select_info_extra#i#') and len(evaluate('this.basket_data.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.detail_info_extra#i#') and len(evaluate('this.basket_data.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('this.basket_data.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.basket_employee_id#i#') and len(evaluate('this.basket_data.basket_employee_id#i#')) and isdefined('this.basket_data.basket_employee#i#') and len(evaluate('this.basket_data.basket_employee#i#'))>#evaluate('this.basket_data.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.otv_oran#i#') and len(evaluate('this.basket_data.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.otv_oran#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_otvtotal#i#') and len(evaluate('this.basket_data.row_otvtotal#i#'))>#evaluate('this.basket_data.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_promotion_id#i#') and len(evaluate('this.basket_data.row_promotion_id#i#'))>#evaluate('this.basket_data.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.promosyon_yuzde#i#') and len(evaluate('this.basket_data.promosyon_yuzde#i#'))>#evaluate('this.basket_data.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.prom_stock_id#i#') and len(evaluate('this.basket_data.prom_stock_id#i#'))>#evaluate('this.basket_data.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                    0,
                    <cfif isdefined('this.basket_data.price_cat#i#') and len(evaluate('this.basket_data.price_cat#i#'))>#evaluate('this.basket_data.price_cat#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_catalog_id#i#') and len(evaluate('this.basket_data.row_catalog_id#i#'))>#evaluate('this.basket_data.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                    0,
                    <cfif isdefined('this.basket_data.wrk_row_id#i#') and len(evaluate('this.basket_data.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.wrk_row_relation_id#i#') and len(evaluate('this.basket_data.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_width#i#') and len(evaluate('this.basket_data.row_width#i#'))>#evaluate('this.basket_data.row_width#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_depth#i#') and len(evaluate('this.basket_data.row_depth#i#'))>#evaluate('this.basket_data.row_depth#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_height#i#') and len(evaluate('this.basket_data.row_height#i#'))>#evaluate('this.basket_data.row_height#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('this.basket_data.row_project_id#i#') and len(evaluate('this.basket_data.row_project_id#i#')) and isdefined('this.basket_data.row_project_name#i#') and len(evaluate('this.basket_data.row_project_name#i#'))>#evaluate('this.basket_data.row_project_id#i#')#<cfelse>NULL</cfif>,
                    <cfif len(reasonCode) and reasonCode contains '*'>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
                    <cfelse>
                        NULL,
                        NULL
                    </cfif>
                    <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_center_id#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_item_id#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_activity_id#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('this.basket_data.row_acc_code#i#')#"></cfif>	
                    <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_subscription_id#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_assetp_id#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_rate#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_amount#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_currency#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_rate#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_amount#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_rate#i#')#"></cfif>
                    <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_amount#i#')#"></cfif>
                    )
            </cfquery>

            <cfset this.basket_data.karma_product_list = listappend( this.basket_data.karma_product_list,evaluate("this.basket_data.product_id#i#"))>

            <cfquery name="GET_MAX_INV_ROW" datasource="#this.basket_data.new_dsn2_group#">
                SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
            </cfquery>

            <cfif isdefined('this.basket_data.basket_employee_id#i#') and len(evaluate('this.basket_data.basket_employee_id#i#')) and isdefined('this.basket_data.basket_employee#i#') and len(evaluate('this.basket_data.basket_employee#i#'))>
                <cfset sales_emp_id = evaluate('this.basket_data.basket_employee_id#i#')>
            <cfelseif isDefined("this.basket_data.EMPO_ID") and len(this.basket_data.EMPO_ID)>
                <cfset sales_emp_id = this.basket_data.EMPO_ID>
            <cfelseif isdefined("session_base")>
                <cfset sales_emp_id = session_base.userid>
            <cfelse>
                <cfset sales_emp_id = 0>
            </cfif>

            <cfscript>
                if(isdefined("session_base") and this.basket_data.is_project_based_budget and session_base.our_company_info.project_followup eq 1)
                {
                    if(isdefined('this.basket_data.row_project_id#i#') and len(evaluate('this.basket_data.row_project_id#i#')) and isdefined('this.basket_data.row_project_name#i#') and len(evaluate('this.basket_data.row_project_name#i#')))
                        inv_project_id=evaluate('this.basket_data.row_project_id#i#'); 
                    else if(isdefined("this.basket_data.project_id") and len(this.basket_data.project_id) and len(this.basket_data.project_head))
                        inv_project_id=this.basket_data.project_id; 
                    else 
                        inv_project_id='';
                }
                else 
                    inv_project_id='';
            
                if(this.basket_data.is_budget)
                { //butce
                    if(isdefined('this.basket_data.branch_id') and len(this.basket_data.branch_id) )
                        budget_branch_id = this.basket_data.branch_id;
                    else if(isdefined("session_base"))
                        budget_branch_id = ListGetAt(session_base.user_location,2,"-");
                    else
                        budget_branch_id = '';
                    if (isdefined('this.basket_data.other_money_#i#'))
                        other_money=evaluate('this.basket_data.other_money_#i#');
                    else
                        other_money='';
                    if (isdefined('this.basket_data.other_money_value_#i#') and len(evaluate('this.basket_data.other_money_value_#i#')))
                        other_money_value=evaluate('this.basket_data.other_money_value_#i#');
                    else
                        other_money_value=0;

                    sql_unicode = application.functions.sql_unicode;
                    butceci = application.faFunctions.butceci;
                    butce=butceci(
                        action_id:MAX_ID.IDENTITYCOL,
                        muhasebe_db:this.basket_data.new_dsn2_group,
                        stock_id: evaluate("this.basket_data.stock_id#i#"),
                        product_id:evaluate("this.basket_data.product_id#i#"),
                        product_tax:evaluate("this.basket_data.tax#i#"),
                        product_otv: iif((isdefined("this.basket_data.otv_oran#i#") and len(evaluate('this.basket_data.otv_oran#i#'))),evaluate("this.basket_data.otv_oran#i#"),0),
                        tevkifat_rate: iif((isdefined("this.basket_data.row_tevkifat_rate#i#") and len(evaluate('this.basket_data.row_tevkifat_rate#i#'))),evaluate("this.basket_data.row_tevkifat_rate#i#"),0),
			            activity_type: iif((isdefined("this.basket_data.row_activity_id#i#") and len(evaluate('this.basket_data.row_activity_id#i#'))),evaluate("this.basket_data.row_activity_id#i#"),de('')),
			            expense_center_id: iif((isdefined("this.basket_data.row_exp_center_id#i#") and len(evaluate('this.basket_data.row_exp_center_id#i#'))),evaluate("this.basket_data.row_exp_center_id#i#"),0),
			            expense_item_id: iif((isdefined("this.basket_data.row_exp_item_id#i#") and len(evaluate('this.basket_data.row_exp_item_id#i#'))),evaluate("this.basket_data.row_exp_item_id#i#"),0),	
                        invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
                        paper_no:this.basket_data.INVOICE_NUMBER,
                        detail : '#this.basket_data.INVOICE_NUMBER# Nolu Fatura',
                        is_income_expense: 'true',
                        process_type:this.basket_data.invoice_cat,
                        process_cat:this.basket_data.PROCESS_CAT,
                        nettotal:evaluate("this.basket_data.row_nettotal#i#"),
                        other_money_value:other_money_value,
                        action_currency:other_money,
                        action_currency_2:session_base.money2,
                        expense_date:this.basket_data.INVOICE_DATE,
                        department_id:this.basket_data.department_id,
                        project_id:inv_project_id,
                        expense_member_id : sales_emp_id,
                        expense_member_type : 'employee',
                        branch_id : budget_branch_id,
                        discounttotal : DISCOUNT_AMOUNT,
                        currency_multiplier : this.basket_data.currency_multiplier
                        );
                    if(butce)   this.basket_data.dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
                }
            </cfscript>

        </cfloop>

        <!---
        <cfscript>
            //döngü dışına alındı her satırda is_cost update etmemesi için
            if(this.basket_data.dagilim) upd_invoice_cost = cfquery(datasource : "#new_dsn2_group#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#MAX_ID.IDENTITYCOL#");
        </cfscript>
        --->

        <cfif this.basket_data.dagilim>
            <cfquery name="upd_invoice_cost" datasource="#this.basket_data.new_dsn2_group#">
                UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#MAX_ID.IDENTITYCOL#
            </cfquery>
        </cfif>

        <!--- tevkifatlı fatura ise --->
        <cfif isdefined("this.basket_data.tevkifat_box") and isdefined("this.basket_data.tevkifat_oran") and len(this.basket_data.tevkifat_oran)>
            <cfloop from="1" to="#this.basket_data.basket_tax_count#" index="tax_i">
                <cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
                    INSERT INTO
                        INVOICE_TAXES
                        (
                        INVOICE_ID,
                        TAX,
                        TEVKIFAT_TUTAR,
                        BEYAN_TUTAR					
                        )
                    VALUES
                        (
                        #MAX_ID.IDENTITYCOL#,
                        #evaluate("this.basket_data.basket_tax_#tax_i#")#,
                        #evaluate("this.basket_data.tevkifat_tutar_#tax_i#")#,
                        #evaluate("this.basket_data.basket_tax_value_#tax_i#")*100#   
                        )
                </cfquery>
            </cfloop>
        </cfif>

    </cffunction>

    <cffunction name="cari_muhasebe">
        <cfscript>
            if( len(ListGetAt(session_base.user_location,2,"-")))
                to_branch_id = ListGetAt(session_base.user_location,2,"-");
            else
                to_branch_id = '';

            if (this.basket_data.is_cari eq 1)
            {
                carici = application.faFunctions.carici;
                carici(
                    action_id : this.basket_data.invoice_id,
                    action_table : 'INVOICE',
                    workcube_process_type : this.basket_data.invoice_cat,
                    account_card_type : 12,
                    islem_tarihi : this.basket_data.invoice_date,
                    islem_tutari : this.basket_data.basket_net_total,
                    islem_belge_no : this.basket_data.invoice_number,
                    to_cmp_id : this.basket_data.company_id,
                    to_consumer_id : this.basket_data.consumer_id,
                    to_branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
                    islem_detay : this.basket_data.DETAIL_,
                    action_detail : this.basket_data.NOTE,
                    other_money_value : this.basket_data.basket_net_total/this.basket_data.basket_rate2,
                    other_money : this.basket_data.basket_money,
                    due_date : this.basket_data.invoice_due_date,
                    action_currency : session_base.MONEY,
                    process_cat : this.basket_data.process_cat,
                    currency_multiplier : this.basket_data.currency_multiplier,
                    assetp_id : iif((isdefined("this.basket_data.asset_id") and len(this.basket_data.asset_id) and len(this.basket_data.asset_name)),'this.basket_data.asset_id',de('')),
                    rate2:this.basket_data.paper_currency_multiplier
                );
            }
            if(this.basket_data.is_account eq 1)  //fatura muhasebe
            {	
                if(isdefined("this.basket_data.project_id") and len(this.basket_data.project_id) and len(this.basket_data.project_head)) main_project_id = this.basket_data.project_id; else main_project_id = 0;

                this.basket_data.detail_1 = this.basket_data.comp_name & ' ' & this.basket_data.DETAIL_ & ' GİRİŞ İŞLEMİ';

                if(len(this.basket_data.company_id)) comp_name_ = this.basket_data.comp_name; else comp_name_ = "#this.basket_data.member_name# #this.basket_data.member_surname#";

                if(isDefined("this.basket_data.note") and Len(this.basket_data.note)) note_ = "- #note#"; else note_ = "";

                if(this.basket_data.is_account_group neq 1)
                    this.basket_data.genel_fis_satir_detay = "#this.basket_data.invoice_number#-#comp_name_# FATURA";
                else
                    this.basket_data.genel_fis_satir_detay = "#this.basket_data.invoice_number#-#comp_name_# FATURA#note_#";

                satir_detay_list = ArrayNew(2);
                str_borclu_hesaplar = '' ;
                str_borclu_tutarlar = '' ;
                str_dovizli_borclar = '' ;
                str_alacakli_hesaplar = '' ;
                str_alacakli_tutarlar = '' ;
                str_dovizli_alacaklar = '' ;
                str_other_currency_alacak = '';
                str_other_currency_borc = '';
                acc_project_list_alacak='';
                acc_project_list_borc='';
                str_alacak_miktar = ArrayNew(1);
                str_alacak_tutar = ArrayNew(1) ;
                product_account_code ='';	
                new_karma_prod_id_list_='';

                if(isdefined('this.basket_data.is_prod_cost_acc_action') and this.basket_data.is_prod_cost_acc_action eq 1 and this.basket_data.invoice_cat eq 52)
                {
                    str_karma_prods = "SELECT KARMA_PRODUCT_ID,KP.PRODUCT_ID,PRODUCT_AMOUNT,P.PRODUCT_NAME FROM #dsn1#.KARMA_PRODUCTS KP,#dsn3#.PRODUCT P WHERE P.PRODUCT_ID = KP.PRODUCT_ID AND P.IS_INVENTORY = 1 AND KP.KARMA_PRODUCT_ID IN (#this.basket_data.product_id_list#) ORDER BY KP.KARMA_PRODUCT_ID";

                    get_karma_prods_ = cfquery(datasource:"#dsn2#",sqlstring:str_karma_prods);
                    new_karma_prod_content_list_ = valuelist(get_karma_prods_.PRODUCT_ID);
                    new_karma_prod_id_list_ = valuelist(get_karma_prods_.KARMA_PRODUCT_ID);
                    check_prod_cost_list = this.basket_data.product_id_list;
                    if(len(new_karma_prod_content_list_))
                        check_prod_cost_list = listappend(check_prod_cost_list,new_karma_prod_content_list_);
                    
                    prod_cost_str = "SELECT PRODUCT_ID,(PURCHASE_NET+PURCHASE_EXTRA_COST) AS PRODUCT_COST_AMOUNT, PURCHASE_NET_MONEY,(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS PRODUCT_COST_SYSTEM_AMOUNT ,PURCHASE_NET_SYSTEM_MONEY ";
                    
                    prod_cost_str = prod_cost_str & " FROM #dsn3#.PRODUCT_COST WHERE PRODUCT_ID IN (#this.basket_data.karma_product_list#) AND START_DATE <= #this.basket_data.invoice_date# AND PRODUCT_COST_ID=";

                    prod_cost_str = prod_cost_str & " (SELECT TOP 1 PC.PRODUCT_COST_ID FROM #dsn3#.PRODUCT_COST PC WHERE PC.PRODUCT_ID =PRODUCT_COST.PRODUCT_ID AND START_DATE <= #this.basket_data.invoice_date# ORDER BY PRODUCT_ID,RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC)";
                    
                    prod_cost_str = prod_cost_str & " ORDER BY PRODUCT_ID,RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC";

                    get_prod_cost_amounts = cfquery(datasource:"#dsn2#",sqlstring:prod_cost_str);
                    
                    product_cost_list_new = listdeleteduplicates(listsort(valuelist(get_prod_cost_amounts.PRODUCT_ID),'numeric','asc'));

                }

                if((this.basket_data.basket_gross_total-(this.basket_data.basket_discount_total - this.basket_data.genel_indirim)) neq 0)
                    genel_indirim_yuzdesi = this.basket_data.genel_indirim / (this.basket_data.basket_gross_total - (this.basket_data.basket_discount_total - this.basket_data.genel_indirim));
                else
                    genel_indirim_yuzdesi = 0;

                if(this.basket_data.is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and len(this.basket_data.project_id) and len(this.basket_data.project_head))
                {
                    main_product_account_codes = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_DISCOUNT_PUR,ACCOUNT_CODE,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,SALE_PRODUCT_COST,ACCOUNT_DISCOUNT,ACCOUNT_YURTDISI,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_CODE_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE FROM #dsn3#.PROJECT_PERIOD WHERE PROJECT_ID = #this.basket_data.project_id# AND PERIOD_ID = #session_base.period_id# ");
                }

                for(i=1;i lte this.basket_data.rows_;i=i+1)
	            {
                    if(this.basket_data.is_dept_based_acc eq 1)
                    {
                        dept_id = this.basket_data.department_id;
                        loc_id = this.basket_data.location_id;
                    }
                    else
                    {
                        dept_id = 0;
                        loc_id = 0;
                    }

                    if(this.basket_data.is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and isdefined("this.basket_data.row_project_id#i#") and len(evaluate("this.basket_data.row_project_id#i#")) and len(evaluate("this.basket_data.row_project_name#i#")))
                    {
                        product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_DISCOUNT_PUR,ACCOUNT_CODE,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,SALE_PRODUCT_COST,ACCOUNT_DISCOUNT,ACCOUNT_YURTDISI,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_CODE_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE FROM #dsn3#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("row_project_id#i#")# AND PERIOD_ID = #session_base.period_id# ");
                    }
                    else if(this.basket_data.is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and len(this.basket_data.project_id) and len(this.basket_data.project_head))	// proje bazlı muhasebe islemi yapılacaksa
                    {
                        product_account_codes = main_product_account_codes;
                    }
                    else
                    {
                        product_account_codes = get_product_account(prod_id:evaluate("this.basket_data.product_id#i#"),period_id:session_base.period_id,product_account_db:dsn2,product_alias_db:dsn3,department_id:dept_id,location_id:loc_id);
                    }

                    urun_toplam_indirim = (evaluate("this.basket_data.row_total#i#") - evaluate("this.basket_data.row_nettotal#i#"));

                    if(this.basket_data.genel_indirim gt 0)
                        urun_toplam_indirim = urun_toplam_indirim + (evaluate("this.basket_data.row_nettotal#i#") * genel_indirim_yuzdesi);
                    if(this.basket_data.invoice_cat is '62')
                        product_account_code = product_account_codes.ACCOUNT_PUR_IADE ;
                    else // 52 veya 53 Toptan veya Perakende Satış Faturasi ise
                        product_account_code = product_account_codes.ACCOUNT_CODE ;
                    
                    str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_code,",");

                    if(this.basket_data.is_discount eq 1)//indirimler muhasebe fisinde gosterilmeyecekse satır toplamından dusurulur
                    {
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,(evaluate("this.basket_data.row_total#i#") - urun_toplam_indirim),",");
                        
                        if(genel_indirim_yuzdesi eq 0 and isdefined("this.basket_data.other_money_value_#i#") and len(evaluate("this.basket_data.other_money_value_#i#")) )
                        {
                            str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,evaluate("this.basket_data.other_money_value_#i#"),",");
                            str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("this.basket_data.other_money_#i#"),",");
                        }
                        else
                        {
                            str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,((evaluate("this.basket_data.row_total#i#") - urun_toplam_indirim) * this.basket_data.basket_rate1 / this.basket_data.basket_rate2),",");

                            str_other_currency_alacak = ListAppend(str_other_currency_alacak, this.basket_data.basket_money,",");
                        }
                    }
                    else
                    {
                        str_alacakli_tutarlar = ListAppend( str_alacakli_tutarlar, evaluate("this.basket_data.row_total#i#"),",");
                        
                        if(urun_toplam_indirim eq 0 and isdefined("this.basket_data.other_money_value_#i#") and len(evaluate("this.basket_data.other_money_value_#i#")) )
                        {
                            str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, evaluate("this.basket_data.other_money_value_#i#"),",");
                            str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("this.basket_data.other_money_#i#"),",");
                        }
                        else
                        {
                            str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (evaluate("this.basket_data.row_total#i#") * this.basket_data.basket_rate1 / this.basket_data.basket_rate2),",");
                            str_other_currency_alacak = ListAppend( str_other_currency_alacak, this.basket_data.basket_money,",");
                        }
                    }

                    str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.amount#i#")#';

                    str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.price#i#")#';

                    if(this.basket_data.is_account_group neq 1)
                        satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("this.basket_data.product_name#i#")#';
                    else
			            satir_detay_list[2][listlen(str_alacakli_tutarlar)] = this.basket_data.genel_fis_satir_detay;

                    if(isdefined("this.basket_data.row_project_id#i#") and len(evaluate("this.basket_data.row_project_id#i#")) and len(evaluate("this.basket_data.row_project_name#i#")))
                        acc_project_list_alacak = ListAppend(acc_project_list_alacak, evaluate("this.basket_data.row_project_id#i#"),",");
                    else
                        acc_project_list_alacak = ListAppend(acc_project_list_alacak, main_project_id,",");

                    if (this.basket_data.is_discount neq 1)
                    {
                        if(urun_toplam_indirim gt 0)
                        { //urune ait satis indirim hesabina
                            if(len(product_account_codes.ACCOUNT_DISCOUNT))
                                str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_DISCOUNT,",");
                            else
                                str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, query_GET_NO_.A_DISC,",");					
                            str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, urun_toplam_indirim, ",");
                            str_dovizli_borclar = ListAppend(str_dovizli_borclar, urun_toplam_indirim, ",");
                            str_other_currency_borc = ListAppend(str_other_currency_borc, session_base.money,",");
                            satir_detay_list[1][listlen(str_borclu_tutarlar)] = this.basket_data.genel_fis_satir_detay;
                            
                            if(isdefined("this.basket_data.row_project_id#i#") and len(evaluate("this.basket_data.row_project_id#i#")) and len(evaluate("this.basket_data.row_project_name#i#")))
                                acc_project_list_borc = ListAppend(acc_project_list_borc, evaluate("this.basket_data.row_project_id#i#"),",");
                            else
                                acc_project_list_borc = ListAppend(acc_project_list_borc, main_project_id, ",");
                        }
                    }

                    if(isdefined('this.basket_data.is_prod_cost_acc_action') and this.basket_data.is_prod_cost_acc_action eq 1 and this.basket_data.invoice_cat eq 52)
                    {
                        temp_row_amount=0;
                        if(len(new_karma_prod_id_list_) and listfind(new_karma_prod_id_list_,evaluate("this.basket_data.product_id#i#")) neq 0) //satırdaki karma koli urunse, set icerigindeki urunlerin maliyet toplamı karmakoli urune yansıtılacak
                        {
                            row_prod_id = evaluate("this.basket_data.product_id#i#");
                            'temp_row_amount_#row_prod_id#' = 0;
                            for(kp=1;kp lte get_karma_prods_.recordcount;kp=kp+1)
                            {
                                if(row_prod_id eq get_karma_prods_.KARMA_PRODUCT_ID[kp])
                                {
                                    if(listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp]))
                                    {
                                        temp_karma_prod_amount=get_karma_prods_.PRODUCT_AMOUNT[kp];
                                        'temp_row_amount_#row_prod_id#' = evaluate('temp_row_amount_#row_prod_id#') + wrk_round(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp])] * get_karma_prods_.PRODUCT_AMOUNT[kp]);
                                    }
                                }
                            }
                            temp_row_amount = evaluate('temp_row_amount_#row_prod_id#') * evaluate("this.basket_data.amount#i#");
                            temp_row_other_amount = wrk_round(temp_row_amount * (this.basket_data.basket_rate1 / this.basket_data.basket_rate2));
                            temp_row_other_currency = this.basket_data.basket_money;
                        }
                        else if(listfind(product_cost_list_new,evaluate("this.basket_data.product_id#i#")))
                        {
                            temp_row_amount = (get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new, evaluate("this.basket_data.product_id#i#"))] * evaluate("this.basket_data.amount#i#"));
                            temp_row_other_amount = (get_prod_cost_amounts.PRODUCT_COST_AMOUNT[listfind(product_cost_list_new, evaluate("this.basket_data.product_id#i#"))] * evaluate("this.basket_data.amount#i#"));
                            temp_row_other_currency = get_prod_cost_amounts.PURCHASE_NET_MONEY[listfind(product_cost_list_new, evaluate("this.basket_data.product_id#i#"))];
                        }

                        if(temp_row_amount neq 0)
                        {
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");  //alıs hesabı alacaklı
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, temp_row_amount, ",");
                            str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, temp_row_other_amount, ",");
                            str_other_currency_alacak = ListAppend(str_other_currency_alacak, temp_row_other_currency, ",");
                            str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.amount#i#")#';
                            str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.price#i#")#'; 

                            if(this.basket_data.is_account_group neq 1)
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.product_name#i#")#';
                            else
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)] = this.basket_data.genel_fis_satir_detay;
                        
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SALE_PRODUCT_COST, ",");  //satılan malın maliyeti hesabı borclu
                            str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, temp_row_amount, ",");
                            str_dovizli_borclar = ListAppend(str_dovizli_borclar, temp_row_other_amount, ",");
                            str_other_currency_borc = ListAppend(str_other_currency_borc, temp_row_other_currency, ",");

                            if(this.basket_data.is_account_group neq 1)
                                satir_detay_list[1][listlen(str_borclu_tutarlar)] = '#evaluate("this.basket_data.product_name#i#")#';
                            else
                                satir_detay_list[1][listlen(str_borclu_tutarlar)] = this.basket_data.genel_fis_satir_detay;

                            if(isdefined("this.basket_data.row_project_id#i#") and len(evaluate("this.basket_data.row_project_id#i#")) and len(evaluate("this.basket_data.row_project_name#i#")))
                            {
                                acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("this.basket_data.row_project_id#i#"),",");
                                acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("this.basket_data.row_project_id#i#"),",");
                            }
                            else
                            {
                                acc_project_list_borc = ListAppend(acc_project_list_borc, main_project_id,",");
                                acc_project_list_alacak = ListAppend(acc_project_list_alacak, main_project_id,",");
                            }
                        }


                    }

                    // kdv bloğu
                    if(evaluate("this.basket_data.row_taxtotal#i#") gt 0)
                    {
                        temp_tax_tutar = evaluate("this.basket_data.row_taxtotal#i#");
                        if( isdefined("this.basket_data.tevkifat_box") and isdefined('this.basket_data.tevkifat_oran') and len(this.basket_data.tevkifat_oran))
                        { /*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
                            tevkifat_acc_codes = cfquery(datasource:"#dsn2#", sqlstring:"SELECT 
                                                        ST_ROW.TEVKIFAT_BEYAN_CODE,ST_ROW.TAX
                                                    FROM 
                                                        #dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
                                                    WHERE
                                                        S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
                                                        AND S_TEV.TEVKIFAT_ID = #this.basket_data.tevkifat_id#
                                                        AND ST_ROW.TAX = #evaluate("this.basket_data.tax#i#")#
                                                    ORDER BY ST_ROW.TAX");
                            temp_tax_tutar = wrk_round((temp_tax_tutar * this.basket_data.tevkifat_oran), this.basket_data.basket_price_round_number);
                        }
                        get_tax_row = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("this.basket_data.tax#i#")#");

                        if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
                            temp_tax_tutar =  wrk_round((temp_tax_tutar - (temp_tax_tutar * genel_indirim_yuzdesi)), this.basket_data.basket_price_round_number);

                        if( isdefined("this.basket_data.tevkifat_box") and isdefined('this.basket_data.tevkifat_oran') and len(this.basket_data.tevkifat_oran))
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, tevkifat_acc_codes.tevkifat_beyan_code, ",");
                        else
                        {
                            if(this.basket_data.invoice_cat eq 62) //iade faturası
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.purchase_code_iade, ",");
                            else if(this.basket_data.invoice_cat eq 58) //verilen fiyat farkı
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.sale_price_diff_code, ",");
                            else
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.sale_code, ",");
                        }

                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, temp_tax_tutar, ",");
                        str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (temp_tax_tutar * (this.basket_data.basket_rate1 / this.basket_data.basket_rate2)), ",");
                        str_other_currency_alacak = ListAppend(str_other_currency_alacak, this.basket_data.basket_money, ",");

                        if(isdefined("this.basket_data.row_project_id#i#") and len(evaluate("this.basket_data.row_project_id#i#")) and len(evaluate("this.basket_data.row_project_name#i#")))
                            acc_project_list_alacak = ListAppend(acc_project_list_alacak, evaluate("this.basket_data.row_project_id#i#"),",");
                        else
                            acc_project_list_alacak = ListAppend(acc_project_list_alacak, main_project_id, ",");

                        str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.price#i#")#'; 
                        str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("this.basket_data.amount#i#")#';

                        if(this.basket_data.is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
                            satir_detay_list[2][listlen(str_alacakli_tutarlar)] = '#comp_name_# - #evaluate("this.basket_data.product_name#i#")#';
                        else
                            satir_detay_list[2][listlen(str_alacakli_tutarlar)] = this.basket_data.genel_fis_satir_detay;

                        
                    }

                }

                str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, this.basket_data.ACC, ",");
                str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, this.basket_data.basket_net_total, ",");
                str_dovizli_borclar = ListAppend(str_dovizli_borclar, (this.basket_data.basket_net_total * this.basket_data.basket_rate1 / this.basket_data.basket_rate2), ",");
                str_other_currency_borc = ListAppend(str_other_currency_borc, this.basket_data.basket_money, ",");
                satir_detay_list[1][listlen(str_borclu_tutarlar)] = this.basket_data.genel_fis_satir_detay;
                
                if(isdefined("this.basket_data.project_id") and len(this.basket_data.project_id) and len(this.basket_data.project_head))
                    acc_project_list_borc = ListAppend(acc_project_list_borc, this.basket_data.project_id, ",");
                else
                    acc_project_list_borc = ListAppend(acc_project_list_borc, 0, ",");
                
                //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                str_fark_gelir = query_GET_NO_.FARK_GELIR;
                str_fark_gider = query_GET_NO_.FARK_GIDER;
                str_max_round = 0.5;
                str_round_detail = this.basket_data.genel_fis_satir_detay;

                muhasebeci = application.faFunctions.muhasebeci;
                muhasebeci(
                    wrk_id='#this.basket_data.wrk_id#',
                    action_id : this.basket_data.invoice_id,
                    workcube_process_type : this.basket_data.INVOICE_CAT,
                    workcube_process_cat: this.basket_data.process_cat,
                    account_card_type : 13,
                    company_id : this.basket_data.company_id,
                    consumer_id : this.basket_data.consumer_id,
                    islem_tarihi : this.basket_data.invoice_date,
                    borc_hesaplar : str_borclu_hesaplar,
                    borc_tutarlar : str_borclu_tutarlar,
                    other_amount_borc : str_dovizli_borclar,
                    other_currency_borc : str_other_currency_borc,
                    alacak_hesaplar : str_alacakli_hesaplar,
                    alacak_tutarlar : str_alacakli_tutarlar,
                    other_amount_alacak : str_dovizli_alacaklar,
                    other_currency_alacak :str_other_currency_alacak,
                    alacak_miktarlar : str_alacak_miktar,
                    alacak_birim_tutar : str_alacak_tutar,
                    to_branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
                    fis_detay : "#this.basket_data.DETAIL_1#",
                    fis_satir_detay : satir_detay_list,
                    belge_no : this.basket_data.invoice_number,
                    is_account_group : this.basket_data.is_account_group,
                    dept_round_account :str_fark_gider,
                    claim_round_account : str_fark_gelir,
                    max_round_amount :str_max_round,
                    round_row_detail:str_round_detail,
                    currency_multiplier : this.basket_data.currency_multiplier,
                    acc_project_id : main_project_id,
                    acc_project_list_alacak : acc_project_list_alacak,
                    acc_project_list_borc : acc_project_list_borc
                );
            }
        </cfscript>

        <cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
            UPDATE INVOICE SET IS_PROCESSED = #this.basket_data.is_account# WHERE INVOICE_ID = #this.basket_data.invoice_id#
        </cfquery>
        
    </cffunction>

    <cffunction name="kasa_muhasebe">
        <cfif isDefined("this.basket_data.cash") and (this.basket_data.cash)>
            <cfloop from="1" to="#this.basket_data.kur_say#" index="k">
                <cfif isdefined("this.basket_data.kasa#k#") and isdefined("this.basket_data.cash_amount#k#") and (evaluate('this.basket_data.cash_amount#k#') gt 0)>
                    <cfset 'this.basket_data.cash_amount#k#' = filternum(evaluate('this.basket_data.cash_amount#k#'))>
                    <cfquery name="query_get_cash_code" datasource="#dsn2#">
                        SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID = #evaluate("this.basket_data.kasa#k#")#
                    </cfquery>
                    <cfif len(query_get_cash_code.BRANCH_ID)> <!--- carici ve muhasebecide kullanılıyor --->
                        <cfset cash_branch_id = query_get_cash_code.BRANCH_ID>
                    <cfelse>
                        <cfset cash_branch_id = ''>
                    </cfif>
                    <cfquery name="query_ADD_ALISF_KAPA" datasource="#dsn2#">
                        INSERT INTO CASH_ACTIONS
                            (
                            CASH_ACTION_TO_CASH_ID,
                            ACTION_TYPE,
                            ACTION_TYPE_ID,
                            BILL_ID,
                        <cfif isDefined("this.basket_data.company_id") and len(this.basket_data.company_id)>
                            CASH_ACTION_FROM_COMPANY_ID,
                        <cfelse>
                            CASH_ACTION_FROM_CONSUMER_ID,
                        </cfif>
                            CASH_ACTION_VALUE,
                            CASH_ACTION_CURRENCY_ID,				
                            ACTION_DATE,
                            ACTION_DETAIL,
                            IS_PROCESSED,
                            PAPER_NO,
                            IS_ACCOUNT,
                            IS_ACCOUNT_TYPE,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE,
                            PROCESS_CAT,
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID
                            <cfif len(session_base.money2)>
                                ,ACTION_VALUE_2
                                ,ACTION_CURRENCY_ID_2
                            </cfif>
                            )
                        VALUES
                            (
                            #evaluate("this.basket_data.kasa#k#")#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
                            35,
                            #this.basket_data.invoice_id#,
                        <cfif isDefined("this.basket_data.company_id") and len(this.basket_data.company_id)>
                            #this.basket_data.company_id#,
                        <cfelse>
                            #this.basket_data.consumer_id#,
                        </cfif>
                            #evaluate('this.basket_data.cash_amount#k#')#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.currency_type#k#')#">,
                            #this.basket_data.invoice_date#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
                        <cfif this.basket_data.is_account>1<cfelse>0</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.INVOICE_NUMBER#">,
                            <cfif this.basket_data.is_account eq 1>
                                1,
                                11,
                            <cfelse>
                                0,
                                11,
                            </cfif>
                            #session_base.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#,
                            0,
                            #evaluate('this.basket_data.system_cash_amount#k#')#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#">
                            <cfif len(session_base.money2)>
                                ,#wrk_round(evaluate('this.basket_data.system_cash_amount#k#')/this.basket_data.currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money2#">
                            </cfif>
                            )
                    </cfquery>
                    <cfquery name="GET_ACT_ID" datasource="#dsn2#">
                        SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
                    </cfquery>
                    <cfset act_id=get_act_id.ACT_ID>
                    <cfquery name="query_UPD_INVOICE_CASH" datasource="#dsn2#">
                        INSERT INTO INVOICE_CASH_POS
                            (
                            INVOICE_ID,
                            CASH_ID,
                            KASA_ID
                            )
                        VALUES
                            (
                            #this.basket_data.invoice_id#,
                            #ACT_ID#,
                            #evaluate("this.basket_data.kasa#k#")#
                            )
                    </cfquery>
                    <cfscript>
                        if(this.basket_data.is_cari eq 1)
                        {
                            carici = application.faFunctions.carici;
                            carici(
                                action_id : ACT_ID,
                                action_table : 'CASH_ACTIONS',
                                workcube_process_type : 35,
                                account_card_type : 13,
                                islem_tarihi : this.basket_data.invoice_date,
                                islem_tutari : evaluate("this.basket_data.system_cash_amount#k#"),
                                islem_belge_no : this.basket_data.INVOICE_NUMBER,
                                from_cmp_id : this.basket_data.company_id,
                                from_consumer_id : this.basket_data.consumer_id,
                                islem_detay : 'SATIŞ FATURASI KAPAMA İŞLEMİ',
                                action_detail : this.basket_data.note,
                                other_money_value : evaluate("this.basket_data.cash_amount#k#"),
                                other_money : evaluate("this.basket_data.currency_type#k#"),
                                action_currency : session_base.MONEY,
                                to_cash_id : evaluate("this.basket_data.kasa#k#"),
                                to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
                                process_cat : 0,
                                currency_multiplier : this.basket_data.currency_multiplier
                                );
                        }
                        if(this.basket_data.is_account eq 1)
                        {
                            DETAIL_2 = this.basket_data.DETAIL_ & " KAPAMA ISLEMI";
                            muhasebeci_ifrs = application.faFunctions.muhasebeci_ifrs;
                            muhasebeci = application.faFunctions.muhasebeci;
                            muhasebeci(
                                wrk_id='#this.basket_data.wrk_id#',
                                action_id : ACT_ID,
                                workcube_process_type : 35,
                                account_card_type : 11, 
                                company_id : this.basket_data.company_id,
                                consumer_id : this.basket_data.consumer_id,
                                islem_tarihi : this.basket_data.invoice_date,
                                borc_hesaplar : query_get_cash_code.CASH_ACC_CODE,
                                borc_tutarlar : wrk_round(evaluate("this.basket_data.system_cash_amount#k#")),
                                other_amount_borc : evaluate("this.basket_data.cash_amount#k#"),
                                other_currency_borc : evaluate("this.basket_data.currency_type#k#"),
                                alacak_hesaplar : this.basket_data.ACC,
                                alacak_tutarlar : wrk_round(evaluate("this.basket_data.system_cash_amount#k#")),
                                other_amount_alacak : evaluate("this.basket_data.cash_amount#k#"),
                                other_currency_alacak : evaluate("this.basket_data.currency_type#k#"),
                                to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
                                fis_detay : '#DETAIL_2#',
                                fis_satir_detay : 'Satış Fatura Kapama',
                                belge_no : this.basket_data.invoice_number,
                                is_account_group : this.basket_data.is_account_group,
                                currency_multiplier : this.basket_data.currency_multiplier 
                                );
                        }
                    </cfscript>	
                </cfif>
            </cfloop>
            <cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
                UPDATE INVOICE SET IS_ACCOUNTED = #this.basket_data.is_account# WHERE INVOICE_ID = #this.basket_data.invoice_id#
            </cfquery>
        <cfelse>
            <cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
                UPDATE INVOICE SET IS_ACCOUNTED=0 WHERE INVOICE_ID = #this.basket_data.invoice_id#
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction name="pos_islem">
        
        <cfif isdefined("this.basket_data.is_pos") and len(this.basket_data.is_pos)>
            <cfloop from="1" to="5" index="pos_sira">
                <cfif isdefined("this.basket_data.pos_amount_#pos_sira#") and filterNum(evaluate('this.basket_data.pos_amount_#pos_sira#')) gt 0 >
                    <cfscript>
                        action_to_account_id_first = listfirst(evaluate('this.basket_data.POS#pos_sira#'),';');
                        account_currency_id = listgetat(evaluate('this.basket_data.POS#pos_sira#'),2,';');
                        payment_type_id = listgetat(evaluate('this.basket_data.POS#pos_sira#'),3,';');
                        temp_pos_tutar = evaluate('this.basket_data.pos_amount_#pos_sira#');
                        to_branch_id = ListGetAt(session_base.user_location,2,"-");
                    </cfscript>
                    <cfquery name="query_GET_CREDIT_PAYMENT" datasource="#dsn2#">
                        SELECT 
                            PAYMENT_TYPE_ID, 
                            NUMBER_OF_INSTALMENT, 
                            P_TO_INSTALMENT_ACCOUNT,
                            ACCOUNT_CODE,
                            SERVICE_RATE,
                            IS_PESIN
                        FROM 
                            #dsn3_alias#.CREDITCARD_PAYMENT_TYPE 
                        WHERE 
                            PAYMENT_TYPE_ID = #payment_type_id#
                    </cfquery>
                    <cfif query_GET_CREDIT_PAYMENT.recordcount and len(query_GET_CREDIT_PAYMENT.p_to_instalment_account)>
                        <cfset due_value_date = date_add("d",query_GET_CREDIT_PAYMENT.p_to_instalment_account, this.basket_data.invoice_date)>
                    <cfelse>
                        <cfset due_value_date = this.basket_data.action_date>
                    </cfif>
                    <cfif len(query_GET_CREDIT_PAYMENT.SERVICE_RATE) and query_GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
                        <!--- ödeme yöntemindeki seçilen hizmet komisyon çarpanına göre komisyon oranı hesaplanır --->
                        <cfset commission_multiplier_amount = wrk_round(temp_pos_tutar * query_GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
                    <cfelse>
                        <cfset commission_multiplier_amount = 0>
                    </cfif>
                    <cfset credit_currency_multiplier = ''>
                    <cfif isDefined('this.basket_data.kur_say') and len(this.basket_data.kur_say)>
                        <cfloop from="1" to="#this.basket_data.kur_say#" index="mon">
                            <cfif evaluate("this.basket_data.hidden_rd_money_#mon#") is this.basket_data.basket_money>
                                <cfset credit_currency_multiplier = evaluate('this.basket_data.txt_rate2_#mon#/this.basket_data.txt_rate1_#mon#')>
                            </cfif>
                            <cfif evaluate("this.basket_data.hidden_rd_money_#mon#") is account_currency_id>
                                <cfset credit_currency_multiplier2 = evaluate('this.basket_data.txt_rate2_#mon#/this.basket_data.txt_rate1_#mon#')>
                            </cfif>
                        </cfloop>
                    </cfif>
                    <cfquery name="query_ADD_CREDIT_PAYMENT" datasource="#dsn2#" result="MAX_ID">
                        INSERT
                        INTO
                            #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
                            (
                                PROCESS_CAT,
                                ACTION_TYPE_ID,
                                WRK_ID,
                                PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
                                NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
                                ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
                                ACTION_CURRENCY_ID,<!--- hesap para birimi --->
                                ACTION_FROM_COMPANY_ID,
                                PARTNER_ID,
                                CONSUMER_ID,
                                STORE_REPORT_DATE,<!--- işlem tarihi --->
                                SALES_CREDIT,<!--- işlem tutarı --->
                                COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
                                ACTION_TYPE,
                                OTHER_CASH_ACT_VALUE,
                                OTHER_MONEY,
                                IS_ACCOUNT,
                                IS_ACCOUNT_TYPE,
                                ACTION_PERIOD_ID,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP,
                                TO_BRANCH_ID
                            )
                            VALUES
                            (
                                #this.basket_data.PROCESS_CAT#,
                                #this.basket_data.INVOICE_CAT#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.wrk_id#">,
                                #payment_type_id#,
                                <cfif len(query_get_credit_payment.number_of_instalment)>#query_get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
                                #action_to_account_id_first#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_currency_id#">,
                                <cfif isdefined("this.basket_data.company_id") and len(this.basket_data.company_id)>#this.basket_data.company_id#,<cfelse>NULL,</cfif>
                                <cfif isdefined("this.basket_data.partner_id") and len(this.basket_data.partner_id)>#this.basket_data.partner_id#,<cfelse>NULL,</cfif>
                                <cfif isdefined("this.basket_data.consumer_id") and len(this.basket_data.consumer_id)>#this.basket_data.consumer_id#,<cfelse>NULL,</cfif>
                                #this.basket_data.invoice_date#,
                                #evaluate('this.basket_data.pos_amount_#pos_sira#')#,
                                #commission_multiplier_amount#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT (Per)">,
                                #wrk_round(evaluate('this.basket_data.pos_amount_#pos_sira#')*credit_currency_multiplier2 /  credit_currency_multiplier)#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.basket_money#">,
                                <cfif this.basket_data.is_account eq 1>1,13,<cfelse>0,13,</cfif>
                                #session_base.period_id#,
                                #session_base.userid#,
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                #ListGetAt(session_base.user_location,2,"-")#						
                            )
                    </cfquery>
                    <cfloop from="1" to="#this.basket_data.kur_say#" index="j">
                        <cfquery name="query_ADD_CREDIT_MONEY" datasource="#dsn2#">
                            INSERT INTO
                                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY
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
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.hidden_rd_money_#j#')#">,
                                    #evaluate("this.basket_data.txt_rate2_#j#")#,
                                    #evaluate("this.basket_data.txt_rate1_#j#")#,
                                    <cfif evaluate("this.basket_data.hidden_rd_money_#j#") is account_currency_id>1<cfelse>0</cfif>
                                )
                        </cfquery>
                    </cfloop>
                    <cfquery name="query_GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
                        SELECT 
                            SALES_CREDIT,
                            COMMISSION_AMOUNT,
                            PAYMENT_TYPE_ID,
                            STORE_REPORT_DATE,
                            CREDITCARD_PAYMENT_ID
                        FROM 
                            #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
                        WHERE 
                            CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
                    </cfquery>

                    <!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
		            <cfset bank_action_date = date_add("d", query_GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,query_GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>
                    <cfif (query_GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(query_GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (query_GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)>
                        <cfset satir_sayisi = 1>
                        <cfset operation_type = 'Peşin Giriş'>
                        <cfset tutar = query_GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
                        <cfif (query_GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
                            <cfset komsiyon_tutar = query_GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
                        <cfelse>
                            <cfset komsiyon_tutar = 0>
                        </cfif>
                    <cfelse>
                        <cfset satir_sayisi = query_GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
                        <cfset tutar = (query_GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/query_GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
                        <cfif (query_GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
                            <cfset komsiyon_tutar = (query_GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/query_GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
                        <cfelse>
                            <cfset komsiyon_tutar = 0>
                        </cfif>
                    </cfif>
                    <cfloop from="1" to="#satir_sayisi#" index="i">
                        <cfquery name="query_ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn2#">
                            INSERT
                            INTO
                                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
                                (
                                    STORE_REPORT_DATE,<!--- tahsilat işlem tarihi --->
                                    BANK_ACTION_DATE,<!--- hesaba geçiş tarihi --->
                                    CREDITCARD_PAYMENT_ID,<!--- tahsilat id si --->
                                    PAYMENT_TYPE_ID,<!--- ödeme yöntemi id si --->
                                    OPERATION_NAME,
                                    AMOUNT,<!--- işlem tutarı --->
                                    COMMISSION_AMOUNT<!--- komsiyon tutarı --->
                                )
                            VALUES
                                (
                                    #CreateODBCDateTime(query_GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)#,
                                    #bank_action_date#,
                                    #query_GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
                                    #query_GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
                                    <cfif isDefined("operation_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#operation_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#i#. Taksit"></cfif>,
                                    #tutar#,
                                    #komsiyon_tutar#
                                )
                        </cfquery>
                        <cfset bank_action_date = date_add("m",1,bank_action_date)>
                    </cfloop>
                    <cfquery name="query_ADD_INVOICE_CASH_POS" datasource="#dsn2#">
                        INSERT INTO INVOICE_CASH_POS
                            (
                                INVOICE_ID,
                                POS_ID,<!--- artık pos_id degilde,ödeme yöntemi id tutulcak --->
                                POS_ACTION_ID,
                                POS_PERIOD_ID
                            )
                        VALUES
                            (
                                #this.basket_data.invoice_id#,
                                #payment_type_id#,
                                #MAX_ID.IDENTITYCOL#,
                                #session_base.period_id#
                            )
                    </cfquery>
                    <cfscript>
                        if(this.basket_data.is_cari eq 1)
                        {
                            carici = application.faFunctions.carici
                            if(account_currency_id is session_base.money)
                            {
                                carici
                                (
                                    action_id : MAX_ID.IDENTITYCOL,
                                    action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                                    workcube_process_type : 241,		
                                    process_cat : this.basket_data.process_cat,	
                                    islem_tarihi : this.basket_data.invoice_date,
                                    due_date : due_value_date,
                                    islem_belge_no : this.basket_data.INVOICE_NUMBER,
                                    to_account_id : action_to_account_id_first,
                                    islem_tutari : temp_pos_tutar,
                                    other_money_value : wrk_round(evaluate('this.basket_data.pos_amount_#pos_sira#')/credit_currency_multiplier),
                                    other_money : this.basket_data.basket_money,
                                    action_currency : session_base.money,									
                                    islem_detay : 'KREDİ KARTI TAHSİLAT (Per)',
                                    action_detail : this.basket_data.note,
                                    account_card_type : 13,
                                    from_cmp_id : this.basket_data.company_id,
                                    from_consumer_id : this.basket_data.consumer_id,
                                    currency_multiplier : this.basket_data.currency_multiplier,
                                    to_branch_id : to_branch_id,
                                    rate2:this.basket_data.paper_currency_multiplier
                                );
                            }
                            else
                            {
                                carici
                                (
                                    action_id : MAX_ID.IDENTITYCOL,
                                    action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                                    workcube_process_type : 241,		
                                    process_cat : this.basket_data.process_cat,	
                                    islem_tarihi : this.basket_data.invoice_date,
                                    due_date : due_value_date,
                                    islem_belge_no : this.basket_data.INVOICE_NUMBER,
                                    to_account_id : action_to_account_id_first,
                                    islem_tutari :  wrk_round(evaluate('this.basket_data.pos_amount_#pos_sira#')*credit_currency_multiplier),
                                    other_money : account_currency_id,
                                    other_money_value:  evaluate('this.basket_data.pos_amount_#pos_sira#'),
                                    action_currency : session_base.money ,									
                                    islem_detay : 'KREDİ KARTI TAHSİLAT (Per)',
                                    action_detail : this.basket_data.note,
                                    account_card_type : 13,
                                    from_cmp_id : this.basket_data.company_id,
                                    from_consumer_id : this.basket_data.consumer_id,
                                    currency_multiplier : this.basket_data.currency_multiplier,
                                    to_branch_id : to_branch_id
                                );
                            }
                        }
                        if (this.basket_data.is_account eq 1)
                        {
                            muhasebeci = application.faFunctions.muhasebeci;
                            if(account_currency_id is session_base.money)
                            {
                
                                muhasebeci (
                                    action_id: MAX_ID.IDENTITYCOL,
                                    workcube_process_type: 241,
                                    account_card_type: 13,
                                    company_id : this.basket_data.company_id,
                                    consumer_id : this.basket_data.consumer_id,
                                    islem_tarihi: this.basket_data.invoice_date,
                                    fis_satir_detay: 'KREDİ KARTI TAHSİLAT (Per)',
                                    borc_hesaplar: query_GET_CREDIT_PAYMENT.account_code,
                                    borc_tutarlar: temp_pos_tutar,
                                    other_amount_borc : temp_pos_tutar,
                                    other_currency_borc : account_currency_id,
                                    alacak_hesaplar: this.basket_data.ACC,
                                    alacak_tutarlar: temp_pos_tutar,
                                    other_amount_alacak : temp_pos_tutar,
                                    other_currency_alacak : account_currency_id,
                                    belge_no : this.basket_data.invoice_number,
                                    fis_detay: 'KREDİ KARTI TAHSİLAT (Per)',
                                    currency_multiplier : this.basket_data.currency_multiplier,
                                    to_branch_id : to_branch_id
                                    );		
                            }
                            else
                            {
                                muhasebeci (
                                    action_id: MAX_ID.IDENTITYCOL,
                                    workcube_process_type: 241,
                                    account_card_type: 13,
                                    company_id : this.basket_data.company_id,
                                    consumer_id : this.basket_data.consumer_id,
                                    islem_tarihi: this.basket_data.invoice_date,
                                    fis_satir_detay: 'KREDİ KARTI TAHSİLAT (Per)',
                                    borc_hesaplar: query_GET_CREDIT_PAYMENT.account_code,
                                    borc_tutarlar: evaluate("this.basket_data.system_pos_amount_#pos_sira#"),
                                    other_amount_borc : temp_pos_tutar,
                                    other_currency_borc : account_currency_id,
                                    alacak_hesaplar: this.basket_data.ACC,
                                    alacak_tutarlar: evaluate("this.basket_data.system_pos_amount_#pos_sira#"),
                                    other_amount_alacak : temp_pos_tutar,
                                    other_currency_alacak : account_currency_id,
                                    belge_no : this.basket_data.invoice_number,
                                    fis_detay: 'KREDİ KARTI TAHSİLAT (Per)',
                                    currency_multiplier : this.basket_data.currency_multiplier,
                                    to_branch_id : to_branch_id
                                    );		
                            }
                        }
                    </cfscript>
                </cfif>
            </cfloop>
        </cfif>
    </cffunction>

    <cffunction name="stok_islem">
        <cfif this.basket_data.invoice_cat eq 52>
            <cfscript>
                get_ship_process = createObject("component", "V16.invoice.cfc.get_ship_process_cat");
                get_ship_process.dsn2 = dsn2;
                get_ship_process.dsn3_alias = dsn3_alias;
            </cfscript>
            <cfset int_ship_process_type = 70>
            <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat: this.basket_data.process_cat)>
            <cfif (not this.basket_data.included_irs) and (this.basket_data.inventory_product_exists eq 1)>
                <!--- karma koli icin eklendi --->
                <cfif isdefined("this.basket_data.karma_product_list") and len(this.basket_data.karma_product_list)>
                    <cfquery name="query_CHECK_KARMA_PRODUCTS" datasource="#dsn2#">
                        SELECT PRODUCT_ID FROM #dsn1#.PRODUCT WHERE PRODUCT_ID IN (#this.basket_data.karma_product_list#) AND IS_KARMA=1
                    </cfquery>
                    <cfif query_CHECK_KARMA_PRODUCTS.recordcount>
                        <cfquery name="query_GET_KARMA_PRODUCTS" datasource="#dsn2#">
                            SELECT 
                                S.STOCK_ID,
                                KP.PRODUCT_ID,
                                KP.PRODUCT_AMOUNT,
                                KP.KARMA_PRODUCT_ID
                            FROM 
                                #dsn1#.KARMA_PRODUCTS KP,
                                #dsn1#.PRODUCT P,
                                #dsn1#.STOCKS S
                            WHERE  
                                P.PRODUCT_ID = KP.PRODUCT_ID AND 
                                S.PRODUCT_ID = KP.PRODUCT_ID AND
                                S.STOCK_ID = KP.STOCK_ID AND
                                KP.KARMA_PRODUCT_ID IN (#valuelist(query_CHECK_KARMA_PRODUCTS.PRODUCT_ID,",")#)
                        </cfquery>
                    </cfif>
                </cfif>
                <!--- //karma koli icin eklendi--->
                <cfquery name="ADD_SALE" datasource="#dsn2#">
                    INSERT INTO SHIP
                        (
                        WRK_ID,
                        PURCHASE_SALES,
                        SHIP_NUMBER,
                        SHIP_TYPE,
                        PROCESS_CAT,
                    <cfif not this.basket_data.included_irs>
                        SHIP_METHOD,
                    </cfif>
                        SHIP_DATE,
                        DELIVER_DATE,
                    <cfif isdefined("this.basket_data.member_type") and this.basket_data.member_type eq 1>
                        COMPANY_ID,
                        PARTNER_ID,
                    <cfelse>
                        CONSUMER_ID,
                    </cfif>
                        DELIVER_EMP, 
                        DISCOUNTTOTAL,
                        NETTOTAL,
                        GROSSTOTAL,
                        TAXTOTAL,
                        ADDRESS,
                        DELIVER_STORE_ID,
                        LOCATION,
                        RECORD_DATE,
                        RECORD_EMP,
                        IS_WITH_SHIP,
                        SHIP_DETAIL
                        )
                    VALUES
                        (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.wrk_id#">,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.INVOICE_NUMBER#">,
                        #int_ship_process_type#,
                        <cfif len(int_ship_process_cat)>#int_ship_process_cat#<cfelse>NULL</cfif>,
                    <cfif not this.basket_data.included_irs>
                        <cfif isdefined('this.basket_data.ship_method') and len(this.basket_data.ship_method)>#this.basket_data.ship_method#<cfelse>NULL</cfif>,
                    </cfif>
                        #this.basket_data.invoice_date#,
                        #this.basket_data.invoice_date#,
                    <cfif isdefined("this.basket_data.member_type") and this.basket_data.member_type eq 1>
                        <cfif len(this.basket_data.company_id)>#this.basket_data.company_id#<cfelse>NULL</cfif>,
                        <cfif len(this.basket_data.partner_id)>#this.basket_data.partner_id#<cfelse>NULL</cfif>,
                    <cfelse>
                        <cfif len(this.basket_data.consumer_id)>#this.basket_data.consumer_id#<cfelse>NULL</cfif>,
                    </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(this.basket_data.DELIVER_GET),50)#">,
                        #this.basket_data.basket_discount_total#,
                        #this.basket_data.basket_net_total#,
                        #this.basket_data.basket_gross_total#,
                        #this.basket_data.basket_tax_total#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.address#">,
                        #this.basket_data.department_id#,
                        #this.basket_data.location_id#,
                        #NOW()#,
                        #session_base.USERID#,
                        1,
                        <cfif isDefined("this.basket_data.note") and len(this.basket_data.note)><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.note#"><cfelse>NULL</cfif>
                        )
                </cfquery>
                <cfquery name="GET_SHIP_ID" datasource="#dsn2#">
                    SELECT SHIP_ID AS MAX_ID,SHIP_NUMBER,SHIP_TYPE FROM SHIP WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.wrk_id#"> AND SHIP_ID = (SELECT MAX(SHIP_ID) AS MAX_ID FROM SHIP WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.wrk_id#">)
                </cfquery>
                <cfloop from="1" to="#this.basket_data.rows_#" index="i">
                    <cfif evaluate('this.basket_data.is_inventory#i#') eq 1>
                        <cfif isdefined('this.basket_data.row_ship_id#i#')><cfset ship_id = evaluate('this.basket_data.row_ship_id#i#')><cfelse><cfset ship_id = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim1#i#') and len(evaluate("this.basket_data.indirim1#i#")) ><cfset indirim1 = evaluate('this.basket_data.indirim1#i#')><cfelse><cfset indirim1 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim2#i#') and len(evaluate("this.basket_data.indirim2#i#")) ><cfset indirim2 = evaluate('this.basket_data.indirim2#i#')><cfelse><cfset indirim2 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim3#i#') and len(evaluate("this.basket_data.indirim3#i#")) ><cfset indirim3 = evaluate('this.basket_data.indirim3#i#')><cfelse><cfset indirim3 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim4#i#') and len(evaluate("this.basket_data.indirim4#i#")) ><cfset indirim4 = evaluate('this.basket_data.indirim4#i#')><cfelse><cfset indirim4 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim5#i#') and len(evaluate("this.basket_data.indirim5#i#")) ><cfset indirim5 = evaluate('this.basket_data.indirim5#i#')><cfelse><cfset indirim5 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim6#i#') and len(evaluate("this.basket_data.indirim6#i#")) ><cfset indirim6 = evaluate('this.basket_data.indirim6#i#')><cfelse><cfset indirim6 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim7#i#') and len(evaluate("this.basket_data.indirim7#i#")) ><cfset indirim7 = evaluate('this.basket_data.indirim7#i#')><cfelse><cfset indirim7 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim8#i#') and len(evaluate("this.basket_data.indirim8#i#")) ><cfset indirim8 = evaluate('this.basket_data.indirim8#i#')><cfelse><cfset indirim8 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim9#i#') and len(evaluate("this.basket_data.indirim9#i#")) ><cfset indirim9 = evaluate('this.basket_data.indirim9#i#')><cfelse><cfset indirim9 = 0></cfif>
                        <cfif isdefined('this.basket_data.indirim10#i#') and len(evaluate("this.basket_data.indirim10#i#")) ><cfset indirim10 = evaluate('this.basket_data.indirim10#i#')><cfelse><cfset indirim10 = 0></cfif>
                        <cfset indirim_carpan = 100000000000000000000 - ((100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5)*(100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)) >
                        <cfif isdefined('this.basket_data.row_total#i#') and len(evaluate("this.basket_data.row_total#i#"))>
                            <!--- 20060224 artik basket elemanlarinin tumune actigimiz gore... hatta ustteki if ler bile yalan bakilacak
                            <cfif isdefined('this.basket_data.iskonto_tutar#i#') and len(evaluate('this.basket_data.iskonto_tutar#i#'))>
                                <cfset discount_amount = evaluate('this.basket_data.amount#i#')*evaluate('this.basket_data.iskonto_tutar#i#')>
                                <cfset temp_row_total = evaluate("this.basket_data.row_total#i#") - discount_amount>
                                <cfif isdefined('this.basket_data.promosyon_yuzde#i#') and len(evaluate('this.basket_data.promosyon_yuzde#i#'))>
                                    <cfset discount_amount = discount_amount + (temp_row_total * evaluate('this.basket_data.promosyon_yuzde#i#')/100)>
                                </cfif>
                                <cfset temp_row_total = evaluate("this.basket_data.row_total#i#") - discount_amount>
                                <cfset discount_amount = discount_amount + ( temp_row_total * indirim_carpan) / 100000000000000000000 >
                            <cfelse>
                                <cfset discount_amount = 0>
                                <cfif isdefined('this.basket_data.promosyon_yuzde#i#') and len(evaluate('this.basket_data.promosyon_yuzde#i#'))>
                                    <cfset discount_amount = evaluate("this.basket_data.row_total#i#") * evaluate('this.basket_data.promosyon_yuzde#i#')/100 >
                                </cfif>
                                <cfset temp_row_total = evaluate("this.basket_data.row_total#i#") - discount_amount>
                                <cfset discount_amount = discount_amount + (temp_row_total * indirim_carpan / 100000000000000000000) >
                            </cfif> --->
                            <cfset discount_amount = evaluate("this.basket_data.row_total#i#")-evaluate("this.basket_data.row_nettotal#i#") >
                            <cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session_base.userid##round(rand()*100)#">
                            <cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
                                INSERT INTO SHIP_ROW
                                    (
                                    NAME_PRODUCT,
                                    SHIP_ID,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    AMOUNT,
                                    UNIT,
                                    UNIT_ID,
                                    TAX,
                                    PRICE,
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
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE,
                                    OTHER_MONEY_GROSS_TOTAL,
                                <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                                    SPECT_VAR_ID,
                                    SPECT_VAR_NAME,
                                </cfif>
                                    LOT_NO,
                                    PRICE_OTHER,
                                    IS_PROMOTION,
                                    DISCOUNT_COST,
                                    UNIQUE_RELATION_ID,
                                    PROM_RELATION_ID,
                                    PRODUCT_NAME2,
                                    AMOUNT2,
                                    UNIT2,
                                    EXTRA_PRICE,
                                    EXTRA_PRICE_TOTAL,
                                    SHELF_NUMBER,
                                    PRODUCT_MANUFACT_CODE,
                                    BASKET_EMPLOYEE_ID,
                                    LIST_PRICE,
                                    PRICE_CAT,
                                    CATALOG_ID,
                                    NUMBER_OF_INSTALLMENT,
                                    WRK_ROW_ID,
                                    WRK_ROW_RELATION_ID,
                                    OTV_ORAN,
                                    OTVTOTAL,
                                    WIDTH_VALUE,
                                    DEPTH_VALUE,
                                    HEIGHT_VALUE,
                                    ROW_PROJECT_ID
                                    <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
                                    <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
                                    <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                                    <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,ACC_CODE</cfif>
                                    <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
                                    <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,ASSETP_ID</cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
                                    <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                                    <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
                                    <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                                    <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
                                    )
                                VALUES
                                    (
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('this.basket_data.product_name#i#'),250)#">,
                                    #GET_SHIP_ID.MAX_ID#,
                                    #evaluate("this.basket_data.stock_id#i#")#,
                                    #evaluate("this.basket_data.product_id#i#")#,
                                    #evaluate("this.basket_data.amount#i#")#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit#i#')#">,
                                    #evaluate("this.basket_data.unit_id#i#")#,						
                                    #evaluate("this.basket_data.tax#i#")#,
                                    #evaluate("this.basket_data.price#i#")#,
                                    1,
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
                                    #DISCOUNT_AMOUNT#,
                                    #evaluate("this.basket_data.row_lasttotal#i#")#,
                                    #evaluate("this.basket_data.row_nettotal#i#")#,
                                    #evaluate("this.basket_data.row_taxtotal#i#")#,						
                                    <cfif isdefined('this.basket_data.deliver_date#i#') and isdate(evaluate('this.basket_data.deliver_date#i#'))>#evaluate('this.basket_data.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                    <cfif isdefined("this.basket_data.deliver_dept#i#") and len(trim(evaluate("this.basket_data.deliver_dept#i#"))) and len(listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                                        #listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                                    <cfelseif isdefined('this.basket_data.department_id') and len(this.basket_data.department_id)>
                                        #this.basket_data.department_id#,
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    <cfif isdefined("this.basket_data.deliver_dept#i#") and listlen(trim(evaluate("this.basket_data.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                                        #listlast(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                                    <cfelseif isdefined('this.basket_data.location_id') and len(this.basket_data.location_id)>
                                        #this.basket_data.location_id#,
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    <cfif isdefined("this.basket_data.other_money_#i#") and len(evaluate("this.basket_data.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.other_money_#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined("this.basket_data.other_money_value_#i#") and len(evaluate("this.basket_data.other_money_value_#i#"))>#evaluate("this.basket_data.other_money_value_#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.other_money_gross_total#i#') and len(evaluate('this.basket_data.other_money_gross_total#i#'))>#evaluate('this.basket_data.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                                        #evaluate("this.basket_data.spect_id#i#")#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.spect_name#i#')#">,
                                    </cfif>
                                    <cfif isdefined("this.basket_data.lot_no#i#") and len(evaluate("this.basket_data.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined("this.basket_data.price_other#i#") and len(evaluate("this.basket_data.price_other#i#"))>#evaluate("this.basket_data.price_other#i#")#<cfelse>NULL</cfif>,
                                        0,
                                    <cfif isdefined('this.basket_data.iskonto_tutar#i#') and len(evaluate('this.basket_data.iskonto_tutar#i#'))>#evaluate('this.basket_data.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_unique_relation_id#i#') and len(evaluate('this.basket_data.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.prom_relation_id#i#') and len(evaluate('this.basket_data.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.product_name_other#i#') and len(evaluate('this.basket_data.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.amount_other#i#') and len(evaluate('this.basket_data.amount_other#i#'))>#evaluate('this.basket_data.amount_other#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.unit_other#i#') and len(evaluate('this.basket_data.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit_other#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.ek_tutar#i#') and len(evaluate('this.basket_data.ek_tutar#i#'))>#evaluate('this.basket_data.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.ek_tutar_total#i#') and len(evaluate('this.basket_data.ek_tutar_total#i#'))>#evaluate('this.basket_data.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.shelf_number#i#') and len(evaluate('this.basket_data.shelf_number#i#'))>#evaluate('this.basket_data.shelf_number#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.manufact_code#i#') and len(evaluate('this.basket_data.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.basket_employee_id#i#') and len(evaluate('this.basket_data.basket_employee_id#i#')) and isdefined('this.basket_data.basket_employee#i#') and len(evaluate('this.basket_data.basket_employee#i#'))>#evaluate('this.basket_data.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.list_price#i#') and len(evaluate('this.basket_data.list_price#i#'))>#evaluate('this.basket_data.list_price#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.price_cat#i#') and len(evaluate('this.basket_data.price_cat#i#'))>#evaluate('this.basket_data.price_cat#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_catalog_id#i#') and len(evaluate('this.basket_data.row_catalog_id#i#'))>#evaluate('this.basket_data.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.number_of_installment#i#') and len(evaluate('this.basket_data.number_of_installment#i#'))>#evaluate('this.basket_data.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                    #row_temp_wrk_id#,
                                    <cfif isdefined('this.basket_data.wrk_row_id#i#') and len(evaluate('this.basket_data.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
                                    <cfif isdefined('this.basket_data.otv_oran#i#') and len(evaluate('this.basket_data.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_otvtotal#i#') and len(evaluate('this.basket_data.row_otvtotal#i#'))>#evaluate('this.basket_data.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_width#i#') and len(evaluate('this.basket_data.row_width#i#'))>#evaluate('this.basket_data.row_width#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_depth#i#') and len(evaluate('this.basket_data.row_depth#i#'))>#evaluate('this.basket_data.row_depth#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_height#i#') and len(evaluate('this.basket_data.row_height#i#'))>#evaluate('this.basket_data.row_height#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.row_project_id#i#') and len(evaluate('this.basket_data.row_project_id#i#')) and isdefined('this.basket_data.row_project_name#i#') and len(evaluate('this.basket_data.row_project_name#i#'))>#evaluate('this.basket_data.row_project_id#i#')#<cfelse>NULL</cfif>
                                    <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_center_id#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_item_id#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_activity_id#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('this.basket_data.row_acc_code#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_subscription_id#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_assetp_id#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_rate#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_amount#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_currency#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_rate#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_amount#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_rate#i#')#"></cfif>
                                    <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_amount#i#')#"></cfif>
                                    )
                            </cfquery>
                        <cfelse>
                            <cfset discount_amount = 0>
                        </cfif>
                        <cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session_base.userid##round(rand()*100)#">
                        <cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
                            INSERT INTO SHIP_ROW
                                (
                                NAME_PRODUCT,
                                SHIP_ID,
                                STOCK_ID,
                                PRODUCT_ID,
                                AMOUNT,
                                UNIT,
                                UNIT_ID,
                                TAX,
                                PRICE,
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
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                OTHER_MONEY_GROSS_TOTAL,
                            <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                                SPECT_VAR_ID,
                                SPECT_VAR_NAME,
                            </cfif>
                                LOT_NO,
                                PRICE_OTHER,
                                IS_PROMOTION,
                                DISCOUNT_COST,
                                UNIQUE_RELATION_ID,
                                PROM_RELATION_ID,
                                PRODUCT_NAME2,
                                AMOUNT2,
                                UNIT2,
                                EXTRA_PRICE,
                                EXTRA_PRICE_TOTAL,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                BASKET_EMPLOYEE_ID,
                                LIST_PRICE,
                                PRICE_CAT,
                                CATALOG_ID,
                                NUMBER_OF_INSTALLMENT,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                OTV_ORAN,
                                OTVTOTAL,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID
                                <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
                                <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
                                <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                                <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,ACC_CODE</cfif>
                                <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
                                <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,ASSETP_ID</cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
                                <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                                <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
                                <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                                <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
                                )
                            VALUES
                                (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('this.basket_data.product_name#i#'),250)#">,
                                #GET_SHIP_ID.MAX_ID#,
                                #evaluate("this.basket_data.stock_id#i#")#,
                                #evaluate("this.basket_data.product_id#i#")#,
                                #evaluate("this.basket_data.amount#i#")#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit#i#')#">,
                                #evaluate("this.basket_data.unit_id#i#")#,						
                                #evaluate("this.basket_data.tax#i#")#,
                                #evaluate("this.basket_data.price#i#")#,
                                1,
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
                                #DISCOUNT_AMOUNT#,
                                #evaluate("this.basket_data.row_lasttotal#i#")#,
                                #evaluate("this.basket_data.row_nettotal#i#")#,
                                #evaluate("this.basket_data.row_taxtotal#i#")#,						
                                <cfif isdefined('this.basket_data.deliver_date#i#') and isdate(evaluate('this.basket_data.deliver_date#i#'))>#evaluate('this.basket_data.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                <cfif isdefined("this.basket_data.deliver_dept#i#") and len(trim(evaluate("this.basket_data.deliver_dept#i#"))) and len(listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                                    #listfirst(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined('this.basket_data.department_id') and len(this.basket_data.department_id)>
                                    #this.basket_data.department_id#,
                                <cfelse>
                                    NULL,
                                </cfif>
                                <cfif isdefined("this.basket_data.deliver_dept#i#") and listlen(trim(evaluate("this.basket_data.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("this.basket_data.deliver_dept#i#"),"-"))>
                                    #listlast(evaluate("this.basket_data.deliver_dept#i#"),"-")#,
                                <cfelseif isdefined('this.basket_data.location_id') and len(this.basket_data.location_id)>
                                    #this.basket_data.location_id#,
                                <cfelse>
                                    NULL,
                                </cfif>
                                <cfif isdefined("this.basket_data.other_money_#i#") and len(evaluate("this.basket_data.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.other_money_#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("this.basket_data.other_money_value_#i#") and len(evaluate("this.basket_data.other_money_value_#i#"))>#evaluate("this.basket_data.other_money_value_#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.other_money_gross_total#i#') and len(evaluate('this.basket_data.other_money_gross_total#i#'))>#evaluate('this.basket_data.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>
                                    #evaluate("this.basket_data.spect_id#i#")#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.spect_name#i#')#">,
                                </cfif>
                                <cfif isdefined("this.basket_data.lot_no#i#") and len(evaluate("this.basket_data.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("this.basket_data.price_other#i#") and len(evaluate("this.basket_data.price_other#i#"))>#evaluate("this.basket_data.price_other#i#")#<cfelse>NULL</cfif>,
                                    0,
                                <cfif isdefined('this.basket_data.iskonto_tutar#i#') and len(evaluate('this.basket_data.iskonto_tutar#i#'))>#evaluate('this.basket_data.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_unique_relation_id#i#') and len(evaluate('this.basket_data.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.prom_relation_id#i#') and len(evaluate('this.basket_data.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.product_name_other#i#') and len(evaluate('this.basket_data.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.amount_other#i#') and len(evaluate('this.basket_data.amount_other#i#'))>#evaluate('this.basket_data.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.unit_other#i#') and len(evaluate('this.basket_data.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.ek_tutar#i#') and len(evaluate('this.basket_data.ek_tutar#i#'))>#evaluate('this.basket_data.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.ek_tutar_total#i#') and len(evaluate('this.basket_data.ek_tutar_total#i#'))>#evaluate('this.basket_data.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.shelf_number#i#') and len(evaluate('this.basket_data.shelf_number#i#'))>#evaluate('this.basket_data.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.manufact_code#i#') and len(evaluate('this.basket_data.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.basket_employee_id#i#') and len(evaluate('this.basket_data.basket_employee_id#i#')) and isdefined('this.basket_data.basket_employee#i#') and len(evaluate('this.basket_data3.basket_employee#i#'))>#evaluate('this.basket_data.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.list_price#i#') and len(evaluate('this.basket_data.list_price#i#'))>#evaluate('this.basket_data.list_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.price_cat#i#') and len(evaluate('this.basket_data.price_cat#i#'))>#evaluate('this.basket_data.price_cat#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_catalog_id#i#') and len(evaluate('this.basket_data.row_catalog_id#i#'))>#evaluate('this.basket_data.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.number_of_installment#i#') and len(evaluate('this.basket_data.number_of_installment#i#'))>#evaluate('this.basket_data.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                #row_temp_wrk_id#,
                                <cfif isdefined('this.basket_data.wrk_row_id#i#') and len(evaluate('this.basket_data.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
                                <cfif isdefined('this.basket_data.otv_oran#i#') and len(evaluate('this.basket_data.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_otvtotal#i#') and len(evaluate('this.basket_data.row_otvtotal#i#'))>#evaluate('this.basket_data.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_width#i#') and len(evaluate('this.basket_data.row_width#i#'))>#evaluate('this.basket_data.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_depth#i#') and len(evaluate('this.basket_data.row_depth#i#'))>#evaluate('this.basket_data.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_height#i#') and len(evaluate('this.basket_data.row_height#i#'))>#evaluate('this.basket_data.row_height#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('this.basket_data.row_project_id#i#') and len(evaluate('this.basket_data.row_project_id#i#')) and isdefined('this.basket_data.row_project_name#i#') and len(evaluate('this.basket_data.row_project_name#i#'))>#evaluate('this.basket_data.row_project_id#i#')#<cfelse>NULL</cfif>
                                <cfif isdefined('this.basket_data.row_exp_center_id#i#') and len(evaluate("this.basket_data.row_exp_center_id#i#")) and isdefined('this.basket_data.row_exp_center_name#i#') and len(evaluate("this.basket_data.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_center_id#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_exp_item_id#i#') and len(evaluate("this.basket_data.row_exp_item_id#i#")) and isdefined('this.basket_data.row_exp_item_name#i#') and len(evaluate("this.basket_data.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_exp_item_id#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_activity_id#i#') and len(evaluate("this.basket_data.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_activity_id#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_acc_code#i#') and len(evaluate("this.basket_data.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('this.basket_data.row_acc_code#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_subscription_name#i#') and len(evaluate("this.basket_data.row_subscription_name#i#")) and isdefined('this.basket_data.row_subscription_id#i#') and len(evaluate("this.basket_data.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_subscription_id#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_assetp_name#i#') and len(evaluate("this.basket_data.row_assetp_name#i#")) and isdefined('this.basket_data.row_assetp_id#i#') and len(evaluate("this.basket_data.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('this.basket_data.row_assetp_id#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_rate#i#') and len(evaluate("this.basket_data.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_rate#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_amount#i#') and len(evaluate("this.basket_data.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_amount#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_bsmv_currency#i#') and len(evaluate("this.basket_data.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_bsmv_currency#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_oiv_rate#i#') and len(evaluate("this.basket_data.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_rate#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_oiv_amount#i#') and len(evaluate("this.basket_data.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_oiv_amount#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_tevkifat_rate#i#') and len(evaluate("this.basket_data.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_rate#i#')#"></cfif>
                                <cfif isdefined('this.basket_data.row_tevkifat_amount#i#') and len(evaluate("this.basket_data.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('this.basket_data.row_tevkifat_amount#i#')#"></cfif>
                                )
                        </cfquery>
                        <cfif this.basket_data.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
                            <cfquery name="GET_UNIT" datasource="#dsn2#">
                                SELECT 
                                    ADD_UNIT,
                                    MULTIPLIER,
                                    MAIN_UNIT,
                                    PRODUCT_UNIT_ID
                                FROM
                                    #dsn3_alias#.PRODUCT_UNIT 
                                WHERE
                                    PRODUCT_ID = #evaluate("this.basket_data.product_id#i#")# AND
                                    ADD_UNIT = '#evaluate("this.basket_data.unit#i#")#'
                            </cfquery>
                            <cfif get_unit.recordcount and len(get_unit.multiplier)>
                                <cfset multi = get_unit.multiplier*evaluate("this.basket_data.amount#i#")>
                            <cfelse>
                                <cfset multi = evaluate("this.basket_data.amount#i#")>
                            </cfif>
                            <!---  specli bir satirsa main_spec id yazilacak stok row a --->
                            <cfset form_spect_main_id="">
                            <cfif isdefined('this.basket_data.spect_id#i#') and len(evaluate('this.basket_data.spect_id#i#'))>
                                <cfset form_spect_id="#evaluate('this.basket_data.spect_id#i#')#">
                                <cfif len(form_spect_id) and len(form_spect_id)>
                                    <cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
                                        SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
                                    </cfquery>
                                    <cfif GET_MAIN_SPECT.RECORDCOUNT>
                                        <cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <!--- karma koli icin eklendi --->
                            <cfif isdefined("this.basket_data.karma_product_list") and len(this.basket_data.karma_product_list) and (query_CHECK_KARMA_PRODUCTS.recordcount)>
                                <cfquery name="GET_KARMA_PRODUCT" dbtype="query">
                                    SELECT 
                                        STOCK_ID,
                                        PRODUCT_ID,
                                        PRODUCT_AMOUNT
                                    FROM
                                        GET_KARMA_PRODUCTS
                                    WHERE  
                                        KARMA_PRODUCT_ID = #evaluate("this.basket_data.product_id#i#")#
                                </cfquery>
                            <cfelse>
                                <cfset GET_KARMA_PRODUCT.recordcount=0>
                            </cfif>
                            <cfif GET_KARMA_PRODUCT.recordcount>
                                <cfloop query="GET_KARMA_PRODUCT">
                                    <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                        INSERT INTO STOCKS_ROW
                                            (
                                            UPD_ID,
                                            PRODUCT_ID,
                                            STOCK_ID,
                                            PROCESS_TYPE,
                                            STOCK_OUT,
                                            STORE,
                                            STORE_LOCATION,
                                            PROCESS_DATE,
                                            SPECT_VAR_ID,
                                            LOT_NO,
                                            DELIVER_DATE,
                                            SHELF_NUMBER,
                                            PRODUCT_MANUFACT_CODE
                                            )
                                        VALUES
                                            (
                                            #GET_SHIP_ID.MAX_ID#,
                                            #GET_KARMA_PRODUCT.product_id#,
                                            #GET_KARMA_PRODUCT.stock_id#,
                                            #int_ship_process_type#,
                                            #multi*GET_KARMA_PRODUCT.product_amount#,
                                            #this.basket_data.department_id#,
                                            #this.basket_data.location_id#,
                                            #this.basket_data.invoice_date#,
                                        <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>#evaluate("this.basket_data.spect_id#i#")#<cfelse>NULL</cfif>, --->
                                        <cfif isdefined("this.basket_data.lot_no#i#") and len(evaluate("this.basket_data.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.lot_no#i#')#"><cfelse>NULL</cfif>,
                                        <cfif isdefined('this.basket_data.deliver_date#i#') and isdate(evaluate('this.basket_data.deliver_date#i#'))>#evaluate('this.basket_data.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                        <cfif isdefined('this.basket_data.shelf_number#i#') and len(evaluate('this.basket_data.shelf_number#i#'))>#evaluate('this.basket_data.shelf_number#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('this.basket_data.manufact_code#i#') and len(evaluate('this.basket_data.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.manufact_code#i#')#"><cfelse>NULL</cfif>
                                            )
                                    </cfquery>					
                                </cfloop>
                            <cfelse>
                                <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                    INSERT INTO STOCKS_ROW
                                        (
                                        UPD_ID,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        PROCESS_TYPE,
                                        STOCK_OUT,
                                        STORE,
                                        STORE_LOCATION,
                                        PROCESS_DATE,
                                        SPECT_VAR_ID,
                                        LOT_NO,
                                        DELIVER_DATE,
                                        SHELF_NUMBER,
                                        PRODUCT_MANUFACT_CODE
                                        )
                                    VALUES
                                        (
                                        #GET_SHIP_ID.MAX_ID#,
                                        #evaluate("this.basket_data.product_id#i#")#,
                                        #evaluate("this.basket_data.stock_id#i#")#,
                                        #int_ship_process_type#,
                                        #multi#,
                                        #this.basket_data.department_id#,
                                        #this.basket_data.location_id#,
                                        #this.basket_data.invoice_date#,
                                    <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("this.basket_data.spect_id#i#") and len(evaluate("this.basket_data.spect_id#i#"))>#evaluate("this.basket_data.spect_id#i#")#<cfelse>NULL</cfif>, --->
                                    <cfif isdefined("this.basket_data.lot_no#i#") and len(evaluate("this.basket_data.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.deliver_date#i#') and isdate(evaluate('this.basket_data.deliver_date#i#'))>#evaluate('this.basket_data.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                    <cfif isdefined('this.basket_data.shelf_number#i#') and len(evaluate('this.basket_data.shelf_number#i#'))>#evaluate('this.basket_data.shelf_number#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('this.basket_data.manufact_code#i#') and len(evaluate('this.basket_data.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('this.basket_data.manufact_code#i#')#"><cfelse>NULL</cfif>
                                        )
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
                    INSERT INTO
                        INVOICE_SHIPS
                        (
                        INVOICE_ID,
                        INVOICE_NUMBER,
                        SHIP_ID,
                        SHIP_NUMBER,
                        IS_WITH_SHIP,
                        SHIP_PERIOD_ID
                        )
                    VALUES
                        (
                        
                        #this.basket_data.invoice_id#,					
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.invoice_number#">,
                        #GET_SHIP_ID.MAX_ID#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.basket_data.invoice_number#">,
                        1, <!--- faturanın kendi irsaliyesi --->
                        #session_base.period_id#
                        )
                </cfquery>
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="add" access="public" output="true">
        
        <cfargument name="datas">
        <cfset this.basket_data = arguments>
        <cfset this.basket_data.DETAIL_ = "#getLang('main',412)#">
        <cftry>
        <cfset check_invoice()>
        <cfif this.basket_data.basket_check_status eq 0>
            <cfreturn { status: this.basket_data.basket_check_status, message: this.basket_data.basket_check_status_code }>
        </cfif>
        <cfcatch>
            <cfreturn cfcatch>
        </cfcatch>
        </cftry>
        
        <cfif len(this.basket_data.department_id) and len(this.basket_data.location_id)>
            <cfquery name="query_get_location_type" datasource="#dsn#">
                SELECT LOCATION_TYPE,IS_SCRAP FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = #this.basket_data.department_id# AND LOCATION_ID = #this.basket_data.location_id#
            </cfquery>
            <cfset this.basket_data.location_type = query_get_location_type.LOCATION_TYPE>
            <cfset this.basket_data.is_scrap = query_get_location_type.IS_SCRAP>
        <cfelse>
            <cfset this.basket_data.location_type = "">
            <cfset this.basket_data.is_scrap = 0>
        </cfif>

        <cfset this.basket_data.wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)>
        
        <cflock name="#createUUID()#" timeout="60">
        <cftransaction>
            <cftry>
                <cfif isDefined("this.basket_data.company_id") and len(this.basket_data.company_id)>
                    <cfif not isDefined("this.basket_data.xml_import")>
                        <cfset upd_company()>
                        <cfset this.basket_data.member_type = 1>
                        <cfset add_new_member = "-1">
                    </cfif>
                <cfelseif isdefined("this.basket_data.consumer_id") and len(this.basket_data.consumer_id)>
                    <cfset upd_consumer()>
                    <cfset this.basket_data.member_type = 2>
                    <cfset add_new_member = "-2">
                <cfelseif isdefined("this.basket_data.member_type") and this.basket_data.member_type eq 1>
                    <cfset add_company()>
                    <cfset add_new_member=1>
                <cfelseif isdefined("this.basket_data.member_type") and this.basket_data.member_type eq 2>
                    <cfset add_consumer()>
                    <cfset add_new_member=1> <!--- yeni uyeyle ilgili action files da kullanılıyor, SILMEYIN --->
                </cfif>

                <cfset add_sale()>
                <cfset kasa_muhasebe()>
                <cfset cari_muhasebe()>
                
                <cfset pos_islem()>
                <cfset stok_islem()>
                <cfscript>
                    attributes = this.basket_data;
                    structAppend(attributes, this.basket_data);
                    basket_kur_ekle = application.functions.basket_kur_ekle;
                    basket_kur_ekle(action_id:this.basket_data.invoice_id,table_type_id:1,process_type:0);
                </cfscript>
                <cf_workcube_process_cat 
                    process_cat="#this.basket_data.process_cat#"
                    action_id = "#this.basket_data.invoice_id#"
                    action_table="INVOICE"
                    action_column="INVOICE_ID"
                    is_action_file = 1
                    action_page='index.cfm?fuseaction=invoice.add_bill_retail&event=upd&iid=#this.basket_data.invoice_id#'
                    action_file_name='#this.basket_data.action_file_name#'
                    action_db_type = '#dsn2#'
                    is_template_action_file = '#this.basket_data.action_file_from_template#'>
                <cfcatch>
                    <cftransaction action="rollback">
                    <cfreturn cfcatch>
                </cfcatch>
            </cftry>
        </cftransaction>
        </cflock>

        <cfreturn { status: this.basket_data.basket_check_status, message: this.basket_data.basket_check_status_code, new_member: add_new_member, invoice_id: this.basket_data.invoice_id }>
    </cffunction>
    
    <cffunction name="send_invoice" access="public" output="true">
        <cfset response = structNew()>
        <cfquery name="get_sale_det" datasource="#dsn2#">
            SELECT COMPANY_ID, CONSUMER_ID, INVOICE_DATE FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#">
        </cfquery>
        <cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
            <cfquery name="GET_SALE_DET_COMP" datasource="#DSN#">
                SELECT USE_EFATURA, EFATURA_DATE FROM COMPANY WHERE COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.company_id#">
            </cfquery>
        <cfelseif len(get_sale_det.consumer_id)>
            <cfquery name="GET_CONS_NAME" datasource="#DSN#">
                SELECT USE_EFATURA, EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.consumer_id#">
            </cfquery>		
        </cfif>
        <cfscript>
            try{
                if( (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0)){
                    attributes.action_id = arguments.invoice_id;
                    attributes.action_type = 'INVOICE';
                    url.action_id = arguments.invoice_id;
                    url.action_type = 'INVOICE';
                    attributes.fuseaction = 'invoice.popup_create_xml';
                    include '/V16/e_government/display/create_xml.cfm';
                    getPageContext().getCFOutput().clearAll();
                    getPageContext().getCFOutput().clearHeaderBuffers();
                }else if( session_base.our_company_info.is_earchive eq 1 and datediff('d',session_base.our_company_info.earchive_date,get_sale_det.invoice_date) gte 0){
                    attributes.action_id = arguments.invoice_id;
                    attributes.action_type = 'INVOICE';
                    url.action_id = arguments.invoice_id;
                    url.action_type = 'INVOICE';
                    attributes.fuseaction = 'invoice.popup_create_xml_earchive';
                    include '/V16/e_government/display/create_xml_earchive.cfm';
                    getPageContext().getCFOutput().clearAll();
                    getPageContext().getCFOutput().clearHeaderBuffers();
                }
                response.message = "Gonderim Basarili";
                response.status = 1;
            }catch( any e){
                response.message = "Gonderim Sırasında Sorun Oluştu";
                response.status = 0;
            }
        </cfscript>
        <cfreturn response>
    </cffunction>

    <cffunction name="print_invoice" access="public" output="true">
        <cfquery name="get_comp_info" datasource="#dsn#">
            SELECT * FROM OUR_COMPANY OU
            JOIN SETUP_CITY AS SC ON OU.CITY_ID = SC.CITY_ID
            JOIN SETUP_COUNTY AS SCC ON OU.COUNTY_ID = SCC.COUNTY_ID WHERE COMP_ID = #session_base.company_id#
        </cfquery>
        <cfquery name="Get_Invoice" datasource="#dsn2#">
            SELECT NETTOTAL, TAXTOTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfquery name="Get_Invoice_Row" datasource="#dsn2#">
            SELECT 
                IR.*,
                S.PROPERTY,
                IR.NAME_PRODUCT AS PRODUCT_NAME,
                S.STOCK_CODE
            FROM 
                INVOICE_ROW IR, 
                #dsn3_alias#.STOCKS S
            WHERE 
                IR.STOCK_ID = S.STOCK_ID AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
            ORDER BY
                IR.INVOICE_ROW_ID 
        </cfquery>
        <cfquery name="control_cashes" datasource="#dsn2#">
            SELECT 
                CASH_ACTIONS.ACTION_VALUE,
                CASH_ACTIONS.ACTION_CURRENCY_ID
            FROM
                INVOICE,
                INVOICE_CASH_POS,
                CASH_ACTIONS
            WHERE
                CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
                AND INVOICE_CASH_POS.INVOICE_ID=INVOICE.INVOICE_ID 
                AND INVOICE.INVOICE_ID = #arguments.id#
            ORDER BY 
                INVOICE_CASH_POS.KASA_ID DESC
        </cfquery>
        <cfset total_cash = 0>
        <cfset total_pos = 0>
        <cfif control_cashes.recordcount>
            <cfoutput query="control_cashes">
                <cfset total_cash += control_cashes.ACTION_VALUE>
            </cfoutput>
        </cfif>
        <cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#" maxrows="3">
            SELECT 
                INVOICE_CASH_POS.*,
                CREDIT_CARD_BANK_PAYMENTS.*
            FROM
                INVOICE,
                INVOICE_CASH_POS,
                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
            WHERE
                INVOICE.INVOICE_ID=INVOICE_CASH_POS.INVOICE_ID
                AND INVOICE_CASH_POS.POS_ACTION_ID=CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
                AND INVOICE.INVOICE_ID = #arguments.id# AND
                INVOICE_CASH_POS.POS_PERIOD_ID = #session_base.period_id#
            ORDER BY
                INVOICE_CASH_POS.POS_ACTION_ID
        </cfquery>
        <cfif CONTROL_POS_PAYMENT.recordcount>
            <cfoutput query="CONTROL_POS_PAYMENT">
                <cfset total_pos += CONTROL_POS_PAYMENT.SALES_CREDIT>
            </cfoutput>
        </cfif>
        <cfset sepet.kdv_array = ArrayNew(2)>
        <cfset invoice_bill_upd = arraynew(2)>
        <cfset kdv_total = 0>
        <cfoutput query="Get_Invoice_Row">
            <cfset invoice_bill_upd[currentrow][2] = product_name>
            <cfset invoice_bill_upd[currentrow][3] = stock_code>
            <cfset invoice_bill_upd[currentrow][4] = amount>
            <cfset invoice_bill_upd[currentrow][5] = unit>	
            <cfset invoice_bill_upd[currentrow][6] = price>	
            <cfset invoice_bill_upd[currentrow][18] = grosstotal>
            <cfset invoice_bill_upd[currentrow][17] = taxtotal>
            <cfif len(TAX)>
                <cfset invoice_bill_upd[currentrow][7] = TAX>
                <cfelse>
                    <cfif nettotal neq 0>
                        <cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 >
                    <cfelse>	
                        <cfset invoice_bill_upd[currentrow][7] = 0>
                    </cfif>
            </cfif>		
            <cfscript>
            kdv_flag = 0;
            for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
            {
                if (sepet.kdv_array[k][1] eq invoice_bill_upd[currentrow][7])
                {
                    kdv_flag = 1;
                    sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + invoice_bill_upd[currentrow][17];				
                }
            }
            if (not kdv_flag)
            {
                sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
                sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
            }	
            </cfscript>
            <cfset kdv_total = kdv_total + invoice_bill_upd[currentrow][17]>   
        </cfoutput>
        <cfsavecontent variable="prints">
        <div id="woc_preview">
            <div class="col-12">
                <div class="col col-12 bold">
                    <cfoutput>#get_comp_info.COMPANY_NAME#</cfoutput>
                </div>
                    <div class="col col-12" style="margin-top:5px;"><cfoutput>#get_comp_info.ADDRESS#</cfoutput></div>
                    <div class="col col-12"><cfoutput>#get_comp_info.CITY_NAME# #get_comp_info.COUNTY_NAME# #get_comp_info.DISTRICT_NAME#</cfoutput></div>
                    <div class="col col-12"><cfoutput>#get_comp_info.TEL_CODE#-#get_comp_info.TEL#</cfoutput></div>
                    <div class="col col-12"><cfoutput>#get_comp_info.TAX_OFFICE# #get_comp_info.TAX_NO#</cfoutput></div>
                    <div class="col col-12">Mersis No: <cfoutput>#get_comp_info.MERSIS_NO#</cfoutput></div>
                <div class="col col-8" style="margin-top:5px;">
                    <div class="col col-12">Tarih: <cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput> </div>
                    <div class="col col-12">Saat: <cfoutput>#timeformat(now(), 'HH:MM')#</cfoutput></div>
                    <div class="col col-12"> Fiş No  : 021</div>
                </div>
            </div>
            <div class="col-12">
                <div class="col col-12 text-center bold">
                    ---------- Bilgi Fişi -----------
                </div>
                <!--- <div class="col col-12" style="margin-top:5px;">
                    <div class="col col-12 bold">E-Arşiv  - Fatura</div>
                    <div class="col col-12">E-Arşiv No:  KTLZ120320210001</div>
                    <div class="col col-12">Müşteri VKN: 8090211 - Kadıköy VD</div>
                </div> --->
            </div>
            <div class="col-12" style="margin-top:5px;">
                <cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
                    <div class="col col-12"><cfoutput>#invoice_bill_upd[i][4]# #invoice_bill_upd[i][5]#</cfoutput> x <cfoutput>#TLFormat(invoice_bill_upd[i][6])#</cfoutput></div>
                    <div class="col col-12">
                        <div class="col col-8"><cfoutput>#invoice_bill_upd[i][2]#</cfoutput></div>
                        <div class="col col-2"><cfoutput>%(#invoice_bill_upd[i][7]#) #TLFormat(invoice_bill_upd[i][17])#&nbsp;#session_base.money#</cfoutput></div>
                        <div class="col col-2"><cfoutput>#TLFormat(invoice_bill_upd[i][18])#&nbsp;#session_base.money#</cfoutput></div>
                    </div>
                </cfloop>
            </div>
            <div class="col col-12 text-center bold">
                -------------------------------
            </div>
            <div class="col col-12 bold">
                <div class="col col-10">Toplam KDV</div>
                <div class="col col-2">*<cfoutput>#TLFormat(Get_Invoice.Taxtotal)#&nbsp;#session_base.money#</cfoutput></div>
                <div class="col col-10" style="margin-top:5px;">TOPLAM</div>
                <div class="col col-2" style="margin-top:5px;">*<cfoutput>#TLFormat(Get_Invoice.Nettotal)#&nbsp;#session_base.money#</cfoutput></div>
            </div>
            <div class="col col-12 text-center bold">
                ------------------------------
            </div>
            <div class="col col-12 bold">
                <div class="col col-10">Kredi Kartı</div>
                <div class="col col-2">* <cfoutput>#tlformat(total_cash)#</cfoutput></div>
                <div class="col col-10" style="margin-top:5px;">Nakit</div>
                <div class="col col-2" style="margin-top:5px;">* <cfoutput>#total_pos#</cfoutput></div>
                <!---<div class="col col-10" style="margin-top:5px;">Para Üstü</div>
                <div class="col col-2" style="margin-top:5px;">*5,24</div>--->
            </div>
            <div class="col-12">
                <div class="col col-8">Whops Kodu: <cfoutput>#session_base.WHOPS.EQUIPMENT_CODE#</cfoutput></div>
                <div class="col col-8" style="margin-top:5px;">Satış Uzmanı <cfoutput>#session_base.USERID# - #session_base.NAME# #session_base.SURNAME#</cfoutput></div>
                <div class="col col-12 bold" style="margin-top:5px;">** MALİ DEĞERİ YOKTUR **</div>
                <!---<div class="col col-12" style="margin-top:5px;">Mükellefe e-arşiv gönderilmiştir.</div>--->
            </div>
        </div></cfsavecontent>
        <cfreturn prints>
    </cffunction>

</cfcomponent>