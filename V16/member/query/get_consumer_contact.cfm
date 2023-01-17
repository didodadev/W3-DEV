<cfquery name="GET_CONSUMER_CONTACT" datasource="#DSN#">
	SELECT
		CONTACT_ID,
		CONTACT_NAME,
		CONTACT_TELCODE,
		CONTACT_TEL1,
		CONTACT_EMAIL,
		CONTACT_COUNTY_ID,
		CONTACT_CITY_ID,
		CONTACT_COUNTRY_ID,
		STATUS		
	FROM
		CONSUMER_BRANCH
	WHERE
		CONSUMER_ID = #attributes.cid#
	ORDER BY
		CONTACT_NAME
</cfquery>
