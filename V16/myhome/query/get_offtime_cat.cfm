<cfquery name="get_offtime_cat" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_OFFTIME
	WHERE
		OFFTIMECAT_ID = #attributes.offtime_cat_id#
</cfquery>
