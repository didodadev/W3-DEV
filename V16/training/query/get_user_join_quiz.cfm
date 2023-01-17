<cfquery name="GET_USER_JOIN_QUIZ" datasource="#dsn#">
	SELECT 
		RESULT_ID,
		EMP_ID,
		PARTNER_ID
	FROM 
		QUIZ_RESULTS
	WHERE
	<cfif isDefined("session.ep")>
		EMP_ID=#session.ep.userid# AND
	<cfelseif isdefined('session.pp')>
		PARTNER_ID = #session.pp.userid# AND
	</cfif>
	<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
		CLASS_ID = #attributes.class_id# AND
	</cfif>
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
