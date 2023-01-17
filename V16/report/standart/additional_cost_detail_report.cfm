<!--- 
File: additional_cost_detail_report.cfm
Author:Melek KOCABEY <melekkocabey@workcube.com>, Esma Uysal <esmauysal@workcube.com>
Date: 02.09.2019
Controller: -
Description: Üretim Ek Maliyet dağıtımından oluşan detayların raporlanması.​ 
--->
<cfparam  name="attributes.product_cat_id " default="">
<cfparam  name="attributes.product_id" default="">
<cfparam  name="attributes.product_cat" default="">
<cfparam  name="attributes.product_name" default="">
<cfparam  name="attributes.expense_center_id" default="">
<cfparam name="attributes.acc_code_1" default="">
<cfparam name="attributes.acc_code_2" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam  name="attributes.is_excel" default="">
<cfparam  name="attributes.station_id" default="">
<cfparam name="attributes.page" default='1'><!--- sayfalamada kullanılıyor --->
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=''><!--- query.recordcount --->
<cfif isDate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isDate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfset getComponent = createObject('component','V16.report.cfc.get_cost')>
<cfset get_expence = getComponent.EXPENCE_CENTER()>
<cfset get_cost_det = getComponent.EXTRA_COST_DETAIL(
                                                    product_id : attributes.product_id,
                                                    expense_center_id : attributes.expense_center_id,
                                                    acc_code_1 : attributes.acc_code_1,
                                                    acc_code_2 : attributes.acc_code_2,
                                                    start_date : attributes.start_date,
                                                    finish_date : attributes.finish_date,
                                                    product_cat_id : attributes.product_cat_id,
                                                    station_id : attributes.station_id
                                                    )>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='57175.Ek Maliyet'> <cf_get_lang dictionary_id ='39485.Raporu' ></cfsavecontent>
<cfform name="cost_detail" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<input name="form_varmi" id="form_varmi" value="1" type="hidden">
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">                      
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-12">
                                    <div class="input-group"> 
                                        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                        <cfinput  type="text" name="product_name" id="product_name" value="#attributes.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','120');">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=cost_detail.product_id&field_name=cost_detail.product_name','list');"></span>
                                    </div>    
                                </div>    
                            </div>
                            <div class="form-group">
                                <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-12"> 
                                    <div class="input-group">
                                        <cfinput type="hidden" name="product_catid" value="#attributes.product_cat_id#">
                                        <cfinput type="text" name="product_cat" id="product_cat" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">       
                                        <span class="input-group-addon icon-ellipsis btnPoniter" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=product_catid&field_name=cost_detail.product_cat&field_min=cost_detail.MIN_MARGIN&field_max=cost_detail.MAX_MARGIN');" title="<cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'>!"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">	
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58834.İstasyon"></label>
                                <cf_wrk_list_items table_name ='WORKSTATIONS' wrk_list_object_id='STATION_ID' wrk_list_object_name='STATION_NAME' sub_header_name="#getLang('main',1422)#" header_name="#getLang('main',1422)#" datasource ="#dsn3#">
                            </div>                          
                            <div class="form-group">
                                <label class="col col-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                <div class="col col-12"> 
                                    <select name="expense_center_id" id="expense_center_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Lütfen seçiniz'></option>                                        
                                        <cfoutput query = "get_expence">
                                            <option value="#EXPENSE_ID#" <cfif attributes.expense_center_id eq expense_id>selected </cfif>>#EXPENSE#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>     
                        </div>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                                <div class="col col-12">
                                    <cf_wrk_multi_account_code form_name='cost_detail' acc_code1_1='#attributes.acc_code_1#' acc_code2_1='#attributes.acc_code_2#'>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>   
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="start_date">
                                        </span>	                           
                                    </div>
                                </div>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="finish_date">
                                        </span>
                                    </div>                                                 
                                </div>
                            </div>     
                        </div>
                    </div>
                </div>            	
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                        <cf_wrk_report_search_button button_type='1' is_excel="1" search_function="control()">
                    </div>
                </div>
            </div>
        </div>      
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.form_varmi")>
    <cf_report_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57880.Belge no'></th>
                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th><cf_get_lang dictionary_id='57174.Net Maliyet'></th>
                <th><cf_get_lang dictionary_id='47545.Yansıma'></th>
                <th><cf_get_lang dictionary_id='57175.Ek Maliyet'></th>
                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                <th><cf_get_lang dictionary_id="50296.Muhasebe Hesabı"></th>
                <th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_cost_det.recordcount>
                <cfoutput query = "get_cost_det"> 
                    <tr>
                        <td>#PRODUCT_COST_ID#</td><!--- Belge No --->
                        <td>#NAME_PRODUCT#</td><!--- Ürün İsmi --->  
                        <td><!--- Net Maliyet --->
                            <cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                #tlformat(PURCHASE_NET_SYSTEM_LOCATION,4)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
                            <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                #tlformat(PURCHASE_NET_SYSTEM_DEPARTMENT,4)# #PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT#
                            <cfelse>
                                #tlformat(PURCHASE_NET_SYSTEM,4)# #PURCHASE_NET_SYSTEM_MONEY#
                            </cfif>
                        </td>
                        <td>%#EXPENSE_SHIFT#</td><!--- Yansıma Oranı --->
                        <td>#tlformat(AMOUNT,4)# </td><!--- Ek Maliyet --->
                        <td><!--- Para Birimi --->
                            <cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                            #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
                            <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                            #PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT#
                            <cfelse>
                            #PURCHASE_NET_SYSTEM_MONEY#
                            </cfif>
                        </td>
                        <td>#EXPENSE#</td><!--- Masraf Merkezi --->
                        <td>#ACCOUNT_NAME#</td><!--- muhasebe hesabı --->
                        <td>#ACCOUNT_ID#</td> <!--- Muhasebe Kodu --->
                        <td>#dateformat(START_DATE,dateformat_style)#</td><!--- Tarih --->
                    </td>
                </cfoutput>
            <cfelse>
                <td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
            </cfif>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="11"></td>
            </tr>
        </tfoot>
    </cf_report_list>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "">
    <cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
        <cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#">
    </cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cfset url_str = '#url_str#&start_date=#attributes.start_date#'>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cfset url_str = '#url_str#&finish_date=#attributes.finish_date#'>
    </cfif>
    <cfif isdefined("attributes.product_cat") and len(attributes.product_cat) and isdefined('attributes.product_cat_id') and len(attributes.product_cat_id)>
        <cfset url_str = "#url_str#&product_cat=#attributes.product_cat#&product_cat_id=#attributes.product_cat_id#">
    </cfif>
    <cfif len(attributes.product_name) and len(attributes.product_name)>
        <cfset url_str = "#url_str#&product_name=#attributes.product_name#&product_name=#attributes.product_name#">
    </cfif>
    <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
        <cfset url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#">
    </cfif>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction#&#url_str#">
</cfif>
</cfif>
<script>
    if ((document.cost_detail.start_date.value != '') && (document.cost_detail.finish_date.value != '') )
    {
        if(!date_check(document.cost_detail.start_date,document.cost_detail.finish_date,"<cf_get_lang dictionary_id='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))        
        {
            return false;
        }
    }          
</script>