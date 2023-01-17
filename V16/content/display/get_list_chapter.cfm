<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.cont_catid") and len(attributes.cont_catid)>
	<cf_wrk_selectlang
		name="chapter"
		width="130"
		option_name="chapter"
		table_name="CONTENT_CHAPTER"
		extra_params="CONTENTCAT_ID"
		option_value="chapter_id"
		condition="CONTENTCAT_ID = #attributes.cont_catid#">
</cfif>
