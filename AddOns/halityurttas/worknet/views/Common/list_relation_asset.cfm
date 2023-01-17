<cfinclude template="../../config.cfm">
<cfsetting showdebugoutput="no">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.common.asset") />
<cfset getRelationAsset = cmp.getRelationAsset
	(action_id:attributes.action_id,
		action_section:attributes.action_section,
		asset_cat_id:attributes.asset_cat_id
	) />

<table class="ajax_list" style="width:100%;">
	<cfif getRelationAsset.recordcount>
		<cfoutput query="getRelationAsset">
			<div class="row" type="row">
				<div class="col col-10">
					<cfif ListLast(asset_file_name,'.') is 'flv'>
						<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##ASSETCAT_PATH#/#asset_file_name#&ext=flv&video_id=#asset_id#','video');" class="tableyazi">
						#ASSET_NAME#
						</a>
					<cfelse>
						<a href="javascript://" onClick="windowopen('#file_web_path##ASSETCAT_PATH#/#asset_file_name#','medium');" title="#ASSET_NAME#" class="tableyazi">
						#ASSET_NAME#
						</a>
					</cfif>
				</div>
				<div class="col col-2 text-right">
					<a href="javascript://"
					 onClick="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-relation-asset']['fuseaction']#&asset_id=#asset_id#&asset_cat_id=#assetcat_id#&action_id=#attributes.action_id#&action_section=#attributes.action_section#','body_relation_assets',1,'Loading..')">
					 <img src="/images/update_list.gif"  border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
				</div>
			</div>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		</tr>
	</cfif>
</table>