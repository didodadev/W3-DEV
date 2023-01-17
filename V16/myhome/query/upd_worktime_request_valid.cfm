<cfquery name="upd_ext_worktime" datasource="#dsn#">
	UPDATE
		EMPLOYEES_EXT_WORKTIMES
	SET
		PROCESS_STAGE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#

	WHERE
		EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ewt_id#">
</cfquery>

<cfquery name="get_ext_worktime" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_EXT_WORKTIMES WHERE EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ewt_id#">
</cfquery>

<cfquery name="get_employee_mail" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ext_worktime.employee_id#">
</cfquery>

<cfif isDefined("validator_position_1") and len(validator_position_1)>
	<cfif isdefined("valid_1") and len(valid_1)>
		<cfif len(get_employee_mail.employee_email)>
			<cfmail to="#get_employee_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
				<br/><br/>
				#dateformat(get_ext_worktime.start_time,dateformat_style)# tarihinde fazla mesai talebiniz birinci amiriniz tarafından <cfif valid_1 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
				
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>
	<cfif isdefined("valid_1") and valid_1 eq 1 and len(get_ext_worktime.validator_position_code_2)>
		<cfquery name="get_validate_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ext_worktime.validator_position_code_2#">
		</cfquery>
		<cfif len(get_validate_mail.employee_email)>
			<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı (İkinci Amir)" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
				<br/><br/>
				<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(get_ext_worktime.start_time,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
				
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>
</cfif>

<cfif isDefined("validator_position_2") and len(validator_position_2) and isdefined("valid_2") and len(valid_2)>
	<cfif len(get_employee_mail.employee_email)>
		<cfmail to="#get_employee_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi" type="HTML">
			<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
			<br/><br/>
			#dateformat(get_ext_worktime.start_time,dateformat_style)# tarihinde fazla mesai talebiniz ikinci amiriniz tarafından <cfif valid_2 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
			<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
			
			<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
			<br/><br/>
			<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
		</cfmail>
	</cfif>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='EMPLOYEES_EXT_WORKTIMES'
	action_column='EWT_ID'
	action_id='#attributes.EWT_ID#'
	action_page='#request.self#?fuseaction=myhome.extra_times_approve&event=upd&ewt_id=#attributes.ewt_id#'
	warning_description='Fazla Mesai Talebi'>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	<cfset attributes.EWT_ID = contentEncryptingandDecodingAES(isEncode:1,content:attributes.EWT_ID,accountKey:'wrk')>
<cfelse>
	<cfset attributes.EWT_ID = attributes.EWT_ID>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.extra_times_approve&event=upd&ewt_id=#attributes.ewt_id#</cfoutput>";

</script>
