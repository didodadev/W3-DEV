<cfsetting showdebugoutput="no">
<cfinclude template="../../config.cfm">
<cfset getAssetProperty = objectResolver.resolveByRequest("#addonNS#.components.common.asset").getAssetProperty()>
<iframe style="display:none;" src="" name="add_edit_asset" id="add_edit_asset" width="0" height="0"></iframe>

<cfform name="addEditAsset" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['save-relation-asset']['fuseaction']#" method="post" enctype="multipart/form-data">
<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#attributes.asset_cat_id#</cfoutput>">
<cfif isdefined('attributes.asset_id') and len(attributes.asset_id)>
	<cfset getAsset = objectResolver.resolveByRequest("#addonNS#.components.common.asset").getRelationAsset(asset_id:attributes.asset_id,action_id:attributes.action_id,action_section:attributes.action_section,asset_cat_id:attributes.asset_cat_id)>
	<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#getAsset.asset_id#</cfoutput>">
	<input type="hidden" name="is_del" id="is_del" value="0">
	<div class="row" type="row">
		<div class="col col-12">
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'> *</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="text" name="asset_name" id="asset_name" maxlength="150" value="<cfoutput>#getAsset.asset_name#</cfoutput>" style="width:150px;">
						<cfif listlast(getAsset.ASSET_FILE_NAME,'.') is 'jpg' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'png' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'gif' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'jpeg'> 
							<div class="input-group-addon">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getAsset.ASSET_FILE_SERVER_ID#&old_file_name=#getAsset.ASSET_FILE_NAME#&asset_cat_id=#attributes.asset_cat_id#</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
							</div>
						</cfif>
					</div>
					<input type="hidden" name="property_id" id="property_id" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'> *</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" value="<cfoutput>#getAsset.ASSET_FILE_NAME#</cfoutput>" name="old_file_name" id="old_file_name">
						<input type="hidden" value="<cfoutput>#getAsset.ASSET_FILE_SERVER_ID#</cfoutput>" name="old_file_server_id" id="old_file_server_id">
						<input type="file" name="asset_file" id="asset_file">
						<div class="input-group-addon">
							<cfoutput>
								<cfif ListLast(getAsset.asset_file_name,'.') is 'flv'>
									<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##getAsset.ASSETCAT_PATH#/#getAsset.asset_file_name#&ext=flv&video_id=#getAsset.asset_id#','video');" class="tableyazi"><font color="red">Görüntüle.</font></a>
								<cfelse>
									<a href="javascript://" onClick="windowopen('#file_web_path##getAsset.ASSETCAT_PATH#/#getAsset.asset_file_name#','medium');" title="#getAsset.ASSET_NAME#" class="tableyazi"><font color="red">Görüntüle.</font></a>
								</cfif>	
							</cfoutput>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang no='11.Anahtar Kelime'></label>
				<div class="col col-8 col-xs-12">
					<textarea
						style="height:50px;" 
						name="detail" id="detail" 
						onChange="counter();return ismaxlength(this);" 
						onkeydown="counter();return ismaxlength(this);" 
						onkeyup="counter();return ismaxlength(this);" 
						onBlur="return ismaxlength(this);" 
						><cfoutput>#getAsset.ASSET_DETAIL#</cfoutput></textarea>
				</div>
			</div>
			<div class="form-group">
				<div class="col col-12 text-right">
					<input type="button" value="<cf_get_lang_main no ='51.Sil'>" onClick="controlAsset(3);" />
					<input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onClick="controlAsset(2);" />
					<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_asset();" />
				</div>
			</div>
		</div>
	</div>
<cfelse>
	<div class="row">
		<div class="col col-12">
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'> *</label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="asset_name" id="asset_name" value="" maxlength="100" style="width:150px;">
					<input type="hidden" name="property_id" id="property_id" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'> *</label>
				<div class="col col-8 col-xs-12">
					<input type="file" name="asset_file" id="asset_file" style="width:150px;">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang no='11.Anahtar Kelime'></label>
				<div class="col col-8 col-xs-12">
					<textarea
						style="width:150px;height:50px;" 
						name="detail" id="detail" 
						onChange="counter();return ismaxlength(this);"
						onkeydown="counter();return ismaxlength(this);" 
						onkeyup="counter();return ismaxlength(this);" 
						onBlur="return ismaxlength(this);"></textarea>
				</div>
			</div>
			<div class="form-group" id="item-">
				<div class="col col-12 text-right">
					<input type="button" value="<cf_get_lang_main no ='49.Kaydet'>" onClick="controlAsset(1);" />
					<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_asset();" />
				</div>
			</div>
		</div>
	</div>
</cfif>
</cfform>

<script type="text/javascript">
function reload_this_asset()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-relation-asset']['fuseaction']#&action_id=#attributes.action_id#&action_section=#attributes.action_section#&asset_cat_id=#attributes.asset_cat_id#</cfoutput>','body_relation_assets',0,'Loading..')
}
function controlAsset(type)
{
	if(type == 1 || type == 2)
	{
		if(document.getElementById('asset_name').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'>");
			return false;
		}
		/*if (document.getElementById('property_id').value < 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='655.Döküman Tipi'>");
			return false;
		}*/	
		if(type == 1)
		{
			if(document.getElementById('asset_file').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='56.Belge'>");
				return false;
			}
		}
	}
	if(type == 3)
	{
		var delAnswer = confirm("<cf_get_lang_main no='1057.Kayıtlı belgeyi siliyorsunuz emin misiniz'>");
		if (delAnswer == true)
			document.getElementById('is_del').value = 1;
		else return false;
	}
	if(type != 3)
		if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
	
	document.addEditAsset.target = 'add_edit_asset';
	document.addEditAsset.submit();
}
function counter()
 {
	if (document.addEditAsset.detail.value.length > 100) 
	  {
			document.addEditAsset.detail.value = document.addEditAsset.detail.value.substring(0, 100);
			alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 100"); 
	   }
 } 
</script>
