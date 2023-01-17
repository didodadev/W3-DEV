<cfquery name="GET_CASH_POS" datasource="#DSN3#">
	SELECT POS_ID,EQUIPMENT FROM POS_EQUIPMENT <cfif session.ep.isBranchAuthorization>WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif> ORDER BY EQUIPMENT
</cfquery>
<cf_basket_form id="fatura">
	<cfoutput>
        <div id="hidden_fields_zreport" ></div>  
        <input type="hidden" name="x_show_info" id="x_show_info" value="#x_show_info#">	
        <input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">
        <input type="hidden" name="is_cash" id="is_cash" value="0">
        <input type="hidden" name="is_pos" id="is_pos" value="0">		
        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
        <input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.iid#">
        <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_daily_zreport">
    </cfoutput>
    <cf_box_elements>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group require" id="item-process_cat">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
                <div class="col col-8 col-sm-12">
                    <cf_workcube_process_cat process_cat='#get_sale_det.process_cat#' slct_width="140">
                </div>                
            </div> 
            <div class="form-group require" id="item-pos_cash_id">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39344.Yazar Kasa'>*</label>
                <div class="col col-8 col-sm-12">
                    <select name="pos_cash_id" id="pos_cash_id">
                        <cfoutput query="get_cash_pos">
                            <option value="#pos_id#" <cfif get_sale_det.pos_cash_id eq pos_id>selected</cfif>>#equipment#</option>
                        </cfoutput>
                    </select>
                </div>                
            </div> 
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group require" id="item-invoice_date">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30631.Tarih'>*</label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfinput type="text" name="invoice_date" style="width:90px;" required="Yes" message="#getLang('','Lütfen Tarih Giriniz',58503)#" value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_date"></span>
                    </div>
                </div>                
            </div> 
            <div class="form-group require" id="item-employee_id">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54577.Kasiyer'>*</label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_sale_det.sale_emp#</cfoutput>">
                        <input type="text" name="employee_name" id="employee_name" value="<cfif len(get_sale_det.sale_emp)><cfoutput>#get_emp_info(get_sale_det.sale_emp,0,0)#</cfoutput></cfif>" style="width:140px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.employee_name&field_emp_id=form_basket.employee_id</cfoutput>');"></span>
                    </div>
                </div>                
            </div> 
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group require" id="item-department_name">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfset location_info_ = get_location_info(get_sale_det.department_id,get_sale_det.department_location,1,1)>
                        <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_sale_det.department_id#</cfoutput>" >
                        <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_sale_det.department_location#</cfoutput>" >
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#listlast(location_info_,',')#</cfoutput>">
                        <cfinput type="text" name="department_name" value="#listfirst(location_info_,',')#" style="width:140px;" message="#getLang('','Depo Girmelisiniz',33242)#!" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name&field_id=department_id&field_location_id=location_id&branch_id=branch_id&is_no_sale=1&dsp_service_loc=1<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>')"></span>	
                    </div>	
                </div>
            </div>
            <div class="form-group require" id="item-invoice_number">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
                <div class="col col-8 col-sm-12">
                    <cfinput type="text" maxlength="50" name="invoice_number" value="#get_sale_det.invoice_number#" required="yes" message="#getLang('','Belge No Girmelisiniz',54868)#!">
                </div>                
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group require" id="item-note">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                <div class="col col-8 col-sm-12">
                    <textarea name="note" id="note" style="width:135px;height:45px;"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
                </div>                
            </div> 
        </div>
    </cf_box_elements>
    <cf_box_footer>
    	<cf_record_info query_name="get_sale_det">
         <cfquery name="GET_BANK_ACTION_INFO" datasource="#DSN2#">
            SELECT
                INVOICE.INVOICE_ID
            FROM
                INVOICE,
                INVOICE_CASH_POS,
                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CC
            WHERE
                INVOICE.INVOICE_ID = INVOICE_CASH_POS.INVOICE_ID AND
                INVOICE_CASH_POS.POS_ACTION_ID = CC.CREDITCARD_PAYMENT_ID AND
                CC.BANK_ACTION_ID IS NOT NULL AND
                INVOICE.INVOICE_ID = #attributes.iid#
        </cfquery>
        <cfif get_bank_action_info.recordcount>
            <font color="red"><cf_get_lang dictionary_id='63268.Kredi Kartı Tahsilatlarınızın Hesaba Geçişlerini Yaptığınız İçin,Hesaba Geçiş İşlemlerinizi Geri Almadan İşlemi Güncelleyemezsiniz'>!</font>
        <cfelse>
            <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' del_function='kontrol2()' update_status='#get_sale_det.upd_status#'>
        </cfif>
    </cf_box_footer>
</cf_basket_form>

