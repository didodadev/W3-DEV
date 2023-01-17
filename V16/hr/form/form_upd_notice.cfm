<cfinclude template="../query/get_notice.cfm">
<cfif not GET_NOTICE.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='35509.Olmayan bir ilana erişmeye çalışıyorsunuz'>");
		history.go(-1);
	</script>
</cfif>
<cfinclude template="../query/get_notice_apps.cfm">
<!--- <cfif len(get_notice.POSITION_ID)>
	<cfquery name="get_position_name" datasource="#dsn#">
		SELECT
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.POSITION_CODE = #get_notice.POSITION_ID#
	</cfquery>
	<cfset app_position = "#get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#">
<cfelse>
	<cfset app_position = "">
</cfif> --->
		
<!--- <cfif len(get_notice.POSITION_CAT_ID)>
	<cfset attributes.POSITION_CAT_ID = get_notice.POSITION_CAT_ID>
	<cfinclude template="../query/get_position_cat.cfm">
	<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
<cfelse>
	<cfset POSITION_CAT = "">
</cfif> --->
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <div class="col col-9 col-xs-12">
        <cf_box>
            <cfform name="upd_notice" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_notice" enctype="multipart/form-data">
                <input type="Hidden" name="notice_id" id="notice_id" value="<cfoutput>#notice_id#</cfoutput>">
                <cfif not len(get_notice.valid)>
                    <input type="Hidden" name="valid" id="valid" value="">
                </cfif>
                <!--- Sayfa ana kısım  --->               
                <cf_box_elements>
                    <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-notice_no">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55250.İlan No'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55250.ilan no'></cfsavecontent>
                                <cfinput type="text" name="notice_no" id="notice_no" required="yes" value="#get_notice.notice_no#" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-notice_head">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55761.İlan Başlığı'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <input type="text" name="notice_head" id="notice_head" maxlength="100" value="<cfoutput>#get_notice.notice_head#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group" id="item-pif_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56204.Personel İstek Formu'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <cfif len(GET_NOTICE.PIF_ID)>
                                    <cfquery name="GET_PIF_LIST" datasource="#DSN#">
                                        SELECT
                                            PERSONEL_REQUIREMENT_HEAD
                                        FROM
                                            PERSONEL_REQUIREMENT_FORM
                                        WHERE
                                            PERSONEL_REQUIREMENT_ID=#GET_NOTICE.pif_id#
                                    </cfquery>
                                </cfif>
                                    <input type="hidden" name="pif_id" id="pif_id" value="<cfoutput>#GET_NOTICE.PIF_ID#</cfoutput>">
                                    <cfif isdefined("GET_PIF_LIST")>
                                        <cfinput type="text" name="pif_name" id="pif_name" value="#GET_PIF_LIST.PERSONEL_REQUIREMENT_HEAD#">
                                    <cfelse>
                                        <cfinput type="text" name="pif_name" id="pif_name" value="" readonly>
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_personel_requirement&field_id=upd_notice.pif_id&field_name=upd_notice.pif_name</cfoutput>','list');" title="<cf_get_lang dictionary_id='55146.Seçim Listesi Seç'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-position_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <input type="Hidden" name="POSITION_CAT_ID" id="POSITION_CAT_ID" value="<cfoutput>#get_notice.position_cat_id#</cfoutput>">
                                    <cfinput type="text" name="POSITION_CAT" id="POSITION_CAT" value="#get_notice.POSITION_CAT_NAME#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=upd_notice.POSITION_CAT_ID&field_cat=upd_notice.POSITION_CAT','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-app_position">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <input type="Hidden" name="POSITION_ID" id="POSITION_ID" value="<cfoutput>#get_notice.POSITION_ID#</cfoutput>" maxlength="50">
                                    <cfinput type="text" name="app_position" id="app_position" value="#get_notice.POSITION_NAME#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_notice.POSITION_ID&field_pos_name=upd_notice.app_position&field_dep_name=upd_notice.department&field_dep_id=upd_notice.department_id&field_branch_name=upd_notice.branch&field_branch_id=upd_notice.branch_id&field_comp=upd_notice.our_company&field_comp_id=upd_notice.our_company_id&show_empty_pos=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <cfif len(get_notice.department_id) and len(get_notice.branch_id) and len(get_notice.our_company_id)>
                            <cfquery name="get_branch" datasource="#dsn#">
                                SELECT 
                                    BRANCH.BRANCH_NAME,
                                    DEPARTMENT.DEPARTMENT_HEAD,
                                    OUR_COMPANY.NICK_NAME
                                FROM 
                                    DEPARTMENT,
                                    BRANCH,
                                    OUR_COMPANY
                                WHERE 
                                    OUR_COMPANY.COMP_ID=#get_notice.our_company_id# AND
                                    BRANCH.BRANCH_ID= #get_notice.branch_id# AND
                                    DEPARTMENT_ID = #get_notice.department_id#
                            </cfquery>
                        </cfif>
                        <div class="form-group" id="item-department">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
                            <div class="col col-9 col-xs-12"> 
                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_notice.department_id#</cfoutput>">
                                <input type="text" name="department" id="department" value="<cfif isdefined('get_branch') and get_branch.recordcount><cfoutput>#get_branch.department_head#</cfoutput></cfif>" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-interview_position">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55597.Bağlantı kurulacak Kişi'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <input type="Hidden" name="interview_position_code" id="interview_position_code" value="<cfoutput>#get_notice.interview_position_code#</cfoutput>">
                                    <input type="hidden" name="interview_par" id="interview_par" value="<cfoutput>#get_notice.interview_par#</cfoutput>">
                                    <cfif len(get_notice.interview_position_code)>
                                        <cfset attributes.position_code = get_notice.interview_position_code>
                                        <cfset attributes.employee_id = "">
                                        <cfinclude template="../query/get_position.cfm">
                                        <cfset pos2_temp = "#get_position.employee_name# #get_position.employee_surname#">
                                    <cfelseif len(get_notice.interview_par)>
                                        <cfquery name="get_partner_" datasource="#dsn#">
                                            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_notice.interview_par#
                                        </cfquery>
                                        <cfset pos2_temp = "#get_partner_.company_partner_name# #get_partner_.company_partner_surname#">
                                    <cfelse>
                                        <cfset pos2_temp = "">
                                    </cfif>
                                    <cfinput type="text" name="interview_position" id="interview_position" value="#pos2_temp#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_notice.interview_position_code&field_emp_name=upd_notice.interview_position&field_partner=upd_notice.interview_par&field_name=upd_notice.interview_position','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-publish">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55516.Yayın Alanı'></label>
                            <div class="col col-3 col-xs-12"> 
                                <label><input type="checkbox" name="publish" id="publish" value="1" <cfif get_notice.publish contains "1">checked</cfif>><cf_get_lang dictionary_id='55435.İnternet'></label>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <label><input type="checkbox" name="publish" id="publish" value="2" <cfif get_notice.publish contains "2">checked</cfif>><cf_get_lang dictionary_id='29659.Intranet'></label>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <label><input type="checkbox" name="publish" id="publish" value="3" <cfif get_notice.publish contains "3">checked</cfif>><cf_get_lang dictionary_id='58019.Extranet'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-view_logo">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'></label>
                            <div class="col col-4 col-xs-12"> 
                                <label><input type="checkbox" name="view_logo" id="view_logo" value="1" <cfif get_notice.is_view_logo eq 1>checked</cfif>> (<cf_get_lang dictionary_id='56314.Görünsün'>) - <cf_get_lang dictionary_id='57574.Şirket'></label> 
                            </div>
                            <div class="col col-4 col-xs-12">
                                <label><input type="checkbox" name="view_company_name" id="view_company_name" value="1" <cfif get_notice.is_view_company_name eq 1>checked</cfif>> (<cf_get_lang dictionary_id='56314.Görünsün'>)</label>
                            </div>
                        </div>
                        <div class="form-group" id="item-view_visual_notice">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56315.Görsel İlan'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <input type="file" name="visual_notice" id="visual_notice">
                                    <cfinput type="hidden" name="del_visual_notice" id="del_visual_notice" value="">
                                    <span class="input-group-addon" href="javascript://" id="val_del_visual" name="val_del_visual" onclick="del_visual_notice();"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></span>                                  
                                </div>   
                                <label>
                                    <input type="checkbox" name="view_visual_notice" id="view_visual_notice" value="1" <cfif get_notice.view_visual_notice eq 1>checked</cfif>> (<cf_get_lang dictionary_id='56314.Görünsün'>)&nbsp;
                                    <cfif len(get_notice.visual_notice)>
                                        <cf_get_server_file output_file="hr/#get_notice.visual_notice#" output_server="#get_notice.SERVER_VISUAL_NOTICE_ID#" output_type="2" image_link="1">
                                    </cfif>
                                </label> 
                            </div>
                        </div>
                        <div class="form-group" id="item-dates">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="31639.Yayın Tarihi"></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55161.Yayın Başlangıç Tarihi girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" value="#dateformat(get_notice.startdate,dateformat_style)#" name="startdate" id="startdate" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55160.yayın bitiş girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" value="#dateformat(get_notice.finishdate,dateformat_style)#" name="finishdate" id="finishdate" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"> </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-onaylandi">
                            <label class="col col-12 bold">
                                <span class="hide"><cf_get_lang dictionary_id="30925.Onay durumu"></span>
                                <cfif get_notice.valid eq 1>
                                    <cf_get_lang dictionary_id='58699.Onaylandı'>!
                                    <cfif len(get_notice.valid_emp)>
                                        <cfset attributes.employee_id = get_notice.valid_emp>
                                        <cfinclude template="../query/get_hr_name.cfm">
                                        <cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname# - #dateformat(get_notice.valid_date,dateformat_style)# (#timeformat(get_notice.valid_date,timeformat_style)#)</cfoutput>
                                    <cfelseif len(get_notice.valid_par)>
                                        <cfoutput>#get_par_info(get_notice.valid_par,0,0,0)# - #dateformat(get_notice.valid_date,dateformat_style)# (#timeformat(get_notice.valid_date,timeformat_style)#)</cfoutput>
                                    </cfif>
                                <cfelseif get_notice.valid eq 0>
                                    <cf_get_lang dictionary_id='57617.Reddedildi'> !
                                    <cfif len(get_notice.valid_emp)>
                                        <cfset attributes.employee_id = get_notice.valid_emp>
                                        <cfinclude template="../query/get_hr_name.cfm">
                                        <cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname# - #dateformat(get_notice.valid_date,dateformat_style)# (#timeformat(get_notice.valid_date,timeformat_style)#)</cfoutput>
                                    <cfelseif len(get_notice.valid_par)>
                                        <cfoutput>#get_par_info(get_notice.valid_par,0,0,0)# - #dateformat(get_notice.valid_date,dateformat_style)# (#timeformat(get_notice.valid_date,timeformat_style)#)</cfoutput>
                                    </cfif>
                                <cfelseif get_notice.validator_position_code eq session.ep.position_code>
                                    <div style="width:30px;height:15px;display:flex;margin-bottom:20px;">
                                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cf_get_lang dictionary_id="31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz?">')) {upd_notice.valid.value='1'} else {return false}" border="0" style="height:15px;" />
                                        <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cf_get_lang dictionary_id="31576.Onaylamakta olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz?"> ?')) {upd_notice.valid.value='0'} else {return false}" border="0" style="height:15px;" />
                                    </div>
                                </cfif>
                            </label>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-status">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <div class="col col-9 col-xs-12"> 
                                <input type="checkbox" name="status" id="status" value="1" <cfif get_notice.status eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-status_notice">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <div class="col col-9 col-xs-12"> 
                            <cf_workcube_process is_upd='0' process_cat_width='150' select_value='#get_notice.status_notice#' is_detail='1'>
                                <!--- <select name="status_notice" id="status_notice">
                                    <option value="-1" <cfif get_notice.status_notice eq -1>selected</cfif>><cf_get_lang dictionary_id='56203.Hazırlık'></option>
                                    <option value="-2" <cfif get_notice.status_notice eq -2>selected</cfif>><cf_get_lang dictionary_id='29479.Yayın'></option>					
                                </select> --->
                            </div>
                        </div>
                        <div class="form-group" id="item-staff_count">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56205.Kadro Sayısı'></label>
                            <div class="col col-9 col-xs-12"> 
                                <cfinput type="text" validate="integer" name="staff_count" id="staff_count" value="#get_notice.count_staff#" message="#getLang('','Kadro Sayısını Giriniz',35507)#!">
                            </div>
                        </div>
                        <div class="form-group" id="item-company">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <input type="hidden" id="company_id" value="<cfoutput>#get_notice.company_id#</cfoutput>" name="company_id">
                                    <input type="text" id="company" name="company" value="<cfif len(get_notice.company_id)><cfoutput>#get_par_info(get_notice.company_id,1,0,0)#</cfoutput></cfif>" maxlength="100">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_notice.company_id&field_comp_name=upd_notice.company&select_list=7','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-our_company">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                            <div class="col col-9 col-xs-12"> 
                                <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined('get_branch.nick_name')><cfoutput>#get_notice.our_company_id#</cfoutput></cfif>">
                                <input type="text" name="our_company" id="our_company" value="<cfif isdefined('get_branch.nick_name')><cfoutput>#get_branch.nick_name#</cfoutput></cfif>">
                            </div>
                        </div>
                        <div class="form-group" id="item-branch">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-9 col-xs-12"> 
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_notice.branch_id#</cfoutput>">
                                <input type="text" name="branch" id="branch" value="<cfif isdefined('get_branch') and get_branch.recordcount><cfoutput>#get_branch.branch_name#</cfoutput></cfif>" readonly>
                            </div>
                        </div>
                        <cfif not len(get_notice.valid)>
                            <div class="form-group" id="item-validator_position">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55282.Onaylayacak'>*</label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="Hidden" name="validator_position_code" id="validator_position_code" value="<cfoutput>#get_notice.validator_position_code#</cfoutput>">
                                        <input type="hidden" name="validator_par" id="validator_par" value="<cfoutput>#get_notice.validator_par#</cfoutput>">
                                        <cfif len(get_notice.validator_position_code)>
                                            <cfset attributes.position_code = get_notice.validator_position_code>
                                            <cfset attributes.employee_id = "">
                                            <cfinclude template="../query/get_position.cfm">
                                            <cfset pos3_temp = "#get_position.employee_name# #get_position.employee_surname#">
                                        <cfelseif len(get_notice.validator_par)>
                                            <cfquery name="get_partner_" datasource="#dsn#">
                                                SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_notice.validator_par#
                                            </cfquery>
                                            <cfset pos3_temp = "#get_partner_.company_partner_name# #get_partner_.company_partner_surname#">
                                        <cfelse>
                                            <cfset pos3_temp = "">
                                        </cfif>
                                        <cfinput type="text" name="validator_position" id="validator_position" value="#pos3_temp#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_notice.validator_position_code&field_emp_name=upd_notice.validator_position&field_partner=upd_notice.validator_par&field_name=upd_notice.validator_position','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-city">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56209.Çalışılacak İller'></label>
                            <div class="col col-9 col-xs-12"> 
                                <cfquery name="get_city" datasource="#dsn#">
                                    SELECT CITY_ID, CITY_NAME, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
                                </cfquery>
                                <select name="city" id="city" multiple>
                                    <option value="" <cfif not len(get_notice.notice_city)>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>			
                                    <option value="0" <cfif listfind(get_notice.notice_city,0,',')>selected</cfif>><cf_get_lang dictionary_id="31704.Tüm Türkiye"></option>			
                                    <cfoutput query="get_city">
                                        <option value="#city_id#" <cfif listfind(get_notice.notice_city,get_city.city_id,',')>selected</cfif>>#city_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-notice_cat_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='56510.İlan Grubu'></label>
                            <div class="col col-9 col-xs-12"> 
                                <cf_wrk_combo 
                                    name="notice_cat_id"
                                    id="notice_cat_id"
                                    query_name="GET_NOTICE_GROUP"
                                    option_name="notice"
                                    value=#get_notice.notice_cat_id#
                                    option_value="notice_cat_id"
                                    width="150">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_elements vertical="1">
                    <div class="col col-12 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-work_detail">
                            <label class="bold"><cf_get_lang dictionary_id='56206.İşin Tanımı'></label> 
                            <textarea name="work_detail" id="work_detail"><cfoutput>#get_notice.work_detail#</cfoutput></textarea>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarSet="WRKContent"
                                    basePath="/fckeditor/"
                                    instanceName="detail"
                                    valign="top"
                                    value="#get_notice.detail#"
                                    width="550"
                                    height="320">                           
                        </div>
                    </div>
                </cf_box_elements>                            
                <cf_box_footer>	
                    <div class="col col-6">
                        <cf_record_info query_name="get_notice">
                    </div> 
                    <div class="col col-6">
                        <cfif GET_NOTICE_APPS.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' delete_page_url = '#request.self#?fuseaction=hr.emptypopup_del_notice&notice_id=#attributes.notice_id#'>
                        </cfif>    
                    </div> 
                </cf_box_footer>                       
            </cfform>   
        </cf_box>
    </div> 
    <div class="col col-3 col-xs-12"> 
        <cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='NOTICE_ID' action_id='#attributes.notice_id#'>
    </div>
</div>
<script type="text/javascript">
function del_visual_notice()
	{
		document.getElementById('visual_notice').style.display='';	
		$('#del_visual_notice').val(1);	
		upd_notice.visual_notice.value='';
	}
function kontrol()
{
	/*if(document.getElementById('notice_cat_id').value == "")
	{
		alert("<cf_get_lang no ='1443.Lütfen İlan Grubu Seçiniz'>.");
		return false;
	}*/
	if (document.getElementById('app_position').value.length == 0) document.getElementById('POSITION_ID').value = "";
	if (document.getElementById('POSITION_CAT').value.length == 0) document.getElementById('POSITION_CAT_ID').value = "";

	if ((document.getElementById('work_detail').value.length)>1000)
	{
		alert("<cf_get_lang dictionary_id='56207.İş tanımı 1000 karakterden fazla olamaz'>!");
		return false;
	}
		
	if ((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
	return date_check(document.upd_notice.startdate,document.upd_notice.finishdate,"<cf_get_lang dictionary_id='56208.Başlama Tarihi Bitiş Tarihinden küçük olmalıdır'> !"); 
}
</script>

