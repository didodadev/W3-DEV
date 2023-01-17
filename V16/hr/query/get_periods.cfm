<cfif isdefined("attributes.employee_id")>
	<cfquery name="PERIODS" datasource="#dsn#">
		SELECT
			SP.*,
			OC.NICK_NAME,
			OC.COMP_ID
		FROM
			SETUP_PERIOD SP,
			OUR_COMPANY OC,
			EMPLOYEE_POSITIONS EPS
		WHERE
			OC.COMP_ID=SP.OUR_COMPANY_ID
			AND
			EPS.PERIOD_ID=SP.PERIOD_ID
			AND
			EPS.EMPLOYEE_ID=#attributes.employee_id#
	</cfquery>
<cfelse>
	<cfquery name="PERIODS" datasource="#dsn#">
		SELECT
			SP.*,
			OC.COMP_ID
		FROM
			SETUP_PERIOD SP,
			OUR_COMPANY OC
		WHERE
			OC.COMP_ID=SP.OUR_COMPANY_ID
	</cfquery>
</cfif>
