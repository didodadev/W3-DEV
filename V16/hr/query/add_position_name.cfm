<cfquery name="ads_pos_name" datasource="#DSN#">
	INSERT INTO EMPLOYEE_POSITION_NAMES (POSITION_NAME) VALUES ('#attributes.position_name#')
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
