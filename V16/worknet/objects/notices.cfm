<cfset getNotices = createObject("component","worknet.objects.worknet_objects").getContents(content_cat_id:attributes.contentCatId2,recordCount:attributes.contentMaxrows,isHomePage:1) />
<cfif len(attributes.contentCatId2)>
	<cfset getContenCat2 = createObject("component","worknet.objects.worknet_objects").getContentCat(cat_id:attributes.contentCatId2)>
	<cfset headName = getContenCat2.CONTENTCAT>
<cfelse>
	<cfset headName = ''>
</cfif>
<div class="kutular_3">
	<div class="kutular_31"><h4><cfoutput>#headName#</cfoutput></h4></div>
	<div class="kutular_32 dcor">
		<div class="section4">
			<div class="scroll-pane4">
				<cfif getNotices.recordcount>
					<cfoutput query="getNotices">
						<div class="kutular_4211">
							<div class="kutular_42111">
								<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:0) />
								<cfif getContentImage.recordcount>
									<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="60" image_height="60" output_server="#getContentImage.image_server_id#" output_type="0"></a>
								</cfif>
							</div>
							<div class="kutular_42112">
								<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#" style="color:##80860f;">#left(cont_head,50)#</a>
								<span>#left(cont_summary,75)#</span>
							</div>
						</div>
					</cfoutput>
				<cfelse>
					<div class="kutular_4211">
						<div class="kutular_42112">
							<cf_get_lang_main no="72.Kayit Yok">!
						</div>
					</div>
				</cfif>
			</div>
		</div>
	</div>
</div>

