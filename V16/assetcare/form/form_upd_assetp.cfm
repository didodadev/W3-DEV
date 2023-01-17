<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset cfc = createObject("component","V16.assetcare.cfc.assetp")>
<cfset get_api_key = googleapi.get_api_key()>
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="assetcare.form_add_assetp">
<cf_papers paper_type="FIXTURES">
<cfparam name="attributes.assetp_space_id" default="">
<cfif not isnumeric(attributes.assetp_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfinclude template="../query/get_assetp.cfm">
<cfif (not get_assetp.recordcount)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../query/get_assetp_groups.cfm">
	<cfinclude template="../query/get_purpose.cfm">
<cfinclude template="../query/get_money.cfm">	
	<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
        SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT  WHERE MOTORIZED_VEHICLE = 0 AND IT_ASSET = 0 ORDER BY ASSETP_CAT
	</cfquery>
	<cfquery name="GET_ASSETP_IT" datasource="#DSN#">
		SELECT ASSETP_ID FROM ASSET_P_IT WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
	</cfquery>
	<cfquery name="KONTROL_" datasource="#DSN#">
		SELECT ASSET_ID FROM CARE_STATES WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
	</cfquery>
	<cfif len(get_assetp.department_id)>
		<cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
			SELECT
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME,
                DEPARTMENT.BRANCH_ID
			FROM
				BRANCH,
				DEPARTMENT
			WHERE
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id#"> AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
	</cfif>
	<cfif len(get_assetp.department_id2)>
		<cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
			SELECT
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME
			FROM 
				BRANCH,
				DEPARTMENT
			WHERE
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id2#"> AND
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
				CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#"> AND
				CP.COMPANY_ID = C.COMPANY_ID
		</cfquery>		
	<cfelseif len(get_assetp.sup_consumer_id)>
		<cfquery name="GET_CONSUMER" datasource="#dsn#">
			SELECT
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				COMPANY,
				CONSUMER_ID
			FROM
				CONSUMER
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#">
		</cfquery>		
	</cfif>
<cf_catalystHeader>
<div class="row">
    <div class="col col-9 col-xs-12">
        <cf_box title="#getLang('','Makine-Ekipman ve Binalar','47149')#">
            <cfform name="upd_assetp" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_assetp">
                <cf_box_elements>
                <input type="hidden" name="x_dimension" id="x_dimension" value="<cfoutput>#x_dimension#</cfoutput>" />
                <cfoutput>
                    <input type="hidden" name="old_assetp" id="old_assetp" value="#get_assetp.assetp#" />
                    <input type="hidden" name="old_property" id="old_property" value="#get_assetp.property#" />
                    <input type="hidden" name="old_department_id" id="old_department_id" value="#get_assetp.department_id#" />
                    <input type="hidden" name="old_department_id2" id="old_department_id2" value="#get_assetp.department_id2#" />
                    <input type="hidden" name="old_position_code" id="old_position_code" value="#get_assetp.position_code#" />
                    <input type="hidden" name="old_status" id="old_status" value="#get_assetp.status#" />
                    <input type="hidden" name="assetp_id" id="assetp_id" value="#get_assetp.assetp_id#" />
                    <input type="hidden" name="date_now" id="date_now" value="#dateformat(now(),dateformat_style)#" />
                    <input type="hidden" name="old_sup_company_date" id="old_sup_company_date" value="#get_assetp.sup_company_date#" />
                    <input type="hidden" name="old_emp_id" id="old_emp_id" value="#get_assetp.EMPLOYEE_ID#" />
                    <input type="hidden" name="old_transfer_date" id="old_transfer_date" value="#dateformat(get_assetp.transfer_date,dateformat_style)#" />
                    <input type="hidden" name="old_assetp_id" id="assetp_id" value="#get_assetp.assetp_id#" />
                    <input type="hidden" name="old_status_id" id="old_status_id" value="#get_assetp.ASSETP_STATUS#" />
                </cfoutput>
                <div class="row" type="row">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-property">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38829.Mülkiyet'></label>
                            <div class="col col-2 col-xs-12">
                                <label><input name="property" id="property_1" type="radio" value="1" <cfif get_assetp.property eq 1>checked</cfif>><cf_get_lang_main no='37.Satın Alma'></label>
                                </div><div class="col col-2 col-xs-12">
                                <label><input name="property" id="property_2" type="radio" value="2" <cfif get_assetp.property eq 2>checked</cfif>><cf_get_lang no='194.Kiralama'></label>						
                                </div><div class="col col-2 col-xs-12">
                                <label><input name="property" id="property_3" type="radio" value="3" <cfif get_assetp.property eq 3>checked</cfif>><cf_get_lang no='195.Leasing'></label>
                                </div><div class="col col-2 col-xs-12">
                                <label><input name="property" id="property_4" type="radio" value="4" <cfif get_assetp.property eq 4>checked</cfif>><cf_get_lang no='196.Sozleşmeli'></label>							
                            </div>						
                        </div>
                        
                        <div class="form-group" id="item-barcode">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="barcode" value="#get_assetp.barcode#" maxlength="100">
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29452.Varlık Adı'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="assetp" value="#get_assetp.assetp#">
                            </div>
                        </div>
                        <div class="form-group" id="item-sup_comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38825.Alınan Şirket'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfoutput>#get_assetp.sup_company_id#</cfoutput>" />
                                    <cfif len(get_assetp.sup_partner_id)>
                                        <input type="text" name="sup_comp_name" id="sup_comp_name" value="<cfoutput>#get_partner.fullname#</cfoutput>" onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','135');" />
                                    <cfelse>
                                        <input type="text" name="sup_comp_name" id="sup_comp_name" value="" onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','135');" />
                                    </cfif>
                                    <span class="input-group-addon btn_Pointer icon-ellipsis"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=upd_assetp.sup_partner_name&field_partner=upd_assetp.sup_partner_id&field_comp_name=upd_assetp.sup_comp_name&field_comp_id=upd_assetp.sup_company_id&field_consumer=upd_assetp.sup_consumer_id&select_list=2,3','list','popup_list_pars');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-sup_partner_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="sup_partner_id" id="sup_partner_id" value="<cfoutput>#get_assetp.sup_partner_id#</cfoutput>" />
                                <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="<cfoutput>#get_assetp.sup_consumer_id#</cfoutput>" />
                                <input type="hidden" name="company_partner_id" id="company_partner_id" value="" />
                                <cfif len(get_assetp.sup_partner_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>" readonly  />
                                <cfelseif len(get_assetp.sup_consumer_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>" readonly />
                                <cfelse>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="" readonly />
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-sup_process_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' select_value="#get_assetp.process_stage#">
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_catid">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36646.Varlık Tipi'>*</label>
                            <div class="col col-8 col-xs-12">                                
                                <cf_wrkassetcat Lang_main="322.Seciniz" it_asset="0" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="#get_assetp.assetp_catid#" onchange_action="get_assetp_sub_cat()" >
                            </div>                      
                        </div>
                        <div class="form-group" id="item-assetp_sub_catid">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_assetp.ASSETP_SUB_CATID)>
                                    <cfquery name="GET_SUB_CAT" datasource="#dsn#">
                                        SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid# ORDER BY ASSETP_SUB_CAT
                                    </cfquery>
                                </cfif>
                                <select name="assetp_sub_catid" id="assetp_sub_catid" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif len(get_assetp.ASSETP_SUB_CATID)>
                                        <cfoutput query="GET_SUB_CAT">
                                            <option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq get_assetp.ASSETP_SUB_CATID> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48015.Kayıtlı Departman'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_assetp.department_id#</cfoutput>" />
                                    <cfif len(get_assetp.department_id)>
                                        <cfinput type="text" name="department" id="department" value="#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#"  onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','add_department()');">
                                    <cfelse>
                                        <cfinput type="text" name="department" id="department" value="" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','add_department()');">
                                    </cfif>
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_assetp.department_id&field_dep_branch_name=upd_assetp.department','list','popup_list_departments');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-department2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48016.Kullanıcı Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id2" id="department_id2" value="<cfoutput>#get_assetp.department_id2#</cfoutput>" />
                                    <cfif len(get_assetp.department_id2)>
                                        <cfinput type="text" name="department2" id="department2" value="#get_branchs_deps2.branch_name# - #get_branchs_deps2.department_head#" onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_assetp','3','200');">
                                    <cfelse>
                                        <cfinput type="text" name="department2" id="department2" value=""  onFocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','upd_assetp','3','200');">
                                    </cfif>
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_assetp.department_id2&field_dep_branch_name=upd_assetp.department2&is_get_all=1','list','popup_list_departments');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item_assetp_space_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60386.Bulunduğu Yer">/<cf_get_lang dictionary_id="60371.Mekan"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="assetp_space_id" id="assetp_space_id" value="<cfoutput>#get_assetp.asset_p_space_id#</cfoutput>">
                                    <input type="hidden" name="assetp_space_code" id="assetp_space_code" value="<cfoutput>#get_assetp.space_code# /#get_assetp.space_name#</cfoutput>">
                                    <input type="text" name="assetp_space_name" id="assetp_space_name" value="<cfoutput>#get_assetp.space_name#</cfoutput>" onFocus="AutoComplete_Create('assetp_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','assetp_space_id','','3','135')">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=assetp_space_name&field_code=assetp_space_code&field_id=assetp_space_id</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_assetp.position_code#</cfoutput>" />
                                    <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_assetp.employee_id#</cfoutput>" />
                                    <input type="text" name="employee_name" id="employee_name" value="<cfif len(get_assetp.position_code)><cfoutput>#get_assetp.employee_fullname#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()')" />
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_assetp.position_code&field_name=upd_assetp.employee_name&field_emp_id=upd_assetp.emp_id&function_name=fill_department&select_list=1','list')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-position2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>2</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="position_code2" id="position_code2" value="<cfoutput>#get_assetp.position_code2#</cfoutput>" />
                                    <input type="hidden" name="member_type_2" id="member_type_2" value="<cfif isdefined('get_assetp.member_type_2')><cfoutput>#get_assetp.member_type_2#</cfoutput></cfif>" />
                                    <input type="text" name="position2" id="position2" value="<cfoutput><cfif isdefined('get_assetp.position_code2')><cfif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'employee'>#get_emp_info(get_assetp.position_code2,0,0)#<cfelseif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'partner'>#get_par_info(get_assetp.position_code2,0,0,0)#<cfelseif get_assetp.member_type_2 eq 'consumer'>#get_cons_info(get_assetp.position_code2,0,0)#</cfif></cfif></cfoutput>" onfocus="AutoComplete_Create('position2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','position_code2,position_code2,position_code2,member_type_2','','3','225');">
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_assetp.position_code2&field_name=upd_assetp.position2&field_partner=upd_assetp.position_code2&field_consumer=upd_assetp.position_code2&field_emp_id=upd_assetp.position_code2&field_type=upd_assetp.member_type_2&select_list=1,7,8&branch_related','list','popup_list_positions')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_other_money_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36493.Deger'></label>
                            <div class="col col-5 col-xs-12">
                                <input type="text" name="assetp_other_money_value" id="assetp_other_money_value" value="<cfoutput>#tlFormat(get_assetp.other_money_value)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"/>    
                            </div>
                            <div class="col col-3 col-xs-12">
                                <select name="assetp_other_money" id="assetp_other_money">
                                    <cfoutput query="get_money">
                                        <option value="#money#"<cfif money eq get_assetp.other_money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36424.Alıs Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='36424.Alıs Tarihi !'></cfsavecontent>
                                    <cfinput type="text" name="get_date" id="get_date" value="#dateformat(get_assetp.sup_company_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="get_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_exit_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_assetp.exit_date)>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='53224.Çıkış Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="get_exit_date" id="get_exit_date" value="#dateFormat(get_assetp.exit_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:75px;">
                                    <cfelse>
                                        <cfinput type="text" name="get_exit_date" id="get_exit_date" value="" validate="#validate_style#" message="#message#" style="width:75px;">
                                    </cfif>
                                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="get_exit_date"></span>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="status" id="status" value="1" <cfif get_assetp.status eq 1>checked</cfif>>
                                <cfif get_assetp.is_sales eq 1>
                                    <font color="red"><cf_get_lang dictionary_id='48409.Satışı Yapıldı'></font>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-relation_asset">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_assetp.relation_physical_asset_id)>
                                        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                            SELECT ASSETP_ID, ASSETP,IS_IT FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
                                        </cfquery>
                                        <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
                                        <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
                                    <cfelse>
                                        <cfset relation_phy_asset_id = ''>
                                        <cfset relation_phy_asset = ''>
                                    </cfif>
                                    <cfinput type="hidden" name="relation_asset_id" id="relation_asset_id" value="#get_assetp.RELATED_ASSETP_ID#">
                                    <cfinput type="text" name="relation_asset" id="relation_asset" value="#get_assetp.RELATED_ASSETP#" style="width:200px" onFocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','135');">
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=upd_assetp.relation_asset_id&field_name=upd_assetp.relation_asset&event_id=0&motorized_vehicle=0','list');"></span>
                                    <cfif len(get_assetp.RELATED_ASSETP)>
                                        <cfif get_assetp.IS_IT eq 0>
                                            <cfset link_ = "windowopen('#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#relation_phy_asset_id#','wide')">
                                        <cfelse>
                                            <cfset link_ = "windowopen('#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#relation_phy_asset_id#','wide')">
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined('link_')>
                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="<cfoutput>#link_#</cfoutput>"></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-fixtures_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58878.Demirbaş No'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="fixtures_id" id="fixtures_id" value="<cfoutput>#get_assetp.inventory_id#</cfoutput>" />
                                    <input type="text" name="fixtures_no" id="fixtures_no" value="<cfoutput>#get_assetp.inventory_number#</cfoutput>" maxlength="50" style="width:200px;" />
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=upd_assetp.fixtures_id&field_name=upd_assetp.fixtures_no&type=1','wide');"></span>                                        
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-serial_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="serial_number" value="#get_assetp.serial_no#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-special_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="special_code" value="#get_assetp.primary_code#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38901.Servis Çalışanı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_assetp.service_employee_id#</cfoutput>" />
                                    <cfif len(get_assetp.service_employee_id)>
                                        <input type="text" name="employee" id="employee" value="<cfoutput>#get_emp_info(get_assetp.service_employee_id,1,0)#</cfoutput>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');" />
                                    <cfelse>
                                        <input type="text" name="employee" id="employee" value="" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');" />
                                    </cfif>
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_assetp.employee_id&field_name=upd_assetp.employee&select_list=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_combo
                                    name="assetp_status"
                                    query_name="GET_ASSET_STATE"
                                    option_name="asset_state"
                                    option_value="asset_state_id"
                                    value="#get_assetp.assetp_status#"
                                    option_text="Seçiniz"
                                    width=200>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="assetp_group" id="assetp_group">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_assetp_groups">
                                        <option value="#group_id#" <cfif get_assetp.assetp_group eq group_id>selected</cfif>>#group_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-usage_purpose_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41759.Kullanım Amacı'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="usage_purpose_id" id="usage_purpose_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_purpose">
                                        <option value="#usage_purpose_id#" <cfif get_assetp.usage_purpose_id eq usage_purpose_id>selected</cfif>>#usage_purpose#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-make_year">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="make_year" id="make_year">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                                    <cfset model_yili = get_assetp.make_year>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <cfoutput>
                                            <option value="#i#" <cfif model_yili eq i>selected</cfif>>#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-brand_type_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#get_assetp.brand_id#</cfoutput>" />
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#get_assetp.brand_type_id#</cfoutput>" onfocus="AutoComplete_Create('brand_type_id','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID,BRAND_NAME','brand_id,brand_type_id','','3','135');" />
                                <cfif isdefined('attributes.assetp_id')>
                                <cf_wrkbrandtypecat
                                    brand_type_cat_id="#get_assetp.brand_type_cat_id#"
                                    compenent_name="getBrandTypeCat1"      
                                    brand_type_cat_name="1"         
                                    width="200"
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
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="assetp_detail" id="assetp_detail"><cfoutput>#get_assetp.assetp_detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <cfif isdefined('x_dimension') and x_dimension eq 1>
                            <div class="form-group" id="item-physical_assets">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58831.Boyutlar'></label>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" name="physical_assets_width" id="physical_assets_width"  value="<cfoutput>#get_assetp.physical_assets_width#</cfoutput>" style="width:35px;" onkeyup="FormatCurrency(this,event);" />
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" name="physical_assets_size" id="physical_assets_size" value="<cfoutput>#get_assetp.physical_assets_size#</cfoutput>" style="width:35px;" onkeyup="FormatCurrency(this,event);" />
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" name="physical_assets_height" id="physical_assets_height" value="<cfoutput>#get_assetp.physical_assets_height#</cfoutput>" style="width:35px;" onkeyup="FormatCurrency(this,event);" />
                                </div>
                                <div class="col col-2 col-xs-12">
                                    a/b/h 
                                </div>
                            </div>
                        </cfif>
                        <cfset branchCoordinates = cfc.getBranchCoordinatesById(branch_id: GET_BRANCHS_DEPS.BRANCH_ID)>
                        <div class="form-group" id="item-coordinates">
                            <cfif len(get_assetp.department_id) and not len(get_assetp.coordinate_1) and not len(get_assetp.coordinate_2)>
                                <cfif branchCoordinates.recordcount>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42307.Konum'>( <cf_get_lang dictionary_id='57453.Şube'>)</label>
                                </cfif>
                            <cfelse>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42307.Konum'></label>
                            </cfif>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_api_key.GOOGLE_API_KEY)>
                                        <cfif len(get_assetp.department_id) and not len(get_assetp.coordinate_1) and not len(get_assetp.coordinate_2)><!--- Varlığa ait koordinat yoksa, şubesine ait koordinata gidiyor. --->
                                            <cfif branchCoordinates.recordcount>
                                                <cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#branchCoordinates.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:65px;">
                                                <span class="input-group-addon"><cfoutput>#getLang('settings',670)#</cfoutput></span>
                                                <span class="input-group-addon no-bg"></span>
                                                <cfinput type="text" maxlength="10"  range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#branchCoordinates.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:65px;">
                                                <span class="input-group-addon"><cfoutput>#getLang('hr',650)#</cfoutput></span>
                                                <span class="input-group-addon no-bg"></span>
                                                <span class="input-group-addon">
                                                    <cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.list_assetp&type=upd&event=googleMap&coords=#branchCoordinates.coordinate_1#,#branchCoordinates.coordinate_2#','map_upd_box','ui-draggable-box-medium')"><i class="fa fa-map-marker"></i></a></cfoutput>
                                                </span>
                                            </cfif>
                                        <cfelse>
                                            <cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#get_assetp.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:65px;">
                                            <span class="input-group-addon"><cfoutput>#getLang('settings',670)#</cfoutput></span>
                                            <span class="input-group-addon no-bg"></span>
                                            <cfinput type="text" maxlength="10"  range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#get_assetp.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:65px;">
                                            <span class="input-group-addon"><cfoutput>#getLang('hr',650)#</cfoutput></span>
                                            <span class="input-group-addon no-bg"></span>
                                            <span class="input-group-addon">
                                                <cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.list_assetp&type=upd&event=googleMap&coords=#get_assetp.coordinate_1#,#get_assetp.coordinate_2#','map_upd_box','ui-draggable-box-medium')"><i class="fa fa-map-marker"></i></a></cfoutput>
                                            </span>
                                        </cfif>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'><cf_get_lang dictionary_id='65286.bilgilerinin girilmesi gerekiyor'>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_collective_usage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48516.Ortak Kullanım'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1"<cfif get_assetp.IS_COLLECTIVE_USAGE eq 1>checked</cfif> />
                            </div>
                        </div>
                        <div class="form-group" id="item-transfer_datee">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48119.Transfer Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="transfer_date" value="#dateformat(get_assetp.transfer_date,dateformat_style)#" validate="#validate_style#" style="width:75px;">
                                    <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="transfer_date"></span> 
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-info">
                            <label class="col col-4 col-xs-12"></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="txt"><cfif len(get_assetp.assetp_catid)><cfoutput>#trim(get_assetp.assetp_catid)#</cfoutput></cfif></cfsavecontent>
                                <cf_wrk_add_info info_type_id="-13" info_id="#attributes.assetp_id#" upd_page = "1" colspan="9" assetp_catid=#txt#>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" id="add_info_plus"><!---<cf_object_td td_style id="add_info_plus"></cf_object_td---></div>
                
                <div class="row formContentFooter">
                    <div class="col col-6 col-xs-12">
                        <cf_record_info query_name="get_assetp">
                    </div>
                    <div class="col col-6 col-xs-12">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' type_format="1" is_delete='0'>
                    </div>
                </div>
            </cf_box_elements>
            </cfform>
        </cf_box>

        <cfset attributes.asset_id = get_assetp.assetp_id>
        <cfset attributes.asset = get_assetp.assetp>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='48653.Bileşenler'></cfsavecontent>
        <cfsavecontent variable="info_title"><cf_get_lang dictionary_id='47890.Fiziki Varlık Ekle'></cfsavecontent>
        <cfsavecontent variable="info_title3"><cf_get_lang dictionary_id='48467.Varolan Fiziki Varlıkla İlişkilendir'></cfsavecontent>
        <cf_box 
            box_page="#request.self#?fuseaction=assetcare.emptypopup_relation_phsical_asset&asset_id=#attributes.assetp_id#&assetp=#attributes.asset#"
            id="list_member_rel"
            title="#message#"
            closable="0"
            unload_body="1"
            add_href="javascript:openBoxDraggable('#request.self#?fuseaction=assetcare.list_assetp&event=add&relation_assetp_id=#attributes.asset_id#');"
            info_href="javascript:openBoxDraggable('#request.self#?fuseaction=assetcare.popup_list_relation_assetp&row_assetp_id=#attributes.asset_id#');"
            info_title="#info_title#"
            info_title_3="#info_title3#">
        </cf_box>
        <!--- Yedek Parçalar --->
        <cf_box
        title="#getLang('','Yedek Parçalar','63950')#"
        box_page="#request.self#?fuseaction=assetcare.list_spare_parts&asset_id=#attributes.assetp_id#&assetp=#attributes.asset#"
        id="upd_spare"
        add_href="javascript:openBoxDraggable('#request.self#?fuseaction=assetcare.list_spare_parts&event=add&asset_p_id=#attributes.asset_id#','','ui-draggable-box-medium')"
        >

        </cf_box>
        <cfif kontrol_.recordcount>
            <cfset attributes.asset_id = get_assetp.assetp_id>
            <!---<cfinclude template="../form/upd_assetp_care_states.cfm">--->
            <cf_box 
                box_page="#request.self#?fuseaction=assetcare.upd_assetp_care_states&asset_id=#attributes.assetp_id#&assetp=#attributes.asset#"
                id="list_assetp_care"
                title="#getLang('','Bakım Planı',29682)#"
                closable="0"
                unload_body="1">
            </cf_box>
        <cfelse>
            <cfset attributes.asset_id = get_assetp.assetp_id>
            <!---<cfinclude template="../form/add_assetp_care_states.cfm">--->
            <cf_box 
                box_page="#request.self#?fuseaction=assetcare.add_assetp_care_states&asset_id=#attributes.assetp_id#&assetp=#attributes.asset#"
                id="list_assetp_care"
                title="#getLang('','Bakım Planı',29682)#"
                closable="0"
                unload_body="1">
            </cf_box>
        </cfif>
        <cfsavecontent variable="message1"><cf_get_lang dictionary_id='58020.isler'> </cfsavecontent>
        <cf_box 
            id="main_news_menu"
            title="#message1#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=objects.emptypopup_ajax_project_works&assetp_id=#attributes.assetp_id#">
        </cf_box>
    </div>
    <div class="col col-3 col-xs-12">
        <cfinclude template="../display/upd_assetp_sag.cfm">
    </div>
</div>
<script type="text/javascript">
	function kontrol()
	{
		<cfif x_control_fixtures_no eq 1>
			if(upd_assetp.fixtures_no.value != '')
				if(!paper_control(upd_assetp.fixtures_no,'FIXTURES','1',<cfoutput>'#get_assetp.assetp_id#','#get_assetp.inventory_number#','','','','#dsn#</cfoutput>')) return false;
		</cfif>
		
		if($('#property_1').is(':checked')==false && $('#property_2').is(':checked')==false && $('#property_3').is(':checked')==false && $('#property_4').is(':checked')==false)
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48063.Mülkiyet Tipi'>");
			return false;
		}
		if ($('#assetp').val()== "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29452.Varlık'> <cf_get_lang dictionary_id='57897.adı'> !");
			return false;
		}
		var x =$("#assetp_catid").prop('selectedIndex');
		if ($('#assetp_catid option')[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56930.Varlık Tipi'> !");
			return false;
		}
		if($('#get_date').val() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56996.Alım Tarihi !'>!");
			return false;
		}		
		if(!date_check(document.upd_assetp.get_date,document.upd_assetp.date_now,"<cf_get_lang dictionary_id='552.Alış Tarihini Kontrol Ediniz'>!"))
		{
			return false;
		}
		x = (250 - upd_assetp.assetp_detail.value.length);
		if(x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
			return false;
		}
		if($('#get_exit_date').val() != "")
		{
			if(!date_check(document.upd_assetp.get_date,document.upd_assetp.date_now,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
			{
				return false;
			}
		}	
		
		if($('#status').prop('checked') == true)
		{
			if($('#department').val() == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='48015.Kayıtlı Departman '> !");
				return false;
			}
			if($('#employee_name').val() == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57544.Sorumlu !'>");
				return false;
			}	
		}
		for(var i=1;i<=4;i++)
		{
			if($('#property_'+i).is(':checked')==true)
				if($('#property_'+i).val() != $('#old_property').val() )
				{
					if(confirm("<cf_get_lang dictionary_id='48504.Mülkiyet Alanındaki Değişiklik Araçtaki Belli Bilgileri Silecektir,Emin Misiniz?'>"));
					else return false;
				}
		}	
		$('#assetp_other_money_value').val( filterNum($('#assetp_other_money_value').val()) );	
		if(process_cat_control())
			if(confirm("<cf_get_lang dictionary_id='52217.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
        else
			return false;
	}
	function add_department()
	{
		if($('#department_id2').val() == "" && $('#department2').val() == "")
		{
		$('#department_id2').val() =$('#department_id').val();
		$('#department2').val() = $('#department').val();
		}
	}
	function get_assetp_sub_cat()
{
	for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
		{
				$('#assetp_sub_catid option').eq(i).remove();
		}
	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $("#assetp_catid").val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	if(get_assetp_sub_cat.recordcount > 0)	
		
	{
		var selectBox = $("#assetp_sub_catid").attr('disabled');
		if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
		$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
				$("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
			}
	}
	else{
			
		$("#assetp_sub_catid").attr('disabled','disabled');
		
	}
}
	
	function fill_department()
	{	
		<cfif x_fill_department eq 1>
			$('#department_id').val("");
			$('#department_id2').val("");
			$('#department').val("");
			$('#department2').val("");
			var member_id=$('#position_code').val();
			if(member_id!='')
			{
				var sql = "SELECT DISTINCT D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP,BRANCH B  WHERE D.BRANCH_ID = B.BRANCH_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND EP.POSITION_CODE=" + member_id;
				get_department= wrk_query(sql,'dsn');
				if($('#DEPARTMENT_ID')!='')
				{
					$('#department_id').val(get_department.DEPARTMENT_ID);
					$('#department_id2').val(get_department.DEPARTMENT_ID);
					$('#department').val(get_department.BRANCH_NAME +' - '+get_department.DEPARTMENT_HEAD);
					$('#department2').val(get_department.BRANCH_NAME +' - '+get_department.DEPARTMENT_HEAD);
				}
			}
		</cfif>
	}
	</script>
</cfif>
