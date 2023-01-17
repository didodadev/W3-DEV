<cfquery NAME="DEL_EMPLOYEE_HEALTY" DATASOURCE="#DSN#">
	DELETE
	FROM
		EMPLOYEE_HEALTY
	WHERE
		HEALTY_ID=#attributes.HEALTY_ID#
</cfquery>
<script type="text/javascript">
    window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_employee_healty_all';
</script>
