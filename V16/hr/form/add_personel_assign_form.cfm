<cf_xml_page_edit fuseact="hr.from_upd_personel_assign_form">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_driverlicence.cfm">
<cfquery name="get_per_req" datasource="#dsn#">
	SELECT
		PRF.PERSONEL_REQUIREMENT_ID,
		PRF.PERSONEL_REQUIREMENT_HEAD
	FROM
		PERSONEL_REQUIREMENT_FORM PRF
	WHERE
		PRF.PERSONEL_REQUIREMENT_HEAD IS NOT NULL AND 
		PRF.IS_FINISHED = 1 AND 
		PRF.PERSONEL_REQUIREMENT_ID NOT IN (SELECT PAF.PERSONEL_REQ_ID FROM PERSONEL_ASSIGN_FORM PAF WHERE IS_FINISHED = 1 AND PAF.PERSONEL_REQ_ID IS NOT NULL)
	<cfif not session.ep.ehesap>
		AND PRF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY
		PRF.PERSONEL_REQUIREMENT_ID
</cfquery>
<cfinclude template="../query/get_moneys.cfm">

<cf_catalystHeader>
<cfform name="add_form" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_personel_assign">
<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="row formContent">
			<div class="row" type="row">
				<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                	<div class="form-group" id="item-PERSONEL_REQ_ID">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56873.Personel Talebi'></label>
                        <div class="col col-8 col-xs-12">
                        	<select name="PERSONEL_REQ_ID" id="PERSONEL_REQ_ID" onchange="get_per_req();" style="width:305px;">
				                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				                <cfoutput query="get_per_req">
				                    <option value="#PERSONEL_REQUIREMENT_ID#">#PERSONEL_REQUIREMENT_ID# - #PERSONEL_REQUIREMENT_HEAD#</option>
				                </cfoutput>
				            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-personel_assign_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<cfsavecontent variable="head_message"><cf_get_lang dictionary_id='56872.Atama Formu'></cfsavecontent>
				            <cfinput type="text" name="personel_assign_head" value="#head_message#" id="personel_assign_head" required="yes" maxlength="100" style="width:456px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-our_company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'> *</label>
                        <div class="col col-8 col-xs-12">
	                        <div class="input-group">
	                        	<input type="hidden" name="our_company_id" id="our_company_id" value="" readonly>
	                            <input type="hidden" name="branch_id" id="branch_id" value="">
	            				<input type="hidden" name="department_id"  id="department_id"value="">
	                            <cfinput type="text" name="our_company" id="our_company" value="" style="width:150px;" required="yes" readonly>
	                            <span class="input-group-addon no-bg"></span>
	                            <input type="text" name="branch" id="branch" value="" style="width:150px;" readonly>
	                            <span class="input-group-addon no-bg"></span>
	                            <input type="text" name="department" id="department" value="" style="width:150px;" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_form.department_id&field_name=add_form.department&field_branch_name=add_form.branch&field_branch_id=add_form.branch_id&field_our_company=add_form.our_company&field_our_company_id=add_form.our_company_id</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-personel_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="hidden" name="related_cv_bank_id" id="related_cv_bank_id" value="">	
                            <cfif x_readonly_name_surname_info eq 1>
                                <div class="input-group">
                                    <cfinput type="text" name="personel_name" id="personel_name"  style="width:150px;" maxlength="100" required="yes">
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="personel_surname" id="personel_surname"  style="width:150px;" maxlength="100" required="yes" >
                                    <span class="input-group-addon catalyst-drawer bold btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_cv_bank&field_empapp_id=add_form.related_cv_bank_id&field_name=add_form.personel_name&field_surname=add_form.personel_surname&field_tc_identy_no=add_form.personel_tc_identy_no&field_birthdate=add_form.birth_date&field_sex=add_form.sex&field_military_status=add_form.military_status&field_military_exempt_detail=add_form.military_detail&field_training_level=add_form.training_level&field_driverlicence=add_form.driver_licence_type&field_psychotechnics=add_form.is_psychotechnics&field_functions=relative_detail_info()&field_relative_status=add_form.relative_status&field_relative_detail=add_form.relative_detail','list');" title="CV Bank"></span>
                                </div>
                             <cfelse>
                                <div class="input-group">
                                    <cfinput type="text" name="personel_name" id="personel_name" readonly="yes" style="width:150px;" maxlength="100" required="yes" >
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="personel_surname" id="personel_surname" readonly="yes" style="width:150px;" maxlength="100" required="yes">
                                    <span class="input-group-addon catalyst-drawer bold btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_cv_bank&field_empapp_id=add_form.related_cv_bank_id&field_name=add_form.personel_name&field_surname=add_form.personel_surname&field_tc_identy_no=add_form.personel_tc_identy_no&field_birthdate=add_form.birth_date&field_sex=add_form.sex&field_military_status=add_form.military_status&field_military_exempt_detail=add_form.military_detail&field_training_level=add_form.training_level&field_driverlicence=add_form.driver_licence_type&field_psychotechnics=add_form.is_psychotechnics&field_functions=relative_detail_info()&field_relative_status=add_form.relative_status&field_relative_detail=add_form.relative_detail','list');" title="CV Bank"></span>
                                </div>
                             </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-personel_tc_identy_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<cfinput type="text" name="personel_tc_identy_no"  id="personel_tc_identy_no" onKeyUp="isNumber(this);" style="width:150px;" maxlength="11" required="yes" onBlur="control_identy_no();">
            				<label id="identy_control_td" class="table_warning"></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55280.Birim ve Görev'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
                            	<input type="Hidden" name="position_cat_id" id="position_cat_id" value="">
            					<cfinput type="text" name="position_cat" id="position_cat" style="width:150px;" value="" required="yes">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_form.position_cat_id&field_cat=add_form.position_cat','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56874.Kişi Özellikleri"></cfsavecontent>
            <cf_seperator id="kisi_ozellikleri" title="#message#">
			<div id="kisi_ozellikleri">
                <div class="row" type="row">
                    <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-birth_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="birth_date" id="birth_date" style="width:150px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-PERSONEL_ATTEMPT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55309.Bu Alandaki İş Tecrübesi (Yıl)'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text"  name="PERSONEL_ATTEMPT" id="PERSONEL_ATTEMPT"  style="width:150px;" maxlength="2" onKeyUp="isNumber(this)"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-sex">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" name="sex" id="sex" value="0"> <cf_get_lang dictionary_id='58958.Kadın'></label>
                                <label><input type="radio" name="sex" id="sex" value="1" checked="checked"><cf_get_lang dictionary_id='58959.Erkek'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-military_status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56545.Askerlik Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" name="military_status" id="military_status" value="0"><cf_get_lang dictionary_id='55624.Yapmadı'></label>
                                <label><input type="radio" name="military_status" id="military_status" value="1" checked="checked"><cf_get_lang dictionary_id='55625.Yaptı'></label>
                                <label><input type="radio" name="military_status" id="military_status" value="2"><cf_get_lang dictionary_id='55626.Muaf'></label>
                                <label><input type="radio" name="military_status" id="military_status" value="3"><cf_get_lang dictionary_id='55627.Yabancı'></label>
                                <label><input type="radio" name="military_status" id="military_status" value="4"><cf_get_lang dictionary_id='55340.Tecilli'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-military_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56545.Askerlik Durumu'><cf_get_lang dictionary_id='57629.Aciklama'></label>
                            <div class="col col-8 col-xs 12">
                                <input type="text"  name="military_detail" id="military_detail"  style="width:150px;" maxlength="50"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-training_level">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55495.Eğitim Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput query="GET_EDU_LEVEL">
                                <label><input type="radio" name="training_level" id="training_level" value="#GET_EDU_LEVEL.EDU_LEVEL_ID#" <cfif currentrow eq 1>checked</cfif>> #GET_EDU_LEVEL.EDUCATION_NAME#</label>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_licence_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55334.Ehliyet'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput query="get_driverlicence">
                                    <cfif currentrow mod 5 eq 1><tr></cfif>
                                        <label><input type="checkbox" name="driver_licence_type" id="driver_licence_type" value="#LICENCECAT_ID#">#LICENCECAT#</label>
                                    <cfif currentrow mod 5 eq 0></tr></cfif>
                                </cfoutput>
                            </div>
                        </div>
                        <cfif x_show_psychotechnics_info eq 1>
                        <div class="form-group" id="item-is_psychotechnics">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55136.Psikoteknik'></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" name="is_psychotechnics" id="is_psychotechnics" value="1"> <cf_get_lang dictionary_id='57495.Evet'></label>
                                <label><input type="radio" name="is_psychotechnics" id="is_psychotechnics" value="0" checked> <cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-relative_status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55764.Aynı Depoda Çalışan Yakını Var Mı?'></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" name="relative_status" id="relative_status" value="1" onclick="relative_detail_info();"> <cf_get_lang dictionary_id='57495.Evet'></label>
                                <label><input type="radio" name="relative_status" id="relative_status" value="0" checked="checked" onclick="relative_detail_info();"> <cf_get_lang dictionary_id='57496.Hayır'></label>
                            </div>
                        </div>
                        <div class="form-group" id="relative_info" sytle="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55156.Çalışana Yakınlığı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text"  name="relative_detail" id="relative_detail" style="width:150px;" maxlength="50"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='55536.Belirli Süreli Çalışan ise'></label>
                        </div>
                        <div class="form-group" id="item-work_start">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="work_start" id="work_start" style="width:127px;" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="work_start"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_finish">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="work_finish" id="work_finish" style="width:127px;" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="work_finish"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55772.Nakil Yoluyla Atama Yapılıyorsa veya Eski Çalışanımızsa Son İşyerine Ait"></cfsavecontent>
            <cf_seperator id="nakil_" title="#message#">
            <div id="nakil_">
                <div class="row" type="row">
                    <div class="col col-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-our_company">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="old_our_company_id" id="old_our_company_id" value="">
                                    <input type="hidden" name="old_branch_id" id="old_branch_id" value="">
                                    <input type="hidden" name="old_department_id" id="old_department_id" value="">
                                    <cfinput type="text" name="old_our_company" id="old_our_company" value="" style="width:150px;">
                                    <span class="input-group-addon no-bg"></span>
                                    <input type="text" name="old_branch" id="old_branch" value="" style="width:150px;" readonly>
                                    <span class="input-group-addon no-bg"></span>
                                    <input type="text" name="old_department" id="old_department" value="" style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_form.old_department_id&field_name=add_form.old_department&field_branch_name=add_form.old_branch&field_branch_id=add_form.old_branch_id&field_our_company=add_form.old_our_company&field_our_company_id=add_form.old_our_company_id</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-old_position_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55773.Görev'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="old_position_id" id="old_position_id" value="">
                                    <input type="text"  name="old_position_name" id="old_position_name"  style="width:150px;" maxlength="200">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_form.old_position_id&field_pos_name=add_form.old_position_name&field_dep_name=add_form.old_department&field_dep_id=add_form.old_department_id&field_branch_name=add_form.old_branch&field_branch_id=add_form.old_branch_id&field_comp=add_form.old_our_company&field_comp_id=add_form.old_our_company_id&show_empty_pos=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-old_finish_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55332.Ayrılma Nedeni'></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" value="Yeni Giriş" name="old_finish_detail" id="old_finish_detail" checked="checked" onclick="if(this.checked){gizle(personel_detail_other_info);}"> <cf_get_lang dictionary_id='55164.Yeni Giriş'></label>
                                <label><input type="radio" value="İstifa" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"> <cf_get_lang dictionary_id='55508.İstifa'></label>
                                <label><input type="radio" value="Fesih" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"> <cf_get_lang dictionary_id='55509.Fesih'></label>
                                <label><input type="radio" value="Nakil" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"> <cf_get_lang dictionary_id='55510.Nakil'></label>
                                <label><input type="radio" value="Diğer" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){goster(personel_detail_other_info);}"> <cf_get_lang dictionary_id='58156.Diğer'></label>
                            </div>
                        </div>
                        <div class="form-group" id="personel_detail_other_info" style="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55513.Diğer ise Nedeni'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" value="" name="old_finish_detail" id="old_finish_detail" style="width:150px;" maxlength="75">
                            </div>
                        </div>
                        <div class="form-group" id="item-old_work_start">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></cfsavecontent>
                                    <cfinput type="text" name="old_work_start" id="old_work_start" style="width:150px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="old_work_start"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-old_work_finish">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55555.Çalışma Bitiş'></cfsavecontent>
                                    <cfinput type="text" name="old_work_finish" id="old_work_finish" style="width:150px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="old_work_finish"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-old_salary">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55171.Eski Ücret'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput name="old_salary" id="old_salary" value="" style="width:150px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <span class="input-group-addon">
                                    <select	name="old_salary_money" id="old_salary_money" style="width:150px;">
                                        <cfoutput query="get_moneys">
                                            <option <cfif session.ep.money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                        </cfoutput>
                                    </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-salary">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55774.Brüt Ücret'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55802.Brüt Ücret Girmelisiniz">!</cfsavecontent>
                                    <cfinput name="salary" id="salary" value="" style="width:150px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox" message="#message#">
                                    <span class="input-group-addon">
                                    <select	name="salary_money"	id="salary_money" style="width:150px;">
                                        <cfoutput query="get_moneys">
                                            <option <cfif session.ep.money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                        </cfoutput>
                                    </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-Ek">
                            <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id="32589.Ek"></label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="checkbox" value="Cep Tel Hattı" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55777.Cep Tel Hattı'></label>
                                <label><input type="checkbox" value="İkramiye" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55795.İkramiye'></label>
                                <label><input type="checkbox" value="Otomobil" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55783.Otomobil'></label>
                                <label><input type="checkbox" value="Prim" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55776.Prim'></label>
                                <label><input type="checkbox" value="Performans Primi" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55794.Performans Primi'></label>
                                
                                <label><input type="checkbox" value="Giysi Yardımı" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55782.Giysi Yardımı'></label>
                                <label><input type="checkbox" value="Jestiyon" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55798.Jestiyon'></label>
                                <label><input type="checkbox" value="Öğle Yemeği" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55792.Öğle Yemeği'></label>
                                <label><input type="checkbox" value="Servis" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='57656.Servis'></label>
                                <label><input type="checkbox" value="Yakacak Yardımı" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55779.Yakacak Yardımı'></label>
                                <label><input type="checkbox" value="Ticket" name="ASSIGN_PROPERTIES" id="ASSIGN_PROPERTIES"> <cf_get_lang dictionary_id='55784.Ticket'></label>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
            <cf_seperator id="gorus_" title="#getLang('hr',486)#"><!---GÖRÜŞ VE ONAY'--->
            <div id="gorus_">
                <div class="row" type="row">
                    <div class="col col-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-personel_assign_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56016.Görüş'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="personel_assign_detail" id="personel_assign_detail" style="width:456px;height:40px;" onKeyUp="CheckLen(this,500);"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55179.Atama Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
		</div>
	</div>
</div>
</cfform>
<script type="text/javascript">
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
	                                	
function kontrol()
{ 
	if(!$("#work_start").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></cfoutput>"})    
		return false;
	}
	if(!$("#work_finish").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55555.Çalışma Bitiş'></cfoutput>"})    
		return false;
	}
	if(document.getElementById('position_cat').value == '')
	{
		alertObject({message: "<cf_get_lang dictionary_id='55604.Birim ve Görev Seçmelisiniz'>!"})    
		return false;
	}
	if(!$("#personel_tc_identy_no").val().length)
	{
		alertObject({message: "<cf_get_lang dictionary_id='31325.TC Kimlik No Girmelisiniz'>!"})    
		return false;
	}
	if(!$("#our_company").val().length)
	{
		alertObject({message: "<cf_get_lang dictionary_id='55700.Şirket Seçmelisiniz'>!"})    
		return false;
	}
  	if(!$("#personel_name").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57631.Ad'></cfoutput>"})    
		return false;
	}
	if(!$("#personel_surname").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfoutput>"})    
		return false;
	}
	if(!$("#personel_assign_head").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfoutput>"})    
		return false;
	}
	if(document.getElementById('personel_assign_detail').value == '')
	{
		alert("<cf_get_lang dictionary_id='55590.Görüş Girmelisiniz'>!");
		return false;
	}
	if(document.add_form.relative_status[0].checked && document.getElementById('relative_detail').value=='')
	{
		alert("<cf_get_lang dictionary_id='55808.Yakınlık Derecesi Girmelisiniz'>!");
		return false;
	}
	
	if(process_cat_control())
	{
		if(add_form.salary != undefined) add_form.salary.value = filterNum(add_form.salary.value);
		if(add_form.old_salary != undefined) add_form.old_salary.value = filterNum(add_form.old_salary.value);
		return true;
	}
	else
		return false;
}
function get_per_req()
{
	deger_ = document.add_form.PERSONEL_REQ_ID.value;
	document.add_form.work_start.value = '';
	document.add_form.work_finish.value = '';
	if(deger_ != '')
	{
		get_req_ = wrk_query("SELECT OUR_COMPANY_ID,BRANCH_ID,DEPARTMENT_ID,POSITION_CAT_ID,FORM_TYPE,YEAR(WORK_START) AS BYIL,MONTH(WORK_START) AS BAY,DAY(WORK_START) AS BGUN,YEAR(WORK_FINISH) AS FYIL,MONTH(WORK_FINISH) AS FAY,DAY(WORK_FINISH) AS FGUN FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = " + deger_,"dsn");
		if(get_req_.recordcount)
		{
			var get_company_info = wrk_query("SELECT OC.NICK_NAME,B.BRANCH_NAME,D.DEPARTMENT_HEAD FROM OUR_COMPANY OC,BRANCH B,DEPARTMENT D WHERE OC.COMP_ID = B.COMPANY_ID AND B.BRANCH_ID = D.BRANCH_ID AND OC.COMP_ID = " + get_req_.OUR_COMPANY_ID + " AND B.BRANCH_ID = " + get_req_.BRANCH_ID + " AND D.DEPARTMENT_ID = " + get_req_.DEPARTMENT_ID ,"dsn");
			document.add_form.our_company_id.value = get_req_.OUR_COMPANY_ID;
			document.add_form.our_company.value = get_company_info.NICK_NAME;
			document.add_form.branch_id.value = get_req_.BRANCH_ID;
			document.add_form.branch.value = get_company_info.BRANCH_NAME;
			document.add_form.department_id.value = get_req_.DEPARTMENT_ID;
			document.add_form.department.value = get_company_info.DEPARTMENT_HEAD;
			var get_position_cat = wrk_query("SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = " + get_req_.POSITION_CAT_ID,"dsn");
			if(get_position_cat.recordcount)
			{
				document.add_form.position_cat_id.value = get_req_.POSITION_CAT_ID;
				document.add_form.position_cat.value = get_position_cat.POSITION_CAT;
			}
		}
		
		if(get_req_.FORM_TYPE == '6')
		{
			if(get_req_.BAY != '')
				document.add_form.work_start.value = get_req_.BGUN + '/' + get_req_.BAY + '/' + get_req_.BYIL;
			
			if(get_req_.FAY != '')
				document.add_form.work_finish.value = get_req_.FGUN + '/' + get_req_.FAY + '/' + get_req_.FYIL;
		}
	}
}
function control_identy_no()
{
	if(document.getElementById('personel_tc_identy_no').value.length == 11)
	{
		//Talebi Giren Kisinin Sadece Yekili Oldugu Departmanlardaki Kisilerin Kimlik Bilgilerini Gorebilmesi Icin Kontrol Eklendi FBS 20120607
		get_session_authority_department = "SELECT D.DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES EPB, DEPARTMENT D WHERE D.BRANCH_ID = EPB.BRANCH_ID AND EPB.POSITION_CODE = <cfoutput>#session.ep.position_code#</cfoutput> GROUP BY D.DEPARTMENT_ID";
		get_kisi_ = wrk_query("SELECT DISTINCT E.EMPLOYEE_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS E,EMPLOYEES_IDENTY EI WHERE E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND E.IS_MASTER = 1 AND EI.TC_IDENTY_NO = '" + document.getElementById('personel_tc_identy_no').value + "' AND E.DEPARTMENT_ID IN ("+ get_session_authority_department +")","dsn");
		if(get_kisi_.recordcount > 1)
		{
			var kisiler = "";
			for(var i=0;i<get_kisi_.recordcount;i++)
				var kisiler = kisiler + ' ' + get_kisi_.EMPLOYEE_NAME[i] + ' ' + get_kisi_.EMPLOYEE_SURNAME[i] + ',';

			document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik No Birden Fazla Bulundu : ' + kisiler + '</font>';
			document.getElementById('personel_name').value = "";
			document.getElementById('personel_surname').value = "";
			document.getElementById('old_branch_id').value = "";
			document.getElementById('old_branch').value = "";
			document.getElementById('old_department_id').value = "";
			document.getElementById('old_department').value = "";
			document.getElementById('old_our_company_id').value = "";
			document.getElementById('old_our_company').value = "";
			document.getElementById('old_position_name').value = "";
			document.getElementById('old_position_id').value = "";
			document.getElementById('old_salary').value = "";
			document.getElementById('old_work_start').value = "";
			document.getElementById('old_work_finish').value = "";
		}
		else if(get_kisi_.recordcount == 1)
		{
			document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik No Bulundu : ' + get_kisi_.EMPLOYEE_NAME + ' ' + get_kisi_.EMPLOYEE_SURNAME + '</font>';
			document.getElementById('personel_name').value = get_kisi_.EMPLOYEE_NAME;
			document.getElementById('personel_surname').value = get_kisi_.EMPLOYEE_SURNAME;
			get_kisi_position_ = wrk_query("SELECT TOP 1 EP.POSITION_NAME,EP.POSITION_CODE,D.DEPARTMENT_ID,B.BRANCH_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME,O.NICK_NAME,O.COMP_ID FROM EMPLOYEE_POSITIONS_HISTORY EP,DEPARTMENT D,BRANCH B,OUR_COMPANY O WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = O.COMP_ID AND EP.EMPLOYEE_ID = " + get_kisi_.EMPLOYEE_ID + " ORDER BY EP.RECORD_DATE DESC","dsn");
			if(get_kisi_position_.recordcount)
			{
				document.getElementById('old_branch_id').value = get_kisi_position_.BRANCH_ID;
				document.getElementById('old_branch').value = get_kisi_position_.BRANCH_NAME;
				document.getElementById('old_department_id').value = get_kisi_position_.DEPARTMENT_ID;
				document.getElementById('old_department').value = get_kisi_position_.DEPARTMENT_HEAD;
				document.getElementById('old_our_company_id').value = get_kisi_position_.COMP_ID;
				document.getElementById('old_our_company').value = get_kisi_position_.NICK_NAME;
				document.getElementById('old_position_name').value = get_kisi_position_.POSITION_NAME;
				document.getElementById('old_position_id').value = get_kisi_position_.POSITION_CODE;
			}
			get_kisi_ucret_ = wrk_query("SELECT TOP 1 ES.M12 M12,YEAR(EI.START_DATE) AS BYIL,MONTH(EI.START_DATE) AS BAY,DAY(EI.START_DATE) AS BGUN,YEAR(EI.FINISH_DATE) AS FYIL,MONTH(EI.FINISH_DATE) AS FAY,DAY(EI.FINISH_DATE) AS FGUN FROM EMPLOYEES_IN_OUT EI,EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND EI.EMPLOYEE_ID = " + get_kisi_.EMPLOYEE_ID + " ORDER BY EI.START_DATE DESC,ES.PERIOD_YEAR DESC","dsn");
			if(get_kisi_ucret_.recordcount)
			{
				if(get_kisi_ucret_.M12 != "") document.getElementById('old_salary').value = commaSplit(get_kisi_ucret_.M12,2);				
				if(get_kisi_ucret_.BGUN != "" && get_kisi_ucret_.BAY != "" && get_kisi_ucret_.BYIL != "") document.getElementById('old_work_start').value = get_kisi_ucret_.BGUN + '/' + get_kisi_ucret_.BAY + '/' + get_kisi_ucret_.BYIL;
				if(get_kisi_ucret_.FGUN != "" && get_kisi_ucret_.FAY != "" && get_kisi_ucret_.FYIL != "") document.getElementById('old_work_finish').value = get_kisi_ucret_.FGUN + '/' + get_kisi_ucret_.FAY + '/' + get_kisi_ucret_.FYIL;
			}
		}
		else
		{
			document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik Numarası Bulunamadı!</font>';
			document.getElementById('personel_name').value = "";
			document.getElementById('personel_surname').value = "";
			document.getElementById('old_branch_id').value = "";
			document.getElementById('old_branch').value = "";
			document.getElementById('old_department_id').value = "";
			document.getElementById('old_department').value = "";
			document.getElementById('old_our_company_id').value = "";
			document.getElementById('old_our_company').value = "";
			document.getElementById('old_position_name').value = "";
			document.getElementById('old_position_id').value = "";
			document.getElementById('old_salary').value = "";
			document.getElementById('old_work_start').value = "";
			document.getElementById('old_work_finish').value = "";
		}
	}
}
function relative_detail_info()
{
	if(document.add_form.relative_status[0].checked)
		goster(relative_info);
	else
		gizle(relative_info);
}
</script>
