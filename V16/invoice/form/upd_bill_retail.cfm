<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.detail_invoice_retail">
<cfif isnumeric(attributes.iid)>
    <cfinclude template="../query/get_sale_det.cfm">
<cfelse>
    <cfset get_sale_det.recordcount = 0>
</cfif>
<cfif not get_sale_det.recordcount>
<cfset hata  = 11>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
<cfset hata_mesaj  = message>
<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfinclude template="../query/get_inv_cancel_types.cfm">
<cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
<cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
<cfparam name="attributes.other_amount" default="1">
<cfif isdefined("GET_SALE_DET.COMPANY_ID") and len(GET_SALE_DET.COMPANY_ID)>
    <cfquery name="get_tc"  datasource="#DSN#">
        SELECT TC_IDENTITY
        FROM COMPANY_PARTNER
        WHERE COMPANY_ID = #GET_SALE_DET.COMPANY_ID# 
        AND COMPANY_PARTNER_STATUS = 1 
    </cfquery>
</cfif>
<cfscript>
    session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);
    xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
        if (len(GET_SALE_DET.COMPANY_ID))
        {
            member_tax_office=GET_SALE_DET_COMP.TAXOFFICE;
            member_tax_no=GET_SALE_DET_COMP.TAXNO;
            member_tel_cod=GET_SALE_DET_COMP.COMPANY_TELCODE;
            member_tel=GET_SALE_DET_COMP.COMPANY_TEL1;
            member_fax=GET_SALE_DET_COMP.COMPANY_FAX;
            member_adres=GET_SALE_DET_COMP.COMPANY_ADDRESS;
            member_city=GET_SALE_DET_COMP.CITY;
            member_county=GET_SALE_DET_COMP.COUNTY;
            member_country=GET_SALE_DET_COMP.COUNTRY;
            member_mail=GET_SALE_DET_COMP.COMPANY_EMAIL;
            member_code=GET_SALE_DET_COMP.MEMBER_CODE;
            ims_code_id_ = GET_SALE_DET_COMP.IMS_CODE_ID;
            member_mobil_cod= GET_SALE_DET_COMP.MOBIL_CODE;
            member_mobil= GET_SALE_DET_COMP.MOBILTEL;
            member_tc_no='';
            vocation_type='';
            member_type=GET_SALE_DET_COMP.COMPANYCAT_ID;
        }
        else if(len(GET_SALE_DET.CONSUMER_ID))
        {
            member_tax_office=GET_CONS_NAME.TAX_OFFICE;
            member_tax_no=GET_CONS_NAME.TAX_NO;
            member_tel_cod=GET_CONS_NAME.CONSUMER_WORKTELCODE;
            member_tel=GET_CONS_NAME.CONSUMER_WORKTEL;
            member_fax=GET_CONS_NAME.CONSUMER_FAX;
            member_adres=GET_CONS_NAME.TAX_ADRESS;
            member_city=GET_CONS_NAME.TAX_CITY_ID;
            member_county=GET_CONS_NAME.TAX_COUNTY_ID;
            member_country=GET_CONS_NAME.TAX_COUNTRY_ID;
            member_mail=GET_CONS_NAME.CONSUMER_EMAIL;
            member_code=GET_CONS_NAME.MEMBER_CODE;
            member_mobil_cod=GET_CONS_NAME.MOBIL_CODE;
            member_mobil=GET_CONS_NAME.MOBILTEL;
            member_tc_no=GET_CONS_NAME.TC_IDENTY_NO;
            vocation_type=GET_CONS_NAME.VOCATION_TYPE_ID;
            ims_code_id_ = GET_CONS_NAME.IMS_CODE_ID;
            member_type=GET_CONS_NAME.CONSUMER_CAT_ID;
        }
</cfscript>
<cfquery name="GET_CITY" datasource="#dsn#">
    SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID=#member_country# ORDER BY CITY_NAME
</cfquery>
<cfparam name="attributes.member_type" default="2">
<cfparam name="attributes.comp_member_cat" default="">
<cfparam name="attributes.cons_member_cat" default="">
<cfquery name="get_vocation_type" datasource="#dsn#">
    SELECT VOCATION_TYPE_ID, VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY VOCATION_TYPE
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<div id="basket_main_div">
<cfform name="form_basket" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_retail" method="post">
<cf_basket_form id="upd_retail">
<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_retail</cfoutput>">
<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#get_order.order_id#</cfoutput>">
<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#attributes.iid#</cfoutput>">
<input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">
<input type="hidden" name="cash" id="cash" value="0"><!--- kasa tahsilatını tutar  --->
<input type="hidden" name="is_pos" id="is_pos" value=""><!--- pos tahsilatlarini gosterir --->
<cf_box_elements>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-member_name">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57570.Ad Soyad'>
            </div>
            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_sale_det.partner_id#</cfoutput>">
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_sale_det.consumer_id#</cfoutput>">
            <cfset str_par_name = "">
            <cfset str_par_surname = "">
            <cfif len(GET_SALE_DET.PARTNER_ID)>
                <cfset str_par_name = "#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME#">
                <cfset str_par_surname = "#GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#">
                <cfelseif len(get_sale_det.consumer_id)>
                <cfset str_par_name = "#get_cons_name.consumer_name#">
                <cfset str_par_surname = "#get_cons_name.consumer_surname#">
            </cfif>            
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <input type="text" name="member_name" id="member_name" value="<cfoutput>#str_par_name#</cfoutput>"  maxlength="50">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <input type="text" name="member_surname" id="member_surname" value="<cfoutput>#str_par_surname#</cfoutput>"  maxlength="50">
                </div>
            </div>
        </div>        
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-address">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58723.Adres'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <textarea name="address" id="address"><cfoutput>#member_adres#</cfoutput></textarea>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-country">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58608.İl'>-<cf_get_lang dictionary_id='58638.İlçe'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <select name="city" id="city" onchange="get_phone_code()">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_city">
                            <option value="#city_id#" <cfif len(member_city) and (member_city eq city_id)>selected</cfif> >#city_name#</option>
                        </cfoutput>
                    </select>
                    <cfif len(member_county)>
                        <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #member_county#
                        </cfquery>
                    </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="input-group">
                        <input type="text" name="county" id="county" value="<cfif len(member_county)><cfoutput>#GET_COUNTY_TAX.COUNTY_NAME#</cfoutput></cfif>" maxlength="30" readonly="yes">
                        <span class="input-group-addon btn_Pointer icon-ellipsis" title="Seçiniz" onclick="pencere_ac();"></span>
                        <input type="hidden" name="county_id" id="county_id" value="<cfif len(member_county)><cfoutput>#member_county#</cfoutput></cfif>" readonly="">
                    </div>
                </div> 
            </div>
               
        </div>        
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-tax_office">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58762.Vergi Dairesi'>/<cf_get_lang dictionary_id='57487.No'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" id="tax_office" name="tax_office"  maxlength="30"  value="#member_tax_office#">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" name="tax_num"  maxlength="10" validate="integer" value="#member_tax_no#" message="Vergi Numarası!">
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-tc_kimlik">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id="58025.TC Kimlik No">
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58025.TC Kimlik No"></cfsavecontent>
                <cfif isdefined('get_tc.TC_IDENTITY') and len(get_tc.TC_IDENTITY)>
                    <cfinput id="tc_kimlik" type="text" name="tc_num" maxlength="11" message="#message#" value="#get_tc.TC_IDENTITY#">
                <cfelse>
                    <cfinput id="tc_kimlik" type="text" name="tc_num" maxlength="11" message="#message#" value="#member_tc_no#">
                </cfif>
            </div>
        </div>         
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-ims_code">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cfif len(ims_code_id_)>
                    <cfquery name="get_ims" datasource="#dsn#">
                        SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id_#
                    </cfquery>
                </cfif>
                <div class="input-group">
                    <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif len(ims_code_id_)><cfoutput>#ims_code_id_#</cfoutput></cfif>">
                    <input type="text" name="ims_code_name" id="ims_code_name" value="<cfif len(ims_code_id_)><cfoutput>#get_ims.ims_code# #get_ims.ims_code_name#</cfoutput></cfif>" readonly="yes" tabindex="44">
                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_ims_code&field_name=form_basket.ims_code_name&field_id=form_basket.ims_code_id&select_list=1</cfoutput>','list','popup_list_ims_code');return false"></span>
                </div>
            </div>
        </div>
    </div>            
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-comp_name">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58607.Firma'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_sale_det.company_id#</cfoutput>">
                <cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
                    <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_sale_det_comp.fullname#</cfoutput>" readonly>
                <cfelseif len(get_sale_det.consumer_id)>
                    <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_cons_name.company#</cfoutput>" readonly>
                </cfif>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-tel_code">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57499.Telefon'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" name="tel_code" maxlength="5" passthrough = "readonly=yes" validate="integer" value="#member_tel_cod#" message="Telefon Kodu!">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" name="tel_number" value="#member_tel#"  maxlength="7"  validate="integer" message="Telefon Numarası!">
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-faxcode">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57488.Fax'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput type="text" name="faxcode" value="#member_tel_cod#" passthrough = "readonly=yes" maxlength="5" message="Faks Kodu!">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput name="fax_number" maxlength="7" value="#member_fax#" type="text" validate="integer"  message="Fax Numarası!">
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-mobil_code">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58473.Mobil'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput name="mobil_code" id="mobil_code" maxlength="7" type="text" value="#member_mobil_cod#" validate="integer">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfinput name="mobil_tel" maxlength="10" type="text" value="#member_mobil#" validate="integer"  message="Mobil Telefon!">
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-email">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57428.E-Mail'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <input type="text" name="email" id="email" value="<cfoutput>#member_mail#</cfoutput>" maxlength="50">
            </div>
        </div>
        <cfif session.ep.our_company_info.asset_followup eq 1>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-asset_name">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <cf_get_lang dictionary_id='58833.Fiziki Varlık'>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cf_wrkassetp asset_id="#get_sale_det.assetp_id#" fieldid='asset_id' fieldname='asset_name' form_name='form_basket'>
                </div>
            </div>
        </cfif>
    </div>        
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-member_code">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57558.Üye No'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <input name="member_code" id="member_code" type="text" size="10" value="<cfoutput>#member_code#</cfoutput>">
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-bool_from_control_bill">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57800.işlem tipi'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cf_workcube_process_cat process_cat="#get_sale_det.process_cat#">
                <cfif isdefined("attributes.invoice_id")>
                    <input type="hidden" name="bool_from_control_bill" id="bool_from_control_bill" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
                </cfif>
            </div>   
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-invoice_number">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58133.Fatura No'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cfsavecontent variable="message"> <cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="invoice_number" maxlength="50" value="#get_sale_det.invoice_number#" required="yes" message="#message#" onBlur="paper_control(this,'INVOICE',true,'#attributes.iid#','#get_sale_det.invoice_number#');">
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-invoice_date">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58759.Fatura Tarihi'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="invoice_date" required="yes" message="#message#" readonly value="#dateformat(get_sale_det.invoice_date,dateformat_style)#"  validate="#validate_style#" passthrough="onblur=""change_money_info('form_basket','invoice_date');""">
                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="invoice_date" call_function="change_money_info" control_date="#dateformat(get_sale_det.invoice_date,dateformat_style)#"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-department_name">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='58763.Depo'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cfset location_info_ = get_location_info(get_sale_det.department_id,get_sale_det.department_location,1,1)>
                    <cf_wrkdepartmentlocation
                    returninputvalue="location_id,department_name,department_id,branch_id"
                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                    fieldname="department_name"
                    fieldid="location_id"
                    department_fldid="department_id"
                    xml_all_depo = "#xml_all_depo#"
                    branch_fldid="branch_id"
                    branch_id="#listlast(location_info_,',')#"
                    department_id="#get_sale_det.department_id#"
                    location_id="#get_sale_det.department_location#"
                    location_name="#listfirst(location_info_,',')#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#">
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-project_id">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57416.Proje'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="input-group">
                    <cfoutput>
                        <input type="hidden" name="project_id" id="project_id" value="#get_sale_det.project_id#">
                        <input type="text" name="project_head" id="project_head" style="width:120px;" value="<cfif len(get_sale_det.project_id)>#GET_PROJECT_NAME(get_sale_det.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','140')" autocomplete="off">
                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=objects.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');"></span>
                    </cfoutput>
                </div>
            </div>
        </div>    
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-EMPO_ID">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57021.Satışı Yapan'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="input-group">
                    <cfif len(get_sale_det.sale_emp) or len(get_sale_det.sale_partner)>
                        <cfoutput>
                            <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.sale_emp#">
                            <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.sale_partner#">
                            <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO"  value="<cfif len(get_sale_det.sale_partner) >#get_par_info(get_sale_det.sale_partner,0,0,0)#<cfelse>#get_emp_info(get_sale_det.SALE_EMP,0,0)#</cfif>" disabled>
                            <span class="input-group-addon btn_Pointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID','list')"></span>
                        </cfoutput>
                    <cfelse>
                        <input type="hidden" name="EMPO_ID" id="EMPO_ID">
                        <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                        <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" readonly>
                        <span class="input-group-addon btn_Pointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_positions')"></span>
                    </cfif>
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-deliver_get">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57775.Teslim Alan'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="input-group">
                    <cfoutput>
                            <input type="text" name="deliver_get" id="deliver_get" style="width:120px;" value="#get_sale_det.deliver_emp#">
                    </cfoutput>
                    <span class="input-group-addon btn_Pointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=form_basket.deliver_get&come=stock<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,4,5,6</cfoutput>','list','popup_list_pars');"></span>
                </div>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-note">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id='57629.Açıklama'>
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <textarea name="note" id="note"><cfoutput>#GET_SALE_DET.note#</cfoutput></textarea>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-vocation_type">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id="57329.Meslek Tipi">
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <select name="vocation_type" id="vocation_type" tabindex="13">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_vocation_type">
                        <option value="#vocation_type_id#" <cfif vocation_type_id eq vocation_type >selected</cfif>>#vocation_type#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-member_type">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id="57042.Müşteri Güncelle">
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-5 col-md-4 col-sm-4 col-xs-12">
                    <input name="member_type" id="member_type" type="radio" value="1"  onclick="kontrol_member_cat(1);" <cfif len(GET_SALE_DET.COMPANY_ID) neq len(GET_SALE_DET.CONSUMER_ID)>checked</cfif>><cf_get_lang dictionary_id='57255.Kurumsal'>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <input name="member_type" id="member_type" type="radio" value="2"  onclick="kontrol_member_cat(2);"<cfif len(GET_SALE_DET.CONSUMER_ID)>checked</cfif>><cf_get_lang dictionary_id='57256.Bireysel'>
                </div>
                <cfif len(GET_SALE_DET.CONSUMER_ID)>
                    <div style="display:none;" class="col col-3 col-md-4 col-sm-4 col-xs-12" id="is_person_">
                        <input name="is_person" id="is_person" type="checkbox" value="1" <cfif isdefined('GET_SALE_DET_COMP.is_person') and len(GET_SALE_DET_COMP.is_person) and GET_SALE_DET_COMP.is_person eq 1>checked</cfif>><cf_get_lang dictionary_id='30118.Şahıs'> 
                    </div>
                </cfif>     
            </div>
        </div>
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-fatura_iptal">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_get_lang dictionary_id="58750.Fatura İptal">
            </div>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                    <input name="fatura_iptal" id="fatura_iptal" value="1" <cfif len(get_sale_det.is_iptal) and get_sale_det.is_iptal >checked</cfif> type="checkbox" onclick="gizle_goster(cancel_type);">
                </div>
                <div id="cancel_type" class="col col-11 col-md-11 col-sm-11 col-xs-12" <cfif get_sale_det.is_iptal neq 1> style="display:none;"</cfif>>
                    <cfif isdefined("is_add_cancel_types") and is_add_cancel_types eq 1>
                        <select name="cancel_type_id" id="cancel_type_id">                  <!---DROPDOWNLIST AKTİF OLMUYOR!!!--->
                            <option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
                        <cfoutput query="get_inv_cancel_types">
                                <option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                        </cfoutput>
                        </select>
                    </cfif>
                </div>
            </div>
        </div>
    </div>          
</cf_box_elements>
<cf_box_footer>
    <cf_record_info query_name="GET_SALE_DET">
    <cfif not len(isClosed('INVOICE',attributes.iid)) and (GET_SALE_DET.RELATED_ACTION_TABLE eq '' or not len(isClosed(GET_SALE_DET.RELATED_ACTION_TABLE,GET_SALE_DET.RELATED_ACTION_ID)))>
        <cfquery name="GET_BANK_ACTION_INFO" datasource="#dsn2#">
                SELECT
                    *
                FROM
                    INVOICE,
                    INVOICE_CASH_POS,
                    #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CC
                WHERE
                    INVOICE.INVOICE_ID = INVOICE_CASH_POS.INVOICE_ID AND
                    INVOICE_CASH_POS.POS_ACTION_ID = CC.CREDITCARD_PAYMENT_ID AND
                    CC.BANK_ACTION_ID IS NOT NULL AND
                    INVOICE.INVOICE_ID = #attributes.IID#
        </cfquery>
        <cfif GET_BANK_ACTION_INFO.recordcount>
                <font color="red">
                <cf_get_lang dictionary_id="57046.Kredi Kartı Tahsilatlarınızın Hesaba Geçişlerini Yaptığınız İçin">,<br />
                <cf_get_lang dictionary_id="57047.Hesaba Geçiş İşlemlerinizi Geri Almadan Faturayı Güncelleyemezsiniz">!
            </font>
        </cfif>
        <cfif get_sale_det.upd_status neq 0 and not GET_BANK_ACTION_INFO.recordcount>
            <cf_workcube_buttons is_upd='1' is_delete=1 add_function='kontrol()' del_function='kontrol2()'>
        </cfif>
    <cfelse>
            <font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
    </cfif>
</cf_box_footer>
</cf_basket_form>
<cfset attributes.basket_id = 18>
<cfset attributes.is_retail = 1>
<cfinclude template="../../objects/display/basket.cfm">
</div>    
</cfform>
</cf_box>
</div>
<script type="text/javascript">
phone_code_list = new Array(<cfoutput>#listdeleteduplicates(valuelist(get_city.phone_code))#</cfoutput>);
    function get_phone_code()
    {
        if(document.form_basket.city.selectedIndex > 0)
        {	document.form_basket.tel_code.value = phone_code_list[document.form_basket.city.selectedIndex-1];
            document.form_basket.faxcode.value = phone_code_list[document.form_basket.city.selectedIndex-1]; }
        else
        {	document.form_basket.tel_code.value = '';
            document.form_basket.faxcode.value = ''; }
    }

    function pencere_ac(no)
    {
    if (document.form_basket.city[document.form_basket.city.selectedIndex].value == "")
        alert("<cf_get_lang dictionary_id='57257.İlk Olarak İl Seçiniz'>!");
    else
    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_basket.county_id&field_name=form_basket.county&city_id=' + document.form_basket.city.value,'small');
}
function kontrol_member_cat(type)
{
    if (type == 1)
    {
       /* is_company.style.display = '';
        is_consumer.style.display = 'none';
        is_person_.style.display = '';        
        document.getElementById('cons_member_cat').value = ''; */
        is_person_.style.display = '';       
    }
    if (type == 2)
    {
        /*is_company.style.display = 'none';
        is_consumer.style.display = '';
        is_person_.style.display = 'none';
        document.getElementById('comp_member_cat').value = '';  */
        is_person_.style.display = 'none';
    }
}
function kontrol()
{
    var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('department_id').value+" AND LOCATION_ID ="+document.getElementById('location_id').value,"dsn");
    if(get_is_no_sale.recordcount)
        {
            var is_sale_=get_is_no_sale.NO_SALE;
            if(is_sale_==1)
            {
                alert("<cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz.'>!");
                return false;
            }
        }
control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>);
if (!paper_control(document.form_basket.invoice_number,'INVOICE',true,<cfoutput>'#attributes.iid#','#get_sale_det.invoice_number#'</cfoutput>)) return false;
    if (!chk_process_cat('form_basket')) return false;
    if (!check_display_files('form_basket')) return false;
    if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
    if (!check_product_accounts()) return false;
   
        if(form_basket.member_type[0].checked && (form_basket.comp_name.value=="" || form_basket.tax_office.value=="" || form_basket.tax_num.value=="" || form_basket.address.value=="") && form_basket.is_person.checked != true)
        {
            alert("<cf_get_lang dictionary_id='57339.Kurumsal Müşteri İçin Firma Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz'>!");
            return false;
        }
        else if(form_basket.member_type[1].checked && (form_basket.member_name.value=="" || form_basket.member_surname.value=="" || form_basket.address.value==""))
        {
            alert("<cf_get_lang dictionary_id='57258.Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
            return false;
        }
   
        var kalan_risk_ = 0;
        if(form_basket.member_type[0].checked)//kurumsal
        {
            var risk_info = wrk_safe_query('inv_risk_info','dsn2',0,document.getElementById('company_id').value);
        }
        else if(form_basket.member_type[1].checked)//bireysel
        {
            var risk_info = wrk_safe_query('inv_risk_info2','dsn2',0,document.getElementById('consumer_id').value);
        }
        if(risk_info != undefined && risk_info.recordcount)
        {
            risk_tutar_ = parseFloat(risk_info.TOTAL_RISK_LIMIT) - parseFloat(risk_info.BAKIYE) - (parseFloat(risk_info.CEK_ODENMEDI) + parseFloat(risk_info.SENET_ODENMEDI) + parseFloat(risk_info.CEK_KARSILIKSIZ) + parseFloat(risk_info.SENET_KARSILIKSIZ));
            kalan_risk_ = ( window.basketManager !== undefined ) ? parseFloat(risk_tutar_ - wrk_round( basketManagerObject.basketFooter.basket_net_total() )) : parseFloat(risk_tutar_ - wrk_round(form_basket.basket_net_total.value));
        }
        else
            kalan_risk_ = -1;

    <cfif is_control_risk eq 1>
		if (kalan_risk_ < 0){
            if( window.basketManager !== undefined ){ 
                if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) > wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                return false;
                }
                if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) < wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                return false;
                }
            }else{
                if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value)){
                alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                return false;
                }
                if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value)){
                alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                return false;
                }
            }
		}
	<cfelseif is_control_risk eq 2>
        if( window.basketManager !== undefined ){ 
            if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) > wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                return false;
                }
            if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) < wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                return false;
            }
            }else{ 
            if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value)){
                alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                return false;
                }
            if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value)){
                alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                return false;
            }
        }
	</cfif>

if(document.form_basket.fatura_iptal.checked==false)
{
if(check_stock_action('form_basket')) //islem kategorisi stock hareketi yapıyorsa
{
var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
if(basket_zero_stock_status.IS_SELECTED != 1)
{
var ship_sql = wrk_safe_query('inv_ship_q','dsn2',0,<cfoutput>#attributes.iid#</cfoutput>);
        if(ship_sql.SHIP_ID != '') /*faturanın irsaliyesi icin sıfır stok kontrolu yapılır */
        {
            var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
            var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
            if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,ship_sql.SHIP_ID,temp_process_type.value)) return false;
        }
    }
    }
    }
        return (check_cash_pos() && saveForm());
        return false;
    }
    function kontrol2()
    {
		control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>);
        if (!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
        return true;
    }
    function check_cash_pos()
    {
        /*secili kasa olup olmadigi kontrol ediliyor*/
    <cfoutput query="get_money_bskt">
        if(eval(form_basket.kasa#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#).value!=""){
            form_basket.cash.value=1;
        }
    </cfoutput>
        for(var a=1; a<=5; a++)
        {
            if(eval('form_basket.pos_amount_'+a)!= undefined && eval('form_basket.pos_amount_'+a).value!="")
            {
                eval('form_basket.pos_amount_'+a).value=filterNum((eval('form_basket.pos_amount_'+a).value));
                form_basket.is_pos.value=1;
            }
        }
        return true;
    }
    </script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

<cfsetting showdebugoutput="no">