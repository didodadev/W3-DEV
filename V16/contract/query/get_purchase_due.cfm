<cfquery name="GET_PURCHASE_DUE" datasource="#dsn3#">
SELECT
	CONTRACT_PURCHASE_DUE_ID
FROM
	CONTRACT_PURCHASE_DUE
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
