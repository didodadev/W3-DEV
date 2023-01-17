<!---
    File: detail_custom_export.cfm
    Controller: CustomExportController.cfm
    Folder: invoice\form\upd_custom_export.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 2002/02/20 14:23:21
    Description:Dış Ticaret > İhracat İşlemleri detay sayfası.
    History:      
    To Do:
--->
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfinclude template="../../cash/query/get_money.cfm">
<cfset xml_genel_number=4>
<cfset xml_satir_number=4>
<cfset getComponent = createObject('component','V16.invoice.cfc.custom_export')>
<cfset getCustomDecleration=getComponent.GET_CUSTOM_DECLERATION(export_id:url.export_id)>
<cfset get_country = cmp.getCountry()>
<cfform name="upd_custom_export" action="V16/invoice/cfc/custom_export.cfc?method=upd_custom_export&export_id=#url.export_id#" method="post">
    <cfinput type="hidden" name="invoice_export_id" id="invoice_export_id" value="#url.iid#">
    <cfinput type="hidden" name="declaration" id="declaration" value="#getCustomDecleration.declaration#"/>
    <cfinput type="hidden" name="invoice_paper_no" id="invoice_paper_no" value="#url.invoice_paper_no#"/>
    <cf_box_elements vertical="1">
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>1.<cf_get_lang dictionary_id='47991.Beyan'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <cfscript>
                        beyan_name="";
                        beyan_name1 = "";
                        beyan_name2 = "";
                        if(len(getCustomDecleration.declaration)){                    
                       beyan_name = (listgetAt('#getCustomDecleration.declaration#',1) EQ 'NULL')?'':listgetAt('#getCustomDecleration.declaration#',1);
                       beyan_name1 = (listgetAt('#getCustomDecleration.declaration#',2) EQ 'NULL')?'':listgetAt('#getCustomDecleration.declaration#',2);
                       beyan_name2 = (listgetAt('#getCustomDecleration.declaration#',3) EQ 'NULL')?'':listgetAt('#getCustomDecleration.declaration#',3); 
                    }
                    </cfscript> 
                    <cfinput type="text" name="beyan_name" id="beyan_name" value="#beyan_name#" onBlur="Inputkontrol();">
                </div>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <cfinput type="text" name="beyan_name1" id="beyan_name1" value="#beyan_name1#" onBlur="Inputkontrol();">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" name="beyan_name2" id="beyan_name2" value="#beyan_name2#" onBlur="Inputkontrol();">
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>2.<cf_get_lang dictionary_id='60308.Gönderici'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">             
                <cfinput type="hidden" name="sender_id" id="sender_id" value="#session.ep.userid#">
                <cfinput type="text" name="sender" value="#session.ep.name# #session.ep.surname#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='60307.Beyanname No'>*</label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="decleration_no" value="#getCustomDecleration.decleration_no#" required="true">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>8.<cf_get_lang dictionary_id='58733.Alıcı'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfinput type="hidden" name="buyer_id" id="buyer_id" value="#getCustomDecleration.DECLERATION_BUYER#">
                    <cfinput type="text" name="buyer" id="buyer" value="#get_emp_info(getCustomDecleration.DECLERATION_BUYER,0,0)#" onFocus="AutoComplete_Create('buyer','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','COMPANY_ID,PARTNER_ID,EMPLOYEE_ID','buyer_id,buyer_id,buyer_id','','3','200','get_company()');">
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_custom_export.buyer_id&field_emp_id=upd_custom_export.buyer_id&field_comp_id=upd_custom_export.buyer_id&field_name=upd_custom_export.buyer&select_list=1,2</cfoutput>','list');"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='60336.Rejim'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="regim" id="regim" value="#getCustomDecleration.REGIME#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>9.<cf_get_lang dictionary_id='60310.Mali Sorumlu'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfinput type="hidden" name="financial_reponsible_id" id="financial_reponsible_id" value="#getCustomDecleration.FINANCIAL_RESPONSIBLE_COMPANY#">
                    <cfinput type="text" name="financial_reponsible" id="financial_reponsible" value="#get_emp_info(getCustomDecleration.FINANCIAL_RESPONSIBLE_COMPANY,0,0)#" onFocus="AutoComplete_Create('financial_reponsible','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','COMPANY_ID,PARTNER_ID,EMPLOYEE_ID','financial_reponsible_id,financial_reponsible_id,financial_reponsible_id','','3','200','get_company()');">
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_custom_export.financial_reponsible_id&field_emp_id=upd_custom_export.financial_reponsible_id&field_comp_id=upd_custom_export.financial_reponsible_id&field_name=upd_custom_export.financial_reponsible&select_list=1,2</cfoutput>','list');"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>4.<cf_get_lang dictionary_id='60309.Yükleme Listeleri'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="loading_list" id="loading_list" value="#getCustomDecleration.LOADING_PLACE#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>10.<cf_get_lang dictionary_id='60311.İlk Varış Ülke'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <select name="decleration_country" id="decleration_country">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#country_id#" <cfif getCustomDecleration.FIRST_DESTINATION_COUNTRY eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>  
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>5.<cf_get_lang dictionary_id='60314.Kalem Sayısı'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="pencil_count" value="">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>11.<cf_get_lang dictionary_id='60312.Ticaret Yapan Ülke'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <select name="trader_country" id="trader_country">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#country_id#" <cfif getCustomDecleration.TRADER_COUNTRY eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>  
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>6.<cf_get_lang dictionary_id='60337.Kap Adedi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="kap_adedi" value="">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>13.<cf_get_lang dictionary_id='60338.Tarım Politikası'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="farm_policy" id="farm policy" value="#getCustomDecleration.FARM_POLICY#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>7.<cf_get_lang dictionary_id='58794.Referans No'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfinput type="text" name="reference_no" id ="reference_no" value="#getCustomDecleration.REFERENCE_NO#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>14.<cf_get_lang dictionary_id='60339.Beyan Sahibi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfinput type="hidden" name="decleration_company_id" id="decleration_company_id" value="">
                    <cfinput type="text" name="decleration_company" id="decleration_company" value="" onFocus="AutoComplete_Create('beyan_sahibi','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','COMPANY_ID,PARTNER_ID,EMPLOYEE_ID','beyan_sahibi_id,beyan_sahibi_id,beyan_sahibi_id','','3','200','get_company()');">
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_custom_export.beyan_sahibi_id&field_emp_id=upd_custom_export.beyan_sahibi_id&field_comp_id=upd_custom_export.beyan_sahibi_id&field_name=upd_custom_export.beyan_sahibi&select_list=1,2</cfoutput>','list');"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>15.<cf_get_lang dictionary_id='60340.Sevk/İhracat Ülkesi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <select name="export_country" id="export_country">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#country_id#" <cfif getCustomDecleration.EXPORTER_COUNTRY eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>  
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>17.<cf_get_lang dictionary_id='60342.Varış Ülkesi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <select name="country_destination" id="country_destination">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#country_id#" <cfif getCustomDecleration.FINAL_DESTINATION_COUNTRY eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>  
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>24.<cf_get_lang dictionary_id='51040.Sözleşme Tipi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <select name="contract_type" id="contract_type">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="1" <cfif getCustomDecleration.CONTRATCT_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
                    <option value="2" <cfif getCustomDecleration.CONTRATCT_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
                </select>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>54.<cf_get_lang dictionary_id='60344.Beyan Tarihi'>*</label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='60344.Beyan Tarihi'></cfsavecontent>
                    <cfinput type="text" name="decleration_date" id="decleration_date" message = "#message#" required="true" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='60345.Gümrük Musaviri'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfoutput>
                        <input type="hidden" name="customs_company_id" id="customs_company_id" value="">
                        <input type="hidden" name="customs_partner_id" id="customs_partner_id" value="">
                        <input type="hidden" name="customs_consumer_id" id="customs_consumer_id" value="">
                        <input type="text" name="customs_comp_name" id="customs_comp_name" value="#get_par_info(getCustomDecleration.CUSTOM_BROKER,0,0,0)#" onfocus="AutoComplete_Create('customs_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','customs_company_id,customs_comp_name,customs_partner_id,sup_partner_name','','3','170');">
                    </cfoutput>
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_partner=upd_custom_export.customs_partner_id&field_comp_name=upd_custom_export.customs_comp_name&field_comp_id=upd_custom_export.customs_company_id&field_consumer=upd_custom_export.customs_consumer_id&select_list=1,2,3','list','popup_list_pars');"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='32655.Onay Tarihi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfinput type="text" name="approve_date" id="approve_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>25.<cf_get_lang dictionary_id='60362.Sınırdaki Taşıma Şekli'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cf_wrk_dynamic_params 
                returninputvalue="outland_transport_type_id,outland_transport_type"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="25"
                type_name="Sınırdaki Taşıma  Şekilleri"
                fieldId="outland_transport_type_id" 
                fieldName="outland_transport_type"
                line_info="25"
                data_id="#getCustomDecleration.outland_transport_type#">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='60350.Kapama Tarihi'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <div class="input-group">
                    <cfinput type="text" name="onay_date"  value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>26.<cf_get_lang dictionary_id='60353.Dahili Taşıma Şekli'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cf_wrk_dynamic_params 
                returninputvalue="domestic_transport_type_id,domestic_transport_type"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="26"
                defaultColumnList="Taşıma Şekilleri"
                type_name="Dahili Taşıma Şekli"
                fieldId="domestic_transport_type_id" 
                fieldName="domestic_transport_type"
                data_id="#getCustomDecleration.domestic_transport_type#"
                line_info="26">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cfsavecontent  variable="ExitCustonName"><cf_get_lang dictionary_id='60354.Çıkış Gümrük İdaresi'></cfsavecontent>
                <label>29.<cfoutput>#ExitCustonName#</cfoutput></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cf_wrk_dynamic_params 
                returninputvalue="exit_custom_office_id,exit_custom_office"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="29"
                type_name="#ExitCustonName#"
                fieldId="exit_custom_office_id" 
                fieldName="exit_custom_office"
                data_id="#getCustomDecleration.exit_custom_office#"
                line_info="29">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cfsavecontent  variable="goodsName"><cf_get_lang dictionary_id='60355.Eşyanın Bulunduğu Yer'></cfsavecontent>
                <label>30.<cf_get_lang dictionary_id='60355.Eşyanın Bulunduğu Yer'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cf_wrk_dynamic_params 
                returninputvalue="goods_place_id,goods_place"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="30"
                type_name="#goodsName#"
                fieldId="goods_place_id" 
                fieldName="goods_place"
                data_id="#getCustomDecleration.goods_place#"
                line_info="30">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cfsavecontent  variable="UnbonnedName"><cf_get_lang dictionary_id='60356.Antrepo'></cfsavecontent>
                <label>49.<cfoutput>#UnbonnedName#</cfoutput></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cf_wrk_dynamic_params 
                returninputvalue="unbonded_warehouse_id,unbonded_warehouse"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="49"
                type_name="#UnbonnedName#"
                fieldId="unbonded_warehouse_id" 
                fieldName="unbonded_warehouse"
                data_id="#getCustomDecleration.unbonded_warehouse#"
                line_info="49">
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label>27.<cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <textarea name="loading_place" id="loading_place"></textarea>
            </div>
        </div>
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <textarea></textarea>
            </div>
        </div>
    </cf_box_elements>
    <cfsavecontent  variable="head_"><cf_get_lang dictionary_id='60341.Taşıma Bilgileri'></cfsavecontent>
    <cf_seperator title="#head_#" id="transport_information">
    <cf_box_elements vertical="1" id="transport_information">
        <div class="col col-12">
        <div class="col col-4">
        <label class="bold">18.<cf_get_lang dictionary_id='60357.Taşıma Aracı Bölge Kodu'></label>
        </div>
        <div class="col col-4">
        </div>
        <div class="col col-4">
        <label class="bold">&nbsp;&nbsp;57.<cf_get_lang dictionary_id='64360.Sınırı Geçen Aracın Ülke Kodu'></label>
        </div>
        <br/><br/>
        </div>
        <div class="form-group col col-4">
            <cfsavecontent variable="TransportName"><cf_get_lang dictionary_id="60490.Taşıma Aracı Kodu"></cfsavecontent>
                <cf_wrk_dynamic_params 
                returninputvalue="transport_vehicle_code_id,transport_vehicle_code"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="18"
                type_name="#TransportName#"
                fieldId="transport_vehicle_code_id" 
                fieldName="transport_vehicle_code"
                placeHolder="#TransportName#"
                data_id="#getCustomDecleration.transport_vehicle_code#"
                line_info="18">
        </div>
        <div class="form-group col col-4">
            <cfinput type="text" name="transport_vehicle_info" id="transport_vehicle_info" value="#getCustomDecleration.transport_vehicle_info#" placeHolder="#getlang('','Taşıma Aracı Bilgisi','60357')#">
        </div>
        <div class="form-group col col-4">
            <cf_wrk_dynamic_params 
                returninputvalue="transport_vehicle_contry_id,transport_vehicle_contry"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="57"
                type_name="#getlang('','Taşıma Aracı Bölge Kodu','64360')#"
                fieldId="transport_vehicle_contry_id" 
                fieldName="transport_vehicle_contry"
                placeHolder="#getlang('','Taşıma Aracı Bölge Kodu','64360')#"
                data_id="#getCustomDecleration.transport_vehicle_contry#"
                line_info="57">
        </div>
        <div class="col col-12">
        <label class="bold">19.<cf_get_lang dictionary_id='60361.Konteyner/Konteyners'></label><br/><br/>
        </div>
        <div class="form-group col col-4">
            <cf_wrk_dynamic_params 
                returninputvalue="container_type_id,container_type"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="19"
                type_name="#getlang('','Konteyner','64360')#"
                fieldId="container_type_id" 
                fieldName="container_type"
                placeHolder="#getlang('','Konteyner','64360')#"
                data_id="#getCustomDecleration.container_type#"
                line_info="19">
        </div>
        <div class="form-group col col-4">
            <cfinput type="text" name="gross_kg" id="gross_kg" value="#getCustomDecleration.gross_kg#" placeHolder="#getlang('','Brüt Kg','64361')#">
        </div>
        <div class="form-group col col-4">
            <cfinput type="text" name="net_kg" id="net_kg" value="#getCustomDecleration.net_kg#" placeHolder="#getlang('','Net Kg','64362')#">
        </div>
        <div class="col col-12">
        <label class="bold">20.<cf_get_lang dictionary_id='60358.Teslim Şekli'></label><br/><br/>
        </div>
        <div class="form-group col col-4">
            <cf_wrk_dynamic_params 
                returninputvalue="delivery_code_id,delivery_code"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="20"
                type_name="#getlang('','Teslim Şekli','60358')#"
                fieldId="delivery_code_id" 
                fieldName="delivery_code"
                placeHolder="#getlang('','Teslim Şekli','60358')#"
                data_id="#getCustomDecleration.delivery_code#"
                line_info="20">
        </div>
        <div class="form-group col col-4">
        <cfoutput>
            <textarea name="delivery_adress" id="delivery_adress" placeHolder="#getlang('','Teslim Adresi','41807')#"><cfoutput>#getCustomDecleration.delivery_adress#</cfoutput></textarea>
        </cfoutput>
        </div>
        <div class="col col-12">
            <div class="col col-4">
        <label class="bold">21.<cf_get_lang dictionary_id='60360.Sınırı Geçen Araç Bilgisi'></label>
        </div>
        <div class="col col-4">
        <label class="bold">&nbsp;&nbsp;58.<cf_get_lang dictionary_id='64363.Sınırı Geçen Aracın Ülke Kodu'></label>
        </div>
        <div class="col col-4">
        </div>
            <br/><br/>
        </div>
        <div class="form-group col col-4">
            <cf_wrk_dynamic_params 
                returninputvalue="outland_vehicle_code_id,outland_vehicle_code"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="21"
                type_name="#getlang('','Sınırı Geçen Aracın Kodu','60360')#"
                fieldId="outland_vehicle_code_id" 
                fieldName="outland_vehicle_code"
                placeHolder="#getlang('','Sınırı Geçen Aracın Kodu','60360')#"
                data_id="#getCustomDecleration.outland_vehicle_code#"
                line_info="21">
        </div>
        <div class="form-group col col-4">
            <cf_wrk_dynamic_params 
                returninputvalue="outland_vehicle_contry_id,outland_vehicle_contry"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="58"
                type_name="#getlang('','Sınırı Geçen Aracın Ülkesi','64364')#"
                fieldId="outland_vehicle_contry_id" 
                fieldName="outland_vehicle_contry"
                placeHolder="#getlang('','Sınırı Geçen Aracın Ülke Kodu','64363')#"
                data_id="#getCustomDecleration.outland_vehicle_country#"
                line_info="58">
        </div>
        <div class="form-group col col-4">
        <cfoutput>
            <textarea name="outland_vehicle_info" id="outland_vehicle_info" placeHolder="#getlang('','Notlar','57422')#"><cfoutput>#getCustomDecleration.outland_vehicle_info#</cfoutput></textarea>
        </cfoutput>
    </div>
    </cf_box_elements>
    <cfsavecontent  variable="head_bed"><cf_get_lang dictionary_id='60346.Bedeler'></cfsavecontent>
    <cf_seperator title="#head_bed#" id="bedeler">
    <cf_box_elements vertical="1" id="bedeler">
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label>22.<cf_get_lang dictionary_id='60347.Fatura Bedeli'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='60347.Fatura Bedeli'></cfsavecontent>
                        <cfinput type="text" class="text-right" name="invoice_cost" id="total_1"  onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.invoice_cost)#" required="true" message="#message#">
                        <span class="input-group-addon width">
                            <select name="invoice_cost_money_type" id = "money_type_1" class="boxtext money_class" onChange="MoneyChange();">
                                <cfloop query="get_money">
									<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
                                    <cfoutput>
                                        <option value="#money_#,#rate1#,#rate2#" <cfif getCustomDecleration.invoice_cost_money_type  eq money_>selected</cfif>>#money_#</option>
                                    </cfoutput>
								</cfloop>
                            </select>
                        </span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='60348.Navlun Bedeli'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" class="text-right" name="transport_cost" id="total_2" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.transport_cost)#" required="true">
                        <span class="input-group-addon width">
                            <select  name="transport_cost_money_type" id = "money_type_2" class="boxtext money_class" onChange="MoneyChange();">
                                <cfloop query="get_money">
									<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
                                    <cfoutput>
                                        <option value="#money_#,#rate1#,#rate2#" <cfif getCustomDecleration.transport_cost_money_type  eq money_>selected</cfif>>#money_#</option>
                                    </cfoutput>
								</cfloop>
                            </select>
                        </span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='60349.Sigorta Bedeli'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" class="text-right" name="assurance_cost" id="total_3" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.assurance_cost)#" required="true">
                        <span class="input-group-addon width">
                            <select name="assurance_cost_money_type" id = "money_type_3" class="boxtext money_class" onChange="MoneyChange();">
                                <cfloop query="get_money">
									<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
                                    <cfoutput>
                                        <option value="#money_#,#rate1#,#rate2#" <cfif getCustomDecleration.assurance_cost_money_type  eq money_>selected</cfif>>#money_#</option>
                                    </cfoutput>
								</cfloop>
                            </select>
                        </span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='29691.Yurtiçi'><cf_get_lang dictionary_id='31116.Harcamalar'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" class="text-right" name="domestic_cost" id="total_4" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.domestic_cost)#" required="true">
                        <span class="input-group-addon width">
                            <select name="domestic_cost_money_type" id = "money_type_4" class="boxtext money_class" onChange="MoneyChange();">
                                <cfloop query="get_money">
									<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
                                    <cfoutput>
                                        <option value="#money_#,#rate1#,#rate2#" <cfif getCustomDecleration.domestic_cost_money_type  eq money_>selected</cfif>>#money_#</option>
                                    </cfoutput>
								</cfloop>
                            </select>
                        </span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='29692.Yurtdışı'><cf_get_lang dictionary_id='31116.Harcamalar'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" class="text-right" name="outland_cost" id="total_5" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.outland_cost)#" required="true">
                        <span class="input-group-addon width">
                            <select name="outland_cost_money_type" id = "money_type_5" class="boxtext money_class" onChange="MoneyChange();">
                                <cfloop query="get_money">
									<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
                                    <cfoutput>
                                        <option value="#money_#,#rate1#,#rate2#" <cfif getCustomDecleration.outland_cost_money_type  eq money_>selected</cfif>>#money_#</option>
                                    </cfoutput>
								</cfloop>
                            </select>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label> <cf_get_lang dictionary_id='64359.Dövizli Toplam'></label>
                </div>
                 <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                       <cfinput type="text" class="text-right" name="totatl_cost_other_money" id="totatl_cost_other_money" onkeyup="return(FormatCurrency(this,event));" value="#TLFORMAT(getCustomDecleration.TOTAL_COST_OTHER_MONEY)#" required="true">
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <cfinput type="text" class="text-right" name="totatl_cost_system_money_type" id="totatl_cost_system_money_type" onkeyup="return(FormatCurrency(this,event));" value="#getCustomDecleration.TOTAL_COST_MONEY_TYPE#" required="true" readonly>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='33046.Sistem Para Birimi'>- <cf_get_lang dictionary_id='57492.Toplam'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfinput type="text" class="text-right" name="totatl_cost_system" id="totatl_cost_system"  onkeyup="FormatCurrency(this,event,2,'float');" value="#TLFORMAT(getCustomDecleration.TOTAL_COST_SYTEM)#" required="true">
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group">
                <label class="col col-8 bolt"><cf_get_lang dictionary_id='30636.İşlem Para Br'></label>
            </div>
            <div class="col col-12">
                <cfif session.ep.rate_valid eq 1>
                    <cfset readonly_info = "yes">
                <cfelse>
                    <cfset readonly_info = "no">
                </cfif>
                <cfif get_money.recordcount>
                    <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
                        SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    </cfquery>
                    <cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
                        <cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
                    <cfelseif len(session.ep.money2)>
                        <cfset default_basket_money_=session.ep.money2>
                    <cfelse>
                        <cfset default_basket_money_=session.ep.money>
                    </cfif>
                    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                    <input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
                    <cfset str_money_bskt_found = true>
                    <cfoutput query="get_money">
                        <cfif IS_SELECTED>
                            <cfset str_money_bskt = money>
                            <cfset str_money_bskt_found = false>
                        <cfelseif str_money_bskt_found and money eq default_basket_money_>
                            <cfset str_money_bskt = money>
                            <cfset str_money_bskt_found = false>
                        </cfif>
                            <div class="form-group">
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-6">
                                    <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                    <input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="dovizli_toplam();" <cfif isDefined('str_money_bskt') and str_money_bskt eq money>checked</cfif>>
                                    <label>#money#</label>
                                </div>
                                <cfif session.ep.rate_valid eq 1>
                                    <cfset readonly_info = "yes">
                                <cfelse>
                                    <cfset readonly_info = "no">
                                </cfif>
                                <div class="col col-5 col-md-5 col-xs-6">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="txt_rate2_#currentrow#" money_type="#money#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,xml_genel_number)#" onkeyup="return(FormatCurrency(this,event,#xml_genel_number#));">
                                    </div>
                                </div>
                            </div>
                    </cfoutput>
                </cfif>
            </div>
        </div> 
    </cf_box_elements>
    <div class="ui-form-list-btn">
        <div class="col col-6">
            <cf_record_info 
                query_name="getCustomDecleration" 
                record_emp="RECORD_EMP" 
                update_emp="UPDATE_EMP" 
                record_date="RECORD_DATE" 
                update_date="UPDATE_DATE">
        </div>
        <div class="col col-6">
            <div class="form-group">
                <cf_workcube_buttons is_upd='1' add_function='Updatekontrol()' delete_page_url='V16/invoice/cfc/custom_export.cfc?method=dlt_DECLERATION&export_id=#url.export_id#'>
            </div>
        </div>
    </div>
</cfform>
<script>
    function Inputkontrol() {
        declaration_list = "";
        declaration_list_1 = "";
        declaration_list_2 = "";
        if($("#beyan_name").val() != '') declaration_list = $("#beyan_name").val();
        if($("#beyan_name1").val() != '') declaration_list_1 = $("#beyan_name1").val();
        if($("#beyan_name2").val() != '') declaration_list_2 = $("#beyan_name2").val();
        document.getElementById("declaration").value = declaration_list + ',' + declaration_list_1 + ',' + declaration_list_2;
    }
    function getTotalAmount(){
        if($("#invoice_cost").val() == '') $("#invoice_cost").val(commaSplit(0));
        if($("#transport_cost").val() == '') $("#transport_cost").val(0);
        if($("#assurance_cost").val() == '') $("#assurance_cost").val(0);
        if($("#domestic_cost").val() == '') $("#domestic_cost").val(0);
        if($("#outland_cost").val() == '') $("#outland_cost").val(0);
        /* invoice_amount = parseFloat(filterNum($("#invoice_cost").val()));
        tra_amount = parseFloat(filterNum($("#transport_cost").val()));
        ass_amount = parseFloat(filterNum($("#assurance_cost").val()));
        dom_amount = parseFloat(filterNum($("#domestic_cost").val()));
        out_amount = parseFloat(filterNum($("#outland_cost").val()));
        total_amount = invoice_amount + tra_amount + ass_amount + dom_amount + out_amount; */
        document.getElementById("total_1").value = commaSplit(filterNum(document.getElementById("total_1").value));
        document.getElementById("total_2").value = commaSplit(filterNum(document.getElementById("total_2").value));
        document.getElementById("total_3").value = commaSplit(filterNum(document.getElementById("total_3").value));
        document.getElementById("total_4").value = commaSplit(filterNum(document.getElementById("total_4").value));
        document.getElementById("total_5").value = commaSplit(filterNum(document.getElementById("total_5").value));
        /* document.getElementById("totatl_cost_system").value = commaSplit(total_amount);   */    
        MoneyChange();
    }
    function dovizli_toplam() {
        document.getElementById("totatl_cost_system_money_type").value = $('input[name=rd_money]:checked + label').text();
    }
    function MoneyChange(){
	deger_ =  { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0} ,</cfoutput> };
	i=0;
	$('select.money_class').each(function() {
		i++;
		var selectName = $("select[id=money_type_"+i+"]").val();
		var total_value = parseFloat(filterNum($("input[id=total_"+i+"]").val(),<cfoutput>#xml_satir_number#</cfoutput>));
		type = selectName.split(',')[0];
		deger_[type]["money"] += total_value;
        deger_["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += total_value / filterNum($("input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * filterNum($("input[money_type="+type+"]").val());
        deger_[type]["counter"] ++;
        deger_[type]["doviz_money_counter"] ++;
		deger_["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++; 
    });
    var dovizadi= $('input[name=rd_money]:checked + label').text();
     $("#totatl_cost_system").val(commaSplit(deger_["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"],2)).parent().find("span.input-group-addon > strong").html(deger_["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);
     $("#totatl_cost_other_money").val(commaSplit(deger_["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"]/filterNum($("input[money_type="+dovizadi+"]").val()),2)).parent().find("span.input-group-addon > strong").html(deger_[type]["doviz_money_counter"]);
	};
</script>
