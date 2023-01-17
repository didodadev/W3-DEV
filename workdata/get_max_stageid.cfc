<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	<cfset task_types = QueryNew("MAX_ID,STAGE","Integer,VarChar")>
	<cfquery name="get_max_id" datasource="#dsn#">
		SELECT MAX(STAGE_ID)+1 AS MAX_ID FROM SETUP_QUIZ_STAGE
	</cfquery>
	<cfscript>
		QueryAddRow(task_types,1);
		QuerySetCell(task_types,"STAGE","",1);
		QuerySetCell(task_types,"MAX_ID","#get_max_id.MAX_ID#",1);
	</cfscript>
	<cfquery name="get_max_stageid" dbtype="query">
		SELECT * FROM task_types
	</cfquery>
	<cfreturn get_max_stageid>
    </cffunction>	
</cfcomponent>
