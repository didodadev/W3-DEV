<!---
    File: V16\product\display\design_data.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data for product display
--->
<cf_box title="#getLang('','Design Data Import',65352)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="formimport" enctype="multipart/form-data" method="post">
        <div class="w-cards">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 d-flex">
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('clo')" class="d-flex"><img src="/images/design-data/clo-logo.png" class="w-cards"></a>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('solidworks')" class="d-flex"><img src="/images/design-data/solidworks-logo.png" class="w-cards"></a>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('inventor')" class="d-flex"><img src="/images/design-data/inventor-logo.png" class="w-cards"></a>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 d-flex">
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('fusion360')" class="d-flex"><img src="/images/design-data/fusion360-logo.png" class="w-cards"></a>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('tekla')" class="d-flex"><img src="/images/design-data/tekla-logo.png" class="w-cards"></a>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="watalogy-cards" style="flex-direction:row">
                        <a onclick="open_settings('revit')" class="d-flex"><img src="/images/design-data/revit-logo.png" class="w-cards"></a>
                    </div>
                </div>
            </div>
        </div>
    </cfform>
</cf_box>
<script>
    function open_settings(type) {
        
        form_data = new FormData();
        form_data.append("data_type", type);
        AjaxControlPostData('V16/product/cfc/design_data.cfc?method=GET_DESIGN_DATA_SETTINGS', form_data, function(response) {
            response = JSON.parse(response);
            if(response == 0)
            {
                openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=info&product_sample_id=#attributes.product_sample_id#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>&data_type='+type,'','ui-draggable-box-small');
                closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
            }else
            {
                openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=import&product_sample_id=#attributes.product_sample_id#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>&data_type='+type,'','ui-draggable-box-large');
                closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
            }
          
        });
    }

</script>