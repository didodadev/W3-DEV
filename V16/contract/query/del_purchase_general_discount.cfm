<cfif attributes.type eq 1><!--- 1=satınalma --->
	<cfset TABLE_NAME ='CONTRACT_PURCHASE_GENERAL_DISCOUNT'>
	<cfset BRANCH_TABLE ='CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES'>
<cfelseif attributes.type eq 2><!--- 2=satış --->
	<cfset TABLE_NAME ='CONTRACT_SALES_GENERAL_DISCOUNT'>
	<cfset BRANCH_TABLE ='CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES'>
</cfif>
<CFTRANSACTION>
<!--- GENERAL_DISCOUNT --->
<cfquery name="DEL_CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES" datasource="#dsn3#">
DELETE FROM #BRANCH_TABLE# WHERE GENERAL_DISCOUNT_ID = #attributes.GENERAL_DISCOUNT_ID#
</cfquery>
<cfquery name="DEL_PURCHASE_GENERAL_DISCOUNT" datasource="#dsn3#">
DELETE FROM
	#TABLE_NAME#
WHERE
	GENERAL_DISCOUNT_ID = #attributes.GENERAL_DISCOUNT_ID#
</cfquery>
<!--- //GENERAL_DISCOUNT --->
</CFTRANSACTION>

<script type="text/javascript">
/*opener.reloadOpener();*/
wrk_opener_reload();
window.close();
</script>
