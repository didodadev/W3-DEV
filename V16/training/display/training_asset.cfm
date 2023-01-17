<cfscript>
	get_class_asset_action = createObject("component","V16.training.cfc.get_training_asset");
	get_class_asset_action.dsn = dsn;
	trainig_asset = get_class_asset_action.get_training_asset_fnc
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cf_ajax_list>
    <tbody>
         <cfif trainig_asset.recordcount> 
            <cfoutput query="trainig_asset"> 
                <tr height="20"> 
                    <td>
                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=-6&file_name=training/#asset_file_name#"><img src="/images/download.gif" border="0" align="absmiddle"></a>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_download_file&direct_show=1&file_name=training/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=-6','medium');" class="tableyazi">#asset_name# </a>(#NAME#)
                    </td>
                </tr>
            </cfoutput> 
         <cfelse> 
                <tr>
                    <td>
                        <cf_get_lang_main no='72.Kayit Bulunamadi'>!
                    </td>
                </tr>
         </cfif> 
    </tbody>
</cf_ajax_list>
