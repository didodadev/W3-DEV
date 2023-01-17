<cfif not isdefined('attributes.complaint_status')>
	<cfset attributes.complaint_status = 0>
</cfif>
<cfset createObject("component","V16.settings.cfc.setupComplaints").addComplaint(
		code:attributes.code,
		complaint:attributes.complaint,
		description:attributes.description,
		is_default:attributes.complaint_status
	) />
<cfif isdefined("attributes.is_popup") and  attributes.is_popup eq 1>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<cfquery name="get_last_id" datasource="#dsn#">
		SELECT MAX(COMPLAINT_ID) AS LAST_ID FROM SETUP_COMPLAINTS
	</cfquery>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_complaints&complaint_id=#get_last_id.LAST_ID#">
</cfif>
