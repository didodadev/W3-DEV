<cfif len(head_exp_code)>
	<cfset expense_code = head_exp_code & "." & exp_code>
<cfelse>
	<cfset expense_code = exp_code>
</cfif>
<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn_expense#">
	SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_CODE= '#EXPENSE_CODE#'
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
	<cfquery name="ADD_EXPENSE_CENTER" datasource="#dsn_expense#">
		INSERT INTO 
			EXPENSE_CENTER
		(
			EXPENSE,
			EXPENSE_CODE,
			DETAIL,
			RECORD_EMP,
			EXPENSE_ACTIVE,
			RECORD_EMP_IP,
			RECORD_DATE,
			ACTIVITY_ID
		)
		VALUES
		(
			'#EXPENSE_NAME#',
			'#EXPENSE_CODE#',
			'#EXPENSE_DETAIL#',
			#session.ep.userid#,
			1,
			'#cgi.remote_addr#',
			#now()#,
			<cfif len(attributes.activity_id)>#attributes.activity_id#<cfelse>null</cfif>
		)
	</cfquery>

	<cfif len(head_exp_code)>
		<cfquery name="UPD_MAIN_EXPENSE" datasource="#dsn_expense#">
			UPDATE EXPENSE_CENTER SET HIERARCHY = 1 WHERE EXPENSE_CODE = '#head_exp_code#'
		</cfquery>
	</cfif>	
 </cftransaction>
</cflock>
<script type="text/javascript">
location.href= document.referrer;
	wrk_opener_reload();
	self.close();
</script>
