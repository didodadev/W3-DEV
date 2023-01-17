<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset get_opportunity = opportunitiesCFC.GET_OPPORTUNITY(opp_id : url.opp_id)>
<cfset get_opportunity_type = opportunitiesCFC.GET_OPPORTUNITY_TYPE(OPPORTUNITY_TYPE_ID : get_opportunity.OPPORTUNITY_TYPE_ID)>
<cfset get_moneys = opportunitiesCFC.GET_MONEYS()>
<cfset get_probability_rate = opportunitiesCFC.GET_PROBABILITY_RATE()>
<cfset get_opp_currencies = opportunitiesCFC.GET_OPP_CURRENCIES()>

<cfform enctype="multipart/form-data" method="post" name="upd_opp">
    <input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#opp_id#</cfoutput>">
    <input type="hidden" name="old_process_stage" id="old_process_stage" value="<cfoutput>#get_opportunity.opp_stage#</cfoutput>">
    <style>.ck-editor__editable{height:200px}</style>
    <div class="ui-scroll">
        <cfoutput query="get_opportunity">
            <div class="row mb-2">
                <div class="col-lg-12 col-xl-12">
                    <div class="form-group">
                        <input type="text" class="form-control" id="opp_head" name="opp_head" value="#opp_head#">
                    </div>                
                </div>
            </div>
            <div class="row mb-2">
                <div class="col-lg-12 col-xl-12">
                    <textarea class="form-control" id="opp_detail" name="opp_detail">#opp_detail#</textarea>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-lg-4 col-xl-4" id="item-opp_stage">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58859.Süreç'> *</label>        
                    <cf_workcube_process is_upd='0' select_value='#get_opportunity.opp_stage#' is_detail='1'>        
                </div>
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57482.Aşama'></label>            
                    <select class="form-control" name="opp_currency_id" id="opp_currency_id">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seciniz'></option>
                        <cfloop query="get_opp_currencies">
                            <option value="#opp_currency_id#" <cfif opp_currency_id eq get_opportunity.opp_currency_id>selected</cfif>>#opp_currency#</option>
                        </cfloop>
                    </select>
                </div>    
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
                    <select name="opportunity_type_id" id="opportunity_type_id" class="form-control input-color-6">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="get_opportunity_type">
                            <option value="#opportunity_type_id#" <cfif opportunity_type_id eq get_opportunity.opportunity_type_id>selected</cfif>>#opportunity_type#</option>
                        </cfloop>
                    </select>
                </div>
                
            </div>
            <div class="row mb-3">
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                    <div class="input-group">
                        <input type="hidden" name="old_company_id" id="old_company_id" value="#get_opportunity.company_id#">
                        
                            <input type="hidden" name="old_company_id" id="old_company_id" value="#get_opportunity.company_id#">
                            <cfif len(get_opportunity.partner_id)>
                                <input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
                                <input type="hidden" name="member_type" id="member_type" value="partner">
                                <input type="hidden" name="member_id" id="member_id" value="#get_opportunity.partner_id#">
                                <input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.partner_id#">                    
                                <input class="form-control" type="text" name="company" id="company" value="#get_par_info(get_opportunity.company_id,1,0,0)#" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                <div class="input-group-append">
                                    <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8');"></span>
                                </div>
                            <cfelseif len(get_opportunity.consumer_id)>
                                <input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
                                <input type="hidden" name="member_type" id="member_type" value="consumer">
                                <input type="hidden" name="member_id" id="member_id"  value="#get_opportunity.consumer_id#">
                                <input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.consumer_id#">
                                
                                <input class="form-control" type="text" name="company" id="company"  value="#get_cons_info(get_opportunity.consumer_id,0,0,0)#" readonly onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                <div class="input-group-append">
                                    <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8');"></span>
                                </div>
                            <cfelse>
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input type="hidden" name="member_type" id="member_type" value="">
                                <input type="hidden" name="member_id" id="member_id" value="">
                                <input type="hidden" name="old_member_id" id="old_member_id"  value="">                    
                                <input class="form-control" type="text" name="company" id="company"  value="" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                <div class="input-group-append">
                                    <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8');"></span>
                                </div>
                            </cfif>
                            
                    </div>
                </div>
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='32575.İş Ortağı'></label>
                    <div class="input-group">
                        <cfif len(get_opportunity.sales_partner_id)>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="#get_opportunity.sales_partner_id#">
                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
                            <input type="text" class="form-control" name="sales_member" id="sales_member" value="#get_par_info(get_opportunity.sales_partner_id,0,-1,0)#" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                            <div class="input-group-append">
                                <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_id=upd_opp.sales_member_id&field_name=upd_opp.sales_member&field_type=upd_opp.sales_member_type&select_list=7,8');"></span>
                            </div>
                        <cfelseif len(get_opportunity.sales_consumer_id)>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="#get_opportunity.sales_consumer_id#">
                            <input type="hidden" name="sales_member_type" id="sales_member_type"  value="consumer">
                            <input type="text" class="form-control" name="sales_member" id="sales_member" value="#get_cons_info(get_opportunity.sales_consumer_id,0,0)#" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                            <div class="input-group-append">
                                <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_id=upd_opp.sales_member_id&field_name=upd_opp.sales_member&field_type=upd_opp.sales_member_type&select_list=7,8');"></span>
                            </div>
                        <cfelse>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="">
                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="">
                            <input type="text" class="form-control" name="sales_member" id="sales_member"  value="" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                            <div class="input-group-append">
                                <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&is_period_kontrol=0&field_id=upd_opp.sales_member_id&field_name=upd_opp.sales_member&field_type=upd_opp.sales_member_type&select_list=7,8');"></span>
                            </div>
                        </cfif>
                    </div>
                </div>
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='61836.Kontak'></label>
                    <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="#get_opportunity.sales_emp_id#">
                    <div class="input-group">
                        <input type="text" name="sales_emp" id="sales_emp" class="form-control" value="<cfif len(get_opportunity.sales_emp_id)>#get_emp_info(get_opportunity.sales_emp_id,0,0)#</cfif>" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','140');" autocomplete="off">
                        <div class="input-group-append">
                            <span class="input-group-text btnPointer icon-ellipsis" onClick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&draggable=1&field_emp_id=upd_opp.sales_emp_id&field_name=upd_opp.sales_emp&select_list=1');"></span>
                        </div>
                    </div>
                </div>   
            </div>
            <div class="row mb-3">
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                    <cfif len(get_opportunity.partner_id)>
                        <input type="text" name="member" id="member" class="form-control" value="#get_par_info(get_opportunity.partner_id,0,-1,0)#" readonly>
                    <cfelseif len(get_opportunity.consumer_id)>
                        <input type="text" name="member" id="member" class="form-control" value="#get_cons_info(get_opportunity.consumer_id,0,0,0)#" readonly>
                    <cfelse>
                        <input type="text" name="member" id="member" class="form-control" value="" readonly>
                    </cfif>        
                </div>
                <div class="col-lg-4 col-xl-3">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='61880.Gelir Potansiyeli'></label>                
                    <input type="text" name="income" id="income" class="form-control text-right" value="#TLFormat(get_opportunity.income)#" onkeyup="return(FormatCurrency(this,event));">
                </div>
                <div class="col-xl-1 mt-auto pl-0">            
                    <select name="money" id="money" class="form-control">
                        <cfloop query="get_moneys">
                            <option value="#money#" <cfif money is get_opportunity.money>selected</cfif>>#money#</option>
                        </cfloop>
                    </select>             
                </div>
                <div class="col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58652.Olasılık'></label>
                    <select class="form-control" name="probability" id="probability">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="get_probability_rate">
                            <option value="#probability_rate_id#" <cfif get_opportunity.probability eq probability_rate_id>selected</cfif>><!--- #get_probability_rate.probability_name# ---> #get_probability_rate.probability_name#</option>
                        </cfloop>
                    </select>
                </div>   
            </div>
        </cfoutput>
    </div> 
    <div class="draggable-footer">
        <cf_workcube_buttons is_upd="1" data_action="V16/objects2/protein/data/opportunities_data:UPD_OPPORTUNITY" next_page="#site_language_path#/opportunitiesDetail?opp_id="  del_action="V16/objects2/protein/data/opportunities_data:DEL_OPPORTUNITY:#opp_id#" del_next_page="#site_language_path#/opportunities">
    </div> 
</cfform> 

<script>
    ClassicEditor
        .create( document.querySelector( '#opp_detail' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
        } )
        .catch( err => {
            console.error( err.stack );
        } );
    function kontrol(){
        var myEditor;
        document.getElementById('opp_detail').value = myEditor.instances.opp_detail.getData();	
        console.log(myEditor);
    }            
</script>