<cfquery name="GET_SUBS_ADD_OPTION" datasource="#DSN3#">
	SELECT
		SUBSCRIPTION_ADD_OPTION_ID,
		SUBSCRIPTION_ADD_OPTION_NAME
	FROM
		SETUP_SUBSCRIPTION_ADD_OPTIONS
</cfquery>
