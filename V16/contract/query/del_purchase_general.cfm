<CFTRANSACTION>
<!--- GENERAL_PREMIUM --->
<cfquery name="DEL_PURCHASE_GENERAL_PREMIUM" datasource="#dsn3#">
DELETE FROM
	CONTRACT_PURCHASE_GENERAL_PREMIUM
WHERE
	CONTRACT_ID = #attributes.CONTRACT_ID#
</cfquery>
<!--- //GENERAL_PREMIUM --->
<!--- RETAIL --->
<cfquery name="DEL_PURCHASE_RETAIL" datasource="#dsn3#">
DELETE FROM
	CONTRACT_PURCHASE_RETAIL
WHERE
	CONTRACT_ID = #attributes.CONTRACT_ID#
</cfquery>
<!--- //RETAIL --->
<!--- DUE --->
<cfquery name="DEL_PURCHASE_DUE" datasource="#dsn3#">
DELETE FROM
	CONTRACT_PURCHASE_DUE
WHERE
	CONTRACT_ID = #attributes.CONTRACT_ID#
</cfquery>
<!--- //DUE --->
<!--- PHYSICAL --->
<cfquery name="DEL_PURCHASE_PHYSICAL" datasource="#dsn3#">
DELETE FROM
	CONTRACT_PURCHASE_PHYSICAL
WHERE
	CONTRACT_ID = #attributes.CONTRACT_ID#
</cfquery>
<!--- //PHYSICAL --->
</CFTRANSACTION>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
