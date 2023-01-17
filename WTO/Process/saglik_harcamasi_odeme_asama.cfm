<!---
    Author: Workcube - Botan Kaygan <botankaygan@workcube.com>
    Date: 21.04.2020
    Description:
	    Sağlık Harcaması sürecinde ödeme aşamasına eklenmelidir. Harcamanın ödendiği bilgisini tabloya yazar.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfquery name="upd_is_payment" datasource="#caller.dsn2#">
        UPDATE EXPENSE_ITEM_PLAN_REQUESTS SET IS_PAYMENT = 1 WHERE EXPENSE_ID = #attributes.action_id#
    </cfquery>
</cfif>