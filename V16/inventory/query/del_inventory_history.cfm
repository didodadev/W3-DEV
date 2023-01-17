<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.history_id") and len(attributes.history_id)>
			<cfquery name="get_last_inventory_history_1" datasource="#dsn3#">
				SELECT 
					TOP 1 INVENTORY_HISTORY_ID
				FROM 
					INVENTORY_HISTORY
				WHERE
					INVENTORY_ID = #attributes.inventory_id#
				ORDER BY 
					ACTION_DATE DESC,
					INVENTORY_HISTORY_ID DESC
			</cfquery>
			<cfquery name="del_inventory_history" datasource="#dsn3#">
				DELETE FROM INVENTORY_HISTORY WHERE INVENTORY_HISTORY_ID = #attributes.history_id#
			</cfquery>
			<cfif get_last_inventory_history_1.recordcount and get_last_inventory_history_1.INVENTORY_HISTORY_ID eq attributes.history_id>
				<cfquery name="get_last_inventory_history_2" datasource="#dsn3#">
					SELECT 
						TOP 1 INVENTORY_HISTORY_ID
					FROM 
						INVENTORY_HISTORY
					WHERE
						INVENTORY_ID = #attributes.inventory_id#
					ORDER BY 
						ACTION_DATE DESC,
						INVENTORY_HISTORY_ID DESC
				</cfquery>
				<cfquery name="get_last" datasource="#dsn3#">
					SELECT 
						INVENTORY_ID,
						PROJECT_ID,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID,
						CLAIM_ACCOUNT_CODE,
						DEBT_ACCOUNT_CODE,
						ACCOUNT_CODE,
						INVENTORY_DURATION,
						INVENTORY_DURATION_IFRS,
						AMORTIZATION_RATE
					FROM 
						INVENTORY_HISTORY
					WHERE
						INVENTORY_HISTORY_ID = #get_last_inventory_history_2.INVENTORY_HISTORY_ID#
				</cfquery>
				<cfif get_last.recordcount>
					<cfquery name="upd_inventory" datasource="#dsn3#">
						UPDATE
							INVENTORY
						SET
							PROJECT_ID = <cfif len(get_last.PROJECT_ID)>#get_last.PROJECT_ID#<cfelse>NULL</cfif>,
							EXPENSE_CENTER_ID = <cfif len(get_last.EXPENSE_CENTER_ID)>#get_last.EXPENSE_CENTER_ID#<cfelse>NULL</cfif>,
							EXPENSE_ITEM_ID = <cfif len(get_last.EXPENSE_ITEM_ID)>#get_last.EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,
							CLAIM_ACCOUNT_ID = <cfif len(get_last.CLAIM_ACCOUNT_CODE)>'#get_last.CLAIM_ACCOUNT_CODE#'<cfelse>NULL</cfif>,
							DEBT_ACCOUNT_ID = <cfif len(get_last.DEBT_ACCOUNT_CODE)>'#get_last.DEBT_ACCOUNT_CODE#'<cfelse>NULL</cfif>,
							ACCOUNT_ID = <cfif len(get_last.ACCOUNT_CODE)>'#get_last.ACCOUNT_CODE#'<cfelse>NULL</cfif>,
							INVENTORY_DURATION = <cfif len(get_last.INVENTORY_DURATION)>#get_last.INVENTORY_DURATION#<cfelse>NULL</cfif>,
							INVENTORY_DURATION_IFRS = <cfif len(get_last.INVENTORY_DURATION_IFRS)>#get_last.INVENTORY_DURATION_IFRS#<cfelse>NULL</cfif>,
							AMORTIZATON_ESTIMATE = <cfif len(get_last.AMORTIZATION_RATE)>#get_last.AMORTIZATION_RATE#<cfelse>NULL</cfif>
						WHERE
							INVENTORY_ID = #get_last.inventory_id#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=invent.list_inventory&event=det&inventory_id=#attributes.inventory_id#" addtoken="No">

