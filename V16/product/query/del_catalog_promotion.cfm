<cfquery name="get_process" datasource="#dsn3#">
	SELECT CAT_PROM_NO FROM CATALOG_PROMOTION WHERE CATALOG_ID = #attributes.del_cat#
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_CATALOG_PRICE_LISTS" datasource="#DSN3#">
			DELETE CATALOG_PRICE_LISTS WHERE CATALOG_PROMOTION_ID = #attributes.del_cat#
		</cfquery>
		<cfquery name="DEL_CATALOG_PROMOTION_PRODUCTS" datasource="#DSN3#">
			DELETE CATALOG_PROMOTION_PRODUCTS WHERE CATALOG_ID = #attributes.del_cat#
		</cfquery>
		<cfquery name="DEL_CATALOG_PROMOTION" datasource="#DSN3#">
			DELETE CATALOG_PROMOTION WHERE CATALOG_ID = #attributes.del_cat#
		</cfquery>
		<cfquery name="DEL_CATALOG_PROMOTION_MEMBERS" datasource="#DSN3#">
			DELETE CATALOG_PROMOTION_MEMBERS WHERE CATALOG_ID = #attributes.del_cat#
		</cfquery>
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CATALOG_ID = #attributes.del_cat#
		</cfquery>
		<cfif get_segment.recordcount>
			<cfoutput query="get_segment">
				<cfquery name="del_rows" datasource="#dsn3#">
					DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>		
			</cfoutput>
			<cfquery name="del_segment" datasource="#dsn3#">
				DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE CATALOG_ID = #attributes.del_cat#
			</cfquery>	
		</cfif>
		<cfquery name="del_premium" datasource="#dsn3#">
			DELETE FROM SETUP_CONSCAT_PREMIUM WHERE CATALOG_ID = #attributes.del_cat#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.del_cat#"  paper_no="#get_process.cat_prom_no#" action_name="#attributes.head#" data_source="#dsn3#">	
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion</cfoutput>';
</script>

