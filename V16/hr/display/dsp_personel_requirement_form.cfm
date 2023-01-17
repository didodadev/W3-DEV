<!--- Personel Talep Formu --->
<cfoutput>
<input type="hidden" name="x_display_page_detail" id="x_display_page_detail" value="#x_display_page_detail#"><!--- Xml ile gelen parametreye gore queryde guncelleme islemi yapmayacagiz FBS 20110411 --->
<input type="hidden" name="req_head" id="req_head" value="#get_per_req.personel_requirement_head#">
<cf_box_elements>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-PERSONEL_REQUIREMENT_HEAD">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.PERSONEL_REQUIREMENT_HEAD#</div>
		</div>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-nick_name">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
				<cfif len(get_per_req.our_company_id)>#get_department_info.nick_name#</cfif>
				<cfif isdefined('get_department_info.branch_name')>#get_department_info.branch_name#</cfif>
				<cfif isdefined('get_department_info.department_head')>#get_department_info.department_head#</cfif>
			</div>
		</div>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-position_cat">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55280.Birim ve Görev"> *</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#position_cat#</div>
		</div>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_count">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55283.Talep Edilen Kişi Sayısı"> *</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_count#</div>
		</div>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-REQUIREMENT_DATE">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="31023.Talep Tarihi"></label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#dateformat(get_per_req.REQUIREMENT_DATE,dateformat_style)#</div>
		</div>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-PERSONEL_REQUIREMENT_HEAD">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.PERSONEL_REQUIREMENT_HEAD#</div>
		</div>
		<cfif len(get_per_req.REQUIREMENT_EMP)>
			<cfset isim = '#get_emp_info(get_per_req.REQUIREMENT_EMP,0,0,0)#'>
		<cfelseif len(get_per_req.REQUIREMENT_PAR_ID)>
			<cfset isim = '#get_par_info(get_per_req.REQUIREMENT_PAR_ID,0,0,0)#'>
		<cfelseif len(get_per_req.REQUIREMENT_CONS_ID)>
			<cfset isim = '#get_cons_info(get_per_req.REQUIREMENT_CONS_ID,0,0)#'>
		<cfelse>
			<cfset isim = ''>
		</cfif>
		<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-isim">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56219.Istekte Bulunan'></label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#isim#</div>
		</div>
		<cfif x_related_forms eq 1>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-quiz_head">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55119.Ölçme Değerlendirme Formu'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(get_per_req.related_forms)>
						<cfquery name="get_emp_quizes" datasource="#dsn#">
							SELECT QUIZ_ID,QUIZ_HEAD FROM EMPLOYEE_QUIZ WHERE QUIZ_ID IN (#get_per_req.related_forms#)
						</cfquery>
						<cfloop query="get_emp_quizes">#quiz_head#<cfif currentrow neq recordcount>,</cfif>
						</cfloop>
					</cfif>
				</div>
			</div>
		</cfif>
	</div>
</cf_box_elements>

<cf_seperator id="kisi_ozellikleri" title="#getLang('','Talep Edilen Kişi Özellikleri','55297')#">
<div id="kisi_ozellikleri">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif x_show_sex_info eq 1>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-gender">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57764.Cinsiyet"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfif get_per_req.sex eq 0><cf_get_lang dictionary_id="58958.Kadın"></cfif>-<cfif get_per_req.sex eq 1><cf_get_lang dictionary_id="58959.Erkek"></cfif></div>
				</div>
			</cfif>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-education_name">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30237.Eğitim Durumu"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfloop query="get_edu_level">
						<cfif edu_level_id eq get_per_req.training_level>#get_edu_level.education_name#,</cfif>
					</cfloop>
				</div>
			</div>
			<cfif x_show_language_info eq 1>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-language">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55218.Yabancı Dil Bilgisi"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfif get_per_req.language eq 0><cf_get_lang dictionary_id='58546.Yok'><cfelse><cf_get_lang dictionary_id='58564.Var'></cfif></div>
				</div>
				<cfif get_per_req.language eq 1 and ListLen(get_per_req.language_id)>
					<table cellpadding="1" cellspacing="0">
						<tr>
							<td height="20"style="width:150px;"><cf_get_lang dictionary_id="33172.Yabancı Dil"></td>
							<td height="20"style="width:150px;"><cf_get_lang dictionary_id="31669.Seviye"></td>
						</tr>
						<cfloop from="1" to="#ListLen(get_per_req.language_id)#" index="li">
							<tr>
								<td height="20"><cfloop query="get_languages">
										<cfif ListGetAt(get_per_req.language_id,li,',') eq language_id>#language_set#</cfif>
									</cfloop>
								</td>
								<td height="20"><cfloop query="know_levels">
										<cfif ListGetAt(get_per_req.knowlevel_id,li,',') eq knowlevel_id> #knowlevel# </cfif>
									</cfloop>
								</td>
							</tr>
						</cfloop>
					</table>
				</cfif>
			</cfif>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_age">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="39531.Yaş Aralığı"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_age#</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_exp">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55309.Bu Alandaki İş Tecrübesi (Yıl)"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_exp#</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_start_date">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="31622.İşe Başlama Tarihi"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfif len(get_per_req.personel_start_date)>#dateformat(get_per_req.personel_start_date,dateformat_style)#</cfif></div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-LICENCECAT">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55334.Ehliyet'></label>
				<cfquery name="DRIVERLICENCECATEGORIES" datasource="#dsn#">
					SELECT 
						LICENCECAT_ID, 
						LICENCECAT, 
						RECORD_EMP, 
						RECORD_IP, 
						RECORD_DATE, 
						UPDATE_EMP, 
						UPDATE_IP, 
						UPDATE_DATE, 
						IS_LAST_YEAR_CONTROL, 
						USAGE_YEAR 
					FROM 
						SETUP_DRIVERLICENCE 
					ORDER BY 
						LICENCECAT
				</cfquery>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfloop query="DRIVERLICENCECATEGORIES">
						<cfif len(get_per_req.LICENCECAT_ID) and listfindnocase(get_per_req.LICENCECAT_ID,LICENCECAT_ID)>#LICENCECAT#,</cfif>
					</cfloop>
				</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-vehicle_req">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif get_per_req.vehicle_req eq 1><cf_get_lang dictionary_id="58564.Var"></cfif>
					<cfif get_per_req.vehicle_req eq 0><cf_get_lang dictionary_id="58546.Yok"></cfif>
				</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-vehicle_req_model">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33567.Araç Modeli"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.vehicle_req_model#</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_details">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55344.Diğer Nitelikler"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_detail#</div>
			</div>
		</div>
	</cf_box_elements>
</div>
<cf_seperator id="ihtiyac" title="#getLang('','İhtiyaç Gerekçeleri','55370')#">
<cf_flat_list id="ihtiyac">
	<tr>
		<thead>
			<th height="20"><cf_get_lang dictionary_id='55550.Gerekçe'></th>
			<th height="20"colspan="2">
				<cfif get_per_req.form_type eq 2><cf_get_lang dictionary_id="55436.Ek Kadro Süresiz"></cfif>
				<cfif get_per_req.form_type eq 6><cf_get_lang dictionary_id="55449.Ek Kadro Süreli"></cfif>
				<cfif get_per_req.form_type eq 1><cf_get_lang dictionary_id="55433.Ayrılan Kişinin Yerine"></cfif>
				<cfif get_per_req.form_type eq 4><cf_get_lang dictionary_id="55481.Nakil Olan Personelin Yerine"></cfif>
				<cfif get_per_req.form_type eq 3><cf_get_lang dictionary_id="55451.Pozisyon Değişikliği Yapan Personelin Yerine"></cfif>
				<cfif get_per_req.form_type eq 5><cf_get_lang dictionary_id="55488.Emeklilik Nedeniyle Giriş / Çıkış Yapan Personelin Yerine"></cfif>
			</th>
		</thead>
	</tr>
	<cfif ListFind("1,3,4,5,6",get_per_req.form_type,",")>
		<tbody>
			<tr>
				<td height="20"colspan="2" class="formbold"><cf_get_lang dictionary_id="55536.Belirli Süreli Çalışan ise"></td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
				<td height="20"><cfif len(get_per_req.work_start)>#dateformat(get_per_req.work_start,dateformat_style)#</cfif>
				</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
				<td height="20"><cfif len(get_per_req.work_finish)>#dateformat(get_per_req.work_finish,dateformat_style)#</cfif>
				</td>
			</tr>
		</tbody>
	</cfif>
	
	<cfif ListFind("1,5",get_per_req.form_type,",")>
		<tbody>
			<tr>
				<td height="20" colspan="2" class="formbold"><cf_get_lang dictionary_id="55489.İlgili Pozisyondaki Çalışan Bilgileri"></td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55522.Ad Soyad / Görev"></td>
				<td height="20">#get_per_req.old_personel_name# - #get_per_req.old_personel_position#</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="31530.Ayrılma Nedeni"></td>
				<td height="20"><cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'İstifa')><cf_get_lang dictionary_id="55508.İstifa"></cfif>
					<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Fesih')><cf_get_lang dictionary_id="55509.Fesih"></cfif>
					<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Nakil')><cf_get_lang dictionary_id="40516.Nakil"></cfif>
					<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Emeklilik')><cf_get_lang dictionary_id="33549.Emeklilik"></cfif>
					<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Diğer')><cf_get_lang dictionary_id="58156.Diğer"> : </cfif>
					<cfif listlen(get_per_req.old_personel_detail) and listfindnocase(get_per_req.old_personel_detail,'Diğer') and listlen(get_per_req.old_personel_detail) eq 2>#listgetat(get_per_req.old_personel_detail,2)#</cfif>
				</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="33787.Ayrılma Tarihi"></td>
				<td height="20"><cfif len(get_per_req.old_personel_finishdate)>#dateformat(get_per_req.old_personel_finishdate,dateformat_style)#</cfif></td>
			</tr>
		</tbody>
	<cfelseif ListFind("4",get_per_req.form_type,",")>
		<tbody>
			<tr>
				<td height="20" colspan="2" class="formbold"><cf_get_lang dictionary_id="55524.Nakil Olan Personelin"></td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55522.Ad Soyad / Görev"></td>
				<td height="20">#get_per_req.transfer_personel_name# - #get_per_req.transfer_personel_position#</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55525.Yeni Şubesi / Pozisyonu"></td>
				<td height="20">#get_per_req.transfer_personel_branch_new# - #get_per_req.transfer_personel_position_new#</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="40494.Nakil Tarihi"></td>
				<td height="20"><cfif len(get_per_req.transfer_personel_startdate)>#dateformat(get_per_req.transfer_personel_startdate,dateformat_style)#</cfif></td>
			</tr>
		</tbody>
	<cfelseif ListFind("3",get_per_req.form_type,",")>
		<tbody>
			<tr>
				<td height="20" colspan="2" class="formbold"><cf_get_lang dictionary_id="55519.Pozisyon Değişikliği Yapan Personelin"></td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55522.Ad Soyad / Görev"></td>
				<td height="20">#get_per_req.change_personel_name# - #get_per_req.change_personel_position#</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="55523.Yeni Pozisyonu"></td>
				<td height="20">#get_per_req.change_personel_position_new#</td>
			</tr>
			<tr>
				<td height="20"><cf_get_lang dictionary_id="32655.Onay Tarihi"></td>
				<td height="20">#dateformat(get_per_req.change_personel_finishdate,dateformat_style)#</td>
			</tr>
		</tbody>
	</cfif>
	<tr>
		<tbody>
			<td height="20"colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tbody>
	</tr>
</cf_flat_list>
<cf_seperator id="gorus_onay" title="#getLang('hr',486)#">
<div id="gorus_onay">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_other">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="31406.Görüş"> *</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="personel_other" id="personel_other" style="width:456px;height:50px;" onKeyUp="CheckLen(this,500)"></textarea></div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-process_">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33362.Talep Durumu"></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#get_per_req.per_req_stage#' process_cat_width='150' is_detail='1'></div>
			</div>
		</div>
	</cf_box_elements>
</div>
<cf_seperator id="diger_bilgiler" title="#getLang('hr','Diğer Bilgiler',55572)#">
<div id="diger_bilgiler">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-requirement_reason">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56225.Kadro Talebinin Gerekçesi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.requirement_reason#</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_ability">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56227.Özel Yetenekler'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_ability#</div>
			</div>
			<cfif x_show_language_info eq 0>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_lang">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56228.Lisan Bilgisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_lang#</div>
				</div>
			</cfif>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-personel_properties">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56229.Sosyal Fiziki Psikolojik Özellikler'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_per_req.personel_properties#</div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-min_salary">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56230.Verilebilecek Min Brüt Ücret'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#TLFormat(get_per_req.min_salary)# <cfif Len(get_per_req.min_salary)>#get_per_req.min_salary_money#</cfif></div>
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-max_salary">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56231.Verilebilecek Max Brüt Ücret'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">#TLFormat(get_per_req.max_salary)# <cfif Len(get_per_req.max_salary)>#get_per_req.max_salary_money#</cfif></div>
			</div>
		</div>
	</cf_box_elements>
</div>
<cf_box_footer>
	<cf_record_info query_name="get_per_req">
    <cfif len(get_per_req.is_finished)>
        <font color="red"><cf_get_lang dictionary_id="55182.Talebin Süreci Tamamlanmıştır">.</font>
    <cfelse>
        <cfquery name="get_process_row_line" datasource="#dsn#">
            SELECT LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.per_req_stage#"> AND LINE_NUMBER = 1
        </cfquery>
        <cfif session.ep.userid eq get_per_req.record_emp and get_process_row_line.recordcount>
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_personel_requirement_form&per_req_id=#attributes.per_req_id#&cat=#get_per_req.per_req_stage#&head=#get_per_req.PERSONEL_REQUIREMENT_HEAD#' add_function='kontrol()'>
        <cfelse>
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
        </cfif>
    </cfif>
</cf_box_footer>
</cfoutput>
