<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 31/05/2016			Dev Date	: 31/05/2016		
Description :
	Bu utility havaleye dönüştürülen havalelerin ödendi bilgisini günceller. applicationStart methodunda create edilir.
Patameters :
		bankOrderId,isPaid,newDsn
		değerlerini alır.
Used :  updBankOrderStatus.upd(
			bankOrderId	:	evaluate("attributes.bank_order_id#i#"),
			isPaid		:	1,
			newDsn		:	new_dsn2
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="upd" access="public" returntype="boolean">
		<cfargument name="bankOrderId" type="any" required="yes" hint="Banka Talimatı ID">
        <cfargument name="isPaid" type="numeric" required="yes" hint="Ödendi 1,Ödenmedi 0">
        <cfargument name="newDsn" type="string" default="#dsn2#" hint="Dönem Bilgisi">
        <cfquery name="upd_bank_orders" datasource="#arguments.newDsn#">
            UPDATE
            	BANK_ORDERS
            SET
            	IS_PAID = #arguments.isPaid#
            WHERE
            	BANK_ORDER_ID IN (#arguments.bankOrderId#)
        </cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>