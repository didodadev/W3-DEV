<cfquery name="GET_COMMETHOD" datasource="#DSN#">
	SELECT * FROM SETUP_PRIORITY
	<cfif isDefined("GET_ORDER_LIST.PRIORITY_ID") and len(GET_ORDER_LIST.PRIORITY_ID)>
		WHERE PRIORITY_ID = #GET_ORDER_LIST.PRIORITY_ID#
	</cfif>
</cfquery>
