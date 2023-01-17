<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    <cfset internet_control = QueryNew("IS_INTERNET,CONTROL","integer,VarChar")>
		<cfscript>
			QueryAddRow(internet_control,1);
			QuerySetCell(internet_control,"CONTROL","Görünsün",1);
			QuerySetCell(internet_control,"IS_INTERNET","1",1);
		</cfscript>	 
		<cfquery name="GET_INTERNET_CONTROL" dbtype="query">
			SELECT * FROM internet_control
		</cfquery>
	  <cfreturn get_internet_control>
    </cffunction>
</cfcomponent>
