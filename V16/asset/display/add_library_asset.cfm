<cfquery name="DEP" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('asset',100)# #getLang('main',170)#" popup_box="1">
        <cfform name="add_asset_care" action="#request.self#?fuseaction=asset.emptypopup_add_lib_asset" method="post" enctype="multipart/form-data">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-asset_barcode">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47699.Barkod No'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='54667.Lütfen Barkod No Giriniz'></cfsavecontent>
                            <cfinput type="text" name="asset_barcode" maxlength="100" required="yes" message="#message1#">
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_barcode">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="file" name="image_path" id="image_path" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30031.Lokasyon'>* </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="department_id" id="department_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="dep">
                                    <option value="#department_id#">#branch_name# / #department_head# </option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47793.Kitap Adı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='47793.Kitap Adı'></cfsavecontent>
                            <cfinput type="text" name="lib_asset_name" id="lib_asset_name" value="" required="yes" message="#message#" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_turn">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47772.Çeviren'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="asset_turn" id="asset_turn" value="" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-library_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrk_combo
                            name="lib_asset_cat"
                            query_name="LIB_CAT"
                            option_name="library_cat"
                            option_value="library_cat_id"
                            width="120">		
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea style="width:200;height:165" name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-lib_asset_content">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57653.İçerik'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="lib_asset_content" id="lib_asset_content" value="" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_pub">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47686.Yayın Evi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="lib_asset_pub" id="lib_asset_pub" value="" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47691.Yayın Yılı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message3"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                            <cfinput type="text" name="pub_date" id="pub_date" value="" validate="integer" message="#message3#" range="1000,9999" maxlength="4" onKeyUp="isNumber(this)">
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_place">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47738.Yayın Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="pub_place" id="pub_place" value="" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-writer">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47687.Yazar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="writer" id="writer" value="" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-press">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47692.Baskı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="press" value="" maxlength="4" validate="integer" message="#getLang('','	Baskı Sayısal Olmalıdır','47847')#">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		
        x = document.add_asset_care.department_id.selectedIndex;
	if (document.add_asset_care.department_id[x].value == "")
		{ 
		alert ("<cf_get_lang dictionary_id='57471.eksik veri'>: <cf_get_lang dictionary_id='30031.Lokasyon'>!");
		return false;
		}
	x = document.add_asset_care.lib_asset_cat.selectedIndex;
	if (document.add_asset_care.lib_asset_cat[x].value == "")
		{ 
		alert ("<cf_get_lang dictionary_id='57471.eksik veri'>: <cf_get_lang dictionary_id='57486.Kategori'> !");
		return false;
		}
	
	return true;
	}
</script>
