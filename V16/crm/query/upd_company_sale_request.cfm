<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALE_REQUEST" datasource="#DSN#">
			UPDATE
				COMPANY_SALE_REQUEST
			SET
				COMPANY_ID = #attributes.cpid#,
				BRANCH_ID = #attributes.branch_id#,
				PROCESS_CAT = #attributes.process_stage#,
				DETAIL = '#attributes.detail#',
				RECORD_DATE = #now()#,
				RECORD_EMP = #session.ep.userid#,
				RECORD_IP = '#cgi.REMOTE_ADDR#',
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			WHERE
				SALE_REQUEST_ID = #attributes.SALE_REQUEST_ID#
		</cfquery>
		<cfquery name="ADD_NOTE" datasource="#DSN#">
			INSERT INTO 
				NOTES
				(
					ACTION_SECTION,
					ACTION_ID,
					NOTE_HEAD,
					NOTE_BODY,
					IS_SPECIAL,
					IS_WARNING,
					COMPANY_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
			VALUES
				(
					'SALE_REQUEST_ID',
					 #attributes.SALE_REQUEST_ID#,
					'#left(attributes.detail,75)#',
					'#attributes.detail#',
					 0,
					 0,
					 #session.ep.company_id#,
					 #session.ep.userid#,
					 #now()#,
					'#cgi.remote_addr#'
				)
		</cfquery>
	</cftransaction>
</cflock>		
<cf_workcube_process 
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=3&action_id=#attributes.SALE_REQUEST_ID#' 
	action_id='#attributes.SALE_REQUEST_ID#'
	old_process_line='#attributes.old_process_line#'
	warning_description = 'Satışa Açma Talebi : #attributes.fullname#'>
	
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
<!--- BK 120 gun sonra siline 20070608
<cfif isdefined("attributes.is_normal_form")>
	<cflocation url="#request.self#?fuseaction=crm.form_upd_sale_request&sale_request_id=#attributes.sale_request_id#&consumer_id=#attributes.cpid#&is_search=1" addtoken="no">
<cfelse>
	<script type="text/javascript">
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_list_company_requests&cpid=#attributes.cpid#</cfoutput>';
		window.close();
	</script>
</cfif> --->

