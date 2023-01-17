<cfparam name="attributes.is_sample" default="">
<cfparam name="attributes.is_upd" default="">
<cfparam name="attributes.product_sample_id" default="">
<cfparam name="attributes.refinery_lab_test_id" default="">
<cfif listLen(attributes.parameter_id_list)>
    <cfset attributes.parameter_id_list = listDeleteDuplicates(attributes.parameter_id_list)>
</cfif>
<cf_box title="#getLang('','Test Tanımı ve Parametreleri','64140')#" popup_box="1">
    <cfquery name="get_quality_types" datasource="#dsn3#">
        SELECT 
            QR.QUALITY_CONTROL_ROW	SUB_TYPE,
            QR.QUALITY_CONTROL_ROW_ID,
            QT.QUALITY_CONTROL_TYPE AS MAIN_TYPE,
            QT.TYPE_ID
        FROM 
            QUALITY_CONTROL_ROW QR 
            LEFT JOIN QUALITY_CONTROL_TYPE QT ON QT.TYPE_ID= QR.QUALITY_CONTROL_TYPE_ID
        ORDER BY
        MAIN_TYPE,SUB_TYPE
    </cfquery>
    <cfform name="add_form" id="add_form">
        <cfinput type="hidden" name="refinery_lab_test_id" id="refinery_lab_test_id" value="#attributes.refinery_lab_test_id#">
        <cfinput type="hidden" name="is_sample" id="is_sample" value="#attributes.is_sample#">
        <cfinput type="hidden" name="p_id_list" id="p_id_list" value="#attributes.parameter_id_list#">
        <cfinput type="hidden" name="is_upd" id="is_upd" value="#attributes.is_upd#">
        <cfinput type="hidden" name="product_sample_id" id="product_sample_id" value="#attributes.product_sample_id#">

        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='64141.Test Tanımı'></th>
                    <th><cf_get_lang dictionary_id='64052.Parametre'></th>
                    <th></th>
                </tr>
            </thead>
            
            <tbody>
                <cfif get_quality_types.recordCount>
                    <cfoutput query="get_quality_types">
                        <tr>
                            <td>#MAIN_TYPE#</td>
                            <td>#SUB_TYPE#</td>
                            <td>
                                <input type="checkbox" name="is_type_check" id="is_type_check#currentrow#" value="#TYPE_ID#;#QUALITY_CONTROL_ROW_ID#" <cfif listLen(parameter_id_list) and listContains(parameter_id_list,"#TYPE_ID#;#QUALITY_CONTROL_ROW_ID#",",")>checked</cfif>>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cf_box_footer>
            <cf_workcube_buttons extraButton="1" extraButtonText="#getLang('','Ekle','57582')#"  extraFunction="add_()" update_status="0">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function add_() {
        var checkedList = [];
        var add_list = [];
        var del_list = [];
        row_number = 0;
        $("input:checkbox[name=is_type_check]:checked").each(function(){
            row_number++;
            checkedList.push($(this).val());
            
            <cfif attributes.is_upd eq 1>
                var val_1 = $(this).val().split(';')[0];
                var val_2 = $(this).val().split(';')[1];

                $('#add_form').append('<input type="hidden" name="groupId' + row_number + '" id="groupId' + row_number + '" value="'+ val_1 +'" />');
                $('#add_form').append('<input type="hidden" name="parameterId' + row_number +'" id="parameterId' + row_number + '" value="'+ val_2 +'" />');
                $('#add_form').append('<input type="hidden" name="rowcount_add" id="rowcount_add" value="'+row_number+'" />');
            </cfif>
        });
        
        if($("#p_id_list").length > 0){
            if ($("#p_id_list").val().includes(',')) {
                var p_list = $("#p_id_list").val().split(",");
                del_list = p_list.filter(a => !checkedList.includes(a)); /* Checki kaldırılan testin silinmesi için eklendi. */
            }
            else{
                var p_list= $("#p_id_list").val();
                if(jQuery.inArray(p_list, checkedList) == -1){
                    del_list = p_list;
                }
            }
            var B = checkedList;
            add_list = checkedList.filter(a => !p_list.includes(a));  /* Test satırlarında çoklanmaları önlemek için eklendi. */
        }
        <cfif attributes.is_upd eq 1>

            str = $("#add_form").serialize();
            str = str + '&del_list=' + del_list;
            str = str + '&product_sample_id=' + $("#product_sample_id").val();
            $.ajax({
                type:'POST',  
                url:'WBP/Recycle/files/sample_analysis/cfc/sample_analysis.cfc?method=save_parameters',  
                data: str,
                error :  function(response){
                    if(response.status){
                        location.reload();
                    }
                    else{
                        alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                        location.reload();
                    }
                }
            }); 
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=lab.test_parameters&is_sample=#attributes.is_sample#&is_upd=#attributes.is_upd#&refinery_lab_test_id=#attributes.refinery_lab_test_id#&product_sample_id=#attributes.product_sample_id#&is_reload=1</cfoutput>','new_params');

        <cfelse>

            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=lab.test_parameters&is_sample=#attributes.is_sample#&is_upd=#attributes.is_upd#&refinery_lab_test_id=#attributes.refinery_lab_test_id#&product_sample_id=#attributes.product_sample_id#&is_reload=1</cfoutput>&q_id_list='+add_list+'&q_del_list='+del_list+'','new_params');

        </cfif>

            closeBoxDraggable("parameter");
            return false;
    }
</script>