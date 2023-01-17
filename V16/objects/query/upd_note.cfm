<cfif isDefined('attributes.alert_date')>
	<cf_date tarih = 'attributes.alert_date'>
</cfif>

<cfquery name="UPD_NOTE" datasource="#DSN#">
	UPDATE 
		NOTES
    SET
	   	IS_SPECIAL = <cfif isdefined("attributes.is_special")>1,<cfelse>0,</cfif>
	   	IS_WARNING = <cfif isdefined("attributes.is_warning")>1,<cfelse>0,</cfif>
		IS_LINK = <cfif isdefined("attributes.is_link")>1,<cfelse>0,</cfif>
	   	NOTE_HEAD = #sql_unicode()#'#attributes.note_head#',
	   	NOTE_BODY = #sql_unicode()#'#attributes.note_body#',
	   	UPDATE_DATE = #now()#,
   <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	   UPDATE_EMP = #session.ep.userid#,
   <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	   UPDATE_PAR = #session.pp.userid#,
   <cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
	   UPDATE_PAR = #session.ww.userid#,
   </cfif>
	   UPDATE_IP = '#cgi.remote_addr#',
	   ALERT_DATE = <cfif isDefined('attributes.alert_date') and len(attributes.alert_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.alert_date#"><cfelse>NULL</cfif>
	WHERE
		NOTE_ID = #attributes.note_id#
</cfquery>

<script>
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_get_notes');</cfif>
</script>