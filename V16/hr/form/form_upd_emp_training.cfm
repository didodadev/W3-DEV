<cf_xml_page_edit fuseact="hr.popup_form_upd_emp_training">
<cfif not isdefined("get_hr_detail")>
    <cfinclude template="../query/get_hr_detail.cfm">
</cfif>
<cfquery name="get_education_level" datasource="#dsn#">
    SELECT 
        EDU_LEVEL_ID, 
        EDUCATION_NAME, 
        EDU_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
        SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#"> 
	SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
	SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL
</cfquery>
<cfquery name="get_languages_document" datasource="#dsn#">
	SELECT DOCUMENT_ID,DOCUMENT_NAME FROM SETUP_LANGUAGES_DOCUMENTS
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55949.Eğitim Deneyim"></cfsavecontent>
	<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="employe_train" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_training" method="post" enctype="multipart/form-data">
			<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="58996.Dil"></cfsavecontent>
			<cf_seperator title="#message#" id="training_lang">
			<cf_grid_list id='training_lang' sort="0">
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
						EMPLOYEE_ID = #attributes.employee_id#
				</cfquery>
				<input type="hidden" name="add_lang_info" id="add_lang_info" value="<cfoutput>#get_emp_language.recordcount#</cfoutput>">
				<thead>
					<tr>
						<th width="20"><a href="javascript://" onclick="add_lang_info_();"><i class="fa fa-plus" title="Ekle"></i></a></th>
						<th><cf_get_lang dictionary_id='58996.Dil'></th>
						<th><cf_get_lang dictionary_id='56158.Konuşma'></th>
						<th><cf_get_lang dictionary_id='56159.Anlama'></th>
						<th><cf_get_lang dictionary_id='56160.Yazma'></th>
						<th><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></th>
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
							<td width="20"><a style="cursor:pointer" onclick="del_lang('#currentrow#');"><i class="fa fa-minus"></i></a></td>
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
			<cfquery name="get_edu_info" datasource="#DSN#">
				SELECT
					EMPAPP_EDU_ROW_ID, 
					EMPAPP_ID, 
					EMPLOYEE_ID, 
					EDU_TYPE, 
					EDU_ID, 
					EDU_NAME, 
					EDU_PART_ID, 
					EDU_PART_NAME, 
					EDU_START, 
					EDU_FINISH, 
					EDU_RANK, 
					IS_EDU_CONTINUE,
					EDUCATION_TIME,
					EDUCATION_LANG,
					EDU_LANG_RATE
				FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPLOYEE_ID = #attributes.employee_id#
			</cfquery>	
			<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">	
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="55739.Eğitim Bilgileri"></cfsavecontent>				
			<cf_seperator title="#message#" id="table_edu_info_table">
			<div class="ui-scroll">
				<div  id="table_edu_info_table">
					<cf_grid_list sort="0">
						<thead>
							<tr>
								<th width="20" colspan="2">
									<input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>', 'medium');"><i class="fa fa-plus" title="<cf_get_lang no ='1410.Eğitim Bilgisi Ekle'>"></i></a>
								</th>
								<th><cf_get_lang dictionary_id ='56481.Okul Türü'></th>
								<th><cf_get_lang dictionary_id ='56482.Okul Adı'></th>
								<th><cf_get_lang dictionary_id ='56483.Başl Yılı'></th>
								<th><cf_get_lang dictionary_id ='56484.Bitiş Yılı'></th>
								<th><cf_get_lang dictionary_id ='56153.Not Ort'></th>
								<th><cf_get_lang dictionary_id ='57995.Bölüm'></th>
								<th><cf_get_lang dictionary_id ='41520.Öğrenim dili'></th>
								<th><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'>%</th>
								<th><cf_get_lang dictionary_id ='41519.Öğrenim Süresi'></th>
							</tr>
						</thead>
						<tbody id="table_edu_info">
							<cfoutput query="get_edu_info">
							<tr id="frm_row_edu#currentrow#">
								<input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" value="#empapp_edu_row_id#">
								<td width="20"><a href="javascript://" onclick="gonder_upd_edu('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang no ='1523.Eğitim Bilgisi Güncelle'>" border="0"></i></a></td>
								<td width="20"><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#"><a href="javascript://" onclick="sil_edu('#currentrow#');"><i class="fa fa-minus" border="0"></i></a></td>				
								<td>
									<div class="form-group"><cfset edu_type_id_control = "">
										<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>													
											<cfif len(edu_type)>
												<cfquery name="get_education_level_name" datasource="#dsn#">
													SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
												</cfquery>
												<cfset edu_type_name=get_education_level_name.education_name>
												<cfset edu_type_id_control = get_education_level_name.EDU_TYPE>											
											</cfif>
										<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="<cfif len(edu_type)>#edu_type_name#</cfif>" style="width:75px;" readonly>
									</div>
								</td>
								<td>
									<div class="form-group"><cfif len(edu_id) and edu_id neq -1>
										<cfquery name="get_unv_name" datasource="#dsn#">
											SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
										</cfquery>
										<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
									<cfelse>
										<cfset edu_name_degisken = edu_name>
									</cfif>
									<input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
									<input type="text" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly></div>
								</td>
								<td>
									<div class="form-group"><input type="text" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#dateformat(edu_start,dateformat_style)#" readonly></div>
								</td>
								<td>
									<div class="form-group"><input type="text" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#dateformat(edu_finish,dateformat_style)#" readonly></div>
								</td>
								<td>
									<div class="form-group"><input type="text" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></div>
								</td>
								<td>
									<cfset edu_part_name_degisken = "">
									<div class="form-group"><cfif (len(edu_part_id) and edu_part_id neq -1)>
										<cfif edu_type_id_control eq 1><!--- edu_type lise ise--->
												<cfquery name="get_high_school_part_name" datasource="#dsn#">
													SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
												</cfquery>
												<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
										<cfelseif listfind('2,3,4',edu_type_id_control)> <!--- üniversite ise--->
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
									<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" style="width:100%;" class="boxtext" value="#edu_part_name_degisken#" readonly>
									<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type_id_control eq 1>#edu_part_id#</cfif>">
									<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('2,3,4',edu_type_id_control) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
									<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#"></div>
								</td>
								<td>
									<div class="form-group"><cfif isNumeric(education_lang) and len(education_lang)>
										<cfquery name="GET_LANGUAGES_" datasource="#dsn#">
											SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID = #education_lang# ORDER BY LANGUAGE_SET
										</cfquery>
										<input type="text" name="edu_lang#currentrow#" id="edu_lang#currentrow#" class="boxtext" value="#get_languages_.language_set#" readonly>
									<cfelse>
										<input type="text" name="edu_lang#currentrow#" id="edu_lang#currentrow#" class="boxtext" value="#education_lang#" readonly>
									</cfif></div>
	
								</td>
								<td>
									<div class="form-group"><input type="text" name="edu_lang_rate#currentrow#" id="edu_lang_rate#currentrow#" class="boxtext" value="#edu_lang_rate#" readonly></div>
	
								</td>
								<td>
									<div class="form-group"><input type="text" name="education_time#currentrow#" id="education_time#currentrow#" class="boxtext" value="#education_time#" readonly></div>
								</td>
								</tr>
							</cfoutput>
						</tbody>
					</cf_grid_list>
					<div class="ui-info-bottom flex-end">
						<cf_box_elements>
							<div class="col col-12 col-md-12 col-xs-12">
								<div class="col col-6 col-md-6 col-xs-12">
									<div class="form-group">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-6 bold"><cf_get_lang dictionary_id='55695.diploma no'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-6">
											<cfinput name="edu4_diploma_no" value="#get_hr_detail.edu4_diploma_no#">
										</div>
									</div>
								</div>
								<div class="col col-6 col-md-6 col-xs-12">
									<div class="form-group">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-6 bold"><cf_get_lang dictionary_id='55725.En Son Bitirilen Okul'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-6">
											<select name="last_school" id="last_school">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_education_level">
													<option value="#get_education_level.edu_level_id#" <cfif get_education_level.edu_level_id eq get_hr_detail.last_school>SELECTED</cfif>>#get_education_level.education_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
						</cf_box_elements>
					</div>
				</div>
			</div>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="55683.Kurs-Sertifika"></cfsavecontent>
			<cf_seperator title="#message#" id="table_course_info">
			<cf_grid_list id="table_course_info" sort="0">
				<cfquery name="get_emp_course" datasource="#dsn#">
					SELECT 
						COURSE_SUBJECT,
						COURSE_EXPLANATION,
						COURSE_YEAR,
						COURSE_LOCATION,
						COURSE_PERIOD
					FROM 
						EMPLOYEES_COURSE
					WHERE
					EMPLOYEE_ID= #attributes.employee_id#
				</cfquery>
				<input type="hidden" name="emp_ex_course" id="emp_ex_course" value="<cfoutput>#get_emp_course.recordcount#</cfoutput>">
				<thead>
					<tr>
						<th width="20"><a href="javascript://" onclick="add_row_course();"><i class="fa fa-plus" title="Ekle"></i></a></th>
						<th><cf_get_lang dictionary_id='57480.Konu'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='58455.Yıl'></th>
						<th><cf_get_lang dictionary_id='55956.Yer'></th>
						<th><cf_get_lang dictionary_id='57490.Gün'></th>
					</tr>
				</thead>
				<tbody id="emp_course_info">
					<cfoutput query="get_emp_course">
						<tr id="pro_course#currentrow#">
							<td width="20"><a style="cursor:pointer" onclick="sil_('#currentrow#');"><i class="fa fa-minus" title="Sil"></i></a></td>
							<td><div class="form-group"><input type="text" name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#COURSE_SUBJECT#"></div></td>
							<td><div class="form-group"><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#course_explanation#"  maxlength="200"></div></td>
							<td><div class="form-group"><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" value="#left(course_year,4)#" maxlength="4" onkeyup="isNumber(this);"></div></td>
							<td><div class="form-group"><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#"></div></td>
							<td>
								<div class="form-group">
									<input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#">
									<input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
								</div>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		<cfquery name="get_work_info" datasource="#DSN#">
			SELECT
				EMPAPP_ROW_ID, 
				EMPAPP_ID, 
				EMPLOYEE_ID, 
				EXP, 
				EXP_POSITION, 
				EXP_START, 
				EXP_FINISH, 
				EXP_REASON, 
				EXP_EXTRA, 
				EXP_TELCODE, 
				EXP_TEL, 
				EXP_SECTOR_CAT, 
				EXP_SALARY, 
				EXP_EXTRA_SALARY, 
				EXP_TASK_ID, 
				IS_CONT_WORK,
				EXP_WORK_TYPE_ID
			FROM
				EMPLOYEES_APP_WORK_INFO
			WHERE
				EMPLOYEE_ID = #attributes.employee_id#
		</cfquery>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="56615.Deneyim"></cfsavecontent>
		<cf_seperator title="#message#" id="table_work_info_table">
		<cf_grid_list id="table_work_info_table" sort="0">
			<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
			<thead>
				<tr>
					<th width="20" colspan="2"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang no ='1401.İş Tecrübesi Ekle'>" border="0"></i></a></th>
					<th><cf_get_lang dictionary_id ='56485.Çalışılan Yer'></th>
					<th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id ='57579.Sektör'></th>
					<th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
					<th><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
				</tr>
			</thead>
			<tbody id="table_work_info">
				<cfoutput query="get_work_info">
					<tr id="frm_row#currentrow#">
						<input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#">
						<td><a href="javascript://" onclick="gonder_upd('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang no ='1531.İş Tecrübesi Güncelle'>" border="0"></i></a></td>
						<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onclick="sil('#currentrow#');"><i class="fa fa-minus" border="0"></i></a></td>
						<td><div class="form-group"><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></div></td>
						<td><div class="form-group"><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></div></td>
						<td>
							<div class="form-group"><input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
							<cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
								<cfquery name="get_sector_cat" datasource="#dsn#">
									SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
								</cfquery>
							</cfif>
							<input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly></div>
						</td>
						<td>
							<div class="form-group"><input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
							<cfif isdefined("exp_task_id") and len(exp_task_id)>
								<cfquery name="get_exp_task_name" datasource="#dsn#">
									SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
								</cfquery>
							</cfif>
							<input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly></div>
						</td>
						<td>
							<div class="form-group"><input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly></div>
						</td>
						<td>
							<div class="form-group"><input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly></div>
						</td>
						<input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
						<input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
						<input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
						<input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
						<input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
						<input type="hidden" name="exp_work_type_id#currentrow#" id="exp_work_type_id#currentrow#" value="#exp_work_type_id#">
						<input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
						<input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_record_info query_name="get_hr_detail">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function="control_lenght()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('employe_train' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>	
</cf_box>
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
	<input type="hidden" name="education_time_new" id="education_time_new" value="">
	<input type="hidden" name="edu_lang_new" id="edu_lang_new" value="">
	<input type="hidden" name="edu_lang_rate_new" id="edu_lang_rate_new" value="">
</form>
<script type="text/javascript">
var emp_ex_course = <cfoutput>#get_emp_course.recordcount#</cfoutput>;
function sil_(del){
		var my_element_=eval("employe_train.del_course_prog"+del);
		my_element_.value=0;
		var my_element_=eval("pro_course"+del);
		my_element_.style.display="none";

}
function add_row_course(){
	emp_ex_course++;
	employe_train.emp_ex_course.value = emp_ex_course;
	var newRow;
	var newCell;
		newRow = document.getElementById("emp_course_info").insertRow(document.getElementById("emp_course_info").rows.length);
		newRow.setAttribute("name","pro_course" + emp_ex_course);
		newRow.setAttribute("id","pro_course" + emp_ex_course);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + emp_ex_course +'"><a onclick="sil_(' + emp_ex_course + ');"><i class="fa fa-minus" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_' + emp_ex_course +'" style="width:100px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_exp' + emp_ex_course +'" style="width:100px;"  maxlength="200"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_yil' + emp_ex_course +'" style="width:100px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_yer' + emp_ex_course +'" style="width:100px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kurs1_gun' + emp_ex_course +'" style="width:100px;"></div>';
}
<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
	row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
	satir_say=0;
<cfelse>
	row_count=0;
	satir_say=0;
</cfif>
<cfif isdefined('get_edu_info') and (get_edu_info.recordcount)>
	row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
	satir_say_edu=0;
<cfelse>
	row_edu=0;
	satir_say_edu=0;
</cfif>
function control_lenght()
{  
	for (var counter_=1; counter_ <=  document.employe_train.emp_ex_course.value; counter_++)
	{ 
		if(eval("document.employe_train.del_course_prog"+counter_).value == 1 && eval("document.employe_train.kurs1_"+counter_).value == '')
		{
			alert("<cf_get_lang dictionary_id='41017.Lütfen Kurs-Sertifika Seçmek İçin'>  " + counter_ + " <cf_get_lang dictionary_id='41016.Konu Giriniz'>!");
			return false;
		}
	}
	for (var counter_=1; counter_ <=  document.employe_train.emp_ex_course.value; counter_++)
	{
		if(eval("document.employe_train.del_course_prog"+counter_).value == 1 && (eval("document.employe_train.kurs1_yil"+counter_).value == '' || eval("document.employe_train.kurs1_yil"+counter_).value.length <4))
		{
			alert("<cf_get_lang dictionary_id='41017.Lütfen Kurs-Sertifika Seçmek İçin'>  " + counter_ + "  <cf_get_lang dictionary_id='41015.Yıl Giriniz'>!");
			return false;
		}
	}
	if(document.employe_train.edu4_diploma_no.value.length > 50)
	{
		alert("<cf_get_lang dictionary_id ='56617.Diploma Notu 50 Karakterden Fazla Olamaz'>!");
		return false;
	}
	for(i = 1;i<=add_lang_info ; i++)
	{
		document.getElementById("lang_point"+i).value = filterNum(document.getElementById("lang_point"+i).value);
	}
	return true;
}
/*İŞ TECRÜBESİ*/

function sil(sy)
{
	var my_element=eval("employe_train.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	satir_say--;
}

function gonder_upd(count)
{
	form_work_info.exp_name_new.value = eval("employe_train.exp_name"+count).value;
	form_work_info.exp_position_new.value = eval("employe_train.exp_position"+count).value;
	form_work_info.exp_sector_cat_new.value = eval("employe_train.exp_sector_cat"+count).value;
	form_work_info.exp_task_id_new.value = eval("employe_train.exp_task_id"+count).value;
	form_work_info.exp_start_new.value = eval("employe_train.exp_start"+count).value;
	form_work_info.exp_finish_new.value = eval("employe_train.exp_finish"+count).value;
	form_work_info.exp_telcode_new.value = eval("employe_train.exp_telcode"+count).value;
	form_work_info.exp_tel_new.value = eval("employe_train.exp_tel"+count).value;
	form_work_info.exp_salary_new.value = eval("employe_train.exp_salary"+count).value;
	form_work_info.exp_extra_salary_new.value = eval("employe_train.exp_extra_salary"+count).value;
	form_work_info.exp_extra_new.value = eval("employe_train.exp_extra"+count).value;
	form_work_info.exp_work_type_id_new.value = eval("employe_train.exp_work_type_id"+count).value;
	form_work_info.exp_reason_new.value = eval("employe_train.exp_reason"+count).value;
	form_work_info.is_cont_work_new.value = eval("employe_train.is_cont_work"+count).value;
	windowopen('','medium','kariyer_pop');
	form_work_info.target='kariyer_pop';
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
	form_work_info.submit();	
}

function gonder(exp_name,exp_position,exp_sector_cat,exp_task_id,exp_start,exp_finish,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_work_type_id,exp_reason,is_cont_work,control,my_count)
{
	if(control == 1)
	{
		eval("employe_train.exp_name"+my_count).value=exp_name;
		eval("employe_train.exp_position"+my_count).value=exp_position;
		eval("employe_train.exp_start"+my_count).value=exp_start;
		eval("employe_train.exp_finish"+my_count).value=exp_finish;
		eval("employe_train.exp_sector_cat"+my_count).value=exp_sector_cat;
		if(exp_sector_cat != '')
		{
			var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
			var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		eval("employe_train.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
		eval("employe_train.exp_task_id"+my_count).value=exp_task_id;
		if(exp_task_id != '')
		{
		
			var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
			var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
		}
		else
			var exp_task_name = '';
		eval("employe_train.exp_task_name"+my_count).value=exp_task_name;
		eval("employe_train.exp_telcode"+my_count).value=exp_telcode;
		eval("employe_train.exp_tel"+my_count).value=exp_tel;
		eval("employe_train.exp_salary"+my_count).value=exp_salary;
		eval("employe_train.exp_extra_salary"+my_count).value=exp_extra_salary;
		eval("employe_train.exp_extra"+my_count).value=exp_extra;
		eval("employe_train.exp_reason"+my_count).value=exp_reason;
		eval("employe_train.exp_work_type_id"+my_count).value=exp_work_type_id;
		eval("employe_train.is_cont_work"+my_count).value=is_cont_work;
	}
	else
	{
			row_count++;
			employe_train.row_count.value = row_count;
			satir_say++;
			var new_Row;
			var new_Cell;
			new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
			new_Row.setAttribute("name","frm_row" + row_count);
			new_Row.setAttribute("id","frm_row" + row_count);		
			new_Row.setAttribute("NAME","frm_row" + row_count);
			new_Row.setAttribute("ID","frm_row" + row_count);
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><i class="fa fa-pencil" align="absbottom" border="0"></i></a>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" border="0"></a>';		
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<div class="form-group"><input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
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
/*İŞ TECRÜBESİ*/
/*eğitim bilgileri*/
function sil_edu(sv)
{
	var my_element_edu=eval("employe_train.row_kontrol_edu"+sv);
	my_element_edu.value=0;
	var my_element_edu = eval("frm_row_edu"+sv);
	my_element_edu.style.display="none";
	satir_say_edu--;
}

function gonder_upd_edu(count_new)
{
	
	form_edu_info.edu_type_new.value = eval("employe_train.edu_type"+count_new).value;//Okul Türü
	if(eval("employe_train.edu_id"+count_new) != undefined && eval("employe_train.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
		form_edu_info.edu_id_new.value = eval("employe_train.edu_id"+count_new).value;
	else
		form_edu_info.edu_id_new.value = '';
	
	if(eval("employe_train.edu_name"+count_new) != undefined && eval("employe_train.edu_name"+count_new).value != '')
		form_edu_info.edu_name_new.value = eval("employe_train.edu_name"+count_new).value;
	else
		form_edu_info.edu_name_new.value = '';
	
	form_edu_info.edu_start_new.value = eval("employe_train.edu_start"+count_new).value;
	form_edu_info.edu_finish_new.value = eval("employe_train.edu_finish"+count_new).value;
	form_edu_info.edu_rank_new.value = eval("employe_train.edu_rank"+count_new).value;
	form_edu_info.edu_lang_new.value = eval("employe_train.edu_lang"+count_new).value;	
	form_edu_info.edu_lang_rate_new.value = eval("employe_train.edu_lang_rate"+count_new).value;	
	form_edu_info.education_time_new.value = eval("employe_train.education_time"+count_new).value;
	if(eval("employe_train.edu_high_part_id"+count_new) != undefined && eval("employe_train.edu_high_part_id"+count_new).value != '')
		form_edu_info.edu_high_part_id_new.value = eval("employe_train.edu_high_part_id"+count_new).value;
	else
		form_edu_info.edu_high_part_id_new.value = '';
		
	if(eval("employe_train.edu_part_id"+count_new) != undefined && eval("employe_train.edu_part_id"+count_new).value != '')
		form_edu_info.edu_part_id_new.value = eval("employe_train.edu_part_id"+count_new).value;
	else
		form_edu_info.edu_part_id_new.value = '';
		
	if(eval("employe_train.edu_part_name"+count_new) != undefined && eval("employe_train.edu_part_name"+count_new).value != '')
		form_edu_info.edu_part_name_new.value = eval("employe_train.edu_part_name"+count_new).value;
	else
		form_edu_info.edu_part_name_new.value = '';
	form_edu_info.is_edu_continue_new.value = eval("employe_train.is_edu_continue"+count_new).value;
	var form = $('form[name = form_edu_info]');
	openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>&'+form.serialize()).replaceAll("+", " "));
	/*form_edu_info.target='kryr_pop';
	form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
	form_edu_info.submit();*/	
}

function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,is_edu_continue,edu_part_name,edu_lang,edu_lang_rate,education_time)
{

	var edu_type = edu_type.split(';')[0];
	var edu_name_degisken = '';
	var edu_part_name_degisken = '';
	if(ctrl_edu == 1)
	{
		
		eval("employe_train.edu_type"+count_edu).value=edu_type;
		if(edu_type != undefined && edu_type != '')
		{
		
			var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
			if(get_edu_part_name_sql.recordcount)
				var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
		}
		eval("employe_train.edu_type_name"+count_edu).value=edu_type_name;
		eval("employe_train.edu_id"+count_edu).value=edu_id;
		eval("employe_train.edu_high_part_id"+count_edu).value=edu_high_part_id;
		eval("employe_train.edu_part_id"+count_edu).value=edu_part_id;
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			eval("employe_train.edu_name"+count_edu).value=edu_name_degisken;
		}
		else
		{
			eval("employe_train.edu_name"+count_edu).value=edu_name;
		}
		eval("employe_train.edu_start"+count_edu).value=edu_start;
		eval("employe_train.edu_finish"+count_edu).value=edu_finish;
		eval("employe_train.edu_rank"+count_edu).value=edu_rank;
		if(eval("employe_train.edu_high_part_id"+count_edu) != undefined && eval("employe_train.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else if(eval("employe_train.edu_part_id"+count_edu) != undefined && eval("employe_train.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else 
		{
			var edu_part_name_degisken = edu_part_name;
			eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		eval("employe_train.is_edu_continue"+count_edu).value=is_edu_continue;
		eval("employe_train.edu_lang"+count_edu).value=edu_lang;
		eval("employe_train.edu_lang_rate"+count_edu).value=edu_lang_rate;
		eval("employe_train.education_time"+count_edu).value=education_time;
	}
	else
	{
		row_edu++;
		employe_train.row_edu.value = row_edu;
		satir_say_edu++;
		var new_Row_Edu;
		var new_Cell_Edu;
		new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
		new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
		new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);

		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="fa fa-pencil" border="0" align="absbottom"></i></a>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><img  src="images/delete_list.gif" border="0"></a>';
		
		if(edu_type != undefined && edu_type != '')
		{
			var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
			if(get_edu_part_name_sql.recordcount)
				var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
		}
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:75px;" type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
		if(edu_id != undefined && edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input  style="width:100%;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
		}
		if(edu_name != undefined && edu_name != '')
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
		if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" style="width:150px;" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" style="width:150px;" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" style="width:150px;" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_lang' + row_edu + '" value="'+ edu_lang +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_lang_rate' + row_edu + '" value="'+ edu_lang_rate +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="education_time' + row_edu + '" value="'+ education_time +'" class="boxtext" readonly>';
	}
}

/*Eğitim Bilgileri*/
	/* Dil Bilgileri */
	var add_lang_info=<cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
	function del_lang(dell){
			var my_emement1=eval("employe_train.del_lang_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("lang_info_"+dell);
			my_element1.style.display="none";
	}
	function add_lang_info_()
	{
		add_lang_info++;
		employe_train.add_lang_info.value=add_lang_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
		newRow.setAttribute("name","lang_info_" + add_lang_info);
		newRow.setAttribute("id","lang_info_" + add_lang_info);
		employe_train.language_info.value=add_lang_info;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a style="cursor:pointer" onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" border="0" alt="<cf_get_lang_main no ="51.sil">"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang' + add_lang_info +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id="58996.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_speak' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_mean' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_write' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lang_where' + add_lang_info + '" value="" style="width:150px;"></div>';
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