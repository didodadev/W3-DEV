<cfquery name="Get_Partner" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.MOBIL_CODE,
		COMPANY_PARTNER.MOBILTEL,
		COMPANY_PARTNER_DETAIL.BIRTHPLACE,
		COMPANY_PARTNER_DETAIL.BIRTHDATE,
		COMPANY_PARTNER_DETAIL.MARRIED,
		COMPANY_PARTNER_DETAIL.EDU1_FINISH,
		COMPANY_PARTNER.NUMBER_OF_CHILD,
		COMPANY_PARTNER_DETAIL.MARRIED_DATE,
		COMPANY_PARTNER.GRADUATE_YEAR,
		COMPANY_PARTNER_DETAIL.FACULTY,
		COMPANY_PARTNER.IS_SMS,
		COMPANY_PARTNER.TC_IDENTITY,
		COMPANY_PARTNER.IS_HAMSIS,
		COMPANY_PARTNER.SEX,
		COMPANY_PARTNER.RECORD_DATE,
		COMPANY_PARTNER.RECORD_MEMBER,
		COMPANY_PARTNER.UPDATE_DATE,
		COMPANY_PARTNER.UPDATE_MEMBER,
		COMPANY_PARTNER.MISSION,
		COMPANY_PARTNER.DEPARTMENT,
		COMPANY_PARTNER.TITLE
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_PARTNER_DETAIL
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY_PARTNER_DETAIL.PARTNER_ID
</cfquery>
<cfquery name="GET_FACULTY" datasource="#dsn#">
	SELECT UNIVERSITY_ID, UNIVERSITY_NAME FROM SETUP_UNIVERSITY
</cfquery>
<cfquery name="GET_PARTNER_HOBBY" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER_HOBBY.PARTNER_ID,
		COMPANY_PARTNER_HOBBY.HOBBY_ID,
		SETUP_HOBBY.HOBBY_NAME
	FROM 
		COMPANY_PARTNER_HOBBY,
		SETUP_HOBBY
	WHERE
		COMPANY_PARTNER_HOBBY.COMPANY_ID = #attributes.cpid# AND
		COMPANY_PARTNER_HOBBY.PARTNER_ID = #get_partner.partner_id# AND
		COMPANY_PARTNER_HOBBY.HOBBY_ID = SETUP_HOBBY.HOBBY_ID
</cfquery>

<cfsavecontent variable="title"><cf_get_lang no='69.Eczacı Bilgileri'>: <cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput></cfsavecontent>
  
<cf_box title="#title#">

    <cfform  method="post" name="upd_company_special" action="#request.self#?fuseaction=crm.emptypopup_upd_company_special">
        <cfoutput>
            <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)>#attributes.frame_fuseaction#</cfif>">
            <input type="hidden" name="cpid" id="cpid" value="#attributes.cpid#">
            <input type="hidden" name="partner_id" id="partner_id" value="#get_partner.partner_id#">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='71.Cep Tel'>
                        </label>
                        <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Numarası Giriniz !'></cfsavecontent>
                            <cfsavecontent variable="text"><cf_get_lang_main no='1173.Kod'></cfsavecontent>
                        <div class="col col-2 col-xs-12">
                            <cf_wrk_combo
                            name="mobil_code"
                            query_name="GET_SETUP_MOBILCAT"
                            option_name="mobilcat"
                            option_text="#text#"
                            value="#get_partner.mobil_code#"
                            option_value="mobilcat"
                            width="65">
                        </div>
                        <div class="col col-6 col-xs-12">

                            <cfinput name="mobil_num" type="text" value="#get_partner.mobiltel#" maxlength="7" message="#message#" validate="integer" style="width:102px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='77.Hobiler'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <select name="hobby" id="hobby" style="width:170px;height:75px" multiple>
                                <cfloop query="get_partner_hobby">
                                    <option value="#hobby_id#">#hobby_name#</option>
                                </cfloop>
                            </select>
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_hobby_detail&field_name=upd_company_special.hobby','small');"></span>
                            <span class="input-group-addon" onClick="ozel_kaldir('hobby');"><i class="fa fa-minus"></i></span>
                               
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang_main no='378.Doğum Yeri'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="birthplace" value="#get_partner.birthplace#" style="width:170;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">

                            <cf_get_lang_main no='1315.Doğum Tarihi'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'> !</cfsavecontent>
                                <cfinput type="text" name="birthday" value="#dateformat(get_partner.birthdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#" style="width:170;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="birthday"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='74.Medeni Hali'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="marital_status" id="marital_status" style="width:170;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif get_partner.married eq 1>selected</cfif>><cf_get_lang no='110.Bekar'></option>
                                <option value="2" <cfif get_partner.married eq 2>selected</cfif>><cf_get_lang no='109.Evli'></option>
                                <option value="3" <cfif get_partner.married eq 3>selected</cfif>><cf_get_lang no='108.Dul'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='78.Mezun Olduğu Fakülte'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="faculty" id="faculty" style="width:170;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_faculty">
                                    <option value="#university_id#,#university_name#" <cfif get_partner.faculty eq university_id>selected</cfif>>#university_name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
              
                    <div class="form-group">

                        <label class="col col-4 col-xs-12"""><cf_get_lang no='79.Mezuniyet Yılı'></label>
                        <cfset g_year = get_partner.edu1_finish>
                        <div class="col col-8 col-xs-12">
                            <select name="graduate_year" id="graduate_year" style="width:170;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop from="1920" to="#year(now())#" index="i">
                                    <option value="#i#" <cfif i eq g_year>selected</cfif>>#i#</option>
                                </cfloop>  
                            </select>
                        </div>
                    </div>
                   
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='75.Evlenme Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message1"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
                                <cfinput name="marriage_date" type="text" value="#dateformat(get_partner.married_date,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#" style="width:170;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="marriage_date"></span>
                            </div>
                        </div>
                    </div>
                   
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='76.Çocuk Sayısı'></label>
                        <div class="col col-8 col-xs-12"><input type="text" name="child" id="child" value="#get_partner.number_of_child#" style="width:170px;"></div>
                    </div>
                   
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='80.Cinsiyeti'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="sexuality" id="sexuality" style="width:170;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif get_partner.sex eq 1>selected</cfif>><cf_get_lang no='163.Bay'></option>
                                <option value="2" <cfif get_partner.sex eq 2>selected</cfif>><cf_get_lang no='164.Bayan'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='613.TC Kimlik No'></label>
                        <div class="col col-8 col-xs-12"><input type="text" name="tc_identity" id="tc_identity" value="#get_partner.tc_identity#" onkeyup="isNumber(this);" onblur='isNumber(this);' maxlength="11" style="width:170px;"></div>
                    </div>
                   
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Ünvan'></label>
                        <div class="col col-8 col-xs-12"><input  type="text" name="title" id="title" maxlength="50" value="#get_partner.title#" style="width:170px;"></div>
                    </div>
                   
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='572.HAMSIS Kullanıyor mu'> ?</label>
                        <div class="col col-8 col-xs-12"><input type="checkbox" name="is_hamsis" id="is_hamsis" <cfif get_partner.is_hamsis eq 1>checked</cfif>></div>
                    
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_get_lang_main no='71.Kayıt'>:
                    <cfif len(get_partner.record_date)>#get_emp_info(get_partner.record_member,0,1)# - #dateformat(get_partner.record_date,dateformat_style)#</cfif>&nbsp;&nbsp;&nbsp;<br/>
                    <cf_get_lang_main no='291.Son Güncelleme'>:
                    <cfif len(get_partner.update_date)>#get_emp_info(get_partner.update_member,0,1)# - #dateformat(get_partner.update_date,dateformat_style)#</cfif>
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='hepsini_sec()'>
                </div>

            </cf_box_footer>
        </cfoutput>
    </cfform>
      
  
</cf_box>
<cf_get_member_analysis action_type='MEMBER' company_id='#attributes.cpid#' partner_id='#get_partner.partner_id#' is_analysis_link='0'>

<script language="JavaScript" type="text/javascript">
function ozel_kaldir()
{
	for (i=document.upd_company_special.hobby.options.length-1;i>-1;i--)
	{
		if (document.upd_company_special.hobby.options[i].selected==true)
			document.upd_company_special.hobby.options.remove(i);
	}
}

function remove_field(field_option_name)
{
	field_option_name_value = eval('document.upd_company_special.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
			field_option_name_value.options.remove(i);
	}
}

function select_all(selected_field)
{
	var m = eval("document.upd_company_special."+selected_field+".length");
	for(i=0;i<m;i++)
		eval("document.upd_company_special."+selected_field+"["+i+"].selected=true")
}

function hepsini_sec()
{
	select_all('hobby');
	if(document.upd_company_special.tc_identity.value != "")
	{
		if(document.upd_company_special.tc_identity.value.length != 11)
		{
			alert("<cf_get_lang dictionary_id='52469.TC Kimlik Numarası 11 Hane Olmalıdır'>");
			return false;
		}
	}
}
</script>
