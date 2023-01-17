<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
		<cfargument name="data_source" type="any" required="yes">
		<cfargument name="table_name" type="string" required="yes">
		<cfargument name="option_name" type="any" required="yes">
		<cfargument name="option_value" type="string" required="yes">
		<cfif isdefined('session.ep')>
			<cfset session_lang_ = session.ep.language>
		<cfelseif isdefined('session.pp')>
			<cfset session_lang_ = session.pp.language>
		<cfelseif isdefined('session.ww')>
			<cfset session_lang_ = session.ww.language>
		<cfelseif isdefined('session.wp')>
			<cfset session_lang_ = session.wp.language>
        <cfelseif isdefined('session.cp')>
			<cfset session_lang_ = session.cp.language>
		</cfif>
            <cfquery name="GET_QUERY" datasource="#arguments.data_source#">
                SELECT 
					#dsn#.#dsn#.Get_Dynamic_Language(#UCase(arguments.option_value)#,'#session_lang_#','#UCase(arguments.table_name)#','#UCase(arguments.option_name)#',NULL,NULL,#UCase(arguments.option_name)#) AS #UCase(arguments.option_name)#,
					#UCase(arguments.option_value)# 
				FROM 
					#UCase(arguments.TABLE_NAME)# 
				ORDER BY 
					#UCase(arguments.sort_type)#
             </cfquery>
          <cfreturn GET_QUERY>
    </cffunction>
</cfcomponent>

