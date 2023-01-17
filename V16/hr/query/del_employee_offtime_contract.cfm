<cfquery name="add_in_out_real" datasource="#dsn#">
	DELETE FROM EMPLOYEES_OFFTIME_CONTRACT WHERE EMPLOYEES_OFFTIME_CONTRACT_ID = #attributes.EMPLOYEES_OFFTIME_CONTRACT_ID#
</cfquery>
<script type="text/javascript">
	location.href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=list"
</script>
