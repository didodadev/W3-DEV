<cfquery NAME="GET_SERVICE_CARE_CON" DATASOURCE="#DSN3#">
	SELECT * FROM SERVICE_CARE_REPORT WHERE CARE_REPORT_ID=#attributes.id#
</cfquery>
<cfquery NAME="GET_SERVICE_SUB_STATUS" DATASOURCE="#dsn3#">
	SELECT * FROM SERVICE_SUBSTATUS
</cfquery>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfquery name="GET_SERVICE_CARE_DET" datasource="#dsn3#">
		SELECT * FROM SERVICE_CARE WHERE PRODUCT_CARE_ID = #attributes.id#
	</cfquery>
</cfif>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.form_add_service_care_report"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<cfform name="upd_service_contract" action="#request.self#?fuseaction=service.emptypopup_upd_care_report" method="post" enctype="multipart/form-data">
	<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>" />
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-contract_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='68.Başlık'>*</label>
                            <div class="col col-8 col-xs-12">
                                    <cfinput type="text" style="width:170px;" name="contract_head" maxlength="100" required="yes" value="#get_service_care_con.contract_head#">
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='245.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("get_service_care_con.product_id") and len(get_service_care_con.product_id)>
                                        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
                                        SELECT PRODUCT_NAME, PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID=#get_service_care_con.product_id#
                                        </cfquery>
                                    </cfif>
                                    <cfsavecontent variable="alert"><cf_get_lang_main no ='313.Ürün Seçmelisiniz'></cfsavecontent>
                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
                                     <cfinput type="text" name="product_name" id="product_name" style="width:170px;" value="#get_product.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" required="yes" message="#alert#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_service_contract.product_id&field_name=upd_service_contract.product_name','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-serial_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='225.Seri No'>*</label>
                            <div class="col col-8 col-xs-12">
                                 <cfinput type="text" style="width:170px;" name="serial_no" maxlength="100" required="yes" message="#alert#" value="#get_service_care_con.serial_no#">
                            </div>
                        </div>
                        <div class="form-group" id="item-service_member_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='316.Servis Firması'></label>
                             <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                <cfif len(get_service_care_con.company_partner_type)>
                                <cfif get_service_care_con.company_partner_type is "partner">
                                    <cfquery name="GET_COMPANY_AUTHORIZED" datasource="#DSN#">
                                        SELECT 
                                            CP.COMPANY_PARTNER_NAME NAME,
                                            CP.COMPANY_PARTNER_SURNAME SURNAME,
                                            CP.COMPANY_ID COMP_ID, 
                                            C.FULLNAME  COMPANY 
                                        FROM 
                                            COMPANY_PARTNER CP,
                                            COMPANY C 
                                        WHERE 
                                            C.COMPANY_ID=CP.COMPANY_ID AND
                                            CP.PARTNER_ID=#GET_SERVICE_CARE_CON.COMPANY_PARTNER_ID#
                                    </cfquery>
                                </cfif>
                                <cfif get_service_care_con.company_partner_type is "consumer">
                                    <cfquery name="GET_COMPANY_AUTHORIZED" datasource="#DSN#">
                                        SELECT 
                                            CONSUMER_NAME NAME, 
                                            CONSUMER_SURNAME SURNAME, 
                                            COMPANY COMPANY
                                        FROM 
                                            CONSUMER
                                        WHERE 
                                            CONSUMER_ID=#GET_SERVICE_CARE_CON.COMPANY_PARTNER_ID#
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <input type="hidden" name="service_member_id" id="service_member_id" value="<cfoutput>#get_service_care_con.company_partner_id#</cfoutput>">
                            <input type="hidden" name="service_member_type" id="service_member_type" value="<cfoutput>#get_service_care_con.company_partner_type#</cfoutput>">
                            <input type="text" name="service_company" id="service_company" style="width:170px;" value="<cfif len(get_service_care_con.company_partner_type)><cfoutput>#get_company_authorized.company#</cfoutput></cfif>" readonly>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=upd_service_contract.service_member_id&field_comp_name=upd_service_contract.service_company&field_name=upd_service_contract.service_member_name&field_type=upd_service_contract.service_member_type&select_list=7,8','list');"></span>
                                </div>
                             </div>
                        </div>
                        <div class="form-group" id="item-service_member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='116.Servis Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_service_care_con.company_partner_type)>
                                    <cfinput type="Text" name="service_member_name" style="width:170px;" value="#get_company_authorized.name# #get_company_authorized.surname#">
                                    <cfelse>
                                    <cfinput type="Text" name="service_member_name" style="width:170px;" value="">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='114.Servis Çalışan'> 1</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_service_care_con.employee1_id#</cfoutput>"> 
                                    <input type="text" name="employee" id="employee" value="<cfif len(get_service_care_con.employee1_id)><cfoutput>#get_emp_info(get_service_care_con.employee1_id,1,0)#</cfoutput></cfif>" style="width:170px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_service_contract.employee_id&field_name=upd_service_contract.employee&select_list=1','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id2">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='114.Servis Çalışan'> 2</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id2" id="employee_id2" value="<cfoutput>#get_service_care_con.employee2_id#</cfoutput>"> 
                                    <input type="text" name="employee2" id="employee2" value="<cfif len(get_service_care_con.employee2_id)><cfoutput>#get_emp_info(get_service_care_con.employee2_id,1,0)#</cfoutput></cfif>" style="width:170px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_service_contract.employee_id2&field_name=upd_service_contract.employee2&select_list=1','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-start_clock">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='111.Bakım Başlangıç Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="service_start_date"  value="#dateformat(get_service_care_con.care_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes"  style="width:65px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="service_start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <span class="input-group-addon">
									<cfoutput>
                                        <cfif len(get_service_care_con.care_date)>
                                            <cfset start_hour = hour(get_service_care_con.care_date)>
                                            <cfelse>
                                            <cfset start_hour = 0>	
                                        </cfif>
                                        <cf_wrkTimeFormat name="start_clock" value="#start_hour#">
									</cfoutput>
                                    </span>
                                    <span class="input-group-addon">
										<cfoutput>
											<cfif len(get_service_care_con.care_date)>
                                            	<cfset start_minute = minute(get_service_care_con.care_date)>
                                            <cfelse>
                                            	<cfset start_minute = 0>	
                                            </cfif>
                                            <select name="start_minute" id="start_minute" style="width:37px;">
                                                <option value=""><cf_get_lang_main no='1415.Dk'></option>
                                                <cfloop from="0" to="55" step="5" index="k">
                                                    <option value="#k#" <cfif start_minute eq k> selected</cfif>>#numberformat(k,00)#</option>
                                                </cfloop>
                                            </select>
                                        </cfoutput>
                                    </span>                                	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finish_clock">
                            <label class="col col-4 col-xs-12"> <cf_get_lang no='340.Bakım Bitis Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                <cfinput type="text" name="service_finish_date" validate="#validate_style#" value="#dateformat(get_service_care_con.care_finish_date,dateformat_style)#"  maxlength="10" style="width:65px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="service_finish_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <span class="input-group-addon">
								<cfoutput>
                                    <cfif len(get_service_care_con.care_finish_date)>
										<cfset finish_hour = hour(get_service_care_con.care_finish_date)>					
                                        <cfset finish_minute = minute(get_service_care_con.care_finish_date)>
                                    <cfelse>
                                        <cfset finish_hour = ''>					
                                        <cfset finish_minute = ''>						
                                    </cfif> 
                                    <cf_wrkTimeFormat name="finish_clock" value="#finish_hour#">
                                </cfoutput>
                                </span>
                                <span class="input-group-addon">
                                	<cfoutput>
                                        <select name="finish_minute" id="finish_minute" style="width:37px;">
                                            <option value=""><cf_get_lang_main no='1415.Dk'></option>
                                            <cfloop from="0" to="55" step="5" index="k">
                                                <option value="#numberformat(k,00)#" <cfif finish_minute eq k> selected</cfif>>#numberformat(k,00)#</option>
                                            </cfloop>
                                        </select>
                                    </cfoutput>
                                </span>
                            </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea  name="detail" id="detail"><cfoutput>#get_service_care_con.detail#</cfoutput></textarea>&nbsp;
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
                                value="#get_service_care_con.care_cat#"
                                width="170">
                            </div>
                                
                        </div>
                        <div class="form-group" id="item-service_substatus">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1561.Alt Aşama'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="service_substatus" id="service_substatus" style="width:170px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'>   
                                    <cfoutput query="get_service_sub_status">
                                    <option value="#service_substatus_id#" <cfif service_substatus_id eq get_service_care_con.service_substatus>selected</cfif>>#service_substatus#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-document">
                            <label class="col col-4 col-xs-12"><cf_get_lang no ='118.Destek Belgesi'></label>
                            <div class="col col-8 col-x-12">
                                <input type="file" name="document" id="c" style="width:230px;">
                                <cfif len(get_service_care_con.file_name)>
                                	<cfoutput>
	                                	<a href="#file_web_path#service/#get_service_care_con.file_name#" target="_blank">#get_service_care_con.file_name#</a>
                                    </cfoutput>
                                </cfif>
                            </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_service_care_con">
                </div>
                <div class="col col-6 col-xs-12">	
                    <cf_workcube_buttons is_upd='1' add_function="controlServiceCareReport()" delete_page_url='#request.self#?fuseaction=service.emptypopup_del_service_care_contract&id=#attributes.id#'>
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
