<!--- Tum alanlar cekildigi icin duzenlenmedi --->
<cfquery name="GET_LIB_ASSET" datasource="#DSN#">
	SELECT * FROM LIBRARY_ASSET WHERE LIB_ASSET_ID =#attributes.lib_asset_id#
</cfquery>
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
    <cf_box title="#getLang('asset',100)# #getLang('main',52)#" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=asset.library&event=add')" popup_box="1">
        <cfform name="upd_asset_care" action="#request.self#?fuseaction=asset.emptypopup_upd_lib_asset" method="post" enctype="multipart/form-data">
            <input type="hidden" name="lib_asset_id" id="lib_asset_id" value="<cfoutput>#get_lib_asset.lib_asset_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-asset_barcode">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47699.Barkod No'> *</label>
                        <cfsavecontent variable="messageb"><cf_get_lang dictionary_id="54671.Lütfen Barcod No Giriniz"></cfsavecontent>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="asset_barcode" maxlength="100" required="yes" message="#messageb#" value="#get_lib_asset.barcode_no#">
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_barcode">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="old_icon" id="old_icon" value="<cfoutput>#get_lib_asset.image_path#</cfoutput>">
                                <cfinput type="file" name="image_path" id="image_path" value="">
                                <span class="input-group-addon" href="javascript://" onClick="windowopen('<cfoutput>#file_web_path#asset/#get_lib_asset.image_path#</cfoutput> ','medium');"><i class="fa fa-image"></i></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_systemno">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="asset_systemno" id="asset_systemno" maxlength="100" value="<cfoutput>#get_lib_asset.system_no#</cfoutput>" readonly="">
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47793.Kitap Adı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='47793.Kitap Adı'></cfsavecontent>
                            <cfinput type="text" name="lib_asset_name" value="#get_lib_asset.lib_asset_name#" required="yes" message="#message#" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30031.Lokasyon'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="department_id" id="department_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="dep">
                                    <option value="#department_id#" <cfif get_lib_asset.department_id eq department_id>selected</cfif>>#branch_name# / #department_head#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrk_combo
                            name="lib_asset_cat"
                            query_name="LIB_CAT"
                            option_name="library_cat"
                            option_value="library_cat_id"
                            value="#get_lib_asset.lib_asset_cat#"
                            width="120">
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_turn">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47772.Çeviren'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="asset_turn" id="asset_turn" maxlength="100" value="<cfif len(get_lib_asset.asset_turn)><cfoutput>#get_lib_asset.asset_turn#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_content">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57653.İçerik'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="lib_asset_content" id="lib_asset_content" maxlength="100" value="<cfif len(get_lib_asset.lib_asset_content)><cfoutput>#get_lib_asset.lib_asset_content#</cfoutput></cfif>">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea style="width:200;height:145" name="detail" id="detail"><cfif len(get_lib_asset.detail)><cfoutput>#get_lib_asset.detail#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-lib_asset_pub">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47686.Yayın Evi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="lib_asset_pub" id="lib_asset_pub" maxlength="100" value="<cfif len(get_lib_asset.lib_asset_pub)><cfoutput>#get_lib_asset.lib_asset_pub#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47691.Yayın Yılı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message3"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                            <cfinput type="text" name="pub_date" id="pub_date" value="#get_lib_asset.pub_date#" validate="integer" message="#message3#" range="1000,9999" maxlength="4" onKeyUp="isNumber(this)">
                        </div>
                    </div>
                    <div class="form-group" id="item-pub_place">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47738.Yayın Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="pub_place" id="pub_place" value="<cfif len(get_lib_asset.pub_place)><cfoutput>#get_lib_asset.pub_place#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-writer">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47687.Yazar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" maxlength="100" name="writer" id="writer" value="<cfif len(get_lib_asset.writer)><cfoutput>#get_lib_asset.writer#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-press">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47692.Baskı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message2"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='47692.Baskı'></cfsavecontent>
                            <cfinput type="text" name="press" value="#get_lib_asset.press#" validate="integer" message="#message2#" maxlength="4">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_lib_asset">
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=asset.emptypopup_del_lib_asset&lib_asset_id=#get_lib_asset.lib_asset_id#&head=#get_lib_asset.lib_asset_name#' add_function='kontrol()' type_format='1'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
    x = document.upd_asset_care.department_id.selectedIndex;
	if (document.upd_asset_care.department_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57471.eksik veri'>: <cf_get_lang dictionary_id='30031.Lokasyon'>!");
		return false;
	}
	x = document.upd_asset_care.lib_asset_cat.selectedIndex;
	if (document.upd_asset_care.lib_asset_cat[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57486.Kategori'> !");
		return false;
	}
	
}
</script>
