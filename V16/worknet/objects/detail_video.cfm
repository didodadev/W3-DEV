<script type="text/javascript" charset="utf-8" id="sourcecode">
	$(function(){
		$('.scroll-pane3').jScrollPane();
	});
</script>
<cfif isdefined('attributes.video_id') and len(attributes.video_id)>
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang no='183.Video'></h1></div>
		</div>
		<div class="video">
			<div class="video_1">
				<div class="video_11">
					<cfset attributes.playerWidth = 670>
					<cfset attributes.playerHeight = 415>
					<cfinclude template="../../objects2/asset/flvplayer.cfm">
				</div>
				<cfoutput>
				<div class="video_12">
					<div class="video_122"></div>
					<div class="video_121">
						<h2>#get_video.asset_name#</h2>
						<span>#get_video.asset_description#</span>
					</div>
					<div class="video_121">
						<samp><cf_get_lang_main no='74.Kategori'>:</samp>
						<a href="#request.self#?fuseaction=worknet.list_videos&asset_catid=#get_video.assetcat_id#">#get_video.assetcat#</a>
						<samp>|&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='71.Ekleme'>:</samp>
						<small>#dateformat(get_video.record_date,dateformat_style)#</small>  
						<samp>|&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='185.İzlenme'>:</samp>
						<small>#get_video.download_count#</small>
					</div>
				</div>
				</cfoutput>
			</div>
			<!---<cfif session_base.language is 'tr'>
				<cfset asset_catid = 0>
			<cfelseif session_base.language is 'eng'>
				<cfset asset_catid = 1>
			<cfelseif session_base.language is 'spa'>
				<cfset asset_catid = 2>
			</cfif>--->
			<cfset getVideos = createObject("component","worknet.objects.worknet_objects").getVideos(recordCount:20,notassetid=attributes.video_id<!---,asset_catid:asset_catid--->) />
			<div class="video_2">
				<div class="video_21">
					<span><img src="documents/templates/worknet/tasarim/kutu_icon_9.png" width="31" height="31" alt="İcon" /></span>
					<h2><cf_get_lang no='184.Diğer Videolar'></h2>
				</div>
				<div class="video_22 dcor">
					<div class="section3">
					<div class="scroll-pane3">
						<div class="video_22" id="video">
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
								<div class="videod_1">
									<div class="videod_11">
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
											<div style="position:absolute;background:url(../../documents/templates/worknet/tasarim/play.png); width:25px; height:25px; margin:50px; margin-top:-60px;"></div>
										</a>
									</div>
									<div class="videod_12">
										<a href="#request.self#?fuseaction=worknet.detail_video&video_id=#asset_id#" title="#asset_name#">#left(asset_name,30)#</a>
									</div>
								</div>
							</cfoutput>
						</div>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<cfelse>
	<cfinclude template="hata.cfm">
</cfif>
