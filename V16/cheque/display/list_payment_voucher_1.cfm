<cf_box scroll="0">
    <cf_box_search more="0">
        <div class="form-group">
            <div class="input-group">
                <input type="hidden" name="voucher_ids" id="voucher_ids" value="">
                <input type="hidden" name="voucher_ids_2" id="voucher_ids_2" value="">
                <input type="hidden" name="voucher_ids_3" id="voucher_ids_3" value="">
                <input type="hidden" name="cash" id="cash" value="0">
                <input type="hidden" name="is_bank" id="is_bank" value="0">
                <input type="hidden" name="is_pos" id="is_pos" value="0">	
                <input type="hidden" name="creditcard_revenue_id" id="creditcard_revenue_id" value="">	
                <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    <cfset attributes.company = get_par_info(attributes.company_id,1,0,0)>
                <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    <cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
                </cfif>
                <input type="hidden" name="company_id" id="company_id" <cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.company_id)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                <input type="hidden" name="consumer_id" id="consumer_id" <cfif isdefined("attributes.consumer_id") and len(attributes.company) and len(attributes.consumer_id)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                <input type="hidden" name="member_type" id="member_type" <cfif isdefined("attributes.member_type") and len(attributes.company) and len(attributes.member_type)> value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
                <input type="text" placeholder="<cfoutput>#getLang('main',107)#</cfoutput>" name="company" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','225');" value="<cfif isdefined("attributes.company") and len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=add_voucher_action.company_id&field_member_name=add_voucher_action.company&field_name=add_voucher_action.company&field_consumer=add_voucher_action.consumer_id&field_type=add_voucher_action.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');"title="<cf_get_lang_main no='107.Cari Hesap'>"></span>
            </div>
        </div>
        <div class="form-group">
            <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='175' selected_value='#attributes.branch_id#' option_value="#getLang('main',41)#"> <!--- Şube --->
        </div>
        <div class="form-group">
            <select name="paper_type" id="paper_type">
                <option value=""><cf_get_lang_main no='1121.Belge Tipi'></option>
                <option value="0" <cfif attributes.paper_type eq 0>selected</cfif>><cf_get_lang_main no='596.Senet'></option>
                <option value="1" <cfif attributes.paper_type eq 1>selected</cfif>><cf_get_lang_main no='2148.Ödeme Sözü'></option>
            </select>
        </div>
        <div class="form-group">
            <select name="is_payment" id="is_payment">
                <option value="0" <cfif isdefined("attributes.is_payment") and attributes.is_payment eq 0>selected</cfif>><cf_get_lang_main no ='296.Tümü'></option>
                <option value="1" <cfif isdefined("attributes.is_payment") and attributes.is_payment eq 1>selected</cfif>><cf_get_lang no ='233.Ödenmemiş Senetler'></option>
                <option value="2" <cfif isdefined("attributes.is_payment") and attributes.is_payment eq 2>selected</cfif>><cf_get_lang no ='234.Ödenmiş Senetler'></option>
            </select>
        </div>
        <div class="form-group">
            <cfsavecontent variable="message"><cf_get_lang_main no='238.Dök'></cfsavecontent>
            <cf_wrk_search_button button_type="4" search_function="kontrol()" button_name="#message#">
        </div>
        <div class="form-group">
            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                <cfquery name="get_law_request" datasource="#dsn#">
                    SELECT FILE_NUMBER FROM COMPANY_LAW_REQUEST WHERE COMPANY_ID = #attributes.company_id# AND REQUEST_STATUS = 1
                </cfquery>
            <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                <cfquery name="get_law_request" datasource="#dsn#">
                    SELECT FILE_NUMBER FROM COMPANY_LAW_REQUEST WHERE CONSUMER_ID = #attributes.consumer_id# AND REQUEST_STATUS = 1
                </cfquery>
            <cfelse>
                <cfset get_law_request.recordcount = 0>
            </cfif>
            <cfif get_law_request.recordcount>
            &nbsp;<font color="FF0000"><cf_get_lang no ='235.Bu Cari İçin İcra Takibi Bulunmaktadır'>(<cf_get_lang no ='236.Dosya No'> : <cfoutput>#get_law_request.file_number#</cfoutput>)</font>
            </cfif>
        </div>
    </cf_box_search>
</cf_box>