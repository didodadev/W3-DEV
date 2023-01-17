<cfif not isDefined("attributes.camp_id")>
	<cfif isDefined("attributes.prom_id")>
		<cflock timeout="60">
		<cftransaction>
			<cfquery name="get_process" datasource="#dsn3#">
				SELECT
					PROM_STATUS,PROM_NO
				FROM 
					PROMOTIONS 
				WHERE 
					PROM_ID = #attributes.PROM_ID#
			</cfquery>
			<cfquery name="DEL_PROM" datasource="#dsn3#">
				DELETE FROM 
					PROMOTIONS 
				WHERE 
					PROM_ID = #attributes.PROM_ID#
			</cfquery>
			<cfquery name="DEL_PROM_HISTORY" datasource="#dsn3#">
				DELETE FROM
					PROMOTIONS_HISTORY
				WHERE
					PROM_ID = #attributes.prom_id#
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
			<cf_add_log  log_type="-1" action_id="#attributes.prom_id#" process_stage="#get_process.prom_status#" paper_no="#get_process.prom_no#" action_name="#attributes.head#" data_source="#dsn3#">
		</cftransaction>
		</cflock>
	</cfif>
<cfelse>
	<cflock timeout="20">
		<cftransaction>
			<cfquery name="get_process" datasource="#dsn3#">
				SELECT
					PROM_STATUS,PROM_NO
				FROM 
					PROMOTIONS 
				WHERE 
					PROM_ID = #attributes.PROM_ID#
			</cfquery>
			<cfquery name="DEL_PROM" datasource="#dsn3#">
				UPDATE 	
					PROMOTIONS 
				SET 
					CAMP_ID = NULL
				WHERE 
					PROM_ID = #attributes.PROM_ID# AND 
					CAMP_ID = #attributes.CAMP_ID#
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
			<cf_add_log log_type="-1" action_id="#attributes.prom_id#" process_stage="#get_process.PROM_STATUS#" paper_no="#get_process.prom_no#" action_name="#attributes.head#" data_source="#dsn3#">
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions</cfoutput>";
</script>