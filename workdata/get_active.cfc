<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    <cfset active_info = QueryNew("COMPUTER_INFO_STATUS,STATUS","Integer,VarChar")>
		<cfscript>
			QueryAddRow(active_info,1);
			QuerySetCell(active_info,"STATUS","Aktif",1);
			QuerySetCell(active_info,"COMPUTER_INFO_STATUS",'1',1);
		</cfscript>	 
		<cfquery name="get_active" dbtype="query">
			SELECT * FROM active_info
		</cfquery>
	  <cfreturn get_active>
    </cffunction>
</cfcomponent>
