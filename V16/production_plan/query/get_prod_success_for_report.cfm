<cfquery name="get_succ" datasource="#DSN3#">
	SELECT 
		SUCCESS 
	 FROM 
		QUALITY_CONTROL_DETAIL QCD,
		PRODUCTION_QUALITY_SUCCESS PQS 
	WHERE
		PRODUCTION_ORDER_ID = #get_prod.P_ORDER_ID# 
	AND
		PQS.SUCCESS_ID=QCD.SUCCESS_ID
</cfquery>
