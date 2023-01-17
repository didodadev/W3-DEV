<cfquery name="get_driverlicence" datasource="#dsn#">
	SELECT LICENCECAT_ID, LICENCECAT FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
</cfquery>
