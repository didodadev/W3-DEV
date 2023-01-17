<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61528.Fatura - Dönemsel Bağlantı Görüntüleme'></cfsavecontent>
    <cf_box title="#head#">
        <cfform name="form_basket" action="" method="post">
            <cf_box_elements>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="place"><cf_get_lang dictionary_id='58133.Fatura No'></cfsavecontent>
                        <cfinput type="text" name="invoice_number" value="" required="yes" message="Fatura No Girmelisiniz!" style="width:175px;">
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='61538.Fatura Bağlantılarını Görüntüle'></cfsavecontent>
                <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' insert_alert='' insert_info='#message#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>