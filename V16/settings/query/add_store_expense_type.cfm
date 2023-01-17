<cfquery name="ADD_expense_type" datasource="#dsn#">
		INSERT INTO 
		STORE_EXPENSE_TYPE
			(
				EXPENSE_TYPE,
				EXPENSE_TYPE_DETAIL,
				ACCOUNT_CODE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			) 
		VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_type#">,
				<cfif len(attributes.expense_type_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_type_detail#">,<cfelse>null,</cfif>
				<cfif len(attributes.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">,<cfelse>null,</cfif>
				#SESSION.EP.USERID#,
				#NOW()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
			)
</cfquery>
<script>
	location.href=document.referrer;
</script>