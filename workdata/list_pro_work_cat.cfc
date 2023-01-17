<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="LIST_PRO_WORK_CAT" datasource="#dsn#">
                SELECT 
                	* 
                FROM 
                	PRO_WORK_CAT 
                ORDER BY 
                	WORK_CAT
            </cfquery>
          <cfreturn LIST_PRO_WORK_CAT>
    </cffunction>
</cfcomponent>
