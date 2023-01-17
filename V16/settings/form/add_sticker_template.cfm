<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='42541.Etiket Şablonu Ekle'></cfsavecontent>
    <cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_sticker_template" is_blank="0">
        <div class="col col-2 col-md-3 col-sm-3 col-xs-12">
            <div class="scrollbar" style="max-height:403px;overflow:auto;">
                <div id="cc">
                    <cfinclude template="../display/list_sticker_template.cfm">
                </div>
            </div>
        </div>
        <cfform action="#request.self#?fuseaction=settings.popup_add_sticker_template" method="post" name="asset_cat">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42542.Etiket Tür Adı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="Text" name="sticker_name" value="" maxlength="50" required="Yes" message="#getLang('','Etiket Tür Adı girmelisiniz',42281)#">
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='29793.Dikey'></label>
                        </div>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='29794.Yatay'></label>
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42543.Etiket Sayısı'></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42282.Etiket Sayısı girmelisiniz'></cfsavecontent>
                            <cfinput name="ROW_NUMBER" type="text" maxlength="2" validate="integer" message="#message#">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42282.Etiket Sayısı girmelisiniz'></cfsavecontent>
                            <cfinput name="COLUMN_NUMBER" type="text" maxlength="2" validate="integer" message="#message#">
                            
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='58082.adet'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42544.Etiket boyutları'></label>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput name="STICKER_LENGTH" type="text">
                        </div>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput name="STICKER_WIDTH" type="text">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='42549.mm'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57603.Aralık'></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="VERTICAL_GAP" type="text" >
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="HORIZONTAL_GAP" type="text">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='42549.mm'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43284.Sayfa Genişliği'></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_HEIGHT" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Yüksekliğini Giriniz',43285)#">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_WIDTH" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Genişiğini Giriniz',43286)#">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='42549.mm'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='43287.Sayfa Başı'></label>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='43288.Sayfa Sonu'></label>
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43289.Sayfa Boşluğu'></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_TOP_BLANK" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Başı Boşluğunu Giriniz',43290)#">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_FOT_BLANK" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Sonu Boşluğunu Giriniz',43294)#">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='42549.mm'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='43291.Sağ'></label>
                        </div>
                        <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                            <label style="text-align:center;"><cf_get_lang dictionary_id='43292.Sol'></label>
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43289.Sayfa Boşluğu'></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_RIGHT_BLANK" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Başı Boşluğunu Giriniz',43290)#">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                            <cfinput name="PAGE_LEFT_BLANK" type="text" maxlength="3" validate="integer" message="#getLang('','Sayfa Sonu Boşluğunu Giriniz',43294)#">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                            (<cf_get_lang dictionary_id='42549.mm'>)
                        </div>
                    </div>
                    <div class="form-group" id="block_group_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43893.Yetkili Görünsün'></label>
                        <div class="col col-4 col-md-8 col-sm-8 col-xs-12"> 
                            <input name="partner" id="partner" type="checkbox" value="1">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
