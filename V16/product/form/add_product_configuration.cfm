<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_product_configuration" action="#request.self#?fuseaction=product.emptypopup_add_product_configuration" method="post" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="checkbox" name="is_active" id="is_active" checked value="1">
						</div>
					</div>
					<div class="form-group" id="item-configuration_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37499.Konfigürasyon'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfinput type="text" name="configuration_name" required="yes" value="">
						</div>
					</div>
					<div class="form-group" id="item-product_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="stock_id" id="stock_id" value="">
								<input type="text" name="product_name" id="product_name" value="" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&ajax_form=1&field_name=product_name&field_id=stock_id&call_function=setConfTypeNull&call_function_paremeter=\'product\'');" title="<cf_get_lang dictionary_id='37786.Ürün Seç'>"></span>
							</div>
						</div>
					</div>
				<!--- 	<div class="form-group" id="item-brand_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkproductbrand
                            width="100"
                            compenent_name="getProductBrand"               
                            boxwidth="240"
                            boxheight="150"
                            brand_id="">
                        </div>
                    </div>
					<div class="form-group" id="item-cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="cat_id" id="cat_id" value="">
                                <input type="hidden" name="cat" id="cat" value="">
                                <input name="category_name" type="text" id="category_name"  onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_product_configuration.cat_id&field_code=add_product_configuration.cat&field_name=add_product_configuration.category_name&caller_function=setConfTypeNull&caller_function_paremeter=\'category\'</cfoutput>');"></span>
                            </div>
                        </div>
                    </div> --->
					<div class="form-group" id="item-origin">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62469.Origin'></label>
						<div class="col col-8 col-xs-12"> 
							<select name="origin">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='62470.Ağacı kullanarak spekt yarat'></option>
								<option value="2"><cf_get_lang dictionary_id='62471.Karma Koliyi yeniden düzenleyerek özelleştir'></option>
								<option value="3"><cf_get_lang dictionary_id='65197.Tanımları kullanarak spekt yarat'></option>
								<option value="4"><cf_get_lang dictionary_id='65198.Özel Widget kullanarak spect yarat'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true" style="margin-top:20px;">
				<div class="form-group" id="item-product_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62472.Konfigüratör Widget'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="widget_id" id="widget_id">
							<input type="text" name="widget_friendly_name" id="widget_friendly_name">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.popup_widget&field_id=add_product_configuration.widget_id&field_name=add_product_configuration.widget_friendly_name&widget_type=2');"></span>
						</div>
					</div>
				</div>
			<!--- 	<div class="form-group" id="item-startdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama girmelisiniz'></cfsavecontent>
							<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" value="">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57739.Bitiş girmelisiniz'></cfsavecontent>
							<cfinput  validate="#validate_style#" message="#message1#" type="text" name="finishdate" value="">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div> --->
				<div class="form-group" id="item-configuration_detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
					<div class="col col-8 col-xs-12"> 
						<textarea name="configuration_detail" id="configuration_detail"></textarea>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58029.İkon'>- <cf_get_lang dictionary_id='29762.İmaj'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
                </div>
			</div>
			</cf_box_elements>
			<cf_box_footer>	
				<div class="col col-12"><cf_workcube_buttons type_format='1' is_update = '0' add_function='configurator_save()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function configurator_save()
	{
		if(document.add_product_configuration.configuration_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='60465.Lütfen Konfigrasyon Tanımı Giriniz'>!");
			return false;
		}
		if(
			(document.add_product_configuration.stock_id.value == '' || document.add_product_configuration.product_name.value == '')
			&& (document.add_product_configuration.brand_id.value == '' || document.add_product_configuration.brand_name.value == '')
			&& (document.add_product_configuration.cat_id.value == '' || document.add_product_configuration.category_name.value == '')
		)
		{
			alert("<cf_get_lang dictionary_id='62721.Ürün, kategori ya da marka alanlarından birini doldurunuz'>!");
			return false;
		}
		if(document.add_product_configuration.configuration_detail.value == '')
		{
			alert("<cf_get_lang dictionary_id='56660.Lütfen Açıklama Giriniz'>!");
			return false;
		}	
		return true;
	}
	function setConfTypeNull( type ){
		if( type == 'product' ){
			document.getElementById('brand_id').value = '';
			document.getElementById('brand_name').value = '';
			document.getElementById('cat_id').value = '';
			document.getElementById('cat').value = '';
			document.getElementById('category_name').value = '';
		}else if( type == 'category' ){
			document.getElementById('stock_id').value = '';
			document.getElementById('product_name').value = '';
			document.getElementById('brand_id').value = '';
			document.getElementById('brand_name').value = '';
		}
	}
</script>