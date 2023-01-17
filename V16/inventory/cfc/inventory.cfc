<!--- 
    Author : Melek KOCABEY
    Create Date : 10/05/2022
    Desc :  COMPONENT ismi inventory
            Tamir Bakım Fişlerini Sabit Kıtmette Dönüştür için yazılmış fonksiyonlar
            inventory modülün genel cfc olarak kullanılabilir.
---> 
<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        date_add = functions.date_add;
        getLang = functions.getLang;
        TLFORMAT = functions.TLFORMAT;
        LISTDELETEDUPLICATES=functions.LISTDELETEDUPLICATES;
        sql_unicode = functions.sql_unicode;
        functions_ = CreateObject("component","cfc.faFunctions");
        muhasebeci = functions_.muhasebeci;
        cfquery = functions.cfquery;
	</cfscript>
    <cfset dsn1 = application.systemParam.systemParam().dsn>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn2_alias = dsn2>
    <cfset DSN3_ALIAS  = dsn3>
    <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
<cffunction name="GetMaintennanceValuation" returntype="query">
    <cfquery name="GetAssetInventory" datasource="#DSN2#">
        SELECT P.ASSETP_ID FROM #dsn3#.INVENTORY I JOIN #dsn#.ASSET_P P ON  I.INVENTORY_ID = P.INVENTORY_ID
    </cfquery>
    <cfset asset_list = valuelist(GetAssetInventory.ASSETP_ID)>
    <cfquery name="GetMaintennanceValuation" datasource="#DSN2#">
            SELECT
                P.ASSETP_ID,
                I.INVENTORY_ID,
                EIR.PROJECT_ID,
                EIR.BRANCH_ID,
                I.INVENTORY_NAME,
                P.ASSETP,
                I.INVENTORY_NUMBER,
                (EIR.AMOUNT*EIR.QUANTITY) AS AMOUNT,
	            (EIR.OTHER_MONEY_VALUE_2*EIR.QUANTITY) AS AMOUNT_2,
                EIR.EXPENSE_DATE,
                EIR.DETAIL,
                (SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = EIR.EXPENSE_ID) AS PAPER_NO,
                (SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_CENTER.EXPENSE_ID = EIR.EXPENSE_CENTER_ID) EXPENSE_NAME,
                EIR.EXPENSE_ACCOUNT_CODE,
                (SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEMS.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID) ITEM_NAME,
                EIR.EXPENSE_ITEM_ID,
                EIR.EXPENSE_ID,
                EIR.EXP_ITEM_ROWS_ID,
                B.BRANCH_NAME,
                EIR.IS_INVENTORY_ASSET_VALUATION
            FROM 
                #dsn#.ASSET_P P
                JOIN EXPENSE_ITEMS_ROWS EIR ON EIR.PYSCHICAL_ASSET_ID= P.ASSETP_ID
                JOIN #dsn3#.INVENTORY I ON  I.INVENTORY_ID = P.INVENTORY_ID
                LEFT JOIN #dsn#.DEPARTMENT D ON P.DEPARTMENT_ID = D.DEPARTMENT_ID
                LEFT JOIN #dsn#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            WHERE
                <cfif IsDefined("arguments.is_valuation") and len(arguments.is_valuation)>
                    EIR.IS_INVENTORY_ASSET_VALUATION  IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.is_valuation#" list="yes">) AND
                <cfelse>
                    EIR.IS_INVENTORY_ASSET_VALUATION  = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> AND
                </cfif>
                <cfif IsDefined("arguments.branch_id") and len(arguments.branch_id) and IsDefined("arguments.branch") and len(arguments.branch)>
                    B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> AND
                </cfif>
                <cfif IsDefined("arguments.project_id") and len(arguments.project_id) and IsDefined("arguments.project_head") and len(arguments.project_head)>
                    EIR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> AND
                </cfif>
                EIR.INVENTORY_ID IS NULL AND
                EIR.EXPENSE_COST_TYPE = ISNULL((SELECT PROCESS_TYPE FROM #dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="122"> AND IS_INVENTORY_VALUATION = <cfqueryparam cfsqltype="cf_sql_integer" value="1">),0) and
                EIR.PYSCHICAL_ASSET_ID IN (#asset_list#)
                <cfif IsDefined("arguments.inventory_id") and len(arguments.inventory_id)>
                    AND I.INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_id#">
                </cfif>
            ORDER BY 
                I.INVENTORY_NAME
    </cfquery>
    <cfreturn GetMaintennanceValuation>
</cffunction>
<cffunction name="GetInvent" returntype="query">
    <cfquery name="GetInvent" datasource="#DSN3#">
        SELECT 
            INVENTORY_NAME,
            INVENTORY_NUMBER,
            (AMOUNT*QUANTITY) AS AMOUNT,
            (ISNULL(AMOUNT_2*QUANTITY,0)) AS AMOUNT_2,
            (LAST_INVENTORY_VALUE) LAST_INVENTORY_VALUE,
            (ISNULL(LAST_INVENTORY_VALUE_2,0)) AS LAST_INVENTORY_VALUE_2,
            AMORTIZATON_METHOD,
            AMORTIZATON_ESTIMATE,
            INVENTORY_DURATION,
            ACCOUNT_PERIOD,
            ENTRY_DATE,
            INVENTORY_CATID,
            AMORTIZATION_TYPE,
            AMORTIZATON_ESTIMATE,
            ACCOUNT_PERIOD,
            ACCOUNT_ID,
            EXPENSE_ITEM_ID,
            EXPENSE_CENTER_ID,
            QUANTITY,
            (SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = INVENTORY.INVENTORY_CATID) CAT_NAME
        FROM 
            INVENTORY
        WHERE
            INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_id#">
    </cfquery>
    <cfreturn GetInvent>
</cffunction>
<cffunction name="ValuationInvent" returntype="query">
    <cfquery name="ValuationInvent" datasource="#DSN3#">
        SELECT 
            (SELECT INVENTORY_NAME FROM INVENTORY I WHERE IV.OLD_INVENTORY_ID = I.INVENTORY_ID) OLD_INVENTORY_NAME,
            (SELECT INVENTORY_NAME FROM INVENTORY I WHERE IV.NEW_INVENTORY_ID = I.INVENTORY_ID) NEW_INVENTORY_NAME,
            (SELECT INVENTORY_ID FROM INVENTORY I WHERE IV.NEW_INVENTORY_ID = I.INVENTORY_ID) INVENTORY_ID,
            (SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT STP WHERE IV.ACTION_TYPE = STP.PROCESS_TYPE ) PROCESS_NAME,
             (SELECT (AMOUNT*QUANTITY) FROM INVENTORY I WHERE IV.OLD_INVENTORY_ID = I.INVENTORY_ID) AMOUNT,
             (SELECT INVENTORY_NUMBER FROM INVENTORY I WHERE IV.NEW_INVENTORY_ID = I.INVENTORY_ID) INVENTORY_NUMBER,
            PAPER_NO,
            IV.NEW_INVENTORY_MONEY,
            IV.NEW_VALUE_OTHER_MONEY,
            IV.VALUATION_DATE,
            IV.OLD_INVENTORY_MONEY,
            IV.VALUATION_METHOD,
            IV.NEW_VALUE_MONEY 
        FROM 
            INVENTORY_VALUATION AS IV 
    </cfquery>
    <cfreturn ValuationInvent>
</cffunction>
<cffunction name="AddValuationInventory" access="public" returntype="struct" output="false" hint="Demirbaş Yeniden Değerleme İşlemleri">
    <cfset arguments.newValue = (arguments.calculativeMethod eq 0) ? (arguments.newValue + arguments.OldInventoryMoney) : arguments.newValue>
    <cfset arguments.newValue_ = (arguments.calculativeMethod eq 0) ? (arguments.newValue_ + arguments.OldInventoryMoney_) : arguments.newValue_>
    <cflock name="#CreateUUID()#" timeout="20">
        <cftransaction>
            <cftry>
                <cfif len(session.ep.money2)>
                    <cfquery name="get_money" datasource="#dsn3#">
                        SELECT RATE1, RATE2 FROM #dsn2#.SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfquery>
                    <cfset currency_multiplier = get_money.rate2/get_money.rate1>
                <cfelse>
                    <cfset currency_multiplier = ''>
                </cfif>
                <cfquery name="ADD_INVENT" datasource="#dsn3#" result="Inventresult">
                    INSERT INTO 
                        INVENTORY
                        (
                            INVENTORY_NUMBER,
                            INVENTORY_NAME,
                            QUANTITY,
                            AMOUNT,
                            AMOUNT_2,
                            AMORTIZATON_ESTIMATE,
                            AMORTIZATON_METHOD,
                            LAST_INVENTORY_VALUE,
                            LAST_INVENTORY_VALUE_2,
                            AMORT_LAST_VALUE,
                            ACCOUNT_ID,
                            ACCOUNT_PERIOD,
                            EXPENSE_CENTER_ID,
                            EXPENSE_ITEM_ID,
                            AMORTIZATION_COUNT,
                            ENTRY_DATE,
                            INVENTORY_DURATION,
                            INVENTORY_DURATION_IFRS,
                            AMORTIZATION_TYPE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            INVENTORY_TYPE,
                            INVENTORY_CATID
                        )
                        VALUES
                        (
                            <cfif len(arguments.paperNo)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paperNo#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(arguments.inventName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inventName#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value=""null="yes"></cfif>,
                            <cfif IsDefined("arguments.quantity") and len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="1"></cfif>,
                            <cfif len(arguments.newValue)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                            <cfif len(arguments.newValue_)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue_)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                            <cfif len(arguments.amortization_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arguments.amortization_rate)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.amor_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amor_method#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.newValue)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                            <cfif len(arguments.newValue_)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue_)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                            <cfif len(arguments.newValue)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                            <cfif len(arguments.account_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.account_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.amortization_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amortization_period#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.expense_center_id) and len(arguments.expense_center_id) ><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value=""null="yes"></cfif>,
                            <cfif len(arguments.expense_item_name) and len(arguments.expense_item_id) ><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value=""null="yes"></cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                            <cfif len(arguments.entryDate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.entryDate#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value=""null="yes"></cfif>,
                            <cfif len(arguments.inventory_duration)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_duration#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.inventory_duration_ifrs)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_duration_ifrs#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(arguments.amortization_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amortization_type_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="2">,
                            <cfif len(arguments.inventory_cat_id) and len(arguments.inventory_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_cat_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>
                        )
                </cfquery>
                <cfquery name="get_type" datasource="#dsn3#">
                    SELECT PROCESS_TYPE,IS_ACCOUNT,IS_BUDGET,IS_ACCOUNT_GROUP FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
                </cfquery>
                <cfquery name="Add_Valuation" datasource="#dsn3#" result="my_result">
                    INSERT INTO
                        INVENTORY_VALUATION
                            (
                                OLD_INVENTORY_ID,
                                NEW_INVENTORY_ID,
                                OLD_INVENTORY_MONEY,
                                NEW_INVENTORY_MONEY,
                                VALUATION_DATE,
                                VALUATION_METHOD,
                                AMORTIZATION_TYPE,
                                AMORTIZATION_COUNT,
                                USEABLE_TIME,
                                PROCESS_CAT,
                                ACTION_TYPE,
                                PROCESS_STAGE,
                                PAPER_NO,
                                VALUATION_EMP_ID,
                                VALUATION_DETAIL,
                                NEW_VALUE_MONEY,
                                NEW_VALUE_OTHER_MONEY
                            )
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Inventresult.IDENTITYCOL#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OldInventoryMoney)#">,
                                <cfif len(arguments.newValue)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                                <cfif len(arguments.entryDate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.entryDate#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(arguments.calculativeMethod)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.calculativeMethod#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(arguments.amortization_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amortization_type_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#amor_count#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#amor_usabled#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_type.process_type#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                                <cfif len(arguments.paperNo)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paperNo#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                                <cfif len(arguments.invent_employee_id) and len(arguments.invent_employee)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invent_employee_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(arguments.detailİnvent)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detailİnvent#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                                <cfif len(arguments.newValue)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                                <cfif len(arguments.newValue_)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.newValue_)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>
                            )
                </cfquery>
                <cfif arguments.calculativeMethod eq 0>
                    <cfquery name="ADD_INVENT_MAIN" datasource="#dsn3#" result="MAX_ID">
                        INSERT INTO
                            INVENTORY_AMORTIZATION_MAIN
                            (
                                PROCESS_TYPE,
                                PROCESS_CAT,
                                ACTION_DATE,
                                DETAIL,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_type.process_type#">,
                                <cfif len(arguments.entryDate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.entryDate#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value=""null="yes"></cfif>,
                                <cfif len(arguments.detailİnvent)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detailİnvent#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                            )
                    </cfquery>
                    <cfquery name="ADD_AMORTIZATION" datasource="#dsn2#">
						INSERT INTO
							INVENTORY_AMORTIZATON
							(
								INVENTORY_ID,
								INV_AMORT_MAIN_ID,
								AMORTIZATON_VALUE,
								PERIODIC_AMORT_VALUE,
								AMORTIZATON_METHOD,
								AMORTIZATON_YEAR,
								AMORTIZATON_ESTIMATE,
								AMORTIZATON_INV_VALUE,
								ACCOUNT_PERIOD,
                                INVENTORY_VALUATION_ID
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OldInventoryMoney)#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OldInventoryMoney)#">,
								<cfif len(arguments.amor_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amor_method#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
								#Year(arguments.entryDate)#,
								<cfif len(arguments.amortization_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arguments.amortization_rate)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
								<cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OldInventoryMoney)#">,
								<cfif len(arguments.amortization_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amortization_period#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#my_result.IDENTITYCOL#">,
 							)
					</cfquery>
                    <cfquery name="UPD_INVENTORY" datasource="#dsn3#">
                        UPDATE
                            INVENTORY
                        SET
                            LAST_INVENTORY_VALUE = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                            LAST_INVENTORY_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        WHERE
                            INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_id#">
                    </cfquery>
                </cfif>
                <cfquery name="UpdExpenseRow" datasource="#dsn3#">
                    UPDATE #dsn2#.EXPENSE_ITEMS_ROWS SET IS_INVENTORY_ASSET_VALUATION = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> WHERE EXPENSE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expenseIdList#" list="yes">) AND EXP_ITEM_ROWS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ExpRowIdList#" list="yes">)
                </cfquery>
                <cfquery name="getExpenseRowAcc" datasource="#dsn3#">
                    SELECT EXPENSE_ACCOUNT_CODE,SUM(AMOUNT) AS AMOUNT, SUM(OTHER_MONEY_VALUE_2) AS other_amount, MONEY_CURRENCY_ID_2 FROM #dsn2#.EXPENSE_ITEMS_ROWS WHERE EXPENSE_ITEM_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemIdList#" list="yes">) AND  EXPENSE_COST_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="122"> AND EXPENSE_ACCOUNT_CODE IS NOT NULL GROUP BY EXPENSE_ACCOUNT_CODE,MONEY_CURRENCY_ID_2
                </cfquery>
                <cfscript>
                    str_borclu_hesaplar="";
                    str_borclu_tutarlar="";
                    str_dovizli_borclar="";
                    str_other_currency_borc="";
                    is_account = get_type.IS_ACCOUNT;
                    is_budget = get_type.IS_BUDGET;
	                is_account_group = get_type.IS_ACCOUNT_GROUP;
                    netTotal = 0;
                    netTotalOther = 0;
                </cfscript>
                <cfoutput query="getExpenseRowAcc">
                    <cfscript>
                        str_borclu_hesaplar=listappend(str_borclu_hesaplar,EXPENSE_ACCOUNT_CODE);
                        str_borclu_tutarlar=listappend(str_borclu_tutarlar,amount);
                        str_dovizli_borclar=listappend(str_dovizli_borclar,other_amount);      
                        str_other_currency_borc=listappend(str_other_currency_borc,MONEY_CURRENCY_ID_2); 
                        netTotal += amount;    
                        netTotalOther += other_amount;
                    </cfscript>
                </cfoutput>
                <cfscript>
                    if(is_account eq 1)
                    {
                        muhasebeci(
                            action_id : Inventresult.IDENTITYCOL,
                            workcube_process_type : get_type.process_type,
                            workcube_process_cat:arguments.process_cat,
                            account_card_type : 13,
                            islem_tarihi : arguments.entryDate,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_borclu_tutarlar,
                            other_amount_borc : str_dovizli_borclar,
                            other_currency_borc : str_other_currency_borc,
                            alacak_hesaplar : '#arguments.account_code#',
                            alacak_tutarlar : arguments.newValue,
                            other_amount_alacak : arguments.newValue_,
                            other_currency_alacak :#session.ep.money2#,
                            fis_detay : "#arguments.detailİnvent#",
                            fis_satir_detay: UCase(getLang('main',2747)),//AMORTİSMAN YENİDEN DEĞERLEME
                            is_account_group : is_account_group,
                            muhasebe_db: "#dsn3#"
                        );
                    }
                    if(is_budget eq 1)
                    {
                      
                        GetInvent = this.GetInvent(inventory_id : arguments.inventory_id);
                        expense_id = GetInvent.expense_item_id;
                        expense_item = GetInvent.expense_center_id;
                        writedump(expense_item);
                        
                        if (len(expense_id) and len(expense_item))
                        {
                            butceci(
                                action_id : Inventresult.IDENTITYCOL,
                                muhasebe_db : dsn3,
                                is_income_expense : false,
                                process_type : get_type.process_type,
                                nettotal : wrk_round(netTotal),
                                other_money_value : wrk_round(netTotalOther),
                                action_currency : session.ep.money,
                                currency_multiplier : currency_multiplier,
                                expense_date : arguments.entryDate,
                                expense_center_id : expense_id,
                                expense_item_id : expense_item,
                                detail : "#arguments.detailİnvent#",
                                branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                insert_type :1
                                );
                        }
                        if (len(arguments.expense_center_id) and len(arguments.expense_item_id))
                        {
                            butceci(
                                action_id : Inventresult.IDENTITYCOL,
                                muhasebe_db : dsn3,
                                is_income_expense : false,
                                process_type : get_type.process_type,
                                nettotal : wrk_round(arguments.newValue),
                                other_money_value : wrk_round(arguments.newValue/currency_multiplier),
                                action_currency : session.ep.money,
                                currency_multiplier : currency_multiplier,
                                expense_date : arguments.entryDate,
                                expense_center_id : arguments.expense_center_id,
                                expense_item_id : arguments.expense_item_id,
                                detail : "#arguments.detailİnvent#",
                                branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                insert_type :1
                                );
                        }
                    }
                </cfscript>
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = Inventresult.IDENTITYCOL>
            <cfcatch type="database">
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>	
        </cftry>
        </cftransaction>
    </cflock>
    <cfreturn responseStruct>
</cffunction>
</cfcomponent>