<cfcomponent>
    <cffunction name="getComponentFunction">
    <cfset task_types = QueryNew("IS_ACTIVE,TYPE_NAME","Integer,VarChar")>
		<cfscript>
			QueryAddRow(task_types,1);
			QuerySetCell(task_types,"TYPE_NAME","Aktif",1);
			QuerySetCell(task_types,"IS_ACTIVE",'1',1);
			
			QueryAddRow(task_types,1);
			QuerySetCell(task_types,"TYPE_NAME","Pasif",2);
			QuerySetCell(task_types,"IS_ACTIVE",'0',2);
		</cfscript>	 
		<cfquery name="GET_TASK_TYPES" dbtype="query">
			SELECT * FROM task_types
		</cfquery>
	  <cfreturn GET_TASK_TYPES>
    </cffunction>
</cfcomponent>

