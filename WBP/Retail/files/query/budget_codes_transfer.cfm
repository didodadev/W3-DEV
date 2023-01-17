<cfquery name="upd_" datasource="#dsn2#">
	UPDATE
    	EXPENSE_ITEMS
    SET
    	STOCK_ID = (SELECT TOP 1 STOCK_ID FROM #dsn#_#session.ep.period_year-1#_#session.ep.company_id#.EXPENSE_ITEMS EI WHERE EI.EXPENSE_ITEM_NAME = EXPENSE_ITEMS.EXPENSE_ITEM_NAME)
</cfquery>
<script>
	alert('Aktarım Tamamlandı!');
	window.close();
</script>