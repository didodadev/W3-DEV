<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="comp_cons" default="">
		<cfargument name="is_active">
		<cfargument name="compcat_type">
		
		<cfif isdefined('session.ep')>
			<cfset session_lang_ = session.ep.language>
			<cfset session_company_id = session.ep.company_id>
		<cfelseif isdefined('session.pp')>
			<cfset session_lang_ = session.pp.language>
			<cfset session_company_id = session.pp.our_company_id>
		<cfelseif isdefined('session.ww')>
			<cfset session_lang_ = session.ww.language>
			<cfset session_company_id = session.ww.our_company_id>
		<cfelseif isdefined('session.wp')>
			<cfset session_lang_ = session.wp.language>
			<cfset session_company_id = session.wp.our_company_id>
		</cfif>
		
		<cfif arguments.comp_cons eq 1>
            <cfquery name="GET_MEMBER_CAT" datasource="#dsn#">
               	SELECT
					COMPANYCAT_ID,
					#dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session_lang_#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT					
				FROM 
					GET_MY_COMPANYCAT
				WHERE 
					OUR_COMPANY_ID=#session_company_id#
					AND EMPLOYEE_ID=#session.ep.userid#
					<cfif arguments.compcat_type eq 0>
						AND COMPANYCAT_TYPE=0
					<cfelseif arguments.compcat_type eq 1>
						AND COMPANYCAT_TYPE=1
					<cfelseif arguments.compcat_type eq 2>
						AND COMPANYCAT_TYPE=NULL
					</cfif>
				ORDER BY
					COMPANYCAT	
            </cfquery>
		<cfelse>
			<cfquery name="GET_MEMBER_CAT" datasource="#DSN#">
				SELECT
					CONSCAT_ID,
					#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session_lang_#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSCAT) AS CONSCAT					
				FROM 
					GET_MY_CONSUMERCAT 
				WHERE 
					OUR_COMPANY_ID=#session_company_id#
					AND EMPLOYEE_ID=#session.ep.userid#
					<cfif arguments.is_active eq 1>
						AND IS_ACTIVE = 1
					</cfif>
				ORDER BY
					CONSCAT		
			</cfquery>
		</cfif>
        <cfreturn GET_MEMBER_CAT>
    </cffunction>
</cfcomponent>

