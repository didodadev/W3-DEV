<cfquery name="GET_SETUP_PRIORITY" datasource="#dsn#">
	SELECT 
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PRIORITY
		END AS PRIORITY,
		PRIORITY_ID,
		COLOR,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	FROM 
		SETUP_PRIORITY
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PRIORITY.PRIORITY_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRIORITY">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PRIORITY">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY 
		PRIORITY
</cfquery>
