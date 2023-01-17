<cfquery name="upd_travel_demand" datasource="#dsn#">
	UPDATE
		EMPLOYEES_TRAVEL_DEMAND
	SET
		DEMAND_STAGE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#
	WHERE
		TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.travel_demand_id#">
</cfquery>

<cfquery name="get_travel_demand" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRAVEL_DEMAND_ID#">
</cfquery>

<cfquery name="get_employee_mail" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_travel_demand.employee_id#">
</cfquery>

<cfif isDefined("validator_position_1") and len(validator_position_1)>
	<cfif isdefined("valid_1") and len(valid_1)>
		<cfif len(get_employee_mail.employee_email)>
			<cfmail to="#get_employee_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Seyahat Talebi" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
				<br/><br/>
				#dateformat(get_travel_demand.departure_date,dateformat_style)# tarihinde seyahat talebiniz birinci amiriniz tarafından <cfif valid_1 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.list_travel_demands" target="_blank">Seyahat Talebi Takip Ekranı</a> <br/><br/>
				
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>
	<cfif isdefined("valid_1") and valid_1 eq 1 and len(get_travel_demand.manager2_pos_code)>
		<cfquery name="get_validate_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_travel_demand.manager2_pos_code#">
		</cfquery>
		<cfif len(get_validate_mail.employee_email)>
			<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Seyahat Talebi Onayı (İkinci Amir)" type="HTML">
				<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
				<br/><br/>
				<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(get_travel_demand.departure_date,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.list_travel_demands" target="_blank">Seyahat Talebi Takip Ekranı</a> <br/><br/>
				
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
			#dateformat(get_travel_demand.departure_date,dateformat_style)# tarihinde seyahat talebiniz ikinci amiriniz tarafından <cfif valid_2 eq 1>kabul edilmiştir.<cfelse>reddedilmiştir.</cfif> <br/><br/>
			<a href="#employee_domain##request.self#?fuseaction=myhome.list_travel_demands" target="_blank">Seyahat Talebi Takip Ekranı</a> <br/><br/>
			
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
	action_table='EMPLOYEES_TRAVEL_DEMAND'
	action_column='TRAVEL_DEMAND_ID'
	action_id='#attributes.TRAVEL_DEMAND_ID#'
	action_page='#request.self#?fuseaction=myhome.travel_demand_approve&event=upd&travel_demand_id=#attributes.travel_demand_id#'
	warning_description='Seyahat Talebi'>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.travel_demand_approve&event=upd&travel_demand_id=#attributes.travel_demand_id#</cfoutput>";
</script>
