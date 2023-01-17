<cfquery name="GET_POS_TARGETS" datasource="#dsn#">
	SELECT 
		TARGET_ID, 
		POSITION_CODE, 
		TARGET_HEAD 
	FROM 
		TARGET 
	WHERE 
		POSITION_CODE=#attributes.POSITION_CODE#
</cfquery>
<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		TARGET_RESULT,
		PER_ID,
		TARGET_ID,
		TARGET_HEAD,
		TARGET_WEIGHT,
		PERFORM_COMMENT,
        EMP_TARGET_RESULT,
        UPPER_POSITION_TARGET_RESULT,
        UPPER_POSITION2_TARGET_RESULT
	FROM 
		TARGET
	WHERE 
		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>