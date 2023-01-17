<!--- Bireysel Uye Sayfası--->
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
		<cfif isdefined("attributes.cpid") or isdefined("attributes.cid")>
			<cfquery name="ADD_BANK" datasource="#DSN#" result="MAX_ID">
				INSERT INTO
					#table_name#
				(
					#column_name#_ID,
					#column_name#_BANK, 
					#column_name#_BANK_CODE, 
					#column_name#_IBAN_CODE, 
					#column_name#_BANK_BRANCH,
					#column_name#_BANK_BRANCH_CODE,
					#column_name#_SWIFT_CODE,
					#column_name#_ACCOUNT_NO,
					#column_name#_ACCOUNT_DEFAULT,
					#money_#,
					RECORD_DATE,
					RECORD_IP,
				<cfif isdefined("session.ep.userid")>
					RECORD_EMP
				</cfif>
				<cfif isdefined("session.ww.userid")>
					RECORD_CONS
				</cfif>
				<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,BANK_STAGE</cfif>
				)
				VALUES
				(
					#temp_id#, 
					'#attributes.BANK_NAME#', 
					'#attributes.BANK_CODE#', 
					<cfif len(attributes.iban_code)>'#attributes.iban_code#'<cfelse>NULL</cfif>, 
					'#attributes.BRANCH_NAME#', 
					'#attributes.BRANCH_CODE#',
					'#attributes.SWIFT_CODE#',
					'#attributes.ACCOUNT_NO#', 
				<cfif isdefined("form.default_account")>1<cfelse>0</cfif>,
					'#attributes.money#',
					 #now()#,
					 '#cgi.remote_addr#',
				 <cfif isdefined("session.ep.userid")>
					 #session.ep.userid#
				</cfif>
				<cfif isdefined("session.ww.userid")>
					#session.ww.userid#
				</cfif>
				<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,'#attributes.process_stage#'</cfif>
				)
			</cfquery>
			<cfif isdefined("form.default_account")>
				<cfquery name="UPD_default_other" datasource="#dsn#">
					UPDATE 
						#table_name# 
					SET
						#column_name#_ACCOUNT_DEFAULT = 0
					WHERE
						#column_name#_ID = #temp_id# AND
						#column_name#_BANK_ID <> #MAX_ID.IDENTITYCOL#
           	    </cfquery>
			</cfif>
		<cfelseif isdefined("attributes.employee_id")>
			<cfif attributes.is_account_control eq 1><!---xml deki kontrol evet ise hesabı kontrol edecek. --->
            <cfquery name="control_" datasource="#dsn#">
				SELECT 
					EBA.BANK_ACCOUNT_NO,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				FROM 
					EMPLOYEES_BANK_ACCOUNTS EBA,
					EMPLOYEES E 
				WHERE
					<cfif len(attributes.IBAN_CODE)>
					EBA.IBAN_NO = '#attributes.IBAN_CODE#' AND
					<cfelse>
					EBA.BANK_ID = #listfirst(attributes.account_bank_id,';')# AND
					EBA.BANK_ACCOUNT_NO = '#attributes.ACCOUNT_NO#' AND
					EBA.BANK_BRANCH_CODE = '#attributes.BRANCH_CODE#' AND
					</cfif>
					EBA.EMPLOYEE_ID = E.EMPLOYEE_ID
			</cfquery>
			<cfif control_.recordcount>
				<script type="text/javascript">
					alert("Bu Banka Hesabı Kullanılmaktadır! Lütfen Kontrol Ediniz\nÇalışan:<cfoutput>#control_.EMPLOYEE_NAME# #control_.EMPLOYEE_SURNAME#</cfoutput>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
            </cfif>
			<cfif isDefined("attributes.default_account")>
				<cfquery name="UPD_BANK" datasource="#DSN#">
					UPDATE 
						EMPLOYEES_BANK_ACCOUNTS
					SET
						DEFAULT_ACCOUNT = 0
					WHERE
						EMPLOYEE_ID = #EMPLOYEE_ID#
				</cfquery>
			</cfif>
				
			<cfquery name="ADD_BANK" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_BANK_ACCOUNTS
				(
					IBAN_NO,
					BANK_ACCOUNT_NO,
					BANK_BRANCH_CODE,
					BANK_SWIFT_CODE,
					BANK_BRANCH_NAME,
					BANK_ID,
					BANK_NAME,
					EMPLOYEE_ID,
					DEFAULT_ACCOUNT,
					MONEY,
                    NAME,
                    SURNAME,
                    TC_IDENTY_NO,
                    JOIN_ACCOUNT_NAME,
                    JOIN_ACCOUNT_SURNAME,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
					<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,BANK_STAGE</cfif>
				)
				VALUES
				(
					<cfif len(attributes.iban_code)>'#attributes.iban_code#'<cfelse>NULL</cfif>,
					'#attributes.ACCOUNT_NO#',
					'#attributes.BRANCH_CODE#',
					'#attributes.SWIFT_CODE#',
					'#attributes.BRANCH_NAME#',
					<cfif len(attributes.account_bank_id)>#listfirst(attributes.account_bank_id,';')#<cfelse>NULL</cfif>,
					'#attributes.BANK_NAME#',
					#attributes.EMPLOYEE_ID#,
				<cfif isDefined("attributes.default_account")>
				   1,
				<cfelse>
				   0,
				</cfif>
					'#attributes.money#',
                   	<cfif isdefined('attributes.name') and len(attributes.name)>'#attributes.name#'<cfelse>NULL</cfif>,
                   	<cfif isdefined('attributes.surname') and len(attributes.surname)>'#attributes.surname#'<cfelse>NULL</cfif>,
                   	<cfif isdefined('attributes.tc_identy_no') and len(attributes.tc_identy_no)>'#attributes.tc_identy_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.join_account_name') and len(attributes.join_account_name)>'#attributes.join_account_name#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.join_account_surname') and len(attributes.join_account_surname)>'#attributes.join_account_surname#'<cfelse>NULL</cfif>,
                    #session.ep.userid#,
					#now()#,
					'#cgi.REMOTE_ADDR#'
					<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>,'#attributes.process_stage#'</cfif>
				)
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
		action_page='#request.self#?fuseaction=objects.popup_form_add_bank_account' 
		warning_description='Banka Hesabı'>
	<cfelseif isdefined("attributes.employee_id") and isdefined("attributes.process_stage")>
	<cf_workcube_process is_upd='1'
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EMPLOYEES_BANK_ACCOUNTS'
		action_column='BANK_STAGE'
		action_id='#attributes.EMPLOYEE_ID#'
		action_page='#request.self#?fuseaction=objects.popup_form_add_bank_account' 
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