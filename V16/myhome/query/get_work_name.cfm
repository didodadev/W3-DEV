<cfquery name="GET_WORK_NAME" datasource="#dsn#">
	SELECT WORK_HEAD,WORK_ID 
	FROM 
		PRO_WORKS
	WHERE 
		WORK_ID= #GET_TIME_COST.WORK_ID#
</cfquery>
