<cfquery name="get_company_stock_code" datasource="#dsn1#" maxrows="1">
	SELECT
		*
	FROM
		SETUP_COMPANY_STOCK_CODE
	WHERE
		COMPANY_ID = #attributes.company_id#
</cfquery>
<form name="form_get_company" method="post" action="">
	<input type="hidden" name="form_varmi" id="form_varmi" value="1">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	<input type="hidden" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>">
</form>
<script type="text/javascript">
	<cfif get_company_stock_code.recordcount>
		form_get_company.action='<cfoutput>#request.self#?fuseaction=product.upd_company_stock_code</cfoutput>';
	<cfelse>
		form_get_company.action='<cfoutput>#request.self#?fuseaction=product.add_company_stock_code</cfoutput>';
	</cfif>
	form_get_company.submit();
</script>
