<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Menkul Kıymetler Güncel Değer Aktarım','60615')#" closable="0">
            <cfform name="formimport" id="formimport" action="#request.self#?fuseaction=settings.emptypopup_form_add_stockbonds_value_import" enctype="multipart/form-data" method="post">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format" >
                                    <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                                </select>
                            </div>
                        </div>   
                        <div class="form-group" id="item-uploaded_file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                    <input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>                        
                        <div class="form-group" id="item-download-link">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                    <a href="/documents/settings/mk_value_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                            </div>
                        </div>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
                            </div>
                        <div class="form-group" id="item-exp2">
                            <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 6
                        </div>
                        <div class="form-group" id="item-exp3">
                            <cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>;
                        </div>
                        <div class="form-group" id="item-exp4">
                            1-<cf_get_lang dictionary_id='51415.M.Kıymet Tipi'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                            2-<cf_get_lang dictionary_id='51413.Güncel Değer'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                            3-<cf_get_lang dictionary_id='51414.Güncel Değer Döviz'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'>: 1.000<br/>
                            4-<cf_get_lang dictionary_id='33562.Güncel Değer Tarihi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 23.03.2020<br/>
                            5-<cf_get_lang dictionary_id='30636.İşlem Para Birimi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : TL<br/>
                            6-<cf_get_lang dictionary_id='30636.İşlem Para Birimi'><cf_get_lang dictionary_id='30635.İşlem Para Birimi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'>  : TL<br/>
                        </div>                        
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                 <cf_workcube_buttons is_upd='0'>
                </cf_box_footer>  
            </cfform>
    </cf_box>
</div>

