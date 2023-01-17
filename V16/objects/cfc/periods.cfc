<cfcomponent><!---Ortak period query'leri için oluşturulmuştur. ERU27062019---->
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_PERIOD_YEAR" access="public" returntype="query">
		<cfquery name="GET_PERIOD_YEAR" datasource="#dsn#">
			SELECT DISTINCT(PERIOD_YEAR)  FROM SETUP_PERIOD
		</cfquery>
		<cfreturn GET_PERIOD_YEAR>
	</cffunction>
</cfcomponent>