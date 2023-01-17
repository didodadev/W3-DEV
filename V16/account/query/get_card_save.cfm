<cfquery name="GET_CARD_SAVE" datasource="#dsn2#">
	SELECT
		ACS.NEW_CARD_ID,
		ACS.CARD_TYPE_NO
	FROM
		ACCOUNT_CARD_SAVE ACS
	WHERE
		ACS.ACTION_TYPE = #attributes.process_cat#
		AND ACS.ACTION_ID = #attributes.action_id#
		AND ISNULL(ACS.IS_TEMPORARY_SOLVED,0) <> 1 <!--- gecici acılmıs fisleri almaması icin --->
</cfquery>
