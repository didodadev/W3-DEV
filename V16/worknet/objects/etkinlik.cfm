<cfset getFuar = createObject("component","worknet.objects.worknet_objects").getContents(content_chapter_id:attributes.contentChapterId2,recordCount:attributes.contentMaxrows,isHomePage:1) />
<cfif len(attributes.contentChapterId2)>
	<cfset getContenChapter= createObject("component","worknet.objects.worknet_objects").getContentChapter(chapter_id:attributes.contentChapterId2)>
	<cfset headName2 = getContenChapter.chapter>
<cfelse>
	<cfset headName2 = ''>
</cfif>
<div class="kutular_4">
	<div class="kutular_41">
		<ul>
			<li><a class="kutular_41a aktif" href="javascript:void(0);" onclick="tab('etkinlik')" id="etkinlik_tab"><cfoutput>#headName2#</cfoutput></a></li>
			<li><a class="kutular_41a" href="javascript:void(0);" onclick="tab('poll')" id="poll_tab"><cf_get_lang_main no='1250.Anket'></a></li>
		</ul>
	</div>
	<div class="kutular_42 dcor">
		<div class="section">
			<div class="scroll-pane">
				<div class="kutular_421" id="etkinlik">
					<cfif getFuar.recordcount>
						<cfoutput query="getFuar">
							<div class="kutular_4211">
								<div class="kutular_42111">
									<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:0) />
									<cfif getContentImage.recordcount>
										<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="60" image_height="60" output_server="#getContentImage.image_server_id#" output_type="0"></a>
									</cfif>
								</div>
								<div class="kutular_42112">
									<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#">#left(cont_head,50)#</a>
									<span>#left(cont_summary,75)#</span>
								</div>
							</div>
						</cfoutput>
					<cfelse>
						<div class="kutular_4211">
							<div class="kutular_42112">
								<cf_get_lang_main no="72.Kayıt Yok">!
							</div>
						</div>
					</cfif>
				</div>
				<div class="kutular_421 gizle" id="poll">
				<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
					<cfinclude template="../../objects2/survey/poll.cfm">
				<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
			</div>
			</div>
		</div>
	</div>
</div>
