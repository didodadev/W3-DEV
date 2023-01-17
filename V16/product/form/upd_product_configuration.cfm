<cfquery name="get_conf" datasource="#dsn3#">
	SELECT 
		SPC.*,
		W.WIDGET_TITLE,
		W.WIDGET_FRIENDLY_NAME,
		PC.PRODUCT_CAT,
		PC.HIERARCHY
	FROM 
		SETUP_PRODUCT_CONFIGURATOR AS SPC
		LEFT JOIN #dsn#.WRK_WIDGET AS W ON SPC.WIDGET_ID = W.WIDGETID
		LEFT JOIN #dsn#_product.PRODUCT_CAT AS PC ON SPC.PRODUCT_CAT_ID = PC.PRODUCT_CATID
	WHERE
		SPC.PRODUCT_CONFIGURATOR_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_product_configuration" action="#request.self#?fuseaction=product.emptypopup_upd_product_configuration" method="post" enctype="multipart/form-data">
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="checkbox" name="is_active" id="is_active"<cfif get_conf.is_active eq 1>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-configuration_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37499.Konfigürasyon'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="configuration_name" style="width:150px;" value="#get_conf.configurator_name#">
								<span class="input-group-addon">
								<cf_language_info
									table_name="SETUP_PRODUCT_CONFIGURATOR"
									column_name="CONFIGURATOR_NAME"
									column_id_value="#attributes.id#"
									maxlength="500" 
									datasource="#dsn3#"
									column_id="PRODUCT_CONFIGURATOR_ID"
									control_type="1">
								</span>		
							</div>	
						</div>
					</div>
					<cfset product_name = ''>
					<cfif len(get_conf.configurator_stock_id)>
						<cfquery name="get_product_name" datasource="#dsn3#">
							SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_conf.configurator_stock_id#
						</cfquery>
						<cfif get_product_name.recordcount>
							<cfset product_name = ValueList(get_product_name.product_name,',')>
						</cfif>
					</cfif>
					<div class="form-group" id="item-product_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57657.Ürün'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="stock_id" id="stock_id" value="#get_conf.configurator_stock_id#">
									<input type="text" name="product_name" id="product_name" value="#product_name#" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
								</cfoutput>
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
                            brand_id="#get_conf.BRAND_ID#">
                        </div>
                    </div>
					<div class="form-group" id="item-cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="cat_id" id="cat_id" value="<cfoutput>#get_conf.PRODUCT_CAT_ID#</cfoutput>">
                                <input type="hidden" name="cat" id="cat" value="<cfoutput>#get_conf.HIERARCHY#</cfoutput>">
                                <input name="category_name" type="text" id="category_name"  onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfoutput>#get_conf.PRODUCT_CAT#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_product_configuration.cat_id&field_code=add_product_configuration.cat&field_name=add_product_configuration.category_name&caller_function=setConfTypeNull&caller_function_paremeter=\'category\'</cfoutput>');"></span>
                            </div>
                        </div>
                    </div> --->
					<div class="form-group" id="item-origin">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62469.Origin'></label>
						<div class="col col-8 col-xs-12"> 
							<select name="origin">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1" <cfoutput>#get_conf.ORIGIN eq 1 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='62470.Ağacı kullanarak spekt yarat'></option>
								<option value="2" <cfoutput>#get_conf.ORIGIN eq 2 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='62471.Karma Koliyi yeniden düzenleyerek özelleştir'></option>
								<option value="3" <cfoutput>#get_conf.ORIGIN eq 3 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='65197.Tanımları kullanarak spekt yarat'></option>
								<option value="4" <cfoutput>#get_conf.ORIGIN eq 4 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='65198.Özel Widget kullanarak spect yarat'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true" style="margin-top:20px;">
				<div class="form-group" id="item-product_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62472.Konfigüratör Widget'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="widget_id" id="widget_id" value="<cfoutput>#get_conf.WIDGET_ID#</cfoutput>">
							<input type="text" name="widget_friendly_name" id="widget_friendly_name" value="<cfoutput>#get_conf.WIDGET_TITLE##len(get_conf.WIDGET_FRIENDLY_NAME) ? " (" & get_conf.WIDGET_FRIENDLY_NAME & ")" : ""#</cfoutput>">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.popup_widget&field_id=add_product_configuration.widget_id&field_name=add_product_configuration.widget_friendly_name&widget_type=2');"></span>
						</div>
					</div>
				</div>
			<!--- 	<div class="form-group" id="item-startdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama girmelisiniz'></cfsavecontent>
							<cfif len(get_conf.start_date)>
								<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:150px;" value="#dateformat(get_conf.start_date,dateformat_style)#">
							<cfelse>
								<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:150px;" value="">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57739.Bitiş girmelisiniz Girmelisiniz'></cfsavecontent>
							<cfif len(get_conf.finish_date)>
								<cfinput validate="#validate_style#" message="#message1#" type="text" name="finishdate" style="width:150px;" value="#dateformat(get_conf.finish_date,dateformat_style)#">
							<cfelse>
								<cfinput validate="#validate_style#" message="#message1#" type="text" name="finishdate" style="width:150px;" value="">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div> --->
				<div class="form-group" id="item-configuration_detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
					<div class="col col-8 col-xs-12"> 
						<textarea name="configuration_detail" id="configuration_detail" style="width:150px;height:45px;"><cfoutput>#get_conf.configurator_detail#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58029.İkon'>- <cf_get_lang dictionary_id='29762.İmaj'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file" style="width:200px;"></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="hidden" name="old_image_file" id="old_image_file" value="<cfoutput>#get_conf.path#</cfoutput>">
                        <cfoutput>#get_conf.path#</cfoutput></div>
                </div>
			</div>
			<!--- Form-Kalite --->
			<div class="row" style="margin-left:5px;">
				<div class="col col-12">
					<div class="ListContent">
						<cf_seperator id="form_quality" header="#getLang(dictionary_id: 65099)#">
							<div id="form_quality">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-is_active">
								<input type="checkbox" name="use_form" id="use_form" value="1" <cfif get_conf.use_form eq 1>checked</cfif>>
								<div class="col col-8 col-xs-12"> 
									<label class="bold"><cf_get_lang dictionary_id='65185.Konfigüratörde Kullan'></label>
								</div>
							</div>
							<div class="form-group" id="item-use_cat">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='65186.Kullanılan kategorilerin ID"lerini virgülle giriniz'></label>
								<div class="col col-4 col-xs-12"> 
										<input type="text" name="use_cat_ids" id="use_cat_ids" value="<cfoutput>#get_conf.use_cat_ids#</cfoutput>">
								</div>
							</div>
							<div class="form-group" id="item-use_cat">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='65187.Kullanılan kalite tanımlarının ID"lerini virgülle giriniz'></label>
								<div class="col col-4 col-xs-12"> 
										<input type="text" name="use_quality_ids" id="use_quality_ids" value="<cfoutput>#get_conf.use_quality_ids#</cfoutput>">
								</div>
							</div>
						</div>
						</div>
					</div>
				</div>
			</div>
			<!--- //Form-Kalite --->
			<!--- Bileşen --->
			<div class="row" style="margin-left:5px;">
				<div class="col col-12">
					<div class="ListContent">
						<cfquery name="get_tree_types" datasource="#dsn#">
							SELECT TYPE_ID,
							#dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
							  FROM PRODUCT_TREE_TYPE
						</cfquery>
						<cf_seperator id="form_component" header="#getLang(dictionary_id: 63535)#">
							<div id="form_component">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-is_active">
									<div class="col col-8 col-xs-12"> 
										<input type="checkbox" name="use_component" id="use_component" value="1" <cfif get_conf.use_component eq 1>checked</cfif>>
										<label class="bold"><cf_get_lang dictionary_id='65185.Konfigüratörde Kullan'></label>
									</div>
								</div>
								<div class="form-group" id="form_ul_tree_types">
									<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='65188.Kullanılan Bileşen Tip'></label>
									<div class="col col-4 col-xs-12">
										<input type="text" name="tree_types" id="tree_types" value="<cfoutput>#get_conf.tree_types#</cfoutput>">
									</div>
								</div>
								<div class="form-group" id="item-use_cat">
									<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='65190.Kullanılan Ürün ID"lerini virgülle giriniz'></label>
									<div class="col col-4 col-xs-12"> 
											<input type="text" name="use_product_ids" id="use_product_ids" value="<cfoutput>#get_conf.use_product_ids#</cfoutput>">
									</div>
								</div>
							<div class="form-group" id="item-use_cat">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='65189.Kullanılan Operasyonların ID"lerini virgülle giriniz'></label>
								<div class="col col-4 col-xs-12"> 
										<input type="text" name="use_operation_ids" id="use_operation_ids" value="<cfoutput>#get_conf.use_operation_ids#</cfoutput>">
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true" style="margin-top:20px;">
							<div class="form-group" id="item-is_active">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65191.En Kullan'></label>
								<div class="col col-8 col-xs-12"> 
									<input type="checkbox" name="use_width" id="use_width" value="1" <cfif get_conf.use_width eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-is_active">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65192.Boy Kullan'></label>
								<div class="col col-8 col-xs-12"> 
									<input type="checkbox" name="use_size" id="use_size" value="1" <cfif get_conf.use_size eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-is_active">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65193.Yükseklik kullan'></label>
								<div class="col col-8 col-xs-12"> 
									<input type="checkbox" name="use_height" id="use_height" value="1" <cfif get_conf.use_height eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-is_active">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65194.Kalınlık Kullan'></label>
								<div class="col col-8 col-xs-12"> 
									<input type="checkbox" name="use_thickness" id="use_thickness" value="1" <cfif get_conf.use_thickness eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-is_active">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65195.Fire Kullan'></label>
								<div class="col col-8 col-xs-12"> 
									<input type="checkbox" name="use_fire" id="use_fire" value="1" <cfif get_conf.use_thickness eq 1>checked</cfif>>
								</div>
							</div>
						</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
			<div class="row">
				<div class="col col-12">
					<div class="ListContent">
						<cf_seperator id="form_price" header="#getLang(dictionary_id: 65196)#">
							<div id="form_price">
								<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-is_active">
									<div class="col col-12 col-xs-12"> 
										<input type="checkbox" name="use_feature" id="use_feature" value="1" <cfif get_conf.use_feature eq 1>checked</cfif>>
										<label class="bold"><cf_get_lang dictionary_id='65185.Konfigüratörde Kullan'></label>
									</div>
								</div>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div id="configurator_save_divid"></div>
							<div id="configurator_save_divid2"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--- //Bileşen --->
			<div class="row">
				<div class="col col-12">
					<div class="ListContent">
						<cf_seperator id="config_test" header="#getLang(dictionary_id: 62473)#">
						<div id="config_test">
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-is_active">
								<div class="col col-12 col-xs-12"> 
									<input type="checkbox" name="use_test_parameter" id="use_test_parameter" value="1" <cfif get_conf.use_test_parameter eq 1>checked</cfif>>
									<label class="bold"><cf_get_lang dictionary_id='65185.Konfigüratörde Kullan'></label>
								</div>
							</div>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div id="configurator_save_divid3">
							</div>
						</div>
						</div>
					</div>
				</div>
			</div>
			<cf_box_footer>	
				<div class="col col-6"><cf_record_info query_name="get_conf"></div> 
				<div class="col col-6"><cf_workcube_buttons is_upd = '1' is_delete='0' add_function='configurator_save()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_configurator&product_configurator_id=#attributes.id#</cfoutput>','configurator_save_divid','1',"Bekleyiniz!");			
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_formula_row&product_configurator_id=#attributes.id#</cfoutput>','configurator_save_divid2','1',"Bekleyiniz!");
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_test_parameter&product_configurator_id=#attributes.id#</cfoutput>','configurator_save_divid3','1',"Bekleyiniz!");			
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
			alert("<cf_get_lang dictionary_id='62721.Ürün, kategori ya da marka alanlarından sadece birini doldurunuz'>!");
			return false;
		}
		if(document.add_product_configuration.configuration_detail.value == '')
		{
			alert("<cf_get_lang dictionary_id='56660.Lütfen Açıklama Giriniz'>!");
			return false;
		}
		for(r=1;r<=add_product_configuration.record_num.value;r++)
		{
			if(eval("document.add_product_configuration.row_control"+r).value == 1)
			{
				if(eval("document.add_product_configuration.property_id"+r).value == '' || eval("document.add_product_configuration.property"+r).value == '')
				{
					alert("<cf_get_lang dictionary_id='58201.Lütfen Özellik Seçiniz'> !");
					return false;
				}
				if(eval("document.add_product_configuration.price_type"+r).value == 3)
				{ 
					if(eval("document.add_product_configuration.property_id_row"+r).value == '' || eval("document.add_product_configuration.property_row"+r).value == '')
					{
						alert("<cf_get_lang dictionary_id='60517.Fiyat Kriteri Özellik İse Satırda Ek Özellik Seçmelisiniz'> !");
						return false;
					}
				}
			}
		}
		if( add_product_configuration.testParameterCount.value != '' && parseInt(add_product_configuration.testParameterCount.value) > 0 ){
			for(r=1;r<=add_product_configuration.testParameterCount.value;r++){
				if( $("#type_id"+r+"") != "undefined" && $("#type_id"+r+"").length != 0 ){
					if(eval("document.add_product_configuration.type_id"+r).value == '' || eval("document.add_product_configuration.quality_control_type"+r).value == ''){
						alert("<cf_get_lang dictionary_id='29785.Lütfen Tip Seçiniz'>!");
						return false;
					}
					if(eval("document.add_product_configuration.standart_value"+r).value == ''){
						alert("<cf_get_lang dictionary_id='62474.Lütfen standart değer giriniz'>!");
						return false;
					}
					if(eval("document.add_product_configuration.quality_measure"+r).value == ''){
						alert("<cf_get_lang dictionary_id='62475.Lütfen ölçü giriniz'>!");
						return false;
					}
					if(eval("document.add_product_configuration.tolerance"+r).value == ''){
						alert("<cf_get_lang dictionary_id='62476.Lütfen tolerans giriniz'>!");
						return false;
					}
				}
			}
		}
		unformat_fields();
		return true;
	}

	function unformat_fields()
    {
        if( add_product_configuration.testParameterCount.value != '' && parseInt(add_product_configuration.testParameterCount.value) > 0 ){
            for (i = 1; i <= parseInt(add_product_configuration.testParameterCount.value); i++) {
                if( $("#type_id"+i+"") != "undefined" && $("#type_id"+i+"").length != 0 ){
					if( $("#standart_value"+i+"") != 'undefined' && $("#standart_value"+i+"").val() != '' ) $("#standart_value"+i+"").val( filterNum( $("#standart_value"+i+"").val() ) );
					if( $("#quality_measure"+i+"") != 'undefined' && $("#quality_measure"+i+"").val() != '' ) $("#quality_measure"+i+"").val( filterNum( $("#quality_measure"+i+"").val() ) );
					if( $("#tolerance"+i+"") != 'undefined' && $("#tolerance"+i+"").val() != '' ) $("#tolerance"+i+"").val( filterNum( $("#tolerance"+i+"").val() ) );
				}
            }
        }
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