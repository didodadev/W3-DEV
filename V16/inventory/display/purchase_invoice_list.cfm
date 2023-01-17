<cf_get_lang_set module_name="invoice">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.belge_no" default="">
    <cfparam name="attributes.cat" default="0">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.department_txt" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.record_date" default="">
    <cfparam name="attributes.payment_type_id" default="">
    <cfparam name="attributes.card_paymethod_id" default="">
    <cfparam name="attributes.payment_type" default="">
    <cfparam name="attributes.empo_id" default="">
    <cfparam name="attributes.parto_id" default="">
    <cfparam name="attributes.emp_partner_nameo" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.detail" default="">
    <cfparam name="attributes.listing_type" default="2">
    <cfparam name="attributes.iptal_invoice" default="0">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.member_cat_type" default="">
    <cfparam name="attributes.budget_record" default="">
    <cfparam name="attributes.efatura_type" default="">
    <cfparam name="attributes.earchive_type" default="">
    <cfparam name="attributes.output_type" default="">
    <cfparam name="attributes.invoice_type" default="">
    <cfparam name="attributes.product_cat_code" default="-2">
    <cfparam name="attributes.product_cat_name" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
        <cf_date tarih= "attributes.record_date">
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cfif isdefined("attributes.form_varmi")>
        <cfscript>
            get_bill_action = createObject("component", "V16.inventory.cfc.get_bill");
            get_bill_action.dsn2 = dsn2;
            get_bill_action.dsn_alias = dsn_alias;
            get_bill_action.dsn3_alias = dsn3_alias;
            get_bill = get_bill_action.get_bill_fnc
            (
                listing_type : attributes.listing_type,
                control : '#IIf(IsDefined("attributes.control"),"attributes.control",DE(""))#',
                project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                budget_record : '#IIf(IsDefined("attributes.budget_record"),"attributes.budget_record",DE(""))#',
                module_name : '#IIf(IsDefined("fusebox.circuit"),"fusebox.circuit",DE(""))#',
                company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
                company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
                consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                empo_id : '#IIf(IsDefined("attributes.empo_id"),"attributes.empo_id",DE(""))#',
                parto_id : '#IIf(IsDefined("attributes.parto_id"),"attributes.parto_id",DE(""))#',
                detail : '#IIf(IsDefined("attributes.detail"),"attributes.detail",DE(""))#',
                cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
                card_paymethod_id : '#IIf(IsDefined("attributes.card_paymethod_id"),"attributes.card_paymethod_id",DE(""))#',
                payment_type_id : '#IIf(IsDefined("attributes.payment_type_id"),"attributes.payment_type_id",DE(""))#',
                payment_type : '#IIf(IsDefined("attributes.payment_type"),"attributes.payment_type",DE(""))#',
                belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                department_txt : '#IIf(IsDefined("attributes.department_txt"),"attributes.department_txt",DE(""))#',
                department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
                location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
                record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                record_emp_name : '#IIf(IsDefined("attributes.record_emp_name"),"attributes.record_emp_name",DE(""))#',
                record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
                product_cat_name : '#IIf(IsDefined("attributes.product_cat_name"),"attributes.product_cat_name",DE(""))#',
                start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                iptal_invoice : '#IIf(IsDefined("attributes.iptal_invoice"),"attributes.iptal_invoice",DE(""))#',
                product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
                is_tevkifat : '#IIf(IsDefined("attributes.is_tevkifat"),"attributes.is_tevkifat",DE(""))#',
                turned_to_total_inv : '#IIf(IsDefined("attributes.turned_to_total_inv"),"attributes.turned_to_total_inv",DE(""))#',
                acc_type_id : '#IIf(IsDefined("attributes.acc_type_id"),"attributes.acc_type_id",DE(""))#',
                oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
                EMP_PARTNER_NAMEO : '#IIf(IsDefined("attributes.EMP_PARTNER_NAMEO"),"attributes.EMP_PARTNER_NAMEO",DE(""))#',
                startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                efatura_type: '#IIf(len(attributes.efatura_type),"attributes.efatura_type",DE(""))#',
                earchive_type: '#IIf(len(attributes.earchive_type),"attributes.earchive_type",DE(""))#',
                invoice_type: '#IIf(len(attributes.invoice_type),"attributes.invoice_type",DE(""))#',
                output_type : '#IIf(IsDefined("attributes.output_type"),"attributes.output_type",DE(""))#'
                );
        </cfscript>
        <cfif get_bill.recordcount>
            <cfparam name="attributes.totalrecords" default="#get_bill.query_count#">
        <cfelse>
            <cfparam name="attributes.totalrecords" default="0">
        </cfif>
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">	
    </cfif>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="form" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_purchase_invoice_list">
                <input name="form_varmi" id="form_varmi" value="1" type="hidden">
                <cfsavecontent variable="title"><cf_get_lang dictionary_id="58917.Faturalar"></cfsavecontent>
                    <cf_box_search>
                            <div class="form-group" id="form_ul_keyword">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                                <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                            </div>
                            <div class="form-group" id="form_ul_belge_no">
                                <cfinput type="text" name="belge_no" value="#attributes.belge_no#" placeholder="#getLang('main',75)#">
                            </div>
                            <div class="form-group" id="form_ul_oby">
                                <select name="oby" id="oby" style="width:100px;">
                                    <option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                                    <option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                                    <option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='57215.Artan Fatura No'></option>
                                    <option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='57216.Azalan Fatura No'></option>
                                </select>
                            </div>
                            <div class="form-group small">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                            </div>
                            <div class="form-group">
                                <cf_wrk_search_button button_type="4">
                            </div>                       
                    </cf_box_search>
                    <cf_box_search_detail> 
                        <div class="col col-3 col-md-4 col-sm-6 col xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="form_ul_detail">
                                <label class="col col-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-12"><cfinput type="text" name="detail" value="#attributes.detail#" maxlength="500"></div>
                            </div>
                            <div class="form-group" id="form_ul_EMP_PARTNER_NAMEO">
                                <label class="col col-12"><cf_get_lang dictionary_id='57021.Satış Yapan'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)><cfoutput>#attributes.EMPO_ID#</cfoutput></cfif>">
                                        <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="<cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)><cfoutput>#attributes.PARTO_ID#</cfoutput></cfif>" >
                                        <input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)><cfoutput>#attributes.EMP_PARTNER_NAMEO#</cfoutput></cfif>" onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.EMP_PARTNER_NAMEO&field_partner=form.PARTO_ID&field_EMP_id=form.EMPO_ID</cfoutput>','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_record_emp_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                    <input type="text" name="record_emp_name" id="record_emp_name" style="width:120px;" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','form','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.record_emp_name&field_emp_id=form.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_department_txt">
                                <label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                                <div class="col col-12">
                                    <cf_wrkdepartmentlocation 
                                        returninputvalue="location_id,department_txt,department_id"
                                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                        fieldname="department_txt"
                                        fieldid="location_id"
                                        department_fldid="department_id"
                                        department_id="#attributes.department_id#"
                                        location_id="#attributes.location_id#"
                                        location_name="#attributes.department_txt#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        user_location = "0"
                                        width="140">
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.is_efatura>
                                <div class="form-group" id="form_ul_efatura_type">
                                <label class="col col-12"><cf_get_lang dictionary_id="29872.E-Fatura"></label>
                                    <div class="col col-12">
                                        <select name="efatura_type" id="efatura_type">
                                            <option value=""><cf_get_lang dictionary_id="29872.E-Fatura"></option>
                                            <option value="1" <cfif attributes.efatura_type eq 1>selected</cfif>><cf_get_lang dictionary_id="59329.Gönderilecekler">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="2" <cfif attributes.efatura_type eq 2>selected</cfif>><cf_get_lang dictionary_id="59776.E-Fatura Kesilenler">(<cf_get_lang dictionary_id="48025.Alış-Satış">)</option>
                                            <option value="3" <cfif attributes.efatura_type eq 3>selected</cfif>><cf_get_lang dictionary_id="57500.Onay">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="4" <cfif attributes.efatura_type eq 4>selected</cfif>><cf_get_lang dictionary_id="29537.Red">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="6" <cfif attributes.efatura_type eq 6>selected</cfif>><cf_get_lang dictionary_id="59332.Gönderilemeyenler"></option>
                                            <option value="7" <cfif attributes.efatura_type eq 7>selected</cfif>><cf_get_lang dictionary_id="46127.Onay Bekleyenler"></option>
                                            <option value="5" <cfif attributes.efatura_type eq 5>selected</cfif>><cf_get_lang dictionary_id="59338.E-Fatura Olmayanlar"></option>
                                        </select>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="form_ul_budget_record">
                                <label class="col col-12"><cf_get_lang dictionary_id ='57559.Bütçe'></label>
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id="57169.Bütçe Kaydı Olanlar/Bütçe Kaydı Olmayanlar"></cfsavecontent>                    
                                <div class="col col-12">
                                    <select name="budget_record" id="budget_record" style="width:90px;">
                                        <option value=""><cf_get_lang dictionary_id ='57559.Bütçe'> <cf_get_lang dictionary_id ='57075.Kaydı'></option>
                                        <option value="1" <cfif attributes.budget_record eq 1>selected</cfif>><cf_get_lang dictionary_id="57170.Bütçe Kaydı Olanlar"></option>
                                        <option value="0" <cfif attributes.budget_record eq 0>selected</cfif>><cf_get_lang dictionary_id="57171.Bütçe Kaydı Olmayanlar"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_invoice_type">
                                <label class="col col-12"><cf_get_lang dictionary_id='57441.Fatura'></label>
                                <div class="col col-12">
                                    <select name="invoice_type" id="invoice_type">
                                        <option value=""><cf_get_lang dictionary_id="57288.Fatura Tipi"></option>
                                        <option value="1" <cfif attributes.invoice_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57274.Toplu Fatura"></option>
                                        <option value="2" <cfif attributes.invoice_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57172.Grup Fatura"></option>
                                        <option value="3" <cfif attributes.invoice_type eq 3>selected</cfif>><cf_get_lang dictionary_id="41378.Manuel Fatura"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_company">
                                <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&field_type=form.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_control">
                                <label class="col col-12"><cf_get_lang dictionary_id='57441.Fatura'> <cf_get_lang dictionary_id='57038.Kontrolü'></label>
                                <div class="col col-12">
                                    <select name="control" id="control">
                                        <option value=""><cf_get_lang dictionary_id='57441.Fatura'> <cf_get_lang dictionary_id='57038.Kontrolü'></option>
                                        <option value="0" <cfif isDefined('attributes.control') and attributes.control eq 0>selected</cfif>><cf_get_lang dictionary_id='57314.Kontrol Edilmiş'></option>
                                        <option value="1" <cfif isDefined('attributes.control') and attributes.control eq 1>selected</cfif>><cf_get_lang dictionary_id='57315.Kontrol Edilmemiş'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="form_ul_product_name">
                                <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                                        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                        <input type="text"   name="product_name"  id="product_name" style="width:140px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form.stock_id&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form.product_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_record_date">
                                <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                                        <cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_payment_type">
                                <label class="col col-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>">
                                    <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>">
                                    <input type="text" name="payment_type" id="payment_type" value="<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>" style="width:140px;" onfocus="AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,card_paymethod_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=form.payment_type_id&field_name=form.payment_type&field_card_payment_id=form.card_paymethod_id&field_card_payment_name=form.payment_type','medium');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_iptal_invoice">
                                <label class="col col-12"><cf_get_lang dictionary_id='58816.İptal Edilenler'></label>
                                <div class="col col-12">
                                    <select name="iptal_invoice" id="iptal_invoice">
                                        <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                                        <option value="1" <cfif attributes.iptal_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id='58816.İptal Edilenler'></option>
                                        <option value="0" <cfif attributes.iptal_invoice eq 0>selected</cfif>><cf_get_lang dictionary_id='58817.İptal Edilmeyenler'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_product_cat_code">
                                <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                        <input name="product_cat_name" type="text" id="product_cat_name" onfocus="AutoComplete_Create('product_cat_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200');" value="<cfif len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_name#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=form.product_cat_code&field_name=form.product_cat_name</cfoutput>');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_start_date">
                                <label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama girmelisiniz'></cfsavecontent>
                                    <cfif session.ep.our_company_info.unconditional_list>
                                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    <cfelse>
                                        <cfif isdefined("url.cat")>
                                            <cfinput type="text" name="start_date" value="" style="width:65px;" validate="#validate_style#" required="no" maxlength="10" message="#message#">
                                        <cfelse>
                                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10" message="#message#">
                                        </cfif>
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                                    <cfif session.ep.our_company_info.unconditional_list> 
                                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    <cfelse>
                                        <cfif isdefined("url.cat") >
                                            <cfinput type="text" name="finish_date" value="" style="width:65px;" validate="#validate_style#" maxlength="10" required="no" message="#message#">			
                                        <cfelse>
                                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">			
                                        </cfif>
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_project_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                <cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfset attributes.project_id=url.pro_id></cfif><!--- Proje icmal raporundan baska bir yerde kullanilmiyorsa pro_id kontrolu kaldirilabilir FBS 20110607 --->
                                <cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif><!--- Buraya baska sayfalardan da erisiliyor, kaldirmayin FBS 20110607 --->
                                <input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head&allproject=1');"></span>
                            </div>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_member_cat_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                            <div class="col col-12">
                                <select name="member_cat_type" id="member_cat_type" style="width:150px;">
                                    <option value="" selected><cf_get_lang dictionary_id='57004.Üye Kategorisi Seçiniz'></option>
                                    <option value="1" <cfif attributes.member_cat_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></option>
                                    <cfinclude template="../../member/query/get_company_cat.cfm">
                                    <cfoutput query="get_companycat">
                                        <option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
                                    </cfoutput>
                                    <option value="2" <cfif attributes.member_cat_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
                                    <cfinclude template="../../member/query/get_consumer_cat.cfm">
                                    <cfoutput query="get_consumer_cat">
                                        <option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_is_tevkifat">
                            <label class="hide"><cf_get_lang dictionary_id='57390.Tevkifatlı Faturalar Gelsin'></label>
                            <div class="col col-12">
                                    <label><input type="checkbox" name="is_tevkifat" id="is_tevkifat" value="1" <cfif isdefined("attributes.is_tevkifat") and attributes.is_tevkifat eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='57390.Tevkifatlı Faturalar Gelsin'>&nbsp;&nbsp;</label>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.is_earchive>
                            <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
                                SELECT
                                    EARCHIVE_INTEGRATION_TYPE
                                FROM
                                    EARCHIVE_INTEGRATION_INFO
                                WHERE
                                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                            </cfquery>
                            <div class="form-group" id="form_ul_earchive_type">
                                <label class="col col-12"><cf_get_lang dictionary_id="57145.E-Arşiv"></label>
                                <div class="col col-12">
                                    <select name="earchive_type" id="earchive_type">
                                        <option value=""><cf_get_lang dictionary_id="57145.E-Arşiv"></option>
                                        <option value="1" <cfif attributes.earchive_type eq 1>selected</cfif>><cf_get_lang dictionary_id="59329.Gönderilecekler"></option>
                                        <option value="2" <cfif attributes.earchive_type eq 2>selected</cfif>><cf_get_lang dictionary_id="59330.Gönderilenler(KAĞIT)"></option>
                                        <option value="4" <cfif attributes.earchive_type eq 4>selected</cfif>><cf_get_lang dictionary_id="59330.Gönderilenler(KAĞIT)"></option>
                                        <option value="3" <cfif attributes.earchive_type eq 3>selected</cfif>><cf_get_lang dictionary_id="59332.Gönderilemeyenler"></option>
                                    </select>
                                </div>
                            </div>
    
                        </cfif>
                    </cf_box_search_detail> 
            </cfform>
        </cf_box>
        <cf_box title="#title#" uidrop="1" hide_table_column="1" scroll="1">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='31257.Kayıt No'></th>
                        <th><cf_get_lang dictionary_id='29412.Seri'></th>
                        <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                        <th><cf_get_lang dictionary_id='57630.Tip'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th nowrap="nowrap"><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                        <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif isdefined("attributes.form_varmi") and get_bill.recordcount>
                        <cfoutput query="get_bill">
                            <cfquery name="GETPRODUCTCODE" datasource="#dsn3#">
                                SELECT ACTIVITY_TYPE_ID, INVENTORY_CODE,INVENTORY_CAT_ID,AMORTIZATION_METHOD_ID,AMORTIZATION_TYPE_ID,AMORTIZATION_EXP_CENTER_ID,AMORTIZATION_EXP_ITEM_ID,AMORTIZATION_CODE FROM PRODUCT_PERIOD WHERE PERIOD_ID = #session.ep.period_id# AND PRODUCT_ID = #product_id#
                            </cfquery>
                            <cfif len(GETPRODUCTCODE.INVENTORY_CAT_ID)>
                                <cfquery name="GET_INV_CAT" datasource="#dsn3#">
                                    SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #GETPRODUCTCODE.INVENTORY_CAT_ID#
                                </cfquery>
                                <cfset inventory_cat = GET_INV_CAT.INVENTORY_CAT>
                            <cfelse>
                                <cfset inventory_cat = "">
                            </cfif>
                            <tr>
                                <td>#currentrow#</td>
                                <td>#get_bill.serial_number#</td>
                                <td><cfif len(get_bill.serial_no)>#get_bill.serial_no#<cfelse>#get_bill.invoice_number#</cfif></a></td>
                                <td><cfif is_iptal eq 1><font color="red"></cfif>#process_cat#<cfif is_iptal eq 1></font></cfif></td>
                                <td>#dateformat(record_date,dateformat_style)#</td>
                                <td>#stock_code#</td>
                                <td><a href="javascript://" onClick="AddRowInventory('#getproductcode.inventory_cat_id#','#inventory_cat#','#amount#','#tlformat(price)#','#row_money#','#product_id#','#stock_id#','#name_product#','#unit_id#','#unit#','#tax#','#tlformat(nettotal)#','#tlformat(taxtotal)#','#tlformat(row_other_value)#','#getproductcode.amortization_method_id#','#getproductcode.amortization_type_id#','#row_exp_center_id#','#expense#','#row_exp_item_id#','#expense_item_name#','#row_acc_code#','#activity_type_id#','#getproductcode.amortization_exp_center_id#','#getproductcode.amortization_exp_item_id#');" class="tableyazi">#name_product#</a></td>
                                <td style="mso-number-format:0\.00;">#TLFormat(amount)#</td>
                                <td style="text-align:right;">#TLFormat(price)#</td>
                                <td width="200">
                                    <cfif len(get_bill.company_id)>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_bill.company_id#','medium');">#fullname#</a>
                                    <cfelseif len(get_bill.con_id)>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_bill.con_id#','medium');">#consumer_name# #consumer_surname#</a>
                                    <cfelse>
                                        #get_emp_info(get_bill.employee_id,0,1)#
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
    <script language="javascript">
   function AddRowInventory(inventory_cat_id,inventory_cat,amount,price,rowmoney,productid,stockid,productname,unitid,unitvalue,tax,nettotal,taxtotal,rowothervalue,amortization_method_id,amortization_type_id,centerid,centername,itemid,itemname,inventory_code,activity_type_id)
    {
        //1-inventory_cat_id 
        //2-inventory_cat,
        //3-invent_no,
        //4-invent_name,
        //5-quantity,
        //6-net_total,
        //7-row_total,
        //8-tax_rate,
        //9-kdv_total,
        //10-net_total,
        
        //11-row_other_total,
        //12-money_id,
        //13-inventory_duration,
        //14-amortization_rate,
        //15-amortization_method,
        //16-amortization_type,
        //17-account_id,
        //18-account_code,
        //19-expense_center_id,
        //20-expense_center_name,
        //21-expense_item_id,
        //22-expense_item_name,
        //23-period,
        //24-debt_account_id,
        //25-debt_account_code,
        //26-claim_account_id,
        //27-claim_account_code,
        //28-product_id,
        //29-stock_id,
        //30-product_name,
        //31-stock_unit_id,
        //32-stock_unit,
        //33-ifrs_inventory_duration
        //34-Activity Type ID
        opener.add_row(inventory_cat_id,inventory_cat,'','',amount,nettotal,price,tax,taxtotal,nettotal,rowothervalue,rowmoney,'','',amortization_method_id,amortization_type_id,inventory_code,inventory_code,centerid,centername,itemid,itemname,'','','','','',productid,stockid,productname,unitid,unitvalue,'',activity_type_id);
    }
    </script>
    <!-- sil -->
    <cfif attributes.totalrecords gt attributes.maxrows>    
        <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.popup_purchase_invoice_list">
        <cfif isDefined('attributes.cat') and len(attributes.cat)>
            <cfset adres = "#adres#&cat=#attributes.cat#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.belge_no)>
            <cfset adres = "#adres#&belge_no=#attributes.belge_no#">
        </cfif>
        <cfif isDefined('attributes.oby') and len(attributes.oby)>
            <cfset adres = "#adres#&oby=#attributes.oby#">
        </cfif>
        <cfif isDefined('attributes.control') and len(attributes.control)>
            <cfset adres = "#adres#&control=#attributes.control#">
        </cfif>
        <cfif isdate(attributes.record_date)>
            <cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
        </cfif>
        <cfif isdate(attributes.start_date)>
            <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
        </cfif>
        <cfif isdate(attributes.finish_date)>
            <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.company_id)>
            <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#&member_type=#attributes.member_type#">
        </cfif>
        <cfif len(attributes.consumer_id)>
            <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#&member_type=#attributes.member_type#">
        </cfif>
        <cfif len(attributes.employee_id)>
            <cfset adres = "#adres#&employee_id=#attributes.employee_id#&company=#attributes.company#&member_type=#attributes.member_type#">
        </cfif>
        <cfif len(attributes.iptal_invoice)>
             <cfset adres = "#adres#&iptal_invoice=#attributes.iptal_invoice#">
        </cfif>
        <cfif isdefined("attributes.form_varmi")>
            <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#">
        </cfif>
        <cfif isdefined("attributes.pro_id")>
            <cfset adres = "#adres#&pro_id=#attributes.pro_id#">
        </cfif>
        <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
            <cfset adres = "#adres#&department_id=#attributes.department_id#" >
        </cfif>
        <cfif isdefined("attributes.department_txt") and len(attributes.department_txt)>
            <cfset adres = "#adres#&department_txt=#attributes.department_txt#">
        </cfif>
        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
            <cfset adres = "#adres#&stock_id=#attributes.stock_id#">
        </cfif>
        <cfif isdefined("attributes.product_id") and len(attributes.product_id)>
            <cfset adres = "#adres#&product_id=#attributes.product_id#">
        </cfif>
        <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
            <cfset adres = "#adres#&product_name=#attributes.product_name#">
        </cfif>
        <cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
            <cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#">
        </cfif>
        <cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
            <cfset adres = "#adres#&card_paymethod_id=#attributes.card_paymethod_id#">
        </cfif>
        <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)>
            <cfset adres = "#adres#&payment_type=#attributes.payment_type#">
        </cfif>
        <cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
            <cfset adres = "#adres#&EMPO_ID=#attributes.EMPO_ID#">
        </cfif>
        <cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)>
            <cfset adres = "#adres#&PARTO_ID=#attributes.PARTO_ID#">
        </cfif>
        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfset adres = "#adres#&project_id=#attributes.project_id#">
        </cfif>
        <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
            <cfset adres = "#adres#&project_head=#attributes.project_head#">
        </cfif>
        <cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
            <cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#">
        </cfif>
        <cfif isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
            <cfset adres = "#adres#&record_emp_name=#attributes.record_emp_name#">
        </cfif>
        <cfif isdefined("attributes.detail") and len(attributes.detail)>
            <cfset adres = "#adres#&detail=#attributes.detail#">
        </cfif>
        <cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
            <cfset adres = "#adres#&listing_type=#attributes.listing_type#">
        </cfif>
        <cfif isdefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
            <cfset adres = "#adres#&is_tevkifat=#attributes.is_tevkifat#">
        </cfif>
        <cfif isdefined("attributes.budget_record") and len(attributes.budget_record)>
            <cfset adres = "#adres#&budget_record=#attributes.budget_record#">
        </cfif>
        <cfif isdefined("attributes.product_cat_code") and len(attributes.product_cat_name)>
            <cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
            <cfset adres = "#adres#&product_cat_name=#attributes.product_cat_name#">
        </cfif>
        <cfif len(attributes.efatura_type)>
            <cfset adres = "#adres#&efatura_type=#attributes.efatura_type#">
        </cfif>
        <cfif len(attributes.earchive_type)>
            <cfset adres = "#adres#&earchive_type=#attributes.earchive_type#">
        </cfif>
        <cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#">
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
