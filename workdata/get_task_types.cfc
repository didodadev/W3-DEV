<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    <cfset task_types = QueryNew("IS_UNIVERSITY,TYPE_NAME","Integer,VarChar")>
		<cfscript>
			QueryAddRow(task_types,1);
			QuerySetCell(task_types,"TYPE_NAME","Üniversite",1);
			QuerySetCell(task_types,"IS_UNIVERSITY",'1',1);
			
			QueryAddRow(task_types,1);
			QuerySetCell(task_types,"TYPE_NAME","Diğer",2);
			QuerySetCell(task_types,"IS_UNIVERSITY",'0',2);
		</cfscript>	 
		<cfquery name="GET_TASK_TYPES" dbtype="query">
			SELECT * FROM task_types
		</cfquery>
	  <cfreturn GET_TASK_TYPES>
    </cffunction>
</cfcomponent>

