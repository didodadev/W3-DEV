<cfprocessingdirective pageEncoding="utf8">
<link rel="stylesheet" href="/AddOns/AFM/assets/css/_bootstrap4.css">
<script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
<cfinclude template="../query/afm_install_wizard.cfm">
<div class="row">
    <div class="col-xl-4 col-md-12 col-sm-12 col-4">
        <cf_box title="Ayarlar" closable="0" collapsable="0" name="install">
            <div class="ui-form-list ui-form-block row">
                <div class="col col-xs-12 col-md-4">
                    <div class="form-group">
                        <label>Ürünlerin Muhasebe Kodunu Seçiniz : </label> <!--- Buradan dönecek olan kodları informixte sorgulatıp değerleri depolara yazılacak ---> 
                        <select name="location" id="acc_code_id">
                            <cfoutput query="GET_CODES">
                                <option value="#PRO_CODE_CATID#">#PRO_CODE_CAT_NAME#</option>
                            </cfoutput>
                        </select> 
                    </div>
                </div>
                <div class="col col-xs-12 col-md-4">
                    <div class="form-group">
                        <label for="location">Hangi Kategoriye Aktarılacağını Seçiniz : </label>
                        <select name="location" id="department_location">
                            <cfoutput query="Get_ProductCat">
                                <option value="#PRODUCT_CATID#">#PRODUCT_CAT#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=afm.popup_catalog','medium');" class="ui-btn ui-btn-green">Ürün Kataloğu</a></cfoutput>
        </cf_box>
    </div>
    <cf_box title="Kurulum Sihirbazı" box_page="#request.self#?fuseaction=objects.emptypopup_product_integration">
    </cf_box>
</div>
