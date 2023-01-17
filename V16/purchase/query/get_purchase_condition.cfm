<!--- get_purchase_condition.cfm --->
<cfquery name="GET_PURCHASE_CONDITION" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PURCHASE_CONDITION
		<cfif isDefined("GET_ORDER_DETAIL.COMPANY_ID")>
	WHERE 
		COMPANY 
	LIKE 
		'%,#GET_ORDER_DETAIL.COMPANY_ID#,%' 
		</cfif>
</cfquery>
