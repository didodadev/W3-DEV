<cfset xml_page_control_list = 'is_image_change,is_image_size_height,is_image_size_width,photo_size_width,photo_size_height,is_info_contract'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="100">
<cfset attributes.employee_id = session.ep.userid>
<cfset employee_id = session.ep.userid>
<cfquery name="GET_HR_DETAIL" datasource="#dsn#">
	SELECT 
		ED.HOMECITY,
		ED.SEX,
		ED.MILITARY_STATUS,
		ED.MILITARY_DELAY_REASON,
		ED.MILITARY_DELAY_DATE,
		ED.MILITARY_FINISHDATE,
		ED.MILITARY_MONTH,
		ED.MILITARY_RANK,
		ED.MILITARY_EXEMPT_DETAIL,
		ED.USE_CIGARETTE,
		ED.MARTYR_RELATIVE,
		ED.DEFECTED,
		ED.DEFECTED_LEVEL,
		ED.SENTENCED,
		ED.ILLNESS_PROBABILITY,
		ED.ILLNESS_DETAIL,
		ED.DIRECT_TELCODE_SPC,
		ED.DIRECT_TEL_SPC,
		ED.EXTENSION_SPC,
		ED.MOBILCODE_SPC,
		ED.MOBILTEL_SPC,
		ED.MOBILCODE2_SPC,
		ED.MOBILTEL2_SPC,
		ED.EMAIL_SPC,
		ED.HOMETEL_CODE,
		ED.HOMETEL,
		ED.HOMECOUNTRY,
		ED.HOMEADDRESS,
		ED.HOMECOUNTY,
		ED.HOMEPOSTCODE,
		ED.CONTACT1,
		ED.CONTACT1_RELATION,
		ED.CONTACT1_TELCODE,
		ED.CONTACT1_TEL,
		ED.CONTACT1_EMAIL,
		ED.LAST_SCHOOL,
		ED.CLUB,
		ED.COMP_EXP,
		ED.TOOLS,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_STAGE,
		E.EMPLOYEE_SURNAME,
		E.MOBILCODE,
		E.MOBILTEL,
		E.EMPLOYEE_EMAIL,
<!---		E.IMCAT_ID,
		E.IM,--->
		E.BIOGRAPHY,
		E.WET_SIGNATURE,
		E.PHOTO,
		E.PHOTO_SERVER_ID,
		EI.MARRIED,
		EI.SERIES,
		EI.NUMBER,
		EI.TC_IDENTY_NO,
		EI.FATHER,
		EI.MOTHER,
        EI.NATIONALITY,
		EI.BLOOD_TYPE,
		EI.BIRTH_DATE,
		EI.TAX_NUMBER,
		EI.BIRTH_PLACE,
		EI.TAX_OFFICE,
		EI.LAST_SURNAME,
		EI.SOCIALSECURITY_NO,
		EI.CITY,
		EI.BINDING,
		EI.COUNTY,
		EI.FAMILY,
		EI.WARD,
		EI.CUE,
		EI.VILLAGE,
		EI.GIVEN_PLACE,
		EI.RECORD_NUMBER,
		EI.GIVEN_REASON,
		EI.GIVEN_DATE,
		EI.RELIGION,
		EI.BIRTH_CITY,
		ED.RECORD_EMP,
		ED.RECORD_DATE,
		ED.UPDATE_EMP,
		ED.UPDATE_DATE,
        (SELECT TOP 1 IMCAT_ID FROM EMPLOYEES_INSTANT_MESSAGE WHERE E.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IMCAT_ID,
        (SELECT TOP 1 IM_ADDRESS FROM EMPLOYEES_INSTANT_MESSAGE WHERE E.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IM
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		ED.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfinclude template="../query/get_know_levels.cfm">
<cfquery name="GET_EDU_LEVEL" datasource="#dsn#">
	SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_ID,CITY_NAME,COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
	SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<cfquery name="get_im_cats" datasource="#dsn#">
	SELECT IMCAT_ID, IMCAT FROM SETUP_IM
</cfquery>
<cfquery name="get_languages_document" datasource="#dsn#">
	SELECT DOCUMENT_ID,DOCUMENT_NAME FROM SETUP_LANGUAGES_DOCUMENTS
</cfquery>
<cfscript>
	get_imcat = createObject("component","V16.hr.cfc.get_im");
	get_imcat.dsn = dsn;
	get_ims = get_imcat.get_im(
		employee_id : attributes.employee_id
	);
</cfscript>
                                                    
<!---  <div class="color-ER portHead" id="position_info_#position_id#" >
    <span><cfoutput></cfoutput></span>
    <i class="fa fa fa-print pull-right" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.EMPLOYEE_ID#&print_type=173</cfoutput>','page','workcube_print');"></i>            
</div> --->

<div class="portBody">
    <cf_box title="#getLang('myhome',393)#" closable="0">
        <cfform name="employe_detail" id="employe_detail" method="post" action="#request.self#?fuseaction=myhome.empytpopup_upd_my_detail" enctype="multipart/form-data">
            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
            <input type="hidden" name="is_image_size_width" id="is_image_size_width" value="<cfif isdefined('is_image_size_width')><cfoutput>#is_image_size_width#</cfoutput></cfif>">
            <input type="hidden" name="is_image_size_height" id="is_image_size_height" value="<cfif isdefined('is_image_size_height')><cfoutput>#is_image_size_height#</cfoutput></cfif>">
            <input type="hidden" name="photo_size_width" id="photo_size_width" value="<cfif isdefined('photo_size_width')><cfoutput>#photo_size_width#</cfoutput></cfif>">
            <input type="hidden" name="photo_size_height" id="photo_size_height" value="<cfif isdefined('photo_size_height')><cfoutput>#photo_size_height#</cfoutput></cfif>">
    <!--- Kisisel Bilgiler --->
            <cf_seperator id="kisisel_bilgiler_" header="#getLang('','Kişisel Bilgiler',31198)#">
                <cf_box_elements id="kisisel_bilgiler_">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-process">
                            <label class="col col-4"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='1' select_value='#get_hr_detail.employee_stage#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-name_">
                            <label class="col col-4"><cf_get_lang dictionary_id='57631.Ad'></label>
                            <div class="col col-8">
                                <cfinput type="text" name="employee_name" maxlength="50" required="yes" message="#getLang('','Ad girmelisiniz',58939)#!" value="#get_hr_detail.employee_name#">
                            </div>
                        </div>
                        <div class="form-group" id="item-last-name">
                            <label class="col col-4"><cf_get_lang dictionary_id='58726.Soyad'></label>
                            <div class="col col-8">
                                <cfinput name="employee_surname" value="#get_hr_detail.employee_surname#" type="text" maxlength="50" required="Yes" message="#getLang('','Soyad Girmelisiniz',29503)#!">
                            </div>
                        </div>
                        <div class="form-group" id="item-nationality_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31226.Uyruğu'></label>
                            <div class="col col-8">
                                <select name="nationality" id="nationality">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_country">
                                        <option value="#country_id#" <cfif get_hr_detail.nationality eq country_id>selected</cfif>> #country_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-mobil-tel">
                            <label class="col col-4"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                            <div class="col col-3">
                                <cf_wrk_combo
                                    option_text="#getLang('','Kod',58585)#"
                                    name="mobilcode"
                                    option_name="mobilcat"
                                    option_value="mobilcat"
                                    query_name="GET_SETUP_MOBILCAT"
                                    width="47"
                                    value="#get_hr_detail.mobilcode#">
                            </div>   
                            <div class="col col-5">
                                <cfinput value="#get_hr_detail.mobiltel#" type="text" name="mobiltel" maxlength="9" validate="integer" message="#getLang('','Mobil Tel girmelisiniz',31225)#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                            </div>
                        </div>
                        <div class="form-group" id="item-e-mail_">
                            <label class="col col-4"><cf_get_lang dictionary_id='57428.E-mail'></label>
                            <div class="col col-8">
                                <cfsavecontent variable="mail"><cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-mail adresi giriniz'></cfsavecontent>
                                <cfinput type="text" name="employee_email" maxlength="50" value="#get_hr_detail.employee_email#" validate="email" message="#mail#">
                            </div>
                        </div>
                        <div class="form-group" id="item-military-service">
                            <label class="col col-4"><cf_get_lang dictionary_id='31209.Askerlik'></label>
                            <div class="col col-8">
                                <input type="radio" name="military_status" id="military_status" value="0" <cfif get_hr_detail.military_status eq 0 or len(get_hr_detail.military_status)>checked</cfif> onclick="tecilli_fonk(this.value);">
                                <label class="col col-2"><cf_get_lang dictionary_id='31210.Yapmadı'> </label>
                                <input type="radio" name="military_status" id="military_status" value="1" <cfif get_hr_detail.military_status eq 1>checked</cfif> onclick="tecilli_fonk(this.value);">
                                <label class="col col-2"><cf_get_lang dictionary_id='31211.Yaptı'></label>
                                <input type="radio" name="military_status" id="military_status" value="2" <cfif get_hr_detail.military_status eq 2>checked</cfif> onclick="tecilli_fonk(this.value);">
                                    <label class="col col-2"><cf_get_lang dictionary_id='53401.Muaf'></label>
                                <input type="radio" name="military_status" id="military_status" value="3" <cfif get_hr_detail.military_status eq 3>checked</cfif> onclick="tecilli_fonk(this.value);">
                                    <label class="col col-2"><cf_get_lang dictionary_id='31213.Yabancı'></label>
                                <input type="radio" name="military_status"  id="military_status" value="4" <cfif get_hr_detail.military_status eq 4>checked</cfif> onclick="tecilli_fonk(this.value);">
                                    <label class="col col-1"><cf_get_lang dictionary_id='31214.Tecilli'></label>
                            </div>
                        </div>
                    
                        <div class="form-group" <cfif get_hr_detail.military_status neq 4>style="display:none"</cfif> id="Tecilli">
                            <label class="col col-4"><cf_get_lang dictionary_id='31215.Tecil Gerekçesi'></label>
                            <div class="col col-8"><cfinput type="text" name="military_delay_reason" maxlength="30" value="#get_hr_detail.military_delay_reason#"></div>
                        </div>
                        <div class="form-group" <cfif get_hr_detail.military_status neq 4>style="display:none"</cfif> id="Tecilli">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31216.Tecil Süresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31216.Tecil Süresi'></cfsavecontent>
                                    <cfinput type="text" name="military_delay_date" value="#dateformat(get_hr_detail.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"> <cf_wrk_date_image date_field="military_delay_date"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group" <cfif get_hr_detail.military_status neq 1>style="display:none"</cfif> id="Yapti">
                            <div class="col col-12">
                                <label><cf_get_lang dictionary_id='31219.Süresi (Ay)'></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='31220.Askerlik Süresi Girmelisiniz'>'></cfsavecontent>
                                <cfinput type="text" name="military_month" value="#get_hr_detail.military_month#" validate="integer" maxlength="2" message="#message#">
                            </div>
                            <div class="col col-12">
                                <label><cf_get_lang dictionary_id='31217.Terhis Tarihi'></label>
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" style="width:130px;" name="military_finishdate" value="#dateformat(get_hr_detail.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
                                </div>
                            </div>
                        
                        </div>
                        <div class="form-group" <cfif get_hr_detail.military_status neq 1>style="display:none"</cfif> id="Yapti2"> 
                            <div class="col col-1"> <input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_hr_detail.military_rank eq 0>checked</cfif>></div>
                            <label class="col col-3"> <cf_get_lang dictionary_id='31221.Er'></label>
                            <div class="col col-1"><input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_hr_detail.military_rank eq 1>checked</cfif>></div>
                            <label class="col col-6"><cf_get_lang dictionary_id='31222.Yedek Subay'></label>
                        </div>
                        <div class="form-group" <cfif get_hr_detail.military_status neq 2>style="display:none"</cfif> id="Muaf">
                            <label class="col col-12"><cf_get_lang dictionary_id='31223.Muaf Olma Nedeni'></label>
                            <div class="col col-12"><input type="text" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_hr_detail.military_exempt_detail#</cfoutput>"></div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-sex">
                            <label class="col col-4"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="sex" id="sex" value="1" <cfif get_hr_detail.sex eq 1 or not len(get_hr_detail.sex)>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='58959.Erkek'> </label>
                                <div class="col col-2"><input type="radio" name="sex" id="sex" value="0" <cfif get_hr_detail.sex eq 0>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='58958.Kadın'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-marital-status">
                            <label class="col col-4"><cf_get_lang dictionary_id='31203.Medeni Durum'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="married" id="married" value="0" <cfif get_hr_detail.married eq 0 or not len(get_hr_detail.married)>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='31205.Bekar'></label>
                                <div class="col col-2"><input type="radio" name="married" id="married" value="1" <cfif get_hr_detail.married eq 1>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='31204.Evli'></label>
                            </div>
                        </div>
                    
                        <!---<td><cf_get_lang no='472.Instant Mesaj'></td>
                        <td>
                        <select name="imcat_id" id="imcat_id" style="width:48px;">
                            <cfoutput query="IM_CATS">
                                <option value="#IM_CATS.IMCAT_ID#" <cfif GET_HR_DETAIL.IMCAT_ID eq IM_CATS.IMCAT_ID>selected</cfif>>#IM_CATS.IMCAT#
                            </cfoutput>
                        </select>
                        <cfinput type="text" name="im" maxlength="50" value="#GET_HR_DETAIL.IM#">
                        </td>--->

                        
                        
                        <div class="form-group" id="item-is-smoking">
                            <label class="col col-4"><cf_get_lang dictionary_id='31230.Sigara Kullanıyor Musunuz?'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_hr_detail.use_cigarette eq 1>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57495.Evet'></label>
                                <div class="col col-2"><input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_hr_detail.use_cigarette eq 0 or not len(get_hr_detail.use_cigarette)>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-martyr_relative_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31231.Şehit Yakını Mısınız'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_hr_detail.martyr_relative eq 1>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57495.Evet'></label>
                                <div class="col col-2"><input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_hr_detail.martyr_relative eq 0 or not len(get_hr_detail.martyr_relative)>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-defected_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31232.Özürlü'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="defected" id="defected" value="1" <cfif get_hr_detail.defected eq 1>checked</cfif> onclick="seviye();"></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57495.Evet'></label>
                                <div class="col col-2"><input type="radio" name="defected" id="defected" value="0" <cfif get_hr_detail.defected eq 0 or not get_hr_detail.recordcount>checked</cfif> onclick="seviye1();"></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57496.Hayır'></label>
                                <div class="col col-12">
                                    <select name="defected_level" id="defected_level" <cfif get_hr_detail.defected eq 0  or not get_hr_detail.recordcount>disabled</cfif>>
                                        <cfloop from="0" to="100" index="a">
                                            <cfoutput><option value="#a#">#a#%</option></cfoutput>
                                            <cfif get_hr_detail.defected_level eq a>
                                                <cfoutput><option value="#a#" selected>#a#%</option></cfoutput>
                                            </cfif>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-sentenced_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31233.Hüküm Giydiniz mi'></label>
                            <div class="col col-8">
                                <div class="col col-2">
                                <input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_hr_detail.sentenced eq 1>checked</cfif>> </div><label  class="col col-4"><cf_get_lang dictionary_id='57495.Evet'></label>
                                <div class="col col-2">
                                <input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_hr_detail.sentenced eq 0  or not get_hr_detail.recordcount>checked</cfif>></div>	
                                <label  class="col col-4"><cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-illness_probability_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31370.Devam Eden Bir Rahatsızlığınız Var Mı?'></label>
                            <div class="col col-8">
                                <div class="col col-2"><input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_hr_detail.illness_probability eq 1>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57495.Evet'></label>
                                <div class="col col-2"><input type="radio" name="illness_probability" id="illness_probability" value="0"<cfif get_hr_detail.illness_probability eq 0 or not get_hr_detail.recordcount>checked</cfif>></div>
                                <label class="col col-4"><cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-illness_detail_">
                            <label class="col col-4"><cf_get_lang dictionary_id='31371.Varsa nedir?'></label>
                            <div class="col col-8"><textarea name="illness_detail" id="illness_detail" style="width:150px;height:35px"><cfif len(get_hr_detail.illness_detail)><cfoutput>#get_hr_detail.illness_detail#</cfoutput></cfif></textarea></div>
                        </div>
                        <div class="form-group" id="item-employee_img_">
                            <cfif isdefined('is_image_change') and is_image_change eq 1>
                                <label class="col col-6"><cf_get_lang dictionary_id='31495.Fotoğraf'></label>
                                <div class="col col-6">
                                    <input type="file" name="employee_img" id="employee_img">
                                </div>
                            <cfelse>
                                <div></div>
                            </cfif>	
                        
                            <cfif len(GET_HR_DETAIL.PHOTO)>
                            <div class="col col-6">
                                <cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') eq 8>
                                    <cfset image_type = 'photo'>
                                    <cfinclude template = "dsp_my_signature.cfm">
                                <cfelse>
                                <!---   <cf_get_server_file output_file="hr/#GET_HR_DETAIL.photo#" output_server="#GET_HR_DETAIL.photo_server_id#" output_type="0" image_width="120" image_height="160" class="img-circle"><br/>--->
                                    <!--- <img src="<cfoutput>documents/hr/#GET_HR_DETAIL.photo#</cfoutput>" border="0" class="my-info-photo img-circle"> --->
                                </cfif>
                                <cfif isdefined('is_image_change') and is_image_change eq 1>
                                    <cfif len(GET_HR_DETAIL.photo)>
                                        <cf_get_lang dictionary_id ='31719.Fotoğrafı Sil'>
                                        <input type="hidden" name="_photo_" id="_photo_" value="<cfoutput>#GET_HR_DETAIL.photo#</cfoutput>">
                                        <input  type="Checkbox" name="del_photo" id="del_photo" value="1" onchange="employee_img.disabled = !(employee_img.disabled);"> <cf_get_lang dictionary_id='57495.Evet'>
                                    </cfif>
                                </cfif>
                            </div>
                        
                        </cfif>
                        </div>
                    </div>
                </cf_box_elements>
            
            <!--- Kisisel Bilgiler --->
            <!--- Kimlik Bilgileri --->
            <cf_seperator id="kimlik_bilgileri" header="#getLang('','Kimlik Bilgileri',31234)#" is_closed="1">
                <cf_box_elements id="kimlik_bilgileri">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-series_">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31235.Cüzdan Seri No'></label>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cfinput type="text" name="series" id="series" maxlength="20" value="#get_hr_detail.series#">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfinput type="text" name="number" id="number" maxlength="50" value="#get_hr_detail.number#">
                            </div>
                        </div>
                        <div class="form-group" id="item-father">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput name="father" type="text" value="#get_hr_detail.father#" maxlength="75">
                            </div>
                        </div>
                        <div class="form-group" id="item-mother">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput name="mother" type="text" value="#get_hr_detail.mother#" maxlength="75" >
                            </div>
                        </div>
                        <div class="form-group" id="item-birth_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="birth_date" value="#dateformat(get_hr_detail.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Doğum Tarihi girmelisiniz',31240)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date" max_date="#dateformat(fusebox.simdi,'yyyymmdd')#"> </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-birth_place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="birth_place" maxlength="100" value="#get_hr_detail.birth_place#">
                            </div>
                        </div>
                        <div class="form-group" id="item-birth_city">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='58608.İl'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="birth_city" id="birth_city">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_city">
                                        <option value="#city_id#"<cfif get_hr_detail.birth_city eq city_id>selected</cfif>>#city_name#</option>
                                    </cfoutput>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-txtbold">
                            <label class="txtbold"><cf_get_lang dictionary_id='31247.Nüfusa Kayıtlı Olduğu'> </label>
                        </div>
                        <div class="form-group" id="item-city">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="city" maxlength="100" value="#get_hr_detail.CITY#">
                            </div>
                        </div>
                        <div class="form-group" id="item-county">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="county" maxlength="100" value="#get_hr_detail.county#">
                            </div>
                        </div>
                        <div class="form-group" id="item-ward">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="ward" maxlength="100" value="#get_hr_detail.ward#">
                            </div>
                        </div>
                        <div class="form-group" id="item-village">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31254.Köy'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="village" maxlength="100" value="#get_hr_detail.village#">
                            </div>
                        </div>
                        <div class="form-group" id="item-binding">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31249.Cilt No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="binding" id="binding" onKeyUp="isNumber(this)" maxlength="20" value="#get_hr_detail.BINDING#">
                            </div>
                        </div>
                        <div class="form-group" id="item-family">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31251.Aile Sıra No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="family" maxlength="20" value="#get_hr_detail.family#">
                            </div>
                        </div>
                        <div class="form-group" id="item-cue">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31253.Sıra No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="cue" maxlength="20" value="#get_hr_detail.cue#">
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-tc_identy_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="tc_identy_no" onKeyUp="isNumber(this);" maxlength="11" value="#get_hr_detail.tc_identy_no#">
                            </div>
                        </div>
                        <div class="form-group" id="item-religion">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31241.Dini'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="religion"maxlength="50" value="#get_hr_detail.religion#">
                            </div>
                        </div>
                        <div class="form-group" id="item-blood_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="blood_type" id="blood_type">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="0"<cfif (get_hr_detail.blood_type eq 0)>selected</cfif>>0 Rh+</option>
                                    <option value="1"<cfif (get_hr_detail.blood_type eq 1)>selected</cfif>>0 Rh-</option>
                                    <option value="2"<cfif (get_hr_detail.blood_type eq 2)>selected</cfif>>A Rh+</option>
                                    <option value="3"<cfif (get_hr_detail.blood_type eq 3)>selected</cfif>>A Rh-</option>
                                    <option value="4"<cfif (get_hr_detail.blood_type eq 4)>selected</cfif>>B Rh+</option>
                                    <option value="5"<cfif (get_hr_detail.blood_type eq 5)>selected</cfif>>B Rh-</option>
                                    <option value="6"<cfif (get_hr_detail.blood_type eq 6)>selected</cfif>>AB Rh+</option>
                                    <option value="7"<cfif (get_hr_detail.blood_type eq 7)>selected</cfif>>AB Rh-</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-tax_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="tax_number" id="tax_number" onKeyUp="isNumber(this);" value="#get_hr_detail.tax_number#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-tax_office">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="tax_office" value="#get_hr_detail.tax_office#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-last_surname">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31244.Önceki Soyadı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="last_surname" maxlength="100" value="#get_hr_detail.last_surname#">
                            </div>
                        </div>
                        <cfif xml_socialsec_no eq 1>
                            <div class="form-group" id="item-socialsec_no">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31245.Sosyal Güvenlik No'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfinput type="text" name="socialsec_no" style="width:150px" maxlength="50" value="#get_hr_detail.SOCIALSECURITY_NO#">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-txtboldd">
                            <label class="txtbold"><cf_get_lang dictionary_id='31255.Cüzdanın'></label>
                        </div>
                        <div class="form-group" id="item-given_place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31256.Verildiği Yer'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="given_place"  maxlength="100" value="#get_hr_detail.given_place#">
                            </div>
                        </div>
                        <div class="form-group" id="item-given_reason">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31258.Veriliş Nedeni'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="given_reason" maxlength="300" value="#get_hr_detail.given_reason#">
                            </div>
                        </div>
                        <div class="form-group" id="item-given_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31165.Veriliş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfinput type="text" name="given_date" value="#dateformat(get_hr_detail.given_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Veriliş Tarihi girmelisiniz',55790)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="given_date" max_date="#dateformat(fusebox.simdi,'yyyymmdd')#"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-record_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31257.Kayıt No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="record_number" maxlength="50" value="#get_hr_detail.record_number#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            
            <!--- Kimlik Bilgileri --->
            <!--- Iletisim- Referans Bilgileri --->
            <cf_seperator id="iletisim" header="#getLang('','İletişim - Referans Bilgileri',31260)#" is_closed="1">
                <cf_box_elements id="iletisim">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-directTelCode_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31648.Direkt Tel'> <cf_get_lang dictionary_id='29677.Sahsi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-3">
                                    <cfinput value="#get_hr_detail.DIRECT_TELCODE_SPC#" type="text" name="directTelCode_spc" maxlength="8" validate="integer" message="#getLang('','Direkt Tel',31648)#!" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                                <div class="col col-9">
                                    <cfinput value="#get_hr_detail.DIRECT_TEL_SPC#" type="text" name="directTel_spc" maxlength="10" validate="integer" message="#getLang('','Direkt Tel',31648)#!" onKeyUp="isNumber(this);"  onblur="isNumber(this);">
                                </div>
                            </div>
                        </div>  
                        <div class="form-group" id="item-mobiltel_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'><cf_get_lang dictionary_id='29677.Sahsi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-3">
                                    <cf_wrk_combo
                                        name="mobilcode_spc"
                                        option_name="mobilcat"
                                        option_value="mobilcat"
                                        query_name="GET_SETUP_MOBILCAT"
                                        width="50"
                                        value="#get_hr_detail.MOBILCODE_SPC#">
                                </div>
                                <div class="col col-9">
                                    <cfinput value="#get_hr_detail.MOBILTEL_SPC#" type="text" name="mobiltel_spc" maxlength="10" validate="integer" message="#getLang('','Mobil Tel girmelisiniz',31225)#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-email_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'> <cf_get_lang dictionary_id='29677.Sahsi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="email_spc" maxlength="100" value="#get_hr_detail.EMAIL_SPC#" validate="email" message="#getLang('','Mail Adresi Girmelisiniz',38343)#!">
                            </div>
                        </div>
                        <div class="form-group" id="item-homecountry">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="homecountry" id="homecountry" tabindex="6" onchange="LoadCity(this.value,'homecity','homecounty',0);">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif get_hr_detail.homecountry eq country_id>selected</cfif>>#country_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-homeaddress">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31263.Ev Adresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="homeaddress" id="homeaddress" style="width:150px;height:70px;" message="<cfoutput>#getLang('','Fazla karakter sayısı',29484)#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_hr_detail.homeaddress#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-homecity">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="homecity" id="homecity"  onchange="LoadCounty(this.value,'homecounty');">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif len(get_hr_detail.HOMECITY) or len(get_hr_detail.HOMECOUNTRY)>
                                        <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_detail.homecountry#">
                                        </cfquery>
                                        <cfoutput query="GET_CITY_WORK">
                                            <option value="#city_id#"<cfif get_hr_detail.HOMECITY eq city_id>selected</cfif>>#city_name#</option>	
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-homecounty">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="homecounty" id="homecounty">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif len(get_hr_detail.HOMECOUNTY)>
                                        <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                            SELECT * FROM SETUP_COUNTY <cfif len(get_hr_detail.HOMECITY)>WHERE CITY = #get_hr_detail.HOMECITY#</cfif>
                                        </cfquery>		
                                        <cfoutput query="GET_COUNTY_WORK">
                                            <option value="#county_id#" <cfif get_hr_detail.HOMECOUNTY eq county_id>selected</cfif>>#county_name#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-homepostcode">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31264.Posta Kod'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="messagepost"><cf_get_lang dictionary_id='31265.Posta Kod girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="homepostcode" id="homepostcode" onKeyUp="isNumber(this);" maxlength="10" value="#get_hr_detail.homepostcode#" message="#messagepost#">
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-extension_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31650.Dahili Tel'> <cf_get_lang dictionary_id='29677.Sahsi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="extension_spc" id="extension_spc" value="#get_hr_detail.EXTENSION_SPC#" maxlength="5" validate="integer" message="#message#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                            </div>
                        </div>
                        <div class="form-group" id="item-mobiltel2_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2 <cf_get_lang dictionary_id='29677.Sahsi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-3 padding-0 padding-right-5">
                                    <cf_wrk_combo
                                        name="mobilcode2_spc"
                                        option_name="mobilcat"
                                        option_value="mobilcat"
                                        query_name="GET_SETUP_MOBILCAT"
                                        width="50"
                                        value="#get_hr_detail.MOBILCODE2_SPC#">
                                </div>
                                <div class="col col-9 padding-0">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31225.Mobil Tel girmelisiniz'></cfsavecontent>
                                    <cfinput value="#get_hr_detail.MOBILTEL2_SPC#" type="text" name="mobiltel2_spc" style="width:97px;" maxlength="10" validate="integer" message="#message#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-hometel">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31261.Ev Tel'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-3 padding-0 padding-right-5">
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='31262.Ev Tel girmelisiniz'>!</cfsavecontent>
                                    <cfinput value="#get_hr_detail.hometel_code#" type="text" name="hometel_code" style="width:48px;" maxlength="5" validate="integer" message="#message1#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                                <div class="col col-9 padding-0">
                                    <cfinput value="#get_hr_detail.hometel#" type="text" name="hometel" style="width:99px;" maxlength="9" validate="integer" message="#message1#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-txtboldd_">
                            <label class="txtbold"><cf_get_lang dictionary_id='31268.Bağlantı Kurulacak Kişi'></label>
                        </div>
                        <div class="form-group" id="item-contact1">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                             <div class="col col-8 col-md-8 col-sm-8 col-xs-12">   
                                <cfinput type="text" name="contact1" maxlength="40" value="#get_hr_detail.contact1#">
                             </div>
                        </div>
                        <div class="form-group" id="item-contact1_relation">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31269.Yakınlık'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="contact1_relation" maxlength="40" value="#get_hr_detail.contact1_relation#">
                            </div>
                        </div>
                        <div class="form-group" id="item-contact1_telcode">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Tel'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-3 padding-0 padding-right-5">
                                    <cfsavecontent variable="messagetel"><cf_get_lang dictionary_id='31270.Telefon girmelisiniz'>!</cfsavecontent>
                                    <cfinput value="#get_hr_detail.contact1_telcode#" type="text" name="contact1_telcode" maxlength="5" style="width:48px;" validate="integer" message="#messagetel#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                                <div class="col col-9 padding-0">
                                    <cfinput value="#get_hr_detail.contact1_tel#" type="text" name="contact1_tel" maxlength="9" style="width:99px;" validate="integer" message="#messagetel#" onKeyUp="isNumber(this);" onblur="isNumber(this);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-contact1_email">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="messagemail">1.<cf_get_lang dictionary_id='31271.Bağlantı kurulacak kişinin maillini giriniz'>!</cfsavecontent>
                                <cfinput type="text" name="contact1_email" maxlength="50" value="#get_hr_detail.contact1_email#" validate="email" message="#messagemail#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            
            <cf_seperator id="im_info_table" header="#getLang('','Sosyal Hesaplar',31386)#" is_closed="1">
                <cf_grid_list id="im_info_table">
                    <input type="hidden" name="add_im_info" id="add_im_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
                    <thead>
                        <tr>	
                            <cfif xml_social_media_info> 
                                <th width="20"><a href="javascript://" onClick="add_im_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57630.Tip'></th>
                            <th><cf_get_lang dictionary_id='58723.Adres'></th>
                        </tr>
                    </thead>
                    <input type="hidden" name="instant_info" id="instant_info" value="">
                    <tbody id="im_info">
                        <cfoutput query="get_ims"> 
                            <tr id="im_info_#currentrow#">
                                <cfif xml_social_media_info> 
                                    <td><a onClick="del_im('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                </cfif>
                                <td>
                                    <div class="form-group">  
                                        <select name="imcat_id#currentrow#" id="imcat_id#currentrow#">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfloop query="get_im_cats">
                                                <option value="#imcat_id#" <cfif get_ims.IMCAT_ID eq imcat_id> selected </cfif>>#imcat#</option>  
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group"> 
                                        <cfinput type="text" name="im_address#currentrow#" id="im_address#currentrow#" value="#IM_ADDRESS#">
                                        <input type="hidden" name="del_im_info#currentrow#" id="del_im_info#currentrow#" value="1">
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
           
            <cf_seperator id="ref_info_table" header="#getLang('','Referans Bilgileri',31695)#" is_closed="1">
                <cf_grid_list id="ref_info_table">
                    <cfquery name="get_referance" datasource="#dsn#">
                        SELECT 
                            REFERENCE_ID,
                            REFERENCE_TYPE,
                            REFERENCE_NAME,
                            REFERENCE_COMPANY,
                            REFERENCE_POSITION,
                            REFERENCE_TELCODE,
                            REFERENCE_TEL,
                            REFERENCE_EMAIL
                        FROM 
                            EMPLOYEES_REFERENCE 
                        WHERE 
                                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                    </cfquery>
                        <input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_referance.recordcount#</cfoutput>">
                    
                    <thead>
                        <tr>
                        <cfif isdefined("xml_ref_info") and xml_ref_info eq 1>
                            <th width="20"><a href="javascript://" onclick="add_ref_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
                        </cfif>
                            <th><cf_get_lang dictionary_id='31063.Referans Tipi'></th>
                            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                            <th><cf_get_lang dictionary_id='57574.Sirket'></th>
                            <th><cf_get_lang dictionary_id='29429.Tel Kodu'></th>
                            <th><cf_get_lang dictionary_id='57499.Telefon'></th>
                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                            <th><cf_get_lang dictionary_id='57428.E mail'></th>
                        </tr>
                    </thead>
                    <input type="hidden" name="referance_info" id="referance_info" value="">
                    <tbody id="ref_info">
                        <cfoutput query="get_referance">
                            <tr id="ref_info_#currentrow#">
                                <cfif isdefined("xml_ref_info") and xml_ref_info eq 1> 
                                    <td><a onclick="del_ref('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                </cfif>
                                <td>
                                    <div class="form-group"> 
                                        <select name="ref_type#currentrow#" id="ref_type#currentrow#">
                                            <option value=""><cf_get_lang dictionary_id='31063.Referans Tipi'></option>
                                            <cfloop query="get_reference_type">
                                                <option value="#reference_type_id#"<cfif reference_type_id eq get_referance.REFERENCE_TYPE>selected</cfif>>#reference_type#</option>
                                            </cfloop>
                                            <!---<option value="1"<cfif len(get_referance.REFERENCE_TYPE) and (get_referance.REFERENCE_TYPE eq 1)>selected</cfif>><cf_get_lang no='1791.Grup İçi'></option>
                                            <option value="2"<cfif len(get_referance.REFERENCE_TYPE) and (get_referance.REFERENCE_TYPE eq 2)>selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
                                            --->
                                        </select>
                                    </div>
                                </td>
                                <td><div class="form-group"><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#REFERENCE_NAME#"></div></td>
                                <td><div class="form-group"><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#REFERENCE_COMPANY#"></div></td>
                                <td><div class="form-group"><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" value="#REFERENCE_TELCODE#"></div></td>
                                <td><div class="form-group"><input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" value="#REFERENCE_TEL#"></div></td>
                                <td><div class="form-group"><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#REFERENCE_POSITION#"></div></td>
                                <td>
                                    <div class="form-group"> 
                                        <input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#REFERENCE_EMAIL#">
                                        <input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
           
            <cf_seperator id="calisan_yakinlari" header="#getLang('','Çalışan Yakınları',31276)#" is_closed="1">
                <cfquery name="get_relatives" datasource="#dsn#">
                    SELECT 
                        RELATIVE_ID,
                        EMPLOYEE_ID,
                        NAME,
                        SURNAME,
                        RELATIVE_LEVEL,
                        BIRTH_DATE,
                        BIRTH_PLACE,
                        TC_IDENTY_NO,
                        EDUCATION,
                        JOB,
                        COMPANY,
                        JOB_POSITION 
                    FROM 
                        EMPLOYEES_RELATIVES 
                    WHERE 
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">  
                    ORDER BY 
                        BIRTH_DATE, 
                        NAME, 
                        SURNAME, 
                        RELATIVE_LEVEL
                </cfquery>
                <cf_grid_list id="calisan_yakinlari">
                    <cfif xml_is_add_relative>
                        <cfif fusebox.circuit eq 'myhome'>
                            <cfset employee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:'wrk')>
                        <cfelse>
                            <cfset employee_id_ = session.ep.userid>
                        </cfif>
                    </cfif>
                    <thead>
                        <tr>
                            <cfif xml_is_add_relative>
                            <th width="20">
                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.employee_relative&event=add&employee_id=#employee_id_#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
                            </th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                            <th><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></th>
                            <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                            <th><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
                            <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                            <th><cf_get_lang dictionary_id='57419.Eğitim'></th>
                            <th><cf_get_lang dictionary_id='31278.Meslek'></th>
                            <th><cf_get_lang dictionary_id='57574.Şirket'></th>	
                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif get_relatives.recordcount>
                            <cfoutput query="get_relatives">
                                <cfif relative_level eq 1><cfset relative_type = "Babası">
                                <cfelseif relative_level eq 2><cfset relative_type = "Annesi">
                                <cfelseif relative_level eq 3><cfset relative_type = "Eşi">
                                <cfelseif relative_level eq 4><cfset relative_type = "Oğlu">
                                <cfelseif relative_level eq 5><cfset relative_type = "Kızı">
                                <cfelseif relative_level eq 6><cfset relative_type = "Kardeşi">
                                </cfif>
                                <tr>
                                    <cfif xml_is_add_relative>
                                        <cfif fusebox.circuit eq 'myhome'>
                                            <cfset RELATIVE_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:RELATIVE_ID,accountKey:'wrk')>
                                        <cfelse>
                                            <cfset RELATIVE_ID_ = RELATIVE_ID>
                                        </cfif>
                                        <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.employee_relative&<cfif isDefined("ssk_ek")>#ssk_ek#</cfif>&event=upd<cfif isDefined("relative_url_string")>#relative_url_string#</cfif>&employee_id=#employee_id_#&relative_id=#RELATIVE_ID_#')"><i class="fa fa-pencil"></i></a></td>
                                    </cfif>
                                    <td>#name# #surname#</td>
                                    <td>#relative_type#</td>
                                    <td align="center">#dateformat(birth_date,dateformat_style)#</td>
                                    <td>#birth_place#</td>
                                    <td>#tc_identy_no#</td>
                                    <td>
                                        <cfif len(education)>
                                            <cfquery name="get_edu" dbtype="query">
                                                SELECT * FROM GET_EDU_LEVEL WHERE EDU_LEVEL_ID=#education#
                                            </cfquery>
                                            #get_edu.education_name#
                                        </cfif>
                                    </td>
                                    <td>#job#</td>
                                    <td>#company#</td>
                                    <td>#job_position#</td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="10"><cf_get_lang dictionary_id='57484.Kayit Yok'>!</td>
                            </tr>
                        </cfif>
                    </tbody>
                </cf_grid_list>

            <cf_seperator id="is_tecrubesi" header="#getLang('','İş Tecrübesi',31280)#" is_closed="1">
                <cf_grid_list id="is_tecrubesi">
                    <cfquery name="get_work_info" datasource="#DSN#">
                        SELECT 
                            EMPLOYEE_ID,
                            EMPAPP_ROW_ID,
                            EXP,
                            EXP_POSITION,
                            EXP_SECTOR_CAT,
                            EXP_TASK_ID,
                            EXP_START,
                            EXP_FINISH,
                            EXP_TELCODE,
                            EXP_TEL,
                            EXP_SALARY,
                            EXP_EXTRA_SALARY,
                            EXP_EXTRA,
                            EXP_REASON,
                            IS_CONT_WORK,
                            EXP_WORK_TYPE_ID
                        FROM 
                            EMPLOYEES_APP_WORK_INFO 
                        WHERE 
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                    </cfquery>
                    <cfif get_work_info.recordcount>
                        <thead>
                            <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
                            <tr>
                                <input name="record_num" id="record_num" type="hidden" value="0">
                                <cfif xml_work_experience>
                                    <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&control=0</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='31526.İş Tecrübesi Ekle'>" alt="<cf_get_lang dictionary_id ='31526.İş Tecrübesi Ekle'>"></i></a></th>
                                    <th width="20"></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id ='31549.Çalışılan Yer'></th>
                                <th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
                                <th><cf_get_lang dictionary_id ='57579.Sektör'></th>
                                <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                                <th><cf_get_lang dictionary_id ='57655.Başlama Tarihi'>*</th>
                                <th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>*</th>
                            </tr>
                        </thead>
                        <tbody id="table_work_info">
                            <cfoutput query="get_work_info">
                                <tr id="frm_row#currentrow#">
                                    <cfif xml_work_experience>
                                        <td><a href="javascript://" onclick="gonder_upd('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='31694.İş Tecrübesi Güncelle'>" alt="<cf_get_lang dictionary_id='31694.İş Tecrübesi Güncelle'>"></i></a></td>
                                    </cfif>
                                    <td>
                                        <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onclick="sil('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>
                                        <input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
                                        <input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
                                        <input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
                                        <input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
                                        <input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
                                        <input type="hidden" name="exp_work_type_id#currentrow#" id="exp_work_type_id#currentrow#" value="#exp_work_type_id#">
                                        <input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
                                        <input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
                                    </td>
                                    <input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" style="width:100%;" value="#empapp_row_id#">
                                    <td><div class="form-group"><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></div></td>
                                    <td><div class="form-group"><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></div></td>
                                    <td>
                                        <input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
                                        <cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
                                            <cfquery name="get_sector_cat" datasource="#dsn#">
                                                SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
                                            </cfquery>
                                        </cfif>
                                        <div class="form-group"><input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly></div>
                                    </td>
                                    <td>
                                        <input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
                                        <cfif isdefined("exp_task_id") and len(exp_task_id)>
                                        <cfquery name="get_exp_task_name" datasource="#dsn#">
                                            SELECT 
                                                PARTNER_POSITION_ID,
                                                PARTNER_POSITION 
                                            FROM 
                                                SETUP_PARTNER_POSITION 
                                            WHERE 
                                                PARTNER_POSITION_ID = #exp_task_id#
                                        </cfquery>
                                        </cfif>
                                        <div class="form-group"><input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly></div>
                                    </td>
                                    <td><div class="form-group"><input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly></div></td>
                                    <td><div class="form-group"><input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly></div></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    <cfelse>
                        <thead>
                            <input type="hidden" name="row_count" id="row_count" value="0">
                            <tr>
                                <cfif xml_work_experience> <th width="20"><input name="record_numb" id="record_numb" type="hidden" value="0"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&control=0</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='31526.İş Tecrübesi Ekle'>" alt="<cf_get_lang dictionary_id ='31526.İş Tecrübesi Ekle'>"></i></a></th>
                                <th width="20"></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id ='31549.Çalışılan Yer'></th>
                                <th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
                                <th><cf_get_lang dictionary_id ='57579.Sektör'></th>
                                <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                                <th><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></th>
                                <th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
                            </tr>
                        </thead>
                        <tbody id="table_work_info"></tbody>
                        <input type="hidden" name="exp_name" id="exp_name" value="">
                        <input type="hidden" name="exp_position" id="exp_position" value="">
                        <input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
                        <input type="hidden" name="exp_task_id" id="exp_task_id" value="">
                        <input type="hidden" name="exp_start" id="exp_start" value="">
                        <input type="hidden" name="exp_finish" id="exp_finish" value="">
                        <input type="hidden" name="exp_telcode" id="exp_telcode" value="">
                        <input type="hidden" name="exp_tel" id="exp_tel" value="">
                        <input type="hidden" name="exp_salary" id="exp_salary" value="">
                        <input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
                        <input type="hidden" name="exp_extra" id="exp_extra" value="">
                        <input type="hidden" name="exp_reason" id="exp_reason" value="">
                        <input type="hidden" name="is_cont_work" id="is_cont_work" value="">
                    </cfif>
                </cf_grid_list>
            
            <cf_seperator id="egitim_durumu" header="#getLang('','Okul Bilgileri',31552)#" is_closed="1">
                <cfquery name="get_edu_info" datasource="#DSN#">
                    SELECT 
                        EMPLOYEE_ID,
                        EDU_TYPE,
                        EDU_ID,
                        EDU_START,
                        EDU_FINISH,
                        EDU_RANK,
                        EDU_PART_ID,
                        IS_EDU_CONTINUE,
                        EMPAPP_EDU_ROW_ID,
                        EDU_NAME,
                        EDU_PART_NAME,
                        EDU_LANG_RATE,
                        EDUCATION_TIME,
                        EDUCATION_LANG AS EDU_LANG
                    FROM 
                        EMPLOYEES_APP_EDU_INFO 
                    WHERE 
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfquery>
                <cf_grid_list id="egitim_durumu">
                    <thead>
                        <input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
                        <tr>
                            <cfif xml_school_info> 
                                <th width="20"><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_edu_info&ctrl_edu=0');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='31555.Eğitim Bilgisi Ekle'>" alt="<cf_get_lang dictionary_id='31555.Eğitim Bilgisi Ekle'>"></i></a></th> 
                            </cfif>
                            <th><cf_get_lang dictionary_id ='31551.Okul Türü'></th>
                            <th><cf_get_lang dictionary_id ='31285.Okul Adı'></th>
                            <th><cf_get_lang dictionary_id ='31553.BaşlYıl'></th>
                            <th><cf_get_lang dictionary_id ='31554.Bitiş Yılı'></th>
                            <th><cf_get_lang dictionary_id ='31482.Not Ort'></th>
                            <th><cf_get_lang dictionary_id ='57995.Bölüm'></th>
                        </tr>
                    </thead>
                    <tbody id="table_edu_info">
                        <cfoutput query="get_edu_info">
                            <tr id="frm_row_edu#currentrow#">
                                <cfif xml_school_info>
                                    <td>
                                        <ul class="ui-icon-list">
                                            <li>
                                                <a href="javascript://" onclick="gonder_upd_edu('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang no ='963.Eğitim Bilgisi Güncelle'>"></i></a>
                                            </li>
                                            <li>
                                                <a href="javascript://" onclick="sil_edu('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                            </li>
                                        </ul>
                                    </td>
                                </cfif>
                                <td>
                                    <input  type="hidden" value="1" id="row_kontrol_edu#currentrow#" name="row_kontrol_edu#currentrow#">
                                    <input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
                                    <cfset edu_type_id_control = "">
                                    <cfif len(edu_type)>
                                        <cfquery name="get_education_level_name" datasource="#dsn#">
                                            SELECT EDU_TYPE,EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                                        </cfquery>
                                        <cfset edu_type_name=get_education_level_name.education_name>	
                                        <cfset edu_type_id_control = get_education_level_name.EDU_TYPE>											
                                    </cfif>		
                                    <div class="form-group">
                                        <input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="#edu_type_name#" readonly>
                                    </div>
                                </td>
                                <td>
                                    <cfif len(edu_id) and edu_id neq -1>
                                        <cfquery name="get_unv_name" datasource="#dsn#">
                                            SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                        </cfquery>
                                        <cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
                                    <cfelse>
                                        <cfset edu_name_degisken = edu_name>
                                    </cfif>
                                    <div class="form-group">
                                        <input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
                                        <input type="text" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
                                    </div>
                                </td>
                                <td><div class="form-group"><input type="text" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#DateFormat(edu_start, "yyyy-mm-dd")#" readonly></div></td>
                                <td><div class="form-group"><input type="text" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#DateFormat(edu_finish, "yyyy-mm-dd")#" readonly></div></td>
                                <td><div class="form-group"><input type="text" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></div></td>
                                <td>
                                    <cfset edu_part_name_degisken = "">
                                    <cfif (len(edu_part_id) and edu_part_id neq -1)>
                                        <cfif edu_type_id_control eq 1><!--- edu_type lise ise--->
                                            <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                            </cfquery>
                                            <cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
                                            <!---<cfelseif listfind('3',edu_type)>--->
                                        <cfelseif listfind('2,3,4,5',edu_type_id_control)> <!--- üniversite ise--->
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
                                    <div class="form-group">
                                        <input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" class="boxtext" value="#edu_part_name_degisken#" readonly>
                                        <input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type_id_control eq 1>#edu_part_id#</cfif>">
                                        <input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('2,3,4,5',edu_type_id_control) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
                                        <input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
                                        <input type="hidden" name="edu_lang_rate#currentrow#" id="edu_lang_rate#currentrow#" class="boxtext" value="#edu_lang_rate#">
                                        <input type="hidden" name="edu_lang#currentrow#" id="edu_lang#currentrow#" class="boxtext" value="#edu_lang#">
                                        <input type="hidden" name="education_time#currentrow#" id="education_time#currentrow#" class="boxtext" value="#education_time#">
                                        <input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" value="#empapp_edu_row_id#">
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot id="tfoot_edu_info">
                        <tr>
                            <td colspan="7">
                                <label class="col col-2"><cf_get_lang dictionary_id='31297.En Son Bitirilen Okul'></label>
                                <div class="form-group col col-4">
                                    <select name="last_school" id="last_school">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="GET_EDU_LEVEL">
                                            <option value="#GET_EDU_LEVEL.edu_level_id#" <cfif GET_EDU_LEVEL.edu_level_id eq get_hr_detail.last_school>SELECTED</cfif>>#GET_EDU_LEVEL.education_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </cf_grid_list>

            <cf_seperator id="akademik_olmayan_programlar" header="#getLang('','Kurs',31294)#" is_closed="1">
                <cf_grid_list id="akademik_olmayan_programlar">
                    <thead>
                        <cfquery name="get_emp_course" datasource="#dsn#">
                            SELECT 
                                COURSE_ID,
                                EMPLOYEE_ID,
                                COURSE_SUBJECT,
                                COURSE_EXPLANATION,
                                COURSE_YEAR,
                                COURSE_LOCATION,
                                COURSE_PERIOD
                            FROM 
                                EMPLOYEES_COURSE 
                            WHERE 
                                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                        </cfquery>
                        <input type="hidden" name="emp_ex_course" id="emp_ex_course" value="<cfoutput>#get_emp_course.recordcount#</cfoutput>">
                        <tr>
                           <cfif xml_course_info><th width="20"><a onclick="add_row_course();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th></cfif>
                            <th><cf_get_lang dictionary_id='57480.Konu'>*</th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <th><cf_get_lang dictionary_id='58455.Yıl'>*</th>
                            <th><cf_get_lang dictionary_id='31296.Yer'></th>
                            <th><cf_get_lang dictionary_id='57490.Gün'></th>
                        </tr>
                    </thead>
                    <tbody id="emp_course_info">
                        <input type="hidden" name="emp_course" id="emp_course" value="">
                        <cfif isdefined("get_emp_course")>
                            <cfoutput query="get_emp_course">
                                <tr id="pro_course#currentrow#">
                                    <cfif xml_course_info><td><a onclick="sil_('#currentrow#');"><i class="fa fa-minus" border="0"></i></a></td></cfif>
                                    <td><div class="form-group"><input type="text" maxlength="200"  name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#COURSE_SUBJECT#"></div></td>
                                    <td><div class="form-group"><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#course_explanation#" maxlength="200"></div></td>
                                    <td><div class="form-group"><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" onkeyup="isNumber(this)" value="#left(course_year,4)#"></div></td>
                                    <td><div class="form-group"><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#" maxlength="150"></div></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#" maxlength="50">
                                            <input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </cf_grid_list>

            <cf_seperator id="interest_info" header="#getLang('','İlgi Alanları ve Üye Olunan Klüpler',31299)#" is_closed="1">
                <div id="interest_info" class="col col-12">
                    <cfinclude template="/V16/objects/query/get_hobby.cfm">
                    <cfquery name="get_emp_hobbies" datasource="#dsn#"> 
                        SELECT 
                            EMPLOYEES_HOBBY.HOBBY_ID,
                            SETUP_HOBBY.HOBBY_NAME
                        FROM 
                            EMPLOYEES_HOBBY,					
                            SETUP_HOBBY
                        WHERE
                            SETUP_HOBBY.HOBBY_ID=EMPLOYEES_HOBBY.HOBBY_ID AND 
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    </cfquery>
                    <cfset employees_hobbies = valueList(get_emp_hobbies.HOBBY_ID) />
                    <div class="form-group">
                        <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='31298.İlgi Alanları'></label>
                        <div class="col col-4 col-sm-12">
                            <cf_multiselect_check
                                name="hobby"
                                option_name="HOBBY_NAME"
                                option_value="HOBBY_ID"
                                width="130"
                                value="#employees_hobbies#"
                                query_name="GET_HOBBY">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='31300.Üye Olunan Klüp Ve Dernekler'></label>
                        <div class="col col-4 col-sm-12">
                            <textarea name="club" id="club" style="width:300px;"  message="<cfoutput>#getLang('','Fazla karakter sayısı',29484)#</cfoutput>" maxlength="300" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_hr_detail.club#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            
            <cf_seperator id="bilgisayar_bilgisi" header="#getLang('','Bilgisayar Bilgisi',31301)#" is_closed="1">
                <div id="bilgisayar_bilgisi" class="col col-12">
                    <div class="form-group">
                        <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='31301.Bilgisayar Bilgisi'></label>
                        <div class="col col-4 col-sm-12">
                            <textarea name="comp_detail" id="comp_detail" style="width:300px;height:50px;"><cfoutput>#get_hr_detail.comp_exp#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            <cf_seperator id="yabanci_diller" header="#getLang('','Diller',31303)#" is_closed="1">
                <cfquery name="get_emp_language" datasource="#dsn#">
                    SELECT 
                        EMPLOYEE_ID,
                        LANG_ID,
                        LANG_SPEAK,
                        LANG_WRITE,
                        LANG_MEAN,
                        LANG_WHERE,
                        PAPER_DATE,
						PAPER_FINISH_DATE,
						PAPER_NAME,
						LANG_POINT,
						LANG_PAPER_NAME 
                    FROM 
                        EMPLOYEES_APP_LANGUAGE
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                </cfquery>
                <input type="hidden" name="add_lang_info" id="add_lang_info" value="<cfoutput>#get_emp_language.recordcount#</cfoutput>">
                <cf_grid_list id="yabanci_diller" sort="0">
                    <thead>
                        <tr>
                            <cfif xml_language_info><th width="20"><a href="javascript://" onclick="add_lang_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th></cfif>
                            <th><cf_get_lang dictionary_id='58996.Dil'></th>
                            <th><cf_get_lang dictionary_id='31304.Konuşma'></th>
                            <th><cf_get_lang dictionary_id='31305.Anlama'></th>
                            <th><cf_get_lang dictionary_id='31306.Yazma'></th>
                            <th><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></th>
                            <th><cf_get_lang dictionary_id='35947.Belge Adı'></th>
                            <th><cf_get_lang dictionary_id='33203.Belge tarihi'></th>
                            <th><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                            <th><cf_get_lang dictionary_id='41169.Dil Puanı'></th>
                        </tr>
                    </thead>
                    <input type="hidden" name="language_info" id="language_info" value="">
                    <tbody id="lang_info">
                        <cfoutput query="get_emp_language">
                            <tr id="lang_info_#currentrow#">
                                <cfif xml_language_info> <td><a onclick="del_lang('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td></cfif>
                                <td>
                                    <div class="form-group">
                                        <select name="lang#currentrow#" id="lang#currentrow#">
                                            <option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
                                            <cfloop query="get_languages">
                                                <option value="#language_id#"<cfif language_id eq get_emp_language.LANG_ID>selected</cfif>>#language_set#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="lang_speak#currentrow#" id="lang_speak#currentrow#">
                                            <cfloop query="know_levels">
                                                <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_speak>selected</cfif>>#knowlevel#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="lang_mean#currentrow#" id="lang_mean#currentrow#">
                                            <cfloop query="know_levels">
                                                <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_mean>selected</cfif>>#knowlevel#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="lang_write#currentrow#" id="lang_write#currentrow#">
                                            <cfloop query="know_levels">
                                                <option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_write>selected</cfif>>#knowlevel#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="lang_where#currentrow#" id="lang_where#currentrow#" value="#get_emp_language.lang_where#">
                                        <input type="hidden" name="del_lang_info#currentrow#" id="del_lang_info#currentrow#" value="1">
                                    </div>
                                </td>
                                <cfif isdefined('x_document_name') and x_document_name eq 0>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="paper_name#currentrow#" id="paper_name#currentrow#" value="#paper_name#">
                                        </div>
                                    </td>
                                <cfelse>
                                    <input type="hidden" name="paper_name#currentrow#" id="paper_name#currentrow#" value="#paper_name#">
                                </cfif>
                                
                                <cfif isdefined('x_document_name') and x_document_name eq 1>
                                    <td>
                                        <div class="form-group">
                                            <select name="lang_paper_name#currentrow#" id="lang_paper_name#currentrow#">
                                                <option value=""><cf_get_lang dictionary_id='35947.Belge Adı'></option>
                                                <cfloop query="get_languages_document">
                                                    <option value="#document_id#"<cfif document_id eq get_emp_language.lang_paper_name>selected</cfif>>#document_name#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </td>
                                <cfelse>
                                    <input type="hidden" name="lang_paper_name#currentrow#" id="lang_paper_name#currentrow#" value="#get_emp_language.lang_paper_name#">
                                </cfif>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput validate="#validate_style#" type="text" name="paper_date#currentrow#" value="#dateformat(get_emp_language.paper_date,dateformat_style)#"> 
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="paper_date#currentrow#"></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput validate="#validate_style#" type="text" name="paper_finish_date#currentrow#" value="#dateformat(get_emp_language.paper_finish_date,dateformat_style)#"> 
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="paper_finish_date#currentrow#"></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="lang_point#currentrow#" id="lang_point#currentrow#" value="#TLFormat(get_emp_language.lang_point)#"  onkeyup="return(FormatCurrency(this,event,2));">
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>

            <cf_seperator id="kullandigi_araclar" header="#getLang('','Kullandığı Araçlar',31308)#" is_closed="1">
                <cf_box_elements id="kullandigi_araclar">
                    <cfset tools_list = get_hr_detail.tools>
                    <cfset counter = 0>
                    <cfset tools ="">
                    <cfset tools_values ="">
                    <cfloop list="#tools_list#" index="item" delimiters=";">
                        <cfset counter = counter +1>
                        <cfif counter mod 2>
                            <cfset tools = listappend(tools, item,";")>
                        <cfelse>
                            <cfset tools_values = listappend(tools_values, item,";")>
                        </cfif>
                    </cfloop>
                    <cfloop from="1" to="12" index="i">
                        <div class="form-group">
                            <label class="col col-7"><input type="text" maxlength="1000" name="tool<cfoutput>#i#</cfoutput>" id="tool<cfoutput>#i#</cfoutput>" <cfif i lte listlen(tools,";")>value="<cfoutput>#listgetat(tools,i,";")#</cfoutput>"</cfif>></label>
                            <div class="col col-5">
                                <select name="tool<cfoutput>#i#</cfoutput>_level" id="tool<cfoutput>#i#</cfoutput>_level" size="1">
                                    <cfoutput query="know_levels">
                                        <option value="#knowlevel_id#" <cfif (i lte listlen(tools,";")) and (listgetat(tools_values,i,";") eq knowlevel_id)>selected</cfif> >#knowlevel# 
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfloop>
                </cf_box_elements>

            <cf_seperator id="biyografi" header="#getLang('','Biyografi',31565)#" is_closed="1">
                <div id="biyografi" class="col col-12">
                    <div class="form-group">
                        <div class="col col-4 col-sm-12">
                            <textarea name="biography" id="biography" maxlength="950" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cfoutput>#getLang('','250 Karakterden Fazla Yazmayınız',56883)#</cfoutput>" style="width:300px;height:50px;"><cfif len(GET_HR_DETAIL.BIOGRAPHY)><cfoutput>#GET_HR_DETAIL.BIOGRAPHY#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                    <!--- Sadeece 8 versiyonunda ıslak imza gelecek. Diğerlerinde cfimage desteklenmiyor --->
                    <cfif listfirst(server.ColdFusion.ProductVersion,',') eq 8>
                        <cfset image_type = 'signature'>
                        <cfinclude template="dsp_my_signature.cfm">
                    </cfif>
                </div>
           
            <!--- //Özlük Belgeleri --->
            <cf_seperator id="ozluk" header="#getLang('','Özlük ve Yetkinlik Belgeleri',61122)#" is_closed="1">
                <cfscript>
                    get_asset = createObject("component","V16.myhome.cfc.get_employment_asset");
                    get_asset.dsn = dsn;
                    get_asset_row = get_asset.get_employe_asset
                                    (
                                        employee_id: attributes.employee_id,
                                        is_view_myhome : 1
                                    );
                    get_personal_certificate = get_asset.get_employee_personal_certificate
                                    (
                                        employee_id: attributes.employee_id
                                    );
                </cfscript>
                <cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
                <cfset get_x_employment_assets_pages = get_fuseaction_property.get_fuseaction_property(
                    company_id : session.ep.company_id,
                    fuseaction_name : 'hr.form_upd_emp',
                    property_name : 'x_employment_assets_pages'
                )>
                <cfif get_x_employment_assets_pages.recordcount>
                    <cfset x_employment_assets_pages = get_x_employment_assets_pages.property_value>
                <cfelse>
                    <cfset x_employment_assets_pages = 0>
                </cfif>
                <table id="ozluk" align="center" width="99%">
                    <tr>
                        <td>
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                                        <th><cf_get_lang dictionary_id='57630.Tip'></th>
                                        <th><cf_get_lang dictionary_id='55652.Belge Adı'></th>
                                        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                                        <th><cf_get_lang dictionary_id='31165.Veriliş Tarihi'></th>
                                        <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                                        <th width="20"><cf_get_lang dictionary_id='57468.Belge'></th>
                                        <cfset emp_id = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:'wrk')>
                                        <cfif x_employment_assets_pages eq 0>
                                            <cfif xml_employment_asset eq 1>
                                                <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_emp_employment_assets&employee_id=<cfoutput>#emp_id#</cfoutput>','page','popup_form_upd_emp_personal_certificate');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='61096.Özlük Belgesi Ekle'>"></i></a></th>
                                            </cfif>
                                        <cfelse>
                                            <cfif xml_employment_asset eq 1>
                                                <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_upd_emp_employment_assets&employee_id=<cfoutput>#emp_id#</cfoutput>','page','popup_form_upd_emp_personal_certificate');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='61096.Özlük Belgesi Ekle'>"></i></a></th>
                                            </cfif>
                                            <cfif xml_personel_document eq 1>
                                                <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_upd_emp_personal_certificate&employee_id=<cfoutput>#emp_id#</cfoutput>','page','popup_form_upd_emp_personal_certificate');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='61097.Yetkinlik Belgesi Ekle'>"></i></a></th>
                                            </cfif>
                                        </cfif>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfif get_asset_row.recordcount or get_personal_certificate.recordcount>
                                        <cfif get_asset_row.recordcount>
                                            <cfoutput query="get_asset_row">
                                                <tr>
                                                    <td>#UPPER_ASSET_CAT#</td>
                                                    <td>#ASSET_CAT#</td>
                                                    <td>#ASSET_NAME#</td>
                                                    <td>#ASSET_NO#</td>
                                                    <td>#dateformat(asset_date,dateformat_style)#</td>
                                                    <td>#dateformat(ASSET_FINISH_DATE,dateformat_style)#</td>
                                                    <td class="text-center"><cfif len(ASSET_FILE)><a href="javascript://" onClick="windowopen('/documents/hr/#ASSET_FILE#','list');"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='36664.Ekli Belge'>" alt="<cf_get_lang dictionary_id='36664.Ekli Belge'>"></i></a></cfif></td>
                                                    <cfif x_employment_assets_pages eq 0>
                                                        <cfif xml_employment_asset eq 1>
                                                            <td></td>
                                                        </cfif>
                                                    <cfelse>
                                                        <cfif xml_employment_asset eq 1>
                                                            <td></td>
                                                        </cfif>
                                                        <cfif xml_personel_document eq 1>
                                                            <td></td>
                                                        </cfif>
                                                    </cfif>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                        <cfif get_personal_certificate.recordcount>
                                            <cfoutput query="get_personal_certificate">
                                                <tr>
                                                    <td><cf_get_lang dictionary_id="55367.Yetkinlik belgeleri"></td>
                                                    <td>#LICENCECAT#</td>
                                                    <td></td>
                                                    <td>#LICENCE_NO#</td>
                                                    <td>#dateformat(LICENCE_START_DATE,dateformat_style)#</td>
                                                    <td>#dateformat(LICENCE_FINISH_DATE,dateformat_style)#</td>
                                                    <td>
                                                        <cfif len(LICENCE_FILE)>
                                                            <a href="javascript://" onClick="windowopen('/documents/hr/#LICENCE_FILE#','list');"><i class="fa fa-file-text" border="0" title="<cf_get_lang dictionary_id='36664.Ekli Belge'>" alt="<cf_get_lang dictionary_id='36664.Ekli Belge'>"></i></a>
                                                        </cfif>
                                                    </td>
                                                    <cfif x_employment_assets_pages eq 0>
                                                        <cfif xml_employment_asset eq 1>
                                                            <td></td>
                                                        </cfif>
                                                    <cfelse>
                                                        <cfif xml_employment_asset eq 1>
                                                            <td></td>
                                                        </cfif>
                                                        <cfif xml_personel_document eq 1>
                                                            <td></td>
                                                        </cfif>
                                                    </cfif>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    <cfelse>
                                        <tr>
                                            <cfset _colspan_ = 7>
                                            <cfif x_employment_assets_pages eq 0>
                                                <cfif xml_employment_asset eq 1>
                                                    <cfset _colspan_++>
                                                </cfif>
                                            <cfelse>
                                                <cfif xml_employment_asset eq 1>
                                                    <cfset _colspan_++>
                                                </cfif>
                                                <cfif xml_personel_document eq 1>
                                                    <cfset _colspan_++>
                                                </cfif>
                                            </cfif>
                                            <td colspan="<cfoutput>#_colspan_#</cfoutput>"><cf_get_lang dictionary_id='58486.kayıt bulunamadı'></td>
                                        </tr>
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
					    </td>
				    </tr>          			
                </table>
          
            <!--- //Özlük Belgeleri --->
            
            <cfif is_info_contract eq 1>
                <div class="row">
                    <div class="col-12">
                        <div class="form-group" id="item-employee_password">
                            <label class="col col-2 col-sm-12 control-label"><b><cf_get_lang dictionary_id="30833.Mevcut şifre"></b></label>
                            <div class="col col-2 col-sm-12">
                                <div class="input-group">
                                    <cfset message = "#getLang('settings',3155,'Lütfen mevcut şifrenizi giriniz!')#">
                                    <cfinput type="text" name="employee_password" id="employee_password" class="input-type-password" value="" maxlength="16" tabindex="3" oncopy="return false" onpaste="return false" required="yes" message="#message#"  autocomplete="off" />
                                    <span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password')"><i class="fa fa-eye"></i></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12">
                        <label class="txtbold"><cfinput type="checkbox" required="yes" message="#getLang('','Belirtilen şartları kabul etmediğiniz için kaydınız gerçekleşmeyecek',59999)#" name="kutu"><cf_get_lang dictionary_id='60000.Tarafımca yukarıda vermiş olduğum bilgilerin doğruluğunu ve bilgilerin hatalı olması durumunda doğacak yükümlülüğü kabul ediyorum'>.</label>
                    </div>
                </div>
            </cfif>
            <cfif xml_is_display>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <div class="col col-6">
                            <cf_record_info query_name="GET_HR_DETAIL">
                        </div>
                        <div class="col col-6">
                            <cf_workcube_buttons add_function='kontrol()'>
                        </div>
                    </div>
                </div>
            </cfif>
        </cfform>
    </cf_box>     
</div>
<form name="form_work_info" method="post" action="">
	<input type="hidden" name="exp_name_new" id="exp_name_new" value="">
	<input type="hidden" name="exp_position_new" id="exp_position_new" value="">
	<input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
	<input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
	<input type="hidden" name="exp_start_new" id="exp_start_new" value="">
	<input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
	<input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
	<input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
	<input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
	<input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
	<input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
    <input type="hidden" name="exp_work_type_id_new" id="exp_work_type_id_new" value="">
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
	<input type="hidden" name="education_time_new" id="education_time_new" value="">
	<input type="hidden" name="edu_lang_rate_new" id="edu_lang_rate_new" value="">
	<input type="hidden" name="edu_lang_new" id="edu_lang_new" value="">
	<input type="hidden" name="edu_part_name_new" id="edu_part_name_new" value="">
	<input type="hidden" name="is_edu_continue_new" id="is_edu_continue_new" value="">
</form>
<script type="text/javascript">
    $( document ).ready(function() {
        <cfif isdefined("xml_ref_info") and xml_ref_info eq 0>
            document.getElementById("ref_info_table").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_personal_info") and xml_personal_info eq 0>
            document.getElementById("kisisel_bilgiler_").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_identification_info") and xml_identification_info eq 0>
            document.getElementById("kimlik_bilgileri").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_contact_info") and xml_contact_info eq 0>
            document.getElementById("iletisim").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_social_media_info") and xml_social_media_info eq 0>
            document.getElementById("im_info_table").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_course_info") and xml_course_info eq 0>
            document.getElementById("akademik_olmayan_programlar").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_interest_info") and xml_interest_info eq 0>
            document.getElementById("interest_info").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_computer_info") and xml_computer_info eq 0>
            document.getElementById("bilgisayar_bilgisi").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_language_info") and xml_language_info eq 0>
            document.getElementById("yabanci_diller").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_tools_info") and xml_tools_info eq 0>
            document.getElementById("kullandigi_araclar").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_biography_info") and xml_biography_info eq 0>
            document.getElementById("biyografi").style.pointerEvents = "none";
        </cfif>
        <cfif isdefined("xml_school_info") and xml_school_info eq 0>
            document.getElementById("tfoot_edu_info").style.pointerEvents = "none";
        </cfif>
    });
	<!-- referans bilgileri-->
	var add_ref_info=<cfif isdefined("get_referance")><cfoutput>#get_referance.recordcount#</cfoutput><cfelse>0</cfif>;
	var add_im_info=<cfif isdefined("get_ims")><cfoutput>#get_ims.recordcount#</cfoutput><cfelse>0</cfif>;

	function del_ref(dell){
			var my_emement1=eval("employe_detail.del_ref_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("ref_info_"+dell);
			my_element1.style.display="none";
	}
	function del_im(dell){
			var my_element3=eval("employe_detail.del_im_info"+dell);
			my_element3.value=0;
			var my_element4=eval("im_info_"+dell);
			my_element4.style.display="none";
	}
	function add_ref_info_()
	{
		add_ref_info++;
		employe_detail.add_ref_info.value=add_ref_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
		newRow.setAttribute("name","ref_info_" + add_ref_info);
		newRow.setAttribute("id","ref_info_" + add_ref_info);
		employe_detail.referance_info.value=add_ref_info;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a onclick="del_ref(' + add_ref_info + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		//newCell.innerHTML = '<select name="ref_type' + add_ref_info +'"><option value=""><cf_get_lang no="306.Referans Tipi"></option><option value="1">Gurup İçi</option><option value="2">Diğer</option></select>';
		newCell.innerHTML = '<div class="form-group"><select name="ref_type' + add_ref_info +'"><option value=""><cf_get_lang dictionary_id="31063.Referans Tipi"></option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_name' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_company' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_telcode' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_tel' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_position' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_mail' + add_ref_info +'"></div>';
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
		newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a onclick="del_im(' + add_im_info + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="imcat_id' + add_im_info +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="im_address' + add_im_info +'"></div>';
	}
	var emp_ex_course =<cfif get_emp_course.recordcount><cfoutput>'#get_emp_course.recordcount#'</cfoutput><cfelse>0</cfif>;
	function sil_(del){
			var my_element_=eval("employe_detail.del_course_prog"+del);
			my_element_.value=0;
			var my_element_=eval("pro_course"+del);
			my_element_.style.display="none";
	
	}
	function add_row_course(){
		emp_ex_course++;
		employe_detail.emp_ex_course.value = emp_ex_course;
		var newRow;
		var newCell;
			newRow = document.getElementById("emp_course_info").insertRow(document.getElementById("emp_course_info").rows.length);
			newRow.setAttribute("name","pro_course" + emp_ex_course);
			newRow.setAttribute("id","pro_course" + emp_ex_course);
			document.employe_detail.emp_course.value=emp_ex_course;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + emp_ex_course +'"><a onclick="sil_(' + emp_ex_course + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" maxlength="200"  name="kurs1_' + emp_ex_course +'"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_exp' + emp_ex_course +'" maxlength="200"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_yil' + emp_ex_course +'" maxlength="4" onkeyup="isNumber(this)"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_yer' + emp_ex_course +'" maxlength="150"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_gun' + emp_ex_course +'" maxlength="50"></div>';
	}
	
	function kontrol()
	{
        for(i = 1;i<=add_lang_info ; i++)
        {
            document.getElementById("lang_point"+i).value = filterNum(document.getElementById("lang_point"+i).value);
        }
        var ext_params2_ = employee_password.value + '¶' + '<cfoutput>#session.ep.userid#</cfoutput>';
        var password_control = wrk_safe_query('employee_password_control','dsn',0,ext_params2_);
      
        if(password_control.recordcount == 0)
        {
            alert("<cf_get_lang dictionary_id='30475.Şifrenizi yanlış girdiniz'> !");
            document.getElementById('employee_password').focus();		
            return false;
        }
        if(document.employe_detail.employee_img != undefined){
            var photo = document.getElementById('employee_img');
            var photoSize = photo.files[0].size;
            if(photoSize > 510200){
                alert("<cf_get_lang dictionary_id='48411.Fotoğrafınız maksimum 50KB boyutunda olmalıdır'>");
                return false;
            }
            var obj =  photo.value.toUpperCase();
            var obj_ = list_len(obj,'.');
            var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
            if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='JPEG') 
            {
                alert("<cf_get_lang dictionary_id='56078.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz'>!");        
                return false;
            }
        }
           
		if(document.employe_detail.signature_ != undefined)
		{
			var obj =  document.employe_detail.signature_.value;		
			if ((document.employe_detail.signature_.value != '') && (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() != 'jpeg') && (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() != 'jpg') && (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() != 'gif'))
			{
				alert("<cf_get_lang dictionary_id ='31646.Lütfen bir resim dosyası (gif,jpg veya jpeg) uzantılı bir dosya yükleyiniz '>!");        
				return false;
			}
		}
		if(document.employe_detail.tc_identy_no.value !='' && document.employe_detail.tc_identy_no.value.length < 11)
			{
			alert("<cf_get_lang dictionary_id='30574.TC Kimlik No - 11 Hane	'>!");
			return false;
			}
		for (var counter_=1; counter_ <=  document.employe_detail.emp_ex_course.value; counter_++)
		{
			if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 && eval("document.employe_detail.kurs1_yil"+counter_).value == '' && eval("document.employe_detail.kurs1_yil"+counter_).value.length <4)
			{
				alert("<cf_get_lang dictionary_id='41017.Lütfen Kurs-Sertifika Seçmek İçin'>" + counter_ + "<cf_get_lang dictionary_id='41015.Yıl Giriniz'> !");
				return false;
			}
		}
       
		select_all('hobby');
		return process_cat_control();
		
		
	}
	function seviye()
	{
		if(document.employe_detail.defected_level.disabled==true)
		{document.employe_detail.defected_level.disabled=false;}
	}
	
	function seviye1()
	{
		if(document.employe_detail.defected_level.disabled==false)
		{document.employe_detail.defected_level.disabled=true;}
	}
	
	function remove_field(field_option_name)
	{
		field_option_name_value = eval('document.employe_detail.' + field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
		
	function select_all(selected_field)
	{
		var m = eval("document.employe_detail." + selected_field + ".length");
		for(i=0;i<m;i++)
		{
			eval("document.employe_detail."+selected_field+"["+i+"].selected=true")
		}
	}
	
	function tecilli_fonk(gelen)
	{
		if (gelen == 4)
		{
			Tecilli.style.display='';
			Yapti.style.display='none';
			Yapti2.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 1)
		{
			Yapti.style.display='';
			Yapti2.style.display='';
			Tecilli.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 2)
		{
			Muaf.style.display='';
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Yapti2.style.display='none';
		}
		else
		{
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Yapti2.style.display='none';
			Muaf.style.display='none';
		}
	}
	
	/*İş Tecrübesi*/
	<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
		row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
		satir_say=0;
	<cfelse>
		row_count=0;
		satir_say=0;
	</cfif>
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
		form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
		form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
		form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
		form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
		form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
		form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
		form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
        form_work_info.exp_work_type_id_new.value = eval("employe_detail.exp_work_type_id"+count).value;
		form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
		form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
		windowopen('','medium','kariyer_pop');
		form_work_info.target='kariyer_pop';
		form_work_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
		form_work_info.submit();	
	}
	
	function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,exp_work_type_id,my_count,is_cont_work)
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
					var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
			}
			else
				var exp_sector_cat_name = '';
			eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
			eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
			if(exp_task_id != '')
			{
				var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
			eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
			eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
			eval("employe_detail.exp_tel"+my_count).value=exp_tel;
			eval("employe_detail.exp_salary"+my_count).value=exp_salary;
			eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
			eval("employe_detail.exp_extra"+my_count).value=exp_extra;
			eval("employe_detail.exp_reason"+my_count).value=exp_reason;
            eval("employe_detail.exp_work_type_id"+my_count).value=exp_work_type_id;
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
			new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';		
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly></div>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly></div>';
			if(exp_sector_cat != '')
			{
				var get_emp_cv =  wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
					var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
			}
			else
				var exp_sector_cat_name = '';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly></div>';
			if(exp_task_id != '')
			{
				var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly></div>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly></div>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly></div>';
			
			new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
			new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
            new_Cell.innerHTML += '<input type="hidden" name="exp_work_type_id' + row_count + '" value="'+ exp_work_type_id +'">';
			new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
		}
	}
	/*İş Tecrübesi*/
	
	/*eğitim bilgileri*/
	<cfif isdefined('get_edu_info') and (get_edu_info.recordcount)>
		row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
		satir_say_edu=0;
	<cfelse>
		row_edu=0;
		satir_say_edu=0;
	</cfif>
	
	function sil_edu(sv)
	{
		var my_element=document.getElementById("row_kontrol_edu"+sv);
		my_element.value=0;
		var my_element=document.getElementById("frm_row_edu"+sv);
		my_element.style.display="none";
		satir_say_edu--;
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
		form_edu_info.edu_lang_rate_new.value = eval("employe_detail.edu_lang_rate"+count_new).value;
		form_edu_info.education_time_new.value = eval("employe_detail.education_time"+count_new).value;
		form_edu_info.edu_lang_new.value = eval("employe_detail.edu_lang"+count_new).value;
        var form = $('form[name = form_edu_info]');
	    openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>&'+form.serialize()).replaceAll("+", " "));
	}
	
	function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,education_time,edu_lang,edu_lang_rate,is_edu_continue)
	{
		var edu_name_degisken = '';
		var edu_part_name_degisken = '';
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
				eval("employe_detail.edu_name"+count_edu).value=edu_name;
			}
			eval("employe_detail.edu_start"+count_edu).value=edu_start;
			eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
			eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
			if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
			{
				var get_cv_edu_high_part_id =  wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
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
			eval("employe_detail.edu_lang_rate"+count_edu).value=edu_lang_rate;
			eval("employe_detail.education_time"+count_edu).value=education_time;
			eval("employe_detail.edu_lang"+count_edu).value=edu_lang;
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
			if(edu_type != undefined && edu_type != '')
			{
				var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
				if(get_edu_part_name_sql.recordcount)
					var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
			}	
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<ul class="ui-icon-list"><li><a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li><li><input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" id="row_kontrol_edu' + row_edu +'"> <a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li></ul>';
			//new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			//new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" id="row_kontrol_edu' + row_edu +'"><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><img  src="images/delete_list.gif" border="0"></a>';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_id' + row_edu + '" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
			new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" id="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" class="boxtext" readonly="readonly">';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_part_id' + row_edu + '" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" class="boxtext" readonly="readonly">';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="is_edu_continue' + row_edu + '" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" class="boxtext" readonly="readonly">';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang_rate' + row_edu + '" name="edu_lang_rate' + row_edu + '" value="'+ edu_lang_rate +'" class="boxtext" readonly="readonly">';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="education_time' + row_edu + '" name="education_time' + row_edu + '" value="'+ education_time +'" class="boxtext" readonly="readonly">';
			new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang' + row_edu + '" name="edu_lang' + row_edu + '" value="'+ edu_lang +'" class="boxtext" readonly="readonly">';
	
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:90px;" type="text" id="edu_type_name' + row_edu + '" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly="readonly"></div>';
			if(edu_id != undefined && edu_id != -1)
			{
				var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
				if(get_cv_edu_new.recordcount)
					var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
				if(edu_name_degisken)
				{
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100%;" type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly="readonly"></div>'
				}
			}
			if(edu_name != undefined && edu_name != '')
			{
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100%;" type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly></div>';
			}
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:70px;" type="text" id="edu_start' + row_edu + '" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly></div>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:70px;" type="text" id="edu_finish' + row_edu + '" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly></div>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:70px;" type="text" id="edu_rank' + row_edu + '" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly></div>';
			
			if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
			{
				var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
				if(get_cv_edu_high_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100%;" type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly></div>';
			}
			else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
			{
				var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
				if(get_cv_edu_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<div class="form-group"><input style="width:100%;" type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly></div>';
			}
			else
			{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<div class="form-group"><input type="text" style="width:100%;" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly></div>';
			}
		}
	}
	/*Eğitim Bilgileri*/
	/* Dil Bilgileri */
	var add_lang_info=<cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
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
		newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang' + add_lang_info +'"><option value=""><cf_get_lang dictionary_id="58996.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_speak' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_mean' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_write' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lang_where' + add_lang_info + '" value=""></div>';
        <cfif isdefined('x_document_name') and x_document_name eq 0>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="paper_name' + add_lang_info +'" id="paper_name' + add_lang_info +'" ></div>';</cfif>
		<cfif isdefined('x_document_name') and x_document_name eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_paper_name' + add_lang_info +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id='35947.Belge Adı'></option><cfoutput query="get_languages_document"><option value="#document_id#">#document_name#</option></cfoutput></select></div>';</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute("id","paper_date_" + add_lang_info + "_td");
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="paper_date' + add_lang_info +'" id="paper_date' + add_lang_info +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="paper_date'+add_lang_info + '_td'+'"></span></div></div>';
		wrk_date_image('paper_date' + add_lang_info);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","paper_finish_date_" + add_lang_info + "_td");
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="paper_finish_date' + add_lang_info +'" id="paper_finish_date' + add_lang_info +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="paper_finish_date'+add_lang_info + '_td'+'"></span></div></div>';
        wrk_date_image('paper_finish_date' + add_lang_info);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lang_point' + add_lang_info + '" id ="lang_point' + add_lang_info + '"  value="" style="width:150px;" onkeyup="return(FormatCurrency(this,event,2));"></div>';
	}
</script>