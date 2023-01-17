<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT 
		ASSET_ID,
		ASSET_FILE_NAME,
		ASSET_FILE_SERVER_ID,
		ASSETCAT_ID,
		ASSET_NAME,
		PROPERTY_ID,
		ASSET_DETAIL
	FROM 
		ASSET 
	WHERE 
		ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
</cfquery>
<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
</cfquery>
<cfform name="upd_asset" action="#request.self#?fuseaction=objects2.emptypopup_upd_asset" method="post" enctype="multipart/form-data">
<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
<input type="hidden" name="old_asset_file" id="old_asset_file" value="<cfoutput>#get_asset.asset_file_name#</cfoutput>">
<input type="hidden" name="old_asset_file_server_id" id="old_asset_file_server_id" value="<cfoutput>#get_asset.asset_file_server_id#</cfoutput>">
<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#get_asset.assetcat_id#</cfoutput>">
<input type="hidden" name="is_file_upload_size" id="is_file_upload_size" value="<cfif isdefined('attributes.is_file_upload_size')><cfoutput>#attributes.is_file_upload_size#</cfoutput></cfif>">

<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="vertical-align:middle; height:35px;">
		<td>
			<table align="center" style="width:98%;">
				<tr>
					<td class="headbold" style="width:48%; vertical-align:bottom;"><cf_get_lang no='1625.Belge Güncelle'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row" style="vertical-align:top;">
		<td>
			<table align="center" cellpadding="0" cellspacing="0" style="width:98%;">
				<tr>
					<td colspan="2">
						<table>
							<tr>
								<td><cf_get_lang no='1626.Belge Adı'> *</td>
								<td><cfsavecontent variable="msg"><cf_get_lang no='219.Lütfen Ad Giriniz!'></cfsavecontent>
									<cfinput type="text" name="asset_file_name" id="asset_file_name" value="#get_asset.asset_name#" maxlength="100" style="width:200px;" required="yes" message="#msg#">
								</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='655.Döküman Tipi'> *</td>
								<td>
									<select name="property_id" id="property_id" style="width:200px;">
										<option value="-1"><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_content_property">
											<option value="#content_property_id#"<cfif get_asset.property_id eq content_property_id> selected</cfif>>#name#</option>
										</cfoutput>
									</select>
								</td>
							</tr>	
							<tr>
								<td><cf_get_lang_main no='56.Belge'> </td>
								<td><input type="file" name="asset_file" id="asset_file" style="width:200px;"></td>
							</tr>
							<tr valign="top">
								<td><cf_get_lang_main no='217.Açıklama'></td>
								<td><textarea name="detail" id="detail" style="width:200px; height:80px;"><cfoutput>#get_asset.asset_detail#</cfoutput></textarea></td>
							</tr>
							<tr style="height:25px;">
								<td></td>
								<td><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_asset_file&asset_id=#get_asset.asset_id#' add_function="input_control()"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
	function get_content_property(type)
	{
		if(type == undefined)
			asset_cat_id = document.getElementById('assetcat_id').value;
		else
			asset_cat_id = type;
		if(asset_cat_id != '')
		{
			get_content_pro = wrk_safe_query('get_content_property3','dsn',0,asset_cat_id);
			var currency_len = document.getElementById("property_id").options.length;
			for(kk=currency_len;kk>=0;kk--)
				document.getElementById("property_id").options[kk] = null;	
				
			document.getElementById("property_id").options[0] = new Option('<cf_get_lang_main no="322.Seçiniz">','');
			for(var jj=0;jj < get_content_pro.recordcount;jj++)
			{
				document.getElementById("property_id").options[jj+1]=new Option(get_content_pro.NAME[jj],get_content_pro.CONTENT_PROPERTY_ID[jj]);
				if(document.getElementById("property_id").options[jj+1].value == <cfoutput>#get_asset.property_id#</cfoutput>)
				{
					document.getElementById("property_id").options[jj+1].selected = true;	
				}
			}
		}
	}
	<cfif isdefined('get_asset.assetcat_id') and len(get_asset.assetcat_id)>
		get_content_property('<cfoutput>#get_asset.assetcat_id#</cfoutput>');
	</cfif>
	function input_control()
	{
		if(document.getElementById('asset_file_name').value == "")
		{
			alert("<cf_get_lang no='1615.Lütfen Belge Adı Giriniz!!'>");
			return false;
		}
		if (document.getElementById('property_id').value == '')
		{
			alert("<cf_get_lang no='1279.Döküman Tipi Seçmelisiniz !'>");
			return false;
		}
		return true;
	}
</script>
