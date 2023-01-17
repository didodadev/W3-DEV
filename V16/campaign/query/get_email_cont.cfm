<cfquery name="EMAIL_CONT" datasource="#DSN3#">
	SELECT 
		CR.CONTENT_ID EMAIL_CONT_ID,
		C.CONT_HEAD EMAIL_SUBJECT,
		C.CONT_BODY EMAIL_BODY,
		C.SENDED_TARGET_MASS,
		C.RECORD_DATE,
		C.RECORD_MEMBER RECORD_EMP,
		C.RECORD_IP,
		C.UPDATE_DATE,
		C.UPDATE_MEMBER UPDATE_EMP,
		C.UPDATE_IP
	FROM 
		#dsn_alias#.CONTENT_RELATION CR, 
		#dsn_alias#.CONTENT C
	WHERE 
		CR.CONTENT_ID = C.CONTENT_ID AND
		CR.ACTION_TYPE = 'CAMPAIGN_ID' AND 
		CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#"> AND
		CR.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#email_cont_id#">
</cfquery>
