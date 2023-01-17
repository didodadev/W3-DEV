<cfquery name="GET_NOTICES" datasource="#dsn#">
	SELECT
		NOTICES.NOTICE_ID,
		NOTICES.NOTICE_HEAD,
		NOTICES.DETAIL,
		NOTICES.RECORD_DATE,
		NOTICES.POSITION_ID,
		NOTICES.POSITION_CAT_ID,
		NOTICES.RECORD_EMP,
		NOTICES.NOTICE_NO
	FROM
		NOTICES
	WHERE
		STATUS = 1
		AND
		STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		AND
		FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
</cfquery>
