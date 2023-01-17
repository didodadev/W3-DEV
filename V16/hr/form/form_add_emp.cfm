<cf_papers paper_type="EMPLOYEE">
<cf_xml_page_edit fuseact="hr.form_upd_emp">
<cfif len(paper_code)>
    <cfset system_paper_no=paper_code & '-' & paper_number>
<cfelse>
    <cfset system_paper_no=paper_number>
</cfif>
<cfset system_paper_no_add=paper_number>
<cfset employee_no = system_paper_no>
<cfset names="yes">
<cfinclude template="../query/get_titles.cfm">
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../query/get_languages.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_active_shifts.cfm">
<cfinclude template="../query/get_id_card_cats.cfm">
<cfinclude template="../query/get_know_levels.cfm">
<cfquery name="GET_PASSWORD_STYLE" datasource="#DSN#">
	SELECT * FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
</cfquery>
<cfset crm=0>
<cfif isdefined("url.crm")>
  <cfset crm=url.crm>
</cfif>
<cfset attributes.tc_identy_no = "">
<cfset attributes.employee_name = "">
<cfset attributes.employee_surname  = "">
<cfset attributes.employee_email = "">
<cfif isDefined("attributes.per_assign_id") and Len(attributes.per_assign_id)>
	<!--- Atama Talebinden Iliskili Calisan Ekleniyor --->
	<cfquery name="get_assign_info" datasource="#dsn#">
		SELECT PERSONEL_NAME, PERSONEL_SURNAME,PERSONEL_TC_IDENTY_NO FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_assign_id#">
	</cfquery>
	<cfset attributes.tc_identy_no = get_assign_info.personel_tc_identy_no>
	<cfset attributes.employee_name = get_assign_info.personel_name>
	<cfset attributes.employee_surname  = get_assign_info.personel_surname>
<cfelseif isDefined("url.service")>
	<cfset attributes.employee_name = attributes.consumer_name>
	<cfset attributes.employee_surname = attributes.consumer_surname>
	<cfset attributes.employee_email = attributes.consumer_email>
</cfif>
<cfif isdefined('xml_is_tc_number') and xml_is_tc_number eq 1><cfset tc_kontrol=1><cfelse><cfset tc_kontrol=0></cfif>
<cf_catalystHeader>
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_emp&crm=#crm#&xml_is_tc_number=#tc_kontrol#" enctype="multipart/form-data" onsubmit="return (last_control());">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
            <cf_box>
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <input type="hidden" name="detailed" id="detailed" value="0">
                        <input type="hidden" name="crm" id="crm" value="<cfoutput>#crm#</cfoutput>">
                        <input type="hidden" name="design_id" id="design_id" value="<cfoutput>#default_menu?:1#</cfoutput>" />
                        <input type="hidden" name="system_paper_no" id="system_paper_no" value="<cfif isdefined('system_paper_no')><cfoutput>#system_paper_no#</cfoutput></cfif>">
                        <input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfif isdefined('system_paper_no_add')><cfoutput>#system_paper_no_add#</cfoutput></cfif>">
                        <div class="form-group" id="item-sex">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            	<label>
                                    <input type="radio" name="sex" id="sex" value="1" checked> <cf_get_lang dictionary_id='58959.Erkek'>
                                </label>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label>
                                    <input type="radio" name="sex" id="sex" value="0"> <cf_get_lang dictionary_id='58958.Kadın'>
                                </label>
                            </div>
                        </div>
                        <div class="form-group" id="item-tc_identy_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif isdefined('xml_tc_identy_no')><cfset maxlength_ = xml_tc_identy_no><cfelse><cfset maxlength_ = 11></cfif>
                                 <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" maxlength="#maxlength_#" onKeyup="isNumber(this);" value="#attributes.tc_identy_no#">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad'> </cfsavecontent>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="employee_name" id="employee_name" maxlength="50" required="yes" onkeyup="isCharacter(this,1,45);" message="#message#" value="#attributes.employee_name#">
                            </div>
                         </div>
                        <div class="form-group" id="item-employee_surname">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput name="employee_surname" id="employee_surname" type="text" maxlength="50" required="yes" onkeyup="isCharacter(this,0,45);" message="#message#" value="#attributes.employee_surname#">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_username">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput value="" type="text" name="employee_username" id="employee_username" maxlength="20" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-password">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55439.Şifre*(karakter duyarlı)'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                <cfif isdefined("use_active_directory") and use_active_directory neq 3>
                                    <cfinput value="" type="text" class="input-type-password" name="employee_password" id="employee_password" maxlength="16" message="#message#">
                                <cfelse>
                                    <cfinput value="" type="text" class="input-type-password" name="employee_password" id="employee_password" maxlength="16" message="#message#" readonly="yes">
                                </cfif>
                                <span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password')"><i class="fa fa-eye"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-language">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="language" id="language">
                                    <cfoutput query="get_languages">
                                        <option value="#language_short#">#language_set#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-reason_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='55550.Gerekçe'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_combo query_name="GET_FIRE_REASONS" name="reason_id" option_value="reason_id" option_name="reason" where="IS_ACTIVE=1">
                            </div>
                        </div>
                        <div class="form-group" id="item-HIERARCHY">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> (<cf_get_lang dictionary_id='57761.Hiyerarşi'>)</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="HIERARCHY" id="HIERARCHY" value="" maxlength="25">
                            </div>
                        </div>
                        <div class="form-group" id="item-ozel_kod_ilk">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> 1</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="ozel_kod_ilk" id="ozel_kod_ilk" value="" maxlength="25">
                            </div>
                        </div>
                        <div class="form-group" id="item-ozel_kod">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> 2</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="ozel_kod" id="ozel_kod" value="" maxlength="25">
                            </div>
                        </div>
                        <div class="form-group" id="item-computer_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55112.Bilgisayar Adı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="computer_name" id="computer_name" value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ip_address">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55111.IP Kontrol'>/<cf_get_lang dictionary_id='55440.IP Adresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">	
                                <div class="input-group">
                                    <input type="text" name="ip_address" id="ip_address" value="" maxlength="25">
                                    <span class="input-group-addon"><input type="checkbox" name="is_ip_control" id="is_ip_control" value="1"></span>
                                </div>	   
                            </div>
                        </div>
                        <div class="form-group" id="item-time_zone">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58880.Time Zone'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<cf_wrkTimeZone width="445">
                            </div>
                        </div>
                        <div class="form-group" id="item-photo">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55110.Fotoğraf'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<input  type="file" name="photo" id="photo" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-add_info">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_add_info info_type_id="-4" upd_page = "0" colspan="9">
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-employee_status">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'> / <cf_get_lang dictionary_id ='56335.Kritik Çalışan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label><input type="checkbox" name="employee_status" id="employee_status" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label><input type="checkbox" name="is_critical" id="is_critical" value="1"><cf_get_lang dictionary_id ='56335.Kritik Çalışan'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58487.Çalışan No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="employee_no" id="employee_no" value="#employee_no#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_email">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-mail adresi giriniz'></cfsavecontent>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                 <cfinput type="text" name="employee_email" id="employee_email" maxlength="50" value="#attributes.employee_email#" validate="email" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_email_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'> (<cf_get_lang dictionary_id='29688.Kişisel'>)</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                 <cfsavecontent variable="message"><cf_get_lang dictionary_id="34350.Lütfen geçerli bir e-posta adresi giriniz"></cfsavecontent>
                                 <cfinput type="text" name="employee_email_spc" id="employee_email_spc" maxlength="50" validate="email" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_kep_adress">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="employee_kep_adress" id="employee_kep_adress" maxlength="50" value="" validate="email" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-tel_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63740.Dahili Telefon Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="tel_type" id="tel_type">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1">Dec</option>
                                    <option value="2">Web Phone</option>
                                    <option value="3">Mobile</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-direct_tel">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55445.Direkt Tel'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Direkt Tel girmelisiniz'></cfsavecontent>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfinput value="" type="text" name="direct_telcode" id="direct_telcode" style="width:53px;" maxlength="5" validate="integer" message="#message#">
                            </div>
                            <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                <cfinput value="" type="text" name="direct_tel" id="direct_tel" style="width:93px;" maxlength="9" validate="integer" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-dahili_tel">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55446.Dahili Tel'></label>
                            <!--- <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div> --->
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Dahili Tel girmelisiniz'></cfsavecontent>
                                <cfinput value="" type="text" name="dahili_tel" id="dahili_tel" style="width:150px;" maxlength="5" validate="integer" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-corbus_tel">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57772.Kısa'> <cf_get_lang dictionary_id='57499.Tel'></label>
                           <!---  <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div> --->
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<input type="text" name="corbus_tel" id="corbus_tel" maxlength="4" value="" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-mobiltel">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Tel girmelisiniz'></cfsavecontent>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfinput value="" type="text" name="mobilcode" id="mobilcode" style="width:47px;" maxlength="7" validate="integer" message="#message#">
                            </div>
                            <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                            <cfinput value="" type="text" name="MOBILTEL" id="MOBILTEL" style="width:100px;" maxlength="10" validate="integer" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-mobiltel_spc">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'> (<cf_get_lang dictionary_id='29688.Kişisel'>)</label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='41237.Mobil Telefon'></cfsavecontent>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfinput value="" type="text" name="mobilcode_spc" id="mobilcode_spc" style="width:47px;" maxlength="7" validate="integer" message="#message#">
                            </div>
                            <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                <cfinput type="text" name="mobiltel_spc" id="mobiltel_spc" maxlength="10" validate="integer" message="#message#" style="width:100px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-expiry_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55493.Sisteme Son Giriş'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="expiry_date" id="expiry_date" maxlength="10" message="#message#" value="" validate="#validate_style#" style="width:130px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="expiry_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
   				</cf_box_elements>
                <div class="ui-form-list-btn">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58126.Devam'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='kontrol()'>
                </div> 
            </cf_box>
        </div>
</cfform>
<script type="text/javascript">
function kontrol()
{
    <cfif isdefined('xml_is_tc_number') and xml_is_tc_number eq 1>
        var tc = $("#TC_IDENTY_NO").val();
        if(tc = "" || tc.length < 11){
            alert("<cf_get_lang dictionary_id='52469.TC Kimlik Numarası 11 Hane Olmalıdır'>");
            return false;
        }
    </cfif>
	var emp_no = $('#employee_no').val();
	var get_employee_no_query = wrk_safe_query('hr_employee_no_qry','dsn',0,emp_no);
	if(get_employee_no_query.recordcount)
	{
		alert("<cf_get_lang dictionary_id='56835.Aynı Çalışan No İle Kayıt Var'>!  <cf_get_lang dictionary_id='55971.Yeni Numara Atanacaktır'>!");
		var run_query = wrk_safe_query('hr_emp_detail','dsn',0,'<cfoutput>#paper_code#</cfoutput>');
		var emp_num = parseFloat(run_query.BIGGEST_NUMBER)+ 1;
		var emp_num_join = '<cfoutput>#paper_code#</cfoutput>' + '-' +emp_num;
        $('#employee_no').val(emp_num_join);
        $('#system_paper_no_add').val(emp_num);

	}
	
	<cfif session.ep.ehesap>
        var photo = document.getElementById('photo');
        if(photo.files.length > 0){ 
            var photoSize = photo.files[0].size;
            if(photoSize > 2000000){
                alert("<cf_get_lang dictionary_id='48411.Fotoğrafınız maksimum 50KB boyutunda olmalıdır'>");
                return false;
            }
        }
		var obj =  photo.value.toUpperCase();
		var obj_ = list_len(obj,'.');
		var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
		if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='JPEG') 
		{
			alert("<cf_get_lang dictionary_id='56078.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz'>!");        
			return false;
		}
	</cfif>
	
	if ((document.getElementById('is_ip_control').checked == true) && (document.getElementById('id_address').value == ''))
	{
		alert("<cf_get_lang dictionary_id='56076.IP Adresi Girmelisiniz'>!");
		return false;
	}
	
	if ((document.getElementById('is_ip_control').checked == true) && (document.getElementById('computer_name').value == ''))
	{
		alert("<cf_get_lang dictionary_id='56077.Bilgisayar Adı Girmelisiniz'>!");
		return false;
	}
	
	if (document.getElementById('detailed').value == 1)
	{
		if (document.getElementById('salary').value != "")
		{
			if (document.getElementById('maas_startdate').value == "")
			{
				alert("<cf_get_lang dictionary_id='56126.Maaş Başlangıç Tarihi giriniz'> !");
				return false
			}
			if (document.getElementById('startdate').value == "")
			{
				alert("<cf_get_lang dictionary_id='56127.İşe Giriş Tarihi giriniz'> !");
				return false
			}
		}
		if ((document.getElementById('exp1_start').value == "") && (document.getElementById('exp1_finish').value != ""))
		{
			alert("1.<cf_get_lang dictionary_id='56128.işe giriş tarihini yazınız'> !");
			document.getElementById('exp1_start').focus();
			return false;
		}
			
		if ((document.getElementById('exp2_start').value == "") && (document.getElementById('exp2_finish').value != ""))
		{
			alert("2. <cf_get_lang dictionary_id='56128.işe giriş tarihini yazınız'> !");
			document.getElementById('exp2_start').focus();
			return false;
		}
			
		if ((document.getElementById('exp3_start').value == "") && (document.getElementById('exp3_finish').value != ""))
		{
			alert("3.<cf_get_lang dictionary_id='56128.işe giriş tarihini yazınız'> !");
			document.getElementById('exp3_start').focus();
			return false;
		}
	
		if ((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
			if (!date_check(employe_detail.startdate, employe_detail.finishdate, "<cf_get_lang dictionary_id='56129.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
				return false;
	
		if ((document.getElementById('exp1_start').value != "") && (document.getElementById('exp1_finish').value != ""))
			if (!date_check(employe_detail.exp1_start, employe_detail.exp1_finish, "1. <cf_get_lang dictionary_id='56129.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
				return false;
	
		if ((document.getElementById('exp2_start').value != "") && (document.getElementById('exp2_finish').value != ""))
			if (!date_check(employe_detail.exp2_start, employe_detail.exp2_finish, "2. <cf_get_lang dictionary_id='56129.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
				return false;
	
		if ((document.getElementById('exp3_start').value != "") && (document.getElementById('exp3_finish').value != ""))
			if (!date_check(employe_detail.exp3_start, employe_detail.exp3_finish, "3. <cf_get_lang dictionary_id='56129.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
				return false;
	}
	if ($('#employee_password').val().indexOf(" ") != -1)
	{
		alert("<cf_get_lang dictionary_id='38682.Şifre boşluk karakterini içeremez'>");
		$('#employee_password').focus();
		return false;
	}
	if(($('#employee_username').val() != "") && ($('#employee_password').val() != "") && ($('#employee_username').val() == $('#employee_password').val()))
	{
		alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz'> !");
		$('#employee_password').focus();
		return false;
	}
	if ($('#employee_password').val() != "")
	{
		<cfif get_password_style.recordcount>
			var number="0123456789";
			var lowercase = "abcdefghijklmnopqrstuvwxyz";
			var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
			
			var containsNumberCase = contains($('#employee_password').val(),number);
			var containsLowerCase = contains($('#employee_password').val(),lowercase);
			var containsUpperCase = contains($('#employee_password').val(),uppercase);
			var ozl = contains($('#employee_password').val(),ozel);
			
			<cfoutput>
				if(document.getElementById('employee_password').value.length < #get_password_style.password_length#)
				{
					alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'> ! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
					document.getElementById('employee_password').focus();				
					return false;
				}
				
				if(#get_password_style.password_number_length# > containsNumberCase)
				{
					alert("<cf_get_lang dictionary_id='30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
					document.getElementById('employee_password').focus();
					return false;
				}
				
				if(#get_password_style.password_lowercase_length# > containsLowerCase)
				{
					alert("<cf_get_lang dictionary_id='30947.Şifrede Olması Gereken Küçük Harf Sayısı'> : #get_password_style.password_lowercase_length#");
					document.getElementById('employee_password').focus();				
					return false;
				}
				
				if(#get_password_style.password_uppercase_length# > containsUpperCase)
				{
					alert("<cf_get_lang dictionary_id='30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
					document.getElementById('employee_password').focus();
					return false;
				}
				
				if(#get_password_style.password_special_length# > ozl)
				{
					alert("<cf_get_lang dictionary_id='30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
					document.getElementById('employee_password').focus();
					return false;
				}
			</cfoutput>
		</cfif>
	}
	return process_cat_control();
}
document.getElementById('employee_name').focus();

function last_control()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_dsp_employee_prerecords&employee_name=' + document.getElementById('employee_name').value + '&employee_surname=' + document.getElementById('employee_surname').value,'project','popup_dsp_employee_prerecords');
	return false;
}

	function contains(deger,validChars)						
	{
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
	}
</script>
