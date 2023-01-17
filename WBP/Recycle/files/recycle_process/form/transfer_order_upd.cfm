<cfif isnumeric(attributes.refinery_transport_id)>
    <cfset transfer_order = createObject("component","WBP/Recycle/files/recycle_process/cfc/transfer_order") />
    <cfset getTransferOrder = transfer_order.getTransferOrder( attributes.refinery_transport_id ) />
</cfif>
<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfif getTransferOrder.recordcount or 1 eq 1>
    <cfoutput>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cfform name="TransportOrdersForm" id="TransportOrdersForm">
                <cf_box>
                    <cfinput type="hidden" name="refinery_transport_id" id="refinery_transport_id" value="#attributes.refinery_transport_id#">
                    <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <!--- <div class="form-group" id="item-general_paper_no">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No">*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="general_paper_no" id="general_paper_no" value=""></div>
                            </div> --->
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#getTransferOrder.PROCESS_STAGE#' process_cat_width='250' is_detail='1'></div>
                            </div>
                            <div class="form-group" id="item-transport_ordering">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62090.Emri Veren'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="transport_ordering_employee_id" id="transport_ordering_employee_id" value="#getTransferOrder.ORDER_EMPLOYEE_ID#">
                                        <input type="text" name="transport_ordering_name" id="transport_ordering_name" value="#getTransferOrder.ORDER_EMPLOYEE_NAME# #getTransferOrder.ORDER_EMPLOYEE_SURNAME#" style="width:100px;" <!--- onfocus="AutoComplete_Create('transport_ordering_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,transport_ordering_employee_id,from_partner_id','','3','250');" ---> autocomplete="off" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=transportOrdersForm.transport_ordering_employee_id&field_name=transportOrdersForm.transport_ordering_name&is_form_submitted=1&select_list=1,7,8','list');" title="<cf_get_lang dictionary_id='62090.Emri Veren'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-operator">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Operator</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="operator_employee_id" id="operator_employee_id" value="#getTransferOrder.OPARATOR_EMPLOYEE_ID#">          
                                        <input type="text" name="operator_name" id="operator_name" value="#getTransferOrder.OPARATOR_EMPLOYEE_NAME# #getTransferOrder.OPARATOR_EMPLOYEE_SURNAME#" style="width:100px;" <!--- onfocus="AutoComplete_Create('operator_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,operator_employee_id,from_partner_id','','3','250');" ---> autocomplete="off" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=transportOrdersForm.operator_employee_id&field_name=transportOrdersForm.operator_name&is_form_submitted=1&select_list=1,7,8','list');" title="<cf_get_lang dictionary_id='62090.Emri Veren'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-department_location">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62089.Çıkış Tank'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                                    <cfif len(getTransferOrder.DEPARTMENT_EXIT_ID)>
                                        <cfset location_info_ = get_location_info(getTransferOrder.DEPARTMENT_EXIT_ID,getTransferOrder.LOCATION_EXIT_ID,1,1)>
                                        <cfset attributes.department_exit_id = getTransferOrder.DEPARTMENT_EXIT_ID>
                                        <cfset attributes.location_exit_id = getTransferOrder.LOCATION_EXIT_ID>
                                    <cfelse>
                                        <cfset location_info_ = ''>
                                        <cfset attributes.department_exit_id = ''>
                                        <cfset attributes.location_exit_id = ''>
                                    </cfif>
                                    <cf_wrkdepartmentlocation
                                        returninputvalue="location_exit_id,department_exit_name,department_exit_id,branch_exit_id"
                                        returninputquery="LOCATION_EXIT_ID,DEPARTMENT_EXIT_NAME,DEPARTMENT_EXIT_ID,BRANCH_EXIT_ID"
                                        fieldname="department_exit_name"
                                        fieldid="location_exit_id"
                                        department_fldid="department_exit_id"
                                        branch_fldid="branch_exit_id"
                                        branch_id="#listlast(location_info_,',')#"
                                        department_id="#attributes.department_exit_id#"
                                        location_id="#attributes.location_exit_id#"
                                        location_name="#listfirst(location_info_,',')#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="135">
                                </div>
                            </div>
                            <div class="form-group" id="item-department_location">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62088.Giriş Tank'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                                    <cfif len(getTransferOrder.DEPARTMENT_ENTRY_ID)>
                                        <cfset location_info_ = get_location_info(getTransferOrder.DEPARTMENT_ENTRY_ID,getTransferOrder.LOCATION_ENTRY_ID,1,1)>
                                        <cfset attributes.department_entry_id = getTransferOrder.DEPARTMENT_ENTRY_ID>
                                        <cfset attributes.location_entry_id = getTransferOrder.LOCATION_ENTRY_ID>
                                    <cfelse>
                                        <cfset location_info_ = ''>
                                        <cfset attributes.department_entry_id = ''>
                                        <cfset attributes.location_entry_id = ''>
                                    </cfif>
                                    <cf_wrkdepartmentlocation
                                        returninputvalue="location_entry_id,department_entry_name,department_entry_id,branch_entry_id"
                                        returninputquery="LOCATION_ENTRY_ID,DEPARTMENT_ENTRY_NAME,DEPARTMENT_ENTRY_ID,BRANCH_ENTRY_ID"
                                        fieldname="department_entry_name"
                                        fieldid="location_entry_id"
                                        department_fldid="department_entry_id"
                                        branch_fldid="branch_entry_id"
                                        branch_id="#listlast(location_info_,',')#"
                                        department_id="#attributes.department_entry_id#"
                                        location_id="#attributes.location_entry_id#"
                                        location_name="#listfirst(location_info_,',')#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="135">
                                </div>
                            </div> 
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-product_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no ='245.Ürün'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="stock_id"  id="stock_id" value="#getTransferOrder.STOCK_ID#">
                                        <input type="hidden" name="product_id"  id="product_id" value="#getTransferOrder.PR_PRODUCT_ID#">
                                        <input type="text" name="product_name" id="product_name" value="#getTransferOrder.PR_PRODUCT_NAME#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');" style="width:100px;">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_id=TransportOrdersForm.stock_id&product_id=TransportOrdersForm.product_id&field_name=TransportOrdersForm.product_name&field_unit=TransportOrdersForm.unit_product_id&field_unit_name=TransportOrdersForm.unit_product_name&field_amount=TransportOrdersForm.amount&product_cat_code=10.01&product_cat=Bakım','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_unit">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'> / <cf_get_lang dictionary_id='57636.Birim'></label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <span class="input-group-addon"><cfinput type="checkbox" name="transport_quantity_status" id="transport_quantity_status" value=""></span>
                                        <input type="text" name="amount" id="amount" value="#getTransferOrder.AMOUNT#" onkeyup="return(FormatCurrency(this,event));">
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="hidden" name="unit_product_id"  id="unit_product_id" value="#getTransferOrder.UNIT_PRODUCT_ID#">
                                    <input type="text" name="unit_product_name" id="unit_product_name" value="#getTransferOrder.MAIN_UNIT#"> 
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6">
                        </div>
                        <div class="col col-6">
                            <cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.transfer_order&event=del&id=#attributes.refinery_transport_id#'>
                        </div>
                    </cf_box_footer>
                </cf_box>
            </cfform>
        </div>
    </cfoutput>
</cfif>