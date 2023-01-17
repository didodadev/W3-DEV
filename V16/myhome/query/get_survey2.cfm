<!--- <cfquery name="get_periods" datasource="#DSN#">
	SELECT DISTINCT 
		OUR_COMPANY_ID,
		COMPANY_NAME
	FROM 
		SETUP_PERIOD,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID
</cfquery>
<cfloop query="get_periods">
<cfset new_dsn3 = '#dsn#_#get_periods.OUR_COMPANY_ID#'> --->
<cfquery name="GET_SURVEY" datasource="#DSN#">
	SELECT
		*
	FROM
		SURVEY
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>
<!--- <cfif len(GET_SURVEY.SURVEY_ID)><!--- Anket bulduğunda çıksın fazladan query dönmesin. --->
	<cfbreak>
</cfif> --->
<!--- </cfloop> --->
