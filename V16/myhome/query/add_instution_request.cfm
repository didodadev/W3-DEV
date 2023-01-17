<!--- myhome\query\add_payment_request.cfm  sayfasına taşındı--->
<!--- <cfparam name="attributes.sal_mon" default="1">
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
				history.back(-1);
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
				RECORD_IP
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
				<cfif len(attributes.validator_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code#"><cfelse>NULL</cfif>,
				<cfif len(attributes.validator_pos_code2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code2#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ins_period#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
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
				from="#session.ep.company#<#session.ep.company_email#>"
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
	<cfif len(attributes.validator_pos_code) and (session.ep.position_code neq get_emp_upper_pos_code.upper_position_code and session.ep.position_code neq get_emp_upper_pos_code.upper_position_code2)>
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
</cftransaction>
</cflock>
<script type="text/javascript">
/* 	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.my_detail&section=myhome.my_extre</cfoutput>";
 */
wrk_opener_reload();
self.close();
 </script>
 --->