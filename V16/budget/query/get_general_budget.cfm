<cfquery name="GET_BUDGET_DETAIL" datasource="#dsn#">
	SELECT
		BT.*,
		PTR.STAGE
	FROM
		BUDGET BT,
		PROCESS_TYPE_ROWS PTR
	WHERE
		BT.BUDGET_ID = #attributes.budget_id# AND
		BT.BUDGET_STAGE = PTR.PROCESS_ROW_ID		
</cfquery>
