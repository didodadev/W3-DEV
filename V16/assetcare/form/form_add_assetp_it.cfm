 <cf_xml_page_edit fuseact="assetcare.form_add_assetp_it">
<cfparam name="attributes.assetp_space_id" default="">
<cfinclude template="../query/get_assetp_groups.cfm">
<cfinclude template="../query/get_money.cfm">
<cf_papers paper_type="FIXTURES">
<cfif len(paper_number)>
	<cfset inventory_number = paper_code & '-' & paper_number>
<cfelse>
	<cfset inventory_number = ''>
</cfif>
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
	</cfif>
    <cfif len(get_assetp.assetp_catid)>
    <cfquery name="GET_SUB_CAT" datasource="#dsn#">
           SELECT
               ASSETP_SUB_CATID,
               ASSETP_SUB_CAT 
           FROM
               ASSET_P_SUB_CAT 
           WHERE
               ASSETP_CATID = #get_assetp.assetp_catid#
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
				DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id2# AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
	</cfif>
	<cfif len(get_assetp.sup_company_id)>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT 
				COMPANY_ID,
				TAXOFFICE,
				TAXNO,
				COMPANY_ADDRESS,
				FULLNAME
			FROM
				COMPANY
			WHERE 
				COMPANY_ID = #get_assetp.sup_company_id#
		</cfquery>
		<cfif len(get_assetp.sup_partner_id)>
            <cfquery name="GET_PARTNER" datasource="#DSN#">
                SELECT
                    PARTNER_ID,COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME
                FROM
                    COMPANY_PARTNER
                WHERE
                    PARTNER_ID= #get_assetp.sup_partner_id#
            </cfquery>
		</cfif>
	<cfelseif len(get_assetp.sup_consumer_id)>
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				COMPANY,
				CONSUMER_ID
			FROM
				CONSUMER
			WHERE
				CONSUMER_ID = #get_assetp.sup_consumer_id#
		</cfquery>		
	</cfif>    
</cfif>
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="0">
        <cfform name="add_asset_it" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_it">
            <input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-form_ul_property">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48014.Mülkiyet'></label>
                        <div class="col col-8 col-xs-12">
                            <label><input type="checkbox" name="status" id="status" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <label><input name="property" id="property_1" type="radio" value="1" onClick="showHide()" checked ><cf_get_lang dictionary_id='57449.Satın Alma'></label>
                            <label><input name="property" id="property_2" type="radio" value="2" onClick="showHide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 2>checked</cfif></cfif>><cf_get_lang dictionary_id='48065.Kiralama'></label>						
                            <label><input name="property" id="property_3" type="radio" value="3" onClick="showHide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 3>checked</cfif></cfif>><cf_get_lang dictionary_id='48066.Leasing'></label>
                            <label><input name="property" id="property_4" type="radio" value="4" onClick="showHide()" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.property eq 4>checked</cfif></cfif>><cf_get_lang dictionary_id='48067.Sözleşme'>	</label>							
                        </div>						
                    </div>
                    <div class="form-group" id="item-barcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <input type="text" name="barcode" id="barcode" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.barcode#</cfoutput></cfif>" maxlength="50">	
                            <cfelse>
                                <cfinput type="text" name="barcode" value="" maxlength="50">
                            </cfif>
                        </div>						
                    </div>  
                    <div class="form-group" id="item-form_ul_assetp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29452.Varlık Adı'>*</label>
                        <div class="col col-8 col-xs-12">						
                            <cfif isdefined('attributes.assetp_id')>
                                <input type="text" name="assetp" id="assetp" value="<cfoutput>#get_assetp.assetp#</cfoutput>" maxlength="100">
                                <cfelse>
                                <cfinput type="text" name="assetp" value="" maxlength="100">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_sup_comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47892.Alınan Şirket'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                    <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_company_id#</cfoutput></cfif>">							
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_assetp.sup_company_id) and get_assetp.sup_company_id neq 0>
                                        <input type="text" name="sup_comp_name" id="sup_comp_name" value="<cfoutput>#get_company.fullname#</cfoutput>"  onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','200');">
                                    <cfelse>
                                        <input type="text" name="sup_comp_name" id="sup_comp_name" value="<cfoutput>#get_consumer.company#</cfoutput>"  onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','200');">
                                    </cfif>
                                <cfelse>
                                    <input type="text" name="sup_comp_name" id="sup_comp_name" value=""  onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','200');">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_asset_it.sup_partner_name&field_partner=add_asset_it.sup_partner_id&field_comp_name=add_asset_it.sup_comp_name&field_comp_id=add_asset_it.sup_company_id&field_consumer=add_asset_it.sup_consumer_id&is_buyer_seller=1&select_list=2,3');"></span>																
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("attributes.assetp_id")>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0' value="#get_assetp.process_stage#">
                            <cfelse>
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                            </cfif>	
                        </div>					
                    </div>
                    <div class="form-group" id="item-form_ul_sup_partner_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="sup_partner_id"  id="sup_partner_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.sup_consumer_id#</cfoutput></cfif>">
                            <cfif isdefined('attributes.assetp_id')>
                                <cfif len(get_assetp.sup_partner_id) and isnumeric(get_assetp.sup_partner_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>">
                                <cfelseif isdefined("get_assetp.sup_consumer_id") and len(get_assetp.sup_consumer_id) and isnumeric(get_assetp.sup_consumer_id)>
                                    <input type="text" name="sup_partner_name" id="sup_partner_name" value="<cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>">
                                </cfif>
                            <cfelse>
                                <input type="text" name="sup_partner_name" id="sup_partner_name" value="">
                            </cfif>
                                <input type="hidden" name="company_partner_id" id="company_partner_id" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_assetp_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48388.Varlık Tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <cf_wrkassetcat width="200" Lang_main="322.Seciniz" it_asset="1" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="#get_assetp.assetp_catid#" onchange_action="get_assetp_sub_cat()">
                            <cfelse>
                                <cf_wrkassetcat width="200" Lang_main="322.Seciniz" it_asset="1" is_motorized="0" compenent_name="GetAssetCat3" onchange_action="get_assetp_sub_cat()">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_assetp_sub_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47876.Varlık Alt Kategorisi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_sub_catid" id="assetp_sub_catid">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfif isdefined('get_assetp.ASSETP_SUB_CATID')>
                                <cfoutput query="GET_SUB_CAT">
                                    <option value="#ASSETP_SUB_CATID#" <cfif isdefined('attributes.assetp_id') and GET_SUB_CAT.ASSETP_SUB_CATID eq get_assetp.ASSETP_SUB_CATID> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                </cfoutput>
                            </cfif>
                            </select>						
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48015.Kayıtlı Departman'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.department_id#</cfoutput></cfif>">
                                <input type="text" name="department" id="department" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_assetp.department_id)><cfoutput>#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#</cfoutput></cfif></cfif>" onfocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','add_asset_it','3','200','add_department()');">
                                <span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_asset_it.department_id&field_dep_branch_name=add_asset_it.department&is_store_module=1&is_get_all=1','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id ="item-form_ul_department2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48016.Kullanıcı Departman'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id2" id="department_id2" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.department_id2#</cfoutput></cfif>">
                                <input type="text" name="department2" id="department2" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_assetp.department_id2)><cfoutput>#get_branchs_deps2.branch_name# - #get_branchs_deps2.department_head#</cfoutput></cfif></cfif>" onfocus="AutoComplete_Create('department2','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id2','add_asset_it','3','200');">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_asset_it.department_id2&field_dep_branch_name=add_asset_it.department2&is_get_all=1','','ui-draggable-box-small');"></span>						
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_assetp_space_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60386.Bulunduğu Yer">/<cf_get_lang dictionary_id="60371.Mekan"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_space_id" id="assetp_space_id">
                                <input type="text" name="assetp_space_name" id="assetp_space_name" value="" onFocus="AutoComplete_Create('assetp_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','assetp_space_id','','3','135')">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=assetp_space_name&field_id=assetp_space_id</cfoutput>','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.position_code#</cfoutput></cfif>">
                                <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isdefined('attributes.assetp_id') and len(get_assetp.employee_id)><cfoutput>#get_emp_info(get_assetp.employee_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_asset_it.position_code&field_name=add_asset_it.employee_name&field_emp_id=add_asset_it.emp_id</cfoutput>&function_name=fill_department&select_list=1&branch_related=1')"></span>							
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_position2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.position_code2#</cfoutput></cfif>" />
                                <input type="hidden" name="member_type_2" id="member_type_2" value="<cfif isdefined('get_assetp.member_type_2')><cfoutput>#get_assetp.member_type_2#</cfoutput></cfif>" />
                                <input type="text" name="position2" id="position2" value="<cfoutput><cfif isdefined('get_assetp.position_code2')><cfif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'employee'>#get_emp_info(get_assetp.position_code2,0,0)#<cfelseif len(get_assetp.member_type_2) and get_assetp.member_type_2 eq 'partner'>#get_par_info(get_assetp.position_code2,0,0,0)#<cfelseif get_assetp.member_type_2 eq 'consumer'>#get_cons_info(get_assetp.position_code2,0,0)#</cfif></cfif></cfoutput>">
                                <span class="input-group-addon  icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_asset_it.position_code2&field_name=add_asset_it.position2&field_emp_id=add_asset_it.position_code2&field_partner=add_asset_it.position_code2&field_consumer=add_asset_it.position_code2&field_type=add_asset_it.member_type_2&select_list=1,7,8&branch_related=')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_assetp_other_money">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48562.Deger'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="assetp_other_money_value" id="assetp_other_money_value" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#tlFormat(get_assetp.other_money_value)#</cfoutput></cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));">
                                <span class="input-group-addon width">                             
                                    <select name="assetp_other_money" id="assetp_other_money">
                                        <cfoutput query="get_money"> 
                                            <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>		
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_is_collective_usage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48516.Ortak Kullanım'></label>
                        <div class="col xol-8 col-xs-12">
                            <input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1"><cfif isdefined('attributes.assetp_id')><cfif get_assetp.IS_COLLECTIVE_USAGE eq 1>checked</cfif></cfif>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div id="rent" column_width_list="100,250" style="display:none;">
                        <div class="form-group" id="item-form_ul_rent_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48204.Kira Tutarı'>(<cf_get_lang dictionary_id='48406.KDV Dahil'>)</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="rent_amount" id="rent_amount" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#TLFormat(get_assetp.rent_amount)#</cfoutput></cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon width">            
                                        <select name="rent_amount_currency" id="rent_amount_currency">
                                            <cfoutput query="get_money"> 
                                                <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-form_ul_rent_payment_period">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48205.Ödeme Periyodu'></label>
                            <div class="col col-8 col-xs-12">
                            <select name="rent_payment_period" id="rent_payment_period">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='58458.Haftalık'></option>
                                <option value="2"><cf_get_lang dictionary_id='58932.Aylık'></option>
                                <option value="3"><cf_get_lang dictionary_id='48206.3 Aylık'></option>
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
                    <div id="outsource" column_width_list="100,250"  style="display:none;">			
                        <div class="form-group" id="item-form_ul_is_care_added">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48215.Bakım Masrafı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="col col-4 col-xs-12">
                                        <label><input name="is_care_added" id="is_care_added" type="radio" value="0" onclick="showHide(care);" 
                                            <cfif isdefined('attributes.assetp_id')><cfif get_assetp.is_care_added eq 0>checked</cfif></cfif> />
                                            <cf_get_lang dictionary_id='48213.Hariç'>
                                        </label>
                                    </div>									
                                    <div class="col col-4 col-xs-12">
                                        <label><input name="is_care_added" id="is_care_added" type="radio" value="2" onclick="showHide(care);" 
                                            <cfif isdefined('attributes.assetp_id')><cfif get_assetp.is_care_added eq 2>checked</cfif></cfif> />
                                                <cf_get_lang dictionary_id='48407.Limitsiz'>
                                        </label>
                                    </div>									
                                    <div class="col col-4 col-xs-12">
                                        <label><input name="is_care_added" id="is_care_added" type="radio" value="1" onclick="showHide(care);" 
                                            <cfif isdefined('attributes.assetp_id')><cfif get_assetp.is_care_added eq 1>checked</cfif></cfif> />
                                            <cf_get_lang dictionary_id='48214.Dahil'>
                                        </label>
                                    </div>									      
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="care" style="display:none;">
                            <div class="col col-4 col-xs-12"></div>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="care_amount" id="care_amount" value=" <cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.care_amount#</cfoutput></cfif>" class="moneybox" onkeyup="FormatCurrency(this,event);">
                                    <span class="input-group-addon">
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
                    <div class="form-group" id="item-form_ul_relation_asset">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfif len(get_assetp.relation_physical_asset_id)>
                                        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                            SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
                                        </cfquery>
                                        <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
                                        <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
                                    <cfelse>
                                        <cfset relation_phy_asset_id = ''>
                                        <cfset relation_phy_asset = ''>
                                    </cfif>
                                </cfif>
                                <input type="hidden" name="relation_asset_id" id="relation_asset_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#relation_phy_asset_id#</cfoutput></cfif>">
                                <input type="text" name="relation_asset" id="relation_asset" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#relation_phy_asset#</cfoutput></cfif>" onfocus="AutoComplete_Create('relation_asset','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id,relation_asset','','3','135');">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_asset_it.relation_asset_id&field_name=add_asset_it.relation_asset&event_id=0&motorized_vehicle=0');"></span>
                            </div>						
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_inventory_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58878.Demirbaş No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(paper_number)>
                                <cfinput type="text" name="inventory_number" id="inventory_number" value="#inventory_number#" maxlength="40" readonly>
                            <cfelse>
                                <input type="text" name="inventory_number" id="inventory_number" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.inventory_number#</cfoutput></cfif>" maxlength="50">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_serial_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <input type="text" name="serial_number" id="serial_number" maxlength="50" value="<cfoutput>#get_assetp.serial_no#</cfoutput>" >
                            <cfelse>
                                <cfinput type="text" name="serial_number" maxlength="50" value="" >                	
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_special_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.assetp_id')>
                                <input type="text" name="special_code" id="special_code" value="<cfoutput>#get_assetp.primary_code#</cfoutput>" maxlength="50">
                            <cfelse>
                                <cfinput type="text" name="special_code" value="" maxlength="50">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47898.Servis Çalışanı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.service_employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.assetp_id')><cfif len(get_assetp.service_employee_id)><cfoutput>#get_emp_info(get_assetp.service_employee_id,1,0)#</cfoutput></cfif></cfif>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_asset_it.employee_id&field_name=add_asset_it.employee&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_asset_state">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'>*</label>
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
                    <div class="form-group" id="item-form_ul_assetp_group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_group" id="assetp_group">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_assetp_groups">
                                    <option value="#group_id#" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.assetp_group eq group_id>selected</cfif></cfif>>#group_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_usage_purpose_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47901.Kullanım Amacı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="usage_purpose_id" id="usage_purpose_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_purpose">
                                    <option value="#usage_purpose_id#" <cfif isdefined('attributes.assetp_id')><cfif get_assetp.usage_purpose_id eq usage_purpose_id>selected</cfif></cfif>>#usage_purpose#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_make_year">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="make_year" id="make_year">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                                <cfif isdefined('attributes.assetp_id')>
                                    <cfset model_yili = get_assetp.make_year>
                                </cfif>
                                <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <option value="#i#" <cfif isdefined('attributes.assetp_id')><cfif model_yili eq i>selected</cfif></cfif>>#i#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_brand_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.brand_id#</cfoutput></cfif>">
                            <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.brand_type_id#</cfoutput></cfif>">
                            <cfif isdefined('attributes.assetp_id')>
                                <cf_wrkbrandtypecat
                                    brand_type_cat_id="#get_assetp.brand_type_cat_id#"
                                    compenent_name="getBrandTypeCat3"      
                                    brand_type_cat_name="1"         
                                    width="200"
                                    boxwidth="240"
                                    boxheight="150">  
                            <cfelse>
                                <cf_wrkbrandtypecat
                                    compenent_name="getBrandTypeCat3"
                                    brand_type_cat_name="1"          
                                    width="200"
                                    boxwidth="200"
                                    boxheight="150">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_assetp_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="assetp_detail" id="assetp_detail"><cfif isdefined('attributes.assetp_id')><cfoutput>#get_assetp.assetp_detail#</cfoutput></cfif></textarea>						
                        </div>
                    </div>
                    <div class="form-group" id="item-form_ul_start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47893.Alis Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined('attributes.assetp_id')>
                                    <input type="text" name="start_date" id="start_date" value="<cfoutput>#dateformat(get_assetp.sup_company_date,dateformat_style)#</cfoutput>" maxlength="10" validate="#validate_style#">
                                <cfelse>
                                    <cfinput type="text" name="start_date" id="start_date" value="" maxlength="10" validate="#validate_style#">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>	
                    </div>		
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
//window.onload = function () { showHide(item-care_amount); } 

showHide();


function kontrol()
{
	if (document.add_asset_it.assetp.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29452.Varlık'> <cf_get_lang dictionary_id='57897.Adı'> !");
		return false;
	}
	
	if(document.add_asset_it.sup_comp_name.value =="" && document.add_asset_it.sup_partner_name.value =="" )
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47892.Alınan Şirket'> !");
		return false;
	}
	
	x = document.add_asset_it.assetp_catid.selectedIndex;
	if (document.add_asset_it.assetp_catid[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48388.Varlık Tipi'> !");
		return false;
	}
			
	if(document.add_asset_it.department.value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='48015.Kayıtlı Departman '> !");
		return false;
	}
	
	if(document.add_asset_it.start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47893.Alım Tarihi !'>!");
		return false;
	}
	if(document.getElementById('status').checked == true)
    {

		/*if($('#emp_id').val()=='' || $('#employee_name').val() == '')
		{
			alert("<cf_get_lang dictionary_id='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='132.Sorumlu !'>");
			return false;
		}*/

		if($('#assetp_status').val() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57756.Durum '>!");
			return false;
		}  
    }
        if($('#department2').val() == "")
            {
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='48016.Kullanıcı Departman'>!");
			    return false;
            }
	
	if(!CheckEurodate(document.add_asset_it.start_date.value,"<cf_get_lang dictionary_id='47893.Alış tarihi'>"))
	{
		return false;
	}
	
	if(!date_check(document.add_asset_it.start_date,document.add_asset_it.date_now,"<cf_get_lang dictionary_id ='48423.Alış Tarihini Kontrol Ediniz'>!"))
	{
		return false;
	}

	x = (250 - add_asset_it.assetp_detail.value.length);
	if(x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	
	if(document.add_asset_it.property[1].checked == true)
	{			
		document.add_asset_it.rent_amount.value = filterNum(document.add_asset_it.rent_amount.value);
	}
	
	if(document.add_asset_it.property[3].checked == true)
	{			
		document.add_asset_it.rent_amount.value = filterNum(document.add_asset_it.rent_amount.value);
		document.add_asset_it.care_amount.value = filterNum(document.add_asset_it.care_amount.value);			
	}
	document.add_asset_it.assetp_other_money_value.value = filterNum(document.add_asset_it.assetp_other_money_value.value);	
	if(process_cat_control())
		if(confirm("<cf_get_lang dictionary_id='29914.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
	else
		return false;
}

function add_department()
{
	if(document.add_asset_it.department_id2.value == "" && document.add_asset_it.department2.value == "")
	{
	document.add_asset_it.department_id2.value = document.add_asset_it.department_id.value;
	document.add_asset_it.department2.value = document.add_asset_it.department.value;
	}
} 

function change_depot()
{
	document.add_asset_it.department_id2.value = document.add_asset_it.department_id.value;
	document.add_asset_it.department2.value = document.add_asset_it.department.value;
}
function showHide()
{
	if(document.add_asset_it.property[0].checked)
	{
		gizle(outsource);
		gizle(rent);
		document.add_asset_it.care_amount.value = "" ;
		document.add_asset_it.rent_amount.value = "" ;
		document.add_asset_it.rent_start_date.value = "" ;
		document.add_asset_it.rent_finish_date.value = "" ;
		document.add_asset_it.is_care_added[0].checked = true;
		document.add_asset_it.is_fuel_added[0].checked = true;
		document.add_asset_it.rent_payment_period[0].selected = true;
	}
	if(document.add_asset_it.property[1].checked)
	{
		gizle(outsource);
		goster(rent);
		document.add_asset_it.care_amount.value = "" ;
	}
	if(document.add_asset_it.property[2].checked)
	{
		gizle(outsource);
		gizle(rent);
		document.add_asset_it.care_amount.value = "" ;
		document.add_asset_it.rent_amount.value = "" ;
		document.add_asset_it.rent_start_date.value = "" ;
		document.add_asset_it.rent_finish_date.value = "" ;
		document.add_asset_it.is_care_added[0].checked.value = true ;
		document.add_asset_it.is_fuel_added[0].checked.value = true ;
		document.add_asset_it.rent_payment_period[0].selected = true;
	}
	if(document.add_asset_it.property[3].checked)
	{
		goster(outsource);
		goster(rent);
	}
	
	if(document.add_asset_it.is_care_added[0].checked)
	{
		gizle(care);
		document.add_asset_it.care_amount.value = "" ;
		document.add_asset_it.care_amount_currency.selectedIndex = "";
	}
	if(document.add_asset_it.is_care_added[1].checked)
	{
		gizle(care);
		document.add_asset_it.care_amount.value = "" ;
		document.add_asset_it.care_amount_currency.selectedIndex = "";
	}
	if(document.add_asset_it.is_care_added[2].checked)
	{
		goster(care);
	}
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
			var member_id=$('#emp_id').val();
		if(member_id!='')
		{
			var sql = "SELECT DISTINCT D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP,BRANCH B  WHERE D.BRANCH_ID = B.BRANCH_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND EP.IS_MASTER=1 AND EMPLOYEE_ID=" + member_id;
			get_department= wrk_query(sql,'dsn');
			if(get_department.DEPARTMENT_ID!='' && get_department.DEPARTMENT_ID!='undefined')
			{
					$('#department_id').val(get_department.DEPARTMENT_ID);
					$('#department_id2').val(get_department.DEPARTMENT_ID);
					$('#department').val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
					$('#department2').val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
			}
		}
	</cfif>
}
</script>
