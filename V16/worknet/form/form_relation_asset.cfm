<cfsetting showdebugoutput="no">
<cfset getAssetProperty = createObject("component","V16.worknet.query.worknet_asset").getAssetProperty()>
<iframe style="display:none;" src="" name="add_edit_asset" id="add_edit_asset" width="0" height="0"></iframe>
<cfform name="addEditAsset" action="#request.self#?fuseaction=worknet.emptypopup_query_relation_asset" method="post" enctype="multipart/form-data">
<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#attributes.asset_cat_id#</cfoutput>">
<cfif isdefined('attributes.asset_id') and len(attributes.asset_id)>
	<cfset getAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(asset_id:attributes.asset_id,action_id:attributes.action_id,action_section:attributes.action_section,asset_cat_id:attributes.asset_cat_id)>
	<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#getAsset.asset_id#</cfoutput>">
	<input type="hidden" name="is_del" id="is_del" value="0">
	<table border="0">
		<tr height="25" style="width:100%">
			<td><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'> *</td>
			<td><input type="text" name="asset_name" id="asset_name" maxlength="150" value="<cfoutput>#getAsset.asset_name#</cfoutput>" style="width:150px;"></td>
            <cfif listlast(getAsset.ASSET_FILE_NAME,'.') is 'jpg' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'png' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'gif' or listlast(getAsset.ASSET_FILE_NAME,'.') is 'jpeg'> 
				<td style="text-align:right;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getAsset.ASSET_FILE_SERVER_ID#&old_file_name=#getAsset.ASSET_FILE_NAME#&asset_cat_id=#attributes.asset_cat_id#</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
				</td>
			</cfif>
		</tr>
		<input type="hidden" name="property_id" id="property_id" value="1">
		<!---<tr height="25">
			<td><cf_get_lang_main no='655.Döküman Tipi'> *</td>
			<td><select name="property_id" id="property_id" style="width:150px;">
					<option value="-1"><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="getAssetProperty">
						<option value="#content_property_id#"<cfif getAsset.property_id eq content_property_id>selected</cfif>>#name#</option>
					</cfoutput>
				</select>
			</td>
		</tr>--->
		<tr height="25">
			<td><cf_get_lang_main no='56.Belge'> *</td>
			<td><input type="hidden" value="<cfoutput>#getAsset.ASSET_FILE_NAME#</cfoutput>" name="old_file_name" id="old_file_name">
				<input type="hidden" value="<cfoutput>#getAsset.ASSET_FILE_SERVER_ID#</cfoutput>" name="old_file_server_id" id="old_file_server_id">
				<input type="file" name="asset_file" id="asset_file" style="width:150px; float:left;">
			</td>
            <td>
				<cfoutput>
					<cfif ListLast(getAsset.asset_file_name,'.') is 'flv'>
						<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##getAsset.ASSETCAT_PATH#/#getAsset.asset_file_name#&ext=flv&video_id=#getAsset.asset_id#','video');" class="tableyazi"><font color="red">Görüntüle.</font></a>
					<cfelse>
						<a href="javascript://" onClick="windowopen('#file_web_path##getAsset.ASSETCAT_PATH#/#getAsset.asset_file_name#','medium');" title="#getAsset.ASSET_NAME#" class="tableyazi"><font color="red">Görüntüle.</font></a>
					</cfif>	
				</cfoutput>
            </td>
		</tr>
		<tr valign="top">
			<td><cf_get_lang no='11.Anahtar Kelime'></td>
			<td colspan="2"><textarea
				style="width:150px;height:50px;" 
				name="detail" id="detail" 
				onChange="counter();return ismaxlength(this);" 
				onkeydown="counter();return ismaxlength(this);" 
				onkeyup="counter();return ismaxlength(this);" 
				onBlur="return ismaxlength(this);" 
				><cfoutput>#getAsset.ASSET_DETAIL#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td></td>
			<td colspan="2"><input type="button" value="<cf_get_lang_main no ='51.Sil'>" onClick="controlAsset(3);" />
				<input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onClick="controlAsset(2);" />
				<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_asset();" />
			</td>
		</tr>
	</table>
<cfelse>
	<table border="0">
		<tr height="25">
			<td><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'> *</td>
			<td><input type="text" name="asset_name" id="asset_name" value="" maxlength="100" style="width:150px;">
			</td>
		</tr>
		<input type="hidden" name="property_id" id="property_id" value="1">
		<!---<tr height="25">
			<td><cf_get_lang_main no='655.Döküman Tipi'> *</td>
			<td><select name="property_id" id="property_id" style="width:150px;">
					<option value="-1"><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="getAssetProperty">
						<option value="#content_property_id#">#name#</option>
					</cfoutput>
				</select>
			</td>
		</tr>--->
		<tr height="25">
			<td><cf_get_lang_main no='56.Belge'> *</td>
			<td><input type="file" name="asset_file" id="asset_file" style="width:150px;"></td>
		</tr>
		<tr valign="top">
			<td><cf_get_lang no='11.Anahtar Kelime'></td>
			<td><textarea
				style="width:150px;height:50px;" 
				name="detail" id="detail" 
				onChange="counter();return ismaxlength(this);"
				onkeydown="counter();return ismaxlength(this);" 
				onkeyup="counter();return ismaxlength(this);" 
				onBlur="return ismaxlength(this);"></textarea>
			</td>
		</tr>
		<tr>
			<td></td>
			<td><input type="button" value="<cf_get_lang_main no ='49.Kaydet'>" onClick="controlAsset(1);" />
				<input type="button" value="<cf_get_lang_main no ='20.Geri'>" onClick="reload_this_asset();" />
			</td>
		</tr>
	</table>
</cfif>
</cfform>

<script type="text/javascript">
function reload_this_asset()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.action_id#&action_section=#attributes.action_section#&asset_cat_id=#attributes.asset_cat_id#</cfoutput>','body_relation_assets',0,'Loading..')
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
