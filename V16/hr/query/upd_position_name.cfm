<cfquery name="ads_pos_name" datasource="#DSN#">
	UPDATE
		 EMPLOYEE_POSITION_NAMES 
	SET
		POSITION_NAME='#attributes.position_name#'
	WHERE
		POS_NAME_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
