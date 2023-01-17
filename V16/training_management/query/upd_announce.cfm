<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfset UPD_ANNOUNCE = createObject("component","V16.training_management.cfc.announce")/>
<cfset Update =UPD_ANNOUNCE.Update(
	ANNOUNCE_ID : attributes.announce_id,
	ANNOUNCE_HEAD : attributes.announce_head,
	DETAIL : attributes.detail,
	START_DATE: attributes.start_date,
	FINISH_DATE : attributes.finish_date
)/>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
