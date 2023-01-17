<cfcomponent output="no">
	<!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Common component is accessible.">
	</cffunction>
    
    <!--- Get Query --->
    <cffunction name="getQuery" access="remote" returntype="any" output="no">
        <cfargument name="_____query_____" type="any" required="yes">
        <cfargument name="_____max_rows_____" type="numeric" required="no" default="-1">
        	
        <cfset result = StructNew()>
        
        <cftry>
        	<cfif isRestrictedQueryWordExist(arguments._____query_____) eq false>
	            <cfquery name="get_query" datasource="#session.databaseName#" maxrows="#arguments._____max_rows_____#">
    	            #preserveSingleQuotes(arguments._____query_____)#
        	    </cfquery>
        		<cfset result["values"] = get_query>
            <cfelse>
            	<cfset result["errorCode"] = -3>
			</cfif>
            
		    <cfcatch type="any">
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                <cfreturn result>
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Check Restricted Query Words --->
    <cffunction name="isRestrictedQueryWordExist" access="public" returntype="boolean" output="no">
    	<cfargument name="query_str" type="string" required="yes">
        <cfargument name="allow_simple_acts" type="boolean" required="no" default="0">
        
        <cfset restrictedWords = "ALTER,TRUNCATE,DROP,CREATE,EXEC,SP_,SYS.,INFORMATION_SCHEMA,MASTER">
        <cfif arguments.allow_simple_acts eq 0><cfset restrictedWords = "#restrictedWords#,DELETE,UPDATE,INSERT"></cfif>
        <cfset arguments.query_str = UCase(arguments.query_str)>
        
        <cfloop from="1" to="#Listlen(restrictedWords, ',')#" index="rw">
        	<cfset rWord = ListGetAt(restrictedWords, rw, ",")>
        	<cfif Find(rWord, arguments.query_str) neq 0><cfreturn true></cfif>
        </cfloop>
        
        <cfreturn false>
    </cffunction>
</cfcomponent>