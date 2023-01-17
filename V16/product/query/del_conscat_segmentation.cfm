<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_segment_row" datasource="#dsn3#">
			DELETE FROM 
				SETUP_CONSCAT_SEGMENTATION_ROWS
			WHERE 
				CONSCAT_SEGMENT_ID IN
				(
					SELECT
						CONSCAT_SEGMENT_ID
					FROM 
						SETUP_CONSCAT_SEGMENTATION
					WHERE
						<cfif isdefined("attributes.campaign_id")>
							CAMPAIGN_ID = #attributes.campaign_id#
						<cfelseif isdefined("attributes.catalog_id")>
							CATALOG_ID = #attributes.catalog_id#
						<cfelseif isdefined("attributes.promotion_id")>	
							PROMOTION_ID = #attributes.promotion_id#
						<cfelseif isdefined("attributes.prom_rel_id")>	
							PROM_REL_ID = #attributes.prom_rel_id#
						</cfif>
				)
		</cfquery>
		<cfquery name="del_segment" datasource="#dsn3#">
			DELETE FROM 
				SETUP_CONSCAT_SEGMENTATION
			WHERE
				<cfif isdefined("attributes.campaign_id")>
					CAMPAIGN_ID = #attributes.campaign_id#
				<cfelseif isdefined("attributes.catalog_id")>
					CATALOG_ID = #attributes.catalog_id#
				<cfelseif isdefined("attributes.promotion_id")>	
					PROMOTION_ID = #attributes.promotion_id#
				<cfelseif isdefined("attributes.prom_rel_id")>	
					PROM_REL_ID = #attributes.prom_rel_id#
				</cfif>
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
