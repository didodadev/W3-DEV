<style type="text/css">
    .material-switch > input[type="checkbox"] {
        display: none;   
    }
    .material-switch > label {
        cursor: pointer;
        height: 0px;
        position: relative; 
        width: 40px;  
    }
    .material-switch > label::before {
        background: rgb(0, 0, 0);
        box-shadow: inset 0px 0px 10px rgba(0, 0, 0, 0.5);
        border-radius: 8px;
        content: '';
        height: 16px;
        margin-top: -8px;
        position:absolute;
        opacity: 0.3;
        transition: all 0.4s ease-in-out;
        width: 40px;
    }
    .material-switch > label::after {
        background: rgb(255, 255, 255);
        border-radius: 16px;
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
        content: '';
        height: 24px;
        left: -4px;
        margin-top: -8px;
        position: absolute;
        top: -4px;
        transition: all 0.3s ease-in-out;
        width: 24px;
    }
    .material-switch > input[type="checkbox"]:checked + label::before {
        background: inherit;
        opacity: 0.5;
    }
    .material-switch > input[type="checkbox"]:checked + label::after {
        background: inherit;
        left: 20px;
    }
</style>

<cfset foldername = createUUID()>
<cfform name="upd_product" id="upd_product" method="post" action="" enctype="multipart/form-data">
	<cf_box id="formUpd" closable="0" collapsable="0" title="#getLang('main',152)# : #getProduct.PRODUCT_NAME#">
		<cf_box_elements vertical="1">
			<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
			<input type="hidden" name="product_status" id="product_status" value="1">
			<input type="hidden" name="old_path" id="old_path" value="<cfoutput>#getProduct.PATH#</cfoutput>">
			<div class="row" type="row">
				<!--- Left --->
				<div class="col col-12 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-product_name">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='245.Ürün'> *</label>
						<div class='col-6 col-xs-12'>
								<input type="text" name="product_name" id="product_name" value="<cfoutput>#getProduct.PRODUCT_NAME#</cfoutput>" maxlength="250"/>
						</div>
					</div>
					<div class="form-group" id="item-product_keyword">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="47741.Anahtar Kelimeler"> *</label>
						<div class='col-6 col-xs-12'>
							<input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="<cfoutput>#getProduct.PRODUCT_KEYWORD#</cfoutput>"/>
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
										onBlur="return ismaxlength(this);" ><cfoutput>#getProduct.PRODUCT_DESCRIPTION#</cfoutput></textarea>
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
								value="#getProduct.PRODUCT_DETAIL#"
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
									<cfoutput query="getProductCat">
										<option value="#PRODUCT_CATID#">#HIERARCHY# #PRODUCT_CAT#</option>
									</cfoutput>
								</select>
								<div align="right">
									<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&order_cat=upd_product.product_catid&is_multi_selection=1','list');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='4.Proje'>" align="top" border="0"></a>
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
								<cfoutput query="getRelatedProduct">
									<option value="#PRODUCT_ID#">#PRODUCT_NAME#</option>
								</cfoutput>
							</select>
							<div align="right">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&order_product=upd_product.r_product_multi_id&is_multi_selection=1','list');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='4.Proje'>" align="top" border="0"></a>
								<a href="javascript://" onclick="project_remove();"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no ='51.Sil'>" style="cursor=hand" align="top"></a>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-showCategory">
						<div style="position:absolute;" id="showCategory"></div>
					</div>
					<div class="form-group" id="item-product_code">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='1388.Ürün Kodu'>-<cf_get_lang dictionary_id='30366.Watalogy'> <cf_get_lang dictionary_id='49089.Kodu'> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='1435.Marka'> *</label>
					</div>
					<div class="form-group" id="item-product_code2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
							<input type="text" name="product_code" id="product_code" value="<cfoutput>#getProduct.PRODUCT_CODE#</cfoutput>">
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<input type="hidden" name="brand_code" id="brand_code" value="">
							<cf_wrkProductBrand
								returnInputValue="brand_id,brand_name,brand_code"
								returnQueryValue="BRAND_ID,BRAND_NAME,BRAND_CODE"
								width="120"
								compenent_name="getProductBrand"               
								boxwidth="300"
								boxheight="150"
								is_internet="1"
								brand_code=""
								brand_ID="#getProduct.BRAND_ID#"
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
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getProduct.COMPANY_ID#</cfoutput>" />
								<input type="text" name="company_name" id="company_name" value="<cfoutput>#getProduct.FULLNAME#</cfoutput>" readonly/>
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_product.company_id&is_period_kontrol=0&field_comp_name=upd_product.company_name&field_partner=upd_product.partner_id&field_name=upd_product.partner_name&par_con=1&select_list=2,3</cfoutput>','list')"></span>
							</div>
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getProduct.PARTNER_ID#</cfoutput>">
							<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#getProduct.PARTNER_NAME#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'>-<cf_get_lang_main no="1447.Süreç"> *</label>
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30366.Watalogy'> <cf_get_lang dictionary_id='35990.Bağlantı'> *</label>
					</div>
					<div class="form-group" id="item-process_stage2">
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; padding-left:0 !important;">
							<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
						</div>
						<div class='col col-3 col-xs-12' style="margin-top:-6px !important; margin-right:0 !important; padding-right:0 !important;">
							<div class="input-group">
								<input type="hidden" name="watalogy_con_id" id="watalogy_con_id" value="<cfoutput>#getProduct.WATALOGY_CON_ID#</cfoutput>">
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
					<div class="form-group" id="item-active">
						<label class="col col-3 col-xs-12"><cf_get_lang_main dictionary_id='57493.Aktif'></label>
						<div class='col-6 col-xs-12'>
						<div class="col-6 col-xs-12 material-switch pull-right">
							<input id="is_active" name="is_active" type="checkbox" value="1" <cfif getProduct.PRODUCT_STATUS eq 1>checked</cfif>/>
							<label for="is_active" class="label-success"></label>
						</div>
						</div>
					</div>
				</div>
				<!--- --->
			</div>
			<!--- Button --->
			<div class="row formContentFooter" style="margin-top:15px !important;">
					<div class="col col-12">
						<cf_workcube_buttons is_upd='1' add_function='kontrol()'>
						<cf_record_info query_name="getProduct" record_emp="RECORD_MEMBER" update_emp="UPDATE_MEMBER">
					</div>
			</div>
			<!--- --->
		</cf_box_elements>
	</cf_box>
</cfform>

<cf_box
	id="list_worknet_relation"
	unload_body="1"
	closable="0"
	add_href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=popup_addWorknetRelation&pid=#attributes.pid#&form_submitted=1"
	title="Pazaryeri Üyelik Listesi"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_product_relation_worknet&pid=#attributes.pid#">
</cf_box>

<cf_box
	id="product_relation_supplier"
	unload_body="1"
	closable="0"
	add_href="#request.self#?fuseaction=objects.popup_list_pars_multiuser&field_comp_id=form1.aaa&select_list=2"
	title="Tedarikçiler"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_product_relation_supplier&pid=#attributes.pid#">
</cf_box>