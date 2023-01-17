<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
		<cfargument name="data_source" type="any" required="yes">
		<cfargument name="table_name" type="string" required="yes">
		<cfargument name="option_name" type="any" required="yes">
		<cfargument name="option_value" type="string" required="yes">
            <cfquery name="GET_QUERY" datasource="#arguments.data_source#">
                SELECT #UCase(arguments.option_name)#,#UCase(arguments.option_value)# FROM #UCase(arguments.TABLE_NAME)# ORDER BY #UCase(arguments.sort_type)#
             </cfquery>
          <cfreturn GET_QUERY>
    </cffunction>
</cfcomponent>

