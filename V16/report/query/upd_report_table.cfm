<cfif isdefined("form.period_id") and form.period_id>
	<cfquery name="get_period" datasource="#dsn#">
		SELECT
			OUR_COMPANY_ID,
			PERIOD_YEAR
		FROM
			SETUP_PERIOD
		WHERE
			PERIOD_ID = #FORM.PERIOD_ID#
	</cfquery>
</cfif>

<cfquery name="INSERT_REPORT_TABLES" datasource="#dsn#">
	UPDATE
		REPORT_TABLES 
	SET
		TABLE_NAME = '#form.Table_Name#',
		TABLE_INREPORT = #in_Report#,
		NICK_NAME_TR = '#form.Nick_TR#',
		NICK_NAME_EN = '#form.Nick_EN#',
	<cfif isdefined("form.period_id") and form.period_id>
		PERIOD_YEAR = #get_period.PERIOD_YEAR#,
		COMPANY_ID = #get_period.OUR_COMPANY_ID#,
	<cfelseif isdefined("form.company_id") and form.company_id>
		PERIOD_YEAR = 0,
		COMPANY_ID = #FORM.COMPANY_ID#,
	<cfelse>
		PERIOD_YEAR = 0,
		COMPANY_ID = 0,
	</cfif>
		DETAIL = '#DETAIL#'
	WHERE
		TABLE_ID = #attributes.Table_ID#	      
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
