<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Seri No Import',58523)#">
        <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_seri_no">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55926.File Format'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Turkish)'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Document'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">        
                        </div>
                    </div>
                    <div class="form-group" id="item-download_link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/seri_no_mport.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>                        
                        </div>
                    </div>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>
                    <div class="form-group" id="item-exp1">
                        <label><b><cf_get_lang dictionary_id='44147.Dosya İçeriği'></b></label>
                    </div>
                    <div class="form-group" id="item-exp2">
                        *<cf_get_lang dictionary_id='44153.Must be Comma Delimited Text File (.txt)'>
                    </div>
                    <div class="form-group" id="item-exp3">
                        <label><b><cf_get_lang dictionary_id='44148.Elements Order'></b></label>
                    </div>
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='57637.Serial No.'></br>
                        2-<cf_get_lang dictionary_id='45498.Lot No.'></br>
                        3-<cf_get_lang dictionary_id='58794.Reference No.'></br>
                        4-<cf_get_lang dictionary_id='57518.Inventory Code'>(<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                        5-<cf_get_lang dictionary_id='44943.Warehouse ID'>(<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                        6-<cf_get_lang dictionary_id='30031.Lokasyon'><cf_get_lang dictionary_id='58527.ID'>(<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                        7-<cf_get_lang dictionary_id='44944.Alış Garanti Kategorisi Id'>(<cf_get_lang dictionary_id='29801.Mandatory'>) ---> (<cf_get_lang dictionary_id='44945.Sisteme alınacak serilerin kategorisi'>)</br>
                        8-<cf_get_lang dictionary_id='44151.Garanti Başlama Tarihi'> - gg/aa/yyyy (<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                        9-<cf_get_lang dictionary_id='44152.Garanti Bitiş Tarihi'> - gg/aa/yyyy (<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                        10-<cf_get_lang dictionary_id='64258.Birim Miktarı'>  (<cf_get_lang dictionary_id='29801.Mandatory'>)</br>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
