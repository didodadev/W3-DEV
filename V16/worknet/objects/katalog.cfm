<cfset getCatalog = createObject("component","V16.worknet.query.worknet_product").getProduct(
		is_online:1,
		is_catalog:1,
		product_status:1,
		is_homepage:1,
		recordCount:20,
		sortfield:'SORT ASC,WP.RECORD_DATE'
) />
<div class="katalog_uyeol">
	<div class="katalog">
		<div class="katalog_1"><h3><cf_get_lang no='154.KATALOG'></h3></div>
		<div class="katalog_2">
			<div class="katalog_21"><cfif getCatalog.recordcount><a href="javascript:void(0);" onclick="kataloge()"></a></cfif></div>
				<div class="katalog_22" style="top:1px;">
					<cfif getCatalog.recordcount>
						<ul id="dkatalogul">
							<cfoutput query="getCatalog">
							<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(action_id:product_id) />
							<li>
								<div class="katalog_2211">
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_catalog&pid=#product_id#" title="#product_name#" target="_blank">
									<cfif len(path)>
										<cfif FileExists(ExpandPath('/documents/thumbnails/#path#')) eq 0>
											<cfset getThumbnail = createObject("component","worknet.objects.worknet_objects").createThumbnailImage(
												maxHeight:142,
												maxWidth:240,
												folder:'product',
												path:path
											) />
											<cfif getThumbnail eq false>
												<img src="../../documents/product/#path#" class="productImagea" />
											<cfelse>
												<img src="../../documents/thumbnails/#path#"  class="productImagea" />
											</cfif>
										<cfelse>
											<img src="../../documents/thumbnails/#path#"  class="productImagea" />
										</cfif>
									<cfelse>
										<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>">
									</cfif>
									</a>
								</div>
								<div class="katalog_2211">
									<span>
									<cfif isdefined('session.pp')>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_catalog&pid=#product_id#" title="#product_name#" target="_blank">
											#left(product_name,40)#
										</a>
									<cfelse>
										<a href="list_catalog" title="#product_name#">#left(product_name,40)#</a>
									</cfif>
									</span>
								</div>
							</li>
							<cfif currentrow mod 2 eq 0>
								<li>
									<cfif session_base.language is 'tr'>
										<img src="../../documents/templates/worknet/tasarim/katalog.png" width="240" height="204" />
									<cfelseif session_base.language is 'eng'>
										<img src="../../documents/templates/worknet/tasarim/katalog_eng.png" />
                                    <cfelse>
                                    	<img src="../../documents/templates/worknet/tasarim/katalog_spa.png" />
									</cfif>
								</li>
							</cfif>
						</cfoutput>
						</ul>
					<cfelse>
						<div class="katalog_221" id="katalog_1">
							<div class="katalog_2211">
								<b><cf_get_lang_main no='72.Kayit Bulunamadi'>!</b>
							</div>
						</div>
					</cfif>
				</div>
			<div class="katalog_23"><cfif getCatalog.recordcount><a href="javascript:void(0);" onclick="kataloga()"></a></cfif></div>
		</div>
		<div class="katalog_3"><a href="list_catalog"><cf_get_lang no='133.Tum Kataloglari Gor'>&nbsp;&nbsp;</a></div>
	</div>
	<cfif isdefined('session_base.userid') and len(attributes.userContentId)>
		<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.userContentId)#</cfoutput>
	<cfelseif len(attributes.notUserContentId)>
		<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.notUserContentId)#</cfoutput>
	</cfif>
</div>

