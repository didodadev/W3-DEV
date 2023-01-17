<cfquery name="get_offer_detail" datasource="#dsn3#">
	SELECT * FROM OFFER WHERE OFFER_ID = <cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>#attributes.for_offer_id#<cfelse>#attributes.offer_id#</cfif>
</cfquery>
<cfif isdefined("url.id")>
	<cfquery name="get_row_prd" datasource="#dsn3#">
		SELECT OFFER_ID, UNIT, PRODUCT_NAME, QUANTITY FROM OFFER_ROW WHERE OFFER_ID = #url.id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id) or len(get_offer_detail.for_offer_id)>
	<cfquery name="get_related_offer_" datasource="#dsn3#">
		SELECT OFFER_NUMBER,OFFER_HEAD,OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE FROM OFFER WHERE OFFER_ID = <cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>#attributes.for_offer_id#<cfelse>#get_offer_detail.for_offer_id#</cfif>
	</cfquery>
</cfif>

