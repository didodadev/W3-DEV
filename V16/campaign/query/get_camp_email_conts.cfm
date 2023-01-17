<cfquery name="CAMP_EMAIL_CONTS" datasource="#DSN#">
	SELECT
		CR.CONTENT_ID EMAIL_CONT_ID,
		C.CONT_HEAD EMAIL_SUBJECT,
		C.SENDED_TARGET_MASS SENDED_TARGET_MASS,
        CR.COMPANY_ID,
        CR.RECORD_DATE
	FROM 
		CONTENT_RELATION CR, 
		CONTENT C
	WHERE 
		CR.CONTENT_ID = C.CONTENT_ID AND
		CR.ACTION_TYPE = 'CAMPAIGN_ID' AND 
		CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CAMP_ID#">
	<cfif isDefined("attributes.email_cont_id")>
        AND CR.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.email_cont_id#">
    </cfif>
    ORDER BY
        RECORD_DATE DESC
</cfquery>
