<cfquery name="GET_DIGITAL_ASSET_GROUP" datasource="#DSN#">
    SELECT 
        DETAIL,
        GROUP_ID,
        #dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','DIGITAL_ASSET_GROUP','GROUP_NAME',NULL,NULL,GROUP_NAME) AS GROUP_NAME
    FROM 
        DIGITAL_ASSET_GROUP
	ORDER BY
		GROUP_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='45129.Dijital Varlık Grupları'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.list_digital_asset_group" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">	
			<table>
					<cfif get_digital_asset_group.recordcount>
						<cfoutput query="get_digital_asset_group">
							<tr>
								<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
								<td width="380"><a href="#request.self#?fuseaction=settings.list_digital_asset_group&event=upd&id=#group_id#" class="tableyazi"> #group_name# </a> </td>	
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
							<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</cfif>
			</table>
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">	
			<cfinclude  template="../form/add_digital_asset_group.cfm">
		</div>
	</cf_box>
</div>