<!--- <cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif> --->
<cfset add_announce = createObject("component","V16.training_management.cfc.announce")/>
<cfset Insert =add_announce.Insert(
	ANNOUNCE_HEAD:attributes.announce_head,
	DETAIL:attributes.detail,
	START_DATE:attributes.start_date,
	FINISH_DATE:attributes.finish_date
)/>
<script>
	<cfoutput>window.location.href = 'index.cfm?fuseaction=training_management.list_class_announcements&event=upd&announce_id=#Insert.IDENTITYCOL#'</cfoutput>
</script>