<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn />
    <cffunction name="setUpgradeInfo" returnFormat="JSON" returnType="any" access="remote">
        <cfargument name="subscription_no" required="true">
        <cfargument name="domain" default="">
        <cfargument name="release" default="">
        <cfargument name="branch" default="">
        <cfargument name="upgrade_date" default="">
        <cfargument name="upgrade_type" default="">
        <cfargument name="upgrade_emp_id" default="">
        <cfargument name="upgrade_user_name_surname" default="">
        <cfargument name="upgrade_user_email" default="">

        <cfquery name="setUpgradeInfo" datasource="#dsn#">
            INSERT INTO SUBSCRIPTION_UPGRADES(
                    SUBSCRIPTION_NO,
                    DOMAIN,
                    RELEASE,
                    BRANCH,
                    UPGRADE_DATE,
                    UPGRADE_TYPE,
                    UPGRADE_EMP_ID,
                    UPGRADE_USER_NAME_SURNAME,
                    UPGRADE_USER_EMAIL
                    )
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.subscription_no#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.domain#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.release#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.branch#'>,
                    <cfqueryparam cfsqltype='CF_SQL_DATETIME' value='#NOW()#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.upgrade_type#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.upgrade_emp_id#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.upgrade_user_name_surname#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.upgrade_user_email#'>,
                )
        </cfquery>
    </cffunction>
</cfcomponent>