<cfif len(head_exp_code)>
	<cfset EXPENSE_CODE=head_exp_code & "." & exp_code >
<cfelse>
	<cfset EXPENSE_CODE= exp_code >
	<cfset head_exp_code="">
</cfif>

<cfset url_string = "">
<cfif isdefined("field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>

<cfif isdefined("field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>

<cfif isdefined("code")>
	<cfset url_string = "#url_string#&code=#code#">
</cfif>
<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn_expense#">
	SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID <> #attributes.expense_id# AND EXPENSE_CODE='#EXPENSE_CODE#'
</cfquery>	

<cfif GET_EXPENSE.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='277.Girdiğiniz Masraf/Gelir Merkezi Kodu Kullanılıyor'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="UPD_EXPENSE" datasource="#dsn_expense#">
		UPDATE
			EXPENSE_CENTER 
		SET
			EXPENSE_CODE = <cfif len(head_exp_code) or len(exp_code)>'#EXPENSE_CODE#',<cfelse>NULL,</cfif>
			EXPENSE = '#EXPENSE_NAME#',
			DETAIL = '#DETAIL#',
			EXPENSE_ACTIVE = <cfif isdefined("attributes.active") and attributes.active eq 1>1<cfelse>0</cfif>,
			EXPENSE_BRANCH_ID =  <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_EMP_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #NOW()#,
			ACTIVITY_ID = <cfif len(attributes.activity_id)>#attributes.activity_id#<cfelse>null</cfif>
		WHERE
			EXPENSE_ID = #EXPENSE_ID#
	</cfquery>

	<cfif HIERARCHY eq 1>
		<cfset bas = len(form.old_expense)+1>
		<cfquery name="SUB_EXPENSES" datasource="#dsn_expense#">
			UPDATE
				EXPENSE_CENTER
			SET
				EXPENSE_CODE = '#EXPENSE_CODE#.' + RIGHT(EXPENSE_CODE,LEN(EXPENSE_CODE)-#BAS#),
				EXPENSE_ACTIVE=<cfif isDefined("attributes.active") and attributes.active eq 1>1<cfelse>0</cfif>,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_EMP_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()#	
			WHERE
				EXPENSE_CODE LIKE '#FORM.OLD_EXPENSE#.%'
		</cfquery>
	</cfif>

	<cfif len(head_exp_code)>
		<cfquery name="UPD_MAIN_EXPENSE" datasource="#dsn_expense#">
			UPDATE EXPENSE_CENTER SET HIERARCHY= 1 WHERE EXPENSE_CODE = '#head_exp_code#'
		</cfquery>
	</cfif>	
 </cftransaction>
</cflock>
<script type="text/javascript">
location.href = document.referrer;
	wrk_opener_reload();
	window.close();
</script>
