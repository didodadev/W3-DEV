<div class="aosdoc">
    <div class="col-xs-12 col-sm-5 col-5 float-left">
        <div class="form-group" style="box-shadow : 0px 1px 15px 1px rgba(39, 39, 39, 0.08);">
            <div class="form-group" id="aosMarka-group">
                <label for="aosMarka">Marka Seçiniz:</label>
                <select class="selectpicker aosMarka" name="aosMarka" id="aosMarka" data-width="100%" data-aosModel-seciniz-language="Model Seçiniz" data-live-search="true">
                    <option value=""> - </option>
                </select>
            </div>
            <div class="form-group" id="aosModel-group">
                <label for="aosModel">Model Seçiniz:</label>
                <select class="selectpicker aosModel" name="aosModel" id="aosModel" data-width="100%" data-aosYil-seciniz-language="Yıl Seçiniz" data-live-search="true">
                    <option value=""> - </option>
                </select>
            </div>
            <div class="form-group" id="aosYil-group">
                <label for="aosYil">Yıl Seçiniz:</label>
                <select class="selectpicker aosYil" name="aosYil" id="aosYil" data-width="100%" data-aosArac-seciniz-language="Araç Seçiniz" data-live-search="true">
                    <option value=""> - </option>
                </select>
            </div>
            <div class="form-group" id="aosArac-group">
                <label for="aosArac">Araç Seçiniz:</label>
                <select class="selectpicker aosArac" name="aosArac" id="aosArac" data-width="100%" data-show-subtext="true" data-live-search="true">
                    <option value=""> - </option>
                </select>
            </div>
            <div class="form-group" id="aosKategori-group">
                <label for="aosKategori">Kategori Seçiniz:</label>
                <select class="selectpicker aosKategori" name="aosKategori" id="aosKategori" data-width="100%" data-show-subtext="true" data-live-search="true">
                    <option value=""> - </option>
                </select>
            </div>
            <div class="col col-12 col-xl-12">
                <a class="ui-btn ui-btn-green" href="javascript://" id="searchPart" name="searchPart" onclick="SearchPart()">Ara</a>
            </div>
        </div>
    </div>
    <div class="col-xs-12 col-lg-5 col-7 form-group" style="height:372px;">
        <div class="col-xs-12 col-12" style="box-shadow : 0px 1px 15px 1px rgba(39, 39, 39, 0.08);height:100%;">
            <label>Parça Seçiniz</label>
            <input type="text" id="partFilter" onkeyup="PartFilter()" placeholder="Ürün Kodu Giriniz..." title="Bir parça kodu yazınız">
            <div class="col-xs-12 col-12" style="height:330px;overflow-y:scroll">
                <cf_grid_list>
                    <thead class="partListHead">
                        <th style="width:145px;">Ürün Adı</th>
                        <th style="width:145px">Ürün Kodu</th>
                        <th style="width:120px">Marka</th>
                        <th style="width:40px">Fiyat</th>
                        <th style="width:40px">Stok</th>
                        <th class="header_icn_none" width="40"><a href="javascript://"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                        </thead>
                    <tbody id="partList">
                        
                    </tbody>
                </cf_grid_list>			
            </div>
        </div>
    </div>
<script src="/AddOns/AFM/assets/JS/catalog/aosdocCatalog.js"></script>
