<cfif len(head_exp_code)>
	<cfset expense_code = head_exp_code & "." & exp_code>
<cfelse>
	<cfset expense_code = exp_code>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
	SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_CODE= '#EXPENSE_CODE#'
</cfquery>	
<cfif GET_EXPENSE.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='20.Girdiğiniz Masraf/Gelir Merkezi Kodu Kullanılıyor'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="ADD_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
		INSERT INTO
			EXPENSE_CENTER
				(
					EXPENSE,
					EXPENSE_CODE,
					DETAIL,
					RESPONSIBLE1,
					RESPONSIBLE2,
					RESPONSIBLE3,	
					EXPENSE_ACTIVE,
					IS_PRODUCTION,
					COMPANY_ID,
					ACTIVITY_ID,
					WORKGROUP_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_EMP_IP,
					EXPENSE_BRANCH_ID,
					EXPENSE_DEPARTMENT_ID,
					IS_GENERAL
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_NAME#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_DETAIL#">,
					<cfif len(pos_code_text1) and len(ATTRIBUTES.POS_CODE1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE1#">,<cfelse>NULL,</cfif>
					<cfif len(pos_code_text2) and len(ATTRIBUTES.POS_CODE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE2#">,<cfelse>NULL,</cfif>
					<cfif len(pos_code_text3) and len(ATTRIBUTES.POS_CODE3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE3#">,<cfelse>NULL,</cfif>
					 1,
					<cfif isdefined("is_production")>1,<cfelse>0,</cfif>
					<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>null,</cfif>
					<cfif len(attributes.activity_id)>#attributes.activity_id#,<cfelse>null,</cfif>
					<cfif len(attributes.workgroup_id)>#attributes.workgroup_id#,<cfelse>null,</cfif>
					#SESSION.EP.USERID#,
					#NOW()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfif len(attributes.branch)>#attributes.branch#<cfelse>null</cfif>,
					<cfif len(attributes.department)>#attributes.department#<cfelse>null</cfif>,
					<cfif isdefined('attributes.is_general')>1<cfelse>0</cfif>
				)
	</cfquery>
	<cfif len(head_exp_code)>
		<cfquery name="UPD_MAIN_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
			UPDATE EXPENSE_CENTER SET HIERARCHY = 1 WHERE EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#head_exp_code#">
		</cfquery>
	</cfif>	
 </cftransaction>
</cflock>
<script type="text/javascript">
    location.reload();
	wrk_opener_reload();
	self.close();
</script>
	
