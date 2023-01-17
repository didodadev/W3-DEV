<cfsetting showdebugoutput="no">
<cf_date tarih="attributes.action_date">
<cf_xml_page_edit fuseact="objects.expense_cost">
<cfset form.active_period = session.ep.period_id>
<cfif len(attributes.RequestIdList)>
    <cfloop list="#attributes.RequestIdList#" index="request_id">
        <cfset attributes.request_id = request_id>
        <cfquery name="GET_GEN_PAPER" datasource="#DSN3#">
            SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
		</cfquery>
        <cfset from_multiple_page = 1>
		<cfset paper_code = get_gen_paper.expense_cost_no>
        <cfset paper_number = int(get_gen_paper.expense_cost_number + 1)>
        <cfset attributes.serial_no = paper_number>
        <cfset attributes.serial_number = paper_code>
        <cfset paper_control_ = 0>
        <cfset attributes.expense_cost_type = 120>
        <cfset paper_number = paper_number>
        <cfquery name="get_project" datasource="#dsn2#">
            SELECT PROJECT_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
        </cfquery>        
        <cfquery name="get_expense" datasource="#dsn2#">
            SELECT
                PAPER_TYPE,
                DETAIL,
                ISNULL(SYSTEM_RELATION,PAPER_NO) SYSTEM_RELATION,
                SALES_COMPANY_ID CH_COMPANY_ID,
                SALES_CONSUMER_ID CH_CONSUMER_ID,
                EMP_ID AS CH_EMPLOYEE_ID,
                SALES_PARTNER_ID CH_PARTNER_ID,
                '' ACC_TYPE_ID,
                '' DEPARTMENT_ID,
                '' LOCATION_ID,
                EXPENSE_CASH_ID,
                PAYMETHOD_ID,
                EXPENSE_DATE,
                EXPENSE_DATE AS PROCESS_DATE,
                DUE_DATE,
                EMP_ID,
                ACC_TYPE_ID ACC_TYPE_ID_EXP,
                IS_CASH,
                IS_BANK,
                '' TEVKIFAT,
                '' TEVKIFAT_ORAN,
                '' TEVKIFAT_ID,
                BRANCH_ID,
                0 ROUND_MONEY,
                0 IS_CREDITCARD,
                '' EXPENSE_ID,
                0 STOPAJ,
                0 STOPAJ_ORAN,
                0 STOPAJ_RATE_ID,
                '' ACC_DEPARTMENT_ID,
                '' TAX_CODE,
                ''SHIP_ADDRESS_ID,
                ''SHIP_ADDRESS,
                (SELECT POSITION_CODE FROM #DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID) POSITION_CODE,*
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
        <cfif isdefined("GET_EXPENSE") and GET_EXPENSE.RECORDCOUNT eq 0>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='34262.Masraf Fişi Yok veya Silinmiş'>");
                history.go(-1);
            </script>
            <cfabort>
        </cfif>
        <cfif isdefined("get_expense") and isdefined("get_expense.expense_date_time") and len(get_expense.expense_date_time)>
            <cfset attributes.expense_date_h = hour(get_expense.expense_date_time)>
            <cfset attributes.expense_date_m = minute(get_expense.expense_date_time)>
        <cfelse>
            <cfset attributes.expense_date_h = hour(dateadd('h',session.ep.time_zone,now()))>
            <cfset attributes.expense_date_m = minute(now())>
        </cfif>
        <cfif isdefined("get_expense")>
            <cfset attributes.expense_paper_type = (len(get_expense.paper_type)) ? get_expense.paper_type : ''>
            <cfset expense_bank_id = get_expense.expense_cash_id>
            <cfset expense_branch_id = get_expense.branch_id>
            <cfif len(get_expense.paymethod_id)>
                <cfquery name="get_pay_meyhod" datasource="#dsn2#">
                    SELECT PAYMETHOD,DUE_DAY FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
                </cfquery>
                <cfset attributes.paymethod_name = get_pay_meyhod.paymethod>
                <cfset attributes.paymethod = get_expense.paymethod_id>
            <cfelse>
                <cfset attributes.paymethod_name = "">
                <cfset attributes.paymethod = "">
            </cfif> 
            <cfif isdefined("get_expense") and len(get_expense.process_date)>
                <cfset p_date = get_expense.process_date>
            <cfelseif isdefined("get_expense") and len(get_expense.expense_date)>
                <cfset p_date = get_expense.expense_date>
            <cfelseif isdefined("process_date_")>
                <cfset p_date = process_date_>
            <cfelse>
                <cfset p_date = now()>
            </cfif>
            <cfset attributes.process_date = "#dateformat(p_date,dateformat_style)#">
            <cfset attributes.expense_date = "#dateformat(get_expense.expense_date,dateformat_style)#">
            <cfset attributes.basket_due_value_date_ = (len(get_expense.due_date)) ? "#dateformat(get_expense.due_date,dateformat_style)#" : "#dateformat(get_expense.expense_date,dateformat_style)#">
            <cfset attributes.total_amount = get_expense.total_amount>
            <cfset attributes.kdv_total_amount = get_expense.net_total_amount>
            <cfset attributes.NET_TOTAL_AMOUNT = get_expense.NET_KDV_AMOUNT>
            <cfset attributes.yuvarlama = "">
            <cfset attributes.RECORD_NUM  = "">
            <cfset nextEvent = 'cost.form_add_expense_cost&event=upd&expense_id='>
            <cfset attributes.system_relation = (len(get_expense.system_relation)) ? get_expense.system_relation : ''>
            <cfset attributes.other_total_amount = (len(get_expense.other_money_amount)) ? get_expense.other_money_amount : ''>
            <cfset attributes.other_money = (len(get_expense.other_money)) ? get_expense.other_money : ''>
            <cfset attributes.detail = '#get_expense.detail#'>
            <cfset attributes.other_kdv_total_amount = get_expense.other_money_kdv>
            <cfset attributes.other_otv_total_amount = "">
            <cfset attributes.otv_total_amount = "">
            <cfset attributes.oiv_total_amount = "">
            <cfset attributes.bsmv_total_amount = "">
            <cfset attributes.other_net_total_amount = get_expense.other_money_net_total>
            <cfif len(get_expense.ch_company_id)>
                <cfset attributes.ch_member_type="partner">
                <cfset attributes.ch_company_id = get_expense.ch_company_id>
                <cfset attributes.ch_partner_id =get_expense.ch_partner_id>
                <cfset attributes.ch_company = get_par_info(get_expense.ch_company_id,1,1,0)>
            <cfelseif len(get_expense.ch_consumer_id)>
                <cfset attributes.ch_member_type="consumer">
                <cfset attributes.ch_partner_id =get_expense.ch_consumer_id>
                <cfset attributes.ch_company = get_cons_info(get_expense.ch_consumer_id,2,0)>
            <cfelseif len(get_expense.ch_employee_id)>
                <cfset attributes.ch_member_type="employee">
                <cfset attributes.ch_partner_id="#get_expense.ch_employee_id#">
                <cfset attributes.ch_partner ="#get_emp_info(get_expense.ch_employee_id,0,0,0,get_expense.acc_type_id)#">
               
            <cfelse>
                <cfset attributes.ch_member_type="">
                <cfset attributes.ch_partner_id="">
                <cfset attributes.ch_company_id="">
                <cfset attributes.ch_company="">
            </cfif>
            
            <cfset emp_id = get_expense.ch_employee_id>
           <cfif isdefined("attributes.xml_acc_type") and len(attributes.xml_acc_type)>
                <cfset emp_id = "#emp_id#_#attributes.xml_acc_type#">
            </cfif>
            <cfset attributes.emp_id=emp_id>
            <cfset attributes.expense_employee_id = get_expense.emp_id>
            <cfif len(get_expense.acc_type_id_exp)>
                <cfset attributes.expense_employee_id = "#attributes.expense_employee_id#_#get_expense.acc_type_id_exp#">
            </cfif>
            <cfset attributes.expense_employee_position = get_expense.POSITION_CODE>
            <cfset attributes.expense_employee = "#get_emp_info(get_expense.emp_id,0,0,0,get_expense.acc_type_id_exp)#">                                  
        <cfelse>
            <cfset expense_bank_id = ''>
            <cfset expense_branch_id = ''>
            <cfset attributes.paymethod = ''>
            <cfset expense_due_date = ''>
            <cfset attributes.expense_employee_id = session.ep.userid>
            <cfset attributes.expense_employee_position = session.ep.position_code>
            <cfset attributes.expense_employee = "#session.ep.name# #session.ep.surname#">
        </cfif>
        <cfif isdefined("get_expense.ACC_DEPARTMENT_ID") and len(get_expense.ACC_DEPARTMENT_ID)>
            <cfset acc_info = get_expense.ACC_DEPARTMENT_ID>
        <cfelse>
            <cfset acc_info = ''>
        </cfif>
        <cfset attributes.acc_department_id = acc_info>
        <cfset location_info_ = get_location_info(get_expense.department_id,get_expense.location_id,1,1)>
        <cfscript>
            attributes.branch_id="#listlast(location_info_,',')#";
            attributes.department_id="#get_expense.department_id#";
            attributes.location_id="#get_expense.location_id#";
            attributes.location_name="#listfirst(location_info_,',')#";
        </cfscript>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#"> ORDER BY MONEY
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="get_money" datasource="#dsn#">
                SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <cfquery name="get_rows" datasource="#dsn2#">
            SELECT  
                EI.ACCOUNT_CODE EXPENSE_ACCOUNT_CODE,
                EI.TAX_CODE,
                EIPR.*
            FROM 
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS EIPR 
                LEFT JOIN EXPENSE_ITEMS EI ON EIPR.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
            WHERE 
                EXPENSE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
        <cfscript>
            for(stp_mny=1;stp_mny lte get_money.RECORDCOUNT;stp_mny=stp_mny+1)
            {                
                rate1 = get_money.RATE1[stp_mny];
                rate2 = get_money.RATE2[stp_mny];
                money = get_money.MONEY[stp_mny];
                deger_money = get_rows.money_currency_id;
                'attributes.hidden_rd_money_#stp_mny#'=get_money.MONEY[stp_mny];
                'attributes.txt_rate1_#stp_mny#'=rate1;	
                'attributes.txt_rate2_#stp_mny#'=rate2; 
                if (deger_money eq money){  
                    'attributes.hidden_rd_money_#stp_mny#'=get_money.MONEY[stp_mny];
                    'attributes.txt_rate1_#stp_mny#'=rate1;	
                    'attributes.txt_rate2_#stp_mny#'=rate2;             
                    attributes.rd_money= '#money#,#stp_mny#,#rate1#,#rate2#';                     
                }    
                attributes.kur_say = get_money.RECORDCOUNT;           
            }
        </cfscript>
        <cfset expense_center_list = "">
        <cfset expense_item_list = "">
        <cfset subscription_list = "">
        <cfset pyschical_asset_list = "">
        <cfset work_head_list = "">
        <cfset opp_head_list = "">
        <cfset spect_id_list = "">
        <cfif get_rows.recordcount>
            <cfoutput query="get_rows">
                <cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
                    <cfset expense_center_list=listappend(expense_center_list,expense_center_id)>
                </cfif>
                <cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
                    <cfset expense_item_list=listappend(expense_item_list,expense_item_id)>
                </cfif>
                <cfif isdefined("subscription_id") and len(subscription_id) and not listfind(subscription_list,subscription_id)>
                    <cfset subscription_list=listappend(subscription_list,subscription_id)>
                </cfif>
                <cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id) and not listfind(pyschical_asset_list,pyschical_asset_id)>
                    <cfset pyschical_asset_list=listappend(pyschical_asset_list,pyschical_asset_id)>
                </cfif>
                <cfif len(work_id) and not listfind(work_head_list,work_id)>
                    <cfset work_head_list=listappend(work_head_list,work_id)>
                </cfif>
                <cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
                    <cfset opp_head_list=listappend(opp_head_list,opp_id)>
                </cfif>
                <cfif isdefined("spect_var_id") and len(spect_var_id) and not listfind(spect_id_list,spect_var_id)>
                    <cfset spect_id_list=listappend(spect_id_list,spect_var_id)>
                </cfif>
            </cfoutput>
            <cfif ListLen(expense_center_list)>
                <cfquery name="get_expense_center" datasource="#dsn2#">
                    SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
                </cfquery>
                <cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center.expense_id)),'numeric','ASC',',')>
            </cfif>
            <cfif ListLen(expense_item_list)>
                <cfquery name="get_expense_item" datasource="#dsn2#">
                    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
                </cfquery>
                <cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item.expense_item_id)),'numeric','ASC',',')>
            </cfif>
            <cfif ListLen(subscription_list)>
                <cfquery name="get_subscription" datasource="#dsn2#">
                    SELECT SUBSCRIPTION_ID, SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IN (#subscription_list#) ORDER BY SUBSCRIPTION_ID
                </cfquery>
                <cfset subscription_list = ListSort(ListDeleteDuplicates(ValueList(get_subscription.subscription_id)),'numeric','ASC',',')>
            </cfif>
            <cfif ListLen(pyschical_asset_list)>
                <cfquery name="get_pyschical_asset" datasource="#dsn2#">
                    SELECT ASSETP_ID, ASSETP FROM #dsn_alias#.ASSET_P WHERE ASSETP_ID IN (#pyschical_asset_list#) ORDER BY ASSETP_ID
                </cfquery>
                <cfset pyschical_asset_list = ListSort(ListDeleteDuplicates(ValueList(get_pyschical_asset.assetp_id)),'numeric','ASC',',')>
            </cfif>
            <cfif len(work_head_list)>
                <cfquery name="get_work" datasource="#dsn2#">
                    SELECT WORK_ID,WORK_HEAD FROM #dsn_alias#.PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
                </cfquery>
                <cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
            </cfif>
            <cfif len(opp_head_list)>
                <cfquery name="get_opportunities" datasource="#DSN2#">
                    SELECT OPP_ID,OPP_HEAD FROM #dsn3_alias#.OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
                </cfquery>
                <cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
            </cfif>
            <cfif len(spect_id_list)>
                <cfquery name="get_spect_name" datasource="#DSN2#">
                    SELECT SPECT_VAR_NAME,SPECT_VAR_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID IN (#spect_id_list#) ORDER BY SPECT_VAR_ID
                </cfquery>
                <cfset spect_id_list = ListSort(ListDeleteDuplicates(ValueList(get_spect_name.spect_var_id)),'numeric','ASC',',')>
            </cfif>
            <cfset sepet = StructNew()>
            <cfset sepet.kdv_array["rate"] = StructNew()>
            <cfset sepet.kdv_array["kdv_total"] = StructNew()>
            <cfset sepet.otv_array["otv_rate"] = StructNew()>
            <cfset sepet.otv_array["otv_total"] = StructNew()>
            <cfset sepet.bsmv_array["bsmv_rate"] = StructNew()>
            <cfset sepet.bsmv_array["bsmv_total"] = StructNew()>
            <cfset sepet.oiv_array["oiv_rate"] = StructNew()>
            <cfset sepet.oiv_array["oiv_total"] = StructNew()>
            <cfset kdv_total = 0.0>
            <cfset otv_total = 0.0>
            <cfset bsmv_total = 0.0>
            <cfset oiv_total = 0.0>
            <cfset kdv_rate_counter = 0>
            <cfset otv_rate_counter = 0>
            <cfset bsmv_rate_counter = 0>
            <cfset oiv_rate_counter = 0>
            <cfoutput query="get_rows">
                <cfset total_value_ = 0>
                <cfset net_total_value_ = 0>
                <cfset other_net_total_value_ = 0>			<!--- genel doviz toplam (kdv dahil) --->
                <cfset other_net_total_value_kdvsiz_ = 0>	<!--- doviz tutar --->
                <cfset deger_money = "">
                <cfset activity_type_ = "">
                <cfset workgroup_id_ = "">
                <cfset total_value_ = amount>
                <cfset net_total_value_ = total_amount>
                <cfset other_net_total_value_ = other_money_value>
                <cfset deger_money = money_currency_id>
                <cfset activity_type_ = activity_type>
                <cfset workgroup_id_ = "">
                <cfset discount_total = amount>
                <cfset discount_rate = 0>
                <cfset discount_price = 0.0>
                <cfset AMOUNT_BSMV = 0.0>
                <cfset BSMV_CURRENCY = 0.0>
                <cfset AMOUNT_OIV = 0.0>
                <cfset TEVKIFAT_RATE = 0>
                <cfset AMOUNT_TEVKIFAT = 0.0>
                <cfset "attributes.row_kontrol#currentrow#" = 1>
                <cfset "attributes.money_id#currentrow#" = deger_money>
                <cfset "attributes.other_net_total#currentrow#" = other_net_total_value_>
                <cfset "attributes.net_total#currentrow#" = net_total_value_>
                <cfset "attributes.row_detail#currentrow#" = detail>
                <cfset "attributes.expense_item_id#currentrow#" = expense_item_id>
                <cfset "attributes.expense_item_name#currentrow#" = (len(expense_item_id)) ? "#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#":"">
                <cfset "attributes.expense_center_id#currentrow#" = expense_center_id>
                <cfset "attributes.expense_center_name#currentrow#" = (len(expense_center_id)) ? "#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#" : "">
                <cfset "attributes.account_code#currentrow#" = expense_account_code>
                <cfset "attributes.stock_id#currentrow#" = stock_id>
                <cfset "attributes.product_id#currentrow#" = product_id>
                <cfset "attributes.product_name#currentrow#" = (len(product_id)) ? "#get_product_name(product_id)#" : "">
                <cfset "attributes.stock_unit_id#currentrow#" = unit_id>
                <cfset "attributes.stock_unit#currentrow#" = unit>
                <cfset "attributes.quantity#currentrow#" = quantity>
                <cfset "attributes.total#currentrow#" = total_value_>
                <cfset "attributes.kdv_total#currentrow#" = amount_kdv>
                <cfset "attributes.tax_rate#currentrow#" = kdv_rate>
                <cfset "attributes.activity_type#currentrow#" = activity_type_>
                <cfset "attributes.workgroup_id#currentrow#" = workgroup_id_>
                <cfset "attributes.project_id#currentrow#" = project_id>
                <cfset "attributes.project#currentrow#" = (len(project_id)) ? "#get_project_name(project_id)#" : "">
                <cfif isdefined("member_type") and member_type eq 'partner'>
                    <cfset member_type_ = "partner">
                    <cfset member_id_ = company_partner_id>
                    <cfset company_id_= company_id>
                    <cfset authorized_ = get_par_info(company_partner_id,0,-1,0)>
                    <cfset company_ = get_par_info(company_id,1,0,0)>
                <cfelseif isdefined("member_type") and member_type eq 'consumer'>
                    <cfset member_type_ = "consumer">
                    <cfset member_id_ = company_partner_id>
                    <cfset company_id_= "">
                    <cfset authorized_ = get_cons_info(company_partner_id,0,0)>
                    <cfset company_ = get_cons_info(company_partner_id,2,0)>
                <cfelseif isdefined("member_type") and member_type eq 'employee'>
                    <cfset member_type_ = "employee">
                    <cfset member_id_ = company_partner_id>
                    <cfset company_id_= "">
                    <cfset authorized_ = get_emp_info(company_partner_id,0,0)>
                    <cfset company_ = "">
                <cfelse>
                    <cfset member_type_ = "">
                    <cfset member_id_ = "">
                    <cfset company_id_= "">
                    <cfset authorized_ = "">
                    <cfset company_ = "">
                </cfif>
                <cfset "attributes.member_type#currentrow#" = member_type_>
                <cfset "attributes.member_id#currentrow#" = member_id_>
                <cfset "attributes.company_id#currentrow#" = company_id_>
                <cfset "attributes.authorized#currentrow#" = authorized_>
                <cfset "attributes.company#currentrow#" = company_>
                <cfset "attributes.asset_id#currentrow#" = pyschical_asset_id>
                <cfset "attributes.asset#currentrow#" = (len(pyschical_asset_id))? "#get_pyschical_asset.assetp[ListFind(pyschical_asset_list,pyschical_asset_id,',')]#":"">
            </cfoutput>
        </cfif>
        <cfset attributes.record_num = get_rows.recordcount>
        <cfinclude template="../../objects/query/add_collacted_expense_cost.cfm">
	</cfloop>
	<script type="text/javascript">
		<cfoutput>
			alert('Toplam #ListLen(attributes.RequestIdList,',')# Adet Masraf Fişi Kaydedildi!');
		</cfoutput>
	</script>
</cfif>
<script type="text/javascript">
    <cfoutput>
        window.location.href="<cfoutput>#request.self#?fuseaction=cost.list_expense_income&type=120&form_submitted=1&listing_type=1</cfoutput>";
    </cfoutput>
</script>
<cfabort>
