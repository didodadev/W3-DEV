<cfset visit_off_list = 'home.act_login,home.emptypopup_special_functions,objects2.pm_kontrol,home.login,objects.popupflush_print_files_inner,objects.popup_add_company_js'>
<cfif isdefined("attributes.fuseaction") and not listfindnocase(visit_off_list,attributes.fuseaction) and not attributes.fuseaction contains 'autoexcelpopuppage_' and not attributes.fuseaction contains 'emptypopup_'>
	<cfset visit_parameters_ = ''>
	<cfset visit_parameters_ = structToList(attributes,'╗')>
	<cfset visit_parameters_ = "#left(visit_parameters_,1500)#">
	<cfif not isdefined("cookie.wrk_cookie_id")>
		<cfset wrk_cookie_id = createUUID() />
		<cfset attributes.is_new = 1 />
		<cfcookie name="wrk_cookie_id" value="#wrk_cookie_id#" expires="never" />
	<cfelse>
		<cfset wrk_cookie_id = cookie.wrk_cookie_id />
		<cfset attributes.is_new = 0>
	</cfif>
		
	<cfif isdefined("attributes.fuseaction") and len(attributes.fuseaction)>
		<cfset visit_fuseact_ = '#attributes.fuseaction#'>
	<cfelse>
		<cfset visit_fuseact_ = 'myhome.welcome'>
	</cfif>
	<cfif len(cgi.QUERY_STRING)>
		<cfset visit_page_ = "#left(replace(cgi.QUERY_STRING,'fuseaction=','','all'),1500)#">
	<cfelse>
		<cfset visit_page_ = 'myhome.welcome'>
	</cfif>
	
	<cfif isdefined("session.ep.userid")>
		<cfset attributes.user_type_proc = 0>
		<cfset attributes.user_id = session.ep.userid>
	<cfelseif isdefined("session.pp.userid")>
		<cfset attributes.user_type_proc = 1>
		<cfset attributes.user_id = session.pp.userid>
	<cfelseif isdefined("session.ww.userid")>
		<cfset attributes.user_type_proc = 2>
		<cfset attributes.user_id = session.ww.userid>
	<cfelse>
		<cfset attributes.user_type_proc = -1>
		<cfset attributes.user_id = 0>
	</cfif>
    <cfif not (isdefined("is_wrk_visit_report") and is_wrk_visit_report eq 0)>
        <cfstoredproc procedure="WRITE_VISIT_ACTION" datasource="#DSN#">
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#attributes.user_type_proc#">
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#attributes.user_id#">
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#wrk_cookie_id#" />
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#attributes.is_new#">
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_timestamp" value="#now()#" />
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#" />
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#cgi.http_host#" />
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#visit_page_#"/>
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#cgi.http_referer#"/>
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#listfirst(visit_fuseact_,'.')#"/>
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#listlast(visit_fuseact_,'.')#"/>
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#visit_parameters_#"/>
            <cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#browserDetect()#"/>
        </cfstoredproc>
    </cfif>
</cfif>

