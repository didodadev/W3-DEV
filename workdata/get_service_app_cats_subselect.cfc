<cfcomponent>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_SERVICE_APP_CATS_SUBSELECT" datasource="#this.dsn3#">
            SELECT SERVICECAT_ID,SERVICECAT,IS_INTERNET FROM SERVICE_APPCAT
        </cfquery>	
        <cfreturn GET_SERVICE_APP_CATS_SUBSELECT>
    </cffunction>
</cfcomponent>
