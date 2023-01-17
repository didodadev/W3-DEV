<cfsavecontent variable="title"><cf_get_lang no='105.Fotoğraf'></cfsavecontent>
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cf_box id="box_photo" title="#title#" closable="0" collapsed="#iif(attributes.style,1,0)#">
	<table class="ajax_list">
		<tr>
			<td style="text-align:center;">
				<cfif len(getPartner.photo)>
					<cf_get_server_file output_file="member/#getPartner.photo#" output_server="#getPartner.photo_server_id#" output_type="0" image_width="120" image_height="160">
				<cfelse>
					<cfif getPartner.sex eq 1>
                        <img src="/images/male.jpg" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
                    <cfelse>
                        <img src="/images/female.jpg" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
                    </cfif> 
				</cfif>
			</td>
			<cfif len(getPartner.photo) and (listlast(getPartner.photo,'.') is 'jpg' or listlast(getPartner.photo,'.') is 'png' or listlast(getPartner.photo,'.') is 'gif' or listlast(getPartner.photo,'.') is 'jpeg')> 
                <td style="text-align:right" valign="top">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getPartner.photo_server_id#&old_file_name=#getPartner.photo#&asset_cat_id=-9</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
                </td>
            </cfif>
		</tr>
	</table>
</cf_box>

<cf_get_workcube_note action_section='PARTNER_ID' action_id='#getPartner.partner_id#'>

