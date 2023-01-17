<cfinclude template="../query/get_partner.cfm">
<cf_ajax_list>	
    <tbody>	
        <tr class="nohover">
            <td style="text-align:center;">
                <cfif len(get_partner.photo)>
                    <cf_get_server_file output_file="member/#get_partner.photo#" output_server="#get_partner.photo_server_id#" output_type="0"  image_width="120" image_height="160">
                <cfelse>
                    <cfif get_partner.sex eq 1>
                        <img src="/images/male.jpg" alt="<cf_get_lang dictionary_id='58546.Yok'>" title="<cf_get_lang dictionary_id='58546.Yok'>">
                    <cfelse>
                        <img src="/images/female.jpg" alt="<cf_get_lang dictionary_id='58546.Yok'>" title="<cf_get_lang dictionary_id='58546.Yok'>">
                    </cfif> 
                </cfif>
            </td>
            <cfif len(get_partner.photo) and (listlast(get_partner.photo,'.') is 'jpg' or listlast(get_partner.photo,'.') is 'png' or listlast(get_partner.photo,'.') is 'gif' or listlast(get_partner.photo,'.') is 'jpeg')> 
                <td style="text-align:right" valign="top">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#get_partner.photo_server_id#&old_file_name=#get_partner.photo#&asset_cat_id=-9</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
                </td>
            </cfif>
        </tr>
    </tbody>
</cf_ajax_list>
