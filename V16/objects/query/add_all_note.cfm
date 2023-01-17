<cfif isDefined('attributes.alert_date')>
	<cf_date tarih = 'attributes.alert_date'>
</cfif>
<cfquery name="ADD_NOTE" datasource="#dsn#">
	INSERT INTO
		NOTES
	(
		ACTION_SECTION,
		<cfif attributes.action_type eq 0>ACTION_ID,<cfelse>ACTION_VALUE,</cfif>
		<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif>
		NOTE_HEAD,
		NOTE_BODY,
		IS_SPECIAL,
		IS_WARNING,
		COMPANY_ID,
		PERIOD_ID,
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		RECORD_EMP,
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		RECORD_PAR,
	<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
		RECORD_CONS,
	</cfif>
		RECORD_DATE,
		RECORD_IP,
		IS_LINK,
		ALERT_DATE
		)
	VALUES
	(
		'#UCASE(attributes.action_section)#',
		<cfif attributes.action_type eq 0>#attributes.action_id#,<cfelse>'#attributes.action_id#',</cfif>
		<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
		#sql_unicode()#'#attributes.NOTE_HEAD#',
		#sql_unicode()#'#attributes.NOTE_BODY#',
	<cfif isdefined("attributes.is_special")>1,<cfelse>0,</cfif>
	<cfif isdefined("attributes.is_warning")>1,<cfelse>0,</cfif>
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		#session.ep.company_id#,
		#session.ep.period_id#,
		#session.ep.userid#,
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		#session.pp.our_company_id#,
		#session.pp.userid#,
	<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
		#session.ww.our_company_id#,
		#session.ww.userid#,
	</cfif>
		#now()#,
		'#CGI.REMOTE_ADDR#',
		<cfif isdefined("attributes.is_link")>1<cfelse>0</cfif>,
		<cfif isDefined('attributes.alert_date') and len(attributes.alert_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.alert_date#"><cfelse>NULL</cfif>
	)
</cfquery>

<script>
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_get_notes');</cfif>
</script>