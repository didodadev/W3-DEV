<cffunction name="login_" returntype="query">
	<cfargument name="username" default="">
    <cfargument name="member_password" default="">
	<cfargument name="career_url_company" default="">
	<cfquery name="LOGIN" datasource="#this.DSN#">
		SELECT
			EA.EMPAPP_ID,
			EA.NAME,
			EA.SURNAME,
			EA.EMAIL,
			EA.EMPAPP_PASSWORD,
			O.COMPANY_NAME,
			O.EMAIL,
			O.NICK_NAME,
			SP.PERIOD_YEAR,
			SP.PERIOD_ID,
			SM.MONEY,
			OI.SPECT_TYPE
		FROM
			EMPLOYEES_APP EA,
			OUR_COMPANY O,
			SETUP_PERIOD SP,
			SETUP_MONEY SM,
			OUR_COMPANY_INFO OI
		WHERE
			EA.EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
			EA.EMPAPP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_password#"> AND
			SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#career_url_company#"> AND
			O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#career_url_company#"> AND
			<!---SP.PERIOD_YEAR = #year(now())# AND--->
			((SP.PERIOD_YEAR = #year(now())# OR YEAR(SP.FINISH_DATE) = #year(now())#) AND (SP.FINISH_DATE IS NULL OR (SP.FINISH_DATE IS NOT NULL AND SP.FINISH_DATE >= #createdate(year(now()),month(now()),1)#))) AND
			SP.PERIOD_ID = SM.PERIOD_ID AND
			SM.RATE1 = SM.RATE2 AND
			OI.COMP_ID = O.COMP_ID
	</cfquery>
	<cfreturn LOGIN/>
</cffunction>

<cffunction name="GET_CP_MENU_" returntype="query">
		<cfquery name="GET_CP_MENU" datasource="#this.DSN#" maxrows="1">
		SELECT MENU_ID,MENU_STYLE FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_TYPE = 3 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> ORDER BY MENU_ID DESC
	</cfquery>
	<cfreturn GET_CP_MENU>
</cffunction>

<cffunction name="GET_PERIOD_YEAR_" returntype="query">
	<cfargument name="period_id" default="">
	<cfquery name="GET_PERIOD_YEAR" datasource="#this.DSN#">
		SELECT PERIOD_YEAR,IS_INTEGRATED,PERIOD_DATE FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
	</cfquery>
	<cfreturn GET_PERIOD_YEAR>
</cffunction>

