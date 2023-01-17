<cfif isdefined("attributes.payroll_id")>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
		SET
			DEFINITION = '#attributes.definition#',
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_DATE = #NOW()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			<!---OUR_COMPANY_ID = #session.ep.company_id#,--->
			PAYROLL_STATUS = <cfif isdefined("attributes.account_type_status")>1<cfelse>0</cfif>
		WHERE
			PAYROLL_ID = #attributes.payroll_id#
	</cfquery>
	<cfquery name="DEL_PAYROLL_ACCOUNTS_ROWS" datasource="#DSN#">
		DELETE FROM SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID= #attributes.payroll_id#
	</cfquery>
	<cfset new_payroll_id = attributes.payroll_id>
    <cfset attributes.actionId =  attributes.payroll_id>
<cfelse>
	<cfquery name="add_payroll_accounts" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
			(
				DEFINITION,
				PAYROLL_STATUS,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				<!---,OUR_COMPANY_ID--->
			)
		VALUES
			(
				'#attributes.definition#',
				<cfif isdefined("attributes.account_type_status")>1<cfelse>0</cfif>,
				#NOW()#,
				#SESSION.EP.USERID#,
			   '#CGI.REMOTE_ADDR#'
			    <!---,#session.ep.company_id#--->
			)
	</cfquery>
	<cfset new_payroll_id = MAX_ID.IDENTITYCOL>
    <cfset attributes.actionId =  MAX_ID.IDENTITYCOL>
</cfif>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfscript>
			attributes.ACCOUNT_CODE = Evaluate("attributes.ACCOUNT_CODE#i#");
			attributes.ACCOUNT_NAME = Evaluate("attributes.ACCOUNT_NAME#i#");
			attributes.BUDGET_ITEM = Evaluate("attributes.BUDGET_ITEM#i#");
			attributes.BUDGET_NAME = Evaluate("attributes.BUDGET_NAME#i#");
			attributes.borc_alacak = Evaluate("attributes.borc_alacak#i#");
			attributes.puantaj_account_name_list = Evaluate("attributes.puantaj_account_name_list#i#");
			attributes.puantaj_account = Evaluate("attributes.puantaj_account#i#");
			attributes.comment_pay_id = Evaluate("attributes.comment_pay_id#i#");
			attributes.puantaj_account_definition = Evaluate("attributes.puantaj_account_definition#i#");
		</cfscript>
		<cfquery name="add_payroll_accounts_row" datasource="#dsn#">
			INSERT INTO 
				SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS 
			(
				PAYROLL_ID, 
				PUANTAJ_ACCOUNT_COL, 
				ACCOUNT_CODE,
				BUDGET_ITEM,
				PUANTAJ_BORC_ALACAK, 
				PUANTAJ_ACCOUNT_DEFINITION,
				PUANTAJ_ACCOUNT,
				COMMENT_PAY_ID,
				IS_PROJECT,
				IS_NET,
                IS_EXPENSE,
				RECORD_DATE,
				RECORD_IP ,
				RECORD_EMP 
			)
			VALUES
			(	
				#new_payroll_id#,
				'#attributes.puantaj_account_name_list#',
				<cfif len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)>'#attributes.ACCOUNT_CODE#'<cfelse>NULL</cfif>,
				<cfif len(attributes.BUDGET_ITEM) and len(attributes.BUDGET_NAME)>#attributes.BUDGET_ITEM#<cfelse>NULL</cfif>,
				#attributes.borc_alacak#,
				'#attributes.puantaj_account_definition#',
				<cfif len(attributes.puantaj_account)>'#attributes.puantaj_account#'<cfelse>NULL</cfif>,				
				<cfif len(attributes.comment_pay_id)>#attributes.comment_pay_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_project#i#")>1<cfelse>0</cfif>,			
				<cfif isdefined("attributes.is_net#i#") and len(evaluate("attributes.is_net#i#"))>#evaluate("attributes.is_net#i#")#<cfelse>0</cfif>,			
				<cfif isdefined("attributes.is_expense#i#") and len(evaluate("attributes.is_expense#i#"))>#evaluate("attributes.is_expense#i#")#<cfelse>0</cfif>,			
                #now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#
			)
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.modal_id")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_payroll_accounts&form_submitted=1</cfoutput>"
</script>
