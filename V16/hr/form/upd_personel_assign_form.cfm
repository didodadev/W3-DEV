<cf_xml_page_edit fuseact="hr.from_upd_personel_assign_form">
<cfquery name="get_per_req" datasource="#dsn#">
	SELECT 
    	PAF.*, 
        EA.WORK_STARTED, 
        EA.WORK_FINISHED ,
        EA.CV_STAGE
  	FROM 
    	PERSONEL_ASSIGN_FORM PAF 
        LEFT JOIN EMPLOYEES_APP EA ON PAF.RELATED_CV_BANK_ID = EA.EMPAPP_ID 
  	WHERE 
    	PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_assign_id#">
</cfquery>
<cfquery name="get_req" datasource="#dsn#">
	SELECT
		PRF.PERSONEL_REQUIREMENT_ID,
		PRF.PERSONEL_REQUIREMENT_HEAD
	FROM
		PERSONEL_REQUIREMENT_FORM PRF
	WHERE
		PRF.PERSONEL_REQUIREMENT_HEAD IS NOT NULL
		AND PRF.IS_FINISHED = 1
		AND PRF.PERSONEL_REQUIREMENT_ID NOT IN (SELECT PAF.PERSONEL_REQ_ID FROM PERSONEL_ASSIGN_FORM PAF WHERE IS_FINISHED = 1 AND PAF.PERSONEL_REQ_ID IS NOT NULL)
		<cfif not session.ep.ehesap>
			AND PRF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		PRF.PERSONEL_REQUIREMENT_ID
</cfquery>
<cfif Len(get_per_req.personel_req_id)>
	<cfquery name="get_relation_requirement" datasource="#dsn#">
		SELECT PERSONEL_REQUIREMENT_ID,PERSONEL_REQUIREMENT_HEAD FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.personel_req_id#"> ORDER BY PERSONEL_REQUIREMENT_ID
	</cfquery>
</cfif>
<cfif not get_per_req.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../query/get_edu_level.cfm">
	<cfinclude template="../query/get_driverlicence.cfm">
	<cfif len(get_per_req.our_company_id) and len(get_per_req.branch_id) and len(get_per_req.department_id)>
		<cfquery name="get_department_info" datasource="#dsn#">
			SELECT 
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME,
				DEPARTMENT.DEPARTMENT_HEAD
			FROM 
				OUR_COMPANY,
				BRANCH,
				DEPARTMENT
			WHERE 
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
				OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.our_company_id#"> AND
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.branch_id#"> AND
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.department_id#">
		</cfquery>
	</cfif>
	<cfif len(get_per_req.old_our_company_id) and len(get_per_req.old_branch_id) and len(get_per_req.old_department_id)>
		<cfquery name="get_old_department_info" datasource="#dsn#">
			SELECT 
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME,
				DEPARTMENT.DEPARTMENT_HEAD
			FROM 
				OUR_COMPANY,
				BRANCH,
				DEPARTMENT
			WHERE 
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
				OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_our_company_id#"> AND
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_branch_id#"> AND
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_department_id#">
		</cfquery>
	</cfif>

	<cfset app_position = "">
	<cfif len(get_per_req.old_position_id)>
		<cfquery name="get_position_name" datasource="#dsn#">
			SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_position_id#">
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
	
	<cfset Detail_ = "">
	<cfif ListLen(x_show_warning_process)>
		<cfquery name="Get_Old_Assign_Control" datasource="#dsn#">
			SELECT
				PERSONEL_ASSIGN_ID,
				UPDATE_DATE,
				ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,
				PERSONEL_ASSIGN_DETAIL
			FROM
				PERSONEL_ASSIGN_FORM
			WHERE
				PERSONEL_ASSIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.personel_assign_id#"> AND
				PER_ASSIGN_STAGE IN (#x_show_warning_process#) AND 
				PERSONEL_TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_per_req.personel_tc_identy_no#">
		</cfquery>
		<cfif Get_Old_Assign_Control.RecordCount>
			<cfset Detail_ = "İlgili Kişinin Ataması #DateFormat(Get_Old_Assign_Control.UPDATE_DATE,dateformat_style)# Tarihinde #Get_Emp_Info(Get_Old_Assign_Control.Update_Emp,0,0)# Tarafından Reddedilmiştir! <br/>Gerekçe : #Get_Old_Assign_Control.Personel_Assign_Detail#">
		</cfif>
	</cfif>
	
    
    <!--- Sayfa ana kısım  --->
    <cf_catalystHeader>
	<!---Geniş alan: içerik---> 
        <cfform name="add_form" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_personel_assign">
            <input type="hidden" name="per_assign_id" id="per_assign_id" value="<cfoutput>#attributes.per_assign_id#</cfoutput>">
                <div class="col col-9 col-md-9 col-sm-12 col-xs-12">
					<cf_box>
						<cfif x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
							<!--- Islem Detayi, Yetkililer Disindaki Kullanicilarda Display Olarak Goruntulensin, Kaydeden Kisi Display Olarak Gormesin --->
							<cfinclude template="../display/dsp_personel_assign_form.cfm">
						<cfelse>
							<cf_box_elements>
								<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
									<div class="form-group" id="item-PERSONEL_REQ_ID">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56873.Personel Talebi'></label>
										<div class="col col-8 col-xs-12">
											<select name="PERSONEL_REQ_ID" id="PERSONEL_REQ_ID" onchange="get_per_req();" style="width:305px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_req">
													<option value="#PERSONEL_REQUIREMENT_ID#" <cfif GET_PER_REQ.PERSONEL_REQ_ID eq get_req.PERSONEL_REQUIREMENT_ID>selected</cfif>>#PERSONEL_REQUIREMENT_ID# - #PERSONEL_REQUIREMENT_HEAD#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-personel_assign_head">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
										<div class="col col-8 col-xs-12">
											<cfinput type="text" name="personel_assign_head" id="personel_assign_head" value="#GET_PER_REQ.personel_assign_head#" required="yes" maxlength="100" style="width:456px;">
										</div>
									</div>
									<div class="form-group" id="item-our_company">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'>*</label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<cfoutput>
													<input type="hidden" name="our_company_id" id="our_company_id" value="#get_per_req.our_company_id#" readonly>
													<input type="hidden" name="branch_id" id="branch_id" value="#get_per_req.branch_id#">
													<input type="hidden" name="department_id" id="department_id" value="#get_per_req.department_id#">
													
													<input type="text" name="our_company" id="our_company" value="<cfif isDefined('get_department_info')>#get_department_info.nick_name#</cfif>" style="width:150px;" readonly>
													<span class="input-group-addon no-bg"></span>
													<input type="text" name="branch" id="branch" value="<cfif isDefined('get_department_info')>#get_department_info.branch_name#</cfif>" style="width:150px;" readonly>
													<span class="input-group-addon no-bg"></span>
													<input type="text" name="department" id="department" value="<cfif isDefined('get_department_info')>#get_department_info.department_head#</cfif>" style="width:150px;" readonly>
												</cfoutput>
												<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_departments&field_id=add_form.department_id&field_name=add_form.department&field_branch_name=add_form.branch&field_branch_id=add_form.branch_id&field_our_company=add_form.our_company&field_our_company_id=add_form.our_company_id');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-personel_name">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'> *</label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<cfinput type="hidden" name="related_cv_bank_id" id="related_cv_bank_id" value="#get_per_req.related_cv_bank_id#">	
												<cfif x_readonly_name_surname_info eq 1>
													<cfinput type="text"  name="personel_name" id="personel_name" value="#GET_PER_REQ.personel_name#" style="width:150px;" maxlength="100" required="yes">
													<span class="input-group-addon no-bg"></span>	
													<cfinput type="text"  name="personel_surname" id="personel_surname" value="#GET_PER_REQ.personel_surname#"  style="width:150px;" maxlength="100" required="yes">
												<cfelse>
													<cfinput type="text"  name="personel_name" id="personel_name" value="#GET_PER_REQ.personel_name#" style="width:150px;" maxlength="100" required="yes" readonly="yes">
													<span class="input-group-addon no-bg"></span>	
													<cfinput type="text"  name="personel_surname" id="personel_surname" value="#GET_PER_REQ.personel_surname#"  style="width:150px;" maxlength="100" required="yes" readonly="yes">
												</cfif>
												<span class="input-group-addon catalyst-drawer btnPointer" title="CV Bank" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_cv_bank&field_empapp_id=add_form.related_cv_bank_id&field_name=add_form.personel_name&field_surname=add_form.personel_surname&field_tc_identy_no=add_form.personel_tc_identy_no&field_birthdate=add_form.birth_date&field_sex=add_form.sex&field_military_status=add_form.military_status&field_military_exempt_detail=add_form.military_detail&field_training_level=add_form.training_level&field_driverlicence=add_form.driver_licence_type&field_psychotechnics=add_form.is_psychotechnics&field_functions=relative_detail_info()&field_relative_status=add_form.relative_status&field_relative_detail=add_form.relative_detail&keyword='+document.add_form.personel_tc_identy_no.value,'list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-personel_tc_identy_no">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</label>
										<div class="col col-8 col-xs-12">
											<cfinput type="text"  name="personel_tc_identy_no" id="personel_tc_identy_no" onKeyUp="isNumber(this);" value="#GET_PER_REQ.personel_tc_identy_no#"  style="width:150px;" maxlength="11" required="yes" message="TC Kimlik No Girmelisiniz!" onBlur="control_identy_no();">
											<label id="identy_control_td" class="table_warning"></label>
										</div>
									</div>
									<div class="form-group" id="item-position_cat">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55280.Birim ve Görev'> *</label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="Hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#GET_PER_REQ.POSITION_CAT_ID#</cfoutput>">
												<cfinput type="text" name="position_cat" id="position_cat" style="width:150px;" value="#position_cat#" required="yes" message="Birim ve Görev Seçmelisiniz!">
												<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_form.position_cat_id&field_cat=add_form.position_cat');"></span>
											</div>
										</div>
									</div>
									<cfif ListLen(x_show_warning_process)>
										<tr>
											<td>&nbsp;</td>
											<td><label id="process_detail_control_td" class="table_warning"><cfoutput>#Detail_#</cfoutput></label></td>
										</tr>
									</cfif>
								</div>
							</cf_box_elements>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="56874.Kişi Özellikleri"></cfsavecontent>
                            <cf_seperator id="kisi_ozellikleri" title="#message#">
                            <div id="kisi_ozellikleri">
								<cf_box_elements>
	                                <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
	                                    <div class="form-group" id="item-birth_date">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <div class="input-group">
	                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
													<cfif len(GET_PER_REQ.birth_date)>
														<cfinput type="text" name="birth_date" id="birth_date" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(GET_PER_REQ.birth_date,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="birth_date" id="birth_date" style="width:150px;" validate="#validate_style#" message="#message#" value="">
													</cfif>
	                                                <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
	                                            </div>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-PERSONEL_ATTEMPT">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55309.Bu Alandaki İş Tecrübesi (Yıl)'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <input type="text"  name="PERSONEL_ATTEMPT" id="PERSONEL_ATTEMPT" value="<cfoutput>#GET_PER_REQ.PERSONEL_ATTEMPT#</cfoutput>"  style="width:150px;" maxlength="50"/>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-sex">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <label><input type="radio" name="sex" id="sex" value="0" <cfif get_per_req.sex eq 0>checked</cfif>> <cf_get_lang dictionary_id='58958.Kadın'></label>
	                                            <label><input type="radio" name="sex" id="sex" value="1" <cfif get_per_req.sex eq 1>checked</cfif>> <cf_get_lang dictionary_id='58959.Erkek'></label>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-military_status">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56545.Askerlik Durumu'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <label><input type="radio" name="military_status" id="military_status" value="0" <cfif get_per_req.military_status eq 0>checked</cfif>><cf_get_lang dictionary_id='55624.Yapmadı'></label>
	                                            <label><input type="radio" name="military_status" id="military_status" value="1" <cfif get_per_req.military_status eq 1>checked</cfif>><cf_get_lang dictionary_id='55625.Yaptı'></label>
	                                            <label><input type="radio" name="military_status" id="military_status" value="2" <cfif get_per_req.military_status eq 2>checked</cfif>><cf_get_lang dictionary_id='55626.Muaf'></label>
	                                            <label><input type="radio" name="military_status" id="military_status" value="3" <cfif get_per_req.military_status eq 3>checked</cfif>><cf_get_lang dictionary_id='55627.Yabancı'></label>
	                                            <label><input type="radio" name="military_status" id="military_status" value="4" <cfif get_per_req.military_status eq 4>checked</cfif>><cf_get_lang dictionary_id='55340.Tecilli'></label>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-military_detail">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56545.Askerlik Durumu'><cf_get_lang dictionary_id='57629.Aciklama'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <input type="text"  name="military_detail" id="military_detail" value="<cfoutput>#get_per_req.military_detail#</cfoutput>" style="width:150px;" maxlength="50"/>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-training_level">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55495.Eğitim Durumu'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <cfoutput query="GET_EDU_LEVEL">
	                                                <label><input type="radio" name="training_level" id="training_level" value="#GET_EDU_LEVEL.EDU_LEVEL_ID#" <cfif EDU_LEVEL_ID eq GET_PER_REQ.TRAINING_LEVEL>checked</cfif>> #GET_EDU_LEVEL.EDUCATION_NAME#</label>
	                                            </cfoutput>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-driver_licence_type">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55334.Ehliyet'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <cfoutput query="get_driverlicence">
	                                                <cfif currentrow mod 5 eq 1><tr></cfif>
	                                                    <label><input type="checkbox" name="driver_licence_type" id="driver_licence_type" value="#licencecat_id#" <cfif len(get_per_req.licencecat_id) and listfindnocase(get_per_req.licencecat_id,licencecat_id)>checked</cfif>>#licencecat#</label>
	                                                <cfif currentrow mod 5 eq 0></tr></cfif>
	                                            </cfoutput>
	                                        </div>
	                                    </div>
	                                    <cfif x_show_psychotechnics_info eq 1>
	                                    <div class="form-group" id="item-is_psychotechnics">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55136.Psikoteknik'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <label><input type="radio" name="is_psychotechnics" id="is_psychotechnics" value="1" <cfif get_per_req.is_psychotechnics eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'></label>
	                                            <label><input type="radio" name="is_psychotechnics" id="is_psychotechnics" value="0" <cfif get_per_req.is_psychotechnics eq 0>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'></label>
	                                        </div>
	                                    </div>
	                                    </cfif>
	                                    <div class="form-group" id="item-relative_status">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55764.Aynı Depoda Çalışan Yakını Var Mı?'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <label><input type="radio" name="relative_status" id="relative_status" value="1" <cfif get_per_req.relative_status eq 1>checked</cfif> onclick="relative_detail_info();"> <cf_get_lang dictionary_id='57495.Evet'></label>
	                                            <label><input type="radio" name="relative_status" id="relative_status" value="0" <cfif get_per_req.relative_status eq 0>checked</cfif> onclick="relative_detail_info();"> <cf_get_lang dictionary_id='57496.Hayır'></label>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="relative_info" style="display:none;">
	                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55156.Çalışana Yakınlığı'></label>
	                                        <div class="col col-8 col-xs-12">
	                                            <input type="text"  name="relative_detail" id="relative_detail" value="<cfoutput>#get_per_req.relative_detail#</cfoutput>" style="width:150px;" maxlength="50"/>
	                                        </div>
	                                    </div>
	                                    <div class="form-group" id="item-">
			                                <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='55536.Belirli Süreli Çalışan ise'></label>
			                            </div>
			                            <div class="form-group" id="item-work_start">
			                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></label>
			                                <div class="col col-8 col-xs-12">
				                                <div class="input-group">
	                                                <cfif len(GET_PER_REQ.work_start)>
	                                                    <cfinput type="text" name="work_start" id="work_start" style="width:150px;" validate="#validate_style#" value="#dateformat(GET_PER_REQ.work_start,dateformat_style)#">
	                                                <cfelse>
	                                                    <cfinput type="text" name="work_start" id="work_start" style="width:150px;" validate="#validate_style#" value="">
	                                                </cfif>	
	                                                <span class="input-group-addon"><cf_wrk_date_image date_field="work_start"></span>
			                                    </div>
			                                </div>
			                            </div>
			                            <div class="form-group" id="item-work_finish">
			                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></label>
			                                <div class="col col-8 col-xs-12">
				                                <div class="input-group">
	                                                <cfif len(GET_PER_REQ.work_finish)>
	                                                    <cfinput type="text" name="work_finish" id="work_finish" style="width:150px;" validate="#validate_style#" value="#dateformat(GET_PER_REQ.work_finish,dateformat_style)#">
	                                                <cfelse>
	                                                    <cfinput type="text" name="work_finish" id="work_finish" style="width:150px;" validate="#validate_style#" value="">
	                                                </cfif>
	                                                <span class="input-group-addon"><cf_wrk_date_image date_field="work_finish"></span>
			                                    </div>
			                                </div>
			                            </div>
	                                </div>
	                            </cf_box_elements>
							</div>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="55772.Nakil Yoluyla Atama Yapılıyorsa veya Eski Çalışanımızsa Son İşyerine Ait"></cfsavecontent>
                            <cf_seperator id="nakil" title="#message#">
                            <div id="nakil">
								<cf_box_elements>
									<div class="col col-6 col-xs-12" type="column" index="3" sort="true">
										<div class="form-group" id="item-our_company">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfoutput>
													<input type="hidden" name="old_our_company_id" id="old_our_company_id" value="#get_per_req.old_our_company_id#">
													<input type="hidden" name="old_branch_id" id="old_branch_id" value="#get_per_req.old_branch_id#">
													<input type="hidden" name="old_department_id" id="old_department_id" value="#get_per_req.old_department_id#">
													<input type="text" name="old_our_company" id="old_our_company" value="<cfif isDefined('get_old_department_info')>#get_old_department_info.nick_name#</cfif>" style="width:150px;" readonly>
													<span class="input-group-addon no-bg"></span>
													<input type="text" name="old_branch" id="old_branch" value="<cfif isDefined('get_old_department_info')>#get_old_department_info.branch_name#</cfif>" style="width:150px;" readonly>
													<span class="input-group-addon no-bg"></span>
													<input type="text" name="old_department" id="old_department" value="<cfif isDefined('get_old_department_info')>#get_old_department_info.department_head#</cfif>" style="width:150px;" readonly>
													<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_departments&field_id=add_form.old_department_id&field_name=add_form.old_department&field_branch_name=add_form.old_branch&field_branch_id=add_form.old_branch_id&field_our_company=add_form.old_our_company&field_our_company_id=add_form.old_our_company_id');"></span>
													</cfoutput>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-old_position_name">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55773.Görev'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<input type="Hidden" name="old_position_id" id="old_position_id" value="<cfoutput>#GET_PER_REQ.old_position_id#</cfoutput>">
													<input type="text"  name="old_position_name" id="old_position_name" value="<cfoutput>#GET_PER_REQ.old_position_name#</cfoutput>" style="width:150px;" maxlength="200">
													<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_form.old_position_id&field_pos_name=add_form.old_position_name&field_dep_name=add_form.old_department&field_dep_id=add_form.old_department_id&field_branch_name=add_form.old_branch&field_branch_id=add_form.old_branch_id&field_comp=add_form.old_our_company&field_comp_id=add_form.old_our_company_id&show_empty_pos=1');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-old_finish_detail">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55332.Ayrılma Nedeni'></label>
											<div class="col col-8 col-xs-12">
												<label><input type="radio" value="Yeni Giriş" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}" <cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Yeni Giriş')>checked</cfif>> <cf_get_lang no='79.Yeni Giriş'></label>
												<label><input type="radio" value="İstifa" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}" <cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'İstifa')>checked</cfif>> <cf_get_lang no='423.İstifa'></label>
												<label><input type="radio" value="Fesih" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}" <cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Fesih')>checked</cfif>> <cf_get_lang no='424.Fesih'></label>
												<label><input type="radio" value="Nakil" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}" <cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Nakil')>checked</cfif>> <cf_get_lang no='425.Nakil'></label>
												<label><input type="radio" value="Diğer" name="old_finish_detail" id="old_finish_detail" onclick="if(this.checked){goster(personel_detail_other_info);}" <cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer')>checked</cfif>> <cf_get_lang_main no='744.Diğer'></label>
											</div>
										</div>
										<div class="form-group" id="personel_detail_other_info" style="display:none;">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55513.Diğer ise Nedeni'></label>
											<div class="col col-8 col-xs-12">
												<input type="text"  name="old_finish_detail" id="old_finish_detail" value="<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer') and listlen(get_per_req.old_finish_detail) eq 2><cfoutput>#listgetat(get_per_req.old_finish_detail,2)#</cfoutput></cfif>" style="width:150px;" maxlength="75">
											</div>
										</div>
										<div class="form-group" id="item-old_work_start">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></cfsavecontent>
													<cfif len(GET_PER_REQ.old_work_start)>
														<cfinput type="text" name="old_work_start" id="old_work_start" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(GET_PER_REQ.old_work_start,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="old_work_start" id="old_work_start" style="width:150px;" validate="#validate_style#" message="#message#" value="">
													</cfif>	
													<span class="input-group-addon"><cf_wrk_date_image date_field="old_work_start"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-old_work_finish">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55555.Çalışma Bitiş'></cfsavecontent>
													<cfif len(GET_PER_REQ.old_work_finish)>
														<cfinput type="text" name="old_work_finish" id="old_work_finish" style="width:150px;" validate="#validate_style#" message="#message#" value="#dateformat(GET_PER_REQ.old_work_finish,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="old_work_finish" id="old_work_finish" style="width:150px;" validate="#validate_style#" message="#message#" value="">
													</cfif>	
													<span class="input-group-addon"><cf_wrk_date_image date_field="old_work_finish"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-old_salary">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55171.Eski Ücret'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfinput name="old_salary" id="old_salary" value="#tlformat(GET_PER_REQ.old_salary)#" style="width:150px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
													<span class="input-group-addon width">
													<select	name="old_salary_money" id="old_salary_money" style="width:150px;">
														<cfoutput query="get_moneys">
															<option <cfif GET_PER_REQ.old_salary_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
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
													<cfinput name="salary" id="salary" value="#tlformat(GET_PER_REQ.salary)#" style="width:150px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox" required="yes" message="Brüt Ücret Girmelisiniz!">
													<span class="input-group-addon width">
													<select	name="salary_money"	id="salary_money" style="width:150px;">
														<cfoutput query="get_moneys">
															<option <cfif GET_PER_REQ.salary_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
														</cfoutput>
													</select>
													</span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-Ek">
											<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id="32589.Ek"></label>
											<div class="col col-8 col-xs-12">
												<cfset Assign_Property_List = "#getLang('','Cep Tel Hattı',55777)#,#getLang('','İkramiye',55795)#,#getLang('','Otomobil',55783)#,#getLang('','Prim',55776)#,#getLang('','Performans Primi',55794)#,#getLang('','Giysi Yardımı',55782)#,#getLang('','Jestiyon',55798)#,#getLang('','Öğle Yemeği',55792)#,#getLang('','Servis',57656)#,#getLang('','Yakacak Yardımı',55779)#,#getLang('','Ticket',55784)#">
												<cfloop list="#Assign_Property_List#" index="apl">
													<label><cfoutput><input type="checkbox" value="#apl#" name="assign_properties" id="assign_properties" <cfif listlen(get_per_req.assign_properties) and listfindnocase(get_per_req.assign_properties,apl)>checked</cfif>>#apl#</cfoutput></label>
													<cfif ListFind(Assign_Property_List,apl) eq 5></label></cfif>
												</cfloop>
											</div>
										</div>
									</div>
								</cf_box_elements>
							</div>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="55571.Görüş ve Onay"></cfsavecontent>
                            <cf_seperator id="gorus_" title="#message#">
                            <div id="gorus_">
								<cf_box_elements>
									<div class="col col-6 col-xs-12" type="column" index="4" sort="true">
										<div class="form-group" id="item-personel_assign_detail">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56016.Görüş'></label>
											<div class="col col-8 col-xs-12">
												<textarea name="personel_assign_detail" id="personel_assign_detail" style="width:505px;height:40px;" onKeyUp="CheckLen(this,500);"><cfoutput>#GET_PER_REQ.personel_assign_detail#</cfoutput></textarea>
											</div>
										</div>
										<div class="form-group" id="item-process_cat">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55179.Atama Durumu'></label>
											<div class="col col-8 col-xs-12">
												<cf_workcube_process is_upd='0' select_value='#get_per_req.per_assign_stage#' process_cat_width='150' is_detail='1'>
											</div>
										</div>
									</div>
								</cf_box_elements>
							</div>
							<cf_box_footer>
								<cf_record_info query_name="get_per_req">
								<cfif len(get_per_req.is_finished) and not ListFind(x_detail_change_personel,session.ep.userid)>
									<font color="red"><cfif get_per_req.is_finished eq 1><cf_get_lang dictionary_id='55182.Talebin Süreci Tamamlanmıştır'><cfelse><cf_get_lang dictionary_id='55186.Talep Reddedilmiştir'></cfif></font>
								<cfelse>
									<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_personel_assign_form&per_assign_id=#attributes.per_assign_id#&cat=#get_per_req.per_assign_stage#&head=#GET_PER_REQ.PERSONEL_assign_HEAD#' add_function='kontrol()'>
								</cfif>
							</cf_box_footer>
						</cfif>
                    </cf_box>
				</div>
                <div class="col col-3 col-md-3 col-sm-12 col-xs-12">
					<cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='PER_ASSIGN_ID' action_id='#attributes.per_assign_id#' style="1" design_id="1">
					<cf_get_workcube_note action_section='per_assign_id' action_id='#attributes.per_assign_id#' style='1' design_id="1">
                </div>
            </div>
        </cfform>
       
    
</cfif>

<script language="JavaScript">
function get_per_req()
{
	deger_ = document.getElementById('PERSONEL_REQ_ID').value;
	document.getElementById('work_start').value = '';
	document.getElementById('work_finish').value = '';
	if(deger_ != '')
		{
		get_req_ = wrk_query("SELECT FORM_TYPE,YEAR(WORK_START) AS BYIL,MONTH(WORK_START) AS BAY,DAY(WORK_START) AS BGUN,YEAR(WORK_FINISH) AS FYIL,MONTH(WORK_FINISH) AS FAY,DAY(WORK_FINISH) AS FGUN FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = " + deger_,"dsn");
		if(get_req_.FORM_TYPE == '6')
			{
				if(get_req_.BAY != '')
					document.getElementById('work_start').value = get_req_.BGUN + '/' + get_req_.BAY + '/' + get_req_.BYIL;
				
				if(get_req_.FAY != '')
					document.getElementById('work_finish').value = get_req_.FGUN + '/' + get_req_.FAY + '/' + get_req_.FYIL;
			}
		}
}
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
	if(!$("#personel_assign_head").val().length)
	{
	alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfoutput>"})    
	return false;
	}
	if(!$("#personel_name").val().length)
	{
	alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'></cfoutput>!"})    
	return false;
	}
	if(!$("#personel_surname").val().length)
	{
	alertObject({message: "<cfoutput><cf_get_lang dictionary_id='29503.Soyad Girmelisiniz'></cfoutput>!"})    
	return false;
	}
	if(!$("#work_start").val().length)
	{
	alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></cfoutput>"})    
	return false;
	}
	if(document.getElementById('work_finish').value == '')
	{
	alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55555.Çalışma Bitiş'></cfoutput>"})    
	return false;
	}
	if(document.getElementById('personel_assign_detail').value == '')
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='55590.Görüş Girmelisiniz'></cfoutput>!"})
		return false;
	}
	<cfif x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
		//Display Olarak Acilsin
	<cfelse>
		if(document.add_form.relative_status[0].checked && document.getElementById('relative_detail').value=='')
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='55808.Yakınlık Derecesi Girmelisiniz'></cfoutput>!"})
			return false;
		}
	</cfif>
	if(process_cat_control())
	{
		if(document.getElementById('salary') != undefined) document.getElementById('salary').value = filterNum(document.getElementById('salary').value);
		if(document.getElementById('old_salary') != undefined) document.getElementById('old_salary').value = filterNum(document.getElementById('old_salary').value);
		return true;
	}
	else
		return false;
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
		
		<cfif ListLen(x_show_warning_process)>
			var Get_Old_Assign_Identy = wrk_query("SELECT PERSONEL_ASSIGN_ID,UPDATE_DATE, ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,PERSONEL_ASSIGN_DETAIL FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID <><cfoutput>#get_per_req.personel_assign_id# AND PER_ASSIGN_STAGE IN (#x_show_warning_process#</cfoutput>) AND PERSONEL_TC_IDENTY_NO = '" + document.all.personel_tc_identy_no.value + "'","dsn");
			if(Get_Old_Assign_Identy.recordcount > 0)
			{
				Get_Update_Emp = wrk_query("SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = " + Get_Old_Assign_Identy.UPDATE_EMP,"dsn");
				document.getElementById('process_detail_control_td').innerHTML = "İlgili Kişinin Ataması " + date_format(Get_Old_Assign_Identy.UPDATE_DATE) + " Tarihinde " + Get_Update_Emp.EMPLOYEE_NAME + " " + Get_Update_Emp.EMPLOYEE_SURNAME + " Tarafından Reddedilmiştir! <br/>Gerekçe : " + Get_Old_Assign_Identy.PERSONEL_ASSIGN_DETAIL;
			}
		</cfif>
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
