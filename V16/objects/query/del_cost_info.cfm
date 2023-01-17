<cfquery name="DEL_COST_INFO" datasource="#dsn2#">
	DELETE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.invoice_row_id#  AND EXPENSE_COST_TYPE = #attributes.invoice_cat#
</cfquery>
<cfif not isdefined("attributes.is_stock_fis")>
	<cfquery name="COST_CONTROL" datasource="#DSN2#">
		SELECT INVOICE_ID FROM EXPENSE_ITEMS_ROWS WHERE INVOICE_ID= #attributes.invoice_id# 
	</cfquery>
	<cfif COST_CONTROL.recordcount eq 0>
		<cfquery name="UPD_COST_CONTROL" datasource="#dsn2#">
			UPDATE INVOICE SET IS_COST=0 WHERE INVOICE_ID= #attributes.invoice_id#
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="COST_CONTROL" datasource="#DSN2#">
		SELECT STOCK_FIS_ID FROM EXPENSE_ITEMS_ROWS WHERE STOCK_FIS_ID= #attributes.invoice_id# 
	</cfquery>
	<cfif COST_CONTROL.recordcount eq 0>
		<cfquery name="UPD_COST_CONTROL" datasource="#dsn2#">
			UPDATE STOCK_FIS SET IS_COST=0 WHERE FIS_ID= #attributes.invoice_id#
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		<cfif cost_control.recordcount eq 0>
		window.opener.opener.document.form_basket.is_cost.value=0;
		</cfif> 
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
