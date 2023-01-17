<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    <cfset interaction_cats = QueryNew("IS_SERVICE_HELP,TYPE_NAME","integer,VarChar")>
		<cfscript>
			QueryAddRow(interaction_cats,1);
			QuerySetCell(interaction_cats,"TYPE_NAME","",1);
			QuerySetCell(interaction_cats,"IS_SERVICE_HELP",'1',1);
		</cfscript>	 
		<cfquery name="GET_INTERACTION_CATS2" dbtype="query">
			SELECT * FROM interaction_cats
		</cfquery>
	  <cfreturn GET_INTERACTION_CATS2>
    </cffunction>
</cfcomponent>

