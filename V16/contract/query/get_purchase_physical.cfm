<cfquery name="GET_PURCHASE_PHYSICAL" datasource="#dsn3#">
SELECT
	CONTRACT_PURCHASE_PHYSICAL_ID
FROM
	CONTRACT_PURCHASE_PHYSICAL
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>