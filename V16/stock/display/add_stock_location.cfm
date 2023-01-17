<cf_get_lang_set module_name="stock">
    <cfparam name="attributes.modal_id" default="">
<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
<cfinclude template="../query/get_location_priority.cfm">
<cfset pageHead=#getLang('stock',40)# >
<cf_box title="#getLang('','Depo Lokasyonu',45219)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_loc" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_stock_location">
    <cf_box_elements>
        <input name = "get_measure" id= "get_measure" type="hidden" value="<cfoutput>#get_measure.recordcount#</cfoutput>">
                    	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-department_id">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='58763.Depo'> *</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<input name="priority_exist" id="priority_exist" type="hidden" value="<cfif get_all_location.recordcount>1<cfelse>0</cfif>">
									<select name="department_id" id="department_id" style="width:200px;" >
                                        <cfinclude template="../query/get_department.cfm">
                                        <cfoutput query="get_department">
                                            <option value="#department_id#" <cfif department_id eq attributes.department_id> selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-location_id">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='45220.Lokasyon Kodu'> *</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='45282.Lokasyon Kodu Girmelisiniz'> !</cfsavecontent>
                                    <cfinput type="text" name="location_id" required="Yes" message="#message#" validate="integer" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-comment">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57629.Açıklama'> *</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.ad girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="comment" required="Yes" message="#message#" maxlength="75" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-location_type">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='59088.Tip'></cfoutput></label>
                                    <label class="col col-2 col-xs-2"><cfoutput><input type="radio" name="location_type" id="location_type" value="1"><cf_get_lang dictionary_id='38390.Hammadde'></cfoutput></label>
                                    <label class="col col-2 col-xs-2"><cfoutput><input type="radio" name="location_type" id="location_type" value="2" checked><cf_get_lang dictionary_id='57657.Ürün'></cfoutput></label>
                                    <label class="col col-2 col-xs-2"><cfoutput><input type="radio" name="location_type" id="location_type" value="3"><cf_get_lang dictionary_id='45519.Mamul'></cfoutput></label>
                                    <label class="col col-2 col-xs-2"><cfoutput><input type="radio" name="location_type" id="location_type" value="4"><cf_get_lang dictionary_id='45518.Konsinye'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-boyut">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57713.boyut'> (cm)</cfoutput></label>
                                    <div class="col col-8">
                                	<div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57695.Genislik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45281.Genislik Girmelisiniz'> !</cfsavecontent>
                                            <cfinput type="text" name="width" maxlength="10" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                    <div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57696.Yukseklik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45277.Yukseklik Girmelisiniz'> !</cfsavecontent>
                                            <cfinput type="text" name="height" maxlength="10" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                    <div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='42675.derinlik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45253.Derinlik Girmelisiniz'> !</cfsavecontent>
                                            <cfinput type="text" name="depth" maxlength="10" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-status">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="status" id="status" checked>&nbsp;<cf_get_lang dictionary_id='57493.Aktif'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-priority">
                            	<label class="col col-12"><cfoutput><cfinput type="checkbox" name="priority" value="1"><cf_get_lang dictionary_id='45187.Öncelikli Lokasyon'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-delivery">
                            	<label class="col col-12"><cfoutput><cfinput type="checkbox" name="delivery"><cf_get_lang dictionary_id='45513.Servis Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_scrap">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="is_scrap" id="is_scrap" value="1"><cf_get_lang dictionary_id ='45744.Hurda Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_end_of_series">
                            	<label class="col col-12"><cfoutput><cfinput type="checkbox" name="is_end_of_series"><cf_get_lang dictionary_id ='45669.Seri Sonu Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_recycle">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="is_recycle" id="is_recycle"><cf_get_lang dictionary_id='63985.Geri Dönüşüm Lokasyonu'> </cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_quality">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="is_quality" id="is_quality" value="1"><cf_get_lang dictionary_id='63695.Kalite Lokasyonu.'>  </cfoutput></label>
                            </div>
                            <div class="form-group" id="item-no_sale">
                            	<label class="col col-12"><cfoutput><cfinput type="checkbox" name="no_sale"><cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz.'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-belongto_institution">
                            	<label class="col col-12"><cfoutput><cfinput name="belongto_institution" type="checkbox" onClick="gizle_goster(belongto);"><cf_get_lang dictionary_id='45401.Bu Lokasyondaki stoklar 3 parti kurum ve kişilere aittir.'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_cost_action">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="is_cost_action" id="is_cost_action"><cf_get_lang dictionary_id ='45670.Maliyet İşlemi Yapmasın'></cfoutput></label>
                            </div>
                            <div class="form-group" style="display:none" id="belongto">
                            	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57519.Cari Hesap'></cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                        <input type="hidden" name="company_id" id="company_id">
                                        <input type="hidden" name="consumer_id" id="consumer_id">
                                        <cfinput  name="member_name" type="text" value="" style="width:150px;" readonly="yes">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_loc.member_name&field_comp_id=add_loc.company_id&field_consumer=add_loc.consumer_id&field_member_name=add_loc.member_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                        <cf_seperator id="measurement" header="#getLang('','Ölçümler',64076)#">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="measurement" type="column" index="2" sort="true">
                            <cf_grid_list>
                                <thead>
                                    <th><cf_get_lang dictionary_id='62817.Ölçüm Adı'></th>
                                    <th><cf_get_lang dictionary_id='62818.Ölçüm Birimi'></th>
                                    <th><cf_get_lang dictionary_id='63696.Minumum Değer'></th>
                                    <th><cf_get_lang dictionary_id='63697.Maximum Değer'></th>
                                    <th><cf_get_lang dictionary_id='63698.Ölçülen Değer'></th>
                                    <th><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
                                </thead>
                                <tbody>
                                    <cfoutput query = "get_measure">
                                        <tr>
                                            <cfset get_measure_row = getComponent.GET_MEASUREMENT_PARAMETER_ROW(measurement_id : measurement_id)>
                                            <td><label class="col col-2 col-xs-12">#MEASUREMENT_NAME#</label></td>
                                            <td>
                                                <div class="form-group">
                                                    <select name="measurement_row_#MEASUREMENT_ID#" id="measurement_row_#MEASUREMENT_ID#" >
                                                        <cfloop query="get_measure_row">
                                                            <option value="#get_measure_row.row_id#" >#get_measure_row.SHORT_UNIT_NAME#</option> 
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="min_value_#MEASUREMENT_ID#"  id="min_value_#currentrow#" onkeyup="return(FormatCurrency(this,event));"  value="">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="max_value_#MEASUREMENT_ID#"  id="max_value_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="measurement_id_#MEASUREMENT_ID#" id="measurement_id_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                        <input type="hidden" name="it_asset_#MEASUREMENT_ID#" id="it_asset_#MEASUREMENT_ID#" value="">
                                                        <div class="input-group">
                                                        <input type="text" name="it_asset_name_#MEASUREMENT_ID#" id="it_asset_name_#MEASUREMENT_ID#" value="" onfocus="AutoComplete_Create('it_asset_name_#MEASUREMENT_ID#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','it_asset_#MEASUREMENT_ID#,it_asset_name_#MEASUREMENT_ID#','','3','135');">
                                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=add_loc.it_asset_#MEASUREMENT_ID#&field_name=add_loc.it_asset_name_#MEASUREMENT_ID#&event_id=0&motorized_vehicle=0','list');"></span>
                                                </div> </div>
                                            </td>
                                        </tr> 
                                    </cfoutput>
                                </tbody>
                            </cf_grid_list>
                        </div>
                  
                   <cf_box_footer>
							<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol_priority()'>
                    </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol_priority()
	{
		if(add_loc.priority.checked && add_loc.priority_exist.value==1)
		    if(!confirm ("<cf_get_lang dictionary_id='45520.Daha onceden Bir Lokasyon Secilmis İptal etmek istiyor musunuz'>?")) return false;

        record_count = $("#get_measure").val();
        for(i = 1; i <= record_count; i++ )
        {
            if($("#min_value_"+i).val() != '') $("#min_value_"+i).val(filterNum($("#min_value_"+i).val())) ;
            if($("#max_value_"+i).val() != '') $("#max_value_"+i).val(filterNum($("#max_value_"+i).val()));
            if($("#measurement_id_"+i).val() != '')$("#measurement_id_"+i).val(filterNum($("#measurement_id_"+i).val()));  
        }
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
