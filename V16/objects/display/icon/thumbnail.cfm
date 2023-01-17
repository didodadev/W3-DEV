<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
<cfset myImage = CreateObject("Component", "WMO.iedit")>
<cfinclude template="../../../settings/query/get_file_format.cfm">
<cfset extention_list = valuelist(format.format_symbol)>
<cfset image_list = valuelist(format.icon_name)>
<cfif attributes.fuseaction contains 'popup'>
	<!---<cfset sayfa = 'objects.popup_asset_digital'>--->
	<cfset sayfa = 'objects.popup_asset_digital'>	
	<cfset this_mod = 5>
<cfelse>
	<cfset sayfa = 'asset.list_asset'>
	<cfset this_mod = 10>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_assets.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id="57487.No"></th>
				<th></th>
			<th><cf_get_lang dictionary_id="29452.Varlık"></th>
		</tr>
	</thead>
	<cfif get_assets.recordcount>
		<tbody>
			<cfoutput query="get_assets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>
						
						<cfif assetcat_id gte 0>
							<cfset path_ = "asset/#assetcat_path#">
						<cfelse>
							<cfset path_ = "#assetcat_path#">
						</cfif>
						<cfif company_asset_relation eq 1>
							<cfif len(get_assets.related_asset_id)>
								<cfquery name="getAssetRelated" datasource="#DSN#">
									SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assets.related_asset_id#">
								</cfquery>
								<cfif len(getAssetRelated.action_id)>
									<cfset url_ = "#file_web_path#/#path_#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#/">
									<cfset path = "#upload_folder##path_##dir_seperator##year(getAssetRelated.record_date)##dir_seperator##getAssetRelated.action_id##dir_seperator#">
								<cfelse>
									<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
									<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
								</cfif>
							<cfelseif len(get_assets.action_id)>
								<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/#get_assets.action_id#/">
								<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator##get_assets.action_id##dir_seperator#">
							<cfelse>
								<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
								<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
							</cfif>
						<cfelse>
							<cfset url_ = "#file_web_path#/#path_#/">
							<cfset path = "#upload_folder##path_##dir_seperator#">
						</cfif>
						<cfif listlen(asset_file_name,'.') eq 2>			
							<cfset extention = ucase(listlast(asset_file_name,'.'))>
							<cfset dosya_ad = listfirst(asset_file_name,'.')>
						<cfelse>
							<cfset extention = 'incorrect'>	
							<cfset dosya_ad = asset_file_name>	
						</cfif>
						<cfif extention is 'JPG'>
							<cfif FileExists('#upload_folder#thumbnails#dir_seperator##asset_file_name#')>
								<cfset image_file = "thumbnails/#asset_file_name#">
							<cfelse>
								<cftry>
								<cffile action="copy" destination="#upload_folder#thumbnails" source="#path##asset_file_name#">
									<cfset myImage.SelectImage("#upload_folder#thumbnails#dir_seperator##asset_file_name#")>
									<cfset myImage.scale(50,50)>
									<cfset myImage.output("#upload_folder#thumbnails#dir_seperator##asset_file_name#", "jpg",100)>
									<cfset image_file = "thumbnails/#asset_file_name#">
									<cfcatch type="any">
									<cfset image_file = "thumbnails/undefined.jpg">
								</cfcatch>
								</cftry>
							</cfif>
						<cfelseif listfindnocase('PNG,GIF,JPEG','#extention#')>
							<cfif FileExists('#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg')>
								<cfset image_file = "thumbnails/#dosya_ad#.jpg">
							<cfelse>
								<cftry>
									<cffile action="copy" destination="#upload_folder#thumbnails" source="#path##asset_file_name#">
									<cfset myImage.SelectImage("#upload_folder#thumbnails#dir_seperator##asset_file_name#")>
									<cfset myImage.scale(50,50)>
									<cfset myImage.output("#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg", "jpg",100)>
									<cffile action="delete" file="#upload_folder#thumbnails#dir_seperator##asset_file_name#">
									<cfset image_file = "thumbnails/#dosya_ad#.jpg">
									<cfcatch type="any">
										<cfset image_file = "thumbnails/undefined.jpg">
									</cfcatch>
								</cftry>							
							</cfif>
						<cfelseif extention is 'FLV'>
							<cfif FileExists('#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg')>
								<cfset image_file = "thumbnails/#dosya_ad#.jpg">
							<cfelse>
								<cftry>
									<cf_wrk_video action="createthumb" inputfile="#path##asset_file_name#" outputfile="#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg" returnvariable="image_file">
								<cfcatch type="any">
										<cfset image_file = "thumbnails/undefined.jpg">
									</cfcatch>
								</cftry>
							</cfif>
						<cfelseif listfindnocase(extention_list,'#extention#')>
							<cfset image_file = "settings/#listgetat(image_list,listfindnocase(extention_list,'#extention#'))#">
						<cfelse>
							<cfset image_file = "thumbnails/undefined.jpg">
						</cfif>
					
						<cfif isdefined("attributes.asset_archive")>
							<cfset file_path = '#path##asset_file_name#'>
							<cfset rm = '#chr(13)#'>
							<cfset desc = ReplaceList(description,rm,'')>
							<cfset rm = '#chr(10)#'>
							<cfset desc = ReplaceList(desc,rm,'')>
							<cfif desc is ''><cfset desc = 'image'></cfif>
							<cfset asset_name2 = replace(asset_name,"'"," ","ALL")>			
							<a href="##" onclick="sendAsset('#asset_file_name#','#ReplaceList(file_path,'\','\\')#','#desc#','#asset_name2#','#asset_file_size#','#property_id#','#asset_id#','#asset_file_real_name#','#assetcat_id#','#attributes.action#','#attributes.action_id#','#EMBEDCODE_URL#')" class="tableyazi"><cf_get_server_file output_file="#image_file#" output_server="#asset_file_server_id#" output_type="0" image_link="0" image_width="50" image_height="50"></a>
								
						<cfelseif isdefined("attributes.thumbnail")>
					
							<cfset file_path = '#path##asset_file_name#'>
							<cfset rm = '#chr(13)#'>
							<cfset desc = ReplaceList(description,rm,'')>
							<cfset rm = '#chr(10)#'>
							<cfset desc = ReplaceList(desc,rm,'')>
							<cfif desc is ''><cfset desc = 'image'></cfif>
							<cfset asset_name2 = replace(asset_name,"'"," ","ALL")>	
							<a href="##" onclick="sendImage('#asset_file_name#','#ReplaceList(file_path,'\','\\')#','#attributes.id#','#desc#')" class="tableyazi"><cf_get_server_file output_file="#image_file#" output_server="#asset_file_server_id#" output_type="0" image_link="0" image_width="50" image_height="50"></a>
								
						<cfelse>	
							<cfif asset_file_server_id eq fusebox.server_machine>
						
								<cfif extention eq "flv">
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_flvplayer&video=/#url_#/#asset_file_name#','video','popup_flvplayer');" class="tableyazi"><cf_get_server_file output_file="#url_#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" image_link="0" image_width="50" image_height="50" small_image="/documents/#image_file#"></a>
								<cfelseif listfind(mediaplayer_extensions, "."&extention)>
									<a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_mediaplayer&video=/#url_#/#asset_file_name#','video');" class="tableyazi"><cf_get_server_file output_file="#url_#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" image_link="0" image_width="50" image_height="50" small_image="/documents/#image_file#"></a>
								<cfelse>
									<a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#url_#/#asset_file_name#&file_control=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#"><cf_get_server_file output_file="#url_#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" image_link="0" image_width="50" image_height="50" small_image="/documents/#image_file#"></a>
								</cfif>
								
							<cfelse>
								<cf_get_server_file output_file="#url_#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" image_link="1" image_width="50" image_height="50" small_image="/documents/#image_file#">
							</cfif>
							
						</cfif>	
				
					</td>
					<td height="30"><a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi">#asset_name#</a></td>
				</tr>
				
			</cfoutput>
		</tbody>
	<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</cf_flat_list>
<cfif attributes.totalrecords gt attributes.maxrows>

	<cfif isdefined("attributes.is_submit")>
		<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#"> 
	</cfif>
	<cfif isdefined("attributes.keyword")>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#"> 
	</cfif>
	<cfif isdefined("attributes.module_id")>
		<cfset url_str = "#url_str#&module_id=#attributes.module_id#"> 
	</cfif>
	<cfif isdefined("attributes.property_id")>
		<cfset url_str = "#url_str#&property_id=#attributes.property_id#"> 
	</cfif>
	<cfif isdefined("attributes.action_id")>
		<cfset url_str = "#url_str#&action_id=#attributes.action_id#"> 
	</cfif>
	<cfif isdefined("attributes.ASSET_ARCHIVE")>
		<cfset url_str = "#url_str#&ASSET_ARCHIVE=#attributes.ASSET_ARCHIVE#"> 
	</cfif>
	<cfif isdefined("attributes.refresh_id")>
		<cfset url_str = "#url_str#&refresh_id=#attributes.refresh_id#">
	</cfif>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#sayfa##url_str#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			
</cfif>
