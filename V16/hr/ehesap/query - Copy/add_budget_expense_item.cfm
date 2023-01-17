<cfquery name="add_expense_cat" datasource="#dsn2#">
	INSERT 
	INTO 
		EXPENSE_ITEMS
		(
			EXPENSE_CATEGORY_ID,
			EXPENSE_ITEM_NAME,
			EXPENSE_ITEM_DETAIL,		
			ACCOUNT_CODE,			
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			#attributes.expense_cat#,
			'#attributes.expense_item_name#',
			'#attributes.expense_item_detail#',					
			<cfif isdefined("attributes.account_id") and len(attributes.account_id)>'#attributes.account_id#'<cfelse>NULL</cfif>,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			#now()#
		)
</cfquery>
<script type="text/javascript">
		<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
			location.href= document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
</script>
