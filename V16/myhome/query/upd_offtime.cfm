<cfquery name="upd_offtime" datasource="#dsn#">
	UPDATE
		OFFTIME
	SET
		OFFTIME_STAGE = #attributes.PROCESS_STAGE#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#
	WHERE
		OFFTIME_ID = #OFFTIME_ID#
</cfquery>

<cfquery name="get_offtime" datasource="#dsn#">
	SELECT *FROM OFFTIME WHERE OFFTIME_ID = #attributes.OFFTIME_ID#
</cfquery>

<cfquery name="get_employee_mail" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_offtime.EMPLOYEE_ID#
</cfquery>

<cfif isDefined("validator_position_1") and len(validator_position_1)>
	<cfif isdefined("valid_1") and len(valid_1)>
		<cfsavecontent variable="message"><cf_get_lang no='1589.İzin Talebi'></cfsavecontent>
		<cfif len(get_employee_mail.EMPLOYEE_EMAIL)>
			<cfmail to="#get_employee_mail.EMPLOYEE_EMAIL#"
				from="#session.ep.company#<#session.ep.company_email#>"
				subject="#message#" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
				<br/><br/>
				#dateformat(get_offtime.startdate,dateformat_style)# - #dateformat(get_offtime.finishdate,dateformat_style)# tarihleri arasında izin talebiniz birinci amiriniz tarafından <cfif valid_1 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
				<a href="#fusebox.server_machine_list#/#request.self#?fuseaction=myhome.my_offtimes" target="_blank"><cf_get_lang no='1591.İzin Takip Ekranı'></a> <br/><br/>
				
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>
	<cfif isdefined("valid_1") and valid_1 eq 1 and len(get_offtime.VALIDATOR_POSITION_CODE_2)>
		<cfquery name="get_validate_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_offtime.VALIDATOR_POSITION_CODE_2#
		</cfquery>
		<cfif len(get_validate_mail.EMPLOYEE_EMAIL)>
			<cfsavecontent variable="message"><cf_get_lang no='1605.İzin Talebi Onayı (İkinci Amir)'></cfsavecontent>
			<cfmail to="#get_validate_mail.EMPLOYEE_EMAIL#"
				from="#session.ep.company#<#session.ep.company_email#>"
				subject="#message#" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
				<br/><br/>
				<b>#get_employee_mail.EMPLOYEE_NAME# #get_employee_mail.EMPLOYEE_SURNAME#</b> adlı kişi #dateformat(get_offtime.startdate,dateformat_style)# - #dateformat(get_offtime.finishdate,dateformat_style)# tarihleri arasında izin talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
				<a href="#fusebox.server_machine_list#/#request.self#?fuseaction=myhome.my_offtimes_approve" target="_blank"><cf_get_lang no='1591.İzin Takip Ekranı'></a> <br/><br/>
				
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>
</cfif>

<cfif isDefined("validator_position_2") and len(validator_position_2) and isdefined("valid_2") and len(valid_2)>
	<cfsavecontent variable="message"><cf_get_lang no='1589.İzin Talebi'></cfsavecontent>
	<cfif len(get_employee_mail.EMPLOYEE_EMAIL)>
		<cfmail to="#get_employee_mail.EMPLOYEE_EMAIL#"
			from="#session.ep.company#<#session.ep.company_email#>"
			subject="#message#" type="HTML">
			<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
			<br/><br/>
			#dateformat(get_offtime.startdate,dateformat_style)# - #dateformat(get_offtime.finishdate,dateformat_style)# tarihleri arasında izin talebiniz ikinci amiriniz tarafından <cfif valid_2 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
			<a href="#fusebox.server_machine_list#/#request.self#?fuseaction=myhome.my_offtimes" target="_blank"><cf_get_lang no='1591.İzin Takip Ekranı'></a> <br/><br/>
			
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
	process_stage='#attributes.PROCESS_STAGE#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='OFFTIME'
	action_column='OFFTIME_ID'
	action_id='#attributes.offtime_id#' 
	action_page='#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.offtime_id,accountKey:"wrk")#' 
	warning_description='İzin : #attributes.offtime_id# - #get_employee_mail.EMPLOYEE_NAME# #get_employee_mail.EMPLOYEE_SURNAME#'>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.my_offtimes_approve&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.offtime_id,accountKey:'wrk')#</cfoutput>";

</script>
