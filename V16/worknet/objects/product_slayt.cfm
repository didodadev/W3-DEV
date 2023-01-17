<cfset getProductSlayt = createObject("component","V16.worknet.query.worknet_product").getProduct(
		is_online:1,
		is_catalog:0,
		product_status:1,
		is_homepage:1,
		recordCount:80,
		sortfield:'COMPANY_SORT ASC,SORT ASC,WP.RECORD_DATE'
) />

<cfset company_id_list = listdeleteduplicates(ValueList(getProductSlayt.company_id,','))>
<div class="band" id="companyProductBand">
	<div class="bandTitle"><cf_get_lang no='230.Üye Firma Ürünleri'></div>
	<div class="leftArrowContainer" style="margin-top: 65px;">
		<a href="#" id="btnPLeft"><img src="../documents/templates/worknet/tasarim/solok.jpg" data-key="p" /></a>
	</div>
	<div class="bandContext bandContetxtProduct">
		<div id="bandContextContainer">
			<cfset index_number = 0>
			 <cfloop list="#company_id_list#" index="company_id">
			 	<cfset index_number = index_number+1>
				<cfquery name="getProductSlayt_" dbtype="query" maxrows="4">
					SELECT * FROM getProductSlayt WHERE COMPANY_ID = #company_id#
				</cfquery>
				<div class="containerItem">
					<div class="companyProduct">
						<cfoutput>
							<div class="companyLogo" style="width:180px;">
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" title="#getProductSlayt_.fullname#">
								<cfif len(getProductSlayt_.ASSET_FILE_NAME1)>
									<cftry>
										<cfimage source="../../documents/member/#getProductSlayt_.ASSET_FILE_NAME1#" name="myImage">
										<cfset imgInfo=ImageInfo(myImage)>
										<cfif imgInfo.width/imgInfo.height lt 160/120>
											<img src="../documents/member/#getProductSlayt_.ASSET_FILE_NAME1#" height="120" />
										<cfelse>
											<img src="../documents/member/#getProductSlayt_.ASSET_FILE_NAME1#" width="160" />
										</cfif>
										<cfcatch type="Any">
											<img src="/images/no_photo.gif" class="productImagea" height="90">
										</cfcatch>
									</cftry>
								</cfif>
								<div class="companyName">
									#getProductSlayt_.fullname#
								</div>
								</a>
							</div>
						</cfoutput>
					</div>
					<div class="split splitCompany"></div>
					<ul>
						<cfoutput query="getProductSlayt_">
							<li>
								<span class="productTitle" style="top:0px;"><cfif len(brand_name)>#brand_name#<cfelse>&nbsp;</cfif></span>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#" title="#product_name#" class="productImagea">
									<cfif len(path)>
										<cftry>
											<cfif FileExists(ExpandPath('/documents/thumbnails/#path#')) eq 0>
												<cfset getThumbnail = createObject("component","worknet.objects.worknet_objects").createThumbnailImage(
													maxHeight:110,
													maxWidth:135,
													folder:'product',
													path:getProductSlayt_.path
												) />
												
												<cfif getThumbnail eq false>
													<img src="../../documents/product/#path#" class="productImagea" />
												<cfelse>
													<img src="../../documents/thumbnails/#path#"  class="productImagea" />
												</cfif>
											<cfelse>
												<img src="../../documents/thumbnails/#path#"  class="productImagea" />
											</cfif>
											<cfcatch type="Any">
												<img src="/images/no_photo.gif" class="productImagea" height="110">
											</cfcatch>
										</cftry>
									<cfelse>
										<img src="/images/no_photo.gif" class="productImagea" height="110">
									</cfif>
								</a>
								<span class="splitProduct"></span>
								<span class="productTitle">
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#" title="#product_name#">
										#left(product_name,30)#<cfif len(product_name) gt 30>...</cfif>
									</a>
								</span>
							</li>
						</cfoutput>
					</ul>
				</div>
				<cfif index_number mod 2 eq 0>
					<div class="containerItem">
						<cfif session_base.language is 'tr'>
							<img src="../../documents/templates/worknet/tasarim/urunlerbanner_tr.png" style="margin-left:5px;"/>
						<cfelse>
							<img src="../../documents/templates/worknet/tasarim/urunlerbanner_eng.png" style="margin-left:5px;" />
						</cfif>
					</div>
				</cfif>
			</cfloop>
		</div>
	</div>
	<div class="rightArrowContainer" style="margin-top: 65px;">
		<a href="#" id="btnPRight"><img src="../documents/templates/worknet/tasarim/sagok.jpg" data-key="p" /></a>
	</div>
</div>
