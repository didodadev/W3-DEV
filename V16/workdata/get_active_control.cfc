<cfcomponent>
    <cffunction name="getComponentFunction">
    <cfset last_control = QueryNew("IS_ACTIVE,STATUS","Integer,VarChar")>
		<cfscript>
			QueryAddRow(last_control,1);
			QuerySetCell(last_control,"STATUS","",1);
			QuerySetCell(last_control,"IS_ACTIVE",'1',1);
		</cfscript>	 
		<cfquery name="get_active_control" dbtype="query">
			SELECT * FROM last_control
		</cfquery>
	  <cfreturn get_active_control>
    </cffunction>
</cfcomponent>
