<!--- Bireysel Uye Sayfası --->	
<cfif isdefined("attributes.cid")>
	<cfset table_name = "CONSUMER_BANK">
	<cfset column_name = "CONSUMER">
	<cfset money_ = "MONEY">
	<cfset temp_id = attributes.cid>
<!--- Kurumsal Uye Sayfası --->	
<cfelseif isdefined("attributes.cpid")>
	<cfset table_name = "COMPANY_BANK">
	<cfset column_name = "COMPANY">
	<cfset money_ = "COMPANY_BANK_MONEY">
	<cfset temp_id = attributes.cpid>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
		<cfif isdefined("attributes.cid") or isdefined("attributes.cpid")>
			<cfquery name="UPD_BANK" datasource="#DSN#">
				UPDATE 
					#table_name#
				SET 
					#column_name#_BANK = '#attributes.bank_name#', 
					#money_# = '#attributes.money#', 
					#column_name#_BANK_BRANCH ='#attributes.branch_name#', 
					#column_name#_BANK_BRANCH_CODE = '#attributes.branch_code#',
					#column_name#_SWIFT_CODE = '#attributes.swift_code#',
					#column_name#_BANK_CODE = '#attributes.bank_code#',
					#column_name#_IBAN_CODE = <cfif len(attributes.iban_code)>'#attributes.iban_code#'<cfelse>NULL</cfif>,
					#column_name#_ACCOUNT_DEFAULT = <cfif isDefined("attributes.default_account")>1<cfelse>0</cfif>,
					#column_name#_ACCOUNT_NO = '#attributes.account_no#',
					UPDATE_DATE = #now()#,					
					UPDATE_IP = '#cgi.remote_addr#',
				<cfif isdefined("session.ep.userid")>
					<cfif isdefined("attributes.cid")>
					UPDATE_CONS = NULL,
					</cfif>
					UPDATE_EMP = #session.ep.userid#
				</cfif>
				<cfif isdefined("session.ww.userid")>
					UPDATE_CONS = #session.ww.userid#,
					UPDATE_EMP = NULL
				</cfif>
				<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,BANK_STAGE= '#attributes.process_stage#'</cfif>
				WHERE 
					#column_name#_BANK_ID = #attributes.bid#
			</cfquery>
			
			<cfif isdefined("attributes.default_account")>
				<cfquery name="UPD_DEFAULT_OTHER" datasource="#DSN#">
					UPDATE 
						#table_name# 
					SET
						#column_name#_ACCOUNT_DEFAULT = 0
					WHERE
						#column_name#_ID = #temp_id# AND
						#column_name#_BANK_ID <> #attributes.bid#
				</cfquery>
			</cfif>
		<cfelseif isdefined("attributes.employee_id")>
        	<cfif attributes.is_account_control eq 1><!---xml deki kontrol evet ise hesabı kontrol edecek. --->
			<cfquery name="control_" datasource="#dsn#">
				SELECT 
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				FROM 
					EMPLOYEES_BANK_ACCOUNTS EBA,
					EMPLOYEES E
				WHERE
					<cfif len(attributes.iban_code)> 
						EBA.IBAN_NO = '#attributes.iban_code#' AND 
					<cfelse> 
						EBA.BANK_ID = #listfirst(attributes.account_bank_id,';')# AND 
						EBA.BANK_ACCOUNT_NO = '#attributes.account_no#' AND 
						EBA.BANK_BRANCH_CODE = '#attributes.branch_code#' AND 
					</cfif> 
					EBA.EMPLOYEE_ID = E.EMPLOYEE_ID  
					AND EBA.EMP_BANK_ID <> #attributes.bid# 
			</cfquery>
			<cfif control_.recordcount>
				<script type="text/javascript">
					alert("Bu Banka Hesabı Kullanılmaktadır! Lütfen Kontrol Ediniz.\nÇalışan:<cfoutput>#control_.employee_name# #control_.employee_surname#</cfoutput>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			</cfif>
			<cfif isDefined("attributes.default_account")>
				<cfquery name="UPD_OTHER" datasource="#DSN#">
					UPDATE 
						EMPLOYEES_BANK_ACCOUNTS
					SET
						DEFAULT_ACCOUNT = 0
					WHERE
						EMP_BANK_ID <> #attributes.bid# AND 
						EMPLOYEE_ID = #attributes.employee_id#
				</cfquery>
			</cfif>
			
			<cfquery name="UPD_BANK" datasource="#DSN#">
				UPDATE
					EMPLOYEES_BANK_ACCOUNTS
				SET
					IBAN_NO = '#attributes.IBAN_CODE#',
					BANK_ACCOUNT_NO = '#attributes.ACCOUNT_NO#',
					BANK_BRANCH_CODE = '#attributes.BRANCH_CODE#',
					BANK_SWIFT_CODE = '#attributes.SWIFT_CODE#',
					BANK_BRANCH_NAME = '#attributes.BRANCH_NAME#',
					<cfif len(attributes.account_bank_id)>BANK_ID = #listfirst(attributes.account_bank_id,';')#,</cfif>
					BANK_NAME = '#attributes.BANK_NAME#',
				  <cfif isDefined("attributes.default_account")>
					DEFAULT_ACCOUNT = 1,
				  <cfelse>
					DEFAULT_ACCOUNT = 0,
				  </cfif>
					MONEY = '#MONEY#',
                    NAME = <cfif isdefined('attributes.name') and len(attributes.name)>'#attributes.name#'<cfelse>NULL</cfif>,
                    SURNAME = <cfif isdefined('attributes.surname') and len(attributes.surname)>'#attributes.surname#'<cfelse>NULL</cfif>,
                    TC_IDENTY_NO = <cfif isdefined('attributes.tc_identy_no') and len(attributes.tc_identy_no)>'#attributes.tc_identy_no#'<cfelse>NULL</cfif>,
                    JOIN_ACCOUNT_NAME = <cfif isdefined('attributes.join_account_name') and len(attributes.join_account_name)>'#attributes.join_account_name#'<cfelse>NULL</cfif>,
                    JOIN_ACCOUNT_SURNAME = <cfif isdefined('attributes.join_account_surname') and len(attributes.join_account_surname)>'#attributes.join_account_surname#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#',
					UPDATE_EMP = #session.ep.userid#
					<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,BANK_STAGE= '#attributes.process_stage#'</cfif>
				WHERE
					EMP_BANK_ID = #attributes.bid#
			</cfquery>
		</cfif>
		<cfif isdefined('attributes.process_stage') and  (isdefined("attributes.cpid") or isdefined("attributes.cid"))>
			<cf_workcube_process is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='#column_name#'
				action_column='BANK_STAGE'
				action_id='#temp_id#'
				action_page='#request.self#?fuseaction=objects.popup_form_upd_bank_account' 
				warning_description='Banka Hesabı'>
			<cfelseif isdefined("attributes.employee_id")>
			<cf_workcube_process is_upd='1'
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='EMPLOYEES_BANK_ACCOUNTS'
				action_column='BANK_STAGE'
				action_id='#attributes.EMPLOYEE_ID#'
				action_page='#request.self#?fuseaction=objects.popup_form_upd_bank_account' 
				warning_description='Banka Hesabı'>
			</cfif>
	</cftransaction>
</cflock>
<script>
	<cfif isDefined('attributes.draggable')>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'emp_bank_accounts');
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>