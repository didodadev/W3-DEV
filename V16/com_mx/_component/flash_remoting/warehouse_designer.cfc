<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Warehouse Designer component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET BRANCH LIST --->
    <cffunction name="getBranchList" access="remote" returntype="query" output="no">
    	<cfquery name="get_branch_list" datasource="#dsn#">
            SELECT
            	BRANCH_ID AS id,
                BRANCH_NAME AS name
        	FROM
            	BRANCH
			WHERE
            	IS_PRODUCTION = 1
        	ORDER BY
            	BRANCH_NAME
        </cfquery>
        
        <cfreturn get_branch_list>
    </cffunction>
</cfcomponent>
