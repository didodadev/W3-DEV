<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
	<cfset caller.module_name = attributes.module_name>
</cfif>

<cftry>
	<cfset sira = listFindNoCase(application.langsAllList,caller.session_base.language,',')>
	<cfcatch type="any">
		<cfset sira = listFindNoCase(application.langsAllList,'tr',',')>
	</cfcatch>
</cftry>
<cftry>
	<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
        <cfoutput>#listGetAt(application.langArrayAll['#trim(ListFirst(attributes.dictionary_id,'.'))#'],sira,'█')#</cfoutput>
    <cfelse>
        <cfoutput>#listGetAt(application.langArray['#caller.module_name#']['#trim(ListFirst(attributes.no,'.'))#'],sira,'█')#</cfoutput>
    </cfif>
<cfcatch>
	<cfoutput>#(isDefined("attributes.no"))?trim(ListFirst(attributes.no,'.')):trim(ListFirst(attributes.dictionary_id,'.'))# Hatası</cfoutput>
</cfcatch>
</cftry>
