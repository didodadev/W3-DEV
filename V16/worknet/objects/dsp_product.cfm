<!---<cfif isdefined('session.pp')>--->
	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<!---incelediklerim cookie si için--->
		<cfset createObject("component","cookie").AddCookie(cookied:attributes.pid,actionType:"product")>
		<cfset CookieGetproduct = createObject("component","cookie").GetCookie(actionType:"product")>
		<!---incelediklerim cookie si için--->
		<cfset getProduct = createObject("component","V16.worknet.query.worknet_product").getProduct(product_id:attributes.pid)>
		<cfset attributes.cpid = getProduct.company_id>
		<cfset attributes.partner_id = getProduct.partner_id>
		<cfset msg_subject = getProduct.product_name>
		<cfset msg_action_id = attributes.pid>
		<cfset msg_action_type = "product">
		<cfset getNxt = createObject("component","worknet.objects.worknet_objects").Get_NextPrevProduct(product_id:attributes.pid,type:1)>
      	<cfset getPrev = createObject("component","worknet.objects.worknet_objects").Get_NextPrevProduct(product_id:attributes.pid,type:2)>
	<cfelse>
		<cfset getProduct.recordcount = 0>
		<cfset attributes.cpid = 0>
		<cfset attributes.partner_id = 0>
		<cfset msg_subject = "">
		<cfset msg_action_id = "">
		<cfset msg_action_type = "">
	</cfif>
	
	<cfif getProduct.recordcount>
		<cfoutput>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1>#getProduct.product_name#</h1></div>
				<cfif isdefined('session.pp.userid') and session.pp.company_id eq getProduct.company_id>
					<div class="haber_liste_right" style="width:40px;">
						<a style="margin-left:10px;" href="#request.self#?fuseaction=worknet.detail_product&pid=#getProduct.product_id#">
							<img src="../documents/templates/worknet/tasarim/kutu_icon_2.png" alt="#getProduct.product_name#" title="<cf_get_lang_main no='1306.Düzenle'>" />
						</a>
					</div>
				</cfif>
			</div>
			<div class="talep_detay">
				<div class="talep_detay_1">
					<div class="talep_detay_11">
						<div class="td_kutu">
							<div class="td_kutu_1" style="width:598px;">
								<span><img src="../documents/templates/worknet/tasarim/kutu_icon_2.png" width="31" height="31" alt="İcon" /></span>
								<h2><cf_get_lang no='114.Ürün Bilgileri'></h2>
							</div>
							<div class="td_kutu_2">
								<cfif isdefined('session.pp.userid') and session.pp.company_id eq getProduct.company_id>
									<div class="td_kutu_21">
										<span><cf_get_lang_main no='70.Aşama'></span>
										<samp><strong>#getProduct.STAGE#</strong></samp>
									</div>
								</cfif>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='809.Urun adı'></span>
									<samp>#getProduct.product_name#</samp>
								</div>
								<cfif len(getProduct.product_code)>
									<div class="td_kutu_21">
										<span><cf_get_lang_main no='1388.Ürün kodu'></span>
										<samp>#getProduct.product_code#</samp>
									</div>
								</cfif>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='74.Kategori'></span>
									<samp>
										<cfset hierarchy_ = "">
										<cfset new_name = "">
										<cfloop list="#getProduct.HIERARCHY#" delimiters="." index="hi">
											<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
											<cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
											<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
										</cfloop>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&product_catid=#getProduct.product_catid#&product_cat=#new_name#" title="#new_name#">#new_name#</a>
									</samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='246.Üye'></span>
									<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#getProduct.company_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getProduct.fullname#</a></samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='166.Yetkili'></span>
									<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getProduct.partner_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getProduct.partner_name#</a></samp>
								</div>
								<cfif len(getProduct.brand_name)>
									<div class="td_kutu_21">
										<span><cf_get_lang_main no='1435.Marka'></span>
										<samp>#getProduct.brand_name#</samp>
									</div>
								</cfif>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='217.Açıklama'></span>
									<samp style="width:100%; margin-top:10px;"><PRE>#getProduct.product_detail#</PRE></samp>
								</div>
							</div>
						</div>
					</div>
					<!--- firma kartı --->
					<cfinclude template="firm_info.cfm">
				</div>
				
				<!--- imajlar --->
				<cfset getProductImage = createObject("component","V16.worknet.query.worknet_product").getProductImage(product_id:attributes.pid,image_type:1)>
				<cfset getProductImages = createObject("component","V16.worknet.query.worknet_product").getProductImage(product_id:attributes.pid,image_type:0,recordCount:4)>
				<div class="urun_detay_2" id="gallery">
					<cfif getProductImage.recordcount>
						<div class="urun_detay_21">
							<div class="urun_detay_211">
								<a href="../documents/product/#getProductImage.path#">
									<cfimage source="../../documents/product/#getProductImage.path#" name="myProductImage">
									<cfset imgProductInfo = ImageInfo(myProductImage)>
									<cfif imgProductInfo.width/imgProductInfo.height lt 300/200>
										<cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0" image_height="200">
									<cfelse>
										<cf_get_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#" output_type="0"  image_width="300">
									</cfif>
								</a>
							</div>
							<!---<span><img src="../documents/templates/worknet/tasarim/buyur_icon.png" width="24" height="24" alt="#getProductImage.detail#" /></span>--->
						</div>
					</cfif>
					<cfif getProductImages.recordcount>
						<cfloop query="getProductImages">
							<div <cfif (currentrow mod 2) eq 0>class="urun_detay_23"<cfelse>class="urun_detay_22"</cfif>>
								<a href="../documents/product/#path#"><cf_get_server_file output_file="product/#path#" alt="#getProductImage.detail#" output_server="#path_server_id#" output_type="0" image_width="100">
								<span><img src="../documents/templates/worknet/tasarim/buyur_icon.png" width="24" height="24" alt="#getProductImage.detail#" /></span></a>
							</div>
						</cfloop>
					</cfif>
				</div>
				<!--- belgeler --->
				<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset
						(action_id:attributes.pid,
							action_section:"WORKNET_PRODUCT_ID",
							asset_cat_id:-3
						) />
				<cfif getRelationAsset.recordcount>
					<div class="talep_detay_2" style="float:right; margin-top:10px;">
						<div class="talep_detay_222">
							<ul>
								<li><a class="talep_detay_222a aktif"><cf_get_lang_main no='156.Belgeler'></a></li>
							</ul>
						</div>
						<div class="td_kutu_2">
							<cfloop query="getRelationAsset">
							<div class="td_kutu_21">
								<cfif ListLast(asset_file_name,'.') is 'flv'>
									<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##ASSETCAT_PATH#/#asset_file_name#&ext=flv&video_id=#asset_id#','video');" class="tableyazi">
										#ASSET_NAME# <font color="red">(#property_name#)</font>
									</a>
								<cfelse>
									<a href="javascript://" onClick="windowopen('#file_web_path##ASSETCAT_PATH#/#asset_file_name#','medium');" title="#ASSET_NAME#" class="tableyazi">
										#ASSET_NAME# <font color="red">(#property_name#)</font>
									</a>
								</cfif>	
							</div>
							</cfloop>
						</div>
					</div>
				</cfif>
				<div class="talep_detay_2" style="margin-top:-10px;">
				<cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite
					(action_id:attributes.pid,
						action_type:"product"
					) />					
				<cfif getFavorite.recordcount>
					<div class="talep_detay_21" style="display:none;" id="add_favorite">
						<a href="javascript:" onClick="addFavorite();"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
					</div>
					<div class="talep_detay_21" style="display:block;" id="remove_favorite">
						<a href="javascript:" onClick="removeFavorite();"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
					</div>
				<cfelse>
					<div class="talep_detay_21" style="display:block;" id="add_favorite">
						<a href="javascript:" onClick="addFavorite();"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
					</div>
					<div class="talep_detay_21" style="display:none;" id="remove_favorite">
						<a href="javascript:" onClick="removeFavorite();"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
					</div>
				</cfif>
				</div>
			</div>
		</div>
        <cfif len(getNxt.PRODUCT_ID)>
        	<a href="#request.self#?fuseaction=worknet.dsp_product&pid=#getNxt.PRODUCT_ID#" style="float:right;"><img src="../../documents/templates/worknet/tasarim/sagokkoyu.jpg" title="<cf_get_lang_main no='1059.Bir Sonraki Kayıt'>" /></a>
        <cfelse>
        	<img src="../../documents/templates/worknet/tasarim/sagok.jpg" title="<cf_get_lang_main no='1059.Bir Sonraki Kayıt'>" style="float:right" />
        </cfif>
        <cfif len(getPrev.PRODUCT_ID)>
        	<a href="#request.self#?fuseaction=worknet.dsp_product&pid=#getPrev.PRODUCT_ID#" title="Önceki"><img src="../../documents/templates/worknet/tasarim/solokkoyu.jpg" title="<cf_get_lang_main no='1058.Bir Önceki Kayıt'>" /></a>
        <cfelse>
        	<img src="../../documents/templates/worknet/tasarim/solok.jpg" title="<cf_get_lang_main no='1058.Bir Önceki Kayıt'>" />
        </cfif>
		<script language="javascript">
			function addFavorite()
			{
				document.getElementById('add_favorite').style.display = 'none';
				document.getElementById('remove_favorite').style.display = 'block';
				AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id=#attributes.pid#&action_type=product&add=1',2);
			}
			function removeFavorite()
			{
				document.getElementById('remove_favorite').style.display = 'none';
				document.getElementById('add_favorite').style.display = 'block';
				AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id=#attributes.pid#&action_type=product&add=0');
			}
		</script>
		</cfoutput>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
	<script type="text/javascript" charset="utf-8" id="sourcecode">
		$(function() {
			$('#gallery a').lightBox();
		});
	</script>
<!---<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>--->
