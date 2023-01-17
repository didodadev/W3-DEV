<cf_get_lang_set_main>
<cfset lang_array_main = variables.lang_array_main>
<cftry>
	<cfset sira = listFindNoCase(application.langsAllList,caller.session_base.language,',')>
	<cfcatch type="any">
		<cfset sira = listFindNoCase(application.langsAllList,'tr',',')>
	</cfcatch>
</cftry>


<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
	<cfoutput>#listGetAt(application.lang_array_all.item['#trim(ListFirst(attributes.dictionary_id,'.'))#'],sira,'█')#</cfoutput>
<cfelse>
	<cfoutput>#listGetAt(lang_array_main.item['#trim(ListFirst(attributes.no,'.'))#'],sira,'█')#</cfoutput> 
</cfif>