<cfinclude template="../query/get_campaigns.cfm">
<cfquery name="GET_IMAGE" datasource="#DSN3#">
	SELECT PATH, IMAGE_SERVER_ID FROM CAMPAIGN_IMAGES WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#campaign.camp_id#">
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
	<tr>
		<td class="formbold"><cf_get_lang no='270.Kampanyalar'></td>
	</tr>
	<cfoutput>
		<tr style="height:25px;">
			<td class="txtbold"><a href="#request.self#?fuseaction=objects2.dsp_campaign&camp_id=#campaign.camp_id#">>> #campaign.camp_head#</a></td>
		</tr>
		<tr>
			<td>
				<cfif not (isdefined("get_image.path") and len(get_image.path))>
					<cf_get_server_file output_file="campaign/#get_image.path#" output_server="#get_image.image_server_id#" output_type="0"  image_link="1" alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#">
				</cfif>
			</td>
		</tr>
		<tr style="height:25px;">
			<td><a href="#request.self#?fuseaction=objects2.list_campaign_ww">>> <cf_get_lang no='270.Tüm Kampanyalar'>...</a></td>
		</tr>
	</cfoutput>
</table>
