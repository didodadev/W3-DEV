<cfif isdefined('session.pp.userid')>
	<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(partner_id:session.pp.userid)>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
	<cfset getProduct = cmp.getProduct(product_id:attributes.pid)>
	
	<cfif getProduct.recordcount and getProduct.company_id eq session.pp.company_id>
		<cfoutput>
			<div class="haber_liste">
				<div class="haber_liste_1">
					<div class="haber_liste_11"><h1>#getProduct.product_name#</h1></div>
				</div>
				<div class="talep_detay">
					<div class="talep_detay_1">
						<div style="position:absolute; margin-top:140px;" id="showCategory"></div>
						<cfform name="upd_product_" id="upd_product_" method="post" action="#request.self#?fuseaction=worknet.emptypopup_upd_product">
						<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>" />
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getProduct.company_id#</cfoutput>">
						<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getProduct.partner_id#</cfoutput>">
						<input type="hidden" name="is_catalog" id="is_catalog" value="0" />
						<input type="hidden" name="type_" id="type_" value="1">
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1" style="width:598px;">
									<h2><cf_get_lang no='114.Ürün Bilgileri'></h2>
								</div>
								<div class="td_kutu_2">
									<table>	
										<cfif session.pp.userid eq getPartner.manager_partner_id>
											<tr height="25">
												<td><cf_get_lang_main no='344.Durum'></td>
												<td><div class="ftd_kutu_21">
														<input type="checkbox" name="product_status" id="product_status" <cfif getProduct.product_status eq 1>checked</cfif> class="kutu_ckb_1"  /> 
														<samp><cf_get_lang_main no='81.Aktif'></samp>
													</div>
												</td>
											</tr>
											<tr>
												<td><cf_get_lang_main no="1447.Süreç"></td>
												<td><cf_workcube_process is_upd='0' select_value='#getProduct.product_stage#' process_cat_width="150" is_detail='1'></td>
											</tr>
										<cfelse>
											<input type="hidden" name="product_status" id="product_status" value="<cfoutput>#getProduct.product_status#</cfoutput>"  />
											<div style="display:none;"><cf_workcube_process is_upd='0' select_value='#getProduct.product_stage#' is_detail='1'></div>
										</cfif>
										<tr height="25">
											<td width="120"><cf_get_lang_main no='74.Kategori'> *</td>
											<td><cfset hierarchy_ = "">
												<cfset new_name = "">
												<cfloop list="#getProduct.HIERARCHY#" delimiters="." index="hi">
													<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
													<cfset getCat = cmp.getMainProductCat(hierarchy:hierarchy_)>
													<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
												</cfloop>
												<input type="hidden" name="product_catid" id="product_catid" value="#getProduct.product_catid#" />
												<input type="text" name="product_cat" id="product_cat" style="width:400px;font-size:bold;" onclick="openProductCat();" value="#new_name#" readonly="" />
												<a href="javascript://" onClick="openProductCat();" style="position:absolute;">
													<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
												</a>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='809.Ürün Adı'> *</td>
											<td><input type="text" name="product_name" id="product_name" value="#getProduct.product_name#" maxlength="250" style="width:400px;"/></td>
										</tr>
										<tr height="25">
											<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
											<td><input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="#getProduct.product_keyword#" style="width:200px;"/></td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='1435.Marka'></td>
											<td><input type="text" name="product_brand" id="product_brand" value="#getProduct.brand_name#" maxlength="150" style="width:200px;"/></td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='1388.Ürün Kodu'></td>
											<td><input type="text" name="product_code" id="product_code" value="#getProduct.product_code#" maxlength="150" style="width:200px;"/></td>
										</tr>
										<tr height="25">
											<td valign="top"><cf_get_lang_main no='640.Özet'> *</td>
											<td><textarea 
													style="width:400px; height:75px;" 
													name="description" 
													id="description" 
													onChange="counter();return ismaxlength(this);"
													onkeydown="counter();return ismaxlength(this);" 
													onkeyup="counter();return ismaxlength(this);" 
													onBlur="return ismaxlength(this);" >#getProduct.product_description#</textarea>
													<input type="text" name="detailLen" id="detailLen" size="1"  style="width:25px;" value="250" readonly />
											</td>
										</tr>
										<tr>
											<td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
											<td>
												<textarea 
													style="width:500px; height:300px;" 
													name="product_detail" 
													id="product_detail" >#getProduct.product_detail#</textarea>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='487.Kaydeden'></td>
											<td><div class="ftd_kutu_21">
													<cfoutput><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getProduct.partner_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getProduct.partner_name# - 
													#dateformat(getProduct.record_date,dateformat_style)# #timeformat(date_add('h',session.pp.time_zone,getProduct.record_date),timeformat_style)#</cfoutput></a>
												</div>
											</td>
										</tr>
									</table>
								</div>
							</div>
							<div style="width:600px; text-align:right; margin-top:10px;">
								<cfsavecontent variable="message"><cf_get_lang_main no="52.Güncelle"></cfsavecontent>
								<input class="btn_1" type="button" onClick="kontrol()" value="<cfoutput>#message#</cfoutput>" />
							</div>
						</div>
						</cfform>
					</div>
					<div class="talep_detay_2">
						<div class="td_kutu">
							<cfset getProductImage = cmp.getProductImage(product_id:attributes.pid,image_type:1)>
							<table align="center">
								<tr>
									<td style="text-align:center;" align="center">
										<cfif len(getProductImage.path)>
											<cfimage source="../../documents/product/#getProductImage.path#" name="myImage">
											<cfset imgInfo=ImageInfo(myImage)>
                                            <cfif imgInfo.width/imgInfo.height lt 285/200>
                                                <cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0" image_height="200">
                                            <cfelse>
                                                <cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0" image_width="285">
                                            </cfif>
										<cfelse>
											<img src="/images/no_photo.gif">
										</cfif>
									</td>
								</tr>
							</table>
						</div>
						<div style="margin-top:10px;;">
							<cfsavecontent variable="text"><cf_get_lang_main no='1965.İmaj'></cfsavecontent>
							<div class="talep_detay_222">
								<ul>
									<li><a class="talep_detay_222a aktif">#text#</a></li>
									<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
										<a href="javascript://" data-width="300px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
											<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
										</a>
									</cfif>
								</ul>
							</div>
							<cf_box id="product_images" design_type="1" header_style="width:280px;" style="width:300px" title=" " closable="0" collapsable="0" refresh="0" box_page="#request.self#?fuseaction=worknet.emptypopup_list_product_images&pid=#attributes.pid#"
								add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.product_image&pid=#attributes.pid#&product_name=#getProduct.product_name#','body_product_images',0)" class="pod_box1">
							</cf_box>
							
							<cfsavecontent variable="text"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>
							<div class="talep_detay_222">
								<ul>
									<li><a class="talep_detay_222a aktif">#text#</a></li>
									<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
										<a href="javascript://" data-width="300px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
											<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
										</a>
									</cfif>
								</ul>
							</div>
							<cf_box id="relation_assets" design_type="1" header_style="width:290px;" style="width:300px;" title=" " closable="0" collapsable="0" refresh="0" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-3"
								add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-3','body_relation_assets',1)" class="pod_box1">
							</cf_box>
						</div>
						<!--- tıklanma sayisi --->
						<div class="dashboard_11">
							<span><img src="../documents/templates/worknet/tasarim/kutu_icon_8.png" class="chapterImage" alt="İcon" /></span>
						  <h2><cf_get_lang no='281.Tıklanma Sayıları'></h2>
						  <samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'product',process_id:attributes.pid)#</cfoutput></samp>
					    </div>
					</div>
				</div>
			</div>
		</cfoutput>
		<script language="javascript">
			function openProductCat()
			{
				document.getElementById('showCategory').style.display = 'block';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1);
			}
			
			function kontrol()
			{
				if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='74.Kategori'> !");
					document.getElementById('product_cat').focus();
					return false;
				}
				if(document.getElementById('product_name').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='809.Ürün Adı'>!");
					document.getElementById('product_name').focus();
					return false;
				}
				if(document.getElementById('product_keyword').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>!");
					document.getElementById('product_keyword').focus();
					return false;
				}
				if(document.upd_product_.description.value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='640.Özet'>!");
					document.getElementById('description').focus();
					return false;
				}
				if(document.getElementById('product_detail').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.Açıklama'>!");
					document.getElementById('product_detail').focus();
					return false;
				}
				if(confirm("<cf_get_lang_main no='123.Kaydetmek Istediginizden Emin Misiniz?'>")); else return false;
				
				document.getElementById('upd_product_').submit();
			}
			function counter()
			 { 
				if (document.upd_product_.description.value.length > 250) 
				  {
						document.upd_product_.description.value = document.upd_product_.description.value.substring(0, 250);
						alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250"); 
				   }
				else 
					document.getElementById('detailLen').value = 250 - (document.upd_product_.description.value.length); 
			 } 
			counter();
		</script>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
