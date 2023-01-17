<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name = "run_application" returnType = "any" returnformat = "JSON" access = "public" description = "Update company, period, employee, system parameters and run application">
        <cfargument name="company_fullname" type="string" required="true">
        <cfargument name="company_website" type="string" required="false" default="">
        <cfargument name="company_email" type="string" required="true">
        <cfargument name="company_telcode" type="string" required="true">
        <cfargument name="company_tel1" type="string" required="true">
        <cfargument name="company_tax_office" type="string" required="true">
        <cfargument name="company_tax_no" type="string" required="true">
        <cfargument name="company_address" type="string" required="true">
        <cfargument name="partner_name" type="string" required="true">
        <cfargument name="partner_surname" type="string" required="true">
        <cfargument name="partner_email" type="string" required="true">
        <cfargument name="partner_mobile_telcode" type="string" required="true">
        <cfargument name="partner_mobile_tel" type="string" required="true">
        <cfargument name="partner_password" type="string" required="true">

        <cfset response = StructNew() />

        <cftry>
            <cftransaction>

                <cfquery name="UPD_OUR_COMPANY" datasource="#dsn#">
                    UPDATE OUR_COMPANY
                    SET
                        COMPANY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_fullname#">,
                        NICK_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_fullname#">,
                        MANAGER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.partner_name# #arguments.partner_surname#">,
                        TAX_OFFICE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_tax_office#">,
                        TAX_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_tax_no#">,
                        TEL_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_telcode#">,
                        TEL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_tel1#">,
                        WEB = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_website#" null = "#not len(arguments.company_website) ? 'yes' : 'no'#">,
                        EMAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_email#">,
                        ADDRESS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_address#">,
                        ADMIN_MAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.partner_email#">
                    WHERE COMP_ID = 1
                </cfquery>

                <cfquery name="UPD_SETUP_PERIOD" datasource="#dsn#">
                    UPDATE SETUP_PERIOD
                    SET
                        PERIOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_fullname# - #year(now())#">,
                        PERIOD_YEAR = #year(now())#,
                        PERIOD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/#year(now())#">,
                        START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/#year(now())#">,
                        PROCESS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/#year(now())#">,
                        FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="31/12/#year(now())#">
                    WHERE PERIOD_ID = 1
                </cfquery>

                <cf_cryptedpassword password="#arguments.partner_password#" output="userPassword" mod="1">

                <cfquery name="UPD_EMPLOYEES" datasource="#dsn#">
                    UPDATE EMPLOYEES
                    SET EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#userPassword#">
                </cfquery>

            </cftransaction>
            <cfset response = { status: true } />
            <cfcatch type="any">
                <cfset response = { status: false, message: 'Revize site bilgileri güncellenirken bir hata oluştu', catch: cfcatch } />
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(response),'//','')>
    </cffunction>
</cfcomponent>