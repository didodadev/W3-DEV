<cf_get_lang_set module_name="stock">
<cfset DEPO = listgetat(attributes.id,1,"-")>
<cfset LOC = listgetat(attributes.id,2,"-")>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_location_priority.cfm">
<cfinclude template="../query/get_det_stock_location.cfm">
<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
<cfquery name="GET_DET" datasource="#DSN2#">
	SELECT
		STOCKS_ROW_ID
	FROM
		STOCKS_ROW
	WHERE 
		STORE = #DEPO# AND
		STORE_LOCATION = #LOC#
</cfquery>
<cfif not get_det_stock_location.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfsavecontent variable="right">
	<cfoutput>
		<cfif not listfindnocase(denied_pages,'product.popup_list_stock_location_period')><li><a href="javascript://" title="<cf_get_lang dictionary_id='58811.muhasebe kodu'>" onClick="windowopen('#request.self#?fuseaction=stock.popup_list_stock_location_period&id=#attributes.id#','list');"><i class="fa fa-handshake-o"></i></a></li></cfif>	  
	</cfoutput>
</cfsavecontent>
<cfset pageHead=#getLang('stock',42)#&" : "& #attributes.id# >
<cf_box title="#getLang('','Depo Lokasyonu',45219)#" scroll="1" right_images="#right#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_loc" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_stock_location_process">
    <cf_box_elements>
        <input type="hidden" id="dep_loc_id" name="dep_loc_id" value="<cfoutput>#attributes.id#</cfoutput>" />
    	<input type="hidden" id="id" name="id" value="<cfoutput>#get_det_stock_location.id#</cfoutput>" />
        <input name = "get_measure" id= "get_measure" type="hidden" value="<cfoutput>#get_measure.recordcount#</cfoutput>">
                    	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        	<cfif get_det.recordcount eq 0><!--- Bu lokasyondan henuz hareket yoksa --->
                                <div class="form-group" id="item-department_id">
                                    <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='58763.Depo'> *</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="department_id" id="department_id" style="width:200px;" >
                                            <cfinclude template="../query/get_department.cfm">
                                            <cfoutput query="get_department">
                                                <option value="#department_id#" <cfif department_id eq get_det_stock_location.department_id> selected</cfif>>#department_head#</option> 
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-location_id">
                                    <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='45220.Lokasyon Kodu'> *</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='45282.lokasyon kodu girmelisiniz'></cfsavecontent>
                            			<cfinput type="text" style="width:200px;" name="location_id" id="location_id" required="Yes" message="#message#" value="#get_det_stock_location.location_id#">
                                    </div>
                                </div>
							<cfelse>
                                <cfquery name="GET_NAME" datasource="#DSN#">
                                    SELECT 
                                        DEPARTMENT_HEAD
                                    FROM 
                                        DEPARTMENT
                                    WHERE
                                        DEPARTMENT_ID=#DEPO#
                                </cfquery>
                                <cfoutput>
                                    <div class="form-group" id="item-department_id">
                                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='58763.Depo'> *</cfoutput></label>
                                        <div class="col col-8 col-xs-12">
											<input type="text" name="name" id="name" value="#get_name.department_head#" disabled style="width:200px;">
                                			<input name="department_id" id="department_id" type="hidden" value="<cfoutput>#depo#</cfoutput>">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-location_id">
                                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='45220.Lokasyon Kodu'> *</cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="hidden" name="dont" id="dont" value="1">
                                            <input type="text" name="location_id" id="location_id" value="#get_det_stock_location.location_id#" readonly style="width:200px;">
                                        </div>
                                    </div>
								</cfoutput>
                            </cfif>
                            <div class="form-group" id="item-comment">
                                <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='36199.Açıklama'> *</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input name="priority_exist" id="priority_exist" type="hidden" value="<cfif get_all_location.recordcount and get_all_location.location_id neq LOC>1<cfelse>0</cfif>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33337.Açıklama Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="comment" value="#get_det_stock_location.comment#" required="Yes" message="#message#"  maxlength="75" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-location_type">
                                <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='59088.Tip'></cfoutput></label>
									<cfoutput>
                                        <label class="col col-2 col-xs-2"><input type="radio" name="location_type" id="location_type" value="1" <cfif get_det_stock_location.location_type eq 1>checked</cfif>><cf_get_lang dictionary_id='37498.Hammadde'></label>
                                        <label class="col col-2 col-xs-2"><input type="radio" name="location_type" id="location_type" value="2" <cfif get_det_stock_location.location_type eq 2>checked</cfif>><cf_get_lang dictionary_id='45517.Mal'> </label>
                                        <label class="col col-2 col-xs-2"><input type="radio" name="location_type" id="location_type" value="3" <cfif get_det_stock_location.location_type eq 3>checked</cfif>><cf_get_lang dictionary_id='45519.Mamul'></label>
                                        <label class="col col-2 col-xs-2"><input type="radio" name="location_type" id="location_type" value="4" <cfif get_det_stock_location.location_type eq 4>checked</cfif>><cf_get_lang dictionary_id='45518.Konsinye'></label>
                                    </cfoutput>
                            </div>
                            <div class="form-group" id="item-boyut">
                                <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57713.boyut'> (cm)</cfoutput></label>
                                <div class="col col-8">
                                	<div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57695.Genislik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                        	<cfsavecontent variable="message"><cf_get_lang dictionary_id='42113.genislik girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="width" maxlength="10" value="#get_det_stock_location.width#" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                    <div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57696.Yukseklik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45277.yukseklik girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="height" maxlength="10" value="#get_det_stock_location.height#" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                    <div class="form-group col col-4">
                                    	<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='45200.derinlik'></cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45253.derinlik girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="depth" maxlength="10" value="#get_det_stock_location.depth#" validate="float" message="#message#" style="width:50px;">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <cfquery name="get_department_status" datasource="#dsn#">
                                SELECT 
                                    DEPARTMENT_STATUS
                                FROM 
                                    DEPARTMENT
                                WHERE 
                                    DEPARTMENT_ID = #get_det_stock_location.department_id#
                            </cfquery>
                            <div class="form-group" id="item-status">
                                <label class="col col-12">
									<cfoutput>
                                	<input type="hidden" name="control_status" id="control_status" value="<cfoutput>#get_department_status.department_status#</cfoutput>">
									<input type="checkbox" name="status" id="status" <cfif get_det_stock_location.status>checked="checked"</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
									</cfoutput>
                                </label>
                            </div>
                            <div class="form-group" id="item-priority">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="priority" id="priority" <cfif get_det_stock_location.priority eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='45187.Öncelikli Lokasyon'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-delivery">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="delivery" id="delivery" <cfif get_det_stock_location.delivery eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='45513.Servis Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_scrap">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="is_scrap" id="is_scrap" <cfif get_det_stock_location.is_scrap eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id ='45744.Hurda Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_end_of_series">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="is_end_of_series" id="is_end_of_series" <cfif get_det_stock_location.is_end_of_series eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id ='45669.Seri Sonu Lokasyonu'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_recycle">
                            	<label class="col col-12"><cfoutput><input type="checkbox" name="is_recycle" id="is_recycle" <cfif get_det_stock_location.IS_RECYCLE_LOCATION eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='63985.Geri Dönüşüm Lokasyonu'> </cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_quality">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="is_quality" id="is_quality" value="1" <cfif get_det_stock_location.is_quality eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='63695.Kalite Lokasyonu'> </cfoutput></label>
                            </div>
                            <div class="form-group" id="item-no_sale">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="no_sale" id="no_sale" <cfif get_det_stock_location.no_sale eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz.'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-belongto_institution">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="belongto_institution" id="belongto_institution" onClick="gizle_goster(belongto);" <cfif get_det_stock_location.belongto_institution eq 1>checked</cfif>><cf_get_lang dictionary_id='45401.Bu Lokasyondaki stoklar üçüncü parti kurum ve kişilere aittir.'></cfoutput></label>
                            </div>
                            <div class="form-group" id="item-is_cost_action">
                                <label class="col col-12"><cfoutput><input type="checkbox" name="is_cost_action" id="is_cost_action" <cfif get_det_stock_location.is_cost_action eq 1>checked</cfif>><cf_get_lang dictionary_id ='45671.Maliyet Takip Edilmiyor'> </cfoutput></label>
                            </div>
                            <div class="form-group" <cfif get_det_stock_location.belongto_institution eq 0>style="display:none"</cfif> id="belongto">
                                <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57519.Cari Hesap'></cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_det_stock_location.company_id)>
                                            <cfquery name="get_company" datasource="#dsn#">
                                                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_det_stock_location.company_id#
                                            </cfquery>
                                            <input type="hidden" name="consumer_id" id="consumer_id">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_det_stock_location.company_id#</cfoutput>">
                                            <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_company.fullname#</cfoutput>" style="width:150px;">
                                        <cfelseif len(get_det_stock_location.consumer_id)>
                                            <cfquery name="get_consumer" datasource="#dsn#">
                                                SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #get_det_stock_location.consumer_id#
                                            </cfquery>
                                            <input type="hidden" name="consumer_id" id="consumer_id">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_det_stock_location.consumer_id#</cfoutput>">
                                            <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_consumer.fullname#</cfoutput>" style="width:150px;">
                                        <cfelse>
                                            <input type="hidden" name="consumer_id" id="consumer_id">
                                            <input type="hidden" name="company_id" id="company_id" value="">
                                            <input type="text" name="member_name" id="member_name" value="" style="width:150px;">
                                        </cfif>
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
                                            <cfset get_measure_value = getComponent.STOCK_LOCATION_MEASUREMENT(
                                                measurement_id : measurement_id,
                                                department_id : get_det_stock_location.department_id,
                                                location_id : get_det_stock_location.location_id
                                            )>
                                            <td><label class="col col-2 col-xs-12">#MEASUREMENT_NAME#</label></td>
                                            <td>
                                                <div class="form-group">
                                                    <select name="measurement_row_#MEASUREMENT_ID#" id="measurement_row_#MEASUREMENT_ID#" >
                                                        <cfloop query="get_measure_row">
                                                            <option value="#get_measure_row.row_id#" <cfif get_measure_row.row_id eq get_measure_value.MEASUREMENT_ROW_ID>selected</cfif>>#get_measure_row.SHORT_UNIT_NAME#</option> 
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="min_value_#MEASUREMENT_ID#" id="min_value_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(get_measure_value.MIN_VALUE)#">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="max_value_#MEASUREMENT_ID#" id="max_value_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(get_measure_value.MAX_VALUE)#">
                                                </div>
                                            </td>
                                            <td> 
                                                <!--- daha önce girilmemişse insert için --->
                                                <div class="form-group">
                                                    <cfif get_measure_value.recordcount>
                                                        <cfinput type="hidden" name="measure_existent_#MEASUREMENT_ID#" value="#get_measure_value.stock_location_id#">
                                                    </cfif>
                                                    <cfinput type="text" name="measurement_id_#MEASUREMENT_ID#" id="measurement_id_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(get_measure_value.MEASUREMENT_VALUE)#">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                        <cfif len(get_measure_value.IT_ASSET_ID)>
                                                            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                                                SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_measure_value.IT_ASSET_ID#
                                                            </cfquery>
                                                            <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
                                                            <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
                                                        <cfelse>
                                                            <cfset relation_phy_asset_id = "">
                                                            <cfset relation_phy_asset = "">
                                                        </cfif>
                                                        <input type="hidden" name="it_asset_#MEASUREMENT_ID#" id="it_asset_#MEASUREMENT_ID#" value="#get_measure_value.IT_ASSET_ID#">
                                                        <div class="input-group">
                                                        <input type="text" name="it_asset_name_#MEASUREMENT_ID#" id="it_asset_name_#MEASUREMENT_ID#" value="#relation_phy_asset#" onfocus="AutoComplete_Create('it_asset_name_#MEASUREMENT_ID#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','it_asset_#MEASUREMENT_ID#,it_asset_name_#MEASUREMENT_ID#','','3','135');">
                                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=add_loc.it_asset_#MEASUREMENT_ID#&field_name=add_loc.it_asset_name_#MEASUREMENT_ID#&event_id=0&motorized_vehicle=0','list');"></span>
                                                </div> </div>
                                            </td>
                                        </tr> 
                                    </cfoutput>
                                </tbody>
                            </cf_grid_list>
                        </div>
                    <cf_box_footer>
							<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol_priority()'>
                    </cf_box_footer>
	</cfform>
</cf_box>
</cfif>
<script type="text/javascript">
	function kontrol_priority()
	{
		if (document.getElementById('control_status').value == 0)
		{
			alert("Bu lokasyonun bağlı olduğu depo pasif durumdadır.");
			return false;
		}	
		if(document.add_loc.status.checked == false)
		{
			var listParam = document.getElementById('department_id').value+"*" + document.getElementById('location_id').value;
			var shelf_status = wrk_safe_query('stk_get_shelf_status','dsn3',0,listParam);
			if(shelf_status.recordcount)
			{
				alert("Bu lokasyona ait aktif raflar bulunmaktadır.");
				return false;
			}
		}	
		if(add_loc.priority.checked && add_loc.priority_exist.value==1)
            if(!confirm ("<cf_get_lang dictionary_id='45520.Daha onceden Bir Lokasyon Secilmis!İptal etmek istiyor musunuz'>?")) return false;
            
        record_count = $("#get_measure").val();
        for(i = 1; i <= record_count; i++ )
        {
            if($("#min_value_"+i).val() != '') $("#min_value_"+i).val(filterNum($("#min_value_"+i).val()));
            if($("#max_value_"+i).val() != '') $("#max_value_"+i).val(filterNum($("#max_value_"+i).val()));
            if($("#measurement_id_"+i).val() != '')$("#measurement_id_"+i).val(filterNum($("#measurement_id_"+i).val()));  
        }   
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
