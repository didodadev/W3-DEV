<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
</cfquery>
<cfform name="add_asset" action="#request.self#?fuseaction=pda.emptypopup_add_asset" method="post" enctype="multipart/form-data">
<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#attributes.asset_cat_id#</cfoutput>">
<input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>">
<input type="hidden" name="module_id" id="module_id" value="<cfoutput>#attributes.module_id#</cfoutput>">
<input type="hidden" name="is_file_upload_size" id="is_file_upload_size" value="<cfif isdefined('attributes.is_file_upload_size')><cfoutput>#attributes.is_file_upload_size#</cfoutput></cfif>">
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="height:35px;">
		<td>
            <table align="center" style="width:99%;">
                <tr>
                    <td class="headbold" style="vertical-align:bottom;"><cf_get_lang_main no='54.Belge Ekle'></td>
                </tr>
            </table>
		</td>
	</tr>  
	<tr class="color-row " style="vertical-align:top;">
		<td>
			<table>      
				<tr>
					<td><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='485.Adı'> *</td>
					<td><cfsavecontent variable="msg"><cf_get_lang no='1615.Lütfen Belge Adı Giriniz'>!</cfsavecontent>
						<cfinput type="text" name="asset_file_name" id="asset_file_name" value="" maxlength="100" style="width:200px;" required="yes" message="#msg#">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='655.Döküman Tipi'> *</td>
					<td>
						<select name="property_id" id="property_id" style="width:200px;">
							<option value="-1"><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_content_property">
								<option value="#content_property_id#">#name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>	
                <tr>
                	<td><cf_get_lang_main no="1447.Süreç"></td>
					<cfif isdefined('attributes.process_stage')>
                        <td><cf_workcube_process is_upd='0' process_cat_width='200' select_value='#attributes.process_stage#' is_detail='0'></td>
                    <cfelse>
                        <td><cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'></td>                    
                    </cfif>
                </tr>
				<tr>
				  	<td><cf_get_lang_main no='56.Belge'> *</td>
				  	<td><input type="file" name="asset_file" id="asset_file" style="width:300px;height:50px;"></td>
				</tr>
				<tr valign="top">
					<td><cf_get_lang_main no='217.Açıklama'></td>
					<td><textarea name="detail" id="detail" style="width:200px; height:80px;"></textarea></td>
				</tr>
				<tr style="height:35px;">
					<td></td>
					<td><cf_workcube_buttons is_upd='0' add_function="input_control()"></td>
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
				document.getElementById("property_id").options[jj+1]=new Option(get_content_pro.NAME[jj],get_content_pro.CONTENT_PROPERTY_ID[jj]);
		}
	}
	<cfif isdefined('attributes.asset_cat_id') and len(attributes.asset_cat_id)>
		get_content_property('<cfoutput>#attributes.asset_cat_id#</cfoutput>');
	</cfif>
	function input_control()
	{
		if(document.getElementById('asset_file_name').value == "")
		{
			alert("<cf_get_lang no='1615.Lütfen Belge Adı Giriniz'>");
			return false;
		}
		if (document.getElementById('property_id').value == '')
		{
			alert("<cf_get_lang no='1279.Döküman Tipi Seçmelisiniz'>");
			return false;
		}	
		if(document.getElementById('asset_file').value == "")
		{
			alert("<cf_get_lang no='15.Belge Secmelisiniz'>");
			return false;
		}
		return true;
	}
    addLoadEvent();
</script>
