<cfquery name="GET_ACC_INFO" datasource="#dsn_dev#">
   DELETE FROM PRICE_TABLE WHERE ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	<cfoutput>window.opener.hide('s_price_row_#attributes.row_id#');</cfoutput>
	self.close();
</script>