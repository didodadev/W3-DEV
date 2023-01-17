<cfif isdefined('session.pp.userid')>
	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(partner_id:session.pp.userid)>
		<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
		<cfset getProduct = cmp.getProduct(product_id:attributes.pid)>
		<cfset getProductImage = cmp.getProductImage(product_id:attributes.pid)>
		<cfset getProductAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset
				(action_id:attributes.pid,
				action_section:"WORKNET_PRODUCT_ID",
				asset_cat_id:-25
		) />
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cf_get_lang no='154.Katalog'></h1></div>
			</div>
			<div class="talep_detay">
				<div class="talep_detay_1">
					<div style="position:absolute; margin-top:130px;" id="showCategory"></div>
					<cfform name="add_product_" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_query_catalog">
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1" style="width:598px;">
								<h2><cf_get_lang no='154.Katalog'><cf_get_lang_main no='359.Detay'></h2>
							</div>
							<div class="td_kutu_2">
								<table style="width:100%">	
									<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getProduct.company_id#</cfoutput>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getProduct.partner_id#</cfoutput>">
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
											<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#getProduct.product_catid#</cfoutput>" />
											<input type="text" name="product_cat" id="product_cat" style="width:400px;font-size:bold;" onclick="openProductCat();" value="<cfoutput>#new_name#</cfoutput>" readonly="" />
											<a href="javascript://" onClick="openProductCat();" style="position:absolute;">
												<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
											</a>
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='154.Katalog'><cf_get_lang_main no='485.Adi'> *</td>
										<td><input type="text" name="product_name" id="product_name" value="<cfoutput>#getProduct.product_name#</cfoutput>" maxlength="250" style="width:400px;"/></td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
										<td><input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="<cfoutput>#getProduct.product_keyword#</cfoutput>" style="width:200px;"/></td>
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
												onBlur="return ismaxlength(this);" ><cfoutput>#getProduct.product_description#</cfoutput></textarea>
												<input type="text" name="detailLen" id="detailLen" size="1"  style="width:25px;" value="250" readonly />
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='155.Katalog Belgesi'> *</td>
										<td><input type="hidden" value="<cfoutput>#getProductAsset.asset_id#</cfoutput>" name="asset_id" id="asset_id">
											<input type="hidden" value="<cfoutput>#getProductAsset.ASSET_FILE_NAME#</cfoutput>" name="old_file_name" id="old_file_name">
											<input type="hidden" value="<cfoutput>#getProductAsset.ASSET_FILE_SERVER_ID#</cfoutput>" name="old_file_server_id" id="old_file_server_id">				
											<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
												<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
													<input type="file" name="product_asset" id="product_asset" style="width:200px; float:left; margin-right:5px;">
													<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" style="margin-right:5px;"/>
												</a>
											<cfelse>
												<input type="file" name="product_asset" id="product_asset" style="width:200px; float:left;">
											</cfif>
											<cfif getProductAsset.recordcount>
												<cfoutput>
													<a href="javascript://" onClick="windowopen('#file_web_path##getProductAsset.ASSETCAT_PATH#/#getProductAsset.asset_file_name#','medium');" title="#getProductAsset.ASSET_NAME#" class="tableyazi">
														<font color="red"><cf_get_lang no='157.Goruntule'></font>
													</a>
												</cfoutput>
											</cfif>
										</td>
									</tr>
									<tr height="25">
										<td valign="top"><cf_get_lang no='156.Katalog İmajı'> *</td>
										<td><input type="hidden" value="<cfoutput>#getProductImage.product_image_id#</cfoutput>" name="product_image_id" id="product_image_id">
											<input type="hidden" value="<cfoutput>#getProductImage.path#</cfoutput>" name="old_img_name" id="old_img_name">
											<input type="hidden" value="<cfoutput>#getProductImage.path_server_id#</cfoutput>" name="old_img_server_id" id="old_file_server_id">				
											<cfif isdefined('attributes.info_content_id_2') and len(attributes.info_content_id_2)>
												<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id_2)#</cfoutput>" class="tooltip">
													<input type="file" name="product_image" id="product_image" style="width:200px; float:left; margin-right:5px;">
													<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" style="margin-right:5px;" />
												</a>
											<cfelse>
												<input type="file" name="product_image" id="product_image" style="width:200px; float:left;">
											</cfif>
											<cfif getProductImage.recordcount>
												<cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0" image_width="75">
												<!--- crop tool --->
												<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&product_id=#attributes.pid#&product_image_path=#getProductImage.path#</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
											</cfif>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div style=" width:100%; text-align:center;">
						<cfsavecontent variable="message"><cf_get_lang_main no="52.Kaydet"></cfsavecontent>
						<input class="btn_1" type="button" onclick="editKontrol()" value="<cfoutput>#message#</cfoutput>" />
					</div>
					</cfform>
				</div>
			
				<div class="talep_detay_2">
					<!--- tıklanma sayisi --->
					<div class="dashboard_11">
						<span><img src="../documents/templates/worknet/tasarim/kutu_icon_8.png" class="chapterImage" alt="İcon" /></span>
					  <h2><cf_get_lang no='281.Tıklanma Sayıları'></h2>
					  <samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'catalog',process_id:attributes.pid)#</cfoutput></samp>
					</div>
				</div>
			</div>
		</div>
		<script language="javascript">
			function openProductCat()
			{
				document.getElementById('showCategory').style.display = 'block';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
			}
			function editKontrol()
			{
				if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
				{
					alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
					document.getElementById('product_cat').focus();
					return false;
				}
				if(document.getElementById('product_name').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='154.Katalog'><cf_get_lang_main no='485.Adi'>!");
					document.getElementById('product_name').focus();
					return false;
				}
				if(document.getElementById('product_keyword').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>!");
					document.getElementById('product_keyword').focus();
					return false;
				}
				if(document.getElementById('description').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='640.Özet'>!");
					document.getElementById('description').focus();
					return false;
				}
				<cfif getProductAsset.recordcount eq 0>
					if(document.getElementById('product_asset').value == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='155.Katalog Belgesi'>!");
						document.getElementById('product_asset').focus();
						return false;
					}
				</cfif>
				var obj =  document.getElementById('product_image').value;	
				if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg')))
				{
					alert("<cf_get_lang no='223.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz!'>!");
					return false;
				}
				if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
				
				document.getElementById('add_product_').submit();		
			}
			function counter()
			 { 
				if (document.getElementById('description').value.length > 250) 
				  {
						document.getElementById('description').value = document.getElementById('description').value.substring(0, 250);
						alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250"); 
				   }
				else 
					document.getElementById('detailLen').value = 250 - (document.getElementById('description').value.length); 
			 } 
			counter();
		</script>
	<cfelse>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cf_get_lang no='154.Katalog'><cf_get_lang_main no='170.Ekle'></h1></div>
			</div>
			<div class="talep_detay">
				<div style="position:absolute;margin-top:95px;" id="showCategory"></div>
				<cfform name="add_product_" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_query_catalog">
				<div class="talep_detay_1" style="width:905px;">
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1">
								<h2><cf_get_lang no='154.Katalog'><cf_get_lang_main no='170.Ekle'></h2>
							</div>
							<div class="td_kutu_2">
								<div style="display:none;"><cf_workcube_process is_upd='0' is_detail='0'></div>
								<table>	
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#session.pp.userid#</cfoutput>">
									<tr height="25">
										<td width="110"><cf_get_lang_main no='74.Kategori'> *</td>
										<td><input type="hidden" name="product_catid" id="product_catid" value="" />
											<input type="text" name="product_cat" id="product_cat" style="width:400px;" value="" onfocus="openProductCat();" readonly="" />
											<a href="javascript://" onClick="openProductCat();" style="position:absolute;">
												<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
											</a>
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='154.Katalog'><cf_get_lang_main no='485.Adi'> *</td>
										<td><input type="text" name="product_name" id="product_name" value="" maxlength="250" style="width:400px;"/></td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
										<td><input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="" style="width:200px;"/></td>
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
												onBlur="return ismaxlength(this);" ></textarea>
												<input type="text" name="detailLen" id="detailLen" size="1"  style="width:25px;" value="250" readonly />
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='155.Katalog Belgesi'> *</td>
										<td><cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
												<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">	
													<input type="file" name="product_asset" id="product_asset" style="width:200px; float:left; margin-right:5px;">
													<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" style="margin-right:5px;" />
												</a>
											<cfelse>
												<input type="file" name="product_asset" id="product_asset" style="width:200px; float:left;">
											</cfif>
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='156.Katalog İmajı'> *</td>
										<td>
											<cfif isdefined('attributes.info_content_id_2') and len(attributes.info_content_id_2)>
												<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id_2)#</cfoutput>" class="tooltip">
													<input type="file" name="product_image" id="product_image" style="width:200px; float:left; margin-right:5px;">
													<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" style="margin-right:5px;" />
												</a>
											<cfelse>
												<input type="file" name="product_image" id="product_image" style="width:200px; float:left;">
											</cfif>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div style=" width:100%; text-align:center;">
					<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
					<input class="btn_1" type="button" onclick="kontrol()" value="<cfoutput>#message#</cfoutput>" />
				</div>
				</cfform>
			</div>
		</div>
		<script language="javascript">
			function openProductCat()
			{
				document.getElementById('showCategory').style.display = 'block';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
			}
			function kontrol()
			{
				if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
				{
					alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
					document.getElementById('product_cat').focus();
					return false;
				}
				if(document.getElementById('product_name').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='154.Katalog'><cf_get_lang_main no='485.Adi'>!");
					document.getElementById('product_name').focus();
					return false;
				}
				if(document.getElementById('product_keyword').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>!");
					document.getElementById('product_keyword').focus();
					return false;
				}
				if(document.getElementById('description').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='640.Özet'>!");
					document.getElementById('description').focus();
					return false;
				}
			
				if(document.getElementById('product_asset').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='155.Katalog Belgesi'>!");
					document.getElementById('product_asset').focus();
					return false;
				}
			
				var obj =  document.getElementById('product_image').value;	
				if ((obj == "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg')))
				{
					alert("<cf_get_lang no='223.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz!'>!");        
					return false;
				}
				if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
				
				document.getElementById('add_product_').submit();		
			}
			function counter()
			 { 
				if (document.getElementById('description').value.length > 250) 
				  {
						document.getElementById('description').value = document.getElementById('description').value.substring(0, 250);
						alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250"); 
				   }
				else 
					document.getElementById('detailLen').value = 250 - (document.getElementById('description').value.length); 
			 } 
			counter();
		</script>
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
