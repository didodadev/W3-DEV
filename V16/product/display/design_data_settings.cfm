<!---
    File: V16\product\display\design_data_settings.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data for product settings route
--->

<cfif attributes.data_type neq 'clo'>
    <script>
        $( document ).ready(function() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=info&product_sample_id=#attributes.product_sample_id#&data_type=#attributes.data_type#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>','','ui-draggable-box-small');
            closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
        });
    </script>
<cfelse>
    <cfinclude template="#attributes.data_type#_w3_setting.cfm" />
</cfif>