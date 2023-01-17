<!---
    File: V16\product\display\design_data_info.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data for product display
--->
<cf_box popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform id="design_data_info" name = "design_data_info" method="post">
        <cf_box_elements>
            <div class="w-cards">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 d-flex">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="watalogy-cards" style="flex-direction:row">
                            <a class="d-flex"><img src="/images/design-data/<cfoutput>#attributes.data_type#</cfoutput>-logo.png" class="w-cards"></a>
                        </div>
                    </div>                    
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 d-flex">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="col-xs-1 center-block">
                            <center>
                            <span><h2 style="color:#696A6A"><cf_get_lang dictionary_id='65357.Entegrasyon Ayarı Bulunamadı'>!</h2></span>
                            </center>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <div class="box_footer_border">
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' insert_info="#getLang('','Ayarları Yap',65359)#" insert_alert="#getLang('','Ayarlar Ekranına Gitmek İstediğinize Emin Misiniz?',65364)#" add_function='post_function()' cancel_function = "cancel_function()" is_cancel="1" cancel_alert="#getLang('','Vazgeçmek istediğinize emin misiniz',60633)#">
            </cf_box_footer>
        </div>
    </cfform>
</cf_box>
<script>
    function post_function() {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=settings&data_type=#attributes.data_type#&product_sample_id=#attributes.product_sample_id#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>');
        closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
        return false;
    }
    function cancel_function() {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&product_sample_id=#attributes.product_sample_id#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>');
        closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
        return false;
    }
</script>