<cflock timeout="60">
	<cftransaction>
		<cfquery name="get_head" datasource="#dsn3#">
			SELECT PROM_HEAD,PROM_STAGE,PROM_NO FROM PROMOTIONS WHERE PROM_ID = #attributes.prom_id#
		</cfquery>
		<cfquery name="del_prom" datasource="#dsn3#">
			DELETE FROM PROMOTIONS WHERE PROM_ID = #attributes.prom_id#
		</cfquery>
		<cfquery name="del_prom_products" datasource="#dsn3#">
			DELETE FROM PROMOTION_PRODUCTS WHERE PROMOTION_ID = #attributes.prom_id#
		</cfquery>
		<cfquery name="del_prom_conditions_product" datasource="#dsn3#">
			DELETE FROM PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID IN (SELECT PROM_CONDITION_ID FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = #attributes.prom_id# )
		</cfquery>
		<cfquery name="del_prom_conditions" datasource="#dsn3#">
			DELETE FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = #attributes.prom_id#
		</cfquery>
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROMOTION_ID = #attributes.prom_id#
		</cfquery>
		<cfif get_segment.recordcount>
			<cfoutput query="get_segment">
				<cfquery name="del_rows" datasource="#dsn3#">
					DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>		
			</cfoutput>
			<cfquery name="del_segment" datasource="#dsn3#">
				DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE PROMOTION_ID = #attributes.prom_id#
			</cfquery>	
		</cfif>
		<cfquery name="del_premium" datasource="#dsn3#">
			DELETE FROM SETUP_CONSCAT_PREMIUM WHERE PROMOTION_ID = #attributes.prom_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.prom_id#" action_name="#get_head.prom_head#" paper_no="#get_head.prom_no#" process_stage="#get_head.prom_stage#" data_source="#dsn3#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="#request.self#?fuseaction=product.list_promotions";
</script>
