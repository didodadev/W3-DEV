<cfquery name="GET_PURCHASE_RETAIL" datasource="#dsn3#">
SELECT
	CONTRACT_PURCHASE_RETAIL_ID
FROM
	CONTRACT_PURCHASE_RETAIL
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
