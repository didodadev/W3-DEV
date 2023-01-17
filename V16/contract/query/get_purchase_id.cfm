<cfquery name="GET_PURCHASE_ID" datasource="#dsn3#">
	SELECT 
		*
	FROM
		PURCHASE_CONDITION 
	WHERE 
		PURCHASE_ID=#PURCHASE_ID#
</cfquery>
