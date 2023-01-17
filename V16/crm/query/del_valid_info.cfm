<cfquery name="DEL_VALID_INFO" datasource="#dsn#">
	UPDATE
		COMPANY_BRANCH_RELATED
	SET 
		VALID_DATE = NULL,
		VALID_EMP = NULL
	WHERE
		COMPANY_ID = #attributes.company_id# AND
		BRANCH_ID = #attributes.branch_id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
