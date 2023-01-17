<!---
    File: V16/hr/ehesap/form/fire_execution_control.cfm
    Author: Esma R. UYSAL
    Description:
       İcra kontrolleri
--->



<cf_date tarih="attributes.finish_date_">
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.list_fire_in_out")>
<cfset get_execution = get_component.get_execution_detail(employee_id: attributes.employee_id, sal_mon: month(attributes.finish_date_), sal_year: year(attributes.finish_date_))>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="4 - #getLang('','İşten Çıkarma','52993')# - #getLang('','İcralar','47125')#" scroll="1" collapsable="1" resize="1" popup_box="1">
        <cfform name="execution" id="execution" action="#request.self#?fuseaction=ehesap.emptypopup_fire" method="post">
            <cfset id_list = valueList(get_execution.COMMANDMENT_ID)>
            <cfinput type="hidden" name="attributes_json" value="#attributes.attributes_json#">
            <cfinput type="hidden" name="id_list" value="#id_list#">
            <cfinput type="hidden" name="employee_id_" value="#attributes.employee_id#">
            <cf_box_elements>
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id="57487.No"></th>
                            <th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
                            <th><cf_get_lang dictionary_id="31746.İcra Tarihi"></th>
                            <th><cf_get_lang dictionary_id="45515.İcra No"></th>
                            <th><cf_get_lang dictionary_id="57673.Tutar"></th>
                            <th><cf_get_lang dictionary_id="58444.Kalan"></th>
                            <th><cf_get_lang dictionary_id='53572.Kesilecek İcra Tutarı'></th>
                        </tr>
                    </thead>
                    <thead>
                        <cfoutput query = "get_execution">
                            <tr>
                                <td>IC-#COMMANDMENT_ID#</td>
                                <td>#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
                                <td>#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
                                <td>#serial_no# #serial_number#</td>
                                <td style="text-align:right;">#tlformat(COMMANDMENT_VALUE)#</td>
                                <td style="text-align:right;">#tlformat(REMAINING)#</td>
                                <td style="text-align:right;"><cfinput type="text" name="pay_commandment_value_#COMMANDMENT_ID#" max_value="#REMAINING#" id="pay_commandment_value" value="" class="moneybox" maxlength="50" style="width:170px" onkeyup="max_control(this)">	</td>
                            </tr>
                        </cfoutput>
                    </thead>
                </cf_grid_list>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="0" add_function="control()" insert_alert="" insert_info="#getLang('','İleri','58843')#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script>
    function control(){
        myform = document.getElementById("execution");
        form_data= new FormData(myform);
        AjaxControlPostData("V16/hr/ehesap/cfc/list_fire_in_out.cfc?method=upd_execution_detail" ,form_data,function(response) {    
            response = JSON.parse(response);
            if(response.STATUS)
                loadPopupBox('execution', <cfoutput>#attributes.modal_id#</cfoutput>);
            else
                return false;
        });   
       return false;  
    }      
    function max_control(row_input){
        if(filterNum(row_input.value) > parseFloat(row_input.getAttribute('max_value'))){
            alert("<cf_get_lang dictionary_id='49742.Kapanacak Tutar Kalan Tutardan Büyük Olamaz!!'>");
            row_input.value = commaSplit(row_input.getAttribute('max_value'));
        }else
            return(FormatCurrency(row_input,event,2));
    }      
</script>