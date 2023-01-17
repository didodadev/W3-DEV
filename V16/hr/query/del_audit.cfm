<cfif isDefined('attributes.audit_id')>
	<cfquery name="DEL_AUDIT" datasource="#dsn#">
		DELETE FROM
			EMPLOYEES_AUDIT
		WHERE
			AUDIT_ID = #attributes.audit_id#
	</cfquery>
</cfif>

<script type="text/javascript">
		location.href = document.referrer;
</script>
