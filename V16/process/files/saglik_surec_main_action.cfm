<!---
    Author: Workcube - Botan Kaygan <botankaygan@workcube.com>
    Date: 30.04.2020
    Description:
        Sağlık Harcaması sürecine main action file olarak eklenecektir.
        Workflowdan aşama id'ye göre seçilen anlaşmalı kurumlar için gruplama yapılarak ödeme talebi oluşturur ve workflow kaydı oluşturur.
        Workflowdan aşama id'ye göre seçilen harcamalar için ödendi bilgisini ve ödeme tarihini tabloya kayıt eder. 
        Belge bazlı, workflow'dan veya toplu onayda süreç aşamalarında ilgili sağlık harcamasının onaylandı veya ödendi alanlarını günceller.
--->
<cfset onay_asama_id = "167"> <!--- Sağlık harcamasının onaylandı olarak işaretleneceği aşama id : Muhasebe Onayında aşamasının idsi verildi --->
<cfset red_asama_id = "170"> <!--- Sağlık harcamasının red olarak işaretleneceği aşama id : Red aşamasının idsi verildi --->
<cfset odeme_asama_id = "254"> <!--- Sağlık harcamasının ödendi olarak işaretleneceği aşama id : Tamamlandı aşamasının idsi verildi --->
<cfset basvuru_asama_id = "77"> <!--- Sağlık harcamasının is_approbe'un 0 olarak updatei : Başvuru aşamasının idsi verildi --->

<cfquery name="get_period" datasource="#caller.dsn#">
    SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #session.ep.period_year - 1#
</cfquery>
<cfif get_period.recordCount>
    <cfset period_db = "#caller.dsn#_#session.ep.period_year - 1#_#session.ep.company_id#">
<cfelse>
    <cfset period_db = "">
</cfif>

<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfset use_dsn = caller.dsn2>
    <cfquery name="expense_control" datasource="#caller.dsn2#">
        SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.action_id#
    </cfquery>
    <cfif not expense_control.recordCount>
        <cfif len(period_db)>
            <cfquery name="gecmis_expense_control" datasource="#period_db#">
                SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.action_id#
            </cfquery>
            <cfif gecmis_expense_control.recordCount>
                <cfset use_dsn = period_db>
            </cfif>
        </cfif>
    </cfif>
    <cfif attributes.process_stage eq onay_asama_id>
        <cfquery name="upd_is_approve" datasource="#use_dsn#">
            UPDATE EXPENSE_ITEM_PLAN_REQUESTS SET IS_APPROVE = 1 WHERE EXPENSE_ID = #attributes.action_id#
        </cfquery>
    <cfelseif attributes.process_stage eq red_asama_id>
        <cfquery name="pd_is_approve" datasource="#use_dsn#">
            UPDATE EXPENSE_ITEM_PLAN_REQUESTS SET IS_APPROVE = 0 WHERE EXPENSE_ID = #attributes.action_id#
        </cfquery>
	<cfelseif attributes.process_stage eq odeme_asama_id>
        <cfquery name="upd_is_payment" datasource="#use_dsn#">
            UPDATE EXPENSE_ITEM_PLAN_REQUESTS SET IS_PAYMENT = 1 WHERE EXPENSE_ID = #attributes.action_id#
        </cfquery>
    </cfif>
</cfif>

<cfif caller.attributes.fuseaction eq 'myhome.emptypopup_upd_list_warning'> <!--- Workflowdan tetiklendiğinde çalışacak --->
    <!--- Süreç Muhasebe Onay ise ödeme tarihi ve is_payment alanları set edilecek --->
    <cfif caller.get_warnings.recordcount and caller.get_warnings.ACTION_STAGE_ID eq 683> <!--- Test sistemine bu aşamanın idsi ödeme aşaması olarak atandı. --->
        <!--- Toplu onay kontrolü - toplu onay varsa çalışacak --->
        <cfif len(getGeneralPaper.ACTION_LIST_ID) and actionListCounter eq listLen(getGeneralPaper.ACTION_LIST_ID)>
            <cfset id_list = getGeneralPaper.ACTION_LIST_ID>
        <cfelse>
            <cfset id_list = ''>
        </cfif>
        <cfif len(id_list) >
            <cfset use_dsn = caller.dsn2>
            <cfquery name="expense_control" datasource="#caller.dsn2#">
                SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID IN (#id_list#)
            </cfquery>
            <cfif expense_control.recordCount neq listLen(id_list)>
                <cfif len(period_db)>
                    <cfquery name="gecmis_expense_control" datasource="#period_db#">
                        SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID IN (#id_list#)
                    </cfquery>
                    <cfif gecmis_expense_control.recordCount eq listLen(id_list)>
                        <cfset use_dsn = period_db>
                    </cfif>
                </cfif>
            </cfif>
            <cfquery name="upd_payment_date" datasource="#use_dsn#">
                UPDATE
                    EXPENSE_ITEM_PLAN_REQUESTS 
                SET
                    PAYMENT_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                    EXPENSE_ID IN (#id_list#)
            </cfquery>
        </cfif>
    </cfif>
    <!--- Süreç İK Onay ise onaylandığında Ödeme talebi ve buna ilişkin workflow kaydını oluşturur --->
    <cfif caller.get_warnings.recordcount and caller.get_warnings.ACTION_STAGE_ID eq 683> <!--- İK Onay aşamasının idsi verildi --->
        <!--- Toplu onay kontrolü - toplu onay varsa çalışacak --->
        <cfif len(getGeneralPaper.ACTION_LIST_ID) and actionListCounter eq listLen(getGeneralPaper.ACTION_LIST_ID)>
            <cfset id_list = getGeneralPaper.ACTION_LIST_ID>
        <cfelse>
            <cfset id_list = ''>
        </cfif>
        <cfif len(id_list)>
            <cfset use_dsn = caller.dsn2>
            <cfquery name="expense_control" datasource="#caller.dsn2#">
                SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID IN (#id_list#)
            </cfquery>
            <cfif expense_control.recordCount neq listLen(id_list)>
                <cfif len(period_db)>
                    <cfquery name="gecmis_expense_control" datasource="#period_db#">
                        SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID IN (#id_list#)
                    </cfquery>
                    <cfif gecmis_expense_control.recordCount eq listLen(id_list)>
                        <cfset use_dsn = period_db>
                    </cfif>
                </cfif>
            </cfif>
            <!--- Gelen e fatura mı değil mi kontrol. Çünkü sadece anlaşmalı kurumlar için ödeme talebi oluşturulacak --->
            <cfquery name="cari_control" datasource="#use_dsn#">
                SELECT 
                    INVOICE_NO 
                FROM 
                    EXPENSE_ITEM_PLAN_REQUESTS 
                WHERE 
                    EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(id_list,1)#">
            </cfquery>
            <cfif len(cari_control.INVOICE_NO)>
                <cfset type = 1>
            <cfelse>
                <cfset type = ''>
            </cfif>
            <cfif len(type) and type eq 1>
                <cfquery name="getExpenses" datasource="#use_dsn#">
                    SELECT 
                        COMPANY_ID, SUM(NET_TOTAL_AMOUNT) AS NET_TOTAL_AMOUNT, SUM(TREATMENT_AMOUNT) AS TREATMENT_AMOUNT 
                    FROM 
                        EXPENSE_ITEM_PLAN_REQUESTS
                    WHERE
                        EXPENSE_ID IN (#id_list#)
                    GROUP BY 
                        COMPANY_ID
                </cfquery>
                <cfif getExpenses.recordCount>
                    <cfoutput query="getExpenses">
                        <!--- Cari Bazlı Banka Ödeme Talebi Oluşturma --->
                        <cfquery name="ADD_CARI_CLOSED" datasource="#caller.DSN2#">
                            INSERT INTO 
                                CARI_CLOSED
                            (	
                                PROCESS_STAGE, <!--- onayın idsi --->
                                COMPANY_ID,
                                OTHER_MONEY,
                                IS_DEMAND,
                                PAYMENT_DEBT_AMOUNT_VALUE,
                                PAYMENT_CLAIM_AMOUNT_VALUE,
                                PAYMENT_DIFF_AMOUNT_VALUE,
                                ACTION_DETAIL,
                                PAPER_ACTION_DATE,
                                PAPER_DUE_DATE,
                                IS_BANK_ORDER,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                193, <!--- Ödeme talebi onay aşama idsi --->
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#COMPANY_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="TL">,
                                1,
                                0,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#NET_TOTAL_AMOUNT#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#-1*NET_TOTAL_AMOUNT#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.get_warnings.GENERAL_PAPER_NOTICE#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                0,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                            )
                        </cfquery>
                        <cfquery name="GET_MAX_CLOSED" datasource="#caller.DSN2#">
                            SELECT MAX(CLOSED_ID) AS CLOSED_ID FROM CARI_CLOSED
                        </cfquery>
                        <cfquery name="ADD_CARI_CLOSED_ROW" datasource="#caller.DSN2#">
                            INSERT INTO
                                CARI_CLOSED_ROW
                            (
                                CLOSED_ID,
                                CARI_ACTION_ID,
                                ACTION_ID,
                                ACTION_TYPE_ID,
                                ACTION_VALUE,
                                PAYMENT_VALUE,
                                OTHER_PAYMENT_VALUE,
                                OTHER_MONEY,
                                DUE_DATE
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_closed.closed_id#">,
                                0,
                                0,
                                0,
                                0,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#getExpenses.NET_TOTAL_AMOUNT#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#getExpenses.NET_TOTAL_AMOUNT#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="TL">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                            )
                        </cfquery>
                        <!--- Workflow kaydı --->
                        <cfset odeme_talep_str = "Ödeme Talebi : #get_max_closed.closed_id#">
                        <cfquery name="add_Page_Warnings" datasource="#caller.dsn#">
                            INSERT INTO
                                PAGE_WARNINGS
                                (
                                    URL_LINK,
                                    WARNING_HEAD,
                                    SETUP_WARNING_ID, <!---- değişecek. Ödeme talebi onayın idsi --->
                                    WARNING_DESCRIPTION,
                                    POSITION_CODE,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP,
                                    IS_ACTIVE,
                                    IS_PARENT,
                                    RESPONSE_ID,
                                    WARNING_PROCESS,
                                    OUR_COMPANY_ID,
                                    PERIOD_ID,
                                    ACTION_TABLE,
                                    ACTION_COLUMN,
                                    ACTION_ID,
                                    ACTION_STAGE_ID, <!---- değişecek. Ödeme talebi onayın idsi --->
                                    IS_CONFIRM,
                                    IS_AGAIN,
                                    IS_SUPPORT,
                                    IS_CANCEL,
                                    IS_APPROVE_ALL_CHECKERS,
                                    IS_REFUSE,
                                    IS_CONFIRM_FIRST_CHIEF,
                                    IS_CONFIRM_SECOND_CHIEF,
                                    SENDER_POSITION_CODE
                                )
                            VALUES
                                (
                                    'index.cfm?fuseaction=correspondence.list_payment_actions_demand',
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#odeme_talep_str#">,
                                    193, <!--- Ödeme talebi onay aşama idsi --->
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.get_warnings.GENERAL_PAPER_NOTICE#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    1,
                                    1,
                                    0,
                                    1,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                                    'CARI_CLOSED',
                                    'CLOSED_ID',
                                    #get_max_closed.closed_id#,
                                    193, <!--- Ödeme talebi onay aşama idsi --->
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                )
                        </cfquery>
                        <cfquery name="Get_Max_Warnings" datasource="#caller.dsn#">
                            SELECT MAX(W_ID) MAX FROM PAGE_WARNINGS
                        </cfquery>
                        <cfquery name="Upd_Warnings" datasource="#caller.dsn#">
                            UPDATE PAGE_WARNINGS SET PARENT_ID = #Get_Max_Warnings.Max# WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Max_Warnings.Max#">
                        </cfquery>
                        <cfquery name="Add_Warning_Actions" datasource="#caller.dsn#">
                            INSERT INTO
                            PAGE_WARNINGS_ACTIONS
                            (
                                WARNING_ID,
                                ACTION_TABLE,
                                ACTION_COLUMN,
                                ACTION_STAGE_COLUMN,
                                ACTION_STAGE_ID, <!---- değişecek. Ödeme talebi kaydın idsi --->
                                ACTION_ID,
                                OUR_COMPANY_ID,
                                PERIOD_ID,
                                IS_CONFIRM,
                                CONFIRM_POSITION_CODE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                ACTION_DB,
                                URL_LINK,
                                WARNING_DESCRIPTION,
                                IS_AGAIN,
                                IS_SUPPORT,
                                IS_CANCEL,
                                IS_REFUSE
                            )
                            VALUES
                            (
                                #Get_Max_Warnings.Max#,
                                'CARI_CLOSED',
                                'CLOSED_ID',
                                'PROCESS_STAGE',
                                36,
                                #get_max_closed.closed_id#,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                                1,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#caller.dsn2#">,
                                'index.cfm?fuseaction=correspondence.list_payment_actions_demand',
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#odeme_talep_str#">,
                                0,
                                0,
                                0,
                                0
                            )
                        </cfquery>
                    </cfoutput>
                </cfif>
            </cfif>
        </cfif>
    </cfif>
</cfif>