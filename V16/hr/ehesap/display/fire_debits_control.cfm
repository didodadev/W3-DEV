<!---
    File: V16\hr\ehesap\display\fire_debits_control.cfm
    Author: Esma R. UYSAL
    Description:
       Zimmet kontrolleri
--->
<cfif isdefined("attributes.attributes_json")>
	<cfset deserialize_atributes = DeserializeJSON(URLDecode(attributes.ATTRIBUTES_JSON))>
	<cfset StructAppend(attributes,deserialize_atributes,true)>
</cfif>
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.list_fire_in_out")>
<cfset get_assetps = get_component.get_assetps(employee_id: attributes.employee_id)>
<cfset get_debits = get_component.get_debits(employee_id: attributes.employee_id)>
<cfset get_execution = get_component.get_execution(employee_id: attributes.employee_id)>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="3 - #getLang('','İşten Çıkarma','52993')# - #getLang('','Çalışan Zimmetleri','41817')#" scroll="1" collapsable="1" resize="1" popup_box="1">
        <cfif get_execution gt 0>
            <cfset action = "#request.self#?fuseaction=ehesap.list_fire&event=executive">
        <cfelse>
            <cfset action = "#request.self#?fuseaction=ehesap.emptypopup_fire">
        </cfif>
        <cfform name="debits" id="debits" action="#action#" method="post">  
            <cf_box_elements>
                <cfset attributes_json = Replace(SerializeJSON(attributes),"//","")>
                <cfinput type="hidden" name="attributes_json" value="#attributes_json#">
                <cfinput type="hidden" name="employee_id" value="#attributes.employee_id#">
                <cfinput type="hidden" name="finish_date_" value="#attributes.finish_date#">
                <cfif get_assetps.recordcount>
                    <cf_flat_list>
                        <thead>
                            <th><cf_get_lang dictionary_id='29452.Varlık'></th>
                            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        </thead>
                        <cfoutput query="get_assetps">
                            <tr>
                                <td>#assetp#</td>
                                <td>#assetp_cat#</td>
                            </tr>
                        </cfoutput>
                    </cf_flat_list>
                </cfif>
               
                <cf_flat_list>
                    <cfif get_debits.recordcount>
                        <thead>
                            <th><cf_get_lang dictionary_id='57931.Cins'></th>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='40146.Ürün Özellikleri'></th>
                        </thead>
                        <cfoutput query="get_debits">
                            <tr>
                                <td>#DEVICE_NAME#</td>
                                <td>#INVENTORY_NO#</td>
                                <td>#PROPERTY#</td>
                            </tr>
                        </cfoutput>
                    </cfif>
                    <cfif not (get_assetps.recordcount or get_debits.recordcount)>
                        <tr>
                            <td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </cf_flat_list>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="0" add_function="control()" insert_alert="" insert_info="#getLang('','İleri','58843')#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    function control(){
        loadPopupBox('debits', <cfoutput>#attributes.modal_id#</cfoutput>);
        return false;
    }            
</script>