<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
	<!--- TEST --->
	<cffunction name="test" access="remote" returntype="string" output="no">
		<cfreturn "Language component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLanguageSet" access="remote" returntype="any" output="no">
        <cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
        
        <!--
        	Numbers structure:
            
            + numbers (string) as "1,main|2,main|5,project" etc
            	- word 1 (string) 	"1,main"
                - word 2 (string) 	"2,main"
                - word 3 (string)	"5,main" etc.
		-->
        
        <cfset language_set = ArrayNew(1)>
        <cfloop from="1" to="#listlen(arguments.numbers, '|')#" index="i">
        	<cfset word_str = listgetat(arguments.numbers, i, '|')>
            <cfset _id = listgetat(word_str, 1, ',')>
            <cfset _module = listgetat(word_str, 2, ',')>
            <cfquery name="get_word" datasource="#dsn#">
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
            <cfset word["id"] = _id>
            <cfset word["word"] = _word>
            <cfset word["module"] = _module>
            <cfset language_set[arraylen(language_set) + 1] = word>
        </cfloop>
    
    <cfreturn language_set>
	</cffunction>
</cfcomponent>