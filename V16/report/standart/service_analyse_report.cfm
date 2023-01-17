<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="14">
<cfinclude template="../../report/standart/report_authority_control.cfm">

<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.graph_type" default="">
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID,SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#dsn3#">
	SELECT SERVICE_SUBSTATUS_ID,SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS ORDER BY SERVICE_SUBSTATUS
</cfquery>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_SERVICE_ADD_OPTION" datasource="#DSN3#">
	SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_SERVICE_CODE" datasource="#DSN3#">
	SELECT 
		SERVICE_CODE_ID,
		SERVICE_CODE 
	FROM 
		SETUP_SERVICE_CODE
	ORDER BY
		SERVICE_CODE
</cfquery>
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.service_finishdate1" default="">
<cfparam name="attributes.service_finishdate2" default="">

<cfif isdefined("attributes.app_start_date") and isdate(attributes.app_start_date)>
	<cf_date tarih = "attributes.app_start_date">
<cfelse>
	<cfset attributes.app_start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.app_finish_date") and isdate(attributes.app_finish_date)>
	<cf_date tarih = "attributes.app_finish_date">
<cfelse>
	<cfset attributes.app_finish_date = date_add('d',7,attributes.app_start_date)>
</cfif>
<cfif isdefined("attributes.service_finishdate1") and isdate(attributes.service_finishdate1)>
	<cf_date tarih = "attributes.service_finishdate1">
</cfif>
<cfif isdefined("attributes.service_finishdate2") and isdate(attributes.service_finishdate2)>
	<cf_date tarih = "attributes.service_finishdate2">
</cfif>
<!--- <table width="99%" align="center">
	<div class="form-group">
        <td class="detailhead"><a href="javascript:gizle_goster_ikili('search','alt_table');">&raquo;<cf_get_lang dictionary_id='572.Detaylı Servis Analizi Raporu'></span></div>
		<div class="col col-11 col-xs-12">	<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="alt_table" is_ajax="1"></div>
	</div>
</table> --->
<cfform name="search_" method="post" action="#request.self#?fuseaction=report.service_analyse_report">

<input type="hidden" name="is_submit" id="is_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang_main dictionary_id="39293.Detaylı Servis Analizi Raporu"> </cfsavecontent>
<cf_report_list_search title="#message#">
<cf_report_list_search_area>

<cfoutput>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box_elements vertical="1">
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                <div class="form-group ui-form-list ui-form-block" id="item-product_id">
                    <label><cf_get_lang_main dictionary_id='57657.Ürün'></label>
                    <div class="input-group">
                        <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")>#attributes.product_id#</cfif>">
                        <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")>#attributes.stock_id#</cfif>">
                        <input type="text" name="product" id="product" style="width:90px;" onfocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME,STOCK_ID','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" autocomplete="off" value="<cfif isdefined("attributes.product")>#attributes.product#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=search_.stock_id&product_id=search_.product_id&field_name=search_.product','list');"></span>
                    </div>
                </div>
                    <div class="form-group" id="item-product_catid">
                    <label><cf_get_lang_main dictionary_id='57486.Kategori'></label>
                    <div class="input-group" >
                        <cf_wrk_product_cat form_name='search_' product_cat_id='product_catid' hierarchy_code='product_hierarchy' product_cat_name='product_cat'>
                        <input type="hidden" name="product_hierarchy" id="product_hierarchy" value="<cfif isdefined("attributes.product_hierarchy")>#attributes.product_hierarchy#</cfif>">
                        <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined("attributes.product_catid")>#attributes.product_catid#</cfif>">
                        <input type="text" name="product_cat" id="product_cat" style="width:100px;" value="<cfif isdefined("attributes.product_cat")>#attributes.product_cat#</cfif>" onkeyup="get_product_cat();" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
                        <span class="input-group-addon btnPointer icon-ellipsis"onclick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_.product_catid&field_name=search_.product_cat&field_hierarchy=search_.product_hierarchy','list');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-tedarikci_company_id">
                    <label><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                    <div class="input-group">
                        <input type="Hidden" name="tedarikci_company_id" id="tedarikci_company_id" value="<cfif isdefined("attributes.tedarikci_company_id")>#attributes.tedarikci_company_id#</cfif>">
                        <input type="text" name="tedarikci_company" id="tedarikci_company" style="width:90px;" value="<cfif isdefined("attributes.tedarikci_company")>#attributes.tedarikci_company#</cfif>" onfocus="AutoComplete_Create('tedarikci_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_.tedarikci_company_id&field_comp_name=search_.tedarikci_company&select_list=2','list');"></span>
                    </div>
                </div> 
                <div class="form-group" id="item-PRODUCT_BRANDS">
                    <label><cf_get_lang dictionary_id='58847.Marka'></label>
                    <cf_wrk_list_items 
                        table_name ='PRODUCT_BRANDS' 
                        wrk_list_object_id='BRAND_ID' 
                        wrk_list_object_name='BRAND_NAME' 
                        sub_header_name="#getLang('main',1435)#" 
                        header_name="#getLang('report',1818)#"
                        width='90' 
                        datasource ="#dsn1#">
                </div>
                <div class="form-group" id="item-product_manager">
                    <label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                    <div class="input-group">
                        <input type="hidden" name="product_manager" id="product_manager" value="<cfif isdefined("attributes.product_manager")>#attributes.product_manager#</cfif>">
                        <input type="text" name="product_manager_name" id="product_manager_name" style="width:90px;" value="<cfif isdefined("attributes.product_manager_name")>#attributes.product_manager_name#</cfif>" onfocus="AutoComplete_Create('product_manager_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','POSITION_CODE','product_manager','','3','150');">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=search_.product_manager&field_name=search_.product_manager_name','list');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-gorevli_id">
                    <label><cf_get_lang dictionary_id='44021.Görevli'></label>
                    <div class="input-group">
                        <input type="hidden" name="gorevli_id" id="gorevli_id" value="<cfif isdefined("attributes.gorevli_id")>#attributes.gorevli_id#</cfif>">
                        <input type="text" name="gorevli" id="gorevli" style="width:90px;" value="<cfif isdefined("attributes.gorevli")>#attributes.gorevli#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_emps&field_id=search_.gorevli_id&field_name=search_.gorevli','list');"></span>					
                    </div>
                </div>
                <div class="form-group" id="item-customer_value">
                    <label><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
                        <select name="customer_value" id="customer_value" style="width:90px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_customer_value">
                                <option value="#customer_value_id#" <cfif isdefined("attributes.customer_value") and attributes.customer_value eq customer_value_id> selected</cfif>>#customer_value#</option>
                            </cfloop>
                        </select>	
                </div> 
                    <div class="form-group" id="item-GET_PARTNER_RESOURCE">
                    <label><cf_get_lang dictionary_id='35363.İlişki Tipi'> </label>
                    <cf_wrk_combo
                        name="resource"
                        query_name="GET_PARTNER_RESOURCE"
                        option_name="resource"
                        option_value="resource_id"
                        value="#iif(isdefined("attributes.resource"),'attributes.resource',DE(''))#"
                        width="90">		
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                <div class="form-group" id="item-servicecat_id">
                    <label> <cf_get_lang dictionary_id='39313. servis Kategori'></label>
                    <select name="servicecat_id" id="servicecat_id" style="width:130px;height:80px;" multiple="multiple">
                        <cfloop query="get_service_appcat">
                            <option value="#servicecat_id#" <cfif isdefined("attributes.servicecat_id") and listfindnocase(attributes.servicecat_id,servicecat_id)> selected</cfif>>#servicecat#</option>
                        </cfloop>
                    </select>		
                </div>
                <div class="form-group" id="item-service_substatus_id">
                    <label><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
                    <select name="service_substatus_id" id="service_substatus_id" style="width:130px;height:80px;" multiple="multiple">
                        <cfloop query="get_service_substatus">
                            <option value="#service_substatus_id#" <cfif isdefined("attributes.service_substatus_id") and listfindnocase(attributes.service_substatus_id,service_substatus_id)> selected</cfif>>#service_substatus#</option>
                        </cfloop>
                    </select>	
                </div>
                <div class="form-group" id="item-sales_add_option">
                    <label><cf_get_lang dictionary_id="34753.Özel Tanım"></label>
                        <select multiple="multiple" name="sales_add_option" id="sales_add_option"  style="width:130px;height:80px;">
                            <cfloop query="get_service_add_option">
                                <option value="#service_add_option_id#" <cfif isdefined("attributes.sales_add_option") and listfindnocase(attributes.sales_add_option,service_add_option_id)>selected</cfif>>#service_add_option_name#</option>
                            </cfloop>
                        </select>
                </div> 
                        <div class="form-group" id="item-process_stage">
                        <label> <cf_get_lang dictionary_id='39339. servis Aşama'></label>
                        <select name="process_stage" id="process_stage" style="width:130px;height:80px;" multiple="multiple">
                            <cfloop query="get_process_stage">
                                <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and listfindnocase(attributes.process_stage,process_row_id)> selected</cfif>>#stage#</option>
                            </cfloop>
                        </select>	
                    </div>
                
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="3" type="column" sort="true"> 
                <div class="form-group" id="item-service_defect_code">
                    <label> <cf_get_lang_main  dictionary_id='58934.Arıza Kodu'></label>
                        <select multiple="multiple" name="service_defect_code" id="service_defect_code" >
                            <cfloop query="get_service_code">
                                <option value="#service_code_id#" <cfif isdefined("attributes.service_defect_code") and listfindnocase(attributes.service_defect_code,service_code_id)> selected</cfif>>#service_code#</option>
                            </cfloop>
                        </select>
                </div>
                <div class="form-group" id="item-sales_county">
                    <label><cf_get_lang dictionary_id='57659.Satış Bölgesi'> </label>
                        <select name="sales_county" id="sales_county" style="width:90px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="sz">
                                <option value="#sz_id#" <cfif isdefined("attributes.sales_county") and attributes.sales_county eq sz_id> selected</cfif>>#sz_name#</option>
                            </cfloop>
                        </select>	
                </div>
                    <div class="form-group" id="item-ims_code_id">
                        <label><cf_get_lang dictionary_id='32460.Mikro Bölge'></label>
                            <div class="input-group">
                                <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif isdefined("attributes.ims_code_id")>#attributes.ims_code_id#</cfif>">
                                <input type="text" name="ims_code_name" id="ims_code_name" style="width:90px;" value="<cfif isdefined("attributes.ims_code_name")>#attributes.ims_code_name#</cfif>" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_ims_code&field_name=search_.ims_code_name&field_id=search_.ims_code_id&select_list=1','list');"></span>
                            </div>
                    </div>
                <div class="form-group" id="item-serial_no">
                    <label> <cf_get_lang dictionary_id="57637.Seri No"></label>
                        <input type="text" name="serial_no" id="serial_no" style="width:120px;" value="<cfif isdefined("attributes.serial_no")>#attributes.serial_no#</cfif>">
                </div>
                <div class="form-group" id="item-subscription_id">
                    <label><cf_get_lang dictionary_id='29502.abone no'></label>	
                    <div class="input-group">
                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
                    <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','100');" autocomplete="off">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=search_.subscription_id&field_no=search_.subscription_no'</cfoutput>,'list','popup_list_subscription');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-service1">
                    <div class="col col-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='39309.Servis Sayı'><input type="checkbox" name="is_service_count" id="is_service_count" <cfif isdefined("attributes.is_service_count")>checked</cfif>> </label>
                        <label><cf_get_lang dictionary_id='57561.Zaman Harcamaları'><input type="checkbox" name="is_time_cost" id="is_time_cost" <cfif isdefined("attributes.is_time_cost")>checked</cfif>> </label> <label><cf_get_lang dictionary_id='39339.Servis Aşama'><input type="checkbox" name="is_service_asama" id="is_service_asama" <cfif isdefined("attributes.is_service_asama")>checked</cfif>></label>
                        <label> <cf_get_lang dictionary_id='39324.Servis Gelirleri'><input type="checkbox" name="is_service_gelirler" id="is_service_gelirler" <cfif isdefined("attributes.is_service_gelirler")>checked</cfif>></label>
                        <label><cf_get_lang dictionary_id='57567.Ürün Kategorileri'><input type="checkbox" name="is_urun_kategorileri" id="is_urun_kategorileri" <cfif isdefined("attributes.is_urun_kategorileri")>checked</cfif>></label>
                        
                    </div>
                    <div class="col col-6 col-xs-12">
                        <label><cf_get_lang dictionary_id="57637.Seri No">
                        <input type="checkbox" name="is_serial_no" id="is_serial_no" <cfif isdefined("attributes.is_serial_no")>checked</cfif>> </label>
                        <label><cf_get_lang dictionary_id='39313.Servis Kategori'><input type="checkbox" name="is_service_cat" id="is_service_cat" <cfif isdefined("attributes.is_service_cat")>checked</cfif>> </label>
                        <label><cf_get_lang dictionary_id='39314. Yedek Parça Maliyetleri'><input type="checkbox" name="is_service_maliyet" id="is_service_maliyet" <cfif isdefined("attributes.is_service_maliyet")>checked</cfif>></label>
                        <label><cf_get_lang dictionary_id='40140.Servis Alt Aşamaları'> <input type="checkbox" name="is_service_alt_asama" id="is_service_alt_asama" <cfif isdefined("attributes.is_service_alt_asama")>checked</cfif>></label>
                        <label><cf_get_lang dictionary_id="38125.Özel Tanım"><input type="checkbox" name="is_special_def" id="is_special_def" value="1" <cfif isdefined("attributes.is_special_def")>checked</cfif>></label>
                        <label><cf_get_lang dictionary_id="58934.Arıza Kodu"><input type="checkbox" name="is_failure_code" id="is_failure_code" value="1" <cfif isdefined("attributes.is_failure_code")>checked</cfif>></label>
                    </div>
                </div> 
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="4" type="column" sort="true">		
                <div class="form-group" id="item-date">
                    <label><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label></label>
                    <div class="col col-6 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                            <cfinput type="text" name="app_start_date" id="app_start_date" maxlength="10" value="#dateformat(attributes.app_start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="app_start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="app_finish_date" id="app_finish_date" maxlength="10" value="#dateformat(attributes.app_finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="app_finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-date2">
                    <label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                    <div class="col col-6 col-xs-12">
                        <div class="input-group" >
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="service_finishdate1" id="service_finishdate1" maxlength="10" value="#dateformat(attributes.service_finishdate1,dateformat_style)#" style="width:64px;" validate="#validate_style#" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="service_finishdate1"></span> <span class="input-group-addon no-bg"></span>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12">
                        <div class="input-group" >
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="service_finishdate2" id="service_finishdate2" maxlength="10" value="#dateformat(attributes.service_finishdate2,dateformat_style)#" style="width:64px;" validate="#validate_style#" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="service_finishdate2"></span>
                        </div>
                    </div>
                </div>	
                <div class="form-group" id="item-branch_id">
                    <label><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="input-group">
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")>#attributes.branch_id#</cfif>">
                        <input type="text" name="branch_name" id="branch_name" style="width:90px;" value="<cfif isdefined("attributes.branch_name")>#attributes.branch_name#</cfif>" onFocus="AutoComplete_Create('branch_name','BRANCH_NAME','BRANCH_NAME','get_position_branch','','BRANCH_ID','branch_id','3','120')">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=search_.branch_id&field_branch_name=search_.branch_name','list');"></span>
                    
                    </div>
                </div>
                <div class="form-group" id="item-report_type">
                    <label><cf_get_lang dictionary_id='58960.Rapor Tipi'> </label>
                    <select name="report_type" id="report_type" >
                        <option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1> selected</cfif>><cf_get_lang dictionary_id='39298.Ürüne Göre'></option>
                        <option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2> selected</cfif>><cf_get_lang dictionary_id='37971.Tedarikçiye Göre'></option>
                        <option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3> selected</cfif>><cf_get_lang dictionary_id='39300.Müşteriye Göre'></option>
                        <option value="9" <cfif isdefined("attributes.report_type") and attributes.report_type eq 9> selected</cfif>><cf_get_lang dictionary_id='40139.Bireysel Müşteriye Göre'></option>
                        <option value="4" <cfif isdefined("attributes.report_type") and attributes.report_type eq 4> selected</cfif>><cf_get_lang dictionary_id='39301.Sorumluya Göre'></option>
                        <option value="5" <cfif isdefined("attributes.report_type") and attributes.report_type eq 5> selected</cfif>><cf_get_lang dictionary_id='37972.Markaya Göre'></option>
                        <option value="6" <cfif isdefined("attributes.report_type") and attributes.report_type eq 6> selected</cfif>><cf_get_lang dictionary_id='35987.Kategoriye Göre'></option>
                        <option value="7" <cfif isdefined("attributes.report_type") and attributes.report_type eq 7> selected</cfif>><cf_get_lang dictionary_id='39305.Şubelere Göre'></option>
                        <option value="8" <cfif isdefined("attributes.report_type") and attributes.report_type eq 8> selected</cfif>><cf_get_lang dictionary_id='39306.Görevliye Göre'></option>
                        <option value="10"<cfif isdefined("attributes.report_type") and attributes.report_type eq 10> selected</cfif>><cf_get_lang dictionary_id="57637.Seri No"></option>
                    </select>	
                </div>
                <div class="form-group" id="item-service_status">
                    <label><cf_get_lang_main dictionary_id='58515.Aktif / Pasif'> </label>
                    <select name="service_status" id="service_status">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.service_status") and attributes.service_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isdefined("attributes.service_status") and attributes.service_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>					
                </div>     
                <div class="form-group" id="item-department_id">
                    <label><cf_get_lang dictionary_id='30031.Lokasyon'></label>
                    <div class="input-group">
                        <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")>#attributes.department_id#</cfif>">
                        <input type="hidden" name="location_id" id="location_id" value="<cfif isdefined("attributes.location_id")>#attributes.location_id#</cfif>">					
                        <input type="text" name="department" id="department" value="<cfif isdefined("attributes.department")>#attributes.department#</cfif>" style="width:90px;" onfocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','add_asset_it','3','200','add_department()');">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=search_&field_name=department&field_location_id=location_id&field_id=department_id&is_delivery=1</cfoutput>','medium');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-graph_type">
                    <label><cf_get_lang dictionary_id='39741.Grafik'></label>
                        <select name="graph_type" id="graph_type" >
                            <option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>
                            <option value="line" <cfif attributes.graph_type eq 'line'> selected</cfif>><cf_get_lang dictionary_id='51320.Line'></option>
                            <option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
                            <option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                        </select>
                </div>
            </div>
        </cf_box_elements>
        <div class="row ReportContentBorder">
            <div class="ReportContentFooter">
                <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                <cfelse>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                </cfif>
                <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
                <cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
            </div>
        </div>
    </div>
    
    
    
</cfoutput>

</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
    <cfset type_ = 2>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=999999999>
<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <cfset type_ = 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=999999999>
<cfelse>
    <cfset type_ = 0>
</cfif>   

<cfif isdefined("attributes.is_submit")>
    <cf_report_list>
	<cfset my_report_type = attributes.report_type>
	<cfif (isdefined("attributes.customer_value") and len(attributes.customer_value)) or (isdefined("attributes.resource") and len(attributes.resource)) or (isdefined("attributes.sales_county") and len(attributes.sales_county)) or (isdefined("attributes.ims_code_id") and isdefined("attributes.ims_code_name") and len(attributes.ims_code_id) and len(attributes.ims_code_name))>
		<cfset company_getir = 1>
	</cfif>
	<cfif isdefined("attributes.gorevli_id") and len(attributes.gorevli_id) and len(attributes.gorevli)>
		<cfset service_task = 1>
	</cfif>
	<cfquery name="GET_ALL_SERVICES" datasource="#DSN3#">
		SELECT
			<cfif my_report_type eq 1>P.PRODUCT_NAME AS DEGISKEN,P.PRODUCT_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 2>C.NICKNAME AS DEGISKEN,C.COMPANY_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 3>C.NICKNAME AS DEGISKEN,C.COMPANY_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 9>CON.CONSUMER_NAME + '' + CON.CONSUMER_SURNAME AS DEGISKEN,CON.CONSUMER_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 4>EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS DEGISKEN,EP.POSITION_CODE AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 5>PB.BRAND_NAME AS DEGISKEN,P.BRAND_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 6>PC.PRODUCT_CAT AS DEGISKEN,PC.PRODUCT_CATID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 7>B.BRANCH_NAME AS DEGISKEN,B.BRANCH_ID AS DEGISKEN_ID,</cfif>
			<cfif my_report_type eq 8>E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS DEGISKEN,ST.PROJECT_EMP_ID AS DEGISKEN_ID,</cfif>
            <cfif my_report_type eq 10>S.PRO_SERIAL_NO AS DEGISKEN, S.PRO_SERIAL_NO AS DEGISKEN_ID,P.PRODUCT_ID,P.PRODUCT_NAME,</cfif>
			<cfif isdefined("attributes.is_special_def")>SETUP_SERVICE_ADD_OPTIONS.SERVICE_ADD_OPTION_ID,</cfif>
            <cfif isdefined("attributes.is_failure_code")>SCR.SERVICE_CODE_ID,</cfif>
            S.SALE_ADD_OPTION_ID,
			S.SERVICECAT_ID,
			S.SERVICE_COMPANY_ID,
			S.SERVICE_CONSUMER_ID,
			S.SERVICE_EMPLOYEE_ID,
			S.APPLICATOR_NAME,
			S.SERVICE_NO,
			S.PRO_SERIAL_NO,
			S.PRODUCT_NAME,
			S.SERVICE_HEAD,
			S.SERVICE_BRANCH_ID,
			S.APPLY_DATE,
			SC.SERVICECAT,
			PTR.STAGE,
			<cfif my_report_type neq 3 or isdefined("attributes.is_urun_kategorileri") or (isdefined("attributes.product") and len(attributes.product) and len(attributes.product_id)) or (isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)) or (isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)) or (isdefined("attributes.product_manager") and len(attributes.product_manager) and len(attributes.product_manager_name)) or (isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name))>
				P.PRODUCT_CATID,
			</cfif>
			S.SERVICE_ID,
			S.SERVICE_STATUS_ID,
            S.SERVICE_SUBSTATUS_ID,
			S.SERVICE_ACTIVE
		FROM
			SERVICE S
			<cfif my_report_type neq 3 or isdefined("attributes.is_urun_kategorileri") or (isdefined("attributes.product") and len(attributes.product) and len(attributes.product_id)) or (isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)) or (isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)) or (isdefined("attributes.product_manager") and len(attributes.product_manager) and len(attributes.product_manager_name)) or (isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name))>
				LEFT JOIN STOCKS P ON S.STOCK_ID = P.STOCK_ID
			</cfif> 
            <cfif isdefined("attributes.is_special_def")>
            	LEFT JOIN SETUP_SERVICE_ADD_OPTIONS ON S.SALE_ADD_OPTION_ID =  SETUP_SERVICE_ADD_OPTIONS.SERVICE_ADD_OPTION_ID
            </cfif>  
            <cfif (isdefined("attributes.SERVICE_DEFECT_CODE") and len(SERVICE_DEFECT_CODE)) or isdefined("attributes.is_failure_code")>
            	LEFT JOIN SERVICE_CODE_ROWS SCR ON S.SERVICE_ID = SCR.SERVICE_ID
            </cfif>         
            ,
			<cfif my_report_type eq 6>
				PRODUCT_CAT PC,
			</cfif>
			<cfif my_report_type eq 2 or my_report_type eq 3 or isdefined("company_getir")>#dsn_alias#.COMPANY C,</cfif>
			<cfif my_report_type eq 9>#dsn_alias#.CONSUMER CON,</cfif>
			<cfif my_report_type eq 4>#dsn_alias#.EMPLOYEE_POSITIONS EP,</cfif>
			<cfif my_report_type eq 5>PRODUCT_BRANDS PB,</cfif>
			<cfif my_report_type eq 7>#dsn_alias#.BRANCH B,</cfif>
			<cfif isdefined("service_task") or my_report_type eq 8>
				#dsn_alias#.PRO_WORKS ST,
				#dsn_alias#.EMPLOYEES E,
			</cfif>
			
				SERVICE_APPCAT SC,
				#dsn_alias#.PROCESS_TYPE_ROWS AS PTR
		WHERE
			<cfif my_report_type eq 2>P.COMPANY_ID = C.COMPANY_ID AND</cfif>
			<cfif my_report_type eq 3 or isdefined("company_getir")>S.SERVICE_COMPANY_ID = C.COMPANY_ID AND</cfif>
			<cfif my_report_type eq 9>S.SERVICE_CONSUMER_ID = CON.CONSUMER_ID AND</cfif>
			<cfif my_report_type eq 4>P.PRODUCT_MANAGER = EP.POSITION_CODE AND</cfif>
			<cfif my_report_type eq 5>P.BRAND_ID = PB.BRAND_ID AND</cfif>
			<cfif my_report_type eq 6>P.PRODUCT_CATID = PC.PRODUCT_CATID AND</cfif>
			<cfif my_report_type eq 7>S.SERVICE_BRANCH_ID = B.BRANCH_ID AND</cfif>
			<cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
            	<cfif my_report_type eq 10>
                    S.PRO_SERIAL_NO = '#attributes.serial_no#' AND 
                <cfelse>
                	1 = 0 AND
                </cfif>
            </cfif>
			<cfif isdefined("service_task") or my_report_type eq 8>
                ST.SERVICE_ID = S.SERVICE_ID AND
                ST.PROJECT_EMP_ID = E.EMPLOYEE_ID AND
                ST.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfif isdefined("attributes.gorevli_id") and len(attributes.gorevli_id) and len(attributes.gorevli)>
                    ST.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gorevli_id#"> AND
                </cfif>
			</cfif>
			<cfif isdefined("attributes.service_status") and attributes.service_status eq 0>
				S.SERVICE_ACTIVE = 0 AND
			<cfelseif isdefined("attributes.service_status") and attributes.service_status eq 1>	
				S.SERVICE_ACTIVE = 1 AND
			</cfif>
			S.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID AND
			S.SERVICECAT_ID = SC.SERVICECAT_ID
			<cfif isdefined("attributes.service_defect_code") and listlen(attributes.service_defect_code)>
                AND	S.SERVICE_ID = SCR.SERVICE_ID 
                AND	SCR.SERVICE_CODE_ID IN (#attributes.service_defect_code#)
			</cfif>
            <cfif isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no)>
				AND S.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfif>
			<cfif isdefined("attributes.location_id") and len(attributes.location_id) and isdefined("attributes.department") and len(attributes.department)>AND S.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"></cfif>
			<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#"></cfif>
			<cfif isdefined("attributes.resource") and len(attributes.resource)>AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#"></cfif>
			<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#"></cfif>
			<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#"></cfif>
			<cfif isdefined("attributes.servicecat_id") and listlen(attributes.servicecat_id)>AND S.SERVICECAT_ID IN (#attributes.servicecat_id#)</cfif>
			<cfif isdefined("attributes.service_substatus_id") and listlen(attributes.service_substatus_id)>AND S.SERVICE_SUBSTATUS_ID IN (#attributes.service_substatus_id#)</cfif>
			<cfif isdefined("attributes.process_stage") and listlen(attributes.process_stage)>AND S.SERVICE_STATUS_ID IN (#attributes.process_stage#)</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)>AND S.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"></cfif>
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
			<cfif isdefined("attributes.product") and len(attributes.product) and len(attributes.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>AND P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"></cfif>
			<cfif isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)>AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tedarikci_company_id#"></cfif>
			<cfif isdefined("attributes.product_manager") and len(attributes.product_manager) and len(attributes.product_manager_name)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_manager#"></cfif>
			<cfif isdefined("attributes.app_start_date") and len(attributes.app_start_date)>AND S.APPLY_DATE >= #attributes.app_start_date#</cfif>
			<cfif isdefined("attributes.app_finish_date") and len(attributes.app_finish_date)>AND S.APPLY_DATE < #DATEADD("d",1,attributes.app_finish_date)#</cfif>
			<cfif isdefined("attributes.service_finishdate1") and len(attributes.service_finishdate1)>AND S.FINISH_DATE >= #attributes.service_finishdate1#</cfif>
			<cfif isdefined("attributes.service_finishdate2") and len(attributes.service_finishdate2)>AND S.FINISH_DATE < #DATEADD("d",1,attributes.service_finishdate2)#</cfif>
	</cfquery>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset type_ = 1>
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows=get_all_services.recordcount>				
    <cfelse>
        <cfset type_ = 0>
    </cfif>
	<cfif my_report_type eq 8 and isdefined("attributes.gorevli_id") and len(attributes.gorevli_id) and len(attributes.gorevli)> <!--- gorveliye goreyse buraya gir --->
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.totalrecords" default="#get_all_services.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
     
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                    <th><cf_get_lang dictionary_id='55116.Başvuru'> Y.</th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                </tr> 
            </thead>
                <cfif get_all_services.recordcount>
                    <cfoutput query="get_all_services" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tbody>
                            <tr >
                                <td>#service_no#</td>
                                <td>#dateformat(apply_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#</td>          
                                <td>#service_head#</td>
                                <td>
                                    <cfif len(service_company_id) and service_company_id neq 0>#get_par_info(service_company_id,1,1,1)# - #applicator_name#
                                    <cfelseif len(service_consumer_id) and service_consumer_id neq 0>#get_cons_info(service_consumer_id,1,1)#</span>
                                    <cfelseif len(service_employee_id) and service_employee_id neq 0>#get_emp_info(service_employee_id,0,1)#</cfif>
                                    </td>
                                <td>
                                    <cfif len(service_branch_id)>
                                        <cfset attributes.branch_id = service_branch_id>
                                        <cfquery name="GET_BRANCH" datasource="#DSN#">
                                            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                                        </cfquery>  
                                        #get_branch.branch_name#
                                    </cfif>
                                    </td>
                                <td>#servicecat#</td>
                                <td>#stage#</td>
                                <td>#product_name#</td>
                                <td>#pro_serial_no#</td>
                             </tr>
                         </tbody>    
                    </cfoutput>
                <cfelse>
                    <tbody> 
                        <tr>
                            <td colspan="20"><cfif isdefined("attributes.is_form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </tbody> 
                </cfif>
       
    <cfelse>
        <cfquery name="GET_SATIR_NAMES" dbtype="query"> <!--- diger kriterlere goreyse buraya gir --->
            SELECT 
                DISTINCT
                DEGISKEN,DEGISKEN_ID
            FROM
                GET_ALL_SERVICES
            WHERE 
                DEGISKEN_ID IS NOT NULL
                <cfif my_report_type eq 10>
                    ORDER BY PRODUCT_NAME
                <cfelse>
                    ORDER BY DEGISKEN
                </cfif>
        </cfquery>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.totalrecords" default=#get_satir_names.recordcount#>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfif get_satir_names.recordcount>
            <cfif isdefined("attributes.is_service_asama") and isdefined("attributes.process_stage")>
                <cfquery name="GET_PROCESS_STAGE_ROW" dbtype="query">
                    SELECT * FROM GET_PROCESS_STAGE WHERE PROCESS_ROW_ID IN (#attributes.process_stage#)
                </cfquery>
            <cfelseif isdefined("attributes.is_service_asama")>
                <cfquery name="GET_PROCESS_STAGE_ROW" dbtype="query">
                    SELECT * FROM GET_PROCESS_STAGE
                </cfquery>
            </cfif>
            
            <cfif isdefined("attributes.is_service_cat") and isdefined("attributes.servicecat_id")>
                <cfquery name="GET_SERVICE_APPCAT_ROW" dbtype="query">
                    SELECT * FROM GET_SERVICE_APPCAT WHERE SERVICECAT_ID IN (#attributes.servicecat_id#)
                </cfquery>
            <cfelseif isdefined("attributes.is_service_cat")>
                <cfquery name="GET_SERVICE_APPCAT_ROW" dbtype="query">
                    SELECT * FROM GET_SERVICE_APPCAT
                </cfquery>
            </cfif>
            
            <!--- özel tanım --->
            <cfif isdefined("attributes.sales_add_option") and len(attributes.sales_add_option)>
                <cfquery name="GET_SERVICE_ADD_OPTION" dbtype="query">
                    SELECT * FROM GET_SERVICE_ADD_OPTION WHERE SERVICE_ADD_OPTION_ID IN (#attributes.sales_add_option#)
                </cfquery>
            <cfelseif isdefined("attributes.is_special_def")>
                <cfquery name="GET_SERVICE_ADD_OPTION" dbtype="query">
                    SELECT * FROM GET_SERVICE_ADD_OPTION
                </cfquery>
            </cfif>

            <!--- arıza kodu --->
			<cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>
                <cfquery name="GET_SERVICE_CODE" dbtype="query">
                    SELECT * FROM GET_SERVICE_CODE WHERE SERVICE_CODE_ID IN (#attributes.service_defect_code#)
                </cfquery>
            <cfelseif isdefined("attributes.is_failure_code")>
                <cfquery name="GET_SERVICE_CODE" dbtype="query">
                    SELECT * FROM GET_SERVICE_CODE
                </cfquery>
            </cfif>
        
			<cfif isdefined("attributes.is_urun_kategorileri") and attributes.is_urun_kategorileri eq 1>
                <cfset product_cat_list_ = valuelist(get_all_services.product_catid)>
				<cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
					SELECT 
						*
					FROM 
						PRODUCT_CAT 
					WHERE 
						PRODUCT_CATID 
					IN 
					(
						<cfloop from="1" to="#ListLen(product_cat_list_)#" index="sayac">
							#ListGetAt(product_cat_list_,sayac,',')#
							<cfif sayac lt ListLen(product_cat_list_)>,</cfif>
						</cfloop>
					)
				</cfquery>
			</cfif>
           
                <cfoutput>     
                    <thead>
                        <cfif isdefined("attributes.is_special_def") or isdefined("attributes.is_failure_code") or isdefined("attributes.is_service_count") or (isdefined("attributes.is_service_cat") and get_service_appcat_row.recordcount) or (isdefined("attributes.is_service_asama") and get_process_stage_row.recordcount) or (isdefined("attributes.is_service_alt_asama") and GET_SERVICE_SUBSTATUS.recordcount) or isdefined("attributes.is_time_cost") or isdefined("attributes.is_service_maliyet") or isdefined("attributes.is_service_gelirler") or isdefined("attributes.is_urun_kategorileri")>
                            <!--- Üstteki kosulu hicbir checkbox secilmediginde bos bir satir atiyordu onu engellemek icin ekledim. M.E.Y 20120810--->
                            <tr>
                               <th><cf_get_lang dictionary_id='58960.Rapor Tipi'></th>
                                <cfif my_report_type eq 10><th>&nbsp;</th></cfif>
                                <cfif isdefined("attributes.is_service_count")><th colspan="3"><cf_get_lang dictionary_id='39319.Servis Sayıları'></th></cfif>
                                <cfif isdefined("attributes.is_service_cat") and get_service_appcat_row.recordcount><th colspan="#get_service_appcat_row.recordcount#"><cf_get_lang dictionary_id='39313.Servis Kategorileri'></th></cfif>
                                <cfif isdefined("attributes.is_service_asama") and get_process_stage_row.recordcount><th colspan="#get_process_stage_row.recordcount#"><cf_get_lang dictionary_id='39891.Servis Aşamaları'></th></cfif>
                                <cfif isdefined("attributes.is_service_alt_asama") and GET_SERVICE_SUBSTATUS.recordcount><th colspan="#GET_SERVICE_SUBSTATUS.recordcount#"><cf_get_lang dictionary_id='40140.Servis Alt Aşamaları'></th></cfif>
                                <cfif isdefined("attributes.is_time_cost")><th colspan="2"><cf_get_lang dictionary_id='55178.Zaman Yönetimi'></th></cfif>
                                <cfif isdefined("attributes.is_service_maliyet")><th><cf_get_lang dictionary_id='39322.Servis Maliyetleri'></th></cfif>
                                <cfif isdefined("attributes.is_service_gelirler")><th><cf_get_lang dictionary_id='39324.Servis Gelirleri'></th></cfif>
                                <cfif isdefined("attributes.is_urun_kategorileri") and attributes.is_urun_kategorileri eq 1><th colspan="#get_product_cats.recordcount#"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></th></cfif>
                                <cfif my_report_type eq 1 and isdefined("attributes.is_serial_no")><th><cf_get_lang dictionary_id="57637.Seri no"></th></cfif>
                                <cfif isdefined("attributes.is_special_def") and get_service_add_option.recordcount><th colspan="#get_service_add_option.recordcount#"><cf_get_lang dictionary_id="34753.Özel Tanım"></th></cfif>
                                <cfif isdefined("attributes.is_failure_code") and get_service_code.recordcount><th colspan="#get_service_code.recordcount#"><cf_get_lang dictionary_id="58934.Arıza Kodu"></th></cfif>
                            </tr>
                        </cfif>
                           <th>
                                <cfif attributes.report_type eq 1>
                                    <cfset report_name =getLang('report',577)>
                                <cfelseif attributes.report_type eq 2>
                                    <cfset report_name =getLang('report',578)>
                                <cfelseif attributes.report_type eq 3>
                                    <cfset report_name =getLang('report',579)>
                                <cfelseif attributes.report_type eq 9>
                                    <cfset report_name =getLang('report',1418)>
                                <cfelseif attributes.report_type eq 4>
                                    <cfset report_name =getLang('report',580)>
                                <cfelseif attributes.report_type eq 5>
                                    <cfset report_name =getLang('report',581)>
                                <cfelseif attributes.report_type eq 6>
                                    <cfset report_name =getLang('report',582)>
                                <cfelseif attributes.report_type eq 7>
                                    <cfset report_name =getLang('report',584)>
                                <cfelseif attributes.report_type eq 8>
                                    <cfset report_name =getLang('report',585)>
                                <cfelseif attributes.report_type eq 10>
                                    <cfset report_name =getLang('main',225)>
                                <cfelse>
                                    <cfset report_name = "">
                                </cfif>#report_name#
                            </th>
                            <!--- <cfif my_report_type eq 10><th><cf_get_lang dictionary_id='58221.Ürün adı'></th></cfif> --->
                            <cfif isdefined("attributes.is_service_count")><th><cf_get_lang dictionary_id='57493.Aktif'></th><th><cf_get_lang dictionary_id='57494.Pasif'></th><th><cf_get_lang dictionary_id='57708.Tümü'></th></cfif>
                            <cfif isdefined("attributes.is_service_cat") and get_service_appcat_row.recordcount><cfloop query="get_service_appcat_row"><th>#servicecat#</th></cfloop></cfif>
                            <cfif isdefined("attributes.is_service_asama") and get_process_stage_row.recordcount><cfloop query="get_process_stage_row"><th>#stage#</th></cfloop></cfif>
                            <cfif isdefined("attributes.is_service_alt_asama") and GET_SERVICE_SUBSTATUS.recordcount><cfloop query="GET_SERVICE_SUBSTATUS"><th>#SERVICE_SUBSTATUS#</th></cfloop></cfif>
                            <cfif isdefined("attributes.is_time_cost")><th><cf_get_lang dictionary_id='29513.Süre'></th><th><cf_get_lang dictionary_id='57673.Tutar'></th></cfif>
                            <cfif isdefined("attributes.is_service_maliyet")><th style="text-align:right;">#session.ep.money#</th></cfif>
                            <cfif isdefined("attributes.is_service_gelirler")><th style="text-align:right;">#session.ep.money#</th></cfif>
                            <cfif isdefined("attributes.is_urun_kategorileri") and attributes.is_urun_kategorileri eq 1><cfloop query="get_product_cats"><th>#product_cat#</th></cfloop></cfif>
                            <cfif my_report_type eq 1 and isdefined("attributes.is_serial_no")><th><cf_get_lang dictionary_id="57637.Seri no"></th></cfif>
                            <cfif isdefined("attributes.is_special_def") and get_service_add_option.recordcount><cfloop query="get_service_add_option"><th>#SERVICE_ADD_OPTION_NAME#</th></cfloop></cfif>
                            <cfif isdefined("attributes.is_failure_code") and get_service_code.recordcount><cfloop query="get_service_code"><th>#SERVICE_CODE#</th></cfloop></cfif>
                            </tr>
                    </thead>
                </cfoutput>
               <tbody> 
                    <cfoutput query="get_satir_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        
                            <tr>
							<cfset this_satir_degisken = DEGISKEN_ID>
                           <td>#DEGISKEN#</td>
                            <cfif my_report_type eq 10>
                                <cfquery name="GET_SERI_SERVICES_" dbtype="query">
                                    SELECT PRODUCT_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_satir_degisken#">
                                </cfquery>
                                <cfset product_id_ = get_seri_services_.product_id>
                               <td>
                                    <cfloop list="#listdeleteduplicates(valuelist(get_seri_services_.PRODUCT_ID))#" index="cc">
                                        #get_product_name(cc)#<br />
                                    </cfloop>
                                </td>
                            </cfif>
                            <cfset service_list_ = "">
                            <cfset ship_list_ = "">
                            <cfset gelirler_list = 0>
                            <cfif isdefined("attributes.is_time_cost") or isdefined("attributes.is_service_maliyet") or isdefined("attributes.is_service_gelirler")>
                                <cfif my_report_type eq 10>
                                    <cfquery name="get_this_servisler_" dbtype="query">
                                        SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = '#DEGISKEN_ID#'
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_this_servisler_" dbtype="query">
                                        SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = #DEGISKEN_ID#
                                    </cfquery>
                                </cfif>
                                <cfset service_list_ = valuelist(get_this_servisler_.service_id)>
                            </cfif>
                            <cfif isdefined("attributes.is_service_maliyet") or isdefined("attributes.is_service_gelirler")>
                                <cfquery name="get_ships" datasource="#dsn2#">
                                    SELECT SUM(SR.COST_PRICE+SR.EXTRA_COST) AS MALIYETLER FROM SHIP S,SHIP_ROW SR WHERE SR.SERVICE_ID IN (#service_list_#) AND S.SHIP_TYPE = 141 AND S.SHIP_ID = SR.SHIP_ID
                                </cfquery>
                                <cfquery name="get_shipler" datasource="#dsn2#">
                                    SELECT DISTINCT SHIP.SHIP_ID FROM SHIP,SHIP_ROW WHERE SHIP_ROW.SHIP_ID=SHIP.SHIP_ID AND SHIP_ROW.SERVICE_ID IN (#service_list_#) AND SHIP.SHIP_TYPE = 141
                                </cfquery>
                                <cfset ship_list_ = valuelist(get_shipler.SHIP_ID)>
                            </cfif>
                            <cfif isdefined("attributes.is_service_gelirler")>
                                <cfif listlen(ship_list_)>
                                    <cfquery name="get_gelirler_" datasource="#dsn2#">
                                        SELECT SUM(NETTOTAL) AS GELIRLER FROM INVOICE I,INVOICE_SHIPS ISH WHERE I.INVOICE_ID = ISH.INVOICE_ID AND <cfif ListFind("2,3",my_report_type)>COMPANY_ID = #this_satir_degisken# AND</cfif> ISH.SHIP_ID IN (#ship_list_#) AND ISH.SHIP_PERIOD_ID = #session.ep.period_id#
                                    </cfquery>
                                    <cfset gelirler_list = get_gelirler_.gelirler>
                                </cfif>
                            </cfif>
                            <!--- servis sayilari --->
                            <cfif isdefined("attributes.is_service_count")>
                                <cfif my_report_type eq 10>
                                    
                                    <cfquery name="get_aktif_services_" dbtype="query">
                                        SELECT SERVICE_ID FROM get_all_services WHERE SERVICE_ACTIVE = 1 AND DEGISKEN_ID = '#DEGISKEN_ID#' <cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>GROUP BY SERVICE_ID</cfif>
                                    </cfquery>
                                    <cfquery name="get_all_services_" dbtype="query">
                                        SELECT SERVICE_ID FROM get_all_services WHERE DEGISKEN_ID = '#DEGISKEN_ID#' <cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>GROUP BY SERVICE_ID</cfif>
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_aktif_services_" dbtype="query">
                                        SELECT SERVICE_ID FROM get_all_services WHERE SERVICE_ACTIVE = 1 AND DEGISKEN_ID = #DEGISKEN_ID# <cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>GROUP BY SERVICE_ID</cfif>
                                    </cfquery>
                                    <cfquery name="get_all_services_" dbtype="query">
                                        SELECT SERVICE_ID FROM get_all_services WHERE DEGISKEN_ID = #DEGISKEN_ID# <cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>GROUP BY SERVICE_ID</cfif>
                                    </cfquery>
                                </cfif>
                                <cfif get_all_services_.recordcount><cfset my_all_ = get_all_services_.recordcount><cfelse><cfset my_all_ = 0></cfif>
                                <cfif get_aktif_services_.recordcount><cfset my_aktif_ = get_aktif_services_.recordcount><cfelse><cfset my_aktif_ = 0></cfif>
                                <cfset my_pasif_ = 	my_all_ - my_aktif_>		
                               <td style="text-align:right;">#my_aktif_#</td>
                               <td style="text-align:right;">#my_pasif_#</td>
                               <td style="text-align:right;">#my_all_#</td>
                            </cfif>
                            <!--- servis kategorileri --->
                            <cfif isdefined("attributes.is_service_cat") and get_service_appcat_row.recordcount>
                               
                                <cfloop query="GET_SERVICE_APPCAT_ROW">
                                    <cfif my_report_type eq 10>
                                        <cfquery name="get_this_services_" dbtype="query">
                                            SELECT SERVICE_ID FROM get_all_services WHERE DEGISKEN_ID = '#this_satir_degisken#' AND SERVICECAT_ID = #SERVICECAT_ID#
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="get_this_services_" dbtype="query">
                                            SELECT SERVICE_ID FROM get_all_services WHERE DEGISKEN_ID = #this_satir_degisken# AND SERVICECAT_ID = #SERVICECAT_ID#
                                        </cfquery>
                                    </cfif>
                                   <td style="text-align:right;">#get_this_services_.recordcount#</td>
                                </cfloop>
                            </cfif>
                            <!--- servis asamalari --->
                            <cfif isdefined("attributes.is_service_asama") and get_process_stage_row.recordcount>
                              
                                <cfloop query="get_process_stage_row">
                                    <cfif my_report_type eq 10>
                                        <cfquery name="get_asama_services_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = '#this_satir_degisken#' AND SERVICE_STATUS_ID = #PROCESS_ROW_ID#
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="get_asama_services_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = #this_satir_degisken# AND SERVICE_STATUS_ID = #PROCESS_ROW_ID#
                                        </cfquery>
                                    </cfif>
                                   <td style="text-align:right;">#get_asama_services_.recordcount#</td>
                                </cfloop>
                            </cfif>
                            <!--- servis alt_asamalari --->
                            <cfif isdefined("attributes.is_service_alt_asama") and get_service_substatus.recordcount>
                               
                                <cfloop query="get_service_substatus">
                                    <cfif my_report_type eq 10>
                                        <cfquery name="GET_ALT_ASAMA_SERVICES_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_satir_degisken#"> AND SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_substatus_id#">
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="GET_ALT_ASAMA_SERVICES_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_satir_degisken#"> AND SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_substatus_id#">
                                        </cfquery>
                                    </cfif>
                                   <td style="text-align:right;">#get_alt_asama_services_.recordcount#</td>
                                </cfloop>
                            </cfif>
                            <!--- zaman yonetimi --->
                            <cfif isdefined("attributes.is_time_cost")>
                              
                                <cfquery name="GET_REL_WORK" datasource="#DSN#">
                                    SELECT WORK_ID FROM PRO_WORKS WHERE SERVICE_ID IN (#service_list_#) 
                                </cfquery>
                                <cfquery name="GET_ZAMAN_HARCAMALARI" datasource="#DSN#">
                                    SELECT SUM(EXPENSED_MONEY) AS TUTAR,SUM(EXPENSED_MINUTE) AS ZAMAN  FROM TIME_COST WHERE SERVICE_ID IN (#service_list_#)
                                </cfquery>
                                <cfset zaman_ = 0>
                                <cfset tutar_ = 0>
                                <cfif get_zaman_harcamalari.recordcount and len(get_zaman_harcamalari.ZAMAN)>
                                    <cfset zaman_ = get_zaman_harcamalari.ZAMAN>
                                </cfif>
                                <cfif get_zaman_harcamalari.recordcount and len(get_zaman_harcamalari.TUTAR)>
                                    <cfset tutar_ = get_zaman_harcamalari.TUTAR>
                                </cfif>
                                <cfloop list="#service_list_#" index="ss">
                                    <cfquery name="GET_REL_WORK" datasource="#DSN#">
                                        SELECT WORK_ID FROM PRO_WORKS WHERE SERVICE_ID = #ss#
                                    </cfquery>
                                    <cfquery name="GET_S_DATE" datasource="#DSN3#">
                                        SELECT RECORD_DATE FROM SERVICE WHERE SERVICE_ID = #ss#
                                    </cfquery>
                                    <cfif GET_REL_WORK.recordcount>
                                         <cfquery name="GET_ZAMAN_HARCAMALARI2" datasource="#DSN#">
                                            SELECT SUM(EXPENSED_MONEY) AS TUTAR,SUM(EXPENSED_MINUTE) AS ZAMAN  FROM TIME_COST WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rel_work.work_id#"> AND EVENT_DATE < <cfqueryparam value="#GET_S_DATE.RECORD_DATE#" cfsqltype="cf_sql_timestamp">
                                        </cfquery>
                                        <cfif get_zaman_harcamalari2.recordcount and len(get_zaman_harcamalari2.ZAMAN)>
                                            <cfset zaman_ = zaman_ + get_zaman_harcamalari2.ZAMAN>
                                        </cfif>
                                        <cfif get_zaman_harcamalari2.recordcount and len(get_zaman_harcamalari2.TUTAR)>
                                            <cfset tutar_ = tutar_ + get_zaman_harcamalari2.TUTAR>
                                        </cfif>
                                    <cfelse>
                                        <cfset get_zaman_harcamalari2.recordcount = 0>
                                    </cfif>
                                </cfloop>
                                <cfif get_zaman_harcamalari.recordcount and len(get_zaman_harcamalari.ZAMAN) or get_zaman_harcamalari2.recordcount and len(get_zaman_harcamalari2.ZAMAN)>
                                   <td>#int(zaman_/60)# : #zaman_%60#<cf_get_lang dictionary_id='57491.Saat'></td>
                                   <td style="text-align:right;">#tutar_# #session.ep.money#</td>
                                <cfelse>
                                   <td></td>
                                   <td></td>
                                </cfif>
                            </cfif>
                            <!--- servis maliyetleri --->
                            <cfif isdefined("attributes.is_service_maliyet")>
                             
                               <td style="text-align:right;"><cfif get_ships.recordcount and len(get_ships.maliyetler)>#tlformat(get_ships.maliyetler)# #session.ep.money#</cfif></td>
                            </cfif>
                            <!--- servis gelirleri --->
                            <cfif isdefined("attributes.is_service_gelirler")>
                              
                               <td style="text-align:right;"><cfif Len(gelirler_list)>#tlformat(gelirler_list)# #session.ep.money#</cfif></td>
                            </cfif>
                            <!--- urun kategoriler --->
                            <cfif isdefined("attributes.is_urun_kategorileri") and attributes.is_urun_kategorileri eq 1>
                               
                                <cfloop query="get_product_cats">
                                    <cfquery name="GET_URUN_KAT_SERVICES_" dbtype="query">
                                        SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_satir_degisken#"> AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#">
                                    </cfquery>
                                   <td>#get_urun_kat_services_.recordcount#</td>
                                </cfloop>
                            </cfif>
                            <!--- seri no --->
                            <cfif my_report_type eq 1 and isdefined("attributes.is_serial_no")>
                                <cfquery name="GET_SERI_SERVICES_" dbtype="query">
                                    SELECT PRO_SERIAL_NO FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_satir_degisken#">
                                </cfquery>
                              
                               <td style="text-align:right;">
                                    <cfloop list="#valuelist(get_seri_services_.PRO_SERIAL_NO)#" index="cc">
                                        #cc#<br />
                                    </cfloop>
                                </td>
                            </cfif>
                            <!--- Özel Tanım--->
                            <cfif isdefined("attributes.is_special_def") and get_service_add_option.recordcount>
                               
                                <cfloop query="get_service_add_option">
                                    <cfif my_report_type eq 10>
                                        <cfquery name="GET_THIS_SERVICES2_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_satir_degisken#"> AND SERVICE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_add_option_id#">
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="GET_THIS_SERVICES2_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_satir_degisken#"> AND SERVICE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_add_option_id#">
                                        </cfquery>
                                    </cfif>
                                   <td style="text-align:right;">
                                        #get_this_services2_.recordcount#
                                    </td>
                                </cfloop>
                            </cfif>

                            <!--- arıza kodu --->
							<cfif isdefined("attributes.is_failure_code") and get_service_code.recordcount>
                               
                                <cfloop query="get_service_code">
                                    <cfif my_report_type eq 10>
                                        <cfquery name="GET_THIS_SERVICES2_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_satir_degisken#"> AND SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_code_id#">
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="GET_THIS_SERVICES2_" dbtype="query">
                                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_satir_degisken#"> AND SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_code_id#">
                                        </cfquery>
                                    </cfif>
                                   <td style="text-align:right;">
                                        #get_this_services2_.recordcount#
                                    </td>
                                </cfloop>
                            </cfif>
                        </tr>
                    </tbody>
                    </cfoutput>
	        <cfelse>
                <tbody> 
                    <tr>
                        <td colspan="20"><cfif isdefined("attributes.is_form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </tbody>
        </cfif>
    </cfif>
    </cf_report_list>
  
    <cfif  attributes.totalrecords gt attributes.maxrows>
           <cfset adres="report.service_analyse_report&is_submit=1">
           <cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product) and len(attributes.stock_id)>
               <cfset adres="#adres#&product_id=#attributes.product_id#">
               <cfset adres="#adres#&stock_id=#attributes.stock_id#">
               <cfset adres="#adres#&product=#attributes.product#">
           </cfif>
   
           <cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
               <cfset adres="#adres#&customer_value=#attributes.customer_value#">
           </cfif>
           
           <cfif isdefined("attributes.servicecat_id") and len(attributes.servicecat_id)>
               <cfset adres="#adres#&servicecat_id=#attributes.servicecat_id#">
           </cfif>
           <cfif len(attributes.graph_type)>
               <cfset adres = "#adres#&graph_type=#attributes.graph_type#">
           </cfif>
           <cfif isdefined("attributes.service_substatus_id") and len(attributes.service_substatus_id)>
               <cfset adres="#adres#&service_substatus_id=#attributes.service_substatus_id#">
           </cfif>
           
           <cfset adres="#adres#&app_start_date=#dateformat(attributes.app_start_date,dateformat_style)#">
           <cfset adres="#adres#&app_finish_date=#dateformat(attributes.app_finish_date,dateformat_style)#">
           
           <cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
               <cfset adres="#adres#&product_catid=#attributes.product_catid#">
               <cfset adres="#adres#&product_cat=#attributes.product_cat#">
           </cfif>
           
           <cfif isdefined("attributes.service_defect_code")>
               <cfset adres="#adres#&service_defect_code=#attributes.service_defect_code#">
           </cfif>
           
           <cfif isdefined("attributes.resource") and len(attributes.resource)>
               <cfset adres="#adres#&resource=#attributes.resource#">
           </cfif>
           <cfset adres="#adres#&report_type=#attributes.report_type#">
           
           <cfif isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)>
               <cfset adres="#adres#&tedarikci_company_id=#attributes.tedarikci_company_id#">
               <cfset adres="#adres#&tedarikci_company=#attributes.tedarikci_company#">
           </cfif>
           <cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>
               <cfset adres="#adres#&sales_county=#attributes.sales_county#">
           </cfif>
           <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
               <cfset adres="#adres#&brand_id=#attributes.brand_id#">
               <cfset adres="#adres#&brand_name=#attributes.brand_name#">
           </cfif>
           <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
               <cfset adres="#adres#&ims_code_id=#attributes.ims_code_id#">
               <cfset adres="#adres#&ims_code_name=#attributes.ims_code_name#">
           </cfif>
           <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
               <cfset adres="#adres#&process_stage=#attributes.process_stage#">
           </cfif>
           <cfif isdefined("attributes.is_service_count")>
               <cfset adres="#adres#&is_service_count=1">
           </cfif>
           <cfif isdefined("attributes.is_time_cost")>
               <cfset adres="#adres#&is_time_cost=1">
           </cfif>
           <cfif isdefined("attributes.product_manager") and len(attributes.product_manager) and len(attributes.product_manager_name)>
               <cfset adres="#adres#&product_manager=#attributes.product_manager#">
               <cfset adres="#adres#&product_manager_name=#attributes.product_manager_name#">
           </cfif>
   
           <cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and isdefined("attributes.branch_name") and len(attributes.branch_name)>
               <cfset adres="#adres#&branch_id=#attributes.branch_id#">
               <cfset adres="#adres#&branch_name=#attributes.branch_name#">
           </cfif>
           <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
               <cfset adres="#adres#&subscription_id=#attributes.subscription_id#">
               <cfset adres="#adres#&subscription_no=#attributes.subscription_no#">
           </cfif>
           <cfif isdefined("attributes.gorevli_id") and len(attributes.gorevli_id) and len(attributes.gorevli)>
               <cfset adres="#adres#&gorevli_id=#attributes.gorevli_id#">
               <cfset adres="#adres#&gorevli=#attributes.gorevli#">
           </cfif>
           
           <cfif isdefined("attributes.is_service_cat")>
               <cfset adres="#adres#&is_service_cat=1">
           </cfif>
           <cfif isdefined("attributes.is_service_maliyet")>
               <cfset adres="#adres#&is_service_maliyet=1">
           </cfif>
           <cfif isdefined("attributes.is_service_asama")>
               <cfset adres="#adres#&is_service_asama=1">
           </cfif>
           <cfif isdefined("attributes.is_service_alt_asama")>
               <cfset adres="#adres#&is_service_alt_asama=1">
           </cfif>
           <cfif isdefined("attributes.is_service_gelirler")>
               <cfset adres="#adres#&is_service_gelirler=1">
           </cfif>
           <cfif isdefined("attributes.is_serial_no")>
               <cfset adres="#adres#&is_serial_no=1">
           </cfif>
           <cfif isdefined("attributes.is_special_def")>
               <cfset adres="#adres#&is_special_def=1">
           </cfif>
           <cfif isdefined("attributes.is_failure_code")>
               <cfset adres="#adres#&is_failure_code=1">
           </cfif>
            <cfif isdefined("attributes.sales_add_option")>
               <cfset adres="#adres#&sales_add_option=#attributes.sales_add_option#">
           </cfif>
           <cfif isdefined("attributes.serial_no")>
               <cfset adres="#adres#&serial_no=#attributes.serial_no#">
           </cfif>

           <cfif isdefined("attributes.department") and len(attributes.department)>
               <cfset adres="#adres#&department_id=#attributes.department_id#">
               <cfset adres="#adres#&location_id=#attributes.location_id#">
               <cfset adres="#adres#&department=#attributes.department#">
           </cfif>
                <cf_paging page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
    </cfif>
</cfif>
<br/>
<cfif isdefined("attributes.is_submit") and len(attributes.graph_type)>
	
		<div class="form-group">
			<td align="center">

					<cfoutput query="get_satir_names" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfset service_list_ = "">
                        <cfset ship_list_ = "">
						<cfif isdefined("attributes.is_time_cost") or isdefined("attributes.is_service_maliyet") or isdefined("attributes.is_service_gelirler")>
							<cfquery name="GET_THIS_SERVISLER_" dbtype="query">
								SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#degisken_id#">
							</cfquery>
							<cfset service_list_ = valuelist(get_this_servisler_.service_id)>
						</cfif>
						<cfif isdefined("attributes.is_service_maliyet") or isdefined("attributes.is_service_gelirler")>
							<cfquery name="GET_SHIPLER" datasource="#DSN2#">
								SELECT DISTINCT SHIP.SHIP_ID FROM SHIP,SHIP_ROW WHERE SHIP_ROW.SHIP_ID=SHIP.SHIP_ID AND SHIP_ROW.SERVICE_ID IN (#service_list_#) AND SHIP.SHIP_TYPE = 141
							</cfquery>
							<cfset ship_list_ = valuelist(get_shipler.ship_id)>
						</cfif>
						<cfif isdefined("attributes.is_service_gelirler")>
							<cfif listlen(ship_list_)>
								<cfquery name="get_gelirler_#degisken_id#" datasource="#DSN2#">
									SELECT SUM(NETTOTAL) AS GELIRLER FROM INVOICE I,INVOICE_SHIPS ISH WHERE I.INVOICE_ID = ISH.INVOICE_ID AND <cfif ListFind("2,3",my_report_type)>COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#degisken_id#"> AND</cfif> ISH.SHIP_ID IN (#ship_list_#) AND ISH.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
								</cfquery>
							</cfif>
						</cfif>

						<cfif isdefined("get_gelirler_#degisken_id#.recordcount") and evaluate("get_gelirler_#degisken_id#").recordcount and len(evaluate("get_gelirler_#degisken_id#.gelirler"))>
							<cfset gelir_=evaluate("get_gelirler_#degisken_id#.gelirler")>
						<cfelse>
							<cfset gelir_=0>
						</cfif>
                        <cfquery name="GET_ALL_SERVICES_" dbtype="query">
                            SELECT SERVICE_ID FROM GET_ALL_SERVICES WHERE DEGISKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#degisken_id#">
                        </cfquery>
                        <cfif get_all_services_.recordcount><cfset my_all_ = get_all_services_.recordcount><cfelse><cfset my_all_ = 0></cfif>
                        <cfset item_value = ''>
                        <cfset item_value = '#DEGISKEN# - #my_all_# -'>
                        <cfset 'item_#currentrow#' = "#item_value#">
					    <cfset 'value_#currentrow#' = "#gelir_#"> 
                    </cfoutput>
                    <script src="JS/Chart.min.js"></script> 
                    <canvas id="myChart" style="float:left;height:100%;"></canvas>
				    <script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_satir_names.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Servis Analiz Raporu",
									backgroundColor: [<cfloop from="1" to="#get_satir_names.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_satir_names.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				 </script>
			</div>
        </div>
</cfif>

<br/>
<script language="javascript">
	function kontrol()
	{	
        
		if(document.search_.is_excel.checked==false)
			{
				document.search_.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.service_analyse_report"
				return true;
			}
			else
			{
				document.search_.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_service_analyse_report</cfoutput>"
			}
    }
    </script>
