<cfif session_base.language is 'tr'>
	<cfset attributes.asset_catid = 0>
<cfelseif session_base.language is 'eng'>
	<cfset attributes.asset_catid = 1>
<cfelseif session_base.language is 'spa'>
	<cfset attributes.asset_catid = 2>
</cfif>
<cfset getVideos = createObject("component","worknet.objects.worknet_objects").getVideos(recordCount:attributes.contentMaxrows,asset_catid:attributes.asset_catid) />
<cfset getLiveTv = createObject("component","worknet.objects.worknet_objects").getLiveTv() />

<cfset getOne = createObject("component","worknet.objects.worknet_objects").getContents(content_chapter_id:attributes.contentChapterId1,recordCount:attributes.contentMaxrows,isHomePage:1) />
<!---<cfset getTwo = createObject("component","worknet.objects.worknet_objects").getContents(content_cat_id:attributes.contentCatId1,recordCount:attributes.contentMaxrows,isHomePage:1) />--->
<cfset getThree = createObject("component","worknet.objects.worknet_objects").getContents(content_cat_id:attributes.contentCatId2,recordCount:attributes.contentMaxrows,isHomePage:1) />
<cfset getContentDetail = createObject("component","worknet.objects.worknet_objects").getContents(content_cat_id:attributes.contentCatId3,recordCount:1,isHomePage:1) />

<cfif len(attributes.contentCatId1)>
	<cfset getContenCat = createObject("component","worknet.objects.worknet_objects").getContentCat(cat_id:attributes.contentCatId1)>
	<cfset headName = getContenCat.CONTENTCAT>
<cfelse>
	<cfset headName = ''>
</cfif>
<!---<cfif len(attributes.contentChapterId1)>
	<cfset getContenChapter= createObject("component","worknet.objects.worknet_objects").getContentChapter(chapter_id:attributes.contentChapterId1)>
	<cfset headName2 = getContenChapter.chapter>
<cfelse>
	<cfset headName2 = ''>
</cfif>--->

<cfif len(attributes.contentCatId2)>
	<cfset getContenCat2 = createObject("component","worknet.objects.worknet_objects").getContentCat(cat_id:attributes.contentCatId2)>
	<cfset headName3 = getContenCat2.CONTENTCAT>
<cfelse>
	<cfset headName3 = ''>
</cfif>

<div class="proma">
	<!--- videolar --->
	<div class="proma_3 dcor">
		<!---<a href="http://188.138.89.12/ihkib.asp" target="_blank">--->
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_live_internettv&playerWidth=565&playerHeight=487','userTv');">
			<div <cfif session_base.language is 'tr'>class="proma_31"<cfelse>class="proma_31_eng"</cfif>><cfif getLiveTv.recordcount><div class="canli"></div></cfif></div>
		</a>
		<div class="proma_32">
			<div class="section2">
			<div class="scroll-pane2">
				<cfoutput query="getVideos">
					<cfset path = "#upload_folder#asset#dir_seperator##dir_seperator#">
					<cfif listlen(asset_file_name,'.') eq 2>			
					   <cfset extention = ucase(listlast(asset_file_name,'.'))>
					   <cfset dosya_ad = listfirst(asset_file_name,'.')>
					<cfelse>
					   <cfset extention = 'incorrect'>	
					   <cfset dosya_ad = asset_file_name>	
					</cfif>
					<cfif extention is 'FLV'>
						<cfset image_file = "thumbnails/#dosya_ad#.jpg">
					</cfif>
					<div class="proma_321">
						<div class="proma_3211" style="width:150px; text-align:center;">
							<cfif assetcat_id gte 0>
								<cfset folder="asset/#assetcat_path#">
							<cfelse>
								<cfset folder="#assetcat_path#">
							</cfif>
							<a href="#request.self#?fuseaction=worknet.detail_video&video_id=#asset_id#" title="#asset_name#">
								<cfif FileExists(ExpandPath('/documents/#image_file#'))>
									<img src="/documents/#image_file#" width="139" height="93" />
								<cfelse>
									<cftry>
										<cfexecute name="#expandPath('/COM_MX/tools/ffmpeg.exe')#" arguments="-i ""#expandPath('/documents/#folder#/#dosya_ad#')#.flv"" -deinterlace -an -ss 3 -t 00:00:15 -r 1 -y -s 139x93 -vcodec mjpeg -f mjpeg ""#expandPath('/documents')#\#replaceList(image_file, '/', '\')#""" variable="output" timeout="30"/>
										<cfcatch type="any"></cfcatch>
									</cftry>
									<img src="/documents/#image_file#" width="139" height="93" />
								</cfif>
								<div style="position:absolute;background:url(../../documents/templates/worknet/tasarim/play.png); width:25px; height:25px; margin:57px; margin-top:-60px;"></div>
							</a>
						</div>
						<div class="proma_3212"><a href="#request.self#?fuseaction=worknet.detail_video&video_id=#asset_id#" title="#ASSET_NAME#">#left(ASSET_NAME,20)#<cfif len(ASSET_NAME) gt 20>...</cfif></a></div>
					</div>
				</cfoutput>
			</div>
			</div>
		</div>
		<div class="proma_33"><a href="list_videos"><cf_get_lang no='174.Tümünü Gör'></a></div>
	</div>
	<div class="proma_1">
		<ul>
			<cfif getContentDetail.recordcount>
				<li><a class="proma_1a aktif" href="javascript:void(0);" onclick="tab2('important')" id="important_tab"><cfoutput>#getContentDetail.cont_head#</cfoutput></a></li>
			</cfif>
			<!---<li><a class="proma_1a <cfif getContentDetail.recordcount eq 0>aktif</cfif>" href="javascript:void(0);" onclick="tab2('haber')" id="haber_tab"><cfoutput>#headName2#</cfoutput></a></li>--->
			<li><a class="proma_1a aktif" href="javascript:void(0);" onclick="tab2('duyuru')" id="duyuru_tab"><cfoutput>#headName#</cfoutput></a></li>
			<cfif getThree.recordcount and len(headName3)>
				<li><a class="proma_1a" href="javascript:void(0);" onclick="tab2('three')" id="three_tab"><cfoutput>#headName3#</cfoutput></a></li>
			</cfif>
		</ul>
	</div>
	<div class="proma_2">
		<div class="proma_21">
			<!--- önemli duyuru sekmesi --->
			<cfif getContentDetail.recordcount>
				<div class="proma_211" id="important">	
					<ul id="important_" class="proma_iul">
						<li>
							<div class="proma_21111">
								<cfoutput>#getContentDetail.cont_body#</cfoutput>
							</div>
						</li>
					</ul>
				</div>
			</cfif>
			<!--- 1. sekme --->
			<div class="proma_211 <cfif getContentDetail.recordcount>gizle</cfif>" id="haber">	
				<ul id="haber_" class="proma_iul">
				<cfoutput query="getOne">
					<li>
						<div class="proma_21111">
							<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:2) />
							<cfif getContentImage.recordcount>
								<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="425" image_height="235" output_server="#getContentImage.image_server_id#" output_type="0"></a>
							</cfif>
						</div>
						<div class="proma_21112">
							<div class="proma_211121"><a href="javascript:void(0);" onclick="promae()" ><img src="../documents/templates/worknet/tasarim/proma_211121_ap.png" width="30" height="51" /></a></div>
							<div class="proma_211122"><a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><strong>#left(cont_head,50)#</strong><br />#left(cont_summary,50)#...</a></div>
							<div class="proma_211123"><a href="javascript:void(0);" onclick="promaa()" ><img src="../documents/templates/worknet/tasarim/proma_211123_ap.png" width="30" height="51" /></a></div>
						</div>
					</li>
				</cfoutput>
				</ul>
				<ul class="proma_sul" id="haber__">
					<cfoutput query="getOne">
						<li class="haber__ aktif" id="haber__#currentrow#">#currentrow#</li>
					</cfoutput>
                </ul>				
			</div>
			<!--- 2. sekme --->
			<!---<div class="proma_211 gizle" id="duyuru">	
                <ul id="duyuru_" class="proma_iul">
				<cfoutput query="getTwo">
					<li>
						<div class="proma_21111">
							<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:2) />
							<cfif getContentImage.recordcount>
								<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="425" image_height="235" output_server="#getContentImage.image_server_id#" output_type="0"></a>
							</cfif>
						</div>
						<div class="proma_21112">
							<div class="proma_211121"><a href="javascript:void(0);" onclick="promaae()" ><img src="../documents/templates/worknet/tasarim/proma_211121_ap.png" width="30" height="51" /></a></div>
							<div class="proma_211122"><a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><strong>#left(cont_head,50)#</strong><br />#left(cont_summary,50)#...</a></div>
							<div class="proma_211123"><a href="javascript:void(0);" onclick="promaaa()" ><img src="../documents/templates/worknet/tasarim/proma_211123_ap.png" width="30" height="51" /></a></div>
						</div>
					</li>
				</cfoutput>
				</ul>
				<ul class="proma_sul" id="duyuru__">
					<cfoutput query="getTwo">
						<li class="duyuru__ aktif" id="duyuru__#currentrow#">#currentrow#</li>
					</cfoutput>
                </ul>
			</div>--->
			<!--- 3. sekme --->
			<cfif getThree.recordcount>
				<div class="proma_211 gizle" id="three">	
					<ul id="three_" class="proma_iul">
					<cfoutput query="getThree">
						<li>
							<div class="proma_21111">
								<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:2) />
								<cfif getContentImage.recordcount>
									<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="425" image_height="235" output_server="#getContentImage.image_server_id#" output_type="0"></a>
								</cfif>
							</div>
							<div class="proma_21112">
								<div class="proma_211121"><a href="javascript:void(0);" onclick="promaaae()" ><img src="../documents/templates/worknet/tasarim/proma_211121_ap.png" width="30" height="51" /></a></div>
								<div class="proma_211122"><a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><strong>#left(cont_head,50)#</strong><br />#left(cont_summary,50)#...</a></div>
								<div class="proma_211123"><a href="javascript:void(0);" onclick="promaaaa()" ><img src="../documents/templates/worknet/tasarim/proma_211123_ap.png" width="30" height="51" /></a></div>
							</div>
						</li>
					</cfoutput>
					</ul>
					<ul class="proma_sul" id="three__">
						<cfoutput query="getThree">
							<li class="three__ aktif" id="three__#currentrow#">#currentrow#</li>
						</cfoutput>
					</ul>
				</div>
			</cfif>
		</div>
	</div>
</div>
