<!--- Bu sayfa maliyet sayfasındaki eklenen önerilerin listelenmesi sırasında
ajax ile çağırılır. --->
<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.suggest_id') and len(attributes.suggest_id)>
	<cfquery name="DELETE_COST_SUGGESTION" datasource="#dsn1#">
		DELETE FROM PRODUCT_COST_SUGGESTION WHERE PRODUCT_COST_SUGGESTION_ID = #attributes.suggest_id#
	</cfquery>
</cfif>
