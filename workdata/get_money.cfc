<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_MONEY" datasource="#dsn#">
                SELECT * FROM SETUP_MONEY
                WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
            </cfquery>
          <cfreturn GET_MONEY>
    </cffunction>
</cfcomponent>

