<cfcomponent>
	<cffunction name="getComponentFunction">
    <cfset last_year_control = QueryNew("IS_INTERNET,CONTROL","Integer,VarChar")>
		<cfscript>
			QueryAddRow(last_year_control,1);
			QuerySetCell(last_year_control,"CONTROL","Herkes Görsün",1);
			QuerySetCell(last_year_control,"IS_INTERNET",'1',1);
		</cfscript>	 
		<cfquery name="GET_SERVICE_APP_CATS_IS_INTERNET" dbtype="query">
			SELECT * FROM last_year_control
		</cfquery>
     <cfreturn GET_SERVICE_APP_CATS_IS_INTERNET>        
    </cffunction>
</cfcomponent>


        
      
