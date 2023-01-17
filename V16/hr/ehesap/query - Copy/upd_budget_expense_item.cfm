<cfquery name="UPD_EXPENSE_ITEM" datasource="#dsn2#">
	UPDATE 
		EXPENSE_ITEMS
	SET
		EXPENSE_CATEGORY_ID = #attributes.expense_cat#,
		EXPENSE_ITEM_NAME = '#attributes.expense_item_name#',
		EXPENSE_ITEM_DETAIL = '#attributes.expense_item_detail#',	
		ACCOUNT_CODE = <cfif isdefined("attributes.account_id") and len(attributes.account_id)>'#attributes.account_id#'<cfelse>NULL</cfif>,		
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE
		EXPENSE_ITEM_ID=#attributes.expense_item_id#	
</cfquery>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
		location.href= document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
