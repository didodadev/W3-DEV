<cf_xml_page_edit fuseact="assetcare.vehicle_detail">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_type_2" default="">
<cfinclude template="../query/get_assetp_groups.cfm">
<cfinclude template="../query/get_asset_state.cfm">
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cf_papers paper_type="FIXTURES">
    <cfif len(paper_number)>
        <cfset inventory_number = paper_code & '-' & paper_number>
    <cfelse>
        <cfset inventory_number = ''>
    </cfif>
<cfif isdefined('attributes.assetp_id') and len(attributes.assetp_id)>
	<cfinclude template="../query/get_assetp.cfm">
    <cfquery name="GET_VEHICLES" datasource="#DSN#">
        SELECT 
		   (SELECT POSITION_CAT FROM SETUP_POSITION_CAT SPC WHERE SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID) POSITION_CAT,
		    EP.POSITION_CAT_ID,
            ASSET_P.*,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME	
        FROM 
            ASSET_P,
            EMPLOYEES,
            EMPLOYEE_POSITIONS EP
        WHERE	
            EP.POSITION_CODE = ASSET_P.POSITION_CODE AND
            ASSET_P.ASSETP_ID = #attributes.assetp_id# AND
            ASSET_P.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
    </cfquery>
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
                DEPARTMENT.DEPARTMENT_ID = #get_vehicles.department_id# AND
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
                BRANCH_ID = #get_vehicles.branch_id#
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
                DEPARTMENT.DEPARTMENT_ID = #get_vehicles.department_id2# AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
    <!--- Alinan firma bilgileri için --->
	<cfif len(get_vehicles.sup_company_id)>
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_vehicles.sup_company_id#
        </cfquery>
        <cfif len(get_vehicles.sup_partner_id)>
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID= #get_vehicles.sup_partner_id#
        </cfquery>
        </cfif>
    <cfelseif len(get_vehicles.sup_consumer_id)>
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
            SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID = #get_vehicles.sup_consumer_id#
        </cfquery>		
    </cfif>
</cfif>
<cfif isDefined("attributes.assetp_id")>
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
<cfelse>
    <cfquery name="GET_RENT_CONTRACT" datasource="#dsn#">
        SELECT 
            COMPANY.COMPANY_ID,
            ASSET_CARE_CONTRACT.*,
            COMPANY.FULLNAME 
        FROM 
            ASSET_CARE_CONTRACT,
            COMPANY
        WHERE 
            1 = 0
    </cfquery>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
		POSITION_CAT_ID,
		POSITION_CAT 
	FROM 
		SETUP_POSITION_CAT
	WHERE
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		POSITION_CAT LIKE '%#attributes.keyword#%' AND
		</cfif>
		POSITION_CAT_STATUS =1
	ORDER BY 
		POSITION_CAT 
</cfquery>
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE WHERE MOTORIZED_VEHICLE = 1 ORDER BY USAGE_PURPOSE
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>      
        <cfform name="add_vehicle" method="post" action="#request.self#?fuseaction=assetcare.add_assetp_vehicle">
            <input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-form_ul_property">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48014.Mülkiyet'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="property" onchange="show_hide()">
                                <option value="1" <cfif isdefined('attributes.assetp_id') and isDefined("get_assetp") and get_assetp.property eq 1>selected</cfif>><cf_get_lang dictionary_id='57449.Satın Alma'></option>
                                <option value="2" <cfif isdefined('attributes.assetp_id') and isDefined("get_assetp") and get_assetp.property eq 2>selected</cfif>><cf_get_lang dictionary_id='48065.Kiralama'></option>
                                <option value="3" <cfif isdefined('attributes.assetp_id') and isDefined("get_assetp") and get_assetp.property eq 3>selected</cfif>><cf_get_lang dictionary_id='48066.Leasing'></option>
                                <option value="4" <cfif isdefined('attributes.assetp_id') and isDefined("get_assetp") and get_assetp.property eq 4>selected</cfif>><cf_get_lang dictionary_id='48067.Sozleşmeli'></option>
                            </select>
                        </div>													
					</div>
                    <div class="form-group" id="item-assetp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="assetp" id="assetp" value="" maxlength="100"> 
                        </div>
                    </div>
                    <div class="form-group" id="item-sup_comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47892.Alınan Şirket'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.sup_company_id#</cfif>">
                                <cfif isdefined('attributes.assetp_id')>
                                    <input type="text" name="sup_comp_name" id="sup_comp_name" value="<cfif len(get_vehicles.sup_company_id) and get_vehicles.sup_company_id neq 0>#get_company.fullname#<cfelseif len(get_vehicles.sup_consumer_id)>#get_consumer.company#</cfif>"  onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','200');">
                                <cfelse>   
                                    <input type="text" name="sup_comp_name" id="sup_comp_name" value="" onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','200');">
                                </cfif>
                                </cfoutput>
                                <span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_vehicle.sup_partner_name&field_partner=add_vehicle.sup_partner_id&field_comp_name=add_vehicle.sup_comp_name&field_comp_id=add_vehicle.sup_company_id&field_consumer=add_vehicle.sup_consumer_id&is_buyer_seller=1&select_list=2,3');"></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-sup_partner_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <input type="hidden" name="sup_partner_id" id="sup_partner_id" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.sup_partner_id#</cfif>">
                                <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.sup_consumer_id#</cfif>">
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_vehicles.sup_partner_id) and isnumeric(get_vehicles.sup_partner_id)>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="#get_partner.company_partner_name# #get_partner.company_partner_surname#" readonly>
                                    <cfelseif len(get_vehicles.sup_consumer_id) and isnumeric(get_vehicles.sup_consumer_id)>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="#get_consumer.consumer_name# #get_consumer.consumer_surname#" readonly>
                                    <cfelse>
                                        <input type="text" name="sup_partner_name" id="sup_partner_name" value="" readonly>							
                                    </cfif>
                                <cfelse>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="" readonly >
                                </cfif>
                            </cfoutput>
                        </div>
                    </div>

                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cfif  isdefined("attributes.assetp_id")>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0' value="#get_assetp.process_stage#">
                            <cfelse>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                            </cfif>
                        </div>
                    </div>

                    <div class="form-group" id="item-vehicle_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47973.Araç Tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <cf_wrkassetcat width="200" Lang_main="322.Seciniz" it_asset="0" is_motorized="1" compenent_name="GetAssetCat1" assetp_catid="#get_vehicles.assetp_catid#" onchange_action="get_assetp_sub_cat()">
                            <cfelse>
                                <cf_wrkassetcat width="200" Lang_main="322.Seciniz" it_asset="0" is_motorized="1" compenent_name="GetAssetCat1" onchange_action="get_assetp_sub_cat()">
                            </cfif>
                        </div>
                    </div>

                    <div class="form-group" id="item-assetp_sub_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id') and len(get_vehicles.assetp_catid)>
                                <cfquery name="GET_ASSETP_SUB_CAT" datasource="#DSN#">
                                    SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #get_vehicles.assetp_catid#
                                </cfquery>
                                <select name="assetp_sub_catid" id="assetp_sub_catid" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
                                    <cfoutput query="GET_ASSETP_SUB_CAT">
                                    <option value="#ASSETP_SUB_CATID#" <cfif get_vehicles.assetp_sub_catid eq ASSETP_SUB_CATID>selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                    </cfoutput>
                                </select>
                            <cfelse>
                                <select name="assetp_sub_catid" id="assetp_sub_catid">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>                            
                            </cfif>
                        </div>
                    </div>

                    <div class="form-group" id="item-branch_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput><cfif len(get_vehicles.branch_id)>#get_vehicles.branch_id#<cfelseif isdefined('get_branchs_deps.branch_id') and len(get_branchs_deps.branch_id)>#get_branchs_deps.branch_id#</cfif></cfoutput></cfif>">
                                <input type="text" name="branch_name" id="branch_name" value="<cfif isdefined('attributes.assetp_id')><cfoutput><cfif isdefined("get_branchs.branch_name") and len(get_branchs.branch_name)>#get_branchs.branch_name#<cfelseif isdefined('get_branchs_deps.branch_name') and len(get_branchs_deps.branch_name)>#get_branchs_deps.branch_name#</cfif></cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_vehicle.department_id&field_name=add_vehicle.department&branch_id=add_vehicle.branch_id&branch_name=add_vehicle.branch_name','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_vehicles.department_id#</cfoutput></cfif>">
                            <input type="text" name="department" id="department" value="<cfif isdefined('attributes.assetp_id') and len(get_vehicles.department_id)><cfoutput>#get_branchs_deps.department_head#</cfoutput></cfif>"  readonly="yes">
                        </div>
                    </div>
                        <div class="form-group" id="item-department2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48016.Kullanıcı Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                	<cfoutput>
                                    <input type="hidden" name="department_id2" id="department_id2" value="<cfif isdefined('attributes.assetp_id') and len(get_vehicles.department_id2)>#get_vehicles.department_id2#</cfif>">
                                    <input type="text" name="department2" id="department2" value="<cfif isdefined('attributes.assetp_id') and len(get_vehicles.department_id2)>#get_branchs_deps2.branch_name# - #get_branchs_deps2.department_head#</cfif>" onfocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','add_vehicle','3','200');">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_vehicle.department_id2&field_dep_branch_name=add_vehicle.department2&is_get_all=1','','ui-draggable-box-small');"></span>
                                   	</cfoutput>
                                </div>
                            </div>
                        </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_vehicles.position_code#</cfoutput></cfif>">
                                <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_vehicles.employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isdefined('attributes.assetp_id') and len(get_vehicles.employee_id)><cfoutput>#get_emp_info(get_vehicles.employee_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');">
                                <cfif x_fill_department eq 1>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_vehicle.position_code&field_name=add_vehicle.employee_name&field_emp_id=add_vehicle.emp_id&field_branch_id=add_vehicle.branch_id&field_branch_name=add_vehicle.branch_name&field_dep_id=add_vehicle.department_id&field_dep_name=add_vehicle.department</cfoutput>&select_list=1')"></span>
                                <cfelse>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_vehicle.position_code&field_name=add_vehicle.employee_name&field_emp_id=add_vehicle.emp_id</cfoutput>&select_list=1')"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-position_name2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="member_type_2" id="member_type_2" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.member_type_2#</cfif>">
                                    <input type="hidden" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.position_code2#</cfif>">
                                    <input type="text" name="position_name2" id="position_name2" readonly="readonly" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_vehicles.member_type_2) and get_vehicles.member_type_2 eq 'employee'>#get_emp_info(get_vehicles.position_code2,0,0)#<cfelseif len(get_vehicles.member_type_2) and get_vehicles.member_type_2 eq 'partner'>#get_par_info(get_vehicles.position_code2,0,0,0)#<cfelseif get_vehicles.member_type eq 'consumer'>#get_cons_info(get_vehicles.position_code2,0,0)#</cfif></cfif>"/> <!--- onFocus="AutoComplete_Create('position_name2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" --->
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_vehicle.position_code2&field_name=add_vehicle.position_name2&field_emp_id=add_vehicle.position_code2</cfoutput>&field_partner=add_vehicle.position_code2&field_consumer=add_vehicle.position_code2&field_type=add_vehicle.member_type_2&select_list=1,7,8&branch_related')"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47893.Alis Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined('attributes.assetp_id')>
                                <cfif len(get_vehicles.sup_company_date)>
                                    <cfinput type="text" name="start_date" value="#dateFormat(get_vehicles.sup_company_date,dateformat_style)#" maxlength="10" >
                                </cfif>
                                <cfelse>
                                    <cfinput type="text" name="start_date" value="" maxlength="10" >
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                        <div class="form-group" id="item-assetp_other_money_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48562.Deger'></label>
                            <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="assetp_other_money_value" id="assetp_other_money_value" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#tlFormat(get_vehicles.other_money_value)#</cfoutput></cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));">
                                <span class="input-group-addon width"><select name="assetp_other_money" id="assetp_other_money">
                                    <cfoutput query="get_money"> 
                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                                </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-size">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58831.Boyutlar'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 col-xs-4">
                                    <cfoutput>
                                        <input type="text" name="asset_vehicle_width" id="asset_vehicle_width" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.PHYSICAL_ASSETS_WIDTH#</cfif>"  onkeyup="isNumber(this);" placeholder="a">
                                    </cfoutput>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <cfoutput>
                                        <input type="text" name="asset_vehicle_size" id="asset_vehicle_size" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.PHYSICAL_ASSETS_SIZE#</cfif>" onkeyup="isNumber(this);" placeholder="b">
                                    </cfoutput>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <cfoutput>
                                        <input type="text" name="asset_vehicle_height" id="asset_vehicle_height" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.PHYSICAL_ASSETS_HEIGHT#</cfif>" onkeyup="isNumber(this);" placeholder="h">
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    <div class="form-group" id="item-is_collective_usage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48516.Ortak Kullanım'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1" <cfif isdefined('attributes.assetp_id')><cfif get_vehicles.IS_COLLECTIVE_USAGE eq 1>checked</cfif></cfif>>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-relation_asset">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                
                                <cfif isdefined("attributes.assetp_id")>
                                    <cfif len(get_assetp.relation_physical_asset_id)>
                                        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
                                        </cfquery>
                                            <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
                                            <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
                                    <cfelse>
                                            <cfset relation_phy_asset_id = ''>
                                            <cfset relation_phy_asset = ''>
                                    </cfif>
                                    <cfinput type="hidden" name="relation_asset_id" id="relation_asset_id" value="#relation_phy_asset_id#">
                                    <cfinput type="text" name="relation_asset" id="relation_asset" value="#relation_phy_asset#" onFocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','135');">
                                    <span class="input-group-addon icon-ellipsis"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_vehicle.relation_asset_id&field_name=add_vehicle.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                                    <cfif len(get_assetp.relation_physical_asset_id)><a target="_blank" href="<cfoutput>#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#relation_phy_asset_id#</cfoutput>" class="tableyazi"><img src="../images/update_list.gif" border="0" align="absbottom" alt="<cf_get_lang dictionary_id='57771.Detay'>" title="<cf_get_lang dictionary_id='57771.Detay'>"></a></cfif>
                                    <cfelse>
                                    <cfif isdefined("attributes.relation_assetp_id")>
                                        
                                        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.relation_assetp_id#
                                        </cfquery>
                                        <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
                                        <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
                                    <cfelse>
                                        <cfset relation_phy_asset_id = ''>
                                        <cfset relation_phy_asset = ''>
                                    </cfif>
                                    <input type="hidden" name="relation_asset_id" id="relation_asset_id" value="<cfoutput>#relation_phy_asset_id#</cfoutput>">
                                    <input type="text" name="relation_asset" id="relation_asset" value="<cfoutput>#relation_phy_asset#</cfoutput>" style="width:187px" onFocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','135');">
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_vehicle.relation_asset_id&field_name=add_vehicle.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                                </cfif>
                                
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-first_km">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48089.İlk KM'><cfif isdefined("attributes.x_first_km") and len(x_first_km) eq 1>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="first_km" id="first_km" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#tlFormat(get_vehicles.first_km,0)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-first_date_km">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48209.İlk KM Tarihi'><cfif isdefined("attributes.x_first_date_km") and len(x_first_date_km) eq 1>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="first_date_km" id="first_date_km" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_vehicles.first_km_date)><cfoutput>#dateformat(get_vehicles.first_km_date,dateformat_style)#</cfoutput></cfif></cfif>"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="first_date_km"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-inventory_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58878.Demirbaş No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(paper_number)>
                                <cfinput type="text" name="inventory_number" id="inventory_number" value="#inventory_number#" maxlength="40" readonly>
                            <cfelse>
                                <input type="text" name="inventory_number" id="inventory_number" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_vehicles.inventory_number#</cfoutput></cfif>" maxlength="50">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-fuel_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30113.Yakıt Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="fuel_type" id="fuel_type">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_fuel_type"> 
                                    <option value="#fuel_id#" <cfif isdefined('attributes.assetp_id')><cfif get_vehicles.fuel_type eq fuel_id>selected</cfif></cfif>>#fuel_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="status" id="status">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_asset_state">
                                    <option value="#asset_state_id#"<cfif isdefined('attributes.assetp_id')><cfif len(get_vehicles.assetp_status) and (get_vehicles.assetp_status eq asset_state_id)>selected</cfif></cfif>>#asset_state#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_group" id="assetp_group">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_assetp_groups">
                                    <option value="#group_id#"<cfif isdefined('attributes.assetp_id')><cfif get_vehicles.assetp_group eq group_id>selected</cfif></cfif>>#group_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <input type="text" name="position_cat_name" id="position_cat_name" value="<cfoutput>#get_vehicles.position_cat#</cfoutput>" readonly="yes">
                            <cfelse>
                                <input type="text" name="position_cat_name" id="position_cat_name" value="" readonly="yes">
                            </cfif>	
                        </div>
                    </div>
                    <div class="form-group" id="item-usage_purpose_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47901.Kullanım Amacı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="usage_purpose_id" id="usage_purpose_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_purpose">
                                <option value="#usage_purpose_id#" <cfif isdefined('attributes.assetp_id')><cfif get_vehicles.usage_purpose_id eq usage_purpose_id>selected</cfif></cfif>>#usage_purpose#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-make_year">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="make_year" id="make_year">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfset model_yili = get_vehicles.make_year>
                                </cfif>
                                <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                    <option value="#i#" <cfif isdefined('attributes.assetp_id')><cfif model_yili eq i>selected</cfif></cfif>>#i#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_model">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.brand_id#</cfif>">
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfif isdefined('attributes.assetp_id')>#get_vehicles.brand_type_id#</cfif>">
                            </cfoutput>
                            <cfif isdefined('attributes.assetp_id')>
                            <cf_wrkbrandtypecat
                                    brand_type_cat_id="#get_vehicles.brand_type_cat_id#"
                                    width="200"
                                    compenent_name="getBrandTypeCat2"      
                                    brand_type_cat_name="1"         
                                    boxwidth="240"
                                    boxheight="150">
                            <cfelse>
                                <cf_wrkbrandtypecat
                                    width="200"
                                    compenent_name="getBrandTypeCat2"
                                    brand_type_cat_name="1"          
                                    boxwidth="240"
                                    boxheight="150">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                             <textarea name="assetp_detail" id="assetp_detail"><cfif isdefined('attributes.assetp_id')><cfoutput>#get_vehicles.assetp_detail#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                </div>
                <div id="kira" class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true" style="display:none;">            
                    <div>
                        <div class="form-group" id="item-rental_information">
                            <label class="col col-4 col-xs-12 bold"><b><cf_get_lang dictionary_id='48203.Kiralama Bilgileri'></b></label>
                        </div>
                        <div class="form-group" id="item-rent_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48204.Kira Tutarı'> (<cf_get_lang dictionary_id='48406.KDV Dahil'>)</label>
                            <div class="col col-6 col-xs-12">
                                <input type="text" name="rent_amount" id="rent_amount"  class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="col col-2 col-xs-12">
                                <select name="rent_amount_currency" id="rent_amount_currency">
                                    <cfoutput query="get_money"> 
                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-rent_payment_period">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48205.Ödeme Periyodu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="rent_payment_period" id="rent_payment_period">
                                    <option value=""></option>
                                    <option value="1"><cf_get_lang dictionary_id='58458.Haftalık'></option>
                                    <option value="2"><cf_get_lang dictionary_id='58932.Aylık'></option>
                                    <option value="3"><cf_get_lang dictionary_id='58932.3 Aylık'></option>
                                    <option value="4"><cf_get_lang dictionary_id='29400.Yıllık'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-form_ul_rent_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48208.Kiralama Süresi'></label>
                            <div class="col col-4 col-xs-4">
                                <div class="input-group">
                                    <input type="text" name="rent_start_date" id="rent_start_date" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#dateformat(get_assetp.rent_start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"> 
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="rent_start_date"></span>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-8">
                                <div class="input-group">
                                    <input type="text" name="rent_finish_date" id="rent_finish_date" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#dateformat(get_assetp.rent_finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"> 
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="rent_finish_date"></span>
                                </div>				
                            </div>
                        </div>
                    </div>
                    <div id="masraf" style="display:none;">
                        <div class="form-group" id="item-cost">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='48210.Masraf Bilgileri'></label>
                        </div>			
                        <div class="form-group" id="item-is_fuel_added">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48216.Yakıt Masrafı'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="is_fuel_added" id="is_fuel_added" onchange="show_hide()">
                                    <option value="0"><cf_get_lang dictionary_id='48213.Hariç'></option>
                                    <option value="1"><cf_get_lang dictionary_id='48214.Dahil'></option>
                                    <option value="2"><cf_get_lang dictionary_id='48407.Limitsiz'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="fuel" style="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48212.Üst Limit'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="fuel_amount" id="fuel_amount" value="" class="moneybox" onkeyup="FormatCurrency(this,event);">
                                    <span class="input-group-addon width">
                                        <select name="fuel_amount_currency" id="fuel_amount_currency">
                                            <cfoutput query="get_money"> 
                                                <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>								
                        </div>
                        <div id="outsource">			
							<div class="form-group" id="item-form_ul_is_care_added">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48215.Bakım Masrafı'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="is_care_added" id="is_care_added" onchange="show_hide()">
                                        <option value="0"><cf_get_lang dictionary_id='48213.Hariç'></option>
                                        <option value="1"><cf_get_lang dictionary_id='48214.Dahil'></option>
                                        <option value="2"><cf_get_lang dictionary_id='48407.Limitsiz'></option>
                                    </select>
                                </div>
							</div>
							<div class="form-group" id="care" style="display:none;">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48212.Üst Limit'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="care_amount" id="care_amount" value=" <cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.care_amount#</cfoutput></cfif>" class="moneybox" onkeyup="FormatCurrency(this,event);">
										<span class="input-group-addon width">
											<select name="care_amount_currency" id="care_amount_currency">
												<cfoutput query="get_money"> 
													<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>								
							</div>           
						</div>
                    </div>
                </div>
                <div id="sozlesme" class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true" style="display:none;">            
					<div>
						<div class="form-group" id="item-header3">
							<label class="col col-4 col-xs-12 bold"><b><cf_get_lang dictionary_id='48362.Sözleşme Bilgisi'></b></label>
						</div>
						<div class="form-group" id="item-contract_head">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
								<cfinput type="text" name="contract_head" value="" maxlength="100" required="no" message="#message#">
							</div>
						</div>

						<div class="form-group" id="item-asset_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="asset_name" value="" readonly>
							</div>
						</div>

						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57574.şirket!'></cfsavecontent>
									<cfinput type="text" name="support_company_id" value="" required="no" message="#message#"  readonly>
									<span  class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=add_vehicle.authorized_id&field_comp_name=add_vehicle.support_company_id&field_name=add_vehicle.support_authorized_id&field_comp_id=add_vehicle.company_id&select_list=2,3,5,6');"></span>
								</div>
							</div>
						</div>

						<div class="form-group" id="item-authorized_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="authorized_id" id="authorized_id" value="">
								<input type="text" name="support_authorized_id" id="support_authorized_id" value="" readonly >
							</div>
						</div>

						<div class="form-group" id="item-support_position_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48115.Sorumlu Çalışan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="support_position_id" id="support_position_id" value="">
									<input type="text" name="support_position_name" id="support_position_name" value="" readonly>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_vehicle.support_position_id&field_name=add_vehicle.support_position_name&select_list=1');"></span>
								</div>
							</div>
						</div>

						<div class="form-group" id="item-support_start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
									<cfinput type="text" name="support_start_date" id="support_start_date" validate="#validate_style#" maxlength="10" message="#message#" value="">
									<span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>
								</div>
							</div>
						</div>

						<div class="form-group" id="item-support_finish_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfinput type="text" name="support_finish_date" id="support_finish_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>	
								</div>
							</div>
						</div>

						<div class="form-group" id="item-project_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_rent_contract.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_project_name(get_rent_contract.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','time_cost','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_vehicle.project_head&project_id=add_vehicle.project_id</cfoutput>');"></span>
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
								<textarea  name="detail" id="detail"></textarea>
							</div>
						</div>
					</div>
				</div>
            </cf_box_elements>
           <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' is_reset='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script language="JavaScript">
show_hide();

function show_hide()
{
    var propertyValue = document.add_vehicle.property.value;

	if(propertyValue == 1)
	{
		gizle(masraf);
        gizle(kira);
        gizle(sozlesme);
		$('#care_amount').val("");
		$('#fuel_amount').val("");
		$('#rent_amount').val("");
		$('#rent_start_date').val("");
		$('#rent_finish_date').val("");
	}
	
	if(propertyValue == 2)
	{
        gizle(sozlesme);
		goster(masraf);
		goster(kira);
		$('#care_amount').val("");
		$('#fuel_amount').val("");
		
	}
	
	if(propertyValue == 3)
	{
        gizle(sozlesme);
		gizle(masraf);
		gizle(kira);
		$('#care_amount').val("");
		$('#fuel_amount').val("");
		$('#rent_amount').val("");
		$('#rent_start_date').val("");
		$('#rent_finish_date').val("");
	}
	
	if(propertyValue == 4)
	{
		gizle(masraf);
        gizle(kira);
        goster(sozlesme);
	}
    
    var is_care_added = document.add_vehicle.is_care_added.value;
    
	if(is_care_added == 0)
	{
		gizle(care);
		document.add_vehicle.care_amount.value = "" ;
		document.add_vehicle.care_amount_currency.selectedIndex = "";
	}
	if(is_care_added == 1)
	{
		gizle(care);
		document.add_vehicle.care_amount.value = "" ;
		document.add_vehicle.care_amount_currency.selectedIndex = "";
	}
	if(is_care_added == 2)
	{
        goster(care);
	}
    
    var is_fuel_added = document.add_vehicle.is_fuel_added.value;
    
	if(is_fuel_added == 0)
	{
		gizle(fuel);
		document.add_vehicle.fuel_amount.value = "" ;
		document.add_vehicle.fuel_amount_currency.selectedIndex = "";
	}
	if(is_fuel_added == 1)
	{
		gizle(fuel);
		document.add_vehicle.fuel_amount.value = "" ;
		document.add_vehicle.fuel_amount_currency.selectedIndex = "";
	}
	if(is_fuel_added == 2)
	{
		goster(fuel);
	}

}

function kontrol()
{
	if( $('#sup_partner_id').val() == '' && $('#sup_consumer_id').val() == '')
	{
		alert('Alınan Şirket Seçiniz !');	
		return false;
	}
	if(document.add_vehicle.assetp.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29453.Plaka'> !");
		return false;
	}
	x = document.add_vehicle.assetp_catid.selectedIndex;
	if (document.add_vehicle.assetp_catid[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47973.Araç Tipi'> !");
		return false;
	}
	 
	if($('#assetp_sub_catid').val() == '')
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'> !");
		return false;	
	}
	if(document.add_vehicle.position_code.value =="" && document.add_vehicle.employee_name.value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57544.Sorumlu !'> !");
		return false;
	}
	<cfif isdefined("attributes.x_first_km") and len(x_first_km) eq 1>
        if(document.add_vehicle.first_km.value =="")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48089.İlk KM '> !");
            return false;
        }
	</cfif>	
	<cfif isdefined("attributes.x_first_date_km") and len(x_first_date_km) eq 1>
        if(document.add_vehicle.first_date_km.value =="")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48209.İlk KM Tarihi'>!");
            return false;
        }
	</cfif>
	if(document.add_vehicle.department.value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48198.Kayıtlı Şube'> !");
		return false;
	}
	
	if(document.add_vehicle.start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56996.Alım Tarihi !'>!");
		return false;
	}		
	
	if(!CheckEurodate(document.add_vehicle.start_date.value,"<cf_get_lang dictionary_id='47893.Alış tarihi'>"))
	{
		return false;
	}
	
	if(!date_check(document.add_vehicle.start_date,document.add_vehicle.date_now,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
	{
		return false;
	}
	
	if(!CheckEurodate(document.add_vehicle.first_date_km.value,'<cf_get_lang dictionary_id ="48209.İlk KM Tarihi">'))
	{
		return false;
	}

	if(document.add_vehicle.first_date_km.value != "" && !date_check(document.add_vehicle.start_date,document.add_vehicle.first_date_km,"<cf_get_lang dictionary_id='48423.Alış Tarihi İlk KM Tarihinden Büyük Olamaz'>!"))
	{
		return false;
	}
			
	if(document.add_vehicle.brand_name.value == "" || document.add_vehicle.brand_type_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'> !");
		return false;
	}
	
	t = document.add_vehicle.make_year.selectedIndex;
	if (document.add_vehicle.make_year[t].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58225.Model'>!");
		return false;
	}
	
	x = (250 - add_vehicle.assetp_detail.value.length);
	if(x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	
	if(document.add_vehicle.property[1].checked == true)
	{			
		document.add_vehicle.rent_amount.value = filterNum(document.add_vehicle.rent_amount.value);
	}
	
	if(document.add_vehicle.property[3].checked == true)
	{			
		document.add_vehicle.rent_amount.value = filterNum(document.add_vehicle.rent_amount.value);
		document.add_vehicle.fuel_amount.value = filterNum(document.add_vehicle.fuel_amount.value);
		document.add_vehicle.care_amount.value = filterNum(document.add_vehicle.care_amount.value);			
	}		
		document.add_vehicle.assetp_other_money_value.value = filterNum(document.add_vehicle.assetp_other_money_value.value);
    	document.add_vehicle.first_km.value = filterNum(document.add_vehicle.first_km.value);
	if(process_cat_control())
		if(confirm("<cf_get_lang dictionary_id='29914.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
	else
		return false;

}
function add_department()
{
	if(document.add_vehicle.department_id2.value == "" && document.add_vehicle.department2.value == "")
	{
	document.add_vehicle.department_id2.value = document.add_vehicle.department_id.value;
	document.add_vehicle.department2.value = document.add_vehicle.department.value;
	}
} 

function change_depot()
{
	document.add_vehicle.department_id2.value = document.add_vehicle.department_id.value;
	document.add_vehicle.department2.value = document.add_vehicle.department.value;
}


function get_assetp_sub_cat()
{
	 for (i=$('#assetp_sub_catid option').length-1 ; i>-1 ; i--)
	{   
	    $('#assetp_sub_catid option').eq(i).remove();
	}	
	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " +  $('#assetp_catid ').val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	
	if(get_assetp_sub_cat.recordcount > 0)
	{
		var selectBox = $("#assetp_sub_catid").attr('disabled');
		if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
		
		$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz" ));
					
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
			$("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
			}
	}else{
			
		$("#assetp_sub_catid").attr('disabled','disabled');
		
	}
}
</script>
