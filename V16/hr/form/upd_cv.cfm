<cf_xml_page_edit fuseact="hr.upd_cv">
<cfscript>
    get_imcat = createObject("component","V16.hr.cfc.get_im");
    get_imcat.dsn = dsn;
    get_ims = get_imcat.get_im(
        empapp_id : attributes.empapp_id
        );
</cfscript>
<cfif not isnumeric(attributes.empapp_id)>
    <cfset hata = 10>
    <cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfset xfa.upd= "hr.emptypopup_upd_cv">
<cfset xfa.del= "hr.emptypopup_del_cv">
<cfinclude template="../query/get_app.cfm">
<cfinclude template="../query/get_know_levels.cfm">
<cfquery name="get_languages" datasource="#dsn#">
	SELECT * FROM SETUP_LANGUAGES
</cfquery>
<cfif not get_app.recordcount>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id='38683.Özgeçmişin kaydı bulunamıyor kayıt silinmiş olabilir'>!");
        history.go(-1);
    </script>
    <cfabort>
</cfif>
<cfinclude template="../query/get_app_identy.cfm">
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../query/get_mobil_cats.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_driverlicence.cfm">
<cfquery name="get_cv_status" datasource="#dsn#">
	SELECT STATUS_ID, ICON_NAME, STATUS FROM SETUP_CV_STATUS
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,
		BRANCH_CITY
	FROM
		BRANCH
	WHERE BRANCH_STATUS =1
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ZONES" datasource="#DSN#">
	SELECT ZONE_ID, ZONE_NAME FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
</cfquery>
<cfquery name="get_computer_info" datasource="#dsn#">
	SELECT * FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1
</cfquery>
<cfquery name="get_teacher_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = #EMPAPP_ID#
</cfquery>
<cfquery name="get_app_pos" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_POS WHERE EMPAPP_ID=#get_app.empapp_id#
</cfquery>
<cfquery name="get_emp_course" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_COURSE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfquery name="get_emp_reference" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
	SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<!---<cfquery name="get_ims" datasource="#dsn#">
	SELECT IMCAT_ID, IM_ADDRESS FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>--->
<cfquery name="get_cv_source" datasource="#dsn#">
	SELECT CV_SOURCE_ID,SOURCE_HEAD FROM SETUP_CV_SOURCE ORDER BY SOURCE_HEAD
</cfquery>
<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm">

<cfsavecontent variable="message"><cf_get_lang dictionary_id='49821.Özgeçmiş'></cfsavecontent>
<cfset pageHead = #message# &" : " &get_app.name & " " &get_app.surname>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
        <cf_box id="box_title">
            <ul class="ui-list">
                <li id="<cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'>" name="gizli0" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli0); "><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'></div></a></li>
                <li id="<cf_get_lang dictionary_id='55126.Kişisel Bilgiler'>" name="gizli1" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli1); "><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55126.Kişisel Bilgiler'></div></a></li>
                <li id="<cf_get_lang dictionary_id='31682.Kimlik Detayları'>" name="gizli2" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli2);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='31682.Kimlik Detayları'></div></a></li>
                <li id="<cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'>" name="gizli3" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli3);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'></div></a></li>
                <li id="<cf_get_lang dictionary_id='55307.İş Tecrübesi'>" name="gizli4" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli4);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55307.İş Tecrübesi'></div></a></li>
                <li id="<cf_get_lang dictionary_id='55252.Referans Bilgileri'>" name="gizli5" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli5);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55252.Referans Bilgileri'></div></a></li>
                <li id="<cf_get_lang dictionary_id='56168.Özel İlgi Alanları'>" name="gizli6" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli6);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='56168.Özel İlgi Alanları'></div></a></li>
                <li id="<cf_get_lang dictionary_id='56170.Aile Bilgileri'>" style="cursor:pointer;" name="gizli7" onClick="hepsini_gizle(id);cv_gizlegoster(gizli7);"> <a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='56170.Aile Bilgileri'></div></a></li>
                <li id="<cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'>" name="gizli8" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli8);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'></div></a></li>
                <li id="<cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'>" style="cursor:pointer;" name="gizli9" onClick="hepsini_gizle(id);cv_gizlegoster(gizli9);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'></div></a></li>
                <li id="<cf_get_lang dictionary_id='55129.Ek Bilgiler'>" name="gizli10" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli10);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55129.Ek Bilgiler'></div></a></li>
            </ul>
        </cf_box>
    </div>
    <cfform action="#request.self#?fuseaction=#xfa.upd#" name="employe_detail" method="post" enctype="multipart/form-data">
        <input type="Hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#empapp_id#</cfoutput>">
            <input type="Hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_app.photo#</cfoutput>">
            <input type="Hidden" name="old_photo_server_id" id="old_photo_server_id" value="<cfoutput>#get_app.photo_server_id#</cfoutput>">
        <input type="hidden" name="counter" id="counter" value="">
        <input type="hidden" name="selected_menu_info" id="selected_menu_info" value="gizli0">
        <cfif not len(get_app.valid)>
            <input type="Hidden" name="valid" id="valid" value="">
        </cfif>
        <div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" index="2" sort="true">
                <!--- Kimlik ve iletişim--->
            <cf_box id="orta_box" title="#getLang('','Kimlik ve İletişim Bilgileri','31647')#">
                <cf_box_elements>
                    <!--- Kimlik Bilgileri --->
                    <div id="gizli0">
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-cv_type">
                                <div class="col col-12">
                                    <label class="col col-4 col-xs-12">&nbsp</label>
                                    <label class="col col-4 col-xs-12"><input type="radio" value="0" name="cv_type" id="cv_type" onclick="referans_calistir();" <cfif get_app.cv_type eq 0>checked</cfif> > <cf_get_lang dictionary_id="38581.Güncel CV"></label>
                                    <label class="col col-4 col-xs-12"><input type="radio" value="1" name="cv_type" id="cv_type" onclick="referans_calistir();" <cfif get_app.cv_type eq 1>checked</cfif> > <cf_get_lang dictionary_id="38580.Referanslı Cv"></label>
                                </div>
                            </div>
                            <div id="referans_area" style="display:none;">
                                <div class="form-group" id="item-reference_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="38625.Referans Adı Soyad"></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif isdefined("get_app.reference_name") and len(get_app.reference_name)>
                                                <cfinput type="text" name="reference_name" value="#get_app.reference_name#"  maxlength="50">
                                            <cfelse>
                                                <cfinput type="text" name="reference_name" value=" "  maxlength="50">
                                            </cfif>
                                                <span class="input-group-addon no-bg"></span>
                                            <cfif isdefined("get_app.reference_surname") and len(get_app.reference_surname)>
                                                <cfinput type="text" name="reference_surname" value="#get_app.reference_surname#"  maxlength="50">
                                            <cfelse>
                                                <cfinput type="text" name="reference_surname" value=" "  maxlength="50">
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-reference_position">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="38624.Referans Görevi"></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif isdefined("get_app.reference_position") and len(get_app.reference_position)>
                                            <cfinput type="text" name="reference_position" value="#get_app.reference_position#"  maxlength="100">
                                        <cfelse>
                                            <cfinput type="text" name="reference_position" maxlength="100">
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' select_value='#get_app.cv_stage#' process_cat_width='153' is_detail='1'>
                                </div>
                            </div>
                            <div class="form-group" id="item-cv_recorder_emp_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37619.Giriş Yapan"></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="hidden" name="cv_recorder_emp_id" value="#session.ep.userid#">
                                        <cfinput type="text" name="cv_recorder_emp_name" value="#session.ep.name# #session.ep.surname#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employe_detail.cv_recorder_emp_name&field_emp_id=employe_detail.cv_recorder_emp_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57453.Şube"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="branch_id" id="branch_id">
                                        <option value=""><cf_get_lang dictionary_id="57453.Şube"></option>
                                        <cfoutput query="get_our_comp_and_branchs">
                                            <option value="#branch_id#" <cfif isdefined("get_app.related_branch_id") and len(get_app.related_branch_id) and get_app.related_branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-cv_source">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59127.CV Kaynağı"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="cv_source" id="cv_source">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_cv_source">
                                            <option value="#cv_source_id#" <cfif get_app.cv_source_id eq cv_source_id>selected</cfif>>#source_head#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-tax_office">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="tax_office" maxlength="50" value="#get_app.tax_office#">
                                </div>
                            </div>
                            <div class="form-group" id="item-tax_number">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="tax_number" maxlength="50" value="#get_app.tax_number#">
                                </div>
                            </div>
                            <div class="form-group" id="item-identycard_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55903.Kimlik Kartı No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="identycard_no" maxlength="50" value="#get_app.identycard_no#">
                                </div>
                            </div>
                            <div class="form-group" id="item-password">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput class="input-type-password" value="" type="text" name="empapp_password" id="empapp_password" maxlength="16" oncopy="return false" onpaste="return false" placeholder="#iIf(len(get_app.empapp_password),DE('&bull;&bull;&bull;&bull;'),DE(''))#">
                                        <span class="input-group-addon showPassword" onclick="showPasswordClass('empapp_password')"><i class="fa fa-eye"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                            <cf_seperator title="#getLang('','Kimlik Bilgileri','55127')#" id="kimlik_" style="display:none;">
                            <div id="kimlik_">
                                <div class="form-group" id="item-nationality">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>#get_app.empapp_id#</cfoutput>
                                    </div>
                                </div>
                                <div class="form-group" id="item-TC_IDENTY_NO">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55649.TC Kimlik No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_duxi type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#get_app_identy.TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"  required="yes" maxlength="11" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-name_">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" value="#get_app.name#" name="name_" maxlength="50" required="Yes" message="#getLang('','Ad Girmelisiniz','58939')#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-surname">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                                        <cfinput value="#get_app.surname#" type="text" name="surname" maxlength="50" required="Yes" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_place">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="birth_place" maxlength="100" value="#get_app_identy.birth_place#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_city">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'> <cf_get_lang dictionary_id='58608.İl'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="birth_city" id="birth_city">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <cfoutput query="get_city">
                                                <option value="#city_id#"<cfif get_app_identy.birth_city eq city_id>selected</cfif>>#city_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarih'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="birth_date" value="#dateformat(get_app_identy.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Doğum tarihi girmelisiniz','55788')#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sex">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="sex" id="sex" onclick="visible_mil(this.value);" value="1" <cfif get_app.sex eq 1>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'></label>
                                        <label><input type="radio" name="sex" id="sex" onclick="visible_mil(this.value);" value="0" <cfif get_app.sex eq 0>checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-married">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55654.Medeni Durum'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="married" id="married" value="0" onchange="disp_spouse()" <cfif get_app_identy.married eq 0>checked</cfif>><cf_get_lang dictionary_id='55744.Bekar'></label>
                                        <label><input type="radio" name="married" id="married" value="1" onchange="disp_spouse()" <cfif get_app_identy.married eq 1>checked</cfif>><cf_get_lang dictionary_id='55743.Evli'></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <cf_seperator title="#getLang('','İletişim Bilgileri','56512')#" id="iletisim_" style="display:none;">
                            <div id="iletisim_">
                                <div class="form-group" id="item-mobilcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput type="text" name="mobilcode" onkeyup="return(isNumber(this));" value="#get_app.mobilcode#" maxlength="3" validate="integer" message="#getLang('','Mobil Telefon Girmelisiniz','55454')#" >
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cf_duxi name='mobil' class="tableyazi" type="text" value="#get_app.mobil#" gdpr="1" maxlength="7" validate="integer" message="#getLang('','Mobil Telefon Girmelisiniz','55454')#" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-hometelcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55593.Ev Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput value="#get_app.hometelcode#" onkeyup="return(isNumber(this));" type="text" name="hometelcode"  maxlength="3" validate="integer" message="#getLang('','ev telefonu girmelisiniz','55601')#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cf_duxi name='hometel' class="tableyazi" type="text" value="#get_app.hometel#" gdpr="1" maxlength="7" validate="integer" message="#getLang('','ev telefonu girmelisiniz','55601')#" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-homeaddress">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55594.Ev Adresi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_duxi name='homeaddress' class="tableyazi" type="textarea" value="#get_app.homeaddress#" gdpr="1" maxlength="500"  message="#getLang('','Fazla karakter sayısı','29484')#" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-worktelcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55445.Direkt Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput value="#get_app.worktelcode#" onkeyup="return(isNumber(this));" type="text" name="worktelcode" maxlength="3" validate="integer" message="#getLang('','direkt tel girmelisiniz','55443')#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cf_duxi name='worktel' class="tableyazi" type="text" value="#get_app.worktel#" gdpr="1" maxlength="7" validate="integer" message="#getLang('','direkt tel girmelisiniz','55443')#" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-home_status">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="home_status" id="home_status">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif get_app.home_status eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='56132.Kendinizin'>
                                            <option value="2" <cfif get_app.home_status eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='56133.Ailenizin'>
                                            <option value="3" <cfif get_app.home_status eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id='56134.Kira'>
                                        </select>
                                    </div>
                                </div>
                                <!---<cfsavecontent variable="header_"><cf_get_lang no='359.Instant Mesaj'></cfsavecontent>
                                    <cf_object_tr id="form_ul_imcat_id" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang no='359.Instant Mesaj'></cf_object_td>
                                        <cf_object_td>
                                            <select name="imcat_id" id="imcat_id" style="width:48px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="im_cats">
                                                    <option value="#imcat_id#" <cfif get_app.imcat_id eq imcat_id>selected</cfif>>#imcat# </option>
                                                </cfoutput>
                                            </select>
                                            <cfinput type="text" name="im" style="width:99px;" maxlength="30" value="#get_app.im#">
                                        </cf_object_td>
                                    </cf_object_tr>--->
                                <div class="form-group" id="item-photo">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55110.Fotoğraf'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="file" name="photo" id="photo">
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_del_photo">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55660.fotoğrafı Sil'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_app.photo)>
                                            <input type="Checkbox" name="del_photo" id="del_photo" value="1">
                                            <cf_get_lang dictionary_id='57495.Evet'>
                                        </cfif>
                                    </div>
                                </div>
                                <div class="form-group" id="item-identycard_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55902.Kimlik Kartı Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrk_combo
                                        query_name="GET_IDENTYCARD"
                                        name="identycard_cat"
                                        value="#get_app.identycard_cat#"
                                        option_value="identycat_id"
                                        option_name="identycat"
                                        width=150>
                                    </div>
                                </div>
                                <div class="form-group" id="item-CITY">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="CITY" maxlength="100" value="#get_app_identy.CITY#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-app_status">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="app_status" id="app_status" value="1" <cfif get_app.app_status eq 1>checked</cfif>>
                                    </div>
                                </div>
                                <div class="form-group" id="item-mobilcode2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput type="text" name="mobilcode2" onkeyup="return(isNumber(this));" value="#get_app.mobilcode2#" maxlength="3" validate="integer" message="#getLang('','Mobil Telefon Girmelisiniz','55454')#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cf_duxi name='mobil2' class="tableyazi" type="text" value="#get_app.mobil2#" gdpr="1" maxlength="7" validate="integer" message="#getLang('','Mobil Telefon Girmelisiniz','55454')#" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-homepostcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55595.Posta Kodu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="homepostcode" maxlength="10" value="#get_app.homepostcode#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-homecountry">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="homecountry"  id="homecountry" onChange="LoadCity(this.value,'homecity','homecounty')">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#get_country.country_id#" <cfif get_app.homecountry eq country_id >selected</cfif>>#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-homecity">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_app.homecity)>
                                            <cfquery name="get_homecity" dbtype="query">
                                                SELECT CITY_NAME FROM get_city WHERE CITY_ID=#get_app.homecity#
                                            </cfquery>
                                        </cfif>
                                        <select name="homecity" id="homecity" onChange="LoadCounty(this.value,'homecounty')">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfquery name="GET_CITY" datasource="#DSN#">
                                                SELECT CITY_ID, CITY_NAME FROM SETUP_CITY <cfif len(get_app.homecountry)>WHERE COUNTRY_ID = #get_app.homecountry#</cfif>
                                            </cfquery>
                                            <cfoutput query="get_city">
                                                <option value="#city_id#" <cfif get_app.homecity eq city_id>selected</cfif>>#city_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-county_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="homecounty" id="homecounty">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif len(get_app.homecity)>
                                                <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                    SELECT * FROM SETUP_COUNTY <cfif len(get_app.homecity)>WHERE CITY = #get_app.homecity#</cfif>
                                                </cfquery>
                                                <cfoutput query="get_county">
                                                    <option value="#county_id#" <cfif get_app.homecounty eq county_id>selected</cfif>>#county_name#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-extension">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55446.Dahili Tel'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput value="#get_app.extension#" onkeyup="return(isNumber(this));" type="text" name="extension" maxlength="5" validate="integer" message="#getLang('','dahili tel girmelisiniz','55453')#">
                                    </div>
                                </div>
								<div class="form-group" id="item-resource">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
									<div class="col col-8 col-sm-12">
										<cf_wrk_combo 
											name="resource"
											query_name="GET_PARTNER_RESOURCE"
											value="#get_app.RESOURCE_ID#"
											option_name="resource"
											option_value="resource_id"
											width="150">
									</div>                
								</div>
								<div class="form-group" id="item-not_want_email">
									<label class="col col-4 col-xs-12" for="not_want_email"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="not_want_email" id="not_want_email" value="0" <cfif get_app.want_email eq 0>checked</cfif>>
									</div>
								</div>
								<div class="form-group" id="item-not_want_sms">
									<label class="col col-4 col-xs-12" for="not_want_sms"><cf_get_lang dictionary_id='30741.SMS Almak İstemiyorum'></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="not_want_sms" id="not_want_sms" value="0" <cfif get_app.want_sms eq 0>checked</cfif>>
									</div>
								</div>
								<div class="form-group" id="item-not_want_call">
									<label class="col col-4 col-xs-12" for="not_want_call"><cf_get_lang dictionary_id='64230.Sesli Arama Almak İstemiyorum'></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="not_want_call" id="not_want_call" value="0" <cfif get_app.want_call eq 0>checked</cfif>>
									</div>
								</div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" index="4" sort="true">
                            <cf_seperator title="#getLang('','Bağlantı Kurulacak Kişi','55597')#" id="contact_1" style="display:none;">
                            <div id="contact_1">
                                <div class="form-group" id="item-contact">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact"  maxlength="40" value="#get_app.contact#" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_telcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput type="text" name="contact_telcode" onkeyup="return(isNumber(this));" id="contact_telcode" maxlength="3" validate="integer" value="#get_app.contact_telcode#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cf_duxi name='contact_tel' class="tableyazi" type="text" value="#get_app.contact_tel#" gdpr="1" maxlength="7" validate="integer" data_control="isnumber">
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_relation">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55693.Yakınlık'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact_relation" maxlength="40" value="#get_app.contact_relation#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-email">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="eposta" value="#get_app.email#" validate="email" maxlength="100" message="#getLang('crm',492)#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_email">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.Email'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact_email" maxlength="50" value="#get_app.contact_email#">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" index="5" sort="true">
                            <cf_seperator title="#getLang('','Instant Message','55444')#" id="instant_message" style="display:none;">
                            <div id="instant_message">
                                <div class="form-group" id="item-add_im_info">
                                    <cf_grid_list>
                                        <thead>
                                            <input type="hidden" name="add_im_info" id="add_im_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
                                            <tr>
                                                <th width="20"><a style="cursor:pointer" onClick="add_im_info_();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                                <th width="112"><cf_get_lang dictionary_id='57630.Tip'></th>
                                                <th width="120"><cf_get_lang dictionary_id='55686.Mail Adresi'></th>
                                            </tr>
                                        </thead>
                                        <tbody id="im_info">
                                            <input type="hidden" name="instant_info" id="instant_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
                                            <cfif isdefined("get_ims")>
                                                <cfoutput query="get_ims">
                                                    <tr id="im_info_#currentrow#">
                                                        <td width="20" nowrap><a style="cursor:pointer" onClick="del_im('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                        <td>
                                                            <select name="imcat_id#currentrow#" id="imcat_id#currentrow#" style="width:112px;">
                                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                                    <cfloop query="IM_CATS">
                                                                        <option value="#imcat_id#" <cfif get_ims.IMCAT_ID eq imcat_id> selected </cfif>>#imcat#</option>
                                                                    </cfloop>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <input type="text" name="im#currentrow#" id="im#currentrow#" value="#IM_ADDRESS#" style="width:120px;">
                                                            <input type="hidden" name="del_im_info#currentrow#" id="del_im_info#currentrow#" value="1">
                                                        </td>
                                                    </tr>
                                                </cfoutput>
                                            </cfif>
                                        </tbody>
                                    </cf_grid_list>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- Kimlik detayları--->
                    <div id="gizli1" style="display:none">
                        <div class="col col-6 col-xs-12" type="column" index="6" sort="true">
                            <div class="form-group" id="form_ul_partner_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56136.Eşinin Adı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="partner_name" value="#get_app.partner_name#" maxlength="150">
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_partner_position">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55633.Eşinin Pozisyonu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="partner_position" maxlength="50" value="#get_app.partner_position#">
                                </div>
                            </div>
                            <div class="form-group" id="item-use_cigarette">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56138.Sigara Kullanıyor mu'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_app.use_cigarette eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_app.use_cigarette eq 0 or not len(get_app.use_cigarette)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-defected">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55614.Engelli'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="defected" id="defected" value="1" onClick="seviye();" <cfif get_app.defected eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="defected" id="defected" value="0" onClick="seviye();" <cfif get_app.defected eq 0 or not len(get_app.defected)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="defectedRatio" style="display:none;">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41311.Özürlü Oranı'> </label>
                                <div class="col col-4 col-xs-12">
                                    <select name="defected_level" id="defected_level" <cfif get_app.defected eq 0>disabled</cfif>>
                                        <option value="0" <cfif get_app.defected_level eq 0>selected</cfif>>%0</option>
                                        <option value="10" <cfif get_app.defected_level eq 10>selected</cfif>>%10</option>
                                        <option value="20" <cfif get_app.defected_level eq 20>selected</cfif>>%20</option>
                                        <option value="30" <cfif get_app.defected_level eq 30>selected</cfif>>%30</option>
                                        <option value="40" <cfif get_app.defected_level eq 40>selected</cfif>>%40</option>
                                        <option value="50" <cfif get_app.defected_level eq 50>selected</cfif>>%50</option>
                                        <option value="60" <cfif get_app.defected_level eq 60>selected</cfif>>%60</option>
                                        <option value="70" <cfif get_app.defected_level eq 70>selected</cfif>>%70</option>
                                        <option value="80" <cfif get_app.defected_level eq 80>selected</cfif>>%80</option>
                                        <option value="90" <cfif get_app.defected_level eq 90>selected</cfif>>%90</option>
                                        <option value="100" <cfif get_app.defected_level eq 100>selected</cfif>>%100</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-sentenced">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_app.sentenced EQ 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_app.sentenced EQ 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-immigrant">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55432.Göçmen'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="immigrant" id="immigrant" value="1" <cfif get_app.immigrant EQ 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="immigrant" id="immigrant" value="0" <cfif get_app.immigrant EQ 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-driver_licence_actived">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56140.Kaç yıldır aktif olarak araba kullanıyorsunuz'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="driver_licence_actived" onkeyup="return(isNumber(this));" value="#get_app.driver_licence_actived#" maxlength="2"  validate="integer" message="Ehliyet Aktiflik Süresine Sayı Giriniz!">
                                </div>
                            </div>
                            <div class="form-group" id="item-defected_probability">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_app.defected_probability eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_app.defected_probability eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-investigation">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55341.Varsa nedir?'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="investigation" value="#get_app.INVESTIGATION#" maxlength="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-illness_probability">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55342.Devam eden bir hastalık veya bedeni sorununuz var mı'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_app.illness_probability eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_app.illness_probability eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-illness_detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55341.Varsa nedir?'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="illness_detail" id="illness_detail" style="width:150px;height:40px;"><cfoutput>#get_app.illness_detail#</cfoutput></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="trAskerlik">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55619.Askerlik'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="military_status" id="military_status" value="0" onClick="tecilli_fonk(this.value)" <cfif get_app.military_status eq 0>checked</cfif> ><cf_get_lang dictionary_id='55624.Yapmadı'></label>
                                    <label><input type="radio" name="military_status" id="military_status" value="1" onClick="tecilli_fonk(this.value)"<cfif get_app.military_status eq 1>checked</cfif> ><cf_get_lang dictionary_id='55625.Yaptı'></label>
                                    <label><input type="radio" name="military_status" id="military_status" value="2" onClick="tecilli_fonk(this.value)"<cfif get_app.military_status eq 2>checked</cfif> ><cf_get_lang dictionary_id='55626.Muaf'></label>
                                    <label><input type="radio" name="military_status" id="military_status" value="3" onClick="tecilli_fonk(this.value)"<cfif get_app.military_status eq 3>checked</cfif> ><cf_get_lang dictionary_id='55627.Yabancı'></label>
                                    <label><input type="radio" name="military_status" id="military_status" value="4" onClick="tecilli_fonk(this.value)"<cfif get_app.military_status eq 4>checked</cfif> ><cf_get_lang dictionary_id='55340.Tecilli'></label>
                                </div>
                            </div>
                            <div style="display:none;" id="Yapti">
                                <div class="form-group" id="item-military_finishdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56144.Terhis Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="military_finishdate" value="#dateformat(get_app.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-military_month">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56145.Süresi'> (<cf_get_lang dictionary_id='56146.Ay Olarak Giriniz'>)</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='56147.Askerlik Süresi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="military_month" onkeyup="return(isNumber(this));" value="#get_app.military_month#" validate="integer" maxlength="2" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-military_rank">
                                    <div class="col col-12">
                                        <label><input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_app.military_rank eq 0>checked</cfif>> <cf_get_lang dictionary_id='56148.Er'></label>
                                        <label><input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_app.military_rank eq 1>checked</cfif>> <cf_get_lang dictionary_id='56149.Yedek Subay'></label>
                                    </div>
                                </div>
                            </div>
                            <div style="display:none;" id="Muaf">
                                <div class="form-group" id="item-military_exempt_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56143.Muaf Olma Nedeni'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_app.military_exempt_detail#</cfoutput>">
                                    </div>
                                </div>
                            </div>
                            <div style="display:none;" id="Tecilli">
                                <div class="form-group" id="item-military_delay_reason">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="military_delay_reason" maxlength="30" value="#get_app.military_delay_reason#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-military_delay_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55338.Tecil Süresi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="military_delay_date" id="military_delay_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="military_delay_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" index="7" sort="true">
                            <div class="form-group" id="form_ul_partner_company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55618.Eşinin Ç Şirket'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="partner_company" maxlength="50" value="#get_app.partner_company#">
                                </div>
                            </div>
                            <div class="form-group" id="item-have_children">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55906.Çocuğunuz var mı'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="have_children" id="have_children" value="1" <cfif get_app.have_children eq 1>checked</cfif> onchange="disp_child()"><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="have_children" id="have_children" value="0" <cfif get_app.have_children neq 1>checked</cfif> onchange="disp_child()"><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-child">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56137.ÇocukSayısı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55942.çocuk sayısı girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="child" onkeyup="return(isNumber(this));" maxlength="2" value="#get_app.child#" validate="integer" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-martyr_relative">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_app.martyr_relative eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-psikoteknik">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55136.Psikoteknik"></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="psikoteknik" id="psikoteknik" value="1" <cfif get_app.is_psicotechnic eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="psikoteknik" id="psikoteknik" value="0" <cfif get_app.is_psicotechnic eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-driver_licence_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55629.Ehliyet Tip / Yıl'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="driver_licence_type" id="driver_licence_type" style="width:82px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_driverlicence">
                                                <option value="#licencecat_id#" <cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
                                            </cfoutput>
                                        </select>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='56601.Ehliyet Yılına Geçerli Bir Tarih Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="licence_start_date" value="#DateFormat(get_app.licence_start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message_driver#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="licence_start_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-driver_licence">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55630.Ehliyet No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="Text" name="driver_licence" maxlength="40" value="#get_app.driver_licence#">
                                </div>
                            </div>
                            <div class="form-group" id="item-surgical_operation">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56142.Geçirdiğiniz Ameliyat'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="surgical_operation" id="surgical_operation" message="<cfoutput>#getLang('','Fazla karakter sayısı','29484')#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_app.SURGICAL_OPERATION#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="gizli2" style="display:none">
                        <div class="col col-4 col-sm-8 col-xs-12" type="column" index="8" sort="true">
                            <div class="form-group" id="item-series">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                                <div class="col col-3 col-xs-12">
                                    <cfinput type="text" name="series" style="width:50px;" maxlength="20" value="#get_app_identy.series#">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <cfinput type="text" name="number" style="width:98px;" maxlength="50" value="#get_app_identy.number#">
                                </div>
                            </div>
                            <div class="form-group" id="item-father">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput name="father" type="text" value="#get_app_identy.father#" maxlength="75">
                                </div>
                            </div>
                            <div class="form-group" id="item-father_job">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56151.Baba İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="father_job" value="#get_app_identy.father_job#" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-LAST_SURNAME">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55640.Önceki Soyadı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="LAST_SURNAME" maxlength="100" value="#get_app_identy.LAST_SURNAME#">
                                </div>
                            </div>
                            <div class="form-group" id="item-BLOOD_TYPE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="BLOOD_TYPE" id="BLOOD_TYPE">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="0"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 0)>selected</cfif>>0 Rh+</option>
                                        <option value="1"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 1)>selected</cfif>>0 Rh-</option>
                                        <option value="2"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 2)>selected</cfif>>A Rh+</option>
                                        <option value="3"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 3)>selected</cfif>>A Rh-</option>
                                        <option value="4"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 4)>selected</cfif>>B Rh+</option>
                                        <option value="5"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 5)>selected</cfif>>B Rh-</option>
                                        <option value="6"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 6)>selected</cfif>>AB Rh+</option>
                                        <option value="7"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 7)>selected</cfif>>AB Rh-</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-mother">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput name="mother" type="text" value="#get_app_identy.mother#" maxlength="75">
                                </div>
                            </div>
                            <div class="form-group" id="item-mother_job">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56152.Anne İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="mother_job" value="#get_app_identy.mother_job#" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-religion">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55651.Dini'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="religion" maxlength="50" value="#get_app_identy.religion#">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-sm-8 col-xs-12" type="column" index="9" sort="true">
                            <cf_seperator title="#getLang('','Nüfusa Kayıtlı Olduğu','55641')#" id="kayit_" style="display:none;">
                            <div id="kayit_">
                                <div class="form-group" id="item-COUNTY">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="COUNTY" maxlength="100" value="#get_app_identy.COUNTY#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-WARD">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="WARD" maxlength="100" value="#get_app_identy.WARD#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-VILLAGE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55645.Köy'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="VILLAGE" maxlength="100" value="#get_app_identy.VILLAGE#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-BINDING">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55655.Cilt No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="BINDING" maxlength="20" value="#get_app_identy.BINDING#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-FAMILY">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55656.Aile Sıra No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="FAMILY" maxlength="20" value="#get_app_identy.FAMILY#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-CUE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55657.Sıra No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="CUE" maxlength="20" value="#get_app_identy.CUE#">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-sm-8 col-xs-12" type="column" index="10" sort="true">
                            <cf_seperator title="#getLang('','Cüzdanın','55646')#" id="cuzdanin_" style="display:none;">
                            <div id="cuzdanin_">
                                <div class="form-group" id="item-GIVEN_PLACE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55647.Verildiği Yer'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="GIVEN_PLACE" maxlength="100" value="#get_app_identy.GIVEN_PLACE#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-GIVEN_REASON">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="GIVEN_REASON" maxlength="300" value="#get_app_identy.GIVEN_REASON#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-RECORD_NUMBER">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55658.Kayıt No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="RECORD_NUMBER" maxlength="50" value="#get_app_identy.RECORD_NUMBER#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-GIVEN_DATE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55790.veriliş tarihi'></cfsavecontent>
                                            <cfinput type="text" name="GIVEN_DATE" value="#dateformat(get_app_identy.GIVEN_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="GIVEN_DATE"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!---Eğitim Bilgileri --->
                    <div id="gizli3" style="display:none">
                        <div class="col col-12" type="column" index="11" sort="false">
                            <div class="form-group" id="item-egitim">
                                <cfquery name="get_edu_info" datasource="#DSN#">
                                    SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
                                </cfquery>
                                <cf_grid_list>
                                    <thead>
                                        <input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
                                        <tr>
                                            <th colspan="2" style="text-align:center;;">
                                                <input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a style="cursor:pointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','medium');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                                            </th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56481.Okul Türü'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='30645.Okul Adı'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56483.Başl Yılı'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56484.Bitiş Yılı'></th>
                                            <th style="width:50px;"><cf_get_lang dictionary_id ='56153.Not Ort'>.</th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id='57995.Bölüm'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_edu_info">
                                        <cfoutput query="get_edu_info">
                                            <tr id="frm_row_edu#currentrow#">
                                                <input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
                                                <td width="20"><a style="cursor:pointer" href="javascript://" onClick="gonder_training('#currentrow#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                                <td width="20"><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#"><a style="cursor:pointer" href="javascript://" onClick="sil_edu('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                <td>
                                                    <input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
                                                    <cfif len(edu_type)>
                                                        <cfquery name="get_education_level_name" datasource="#dsn#">
                                                            SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                                                        </cfquery>
                                                        <cfset edu_type_name=get_education_level_name.education_name>
                                                        <cfset edu_type_ = get_education_level_name.EDU_TYPE>
                                                    </cfif>
                                                    <input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="<cfif len(edu_type)>#edu_type_name#</cfif>" style="width:80px;" readonly>
                                                </td>
                                                <td>
                                                    <cfif len(edu_id) and edu_id neq -1>
                                                        <cfquery name="get_unv_name" datasource="#dsn#">
                                                            SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                                        </cfquery>
                                                        <cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
                                                    <cfelse>
                                                        <cfset edu_name_degisken = edu_name>
                                                    </cfif>
                                                    <input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
                                                    <input type="text" style="width:185px;" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
                                                </td>
                                                <td><input type="text" style="width:70px;" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#dateformat(edu_start,dateformat_style)#" readonly></td>
                                                <td><input type="text" style="width:70px;" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#dateformat(edu_finish,dateformat_style)#" readonly></td>
                                                <td><input type="text" style="width:40px;" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></td>
                                                <td>
                                                    <cfif (len(edu_part_id) and edu_part_id neq -1)>
                                                        <cfif get_education_level_name.edu_type eq 1> <!--- edu_type 0:İlköğretim,1:lise,2:üniversite--->
                                                            <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                                            </cfquery>
                                                            <cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
                                                        <cfelse>
                                                            <cfquery name="get_school_part_name" datasource="#dsn#">
                                                                SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
                                                            </cfquery>
                                                            <cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
                                                        </cfif>
                                                    <cfelseif len(edu_part_name)>
                                                        <cfset edu_part_name_degisken = edu_part_name>
                                                    <cfelse>
                                                        <cfset edu_part_name_degisken = "">
                                                    </cfif>
                                                    <input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" style="width:150;" class="boxtext" value="#edu_part_name_degisken#" readonly>
                                                    <input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type_ eq 1>#edu_part_id#</cfif>">
                                                    <input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif edu_type_ eq 2 and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
                                                    <input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td width="110" colspan="8">
                                                <div class="form-group" id="item-training_level">
                                                    <div class="col col-4 col-xs-12"><label><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'></label></div>
                                                    <div class="col col-4 col-xs-12">
                                                        <select name="training_level" id="training_level">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfloop query="get_edu_level">
                                                                <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_app.training_level eq get_edu_level.edu_level_id>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                                                            </cfloop>
                                                        </select>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </cf_grid_list>
                            </div>
                            <cf_seperator id="item_add_lang_info" title="#getLang('','	Yabancı Dil Bilgisi','55218')#" style="display:none;">
                            <div id="item_add_lang_info">
                                <cf_grid_list>
                                    <cfquery name="get_emp_language" datasource="#dsn#">
                                        SELECT
                                            EMPAPP_ID,
                                            LANG_ID,
                                            LANG_SPEAK,
                                            LANG_WRITE,
                                            LANG_MEAN,
                                            LANG_WHERE
                                        FROM
                                            EMPLOYEES_APP_LANGUAGE
                                        WHERE
                                            EMPAPP_ID = #EMPAPP_ID#
                                    </cfquery>
                                    <input type="hidden" name="add_lang_info" id="add_lang_info" value="<cfoutput>#get_emp_language.recordcount#</cfoutput>">
                                    <thead>
                                        <tr>
                                            <th width="20"><a style="cursor:pointer" href="javascript://" onClick="add_lang_info_();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id='58996.Dil'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id='56158.Konuşma'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id='56159.Anlama'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id='56160.Yazma'></th>
                                            <th><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></th>
                                        </tr>
                                    </thead>
                                    <input type="hidden" name="language_info" id="language_info" value="">
                                    <tbody id="lang_info">
                                        <cfoutput query="get_emp_language">
                                            <tr id="lang_info_#currentrow#">
                                                <td><a style="cursor:pointer" onClick="del_lang('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                <td>
                                                    <select name="lang#currentrow#" id="lang#currentrow#" style="width:100px;">
                                                        <option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
                                                        <cfloop query="get_languages">
                                                            <option value="#language_id#"<cfif language_id eq get_emp_language.LANG_ID>selected</cfif>>#language_set#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select name="lang_speak#currentrow#" id="lang_speak#currentrow#" style="width:100px;">
                                                        <cfloop query="know_levels">
                                                            <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_speak>selected</cfif>>#knowlevel#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select name="lang_mean#currentrow#" id="lang_mean#currentrow#" style="width:100px;">
                                                        <cfloop query="know_levels">
                                                            <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_mean>selected</cfif>>#knowlevel#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select name="lang_write#currentrow#" id="lang_write#currentrow#" style="width:100px;">
                                                        <cfloop query="know_levels">
                                                            <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_write>selected</cfif>>#knowlevel#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td>
                                                    <input type="text" name="lang_where#currentrow#" id="lang_where#currentrow#" value="#get_emp_language.lang_where#">
                                                    <input type="hidden" name="del_lang_info#currentrow#" id="del_lang_info#currentrow#" value="1">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                            <cf_seperator id="item_program" title="#getLang('','','56162')#" style="display:none;">
                            <div id="item_program">
                                <cf_grid_list>
                                    <thead>
                                        <input type="hidden" name="extra_course" id="extra_course" value="<cfoutput>#get_emp_course.recordcount#</cfoutput>">
                                        <tr>
                                            <th width="20"><a style="cursor:pointer" onClick="add_row_course();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="115"><cf_get_lang dictionary_id="30919.Eğitim Konusu"></th>
                                            <th width="115"><cf_get_lang dictionary_id="37611.Eğitim Veren Kurum"></th>
                                            <th width="140"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                            <th width="115"><cf_get_lang dictionary_id='58455.Yıl'></th>
                                            <th width="115"><cf_get_lang dictionary_id='29513.Sure'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="add_course_pro">
                                        <cfif isdefined("get_emp_course")>
                                            <cfoutput query="get_emp_course">
                                                <tr id="pro_course#currentrow#">
                                                    <td><a style="cursor:pointer" onClick="sil_('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                    <td><input type="text" name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#COURSE_SUBJECT#" style="width:115px;"></td>
                                                    <td><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#" style="width:115px;"></td>
                                                    <td><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#COURSE_EXPLANATION#" style="width:140px;"  maxlength="200"></td>
                                                    <td><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" value="#left(course_year,4)#" maxlength="4" onKeyup="isNumber(this);" style="width:115px;"></td>
                                                    <td>
                                                        <input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#" style="width:115px;">
                                                        <input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
                                                    </td>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                            <div class="form-group margin-top-25" id="item-get_computer_info">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                                        <select name="computer_education" id="computer_education" style="width:220px; height:70px;" multiple>
                                            <cfoutput query="get_computer_info">
                                                <option value="#computer_info_id#" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,computer_info_id,',')>selected</cfif>>#computer_info_name#</option>
                                            </cfoutput>
                                            <option value="-1" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,-1,',')>selected</cfif>>Diğer</option>
                                        </select>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                                        <textarea name="comp_exp" id="comp_exp" style="width:310px;height:70px;"><cfoutput>#get_app.COMP_EXP#</cfoutput></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-program">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="38610.Paket Program Bilgisi"></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="comp_packet_pro" id="comp_packet_pro" style="width:536px;height:70px;"><cfif isdefined("get_app.com_packet_pro") and len(get_app.com_packet_pro)><cfoutput>#get_app.com_packet_pro#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-ofis2">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="37597.Ofis Araçları Bilgisi"></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="electronic_tools" id="electronic_tools" style="width:536px;height:70px;"><cfif isdefined("get_app.electronic_tools") and len(get_app.electronic_tools)><cfoutput>#get_app.electronic_tools#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                                
                        </div>
                    </div>
                    <!---İş Tecrübesi --->
                    <div id="gizli4" style="display:none">
                        <div class="col col-12" type="column" index="12" sort="false">
                            <div class="form-group" id="item-table_work_info">
                                <cfquery name="get_work_info" datasource="#DSN#">
                                    SELECT
                                        *
                                    FROM
                                        EMPLOYEES_APP_WORK_INFO
                                    WHERE
                                        EMPAPP_ID=#attributes.empapp_id#
                                </cfquery>
                                <cf_grid_list>
                                    <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
                                    <thead>
                                        <tr>
                                            <th colspan="2" style="text-align:center; width:20px;"><input name="record_num" id="record_num" type="hidden" value="0"><a style="cursor:pointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0&draggable=1</cfoutput>','medium');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="120"><cf_get_lang dictionary_id='56485.Çalışılan Yer'></th>
                                            <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57579.Sektör'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57571.Ünvan'></th>
                                            <th width="120"><cf_get_lang dictionary_id='30128.Çalışma Şekli'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_work_info">
                                        <cfoutput query="get_work_info">
                                            <tr id="frm_row#currentrow#">
                                                <td><a style="cursor:pointer" href="javascript://" onClick="gonder_upd('#currentrow#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                                <td>
                                                    <input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                                                    <a style="cursor:pointer" href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                                </td>
                                                <input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
                                                <input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
                                                <input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
                                                <input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
                                                <input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
                                                <input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
                                                <input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
                                                <input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#">
                                                <td><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></td>
                                                <td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></td>
                                                <td>
                                                    <input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
                                                        <cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
                                                            <cfquery name="get_sector_cat" datasource="#dsn#">
                                                                SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
                                                            </cfquery>
                                                        </cfif>
                                                    <input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
                                                    <cfif isdefined("exp_task_id") and len(exp_task_id)>
                                                        <cfquery name="get_exp_task_name" datasource="#dsn#">
                                                            SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
                                                        </cfquery>
                                                    </cfif>
                                                    <input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" style="width:100px;" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="hidden" name="exp_work_type_id#currentrow#" id="exp_work_type_id#currentrow#" class="boxtext" value="#exp_work_type_id#">
                                                    <cfif isdefined("exp_work_type_id") and len(exp_work_type_id)>
                                                        <cfquery name="get_exp_work_type_name" datasource="#dsn#">
                                                            SELECT WORK_TYPE_ID,WORK_TYPE_NAME FROM SETUP_WORK_TYPE WHERE WORK_TYPE_ID = #exp_work_type_id#
                                                        </cfquery>
                                                    </cfif>
                                                    <input type="text" name="exp_work_type_name#currentrow#" id="exp_work_type_name#currentrow#" style="width:100px;" class="boxtext" value="<cfif isdefined("exp_work_type_id") and len(exp_work_type_id) and get_exp_work_type_name.recordcount>#get_exp_work_type_name.WORK_TYPE_NAME#</cfif>" readonly="readonly">
                                                </td>
                                                <td><input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" style="width:70px;" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly="readonly"></td>
                                                <td><input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" style="width:70px;" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly="readonly"></td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                    </div>
                    <!---Referans Bilgileri --->
                    <div id="gizli5" style="display:none">
                        <div class="col col-12" type="column" index="13" sort="false">
                            <div class="form-group" id="item-add_ref_info">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th width="20"><a style="cursor:pointer" onClick="add_ref_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                                                <input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
                                                <input type="hidden" name="referance_info" id="referance_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
                                            </th>
                                            <th width="150"><cf_get_lang dictionary_id="31063.Referans Tipi"></th>
                                            <th width="100"><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
                                            <th width="100"><cf_get_lang dictionary_id="57574.Şirket"></th>
                                            <th width="100"><cf_get_lang dictionary_id="41193.Tel.Kod"></th>
                                            <th width="100"><cf_get_lang dictionary_id="57499.Telefon"></th>
                                            <th width="100"><cf_get_lang dictionary_id="58497.Pozisyon"></th>
                                            <th width="100"><cf_get_lang dictionary_id="32508.E-mail"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="ref_info">
                                        <cfif isdefined("get_emp_reference")>
                                            <cfoutput query="get_emp_reference">
                                                <tr id="ref_info_#currentrow#">
                                                    <td width="20" nowrap><a style="cursor:pointer" onClick="del_ref('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                    <td>
                                                        <select name="ref_type#currentrow#" id="ref_type#currentrow#">
                                                            <option value=""><cf_get_lang dictionary_id="31063.Referans Tipi"></option>
                                                            <cfloop query="get_reference_type">
                                                                <option value="#reference_type_id#"<cfif len(get_emp_reference.REFERENCE_TYPE) and (get_emp_reference.REFERENCE_TYPE eq reference_type_id)>selected</cfif>>#reference_type#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>
                                                    <td><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#REFERENCE_NAME#" style="width:90px;"></td>
                                                    <td><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#REFERENCE_COMPANY#" style="width:90px;"></td>
                                                    <td><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" value="#REFERENCE_TELCODE#" style="width:90px;"> </td>
                                                    <td><input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" value="#REFERENCE_TEL#" style="width:90px;"></td>
                                                    <td><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#REFERENCE_POSITION#" style="width:90px;"></td>
                                                    <td>
                                                        <input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#REFERENCE_EMAIL#" style="width:90px;">
                                                        <input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
                                                    </td>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                        <div class="col col-12" type="column" index="14" sort="true">
                            <div class="form-group" id="item-related_ref_name">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="37595.Grup şirketinde çalışan yakınınızın ismi"></label>
                                <div class="col col-4 col-xs-12">
                                    <cfif isdefined("get_app.related_ref_name") and len(get_app.related_ref_name)>
                                        <cfinput type="text" name="related_ref_name" maxlength="100" value="#get_app.related_ref_name#">
                                    <cfelse>
                                        <cfinput type="text" name="related_ref_name" maxlength="100" value="">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-related_ref_company">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="57574.Şirketi"></label>
                                <div class="col col-4 col-xs-12">
                                    <cfif isdefined("get_app.related_ref_company") and len(get_app.related_ref_company)>
                                        <cfinput type="text" name="related_ref_company" maxlength="100" value="#get_app.related_ref_company#">
                                    <cfelse>
                                        <cfinput type="text" name="related_ref_company" maxlength="100" value="">
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!---Özel İlgi Alanları --->
                    <div id="gizli6" style="display:none" class="col col-12">
                        <div class="col col-8 col-sm-8 col-xs-12" type="column" index="15" sort="true">
                            <div class="form-group" id="item-hobby">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56168.Özel İlgi Alanları'></label>
                                <div class="col col-6 col-xs-12">
                                    <textarea name="hobby" id="hobby" style="width:500px; height:70px" message="<cfoutput>#getLang('','Fazla karakter sayısı','29484')#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_app.hobby#</cfoutput></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-club">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56169.Üye Olunan Klüp Ve Dernekler'></label>
                                <div class="col col-6 col-xs-12">
                                    <textarea name="club" id="club" style="width:500px; height:70px" message="<cfoutput>#getLang('','Fazla karakter sayısı','29484')#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_app.club#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!---Aile Bilgileri --->
                    <div id="gizli7" style="display:none">
                        <div class="col col-12 scrollContent scroll-x5" type="column" index="16" sort="false">
                            <div class="form-group" id="item-get_relatives">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <input type="hidden" name="rowCount" id="rowCount" value="">
                                            <th width="20"><a title="<cf_get_lang_main no ='170.Ekle'>" onClick="addRow();"><i class="fa fa-plus"></i></a></th>
                                            <th width="70"><cf_get_lang dictionary_id='57631.Ad'></th>
                                            <th width="70"><cf_get_lang dictionary_id='58726.Soyad'></th>
                                            <th width="70"><cf_get_lang dictionary_id='56171.Yakınlık Derecesi'></th>
                                            <th width="100"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                                            <th width="80"><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
                                            <th width="220"><cf_get_lang dictionary_id='57419.Eğitim'></th>
                                            <th width="70"><cf_get_lang dictionary_id='55494.Meslek'></th>
                                            <th width="70"><cf_get_lang dictionary_id='57574.Şirket'></th>
                                            <th width="70"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_list">
                                        <cfquery name="get_relatives" datasource="#DSN#">
                                            SELECT
                                                *
                                            FROM
                                                EMPLOYEES_RELATIVES
                                            WHERE
                                                EMPAPP_ID=#attributes.empapp_id#
                                            ORDER BY
                                                BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
                                        </cfquery>
                                        <cfif get_relatives.recordcount>
                                            <cfoutput query="get_relatives">
                                                <input type="hidden" id="relative_id#currentrow#" name="relative_id#currentrow#" value="#get_relatives.relative_id#">
                                                <input type="hidden" id="relative_sil#currentrow#" name="relative_sil#currentrow#" value="0">
                                                <tr id="frm_row#currentrow#">
                                                    <td width="20"><a href="javascript://" onClick="relative_sil(#currentrow#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                    <td><input type="text" id="name_relative#currentrow#" name="name_relative#currentrow#" value="#get_relatives.name#" maxlength="50" style="width:75px;"></td>
                                                    <td><input type="text" id="surname_relative#currentrow#" name="surname_relative#currentrow#" value="#get_relatives.surname#" maxlength="50" style="width:75px;"></td>
                                                    <td>
                                                        <select name="relative_level#currentrow#" id="relative_level#currentrow#" style="width:105px;">
                                                            <option value="1" <cfif get_relatives.relative_level eq 1>selected</cfif>><cf_get_lang dictionary_id='55265.Baba'></option>
                                                            <option value="2" <cfif get_relatives.relative_level eq 2>selected</cfif>><cf_get_lang dictionary_id='55470.Anne'></option>
                                                            <option value="3" <cfif get_relatives.relative_level eq 3>selected</cfif>><cf_get_lang dictionary_id='55275.Eşi'></option>
                                                            <option value="4" <cfif get_relatives.relative_level eq 4>selected</cfif>><cf_get_lang dictionary_id='55253.Oğlu'></option>
                                                            <option value="5" <cfif get_relatives.relative_level eq 5>selected</cfif>><cf_get_lang dictionary_id='55234.Kızı'></option>
                                                            <option value="6" <cfif get_relatives.relative_level eq 6>selected</cfif>><cf_get_lang dictionary_id="31449.Kardeşi"></option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <cfinput type="text" id="birth_date_relative#currentrow#" name="birth_date_relative#currentrow#" value="#dateformat(get_relatives.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                                            <cf_wrk_date_image date_field="birth_date_relative#currentrow#">
                                                    </td>
                                                    <td><cfinput type="text" name="birth_place_relative#currentrow#" value="#get_relatives.birth_place#" style="width:75px;"></td>
                                                    <td>
                                                        <div class="form-group">
                                                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                                                <select name="education_relative#currentrow#" id="education_relative#currentrow#">
                                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                                    <cfloop query="get_edu_level">
                                                                        <option value="#get_edu_level.edu_level_id#" <cfif get_edu_level.edu_level_id eq get_relatives.education>selected</cfif>>#get_edu_level.education_name#</option>
                                                                    </cfloop>
                                                                </select>
                                                            </div>
                                                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label><cf_get_lang dictionary_id="55483.Okuyor"><input type="checkbox" name="education_status_relative#currentrow#" id="education_status_relative#currentrow#" value="1" <cfif get_relatives.education_status eq 1>checked</cfif>></label>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><cfinput type="text" name="job_relative#currentrow#" value="#get_relatives.job#" style="width:75px;" maxlength="30"></td>
                                                    <td><cfinput type="text" name="company_relative#currentrow#" value="#get_relatives.company#" style="width:75px;" maxlength="50"></td>
                                                    <td><cfinput type="text" name="job_position_relative#currentrow#" value="#get_relatives.job_position#" style="width:75px;" maxlength="30"></td>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                    </div>
                    <!---Çalışılmak İstenilen Birimler --->
                    <div id="gizli8" style="display:none" class="col col-12">
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="17" sort="true">
                            <cfquery name="get_cv_unit" datasource="#DSN#">
                                SELECT
                                    *
                                FROM
                                    SETUP_CV_UNIT
                                WHERE
                                    IS_ACTIVE =1
                            </cfquery>
                            <div class="form-group" id="item-label">
                                <label class="col col-12">(<cf_get_lang dictionary_id='56173.Öncelik sıralarını yandaki kutulara yazınız'>...)</label>
                            </div>
                            <cfif get_cv_unit.recordcount>
                                <cfquery name="get_app_unit" datasource="#dsn#">
                                    SELECT
                                        UNIT_ID,UNIT_ROW
                                    FROM
                                        EMPLOYEES_APP_UNIT
                                    WHERE
                                        EMPAPP_ID=#attributes.empapp_id#
                                </cfquery>
                                <cfset liste = valuelist(get_app_unit.unit_id)>
                                <cfset liste_row = valuelist(get_app_unit.unit_row)>
                                <cfoutput query="get_cv_unit">
                                    <div class="form-group" id="item-unit#get_cv_unit.unit_id#">
                                        <label class="col col-8 col-xs-12">#get_cv_unit.unit_name#</label>
                                        <div class="col col-2 col-xs-12">
                                            <cfif listfind(liste,get_cv_unit.unit_id,',')>
                                                <cfinput type="text" name="unit#get_cv_unit.unit_id#" value="#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="#getLang('','Sayı Giriniz',55805)#!">
                                            <cfelse>
                                                <cfinput type="text" name="unit#get_cv_unit.unit_id#" value="" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="#getLang('','Sayı Giriniz',55805)#!">
                                            </cfif>
                                        </div>
                                    </div>
                                </cfoutput>
                            <cfelse>
                                <label class="col col-12"><cf_get_lang dictionary_id='56174.Sisteme kayıtlı birim yok'></label>
                            </cfif>
                        </div>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="18" sort="true">
                            <cf_seperator id="item_positions" title="#getLang('','Çalışmak İstenilen Pozisyonlar','37589')#">
                            <div id="item_positions">
                                <div class="form-group" id="item-position_cat_id1">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37585.Tercih"> 1</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfquery name="get_position_cat" datasource="#dsn#">
                                            SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_UPPER_TYPE = 1
                                        </cfquery>
                                        <select name="position_cat_id1" id="position_cat_id1">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_position_cat">
                                                <option value="#get_position_cat.position_cat_id#"<cfif len(get_app.position_cat_id1) and get_position_cat.position_cat_id eq get_app.position_cat_id1>selected</cfif>>#position_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-position_cat_id2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37585.Tercih"> 2</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="position_cat_id2" id="position_cat_id2">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_position_cat">
                                                <option value="#get_position_cat.position_cat_id#"<cfif len(get_app.position_cat_id2) and get_position_cat.position_cat_id eq get_app.position_cat_id2>selected</cfif>>#position_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-position_cat_id3">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37585.Tercih"> 3</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="position_cat_id3" id="position_cat_id3">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_position_cat">
                                                <option value="#get_position_cat.position_cat_id#"<cfif len(get_app.position_cat_id3) and get_position_cat.position_cat_id eq get_app.position_cat_id3>selected</cfif>>#position_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!---Çalışılmak İstenen  Şubeler--->
                    <div id="gizli9" style="display:none" class="col col-12">
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="19" sort="true">
                            <div class="form-group" id="item-preference_branch">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="preference_branch" id="preference_branch" multiple>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#" <cfif listfind(get_app.preference_branch,branch_id,',')>selected</cfif>>#branch_name# - #branch_city#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-preference_zone">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55188.Bölgeler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="preference_zone" id="preference_zone">
                                        <cfoutput query="get_zones">
                                            <option value="#zone_id#" <cfif get_app.preference_zone eq zone_id>selected</cfif>>#zone_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!---Ek Bilgiler --->
                    <div id="gizli10" style="display:none" class="col col-12">
                        <div class="col col-6 col-sm-10 col-xs-12" type="column" index="20" sort="true">
                            <div class="form-group" id="item-prefered_city">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55329.Çalışmak İstediğiniz Şehir'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                    name="prefered_city"
                                    option_name="CITY_NAME"
                                    option_value="CITY_ID"
                                    table_name="SETUP_CITY"
                                    is_option_text="1"
                                    option_text="#getLang('','TÜM TÜRKİYE','56175')#"
                                    value="#get_app.prefered_city#">
                                </div>
                            </div>
                            <div class="form-group" id="item-IS_TRIP">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55328.Seyahat Edebilir misiniz'>?</label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="IS_TRIP" id="IS_TRIP" value="1" <cfif get_app.IS_TRIP IS 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="IS_TRIP" id="IS_TRIP" value="0" <cfif get_app.IS_TRIP IS 0 OR get_app.IS_TRIP IS "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-EXPECTED_MONEY_TYPE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56489.İstenilen Ücret (Net)'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="expected_price" value="#TLFormat(get_app.expected_price)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                        <span class="input-group-addon no-bg width">
                                            <select name="EXPECTED_MONEY_TYPE" id="EXPECTED_MONEY_TYPE" class="formselect" style="width:58px;">
                                                <cfquery name="GET_MONEY" datasource="#dsn#">
                                                    SELECT
                                                        *
                                                    FROM
                                                        SETUP_MONEY
                                                    WHERE
                                                        PERIOD_ID = #SESSION.EP.PERIOD_ID#
                                                </cfquery>
                                                <cfoutput query="get_money">
                                                    <option value="#MONEY#"<cfif money is get_app.expected_money_type> selected</cfif>>#MONEY#</option>
                                                </cfoutput>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-work_start_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37582.Başlayabileceğiniz Tarih"></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("get_app.work_start_date") and len(get_app.work_start_date)>
                                            <cfinput type="text" style="width:120px;" name="work_start_date" value="#dateformat(get_app.work_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                        <cfelse>
                                            <cfinput type="text" style="width:120px;" name="work_start_date" value="" validate="#validate_style#" maxlength="10">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="work_start_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-applicant_notes">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55326.Eklemek İstedikleriniz'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="applicant_notes" id="applicant_notes" message="<cfoutput>#getLang('','Fazla karakter sayısı','29484')#</cfoutput>" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="4"  style="width:530px;"><cfoutput>#GET_APP.APPLICANT_NOTES#</cfoutput></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-interview_result">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55785.Mülakat Görüşü'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="interview_result" id="interview_result" style="width:530px;" message="<cfoutput>#getLang('','Fazla karakter sayısı','29484')#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="5"><cfif isdefined("get_app.interview_result") and len(get_app.interview_result)><cfoutput>#get_app.interview_result#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-ekbilgi">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-23" info_id="#attributes.empapp_id#" upd_page = "1">
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <!---Butonlar--->
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_box_footer>
                        <cf_record_info query_name="get_app">
                        <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&empapp_id=#attributes.empapp_id#' add_function='kontrol()'>
                    </cf_box_footer>
                </div>
            </cf_box>
        </div>
    </cfform>
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true"><!---Fotoğraf--->
        <cf_box id="get_photo_box"
            box_page="#request.self#?fuseaction=hr.emptypopup_hr_photo_ajax&empapp_id=#attributes.empapp_id#"
            title="#getLang('','Fotoğraf','55110')#"
            closable="0"
            unload_body="1">
        </cf_box>
        <!--- Varlıklar --->
        <cf_get_workcube_asset module_id=3 asset_cat_id="-8" action_section='EMPLOYEES_APP_ID' action_id='#empapp_id#'>
        <!--- Notlar --->
        <cf_get_workcube_note action_section='EMPLOYEES_APP_ID' action_id='#empapp_id#' box_id="notes1">
        <!---Yazışmalar--->
        <cfsavecontent variable="yaz"><cf_get_lang dictionary_id ='57459.Yazışmalar'></cfsavecontent>
        <cf_box
            id="get_corresp_box"
            box_page="#request.self#?fuseaction=hr.emptypopup_hr_correspon_ajax&empapp_id=#attributes.empapp_id#"
            title="#yaz#"
            add_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_app_add_mail&empapp_id=#attributes.empapp_id#&draggable=1');"
            closable="0"
            unload_body="1">
        </cf_box>
        <!---Sınav Sonuçları--->
        <cfsavecontent variable="yaz"><cf_get_lang dictionary_id="41310.Sınav Sonuçları"></cfsavecontent>
        <cf_box
                id="get_test_result_box"
                box_page="#request.self#?fuseaction=hr.emptypopup_hr_test_result_ajax&empapp_id=#attributes.empapp_id#"
                title="#yaz#"
                add_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_add_test_result&empapp_id=#attributes.empapp_id#&draggable=1');"
                add_href_size="small">
        </cf_box>
        <!---form generator değerlendirme formları ---->
        <cf_get_workcube_form_generator action_type='7' related_type='7' action_type_id='#attributes.empapp_id#' design='1' box_id="eva_form1">
        <!--- Başvurular--->
        <cfsavecontent variable="baslik"><cf_get_lang dictionary_id='58186.Başvurular'></cfsavecontent>
        <cf_box closable="0"
                title="#baslik#"
                add_href="javascript:windowopen('#request.self#?fuseaction=hr.apps&event=add&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#get_app.empapp_id#','medium');"
                box_page="#request.self#?fuseaction=hr.emptypopup_list_app_pos_to_cv_ajax&empapp_id=#attributes.empapp_id#">
        </cf_box>
        <cf_box closable="0"
            id="select_list"
            title="#getLang('','Seçim Listeleri','31337')#"
            add_href="javascript:edit_select_list(1);"
            box_page="#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#get_app.empapp_id#&type=1">
        </cf_box>
    </div>
</div>

<form name="form_work_info" method="post" action="">
    <input type="hidden" name="exp_name_new" id="exp_name_new" value="">
    <input type="hidden" name="exp_position_new" id="exp_position_new" value="">
    <input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
    <input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
    <input type="hidden" name="exp_work_type_id_new" id="exp_work_type_id_new" value="">
    <input type="hidden" name="exp_start_new" id="exp_start_new" value="">
    <input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
    <input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
    <input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
    <input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
    <input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
    <input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
    <input type="hidden" name="exp_reason_new" id="exp_reason_new" value="">
    <input type="hidden" name="is_cont_work_new" id="is_cont_work_new" value="">
</form>
<br/>
<form name="form_edu_info" method="post" action="">
    <input type="hidden" name="edu_type_new" id="edu_type_new" value="">
    <input type="hidden" name="edu_id_new" id="edu_id_new" value="">
    <input type="hidden" name="edu_name_new" id="edu_name_new" value="">
    <input type="hidden" name="edu_start_new" id="edu_start_new" value="">
    <input type="hidden" name="edu_finish_new" id="edu_finish_new" value="">
    <input type="hidden" name="edu_rank_new" id="edu_rank_new" value="">
    <input type="hidden" name="edu_high_part_id_new" id="edu_high_part_id_new" value="">
    <input type="hidden" name="edu_part_id_new" id="edu_part_id_new" value="">
    <input type="hidden" name="edu_part_name_new" id="edu_part_name_new" value="">
    <input type="hidden" name="is_edu_continue_new" id="is_edu_continue_new" value="">
</form>
<form name="create_selected_list" method="post" action="">
<cfoutput>
    <input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="#get_app_pos.app_pos_id#">
        <input type="hidden" name="list_empapp_id" id="list_empapp_id" value="#empapp_id#">
    <input type="hidden" name="search_app_pos" id="search_app_pos" value="1">
    <input type="hidden" name="status_app_pos" id="status_app_pos" value="">
    <input type="hidden" name="search_app" id="search_app" value="">
    <input type="hidden" name="app_position" id="app_position" value="">
    <input type="hidden" name="position_cat_id" id="position_cat_id" value="">
    <input type="hidden" name="position_cat" id="position_cat" value="">
    <input type="Hidden" name="position_id" id="position_id" value="">
    <input type="hidden" name="branch_id" id="branch_id" value="">
    <input type="hidden" name="branch" id="branch" value="">
    <input type="hidden" name="our_company_id" id="our_company_id" value="">
    <input type="hidden" name="department_id" id="department_id" value="">
    <input type="hidden" name="department" id="department" value="">
    <input type="hidden" name="company_id" id="company_id" value="">
    <input type="hidden" name="company" id="company" value="">
    <input type="hidden" name="prefered_city" id="prefered_city" value="">
    <input type="hidden" name="date_status" id="date_status" value="">
    <input type="hidden" name="notice_id" id="notice_id" value="">
    <input type="hidden" name="notice_head" id="notice_head" value="">
    <input type="hidden" name="app_date1" id="app_date1" value="">
    <input type="hidden" name="app_date2" id="app_date2" value="">
    <input type="hidden" name="salary_wanted1" id="salary_wanted1" value="">
    <input type="hidden" name="salary_wanted2" id="salary_wanted2" value="">
    <input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="">
    <input type="hidden" name="status_app" id="status_app" value="">
        <input type="hidden" name="app_name" id="app_name" value="#get_app.name#">
        <input type="hidden" name="app_surname" id="app_surname" value="#get_app.surname#">
    <input type="hidden" name="birth_date1" id="birth_date1" value="">
    <input type="hidden" name="birth_date2" id="birth_date2" value="">
    <input type="hidden" name="birth_place" id="birth_place" value="">
    <input type="hidden" name="married" id="married" value="">
    <input type="hidden" name="city" id="city"  value="">
    <input type="hidden" name="sex" id="sex" value="">
    <input type="hidden" name="martyr_relative" id="martyr_relative" value="">
    <input type="hidden" name="is_trip" id="is_trip" value="">
    <input type="hidden" name="driver_licence" id="driver_licence" value="">
    <input type="hidden" name="driver_licence_type" id="driver_licence_type" value="">
    <input type="hidden" name="sentenced" id="sentenced" value="">
    <input type="hidden" name="defected" id="defected" value="">
    <input type="hidden" name="defected_level" id="defected_level" value="">
    <input type="hidden" name="email" id="email" value="">
    <input type="hidden" name="military_status" id="military_status" value="">
    <input type="hidden" name="homecity" id="homecity" value="">
    <input type="hidden" name="training_level" id="training_level" value="">
    <input type="hidden" name="edu_finish" id="edu_finish" value="">
    <input type="hidden" name="exp_year_s1" id="exp_year_s1" value="">
    <input type="hidden" name="exp_year_s2" id="exp_year_s2" value="">
    <input type="hidden" name="lang" id="lang" value="">
    <input type="hidden" name="lang_level" id="lang_level" value="">
    <input type="hidden" name="lang_par" id="lang_par" value="">
    <input type="hidden" name="edu3_part" id="edu3_part" value="">
    <input type="hidden" name="edu4_id" id="edu4_id" value="">
    <input type="hidden" name="edu4_part_id" id="edu4_part_id" value="">
    <input type="hidden" name="edu4" id="edu4" value="">
    <input type="hidden" name="edu4_part" id="edu4_part" value="">
    <input type="hidden" name="unit_id" id="unit_id" value="">
    <input type="hidden" name="unit_row" id="unit_row" value="">
    <input type="hidden" name="referance" id="referance" value="">
    <input type="hidden" name="tool" id="tool" value="">
    <input type="hidden" name="kurs" id="kurs" value="">
    <input type="hidden" name="other" id="other" value="">
    <input type="hidden" name="other_if" id="other_if" value="">
</cfoutput>
</form>
<script type="text/javascript">
var add_lang_info = <cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
$(document).ready(function(){
    disp_spouse();
    disp_child();
    tecilli_fonk(<cfoutput>#get_app.military_status#</cfoutput>);
    keep_info();

});
function keep_info()
{
<cfif isdefined('attributes.last_area') AND len(attributes.last_area)>
        var id_list=document.getElementsByName('<cfoutput>#attributes.last_area#</cfoutput>');
        var my_id=id_list[0].getAttribute('id');
        hepsini_gizle(my_id);
        cv_gizlegoster('<cfoutput>#attributes.last_area#</cfoutput>');
</cfif>
}
function visible_mil(gelen)
{
    if(gelen == 0)
    {
        military.style.display = 'none';
        Tecilli.style.display='none';
        Yapti.style.display='none';
        Muaf.style.display='none';
    }
    else
    {
        military.style.display = '';
        Yapti.style.display='';

    }
}
function hepsini_gizle(id)
{
    $('#handle_orta_box').text("").append("<a href='javascript://'>" + id + "</a>");
    for(var i=0;i<11;i++)
    {
        document.getElementById('gizli'+i).style.display='none';
    }

}
function referans_calistir()
{
    /*if(document.employe_detail.cv_type[0].checked == true)*/
    if($('input[name=cv_type]:checked').val() == 0)
    {
        gizle(referans_area);
    }
    else
    {
        goster(referans_area);
    }
}
var add_ref_info=<cfif isdefined("get_emp_reference")><cfoutput>#get_emp_reference.recordcount#</cfoutput><cfelse>0</cfif>;
function del_ref(dell){
    var my_emement1=eval("employe_detail.del_ref_info"+dell);
    my_emement1.value=0;
    var my_element1=eval("ref_info_"+dell);
    my_element1.style.display="none";
}
function add_ref_info_(){
    add_ref_info++;
    employe_detail.add_ref_info.value=add_ref_info;
    var newRow;
    var newCell;
    newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
    newRow.setAttribute("name","ref_info_" + add_ref_info);
    newRow.setAttribute("id","ref_info_" + add_ref_info);
    document.employe_detail.referance_info.value=add_ref_info;
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" style="width:75px;"><option value="">Referans Tipi</option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" style="width:90px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" style="width:90px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" style="width:90px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" style="width:90px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" style="width:90px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" style="width:90px;">';
}
var add_im_info=<cfif isdefined("get_ims")><cfoutput>#get_ims.recordcount#</cfoutput><cfelse>0</cfif>;
function del_im(dell){
    var my_emement1=eval("employe_detail.del_im_info"+dell);
    my_emement1.value=0;
    var my_element1=eval("im_info_"+dell);
    my_element1.style.display="none";
}
function add_im_info_(){
    add_im_info++;
    employe_detail.add_im_info.value=add_im_info;
    var newRow;
    var newCell;
    newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
    newRow.setAttribute("name","im_info_" + add_im_info);
    newRow.setAttribute("id","im_info_" + add_im_info);
    document.employe_detail.instant_info.value=add_im_info;
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a style="cursor:pointer" onclick="del_im(' + add_im_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="imcat_id' + add_im_info +'" style="width:"112px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput>/select>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML ='<input type="text" name="im' + add_im_info +'" style=" width:120px;">';
}
var extra_course = <cfif isdefined("get_emp_course")><cfoutput>'#get_emp_course.recordcount#'</cfoutput><cfelse>0</cfif>;
/*value="'+course_subject+'"value="'+course_year+'" value="'+course_location+'"value="'+course_period+'"*/
function sil_(del){
    var my_element_=eval("employe_detail.del_course_prog"+del);
    my_element_.value=0;
    var my_element_=eval("pro_course"+del);
    my_element_.style.display="none";

}
function sil_lang(del){
    var my_element_=eval("employe_detail.del_lang_prog"+del);
    my_element_.value=0;
    var my_element_=eval("pro_lang"+del);
    my_element_.style.display="none";

}

function add_row_course(){
    extra_course++;
    employe_detail.extra_course.value = extra_course;
    var newRow;
    var newCell;
    newRow = document.getElementById("add_course_pro").insertRow(document.getElementById("add_course_pro").rows.length);
    newRow.setAttribute("name","pro_course" + extra_course);
    newRow.setAttribute("id","pro_course" + extra_course);
    document.employe_detail.extra_course.value=extra_course;
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + extra_course +'"><a style="cursor:pointer" onclick="sil_(' + extra_course + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="kurs1_' + extra_course +'" style="width:115px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="kurs1_yer' + extra_course +'" style="width:115px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="kurs1_exp' + extra_course +'" style="width:140px;"  maxlength="200">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="kurs1_yil' + extra_course +'"  maxlength="4" onKeyup="isNumber(this);" style="width:115px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="kurs1_gun' + extra_course +'"  style="width:115px;">';
}

function add_select_list()
{
       
        var form = $('form[name = create_selected_list]');
	openBoxDraggable( decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list</cfoutput>&' + form.serialize() ).replaceAll("+", " ") );
    /*document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
    /*document.create_selected_list.list_app_pos_id.value='';*/
    
    
}
function edit_select_list(type)
{
    var form = $('form[name = create_selected_list]');
    if(!type)
        type = 0;
	openBoxDraggable( decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1</cfoutput>&' + form.serialize() ).replaceAll("+", " ")+'&type='+type );
  
    // windowopen('','list','select_list_window');
    //     create_selected_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfoutput>';<!--- <cfif not len(get_app_pos.app_pos_id)>&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfif>--->
    // create_selected_list.target='select_list_window';
    // create_selected_list.submit();
    /*document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
   /* document.create_selected_list.list_app_pos_id.value='';*/

}
//document.employe_detail.upload_status.style.display = 'none';
<!---özürlü seviyesi select pasif aktif yapma--->
function seviye()
{
    if(document.getElementById('defected_level').disabled==true)
    {document.getElementById('defected_level').disabled=false;}
    else
    {document.getElementById('defected_level').disabled=true;}
    if($('#defected:checked').val() == 1)
    {
        $('#defectedRatio').css('display','');
    }
    else
    {
        $('#defectedRatio').css('display','none');
    }
}
function pencere_ac()
{
    x = document.employe_detail.homecountry.selectedIndex;
if (document.employe_detail.homecountry[x].value == "")
{
alert("<cf_get_lang dictionary_id ='56176.İlk Olarak Ülke Seçiniz'>.");
}
else if(document.employe_detail.homecity.value == "")
{
alert("<cf_get_lang dictionary_id ='56490.İl Seçiniz'>!");
}
else
{
windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.employe_detail.homecity.value,'small');
}
}
function pencere_ac_city()
{
    x = document.employe_detail.homecountry.selectedIndex;
if (document.employe_detail.homecountry[x].value == "")
{
alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'> !");
}
else
{
windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.employe_detail.homecountry.value,'small');
}
}

//departmanlar
<cfoutput>
    <cfif get_cv_unit.recordcount>
        unit_count=#get_cv_unit.recordcount#;
    <cfelse>
        unit_count=0;
    </cfif>
</cfoutput>
function seviye_kontrol(nesne)
{
for(var j=1;j<=unit_count;j++)
{
    diger_nesne=eval("document.employe_detail.unit"+j);
if(diger_nesne!=nesne)
{
if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
{
alert("<cf_get_lang dictionary_id ='56491.İki tane aynı seviye giremezsiniz'>!");
    diger_nesne.value='';
}
}
}
}
function kontrol()
{

    var obj =  document.employe_detail.photo.value;
if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
{
alert("<cf_get_lang dictionary_id ='56078.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");
    return false;
}
    for (var counter_=1; counter_ <=  document.employe_detail.extra_course.value; counter_++)
    {
        if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 && eval("document.employe_detail.kurs1_"+counter_).value == '')
        {
            alert(+ counter_ + "<cf_get_lang dictionary_id='37581.Lütfen Kurs İçin Konu Giriniz'>!");
            return false;
        }
        if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 &&  (eval("document.employe_detail.kurs1_yil"+counter_).value == '' || eval("document.employe_detail.kurs1_yil"+counter_).value.length <4))
        {
            alert(+ counter_ + "<cf_get_lang dictionary_id='37579.Lütfen Kurs İçin Yıl Giriniz'>!");
            return false;
        }
    }
    for (var counter_=1; counter_ <=  document.employe_detail.referance_info.value; counter_++)
    {
        if(eval("document.employe_detail.ref_name"+counter_).value == '' && eval("document.employe_detail.del_ref_info"+counter_).value == 1)
        {
            alert(+ counter_ + "<cf_get_lang dictionary_id='41450.Lütfen Satır İçin Ad Soyad Giriniz'>!");
            return false;
        }

    }
if(document.getElementById('imcat_id')!= null){
    var imcat = document.getElementById('imcat_id').selectedIndex;
if(document.employe_detail.imcat_id[imcat].value != "")
{
if(document.employe_detail.im.value.length == 0)
{
alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30738.IMessege Kategorisi seçilmiş fakat Instant Mesaj adresi girilmemiş'>!");
    document.employe_detail.im.focus();
    return false;
}
}
}
    employe_detail.expected_price.value=filterNum(employe_detail.expected_price.value);
    process_cat_control();
    return  true;
}

function tecilli_fonk(gelen)
{
    if (gelen == 4)
    {
        $('#Tecilli').css('display','');
        $('#Yapti').css('display','none');
        $('#Muaf').css('display','none');
    }
    else if(gelen == 1)
    {
        $('#Yapti').css('display','');
        $('#Tecilli').css('display','none');
        $('#Muaf').css('display','none');
    }
    else if(gelen == 2)
    {
        $('#Muaf').css('display','');
        $('#Tecilli').css('display','none');
        $('#Yapti').css('display','none');
    }
    else
    {
        $('#Tecilli').css('display','none');
        $('#Yapti').css('display','none');
        $('#Muaf').css('display','none');
    }
}

/*yakınlar için*/
<cfif get_relatives.recordcount gt 0>
    rowCount=<cfoutput>#get_relatives.recordcount#</cfoutput>;
    employe_detail.rowCount.value = rowCount;
<cfelse>
    rowCount=0;
</cfif>

function addRow()
{
    rowCount++;
    satir_say++;
    employe_detail.rowCount.value = rowCount;
    var newRow;
    var newCell;
    newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
    newRow.setAttribute("name","frm_row" + rowCount);
    newRow.setAttribute("id","frm_row" + rowCount);
    newRow.setAttribute("NAME","frm_row" + rowCount);
    newRow.setAttribute("ID","frm_row" + rowCount);

    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<a href="javascript://" onClick="relative_sil('+rowCount+');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="hidden" id="relative_sil'+rowCount+'" name="relative_sil'+rowCount+'" value="0">';
    newCell.innerHTML += '<input type="text" name="name_relative' + rowCount + '" id="name_relative' + rowCount + '" value="" style="width:75px;">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="surname_relative' + rowCount + '" id="surname_relative' + rowCount + '" style="width:75px;">';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="relative_level' + rowCount + '" style="width:105px;"><option value="1"><cf_get_lang dictionary_id="55265.Babası"></option><option value="2"><cf_get_lang dictionary_id="55470.Annesi"></option><option value="3"><cf_get_lang dictionary_id="55275.Eşi"></option><option value="4"><cf_get_lang dictionary_id="55253.Oğlu"></option><option value="5"><cf_get_lang dictionary_id="55234.Kızı"></option><option value="6">Kardeşi</option></select>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" maxlength="10" value=""><span class="input-group-addon" id="birth_date_relative' + rowCount + '_td"></span></div></div> ';
    wrk_date_image('birth_date_relative' + rowCount);
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="birth_place_relative' + rowCount + '" value="" style="width:75px;">';
    /*newCell = newRow.insertCell();
    newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="" style="width:75px;">';*/
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-md-6 col-sm-6 col-xs-12"><select name="education_relative' + rowCount + '"> <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select></div><div class="col col-6 col-md-6 col-sm-6 col-xs-12"><div class="input-group"><label><cf_get_lang dictionary_id="55483.Okuyor"></label><span class="input-group-addon"><input type="checkbox" name="education_status_relative' + rowCount + '" value="1"></span></div></div></div>';

    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="job_relative' + rowCount + '" style="width:75px;" value="">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="company_relative' + rowCount + '" style="width:75px;" value="">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="job_position_relative' + rowCount + '" style="width:75px;" value="">';

}
function relative_sil(satir)
{
    var my_element=eval("employe_detail.relative_sil"+satir);
    my_element.value=0;
    var my_element=eval("frm_row"+satir);
    my_element.style.display="none";
    satir_say--;
}

/*iş tecrübeleri*/
row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
satir_say=0;

function sil(sy)
{
    var my_element=eval("employe_detail.row_kontrol"+sy);
    my_element.value=0;
    var my_element=eval("frm_row"+sy);
    my_element.style.display="none";
    satir_say--;
}

function gonder_upd(count)
{
    form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
    form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
    form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
    form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
    form_work_info.exp_work_type_id_new.value = eval("employe_detail.exp_work_type_id"+count).value;
    form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
    form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
    form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
    form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
    form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
    form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
    form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
    form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
    form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
    /* windowopen('','medium','kariyer_pop');
    form_work_info.target='kariyer_pop'; 
    form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
    form_work_info.submit(); */

    var form = $('form[name = form_work_info]');
	openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>&'+form.serialize()).replaceAll("+", " "));
}

function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_work_type_id,exp_work_type_name,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
{
    if(control == 1)
    {
        eval("employe_detail.exp_name"+my_count).value=exp_name;
        eval("employe_detail.exp_position"+my_count).value=exp_position;
        eval("employe_detail.exp_start"+my_count).value=exp_start;
        eval("employe_detail.exp_finish"+my_count).value=exp_finish;
        eval("employe_detail.exp_sector_cat"+my_count).value=exp_sector_cat;
        if(exp_sector_cat != '')
        {
            var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
            /*if(get_emp_cv_new.recordcount)*/
            var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
        }
        else
            var exp_sector_cat_name = '';
        eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
        eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
        if(exp_task_id != '')
        {
            var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
            /*if(get_emp_task_cv_new.recordcount)*/
            var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
        }
        else
            var exp_task_name = '';
        eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
        eval("employe_detail.exp_work_type_id"+my_count).value=exp_work_type_id;

        if(exp_work_type_id != '')
        {
            //var get_emp_work_type_cv_new = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
            /*if(get_emp_work_type_cv_new.recordcount)*/
            var exp_work_type_name = exp_work_type_name;
        }
        else
            var exp_work_type_name = '';
        eval("employe_detail.exp_work_type_name"+my_count).value=exp_work_type_name;
        eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
        eval("employe_detail.exp_tel"+my_count).value=exp_tel;
        eval("employe_detail.exp_salary"+my_count).value=exp_salary;
        eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
        eval("employe_detail.exp_extra"+my_count).value=exp_extra;
        eval("employe_detail.exp_reason"+my_count).value=exp_reason;
        eval("employe_detail.is_cont_work"+my_count).value=is_cont_work;
    }
    else
    {
        row_count++;
        employe_detail.row_count.value = row_count;
        satir_say++;
        var new_Row;
        var new_Cell;
        new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
        new_Row.setAttribute("name","frm_row" + row_count);
        new_Row.setAttribute("id","frm_row" + row_count);
        new_Row.setAttribute("NAME","frm_row" + row_count);
        new_Row.setAttribute("ID","frm_row" + row_count);

        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
        new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_work_type_id' + row_count + '" value="'+ exp_work_type_id +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
        new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
        new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
        if(exp_sector_cat != '')
        {
            var get_emp_cv = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
            /*if(get_emp_cv.recordcount)*/
            var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
        }
        else
            var exp_sector_cat_name = '';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
        if(exp_task_id != '')
        {
            var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
            /*if(get_emp_task_cv.recordcount)*/
            var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
        }
        else
            var exp_task_name = '';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" style="width:100px;" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
        if(exp_work_type_id != '' && exp_work_type_name  == '')
        {
            var get_emp_work_type_cv = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
            /*if(get_emp_task_cv.recordcount)*/
            var exp_work_type_name = get_emp_work_type_cv.WORK_TYPE_NAME;
        }
        else if(exp_work_type_id != '' && exp_work_type_name  != '')
        {
           
            var exp_work_type_name = exp_work_type_name;
        }
        else
            var exp_work_type_name = '';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" style="width:100px;" name="exp_work_type_name' + row_count + '" value="'+exp_work_type_name+'" class="boxtext" readonly>';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" style="width:70px;" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
        new_Cell = new_Row.insertCell(new_Row.cells.length);
        new_Cell.innerHTML = '<input type="text" style="width:70px;" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
    }
}
/*iş tecrübeleri*/

/*eğitim bilgileri*/
row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
satir_say_edu=0;

function sil_edu(sv)
{
    var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
    my_element_edu.value=0;
    var my_element_edu=eval("frm_row_edu"+sv);
    my_element_edu.style.display="none";
    satir_say_edu--;
}

function gonder_training(count_new)
{

    form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
    if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
        form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
    else
        form_edu_info.edu_id_new.value = '';

    if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
        form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
    else
        form_edu_info.edu_name_new.value = '';

    form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
    form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
    form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
    if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
        form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
    else
        form_edu_info.edu_high_part_id_new.value = '';

    if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
        form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
    else
        form_edu_info.edu_part_id_new.value = '';

    if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
        form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
    else
        form_edu_info.edu_part_name_new.value = '';
    form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
    windowopen('','medium','kryr_pop');
    form_edu_info.target='kryr_pop';
        form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
    form_edu_info.submit();
}

function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,is_edu_continue,edu_part_name)
{
    var edu_type = edu_type.split(';')[0];
    if(ctrl_edu == 1)
    {
        eval("employe_detail.edu_type"+count_edu).value=edu_type;
        if(edu_type != undefined && edu_type != '')
        {
            var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
            if(get_edu_part_name_sql.recordcount)
                var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
        }

        eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
        eval("employe_detail.edu_id"+count_edu).value=edu_id;
        eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
        eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
        if(edu_id != '' && edu_id != -1)
        {

            var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
            if(get_cv_edu_new.recordcount)
                var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
            eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
        }
        else
        {
            var edu_name_degisken = edu_name;
            eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
        }
        eval("employe_detail.edu_start"+count_edu).value=edu_start;
        eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
        eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
        if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1)
        {

            var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
            if(get_cv_edu_high_part_id.recordcount)
                var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
            eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
        }
        else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
        {

            var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
            if(get_cv_edu_part_id.recordcount)
                var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
            eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
        }
        else
        {
            var edu_part_name_degisken = edu_part_name;
            eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
        }
        eval("employe_detail.is_edu_continue"+count_edu).value=is_edu_continue;
    }
    else
    {
        row_edu++;
        employe_detail.row_edu.value = row_edu;
        satir_say_edu++;
        var new_Row_Edu;
        var new_Cell_Edu;
        new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
        new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
        new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);
        new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
        new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);

        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        new_Cell_Edu.innerHTML = '<a style="cursor:pointer" href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        new_Cell_Edu.innerHTML = '<input style="display:none;" type="hidden" id="row_kontrol_edu' + row_edu + '" value="1" name="row_kontrol_edu' + row_edu +'" ><a style="cursor:pointer" href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
        new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
        new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_id' + row_edu + '" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
        new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_high_part_id' + row_edu + '" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" class="boxtext" readonly>';
        new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_part_id' + row_edu + '" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" class="boxtext" readonly>';
        new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="is_edu_continue' + row_edu + '" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" class="boxtext" readonly>';


        if(edu_type != undefined && edu_type != '')
        {
            var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
            if(get_edu_part_name_sql.recordcount)
                var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
        }
        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        new_Cell_Edu.innerHTML = '<input style="width:80px;" type="text" id="edu_type_name' + row_edu + '" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
        if(edu_id != '' && edu_id != -1)
        {
            var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
            if(get_cv_edu_new.recordcount)
                var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input style="width:185px;" id="edu_name' + row_edu + '" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
        }
        else
        {
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input style="width:185px;" type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
        }
        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        //new_Cell_Edu.innerHTML = '<input style="width:10px;" type="text" id="gizli' + row_edu + '" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
        //new_Cell_Edu = new_Row_Edu.insertCell();
        new_Cell_Edu.innerHTML = '<input style="width:70px;" type="text" id="edu_start' + row_edu + '" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        new_Cell_Edu.innerHTML = '<input style="width:70px;" type="text" id="edu_finish' + row_edu + '" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
        new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
        new_Cell_Edu.innerHTML = '<input type="text" id="edu_rank' + row_edu + '" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
        if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
        {

            var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
            if(get_cv_edu_high_part_id.recordcount)
                var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input style="width:100px;" type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
        }
        else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
        {

            var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
            if(get_cv_edu_part_id.recordcount)
                var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input style="width:100px;" type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
        }
        else
        {
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input style="width:100px;" id="edu_part_name' + row_edu + '" type="text" name="edu_part_name' + row_edu + '" value="" class="boxtext" readonly>';
        }
    }
}
function gonder_upd_edu(count_new)
{

    form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
    if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
        form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
    else
        form_edu_info.edu_id_new.value = '';

    if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
        form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
    else
        form_edu_info.edu_name_new.value = '';

    form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
    form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
    form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
    if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
        form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
    else
        form_edu_info.edu_high_part_id_new.value = '';

    if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
        form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
    else
        form_edu_info.edu_part_id_new.value = '';

    if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
        form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
    else
        form_edu_info.edu_part_name_new.value = '';
    form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
    windowopen('','medium','kryr_pop');
    form_edu_info.target='kryr_pop';
        form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
    form_edu_info.submit();
}
/* Dil Bilgileri */
function del_lang(dell){
    var my_emement1=eval("employe_detail.del_lang_info"+dell);
    my_emement1.value=0;
    var my_element1=eval("lang_info_"+dell);
    my_element1.style.display="none";
}
function add_lang_info_()
{
    add_lang_info++;
    document.getElementById('add_lang_info').value=add_lang_info;
    var newRow;
    var newCell;
    newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
    newRow.setAttribute("name","lang_info_" + add_lang_info);
    newRow.setAttribute("id","lang_info_" + add_lang_info);
    employe_detail.language_info.value=add_lang_info;

    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a style="cursor:pointer" onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang' + add_lang_info +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id="58996.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_speak' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_mean' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
    newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_write' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="lang_where' + add_lang_info + '" value="">';
}
function disp_spouse()
{
    if($('#married:checked').val() == 1)
    {
        $('#form_ul_partner_name').css('display','');
        $('#form_ul_partner_position').css('display','');
        $('#form_ul_partner_company').css('display','');
    }
    else
    {
        $('#form_ul_partner_name').css('display','none');
        $('#form_ul_partner_position').css('display','none');
        $('#form_ul_partner_company').css('display','none');
    }
}
function disp_child()
{
    if($('#have_children:checked').val() == 1)
        $('#form_ul_child').css('display','');
    else
        $('#form_ul_child').css('display','none');
}
function cv_gizlegoster(id)
{
    try{
        if(id.style.display=='')
        {
            id.style.display='none';
        } else {
            id.style.display='';
        }

        document.getElementById("selected_menu_info").value=id.id;
    }
    catch(e)
    {
        try{
            if($("#"+id).css('display')=='' || $("#"+id).css('display')=='block')
            {
                $("#"+id).css('display','none');
            } else {
                $("#"+id).css('display','');
            }
        }
        catch(e)
        {

        }
    }
}
</script>
