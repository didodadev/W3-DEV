<cfquery name="UPD_HEALTY" datasource="#DSN#">
	DELETE FROM EMPLOYEES_RELATIVE_HEALTY WHERE DOC_ID = #ATTRIBUTES.DOC_ID#
</cfquery>
<script type="text/javascript">
   window.location.href = '<cfoutput>#request.self#?fuseaction=hr.list_emp_rel_healty</cfoutput>'; 
</script>
