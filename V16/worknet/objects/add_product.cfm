<cfif isdefined('session.pp.userid')>
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='1613.Urun Ekle'></h1></div>
		</div>
		<div class="talep_detay">
			<div style="position:absolute; margin-top:100px;" id="showCategory"></div>
			<cfform name="add_product_" id="add_product_" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_add_product">
			<div class="talep_detay_1" style="width:905px;">
				<div class="talep_detay_12">
					<div class="td_kutu">
						<div class="td_kutu_1">
							<h2><cf_get_lang no='114.Ürün Bilgileri'></h2>
						</div>
						<div class="td_kutu_2">
							<div style="display:none;"><cf_workcube_process is_upd='0' is_detail='0'></div>
							<table>	
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#session.pp.userid#</cfoutput>">
								<cfif attributes.fuseaction contains 'product'>
									<input type="hidden" name="is_catalog" id="is_catalog" value="0" />
								<cfelse>
									<input type="hidden" name="is_catalog" id="is_catalog" value="1" />
								</cfif>
								<input type="hidden" name="type_" id="type_" value="1">
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
									<td><cf_get_lang_main no='809.Ürün Adı'> *</td>
									<td><input type="text" name="product_name" id="product_name" value="" maxlength="250" style="width:400px;"/></td>
								</tr>
								<tr height="25">
									<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
									<td><input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="" style="width:200px;"/></td>
								</tr>
								<tr height="25">
									<td><cf_get_lang_main no='1435.Marka'> </td>
									<td><input type="text" name="product_brand" id="product_brand" value="" maxlength="150" style="width:200px;"/></td>
								</tr>
								<tr height="25">
									<td><cf_get_lang_main no='1388.Ürün Kodu'></td>
									<td><input type="text" name="product_code" id="product_code" value="" maxlength="150" style="width:200px;"/></td>
								</tr>
								<tr height="25">
									<td><cf_get_lang_main no ='1965.İmaj'> *</td>
									<td><input type="file" name="product_image" id="product_image" style="width:200px;float:left;">
										<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
											<a href="javascript://" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
												<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
											</a>
										</cfif>
									</td>
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
											<input type="text" name="detailLen"  id="detailLen" size="1"  style="width:25px;" value="250" readonly />
									</td>
								</tr>
								<tr>
									<td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
									<td><textarea 
											style="width:500px; height:300px;" 
											name="product_detail" 
											id="product_detail" ></textarea>
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
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='74.Kategori'> !");
				document.getElementById('product_cat').focus();
				return false;
			}
			if(document.getElementById('product_name').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='809.Ürün Adı'> !");
				document.getElementById('product_name').focus();
				return false;
			}
			if(document.getElementById('product_keyword').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>!");
				document.getElementById('product_keyword').focus();
				return false;
			}
			var obj =  document.getElementById('product_image').value;	
			if ((obj == "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png')  || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg')))
			{
				alert("<cf_get_lang no='223.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz!'>!");        
				return false;
			}
			if(document.getElementById('description').value == '')
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
			
			if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
			
			document.getElementById('add_product_').submit();
		}
		function counter()
		 { 
			if (document.add_product_.description.value.length > 250) 
			  {
					document.add_product_.description.value = document.add_product_.description.value.substring(0, 250);
					alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250"); 
			   }
			else 
				document.getElementById('detailLen').value = 250 - (document.add_product_.description.value.length); 
		 } 
	</script>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için Firma Çalışanı olarak Giriş Yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
