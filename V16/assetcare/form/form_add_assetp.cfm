<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_xml_page_edit fuseact="assetcare.form_add_assetp">
<cf_papers paper_type="FIXTURES">
<cfparam name="attributes.modal_id" default="">
<cfif len(paper_number)>
	<cfset inventory_number = paper_code & '-' & paper_number>
<cfelse>
	<cfset inventory_number = ''>
</cfif>
<cfinclude template="../query/get_assetp_groups.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
    SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT  WHERE MOTORIZED_VEHICLE = 0 AND IT_ASSET = 0 ORDER BY ASSETP_CAT
</cfquery>
<cfparam name="attributes.assetp_space_id" default="">
<cfif isdefined('attributes.assetp_id')>
	<cfinclude template="../query/get_assetp.cfm">

	<cfif len(get_assetp.department_id)>
		<cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
			SELECT
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME
			FROM
				BRANCH,
				DEPARTMENT
			WHERE
				DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id# AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
		<cfif len(get_assetp.department_id2)>
			<cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
				SELECT
					DEPARTMENT.DEPARTMENT_HEAD,
					BRANCH.BRANCH_NAME
				FROM 
					BRANCH,
					DEPARTMENT
				WHERE
					DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id2# AND
					BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
			</cfquery>
		</cfif>
        
            <cfif len(get_assetp.sup_partner_id)>
                <cfquery name="GET_PARTNER" datasource="#DSN#">
                    SELECT
                        CP.PARTNER_ID,
                        CP.COMPANY_PARTNER_NAME,
                        CP.COMPANY_PARTNER_SURNAME,
                        C.COMPANY_ID, 
                        C.NICKNAME,
                        C.FULLNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#"> AND
                        CP.COMPANY_ID = C.COMPANY_ID
                </cfquery>
            <cfelseif len(get_assetp.sup_consumer_id)>
                <cfquery name="GET_PARTNER" datasource="#DSN#">
                    SELECT
                        CONSUMER_NAME +' '+ CONSUMER_SURNAME AS FULLNAME,
                        COMPANY,
                        CONSUMER_ID
                    FROM
                        CONSUMER
                    WHERE
                        CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#"> 
                </cfquery>
            </cfif>

    </cfif>
</cfif>
<div style="display:none;z-index:999;" id="assetp_import"></div>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang(2207,'Fiziki Varlıklar',30004)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_assetp" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp">
            <cfif isdefined("attributes.assetp_id")>
                <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
            </cfif>
            <input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <input type="hidden" name="x_dimension" id="x_dimension" value="<cfoutput>#x_dimension#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-property">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='143.Mülkiyet'></label>
                        <div class="col col-2 col-xs-12">
                            <label><input name="property" id="property_1" type="radio" value="1" onClick="show_hide()" checked ><cf_get_lang_main no='37.Satın Alma'></label>
                            </div>	
                        <div class="col col-2 col-xs-12">
                            <label><input name="property" id="property_2" type="radio" value="2" onClick="show_hide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 2>checked</cfif></cfif>><cf_get_lang no='194.Kiralama'></label>						
                        </div>						
                        <div class="col col-2 col-xs-12"> <label><input name="property" id="property_3" type="radio" value="3" onClick="show_hide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 3>checked</cfif></cfif>><cf_get_lang no='195.Leasing'></label>
                        </div>	
                        <div class="col col-2 col-xs-12">
                        <label><input name="property" id="property_4" type="radio" value="4" onClick="show_hide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 4>checked</cfif></cfif>><cf_get_lang no='196.Sözleşme'>	</label>							
                        </div>	
                    </div>
                    
                    <div class="form-group" id="item-barcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='221.Barkod'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="barcode" id="barcode" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.barcode#</cfoutput></cfif>" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1655.Varlık Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="assetp" id="assetp" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.assetp#</cfoutput></cfif>" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-sup_comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='21.Alınan Şirket'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_company_id#</cfoutput></cfif>">
                                <input type="text" name="sup_comp_name" id="sup_comp_name" value="<cfif isdefined('attributes.assetp_id') and len(get_assetp.sup_company_id)><cfoutput>#get_partner.fullname#</cfoutput></cfif>" onFocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','sup_partner_name,sup_consumer_id,sup_partner_id,sup_company_id','','3','220');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_assetp.sup_partner_name&field_partner=add_assetp.sup_partner_id&field_comp_name=add_assetp.sup_comp_name&field_comp_id=add_assetp.sup_company_id&field_consumer=add_assetp.sup_consumer_id&select_list=2,3');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sup_partner_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="sup_partner_id" id="sup_partner_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_consumer_id#</cfoutput></cfif>">
                            <cfif isdefined('attributes.assetp_id')>
                                <cfif len(get_assetp.sup_partner_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>" readonly>
                                <cfelseif len(get_assetp.sup_consumer_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_partner.FULLNAME#</cfoutput>" readonly>
                                <cfelse>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="" readonly>
                                </cfif>
                            <cfelse>
                                <input type="text" name="sup_partner_name" id="sup_partner_name"  readonly>
                            </cfif>
                            <input type="hidden" name="company_partner_id" id="company_partner_id" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cfif  isdefined("attributes.assetp_id")>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0' value="#get_assetp.process_stage#">
                            <cfelse>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='517.Varlık Tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isDefined('attributes.assetp_id')>
                                <cf_wrkassetcat Lang_main="322.Seciniz" it_asset="0" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="#get_assetp.assetp_catid#" onchange_action="get_assetp_sub_cat()" >
                            <cfelse>
                                <cf_wrkassetcat Lang_main="322.Seciniz" it_asset="0" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="assetp_catid" onchange_action="get_assetp_sub_cat()" >
                            </cfif>
                           
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_sub_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='5.Varlık Alt Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <cfif len(get_assetp.assetp_catid)>
                                    <cfquery name="GET_SUB_CAT" datasource="#dsn#">
                                        SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid#
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <select name="assetp_sub_catid" id="assetp_sub_catid">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_assetp.assetp_sub_catid)>
                                        <cfoutput query="GET_SUB_CAT">
                                            <option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq get_assetp.assetp_sub_catid> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                        </cfoutput>
                                    </cfif>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='144.Kayıtlı Departman'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.department_id#</cfoutput></cfif>">
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_assetp.department_id)>
                                        <cfinput type="text" name="department" id="department" value="#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#"  onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','add_department()');">
                                    <cfelse>
                                        <cfinput type="text" name="department" id="department" value="" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','add_department()');">
                                    </cfif>
                                <cfelse>
                                    <input type="text" name="department" id="department" value="" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','add_assetp','3','200','add_department()');">
                                </cfif>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_assetp.department_id&field_dep_branch_name=add_assetp.department&is_function=1');" title="Seçiniz"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department2">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='145.Kullanıcı Departman'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id2" id="department_id2" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.department_id2#</cfoutput></cfif>">
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_assetp.department_id2)>
                                        <cfinput type="text" name="department2" id="department2" value="#get_branchs_deps2.branch_name# - #get_branchs_deps2.department_head#" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_assetp','3','200');">
                                    <cfelse>
                                        <cfinput type="text" name="department2" id="department2" value="" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_assetp','3','200');">
                                    </cfif>
                                <cfelse>
                                    <input type="text" name="department2" id="department2" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','add_assetp','3','200');">
                                </cfif>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_assetp.department_id2&field_dep_branch_name=add_assetp.department2&is_get_all=1');" title="Seçiniz"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_assetp_space_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60386.Bulunduğu Yer">/<cf_get_lang dictionary_id="60371.Mekan"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_space_id" id="assetp_space_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.asset_p_space_id#</cfoutput></cfif>">
                                <input type="text" name="assetp_space_name" id="assetp_space_name" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.space_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('assetp_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','assetp_space_id','','3','135')">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=assetp_space_name&field_id=assetp_space_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.position_code#</cfoutput></cfif>">
                                <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isdefined('attributes.assetp_id') and len(get_assetp.employee_id)><cfoutput>#get_emp_info(get_assetp.employee_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.employee_name&field_emp_id=add_assetp.emp_id&function_name=fill_department</cfoutput>&select_list=1')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position2">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'>2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.position_code2#</cfoutput></cfif>" />
                                <input type="hidden" name="member_type_2" id="member_type_2" value="<cfif isdefined('get_assetp.member_type_2')><cfoutput>#get_assetp.member_type_2#</cfoutput></cfif>" />
                                <input type="text" name="position2" id="position2" value="<cfoutput><cfif isdefined('get_assetp.position_code2')><cfif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'employee'>#get_emp_info(get_assetp.position_code2,0,0)#<cfelseif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'partner'>#get_par_info(get_assetp.position_code2,0,0,0)#<cfelseif get_assetp.member_type_2 eq 'consumer'>#get_cons_info(get_assetp.position_code2,0,0)#</cfif></cfif></cfoutput>" onfocus="AutoComplete_Create('position2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','EMPLOYEE_ID,CONSUMER_ID,PARTNER_ID,MEMBER_TYPE','position_code2,position_code2,position_code2,member_type_2','','3','225');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_assetp.position2&field_partner=add_assetp.position_code2&field_consumer=add_assetp.position_code2&field_emp_id=add_assetp.position_code2&field_type=add_assetp.member_type_2&select_list=1,7,8&branch_related')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_other_money">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='691.Deger'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="assetp_other_money_value" id="assetp_other_money_value" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#tlFormat(get_assetp.other_money_value)#</cfoutput></cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));">
                                <span class="input-group-addon width">
                                    <select name="assetp_other_money" id="assetp_other_money">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_money">
                                            <option value="#money#"
                                                <cfif isdefined('attributes.assetp_id')>
                                                    <cfif money eq get_assetp.other_money>selected</cfif>
                                                <cfelse>
                                                <cfif money eq session.ep.money>selected</cfif></cfif>>#money#
                                            </option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='22.Alis Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'></cfsavecontent>
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfinput type="text" name="start_date" id="start_date" value="#dateformat(get_assetp.sup_company_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                <cfelse>
                                    <cfinput type="text" name="start_date" id="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_collective_usages">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='645.Ortak Kullanım'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1"<cfif isdefined('attributes.assetp_id')><cfif get_assetp.IS_COLLECTIVE_USAGE eq 1>checked</cfif></cfif>>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isDefined('attributes.assetp_id')>
                                <input type="checkbox" name="status" id="status" value="1" <cfif get_assetp.status eq 1>checked</cfif>>
                            <cfelse>
                                <input type="checkbox" name="status" id="status" value="1">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-relation_asset">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='574.İlişkili Fiziki Varlık'></label>
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
                                    <span class="input-group-addon icon-ellipsis"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_assetp.relation_asset_id&field_name=add_assetp.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                                    <cfif len(get_assetp.relation_physical_asset_id)><a target="_blank" href="<cfoutput>#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#relation_phy_asset_id#</cfoutput>" class="tableyazi"><img src="../images/update_list.gif" border="0" align="absbottom" alt="<cf_get_lang_main no='359.Detay'>" title="<cf_get_lang_main no='359.Detay'>"></a></cfif>
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
                                    <input type="text" name="relation_asset" id="relation_asset" value="<cfoutput>#relation_phy_asset#</cfoutput>" onFocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','135');">
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_assetp.relation_asset_id&field_name=add_assetp.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-inventory_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1466.Demirbaş No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(paper_number)>
                                <cfinput type="text" name="inventory_number" id="inventory_number" value="#inventory_number#" maxlength="40" readonly>
                                <cfinput type="hidden" name="fixtures_id" id="fixtures_id" value="">
                            <cfelse>
                                <input type="text" name="inventory_number" id="inventory_number" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.inventory_number#</cfoutput></cfif>" maxlength="50">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-serial_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='225.Seri No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="serial_number" id="serial_number" maxlength="50" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.serial_no#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-special_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="special_code" id="special_code" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.primary_code#</cfoutput></cfif>" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='27.Servis Çalışanı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.service_employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_emp_info(get_assetp.service_employee_id,1,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_assetp.employee_id&field_name=add_assetp.employee&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_status">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='344.Durum'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                            <cf_wrk_combo
                                name="assetp_status"
                                query_name="GET_ASSET_STATE"
                                option_name="asset_state"
                                option_value="asset_state_id"
                                value="#get_assetp.assetp_status#"
                                option_text="Seçiniz"
                                width=200>
                        <cfelse>
                            <cf_wrk_combo
                                name="assetp_status"
                                query_name="GET_ASSET_STATE"
                                option_name="asset_state"
                                option_value="asset_state_id"
                                option_text="Seçiniz"
                                width=200>
                        </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='728.İş Grubu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_group" id="assetp_group">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_assetp_groups">
                                    <option value="#group_id#"
                                    <cfif isdefined('attributes.assetp_id')>
                                        <cfif get_assetp.assetp_group eq group_id>selected</cfif>
                                    </cfif>>#group_name#
                                    </option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-usage_purpose_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='30.Kullanım Amacı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="usage_purpose_id" id="usage_purpose_id">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_purpose">
                                    <option value="#usage_purpose_id#"<cfif isdefined('attributes.assetp_id')><cfif get_assetp.usage_purpose_id eq usage_purpose_id>selected</cfif></cfif>>#usage_purpose#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-make_year">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='813.Model'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="make_year"  id="make_year">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfset model_yili = get_assetp.make_year>
                                </cfif>
                                <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <option value="#i#"<cfif isdefined('attributes.assetp_id')><cfif model_yili eq i>selected</cfif></cfif>>#i#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined('attributes.assetp_id')>#get_assetp.brand_id#</cfif>">
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfif isdefined('attributes.assetp_id')>#get_assetp.brand_type_id#</cfif>">
                            </cfoutput>
                            <cfif isdefined('attributes.assetp_id')>
                            <cf_wrkbrandtypecat
                                    brand_type_cat_id="#get_assetp.brand_type_cat_id#"
                                    width="200"
                                    compenent_name="getBrandTypeCat1"      
                                    brand_type_cat_name="1"         
                                    boxwidth="240"
                                    boxheight="150">
                            <cfelse>
                                <cf_wrkbrandtypecat
                                    width="200"
                                    compenent_name="getBrandTypeCat1"
                                    brand_type_cat_name="1"          
                                    boxwidth="240"
                                    boxheight="150">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="assetp_detail" id="assetp_detail"><cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.assetp_detail#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-physical_assets">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1419.Boyutlar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('x_dimension') and x_dimension eq 1>
                                <div class="col col-4 col-xs-3">
                                    <input type="text" name="physical_assets_width" id="physical_assets_width" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.physical_assets_width#</cfoutput></cfif>" onkeyup="isNumber(this);" placeholder="a">
                                </div>
                                <div class="col col-4 col-xs-3">
                                    <input type="text" name="physical_assets_size" id="physical_assets_size" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.physical_assets_size#</cfoutput></cfif>" onkeyup="isNumber(this);" placeholder="b">
                                </div>
                                <div class="col col-4 col-xs-3">
                                    <input type="text" name="physical_assets_height" id="physical_assets_height" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.physical_assets_height#</cfoutput></cfif>" onkeyup="isNumber(this);" placeholder="h">
                                </div>
                            <cfelse>
                                <cf_get_lang_main no='1419.Boyutlar'>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-coordinates">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42307.Konum'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_api_key.GOOGLE_API_KEY)>
                                    <cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="" name="coordinate_1" id="coordinate_1" style="width:65px;">
                                    <span class="input-group-addon"><cfoutput>#getLang('settings',670)#</cfoutput></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" maxlength="10"  range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="" name="coordinate_2" id="coordinate_2" style="width:65px;">
                                    <span class="input-group-addon"><cfoutput>#getLang('hr',650)#</cfoutput></span>
                                    <span class="input-group-addon no-bg"></span><span class="input-group-addon"><cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.list_assetp&event=googleMap&type=add','map_add_box','ui-draggable-box-medium')"><i class="fa fa-map-marker"></i></a></cfoutput></span>
                                <cfelse>
                                    <cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'><cf_get_lang dictionary_id='65286.bilgilerinin girilmesi gerekiyor'>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div id="rent" style="display:none;">
                        <div class="form-group" id="item-rental_info">
                            <label class="col col-12 col-xs-12"><cf_get_lang no='332.Kiralama Bilgileri'></label>
                        </div>
                        <div class="form-group" id="item-rent_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='333.Kira Tutarı'> (<cf_get_lang no='535.KDV Dahil'>)</label>
                            <div class="col col-5 col-xs-9">
                                <input type="text" name="rent_amount" id="rent_amount" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
                            </div>
                            <div class="col col-3 col-xs-3">
                                <select name="rent_amount_currency" id="rent_amount_currency">
                                    <cfoutput query="get_money">
                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-rent_payment_period">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='334.Ödeme Periyodu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="rent_payment_period" id="rent_payment_period">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <option value="1"><cf_get_lang_main no='1046.Haftalık'></option>
                                    <option value="2"><cf_get_lang_main no='1520.Aylık'></option>
                                    <option value="3"><cf_get_lang no='335.3 Aylık'></option>
                                    <option value="4"><cf_get_lang_main no='1603.Yıllık'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-rent_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='337.Kiralama Süresi'></label>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="rent_start_date" id="rent_start_date" value="" maxlength="10">
                                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="rent_start_date"></span>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="rent_finish_date" id="rent_finish_date" value="" maxlength="10">
                                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="rent_finish_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="outsource" style="display:none;">
                        <div class="form-group" id="item-cost_info">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='339.Masraf Bilgileri'></label>
                            <div class="col col-8 col-xs-12" style="display:none;" id="limit"><cf_get_lang no='341.Üst Limit'></div>
                        </div>
                        <div class="form-group" id="item-is_fuel_added">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='345.Yakıt Masrafı'></label>
                            <div class="col col-4 col-xs-9">
                                <input name="is_fuel_added" id="is_fuel_added_1" type="radio" value="0" onClick="show_hide(fuel);" checked><cf_get_lang no='342.Hariç'>
                            </div>
                            <div class="col col-4 col-xs-9">
                                <input name="is_fuel_added" id="is_fuel_added_2" type="radio" value="2" onClick="show_hide(fuel);"><cf_get_lang no='536.Limitsiz'>
                            </div>
                            <div class="col col-4 col-xs-9">
                                <input name="is_fuel_added" id="is_fuel_added_3" type="radio" value="1" onClick="show_hide(fuel);"><cf_get_lang no='343.Dahil'>
                            </div>
                        </div>
                        <div id="fuel" style="display:none;">
                            <div class="form-group" id="item-fuel_amount">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='333.Kira Tutarı'></label>
                                    <div class="col col-5 col-xs-9">
                                        <input type="text" name="fuel_amount" id="fuel_amount" value="" class="moneybox" onKeyUP="FormatCurrency(this,event);">
                                    </div>
                                    <div class="col col-3 col-xs-3">
                                        <select name="fuel_amount_currency" id="fuel_amount_currency">
                                            <option value=""></option>
                                            <cfoutput query="get_money">
                                                <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group" id="item-rent_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='344.Bakım Masrafı'></label>
                                <div class="col col-4 col-xs-9">
                                    <input name="is_care_added" id="is_care_added_1" type="radio" value="0" onClick="show_hide(care);" checked><cf_get_lang no='342.Hariç'>
                                </div>
                                <div class="col col-4 col-xs-9">
                                    <input name="is_care_added" id="is_care_added_2" type="radio" value="2" onClick="show_hide(care);"><cf_get_lang no='536.Limitsiz'>
                                </div>
                                <div class="col col-4 col-xs-9">
                                    <input name="is_care_added" id="is_care_added_3" type="radio" value="1" onClick="show_hide(care);"><cf_get_lang no='343.Dahil'>
                                </div>
                        </div>
                    </div>
                    <div id="care" style="display:none;">
                        <div class="form-group" id="item-care">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='344.Bakım Masrafı'></label>
                                <div class="col col-5 col-xs-9">
                                    <input type="text" name="care_amount" id="care_amount" value="" class="moneybox" onKeyUp="FormatCurrency(this,event);">
                                </div>
                                <div class="col col-3 col-xs-9">
                                    <select name="care_amount_currency" id="care_amount_currency">
                                        <option value=""></option>
                                        <cfoutput query="get_money">
                                            <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol_add()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol_add()
{   
	if ($('form[name="add_assetp"] #assetp').val() == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'> <cf_get_lang_main no='485.adı'> !");
		return false;
	}
	var x =$('form[name="add_assetp"] #assetp_catid').prop('selectedIndex');
	if ($('form[name="add_assetp"] #assetp_catid option')[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='517.Varlık Tipi'> !");
		return false;
	}
			
	if($('form[name="add_assetp"] #department').val()=="")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='144.Kayıtlı Departman '> !");
		return false;
	}
	if($('form[name="add_assetp"] #employee_name').val() == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
		return false;
	}
	
	if($('form[name="add_assetp"] #start_date').val() == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'>!");
		return false;
	}		
	
	if(!CheckEurodate(document.add_assetp.start_date.value,"<cf_get_lang no='22.Alış tarihi'>"))
	{
		return false;
	}
	
	if(!date_check(document.add_assetp.start_date,document.add_assetp.date_now,"<cf_get_lang no='552.Alış Tarihini Kontrol Ediniz'>!"))
	{
		return false;
	}
	x = (250 - add_assetp.assetp_detail.value.length);
	if(x < 0)
	{ 
		alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
		return false;
	}
	
	if($('form[name="add_assetp"] #property_2').is(':checked') == true)
	{			
		$('form[name="add_assetp"] #rent_amount').val(filterNum($('#rent_amount').val()));
	}
	
	if($('form[name="add_assetp"] #property_4').is(':checked') == true)
	{			
		$('form[name="add_assetp"] #rent_amount').val(filterNum($('#rent_amount').val()));
		$('form[name="add_assetp"] #fuel_amount').val(filterNum($('#fuel_amount').val()));
		$('form[name="add_assetp"] #care_amount').val(filterNum($('#care_amount').val()));				
	}
	$('form[name="add_assetp"] #assetp_other_money_value').val(filterNum($('form[name="add_assetp"] #assetp_other_money_value').val()));	
	if(process_cat_control()){
		if(confirm("<cf_get_lang_main no='2117.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")){
            <cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_assetp' , #attributes.modal_id#);"),DE(""))#</cfoutput>
        }
    }
    <cfif x_control_fixtures_no eq 1>
        if(add_assetp.fixtures_no.value != '')
            if(!paper_control(add_assetp.fixtures_no,'FIXTURES',true,'','','','','','<cfoutput>#dsn#</cfoutput>')) return false;
	</cfif>
    <cfoutput>#iif(isdefined("attributes.draggable"),DE("return false"),DE("return true"))#</cfoutput>
}
function add_department()
{
	if($('form[name="add_assetp"] #department_id2').val() == "" && $('form[name="add_assetp"] #department2').val() == "")
	{
	$('form[name="add_assetp"] #department_id2').val() =$('form[name="add_assetp"] #department_id').val();
	$('form[name="add_assetp"] #department2').val() = $('form[name="add_assetp"] #department').val();
	}
} 
function change_depot()
{
	$('form[name="add_assetp"] #department_id2').val() =$('form[name="add_assetp"] #department_id').val();
	$('form[name="add_assetp"] #department2').val() = $('form[name="add_assetp"] #department').val();
}
function show_hide()
{
	if($('form[name="add_assetp"] #property_1').is(':checked'))
	{
		gizle(outsource);
		gizle(rent);
		$('form[name="add_assetp"] #care_amount').val("");
		$('form[name="add_assetp"] #fuel_amount').val("");
		$('form[name="add_assetp"] #rent_amount').val("");
		$('form[name="add_assetp"] #rent_start_date').val("");
		$('form[name="add_assetp"] #rent_finish_date').val("");
		$('form[name="add_assetp"] #is_care_added_1').is(':checked')==true;
		$('form[name="add_assetp"] #is_fuel_added').is(':checked')==true;
		$('form[name="add_assetp"] #rent_payment_period')[0].selected = true;
	}
	
	if($('form[name="add_assetp"] #property_2').is(':checked'))
	{
		gizle(outsource);
		goster(rent);
		$('form[name="add_assetp"] #care_amount').val("");
		$('form[name="add_assetp"] #fuel_amount').val("");
		
	}
	
	if($('form[name="add_assetp"] #property_3').is(':checked'))
	{
		gizle(outsource);
		gizle(rent);
		$('form[name="add_assetp"] #care_amount').val("");
		$('form[name="add_assetp"] #fuel_amount').val("");
		$('form[name="add_assetp"] #rent_amount').val("");
		$('form[name="add_assetp"] #rent_start_date').val("");
		$('form[name="add_assetp"] #rent_finish_date').val("");
		$('form[name="add_assetp"] #is_care_added_1').is(':checked')==true;
		$('form[name="add_assetp"] #is_fuel_added').is(':checked')==true;
		$('form[name="add_assetp"] #rent_payment_period')[0].selected = true;
	}
	
	if($('form[name="add_assetp"] #property_4').is(':checked'))
	{
		goster(outsource);
		goster(rent);
	}
	
	if($('form[name="add_assetp"] #is_care_added_1').is(':checked'))
	{
		gizle(care);
		$('form[name="add_assetp"] #care_amount').val("");
	}
	
	if($('form[name="add_assetp"] #is_care_added_2').is(':checked'))
	{
		gizle(care);
		$('form[name="add_assetp"] #care_amount').val("");
	}
	
	if($('form[name="add_assetp"] #is_care_added_3').is(':checked'))
	{
		goster(care);
	}
	
	if($('form[name="add_assetp"] #is_fuel_added_1').is(':checked'))
	{
		gizle(fuel);
		$('form[name="add_assetp"] #fuel_amount').val("");

	}
	
	if($('form[name="add_assetp"] #is_fuel_added_2').is(':checked'))
	{
		gizle(fuel);
		$('form[name="add_assetp"] #fuel_amount').val("");
	}
	
	if($('form[name="add_assetp"] #is_fuel_added_3').is(':checked'))
	{
		goster(fuel);
	}
	
	if($('form[name="add_assetp"] #is_care_added_3').is(':checked') || $('form[name="add_assetp"] #is_fuel_added_3').is(':checked'))
		goster(limit);
	else
		gizle(limit);
}
function get_assetp_sub_cat()
{
	for ( var i= $("form[name='add_assetp'] #assetp_sub_catid option").length-1 ; i>-1 ; i--)
		{
				$('form[name="add_assetp"] #assetp_sub_catid option').eq(i).remove();
		}
	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $("form[name='add_assetp'] #assetp_catid").val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	if(get_assetp_sub_cat.recordcount > 0)	
		
	{
		var selectBox = $("form[name='add_assetp'] #assetp_sub_catid").attr('disabled');
		if(selectBox) $("form[name='add_assetp'] #assetp_sub_catid").removeAttr('disabled');
		$("form[name='add_assetp'] #assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
				$("form[name='add_assetp'] #assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
			}
	}
	else{
			
		$("form[name='add_assetp'] #assetp_sub_catid").attr('disabled','disabled');
		
	}
}
function open_tab(url,id) {
    document.getElementById(id).style.display ='';	
    document.getElementById(id).style.width ='600px';
			$("#"+id).css('margin-left',$("#tabMenu").position().left - 600);
			$("#"+id).css('margin-top',$("#tabMenu").position().top);
			$("#"+id).css('position','absolute');			
        AjaxPageLoad(url,id,1);
        return false;
    }
function fill_department()
{	
	<cfif x_fill_department eq 1>
	
			$('form[name="add_assetp"] #department_id').val("");
			$('form[name="add_assetp"] #department_id2').val("");
			$('form[name="add_assetp"] #department').val("");
			$('form[name="add_assetp"] #department2').val("");
			var member_id=$('#emp_id').val();
			if(member_id!='')
			{
				var sql = "SELECT DISTINCT D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP,BRANCH B  WHERE D.BRANCH_ID = B.BRANCH_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND EP.IS_MASTER=1 AND EP.EMPLOYEE_ID=" + member_id;
				get_department= wrk_query(sql,'dsn');
				if($('#DEPARTMENT_ID')!='')
				{
					$('form[name="add_assetp"] #department_id').val(get_department.DEPARTMENT_ID);
					$('form[name="add_assetp"] #department_id2').val(get_department.DEPARTMENT_ID);
					$('form[name="add_assetp"] #department').val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
					$('form[name="add_assetp"] #department2').val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
				}
			}
	
	</cfif>
}
</script>
