<cfquery name="GET_RECORD_EDU" datasource="#DSN#">
	SELECT
		SUBJECT_CURRENCY_ID
	FROM
		TRAINING
	WHERE
		SUBJECT_CURRENCY_ID = #attributes.stage_id#
</cfquery>
<cfif get_record_edu.recordcount>
	<cfset is_upd=0>
<cfelse>
	<cfset is_upd=1>
</cfif>
