<cfquery name="add_" datasource="#dsn_dev#">
	DELETE FROM 
    	SETUP_POS_PAYMETHODS
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>
<script>
	window.opener.location.reload();
	window.close();
</script>
<cfabort>