<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Dictionary component is accessible.">
	</cffunction>
    
    <!--- Get Dictionary --->
    <cffunction name="getDictionary" access="remote" returntype="any" output="no">
        <cfargument name="dictionary_tag" required="yes">
        <cfargument name="word_list" type="string" required="yes">
        
        <cfquery name="get_words" datasource="#session.databaseName#">
        	SELECT DICTIONARY_ID AS id, ISNULL(TEXT_#arguments.dictionary_tag#, STR(DICTIONARY_ID) + '?') AS word FROM DICTIONARY <cfif len(arguments.word_list)>WHERE DICTIONARY_ID IN(#arguments.word_list#)</cfif>
        </cfquery>
        
        <cfreturn get_words>
    </cffunction>
</cfcomponent>
