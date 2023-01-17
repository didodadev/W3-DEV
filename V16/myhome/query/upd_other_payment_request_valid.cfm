<cfquery name="upd_offtime" datasource="#dsn#">
	UPDATE
		SALARYPARAM_GET_REQUESTS
	SET
	<cfif isDefined("validator_position_1") and len(validator_position_1)>
		VALIDATOR_POSITION_CODE_1 =<cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_1#">,
		<cfif isdefined("valid_1") and len(valid_1)>
			VALID_EMPLOYEE_ID_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			VALIDDATE_1 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			VALID_1 = <cfqueryparam cfsqltype="cf_sql_bit" value="#valid_1#">
		</cfif>
	<cfelseif isDefined("validator_position_2") and len(validator_position_2)>
		VALIDATOR_POSITION_CODE_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_2#">,
		<cfif isdefined("valid_2") and len(valid_2)>
			VALID_EMPLOYEE_ID_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			VALIDDATE_2 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			VALID_2 = <cfqueryparam cfsqltype="cf_sql_bit" value="#valid_2#">
		</cfif>
	</cfif>
	WHERE
		SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="Get_Payment" datasource="#dsn#">
	SELECT EMPLOYEE_ID,VALIDATOR_POSITION_CODE_2,VALIDATOR_POSITION_CODE_1,START_SAL_MON FROM SALARYPARAM_GET_REQUESTS WHERE SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="Get_Emp_Mail" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Payment.Employee_Id#">
</cfquery>
<cfsavecontent variable="message_head">
	<cfoutput>
	<a href="#employee_domain##request.self#?fuseaction=myhome.my_payment_request" target="_blank"><cf_get_lang no='1592.Avans Takip Ekranı'></a> <br/><br/>
	</cfoutput>
		
	<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
	<br/><br/>
	<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz'><br/><br/>
</cfsavecontent>
<cfif isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and Len(Get_Payment.VALIDATOR_POSITION_CODE_2)>
	<!--- 1. Amir Onaylarsa, 2. Amire Mail Gider --->
	<cfsavecontent variable="message">Taksitli <cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
	<cfquery name="get_validate_mail" datasource="#dsn#">
		SELECT E.EMPLOYEE_EMAIL,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment.validator_position_code_2#">
	</cfquery>
	<cfif len(get_validate_mail.employee_email)>
		<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
			<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
			<br/><br/>
			<b>#Get_Emp_Mail.EMPLOYEE_NAME# #Get_Emp_Mail.EMPLOYEE_SURNAME#</b> adlı kişi #listgetat(ay_list(),Get_Payment.start_sal_mon,',')# ayı için taksitli avans talebinde bulunmuştur.Onayınız Bekleniyor !<br/><br/>

			#message_head#
		</cfmail>
	</cfif>
</cfif>
<cfif (isDefined("attributes.valid_2") and attributes.valid_2 eq 1 and Len(get_payment.validator_position_code_2)) or (isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and not Len(get_payment.validator_position_code_2))>
	<!--- Son amir onayindan sonra Calisana Mail Gider --->
	<cfsavecontent variable="message">Taksitli <cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
	<cfif len(get_emp_mail.employee_email)>
		<cfif isDefined("attributes.valid_2") and attributes.valid_2 eq 1 and Len(get_payment.validator_position_code_2)>
			<cfset validator_pos_code = get_payment.validator_position_code_2>
		<cfelseif isDefined("attributes.valid_1") and attributes.valid_1 eq 1 and not Len(get_payment.validator_position_code_2)>
			<cfset validator_pos_code = get_payment.validator_position_code_1>
		</cfif>
		<cfif len(validator_pos_code)>
			<cfquery name="get_validate_mail" datasource="#dsn#">
				SELECT E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_pos_code#">
			</cfquery>
			<cfmail to="#Get_Emp_Mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
				<cf_get_lang_main no='1368.Sayın'> #Get_Emp_Mail.employee_name# #Get_Emp_Mail.employee_surname#,
				<br/><br/>
				<b>#get_validate_mail.EMPLOYEE_NAME# #get_validate_mail.EMPLOYEE_SURNAME#</b> adlı kişi #listgetat(ay_list(),Get_Payment.start_sal_mon,',')# ayı için taksitli avans talebini onaylamıştır !<br/><br/>
	
				#message_head#
			</cfmail>
		</cfif>
	</cfif>
</cfif>
<cfquery name="get_max_period" datasource="#DSN#">
	SELECT MAX(SPGR_ID) AS RESULT_ID  FROM SALARYPARAM_GET_REQUESTS
</cfquery>
<!---old_process_line='#attributes.old_process_line#'---> <!--- formda süreç olmadığı için sayfa çakıyordu bu nedenle kapatıldı daha sonra kontrol edilecek SG20120626--->
<cf_workcube_process
	is_upd='1'
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='SALARYPARAM_GET_REQUESTS'
	action_column='SPGR_ID'
	action_id='#get_max_period.result_id#'
	action_page='#request.self#?fuseaction=myhome.popupform_upd_other_payment_request_valid&id=#get_max_period.result_id#'
	warning_description = ' Taksitli Avans Talebi : get_max_period.result_id'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
