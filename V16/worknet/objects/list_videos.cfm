<cfif session_base.language is 'tr'>
	<cfset attributes.asset_catid = 0>
<cfelseif session_base.language is 'eng'>
	<cfset attributes.asset_catid = 1>
<cfelseif session_base.language is 'spa'>
	<cfset attributes.asset_catid = 2>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_catid" default="#attributes.asset_catid#">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='21'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset getVideos = createObject("component","worknet.objects.worknet_objects").getVideos(
	keyword:attributes.keyword
	,asset_catid:attributes.asset_catid
) />

<cfparam name="attributes.totalrecords" default="#getVideos.recordcount#">

<div class="haber_liste">
	<div class="haber_liste_1">
		<cfform name="search" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_videos" method="post">
			<div class="haber_liste_11"><h1><cf_get_lang no='186.Videolar'></h1></div>
			<div class="haber_liste_12" style="width:32px;">
				<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
			</div>
			<div class="haber_liste_12" style="width:210px;">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:200px; border:none;padding-top:5px;">
			</div>
		</cfform>
	</div>
	<cfif getVideos.recordcount>
	<div class="video">
		<cfoutput query="getVideos" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
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
			<div class="video_3">
				<div class="video_31">
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
						<div style="position:absolute;background:url(../../documents/templates/worknet/tasarim/play.png); width:25px; height:25px; margin:60px; margin-top:35px;"></div>
					</a>
				</div>
				<div class="video_32">
					<h4><a href="#request.self#?fuseaction=worknet.detail_video&video_id=#asset_id#">#left(asset_name,22)#</a></h4>
					#left(asset_detail,40)#<cfif len(asset_detail) gt 40>...</cfif>
					<samp>#dateformat(record_date,dateformat_style)#</samp>
					<a class="izle" href="#request.self#?fuseaction=worknet.detail_video&video_id=#asset_id#"><font color="FFFFFF"><cf_get_lang no='187.İzle'></font></a>
				</div>
			</div>
		</cfoutput>
	</div>
	<cfelse>
		<div class="haber_liste_21">
			<div class="haber_liste_212">
				<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
			</div>
		</div>
	</cfif>
	
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset urlstr="&keyword=#attributes.keyword#">
		
					  <cf_paging page="#attributes.page#" 
						page_type="1"
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#attributes.fuseaction##urlstr#">
					
		</cfif>
	</div>
</div>
