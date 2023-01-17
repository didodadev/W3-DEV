<cfif isdefined("attributes.form_add_request") and len(attributes.form_add_request) and attributes.form_add_request eq 0>
	<cfparam name="attributes.sal_mon" default="1">
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfscript>
				ay_sayisi= attributes.sal_mon + attributes.ins_period;
				sonraki_yil = session.ep.period_year+1;
			</cfscript>
			<cfset attributes.group_id = "">
			<cfset attributes.sal_year =  attributes.term>
			<cfif len(attributes.in_out_id)>
				<cfquery name="get_in_out" datasource="#dsn#">
					SELECT IN_OUT_ID,BRANCH_ID,PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
				</cfquery>
				<cfif len(get_in_out.puantaj_group_ids)>
					<cfset attributes.group_id = "#get_in_out.puantaj_group_ids#,">
				</cfif>
				<cfset attributes.branch_id = get_in_out.branch_id>
				<cfset not_kontrol_parameter = 1>
			</cfif>
			<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
			<cfquery name="get_all_payment_request" datasource="#dsn#">
				SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
			</cfquery>
			<cfif get_all_payment_request.recordcount gte get_program_parameters.yearly_payment_req_limit>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1217.Yıllık Avans Talebi Hakkınız Dolmuştur Avans Talebi Yapamazsınız'> !");
					window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.form_add_payment_request&event=add&is_installment=1</cfoutput>";
				</script>
				<cfabort>
			</cfif>
			<cfset max_count = get_program_parameters.YEARLY_PAYMENT_REQ_COUNT>
			<cfset my_month = attributes.sal_mon>
			<cfset my_year = attributes.term>
			<cfloop from="1" to="#get_program_parameters.YEARLY_PAYMENT_REQ_COUNT#" index="i">
				<cfset my_month = my_month-1>
				<cfif my_month gt 0>
					<cfquery name="get_payment_request" datasource="#dsn#">
						SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
					</cfquery>
					<cfif get_payment_request.recordcount>
						<cfset max_count = max_count -1>
					</cfif>
				<cfelse>
					<cfset my_month = 12>
					<cfset my_year = my_year - 1>
					<cfquery name="get_payment_request" datasource="#dsn#">
						SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
					</cfquery>
					<cfif get_payment_request.recordcount>
						<cfset max_count = max_count -1>
					</cfif>
				</cfif>
			</cfloop>
			<cfif max_count eq 0>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1216.Ardarda Girebileceğiniz Avans Talebi Limitini Aştınız Avans Talebi Yapamazsınız'> !");
					history.back(-1);
				</script>
				<cfabort>
			</cfif>
			<cfif not len(attributes.in_out_id)>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1215.Çalışanın Giriş Çıkış Bilgileri Eksik'> !");
					history.back(-1);
				</script>
				<cfabort>
			</cfif>
			<cfset ay=attributes.sal_mon>
			<cfquery name="add_row" datasource="#dsn#">
				INSERT INTO SALARYPARAM_GET_REQUESTS
					(
					COMMENT_GET,
					AMOUNT_GET,
					SHOW,
					METHOD_GET,
					PERIOD_GET, 
					START_SAL_MON,
					EMPLOYEE_ID,
					TERM,
					CALC_DAYS,
					ODKES_ID,
					FROM_SALARY,
					IN_OUT_ID,
					DETAIL,
					VALIDATOR_POSITION_CODE_1,
					VALIDATOR_POSITION_CODE_2,
					TAKSIT_NUMBER,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					PROCESS_STAGE
					)
				VALUES
					(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comment_get#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.toplam_tutar#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.show#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.method_get#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.periyod_get#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ay#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.calc_days#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.from_salary#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					<cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.validator_pos_code") and len(attributes.validator_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.validator_pos_code2") and len(attributes.validator_pos_code2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code2#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ins_period#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>

					)
			</cfquery>
			<!--- Mail gönderme İşlemleri --->
			<!--- Çalışan Mail --->
			<cfsavecontent variable="message"><cf_get_lang no='816.Taksitli Avans Talebi'></cfsavecontent>
			<cfquery name="get_employee_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			</cfquery>
			<cfif len(get_employee_mail.employee_email)>
				<cfmail to="#get_employee_mail.employee_email#"
					from="#session.ep.company#<#session.ep.COMPANY_EMAIL#>"
					subject="#message#" type="HTML">
					Sayın #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
					<br/><br/>
					#listgetat(ay_list(),attributes.sal_mon,',')# ayı için avans talebinde bulundunuz!<br/><br/>
					<a href="#employee_domain##request.self#?fuseaction=myhome.my_payment_request" target="_blank"><cf_get_lang no='1585.Taksitli Avans Takip Ekranı'></a> <br/><br/>
					
					<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
					<br/><br/>
					<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
				</cfmail>
			</cfif>
			<cfquery name="get_max_period" datasource="#DSN#">
				SELECT MAX(SPGR_ID) AS RESULT_ID  FROM SALARYPARAM_GET_REQUESTS
			</cfquery>
			<!---1.Amir Mail--->
			<cfquery name="get_emp_upper_pos_code" datasource="#dsn#">
				SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfquery>
			<cfif isdefined("attributes.validator_pos_code") and len(attributes.validator_pos_code) and (session.ep.position_code neq get_emp_upper_pos_code.upper_position_code and session.ep.position_code neq get_emp_upper_pos_code.upper_position_code2)>
				<cfsavecontent variable="message"><cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
				<cfquery name="get_validate_mail" datasource="#dsn#">
					SELECT E.EMPLOYEE_EMAIL,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code#">
				</cfquery>
				<cfif len(get_validate_mail.EMPLOYEE_EMAIL)>
					<cfmail to="#get_validate_mail.EMPLOYEE_EMAIL#"
						from="#session.ep.company#<#session.ep.company_email#>"
						subject="#message#" type="HTML">
						Sayın #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
						<br/><br/>
						<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #listgetat(ay_list(),attributes.sal_mon,',')# ayı için avans talebinde bulunmuştur.Onayınız Bekleniyor !<br/><br/>
						<a href="#employee_domain##request.self#?fuseaction=myhome.my_payment_request" target="_blank"><cf_get_lang no='69.Avans Taleplerim'></a> <br/><br/>
						
						<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
						<br/><br/>
						<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
					</cfmail>
				</cfif>
			<cfelseif session.ep.position_code eq get_emp_upper_pos_code.upper_position_code>
				<cfquery name="upd_valid_1" datasource="#DSN#">
					UPDATE SALARYPARAM_GET_REQUESTS SET VALID_1 = 1,VALID_EMPLOYEE_ID_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> WHERE SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_period.result_id#">
				</cfquery>
			<cfelseif session.ep.position_code eq get_emp_upper_pos_code.upper_position_code2>
				<cfquery name="upd_valid_1" datasource="#DSN#">
					UPDATE SALARYPARAM_GET_REQUESTS SET VALID_1 = 1,VALID_2 = 1 WHERE SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_period.result_id#">
				</cfquery>
			</cfif>
			<cf_workcube_process
				is_upd='1'
				old_process_line='0'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='SALARYPARAM_GET_REQUESTS'
				action_column='SPGR_ID'
				action_id='#get_max_period.result_id#'
				action_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payment_request&id=#contentEncryptingandDecodingAES(isEncode:1,content:get_max_period.result_id,accountKey:'wrk')#"
				warning_description = 'Taksitli Avans Talebi : #get_max_period.result_id#'>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		/* 	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.my_detail&section=myhome.my_extre</cfoutput>";
		*/
		location.href=document.referrer;
	</script>
<cfelse>
	<cf_date tarih='attributes.due_date'>
	<cfparam name="attributes.sal_mon" default="1"> 
	<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
		SELECT BRANCH_ID,PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND FINISH_DATE IS NULL ORDER BY START_DATE DESC
	</cfquery>
	<cfset attributes.sal_year = year(attributes.due_date)>
	<cfset attributes.sal_mon = month(attributes.due_date)>
	<cfset attributes.group_id = "">
	<cfset attributes.branch_id = "">
	<cfif len(get_in_out.puantaj_group_ids)>
		<cfset attributes.group_id = "#get_in_out.puantaj_group_ids#,">
	</cfif>
	<cfif len(get_in_out.branch_id)>
		<cfset attributes.branch_id = get_in_out.branch_id>
	</cfif>
	<cfset not_kontrol_parameter = 1>
	<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
	<cfset tarih = "01/01/#session.ep.period_year#">
	<cfset tarih = CreateODBCDateTime(tarih)>
	<cfquery name="get_all_payment_request" datasource="#dsn#">
		SELECT 
			ID AS ID
		FROM 
			CORRESPONDENCE_PAYMENT 
		WHERE 
			TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND 
			DUEDATE > = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih#">
		UNION ALL
		SELECT 
			SPGR_ID AS ID
		FROM 
			SALARYPARAM_GET_REQUESTS 
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND 
			TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
	</cfquery>
	<cfif get_all_payment_request.recordcount gte get_program_parameters.yearly_payment_req_limit>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1218.Yıllık Avans Talebi Hakkınız Dolmuştur Avans Talebi Yapamazsınız'> !");
			window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.form_add_payment_request&event=add&is_installment=1</cfoutput>";
		</script>
		<cfabort>
	</cfif>
	<cfset max_count = get_program_parameters.yearly_payment_req_count>
	<cfset my_month = month(attributes.due_date)>
	<cfset my_year = year(attributes.due_date)>
	<cfloop from="1" to="#get_program_parameters.yearly_payment_req_count#" index="i">
		<cfset my_month = my_month-1>
		<cfif my_month gt 0>
			<cfquery name="get_payment_request" datasource="#dsn#">
				SELECT * FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND YEAR(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND MONTH(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
			</cfquery>
			<cfquery name="get_other_payment_request" datasource="#dsn#">
				SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
			</cfquery>
			<cfif get_payment_request.recordcount or get_other_payment_request.recordcount>
				<cfset max_count = max_count -1>
			</cfif>
		<cfelse>
			<cfset my_month = 12>
			<cfset my_year = my_year - 1>
			<cfquery name="get_payment_request" datasource="#dsn#">
				SELECT * FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND YEAR(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND MONTH(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
			</cfquery>
			<cfquery name="get_other_payment_request" datasource="#dsn#">
				SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_year#"> AND START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_month#">
			</cfquery>
			<cfif get_payment_request.recordcount or get_other_payment_request.recordcount>
				<cfset max_count = max_count -1>
			</cfif>
		</cfif>
	</cfloop>
	<cfif max_count eq 0>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1219.Ardarda Girebileceğiniz Avans Talebi Limitini Aştınız Avans Talebi Yapamazsınız'> !");
			history.back(-1);
		</script>
		<cfabort>
	</cfif>
	<cfset CC_EMPS = attributes.EMP_ID_CC>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="ADD_PAYMENT_REQUEST" datasource="#dsn#">
				INSERT INTO
					CORRESPONDENCE_PAYMENT
				(
					<cfif len(cc_emps)>
						CC_EMP,
					</cfif>
					RECORD_EMP,
					RECORD_DATE,
					PRIORITY,
					DUEDATE,
					PAYMETHOD_ID,
					TO_EMPLOYEE_ID,
					AMOUNT,
					MONEY,
					<cfif isdefined('attributes.detail')>
						DETAIL,
					</cfif>
					PROCESS_STAGE,
					SUBJECT,
					PERIOD_ID,
					DEMAND_TYPE
				)
				VALUES
				(
					<cfif len(cc_emps)>
						'#CC_EMPS#',
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#priority#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date#">,
					<cfif isdefined("attributes.pay_method") and len(attributes.pay_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"></cfif>,
					<cfqueryparam cfsqltype="cf_sql_float" value="#amount#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_id#">,
					<cfif isdefined('attributes.detail')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
					</cfif>
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
					<cfif isdefined("attributes.demand_type") and len(attributes.demand_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_type#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<!--- Mail gönderme İşlemleri --->
			
			<!--- Çalışan Mail --->
			<cfsavecontent variable="message"><cf_get_lang no='157.Avans Talebi'></cfsavecontent>
			<cfsavecontent variable="message_head">
				<cfoutput>
				<a href="#employee_domain##request.self#?fuseaction=myhome.my_payment_request" target="_blank"><cf_get_lang no='1592.Avans Takip Ekranı'></a> <br/><br/>
				</cfoutput>	
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz'><br/><br/>
			</cfsavecontent>
			<cfquery name="get_employee_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
			</cfquery>
			
			<cfif len(get_employee_mail.employee_email)>
				<cfmail to="#get_employee_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
					<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
					<br/><br/>
					#dateformat(attributes.due_date,dateformat_style)# tarihinde #amount# #money_id# tutarında avans talebinde bulundunuz!<br/><br/>
					
					#message_head#
				</cfmail>
			</cfif>
			
			<!--- Bilgi verilecek mail --->
			<cfif len(attributes.emp_id_cc)>
				<cfsavecontent variable="message"><cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
				<cfquery name="get_validate_mail" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id_cc#">
				</cfquery>
				<cfif len(get_validate_mail.employee_email)>
					<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
						<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
						<br/><br/>
						<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> #dateformat(attributes.due_date,dateformat_style)# tarihinde #amount# #money_id# tutarında avans talebinde bulunmuştur!<br/><br/>
						
						#message_head#
					</cfmail>
				</cfif>
			</cfif>
			<cfquery name="get_max_period" datasource="#DSN#">
				SELECT MAX(ID) AS RESULT_ID  FROM CORRESPONDENCE_PAYMENT
			</cfquery>
			<cfquery name="get_emp_upper_pos_code" datasource="#dsn#">
				SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
			</cfquery>
			<!--- 1. Amir Mail
			<cfif len(attributes.validator_pos_code) and (session.ep.position_code neq get_emp_upper_pos_code.upper_position_code and session.ep.position_code neq get_emp_upper_pos_code.upper_position_code2)>
				<cfsavecontent variable="message"><cf_get_lang no='1588.Avans Talep Onayı'></cfsavecontent>
				<cfquery name="get_validate_mail" datasource="#dsn#">
					SELECT E.EMPLOYEE_EMAIL,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code#">
				</cfquery>
				<cfif len(get_validate_mail.employee_email)>
					<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html" charset="utf-8">
						<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
						<br/><br/>
						<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> #dateformat(attributes.due_date,dateformat_style)# tarihinde #amount# #money_id# tutarında avans talebinde bulunmuştur. Onayınız Bekleniyor !<br/><br/>

						#message_head#
					</cfmail>
				</cfif>
			<cfelseif session.ep.position_code eq get_emp_upper_pos_code.upper_position_code>
				<cfquery name="upd_valid_1" datasource="#DSN#">
					UPDATE CORRESPONDENCE_PAYMENT SET VALID_1 = 1,VALID_EMPLOYEE_ID_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_period.result_id#">
				</cfquery>
			<cfelseif session.ep.position_code eq get_emp_upper_pos_code.upper_position_code2>
				<cfquery name="upd_valid_2" datasource="#DSN#">
					UPDATE CORRESPONDENCE_PAYMENT SET VALID_1 = 1,VALID_2 = 1,VALID_EMPLOYEE_ID_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_period.result_id#">
				</cfquery>
			</cfif> --->
			<cf_workcube_process
				is_upd='1'
				old_process_line='0'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='CORRESPONDENCE_PAYMENT'
				action_column='ID'
				action_id='#get_max_period.result_id#'
				action_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payment_request&id=#contentEncryptingandDecodingAES(isEncode:1,content:get_max_period.result_id,accountKey:'wrk')#"
				warning_description = 'Avans Talebi : #attributes.subject#'>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		<cfif isdefined("attributes.from_hr") and attributes.from_hr eq 1>
			self.close();
		<cfelse>
			window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.form_add_payment_request&event=upd&id=#contentEncryptingandDecodingAES(isEncode:1,content:get_max_period.result_id,accountKey:'wrk')#</cfoutput>";
		</cfif>
	</script>
</cfif>