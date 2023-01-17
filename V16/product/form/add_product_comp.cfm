<cfparam  name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Fiyat Yetki Tanımları','37018')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_product_comp" action="#request.self#?fuseaction=product.emptypopup_add_product_comp" method="post" >
            <cf_box_elements>
                <cfinput type="hidden" name="modal_id" id="modal_id"  value="#attributes.modal_id#">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-PRO_COMP">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'>*</label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='60466.Lütfen Rekabet Tanımını Adlandırın'></cfsavecontent>
                            <cfinput type="Text" name="PRO_COMP" value="" required="yes" message="#message#" style="width:200px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="detail" id="detail" value=""></textarea>
                        </div>
                    </div>
                    <div class="form-group scrollContent scroll-x2" id="gizli">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37316.Sorumlular'></label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='37316.Sorumlular'></cfsavecontent>
                            <cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="add_product_comp" str_list_param="1">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons type_format='1' is_upd='0'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

