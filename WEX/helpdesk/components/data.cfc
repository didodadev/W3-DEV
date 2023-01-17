<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="insert" access="public">
        <cfargument name="data">
        <cfset response = StructNew() />
        <cftry>
            <cfquery name="q_insert" datasource="#dsn#" result="query_result">	
                INSERT INTO 
                CUSTOMER_HELP (
                    PARTNER_ID,
                    COMPANY_ID,					
                    CONSUMER_ID,
                    APP_CAT,
                    INTERACTION_CAT,
                    INTERACTION_DATE,
                    SUBJECT,
                    PROCESS_STAGE,
                    DETAIL,
                    APPLICANT_NAME,
                    APPLICANT_MAIL,
                    IS_REPLY_MAIL,
                    IS_REPLY,
                    CUSTOMER_TELCODE,
                    CUSTOMER_TELNO,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.partner_id#" null="#not len(arguments.data.partner_id) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.company_id#" null="#not len(arguments.data.company_id) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.consumer_id#" null="#not len(arguments.data.consumer_id) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.app_cat#" null="#not len(arguments.data.app_cat) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.interaction_cat#" null="#not len(arguments.data.interaction_cat) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.data.interaction_date#" null="#not len(arguments.data.interaction_date) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.subject#" null="#not len(arguments.data.subject) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.process_stage#" null="#not len(arguments.data.process_stage) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.detail#" null="#not len(arguments.data.process_stage) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.applicant_name#" null="#not len(arguments.data.process_stage) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.applicant_mail#" null="#not len(arguments.data.process_stage) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.data.is_reply_mail#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.data.is_reply#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.tel_code#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.tel_no#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data.record_emp#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.data.record_date#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data.record_ip#">
                )
            </cfquery>
            <cfset response = { status: true, id: query_result.identitycol } />
        <cfcatch>
            <cfset response = { status: false } />
        </cfcatch>
        </cftry>
        <cfreturn response />
    </cffunction>

</cfcomponent>