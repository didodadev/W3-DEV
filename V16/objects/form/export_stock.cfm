<cfparam name="attributes.product_cat_id" default="">
<cfif isdefined("attributes.is_branch")>
	<cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')>
	<cfquery name="PRICE_CAT" datasource="#DSN3#">
		SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND BRANCH LIKE '%,#attributes.branch_id#,%' ORDER BY PRICE_CAT
	</cfquery>
<cfelse>
	<!--- Sube ilisikisi olan fiyat listeleri gelecek --->
	<cfquery name="PRICE_CATS" datasource="#DSN3#">
		SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND LEN(BRANCH) > 2  ORDER BY PRICE_CAT
	</cfquery>
</cfif>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32849.Stok Export Belgesi Oluştur'></cfsavecontent>
	<cf_box title="#message#">
		<cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.popupflush_export_stock">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-target_pos">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'></label>
						<div class="col col-8 col-sm-12">
							<select name="target_pos" id="target_pos" style="width:150px;" onchange="type_change()">
								<option value="-1"><cf_get_lang dictionary_id='45932.Genius'></option>
								<option value="-2">Inter</option>
								<option value="-3">N C R</option>
								<option value="-5">N C R - AS@R</option>
								<option value="-6">ESPOS</option>						
								<option value="-4">Workcube</option>
								<option value="-7"><cf_get_lang dictionary_id='45932.Genius'> 2</option>
								<option value="-8">Wincor Nixdorf</option>
							</select>
						</div>
					</div>	
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-product_cat_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="product_cat_id" id="product_cat_id" value="">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='33281.Kategori Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="product_cat" value="" readonly="yes" message="#message#" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_code=formexport.product_cat_id&field_name=formexport.product_cat</cfoutput>&is_sub_category=1','popup_product_cat_names');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang dictionary_id='33118.Ürün Kategorisi Ekle'>" align="middle"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-product_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" value="">
								<input type="hidden" name="stock_id" id="stock_id" value="">
								<input type="text" name="product_name" id="product_name" value="" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','2','200');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=formexport.stock_id&product_id=formexport.product_id&field_name=formexport.product_name','list','popup_product_names');"><img src="/images/plus_thin.gif" border="0"  align="absmiddle"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-company">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="">
								<input type="text" name="company" id="company" value="" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=formexport.company&field_comp_id=formexport.company_id&select_list=2','list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-brand_name">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="brand_id" id="brand_id">
								<input type="text" name="brand_name" id="brand_name" value="" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=formexport.brand_id&brand_name=formexport.brand_name</cfoutput>','list','popup_product_brands');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-department_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfif isdefined("attributes.is_branch")>
									<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#listgetat(session.ep.user_location, 1, '-')#</cfoutput>">
								<cfelse>
									<input type="hidden" name="department_id" id="department_id" value="">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='30126.Şube Seçiniz'>!</cfsavecontent>
									<cfinput type="text" name="department" value="" readonly="yes" message="#message#" style="width:150px;">
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=formexport&field_name=department&field_id=department_id</cfoutput>','list','popup_list_stores_locations');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_recorddate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32853.Ürün Kayıt Tarihi'> (<cf_get_lang dictionary_id='32854.den büyük'>)</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32867.Ürün Kayıt Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" message="#message#" validate="#validate_style#" name="product_recorddate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="product_recorddate"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-price_recorddate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32860.Fiyat Kayıt Tarihi'> (<cf_get_lang dictionary_id='32854.den büyük'>)</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32868.Fiyat Geçerlilik Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" message="#message#" validate="#validate_style#" name="price_recorddate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="price_recorddate"></span>
							</div>
						</div>
					</div>		
					<div class="form-group" id="item-price_recorddate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32869.İndirim Grubu'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="indirim_grubu" id="indirim_grubu" maxlength="8" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-price_catid">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.is_branch")>
								<select name="price_catid" id="price_catid" style="width:150px;">
									<!---<option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>--->
									<cfoutput query="price_cat">
										<option value="#price_catid#">#price_cat#</option>
									</cfoutput>
								</select>
							<cfelse>
								<select name="price_catid" id="price_catid" style="width:150px;">
									<!---<option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>--->
									<cfoutput query="price_cats">
										<option value="#price_catid#">#price_cat#</option>
									</cfoutput>
								</select>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-is_pricecat_control">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32852.Fiyat Listesine Göre Promosyonları Getir'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_pricecat_control" id="is_pricecat_control" value="1" style="margin-left:-3px;">
						</div>
					</div>	
					<div class="form-group" id="item-is_phl">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='33684.PHL İçin Sadece Tedarik Edilenleri Getir'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_phl" id="is_phl" value="1" style="margin-left:-3px;">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true" style="display:none">
					<div class="form-group" id="item-is_insert">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='33834.Yeni Eklenenler'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_insert" id="is_insert" value="1">
						</div>
					</div>
					<div class="form-group" id="item-is_phl">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='33835.Güncellenenler'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_update" id="is_update" value="1">
						</div>
					</div>
					<div class="form-group" id="item-destination_company_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="destination_company_id" id="destination_company_id" value="">
								<input type="text" name="destination_company_name" id="destination_company_name" value="" readonly style="width:150px;">
								<span class="input-group-addon ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=formexport.destination_company_id&field_comp_name=formexport.destination_company_name&select_list=2,6','list','popup_list_pars')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
							</div>
						</div>
					</div>
				</div>	
			</cf_box_elements>
			<cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='form_chk()'>
            </cf_box_footer>
		</cfform>
	</cf_box>
</div>


<script type="text/javascript">
function type_change()
{
	if(document.formexport.target_pos.value=='-4')
		type_workcube.style.display='';
	else
	{
		type_workcube.style.display='none';
		document.formexport.is_insert.checked=false;
		document.formexport.is_update.checked=false;
		document.formexport.is_update.checked=false;
		document.formexport.destination_company_id.value='';
		document.formexport.destination_company_name.value='';
	}
}
function form_chk()
{
	if(document.formexport.target_pos.value!='-4')
		if(document.formexport.department_id.value =="") 
		{
			alert("<cf_get_lang dictionary_id='32870.Stokları Hangi Şube İçin Alacağınızı Seçmediniz'> !");
			return false;
		}
	return process_cat_control();
}
</script>
