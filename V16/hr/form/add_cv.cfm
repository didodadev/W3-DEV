<cf_xml_page_edit fuseact="hr.add_cv">
<cfinclude template="../query/get_id_card_cats.cfm">
<cfinclude template="../query/get_mobil_cats.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm">
<cfparam name="attributes.homecity" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.homecounty" default="">
<cfparam name="attributes.branch_id" default="#listgetat(session.ep.USER_LOCATION,2,'-')#">
<cfquery name="get_unv" datasource="#dsn#">
    SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
    SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
    SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_cv_status" datasource="#dsn#">
    SELECT 
        STATUS_ID,
        ICON_NAME,
        STATUS
    FROM
        SETUP_CV_STATUS
</cfquery>
<cfquery name="get_hr_detail" datasource="#dsn#">
    SELECT * FROM EMPLOYEES_DETAIL
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
    SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
    SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
    SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
    SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_country2" dbtype="query" maxrows="1">
    SELECT COUNTRY_ID FROM get_country WHERE IS_DEFAULT = 1	
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
<cfquery name="get_cv_source" datasource="#dsn#">
    SELECT CV_SOURCE_ID,SOURCE_HEAD FROM SETUP_CV_SOURCE ORDER BY SOURCE_HEAD
</cfquery>
<cf_catalystHeader>
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_cv" enctype="multipart/form-data">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
            <cf_box>
                <ul class="ui-list" id="box_title">
                    <li id="<cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'>" name="gizli0" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli0)"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'></div></a></li>
                    <li id="<cf_get_lang dictionary_id='55126.Kişisel Bilgiler'>" name="gizli1" style="cursor:pointer;" onClick="hepsini_gizle(id);cv_gizlegoster(gizli1);"><a><div class="ui-list-left"><span class="ui-list-icon ctl-test"></span><cf_get_lang dictionary_id='55126.Kişisel Bilgiler'></div></a></li>
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

        <div class="col col-10 col-md-10 col-sm-10 col-xs-12">
            <cf_box id="orta_box" title="#getLang('','Kimlik ve İletişim Bilgileri','31647')#">
                <cf_box_elements>
                    <!--- Kimlik Bilgileri --->
                    <div id="gizli0">
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-cv_type">
                                <div class="col col-12">
                                <label class="col col-4 col-xs-12">&nbsp</label>
                                <label class="col col-4 col-xs-12"><input type="radio" value="0" name="cv_type" id="cv_type" checked="checked" onclick="referans_calistir();"><cf_get_lang dictionary_id="57612.Fırsat"> <cf_get_lang dictionary_id="29767.CV"></label>
                                <label class="col col-4 col-xs-12"><input type="radio" value="1" name="cv_type" id="cv_type" onclick="referans_calistir();"><cf_get_lang dictionary_id="58784.Referans"> <cf_get_lang dictionary_id="29767.CV"></label>
                                </div>
                            </div>
                            <div id="referans_area" style="display:none;">
                                <div class="form-group" id="item-reference_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58784.Referans"> <cf_get_lang dictionary_id="55757.Adı Soyadı"></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                        <cfinput type="text" name="reference_name" id="reference_name"  maxlength="50">
                                            <span class="input-group-addon no-bg"></span>
                                        <cfinput type="text" name="reference_surname"  maxlength="50">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-reference_position">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58784.Referans"> <cf_get_lang dictionary_id="53916.Görevi"></label>
                                    <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="reference_position" id="reference_position"   maxlength="100">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="item-cv_recorder_emp_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37619.Giriş Yapan"></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="hidden" name="cv_recorder_emp_id" id="cv_recorder_emp_id" value="#session.ep.userid#">
                                    <cfinput type="text" name="cv_recorder_emp_name" id="cv_recorder_emp_name"  value="#session.ep.name# #session.ep.surname#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employe_detail.cv_recorder_emp_name&field_emp_id=employe_detail.cv_recorder_emp_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57453.Şube"></label>
                                <div class="col col-8 col-xs-12">
                                <select name="branch_id" id="branch_id" >
                                        <option value=""><cf_get_lang dictionary_id="57453.Şube"></option>
                                        <cfoutput query="get_our_comp_and_branchs">
                                            <option value="#branch_id#"<cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-tax_office">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="tax_office" id="tax_office"  maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-tax_number">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="tax_number" id="tax_number"  maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-identycard_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55903.Kimlik Kartı No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="identycard_no" id="identycard_no" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-password">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55439.Şifre*(case sensitive)'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput value="" type="password" name="empapp_password" id="empapp_password" maxlength="16" message="Şifre">
                                </div>
                            </div>
                            <div class="form-group" id="item-cv_source">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59127.CV Kaynağı"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="cv_source" id="cv_source" >
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_cv_source">
                                            <option value="#cv_source_id#">#source_head#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                            <cf_seperator title="#getLang('','Kimlik Bilgileri','55127')#" id="kimlik_" style="display:none;">
                            <div id="kimlik_">
                                <div class="form-group" id="item-nationality2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="nationality" id="nationality" >
                                            <cfoutput query="get_country">
                                                <option value="#country_id#"<cfif get_country.is_default eq 1>selected</cfif>>#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-TC_IDENTY_NO">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31325.TC Kimlik No girmelisiniz'></cfsavecontent>
                                        <cfif xml_is_tc_number eq 1>
                                            <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO"  validate="integer" message="#message#" maxlength="11" required="yes">
                                        <cfelse>
                                            <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO"  validate="integer" maxlength="11">
                                        </cfif>
                                    </div>
                                </div>
                                <div class="form-group" id="item-name_">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '> !</cfsavecontent>
                                        <cfinput type="text" name="name_" id="name_"  maxlength="50" required="Yes" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-surname">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                                        <cfinput type="text" name="surname" id="surname"  maxlength="50" required="Yes" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_place">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text"  name="birth_place" id="birth_place" maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_city">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'> <cf_get_lang dictionary_id='58608.İl'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="birth_city" id="birth_city" >
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <cfoutput query="get_city">
                                                <option value="#city_id#">#city_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-birth_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarih'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55788.Doğum Tarihi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text"  name="birth_date" id="birth_date" value="" validate="#validate_style#" maxlength="10" message="Doğum Tarihi !">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sex">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="sex" id="sex" value="1" checked onclick="document.getElementById('trAskerlik').style.display='inline'; document.getElementById('military_status').checked = true;"><cf_get_lang_main no='1547.Erkek'></label>
                                        <label><input type="radio" name="sex" id="sex" value="0" onclick="document.getElementById('trAskerlik').style.display = 'none'; document.getElementById('military_status').checked = false;"><cf_get_lang no='536.Kadın'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-married">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55654.Medeni Durum'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="married" id="married" value="0" checked onchange="disp_spouse()"><cf_get_lang dictionary_id='55744.Bekar'></label>
                                        <label><input type="radio" name="married" id="married" value="1" onchange="disp_spouse()"><cf_get_lang dictionary_id='55743.Evli'></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="3" sort="true">
                            <cf_seperator title="#getLang('','İletişim Bilgileri','56512')#" id="iletisim_" style="display:none;">
                            <div id="iletisim_">
                                <div class="form-group" id="item-mobilcode2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="mobilcode" id="mobilcode" style="width:40px;" maxlength="3" validate="integer" message="#message#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cfinput type="text" name="mobil" id="mobil" style="width:107px;" maxlength="7" validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-hometelcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55593.Ev Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55601.Ev Telefonu girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="hometelcode" id="hometelcode" style="width:40px;" maxlength="3" validate="integer" message="#message#" >
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cfinput type="text" name="hometel" id="hometel" style="width:107px;" maxlength="7" validate="integer" message="#message#" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-homeaddress">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55594.Ev Adresi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id='1687.Fazla karakter sayısı'></cfsavecontent>
                                        <textarea name="homeaddress" id="homeaddress"  style="width:150px;height:85px;" message="<cfoutput>#message2#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="item-worktelcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55445.Direkt Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Direkt Telefon girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="worktelcode" id="worktelcode" style="width:48px;" maxlength="3" validate="integer" message="#message#">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cfinput type="text" name="worktel" id="worktel" style="width:99px;" maxlength="7" validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-home_status">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="home_status" id="home_status" >
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1"><cf_get_lang dictionary_id='56132.Kendinizin'></option>
                                            <option value="2"><cf_get_lang dictionary_id='56133.Ailenizin'></option>
                                            <option value="3"><cf_get_lang dictionary_id='56134.Kira'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-photo">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55110.Fotoğraf'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="file" name="photo" id="photo" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-identycard_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55902.Kimlik Kartı Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrk_combo 
                                            query_name="GET_IDENTYCARD" 
                                            name="identycard_cat" 
                                            option_value="identycat_id" 
                                            option_name="identycat"
                                            width="150">
                                    </div>
                                </div>
                                <div class="form-group" id="item-CITY">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='70.Nüfusa Kayıtlı Olduğu İl'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="CITY" id="CITY"  maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-email">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="email" id="email"  maxlength="100" validate="email" message="E-mail adresini giriniz!">
                                    </div>
                                </div>
                                <div class="form-group" id="item-mobilcode2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
                                    <div class="col col-3 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="mobilcode2" id="mobilcode2" maxlength="3" validate="integer" message="#message#" style="width:40px;">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cfinput type="text" name="mobil2" id="mobil2" style="width:107px;" maxlength="7" validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-homepostcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55595.Posta Kodu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="homepostcode" id="homepostcode"  maxlength="10">
                                    </div>
                                </div>
                                <div class="form-group" id="item-homecountry">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="homecountry" id="homecountry"  onChange="LoadCity(this.value,'homecity','county_id');">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#get_country.country_id#" <cfif get_country2.recordcount and get_country2.country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-homecity">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="homecity" id="homecity"  onChange="LoadCounty(this.value,'county_id');">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif isdefined('attributes.homecountry') and len(attributes.homecountry)>
                                                <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #attributes.homecountry#
                                                </cfquery>
                                                <cfoutput query="GET_CITY_NAME">
                                                    <option value="#city_id#"<cfif attributes.homecity eq city_id>selected</cfif>>#city_name#</option>
                                                </cfoutput>
                                            <cfelseif get_country2.recordcount>
                                                <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #get_country2.country_id#
                                                </cfquery>
                                                <cfoutput query="GET_CITY_NAME">
                                                    <option value="#city_id#"<cfif attributes.homecity eq city_id>selected</cfif>>#city_name#</option>
                                                </cfoutput>                                                            
                                            </cfif>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-county_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="county_id" id="county_id" >
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif isdefined('attributes.homecity') and len(attributes.homecity)>
                                                <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                                                    SELECT * FROM SETUP_COUNTY WHERE CITY = #attributes.homecity#
                                                </cfquery>
                                                <cfoutput query="get_county_name">
                                                    <option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-extension">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55446.Dahili Tel'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='368.Dahili Telefon girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="extension" id="extension"  maxlength="5" validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-resource">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
                                    <div class="col col-8 col-sm-12">
                                        <cf_wrk_combo 
                                            name="resource"
                                            query_name="GET_PARTNER_RESOURCE"
                                            value=""
                                            option_name="resource"
                                            option_value="resource_id"
                                            width="150">
                                    </div>                
                                </div>
                                <div class="form-group" id="item-not_want_email">
                                    <label class="col col-4 col-xs-12" for="not_want_email"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="not_want_email" id="not_want_email" value="0">
                                    </div>
                                </div>
                                <div class="form-group" id="item-not_want_sms">
                                    <label class="col col-4 col-xs-12" for="not_want_sms"><cf_get_lang dictionary_id='30741.SMS Almak İstemiyorum'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="not_want_sms" id="not_want_sms" value="0">
                                    </div>
                                </div>
                                <div class="form-group" id="item-not_want_call">
                                    <label class="col col-4 col-xs-12" for="not_want_call"><cf_get_lang dictionary_id='64230.I do not want to receive voice calls'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="not_want_call" id="not_want_call" value="0">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="4" sort="true">
                            <cf_seperator title="#getLang('','Bağlantı Kurulacak Kişi','55597')#" id="contact_1" style="display:none;">
                            <div id="contact_1">
                                <div class="form-group" id="item-contact2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact" maxlength="40">
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_telcode">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Tel'></label>
                                    <div class="col col-3 col-xs-12">
                                        <cfinput type="text" name="contact_telcode" id="contact_telcode" maxlength="3" validate="integer">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <cfinput type="text" name="contact_tel" id="contact_tel" maxlength="7" validate="integer">
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_relation">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55693.Yakınlık'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact_relation" maxlength="40">
                                    </div>
                                </div>
                                <div class="form-group" id="item-contact_email">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.Email'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="contact_email" maxlength="50">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" index="5" sort="true">
                            <cf_seperator title="#getLang('','Instant Message','55444')#" id="instant_message" style="display:none;">
                                <div id="instant_message">
                                    <div class="form-group" id="item-add_im_info2">
                                        <cf_grid_list class="workDevList">
                                    <thead>
                                        <input type="hidden" name="add_im_info" id="add_im_info" value="0">
                                        <tr>
                                            <th width="20"><a style="cursor:pointer" onClick="add_im_info_();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="112px"><cf_get_lang dictionary_id='57630.Tip'></th>
                                            <th width="120"><cf_get_lang dictionary_id='55686.Mail Adresi'></th>
                                        </tr>
                                        <input type="hidden" name="instant_info" id="instant_info" value="">
                                    </thead>
                                    <tbody id="im_info"> </tbody>
                                        </cf_grid_list>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                            <div class="col col-6 col-xs-12">
                                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55126.Kişisel Bilgiler'>');goster(gizli1);"/></div>
                            </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!--- Kimlik detayları--->
                    <div id="gizli1" style="display:none";>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="6" sort="true">
                                <div class="form-group" id="form_ul_partner_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56136.Eşinin Adı'></label>
                                    <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="partner_name" id="partner_name" value="" maxlength="150" >
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_partner_position">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55633.Eşinin Pozisyonu'></label>
                                    <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="partner_position" id="partner_position" maxlength="50" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-use_cigarette">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56138.Sigara Kullanıyor mu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="use_cigarette" id="use_cigarette"  value="1"><cf_get_lang dictionary_id ='57495.Evet'></label>
                                        <label><input type="radio" name="use_cigarette" id="use_cigarette" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-defected">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55614.Engelli'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="defected" id="defected" value="1" onClick="seviye();"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="defected" id="defected" value="0" checked onClick="seviye();"><cf_get_lang dictionary_id='57496.Hayır'> &nbsp;&nbsp;&nbsp;</label>
                                    </div>
                                </div>
                                <div class="form-group" id="defectedRatio" style="display:none;">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55614.Engelli'><cf_get_lang dictionary_id="58671.Oranı"></label>
                                    <div class="col col-4 col-xs-12">
                                        <select name="defected_level" id="defected_level" disabled>
                                            <option value="0">%0</option>
                                            <option value="10">%10</option>
                                            <option value="20">%20</option>
                                            <option value="30">%30</option>
                                            <option value="40">%40</option>
                                            <option value="50">%50</option>
                                            <option value="60">%60</option>
                                            <option value="70">%70</option>
                                            <option value="80">%80</option>
                                            <option value="90">%90</option>
                                            <option value="100">%100</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sentenced">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="sentenced" id="sentenced" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="sentenced" id="sentenced" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-immigrant">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55432.Göçmen'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="immigrant" id="immigrant" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="immigrant" id="immigrant" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-driver_licence_actived">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56140.Kaç yıldır aktif olarak araba kullanıyorsunuz'></label>
                                <div class="col col-6 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="31690.Ehliyet Aktiflik Süresine Sayı Giriniz"></cfsavecontent>
                                    <cfinput type="Text" name="driver_licence_actived" id="driver_licence_actived" maxlength="2"   validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-defected_probability">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="defected_probability" id="defected_probability" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="defected_probability" id="defected_probability" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-investigation">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55341.Varsa nedir?'></label>
                                <div class="col col-6 col-xs-12">
                                    <cfinput type="text" name="investigation" id="investigation" value="" maxlength="150" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-illness_probability">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55342.Devam eden bir hastalık veya bedeni sorununuz var mı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="illness_probability" id="illness_probability" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="illness_probability" id="illness_probability" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-illness_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55341.Varsa nedir?'></label>
                                <div class="col col-6 col-xs-12">
                                    <textarea name="illness_detail" id="illness_detail" ></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="trAskerlik">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55619.Askerlik'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="military_status" id="military_status" value="0" onClick="tecilli_fonk(this.value)" checked><cf_get_lang dictionary_id='55624.Yapmadı'></label>
                                        <label><input type="radio" name="military_status" id="military_status" value="1" onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55625.Yaptı'></label>
                                        <label><input type="radio" name="military_status" id="military_status" value="2" onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55626.Muaf'></label>
                                        <label><input type="radio" name="military_status" id="military_status" value="3" onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55627.Yabancı'></label>
                                        <label><input type="radio" name="military_status" id="military_status" value="4" onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='55340.Tecilli'></label>
                                    </div>
                                </div>
                                <div style="display:none;" id="Yapti">
                                    <div class="form-group" id="item-military_finishdate">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56144.Terhis Tarihi'></label>
                                    <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text"  name="military_finishdate" id="military_finishdate" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-military_month">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56145.Süresi'> (<cf_get_lang dictionary_id='56146.Ay Olarak Giriniz'>)</label>
                                    <div class="col col-6 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='56147.Askerlik Süresi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="military_month" id="military_month" validate="integer" maxlength="2" message="#message#" >
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-military_rank">
                                    
                                    <label class="col col-4 col-xs-12">&nbsp</label>
                                    <label class="col col-1 col-xs-12"><input type="radio" name="military_rank" id="military_rank" value="0"> <cf_get_lang dictionary_id='56148.Er'></label>
                                    <label class="col col-4 col-xs-12"><input type="radio" name="military_rank" id="military_rank" value="1"> <cf_get_lang dictionary_id='56149.Yedek Subay'></label>
                                    
                                    </div>
                                </div>
                                <div style="display:none;" id="Muaf">
                                    <div class="form-group" id="item-military_exempt_detail">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56143.Muaf Olma Nedeni'></label>
                                    <div class="col col-6 col-xs-12">
                                        <input type="text"  name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="">
                                        </div>
                                    </div>
                                </div>
                                <div style="display:none;" id="Tecilli">
                                    <div class="form-group" id="item-military_delay_reason">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></label>
                                    <div class="col col-6 col-xs-12">
                                        <cfinput type="text" name="military_delay_reason" id="military_delay_reason"  maxlength="30">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-military_delay_date">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55338.Tecil Süresi'></label>
                                    <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text"  name="military_delay_date" id="military_delay_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="military_delay_date"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="7" sort="true">
                                <div class="form-group" id="form_ul_partner_company">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55618.Eşinin Ç Şirket'></label>
                                <div class="col col-6 col-xs-12">
                                    <cfinput type="text" name="partner_company" id="partner_company" maxlength="50" >
                                    </div>
                                </div>
                                <div class="form-group" id="item-have_children">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55906.Çocuğunuz var mı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="have_children" id="have_children" value="1" onchange="disp_child()"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="have_children" id="have_children" value="0" checked onchange="disp_child()"><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-child">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56137.ÇocukSayısı'></label>
                                <div class="col col-6 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55942.çocuk sayısı girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="child" id="child" maxlength="2"  validate="integer" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-martyr_relative">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="martyr_relative" id="martyr_relative" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="martyr_relative" id="martyr_relative" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-psikoteknik">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55136.Psikoteknik"></label>
                                    <div class="col col-8 col-xs-12">
                                        <label><input type="radio" name="psikoteknik" id="psikoteknik" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                        <label><input type="radio" name="psikoteknik" id="psikoteknik" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-driver_licence_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55629.Ehliyet Tip / Yıl'></label>
                                <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
                                                SELECT LICENCECAT,LICENCECAT_ID FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
                                            </cfquery>
                                        <select name="driver_licence_type" id="driver_licence_type">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_driver_lis">
                                                    <option value="#licencecat_id#">#licencecat#</option>
                                                </cfoutput>
                                            </select>
                                            <span class="input-group-addon no-bg"></span>
                                            <cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='56601.Ehliyet Yılına Geçerli Bir Tarih Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="licence_start_date" id="licence_start_date" value="" maxlength="10" validate="#validate_style#" message="#message_driver#" style="width:66px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="licence_start_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-driver_licence">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55630.Ehliyet No'></label>
                                <div class="col col-6 col-xs-12">
                                    <cfinput type="Text" name="driver_licence" id="driver_licence" maxlength="40"  >
                                    </div>
                                </div>
                                <div class="form-group" id="item-surgical_operation">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56142.Geçirdiğiniz Ameliyat'></label>
                                <div class="col col-6 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                    <textarea name="surgical_operation" id="surgical_operation"  message="<cfoutput>#message#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                    </div>
                                </div>
                            </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                            <!--- <div class="col col-6 col-xs-12">
                                <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='31682.Kimlik Detayları'>');goster(gizli2);" />
                                <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'>');onceki_adim(1);" />
                            </div> --->
                            <div class="col col-6 col-xs-12">
                                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='31682.Kimlik Detayları'>');goster(gizli2);"/></div>
                                <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'>');onceki_adim(1);"/></div>
                            </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <div id="gizli2" style="display:none";>
                        <div class="col col-4 col-sm-8 col-xs-12" type="column" index="8" sort="true">
                            <div class="form-group" id="item-series">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                                <div class="col col-3 col-xs-12">
                                    <cfinput type="text" name="series" id="series" maxlength="20" value="">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <cfinput type="text" name="number" id="number" maxlength="50" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-father">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput name="father" id="father" type="text" value="" maxlength="75">
                                </div>
                            </div>
                            <div class="form-group" id="item-father_job">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56151.Baba İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="father_job" id="father_job" value="" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-LAST_SURNAME">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55640.Önceki Soyadı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="LAST_SURNAME" id="LAST_SURNAME" maxlength="100" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-BLOOD_TYPE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="BLOOD_TYPE" id="BLOOD_TYPE">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="0">0 Rh+</option>
                                        <option value="1">0 Rh-</option>
                                        <option value="2">A Rh+</option>
                                        <option value="3">A Rh-</option>
                                        <option value="4">B Rh+</option>
                                        <option value="5">B Rh-</option>
                                        <option value="6">AB Rh+</option>
                                        <option value="7">AB Rh-</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-mother">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput name="mother" id="mother" type="text" value="" maxlength="75">
                                </div>
                            </div>
                            <div class="form-group" id="item-mother_job">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56152.Anne İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="mother_job" id="mother_job" value="" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-religion">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55651.Dini'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="religion" id="religion" maxlength="50" value="">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-sm-8 col-xs-12" type="column" index="9" sort="true">
                            <cf_seperator title="#getLang('','Nüfusa Kayıtlı Olduğu','55641')#" id="kayit_" style="display:none;">
                            <div id="kayit_">
                                <div class="form-group" id="item-COUNTY">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="COUNTY" id="COUNTY" maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-WARD">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="WARD" id="WARD" maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-VILLAGE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55645.Köy'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="VILLAGE" id="VILLAGE" maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-BINDING">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55655.Cilt No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="BINDING" id="BINDING" maxlength="20" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-FAMILY">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55656.Aile Sıra No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="FAMILY" id="FAMILY" maxlength="20" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-CUE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55657.Sıra No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="CUE" id="CUE" maxlength="20" value="">
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
                                        <cfinput type="text" name="GIVEN_PLACE" id="GIVEN_PLACE" maxlength="100" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-GIVEN_REASON">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="GIVEN_REASON" id="GIVEN_REASON" maxlength="300" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-RECORD_NUMBER">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55658.Kayıt No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="RECORD_NUMBER" id="RECORD_NUMBER" maxlength="50" value="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-GIVEN_DATE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55790.Veriliş Tarihi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="GIVEN_DATE" id="GIVEN_DATE" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="GIVEN_DATE"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'>');goster(gizli3);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55126.Kişisel Bilgiler'>');onceki_adim(2);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'>');goster(gizli3);"/></div>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55126.Kişisel Bilgiler'>');onceki_adim(2);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                        <!--- Eğitim --->
                    <div id="gizli3" style="display:none";>
                        <div class="col col-8 col-xs-12" type="column" index="11" sort="false">
                            <div class="form-group" id="item-egitim">
                                <cf_grid_list>
                                    <thead>
                                        <input type="hidden" name="row_edu" id="row_edu" value="0">
                                        <tr>
                                            <th width="20" style="text-align:center;" colspan="2"><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','list');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56481.Okul Türü'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56482.Okul Adı'></th>
                                            <th style="width:50px;"><cf_get_lang dictionary_id ='56483.Başl Yılı'></th>
                                            <th style="width:50px;"><cf_get_lang dictionary_id ='56484.Bitiş Yılı'></th>
                                            <th style="width:100px;"><cf_get_lang dictionary_id ='56153.Not Ort'>.</th>
                                            <th style="width:150px;"><cf_get_lang dictionary_id='57995.Bölüm'></th>
                                        </tr>
                                        <input type="hidden" name="edu_type" id="edu_type" value="">
                                        <input type="hidden" name="edu_id" id="edu_id" value="">
                                        <input type="hidden" name="edu_name" id="edu_name" value="">
                                        <input type="hidden" name="edu_start" id="edu_start" value="">
                                        <input type="hidden" name="edu_finish" id="edu_finish" value="">
                                        <input type="hidden" name="edu_rank" id="edu_rank" value="">
                                        <input type="hidden" name="edu_high_part_id" id="edu_high_part_id" value="">
                                        <input type="hidden" name="edu_part_id" id="edu_part_id" value="">
                                        <input type="hidden" name="edu_part_name" id="edu_part_name" value="">
                                        <input type="hidden" name="is_edu_continue" id="is_edu_continue" value=""> 
                                    </thead>
                                    <tbody id="table_edu_info"></tbody>
                                    <tfoot>
                                        <tr>
                                            <td width="110" colspan="8">
                                                <div class="form-group">
                                                    <div class="col col-4 col-xs-12"><label><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'></label></div>
                                                    <div class="col col-8 col-xs-12">
                                                        <select name="training_level" id="training_level">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfloop query="get_edu_level">
                                                            <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>"><cfoutput>#get_edu_level.education_name#</cfoutput></option>
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
                                        <input type="hidden" name="add_lang_info" id="add_lang_info" value="">
                                        <thead>
                                            <tr>
                                                <th style="width:15px; text-align:center;"><a href="javascript://" onClick="add_lang_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                                <th style="width:100px;"><cf_get_lang dictionary_id='58996.Dil'></th>
                                                <th style="width:100px;"><cf_get_lang dictionary_id='56158.Konuşma'></th>
                                                <th style="width:100px;"><cf_get_lang dictionary_id='56159.Anlama'></th>
                                                <th style="width:100px;"><cf_get_lang dictionary_id='56160.Yazma'></th>
                                                <th style="width:150px;"><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></th>
                                            </tr>
                                        </thead>
                                        <input type="hidden" name="language_info" id="language_info" value="">
                                        <tbody id="lang_info"></tbody>
                                    </cf_grid_list>
                            </div>
                            <cf_seperator id="item_program" title="#getLang('','','56162')#" style="display:none;">
                            <div id="item_program">
                                <cf_grid_list>
                                    <thead>
                                        <input type="hidden" name="extra_course" id="extra_course" value="0"> 
                                        <input type="hidden" name="emp_course" id="emp_course" value="">
                                        <tr>
                                            <th style="text-align:center;width:15px;"><a style="cursor:pointer" onClick="add_row_course();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="100"><cf_get_lang dictionary_id="46354.Eğitim Konusu"></th>
                                            <th width="100"><cf_get_lang dictionary_id="37611.Eğitim Veren Kurum"></td>
                                            <th width="100"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                            <th width="100"><cf_get_lang dictionary_id='58455.Yıl'></th>
                                            <th width="150"><cf_get_lang dictionary_id='29513.Sure'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="add_course_pro"></tbody>
                                </cf_grid_list>
                            </div>
                            <div class="form-group" id="item-comp_exp">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="comp_exp" id="comp_exp" style="width:600px;height:70px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-comp_packet_pro">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="45548.Paket"> <cf_get_lang dictionary_id="37609.Program Bilgisi"></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="comp_packet_pro" id="comp_packet_pro" style="width:600px;height:70px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-electronic_tools">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="37597.Ofis Araçları Bilgisi"></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="electronic_tools" id="electronic_tools" style="width:600px;height:70px;"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55307.İş Tecrübesi'>');goster(gizli4);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='31682.Kimlik Detayları'>');onceki_adim(3);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55307.İş Tecrübesi'>');goster(gizli4);"/></div>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='31682.Kimlik Detayları'>');onceki_adim(3);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!--- Deneyim --->
                    <div id="gizli4" style="display:none";>
                        <div class="col col-12" type="column" index="12" sort="false">
                            <div class="form-group">
                                <cf_grid_list class="workDevList">
                                    <thead>
                                        <tr>
                                            <th colspan="2" style="width:30px; text-align:center;"><input name="record_numb" id="record_numb" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th><cf_get_lang dictionary_id ='56485.Çalışılan Yer'></th>
                                            <th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
                                            <th><cf_get_lang dictionary_id ='57579.Sektör'></th>
                                            <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                                            <th><cf_get_lang dictionary_id ='30128.Çalışma Şekli'></th>
                                            <th><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></th>
                                            <th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
                                        </tr>
                                        <input type="hidden" name="exp_name" id="exp_name" value="">
                                        <input type="hidden" name="exp_position" id="exp_position" value="">
                                        <input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
                                        <input type="hidden" name="exp_task_id" id="exp_task_id" value="">
                                        <input type="hidden" name="exp_work_type_id" id="exp_work_type_id" value="">
                                        <input type="hidden" name="exp_start" id="exp_start" value="">
                                        <input type="hidden" name="exp_finish" id="exp_finish" value="">
                                        <input type="hidden" name="exp_telcode" id="exp_telcode" value="">
                                        <input type="hidden" name="exp_tel" id="exp_tel" value="">
                                        <input type="hidden" name="exp_salary" id="exp_salary" value="">
                                        <input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
                                        <input type="hidden" name="exp_extra" id="exp_extra" value="">
                                        <input type="hidden" name="exp_reason" id="exp_reason" value="">
                                        <input type="hidden" name="is_cont_work" id="is_cont_work" value="">
                                    </thead>
                                    <tbody id="table_work_info">
                                    </tbody>
                                    <input type="hidden" name="row_count" id="row_count" value="0">
                                </cf_grid_list>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55252.Referans Bilgileri'>');goster(gizli5);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'>');onceki_adim(4);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55252.Referans Bilgileri'>');goster(gizli5);"/></div>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55739.Eğitim  Bilgileri'>');onceki_adim(4);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---referans --->
                    <div id="gizli5" style="display:none";>
                        <div class="col col-8 col-xs-12" type="column" index="13" sort="false">
                            <div class="form-group">
                                <cf_grid_list class="workDevList">
                                    <thead>
                                        <input type="hidden" name="add_ref_info" id="add_ref_info" value="0">
                                        <tr>
                                            <th><a style="cursor:pointer" onClick="add_ref_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="150"><cf_get_lang dictionary_id='55240.Referans Tipi'></th>
                                            <th width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                                            <th width="100"><cf_get_lang dictionary_id='57574.Sirket'></th>
                                            <th width="100"><cf_get_lang dictionary_id='55920.Tel Kod'></th>
                                            <th width="100"><cf_get_lang dictionary_id='55107.Telefon'></th>
                                            <th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                            <th width="100"><cf_get_lang dictionary_id="55484.E-mail"></th>
                                        </tr>
                                        <input type="hidden" name="referance_info" id="referance_info" value="">
                                    </thead>
                                    <tbody id="ref_info"></tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="14" sort="true">
                            <div class="form-group" id="item-">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="37595.Grup Şirketinde Çalışan Yakınınızın Adı"></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="related_ref_name" id="related_ref_name" style="width:180px;" maxlength="100" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-">
                                <label class="col col-4 col-xs-12 text-left"><cf_get_lang dictionary_id="57574.Şirket"></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="related_ref_company" id="related_ref_company" style="width:180px;" maxlength="100" value="">
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56168.Özel İlgi Alanları'>');goster(gizli6);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55307.İş Tecrübesi'>');onceki_adim(5);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56168.Özel İlgi Alanları'>');goster(gizli6);"/></div>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning"    name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55307.İş Tecrübesi'>');onceki_adim(5);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---hobi--->
                    <div id="gizli6" style="display:none";>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="15" sort="true">
                            <div class="form-group" id="item-hobby">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56168.Özel İlgi Alanları'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                    <textarea name="hobby" id="hobby" style="width:250px;" message="<cfoutput>#message#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-club">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56169.Üye Olunan Klüp Ve Dernekler'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="club" id="club" style="width:250px;" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56170.Aile Bilgileri'>');goster(gizli7);" />&nbsp;
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55252.Referans Bilgileri'>');onceki_adim(6);" />&nbsp;
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56170.Aile Bilgileri'>');goster(gizli7);"/></div>
                                        <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55252.Referans Bilgileri'>');onceki_adim(6);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---aile bilgileri--->
                    <div id="gizli7" style="display:none";>
                        <div class="col col-12" type="column" index="16" sort="false">
                            <div class="form-group">	
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <input type="hidden" name="rowCount" id="rowCount" value="0">
                                            <th><a title="<cf_get_lang_main no ='170.Ekle'>" onClick="addRow();"><i class="fa fa-plus"></i></a></th>
                                            <th><cf_get_lang dictionary_id='57631.Ad'></th>
                                            <th><cf_get_lang dictionary_id='58726.Soyad'></th>
                                            <th><cf_get_lang dictionary_id='56171.Yakınlık Derecesi'></th>
                                            <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                                            <th><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
                                            <th width="220"><cf_get_lang dictionary_id='57419.Eğitim'></th>
                                            <th><cf_get_lang dictionary_id='55494.Meslek'></th>
                                            <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                            </tr>
                                    </thead>
                                    <tbody id="table_list"></tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!---  <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'>');goster(gizli8);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56168.Özel İlgi Alanları'>');onceki_adim(7);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'>');goster(gizli8);"/></div>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56168.Özel İlgi Alanları'>');onceki_adim(7);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---çalışmak istediği birimler--->
                    <div id="gizli8" style="display:none";>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="17" sort="true">
                            <cfquery name="get_cv_unit" datasource="#DSN#">
                                SELECT 
                                    * 
                                FROM 
                                    SETUP_CV_UNIT
                                WHERE 
                                    IS_ACTIVE=1
                            </cfquery>
                            <div class="form-group" id="item-label">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">(<cf_get_lang dictionary_id='56173.Öncelik sıralarını yandaki kutulara yazınız'>...)</label>
                            </div>
                            <cfif get_cv_unit.recordcount>
                                <cfoutput query="get_cv_unit">
                                <div class="form-group" id="item-unit#get_cv_unit.unit_id#">
                                    <label class="col col-10 col-xs-12">#get_cv_unit.unit_name#</label>
                                    <div class="col col-2 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55805.Sayı Giriniz!'>!</cfsavecontent>
                                        <cfinput type="text" name="unit#get_cv_unit.unit_id#" id="unit#get_cv_unit.unit_id#" value="" validate="integer" message="#message#" maxlength="1" onchange="seviye_kontrol(this)">
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
                                                    <option value="#position_cat_id#">#position_cat#</option>
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
                                                <option value="#position_cat_id#">#position_cat#</option>
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
                                                <option value="#position_cat_id#">#position_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'>');goster(gizli9);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56170.Aile Bilgileri'>');onceki_adim(8);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'>');goster(gizli9);"/></div>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56170.Aile Bilgileri'>');onceki_adim(8);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---Çalışılmak İstenen  Şubeler--->
                    <div id="gizli9" style="display:none";>
                        <div class="col col-6 col-sm-8 col-xs-12" type="column" index="19" sort="true">
                            <div class="form-group" id="item-preference_branch">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="preference_branch" id="preference_branch" style="width:220px; height:100px;" multiple>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#">#branch_name# - #branch_city#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-preference_zone">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55188.Bölgeler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="preference_zone" id="preference_zone" style="width:220px;">
                                        <cfoutput query="get_zones">
                                            <option value="#zone_id#">#zone_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!---  <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55129.Ek Bilgiler'>');goster(gizli10);" />
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'>');onceki_adim(9);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='38623.Next Step'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='55129.Ek Bilgiler'>');goster(gizli10);"/></div>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id='56172.Çalışmak İstediğiniz Birimler'>');onceki_adim(9);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                    <!---Ek Bilgiler --->
                    <div id="gizli10" style="display:none">
                        <div class="col col-10 col-sm-8 col-xs-12" type="column" index="20" sort="true">
                            <div class="form-group" id="item-prefered_city">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31703.Çalışmak İstediğiniz Şehir'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                        name="prefered_city"
                                        option_name="CITY_NAME"
                                        option_value="CITY_ID"
                                        table_name="SETUP_CITY"
                                        is_option_text="1"
                                        option_text="#getLang('','TÜM TÜRKİYE','56175')#">
                                </div>
                            </div>
                            <div class="form-group" id="item-IS_TRIP">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55328.Seyahat Edebilir misiniz'>?</label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="radio" name="IS_TRIP" id="IS_TRIP" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
                                    <label><input type="radio" name="IS_TRIP" id="IS_TRIP" value="0"><cf_get_lang dictionary_id='57496.Hayır'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-EXPECTED_MONEY_TYPE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56489.İstenilen Ücret (Net)'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="expected_price" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                        <span class="input-group-addon no-bg width">
                                        <select name="EXPECTED_MONEY_TYPE" id="EXPECTED_MONEY_TYPE" class="formselect">
                                            <cfquery name="GET_MONEY" datasource="#dsn#">
                                                SELECT
                                                    *
                                                FROM
                                                    SETUP_MONEY
                                                WHERE
                                                    PERIOD_ID = #SESSION.EP.PERIOD_ID#
                                            </cfquery>
                                            <cfoutput query="get_money">
                                                <option value="#MONEY#">#MONEY#</option>
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
                                        <cfinput type="text" style="width:120px;" name="work_start_date" value="" validate="#validate_style#" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="work_start_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-applicant_notes">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55326.Eklemek İstedikleriniz'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="4"  style="width:530px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-interview_result">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55785.Mülakat Görüşü'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="interview_result" id="interview_result" style="width:530px;" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="5"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-ekbilgi">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-23" upd_page = "0">
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <cf_box_footer>
                                <!--- <div class="col col-6 col-xs-12">
                                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'>');onceki_adim(10);" />
                                </div> --->
                                <div class="col col-6 col-xs-12">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                    <div id="nextStepButton" class="pull-right"><input class="ui-wrk-btn ui-wrk-btn-warning" name="next_step" id="next_step" type="button" value="<cf_get_lang dictionary_id='64576.Önceki Adım'>" onclick="hepsini_gizle('<cf_get_lang dictionary_id ='56519.Çalışmak İstediğiniz Şubeler'>');onceki_adim(10);"/></div>
                                </div>
                            </cf_box_footer>
                        </div>
                    </div>
                <cf_box_elements>
            </cf_box>
        </div>
    </div>
</cfform>

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
<script type="text/javascript">
    $(document).ready(function(){
        disp_spouse();
        disp_child();
        add_im_info=0;
        row_count=0;
        rowCount=0;
        row_edu=0;
        satir_say_edu=0;
        add_lang_info=0;
        satir_say=0;
        add_ref_info=0;
        extra_course = 0;
    <cfif get_cv_unit.recordcount>
        unit_count='<cfoutput>#get_cv_unit.recordcount#</cfoutput>';
    <cfelse>
        unit_count=0;
    </cfif>
    });
    function hepsini_gizle(id)
    {
        $('#handle_orta_box').text("").append("<a href='javascript://'>" + id + "</a>");
        for(var i=0;i<11;i++)
        {
            document.getElementById('gizli'+i).style.display='none';
        }
    }
        
    function onceki_adim(id)
    {
        document.getElementById('gizli'+id).style.display = 'none';
        document.getElementById('gizli'+(id-1)).style.display = '';
    }
        
    function referans_calistir()
    {
        if($('input[name=cv_type]:checked').val() == 0)
        {
            gizle(referans_area);
        }
        else
        {
            goster(referans_area);
        }
    }
    function del_ref(dell){
        var my_emement1=eval("employe_detail.del_ref_info"+dell);
        my_emement1.value=0;
        var my_element1=eval("ref_info_"+dell);
        my_element1.style.display="none";
    }
    function add_ref_info_(){
        add_ref_info++;
        document.getElementById('add_ref_info').value=add_ref_info;
        var newRow;
        var newCell;
        newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
        newRow.setAttribute("name","ref_info_" + add_ref_info);
        newRow.setAttribute("id","ref_info_" + add_ref_info);
        document.getElementById('referance_info').value=add_ref_info;
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" style="width:"60px;"><option value=""><cf_get_lang dictionary_id="55240.Referans Tipi"></option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput>/select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" style=" width:100px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" style=" width:100px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" style=" width:100px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" style=" width:100px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" style=" width:100px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" style=" width:100px;">';
    }
    function del_im(dell){
        var my_emement1=eval("employe_detail.del_im_info"+dell);
        my_emement1.value=0;
        var my_element1=eval("im_info_"+dell);
        my_element1.style.display="none";
    }
    function add_im_info_(){
        add_im_info++;
        document.getElementById('add_im_info').value=add_im_info;
        var newRow;
        var newCell;
        newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
        newRow.setAttribute("name","im_info_" + add_im_info);
        newRow.setAttribute("id","im_info_" + add_im_info);
        document.getElementById('instant_info').value=add_im_info;
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a style="cursor:pointer" onclick="del_im(' + add_im_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select  id="imcat_id' + add_im_info +'" name="imcat_id' + add_im_info +'" style="width:"112px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput>/select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="text" name="im' + add_im_info +'" style=" width:120px;">';
    }
    function sil_(del){
        var my_element_=eval("employe_detail.del_course_prog"+del);
        my_element_.value=0;
        var my_element_=eval("pro_course"+del);
        my_element_.style.display="none";

    }
    function add_row_course(){
        extra_course++;
        document.getElementById('extra_course').value = extra_course;
        var newRow;
        var newCell;
            newRow = document.getElementById("add_course_pro").insertRow(document.getElementById("add_course_pro").rows.length);
            newRow.setAttribute("name","pro_course" + extra_course);
            newRow.setAttribute("id","pro_course" + extra_course);
            document.getElementById('emp_course').value=extra_course;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + extra_course +'"><a style="cursor:pointer" onclick="sil_(' + extra_course + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="kurs1_' + extra_course +'" style="width:100px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="kurs1_yer' + extra_course +'" style="width:100px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="kurs1_exp' + extra_course +'" style="width:100px;"  maxlength="200">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="kurs1_yil' + extra_course +'" maxlength="4" onKeyup="isNumber(this);" style="width:100px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="kurs1_gun' + extra_course +'" style="width:150px;">';
    }
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
        var x = document.getElementById("homecountry");
        var val = x.options[x.selectedIndex].value;
        if (val == "")
        {
            alert("<cf_get_lang dictionary_id ='56176.İlk Olarak Ülke Seçiniz'>.");
        }	
        else if(document.getElementById('homecity').value == "")
        {
            alert("<cf_get_lang dictionary_id ='56490.İl Seçiniz'>!");
        }
        else
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.getElementById('homecity').value,'small');
        }
    }
    function pencere_ac_city()
    {
        x = document.getElementById('homecountry').selectedIndex;
        if (document.employe_detail.homecountry[x].value == "")
        {
            alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>!");
        }	
        else
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.getElementById('homecountry').value,'small');
        }
    }

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
        var obj =  document.getElementById('photo').value;
        if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
            alert("<cf_get_lang dictionary_id ='56078.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
            return false;
        }
        if(document.getElementById('imcat_id')!= null){
            var imcat = document.getElementById('imcat_id').selectedIndex;
            if(document.employe_detail.imcat_id[imcat].value != "")
            {
                if(document.employe_detail.im.value.length == 0)
                {
                    alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30738.IMessege Kategorisi seçilmiş fakat Instant Mesaj adresi girilmemiş'> !");
                    document.employe_detail.im.focus();
                    return false;
                }
            }
        }

        for (var counter_=1; counter_ <=  document.employe_detail.extra_course.value; counter_++)
        {
            if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 && eval("document.employe_detail.kurs1_"+counter_).value == '')
            {
                alert("37581.Lütfen Kurs İçin Konu Giriniz!");
                return false;
            }
            if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 &&  (eval("document.employe_detail.kurs1_yil"+counter_).value == '' || eval("document.employe_detail.kurs1_yil"+counter_).value.length <4))
            {
                alert("37579.Lütfen Kurs İçin Yıl Giriniz!");
                return false;
            }
        }
        
        return control_last();
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
        
    function addRow()
    {
        rowCount++;
        document.getElementById('rowCount').value = rowCount;
        var newRow;
        var newCell;
        newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '&nbsp;';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="name_relative' + rowCount + '" value="" style="width:75px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="surname_relative' + rowCount + '" style="width:75px;">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="relative_level' + rowCount + '" ><option value="1"><cf_get_lang dictionary_id="55265.Baba"></option><option value="2"><cf_get_lang dictionary_id="55470.Anne"></option><option value="3"><cf_get_lang dictionary_id="55275.Eşi"></option><option value="4"><cf_get_lang dictionary_id="55253.Oğlu"></option><option value="5"><cf_get_lang dictionary_id="55234.Kızı"></option><option value="6">Kardeşi</option></select>';
        newCell = newRow.insertCell(newRow.cells.length);

        


        
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="birth_date_relative' + rowCount + '_td"></span></div></div> ';
        wrk_date_image('birth_date_relative' + rowCount);
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="birth_place_relative' + rowCount + '" value="" style="width:75px;">';
        /*newCell = newRow.insertCell();
        newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="" style="width:75px;">';*/
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"> <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><select name="education_relative' + rowCount + '"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select></div> <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><div class="input-group"><label><cf_get_lang dictionary_id="55483.Okuyor"></label><span class="input-group-addon"><input type="checkbox" name="education_status_relative' + rowCount + '" value="1"></span></div></div></div>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="job_relative' + rowCount + '" style="width:75px;" value="">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="company_relative' + rowCount + '" style="width:75px;" value="">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="job_position_relative' + rowCount + '" style="width:75px;" value="">';
    }
        
    function control_last()
    {
        document.getElementById('expected_price').value = filterNum(document.getElementById('expected_price').value);
        event.preventDefault();
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_dsp_app_prerecords&employee_name=' + document.getElementById('name_').value + '&employee_surname=' + document.getElementById('surname').value +'&identycard_no=' + document.getElementById('identycard_no').value + '&tax_number=' + document.getElementById('tax_number').value,'prerecord_box','ui-draggable-box-medium');
        return false;
    }
    /*İş Tecrübesi*/
    function sil(sy)
    {
        var my_element=eval("employe_detail.row_kontrol"+sy);
        my_element.value=0;
        var my_element=eval("frm_row"+sy);
        my_element.style.display="none";
        satir_say--;
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
            eval("employe_detail.exp_work_type_id" + my_count).value = exp_work_type_id;
            if(exp_work_type_id !='')
            {
                <!---var get_emp_work_type_cv_new = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
                var exp_work_type_name = get_emp_work_type_cv_new.WORK_TYPE_NAME;--->
                var exp_work_type_name = exp_work_type_name;
                }
            else
                var exp_work_type_name ='';
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
            document.getElementById('row_count').value = row_count;
            satir_say++;
            var new_Row;
            var new_Cell;
            get_emp_cv='';
            new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
            new_Row.setAttribute("name","frm_row" + row_count);
            new_Row.setAttribute("id","frm_row" + row_count);		
            new_Row.setAttribute("NAME","frm_row" + row_count);
            new_Row.setAttribute("ID","frm_row" + row_count);	
            
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_add('+row_count+');"><i class="fa fa-pencil"></i></a>';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
            new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_work_type_id' + row_count + '" value="' + exp_work_type_id +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
            new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
        
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" style="width:150px;" class="boxtext" readonly>';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" style="width:100px;" class="boxtext" readonly>';
            if(exp_sector_cat != '')
            {
                var cv_sql = 'SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = '+exp_sector_cat+'';
                var get_emp_cv = wrk_query(cv_sql,'dsn');
                /*if(get_emp_cv.recordcount)*/
                    var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
            }
            else
                var exp_sector_cat_name = '';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" style="width:120px;" class="boxtext" readonly>';
            if(exp_task_id != '')
            {
                var get_emp_task_cv = wrk_safe_query("hr_get_emp_task_cv_new",'dsn',0,exp_task_id);
                /*if(get_emp_task_cv.recordcount)*/
                    var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
            }
            else
                var exp_task_name = '';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" style="width:120px;" class="boxtext" readonly>';
            if(exp_work_type_id!='')
            {
                var work_type_sql = 'SELECT WORK_TYPE_ID, WORK_TYPE_NAME FROM SETUP_WORK_TYPE WHERE WORK_TYPE_ID= '+exp_work_type_id+'';
                var get_emp_work_type_cv = wrk_query(work_type_sql,'dsn');
                var exp_work_type_name = get_emp_work_type_cv.WORK_TYPE_NAME;
                }
            else
                var exp_work_type_name ='';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_work_type_name' + row_count + '" value="'+exp_work_type_name+'" style="width:120px;" class="boxtext" readonly>';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" style="width:100px;" class="boxtext" readonly>';
            new_Cell = new_Row.insertCell(new_Row.cells.length);
            new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" style="width:85px;" class="boxtext" readonly>';
        }
    }
    function gonder_add(count)
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
        windowopen('','large','add_kariyer_pop');
        form_work_info.target='add_kariyer_pop';
        form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
        form_work_info.submit();	
    }
    /*İş Tecrübesi*/
        
    /*Eğitim Bilgileri*/
    function sil_edu(sv)
    {
        var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
        my_element_edu.value=0;
        var my_element_edu=eval("frm_rowt"+sv);
        my_element_edu.style.display="none";
        satir_say_edu--;
    }
        
    function gonder_training(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
    {
        var edu_type = edu_type.split(';')[0];
        var edu_name_degisken = '';
        var edu_part_name_degisken = '';
        if(ctrl_edu == 1)
        {
            eval("employe_detail.edu_type"+count_edu).value=edu_type;
            /*if(eval("employe_detail.edu_type"+count_edu).value == 1)
                var edu_type_name = 'İlkÖgretim';
            else if(eval("employe_detail.edu_type"+count_edu).value == 2)
                var edu_type_name = 'Lise';
            else if(eval("employe_detail.edu_type"+count_edu).value == 3)
                var edu_type_name = 'Üniversite';
            else if(eval("employe_detail.edu_type"+count_edu).value == 4)
                var edu_type_name = 'Yüksek Okul';
            else if(eval("employe_detail.edu_type"+count_edu).value == 5)
                var edu_type_name = 'Yüksek Lisans';
            else if(eval("employe_detail.edu_type"+count_edu).value == 6)
                var edu_type_name = 'Doktora';
            else
                var edu_type_name = 'Diğer';*/
            if(edu_type != undefined && edu_type != '')
            {
                var get_edu_part_name_sql = wrk_safe_query("hr_get_edu_part_name",'dsn',0,edu_type);
                if(get_edu_part_name_sql.recordcount)
                    var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
            }	
            eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
            eval("employe_detail.edu_id"+count_edu).value=edu_id;
            eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
            eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
            if(edu_id != '' && edu_id != -1)
            {
                var get_cv_edu_new = wrk_safe_query("hr_get_cv_edu_new",'dsn',0,edu_id);
                if(get_cv_edu_new.recordcount)
                    var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
                eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
            }
            else
            {
                eval("employe_detail.edu_name"+count_edu).value=edu_name;
            }
            eval("employe_detail.edu_start"+count_edu).value=edu_start;
            eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
            eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
            if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
            {
                var get_cv_edu_high_part_id = wrk_safe_query("hr_cv_edu_high_part_id_q",'dsn',0,edu_high_part_id);
                if(get_cv_edu_high_part_id.recordcount)
                    var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
                eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
            }
            else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
            {
                var cv_edu_part_id_sql = 'SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = '+edu_part_id+'';
                var get_cv_edu_part_id = wrk_safe_query("hr_cv_edu_part_id_q",'dsn',0);
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
            document.getElementById('row_edu').value = row_edu;
            satir_say_edu++;
            var new_Row_Edu;
            var new_Cell_Edu;
            new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
            new_Row_Edu.setAttribute("name","frm_rowt" + row_edu);
            new_Row_Edu.setAttribute("id","frm_rowt" + row_edu);		
            new_Row_Edu.setAttribute("NAME","frm_rowt" + row_edu);
            new_Row_Edu.setAttribute("ID","frm_rowt" + row_edu);
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="fa fa-pencil"></i></a>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
            new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';

            if(edu_type != undefined && edu_type != '')
            {
                var get_edu_part_name_sql = wrk_safe_query("hr_get_edu_part_name",'dsn',0,edu_type);
                if(get_edu_part_name_sql.recordcount)
                    var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
            }
                
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:80px;" type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly></div>';
            if(edu_id != undefined && edu_id != '')
            {
                var get_cv_edu_new = wrk_safe_query("hr_get_cv_edu_new",'dsn',0,edu_id);
                if(get_cv_edu_new.recordcount)
                    var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:185px;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly></div>';
            }
            else if(edu_name != undefined && edu_name != '')
            {
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<div class="form-group"><input  style="width:185px;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly></div>';
            }
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:10px;" type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
            new_Cell_Edu.innerHTML += '<div class="form-group"><input style="width:70px;" type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly></div>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:70px;" type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly></div>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:65px;" type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly></div>';
            if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
            {
                var get_cv_edu_high_part_id = wrk_safe_query("hr_cv_edu_high_part_id_q",'dsn',0,edu_high_part_id);
                if(get_cv_edu_high_part_id.recordcount)
                    var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100px;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:200px;" class="boxtext" readonly></div>';
            }
            else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
            {
                var get_cv_edu_part_id = wrk_safe_query("hr_cv_edu_part_id_q",'dsn',0,edu_part_id);
                if(get_cv_edu_part_id.recordcount)
                    var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100px;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:200px;" class="boxtext" readonly></div>';
            }
            else
            {
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100px;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly></div>';
            }
        }
    }

    function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
    {
        var edu_name_degisken = '';
        var edu_part_name_degisken = '';
        if(ctrl_edu == 1)
        {
            
            var edu_type = edu_type.split(';')[0];
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
                eval("employe_detail.edu_name"+count_edu).value=edu_name;
            }
            eval("employe_detail.edu_start"+count_edu).value=edu_start;
            eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
            eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
            if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
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
            new_Row_Edu.setAttribute("name","frm_rowt" + row_edu);
            new_Row_Edu.setAttribute("id","frm_rowt" + row_edu);
            
            var edu_type = edu_type.split(';')[0];
            if(edu_type != undefined && edu_type != '')
                {
                    var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
                    if(get_edu_part_name_sql.recordcount)
                        var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
                }	

            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_add_edu('+row_edu+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" id="row_kontrol_edu' + row_edu +'" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';
            new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_id' + row_edu + '" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
            new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_high_part_id' + row_edu + '" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_part_id' + row_edu + '" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
            new_Cell_Edu.innerHTML += '<input type="hidden" id="is_edu_continue' + row_edu + '" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';
                
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input type="text" id="edu_type_name' + row_edu + '" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
            if(edu_id != undefined && edu_id != '')
            {
                var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
                if(get_cv_edu_new.recordcount)
                    var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<input type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
            }
            else if(edu_name != undefined && edu_name != '')
            {
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<input type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
            }
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML += '<input type="hidden" id="gizli' + row_edu + '" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
            new_Cell_Edu.innerHTML = '<input type="text" id="edu_start' + row_edu + '" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input type="text" id="edu_finish' + row_edu + '" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input type="text" id="edu_rank' + row_edu + '" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
            if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
            {
                var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
                if(get_cv_edu_high_part_id.recordcount)
                    var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
            }
            else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
            {
                var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
                if(get_cv_edu_part_id.recordcount)
                    var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
                new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
                new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
            }
            else
            {
            new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
            new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
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
        employe_detail.add_lang_info.value=add_lang_info;
        var newRow;
        var newCell;
        newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
        newRow.setAttribute("name","lang_info_" + add_lang_info);
        newRow.setAttribute("id","lang_info_" + add_lang_info);
        employe_detail.language_info.value=add_lang_info;

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a style="cursor:pointer" onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang' + add_lang_info +'" style="width:100px;"><option value=""><cf_get_lang_main no="1584.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_speak' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_mean' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="lang_write' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="lang_where' + add_lang_info + '" value="" style="width:150px;">';
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
            {}
        }
    }
</script>