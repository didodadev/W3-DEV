<cfquery name="del_prize_type" datasource="#DSN#">
	DELETE FROM SETUP_PRIZE_TYPE WHERE PRIZE_TYPE_ID = #attributes.type_id#
</cfquery>

<script type="text/javascript">
	location.href= document.referrer;
</script>
