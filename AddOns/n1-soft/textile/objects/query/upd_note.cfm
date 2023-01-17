<cfquery name="UPD_NOTE" datasource="#DSN#">
	UPDATE 
		NOTES
    SET
	   IS_SPECIAL = <cfif isdefined("attributes.is_special")>1,<cfelse>0,</cfif>
	   IS_WARNING = <cfif isdefined("attributes.is_warning")>1,<cfelse>0,</cfif>
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
	   UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		NOTE_ID = #attributes.note_id#
</cfquery>
<cfquery name="get_empids" datasource="#dsn3#">
SELECT 
      WORKSTATIONS.EMP_ID
  FROM 
		[WORKSTATIONS_PRODUCTS],
		OPERATION_TYPES,
		[WORKSTATIONS]
	where
		OPERATION_TYPES.OPERATION_TYPE_ID=WORKSTATIONS_PRODUCTS.OPERATION_TYPE_ID
		AND WORKSTATIONS.STATION_ID=WORKSTATIONS_PRODUCTS.WS_ID 
		AND OPERATION_TYPES.OPERATION_TYPE_ID=#attributes.operation#
</cfquery>
<cfif len(get_empids.EMP_ID)>
		<cfquery name="get_emp_info" datasource="#dsn#">
			select 
				*
			FROM
			EMPLOYEES
				WHERE EMPLOYEE_ID IN(0#get_empids.EMP_ID#0)
		</cfquery>
		<cfquery name="get_req" datasource="#dsn3#">
			select 
				*FROM
			TEXTILE_SAMPLE_REQUEST
				WHERE
					REQ_ID=#attributes.action_id#
		</cfquery>
				<cfset mail_from_="metincakar@n1-soft.com">
				<cfset warning_number_=get_req.REQ_NO>
				<cfset url_link_="?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.action_id#">
				<cfoutput query="get_emp_info">
							<cfif len(employee_email)> 
									<cfsavecontent variable="message">#attributes.NOTE_HEAD#  Operasyonu İçin Kritik Bilgisi Değiştirilmiştir !</cfsavecontent>
								   <cfmail from="#mail_from_#" to="#employee_email#" subject="#message#" type="html">  
									<style type="text/css"> 
										.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
									</style>
									<table width="600" class="css1">
										<tr>
											<td>Sayın #employee_name# #employee_surname#,</td>
										</tr>
										<tr><td></td></tr>
										<tr>
											<td>#message#</td>
										</tr>
										<tr><td></td></tr>
										<tr>
											<td>İlgili Sayfa : <a href ='#user_domain##url_link_#'>#warning_number_#</a></td>
										</tr>
										<tr><td></td></tr>
										<tr>
											<td>Şirket : #session.ep.company#</td>
										</tr>
										<tr><td></td></tr>
									</table>
									<br><br>
								   </cfmail> 
							</cfif>
				</cfoutput>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
