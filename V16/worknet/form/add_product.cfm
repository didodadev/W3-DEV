<cfset foldername = createUUID()>

<cf_catalystHeader>

<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">

<cfform name="add_product" id="add_product" method="post" action="" enctype="multipart/form-data">
	<cf_box id="add_products" closable="0" collapsable="0" title="#getLang('main',152)# : #getLang('main',2352)#">
		<cf_box_elements vertical="1">
			<cfif not attributes.fuseaction contains 'product'>
				<input type="hidden" name="is_catalog" id="is_catalog" value="1" />
			<cfelseif attributes.fuseaction contains 'product'>
				<input type="hidden" name="is_catalog" id="is_catalog" value="0" />
			</cfif>

			<div class="row" type="row">
				<!--- Left --->
				<div class="col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-product_name">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='245.Ürün'> *</label>
						<div class='col-6 col-xs-12'>
								<cfinput type="text" name="product_name" id="product_name" value="" maxlength="250"/>
						</div>
					</div>
					<div class="form-group" id="item-product_keyword">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="47741.Anahtar Kelimeler"> *</label>
						<div class='col-6 col-xs-12'>
							<input type="text" name="product_keyword" id="product_keyword" maxlength="250" value=""/>
						</div>
					</div>
					<div class="form-group" id="item-product_desc">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no="640.Özet"> *</label>
						<div class='col-6 col-xs-12'>
							<textarea 
										style="width:400px; height:75px;" 
										name="description" 
										id="description" 
										onChange="counterr();return ismaxlength(this);"
										onkeydown="counterr();return ismaxlength(this);" 
										onkeyup="counterr();return ismaxlength(this);" 
										onBlur="return ismaxlength(this);" ></textarea>
							<input type="text" name="descLen"  id="descLen" size="1"  style="width:25px !important; float:right;" value="250" readonly />
						</div>
					</div>
					<div class="form-group" id="item-product_detail">
						<label><cf_get_lang dictionary_id='46775.Dataylı Bilgi'> *</label>
						<div class='col-6 col-xs-12'>
							<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarSet="mailcompose"
								basePath="/fckeditor/"
								instanceName="product_detail"
								valign="top"
								value=""
								width="600"
								height="150">
						</div>
					</div>
					<div class="form-group" id="item-product_category_brand">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='74.Kategori'> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38484.İlişkili Ürün'> *</label>
					</div>
					<div class="form-group" id="item-product_category_brand2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
								<!--- <div class="input-group">
									<input type="hidden" name="product_catid" id="product_catid" value="" />
									<input type="text" name="product_cat" id="product_cat" value="" readonly/>
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=product_catid&field_name=add_product.product_cat','list');" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>!"></span>
								</div> --->
								<select name="product_catid" id="product_catid" multiple>
								</select>
								<div align="right">
									<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&order_cat=add_product.product_catid&is_multi_selection=1','list');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='4.Proje'>" align="top" border="0"></a>
									<a href="javascript://" onclick="cat_remove();"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no ='51.Sil'>" style="cursor=hand" align="top"></a>	
								</div>			
							</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<!--- <div class="input-group">
								<input type="hidden" name="related_product_id" id="related_product_id" value="" />
								<input type="text" name="related_product" id="related_product" value="" readonly/>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_product.related_product_id&field_name=add_product.related_product','list');"></span>
							</div> --->
							<select name="r_product_multi_id" id="r_product_multi_id" multiple>
							</select>
							<div align="right">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&order_product=add_product.r_product_multi_id&is_multi_selection=1','list');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='4.Proje'>" align="top" border="0"></a>
								<a href="javascript://" onclick="project_remove();"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no ='51.Sil'>" style="cursor=hand" align="top"></a>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-showCategory">
						<div style="position:absolute;" id="showCategory"></div>
					</div>
					<div class="form-group" id="item-product_code">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='1388.Ürün Kodu'>-<cf_get_lang dictionary_id='30366.Watalogy'><cf_get_lang dictionary_id='49089.Kodu'> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='1435.Marka'> *</label>
					</div>
					<div class="form-group" id="item-product_code2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
							<input type="text" name="product_code" id="product_code" value="">
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<cfinput type="hidden" name="brand_code" id="brand_code" value="">
							<cf_wrkProductBrand
								returnInputValue="brand_id,brand_name,brand_code"
								returnQueryValue="BRAND_ID,BRAND_NAME,BRAND_CODE"
								width="120"
								compenent_name="getProductBrand"               
								boxwidth="300"
								boxheight="150"
								is_internet="1"
								brand_code=""
								brand_ID=""
								readonly>
						</div>
					</div>
					<div class="form-group" id="item-product_company">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='246.Üye'>-<cf_get_lang_main no='1736.Tedarikçi'> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='166.Yetkili'> *</label>
					</div>
					<div class="form-group" id="item-product_company2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="" />
								<input type="text" name="company_name" id="company_name" value="" readonly/>
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_product.company_id&is_period_kontrol=0&field_comp_name=add_product.company_name&field_partner=add_product.partner_id&field_name=add_product.partner_name&par_con=1&select_list=2,3</cfoutput>','list')"></span>
							</div>
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="text" name="partner_name" id="partner_name" value="" readonly>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'>-<cf_get_lang_main no="1447.Süreç"> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30366.Watalogy'><cf_get_lang dictionary_id='35990.Bağlantı'> *</label>
					</div>
					<div class="form-group" id="item-process_stage2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
							<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<div class="input-group">
								<input type="hidden" name="watalogy_con_id" id="watalogy_con_id" value="1">
							<input type="text" name="watalogy_con" id="watalogy_con" value="deneme" readonly>
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick=""></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_image">
						<label class="col col-3 col-xs-12" style="margin-bottom:5px;"><cf_get_lang dictionary_id="50552.İmajlar"> *</label>
						<div class='col-6 col-xs-12'>
							<div id="fileUpload" class="fileUpload">
								<cfoutput>
								<div class="fileupload-body col col-11 col-md-10 col-sm-10 col-xs-12 offset-1" style="margin-left:0 !important; padding-left:0 !important; margin-right:0 !important; padding-right:0 !important;">
									<!-- Nav tabs -->
									<input type="hidden" name="foldername" value="<cfoutput>#foldername#</cfoutput>">
									<input type="hidden" name="asset" id="asset" value="">
									<input type="hidden" name="message_Del" id="message_Del" value="<cfoutput>#getLang('main',51)#</cfoutput>">
									<input type="hidden" name="message_Cancel" id="message_Cancel" value="<cfoutput>#getLang('crm',21)#</cfoutput>">
									<div class="dropzone dz-clickable dropzonescroll" id="file-dropzone">
										<div class="dz-default dz-message">
											<span>#getLang('assetcare',309)#</span>
										</div>
									</div>				
								</div>  
								</cfoutput>      
							</div>
						</div>
					</div>
				</div>
				<!--- --->
			</div>
			<!--- Button --->
			<div class="row formContentFooter" style="margin-top:15px !important;">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</div>
			</div>
			<!--- --->
		</cf_box_elements>
	</cf_box>
</cfform>

<!---
<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
  <tr>
	<td height="35"><cfif attributes.fuseaction contains 'product'><cf_get_lang_main no='1613.Ürün Ekle'><cfelse><cf_get_lang no='175.Katalog Ekle'></cfif></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0">
	<tr>
		<td> 
			<cf_box id="add_product2" closable="0" collapsable="0">
				<table>	
					<cfform name="add_product2" id="add_product2" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_add_product">
						<cfif not attributes.fuseaction contains 'product'>
							<input type="hidden" name="is_catalog" id="is_catalog" value="1" />
            <cfelseif attributes.fuseaction contains 'product'>
              <input type="hidden" name="is_catalog" id="is_catalog" value="0" />
						</cfif>
						<tr>
							<td width="100"><cf_get_lang_main no='74.Kategori'> *</td>
							<td><input type="hidden" name="product_catid" id="product_catid" value="" />
								<input type="text" name="product_cat" id="product_cat" style="width:400px;" value="" onfocus="goster(showCategory);openProductCat();" readonly="" />
								<a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><cf_get_lang_main no="1535.Kategori Seç"></a>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='246.Üye'> *</td>
							<td>
								<input type="hidden" name="company_id" id="company_id" value="">
								<input name="company_name" type="text" id="company_name" style="width:300px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\'','MEMBER_PARTNER_NAME2,PARTNER_ID,COMPANY_ID','partner_name,partner_id,company_id','','3','250');" value="" autocomplete="off">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_product.company_id&field_comp_name=add_product.company_name&field_id=add_product.partner_id&field_name=add_product.partner_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(add_product.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='166.Yetkili'></td>
							<td>
								<input type="hidden" name="partner_id" id="partner_id" value="">
								<input type="text" name="partner_name" id="partner_name" style="width:200px;"  value="" readonly>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no="1447.Süreç">*</td>
							<td><cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'></td>
						</tr>
						<tr>
							<td><cfif attributes.fuseaction contains 'product'><cf_get_lang_main no='809.Ürün Adı'><cfelse><cf_get_lang no='228.Katalog Adı'></cfif>*</td>
							<td><cfinput type="text" name="product_name" id="product_name" value="" maxlength="250" style="width:400px;"/></td>
						</tr>
						<tr>
							<td><cf_get_lang no="11.Anahtar Kelime"> *</td>
							<td><input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="" style="width:200px;"/></td>
						</tr>
						<cfif attributes.fuseaction contains 'product'>
							<tr>
								<td><cf_get_lang_main no='1435.Marka'> </td>
								<td><input type="text" name="product_brand" id="product_brand" value="" maxlength="150" style="width:200px;"/></td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1388.Ürün Kodu'></td>
								<td><input type="text" name="product_code" id="product_code" value="" maxlength="150" style="width:200px;"/></td>
							</tr>
						</cfif>
						<cfif attributes.fuseaction contains 'catalog'>
							<tr height="25">
								<td><cf_get_lang no='155.Katalog Belgesi'> *</td>
								<td><input type="file" name="product_asset" id="product_asset" style="width:200px;"></td>
							</tr>
						</cfif>
						<tr>
							<td><cf_get_lang_main no ='1965.İmaj'></td>
							<td><input type="file" name="product_image" id="product_image" style="width:200px;"></td>
						</tr>
						<tr>
							<td valign="top"><cf_get_lang_main no="640.Özet"> *</td>
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
							<td>
								<!---<cfmodule
									template="/fckeditor/fckeditor.cfm"
									toolbarSet="mailcompose"
									basePath="/fckeditor/"
									instanceName="product_detail"
									valign="top"
									value=""
									width="600"
									height="150">--->
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
						</tr>
					</cfform>
				</table>
			</cf_box>
		</td>
	</tr>
</table>
--->

<script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/JS/fileupload/fileupload-min.js"></script>
<script language="javascript">

	$(function(){
		///for file upload area text
		if($(window).width() < 768){
			$(".dz-default").html("<span><cfoutput>#getLang('assetcare',472)#</cfoutput></span>");
		}

		$(window).resize(function(){
			if($(window).width() < 768){
				$(".dz-default").html("<span><cfoutput>#getLang('assetcare',472)#</cfoutput></span>");
			}else{
				$(".dz-default").html("<span><cfoutput>#getLang('assetcare',309)#</cfoutput></span>");
			}
		});
	});

	function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}

	function kontrol()
	{
		if(document.getElementById('product_name').value == '')
		{
			alert("<cf_get_lang no ='72.Lütfen Ürün İsmi Giriniz'>!");
			document.getElementById('product_name').focus();
			return false;
		}
		if(document.getElementById('product_keyword').value == '')
		{
			alert("Lütfen ürün anahtar kelime giriniz!");
			document.getElementById('product_keyword').focus();
			return false;
		}
		if(document.getElementById('description').value == '')
		{
			alert("Lütfen özet bilgisi giriniz!");
			document.getElementById('description').focus();
			return false;
		}
		if(CKEDITOR.instances.product_detail.getData() == '')
		{
			alert("Lütfen açıklama giriniz!");
			return false;
		}
		/* if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
		{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			document.getElementById('product_cat').focus();
			return false;
		} */
		if(document.getElementById('product_code').value == '')
		{
			alert("Lütfen ürün kodu giriniz!");
			document.getElementById('product_code').focus();
			return false;
		}
		if(document.getElementById('r_product_multi_id')!= undefined)
		{
				select_all('r_product_multi_id');
		}
		if(document.getElementById('product_catid')!= undefined)
		{
				select_all('product_catid');
		}
		if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('company_name').focus();
			return false;
		}
		if(document.getElementById('partner_id').value == '' || document.getElementById('partner_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('partner_name').focus();
			return false;
		}
		if(document.getElementById('watalogy_con_id').value == '' || document.getElementById('watalogy_con').value == '' )
		{
			alert('Lütfen watalogy bağlantısı yapınız !');
			document.getElementById('watalogy_con').focus();
			return false;
		}
		return true;
	}

	function project_remove()
	{
		for (i=document.getElementById('r_product_multi_id').options.length-1;i>-1;i--)
		{
			if (document.getElementById('r_product_multi_id').options[i].selected==true)
			{
				document.getElementById('r_product_multi_id').options.remove(i);
			}	
		}
	}

	function cat_remove()
	{
		for (i=document.getElementById('product_catid').options.length-1;i>-1;i--)
		{
			if (document.getElementById('product_catid').options[i].selected==true)
			{
				document.getElementById('product_catid').options.remove(i);
			}	
		}
	}

	function select_all(selected_field)
	{
		var m = document.getElementById(selected_field).options.length;
		for(i=0;i<m;i++)
		{
			document.getElementById(selected_field)[i].selected=true;
		}
	}

	function counterr()
	 { 
		if (document.add_product.description.value.length > 250) 
		{
			document.add_product.description.value = document.add_product.description.value.substring(0, 250);
			alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250");  
		}
		else 
			document.getElementById('descLen').value = 250 - (document.add_product.description.value.length); 
	 }
</script>

