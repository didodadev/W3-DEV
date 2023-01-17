<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="POST" scroll="0">
        <cf_box_elements>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-title">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text">
                    </div>
                </div>
                <div class="form-group" id="item-campaign">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37304.İlişkili Kampanya'></label>
                    <div class="col col-8 col-sm-12">
                        <div class = "input-group">
                            <input type="text" />
                            <span class="input-group-addon icon-ellipsis"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-project">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34997.İlişkili Proje'></label>
                    <div class="col col-8 col-sm-12">
                        <div class = "input-group">
                            <input type="text" />
                            <span class="input-group-addon icon-ellipsis"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-link">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61438.Dönüş Linki'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" />
                    </div>
                </div>
                <div class="form-group" id="item-prepared">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29775.Hazırlayan'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" />
                    </div>
                </div>
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                    <div class="col col-8 col-sm-12">
                        <select>
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-release_date">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31639.Yayın Tarihi'></label>
                    <div class="col col-8 col-sm-12">
                        <div class = "input-group">
                            <input type="text">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-platforms">
                    <label class="col col-12 bold"><cf_get_lang dictionary_id='61439.Platformlar ve Hesaplar'></label>
                </div>
                <div class="form-group" id="item-face">
                    <label class="col col-12 bold">Facebook</label>
                </div>
                <div class="form-group" id="item-account">
                    <div class="col col-8 col-xs-12"> 
                        <input type="checkbox"><label>A <cf_get_lang dictionary_id='57652.Hesap'></label>
                    </div>
                </div> 
                <div class="form-group" id="item-account_2">
                    <div class="col col-8 col-xs-12"> 
                        <input type="checkbox"><label>B <cf_get_lang dictionary_id='57652.Hesap'></label>
                    </div>
                </div> 
                <div class="form-group" id="item-twitter">
                    <label class="col col-12 bold">Twitter</label>
                </div>
                <div class="form-group" id="item-account_3">
                    <div class="col col-8 col-xs-12"> 
                        <input type="checkbox"><label>C <cf_get_lang dictionary_id='57652.Hesap'></label>
                    </div>
                </div> 
                <div class="form-group" id="item-account_4">
                    <div class="col col-8 col-xs-12"> 
                        <input type="checkbox"><label>F <cf_get_lang dictionary_id='57652.Hesap'></label>
                    </div>
                </div> 
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
    </cf_box>
</div>