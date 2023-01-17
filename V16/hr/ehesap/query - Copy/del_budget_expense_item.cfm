<cfquery name="DEL_EXPENSE_ITEM" datasource="#dsn2#">
	DELETE
	FROM 
		EXPENSE_ITEMS
	WHERE 
		EXPENSE_ITEM_ID=#ATTRIBUTES.ITEM_ID#
</cfquery>
<script type="text/javascript">
	<cfoutput>
		window.location.href = '#request.self#?fuseaction=ehesap.list_expense_item';
	</cfoutput>
</script>
