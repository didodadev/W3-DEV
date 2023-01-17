<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Workcube component is accessible.">
	</cffunction>
    
	<!--- Get External Dictionary --->
    <cffunction name="getExternalDictionary" access="remote" returntype="any" output="no">
    	<cfargument name="db_name" type="string" required="yes">
        <cfargument name="lang" type="string" required="yes">
        <cfargument name="word_list" type="string" required="yes">
        
        <!--
        	Word List structure:
            
            + word_list (string) as "1,5,main|2,8,main|5,7,project" etc
            	- word 1 (string) 	"1,5,main"
                - word 2 (string) 	"2,8,main"
                - word 3 (string)	"5,7,main" etc.
		-->
        
        <cfset language_set = ArrayNew(1)>
        <cfloop from="1" to="#listlen(arguments.word_list, '|')#" index="i">
        	<cfset word_str = listgetat(arguments.word_list, i, '|')>
            <cfset _id = listgetat(word_str, 1, ',')>
            <cfset _id_internal = listgetat(word_str, 2, ',')>
            <cfset _module = listgetat(word_str, 3, ',')>
            <cfquery name="get_word" datasource="#arguments.db_name#">
                SELECT
                    *
                FROM
                    SETUP_LANGUAGE_#UCase(arguments.lang)#
                WHERE
                    ITEM_ID = #_id#
                    AND MODULE_ID = '#_module#'
            </cfquery>
            
            <cfif get_word.recordcount gte 0>
				<cfset _word = get_word.ITEM>
            <cfelse>
            	<cfset _word = "?">
			</cfif>
            <cfset word = StructNew()>
            <cfset word["id"] = _id_internal>
            <cfset word["word"] = _word>
            <cfset word["module"] = _module>
            <cfset language_set[arraylen(language_set) + 1] = word>
        </cfloop>
    
    <cfreturn language_set>
	</cffunction>
</cfcomponent>