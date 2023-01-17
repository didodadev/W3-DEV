<cfquery name="del_group_emp_par" datasource="#dsn3#">
	DELETE FROM
		PRODUCTGROUP_EMP_PAR
	WHERE
		<cfif len(attributes.type) and attributes.type eq 1>
			POSITION_CODE = #attributes.member_value# AND
		<cfelse>
			PARTNER_ID = #attributes.member_value# AND
		</cfif>
		PRODUCT_ID = #attributes.pid#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
