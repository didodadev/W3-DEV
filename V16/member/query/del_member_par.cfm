<cfquery name="del_group_par" datasource="#DSN#">
	DELETE FROM 
		WORKGROUP_EMP_PAR
	WHERE
		PARTNER_ID = #URL.partner_id# AND
		COMPANY_ID = #URL.cp_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
