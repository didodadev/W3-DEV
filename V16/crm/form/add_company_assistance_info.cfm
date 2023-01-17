<cfinclude template="../query/get_authority.cfm">
<cfinclude template="../query/get_relation.cfm">
<cfinclude template="../query/get_graduate.cfm">
<cfinclude template="../query/get_partner_position.cfm">
<cfinclude template="../query/get_university.cfm">
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT 
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Yardımcı Personel Bilgileri','51607')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_company_assistance_info" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_assistance_info">
          <input name="company_id" id="company_id" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
          <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
          <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-asistance_status">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="asistance_status" id="asistance_status" onChange="get_university();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_partner_position">       
                                    <option value="#partner_position_id#,#is_university#">#partner_position#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="name" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-surname">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='29503.Soyad Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="surname" required="yes" message="#message1#">
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
                                    option_name="mobilcat"
                                    option_value="mobilcat_id"
                                    width="50"
                                    option_text="#getLang('','Kod','58585')#">
                                </span>
                                <cfsavecontent variable="message_gsm_tel"><cf_get_lang dictionary_id='51606.Geçerli Bir Telefon Kodu Giriniz'></cfsavecontent>
                                <cfinput type="text" name="mobil_num" validate="integer" maxlength="7" message="#message_gsm_tel#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-mail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="mail" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-birthplace">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput name="birthplace" id="birthplace">
                        </div>
                    </div>
                    <div class="form-group" id="item-sex">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="sex" id="sex" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='51610.Bay'></option>
                                <option value="2"><cf_get_lang dictionary_id='51611.Bayan'></option>
                              </select>
                        </div>
                    </div>
                     <div class="form-group" id="item-hobby">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51524.Hobiler'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <select name="hobby" id="hobby" style="width:485px; height:80px;" multiple></select>
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
                                <option value="1"><cf_get_lang dictionary_id='51557.Bekar'></option>
                                <option value="2"><cf_get_lang dictionary_id='51556.Evli'></option>
                                <option value="3"><cf_get_lang dictionary_id='51555.Dul'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-married_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message4"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='51522.Evlenme Tarihi'>!</cfsavecontent>
                                <cfinput type="text" name="married_date" value="" maxlength="10" validate="#validate_style#" message="#message4#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="married_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-education">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input name="is_university" id="is_university" value="" type="hidden">
                            <input name="faculty" id="faculty" value="" type="hidden">
                            <div id="table1">
                                <select name="education" id="education"  onChange="education_university();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_graduate">
                                        <option value="#graduate_id#">#graduate_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div id="table2" style="display:none;">
                                <select name="university" id="university" style="width:150px;" onChange="education_university();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_university">
                                        <option value="#university_id#">#university_name#</option>
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
                                    <option value="#authority_id#">#authority_name#</option>
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
                                    <option value="#partner_relation_id#">#partner_relation#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-birthdate">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message3"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi'>!</cfsavecontent>
                                <cfinput type="text" name="birthdate" value="" maxlength="10" validate="#validate_style#" message="#message3#">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="birthdate">
                                </span>
                            </div>
                            
                        </div>
                    </div>
                    <div class="form-group" id="item-title">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input  type="text" name="title" id="title" maxlength="50">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='hepsini_sec()'></cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script language="JavaScript1.2">
	function hepsini_sec()
	{	
		x = document.add_company_assistance_info.asistance_status.selectedIndex;
		if (document.add_company_assistance_info.asistance_status[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='30717.Yardımcı Pozisyonu Şeçmelisiniz'>!");
			return false;
		}
			select_all('hobby'); 
			return true;
	}
	
	function select_all(selected_field)
	{
		var m = eval("document.add_company_assistance_info."+selected_field+".length");
		for(i=0;i<m;i++)
		{
			eval("document.add_company_assistance_info."+selected_field+"["+i+"].selected=true");
		}
	}
			
	function kaldir()
	{
		for (i=document.add_company_assistance_info.hobby.options.length-1;i>-1;i--)
		{
			if (document.add_company_assistance_info.hobby.options[i].selected==true)
			{
				document.add_company_assistance_info.hobby.options.remove(i);
			}	
		}
			}
			
	function get_university()
		{
			university_value = document.add_company_assistance_info.asistance_status.value.split(',');
			graduate_type = university_value[1];
			if (graduate_type == 1)
			{ 
				gizle(table1);
				goster(table2);
				document.add_company_assistance_info.is_university.value = 1;
			}
			else
			{
				gizle(table2);
				goster(table1);
				document.add_company_assistance_info.is_university.value = 0;

			}
		}
	
	function education_university()
		{
			if(document.add_company_assistance_info.is_university.value == 1)
			{	y = document.add_company_assistance_info.university.selectedIndex;
				document.add_company_assistance_info.faculty.value = document.add_company_assistance_info.university[y].value;
			}
			else
			{   z =  document.add_company_assistance_info.education.selectedIndex;
				document.add_company_assistance_info.faculty.value = document.add_company_assistance_info.education[z].value;
			}
		}
</script>
