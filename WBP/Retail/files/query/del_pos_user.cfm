<cfquery name="add_" datasource="#dsn_dev#">
	DELETE FROM POS_USERS WHERE ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	location.href=document.referrer;
</script>