<!--- GENERAL_PREMIUM --->
<cfquery name="GET_PURCHASE_GENERAL_PREMIUM" datasource="#dsn3#">
SELECT
	*
FROM
	CONTRACT_PURCHASE_GENERAL_PREMIUM
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
<!--- //GENERAL_PREMIUM --->
<!--- RETAIL --->
<cfquery name="GET_PURCHASE_RETAIL" datasource="#dsn3#">
SELECT
	*
FROM
	CONTRACT_PURCHASE_RETAIL
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
<!--- //RETAIL --->
<!--- DUE --->
<cfquery name="GET_PURCHASE_DUE" datasource="#dsn3#">
SELECT
	*
FROM
	CONTRACT_PURCHASE_DUE
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
<!--- //DUE --->
<!--- PHYSICAL --->
<cfquery name="GET_PURCHASE_PHYSICAL" datasource="#dsn3#">
SELECT
	*
FROM
	CONTRACT_PURCHASE_PHYSICAL
WHERE
	CONTRACT_ID = #CONTRACT_ID#
</cfquery>
<!--- //PHYSICAL --->

