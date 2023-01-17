<cfquery name="get_insurance_ratio" datasource="#dsn#">
	SELECT
		*
	FROM
		INSURANCE_RATIO
	WHERE
		INS_RAT_ID = #attributes.INS_RAT_ID#
</cfquery>
