<cfquery name="DELTERM" datasource="#dsn#">
	DELETE FROM SETUP_MEMBER_ANALYSIS_TERM WHERE TERM_ID=#TERM_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_member_analysis_period" addtoken="no">
