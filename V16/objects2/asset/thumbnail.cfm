<cfset this_mod = #attributes.asset_position_mode#>
<cfif isdefined('attributes.asset_thumbnail_width') and len(attributes.asset_thumbnail_width)>
	<cfset my_thumbnail_width = #attributes.asset_thumbnail_width#>
<cfelse>
	<cfset my_thumbnail_width = 50>
</cfif>
<cfif isdefined('attributes.asset_thumbnail_height') and len(attributes.asset_thumbnail_height)>
	<cfset my_thumbnail_height = #attributes.asset_thumbnail_height#>
<cfelse>
	<cfset my_thumbnail_height = 50>
</cfif>
<cfif isdefined("attributes.asset_maxrow") and len(attributes.asset_maxrow)>
	<cfset my_maxrows = #attributes.asset_maxrow#>
<cfelse>
	<cfset my_maxrows = 20>
</cfif>
<cfset myImage = CreateObject("Component", "iedit")>
<cfinclude template="../../settings/query/get_file_format.cfm">
<cfset extention_list = valuelist(format.format_symbol)>
<cfset image_list = valuelist(format.icon_name)>

<cfif get_assets.recordcount>
	<table cellpadding="5" cellspacing="5" align="center" style="width:100%"> 
		<cfset my_width_ = 100/#this_mod#>
        <cfoutput query="get_assets" startrow="#attributes.startrow#" maxrows="#my_maxrows#">
            <cfif currentrow eq 1 or (currentrow mod this_mod) eq 1><tr style="height:100px;"></cfif>
            <td style="vertical-align:top; background-color:FFF; width:#my_width_#%;">
                <table>
                    <tr>
                        <td>
                            <cfif get_assets.assetcat_id gte 0>
                                <cfset url_ = "asset/#assetcat_path#">
                                <cfset path = "#upload_folder#asset#dir_seperator##assetcat_path##dir_seperator#">
                            <cfelse>
                                <cfset url_ = "#assetcat_path#">
                                <cfset path = "#upload_folder##assetcat_path##dir_seperator#">
                            </cfif>
                            <cfif listlen(asset_file_name,'.') eq 2>			
                                <cfset extention = ucase(listlast(asset_file_name,'.'))>
                                <cfset dosya_ad = listfirst(asset_file_name,'.')>
                            <cfelse>
                                <cfset extention = 'incorrect'>	
                                <cfset dosya_ad = asset_file_name>	
                            </cfif>
                            <cfif extention is 'JPG'>
                                <cfif FileExists('#upload_folder##dir_seperator#thumbnails#dir_seperator##asset_file_name#')>
                                    <cfset image_file = "thumbnails/#asset_file_name#">
                                <cfelse>
                                    <cftry>
                                        <cffile action="copy" destination="#upload_folder##dir_seperator#thumbnails" source="#path##asset_file_name#">
                                        <cfset myImage.SelectImage("#upload_folder##dir_seperator#thumbnails#dir_seperator##asset_file_name#")>
                                        <cfset myImage.scale(50,50)>
                                        <cfset myImage.output("#upload_folder##dir_seperator#thumbnails#dir_seperator##asset_file_name#", "jpg",100)>   
                                        <cfset image_file = "thumbnails/#asset_file_name#">
                                        <cfcatch type="any">
                                            <cfset image_file = "thumbnails/thumbnail_standart.jpg">
                                        </cfcatch>
                                    </cftry>
                                </cfif>
                            <cfelseif listfindnocase('PNG,GIF,JPEG','#extention#')>
                                <cfif FileExists('#upload_folder##dir_seperator#thumbnails#dir_seperator##dosya_ad#.jpg')>
                                    <cfset image_file = "thumbnails/#dosya_ad#.jpg">
                                <cfelse>
                                    <cftry>
                                        <cffile action="copy" destination="#upload_folder##dir_seperator#thumbnails" source="#path##asset_file_name#">
                                        <cffile action="delete" file="#upload_folder##dir_seperator#thumbnails#dir_seperator##asset_file_name#">
                                        <cfset image_file = "thumbnails/#dosya_ad#.jpg">
                                        <cfcatch type="any">
                                            <cfset image_file = "thumbnails/thumbnail_standart.jpg">
                                        </cfcatch>
                                    </cftry>							
                                </cfif>
                            <cfelseif extention is 'FLV'>
                                <cfif FileExists('#upload_folder##dir_seperator#thumbnails#dir_seperator##dosya_ad#.jpg')>
                                    <cfset image_file = "thumbnails/#dosya_ad#.jpg">
                                <cfelse>
                                    <cftry>
                                        <cf_wrk_video action="createthumb" inputfile="#path##asset_file_name#" outputfile="#upload_folder##dir_seperator#thumbnails#dir_seperator##dosya_ad#.jpg" returnvariable="image_file">
                                    <cfcatch type="any">
                                            <cfset image_file = "thumbnails/thumbnail_standart.jpg">
                                        </cfcatch>
                                    </cftry>
                                </cfif>
                            <cfelseif listfindnocase(extention_list,'#extention#')>
                                <cfset image_file = "settings/#listgetat(image_list,listfindnocase(extention_list,'#extention#'))#">
                            <cfelse>
                                <cfset image_file = "thumbnails/thumbnail_standart.jpg">
                            </cfif>
                            <cfif isDefined("attributes.asset_archive")>
                                <cfset file_path = '#path##asset_file_name#'>
                                <cfset rm = '#chr(13)#'>
                                <cfset desc = ReplaceList(detail,rm,'')>
                                <cfset rm = '#chr(10)#'>
                                <cfset desc = ReplaceList(desc,rm,'')>
                                <cfif desc is ''><cfset desc = 'image'></cfif>
                                <cfset asset_name2 = replace(asset_name,"'"," ","ALL")>			
                                <a href="##" onclick="sendAsset('#asset_file_name#','#ReplaceList(file_path,'\','\\')#','#desc#','#asset_name2#','#asset_file_size#','#property_id#')" class="tableyazi" title="#asset_name#">
                                    <cf_get_server_file output_file="#image_file#" output_server="#asset_file_server_id#" output_type="0" image_link="0" image_width="#my_thumbnail_width#" image_height="#my_thumbnail_height#" title="#asset_name#" alt="#asset_name#">
                                </a>
                            <cfelse>
                                <cf_get_server_file output_file="#url_#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" image_link="1" image_width="#my_thumbnail_width#" image_height="#my_thumbnail_height#" title="#asset_name#" alt="#asset_name#" small_image="/documents/#image_file#">
                            </cfif>	
                        </td>
                        <cfif isdefined('attributes.asset_detail_position') and attributes.asset_detail_position eq 1 and isdefined('attributes.is_asset_detail') and attributes.is_asset_detail eq 1>
                            <td style="vertical-align:top;"><b>#asset_name#</b><br />#detail#</td>
                        </cfif>
                    </tr>
                    <cfif isdefined('attributes.asset_detail_position') and attributes.asset_detail_position eq 2 and isdefined('attributes.is_asset_detail') and attributes.is_asset_detail eq 1>
                        <tr>
                            <td><b>#asset_name#</b></td>
                        </tr>
                        <tr>
                            <td>#detail#</td>
                        </tr>
                    </cfif>
                </table>
            </td>
            <cfif currentrow eq recordcount or (currentrow mod this_mod) eq 0><tr></cfif>
        </cfoutput>
    </table>
<cfelse>
    <table cellspacing="0" cellpadding="0" border="0" align="center" style="width:97%">
        <tr>
			<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
    </table>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrow>
	<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
		<tr>
			<td>
				<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrow#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#">
			</td>
			<td  class="tableyazi" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
	<br/>
</cfif>
