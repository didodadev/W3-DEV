<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Report Runner component is accessible.">
	</cffunction>
    
    <!--- CROSS FUNCTIONS --->
    
    <!--- Load Report --->
    <cffunction name="loadReport" access="remote" returntype="any" output="no">
        <cfargument name="report_id" type="numeric" required="yes">
        
        <cfset result = StructNew()>
        
        <cfset result = CreateObject("component", "boomboss_report_designer").loadReport(report_id: arguments.report_id, skip_auth_checking: true)>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Run Query --->
    <cffunction name="runQuery" access="remote" returntype="any" output="no">
        <cfargument name="query_id" type="any" required="yes">
                
        <cfset result = StructNew()>
                
       	<cfset result = CreateObject("component", "boomboss_query_runner").runQuery(query_id: arguments.query_id)>
        <cfreturn result>
    </cffunction>
</cfcomponent>
