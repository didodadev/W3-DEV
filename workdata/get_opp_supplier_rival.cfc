<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getOppSupplier">
		<cfif listlen(arguments.opp_id) gt 1><cfset arguments.opp_id = listfirst(arguments.opp_id)></cfif>
		<cfquery name="get_opp_supplier" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM OPPORTUNITY_SUPPLIERS WHERE OPP_ID = #arguments.opp_id#
		</cfquery>
		<cfreturn get_opp_supplier>
	</cffunction>
	
	 <cffunction name="getOppRival">
	 	<cfif listlen(arguments.opp_id) gt 1><cfset arguments.opp_id = listfirst(arguments.opp_id)></cfif>
		<cfquery name="get_opp_rival" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM OPPORTUNITY_RIVALS WHERE OPP_ID = #arguments.opp_id#
		</cfquery>
		<cfreturn get_opp_rival>
	</cffunction>
	
	 <cffunction name="getMoney">
		<cfquery name="GET_MONEY" datasource="#dsn#">
			SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
		</cfquery>
		<cfreturn GET_MONEY>
	</cffunction>
	
	 <cffunction name="getRivalPreferenceReasons">
		<cfquery name="GET_RIVAL_PREFERENCE_REASONS" datasource="#DSN#">
			SELECT
				PREFERENCE_REASON_ID,
				PREFERENCE_REASON
			FROM
				SETUP_RIVAL_PREFERENCE_REASONS
			ORDER BY
				PREFERENCE_REASON
		</cfquery>
		<cfreturn GET_RIVAL_PREFERENCE_REASONS>
	</cffunction>
	<cffunction name="getOffRival">
	 	<cfif listlen(arguments.offer_id) gt 1><cfset arguments.offer_id = listfirst(arguments.offer_id)></cfif>
		<cfquery name="get_off_rival" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM OFFER_RIVALS WHERE OFFER_ID = #arguments.offer_id#
		</cfquery>
		<cfreturn get_off_rival>   
    </cffunction>
</cfcomponent>

