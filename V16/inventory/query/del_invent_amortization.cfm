<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name = "get_inv_main" datasource = "#dsn2#">
			SELECT * FROM #dsn3_alias#.INVENTORY_AMORTIZATION_MAIN WHERE INV_AMORT_MAIN_ID = #attributes.inv_main_id#
		</cfquery>
		<cfset go_ifrs = get_inv_main.accounting_type>
		<cfquery name="DEL_AMORT" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_AMORTIZATION_MAIN WHERE INV_AMORT_MAIN_ID = #attributes.inv_main_id#
		</cfquery>
		<cfquery name="get_amortization" datasource="#dsn2#">
			SELECT * FROM #dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif> WHERE INV_AMORT_MAIN_ID = #attributes.inv_main_id#
		</cfquery>
		<cfoutput query="get_amortization">
			<cfquery name="get_invent" datasource="#dsn2#">
				SELECT * FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID = #get_amortization.inventory_id#
			</cfquery>
			<cfquery name="get_total_inv" datasource="#dsn2#">
				SELECT ISNULL(SUM(PERIODIC_AMORT_VALUE),0) TOTAL_VALUE FROM #dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif> WHERE INVENTORY_ID = #get_amortization.inventory_id#
			</cfquery>
			<cfscript>	
				if(get_invent.amount_2 gt 0 and get_invent.amount gt 0)	
					rate2 = get_invent.amount / get_invent.amount_2;
				else
					rate2 = 1;
				last_value = get_invent.last_inventory_value + get_amortization.periodic_amort_value;
				
				
				if(get_invent.AMORTIZATION_TYPE eq 1)
				{	
					if(get_amortization.PARTIAL_AMORTIZATION_VALUE eq '')
					{	
						get_amortization.PARTIAL_AMORTIZATION_VALUE = 0 ;
					}
					if((get_amortization.amortizaton_year - Year(get_invent.entry_date)) eq 1 and  get_amortization.INV_QUANTITY eq 1)
					{ 
						last_value = get_invent.last_inventory_value + get_amortization.periodic_amort_value + get_amortization.PARTIAL_AMORTIZATION_VALUE;
					}
				}
				last_value_ = get_invent.last_inventory_value + get_total_inv.TOTAL_VALUE;
				last_value_2 = (get_invent.last_inventory_value + get_amortization.periodic_amort_value)/rate2;
				amort_count = get_invent.amortization_count - 1;
			</cfscript>
			<cfquery name="UPD_INVENTORY" datasource="#dsn2#">
				UPDATE
					#dsn3_alias#.INVENTORY
				SET
					LAST_INVENTORY_VALUE = #last_value#,
					LAST_INVENTORY_VALUE_2 = #last_value_2#,
					<cfif get_invent.amortization_count eq get_invent.account_period or amort_count eq 0><!--- Sadece dönemin son değerlemesiyse güncelleme yapıyoruz bu alanda --->
						AMORT_LAST_VALUE = #last_value_#,
					</cfif>
					AMORTIZATION_COUNT = #amort_count#
				WHERE
					INVENTORY_ID = #get_amortization.inventory_id#
			</cfquery>
		</cfoutput>
		<cfquery name="DEL_AMORT" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif> WHERE INV_AMORT_MAIN_ID = #attributes.inv_main_id#	
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:attributes.inv_main_id,process_type:attributes.old_process_type);
			butce_sil(action_id:attributes.inv_main_id,process_type:attributes.old_process_type);
		</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=invent.list_invent_amortization";
</script>

