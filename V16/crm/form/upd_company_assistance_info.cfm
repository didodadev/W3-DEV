<cfinclude template="../query/get_authority.cfm">
<cfinclude template="../query/get_relation.cfm">
<cfinclude template="../query/get_graduate.cfm">
<cfinclude template="../query/get_partner_position.cfm">
<cfinclude template="../query/get_university.cfm">
<cfquery name="GET_COMPANY_ASSISTANCE_INFO" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.ASSISTANCE_STATUS,
		COMPANY_PARTNER_DETAIL.MARRIED,
		COMPANY_PARTNER_DETAIL.MARRIED_DATE,
		COMPANY_PARTNER.IS_UNIVERSITY,
		COMPANY_PARTNER_DETAIL.FACULTY,
		COMPANY_PARTNER.MOBIL_CODE,
		COMPANY_PARTNER.MOBILTEL,
		COMPANY_PARTNER.PURCHASE_AUTHORITY,
		COMPANY_PARTNER.MAIL ,
		COMPANY_PARTNER.DEPOT_RELATION,
		COMPANY_PARTNER_DETAIL.BIRTHPLACE,
		COMPANY_PARTNER_DETAIL.BIRTHDATE,
		COMPANY_PARTNER.SEX,
		COMPANY_PARTNER.MISSION,
		COMPANY_PARTNER.DEPARTMENT,
		COMPANY_PARTNER.TITLE,
		COMPANY_PARTNER.RECORD_DATE,
		COMPANY_PARTNER.RECORD_MEMBER,
		COMPANY_PARTNER.UPDATE_DATE,
		COMPANY_PARTNER.UPDATE_MEMBER
	FROM
		COMPANY_PARTNER,
		COMPANY_PARTNER_DETAIL
	WHERE
		COMPANY_PARTNER.PARTNER_ID = #attributes.partner_id# AND
		COMPANY_PARTNER_DETAIL.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID 
</cfquery>
<cfquery name="GET_PARTNER_HOBBY" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER_HOBBY.HOBBY_ID,
		SETUP_HOBBY.HOBBY_NAME
	FROM
		COMPANY_PARTNER_HOBBY,
		SETUP_HOBBY 
	WHERE 
		COMPANY_PARTNER_HOBBY.PARTNER_ID = #attributes.partner_id# AND 
		SETUP_HOBBY.HOBBY_ID = COMPANY_PARTNER_HOBBY.HOBBY_ID
</cfquery>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT 
    	PARTNER_POSITION_ID, 
        PARTNER_POSITION, 
        DETAIL, 
        IS_UNIVERSITY, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PARTNER_POSITION 
    ORDER BY 
    	PARTNER_POSITION
</cfquery>
<cfquery name="GET_PARTNER_EDU_TYPE" datasource="#dsn#">
	SELECT 
    	PARTNER_POSITION_ID, 
        PARTNER_POSITION, 
        DETAIL, 
        IS_UNIVERSITY, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PARTNER_POSITION 
    WHERE 
    	PARTNER_POSITION_ID = #get_company_assistance_info.mission#
</cfquery>
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT 
    	PARTNER_DEPARTMENT_ID, 
        PARTNER_DEPARTMENT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PARTNER_DEPARTMENT 
    ORDER BY 
    	PARTNER_DEPARTMENT 
</cfquery>
<cfparam name="attributes.cpid" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box
    title="#getLang('','Yardımcı Personel Bilgileri','51607')#:#get_company_assistance_info.company_partner_name# #get_company_assistance_info.company_partner_surname#"
    popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
    add_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_add_company_assistance_info&cpid=#attributes.cpid#')">
        <cfform name="upd_company_assistance_info" action="#request.self#?fuseaction=crm.emptypopup_upd_company_assistance_info" method="post">
            <cfinput type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-mission">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="mission" id="mission" onChange="get_university();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_partner_position">       
                                    <option value="#partner_position_id#,#is_university#" <cfif get_company_assistance_info.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="name" required="yes" message="#message#" value="#get_company_assistance_info.company_partner_name#">
                        </div>
                    </div>
                    <div class="form-group" id="item-surname">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='29503.Soyad Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="surname" required="yes" message="#message1#" value="#get_company_assistance_info.company_partner_surname#">
                        </div>
                    </div>
                    <div class="form-group" id="item-mobilcat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51518.Cep Tel'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <span class="input-group-addon width">
                                    <cf_wrk_combo
                                    name="mobil_code"
                                    query_name="GET_SETUP_MOBILCAT"
                                    value="#get_company_assistance_info.mobil_code#"
                                    option_name="mobilcat"
                                    option_value="mobilcat_id"
                                    width="50"
                                    option_text="#getLang('','Kod','58585')#">
                                </span>
                                <cfsavecontent variable="message_gsm_tel"><cf_get_lang dictionary_id='51606.Geçerli Bir Telefon Kodu Giriniz'></cfsavecontent>
                                <cfinput type="text" name="mobil_num" validate="integer" maxlength="7" message="#message_gsm_tel#" value="#get_company_assistance_info.mobiltel#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-mail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="mail" maxlength="50" value="#get_company_assistance_info.mail#">
                        </div>
                    </div>
                    <div class="form-group" id="item-birthplace">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput name="birthplace" id="birthplace" value="#get_company_assistance_info.birthplace#">
                        </div>
                    </div>
                    <div class="form-group" id="item-sex">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="sex" id="sex">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_company_assistance_info.sex eq 1>selected</cfif>><cf_get_lang dictionary_id='51610.Bay'></option>
                                <option value="2" <cfif get_company_assistance_info.sex eq 2>selected</cfif>><cf_get_lang dictionary_id='51611.Bayan'></option>
                              </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-hobby">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51524.Hobiler'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <select name="hobby" id="hobby" style="width:485px; height:80px;" multiple>
                                    <cfoutput query="get_partner_hobby">
                                        <option value="#hobby_id#">#hobby_name#</option>
                                      </cfoutput>
                                </select>
                                <span class="input-group-addon">  
                                    <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_hobby_detail&field_name=add_company_assistance_info.hobby');"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                    <i class="icon-minus btnPointer show" onClick="kaldir();" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_married">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51521.Medeni Hali'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="is_married" id="is_married">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_company_assistance_info.married eq 1>selected</cfif>><cf_get_lang dictionary_id='51557.Bekar'></option>
                                <option value="2" <cfif get_company_assistance_info.married eq 2>selected</cfif>><cf_get_lang dictionary_id='51556.Evli'></option>
                                <option value="3" <cfif get_company_assistance_info.married eq 3>selected</cfif>><cf_get_lang dictionary_id='51555.Dul'></option>
                              </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-married_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message4"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='51522.Evlenme Tarihi'>!</cfsavecontent>
                                <cfinput type="text" name="married_date" value="#dateformat(get_company_assistance_info.married_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message4#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="married_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-education">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput name="is_university" id="is_university" value="#get_company_assistance_info.is_university#" type="hidden">
                            <cfinput name="faculty" id="faculty" value="#get_company_assistance_info.faculty#" type="hidden">
                            <div id="table1" <cfif GET_PARTNER_EDU_TYPE.is_university neq 0>style="display:none;"</cfif>>
                                <select name="education" id="education" onChange="education_university();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_graduate">
                                      <option value="#graduate_id#" <cfif get_company_assistance_info.faculty eq graduate_id>selected</cfif>>#graduate_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div id="table2" <cfif GET_PARTNER_EDU_TYPE.is_university neq 1>style="display:none;"</cfif>>
                                <select name="university" id="university" onChange="education_university();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_university">
                                      <option value="#university_id#" <cfif get_company_assistance_info.faculty eq university_id>selected</cfif>>#university_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-purchase_authority">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51612.Mal Alımında Etkinliği'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="purchase_authority" id="purchase_authority">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_authority">             
                                    <option value="#authority_id#" <cfif get_company_assistance_info.purchase_authority eq authority_id>selected</cfif>>#authority_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-depot_relations">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51613.Depomuz İle İlişkileri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="depot_relation" id="depot_relation" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_relation">             
                                    <option value="#partner_relation_id#" <cfif get_company_assistance_info.depot_relation eq partner_relation_id>selected</cfif>>#partner_relation#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-birthdate">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message3"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi'>!</cfsavecontent>
                                <cfinput type="text" name="birthdate" value="#dateformat(get_company_assistance_info.birthdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message3#">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="birthdate">
                                </span>
                            </div>
                            
                        </div>
                    </div>
                    <div class="form-group" id="item-title">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="title" id="title" maxlength="50" value="#get_company_assistance_info.title#">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_company_assistance_info" record_emp="RECORD_MEMBER" update_emp="RECORD_MEMBER" update_mamber="RECORD_MEMBER">
                <cf_workcube_buttons is_upd='1' is_delete=0 add_function='hepsini_sec()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
function hepsini_sec()
{	
	x = document.upd_company_assistance_info.mission.selectedIndex;
	if(document.upd_company_assistance_info.mission[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary='30717.Yardımcı Pozisyonu Şeçmelisiniz'>!");
		return false;
	}
	select_all('hobby'); 
	return true;
}

function select_all(selected_field)
{
	var m = eval("document.upd_company_assistance_info."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.upd_company_assistance_info."+selected_field+"["+i+"].selected=true");
	}
}

function kaldir()
{
	for (i=document.upd_company_assistance_info.hobby.options.length-1;i>-1;i--)
	{
		if (document.upd_company_assistance_info.hobby.options[i].selected==true)
		{
			document.upd_company_assistance_info.hobby.options.remove(i);
		}	
	}
}

function get_university()
{
	university_value = document.upd_company_assistance_info.mission.value.split(',');
	graduate_type = university_value[1];
	if (graduate_type == 1)
	{ 
		gizle(table1);
		goster(table2);
		document.upd_company_assistance_info.is_university.value = 1;
	}
	else
	{
		gizle(table2);
		goster(table1);
		document.upd_company_assistance_info.is_university.value =0;
	}
}

function education_university()
{
	if(document.upd_company_assistance_info.is_university.value == 1)
	{
		y = document.upd_company_assistance_info.university.selectedIndex;
		document.upd_company_assistance_info.faculty.value = document.upd_company_assistance_info.university[y].value;
	}
	else
	{
		z =  document.upd_company_assistance_info.education.selectedIndex;
		document.upd_company_assistance_info.faculty.value = document.upd_company_assistance_info.education[z].value;
	}
}
</script>
