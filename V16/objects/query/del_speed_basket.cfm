<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.is_all")>
	<cfquery name="del_main_product_" datasource="#dsn#">
		DELETE FROM ORDER_PRE_ROWS WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cflocation url="#request.self#?fuseaction=objects.popup_list_speed_basket" addtoken="no">
<cfelse>
	<cfquery name="del_main_product_" datasource="#dsn#">
		DELETE FROM ORDER_PRE_ROWS WHERE STOCK_ID = #attributes.stock_id#
	</cfquery>
	<script type="text/javascript">
		<cfoutput>document.getElementById('td_islem_#attributes.stock_id#').innerHTML = 'Silindi!';</cfoutput>
	</script>
</cfif>
