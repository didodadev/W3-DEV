<cfif isdefined("attributes.page_type") and isdefined("attributes.id") and isdefined("attributes.cost_id")>
	<cfif attributes.page_type eq 1>
		<cfquery name="DEL_INVOICE_COST" datasource="#DSN2#">
			DELETE FROM
				INVOICE_COST
			WHERE
				INVOICE_ID = #attributes.id#
				AND	INVOICE_COST_ID = #attributes.cost_id#
		</cfquery>
	<cfelseif listfind('2,3',attributes.page_type,',')>
		<cfquery name="DEL_ORDER_OFFER_COST" datasource="#DSN3#">
			DELETE FROM
				ORDER_OFFER_COST
			WHERE
				ORDER_OFFER_ID = #attributes.id#
				AND	COST_ID = #attributes.cost_id#
				AND	IS_ORDER = <cfif attributes.page_type eq 2>1<cfelse>0</cfif>
		</cfquery>
	</cfif>
</cfif>
<cflocation url="#request.self#?fuseaction=objects.popup_list_cost&id=#url.id#&page_type=#url.page_type#" addtoken="no">
