<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_STOCK_AMOUNT" datasource="#dsn#">
                SELECT * FROM SETUP_STOCK_AMOUNT
            </cfquery>
          <cfreturn GET_STOCK_AMOUNT>
    </cffunction>
</cfcomponent>

