<cfquery name="upd_visit" datasource="#dsn#">
	UPDATE
		EMPLOYEES_EXT_WORKTIMES
	SET
		<cfif attributes.type eq 1>
			VALID_1 = #attributes.is_valid#
		<cfelseif attributes.type eq 2>
			VALID_2 = #attributes.is_valid#
		</cfif>
	WHERE
		EWT_ID = #attributes.ewt_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
