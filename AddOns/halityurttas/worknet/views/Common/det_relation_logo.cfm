<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.Companies.member") />
<cfset getCompany = cmp.getCompany(company_id:attributes.cpid,company_status:'') />
<cf_ajax_list>
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
</cf_ajax_list>