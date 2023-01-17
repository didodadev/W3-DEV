
<cf_xml_page_edit fuseact="assetcare.vehicle_detail">
    <cfsetting showdebugoutput="no">
    <cfinclude template="../../assetcare/query/get_asset_state.cfm">
    <cfinclude template="../../assetcare/query/get_assetp_groups.cfm">
    <cfinclude template="../../assetcare/query/get_fuel_type.cfm">
    <cfinclude template="../../assetcare/query/get_money.cfm">
    <cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
    <cfinclude template="../../assetcare/query/get_assetp.cfm">
    
    <cfquery name="GET_RENT_CONTRACT" datasource="#dsn#">
        SELECT 
            COMPANY.COMPANY_ID,
            ASSET_CARE_CONTRACT.*,
            COMPANY.FULLNAME 
        FROM 
            ASSET_CARE_CONTRACT,
            COMPANY
        WHERE 
            ASSET_CARE_CONTRACT.ASSET_ID = #attributes.assetp_id#
            AND ASSET_CARE_CONTRACT.SUPPORT_COMPANY_ID = COMPANY.COMPANY_ID
    </cfquery>
    <cfquery name="KONTROL_" datasource="#DSN#">
        SELECT ASSET_ID FROM CARE_STATES WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.assetp_id#">
    </cfquery>
    <cfquery name="GET_USAGE_PURPOSE" datasource="#DSN#">
        SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE WHERE MOTORIZED_VEHICLE = 1 ORDER BY USAGE_PURPOSE
    </cfquery>
    <cfquery name="GET_VEHICLES" datasource="#DSN#">
        SELECT
            ASSETP_CATID,
            DEPARTMENT_ID,
            BRANCH_ID,
            DEPARTMENT_ID2,
            SUP_COMPANY_ID,
            SUP_PARTNER_ID,
            SUP_CONSUMER_ID,
            ASSETP,
            POSITION_CODE,
            STATUS,
            ASSETP_ID,
            FIRST_KM,
            SUP_COMPANY_DATE,
            PROPERTY,
            INVENTORY_NUMBER,
            PROCESS_STAGE,
            ASSETP_SUB_CATID,
            EXIT_DATE,
            BRAND_ID,
            BRAND_TYPE_ID,
            BRAND_TYPE_CAT_ID,
            MAKE_YEAR,
            PRIMARY_CODE,
            ASSETP_DETAIL,
            PHYSICAL_ASSETS_WIDTH,
            PHYSICAL_ASSETS_SIZE,
            PHYSICAL_ASSETS_HEIGHT,
            IS_SALES,
            EMPLOYEE_ID,
            ISNULL(MEMBER_TYPE_2,'employee') AS MEMBER_TYPE_2,
            POSITION_CODE2,
            RELATION_PHYSICAL_ASSET_ID,
            FIRST_KM_DATE,
            CARE_WARNING_DAY,
            OPTION_KM,
            FUEL_TYPE,
            ASSETP_STATUS,
            ASSETP_GROUP,
            USAGE_PURPOSE_ID,
            OTHER_MONEY_VALUE,
            OTHER_MONEY,
            IS_COLLECTIVE_USAGE,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM
            ASSET_P
        WHERE
            ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
    </cfquery>
    
    <cfif session.ep.userid eq 1>
       
    </cfif>
    <cfif len(get_vehicles.assetp_catid)>
        <cfquery name="GET_ASSET_SUB_CAT" datasource="#DSN#">
            SELECT ASSETP_SUB_CAT,ASSETP_SUB_CATID FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.assetp_catid#">
        </cfquery>
    <cfelse>
        <cfset get_asset_sub_cat.recordcount = 0>
    </cfif>
    <cfif len(get_vehicles.department_id)>
        <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID
            FROM
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.department_id#"> AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
    <cfif len(get_vehicles.branch_id)>
        <cfquery name="GET_BRANCHS" datasource="#DSN#">
            SELECT
                BRANCH_NAME
            FROM
                BRANCH
            WHERE
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.branch_id#">
        </cfquery>
    </cfif>
    <cfif len(get_vehicles.department_id2)>
        <cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID
            FROM
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.department_id2#"> AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
    <!--- Alinan firma bilgileri için --->
    <cfif len(get_vehicles.sup_company_id)>
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.sup_company_id#">
        </cfquery>
        <cfif len(get_vehicles.sup_partner_id)>
            <cfquery name="GET_PARTNER" datasource="#DSN#">
                SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.sup_partner_id#">
            </cfquery>
        </cfif>
    <cfelseif len(get_vehicles.sup_consumer_id)>
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
            SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.sup_consumer_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_FIRST_KM" datasource="#DSN#" maxrows="2">
        SELECT KM_START FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
    </cfquery>
    <cfquery name="GET_ASSETP_CONTROL" datasource="#DSN#">
        SELECT ASSETP, SUP_COMPANY_DATE FROM ASSET_P WHERE ASSETP = '#(get_vehicles.assetp)#' AND STATUS = 1
    </cfquery>
    
    <cfset pageHead = "#getLang('main',2459)# : #getLang('main',1656)# : #get_vehicles.assetp#  ">
    <cf_catalystHeader>
    <div class="col col-9 col-xs-12">
        <cf_box>
            <cfform name="upd_vehicle" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_info_frame">
                <cfoutput>
                    <input type="hidden" name="old_department_id" id="old_department_id" value="#get_vehicles.department_id#">
                    <input type="hidden" name="old_department_id2" id="old_department_id2" value="#get_vehicles.department_id2#">
                    <input type="hidden" name="old_position_code" id="old_position_code" value="#get_vehicles.position_code#">
                    <input type="hidden" name="old_status" id="old_status" value="#get_vehicles.status#">
                    <input type="hidden" name="assetp_id" id="assetp_id" value="#get_vehicles.assetp_id#">
                    <input type="hidden" name="old_assetp" id="old_assetp" value="#get_vehicles.assetp#">
                    <input type="hidden" name="o_first_km" id="o_first_km" value="#get_vehicles.first_km#">
                    <input type="hidden" name="old_first_km_date" id="old_first_km_date" value="#get_vehicles.sup_company_date#">
                    <input type="hidden" name="old_property" id="old_property" value="#get_vehicles.property#">
                    <input type="hidden" name="plaka_kontrol" id="plaka_kontrol" value="0">
                    <input type="hidden" name="date_now" id="date_now" value="#dateformat(now(),dateformat_style)#">
                </cfoutput>
                <cf_box_elements>
                    <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-form_ul_property">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48014.Mülkiyet'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="property" onchange="show_hide_assetcare()">
                                    <option value="1" <cfif get_vehicles.property eq 1>selected</cfif>><cf_get_lang dictionary_id='57449.Satın Alma'></option>
                                    <option value="2" <cfif get_vehicles.property eq 2>selected</cfif>><cf_get_lang dictionary_id='48065.Kiralama'></option>
                                    <option value="3" <cfif get_vehicles.property eq 3>selected</cfif>><cf_get_lang dictionary_id='48066.Leasing'></option>
                                    <option value="4" <cfif get_vehicles.property eq 4>selected</cfif>><cf_get_lang dictionary_id='48067.Sozleşmeli'></option>
                                </select>
                            </div>						
                        </div>
                        <div class="form-group" id="item-inventory_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58878.Demirbaş No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="inventory_number" id="inventory_number" value="<cfoutput>#get_vehicles.inventory_number#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="assetp" id="assetp"  value="#get_vehicles.assetp#" maxlength="100">
                            </div>
                        </div>
                        <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfoutput>#get_vehicles.sup_company_id#</cfoutput>">
                        <div class="form-group" id="item-sup_comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47892.Alınan Şirket'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <cfif len(get_vehicles.sup_company_id) and get_vehicles.sup_company_id neq 0>
                                            <input type="text" name="sup_comp_name" id="sup_comp_name" value="#get_company.fullname#" onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','170');">
                                        <cfelseif isdefined("get_consumer.COMPANY")>
                                            <input type="text" name="sup_comp_name" id="sup_comp_name" value="#get_consumer.company#"  onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','170');">
                                        </cfif>
                                    </cfoutput>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=upd_vehicle.sup_partner_name&field_partner=upd_vehicle.sup_partner_id&field_comp_name=upd_vehicle.sup_comp_name&field_comp_id=upd_vehicle.sup_company_id&field_consumer=upd_vehicle.sup_consumer_id&select_list=2,3');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-sup_partner_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>
                                    <input type="hidden" name="sup_partner_id" id="sup_partner_id" value="#get_vehicles.sup_partner_id#">
                                    <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="#get_vehicles.sup_consumer_id#">
                                    <cfif len(get_vehicles.sup_partner_id) and isnumeric(get_vehicles.sup_partner_id)>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="#get_partner.company_partner_name# #get_partner.company_partner_surname#" readonly>
                                    <cfelseif len(get_vehicles.sup_consumer_id) and isnumeric(get_vehicles.sup_consumer_id)>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="#get_consumer.consumer_name# #get_consumer.consumer_surname#" readonly >
                                    <cfelse>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="" readonly>
                                    </cfif>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='1' select_value="#get_vehicles.process_stage#">
                            </div>
                        </div>
                        <div class="form-group" id="item-vehicle_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47973.Araç Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkassetcat width="170" Lang_main="322.Seciniz" compenent_name="GetAssetCat1" assetp_catid="#get_vehicles.assetp_catid#" onchange_action="get_assetp_sub_cat()">
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_sub_catid">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="assetp_sub_catid" id="assetp_sub_catid" >
                                    <option value=""><cf_get_lang dictionary_id="57734.Seciniz"></option>
                                    <cfif get_asset_sub_cat.recordcount>
                                        <cfoutput query="get_asset_sub_cat">
                                            <option value="#assetp_sub_catid#" <cfif assetp_sub_catid eq get_vehicles.assetp_sub_catid>selected</cfif>>#assetp_sub_cat#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47893.Alış Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_vehicles.sup_company_date)>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56996.Alım Tarihi !'></cfsavecontent>
                                        <cfinput type="text" name="get_date" id="get_date" value="#dateFormat(get_vehicles.sup_company_date,dateformat_style)#" required="yes" message="#message#">
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56996.Alım Tarihi !'></cfsavecontent>
                                        <cfinput type="text" name="get_date" id="get_date" value="" required="yes" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="get_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_exit_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_vehicles.exit_date)>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='48018.Çıkış Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="get_exit_date" id="get_exit_date" value="#dateFormat(get_vehicles.exit_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                    <cfelse>
                                        <cfinput type="text" name="get_exit_date" id="get_exit_date"  value="" validate="#validate_style#" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="get_exit_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-brand_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#get_vehicles.brand_id#</cfoutput>">
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#get_vehicles.brand_type_id#</cfoutput>">
                                <cf_wrkbrandtypecat
                                    brand_type_cat_id="#get_vehicles.brand_type_cat_id#"
                                    width="170"
                                    compenent_name="getBrandTypeCat2"
                                    brand_type_cat_name="1"
                                    boxwidth="240"
                                    boxheight="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-make_year">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="make_year" id="make_year" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
                                    <cfset model_yili = get_vehicles.make_year>
                                    <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <option value="#i#" <cfif model_yili eq i>selected</cfif>>#i#</option>
                                    </cfloop>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-ozel_kod">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ozel_kod" id="ozel_kod" value="#get_vehicles.primary_code#">
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="assetp_detail" id="assetp_detail"><cfoutput>#get_vehicles.assetp_detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-size">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58831.Boyutlar'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 col-xs-4">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="text" name="asset_vehicle_width" id="asset_vehicle_width" value="<cfoutput>#get_vehicles.physical_assets_width#</cfoutput>" onkeyup="isNumber(this);">
                                            <span class="input-group-addon no-bg">a</span>
                                        </cfoutput>
                                    </div>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="text" name="asset_vehicle_size" id="asset_vehicle_size" value="<cfoutput>#get_vehicles.physical_assets_size#</cfoutput>"  onkeyup="isNumber(this);">
                                            <span class="input-group-addon no-bg">b</span>
                                        </cfoutput>
                                    </div>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="text" name="asset_vehicle_height" id="asset_vehicle_height" value="<cfoutput>#get_vehicles.physical_assets_height#</cfoutput>" onkeyup="isNumber(this);">
                                            <span class="input-group-addon no-bg">h</span>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="status" id="status" value="1" <cfif len(get_vehicles.status) and get_vehicles.status eq 1>checked</cfif>><cfif len(get_vehicles.is_sales) and get_vehicles.is_sales eq 1><font color="red"><cf_get_lang dictionary_id='48409.Satışı Yapıldı'></font></cfif>
                            </div>
                        </div>
                        <cfif not len(get_vehicles.employee_id)>
                            <cfquery name="get_emp_id" datasource="#dsn#">
                                SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_vehicles.position_code# 
                            </cfquery>
                            <cfset get_vehicles.employee_id = get_emp_id.EMPLOYEE_ID />
                        </cfif>
                        <div class="form-group" id="item-employee_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                    <input type="hidden" name="position_code" id="position_code" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.position_code#</cfif>" />
                                    <input type="hidden" name="emp_id" id="emp_id" value="#get_vehicles.employee_id#" />
                                    <input type="text" name="employee_name" id="employee_name" value="<cfif len(get_vehicles.employee_id)><cfoutput>#get_emp_info(get_vehicles.employee_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');" />
                                    <cfif x_fill_department eq 1>
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_vehicle.position_code&field_name=upd_vehicle.employee_name&field_emp_id=upd_vehicle.emp_id&field_branch_id=upd_vehicle.branch_id&field_branch_name=upd_vehicle.branch_name&field_dep_id=upd_vehicle.department_id&field_dep_name=upd_vehicle.department</cfoutput>&select_list=1')"></span>
                                    <cfelse>
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_vehicle.position_code&field_name=upd_vehicle.employee_name&field_emp_id=upd_vehicle.emp_id</cfoutput>&select_list=1')"></span>
                                    </cfif>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-position_name2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>2</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">        
                                    <cfoutput>
                                        <input type="hidden" name="member_type_2" id="member_type_2" value="#get_vehicles.member_type_2#">
                                        <input type="hidden" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.position_code2#</cfif>">
                                        <input type="text" name="position_name2" id="position_name2" readonly="readonly" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_vehicles.member_type_2) and get_vehicles.member_type_2 eq 'employee'>#get_emp_info(get_vehicles.position_code2,1,0)#<cfelseif len(get_vehicles.member_type_2) and get_vehicles.member_type_2 eq 'partner'>#get_par_info(get_vehicles.position_code2,0,0,0)#<cfelseif get_vehicles.member_type_2 eq 'consumer'>#get_cons_info(get_vehicles.position_code2,0,0)#</cfif></cfif>"  autocomplete="off" />
                                        <span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_vehicle.position_code2&field_name=upd_vehicle.position_name2&field_emp_id=upd_vehicle.position_code2&field_partner=upd_vehicle.position_code2&field_consumer=upd_vehicle.position_code2&field_type=upd_vehicle.member_type_2&select_list=1,7,8&branch_related')"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-relation_asset">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_vehicles.relation_physical_asset_id)>
                                        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.relation_physical_asset_id#">
                                        </cfquery>
                                        <cfset relation_phy_asset_id = get_asset_name.assetp_id>
                                        <cfset relation_phy_asset = get_asset_name.assetp>
                                    <cfelse>
                                        <cfset relation_phy_asset_id = ''>
                                        <cfset relation_phy_asset = ''>
                                    </cfif>
                                    <cfinput type="hidden" name="relation_asset_id" id="relation_asset_id" value="#relation_phy_asset_id#">
                                    <cfinput type="text" name="relation_asset" id="relation_asset" value="#relation_phy_asset#"  onFocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','170');">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=upd_vehicle.relation_asset_id&field_name=upd_vehicle.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                                    <cfif len(get_vehicles.relation_physical_asset_id)><span class="input-group-addon" target="_blank" href="<cfoutput>#request.self#?fuseaction=assetcare.upd_vehicle_info&assetp_id=#relation_phy_asset_id#</cfoutput>"><img src="../images/update_list.gif" /></span></cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-department2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48016.Kullanıcı Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id2" id="department_id2" value="<cfoutput>#get_vehicles.department_id2#</cfoutput>">
                                    <cfif len(get_vehicles.department_id2)>
                                        <cfinput type="text" name="department2" id="department2" value="#get_branchs_deps2.branch_name# - #get_branchs_deps2.department_head#" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_vehicle','3','170');">
                                    <cfelse>
                                        <cfinput type="text" name="department2" id="department2" value="" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_vehicle','3','170');">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_vehicle.department_id2&field_dep_branch_name=upd_vehicle.department2&is_get_all=1','','ui-draggable-box-small');"></span><!--- BK gecici olarak is_get_all parametresi eklendi. --->
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput><cfif len(get_vehicles.branch_id)>#get_vehicles.branch_id#<cfelseif isdefined('get_branchs_deps.branch_id') and len(get_branchs_deps.branch_id)>#get_branchs_deps.branch_id#</cfif></cfoutput>">
                                    <input type="text" name="branch_name" id="branch_name" value="<cfoutput><cfif isdefined('get_branchs_deps.branch_name') and len(get_branchs_deps.branch_name)>#get_branchs_deps.branch_name#</cfif></cfoutput>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_vehicle.department_id&field_name=upd_vehicle.department&branch_id=upd_vehicle.branch_id&branch_name=upd_vehicle.branch_name','','ui-draggable-box-small');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>
                                    <input type="hidden" name="department_id" id="department_id" value="#get_vehicles.department_id#">
                                    <input type="text" name="department" id="department" value="<cfif isdefined("get_branchs_deps.department_head")>#get_branchs_deps.department_head#</cfif>" readonly="yes">
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-first_km">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48089.İlk KM'></label>
                            <div class="col col-4 col-xs-6">
                                <input type="text" name="first_km" id="first_km" value="<cfoutput>#tlFormat(get_vehicles.first_km,0)#</cfoutput>" onkeyup="FormatCurrency(this,event,0);" class="moneybox" maxlength="50" <cfif get_first_km.recordCount eq 2>readonly="yes"</cfif>>
                            </div>
                            <div class="col col-4 col-xs-6">
                                <div class="input-group">
                                    <input type="text" name="km_date_first" id="km_date_first" value="<cfif len(get_vehicles.first_km_date)><cfoutput>#dateformat(get_vehicles.first_km_date,dateformat_style)#</cfoutput></cfif>" <cfif get_first_km.recordCount eq 2>readonly</cfif> >
                                    <cfif get_first_km.recordCount neq 2><span class="input-group-addon"><cf_wrk_date_image date_field="km_date_first"></span></cfif>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-care_warning_day">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48393.Bakim Uyari Gunu'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="care_warning_day" id="care_warning_day" value="#tlFormat(get_vehicles.care_warning_day,0)#" onKeyup="FormatCurrency(this,event,0);" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-option_km">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48395.Şahsi Ulaşım KM'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="option_km" id="option_km" value="<cfoutput>#tlFormat(get_vehicles.option_km,0)#</cfoutput>" maxlength="50" onkeyup="FormatCurrency(this,event,0);">
                            </div>
                        </div>
                        <div class="form-group" id="item-fuel_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30113.Yakıt Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="fuel_type" id="fuel_type">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_fuel_type">
                                        <option value="#fuel_id#" <cfif get_vehicles.fuel_type eq fuel_id>selected</cfif>>#fuel_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="assetp_status" id="assetp_status" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_asset_state">
                                        <option value="#asset_state_id#" <cfif len(get_vehicles.assetp_status) and (get_vehicles.assetp_status eq asset_state_id)>selected</cfif>>#asset_state#
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-new_assetp_group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'><cfif isdefined("attributes.x_assetp_group_required") and len(x_assetp_group_required) eq 1>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <select name="new_assetp_group" id="new_assetp_group" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_assetp_groups">
                                        <option value="#group_id#" <cfif get_vehicles.assetp_group eq group_id>selected</cfif>>#group_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <cfif len(get_vehicles.position_code)>
                            <cfquery name="GET_POSITON_CAT" datasource="#DSN#">
                                SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = (SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.position_code#">)
                            </cfquery>
                        <cfelse>
                            <cfset get_positon_cat.recordcount = 0>
                        </cfif>    
                        <div class="form-group" id="item-position_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_vehicles.position_code)>
                                    <cfinput type="text" name="position_cat" id="position_cat" value="#get_positon_cat.position_cat#" readonly="yes">
                                <cfelse>
                                    <cfinput type="text" name="position_cat" id="position_cat" value="" readonly="yes">                            
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-new_usage_purpose_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47901.Kullanım Amacı'><cfif isdefined("attributes.x_usage_purpose_required") and len(x_usage_purpose_required) eq 1>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <select name="new_usage_purpose_id" id="new_usage_purpose_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_usage_purpose">
                                        <option value="#usage_purpose_id#" <cfif get_vehicles.usage_purpose_id eq usage_purpose_id>selected</cfif>>#usage_purpose#
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_other_money_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48562.Deger'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="assetp_other_money_value" id="assetp_other_money_value" value="<cfoutput>#tlFormat(get_vehicles.other_money_value)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" >
                                    <span class="input-group-addon width"><select name="assetp_other_money" id="assetp_other_money">
                                        <cfoutput query="get_money">
                                            <option value="#money#"<cfif money eq get_vehicles.other_money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_collective_usage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48516.Ortak Kullanım'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1"<cfif get_vehicles.is_collective_usage eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-additional_info">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_add_info info_type_id="-20" info_id="#attributes.assetp_id#" upd_page="1" colspan="9" assetp_catid="#GET_VEHICLES.ASSETP_CATID#">
                            </div>
                        </div>
                    </div>
                    <div id="kira" class="col col-6 col-xs-12" type="column" index="3" sort="true" style="display:none;">
                        <div class="form-group" id="item-header2">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='48203.Kira Bilgileri'></label>
                        </div>
                        <div class="form-group" id="item-rent_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48204.Kira Tutarı'>(<cf_get_lang dictionary_id='48656.KDV Hariç'>)</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="rent_amount" value="#TLformat(GET_ASSETP.rent_amount)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox"> 
                                    <span class="input-group-addon"><select name="rent_amount_currency" id="rent_amount_currency">
                                        <cfoutput query="get_money"> 
                                        <option value="#money#" <cfif money eq GET_ASSETP.rent_amount_currency>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-rent_payment_period">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48205.Ödeme Periyodu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="rent_payment_period" id="rent_payment_period">
                                    <option value="0"></option>
                                    <option value="1" <cfif GET_ASSETP.rent_payment_period eq 1>selected</cfif>><cf_get_lang dictionary_id='58458.Haftalık'></option>
                                    <option value="2" <cfif GET_ASSETP.rent_payment_period eq 2>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                                    <option value="3" <cfif GET_ASSETP.rent_payment_period eq 3>selected</cfif>>3 <cf_get_lang dictionary_id='58932.Aylık'></option>
                                    <option value="4" <cfif GET_ASSETP.rent_payment_period eq 4>selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-rent_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48208.Kiralama Süresi'></label>
                            <div class="col col-4 col-xs-4">
                                <div class="input-group">
                                    <cfinput type="text" name="rent_start_date" id="rent_start_date" value="#dateformat(GET_ASSETP.rent_start_date,dateformat_style)#" maxlength="10"> 
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="rent_start_date"></span>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-8">
                                <div class="input-group">
                                    <cfinput type="text" name="rent_finish_date" id="rent_finish_date" value="#dateformat(GET_ASSETP.rent_finish_date,dateformat_style)#" maxlength="10"> 
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="rent_finish_date"></span>
                                </div>				
                            </div>
                        </div>
                        <div id="masraf" style="display:none;">
                            <div class="form-group" id="item-rent_payment_period">
                                <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='48210.Masraf Bilgileri'></label>
                            </div>
                            <div class="form-group" id="item-is_fuel_added">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48216.Yakıt Masrafı'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="is_fuel_added" id="is_fuel_added" onchange="show_hide_assetcare()">
                                        <option value="0" <cfif GET_ASSETP.fuel_expense eq 0>selected</cfif>><cf_get_lang dictionary_id='48213.Hariç'></option>
                                        <option value="1" <cfif GET_ASSETP.fuel_expense eq 1>selected</cfif>><cf_get_lang dictionary_id='48214.Dahil'></option>
                                        <option value="2" <cfif GET_ASSETP.fuel_expense eq 2>selected</cfif>><cf_get_lang dictionary_id='48407.Limitsiz'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="fuel" style="display:none;">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48212.Üst Limit'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="fuel_amount" id="fuel_amount" value="<cfoutput>#TLformat(GET_ASSETP.fuel_amount)#</cfoutput>"  onKeyUP="FormatCurrency(this,event);" class="moneybox"> 
                                        <span class="input-group-addon width">
                                            <select name="fuel_amount_currency" id="fuel_amount_currency">
                                                <cfoutput query="get_money"> 
                                                    <option value="#money#"<cfif money eq GET_ASSETP.fuel_amount_currency>selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_care_added">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48215.Bakım Masrafı'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="is_care_added" id="is_care_added" onchange="show_hide_assetcare()">
                                        <option value="0" <cfif GET_ASSETP.care_expense eq 0>selected</cfif>><cf_get_lang dictionary_id='48213.Hariç'></option>
                                        <option value="1" <cfif GET_ASSETP.care_expense eq 1>selected</cfif>><cf_get_lang dictionary_id='48214.Dahil'></option>
                                        <option value="2" <cfif GET_ASSETP.care_expense eq 2>selected</cfif>><cf_get_lang dictionary_id='48407.Limitsiz'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="care" style="display:none;">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48212.Üst Limit'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="care_amount" id="care_amount" value="<cfoutput>#TLformat(GET_ASSETP.care_amount)#</cfoutput>"onKeyUp="FormatCurrency(this,event);" class="moneybox"> 
                                        <span class="input-group-addon width">
                                            <select name="care_amount_currency" id="care_amount_currency">
                                                <cfoutput query="get_money"> 
                                                    <option value="#money#" <cfif money eq GET_ASSETP.care_amount_currency>selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="sozlesme" class="col col-6 col-xs-12" type="column" index="4" sort="true" style="display:none;">            
                        <div class="form-group" id="item-header3">
                            <label class="col col-4 col-xs-12 bold"><b><cf_get_lang dictionary_id='48362.Sözleşme Bilgisi'></b></label>
                        </div>
                        <div class="form-group" id="item-contract_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_rent_contract.contract_head)>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                                    <cfinput type="text" name="contract_head" value="#get_rent_contract.contract_head#" maxlength="100" required="no" message="#message#">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                                    <cfinput type="text" name="contract_head" value="" maxlength="100" required="no" message="#message#">
                                </cfif>	
                            </div>
                        </div>
                        <div class="form-group" id="item-asset_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="asset_name" value="#get_assetp.assetp#" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_rent_contract.support_company_id)>
                                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_rent_contract.support_company_id#</cfoutput>">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57574.şirket!'></cfsavecontent>
                                        <cfinput type="text" name="support_company_id" value="#get_rent_contract.fullname#" readonly required="no" message="#message#" >
                                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=upd_vehicle.authorized_id&field_comp_name=upd_vehicle.support_company_id&field_name=upd_vehicle.support_authorized_id&field_comp_id=upd_vehicle.company_id&select_list=2,3,5,6','list');"></span>
                                    <cfelse>
                                        <input type="hidden" name="company_id" id="company_id" value="">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57574.şirket!'></cfsavecontent>
                                        <cfinput type="text" name="support_company_id" value="" required="no" message="#message#"  readonly>
                                        <span  class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=upd_vehicle.authorized_id&field_comp_name=upd_vehicle.support_company_id&field_name=upd_vehicle.support_authorized_id&field_comp_id=upd_vehicle.company_id&select_list=2,3,5,6','list');"></span>			
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-authorized_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_rent_contract.support_authorized_id)>
                                    <input type="hidden" name="authorized_id" id="authorized_id" value="<cfoutput>#get_rent_contract.support_authorized_id#</cfoutput>">
                                    <input type="text" name="support_authorized_id" id="support_authorized_id" value="<cfoutput>#get_par_info(get_rent_contract.support_authorized_id,0,-1,0)#</cfoutput>" readonly >
                                <cfelse>
                                    <input type="hidden" name="authorized_id" id="authorized_id" value="">
                                    <input type="text" name="support_authorized_id" id="support_authorized_id" value="" readonly >			
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-support_position_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48115.Sorumlu Çalışan'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_rent_contract.support_employee_id)>
                                        <input type="hidden" name="support_position_id" id="support_position_id" value="<cfoutput>#get_rent_contract.support_employee_id#</cfoutput>">
                                        <input type="text" name="support_position_name" id="support_position_name" value="<cfoutput>#get_emp_info(get_rent_contract.support_employee_id,1,0)#</cfoutput>"  readonly>
                                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_vehicle.support_position_id&field_name=upd_vehicle.support_position_name&select_list=1','list');"></span>
                                    <cfelse>
                                        <input type="hidden" name="support_position_id" id="support_position_id" value="">
                                        <input type="text" name="support_position_name" id="support_position_name" value="" readonly>
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_vehicle.support_position_id&field_name=upd_vehicle.support_position_name&select_list=1','list');"></span>				
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-support_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_rent_contract.support_start_date)>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
                                        <cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10" message="#message#" value="#dateformat(get_rent_contract.support_start_date,dateformat_style)#" >
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
                                        <cfinput type="text" name="support_start_date" id="support_start_date" validate="#validate_style#" maxlength="10" message="#message#" value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>	
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-support_finish_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_rent_contract.support_finish_date)>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi !'></cfsavecontent>
                                        <cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10" message="#message#" value="#dateformat(get_rent_contract.support_finish_date,dateformat_style)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>				
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
                                        <cfinput type="text" name="support_finish_date" id="support_finish_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>						
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_rent_contract.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_project_name(get_rent_contract.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','time_cost','3','250');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_vehicle.project_head&project_id=upd_vehicle.project_id</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <cfif len(get_rent_contract.use_certificate)>
                            <div class="form-group" id="item-add-document">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57466.Belge Ekle'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_get_server_file output_file="assetcare/#get_rent_contract.use_certificate#" output_server="#get_rent_contract.use_certificate_server_id#" output_type="2" small_image="images/asset.gif" image_link="1">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-support_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48650.Destek'>:<cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_combo
                                        name="support_cat"
                                        query_name="GET_ASSET_TAKE_SUPPORT_CAT"
                                        option_name="TAKE_SUP_CAT"
                                        option_value="TAKE_SUP_CATID"
                                        value="#get_rent_contract.support_cat_id#"
                                        width="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_rent_contract.detail)>
                                    <textarea  name="detail" id="detail"><cfoutput>#get_rent_contract.detail#</cfoutput></textarea>
                                <cfelse>
                                    <textarea  name="detail" id="detail"></textarea>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6 col-xs-12">
                        <cf_record_info query_name="get_vehicles" record_emp="record_emp" update_emp="update_emp">
                    </div>
                    <div class="col col-6">
                        <cfif not (len(get_vehicles.is_sales) and get_vehicles.is_sales)>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        </cfif>
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <div class="col col-3 col-xs-12">
        <cf_get_workcube_asset asset_cat_id="-23" module_id='40' action_section='ASSETP_ID' action_id='#attributes.assetp_id#'>
        <cfquery name="GET_1" datasource="#dsn#">
            SELECT TOP 1 KM_FINISH,ISNULL(FINISH_DATE,START_DATE) AS TARIH,KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY KM_CONTROL_ID DESC
        </cfquery>
        <cfquery name="GET_2" datasource="#dsn#">
            SELECT TOP 1 FUEL_AMOUNT,FUEL_DATE AS TARIH,FUEL_ID FROM ASSET_P_FUEL WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY FUEL_DATE DESC
        </cfquery>
        <cfquery name="GET_3" datasource="#dsn#">
            SELECT TOP 1 ACCIDENT_DETAIL,ACCIDENT_DATE AS TARIH,ACCIDENT_ID FROM ASSET_P_ACCIDENT WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY ACCIDENT_DATE DESC
        </cfquery>
        <cfquery name="GET_4" datasource="#dsn#">
            SELECT TOP 1 PUNISHMENT_DATE AS TARIH,PAID_AMOUNT,PUNISHMENT_ID FROM ASSET_P_PUNISHMENT WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY PUNISHMENT_DATE DESC
        </cfquery>
        <cfquery name="GET_5" datasource="#dsn#">
            SELECT 
                ACC.ASSET_CARE,
                API.INSURANCE_FINISH_DATE,
                API.INSURANCE_TOTAL,
                API.INSURANCE_ID 
            FROM 
                ASSET_CARE_CAT AS ACC
                LEFT JOIN ASSET_P_INSURANCE AS API ON ACC.ASSET_CARE_ID = API.INSURANCE_NAME_ID AND API.ASSETP_ID = #attributes.assetp_id#
                LEFT JOIN ASSET_P AS AP ON AP.ASSETP_ID = API.ASSETP_ID AND ACC.ASSETP_CAT = AP.ASSETP_CATID
            WHERE
                API.ASSETP_ID = #attributes.assetp_id#
        </cfquery>
        <cf_box title="#getLang('','Son İşlemler',40662)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                        <th><cf_get_lang dictionary_id='35704.Değer'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                        <tr>
                            <td>1</td>
                            <td><cf_get_lang dictionary_id='62395.Son KM Kaydı'></td>
                            <td>#TlFormat(GET_1.KM_FINISH,0)#</td>
                            <td><cfif len(GET_1.KM_FINISH)>#dateFormat(get_1.TARIH,'dd/mm/yyyy')#</cfif></td>
                            <td><cfif GET_1.recordcount and len(GET_1.KM_FINISH)><a href="#request.self#?fuseaction=assetcare.list_vehicles&assetp_id=#attributes.assetp_id#&event=upd_km&km_control_id=#GET_1.KM_CONTROL_ID#" target="_blank"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'> "></i></a></cfif></td>
                            <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=add_km&assetp_id=#attributes.assetp_id#' target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><cf_get_lang dictionary_id='64187.Son Yakıt Kaydı'></td>
                            <td>#TlFormat(GET_2.FUEL_AMOUNT)#</td>
                            <td>#dateFormat(get_2.TARIH,'dd/mm/yyyy')#</td>
                            <td><cfif GET_2.recordcount><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=upd_fuel&fuel_id=#GET_2.FUEL_ID#' target="_blank"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'> "></i></a></cfif></td>
                            <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=add_fuel&assetp_id=#attributes.assetp_id#' target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><cf_get_lang dictionary_id='64188.Son Kaza Kaydı'></td>
                            <td>#GET_3.ACCIDENT_DETAIL#</td>
                            <td>#dateFormat(get_3.TARIH,'dd/mm/yyyy')#</td>
                            <td><cfif GET_3.recordcount><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_accident_detail&accident_id=#GET_3.ACCIDENT_ID#','medium','popup_upd_accident_detail');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'> "></i></a></cfif></td>
                            <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=add_acc&assetp_id=#attributes.assetp_id#' target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td><cf_get_lang dictionary_id='64189.Son Ceza Kaydı'></td>
                            <td>#TlFormat(get_4.PAID_AMOUNT)#</td>
                            <td>#dateFormat(get_4.TARIH,'dd/mm/yyyy')#</td>
                            <td><cfif GET_4.recordcount><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_punishment_detail&punishment_id=#get_4.PUNISHMENT_ID#','medium','popup_upd_punishment_detail');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'> "></i></a></cfif></td>
                            <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=add_pun&assetp_id=#attributes.assetp_id#' target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                        </tr>
                        <cfset curr = 5>
                        <cfloop query="get_5">
                            <tr>
                                <td>#curr#</td>
                                <td>#ASSET_CARE#</td>
                                <td>#TlFormat(INSURANCE_TOTAL)#</td>
                                <td <cfif len(INSURANCE_FINISH_DATE) and dateDiff('d',INSURANCE_FINISH_DATE,now()) gt 0>style="color:red"</cfif>>#dateFormat(INSURANCE_FINISH_DATE,'dd/mm/yyyy')#</td>
                                <td><cfif GET_5.recordcount and len(INSURANCE_FINISH_DATE)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_vehicle_ins&insurance_id=#INSURANCE_ID#&assetp_id=#attributes.assetp_id#','medium','popup_upd_punishment_detail');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> " title="<cf_get_lang dictionary_id='57464.Güncelle'> "></i></a></cfif></td>
                                <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=assetcare.popup_add_vehicle_ins&assetp_id=#attributes.assetp_id#','medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                            </tr>
                            <cfset curr = curr + 1>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
    <div class="col col-9 col-xs-12">
        <cfsavecontent variable="text"><cf_get_lang dictionary_id='29682.Bakım Planı'></cfsavecontent>
        <cfif kontrol_.recordcount>
            <cfset attributes.assetp_id = get_assetp.assetp_id>
            <cf_box id="care_states_plan" title="<cfoutput>#text#</cfoutput>" closable="0" box_page="#request.self#?fuseaction=assetcare.upd_assetp_care_states&asset_id=#attributes.assetp_id#"></cf_box>
        <cfelse>
            <cfset attributes.assetp_id = get_assetp.assetp_id>
            <cf_box id="care_state_add" title="<cfoutput>#text#</cfoutput>" closable="0" unload_body="0" box_page="#request.self#?fuseaction=assetcare.add_assetp_care_states&asset_id=#attributes.assetp_id#"></cf_box>
        </cfif>
    </div>
    <script type="text/javascript">
    show_hide_assetcare();
    
    function show_hide_assetcare()
    {
        var propertyValue = document.upd_vehicle.property.value;

        if(propertyValue == 1)
        {
            gizle(masraf);
            gizle(kira);
            gizle(sozlesme);
            /* document.upd_vehicle.care_amount.value = "" ;
            document.upd_vehicle.rent_amount.value = "" ;
            document.upd_vehicle.rent_start_date.value = "" ;
            document.upd_vehicle.rent_finish_date.value = "" ;
            document.upd_vehicle.is_care_added[0].checked = true;
            document.upd_vehicle.rent_payment_period[0].selected = true; */
        }
        if(propertyValue == 2)
        {
            gizle(sozlesme);
            goster(masraf);
            goster(kira);
            //document.upd_vehicle.care_amount.value = "" ;
        }
        if(propertyValue == 3)
        {
            gizle(masraf);
            gizle(kira);
            gizle(sozlesme);
            /* document.upd_vehicle.care_amount.value = "" ;
            document.upd_vehicle.rent_amount.value = "" ;
            document.upd_vehicle.rent_start_date.value = "" ;
            document.upd_vehicle.rent_finish_date.value = "" ;
            document.upd_vehicle.is_care_added[0].checked.value = true ;
            document.upd_vehicle.rent_payment_period[0].selected = true; */
        }
        if(propertyValue == 4)
        {
            gizle(masraf);
            gizle(kira);
            goster(sozlesme);
        }
    
        var is_care_added = document.upd_vehicle.is_care_added.value;

        if(is_care_added == 0)
        {
            gizle(care);
            document.upd_vehicle.care_amount.value = "" ;
            document.upd_vehicle.care_amount_currency.selectedIndex = "";
        }
        if(is_care_added == 1)
        {
            gizle(care);
            document.upd_vehicle.care_amount.value = "" ;
            document.upd_vehicle.care_amount_currency.selectedIndex = "";
        }
        if(is_care_added == 2)
        {
            goster(care);
        }

        var is_fuel_added = document.upd_vehicle.is_fuel_added.value;

        if(is_fuel_added == 0)
        {
            gizle(fuel);
            document.upd_vehicle.fuel_amount.value = "" ;
            document.upd_vehicle.fuel_amount_currency.selectedIndex = "";
        }
        if(is_fuel_added == 1)
        {
            gizle(fuel);
            document.upd_vehicle.fuel_amount.value = "" ;
            document.upd_vehicle.fuel_amount_currency.selectedIndex = "";
        }
        if(is_fuel_added == 2)
        {
            goster(fuel);
        }
    }
    
    function unformat_fields()
    {
        document.upd_vehicle.option_km.value = filterNum(document.upd_vehicle.option_km.value);
        document.upd_vehicle.care_warning_day.value = filterNum(document.upd_vehicle.care_warning_day.value);
        document.upd_vehicle.first_km.value = filterNum(document.upd_vehicle.first_km.value);
        document.upd_vehicle.assetp_other_money_value.value = filterNum(document.upd_vehicle.assetp_other_money_value.value,0);
        if(document.upd_vehicle.rent_amount != undefined)  
        document.upd_vehicle.rent_amount.value = filterNum(document.upd_vehicle.rent_amount.value);
    }

    function kontrol()
    { 
        unformat_fields();
        if($('#assetp').val() == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29453.Plaka'>!");
            return false;
        }
        x = document.upd_vehicle.assetp_catid.selectedIndex;
        if (document.upd_vehicle.assetp_catid[x].value == "")
        {
            alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47973.Araç Tipi'> !");
            return false;
        }

        // Alis tarihinin bugunden buyuk olmasi durumunda uyari ver
        if(!date_check(document.upd_vehicle.get_date,document.upd_vehicle.date_now,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
        {
            return false;
        }

        // Alis tarihinin cikis tarihinden buyuk olmasi durumunda uyari ver
        if(document.upd_vehicle.get_exit_date.value != "")
        {
            if(!date_check(document.upd_vehicle.get_date,document.upd_vehicle.get_exit_date,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
            {
                return false;
            }
        }

        // Cikis tarihinin bugunden buyuk olmasi durumunda uyari ver
        if(!date_check(document.upd_vehicle.get_exit_date,document.upd_vehicle.date_now,"<cf_get_lang dictionary_id='48503.Çıkış Tarihini Kontrol Ediniz'>!"))
        {
            return false;
        }
        <cfif isdefined("attributes.x_first_date_km") and len(x_first_date_km) eq 1>
        
            if($('#km_date_first').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48209.İlk KM Tarihi '>!");
                return false;
            }
            else
            {
                if(!CheckEurodate(document.upd_vehicle.km_date_first.value,"<cf_get_lang dictionary_id='48209.İlk KM Tarihi'>"))
                {
                    return false;
                }
    
                if(!date_check(document.upd_vehicle.get_date,document.upd_vehicle.km_date_first,"<cf_get_lang dictionary_id='48507.İlk KM Tarihi Alış Tarihinden Küçük Olamaz'>!"))
                {
                    return false;
                }
            }
        </cfif>
        if($('#brand_name').val()== "" || $('#brand_type_id').val() == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'> !");
            return false;
        }

        // Arac aktif olmadigi sürece asagidaki kontrollere ihtiyacimiz yok!
        if(document.getElementById('status').checked == true)
        {
            if($('#department').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57572.Departman'>!");
                return false;
            }

            if($('#emp_id').val() == "" || $('#employee_name').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57544.Sorumlu !'>!");

                return false;
            }
            <cfif isdefined("attributes.x_first_km") and len(x_first_km) eq 1>
                if($('#first_km').val() == "")
                {
                    alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48089.İlk KM '>!");
                    return false;
                }
            </cfif>
            <cfif isdefined("attributes.x_first_date_km") and len(x_first_date_km) eq 1>
                if($('#km_date_first').val() == "")
                {
                    alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48209.İlk KM Tarihi'>");
                    return false;
                }
            </cfif> 
            if($('#fuel_type').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30113.Yakıt Tipi'>!");
                return false;
            }

            if($('#assetp_status').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57756.Durum '>!");
                return false;
            }
            if(document.upd_vehicle.assetp_detail.value.length > 250)
            {
                alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='48082.en fazla 250 karakter'>!");
                return false;
            }
            
            x = (200 - upd_vehicle.detail.value.length);
            if ( x < 0 )
            { 
            alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
            return false;
            }
            return date_check(upd_vehicle.support_start_date,upd_vehicle.support_finish_date,"<cf_get_lang dictionary_id='49242.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
            
                    
            if($('#old_status').val() == 0)
            {
                /*İçerde aynı plakalı aktif bir araç varmı kontrolü */
                <cfif (get_assetp_control.recordCount)>
                    alert("<cf_get_lang dictionary_id='62397.Sistemde'> <cfoutput>#get_vehicles.assetp#</cfoutput> <cf_get_lang dictionary_id='62396.plakalı aktif araç bulunmaktadır'> !" );
                    document.getElementById('status').checked = false;
                    return false;
                </cfif>
            }
            <cfif isdefined("attributes.x_usage_purpose_required") and len(x_usage_purpose_required) eq 1>
                if ($('#new_usage_purpose_id').val() == "")
                {
                    alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47901.Kullanım Amacı'>!");
                    return false;
                }
            </cfif>
            <cfif isdefined("attributes.x_assetp_group_required") and len(x_assetp_group_required) eq 1>
                if ($('#new_assetp_group').val() == "")
                {
                    alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58140.İş Grubu'> !");
                    return false;
                }
            </cfif>
        }

        // Bir aracin cikis tarihi girilirse
        
        if($('#get_exit_date').val() != "")
        {
            if(document.getElementById('status').checked == true)
            {
                alert("<cf_get_lang dictionary_id='62398.Çıkış Tarihi Girilen Bir Araç Aktif Seçili Olmamalıdır'> !");
                return false;
            }
        }

        for(i=0;i<=3;i++)
        if(document.upd_vehicle.property[i].checked==true)
        {
            if(document.upd_vehicle.property[i].value != document.upd_vehicle.old_property.value)
            {
                if(confirm("<cf_get_lang dictionary_id='48504.Mülkiyet Alanındaki Değişiklik Araçtaki Belli Bilgileri Silecektir,Emin Misiniz?'>"));
                else return false;
            }
        }
        
        if(process_cat_control())
            if(confirm("<cf_get_lang dictionary_id='29914.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
        else
            return false;
    }
    
    function get_assetp_sub_cat()
    {
        for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--){
                $('#assetp_sub_catid option')[i].remove();
        }	
        var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $("#assetp_catid").val()+" ORDER BY ASSETP_SUB_CAT","dsn");
        if(get_assetp_sub_cat.recordcount > 0)
        {
            $("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
            for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
            {
                $("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
            }
        }
    }
    </script>