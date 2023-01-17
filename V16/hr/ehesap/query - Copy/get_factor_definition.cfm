<cfquery name="get_factor_definition" datasource="#dsn#">
	SELECT
		*
	FROM
		SALARY_FACTOR_DEFINITION
	<cfif isdefined('attributes.factor_id') and len(attributes.factor_id)>
	WHERE
		ID = #attributes.factor_id#
	</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
