<cfcomponent>
    <cffunction name="getComponentFunction">
   		<cfset last_year_control = QueryNew("IS_LAST_YEAR_CONTROL,CONTROL","Integer,VarChar")>
		<cfscript>
			QueryAddRow(last_year_control,1);
			QuerySetCell(last_year_control,"CONTROL","Kontrol Edilsin",1);
			QuerySetCell(last_year_control,"IS_LAST_YEAR_CONTROL",'1',1);
		</cfscript>	 
		<cfquery name="get_year_control" dbtype="query">
			SELECT * FROM last_year_control
		</cfquery>
	  <cfreturn get_year_control>
    </cffunction>
</cfcomponent>
