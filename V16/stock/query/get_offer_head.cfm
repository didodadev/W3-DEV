<cfquery name="GET_OFFER_HEAD" datasource="#dsn3#">
	SELECT
		OFFER_ID,
		OFFER_HEAD,
		OFFER_NUMBER
	FROM
		OFFER
	WHERE
		OFFER_ID = #attributes.OFFER_ID#
</cfquery>
