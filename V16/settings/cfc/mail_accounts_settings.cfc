<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="Insert" access="public" returnType="any">
        <cfargument name="mail_account" type="string" default="">
        <cfargument name="mail_password" type="string" default="">
        <cfargument name="mail_account_quota" type="numeric" default="">
        <cfargument name="is_active" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="is_authorized" default="">
        <!--- <cfdump var="#arguments#" abort> --->
        <cfquery name="ADD_MAIL_ACCOUNT" datasource="#dsn#" result="result">
            INSERT INTO
                WRK_MAIL_ACCOUNTS_SETTINGS
                (
                    SERVER_NAME_ID,
                    MAIL_ACCOUNT,
                    MAIL_PASSWORD,
                    MAIL_ACCOUNT_QUOTA,
                    IS_ACTIVE,
                    USER_ID,
                    IS_AUTHORIZED,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_name_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail_account#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail_password#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_account_quota#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_authorized#">,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
                )
        </cfquery>
        <cfset response = result>
        <cfreturn response>
    </cffunction>
    <cffunction name="Update" access="public">
        <cfargument name="mail_account_id" type="numeric">
        <cfargument name="is_active"  default="">
        <cfargument name="is_authorized" default="">
        <cfquery name="UPD_MAIL_ACCOUNT" datasource="#dsn#">
            UPDATE
                WRK_MAIL_ACCOUNTS_SETTINGS
            SET
                
                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                IS_AUTHORIZED = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_authorized#">,
                UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE= #now()#
            WHERE
				MAIL_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_account_id#">
        </cfquery>
    </cffunction>
    <cffunction name="Select" access="public">
        <cfargument name="server_name_id" type="numeric">
        <cfargument name="mail_account_id" type="numeric">
        <cfargument name="mail_account" type="string" default="">
        <cfargument name="mail_password" type="string" default="">
        <cfargument name="mail_account_quota" type="numeric">
        <cfargument name="is_active" default="">
        <cfargument name="is_authorized" default="">
        <cfquery name="GET_MAIL_ACCOUNT" datasource="#dsn#">
            SELECT 
				*,WRK_MAIL_ACCOUNTS_SETTINGS.MAIL_ACCOUNT +'@'+  MAIL_SERVER_SETTINGS.SERVER_NAME as EMAIL_ADRESS
			FROM
				WRK_MAIL_ACCOUNTS_SETTINGS INNER JOIN MAIL_SERVER_SETTINGS
            ON
                WRK_MAIL_ACCOUNTS_SETTINGS.SERVER_NAME_ID = MAIL_SERVER_SETTINGS.SERVER_NAME_ID
            WHERE
            1 = 1
			<cfif isDefined('arguments.mail_account') and len(arguments.mail_account)>
                AND WRK_MAIL_ACCOUNTS_SETTINGS.MAIL_ACCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.mail_account#%">
            </cfif>
            <cfif isDefined('arguments.mail_account_id') and len(arguments.mail_account_id)>
                AND WRK_MAIL_ACCOUNTS_SETTINGS.MAIL_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_account_id#">
            </cfif>
        </cfquery>
        <cfreturn GET_MAIL_ACCOUNT>
    </cffunction>
    <cffunction name="SelectSN" access="public" returnType="any">
        <cfargument name="server_name_id" type="numeric">
        <cfquery name="GET_MAIL_SERVER" datasource="#dsn#">
			SELECT 
				*
			FROM
				MAIL_SERVER_SETTINGS
            WHERE
				1=1
				<!--- <cfif isDefined('arguments.server_name') and len(arguments.server_name)>AND SERVER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.server_name#%"></cfif> --->
				<cfif isDefined('arguments.server_name_id') and len(arguments.server_name_id)>AND SERVER_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_name_id#"></cfif>
		</cfquery>
        <cfreturn GET_MAIL_SERVER>
    </cffunction>
    <cffunction name="Delete" access="public">
		<cfquery name="DEL_MAIL_ACCOUNT" datasource="#dsn#">
			DELETE
			FROM
				WRK_MAIL_ACCOUNTS_SETTINGS
			WHERE
				MAIL_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_account_id#">
		</cfquery>
	</cffunction>
</cfcomponent>