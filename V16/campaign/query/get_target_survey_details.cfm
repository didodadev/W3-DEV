<cfquery name="TARGET_SURVEYS" datasource="#dsn3#">
	SELECT	
		*
	FROM
		TARGET_SURVEYS
	WHERE
		TMARKET_ID = #attributes.tmarket_id#
</cfquery>
<cfif target_surveys.recordcount gt 0>
	<cfquery name="TARGET_SURVEY_INFO" datasource="#dsn#">
		SELECT	
			*
		FROM
			SURVEY	
		WHERE
			SURVEY_ID IN (#valuelist(target_surveys.survey_id)#) 
	</cfquery>
</cfif>
