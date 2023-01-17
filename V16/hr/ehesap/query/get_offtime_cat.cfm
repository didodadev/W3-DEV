<cfquery name="get_offtime_cat" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_OFFTIME
	WHERE
		OFFTIMECAT_ID = #attributes.OFFTIME_CAT_ID#
</cfquery>
