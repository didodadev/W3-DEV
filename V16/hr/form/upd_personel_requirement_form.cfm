<cf_xml_page_edit>
<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.per_req_id_ = attributes.per_req_id>
<cfif ListFirst(attributes.fuseaction,'.') is 'myhome'>
    <cfset attributes.per_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_req_id,accountKey:'wrk')>
</cfif>
<cfquery name="get_per_req" datasource="#dsn#">
    SELECT
        PERSONEL_REQUIREMENT_ID
      ,PERSONEL_REQUIREMENT_HEAD
      ,OUR_COMPANY_ID
      ,DEPARTMENT_ID
      ,BRANCH_ID
      ,POSITION_CAT_ID
      ,POSITION_ID
      ,IS_APP
      ,IS_NEW_POS_APP
      ,PERSONEL_COUNT
      ,PERSONEL_DETAIL
      ,REQUIREMENT_REASON
      ,PERSONEL_EXP
      ,PERSONEL_AGE
      ,PERSONEL_ABILITY
      ,PERSONEL_PROPERTIES
      ,PERSONEL_LANG
      ,PERSONEL_OTHER
      ,MIN_SALARY
      ,MIN_SALARY_MONEY
      ,MAX_SALARY
      ,MAX_SALARY_MONEY
      ,PERSONEL_START_DATE
      ,REQUIREMENT_EMP
      ,TRAINING_LEVEL
      ,PER_REQ_STAGE
      ,RECORD_EMP
      ,RECORD_DATE
      ,RECORD_IP
      ,UPDATE_EMP
      ,UPDATE_DATE
      ,UPDATE_IP
      ,REQUIREMENT_PAR_ID
      ,REQUIREMENT_CONS_ID
      ,REQUIREMENT_EMP_POS_CODE
      ,VEHICLE_REQ
      ,VEHICLE_REQ_MODEL
      ,LICENCECAT_ID
      ,OLD_PERSONEL_NAME
      ,OLD_PERSONEL_POSITION
      ,OLD_PERSONEL_FINISHDATE
      ,OLD_PERSONEL_DETAIL
      ,FORM_TYPE
      ,REQUIREMENT_DATE
      ,WORK_START
      ,WORK_FINISH
      ,CHANGE_PERSONEL_POSITION
      ,CHANGE_PERSONEL_NAME
      ,CHANGE_PERSONEL_POSITION_NEW
      ,CHANGE_PERSONEL_FINISHDATE
      ,TRANSFER_PERSONEL_NAME
      ,TRANSFER_PERSONEL_POSITION
      ,TRANSFER_PERSONEL_BRANCH_NEW
      ,TRANSFER_PERSONEL_POSITION_NEW
      ,TRANSFER_PERSONEL_STARTDATE
      ,IS_SHOW
      ,REQ_NUMBER
      ,CHANGE_POSITION_ID
      ,CHANGE_PERSONEL_POSITION_NEW_ID
      ,TRANSFER_POSITION_ID
      ,TRANSFER_PERSONEL_BRANCH_NEW_ID
      ,TRANSFER_PERSONEL_POSITION_NEW_ID
      ,IS_FINISHED
      ,SEX
      ,LANGUAGE
      ,LANGUAGE_ID
      ,KNOWLEVEL_ID
      ,RELATED_FORMS
      ,PERSONEL_EMPLOYEE_ID
      ,PERSONAL_AGE_MIN
      ,PERSONAL_AGE_MAX
      ,IS_STAFF
      ,IS_OUTSOURCE
      ,IS_FULLTIME
      ,IS_HALFTIME
      ,IS_SHIFT
      ,IS_FOREIGN_LANG_EXAM
      ,IS_ORGANIZATION_CHANGE
      ,IS_VOLUME_OF_BUSINESS
      ,VOLUME_BUSINESS_MIN
      ,VOLUME_BUSINESS_MAX
      ,IS_NEW_PROJECT
      ,IS_NUMBER_OF_TRANSACTIONS
      ,TRANSACTION_NUMBER_MIN
      ,TRANSACTION_NUMBER_MAX
      ,ADDITIONAL_STAFF_DETAIL
      ,DEMAND_POSITION_ID
    FROM 
        PERSONEL_REQUIREMENT_FORM 
    WHERE 
        PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_req_id#"> 
</cfquery>
<cfif not get_per_req.recordcount>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfinclude template="../query/get_edu_level.cfm">
    <cfinclude template="../query/get_driverlicence.cfm">
    <cfinclude template="../query/get_languages.cfm">
    <cfinclude template="../query/get_know_levels.cfm">
    <cfif len(get_per_req.our_company_id) and len(get_per_req.branch_id) and len(get_per_req.department_id)>
        <cfquery name="get_department_info" datasource="#dsn#">
            SELECT 
                OUR_COMPANY.NICK_NAME,
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_HEAD
            FROM 
                OUR_COMPANY
                INNER JOIN BRANCH ON OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                INNER JOIN DEPARTMENT ON BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
            WHERE 
                OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.our_company_id#"> AND
                BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.branch_id#"> AND
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.department_id#">
        </cfquery>
    </cfif>
    <cfset app_position = "">
    <cfif len(get_per_req.position_id)>
        <cfquery name="get_position_name" datasource="#dsn#">
            SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.position_id#">
        </cfquery>
        <cfset app_position = "#get_position_name.position_name#">
    </cfif>
    <cfset position_cat = "">
    <cfif len(get_per_req.position_cat_id)>
        <cfset attributes.position_cat_id = get_per_req.position_cat_id>
        <cfinclude template="../query/get_position_cat.cfm">
        <cfset position_cat = "#get_position_cat.position_cat#">
    </cfif>
    <cfinclude template="../query/get_moneys.cfm">
    <cfquery name="get_relation_assign" datasource="#dsn#">
        SELECT PERSONEL_ASSIGN_ID FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_REQ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_req_id#">
    </cfquery>
<cf_catalystHeader>
    <cfform name="upd_form" method="post" action="" enctype="multipart/form-data">
        <!---Sol Kısım--->
        <div class="col col-9 col-xs-12">
            <cf_box title="#getLang('myhome',581,'Personel Taleplerim')#">
                <cfif x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
                    <!--- Islem Detayi, Yetkililer Disindaki Kullanicilarda Display Olarak Goruntulensin, Kaydeden Kisi Display Olarak Gormesin --->
                    <cfinclude template="../display/dsp_personel_requirement_form.cfm">
                <cfelse>
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <div class="col col-6 col-xs-12" type="column" sort="true" index="1">
                            <div class="form-group" id="item-Talep">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                <div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#get_per_req.per_req_stage#' process_cat_width='150' is_detail='1'></div>
                            </div>
                            <div class="form-group" id="item-req_head">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Baslik'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" id="per_req_id" value="<cfoutput>#attributes.per_req_id_#</cfoutput>" name="per_req_id">
                                    <input type="hidden" id="circuitDet" value="<cfoutput>#ListFirst(attributes.fuseaction,'.')#</cfoutput>" name="circuitDet">
                                    <cfif isDefined("x_display_change_head") and x_display_change_head eq 1><cfset readonly_ = ""><cfelse><cfset readonly_ = "yes"></cfif>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfsavecontent>
                                    <cfinput type="text" name="req_head" id="req_head" required="yes" message="#message#" readonly="#readonly_#" maxlength="100" style="width:456px;" value="#get_per_req.PERSONEL_REQUIREMENT_HEAD#">
                                </div>
                            </div>
                            <div class="form-group" id="item-our_company">
                                <cfoutput> <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Sirket'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="hidden" name="our_company_id" id="our_company_id" value="#get_per_req.our_company_id#">
                                        <input type="text" name="our_company" id="our_company" value="<cfif isDefined('get_department_info')>#get_department_info.nick_name#</cfif>" readonly>
                                    </div></cfoutput>
                            </div>
                            <div class="form-group" id="item-our_branch">
                                <cfoutput>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Sube'> /<cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-4 col-xs-12">
                                        <input type="hidden" name="branch_id" id="branch_id" value="#get_per_req.branch_id#">
                                        <input type="text" name="branch" id="branch" value="<cfif isDefined('get_department_info')>#get_department_info.branch_name#</cfif>" readonly>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="department_id" id="department_id" value="#get_per_req.department_id#">
                                            <input type="text" name="department" id="department" value="<cfif isDefined('get_department_info')>#get_department_info.department_head#</cfif>" readonly>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=myhome.popup_list_departments&field_id=upd_form.department_id&field_name=upd_form.department&field_branch_name=upd_form.branch&field_branch_id=upd_form.branch_id&field_our_company=upd_form.our_company&field_our_company_id=upd_form.our_company_id','list');"></span>
                                        </div>
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="form-group" id="item-is_staff">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55441.Kadro"></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-4 col-xs-6"><label><input type="checkbox" name="is_staff" value="1"<cfif get_per_req.is_staff eq 1>checked</cfif>> <cf_get_lang dictionary_id="38671.Kadrolu"></label></div>
                                    <div class="col col-4 col-xs-6"><label><input type="checkbox" name="is_outsource" value="1"<cfif get_per_req.is_outsource eq 1>checked</cfif>><cf_get_lang dictionary_id="30439.Dış Kaynak"></label></div>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_fulltime">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53415.Çalışma Saatleri"></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_fulltime" value="1"<cfif get_per_req.is_fulltime eq 1>checked</cfif>><cf_get_lang dictionary_id="38669.Tam zamanlı"></label></div>
                                    <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_halftime" value="1"<cfif get_per_req.is_halftime eq 1>checked</cfif>> <cf_get_lang dictionary_id="38668.Yarı Zamanlı"></label></div>
                                    <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_shift" value="1"<cfif get_per_req.is_shift eq 1>checked</cfif>><cf_get_lang dictionary_id="58545.Vardiyalı"></label></div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" sort="true" index="2">
                            <div class="form-group" id="item-position_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="Hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#get_per_req.position_cat_id#</cfoutput>">
                                        <cfinput type="text" name="position_cat" id="position_cat" value="#position_cat#" readonly="yes">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=upd_form.position_cat_id&field_cat=upd_form.position_cat','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-position_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                                    <cfset demand_position_name =' '>
                                <cfif len(get_per_req.demand_position_id)>
                                    <cfset attributes.POSITION_CODE = get_per_req.demand_position_id>
                                    <cfinclude template="../query/get_position.cfm">
                                    <cfset demand_position_name = get_position.position_name>
                                </cfif>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="demand_position_id" id="demand_position_id" value="<cfoutput>#get_per_req.position_cat_id#</cfoutput>">
                                        <cfinput type="text" name="demand_position_name" id="demand_position_name" value="#demand_position_name#" readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=upd_form.demand_position_id&field_pos_name=upd_form.demand_position_name&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-personel_count">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55283.Talep Edilen Kisi Sayisi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='56221.Kadro Sayısını Rakam Olarak Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="personel_count" id="personel_count" value="#get_per_req.PERSONEL_COUNT#" validate="integer" required="yes" range="1,99" message="#message#" maxlength="2" onKeyUp="ısNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-requirement_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55285.Talep Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55285.Talep Tarihi'>!</cfsavecontent>
                                        <cfinput type="text" name="requirement_date" id="requirement_date" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.REQUIREMENT_DATE,dateformat_style)#" required="yes">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="requirement_date"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif len(get_per_req.requirement_emp)>
                                <cfset isim = '#get_emp_info(get_per_req.requirement_emp,0,0,0)#'>
                            <cfelseif len(get_per_req.requirement_par_id)>
                                <cfset isim = '#get_par_info(get_per_req.requirement_par_id,0,0,0)#'>
                            <cfelseif len(get_per_req.requirement_cons_id)>
                                <cfset isim = '#get_cons_info(get_per_req.requirement_cons_id,0,0)#'>
                            <cfelse>
                                <cfset isim = ''>
                            </cfif>
                            <div class="form-group" id="item-requirement_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56219.Istekte Bulunan'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="requirement_member_type" id="requirement_member_type" value="">
                                            <input type="hidden" name="requirement_member_id" id="requirement_member_id" value="#get_per_req.requirement_emp#">
                                            <input type="hidden" name="requirement_partner_id" id="requirement_partner_id" value="#get_per_req.requirement_par_id#">
                                            <input type="hidden" name="requirement_consumer_id" id="requirement_consumer_id" value="#get_per_req.requirement_cons_id#">
                                            <input type="hidden" name="requirement_pos_code" id="requirement_pos_code" value="#get_per_req.requirement_emp_pos_code#">
                                        </cfoutput>
                                        <cfinput type="text" name="requirement_name" id="requirement_name" value="#isim#" readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_code=upd_form.requirement_pos_code&field_name=upd_form.requirement_name&field_type=upd_form.requirement_member_type&field_emp_id=upd_form.requirement_member_id&field_partner=upd_form.requirement_partner_id&field_consumer=upd_form.requirement_consumer_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif x_related_forms eq 1>
                                <div class="form-group" id="item-related_forms">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55119.Ölçme Degerlendirme Formu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfquery name="get_emp_quizes" datasource="#dsn#">
                                            SELECT QUIZ_ID,QUIZ_HEAD FROM EMPLOYEE_QUIZ WHERE IS_SHOW = 1
                                        </cfquery>
                                        <select name="related_forms" id="related_forms" multiple>
                                            <cfoutput query="get_emp_quizes">
                                                <option value="#quiz_id#" <cfif listfind(get_per_req.related_forms,quiz_id)>selected</cfif>>#quiz_head#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55297.Talep Edilen Kişi Özellikleri"></cfsavecontent>
                        <cf_seperator id="talep_edilen_kisi_ozellikleri" title="#message#">
                        <div id="talep_edilen_kisi_ozellikleri">
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="3">
                                <cfif x_show_sex_info eq 1>
                                    <div class="form-group" id="item-sex">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="sex" id="sex" value="0" <cfif ListFind(get_per_req.sex,0)>checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'></label></div>
                                            <div class="col col-6 col-xs-6"> <label><input type="radio" name="sex" id="sex" value="1" <cfif ListFind(get_per_req.sex,1)>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'></label></div>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-training_level">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55495.Egitim Durumu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput query="get_edu_level">
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="training_level" id="training_level" value="#get_edu_level.edu_level_id#" <cfif edu_level_id eq get_per_req.training_level>checked</cfif>> #get_edu_level.education_name#</label></div>
                                        </cfoutput>
                                    </div>
                                </div>
                                <cfif x_show_language_info eq 1>
                                    <div class="form-group" id="item-language">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55218.Yabanci Dil Bilgisi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="language" id="language" value="1" <cfif ListFind(get_per_req.language,1)>checked</cfif> onclick="lang_info(1);"><cf_get_lang dictionary_id='58564.Var'></label></div>
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="language" id="language" value="0" <cfif ListFind(get_per_req.language,0)>checked</cfif> onclick="lang_info(0);"><cf_get_lang dictionary_id='58546.Yok'></label></div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="language_info" <cfif ListFind(get_per_req.language,0)>style="display:none;"</cfif>>
                                        <div class="col col-4 col-xs-12"><label class="hide"><cf_get_lang dictionary_id='55218.Yabanci Dil Bilgisi'><cfoutput>#getLang('report',31)#</cfoutput></label></div>
                                        <div class="col col-8 col-xs-12">
                                            <table id="table_lang" class="workDevList" name="table_lang" cellpadding="1" cellspacing="0">
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='55216.Yabancı Dil'></td>
                                                    <td><cf_get_lang dictionary_id='56192.Seviye'></td>
                                                    <td><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#ListLen(get_per_req.language_id)#</cfoutput>">
                                                        <a href="javascript://" onClick="add_row();"><i class="fa fa-plus"  title="Ekle"></i></a>
                                                    </td>
                                                </tr>
                                                <cfif get_per_req.language eq 1 and ListLen(get_per_req.language_id)>
                                                <cfloop from="1" to="#ListLen(get_per_req.language_id)#" index="li">
                                                    <cfif ListGetAt(get_per_req.language_id,li,',') neq 0>
                                                        <input type="hidden" value="1" id="row_kontrol<cfoutput>#li#</cfoutput>" name="row_kontrol<cfoutput>#li#</cfoutput>">
                                                        <tr id="frm_row<cfoutput>#li#</cfoutput>">
                                                            <td><select name="language_id" id="language_id<cfoutput>#li#</cfoutput>">
                                                                    <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                                    <cfoutput query="get_languages">
                                                                        <option value="#language_id#" <cfif ListGetAt(get_per_req.language_id,li,',') eq language_id>selected</cfif>>#language_set#</option>
                                                                    </cfoutput>
                                                                </select>
                                                            </td>
                                                            <td><select name="knowlevel_id" id="knowlevel_id<cfoutput>#li#</cfoutput>">
                                                                    <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                                    <cfoutput query="know_levels">
                                                                        <option value="#knowlevel_id#" <cfif ListGetAt(get_per_req.knowlevel_id,li,',') eq knowlevel_id>selected</cfif>>#knowlevel#</option>
                                                                    </cfoutput>
                                                                </select>
                                                            </td>
                                                            <td><a style="cursor:pointer" onClick="sil('<cfoutput>#li#</cfoutput>');"><i class="fa fa-minus" align="absmiddle" border="0" alt="Sil"></a></td>
                                                        </tr>
                                                    </cfif>
                                                </cfloop>
                                                </cfif>
                                            </table>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-personal_age">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55308.Yas Araligi'></label>
                                    <div class="col col-3 col-xs-2">
                                        <select	name="personal_age_min" id="personal_age_min">
                                            <option value=""></option>
                                            <cfloop from="16" to="60" index="x">
                                                <cfoutput>
                                                <option value="#x#" <cfif get_per_req.personal_age_min is x>selected</cfif>>#x#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <label><cf_get_lang dictionary_id ="30022.ile"></label>
                                    <div class="col col-3 col-xs-2">
                                        <select	name="personal_age_max" id="personal_age_max">
                                            <option value=""></option>
                                            <cfloop from="16" to="60" index="y">
                                                <cfoutput>
                                                <option value="#y#"<cfif get_per_req.personal_age_max is y>selected</cfif>>#y#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <label><cf_get_lang dictionary_id='55215.Arasinda'></label>
                                </div>
                                <div class="form-group" id="item-personel_exp">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55309.Bu Alandaki Is Tecrübesi (Yil)'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text"  name="personel_exp" id="personel_exp" maxlength="200"value="<cfoutput>#get_per_req.PERSONEL_EXP#</cfoutput>">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="4">
                                <div class="form-group" id="item-startdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55154.Ise Baslama Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58499.Göreve Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
                                            <cfif len(get_per_req.personel_start_date)>
                                                <cfinput type="text" name="startdate" id="startdate" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.PERSONEL_START_DATE,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="startdate" id="startdate" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                        
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-driverlicence">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55334.Ehliyet'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput query="get_driverlicence">
                                            <div class="col col-3 col-xs-4"><label><input type="checkbox" name="driver_licence_type" id="driver_licence_type" value="#licencecat_id#" <cfif len(get_per_req.licencecat_id) and listfindnocase(get_per_req.licencecat_id,licencecat_id)>checked</cfif>>#licencecat#</label></div>
                                        </cfoutput>
                                    </div>
                                </div>
                                <div class="form-group" id="item-vehicle_req">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-6"><label><input type="radio" value="1" name="vehicle_req" id="vehicle_req" <cfif get_per_req.vehicle_req eq 1>checked</cfif> onclick="arac_talebi();"><cf_get_lang dictionary_id='58564.Var'></label></div>
                                            <div class="col col-6 col-xs-6"> <label><input type="radio" value="0" name="vehicle_req" id="vehicle_req" <cfif get_per_req.vehicle_req eq 0>checked</cfif> onclick="arac_talebi();"><cf_get_lang dictionary_id='58546.Yok'></label></div>
                                    </div>
                                </div>
                                <div class="form-group" id="arac_modeli"  <cfif get_per_req.vehicle_req eq 0>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33567.Araç Modeli'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="vehicle_req_model" id="vehicle_req_model" value="<cfoutput>#get_per_req.vehicle_req_model#</cfoutput>" maxlength="100" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-personel_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55344.Diger Nitelikler'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla Karakter Sayısı'></cfsavecontent>
                                        <textarea name="personel_detail" id="personel_detail" onKeyUp="CheckLen(this,500);"><cfoutput>#get_per_req.PERSONEL_DETAIL#</cfoutput></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55370.İhtiyaç Gerekçeleri"></cfsavecontent>
                        <cf_seperator id="ihtiyac_gercekleri" title="#message#">
                        <div id="ihtiyac_gercekleri">
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="5">
                                <div class="form-group" id="item-form_type">
                                    <div class="col col-12">
                                        <label><input type="radio" name="form_type" id="form_type" value="2" <cfif get_per_req.form_type eq 2>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55436.Ek Kadro Süresiz'></label>
                                        <label><input type="radio" name="form_type" id="form_type" value="6" <cfif get_per_req.form_type eq 6>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55449.Ek Kadro Süreli'></label>
                                        <label><input type="radio" name="form_type" id="form_type" value="1" <cfif get_per_req.form_type eq 1>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55433.Ayrılan Kişinin Yerine'></label>
                                        <label><input type="radio" name="form_type" id="form_type" value="4" <cfif get_per_req.form_type eq 4>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55481.Nakil Olan Personelin Yerine'></label>
                                        <label><input type="radio" name="form_type" id="form_type" value="3" <cfif get_per_req.form_type eq 3>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55451.Pozisyon Değişikliği Yapan Personelin Yerine'></label>
                                        <label><input type="radio" name="form_type" id="form_type" value="5" <cfif get_per_req.form_type eq 5>checked</cfif> onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55488.Emeklilik Nedeniyle Çıkış / Giriş Yapan Personelin Yerine'></label>                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="6">
                                <div class="form-group" id="belirsiz_header">
                                    <label class="bold col col-12"><cf_get_lang dictionary_id='55536.Belirli Süreli Çalisan ise'></label>
                                </div>
                                <div class="form-group" id="belirsiz_1">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalisma Baslangiç'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55554.Çalışma Başlangıç Girmelisiniz'></cfsavecontent>
                                            <cfif len(get_per_req.work_start)>
                                                <cfinput type="text" name="work_start" id="work_start" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.work_start,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="work_start" id="work_start" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="work_start"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="belirsiz_2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalisma Bitis'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55567.Çalışma Bitiş Girmelisiniz'></cfsavecontent>
                                            <cfif len(get_per_req.work_finish)>
                                                <cfinput type="text" name="work_finish" id="work_finish" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.work_finish,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="work_finish" id="work_finish" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="work_finish"></span>
                                        </div>
                                    </div>
                                </div>
                                <div id="ek_kadro" <cfif listfindnocase('2,6',get_per_req.form_type,',')>style="display:none"</cfif>>
                                    <div class="form-group" id="item-is_organization_change">
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6 col-xs-6">
                                                <label><input type="checkbox" name="is_organization_change" value="1" <cfif get_per_req.is_organization_change eq 1>checked="checked"</cfif>/> <cf_get_lang dictionary_id="38665.Organizasyon Değişikliği"></label>
                                            </div>
                                            <div class="col col-6 col-xs-6">
                                                <label><input type="checkbox" name="is_new_project" value="1" <cfif get_per_req.is_new_project eq 1>checked="checked"</cfif>> <cf_get_lang dictionary_id="38660.Yeni Projeler"></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-volume_of_business">
                                        <label class="col col-4 col-xs-12"><input type="checkbox" name="is_volume_of_business" value="1" <cfif get_per_req.is_volume_of_business eq 1>checked="checked"</cfif>> <cf_get_lang dictionary_id="38661.İş hacmi artışı">% </label>
                                        <div class="col col-4 col-sm-6 col-xs-12">
                                            <input type="text" name="volume_business_min" value="<cfoutput>#get_per_req.volume_business_min#</cfoutput>" placeholder="'den">
                                        </div>
                                        <div class="col col-4 col-sm-6 col-xs-12">
                                                <input type="text" name="volume_business_max" value="<cfoutput>#get_per_req.volume_business_max#</cfoutput>" placeholder="'e">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-number_of_transactions">
                                        <label class="col col-4 col-xs-12"><input type="checkbox" name="is_number_of_transactions" value="1"<cfif get_per_req.is_number_of_transactions eq 1>checked</cfif>/> <cf_get_lang dictionary_id="38659.İşlem adedi artışı"> </label>
                                        <div class="col col-4 col-sm-6 col-xs-12">
                                            <input type="text" name="transaction_number_min" value="<cfoutput>#get_per_req.transaction_number_min#</cfoutput>" placeholder="<cf_get_lang dictionary_id="38657.adetten">">
                        
                                        </div>
                                        <div class="col col-4 col-sm-6 col-xs-12">
                                            <input type="text" name="transaction_number_max" value="<cfoutput>#get_per_req.transaction_number_max#</cfoutput>" placeholder="<cf_get_lang dictionary_id="38653.adede">">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-additional_staff_detail">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                                        <div class="col col-8 col-xs-12">
                                            <textarea name="additional_staff_detail"><cfoutput>#get_per_req.additional_staff_detail#</cfoutput></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55489.İlgili Pozisyondaki Çalışan Bilgileri"></cfsavecontent>
                        <cf_seperator id="ilgili_header_" title="#message#">
                        <div id="ilgili_header_">
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="6">
                                <div class="form-group" id="item-old_personel_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                                        <div class="col col-4 col-xs-4">
                                            <input type="text" name="old_personel_name" id="old_personel_name"  maxlength="200" value="<cfoutput>#get_per_req.old_personel_name#</cfoutput>">
                                        </div>
                                        <div class="col col-4 col-xs-4">
                                            <div class="input-group">
                                                <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_per_req.position_id#</cfoutput>">
                                                <input type="hidden" name="personel_employee_id" id="personel_employee_id" value="<cfoutput>#get_per_req.personel_employee_id#</cfoutput>">
                                                <input type="text" name="old_personel_position" id="old_personel_position" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.old_personel_position#</cfoutput>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=upd_form.old_personel_name&field_code=upd_form.position_id&field_emp_name=upd_form.old_personel_name&field_emp_id=upd_form.personel_employee_id&field_pos_name=upd_form.old_personel_position&field_dep_name=upd_form.department&field_dep_id=upd_form.department_id&field_branch_name=upd_form.branch&field_branch_id=upd_form.branch_id&field_comp=upd_form.our_company&field_comp_id=upd_form.our_company_id&show_empty_pos=1','list');"></span>
                                            </div>
                                        </div>
                                </div>
                                <div class="form-group" id="ilgili_2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55332.Ayrilma Nedeni'></label>
                                    <div class="col col-8 col-xs-12">
                                            <div class="col col-4 col-xs-12"><label><input type="radio" value="İstifa" name="old_personel_detail" id="old_personel_detail" <cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'İstifa')>checked</cfif> onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang no='423.İstifa'></label></div>
                                            <div class="col col-4 col-xs-12"><label><input type="radio" value="Fesih" name="old_personel_detail" id="old_personel_detail" <cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Fesih')>checked</cfif> onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang no='424.Fesih'></label></div>
                                            <div class="col col-4 col-xs-12"><label><input type="radio" value="Nakil" name="old_personel_detail" id="old_personel_detail" <cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Nakil')>checked</cfif> onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang no='425.Nakil'></label></div>
                                            <div class="col col-4 col-xs-12"><label><input type="radio" value="Emeklilik" name="old_personel_detail" id="old_personel_detail" <cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Emeklilik')>checked</cfif> onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang_main no='1129.Emeklilik'></label></div>
                                            <div class="col col-4 col-xs-12"><label><input type="radio" value="Diğer" name="old_personel_detail" id="old_personel_detail" <cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Diğer')>checked</cfif> onclick="if(this.checked){goster(personel_detail_other_info);}"><cf_get_lang_main no='744.Diğer'></label></div>
                                    </div>
                                </div>
                                <div class="form-group" id="personel_detail_other_info" style="display:none;">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55513.Diger ise Nedeni'></label>
                                    <div class="col col-8 col-xs-12"><input type="text" name="old_personel_detail" id="old_personel_detail" value="<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Diğer') and listlen(get_per_req.old_personel_detail) eq 2><cfoutput>#listgetat(get_per_req.old_personel_detail,2)#</cfoutput></cfif>" style="width:150px;" maxlength="75"></div>
                                </div>
                                <div class="form-group" id="ilgili_3">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55517.Isten Ayrilma Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55517.Isten Ayrılma Tarihi'></cfsavecontent>
                                            <cfif len(get_per_req.old_personel_finishdate)>
                                                <cfinput type="text" name="old_personel_finishdate" id="old_personel_finishdate" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.old_personel_finishdate,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="old_personel_finishdate" id="old_personel_finishdate" style="width:150px;" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="old_personel_finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="nakil_header">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id='55524.Nakil Olan Personelin'></label>
                                </div>
                                <div class="form-group" id="nakil_1">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                                        <div class="col col-4 col-xs-4">
                                            <input type="text" name="transfer_personel_name" id="transfer_personel_name" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.transfer_personel_name#</cfoutput>">
                                        </div>
                                        <div class="col col-4 col-xs-4">
                                            <div class="input-group">
                                                <input type="Hidden" name="transfer_position_id" id="transfer_position_id" value="<cfoutput>#get_per_req.transfer_position_id#</cfoutput>">
                                                <input type="text" name="transfer_personel_position" id="transfer_personel_position" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.transfer_personel_position#</cfoutput>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=upd_form.transfer_personel_name&field_code=upd_form.transfer_position_id&field_pos_name=upd_form.transfer_personel_position&show_empty_pos=1','list');"></span>
                                            </div>
                                        </div>
                                </div>
                                <div class="form-group" id="nakil_2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55525.Yeni Subesi / Pozisyonu'></label>
                                        <div class="col col-4 col-xs-4">
                                            <input type="text" name="transfer_personel_branch_new" id="transfer_personel_branch_new" maxlength="200" value="<cfoutput>#get_per_req.transfer_personel_branch_new#</cfoutput>">
                                        </div>
                                        <div class="col col-4 col-xs-4">
                                            <div class="input-group">
                                                <input type="Hidden" name="transfer_personel_branch_new_id" id="transfer_personel_branch_new_id" value="<cfoutput>#get_per_req.transfer_personel_branch_new_id#</cfoutput>">
                                                <input type="Hidden" name="transfer_personel_position_new_id" id="transfer_personel_position_new_id" value="<cfoutput>#get_per_req.transfer_personel_position_new_id#</cfoutput>">
                                                <input type="text" name="transfer_personel_position_new" id="transfer_personel_position_new" maxlength="200" value="<cfoutput>#get_per_req.transfer_personel_position_new#</cfoutput>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_form.transfer_personel_position_new_id&field_pos_name=upd_form.transfer_personel_position_new&field_branch_name=upd_form.transfer_personel_branch_new&field_branch_id=upd_form.transfer_personel_branch_new_id&show_empty_pos=1','list');"></span>
                                            </div>
                                        </div>
                                </div>
                                <div class="form-group" id="nakil_3">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55526.Nakil Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55526.Nakil Tarihi">!</cfsavecontent>
                                            <cfif len(get_per_req.transfer_personel_startdate)>
                                                <cfinput type="text" name="transfer_personel_startdate" id="transfer_personel_startdate" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.transfer_personel_startdate,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="transfer_personel_startdate" id="transfer_personel_startdate" style="width:150px;" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="transfer_personel_startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="position_header">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id='55519.Pozisyon Degisikligi Yapan Personelin'></label>
                                </div>
                                <div class="form-group" id="position_1">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                                        <div class="col col-4 col-xs-4">
                                            <input type="text" name="change_personel_name" id="change_personel_name" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.change_personel_name#</cfoutput>">
                                        </div>
                                        <div class="col col-4 col-xs-4">
                                            <div class="input-group">
                                                <input type="Hidden" name="change_position_id" id="change_position_id" value="<cfoutput>#get_per_req.change_position_id#</cfoutput>">
                                                <input type="text" name="change_personel_position" id="change_personel_position" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.change_personel_position#</cfoutput>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=upd_form.change_personel_name&field_code=upd_form.change_position_id&field_pos_name=upd_form.change_personel_position&show_empty_pos=1','list');"></span>
                                            </div>
                                        </div>
                                </div>
                                <div class="form-group" id="position_2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55523.Yeni Pozisyonu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="change_personel_position_new_id" id="change_personel_position_new_id" value="<cfoutput>#get_per_req.change_personel_position_new_id#</cfoutput>">
                                            <input type="text" name="change_personel_position_new" id="change_personel_position_new" style="width:150px;" maxlength="200" value="<cfoutput>#get_per_req.change_personel_position_new#</cfoutput>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=upd_form.change_personel_position_new_id&field_cat=upd_form.change_personel_position_new','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="position_3">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55839.Onay Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55839.Onay Tarihi'></cfsavecontent>
                                            <cfif len(get_per_req.change_personel_finishdate)>
                                                <cfinput type="text" name="change_personel_finishdate" id="change_personel_finishdate" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(get_per_req.change_personel_finishdate,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="change_personel_finishdate" id="change_personel_finishdate" style="width:150px;" validate="#validate_style#" message="#message#" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="change_personel_finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55572.Diğer Bilgiler"></cfsavecontent>
                        <cf_seperator id="diger_bilgiler" title="#message#">
                        <div id="diger_bilgiler">
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="8">
                                <div class="form-group" id="item-is_foreign_lang_exam">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="38652.Yabancı Dil Sınavı"></label>
                                    <div class="col col-8 col-xs-12">
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="is_foreign_lang_exam" value="1"<cfif get_per_req.is_foreign_lang_exam eq 1>checked</cfif>> <cf_get_lang dictionary_id="38651.Uygulansın"></label></div>
                                            <div class="col col-6 col-xs-6"><label><input type="radio" name="is_foreign_lang_exam" value="0"<cfif get_per_req.is_foreign_lang_exam eq 0>checked</cfif>> <cf_get_lang dictionary_id="38650.Uygulanmasın"></label></div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-requirement_reason">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayisi'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56225.Kadro Talebinin Gerekçesi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="requirement_reason" id="requirement_reason" style="width:456px;height:50px;" onKeyUp="CheckLen(this,500)"><cfoutput>#get_per_req.requirement_reason#</cfoutput></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="item-personel_ability">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56227.Özel Yetenekler'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="personel_ability" id="personel_ability" style="width:456px;height:50px;" onKeyUp="CheckLen(this,200)"><cfoutput>#get_per_req.personel_ability#</cfoutput></textarea>
                                    </div>
                                </div>
                                <cfif x_show_language_info eq 0>
                                    <div class="form-group" id="item-personel_lang">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56228.Lisan Bilgisi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <textarea name="personel_lang" id="personel_lang" style="width:456px;height:50px;" onKeyUp="CheckLen(this,200)"><cfoutput>#get_per_req.personel_lang#</cfoutput></textarea>
                                        </div>
                                    </div>
                                </cfif>
                            </div>
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="9">
                                <div class="form-group" id="item-personel_properties">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56229.Sosyal Fiziki Psikolojik Özellikler'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="personel_properties" id="personel_properties" onKeyUp="CheckLen(this,200)"><cfoutput>#get_per_req.personel_properties#</cfoutput></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="item-min_salary">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56230.Vereilebilecek Min Brüt Ücret'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput name="min_salary" id="min_salary" validate="float" value="#TLFormat(get_per_req.min_salary)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                            <span class="input-group-addon width">
                                                <select	name="min_salary_money" id="min_salary_money">
                                                    <cfoutput query="get_moneys">
                                                        <option <cfif get_per_req.min_salary_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                                    </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-max_salary">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56231.Verilebilecek Max Brüt Ücret'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput name="max_salary" id="max_salary" validate="float" value="#TLFormat(get_per_req.max_salary)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                            <span class="input-group-addon width">
                                                <select	name="max_salary_money" id="max_salary_money">
                                                    <cfoutput query="get_moneys">
                                                        <option <cfif get_per_req.max_salary_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                                    </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55571.Görüş Ve Onay"></cfsavecontent>
                        <cf_seperator id="gorus_ve_onaylar" title="#message#">
                        <div id="gorus_ve_onaylar">
                            <div class="col col-6 col-xs-12" type="column" sort="true" index="7">
                                <div class="form-group" id="item-Gorus">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56016.Görüs'>*</label>
                                    <div class="col col-8 col-xs-12"><textarea name="personel_other" id="personel_other"  onKeyUp="CheckLen(this,500)"><cfoutput>#get_per_req.personel_other#</cfoutput></textarea></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6 col-xs-12">
                            <cf_record_info query_name="get_per_req">
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cfif len(get_per_req.is_finished) and not ListFind(x_detail_change_personel,session.ep.userid)>
                                <label class="col col-12 font-red"><cfif get_per_req.is_finished eq 1><cf_get_lang dictionary_id='55182.Talebin Süreci Tamamlanmıştır'>.<cfelse><cf_get_lang dictionary_id='55186.Talep Reddedilmiştir'>.</cfif></label>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.emptypopup_del_personel_requirement_form&per_req_id=#attributes.per_req_id#&cat=#get_per_req.per_req_stage#&head=#get_per_req.personel_requirement_head#' add_function='kontrol()'>
                            </cfif>
                        </div>
                    </cf_box_footer>
                </cfif>
            </cf_box>
        </div>
    
        <!---Sağ Kısım--->
        <div class="col col-3 col-xs-12 uniqueRow">
            <cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='PER_REQ_ID' action_id='#attributes.per_req_id#'>
            <cf_get_workcube_note action_section='per_req_id' action_id='#attributes.per_req_id#' is_open_det='#iif(x_note_upd eq 0,0,1)#'>
        </div>
    </cfform>
    <script language="JavaScript">
        function CheckLen(Target,limit) 
        {
            StrLen = Target.value.length;
            if (StrLen == 1 && Target.value.substring(0,1) == " ") 
            {
                Target.value = "";
                StrLen = 0;
            }
            if (StrLen > limit ) 
            {
                Target.value = Target.value.substring(0,limit);
                CharsLeft = 0;
                alert("<cf_get_lang dictionary_id ='58774.Maksimum açıklama uzunluğu'>" + ":" + limit);
            }
            else 
            {
                CharsLeft = StrLen;
            }
        }
        
        row_count="<cfoutput>#ListLen(get_per_req.language_id,',')#</cfoutput>";
        function add_row()
        {
            row_count++;
            var newRow;
            var newCell;
        
            newRow = document.getElementById('table_lang').insertRow();
            newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);
            
            document.getElementById('record_num').value=row_count;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><select name="language_id" style="width:150px;"><option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<select name="knowlevel_id" style="width:150px;"><option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="Sil"></a>';							
        }
        function sil(sy)
        {
            var my_element=eval("upd_form.row_kontrol"+sy);
            my_element.value=0;
           
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
            var language_id_ = eval("upd_form.language_id"+sy);
            var knowlevel_id_ = eval("upd_form.knowlevel_id"+sy);
            language_id_.value = 0;
            knowlevel_id_.value= 0;
        }
        
        function lang_info(x)
        {
            gizle(language_info);
            if(x == 1)
                goster(language_info);
            else
                gizle(language_info);
        }
        
        function kontrol()
        {   
            if(!(document.upd_form.form_type[0].checked == true || document.upd_form.form_type[1].checked) == true)
            {
                document.upd_form.is_organization_change.checked = false;
                document.upd_form.is_volume_of_business.checked = false;
                document.upd_form.volume_business_min.value = "";
                document.upd_form.volume_business_max.value = "";
                document.upd_form.is_new_project.checked = false;
                document.upd_form.is_number_of_transactions.checked = false;
                document.upd_form.transaction_number_min.value = "";
                document.upd_form.transaction_number_max.value = "";
                document.upd_form.additional_staff_detail.value = "";
            }			
            /*	Eski-Yeni	0-2		1-0		2-1		3-4		4-3		5-5		*/
            if(document.getElementById('personel_other').value=='')
            {
                alert("<cf_get_lang dictionary_id='55590.Görüş Girmelisiniz'>!");
                return false;
            }
            <cfif x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
                //Display Olarak Acilsin
            <cfelse>
                if(document.upd_form.vehicle_req[0].checked && document.getElementById('vehicle_req_model').value=='')
                {
                    alert("<cf_get_lang dictionary_id='55581.Araç Modeli Girmelisiniz'>!");
                    return false;
                }
                if(document.upd_form.form_type[2].checked || document.upd_form.form_type[5].checked)
                {
                    if(document.getElementById('old_personel_name').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55591.İlgili Pozisyon Çalışanını Giriniz'>!");
                        return false;
                    }
                    
                    if(document.getElementById('old_personel_position').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
                        return false;
                    }
                }
                if(document.upd_form.form_type[4].checked)
                {
                    if(document.getElementById('change_personel_name').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55610.Pozisyon Değişikliği Pozisyon Çalışanını Giriniz'>!");
                        return false;
                    }
                    if(document.getElementById('change_personel_position').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
                        return false;
                    }
                }
                if(document.upd_form.form_type[3].checked)
                {
                    if(document.getElementById('transfer_personel_name').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55591.İlgili Pozisyon Çalışanını Giriniz'>!");
                        return false;
                    }
                    
                    if(document.getElementById('transfer_personel_position').value=='')
                    {
                        alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
                        return false;
                    }
                }
                if(document.getElementById('personal_age_max').value != '' || document.getElementById('personal_age_min').value != ''){
                    if(document.getElementById('personal_age_max').value <= document.getElementById('personal_age_min').value)
                    {
                        alert("<cf_get_lang dictionary_id='55118.Yaş aralığı düzgün girilmedi'>!");
                        return false;
                    }
                }
            </cfif>
            if(process_cat_control())
            {
                if(upd_form.min_salary != undefined) upd_form.min_salary.value = filterNum(upd_form.min_salary.value);
                if(upd_form.min_salary != undefined) upd_form.max_salary.value = filterNum(upd_form.max_salary.value);
                return true;
            }
            else
                return false;
        }
        
        <cfif x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
            //Display Olarak Acilsin
        <cfelse>
            function arac_talebi()
            {
                gizle(arac_modeli);
                if(document.upd_form.vehicle_req[0].checked)
                    goster(arac_modeli);
                else
                    gizle(arac_modeli);
            }
        
            function gizleme_islemi()
            {
                gizle(ilgili_header_);
                gizle(ilgili_2);
                gizle(ilgili_3);
                gizle(belirsiz_header);
                gizle(belirsiz_1);
                gizle(belirsiz_2);
                gizle(position_header);
                gizle(position_1);
                gizle(position_2);
                gizle(position_3);
                gizle(nakil_header);
                gizle(nakil_1);
                gizle(nakil_2);
                gizle(nakil_3);
                gizle(personel_detail_other_info);
                gizle(ek_kadro);
                goster(document.getElementById('item-old_personel_name'));

                if(document.upd_form.form_type[2].checked || document.upd_form.form_type[5].checked)
                {
                    goster(ilgili_header_);
                    goster(ilgili_2);
                    goster(ilgili_3);
                    if(document.upd_form.old_personel_detail[4].checked)
                        goster(personel_detail_other_info);
                }
                if(document.upd_form.form_type[1].checked)
                {
                    goster(belirsiz_header);
                    goster(belirsiz_1);
                    goster(belirsiz_2);
                }
                if(document.upd_form.form_type[4].checked)
                {
                    goster(position_header);
                    goster(position_1);
                    goster(position_2);
                    goster(position_3);
                    gizle(document.getElementById('item-old_personel_name'));
                }
                if(document.upd_form.form_type[3].checked)
                {
                    goster(nakil_header);
                    goster(nakil_1);
                    goster(nakil_2);
                    goster(nakil_3);
                    gizle(document.getElementById('item-old_personel_name'));
                }
                if(document.upd_form.form_type[0].checked || document.upd_form.form_type[1].checked)
                {
                    goster(ek_kadro);
                }
            }
            gizleme_islemi();
        </cfif>
    </script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->