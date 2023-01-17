<cf_xml_page_edit fuseact="contract.popup_add_contract">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfset get_contract= createObject("component","V16.contract.cfc.contract") />
<cfset get_contact_detail=get_contract.get_contact_detail(contract_id:attributes.contract_id)/> 
<cfset GET_KDV=get_contract.GET_KDV()/> 
<cfset GET_PRICE_CATS=get_contract.GET_PRICE_CATS()/> 
    <!--- ilisklili isler --->
<cfset getContractWorks=get_contract.getContractWorks(contract_id:attributes.contract_id)/>    

<cfinclude template="../query/get_cat.cfm">
<cfinclude template="../query/get_moneys.cfm">

<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
    <cfset get_price_cat_exceptions=get_contract.get_price_cat_exceptions(contract_id:attributes.contract_id)/>   
<cfelse>
    <cfset get_price_cat_exceptions.recordcount = 0>
</cfif>
<cfset row = get_price_cat_exceptions.RecordCount>
<!--- iliskili hakedisler --->
<cfset getProgress=get_contract.getProgress(contract_id:attributes.contract_id)/> 
<cf_catalystHeader>
<cfform method="post" name="upd_cont" action="#request.self#?fuseaction=contract.upd">  
    <div class="col col-9 col-xs-12"> 
        <cf_box>            
            <cfif attributes.fuseaction contains 'popup'><input type="hidden" name="is_popup" id="is_popup" value="1"></cfif>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#attributes.contract_id#</cfoutput>">
                            <input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#get_contact_detail.OUR_COMPANY_ID#</cfoutput>">
                            <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_contact_detail.status eq 1>checked="checked"</cfif> /> 
                        </div>
                    </div>
                    <cfif isdefined("x_process_cat") and x_process_cat eq 1>    
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="150" form_name="upd_cont" process_cat='#get_contact_detail.process_cat#'>                          
                            </div>
                        </div>  
                    </cfif>
                    <div class="form-group" id="item-process_cat_width">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='145' select_value='#get_contact_detail.stage_id#' is_detail='1'>
                        </div>
                    </div>  
                    <div class="form-group" id="item-contract_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>* </label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='50759.Başlık !'></cfsavecontent>
                            <cfinput type="text" name="contract_head" value="#get_contact_detail.contract_head#" required="yes" message="#message#" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-contract_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30044.Sözleşme No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="contract_no" value="#get_contact_detail.contract_no#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-contract_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51040.Sözleşme Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="contract_type" id="contract_type" <cfif getContractWorks.recordcount>disabled</cfif>>
                                <option value="1" <cfif get_contact_detail.contract_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
                                <option value="2" <cfif get_contact_detail.contract_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-start">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
                                <cfinput type="text" name="start" id="start" value="#DateFormat(get_contact_detail.STARTDATE,dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finish">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi !'></cfsavecontent>
                                <cfinput required="Yes" message="#message#" type="text" name="finish" validate="#validate_style#" value="#DateFormat(get_contact_detail.FINISHDATE,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-contract_cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="contract_cat_id" id="contract_cat_id">
                                <option value="0" selected><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                <cfoutput query="get_cat">
                                    <option value="#contract_cat_id#" <cfif get_contact_detail.contract_cat_id EQ contract_cat_id> selected </cfif>>#contract_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>                                                                                          
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_contact_detail.consumer_id)>
                                    <cfquery name="get_consumer" datasource="#DSN#">
                                        SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact_detail.consumer_id#">
                                    </cfquery>
                                    <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
                                <cfelseif len(get_contact_detail.company_id)>
                                    <cfquery name="get_company" datasource="#DSN#">
                                        SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_contact_detail.company_id#
                                    </cfquery>
                                    <cfset member_name = get_company.fullname>
                                <cfelse>
                                    <cfset member_name = ''>
                                </cfif>
                                <input type="hidden" name="old_company_id" id="old_company_id" value="<cfoutput>#get_contact_detail.company_id#</cfoutput>" >
                                <input type="hidden" name="consumer_id" id="consumer_id"  value="<cfoutput>#get_contact_detail.consumer_id#</cfoutput>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_contact_detail.company_id#</cfoutput>" >
                                <input type="text" name="member_name" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','upd_cont','3','250')" value="<cfoutput>#member_name#</cfoutput>" autocomplete="off">
                                <cfset str_linke_ait="field_consumer=upd_cont.consumer_id&field_comp_id=upd_cont.company_id&field_comp_name=upd_cont.member_name&field_name=upd_cont.member_name">
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8','list');"></span>
                            </div>
                        </div>
                    </div>   
                        <!---<cfif getContractWorks.recordcount><cf_get_lang dictionary_id='58022.Tevkifat'><cfelse><cf_get_lang dictionary_id='57416.Proje'></cfif>--->
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif not getContractWorks.recordcount>
                            <div class="input-group">
                            </cfif>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_contact_detail.PROJECT_ID#</cfoutput>">
                                <input type="hidden" name="old_project_id" id="old_project_id" value="<cfoutput>#get_contact_detail.PROJECT_ID#</cfoutput>">
                                <input type="text" name="project_head" id="project_head" <cfif getContractWorks.recordcount>readonly="readonly"</cfif> value="<cfif len(get_contact_detail.PROJECT_ID)><cfoutput>#GET_PROJECT_NAME(get_contact_detail.PROJECT_ID)#</cfoutput></cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','upd_cont','3','140')"autocomplete="off">
                                <cfif not getContractWorks.recordcount>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_cont.project_id&project_head=upd_cont.project_head');"></span>
                                    </div>
                                </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-tevkifat_oran">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58022.Tevkifat'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="tevkifat_oran_id" id="tevkifat_oran_id" value="<cfoutput>#get_contact_detail.tevkifat_rate_id#</cfoutput>"  />
                                <input type="text" name="tevkifat_oran" id="tevkifat_oran" value="<cfoutput>#TLFormat(get_contact_detail.tevkifat_rate,4)#</cfoutput>" />
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=upd_cont.tevkifat_oran&field_tevkifat_rate_id=upd_cont.tevkifat_oran_id</cfoutput>','small')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-stopaj">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57711.Stopaj'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="stoppage_oran_id" id="stoppage_oran_id" value="<cfoutput>#get_contact_detail.stoppage_rate_id#</cfoutput>"  />
                                <input type="text" name="stoppage_oran" id="stoppage_oran" value="<cfoutput>#TLFormat(get_contact_detail.stoppage_rate,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" />
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=upd_cont.stoppage_oran&field_stoppage_rate_id=upd_cont.stoppage_oran_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#</cfoutput>','small')"></span>
                            </div>
                        </div>
                    </div>  
                    <div class="form-group" id="item-copy_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39010.Kopya'><cf_get_lang dictionary_id='39852.Sayısı'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="copy_number" id="copy_number" value="<cfoutput>#get_contact_detail.copy_number#</cfoutput>" />
                        </div>
                    </div>                   
                    <div class="form-group" id="item-contract_calculation">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51043.Hesaplama Yöntemi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="contract_calculation" id="contract_calculation" <cfif getContractWorks.recordcount>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_contact_detail.contract_calculation eq 1>selected</cfif>>%</option>
                                <option value="2" <cfif get_contact_detail.contract_calculation eq 2>selected</cfif>><cf_get_lang dictionary_id='29513.Süre'></option>
                                <option value="3" <cfif get_contact_detail.contract_calculation eq 3>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-paymethod_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Odeme Yontemi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <cfif len(get_contact_detail.paymethod_id)>
                                    <cfset pay_id =get_contact_detail.paymethod_id>
                                    <cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
                                        SELECT 
                                            SP.* 
                                        FROM 
                                            SETUP_PAYMETHOD SP
                                            <cfif not(isDefined('pay_id') and len(pay_id))>
                                                ,SETUP_PAYMETHOD_OUR_COMPANY SPOC
                                            </cfif>
                                        WHERE	
                                            <cfif isDefined('pay_id') and len(pay_id)>
                                                SP.PAYMETHOD_ID = #pay_id#
                                            <cfelse>
                                                SP.PAYMETHOD_STATUS = 1
                                                AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
                                                AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                            </cfif>
                                    </cfquery>
                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_payment_method.paymethod_id#">
                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                    <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_payment_method.payment_vehicle#"> <!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
                                    <input type="text" name="pay_method" id="pay_method" value="#get_payment_method.paymethod#" onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                <cfelseif len(get_contact_detail.card_paymethod_id)>
                                    <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                        SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#get_contact_detail.card_paymethod_id#
                                    </cfquery>
                                    <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1">
                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_contact_detail.card_paymethod_id#">
                                    <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                    <input type="text" name="pay_method" id="pay_method" value="#get_card_paymethod.card_no#"  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                <cfelse>
                                    <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                    <input type="text" name="pay_method" id="pay_method" value="" onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                </cfif>
                                <cfset card_link="&field_card_payment_id=upd_cont.card_paymethod_id&field_card_payment_name=upd_cont.pay_method&field_commission_rate=upd_cont.commission_rate&field_paymethod_vehicle=upd_cont.paymethod_vehicle">
                                <span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&function_parameter=order_date&field_id=upd_cont.paymethod_id&field_name=upd_cont.pay_method#card_link#','list');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ship_method_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfoutput>#get_contact_detail.SHIP_METHOD_ID#</cfoutput>">
                                <input type="text" name="ship_method_name" id="ship_method_name" value="<cfoutput>#get_contact_detail.ship_method#</cfoutput>" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','140');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-deliver_loc_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57646.Teslim Depo'></label>
                        <div class="col col-8 col-xs-12">
                            <cfset location_info_ = get_location_info(get_contact_detail.deliver_dept_id,get_contact_detail.location_id,1,1)>
                            <cf_wrkdepartmentlocation 
                                returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="deliver_dept_name"
                                fieldid="deliver_loc_id"
                                department_fldId="deliver_dept_id"
                                branch_fldId="branch_id"
                                branch_id="#listlast(location_info_,',')#"
                                department_id="#get_contact_detail.deliver_dept_id#"
                                location_id="#get_contact_detail.location_id#"
                                location_name="#listfirst(location_info_,',')#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="145"
                                is_branch="1">
                        </div>
                    </div>           
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">                   
                    <div class="form-group" id="item-contract_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50985.Sözleşme Tutarı'></label>
                        <div class="col col-4 col-xs-8">
                                <cfinput type="text" name="contract_amount" id="contract_amount" value="#tlformat(get_contact_detail.contract_amount)#" class="moneybox" onKeyUp="hesapla(1);hesapla(4);hesapla(6);hesapla(8);return(FormatCurrency(this,event));"/>                                                          
                        </div>
                        <label class="col col-1 text-center">-</label>
                        <div class="col col-3">
                            <select name="contract_tax" id="contract_tax" onchange="hesapla(1);">
                                <cfoutput query="get_kdv">
                                    <option value="#tax#" <cfif get_contact_detail.contract_tax eq tax>selected</cfif>>#tax#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-money">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58716.KDVli'> <cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-4 col-xs-8">
                                <cfinput type="text" name="contract_tax_amount" value="#tlformat(get_contact_detail.contract_tax_amount)#" class="moneybox" onKeyUp="hesapla(2);return(FormatCurrency(this,event));"/>
                        </div>        
                        <label class="col col-1 text-center">-</label>
                        <div class="col col-3">
                            <select name="contract_money" id="contract_money">
                                <cfoutput query="get_moneys">
                                    <option value="#money#" <cfif get_contact_detail.contract_money is money> selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-unit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57638.Birim Fiyat'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="contract_unit_price" value="#tlformat(get_contact_detail.contract_unit_price)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"/>
                        </div>
                    </div> 
                    <cfif x_contract_discount eq 1>                   
                        <div class="form-group" id="item-discount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38190.İskonto Oranı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="discount" id="discount" value="<cfoutput>#TLFormat(get_contact_detail.discount_rate)#</cfoutput>" class="moneybox" <cfif getProgress.recordcount>disabled</cfif> />                        
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-guarantee_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
                        <div class="col col-3 col-xs-12">
                            <cfinput type="text" name="guarantee_rate" id="guarantee_rate" value="#tlformat(get_contact_detail.guarantee_rate)#" class="moneybox" onKeyUp="hesapla(4);return(FormatCurrency(this,event));" placeholder="%"/>
                        </div>
                        <label class="col col-1 text-center">-</label>
                        <div class="col col-4 col-xs-12">							
                            <cfinput type="text" name="guarantee_amount" id="guarantee_amount" value="#tlformat(get_contact_detail.guarantee_amount)#" class="moneybox" onKeyUp="hesapla(3);return(FormatCurrency(this,event));"/>
                        </div>
                    </div>
                    <div class="form-group" id="item-advance_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
                        <div class="col col-3 col-xs-12">
                            <cfinput type="text" name="advance_rate" value="#tlformat(get_contact_detail.advance_rate)#" class="moneybox" onKeyUp="hesapla(6);return(FormatCurrency(this,event));" placeholder="%"/>
                        </div>
                        <label class="col col-1 text-center">-</label>
                        <div class="col col-4 col-xs-12">
                            <cfinput type="text" name="advance_amount" value="#tlformat(get_contact_detail.advance_amount)#" class="moneybox" onKeyUp="hesapla(5);return(FormatCurrency(this,event));"/>
                        </div>
                    </div>
                    <div class="form-group" id="item-stamp_tax">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53252.Damga Vergisi'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
                        <div class="col col-3 col-xs-12">
                            <cfinput type="text" name="stamp_tax_rate" id="stamp_tax_rate" value="#tlformat(get_contact_detail.stamp_tax_rate)#" class="moneybox" onkeyup="hesapla(8);return(FormatCurrency(this,event,4));" placeholder="%"/>
                        </div>
                        <label class="col col-1 text-center">-</label>
                        <div class="col col-4 col-xs-12">
                            <cfinput type="text" name="stamp_tax" id="stamp_tax" value="#tlformat(get_contact_detail.stamp_tax)#" class="moneybox" onkeyup="hesapla(7);return(FormatCurrency(this,event));"/>
                        </div>
                    </div>  
                    <div class="form-group" id="ıtem-wrk_add_info">
                        <label class="col col-4 col-xs-12"><cfoutput>#getlang('main',398)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_add_info info_type_id="-21" upd_page="1" info_id="#attributes.contract_id#" colspan="9">
                        </div>
                    </div>	                                                     
                </div>          
            </cf_box_elements>
            <div class="row" type="row">
                <div class="col-12 col-xs-12" item="item-contract_body">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-12">
                            <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                valign="top"
                                instancename="contract_body"
                                value="#get_contact_detail.contract_body#"
                                width="100%"
                                height="100%">
                        </div>
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn">	<!---/// footer alanı record info ve submit butonu--->
                <div class="col col-6"><cf_record_info query_name='get_contact_detail'></div> <!---///record info--->
                <div class="col col-6">
                    <cfif getContractWorks.recordcount>
                        <cfif attributes.fuseaction contains 'popup'>
                            <cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' delete_page_url="#request.self#?fuseaction=contract.del&CONTRACT_ID=#CONTRACT_ID#&is_popup=1" add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' delete_page_url="#request.self#?fuseaction=contract.del&CONTRACT_ID=#CONTRACT_ID#" add_function='kontrol()'>
                        </cfif>
                    <cfelse>
                        <cfif attributes.fuseaction contains 'popup'>
                            <cf_workcube_buttons type_format='1' is_upd='1' is_delete='1' delete_page_url="#request.self#?fuseaction=contract.del&CONTRACT_ID=#CONTRACT_ID#&is_popup=1" add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons type_format='1' is_upd='1' is_delete='1' delete_page_url="#request.self#?fuseaction=contract.del&CONTRACT_ID=#CONTRACT_ID#" add_function='kontrol()'>
                        </cfif>
                    </cfif>
                </div> <!---///butonlar---> 
            </div>               
        </cf_box>
        <cfscript>
            if (isDefined('get_contact_detail.company_id') and len(get_contact_detail.company_id))
                comp_id = "#get_contact_detail.company_id#";
            else
                comp_id = "#get_contact_detail.consumer_id#";                       
        </cfscript>
            <!--- cari teminatlar --->
            <cfsavecontent variable="message_work"><cf_get_lang dictionary_id='57676.Teminatlar'></cfsavecontent>
                
                
            <cfset attributes.contract_id = get_contact_detail.contract_id>
            <cf_box 
            closable="0"
            box_page="#request.self#?fuseaction=contract.emptypopup_list_guarantee&contract_id=#attributes.contract_id#"
            title="#message_work#" add_href="#request.self#?fuseaction=finance.list_securefund&contract_id=#attributes.contract_id#&comp_id=#comp_id#&event=add"></cf_box>
        
    </div>
    <div class="col col-3 col-xs-12">
        <!--- Taraflar --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50706.Taraflar'> (<cf_get_lang dictionary_id='58885.Partner'>)</cfsavecontent>
        <cf_box 
            closable="0"
            id="partner_id_"
            box_page="#request.self#?fuseaction=contract.fan_contract_ajax&contract_id=#attributes.contract_id#"
            title="#message#">
        </cf_box>
        <!--- ilişkili fiziki varlıklar --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='639.İlişkili Fiziki Varlıklar'></cfsavecontent>
        <cf_box 
            id="rel_phy_asset"
            info_href="#request.self#?fuseaction=assetcare.popup_list_relation_assetp&contract_id=#attributes.contract_id#"
            title="#message#"
            box_page="#request.self#?fuseaction=assetcare.emptypopup_ajax_dsp_contract_assets&contract_id=#attributes.contract_id#"
            closable="0">
            </cf_box>
        <!--- Notlar --->
        <cf_get_workcube_note company_id="#session.ep.company_id#" asset_cat_id="-4" module_id='17' action_section='CONTRACT_ID' action_id='#attributes.contract_id#'>
        <!--- Belgeler --->
    <cf_get_workcube_asset asset_cat_id="-4" module_id='17' action_section='CONTRACT_ID' action_id='#attributes.contract_id#' company_id="#session.ep.company_id#">

    </div>
</cfform>
<script type="text/javascript">
    if(document.upd_cont.our_company_id.value != <cfoutput>#session.ep.company_id#</cfoutput>)
    {
        alert("<cf_get_lang dictionary_id='51016.Bu Anlaşma Bu Şirkete Ait Değildir Lütfen Şirket Değiştirin'>");
        window.close();
    }
    function kontrol()
    {
            <cfif isdefined("x_process_cat") and x_process_cat eq 1> 
            if(!chk_process_cat('upd_cont')) return false;
            if (!check_display_files('upd_cont')) return false;
        </cfif>      
        if (upd_cont.contract_cat_id.value == 0)
        {	
            alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57486.Kategori !'>");
            return false;		
        }
        if((document.getElementById('company_id').value ==  '' || document.getElementById('member_name').value == '') && (document.getElementById('consumer_id').value == '' ||document.getElementById('member_name').value == ''))
        {
            alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="57519.Cari Hesap">');
            return false;
        }
        if (upd_cont.contract_no.value == '')
        {
            alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='30044.Sözleşme No'>");
            return false;		
        }
        
        <cfif x_tevkifat_rate eq 1>
            var start_d = document.all.start.value.split(/\D+/);// \D sayı olmayan karakterleri temsil ediyor.
            var finish_d = document.all.finish.value.split(/\D+/);
            var d1=new Date(start_d[2]*1, start_d[1]-1, start_d[0]*1);
            var d2=new Date(finish_d[2]*1, finish_d[1]-1, finish_d[0]*1);
            var start_y = d1.getFullYear();
            var finish_y = d2.getFullYear();
            var fark = Math.abs(finish_y-start_y);
            if(fark != 0)
            {
                if(document.upd_cont.tevkifat_oran_id.value == '' || document.upd_cont.tevkifat_oran.value == '')
                {
                    alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="50734.Tevkifat Oranı">');
                    return false;
                }
            }
        </cfif>
            if((document.getElementById('cc_par_ids') == undefined || document.getElementById('cc_par_ids').value == '') && (document.getElementById('cc_cons_ids') == undefined || document.getElementById('cc_cons_ids').value == '') && (document.getElementById('to_emp_ids') == undefined || document.getElementById('to_emp_ids').value == ''))
            {
                alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='50706.Taraf !'>");
                return false;
            }
        document.all.contract_type.disabled = false;
        document.all.contract_calculation.disabled = false;
        document.all.advance_amount.disabled = false;
        document.all.advance_rate.disabled = false;
        document.all.guarantee_amount.disabled = false;
        document.all.guarantee_rate.disabled = false;
        <cfif x_contract_discount eq 1>
            document.all.discount.disabled = false;
        </cfif>
        
        unformat_fields();
        return process_cat_control();
        return true;
    }
    
    row_count_2 = <cfoutput>#get_price_cat_exceptions.RecordCount#</cfoutput>;
    function sil(sy)
    {
        var my_element=eval("upd_cont.row_kontrol_2"+sy);
        my_element.value=0;
        var my_element=eval("frm_row_2"+sy);
        my_element.style.display="none";
    }

    
    
    function hesapla(type)
    {
        tax_ = document.all.contract_tax.value;
        
        if(type == 1)
        {
            if(document.all.contract_amount.value == '')
                amount_ = 0;
            else
                amount_ = filterNum(document.all.contract_amount.value);
            if(tax_ != 0 && amount_ != '')
            {
                kdvli_amount = ((parseFloat(tax_)*parseFloat(amount_))/100)+parseFloat(amount_);
                document.all.contract_tax_amount.value = commaSplit(kdvli_amount,'2');
            }
            else
                document.all.contract_tax_amount.value = commaSplit(amount_,'2');
        }
        else if(type == 2)
        {
            kdv_amount_ = filterNum(document.all.contract_tax_amount.value);
            if(tax_ != 0 && kdv_amount_ != '')
            {
                amount_ = (parseFloat(kdv_amount_)*100)/(parseFloat(tax_)+100);
                document.all.contract_amount.value = commaSplit(amount_,'2');
            }
            else
                document.all.contract_amount.value = commaSplit(kdv_amount_,'2');
        }
        else if(type == 3 || type == 4 || type == 5 || type == 6|| type == 7 || type == 8)
        {
            if(document.all.contract_amount.value != '' && parseFloat(document.all.contract_amount.value))
            {
                contract_amount_ = filterNum(document.all.contract_amount.value);
                if(document.all.guarantee_amount.value != "" && parseFloat(document.all.guarantee_amount.value)) guarantee_amount_ = filterNum(document.all.guarantee_amount.value); else guarantee_amount_ = 0;
                if(document.all.guarantee_rate.value != "" ) guarantee_rate_ = filterNum(document.all.guarantee_rate.value); else guarantee_rate_ = 0;
                if(document.all.advance_amount.value != "" && parseFloat(document.all.advance_amount.value)) advance_amount_ = filterNum(document.all.advance_amount.value); else advance_amount_ = 0;
                if(document.all.advance_rate.value != "") advance_rate_ = filterNum(document.all.advance_rate.value); else advance_rate_ = 0;
                if(document.all.stamp_tax.value != "" && parseFloat(document.all.stamp_tax.value)) stamp_tax_ = filterNum(document.all.stamp_tax.value); else stamp_tax_ = 0;
                if(document.all.stamp_tax_rate.value != "") stamp_tax_rate_ = filterNum(document.all.stamp_tax_rate.value); else stamp_tax_rate_ = 0;
                
                if(type == 3 && parseFloat(contract_amount_) != 0)
                {
                    if(parseFloat(guarantee_amount_) != 0)
                        var deger_guarantee_rate = (parseFloat(guarantee_amount_)/parseFloat(contract_amount_))*100;
                    else
                        var deger_guarantee_rate = 0;
                    document.all.guarantee_rate.value = commaSplit(deger_guarantee_rate);
                }
                if(type == 4)
                {
                    var deger_guarantee_amount = (parseFloat(contract_amount_)*parseFloat(guarantee_rate_))/100;
                    document.all.guarantee_amount.value = commaSplit(deger_guarantee_amount,'2');
                }
                if(type == 5 && contract_amount_ != 0)
                {
                    if(parseFloat(advance_amount_) != 0)
                        var deger_advance_rate = (parseFloat(advance_amount_)/parseFloat(contract_amount_))*100;
                    else
                        var deger_advance_rate = 0;
                    document.all.advance_rate.value = commaSplit(deger_advance_rate);
                }
                if(type == 6)
                {
                    var deger_advance_amount = (parseFloat(contract_amount_)*parseFloat(advance_rate_))/100;
                    document.all.advance_amount.value = commaSplit(deger_advance_amount,'2');
                }
                if(type == 7 && contract_amount_ != 0)
                {
                    if(parseFloat(stamp_tax_) != 0)
                        var deger_stamp_tax_rate = (parseFloat(stamp_tax_)/parseFloat(contract_amount_))*100;
                    else
                        var deger_stamp_tax_rate = 0;
                    document.all.stamp_tax_rate.value = commaSplit(deger_stamp_tax_rate);
                }
                if(type == 8)
                {
                    var deger_stamp_tax= (parseFloat(contract_amount_)*parseFloat(stamp_tax_rate_))/100;
                    document.all.stamp_tax.value = commaSplit(deger_stamp_tax,'2');
                }
            }
            else
            {
                alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="50985.Sözleşme Tutarı"> !');
                document.all.advance_amount.value = '';
                document.all.advance_rate.value = '';
            }
        }
    }
    function unformat_fields()
    {
        upd_cont.contract_amount.value = filterNum(upd_cont.contract_amount.value);
        upd_cont.contract_tax_amount.value = filterNum(upd_cont.contract_tax_amount.value);
        upd_cont.contract_unit_price.value = filterNum(upd_cont.contract_unit_price.value);
        upd_cont.guarantee_amount.value = filterNum(upd_cont.guarantee_amount.value);
        upd_cont.guarantee_rate.value = filterNum(upd_cont.guarantee_rate.value);
        upd_cont.advance_amount.value = filterNum(upd_cont.advance_amount.value);
        upd_cont.advance_rate.value = filterNum(upd_cont.advance_rate.value);
        upd_cont.tevkifat_oran.value = filterNum(upd_cont.tevkifat_oran.value,4);
        upd_cont.stamp_tax.value = filterNum(upd_cont.stamp_tax.value);
        upd_cont.stamp_tax_rate.value = filterNum(upd_cont.stamp_tax_rate.value);
        upd_cont.stoppage_oran.value = filterNum(upd_cont.stoppage_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
        <cfif x_contract_discount eq 1>
            upd_cont.discount.value = filterNum(upd_cont.discount.value);
        </cfif>
        return true;
    }	
</script>