<cfquery name="GET_SERVICE_SUB_STATUS" datasource="#DSN3#">
	SELECT SERVICE_SUBSTATUS_ID, SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS
</cfquery>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfquery name="GET_SERVICE_CARE_DET" datasource="#DSN3#">
		SELECT SERIAL_NO FROM SERVICE_CARE WHERE PRODUCT_CARE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
</cfif>
<cf_catalystHeader>
<cfform name="service_contract" action="#request.self#?fuseaction=service.emptypopup_add_service_care_contract" method="post" enctype="multipart/form-data">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-contract_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='68.Başlık'>*</label>
                            <div class="col col-8 col-xs-12">
                            	<cfinput type="text" name="contract_head" id="contract_head" value="" style="width:170px;" maxlength="100" required="yes" message="#getLang('main',782)# #getLang('main',68)#">
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='245.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("get_service_care_det.product_id") and len(get_service_care_det.product_id)>
                                        <cfquery name="GET_PRODUCT_PROP_DET" datasource="#DSN3#">
                                            SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_care_det.product_id#">
                                        </cfquery>
                                    </cfif>
                                    <cfif isdefined("get_product_prop_det.product_id") and len(get_product_prop_det.product_id) and isdefined("get_product_prop_det.product_name") and len(get_product_prop_det.product_name)>
                                        <input type="hidden" name="product_id"  id="product_id"  value="<cfoutput>#get_product_prop_det.product_id#</cfoutput>">
                                        <cfinput type="text" name="product_name" id="product_name" style="width:170px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="#get_product_prop_det.product_name#" required="yes" onKeyUp="get_product();" message="#getLang('main',782)# #getLang('main',245)#">
                                    <cfelse>
                                        <input type="hidden" name="product_id" id="product_id"  value="">
                                        <cfinput type="text" name="product_name" id="product_name" style="width:170px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="" required="yes" onKeyUp="" message="#getLang('main',782)# #getLang('main',245)#">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=service_contract.product_id&field_name=service_contract.product_name','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-serial_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='225.Seri No'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("get_service_care_det.serial_no") and len(get_service_care_det.serial_no)>
                                    <cfinput type="text" name="serial_no" id="serial_no" style="width:170px;" maxlength="100" value="#get_service_care_det.serial_no#" message="#getLang('main',782)# #getLang('main',225)#">
                                <cfelse>
                                    <cfinput type="text" name="serial_no" id="serial_no" style="width:170px;" maxlength="100" value="" message="#getLang('main',782)# #getLang('main',225)#">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-service_member_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='316.Servis Firması'></label>
                             <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("get_service_care_det.service_authorized_type") and len(get_service_care_det.service_authorized_type)>
                                        <cfif get_service_care_det.service_authorized_type is "partner">
                                            <cfquery name="GET_SERVICE_AUTHORIZED" datasource="#DSN#">
                                                SELECT
                                                    CP.PARTNER_ID ID,
                                                    CP.COMPANY_PARTNER_NAME NAME,
                                                    CP.COMPANY_PARTNER_SURNAME SURNAME,
                                                    CP.COMPANY_ID COMP_ID,
                                                    C.FULLNAME COMPANY
                                                FROM
                                                    COMPANY_PARTNER CP,
                                                    COMPANY C
                                                WHERE
                                                    C.COMPANY_ID = CP.COMPANY_ID AND
                                                    CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_care_det.service_authorized_id#"> 
                                            </cfquery>
                                        </cfif>
                                        <cfif get_service_care_det.service_authorized_type is "consumer">
                                            <cfquery name="GET_SERVICE_AUTHORIZED" datasource="#DSN#">
                                                SELECT
                                                    CONSUMER_ID ID,
                                                    CONSUMER_NAME NAME,
                                                    CONSUMER_SURNAME SURNAME,
                                                    COMPANY COMPANY
                                                FROM
                                                    CONSUMER
                                                WHERE
                                                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_care_det.service_authorized_id#">
                                            </cfquery>
                                        </cfif>
                                    </cfif>
                                    <input type="hidden" name="service_member_id" id="service_member_id" value="<cfoutput><cfif isdefined("get_service_authorized.id") and len(get_service_authorized.id)>#get_service_authorized.id#</cfif></cfoutput>">
                                    <input type="hidden" name="service_member_type" id="service_member_type" value="<cfoutput><cfif isdefined("get_service_authorized.id") and len(get_service_authorized.id)>#get_service_authorized.id#</cfif></cfoutput>">
                                    <input type="text" name="service_company" id="service_company" style="width:170px;" value="<cfoutput><cfif isdefined("get_service_authorized.company") and len(get_service_authorized.company)>#get_service_authorized.company#</cfif></cfoutput>" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=service_contract.service_member_id&field_comp_name=service_contract.service_company&field_name=service_contract.service_member_name&field_type=service_contract.service_member_type&select_list=7,8','list');" ></span>
                                </div>
                             </div>
                        </div>
                        <div class="form-group" id="item-service_member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='116.Servis Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("get_service_authorized.name") and len(get_service_authorized.name)>
                                    <cfinput type="text" name="service_member_name" id="service_member_name" style="width:170px;" value="#get_service_authorized.name# #get_service_authorized.surname#">
                                    <cfelse>
                                    <cfinput type="text" name="service_member_name" id="service_member_name" style="width:170px;" value="">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='114.Servis Çalışan'> 1</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("get_service_care_det.service_employee") and len(get_service_care_det.service_employee)>
                                        <cfquery name="GET_EMPLOYEE1" datasource="#DSN#">
                                        SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_care_det.service_employee#">
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("get_employee1.employee_id") and len(get_employee1.employee_id)><cfoutput>#get_employee1.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="employee" id="employee" value="<cfif isdefined("get_employee1.employee_id") and len(get_employee1.employee_id)><cfoutput>#get_employee1.employee_name# #get_employee1.employee_surname#</cfoutput></cfif>" style="width:170px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=service_contract.employee_id&field_name=service_contract.employee&select_list=1','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id2">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='114.Servis Çalışan'> 2</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("get_service_care_det.service_employee2") and len(get_service_care_det.service_employee2)>
                                        <cfquery name="GET_EMPLOYEE2" datasource="#DSN#">
                                        SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_care_det.service_employee2#">
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" name="employee_id2" id="employee_id2" value="<cfoutput><cfif isdefined("get_employee2.employee_id") and len(get_employee2.employee_id)>#get_employee2.employee_id#</cfif></cfoutput>">
                                    <input type="text" name="employee2" id="employee2" value="<cfoutput><cfif isdefined("get_employee2.employee_name") and len(get_employee2.employee_name)>#get_employee2.employee_name# #get_employee2.employee_surname#</cfif></cfoutput>" style="width:170px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=service_contract.employee_id2&field_name=service_contract.employee2&select_list=1','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-start_clock">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='111.Bakım Başlangıç Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="service_start_date" id="service_start_date" validate="#validate_style#" maxlength="10" message="#getLang('main',782)# #getLang('service',111)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="service_start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <span class="input-group-addon">
                                        <cf_wrkTimeFormat name="start_clock" value="">
                                    </span>
                                    <span class="input-group-addon">
                                        <select name="start_minute" id="start_minute">
                                            <option value=""><cf_get_lang_main no='1415.Dk'></option>
											<cfoutput>
                                                <cfloop from="0" to="55" step="5" index="k">
                                                    <option value="#k#">#numberformat(k,00)#</option>
                                                </cfloop>
											</cfoutput>
                                        </select>
                                    </span>                                	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finish_clock">
                            <label class="col col-4 col-xs-12"> <cf_get_lang no='340.Bakım Bitis Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                <cfinput type="text" name="service_finish_date" validate="#validate_style#" maxlength="10" style="width:65px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="service_finish_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <span class="input-group-addon">
                                    <cf_wrkTimeFormat name="finish_clock" value="">
                                </span>
                                <span class="input-group-addon">
                                    <select name="finish_minute" id="finish_minute">
                                    <option value=""><cf_get_lang_main no='1415.Dk'></option>
										<cfoutput>
                                            <cfloop from="0" to="55" step="5" index="k">
                                                 <option value="#numberformat(k,00)#">#numberformat(k,00)#</option>
                                            </cfloop>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" maxlength="1000" style="width:170px;height:115px;" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" ></textarea>&nbsp;
                            </div>
                        </div>
                        <div class="form-group" id="item-service_care">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='78.Bakım tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_combo
                                name="service_care"
                                query_name="GET_SERVICE_CARE_CAT"
                                option_name="service_care"
                                option_value="service_carecat_id"
                                width="170">
                            </div>
                        </div>
                        <div class="form-group" id="item-service_substatus">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1561.Alt Aşama'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="service_substatus" id="service_substatus" style="width:170px;">
                                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                    <cfoutput query="get_service_sub_status">
                                        <option value="#service_substatus_id#">#service_substatus#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-document">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='118.Destek Belgesi'></label>
                            <div class="col col-8 col-x-12">
                                <input type="file" name="document" id="document" style="width:230px;">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0' add_function="controlServiceCareReport()">
                    </div>
                </div>
         </div> 
    </div> 
</cfform>

<script type="text/javascript">
function controlServiceCareReport()
{
	if(!$("#contract_head").val().length)
	{
		alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="68.Başlık">');
		return false;	
	}
	if(!$("#product_name").val().length)
	{
		alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="245.Ürün">');
		return false;	
	}
	if(!$("#serial_no").val().length)
	{
		alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="225.Seri No">');
		return false;	
	}
	if(!$("#service_start_date").val().length)
	{
		alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="43.Bakım Tarihi">');
		return false;	
	}
	return true;
}
</script>