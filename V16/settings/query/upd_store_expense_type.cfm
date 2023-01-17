<cfquery name="ADD_expense_type" datasource="#dsn#">
	UPDATE 
		STORE_EXPENSE_TYPE 
	SET 
		EXPENSE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_type#">,
		EXPENSE_TYPE_DETAIL = <cfif len(attributes.expense_type_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_type_detail#">,<cfelse>null,</cfif>
		ACCOUNT_CODE = <cfif len(attributes.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">,<cfelse>null,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE
		EXPENSE_TYPE_ID  = #ATTRIBUTES.EXPENSE_TYPE_ID#
</cfquery>

 <script>
location.href="<cfoutput>#request.self#?fuseaction=settings.form_upd_store_expense_type&expense_type_id=#attributes.expense_type_id#</cfoutput>"
 </script>