<cfquery name="upd_offtime" datasource="#dsn#">
	UPDATE
		CORRESPONDENCE_PAYMENT
	SET
		<cfif isDefined("validator_position_1") and len(validator_position_1)>
			VALID_1_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.valid_1_detail#">,
			VALIDATOR_POSITION_CODE_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_1#">,
			<cfif isdefined("valid_1") and len(valid_1)>
				VALID_EMPLOYEE_ID_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				VALIDDATE_1 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				VALID_1 = <cfqueryparam cfsqltype="cf_sql_bit" value="#valid_1#">
			</cfif>
		<cfelseif isDefined("validator_position_2") and len(validator_position_2)>
			VALID_2_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.valid_2_detail#">,
			VALIDATOR_POSITION_CODE_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_2#">,
			<cfif isdefined("valid_2") and len(valid_2)>
				VALID_EMPLOYEE_ID_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				VALIDDATE_2 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				VALID_2 = <cfqueryparam cfsqltype="cf_sql_bit" value="#valid_2#">
			</cfif>
		</cfif>
		PROCESS_STAGE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#
		<!--- <cfif isdefined("valid_1") and valid_1 eq 1>,STATUS = 1</cfif> birinci amir onaylandigi an, HR ONAYINA DUSMEDEN onaylandi olarak gorunuyordu, bu yuzden kapatildi 20120727 --->
	WHERE
		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfif (isDefined("attributes.valid_1") and attributes.valid_1 eq 1) or (isDefined("attributes.valid_2") and attributes.valid_2 eq 1)>
	<cfquery name="Get_Payment" datasource="#dsn#">
		SELECT VALIDATOR_POSITION_CODE_1,VALID_1,VALIDATOR_POSITION_CODE_2,VALID_2,DUEDATE,TO_EMPLOYEE_ID,AMOUNT,MONEY FROM CORRESPONDENCE_PAYMENT WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
	<cfquery name="Get_Session_Mail" datasource="#dsn#">
		SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Payment.To_Employee_Id#">
	</cfquery>
	<cfsavecontent variable="message_head">
		<cfoutput>
		<a href="#employee_domain##request.self#?fuseaction=myhome.my_payment_request" target="_blank"><cf_get_lang no='1592.Avans Takip Ekranı'></a> <br/><br/>
		</cfoutput>
			
		<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
		<br/><br/>
		<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz'><br/><br/>
	</cfsavecontent>
	
	<cfif isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and Len(Get_Payment.validator_position_code_2)>
		<!--- 1. Amir Onaylarsa, 2. Amire Mail Gider --->
		<cfsavecontent variable="message"><cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
		<cfquery name="get_validate_mail" datasource="#dsn#">
			SELECT E.EMPLOYEE_EMAIL,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment.validator_position_code_2#">
		</cfquery>
		<cfif len(get_validate_mail.employee_email)>
			<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
				<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
				<br/><br/>
				<b>#get_session_mail.employee_name# #get_session_mail.employee_surname#</b> #dateformat(get_payment.duedate,dateformat_style)# tarihinde #get_payment.amount# #get_payment.money# tutarında avans talebinde bulunmuştur.Onayınız Bekleniyor !<br/><br/>
	
				#message_head#
			</cfmail>
		</cfif>
	</cfif>
	<cfif (isDefined("attributes.valid_2") and attributes.valid_2 eq 1 and isDefined("attributes.validator_position_code_2") and Len(attributes.validator_position_code_2)) or (isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and not len(get_payment.validator_position_code_2))>
		<!--- Son Amir Onayindan sonra Calisana Mail Gider --->
		<cfsavecontent variable="message"><cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
		<cfif len(get_session_mail.employee_email)>
			<cfif isDefined("attributes.valid_2") and attributes.valid_2 eq 1 and isDefined("attributes.validator_position_code_2") and Len(attributes.validator_position_code_2)>
				<cfset validator_pos_code = attributes.validator_position_code_2>
			<cfelseif isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and not len(get_payment.validator_position_code_2)>
				<cfset validator_pos_code = attributes.validator_position_code_1>
			</cfif>
			<cfquery name="get_validator" datasource="#dsn#">
				SELECT E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_pos_code#">
			</cfquery>
			<cfmail to="#Get_Session_Mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
				<cf_get_lang_main no='1368.Sayın'> #get_session_mail.employee_name# #get_session_mail.employee_surname#,
				<br/><br/>
				<b>#get_validator.employee_name# #get_validator.employee_surname#</b> adlı kişi #dateformat(get_payment.duedate,dateformat_style)# tarihindeki avans talebini onaylamıştır !<br/><br/>
	
				#message_head#
			</cfmail>
		</cfif>
	</cfif>
</cfif>
<cfquery name="get_payment" datasource="#dsn#">
	SELECT SUBJECT FROM CORRESPONDENCE_PAYMENT WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cf_workcube_process
	is_upd='1'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='CORRESPONDENCE_PAYMENT'
	action_column='ID'
	action_id='#attributes.id#'
	action_page='#request.self#?fuseaction=myhome.my_payment_request'
	warning_description = 'Avans Talebi : #get_payment.subject#'>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.payment_request_approve&event=upd&id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:'wrk')#</cfoutput>";
</script>
