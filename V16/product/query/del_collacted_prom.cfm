<cflock timeout="20">
	<cftransaction>
		<cfquery name="del_prom_rel" datasource="#dsn3#">
			DELETE FROM 
				PROMOTIONS_RELATION 
			WHERE 
				PROM_RELATION_ID = #attributes.prom_rel_id#
		</cfquery>
		<cfquery name="del_prom" datasource="#dsn3#">
			DELETE FROM 
				PROMOTIONS 
			WHERE 
				PROM_RELATION_ID = #attributes.prom_rel_id#
		</cfquery>
		<cfquery name="del_prom_history" datasource="#dsn3#">
			DELETE FROM
				PROMOTIONS_HISTORY
			WHERE
				PROM_RELATION_ID = #attributes.prom_rel_id#
		</cfquery>	
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROM_REL_ID = #attributes.prom_rel_id#
		</cfquery>
		<cfif get_segment.recordcount>
			<cfoutput query="get_segment">
				<cfquery name="del_rows" datasource="#dsn3#">
					DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>		
			</cfoutput>
			<cfquery name="del_segment" datasource="#dsn3#">
				DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE PROM_REL_ID = #attributes.prom_rel_id#
			</cfquery>	
		</cfif>
		<cfquery name="del_premium" datasource="#dsn3#">
			DELETE FROM SETUP_CONSCAT_PREMIUM WHERE PROM_REL_ID = #attributes.prom_rel_id#
		</cfquery>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions</cfoutput>";
</script>

