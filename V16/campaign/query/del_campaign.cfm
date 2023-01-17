<!---E.A select ifadeleri düzenlendi.24082012--->
<cfquery name="get_process" datasource="#dsn3#">
	SELECT PROCESS_STAGE,CAMP_NO FROM CAMPAIGNS WHERE CAMP_ID = #CAMP_ID#
</cfquery>
<cflock timeout="20">
	<cftransaction>
		<cfquery name="DEL_SMS_CONT" datasource="#dsn3#">
			DELETE
				CAMPAIGN_SMS_CONT
			WHERE
				CAMP_ID = #CAMP_ID#
		</cfquery>
		<cfquery name="DEL_PROMS" datasource="#dsn3#">
			DELETE
				PROMOTIONS
			WHERE
				CAMP_ID = #CAMP_ID#
		</cfquery>
		<cfquery name="DEL_CAMPAIGN" datasource="#dsn3#">
			DELETE
				CAMPAIGNS
			WHERE
				CAMP_ID = #CAMP_ID#
		</cfquery>
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT 
            	CONSCAT_SEGMENT_ID,
                CAMPAIGN_ID
            FROM 
            	SETUP_CONSCAT_SEGMENTATION 
            WHERE 
            	CAMPAIGN_ID = #CAMP_ID#
		</cfquery>
        <cfquery name="DEL_CONTENT_REL" datasource="#dsn3#">
            DELETE 
            	#dsn_alias#.CONTENT_RELATION 
            WHERE 
            	ACTION_TYPE_ID = #attributes.camp_id#
        </cfquery>
		<cfif get_segment.recordcount>
			<cfoutput query="get_segment">
				<cfquery name="del_rows" datasource="#dsn3#">
					DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>		
			</cfoutput>
			<cfquery name="del_segment" datasource="#dsn3#">
				DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #CAMP_ID#
			</cfquery>	
		</cfif>
		<cfquery name="del_premium" datasource="#dsn3#">
			DELETE FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #CAMP_ID#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.camp_id#" action_name="#attributes.head#" process_type="#attributes.cat#" paper_no="#get_process.camp_no#" process_stage="#get_process.process_stage#" data_source="#dsn3#">
	</cftransaction>
</cflock>		
<cfset attributes.action_section="CAMPAIGN_ID">
<cfset attributes.action_id=attributes.CAMP_ID>
<cfinclude template="../../objects/query/del_assets.cfm">
<cfinclude template="../../objects/query/del_notes.cfm">
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=campaign.list_campaign</cfoutput>";
</script>
