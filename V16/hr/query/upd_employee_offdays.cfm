<cfsetting showdebugoutput="no">
<cfquery name="UPD_days" datasource="#dsn#">
	UPDATE
		EMPLOYEES
	SET
		IZIN_DAYS = <cfif len(attributes.izin_days)>#attributes.izin_days#<cfelse>0</cfif>
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<script>
	window.location.reload();
</script>
