<cfset getBrand = cmp.getBrand(member_id:attributes.cpid)>
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfsavecontent variable="title"><cf_get_lang_main no='1225.Logo'></cfsavecontent>
<cf_box 
    id="relation_assets" 
    title="#title#" 
    closable="0" 
    style="width:98%;" 
    box_page="#request.self#?fuseaction=worknet.list_relation_logo&cpid=#attributes.cpid#">
</cf_box>
<!---<cf_box id="box_photo" title="#title#" closable="0" collapsed="#iif(attributes.style,1,0)#">
	<table align="center" width="100%">
		<tr>
			<td style="text-align:center;">
				<cfif len(getCompany.ASSET_FILE_NAME1)>
					<cf_get_server_file output_file="member/#getCompany.ASSET_FILE_NAME1#" output_server="#getCompany.ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="120" image_height="100">
				<cfelse>
					<img src="/images/no_photo.gif" />
				</cfif>
			</td>
        	<cfif len(getCompany.ASSET_FILE_NAME1) and (listlast(getCompany.ASSET_FILE_NAME1,'.') is 'jpg' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'png' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'gif' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'jpeg')> 
                <td style="text-align:right" valign="top">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getCompany.ASSET_FILE_NAME1_SERVER_ID#&old_file_name=#getCompany.ASSET_FILE_NAME1#&asset_cat_id=-9</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
                </td>
            </cfif>
		</tr>
	</table>
</cf_box>
--->
<!--- <cf_get_workcube_note action_section='COMPANY_ID' action_id='#attributes.cpid#' style="1"> --->
<!--- <cfsavecontent variable="text"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>
<cf_box id="relation_assets" title="#text#" closable="0" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.cpid#&action_section=COMPANY_ID&asset_cat_id=-9"
	add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#attributes.cpid#&action_section=COMPANY_ID&asset_cat_id=-9','body_relation_assets',0,'Loading..')">
</cf_box> --->
<cfsavecontent variable="text"><cf_get_lang no='2.Markalarım'></cfsavecontent>
<cf_box id="brands" title="#text#" closable="0" collapsable="1" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_brands&cpid=#attributes.cpid#"
	add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_brands&cpid=#attributes.cpid#','body_brands',0,'Loading..')">
</cf_box>
<!--- <cf_get_workcube_content action_type ='COMPANY_ID' action_type_id ='#attributes.cpid#' style='0' design='0'> --->
