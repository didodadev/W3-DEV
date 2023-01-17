<!--[if IE 7]> <link rel="stylesheet" type="text/css" href="/documents/templates/worknet/css/UyeFirmlariIE7.css" /> <![endif]-->
<cfset getMemberLogo = createObject("component","worknet.objects.worknet_objects").getMemberLogo(
		recordCount:50,
		sortfield:'SORT ASC,UPDATE_DATE',
		stage_id_list:attributes.stage_id_list
) />
<div class="band" id="memberCompany" style="margin-top:10px; margin-bottom:10px; height:145px;">
	<div class="bandTitle"><cf_get_lang no='219.Üye Firmalarımız'></div>
	<div class="leftArrowContainer">
		<a href="#" id="btnFSol"><img src="../documents/templates/worknet/tasarim/solok.jpg" data-key="p" /></a>
	</div>
	<div class="bandContext companyBandContext">
		<div id="companyBandContextContainer">
			<cfset index_no = 0>
 			<cfloop from="1" to="#Ceiling(getMemberLogo.recordcount/6)#" index="i">
				<cfset index_no = index_no+1>
				<cfset startrow=((index_no-1)*6)+1>
				<div class="bandContextItem">
					<ul>
						<cfoutput query="getMemberLogo" maxrows="6" startrow="#startrow#">
							<li style="width:140px;">
								<a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#getMemberLogo.company_id#" title="#getMemberLogo.fullname#">
								<cfif FileExists(ExpandPath('/documents/member/#ASSET_FILE_NAME1#'))>
                                	<cfimage source="../../documents/member/#ASSET_FILE_NAME1#" name="imgInfo">
                                    
									<cftry>
										<cfif FileExists(ExpandPath('/documents/thumbnails/#ASSET_FILE_NAME1#')) eq 0>
											<cfset getThumbnail = createObject("component","worknet.objects.worknet_objects").createThumbnailImage(
													maxHeight:70,
													maxWidth:130,
													folder:'member',
													path:ASSET_FILE_NAME1
												) />
											<cfif getThumbnail eq false>
												<img src="../../documents/member/#ASSET_FILE_NAME1#" style="height:auto; width:auto;"/>
											<cfelse>
												<img src="../../documents/thumbnails/#ASSET_FILE_NAME1#" style="height:auto; width:auto;"/>
											</cfif>
										<cfelse>
											<img src="../../documents/thumbnails/#ASSET_FILE_NAME1#" style="height:auto; width:auto;"/>
										</cfif>
										<cfcatch type="Any">
											<img src="/images/no_photo.gif" class="productImagea" height="70">
										</cfcatch>
									</cftry>
								<cfelse>
									<img src="/images/no_photo.gif" class="productImagea" height="70">
								</cfif>
								</a>
								<span class="split"></span>
							</li>
						</cfoutput>
					</ul>
				</div>
			</cfloop>
		</div>
	</div>
	<div class="rightArrowContainer">
		<a href="#" id="btnFSag"><img src="../documents/templates/worknet/tasarim/sagok.jpg" data-key="m" /></a>
	</div>
</div>
