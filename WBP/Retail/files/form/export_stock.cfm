<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.modal_id" default="">

<cfquery name="get_depts" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_ID, 
		D.DEPARTMENT_HEAD
	FROM 
		BRANCH B,
        DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.BRANCH_ID = B.BRANCH_ID AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
        D.DEPARTMENT_HEAD
</cfquery>

<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="formexport" title="#getLang('','Yazar Kasa Bilgi Hazırlama',61830)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="formexport" method="post" action="#request.self#?fuseaction=retail.emptypopup_export_stock">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-target_pos" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'></label>
						<div class="col col-8 col-sm-12">
							<select name="target_pos" id="target_pos" style="width:150px;">
								<option value="-1"><cf_get_lang dictionary_id='45932.Genius'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_all" >
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61886.Bilgi İçeriği'></label>
						<div class="col col-8 col-sm-12">
							<select name="is_all">
								<option value="0"><cf_get_lang dictionary_id='61887.Sadece Değişenler'></option>
								<option value="1"><cf_get_lang dictionary_id='51733.Tüm Kayıtlar'></option>
							</select>
						</div>
					</div>
					<!---<div class="form-group" id="item-process" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>--->
					<div class="form-group" id="item-product_cat_id" >
						<label class="col col-4 col-sm-12">Ürün Kategorisi</label>
						<div class="col col-8 col-sm-12">
							<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
								SELECT 
									PRODUCT_CAT.PRODUCT_CATID, 
									PRODUCT_CAT.HIERARCHY, 
									PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
								FROM 
									PRODUCT_CAT,
									PRODUCT_CAT_OUR_COMPANY PCO
								WHERE 
									PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
									PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
									PRODUCT_CAT.HIERARCHY NOT LIKE '%.%'
								ORDER BY 
									HIERARCHY ASC
							</cfquery>
							<cf_multiselect_check 
									query_name="GET_PRODUCT_CAT"
									selected_text="" 
									name="product_cat_id"
									option_text="#getLang('','Ana Grup',61641)#" 
									width="250"
									height="250"
									option_name="PRODUCT_CAT_NEW" 
									option_value="HIERARCHY"
									value="#attributes.product_cat_id#">
						</div>
					</div>
					<div class="form-group" id="item-product_id" style="<cfif session.ep.username is 'admin1' or session.ep.username is 'emrah'><cfelse>display:none;</cfif>">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='44019.Ürün'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cf_wrk_products form_name = 'formexport' product_name='product_name' product_id='product_id' stock_id='stock_id'>
								<input type="hidden" name="product_id" id="product_id" value="">
								<input type="hidden" name="stock_id" id="stock_id" value="">
								<input type="text" name="product_name" id="product_name" value="" style="width:150px;" onKeyUp="get_product();" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=formexport.stock_id&product_id=formexport.product_id&field_name=formexport.product_name');"></span>
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products</cfoutput>','list');"><i class="fa fa-plus"  align="absmiddle"></i></a>
							</div>
						</div>
					</div>
					<div id="product_div2"></div>
					<div class="form-group" id="item-barcode" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="barcode" id="barcode" value="" style="width:150px;" autocomplete="off">
						</div>
					</div>
					<div class="form-group" id="item-company" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="">
								<input type="text" name="company" id="company" value="" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=formexport.company&field_comp_id=formexport.company_id&select_list=2');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-brand_name" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="brand_id" id="brand_id">
								<input type="text" name="brand_name" id="brand_name" value="" style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=formexport.brand_id&brand_name=formexport.brand_name</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-price_catid" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
						<div class="col col-8 col-sm-12">
							<select name="price_catid" id="price_catid" style="width:150px;">
								<option value="-3"><cf_get_lang dictionary_id='61888.Şubeye Tanımlı Fiyat'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-department_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-sm-12">
							<select name="department_id" id="department_id">
								<cfoutput query="get_depts">
									<option value="#department_id#">#department_Head#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-product_startdate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61889.İlk Tarih'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32867.Ürün Kayıt Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" message="#message#" validate="eurodate" required="yes" value="#dateformat(dateadd('d',-1,now()),'dd/mm/yyyy')#" name="product_startdate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="product_startdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_finishdate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61890.Son Tarih'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfif session.ep.admin or session.ep.userid eq 3>
									<cfinput type="text" name="product_finishdate" maxlength="10" value="#dateformat(now(),'dd/mm/yyyy')#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="product_finishdate"></span>
								<cfelse>
								<cfinput type="text" name="product_finishdate" maxlength="10" value="#dateformat(now(),'dd/mm/yyyy')#" style="width:65px;" readonly="yes">				
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-price_recorddate" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61891.Fiyat Kayıt Tarihi (den büyük)'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='478.Fiyat Geçerlilik Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" message="#message#" validate="eurodate" name="price_recorddate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="price_recorddate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-indirim_grubu" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32869.İndirim Grubu'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="indirim_grubu" id="indirim_grubu" maxlength="8" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-destination_company_id" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='49909.Kurumsal Üye'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="destination_company_id" id="destination_company_id" value="">
								<input type="text" name="destination_company_name" id="destination_company_name" value="" readonly style="width:150px;">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=formexport.destination_company_id&field_comp_name=formexport.destination_company_name&select_list=2,6')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-12 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_phl" style="display:none;">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='33684.PHL İçin Sadece Tedarik Edilenleri Getir'><input type="checkbox" name="is_phl" id="is_phl" value="1" style="margin-left:-3px;">
                        </label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_pricecat_control" style="display:none;">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cf_get_lang dictionary_id='32852.Fiyat Listesine Göre Promosyonları Getir'><input type="checkbox" name="is_pricecat_control" id="is_pricecat_control" value="1" style="margin-left:-3px;">
                        </label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_insert" style="display:none;">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cf_get_lang dictionary_id='33834.Yeni Eklenenler'><input type="checkbox" name="is_insert" id="is_insert" value="1">
                        </label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_update" style="display:none;">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cf_get_lang dictionary_id='33835.Güncellenenler'><input type="checkbox" name="is_update" id="is_update" value="1">
                        </label>
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
function add_row(pid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + pid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + pid_ +')">';
	icerik_ += '<i class="fa fa-minus"></i>';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_product_id" value="' + pid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';

	$('#product_div2').append(icerik_);
}

function del_row_p(pid_)
{
	$("#selected_product_" + pid_).remove();	
}

function form_chk()
{
	if(document.formexport.department_id.value =="") 
	{
		alert("Stokları Hangi Şube İçin Alacağınızı Seçmediniz!");
		return false;
	}
	return process_cat_control();

	<cfif isdefined("attributes.draggable")>loadPopupBox('formexport' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
}
</script>