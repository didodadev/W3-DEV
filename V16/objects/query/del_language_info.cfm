<cfquery datasource="#dsn#">
	DELETE FROM 
		SETUP_LANGUAGE_INFO 
	WHERE 
		<cfif attributes.c_type eq 1>
			COMPANY_ID = #session.ep.company_id# AND
		<cfelseif  attributes.c_type eq 2>
			PERIOD_ID = #session.ep.period_id# AND
		</cfif>
		UNIQUE_COLUMN_ID = #attributes.c_id_value# AND
		COLUMN_NAME = '#attributes.c_name#' AND
		TABLE_NAME = '#attributes.t_name#'
</cfquery>
<script type="text/javascript">
  location.href = document.referrer;
</script>
