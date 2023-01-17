<cfif not isdefined('attributes.complaint_status')>
	<cfset attributes.complaint_status = 0>
</cfif>
<cfset createObject("component","V16.settings.cfc.setupComplaints").updComplaint(
		complaint_id:attributes.complaint_id,
		code:attributes.code,
		complaint:attributes.complaint,
		description:attributes.description,
		is_default:attributes.complaint_status
	) />
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_complaints&complaint_id=#attributes.complaint_id#">
