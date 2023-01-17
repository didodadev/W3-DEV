<cfif not isdefined('attributes.complaint_status')>
	<cfset attributes.complaint_status = 0>
</cfif>
<cfset createObject("component","V16.hr.cfc.setupComplaints").updComplaint(
		complaint_id:attributes.complaint_id,
		code:attributes.code,
		complaint:attributes.complaint,
		description:attributes.description,
		is_default:attributes.complaint_status
	) />
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_complaints&event=upd&complaint_id=#attributes.complaint_id#</cfoutput>';
</script>