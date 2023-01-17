<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    <cfset last_commethod_control = QueryNew("IS_DEFAULT,KONTROL","Integer,VarChar")>
		<cfscript>
			QueryAddRow(last_commethod_control,1);
			QuerySetCell(last_commethod_control,"KONTROL","Standart Seçenek Olarak Gelsin",1);
			QuerySetCell(last_commethod_control,"IS_DEFAULT",'1',1);
		</cfscript>	 
		<cfquery name="get_method_control" dbtype="query">
			SELECT * FROM last_commethod_control
		</cfquery>
	  <cfreturn get_method_control>
    </cffunction>
</cfcomponent>
