<cfif isDefined("attributes.del_id_list") and ListLen(attributes.del_id_list)>
	<cfloop list="#attributes.del_id_list#" index="dl" delimiters=";">
		<cfif ListGetAt(dl,1,'-') gt 0><cfset invoice_id = ListGetAt(dl,1,'-')><cfelse><cfset invoice_id = ""></cfif>
		<cfif ListGetAt(dl,2,'-') gt 0><cfset invoice_row_id = ListGetAt(dl,2,'-')><cfelse><cfset invoice_row_id = ""></cfif>
		<cfif ListGetAt(dl,3,'-') gt 0><cfset cost_id = ListGetAt(dl,3,'-')><cfelse><cfset cost_id = ""></cfif>
		<cfquery name="DELETE_CONTRACT_COMPRASSION" datasource="#dsn2#">
			DELETE FROM
				INVOICE_CONTRACT_COMPARISON
			WHERE
				1=1
				<cfif len(invoice_id)>AND MAIN_INVOICE_ID = '#invoice_id#'</cfif>
				<cfif len(invoice_row_id)>AND MAIN_INVOICE_ROW_ID = '#invoice_row_id#'</cfif>
				<cfif len(cost_id)>AND COST_ID = '#cost_id#'</cfif>
		</cfquery>
		<cfif len(invoice_id)>
			<cfquery name="GET_" datasource="#DSN2#">
				SELECT MAIN_INVOICE_ID FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = '#invoice_id#'
			</cfquery>
			<cfif NOT GET_.RECORDCOUNT>
				<cfquery name="DELETE_CONTRACT_COMPRASSION" datasource="#dsn2#">
					DELETE FROM INVOICE_CONTROL WHERE INVOICE_ID = '#invoice_id#'
				</cfquery>
			</cfif>
		<cfelseif len(cost_id)>
			<cfquery name="DELETE_CONTRACT_COMPRASSION" datasource="#dsn2#">
				DELETE FROM INVOICE_CONTROL WHERE COST_ID = '#cost_id#'
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=invoice.list_conract_comparison#del_url_list#</cfoutput>';
</script>
