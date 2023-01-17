<cfquery name="GET_SHIP" datasource="#dsn2#"><!--- faturanın kendi irsaliyesi varsa alır --->
	SELECT 
		INV_S.SHIP_ID,
		INV_S.INVOICE_NUMBER,
		INV_S.SHIP_NUMBER,
		INV_S.IS_WITH_SHIP,
		S.SHIP_TYPE
	FROM 
		INVOICE_SHIPS INV_S,
		SHIP S 
	WHERE 
		INV_S.INVOICE_ID = #form.invoice_id# AND
		INV_S.IS_WITH_SHIP=1 AND
		INV_S.SHIP_ID=S.SHIP_ID
</cfquery>

<cfset old_ship_id = GET_SHIP.SHIP_ID>
<cfset old_ship_type = GET_SHIP.SHIP_TYPE>

<cfif GET_SHIP.recordcount>
	<cfquery name="del_" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE IS_SALE = 1 AND PROCESS_ID = #old_ship_id# AND PROCESS_CAT = #old_ship_type# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>
