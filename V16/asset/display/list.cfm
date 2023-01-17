<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>

<cfscript>

	imageSettings =	{///thumbnail Settings

		1	:	{
			folderName	:	"icon",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	128,
			newHeight	:	128
		},
		2	:	{
			folderName	:	"middle",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	512,
			newHeight	:	256
		}
	};

</cfscript>

<cfset icon = false>
<cfset fileType = "">
<cfset imagePath = "">

<cffunction name="infoFileType">
	<cfargument name="file_path" type="string" required="true">
	<cfargument name="ext" type="string" required="true">

	<cfif FileExists(file_path)>
		
		<cfset fileSysType = fileSystem.fileType(ext)>
		<cfset fileType = fileSysType["fileType"]>
		<cfif fileSysType["fileType"] eq "document" or fileSysType["fileType"] eq "other"> 

			<cfset imagePath = "css/assets/icons/catalyst-icon-svg/#ext#.svg">
			<cfif ext eq 'docx'>
				<cfset imagePath = "css/assets/icons/catalyst-icon-svg/DOC.svg">
			</cfif>
			<cfset icon = true>

		<cfelseif fileSysType["fileType"] eq "video">
					
			<cfset imagePath = url_ & asset_file_name>
			<cfset icon = false>

		<cfelseif fileSysType["fileType"] eq "audio">

			<cfset imagePath = url_ & asset_file_name>
			<cfset icon = false>

		<cfelseif fileSysType["fileType"] eq "image" or fileSysType["fileType"] eq "noType">
				
			<cfif FileExists("#uploadFolder#thumbnails/middle/#asset_file_name#")>

				<cfset imagePath = "documents/thumbnails/middle/#asset_file_name#">
				<cfset icon = false>

			<cfelse>
				
				<cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />
				<cfif ext neq 'svg'>
					<cfset imageOperations = CreateObject("Component","cfc.image_operations") />

					<cfloop from="1" to="#imageSettings.count()#" index="row">
						
						<cfset imageOperations.imageCrop(
											imagePath : "#file_path#",
											imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#asset_file_name#",
											imageCropType	:	1, <!--- Orantılı boyutlandır --->
											newWidth : #imageSettings[row]["newWidth"]#,
											newHeight : #imageSettings[row]["newHeight"]#
											) />

					</cfloop>
				<cfelse> <!--- SVG formatı için doğrudan thumbnail klasörüne atıyoruz --->
					<cfset imageThumbPath = "#uploadFolder#thumbnails/middle" &"/#asset_file_name#">
					<cffile action="copy" source="#file_path#" destination="#imageThumbPath#">
				</cfif>
				<cfset imagePath = "documents/thumbnails/middle/#asset_file_name#" />
				<cfset icon = false>

			</cfif>

		<cfelse>

			<cfset imagePath = "images/intranet/no-preview.png">
			<cfset icon = true>

		</cfif>
	<cfelseif isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL)>
			<cfset imagePath = '#get_assets.EMBEDCODE_URL#'>
			<cfset icon = false>
	
	<cfelse>

		<cfset imagePath = "images/intranet/no-image.png">
		<cfset icon = true>

	</cfif>	

</cffunction>

<cfset colspan = 11>
<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
<!--- <div class="cat-bar col col-3 col-xs-12" id="cat-bar" <cfif #attributes.list_type# eq "changeListType">style="display:none;"</cfif>>	</div> --->

<div class="ui-row">
	<div id="type-box">	
		<div id="type-box-content">
			
				<cfif get_assets.recordcount>
					<cfset get_emp_list = ''>
					<cfset get_cons_list = ''>
					<cfset get_par_list = ''>
					<cfset get_emp_list_2 = ''>
					<cfset get_cons_list_2 = ''>
					<cfset get_par_list_2 = ''>
					<cfset property_list = ''>
					<cfset page_id_list = ''>
					<cfset project_list = ''>
					<cfoutput query="get_assets">
						<cfif len(record_emp) and not listfind(get_emp_list,record_emp)>
							<cfset get_emp_list=listappend(get_emp_list,record_emp)>
						</cfif>
						<cfif len(record_pub) and not listfind(get_cons_list,record_pub)>
							<cfset get_cons_list=listappend(get_cons_list,record_pub)>
						</cfif>
						<cfif len(record_par) and not listfind(get_cons_list,record_par)>
							<cfset get_par_list=listappend(get_par_list,record_par)>
						</cfif>
						<cfif len(property_id) and not listfind(property_list,property_id)>
							<cfset property_list=listappend(property_list,property_id)>
						</cfif>
						<cfif isdefined("project_id") and len(project_id) and not listfind(project_list,project_id)>
							<cfset project_list=listappend(project_list,project_id)>
						</cfif>
						<cfif isdefined("project_multi_id") and len(project_multi_id) and not listfind(project_list,project_id)>
							<cfset project_list=listappend(project_list,mid(project_multi_id,2,len(project_multi_id)-2))>
						</cfif>
					</cfoutput>		
					<cfif len(get_emp_list)>
						<cfquery name="GET_EMP" datasource="#DSN#">
							SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_emp_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset get_emp_list_2 = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(get_cons_list)>
						<cfquery name="GET_CONS" datasource="#DSN#">
							SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#get_cons_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset get_cons_list_2 = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(get_par_list)>
						<cfquery name="GET_PAR" datasource="#DSN#">
							SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#get_par_list#) ORDER BY PARTNER_ID
						</cfquery>
						<cfset get_par_list_2 = listsort(listdeleteduplicates(valuelist(get_par.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(property_list)>
						<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
							SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN (#property_list#) ORDER BY CONTENT_PROPERTY_ID
						</cfquery> 
						<cfset property_list = listsort(listdeleteduplicates(valuelist(get_content_property.content_property_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_list)>
						<cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
							SELECT PROJECT_NUMBER,PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
						</cfquery> 
						<cfset project_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
					</cfif>
					
					<cfoutput query="get_assets">
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
		
						<cfset file_path = '#path##asset_file_name#'>
						<cfset rm = '#chr(13)#'>
						<cfset desc = ReplaceList(description,rm,'')>
						<cfset rm = '#chr(10)#'>
						<cfset desc = ReplaceList(desc,rm,'')>
						<cfif desc is ''><cfset desc = 'image'></cfif>
						<cfif not isDefined("attributes.asset_archive")>
							<cfif assetcat_id gte 0>
								<cfset file_add_ = "asset/">
							<cfelse>
								<cfset file_add_ = "">
							</cfif>
						</cfif>
						<cfset ext=lcase(listlast(asset_file_name, '.')) />
						
						<cfset infoFileType(file_path,ext)>
		
						
							<div class="col <cfif #attributes.list_type# eq 'changeColumn' and #attributes.listTypeElement# eq 'folder'>col-4<cfelse>col-3</cfif> col-md-4 col-sm-6 col-xs-12">
								<div class="archive_list_item">
									<div class="archive_list_item_image">
										<cfif fileType eq "video">
												
											<cfif len(asset_file_path_name)>
												<cfset my_video_file_path = #asset_file_path_name#>
											<cfelse>
												<cfset my_video_file_path = '/documents/#file_add_##assetcat_path#/#asset_file_name#'>
											</cfif>
			
											<cfif (ext eq "mp4")>
												<cfset type = "video/mp4">
											<cfelseif (ext eq "mpeg")>
												<cfset type = "video/mpeg">
											</cfif>
			
											<cfset fileType = ''>
											<video width="100%" controls controlsList="nodownload">
												<source src="#imagePath###t=1" type="#type#">
												<p>Your browser doesn't support HTML5 video.</p>
											</video>
			
										<cfelseif fileType eq "audio">
			
											<cfif (ext eq "ogg")>
												<cfset type = "audio/ogg">
											<cfelseif (ext eq "mp3")>
												<cfset type = "audio/mpeg">
											<cfelseif (ext eq "wav")>
												<cfset type = "audio/wav">
											</cfif>
			
											<audio style="width:250px;" controls controlsList="nodownload">
												<source src="#imagePath#" type="#type#">
												Your browser does not support the HTML5 audio element.
											</audio>
			
										<cfelseif isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL)>
											<cfif FileExists(file_path)>
												<cfif get_assets.EMBEDCODE_URL contains 'youtube.com' or  get_assets.EMBEDCODE_URL contains 'loom.com' or  get_assets.EMBEDCODE_URL contains 'vimeo.com'>
													<a target="_blank" class="ui-cards-img-play" href="#get_assets.EMBEDCODE_URL#">
														<i class="fa fa-youtube-play play-icon"></i>
													</a>
												</cfif>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif" or ext eq "svg">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
													<img src="#imagePath#">
												</a>
											<cfelseif get_assets.EMBEDCODE_URL contains 'docs.google.com/spreadsheets'>
												<img src="css/assets/icons/catalyst-icon-svg/XLS.svg" >
											<cfelseif get_assets.EMBEDCODE_URL contains 'docs.google.com/document'>
												<img src="css/assets/icons/catalyst-icon-svg/DOC.svg" >
											<cfelseif get_assets.EMBEDCODE_URL contains 'docs.google.com/forms'>
												<img src="css/assets/icons/catalyst-icon-svg/RTF.svg" >
											<cfelseif get_assets.EMBEDCODE_URL contains 'docs.google.com/presentation'>
												<img src="css/assets/icons/catalyst-icon-svg/PPT.svg" >
											<cfelseif get_assets.EMBEDCODE_URL contains 'iframe'>
												#get_assets.EMBEDCODE_URL#
											<cfelseif get_assets.EMBEDCODE_URL contains 'www.youtube.com' or get_assets.EMBEDCODE_URL contains 'youtu.be'>
												<cfif get_assets.EMBEDCODE_URL contains 'youtu.be'>
													<cfset str = listlast(get_assets.EMBEDCODE_URL, '/')>
												<cfelse>
													<cfset str = listfirst(listrest(get_assets.EMBEDCODE_URL, '='),'&')>
												</cfif>
												<iframe width="100%" height="100%" src="https://www.youtube.com/embed/#str#"  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen ></iframe>    
											<cfelse>
												<img src="css/assets/icons/catalyst-icon-svg/UNKOWN.svg" >
											</cfif>
											
										<cfelse>
											<cfif icon>
												<img src="#imagePath#">
											<cfelse>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif" or ext eq "svg">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
												<img src="#imagePath#">
											</a>
											</cfif>
										</cfif>	
									</div>
									<div class="archive_list_item_text">
										<div class="archive_list_item_text_top">
											<a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#">
												#asset_name#
											</a>
										</div>
										<div class="archive_list_item_text_bottom">
											<ul>
												<li class="date">
													<i class="wrk-uF0016"></i>#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
												</li>
												<li class="filesize">
													<i class="wrk-uF0138"></i><cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'asset.tv'>#wrk_round(asset_file_size/0.9765625,2)# MB<cfelse>#asset_file_size# KB</cfif>
												</li>
												<li class="user">
													<cfif len(record_emp)>
														<i class="wrk-uF0092"></i>
														#get_emp.employee_name[listfind(get_emp_list_2,record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,record_emp,',')]#<br>
													<cfelseif len(record_pub)>
														<i class="wrk-uF0092"></i>
														#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#
													<cfelseif len(record_par)>
														<i class="wrk-uF0092"></i>
														#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#
													<cfelse>
														<i class="wrk-uF0092"></i><br>
													</cfif>
												</li>
												<cfif filetype eq "video">
													<!---#my_video_file_path#--->
													<li>
														<a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#','video');">
															<i class="catalyst-cloud-download"></i>
														
														</a>
													</li>
												<cfelseif isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL)>
												
													<li id="#asset_id#_link">
														<cfif get_assets.EMBEDCODE_URL contains 'iframe'>
															<span class="hide" id="#asset_id#">#get_assets.EMBEDCODE_URL#</span>
															<script>
																var link=$('###asset_id# iframe').attr('src');
																$('###asset_id#_link').attr('href',link);
																var btn = $('<a>');
																btn.attr({
																	"href":link,
																	"target":"_blank"
																});
																var icon = "<i class='catalyst-eye'></i>";
																btn.append(icon);
                    											$('###asset_id#_link').append(btn);
															</script>
														<cfelse>
															<a href="#get_assets.EMBEDCODE_URL#" target="_blank">
																<i class="catalyst-eye"></i> 
															</a>
														</cfif>
													</li>
												<cfelse>
													<li>
														<cfif not isDefined("attributes.asset_archive")>
															<cfif assetcat_id gte 0>
																<cfset file_add_ = "asset/">
															<cfelse>
																<cfset file_add_ = "">
															</cfif>
															<cfif asset_file_server_id eq fusebox.server_machine>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');return false;"><i class="catalyst-cloud-download"  title="#getLang('asset',6)#"></i></a>
															<cfelse>
																<cf_get_server_file output_file="#url_##asset_file_name#" output_server="#asset_file_server_id#" output_type="2" icon="catalyst-eye" image_link="3">
															</cfif>
														</cfif>
													</li>	
												</cfif>
											</ul>
										</div>
									</div>
								</div>
							</div>
						
						
					</cfoutput>
				</cfif>	
			
		</div>
	</div>
</div>

<div id="type-list">
<table class="intranet_table" id="assetList">
	<thead>
		<tr>
			<th width="30"><cf_get_lang_main no='1165.Sıra'></th>
			<th>
				<a href="javascript://"><i class="catalyst-cloud-download"></i></a>
			</th>
			<th><cf_get_lang_main no='468.Belge No'></th>
			<th><cf_get_lang_main no='1655.Varlık'></th>
				<cfif isDefined("project_multi_id") and len(project_multi_id) or isdefined("project_id") and len(project_id)>
				<cfset colspan = colspan+2>
			<th><cf_get_lang_main no='4.Proje'> No.</th>
			<th><cf_get_lang no='3.Proje Adı'></th>
				</cfif>   
				<cfif isdefined("product_code") and len(product_code)>
				<cfset ++colspan>
			<th><cf_get_lang_main no='106.Stok kodu'></th>
			<th><cf_get_lang_main no='809.Ürün adı'></th>
				</cfif>        
			<th><cf_get_lang_main no='74.Kategori'></th>
			<th><cf_get_lang_main no='655.Döküman Tipi'></th>
			<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
			<th><cf_get_lang dictionary_id='678.Revizyon Tarihi'></th>
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				<cfset ++colspan>
				<th><cf_get_lang_main no='70.Aşama'></th>
			</cfif>
			<th><cf_get_lang_main no='1182.Format'></th>
			<th><cf_get_lang_main no='487.Kaydeden'></th>
			<th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
			<th width="30"><i class="fa fa-cube"></i></th>
		</tr>
	</thead>
	
	<tbody>
		<cfif get_assets.recordcount>
			<cfoutput query="get_assets">
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

				<cfset file_path = '#path##asset_file_name#'>
				<cfset rm = '#chr(13)#'>
				<cfset desc = ReplaceList(description,rm,'')>
				<cfset rm = '#chr(10)#'>
				<cfset desc = ReplaceList(desc,rm,'')>
				<cfif desc is ''><cfset desc = 'image'></cfif>	
				<cfset ext=lcase(listlast(asset_file_name, '.')) />

				<cfset infoFileType(file_path,ext)>

				<tr>
					<td>#currentrow#</td>   
					<td>
						<cfif not isDefined("attributes.asset_archive")>
							<cfif assetcat_id gte 0>
								<cfset file_add_ = "asset/">
							<cfelse>
								<cfset file_add_ = "">
							</cfif>
							<cfif asset_file_server_id eq fusebox.server_machine>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');return false;"><i class="catalyst-cloud-download"  title="#getLang('asset',6)#"></i></a>
							<cfelse>
								<cf_get_server_file output_file="#url_##asset_file_name#" output_server="#asset_file_server_id#" output_type="2" icon="catalyst-eye" image_link="3">
							</cfif>
						</cfif>
					</td>
					<cfif live eq 1>
						<td><font color="CC0000"><b>(G) #asset_no# <cfif revision_no neq 0>- #revision_no#</cfif></b></font></td>
					<cfelse>
						<td>#asset_no# <cfif revision_no neq 0>- #revision_no#</cfif></td>
					</cfif>
					<td title="Orjinal Dosya Adı : #asset_file_real_name#">
					<cfset ext=lcase(listlast(asset_file_name, '.')) />
					<cfif filetype eq "video">
						<cfif len(asset_file_path_name)>
							<cfset my_video_file_path = #asset_file_path_name#>
						<cfelse>
							<cfset my_video_file_path = '/documents/#file_add_##assetcat_path#/#asset_file_name#'>
						</cfif>
						<!---#my_video_file_path#--->
						<a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#','video');">#asset_name#</a>
					
					<cfelseif listfind(mediaplayer_extensions, "."&ext)>
						<a href="#url_##asset_file_name#">#asset_name#</a>
					<cfelse>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">#asset_name#</a>
					</cfif>
					</td>
					<cfif isDefined("project_multi_id") and len(project_multi_id) or isdefined("project_id") and len(project_id)>
                        <td>
                            <cfif isDefined("project_multi_id") and len(project_multi_id)>
                                <cfloop list="#mid(project_multi_id,2,len(project_multi_id)-2)#" index="k">
                                <a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#k#');">#get_project_name.project_number[listfind(project_list,k,',')]#</a><br />
                                </cfloop>
                            <cfelseif isdefined("project_id") and len(project_id)>
                                <a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#project_id#');">#get_project_name.project_number[listfind(project_list,project_id,',')]#</a>
                            </cfif>
                        </td>
                        <td>
                            <cfif isDefined("project_multi_id") and len(project_multi_id)>
                                <cfloop list="#mid(project_multi_id,2,len(project_multi_id)-2)#" index="k">
                                <a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#k#');">#get_project_name.project_head[listfind(project_list,k,',')]#</a><br />
                                </cfloop>
                            <cfelseif  isdefined("project_id") and len(project_id)>
                                <a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#project_id#');">#get_project_name.project_head[listfind(project_list,project_id,',')]#</a>
                            </cfif>
                        </td>
                    </cfif>
                    <cfif isdefined("product_code") and len(product_code)>
                        <td>#product_code#</td>
                        <td>#product_name#</td>
                    </cfif>
					<td>#assetcat#</td>
					<td>
						<cfif len(property_list)>#get_content_property.name[listfind(property_list,property_id,',')]#</cfif>
					</td>
					<td><cfif len(validity_date)>#dateformat(validity_date,dateformat_style)#</cfif></td>
					<td><cfif len(revision_date)>#dateformat(revision_date,dateformat_style)#</cfif></td>
					<cfif FindNoCase(".",asset_file_name)>
						<cfset last_3 = '.' & listLast(asset_file_name, '.') />
					<cfelse>
						<cfset last_3 = "">
					</cfif>
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
						<td>#stage#</td>
					</cfif>
					<td>#last_3# (#asset_file_size# kb.)</td>
					<td>			  
						<cfif len(record_emp)>
							<a href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list_2,record_emp,',')]#'});">#get_emp.employee_name[listfind(get_emp_list_2,record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,record_emp,',')]#</a>
						<cfelseif len(record_pub)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list_2,record_pub,',')]#','medium')">#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#</a>
						<cfelseif len(record_par)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list_2,record_par,',')]#','medium')">#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#</a>
						</cfif>
					</td>
					<td>&nbsp;#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
					<cfif (not listfindnocase(denied_pages,'asset.form_upd_asset') or session.ep.userid eq update_emp) and (attributes.fuseaction does not contain 'popup')>				    		    
						<!-- sil -->
						<td class="header_icn_none">
							<a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#" title="<cf_get_lang_main no='52.Güncelle'>"><i class="fa fa-cube"></i></a>
						</td>
						<!-- sil -->
					<cfelseif attributes.fuseaction does not contain 'popup'>
						#attributes.fuseaction#<td align="center" width="20">&nbsp;</td>
					</cfif>
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif> </td>
			</tr>
		</cfif>
	</tbody>  
</table>	
</div>

<div class="ui-row" id="type-paging">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<div class="loading-area" id="loading-area">
			<div class="showMoreButton">
				<cfoutput>#getLang('assetcare',513)#</cfoutput>
			</div>
		</div>
	</div>
</div>

<div id="type-folder">
	<cfif not len(attributes.bottomCat)>
		<cfif GET_ASSET_CAT.recordcount>
				<div class="flex-col">
					<div class="ui-row">
						<cfoutput query = "GET_ASSET_CAT">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12"> 
								<div id="cat_#ASSETCAT_ID#" class="folder_item">
									<cfset get_asset_cat_file = Assetcfc.get_asset_cat_file( assetcat_id: ASSETCAT_ID ) />  
									<div class="folder_item_text">
										<a href="javascript://" onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"><i class="wrk-uF0144"></i> #Left(ASSETCAT,20)#</a>
									</div>
									<div class="folder_item_size">
										<ul>
											<li>
												<a href="javascript://">#get_asset_cat_file.ASSET_NO_COUNT#/<cfif len(get_asset_cat_file.SUM_FILE_SIZE)>#get_asset_cat_file.SUM_FILE_SIZE#<cfelse>0</cfif> KB</a>
											</li>
											<!--- <li>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');"><i class="wrk-uF0158"></i></a>
											</li>
											<li>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');"><i class="wrk-uF0221"></i></a>
											</li> --->
										</ul>
									</div>
								</div>
							</div>
						</cfoutput>
					</div>
				</div>
		<cfelse>
			<cf_get_lang dictionary_id = "57484.Kayıt Yok">
		</cfif>
	</cfif>
</div>

