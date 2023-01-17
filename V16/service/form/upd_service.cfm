<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="service.add_service">
<cfset attributes.id = attributes.service_id>
<cfset url.id = attributes.service_id>
<cfparam name="attributes.sales_add_option" default="">
<cfquery name="GET_ACCESSORY" datasource="#DSN3#">
	SELECT ACCESSORY_ID,ACCESSORY FROM SERVICE_ACCESSORY
</cfquery>
<cfquery name="GET_PHY_DAM" datasource="#DSN3#">
	SELECT PHYSICAL_DAMAGE_ID,PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
</cfquery>
<cfquery name="get_sale_zones" datasource="#dsn#">
    SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif isdefined('attributes.id') and len(attributes.id)>
	<cfinclude template="../query/get_service_detail.cfm">
<cfelse>
	<cfset get_service_detail.recordcount = 0>
</cfif>
<cfif not isnumeric(attributes.id) or get_service_detail.recordcount eq 0>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../query/get_priority.cfm">
	<cfinclude template="../query/get_service_substatus.cfm">
	<cfinclude template="../query/get_com_method.cfm">
	<cfinclude template="../query/get_branch.cfm">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME,PHONE_CODE,COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID, SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfif x_is_show_service_workgroups eq 1>
    <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
        SELECT 
            WORKGROUP_ID,
            WORKGROUP_NAME
        FROM 
            WORK_GROUP
        WHERE
            STATUS = 1
            AND HIERARCHY IS NOT NULL AND
            ONLINE_HELP = 1
        ORDER BY 
            HIERARCHY
    </cfquery>
</cfif>
<cfquery name="GET_SERVICE_ADD_OPTION" datasource="#DSN3#">
	SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
</cfquery>
<cfquery name="GET_SERVICE_USING_CODE" datasource="#DSN3#">
	SELECT
		SETUP_SERVICE_CODE.SERVICE_CODE_ID,
		SETUP_SERVICE_CODE.SERVICE_CODE
	FROM 
		SERVICE_CODE_ROWS,
		SETUP_SERVICE_CODE
	WHERE 
		SERVICE_CODE_ROWS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
		SERVICE_CODE_ROWS.SERVICE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
</cfquery>
<cfset our_get_service_using_code=valuelist(get_service_using_code.service_code_id)>
<cfset service_id = get_service_detail.service_id>
<cfscript>
	attributes.company_id=get_service_detail.service_company_id;
	attributes.partner_id=get_service_detail.service_partner_id;
	attributes.consumer_id=get_service_detail.service_consumer_id;
	attributes.employee_id = get_service_detail.service_employee_id;
</cfscript>
<cfscript>
	stock_id = get_service_detail.stock_id;
	pro_serial_no = get_service_detail.pro_serial_no;
	page_no = get_service_detail.guaranty_page_no;
</cfscript>
<cfif len(stock_id) and len(pro_serial_no)>
	<cfinclude template="../query/get_pro_guaranty.cfm">
</cfif>
<cfsavecontent  variable="pageHead">
    <cf_get_lang dictionary_id='41699.Başvuru'>
</cfsavecontent>
    <cfset pageHead = "#pageHead# : #get_service_detail.service_no#">
<cf_catalystHeader>     
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-9 col-sm-12 col-xs-12">
            <cf_box> 
                <cfform name="upd_service" method="post" action="#request.self#?fuseaction=service.emptypopup_act_upd_service&id=#attributes.id#">  
                    <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
                    <input type="Hidden" name="start_date" id="start_date" value="">
                    <input type="Hidden" name="finish_date" id="finish_date" value="">
                    <input type="hidden" name="service_id" id="service_id" value="<cfif isdefined("attributes.service_id") and len(attributes.service_id)><cfoutput>#attributes.service_id#</cfoutput></cfif>">
                    <input type="Hidden" name="id" id="id" value="<cfoutput>#attributes.service_id#</cfoutput>"> 
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-is_salaried">
                                <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'>-<cf_get_lang dictionary_id='58936.Ücretli Servis'></span></label>
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57493.Aktif'>-<cf_get_lang dictionary_id='58936.Ücretli Servis'></cfsavecontent>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="checkbox" name="status" id="status" value="1" <cfif get_service_detail.service_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
                                    <label><input type="checkbox" name="is_salaried" id="is_salaried" value="1" <cfif get_service_detail.is_salaried eq 1>checked</cfif>><cf_get_lang dictionary_id='58936.Ücretli Servis'></label>
                                </div>
                            </div>
                            <cfset attributes.subscription_id = "">
                            <cfif session.ep.our_company_info.subscription_contract eq 1>
                                <div class="form-group" id="item-subscription_no">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='29502.Sistem No'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Sistem No'><cfif isdefined("is_subscription_no") and is_subscription_no eq 2>*</cfif></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_service_detail.subscription_id)>
                                            <cfset attributes.subscription_id = get_service_detail.subscription_id>					 	
                                            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
                                                SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                                            </cfquery>
                                        </cfif>
                                        <div class="input-group">
                                            <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_service_detail.subscription_id#</cfoutput>">
                                            <input type="text" name="subscription_no" id="subscription_no" value="<cfif len(get_service_detail.subscription_id)><cfoutput>#get_subscription.subscription_no#</cfoutput></cfif>" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,MEMBER_NAME','get_subscription','1','SUBSCRIPTION_ID,COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_TYPE,MEMBER_NAME','subscription_id,company_id,company_name,member_id,member_type,member_name','','3','150');" autocomplete="off">                                          
                                                <cfset str_subscription_link="field_project_id=upd_service.project_id&field_project_name=upd_service.project_head&field_partner=&field_id=upd_service.subscription_id&field_no=upd_service.subscription_no&field_member_id=upd_service.member_id&field_member_name=upd_service.member_name&field_member_type=upd_service.member_type&field_company_id=upd_service.company_id&field_company_name=upd_service.company_name&field_ship_address=upd_service.service_address&field_ship_city_id=upd_service.service_city_id&field_ship_county_id=upd_service.service_county_id&field_ship_county_name=upd_service.service_county_name">	
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#</cfoutput>');"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-project_head">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_service_detail.project_id#</cfoutput>">
                                        <input name="project_head" id="project_head" type="text" value="<cfif len(get_service_detail.project_id)><cfoutput>#GET_PROJECT_NAME(get_service_detail.project_id)#</cfoutput></cfif>">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_service.project_id&project_head=upd_service.project_head');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57457.Müşteri'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_service_detail.service_company_id#</cfoutput>">				  
                                        <cfif len(get_service_detail.service_partner_id)>
                                            <cfinput type="text" name="company_name" id="company_name" value="#get_par_info(get_service_detail.service_partner_id,0,1,0)#" readonly="readonly">
                                        <cfelse>
                                            <cfinput type="text" name="company_name" id="company_name" value="#get_cons_info(get_service_detail.service_consumer_id,0,0)#" readonly="readonly">
                                        </cfif>
                                        
                                        <cfset str_linke_ait="field_partner=upd_service.member_id&field_consumer=upd_service.member_id&field_name=upd_service.member_name&field_comp_id=upd_service.company_id&field_comp_name=upd_service.company_name&field_type=upd_service.member_type&#iif(is_county_related_company,DE("&is_county_related_company=1&related_company_id=upd_service.related_company_id&related_company=upd_service.related_company"),DE(""))#">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7,8&function_name=fill_saleszone&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_service.company_name.value)</cfoutput>);" title="<cf_get_lang dictionary_id='41872.Basvuru Yapan Seç'>"></span>
                                    </div>
                                </div>
                            </div>                     
                            <div class="form-group" id="item-member_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57578.Yetkili'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(get_service_detail.service_partner_id)>
                                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service_detail.service_partner_id#</cfoutput>">
                                        <input type="hidden" name="member_type" id="member_type" value="partner">
                                        <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_service_detail.applicator_name#</cfoutput>">
                                    <cfelseif  len(get_service_detail.service_consumer_id)>
                                    <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service_detail.service_consumer_id#</cfoutput>">
                                    <input type="hidden" name="member_type" id="member_type" value="consumer">
                                    <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_service_detail.applicator_name#</cfoutput>">
                                    <cfelse>
                                        <input type="hidden" name="member_id" id="member_id" value="">
                                        <input type="hidden" name="member_type" id="member_type" value="">
                                        <input type="text" name="member_name"  id="member_name" value="<cfoutput>#get_service_detail.applicator_name#</cfoutput>">
                                    </cfif>                                    
                                </div>
                            </div>
                            <div class="form-group" id="item-appcat_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="old_appcat_id" id="old_appcat_id" value="<cfoutput>#get_service_detail.servicecat_id#</cfoutput>" >
                                    <select name="appcat_id" id="appcat_id" onchange="<cfif x_is_multiple_category_select eq 1>showAltKategori();</cfif>">
                                        <cfoutput query="get_service_appcat">
                                            <option value="#servicecat_id#" <cfif get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <cfif x_is_multiple_category_select eq 1>
                                <div class="form-group" id="item-appcat_sub_id">
                                    <cfsavecontent variable="header_"><cf_get_lang dictyionary_id='41709.Alt Kategori'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41709.Alt Kategori'>*</label>
                                    <div class="col col-8 col-xs-12" id="sub_cat_place">
                                        <cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
                                            <cfquery name="get_service_sub_appcat" datasource="#dsn3#">
                                                SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_detail.servicecat_id# ORDER BY SERVICECAT_SUB ASC
                                            </cfquery>
                                        </cfif>
                                        <select name="appcat_sub_id" id="appcat_sub_id" onchange="showAltTreeKategori();">
                                            <option value="0">Seçiniz</option>
                                            <cfif len(get_service_detail.servicecat_id)>
                                                <cfoutput query="get_service_sub_appcat">
                                                    <option value="#servicecat_sub_id#" <cfif servicecat_sub_id eq get_service_detail.servicecat_sub_id>selected</cfif>>#servicecat_sub#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>	
                                    </div>
                                </div>
                                <div class="form-group" id="item-appcat_sub_status_id">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41708.Alt Tree Kategori'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41708.Alt Tree Kategori'>*</label>
                                    <div class="col col-8 col-xs-12" id="sub_cat_tree_place">
                                        <cfif isdefined("get_service_detail.SERVICECAT_SUB_ID") and len(get_service_detail.SERVICECAT_SUB_ID)>
                                            <cfquery name="get_service_sub_status_appcat" datasource="#dsn3#">
                                                SELECT SERVICECAT_SUB_STATUS_ID,SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = #get_service_detail.SERVICECAT_SUB_ID# ORDER BY SERVICECAT_SUB_STATUS ASC
                                            </cfquery>
                                        </cfif>
                                        <select name="appcat_sub_status_id" id="appcat_sub_status_id">
                                            <option value="0">Seçiniz</option>
                                            <cfif len(get_service_detail.SERVICECAT_SUB_STATUS_ID)>
                                                <cfoutput query="get_service_sub_status_appcat">
                                                    <option value="#servicecat_sub_status_id#" <cfif servicecat_sub_status_id eq get_service_detail.SERVICECAT_SUB_STATUS_ID>selected</cfif>>#servicecat_sub_status#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>	
                                    </div>
                                </div>
                            </cfif>
                            <cfif x_is_show_service_workgroups eq 1>
                            <div class="form-group" id="item-service_work_groups">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='29818.İş Grupları'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29818.İş Grupları'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="service_work_groups" id="service_work_groups">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="GET_WORKGROUPS">
                                            <option value="#WORKGROUP_ID#">#WORKGROUP_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            </cfif>
                            <div class="form-group" id="item-process_cat">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id="58859.Süreç"></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='150' is_detail='1'>
                                </div>
                            </div>
                            <div class="form-group" id="item-service_substatus_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58973.Alt Aşama'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="service_substatus_id" id="service_substatus_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_service_substatus">
                                            <option value="#service_substatus_id#" <cfif get_service_detail.service_substatus_id eq service_substatus_id>selected</cfif>>#service_substatus#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-priority_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57485.Öncelik'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="priority_id" id="priority_id">
                                        <cfoutput query="get_priority">
                                            <option value="#priority_id#" <cfif get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-commethod_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_ido='58143.İletişim'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="commethod_id" id="commethod_id">
                                        <cfoutput query="get_com_method">
                                            <option value="#commethod_id#" <cfif get_service_detail.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.subscription_contract eq 1>
                            <div class="form-group" id="item-sales_add_option">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41655.Özel Tanım'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41655.Özel Tanım'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="sales_add_option" id="sales_add_option">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="GET_SERVICE_ADD_OPTION">
                                            <option value="#GET_SERVICE_ADD_OPTION.service_add_option_id#" <cfif GET_SERVICE_DETAIL.SALE_ADD_OPTION_ID eq GET_SERVICE_ADD_OPTION.service_add_option_id>selected</cfif>>#GET_SERVICE_ADD_OPTION.service_add_option_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            </cfif>
                            <div class="form-group" id="item-sales_zone_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='57659.Satis bolgesi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57659.Satis bolgesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="sales_zone_id" id="sales_zone_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_sale_zones">
                                            <option value="#sz_id#" <cfif get_service_detail.sz_id eq sz_id>selected</cfif>>#sz_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-service_head">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57480.Konu Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" required="yes" maxlength="100" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-service_detail">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="service_detail" id="service_detail" style="width:465px;height:199px;"><cfoutput>#get_service_detail.service_detail#</cfoutput></textarea>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                            <div class="form-group" id="item-accessory">
                                <label class="col col-4 col-xs-12"><input type="checkbox" name="accessory" id="accessory" value="1" <cfif get_service_detail.accessory eq 1>checked</cfif>><cf_get_lang dictionary_id='41823.Aksesuar'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif x_inventory_select eq 1>
                                        <select name="accessory_detail_select" id="accessory_detail_select" multiple="multiple">
                                            <cfoutput query="GET_ACCESSORY">
                                                <option value="#ACCESSORY_ID#" <cfif listfind(get_service_detail.accessory_detail_select,ACCESSORY_ID)>selected="selected"</cfif>>#ACCESSORY#</option>
                                            </cfoutput>
                                        </select>
                                    <cfelse>
                                        <textarea name="accessory_detail" id="accessory_detail" rows="3" cols="27"><cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.accessory_detail#</cfoutput></cfif></textarea>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-guaranty_inside">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41870.Fiziki Hasar'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><input type="checkbox" name="guaranty_inside" id="guaranty_inside" value="<cfoutput>#get_service_detail.guaranty_inside#</cfoutput>" <cfif get_service_detail.guaranty_inside eq 1>checked</cfif>><cf_get_lang dictionary_id='41870.Fiziki Hasar'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="inside_detail_select" id="inside_detail_select" multiple="multiple">
                                        <cfoutput query="GET_PHY_DAM">
                                            <option value="#PHYSICAL_DAMAGE_ID#" <cfif listfind(get_service_detail.inside_detail_select,PHYSICAL_DAMAGE_ID)>selected="selected"</cfif>>#PHYSICAL_DAMAGE#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            </cfif> 
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <div class="form-group" id="item-service_product">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_service_detail.stock_id) and len(get_service_detail.service_product_id)>
                                                <cfquery name="GET_PRO_SERIAL" datasource="#DSN3#">
                                                    SELECT IS_SERIAL_NO FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_product_id#">
                                                </cfquery>
                                                <input type="hidden" name="is_check_product_serial_number" id="is_check_product_serial_number" value="<cfoutput>#get_pro_serial.is_serial_no#</cfoutput>">
                                            <cfelse>
                                                <input type="hidden" name="is_check_product_serial_number" id="is_check_product_serial_number" value="">
                                            </cfif>
                                            <input type="hidden" name="service_product_cat" id="service_product_cat" onchange="get_service_defect(this.value);" />
                                            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_service_detail.stock_id#</cfoutput>">
                                            <input type="hidden" name="service_product_id" id="service_product_id" value="<cfoutput>#get_service_detail.service_product_id#</cfoutput>">
                                            <input type="text" name="service_product" id="service_product" onfocus="AutoComplete_Create('service_product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID,PRODUCT_CATID','service_product_id,stock_id,service_product_cat','','3','200','get_service_defect()');" value="<cfoutput>#get_service_detail.product_name#</cfoutput>">
                                            <cfif get_module_user(47)>                                            
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_service.stock_id&product_id=upd_service.service_product_id&&field_name=upd_service.service_product&field_service_serial=upd_service.is_check_product_serial_number&service_product_cat=upd_service.service_product_cat');"></span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <div class="form-group" id="item-spect_name">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41663.Ürün Spec'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41663.Ürün Spec'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_service_detail.spec_main_id)>
                                                <cfquery name="GET_SPEC_NAME" datasource="#DSN3#">
                                                    SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.spec_main_id#">
                                                </cfquery>
                                                <cfset spec_name_ = get_spec_name.SPECT_MAIN_NAME>
                                            <cfelse>
                                                <cfset spec_name_ = "">
                                            </cfif>
                                            <input type="hidden" name="spec_main_id" id="spec_main_id" value="<cfoutput>#get_service_detail.SPEC_MAIN_ID#</cfoutput>">
                                            <input name="spect_name" id="spect_name" type="text" value="<cfoutput>#spec_name_#</cfoutput>">
                                            <span class="input-group-addon icon-ellipsis btnPointer"  onclick="product_control();"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <div class="form-group" id="item-service_product_serial">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57637.Seri No'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                                    <div class="col col-8 col-xs-12">                                       
                                        <cfif not listfindnocase(denied_pages,'objects.serial_no&event=det')>
                                            <cfif len(get_service_detail.pro_serial_no)>            
                                                <div class="input-group">
                                                    <cfinput type="text" name="service_product_serial" id="service_product_serial" value="#get_service_detail.pro_serial_no#" maxlength="100" onChange="serino_search();"><!--- required="yes" message="Ürün İçin Seri No Takibi Yapılıyor!\Lütfen Seri No Giriniz" --->                                
                                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="serino_control();" title="<cf_get_lang dictionary_id='41705.Garanti Kapsamı'>"></span>
                                                </div>
                                            <cfelse>
                                                <cfinput type="text" name="service_product_serial" id="service_product_serial" value="#get_service_detail.pro_serial_no#" maxlength="100" onChange="serino_search();"><!--- required="yes" message="Ürün İçin Seri No Takibi Yapılıyor!\Lütfen Seri No Giriniz" ---> 
                                            </cfif>                                                                          
                                        </cfif>                                    
                                    </div>
                                </div>
                            </cfif>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <div class="form-group" id="item-main_serial_no">
                                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41915.Ana Seri No'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41915.Ana Seri No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="main_serial_no" id="main_serial_no" value="#get_service_detail.main_serial_no#" onChange="main_serino_search();">                                            
                                            <span class="input-group-addon icon-ellipsis btnPointer"  onClick="main_serino_control();" title="<cf_get_lang dictionary_id='41705.Garanti Kapsamı'>"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-info_type_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Fiziki Hasar'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-15" info_id="#attributes.service_id#" upd_page = "1" colspan="9">
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-other_company_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41647.İlgili Bayi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41647.İlgili Bayi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="other_company_id" id="other_company_id" value="<cfoutput>#get_service_detail.other_company_id#</cfoutput>">	
                                        <input type="text" name="other_company_name" id="other_company_name" value="<cfif len(get_service_detail.other_company_id)><cfoutput>#get_par_info(get_service_detail.other_company_id,1,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('other_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','other_company_id','','3','150');" autocomplete="off">
                                        <cfset str_linke_ait="&field_comp_id=upd_service.other_company_id&field_comp_name=upd_service.other_company_name"> 
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7'</cfoutput>);" title="İlgili Şirket"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-other_company_branch_company_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41647.İlgili Bayi'><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41647.İlgili Bayi'><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="other_company_branch_id" id="other_company_branch_id" value="<cfoutput>#get_service_detail.other_company_branch_id#</cfoutput>">	
                                        <cfif len(get_service_detail.other_company_branch_id) and get_service_detail.other_company_branch_id eq -1>
                                            <cfset other_company_branch_name_ = 'Merkez'>
                                        <cfelseif len(get_service_detail.other_company_branch_id)>
                                            <cfquery name="GET_B_NAME" datasource="#DSN#">
                                                SELECT COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.other_company_branch_id#">
                                            </cfquery>
                                            <cfset other_company_branch_name_ = '#get_b_name.COMPBRANCH__NAME#'>
                                        <cfelse>
                                            <cfset other_company_branch_name_ = ''>
                                        </cfif>
                                        <input type="hidden" name="other_company_branch_company_id" id="other_company_branch_company_id" value="<cfoutput>#get_service_detail.other_company_id#</cfoutput>">
                                        <input type="text" name="other_company_branch_name" id="other_company_branch_name" value="<cfoutput>#other_company_branch_name_#</cfoutput>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer"  onclick="add_adress_other();"></span>
                                    </div>
                                </div>
                            </div>                  
                            <div class="form-group" id="item-apply_date">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41671.Başvuru Tarihi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41671.Başvuru Tarihi'> *</label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='41671.Başvuru Tarihi'></cfsavecontent>
                                        <cfif len(get_service_detail.apply_date)>
                                            <cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
                                            <cfset ahour=datepart("H",adate)>
                                            <cfset aminute=datepart("N",adate)>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='41673.Başvuru Tarihini Girmelisiniz'>!</cfsavecontent>
                                            <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(adate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <cfelse>
                                            <cfset adate="">
                                            <cfset ahour="">
                                            <cfset aminute="">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='41673.Başvuru Tarihini Girmelisiniz'>!</cfsavecontent>
                                            <cfinput type="text" name="apply_date" id="apply_date" value="" validate="#validate_style#" message="#message#">
                                        </cfif>
                                        <cfif get_module_user(47)>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="apply_date"></span>
                                        </cfif>
                                    </div>
                                </div>
                                <cfoutput>
                                    <div class="col col-2 col-xs-4">
                                        <cf_wrkTimeFormat name="apply_hour" value="#ahour#">
                                    </div>
                                    <div class="col col-2 col-xs-4">
                                        <select name="apply_minute" id="apply_minute"> <!--- her dakika muhim oldugu icin ozellikle 5dk kontrolu kaldirildi --->
                                            <cfloop from="0" to="59" index="app_min">
                                                <option value="#NumberFormat(app_min,00)#" <cfif aminute eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
                                            </cfloop>
                                        </select> 					
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="form-group" id="item-start_date1">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41672.Kabul Tarihi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41672.Kabul Tarihi'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='41784.Kabul Tarihi Hatalı'></cfsavecontent>
                                        <cfif len(get_service_detail.start_date)>
                                            <cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
                                            <cfset shour=datepart("H",sdate)>
                                            <cfset sminute=datepart("N",sdate)>
                                            <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(sdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <cfelse>
                                            <cfset sdate="">
                                            <cfset shour="">
                                            <cfset sminute="">
                                            <cfinput type="text" name="start_date1" id="start_date1" value="" validate="#validate_style#" message="#message#">
                                        </cfif>
                                        <cfif get_module_user(47)>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date1"></span>
                                        </cfif>
                                    </div>
                                </div>
                                <cfoutput>
                                    <div class="col col-2 col-xs-4">
                                        <cf_wrkTimeFormat name="start_hour" value="#shour#">
                                    </div>
                                    <div class="col col-2 col-xs-4">
                                        <select name="start_minute" id="start_minute">
                                            <cfloop from="0" to="59" index="sta_min">
                                                <option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
                                            </cfloop>
                                        </select>					
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="form-group" id="item-intervention_date">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41706.Müdahale Tarihi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41706.Müdahale Tarihi'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_service_detail.intervention_date)>
                                            <cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.intervention_date)>
                                            <cfset shour=datepart("H",sdate)>
                                            <cfset sminute=datepart("N",sdate)>
                                            <cfinput type="text" name="intervention_date" id="intervention_date" value="#dateformat(sdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <cfelse>
                                            <cfset sdate="">
                                            <cfset shour="">
                                            <cfset sminute="">
                                            <cfinput type="text" name="intervention_date" id="intervention_date" value="" validate="#validate_style#" message="#message#">
                                        </cfif>
                                        <cfif get_module_user(47)><span class="input-group-addon"><cf_wrk_date_image date_field="intervention_date"></span></cfif>
                                    </div>
                                </div>
                                <cfoutput>
                                    <div class="col col-2 col-xs-4">
                                        <cf_wrkTimeFormat name="intervention_start_hour" value="#shour#">
                                    </div>
                                    <div class="col col-2 col-xs-4">
                                        <select name="intervention_start_minute" id="intervention_start_minute">
                                            <cfloop from="0" to="59" index="sta_min">
                                                <option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
                                            </cfloop>
                                        </select> 					
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="form-group" id="item-finish_date1">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_service_detail.finish_date)>
                                            <cfset fdate=date_add("h",session.ep.TIME_ZONE,get_service_detail.FINISH_DATE)>
                                            <cfset fhour=datepart("h",fdate)>
                                            <cfset fminute=datepart("N",fdate)>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739. Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finish_date1" value="#dateformat(fdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <cfelse>
                                            <cfset fdate="">
                                            <cfset fhour="">
                                            <cfset fminute="">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739. Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finish_date1" value="" validate="#validate_style#" message="#message#">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date1"></span>
                                    </div>
                                </div>
                                <cfoutput>
                                    <div class="col col-2 col-xs-4">
                                        <cf_wrkTimeFormat name="finish_hour" value="#fhour#">
                                    </div>
                                    <div class="col col-2 col-xs-4">
                                        <select name="finish_minute" id="finish_minute">
                                            <cfloop from="0" to="59" index="fin_min">
                                                <option value="#NumberFormat(fin_min,00)#" <cfif fminute eq fin_min> selected</cfif>>#NumberFormat(fin_min,00)#</option>
                                            </cfloop>
                                        </select> 					
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="form-group" id="item-task_person_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57569.Görevli'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="task_emp_id" id="task_emp_id" value="<cfoutput>#get_service_detail.service_employee_id#</cfoutput>">
                                        <cfif len(get_service_detail.service_employee_id) and get_service_detail.service_employee_id neq 0>
                                            <cfset person="#get_emp_info(get_service_detail.service_employee_id,0,0)#">
                                        <cfelse>
                                            <cfset person="">
                                        </cfif>   
                                        <cfinput type="text" name="task_person_name" id="task_person_name" value="#person#" onfocus="AutoComplete_Create('task_person_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','task_emp_id','','3','125');" autocomplete="on">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_service.task_emp_id&field_name=upd_service.task_person_name&select_list=1');"></span>                                        
                                    </div>
                                </div>
                            </div>
                            <cfif len(get_service_detail.dead_line_response)>
                                <div class="form-group" id="item-kontrol">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41716.Müdahale Süresi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41716.Müdahale Süresi'></cfsavecontent>
                                        <input id="kontrol" name="kontrol" type="text" value="<cfoutput>#dateformat(date_add('h',session.ep.time_zone,get_service_detail.dead_line_response),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_service_detail.dead_line_response),timeformat_style)#)</cfoutput>" readonly="readonly">
                                    </div>
                                </div>
                            </cfif>
                            <cfif len(get_service_detail.dead_line)>
                                <div class="form-group" id="item-kontrol2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41721.Çözüm Süresi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41721.Çözüm Süresi'></cfsavecontent>
                                        <input id="kontrol2" name="kontrol2" type="text" value="<cfoutput>#dateformat(date_add('h',session.ep.time_zone,get_service_detail.dead_line),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_service_detail.dead_line),timeformat_style)#)</cfoutput>" readonly="readonly">
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-service_branch_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="service_branch_id" id="service_branch_id">
                                        <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                        <cfoutput query="GET_BRANCH">
                                            <option value="#branch_id#" <cfif get_service_detail.service_branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-loc_branch_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='30031.Lokasyon'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30031.Lokasyon'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkdepartmentlocation 
                                        returninputvalue="location_id,department,department_id,branch_id"
                                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldname="department"
                                        fieldid="location_id"
                                        department_fldid="department_id"
                                        branch_fldid="branch_id"
                                        department_id="#get_service_detail.department_id#"
                                        location_id="#get_service_detail.location_id#"
                                        user_location="0"
                                        width="167">
                                </div>
                            </div>
                            <div class="form-group" id="item-related_company">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41664.İş Ortağı'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41664.İş Ortağı'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#get_service_detail.related_company_id#</cfoutput>">
                                        <input type="text" name="related_company" id="related_company" value="<cfif len(get_service_detail.related_company_id)><cfoutput>#get_par_info(get_service_detail.related_company_id,1,1,0)#</cfoutput></cfif>"onfocus="AutoComplete_Create('related_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','related_company_id','','3','150');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_service.related_company_id&field_comp_name=upd_service.related_company&select_list=2');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                            <div class="form-group" id="item-guaranty_start_date">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41912.Garanti Tarihi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41912.Garanti Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='41963.Geçerli Garanti Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfif len(get_service_detail.guaranty_start_date)>
                                            <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" validate="#validate_style#" message="#alert#" value="#dateformat(get_service_detail.guaranty_start_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" validate="#validate_style#" message="#alert#" value="">
                                        </cfif>                                    
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="guaranty_start_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41813.Getiren'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41813.Getiren'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="bring_name" id="bring_name" value="#get_service_detail.bring_name#" maxlength="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_ship_method_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="<cfoutput>#get_service_detail.bring_ship_method_id#</cfoutput>">
                                        <cfif len(get_service_detail.BRING_SHIP_METHOD_ID)>
                                            <cfset attributes.ship_method_id=get_service_detail.BRING_SHIP_METHOD_ID>
                                            <cfinclude template="../query/get_ship_method.cfm">
                                        </cfif>
                                        <input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="<cfif len(get_service_detail.BRING_SHIP_METHOD_ID)><cfoutput>#SHIP_METHOD.ship_method#</cfoutput></cfif>" onfocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=bring_ship_method_name&field_id=bring_ship_method_id');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-applicator_comp_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58607.Firma'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="applicator_comp_name" id="applicator_comp_name" value="#get_service_detail.applicator_comp_name#" maxlength="150">
                                        <cfset str_linke_ait="field_name=upd_service.bring_name&field_comp_name=upd_service.applicator_comp_name&field_tel=upd_service.bring_tel_no&field_mobile_tel=upd_service.bring_mobile_no&field_address=upd_service.service_address&field_city_id=upd_service.service_city_id&field_county_id=upd_service.service_county_id&field_county=upd_service.service_county_name"><!--- &field_long_address --->
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7,8&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_service.applicator_comp_name.value)</cfoutput>);" title="<cf_get_lang dictionary_id='41917.Basvuru Yapan Seç'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_tel_no">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="bring_tel_no" id="bring_tel_no" value="#get_service_detail.bring_tel_no#" maxlength="15" onKeyUp="isNumber(this);">
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_mobile_no">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58813.Cep Telefonu'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58813.Cep Telefonu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="bring_mobile_no" id="bring_mobile_no" value="#get_service_detail.bring_mobile_no#" maxlength="15" onKeyUp="isNumber(this);">
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_email">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57428.E-Mail'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-Mail'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="bring_email" id="bring_email" value="#get_service_detail.bring_email#" maxlength="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-service_address">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41729.Servis Adresi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41729.Servis Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <textarea name="service_address" id="service_address" style="width:140px;height:65px;"><cfoutput>#get_service_detail.service_address#</cfoutput></textarea>
                                        <span  class="input-group-addon icon-ellipsis btnPointer" onClick="add_adress('1');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-service_city_id">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58608.İl'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="service_city_id" id="service_city_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_city">
                                            <option value="#city_id#" <cfif city_id eq get_service_detail.service_city_id>selected</cfif>>#city_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-service_county_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58638.İlçe'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41729.Servis Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_service_detail.service_county_id)>
                                            <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_county_id#">
                                            </cfquery>
                                            <cfset county_ = get_county.COUNTY_NAME>
                                        <cfelse>
                                            <cfset county_ = "">
                                        </cfif>
                                        <input type="hidden" name="service_county_id" id="service_county_id" value="<cfoutput>#get_service_detail.service_county_id#</cfoutput>">
                                        <input type="text" name="service_county_name" id="service_county_name" value="<cfoutput>#county_#</cfoutput>">
                                        <span  class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac();" title="<cf_get_lang dictionary_id ='57734.Seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-doc_no">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41821.Kabul Belge No'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41821.Kabul Belge No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="doc_no" id="doc_no" value="#get_service_detail.doc_no#" maxlength="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-doc_no">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58934.Arıza Kodu'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58934.Arıza Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                    name="failure_code"
                                    option_name="service_code"
                                    option_value="service_code_id"
                                    table_name="SETUP_SERVICE_CODE"
                                    data_source="#dsn3#"
                                    value="iif(#len(our_get_service_using_code)#,#our_get_service_using_code#,DE(''))"
                                    width="200">
                                    <input type="hidden" name="our_get_service_using_code" id="our_get_service_using_code" value="<cfoutput>#our_get_service_using_code#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-service_county">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41737.Teslim Alacak'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41737.Teslim Alacak'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput name="service_county" id="service_county" value="#get_service_detail.service_county#" maxlength="100">
                                </div>
                            </div>
                            <div class="form-group" id="item-service_city">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41822.Teslim Belge No'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41822.Teslim Belge No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput  name="service_city" value="#get_service_detail.service_city#">
                                </div>
                            </div>
                            <div class="form-group" id="item-bring_detail">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='41807.Teslim Adresi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41807.Teslim Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <textarea name="bring_detail" id="bring_detail"><cfoutput>#get_service_detail.bring_detail#</cfoutput></textarea>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="add_adress('2');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method_name">
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_service_detail.ship_method#</cfoutput>">
                                        <cfif len(get_service_detail.ship_method)>
                                            <cfset attributes.ship_method_id=get_service_detail.ship_method>
                                            <cfinclude template="../query/get_ship_method.cfm">
                                        </cfif>
                                        <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_service_detail.ship_method)><cfoutput>#ship_method.ship_method#</cfoutput></cfif>"  onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','125');">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
                                    </div>
                                </div>
                            </div>
                            </cfif>
                        </div>
                        <div class="row" id="seri2" style="display:none;">
                            <cfif len(get_service_detail.stock_id) and len(get_service_detail.service_product_id)>
                                <cfquery name="GET_PRO_REPAIR" datasource="#DSN3#">
                                    SELECT IS_REPAIR FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_product_id#">
                                </cfquery>
                                <cfif (get_pro_repair.recordcount) and (get_pro_repair.is_repair eq 1) and len(get_service_detail.service_product_id)>
                                    <cf_get_lang dictionary_id='41809.Bu ürün tamir edilebilir'>
                                    <input type="checkbox" name="paid_repair" id="paid_repair" value="1" 
                                    <cfif isdefined("get_service_detail.paid_repair") and get_service_detail.paid_repair eq 1>checked</cfif>>
                                        <cf_get_lang dictionary_id='41811.Fatura Kesilecek'>
                                    <cfelseif (get_pro_repair.recordcount) and (get_pro_repair.is_repair eq 0) and len(get_service_detail.service_product_id)>
                                    <cf_get_lang dictionary_id='41810.Bu ürün tamir edilmez'>
                                </cfif>
                            </cfif>
                        </div>
                    </cf_box_elements>           
                    <cf_box_footer>
                        <div class="col col-6 col-xs-12">
                            <cf_record_info query_name="get_service_detail" record_emp="record_member" update_emp="update_member" is_partner="1">
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete='1' 
                                add_function='chk_form()' 
                                data_action = '/V16/service/cfc/ServiceAction:upd_service'
                                next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&service_id=#attributes.service_id#'
                                del_action= '/V16/service/cfc/ServiceAction:del_service:service_id=#attributes.service_id#&service_head=#get_service_detail.service_head# - #get_service_detail.service_no#'
                                del_next_page = '#request.self#?fuseaction=#attributes.fuseaction#'
                                <!--- delete_page_url='#request.self#?fuseaction=service.emptypopup_del_service&service_id=#attributes.service_id#&service_head=#get_service_detail.service_head#  -  #get_service_detail.service_no#' --->>
                        </div>
                    </cf_box_footer>
                    </cfform>
            </cf_box>
            <cfif get_module_user(47)>
                <cfif x_dsp_service_plus>
                    <cfset adres_ = "#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.id#&header=upd_service.service_head&contact_person=#get_service_detail.applicator_name#">
                    <cfif len(get_service_detail.service_consumer_id)>
                        <cfset adres_ = adres_ & "&consumer_id=#get_service_detail.service_consumer_id#">
                    <cfelseif len(get_service_detail.service_partner_id)>
                        <cfset adres_ = adres_ & "&partner_id=#get_service_detail.service_partner_id#">
                    </cfif>
                    <cfset adres_ = adres_ & "&pursuit_type=is_service_application">
                    <cfsavecontent variable="text"><cf_get_lang dictionary_id='41736.Takipler'></cfsavecontent>
                    <cf_box add_href="#adres_#" add_href_size="medium" 
                        closable="0"
                        id="plus_service"
                        box_page="#request.self#?fuseaction=service.dsp_service_plus&id=#id#&service_id=#service_id#"
                        title="#text#">
                    </cf_box>
                    <!---<cfinclude template="dsp_service_plus.cfm">--->
                </cfif>
            </cfif>
            <cfif get_module_user(14)>
                <cfinclude template="../query/get_service_detail.cfm">
                <cfsavecontent variable="text"><cf_get_lang dictionary_id='41670.Üyeye Ait Diğer Servis Başvuruları'></cfsavecontent>
                <cfif is_other_customer_services eq 1>
                    <cfset serviceAction = createObject("component","V16.service.cfc.ServiceAction")>
                    <cfset GET_SERVICE = serviceAction.list_service_search(   
                        partner_id : '#IIf(IsDefined("attributes.partner_id") and len(attributes.partner_id),"attributes.partner_id",DE(""))#',
                        consumer_id : '#IIf(IsDefined("attributes.consumer_id") and len(attributes.consumer_id),"attributes.consumer_id",DE(""))#',       
                        service_id : '#IIf(IsDefined("attributes.service_id") and len(attributes.service_id),"attributes.service_id",DE(""))#'                  
                    )>
                    <cf_box title="#getLang('','Üyeye Ait Diğer Servis Başvuruları','41670')#">
                        <cf_grid_list>
                            <thead id="servis_listesi">
                                <tr>
                                    <th><cf_get_lang dictionary_id='57487.No'></th>
                                    <th><cf_get_lang dictionary_id='41821.Kabul Belge No'></th>
                                    <th><cf_get_lang dictionary_id='29502.Sistem No'></th>
                                    <th><cf_get_lang dictionary_id='29514.Başvuru Sahibi'></th>
                                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                                    <th><cf_get_lang dictionary_id='58973.Alt Aşama'></th>
                                    <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                                    <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                                    </cfif>
                                    <th><cf_get_lang dictionary_id='58608.İl'></th>
                                    <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                                    <th><cf_get_lang dictionary_id='57482.Aşama'></th> 
                                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                                    <th title="<cf_get_lang dictionary_id='57700.Bitiş Tarihi'> - <cf_get_lang dictionary_id='49293.Kabul Tarihi'>" style="text-align:left;"><cf_get_lang dictionary_id='41684.Bitiş Süresi (Saat)'></th>
                                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                                    <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
                                    <!-- sil -->
                                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_service&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                    <!-- sil -->    
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif get_service.recordcount>
                                <cfoutput query="get_service">
                                        <tr>
                                            <td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#&service_no=#get_service.service_no#" class="tableyazi">#get_service.service_no#</a></td>
                                            <td>#get_service.doc_no#</td>
                                                <td><cfif len(subscription_id)>#subscription_no#</cfif></td> 
                                            <td>
                                              <!---   <cfif len(applicator_comp_name)>
                                                    <cfif len(service_company_id) and (service_company_id neq 0)>
                                                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#service_company_id#','medium');" class="tableyazi">#applicator_comp_name#</a> -
                                                    <cfelse>
                                                        #applicator_comp_name# - 
                                                    </cfif>
                                                </cfif> --->
                                                <cfif len(service_consumer_id) and (service_consumer_id neq 0)>
                                                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#service_consumer_id#','medium');" class="tableyazi">#get_cons_info(service_consumer_id,1,1,0)#</a>
                                                <cfelseif len(service_partner_id) and (service_partner_id neq 0)>
                                                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#service_partner_id#','medium');" class="tableyazi">#get_par_info(service_partner_id,0,1,0)#</a>
                                                <cfelseif len(service_employee_id) and (service_employee_id neq 0)>
                                                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#service_employee_id#','medium');" class="tableyazi">#applicator_name#</a>
                                                <cfelse>
                                                    #applicator_name#
                                                </cfif>
                                            </td>
                                            <td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi"> #service_head#</a></td>
                                            <td>#servicecat#<cfif len(service_substatus_id)>#SERVICE_SUBSTATUS#</cfif></td>
                                            <td><cfif len(service_substatus_id)>#SERVICE_SUBSTATUS#</cfif></td>
                                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product&pid=#get_service.service_product_id#','medium');" class="tableyazi">#get_service.product_name#</a></td>
                                            <td>#pro_serial_no#</td>
                                            </cfif> 
                                            <td><cfif len(service_city_id)>#city_name#</cfif></td>
                                            <td><cfif len(service_county_id)>#county_name#</cfif></td>
                                            <td><cfif len(service_branch_id)>#branch_name#</cfif></td>
                                            <td><font color="#color#">#stage#</font></td>
                                            <td>
                                                <cfif len(record_member)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_member#','medium');" class="tableyazi"> 
                                                    #employee_name# #employee_surname#</a> 
                                                </cfif>
                                            
                                                <cfif len(record_par)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#record_par#','medium');" class="tableyazi"> 
                                                    #company_partner_name# #company_partner_surname#</a> 
                                                </cfif>
                                            </td>
                                                <td style="text-align:center;">
                                                    <cfif len(get_service.start_date) and get_service.start_date lt get_service.finish_date>
                                                        <cfset startdate=date_add("H",session.ep.time_zone,get_service.start_date)>
                                                        <cfif len(get_service.finish_date)>
                                                            <cfset finishdate=date_add("H",session.ep.time_zone,get_service.finish_date)>
                                                            <cfif len(startdate) and len(finishdate)>
                                                                <cfset saat=DATEDIFF('h',startdate,finishdate)>
                                                                <cfset minute_=DATEDIFF('N',startdate,finishdate) mod 60>
                                                                <cfset saat_ = minute_ / 60>
                                                                <cfset toplam_saat = saat + saat_>
                                                            </cfif>
                                                            <cfif len(startdate) and len(finishdate)>#tlformat(toplam_saat)#</cfif>
                                                        </cfif>
                                                    <cfelse>
                                                        -
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <cfif isdefined("get_service.project_id") and len(get_service.project_id)>
                                                        <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a></td>
                                                    <cfelse>
                                                        <cf_get_lang dictionary_id='58459.projesiz'>
                                                    </cfif>
                                                </td>
                                            <td>
                                                <cfif Len(apply_date)>
                                                    <cfset adate=date_add("H",session.ep.time_zone,apply_date)>
                                                    <cfset ahour=datepart("H",adate)>
                                                    <cfset aminute=datepart("N",adate)>
                                                    #dateformat(adate,dateformat_style)#
                                                    #timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#
                                                </cfif>
                                            </td>
                                            <cfset COL=COLOR>
                                            <!-- sil -->
                                            <td style="text-align:center">
                                                <a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                            </td>
                                            <!-- sil -->
                                        </tr>
                                    </cfoutput>
                                <cfelse>
                                    <cfset colspan = 22>
                                    <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                        <cfset colspan = colspan + 1>
                                    </cfif>
                                    <tr>
                                        <td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </cf_grid_list>
                    </cf_box>




                    <!--- 
                    <cfset box_page="">
                    <cfinclude template="../query/get_service_detail.cfm">
                    <cfset str_link = "&form_submitted=1&made_application=#get_service_detail.applicator_name#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#">
                    <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
						<cfset box_page = "#request.self#?fuseaction=service.list_service&employee_id=#attributes.employee_id##str_link#">
					<cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
						<cfset box_page ="#request.self#?fuseaction=service.list_service&partner_id=#attributes.partner_id##str_link#">
					<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
						<cfset box_page ="#request.self#?fuseaction=service.list_service&consumer_id=#attributes.consumer_id##str_link#">
					</cfif>
                    <cfsavecontent variable="text"><cf_get_lang dictionary_id='41670.Üyeye Ait Diğer Servis Başvuruları'></cfsavecontent>
                    <cf_box 
                        closable="0"
                        id="service_oper"
                        box_page="#box_page#"
                        title="#text#">
                    </cf_box> --->
                </cfif>
            </cfif>
            <cfif get_module_user(14)>
                <cfif x_service_operation>
                    <cfif len(get_service_detail.service_partner_id)>
                        <cfset member_id=get_service_detail.service_partner_id>
                    <cfelseif len(get_service_detail.service_company_id)>
                        <cfset member_id=get_service_detail.service_company_id>
                    <cfelseif len(get_service_detail.service_consumer_id)>
                        <cfset member_id=get_service_detail.service_consumer_id>
                    <cfelseif len(get_service_detail.service_employee_id)>
                        <cfset member_id=get_service_detail.service_employee_id>
                    <cfelse>
                        <cfset member_id="">                
                    </cfif>
                    <cfsavecontent variable="text"><cf_get_lang dictionary_id='41680.Ürün Servis İşlemleri'></cfsavecontent>
                    <cf_box 
                        closable="0"
                        id="service_trans"
                        box_page="#request.self#?fuseaction=service.list_service_operation_transact&employee_id=#attributes.employee_id#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#&company_id=#attributes.company_id#&member_id=#member_id#"
                        title="#text#">
                    </cf_box>
                </cfif>	
            </cfif>
            <cfif get_module_user(14)>
                <cfif x_emp_based_time_cost>
                    <cfsavecontent variable="text"><cf_get_lang dictionary_id='41731.Çalışan Bazında Zaman Harcamaları'></cfsavecontent>
                    <cf_box 
                        closable="0"
                        id="service_time_cost"
                        box_page="#request.self#?fuseaction=service.list_service_time_cost&employee_id=#attributes.employee_id#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#"
                        title="#text#">
                    </cf_box>
                </cfif>
            </cfif>
            <cfif get_module_user(14)>
                <cfif x_subscription_products and session.ep.our_company_info.subscription_contract eq 1 and (isdefined("attributes.subscription_id") and len(attributes.subscription_id) or len(get_service_detail.SUBSCRIPTION_ID))>
                    <!---Sistem Ürün Planı --->
                    <!---<cfinclude template="../display/list_subscription_products.cfm">--->
                    <cfsavecontent variable="text"><cf_get_lang dictionary_id='41918.Sistem Ürün Plani'></cfsavecontent>
                    <cf_box 
                        title="#text#" 
                        id="system_plan_" 
                        closable="0"
                        box_page="#request.self#?fuseaction=service.list_subscription_products&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#">
                    </cf_box>                
                </cfif>
            </cfif>
            <cfif get_module_user(1)>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
                <cf_box 
                    closable="0"
                    id="main_news_menu"
                    box_page="#request.self#?fuseaction=objects.emptypopup_ajax_project_works&service_id=#attributes.service_id#"
                    title="#message#">
                </cf_box>
            </cfif>
        </div>
        <div class="col col-3 col-sm-12 col-xs-12">
            <!--- Yan kısım--->
            <cfinclude template="upd_service_sag.cfm">
        </div>
    </div>
<script type="text/javascript">

    $(window).load(function(){
        <cfif get_service_detail.accessory neq 1>$('#accessory_detail').attr('readonly', true);</cfif>
        <cfif get_service_detail.accessory neq 1>$('#accessory_detail_select').prop('disabled', true);</cfif>
        <cfif get_service_detail.guaranty_inside neq 1>$('#inside_detail_select').prop('disabled', true);</cfif>
    });
    
	$('#accessory').change(function() { 
		if (this.checked) {
			$('#accessory_detail').attr('readonly', false);
            $('#accessory_detail_select').prop('disabled', false);
		} else {
			$('#accessory_detail').attr('readonly', true);
            $('#accessory_detail_select').prop('disabled', true);
		}
	});
    $('#guaranty_inside').change(function() { 
		if (this.checked) {
			$('#inside_detail_select').prop('disabled', false);
		} else {
			$('#inside_detail_select').prop('disabled', true);
		}
	});
function fill_saleszone(member_id,type)
{
	document.getElementById('sales_zone_id').value='';
	if(type == 1)
	{
		var sql = "SELECT SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id;
		get_country = wrk_query(sql,'dsn');
		if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!='undefined')
			document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
	}
	else if(type == 2)
	{
		var sql = "select SALES_COUNTY from CONSUMER WHERE CONSUMER_ID = " + member_id;
		get_country= wrk_query(sql,'dsn');
		if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!='undefined')
			document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
	}
}
function showAltKategori()	
{
	var appcat_id_ = document.getElementById('appcat_id').value;
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_id="+appcat_id_;
	AjaxPageLoad(send_address,'sub_cat_place',1,'İlişkili Kategoriler');
}

function showAltTreeKategori()	
{
	var appcat_sub_id_ = document.getElementById('appcat_sub_id').value;
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_sub_id="+appcat_sub_id_;
	AjaxPageLoad(send_address,'sub_cat_tree_place',1,'İlişkili Kategoriler');
}
function pencere_ac(no)
	{
		if (document.upd_service.service_city_id[document.upd_service.service_city_id.selectedIndex].value == "")
			alert("<cf_get_lang dictionary_id='41656.İlk Olarak İl Seçiniz'>!");
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_service.service_county_id&field_name=upd_service.service_county_name&city_id=' + document.upd_service.service_city_id.value);
	}
function product_control(){/*Ürün seçmeden spec seçemesin.*/
	if(document.getElementById('stock_id').value=="" || document.getElementById('service_product').value == "" )
	{
		alert("<cf_get_lang dictionary_id='41676.Spec Seçmek için öncelikle ürün seçmeniz gerekmektedir'>!");
		return false;
	}
	else
    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=upd_service.spec_main_id&field_name=upd_service.spect_name&is_display=1&stock_id='+document.getElementById('stock_id').value);
}
function islem_geri()
{
	document.upd_service.appcat_id.value = document.upd_service.old_appcat_id.value;
}

function islem_devam()
{
	window.location.href='<cfoutput>#request.self#?fuseaction=service.add_service<cfif len(get_service_detail.service_company_id)>&company_id=#get_service_detail.service_company_id#</cfif><cfif len(get_service_detail.service_partner_id)>&partner_id=#get_service_detail.service_partner_id#</cfif>&basvuru_yapan=#get_service_detail.applicator_name#</cfoutput>&servicecat_id='+document.upd_service.appcat_id.value;
}

function substatus()
{
	document.upd_service.service_substatus_id.value=document.upd_service.service_status_id.value;
}
function opage(deger)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_service.pro_id' + deger + '&field_name=upd_service.product' + deger,'list');
}
function serino_control()
{	
	if(document.upd_service.service_product_serial.value.length==0)
	{
		alert('Seri No Giriniz');
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=upd_service&product_serial_no='+upd_service.service_product_serial.value,'list');
	}
}
function main_serino_control()
{	
	if(document.upd_service.main_serial_no.value.length==0)
	{
		alert('Ana Seri No Giriniz');
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=upd_service&product_serial_no='+upd_service.service_product_serial.value,'list');
	}
}
function serino_search()
{
	if(document.upd_service.service_product_serial.value.length>0)
	{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=upd_service&product_serial_no='+upd_service.service_product_serial.value,'list');
	}
}	
function main_serino_search()
{
	if(document.upd_service.main_serial_no.value.length>0)
	{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&product_serial_no='+upd_service.main_serial_no.value,'list');
	}
}	

function chk_form()
{
	<cfif  isdefined("is_subscription_no") and is_subscription_no eq 2>
		if(document.getElementById('subscription_id').value=="" || document.getElementById('subscription_no').value == "")
		{
			alert("Sistem No Seçmelisiniz !");
			return false;
		}
	</cfif>
	<cfif x_is_multiple_category_select eq 1>
		if(document.upd_service.appcat_sub_id.value=="")
		{
			alert("Servis Alt Kategorisi Seçmelisiniz !");
			return false;
		}
		if(document.upd_service.appcat_sub_status_id.value=="")
		{
			alert("Servis Alt Tree Kategorisi Seçmelisiniz !");
			return false;
			}
	</cfif>
	<cfif session.ep.our_company_info.guaranty_followup eq 1>
	if ((document.upd_service.service_product_id.value != "") && (document.upd_service.is_check_product_serial_number.value == 1) && (document.upd_service.service_product_serial.value == ""))
	{
		alert("<cf_get_lang dictionary_id='41874.Ürün İçin Seri No Takibi Yapılıyor'>!<cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'> !");
		return false;
	}
	</cfif>

	if(document.upd_service.appcat_id.value=="")
	{
		alert("<cf_get_lang dictionary_id='41877.Servis Kategorisini Seçmelisiniz'>");
		return false;
	}
	
	/*if((document.upd_service.member_id.value=="" || document.upd_service.member_name.value==""))
	{
		alert("Başvuru Yapan Seçmelisiniz!");
		return false;
	}
	if((document.add_service.member_company.value=="") || (document.add_service.company_id.value=="") )
	{
		alert("Başvuru Yapanı Seçmelisiniz");
		return false;
	}*/
	if(document.upd_service.priority_id.value=="")
	{
		alert("<cf_get_lang dictionary_id='41878.Öncelik Kategorisini Seçmelisiniz'>");
		return false;
	}
	if(document.upd_service.commethod_id.value=="")
	{
		alert("<cf_get_lang dictionary_id='41962.Başvuru Şeklini Seçmelisiniz'>");
		return false;
	}
	
    if (document.upd_service.start_date1.value !='' && upd_service.finish_date1.value !='')
	{
		try
		{
			if (!time_check(upd_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], upd_service.finish_date1, document.getElementById("finish_hour").options[document.getElementById("finish_hour").selectedIndex], document.getElementById("finish_minute").options[document.getElementById("finish_minute").selectedIndex], "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!"))
				return false;
		}
		catch(e)
		{
			if (!time_check(upd_service.start_date1, upd_service.start_hour,  upd_service.start_minute, upd_service.finish_date1, upd_service.finish_hour, upd_service.finish_minute, "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!"))
				return false;
		}
	} 
	if(document.upd_service.start_date1.value !='' && document.upd_service.apply_date.value != '')
	{
		<cfif isdefined("x_apply_start_date") and x_apply_start_date eq 1>
			try
			{
				if (!time_check(upd_service.apply_date, document.getElementById("apply_hour").options[document.getElementById("apply_hour").selectedIndex], document.getElementById("apply_minute").options[document.getElementById("apply_minute").selectedIndex], upd_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!",1))
					return false;
			}
			catch(e)
			{
				if (!time_check(upd_service.apply_date, upd_service.apply_hour, upd_service.apply_minute, upd_service.start_date1, upd_service.start_hour, upd_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",1))
					return false;
			}		
		<cfelse>
			try
			{
				if (!time_check(upd_service.apply_date, document.getElementById("apply_hour").options[document.getElementById("apply_hour").selectedIndex], document.getElementById("apply_minute").options[document.getElementById("apply_minute").selectedIndex], upd_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!",0))
					return false;
			}
			catch(e)
			{
				if (!time_check(upd_service.apply_date, upd_service.apply_hour, upd_service.apply_minute, upd_service.start_date1, upd_service.start_hour, upd_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",0))
					return false;
			}	
		</cfif>
	}

	if(document.upd_service.other_company_id.value!="" && document.upd_service.other_company_name.value!="")
		{
		if(document.upd_service.other_company_branch_company_id.value!="" && document.upd_service.other_company_branch_id.value!="" && document.upd_service.other_company_branch_name.value!="")
			{
			if(document.upd_service.other_company_id.value != document.upd_service.other_company_branch_company_id.value)
				{
				alert("<cf_get_lang dictionary_id='41657.İlgili Bayi İle İlgili Bayi Şubesi Uyuşmuyor!'>");
				return false;
				}
			}
		}
	return process_cat_control();
}

function add_adress(type)
{
	if(!(upd_service.company_id.value=="") || !(upd_service.member_id.value==""))
	{
		if(type == 1)
			{
			str_adrlink = '&field_long_adres=upd_service.service_address';
			str_adrlink = str_adrlink+'&field_city=upd_service.service_city_id';
			str_adrlink = str_adrlink+'&field_county=upd_service.service_county_id';
			str_adrlink = str_adrlink+'&field_county_name=upd_service.service_county_name';
			<cfif is_county_related_company>
				str_adrlink = str_adrlink+'&is_county_related_company=1';
				str_adrlink = str_adrlink+'&related_company_id=upd_service.related_company_id';
				str_adrlink = str_adrlink+'&related_company=upd_service.related_company';
			</cfif>
			}
		else
			str_adrlink = '&field_long_adres=upd_service.bring_detail';
		
		if(upd_service.company_id.value!="")
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_service.company_name.value)+''+ str_adrlink);
			return true;
		}
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_service.member_name.value)+''+ str_adrlink);
			return true;
		}
	}

	else
	{
		alert("<cf_get_lang dictionary_id='41924.Müşteri Seçmelisiniz'>!");
		return false;
	}
}

function add_adress_other()
{
	if(!(upd_service.other_company_id.value==""))
	{
		str_adrlink = '&field_id=upd_service.other_company_branch_company_id';
		str_adrlink = str_adrlink + '&company_branch_id=upd_service.other_company_branch_id';
		str_adrlink = str_adrlink + '&company_branch_name=upd_service.other_company_branch_name';
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_service.other_company_name.value)+''+ str_adrlink);
	}
	else
	{
		alert("<cf_get_lang dictionary_id='41658.İlgili Bayi Seçmelisiniz'>!");
		return false;
	}
}
function get_service_defect(deger)
{
	<cfif x_product_cat>
	if(document.getElementById('service_product_cat').value)
	{
		deger = document.getElementById('service_product_cat').value;
		result = wrk_safe_query('srv_get_service_code','dsn3',0,deger);
		mylist = result.SERVICE_CODE_ID;
		$("#failure_code").val(mylist);
		$("#failure_code").multiselect("refresh");
	}
	</cfif>
}

function find_service_f()
{
	if($("#find_service_number").val().length)
	{
		var get_service = wrk_safe_query('sls_get_service','dsn3',0,$("#find_service_number").val());
		if(get_service.recordcount)
			window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=</cfoutput>'+get_service.SERVICE_ID[0];
		else
		{
			alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
			return false;
		}
	}
	else
	{
		alert("Servis no eksik !");
		return false;
	}
}

</script>
</cfif>
