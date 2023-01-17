<!--- Özgeçmişim / Eğitim Bilgilerim (Stage:4) --->
<!--- TODO: arayüzü düzenlenecek. --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_edu_level = get_components.get_edu_level()>
<cfset know_levels =  get_components.know_levels()>
<cfset get_school =  get_components.get_school()>
<cfset get_school_part =  get_components.get_school_part()>
<cfset get_high_school_part =  get_components.get_high_school_part()>
<cfset get_languages =  get_components.get_languages()>
<cfset get_app = get_components.get_app()>
<cfset get_emp_course = get_components.get_emp_course()>
<cfset get_edu_info = get_components.get_edu_info()>
<cfset get_app_lang = get_components.get_app_lang()>

<!--- <cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif> --->

<cfparam name="attributes.stage" default="4"><!--- hangi sayfa olduğunu belirleyen değer--->
<cfform name="employe_detail" method="post">
<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
<table>
	<tr>
		<td><cfinclude template="../display/add_sol_menu.cfm"></td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
	<tr style="height:35px;">
		<td class="txtbold"><cf_get_lang no='803.Özgeçmişim'> \ <cf_get_lang no='225.Eğitim Bilgileri'></td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" class="ik1" style="width:100%;">
				<tr>
					<td colspan="2" class="txtbold" style="font-size:10px;"><cf_get_lang no='225.Eğitim Bilgileri'></td>
				</tr>
				<tr>
					<td style="width:15%;"><cf_get_lang no='834.Eğitim Seviyeniz'></td>
					<td>
						<select name="training_level" id="training_level" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_edu_level">
								<option value="#edu_level_id#" <cfif edu_level_id eq get_app.training_level>selected</cfif>>#get_edu_level.education_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" class="ik1" style="width:100%;">
				<tr>
					<td colspan="2">
						<cfif get_edu_info.recordcount>
							<table id="table_edu_info" border="0" cellpadding="0" cellspacing="5">
							<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
								<tr>
									<td class="txtboldblue"><cf_get_lang no='835.Okul Türü'></td>
									<td class="txtboldblue"><cf_get_lang no='520.Okul Adı'></td>
									<td class="txtboldblue" width="10">&nbsp;</td>
									<td class="txtboldblue"><cf_get_lang no='838.Başl Yılı'></td>
									<td class="txtboldblue"><cf_get_lang no='839.Bitiş Yılı'></td>
									<td class="txtboldblue"><cf_get_lang no='836.Not Ort'>.</td>
									<td class="txtboldblue"><cf_get_lang_main no='583.Bölüm'></td>
									<td>
										<input type="hidden" name="record_numb_edu" id="record_numb_edu" value="0"><a href="javascript://" title="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_edu_info&ctrl_edu=0','small');"><img src="/images/plus_list.gif" alt="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" border="0" /></a>
									</td>
								</tr>
								<cfoutput query="get_edu_info">
									<tr id="frm_row_edu#currentrow#">
										<input type="hidden" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
										<td>
											<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
											<cfif edu_type eq 1>
												<cfset edu_type_name = 'İlk Okul'>
											<cfelseif edu_type eq 2>
												<cfset edu_type_name = 'Orta Okul'>
											<cfelseif edu_type eq 3>
												<cfset edu_type_name = 'Lise'>
											<cfelseif edu_type eq 4>
												<cfset edu_type_name = 'Üniversite'>
											<cfelseif edu_type eq 5>
												<cfset edu_type_name = 'Yüksek Lisans'>
											<cfelseif edu_type eq 6>
												<cfset edu_type_name = 'Doktora'>
											</cfif>
											<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="#edu_type_name#" style="width:80;" readonly>
										</td>
										<td>
											<cfif len(edu_id) and edu_id neq -1>
												<cfif listfind('3,4,5,6',edu_type)>
													<cfquery name="GET_UNV_NAME" datasource="#DSN#">
														SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_id#">
													</cfquery>
												</cfif>
												<cfset edu_name_degisken = get_unv_name.school_name>
											<cfelse>
												<cfset edu_name_degisken = edu_name>
											</cfif>
											<input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
											<input type="text" style="width:185;" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
										</td>
										<td></td>
										<td>
											<input type="text" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#edu_start#" style="width:50px;" readonly>
										</td>
										<td>
											<input type="text" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#edu_finish#" style="width:50px;" readonly>
										</td>
										<td>
											<input type="text" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" style="width:65;" readonly>
										</td>
										<td>
											<cfif (len(edu_part_id) and edu_part_id neq -1)>
												<cfif edu_type eq 3>
													<cfquery name="GET_HIGH_SCHOOL_PART_NAME" datasource="#DSN#">
														SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_part_id#">
													</cfquery>
													<cfset edu_part_name_degisken = get_high_school_part_name.high_part_name>
												<cfelseif listfind('4,5',edu_type)>
													<cfquery name="GET_SCHOOL_PART_NAME" datasource="#DSN#">
														SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_part_id#">
													</cfquery>
													<cfset edu_part_name_degisken = get_school_part_name.part_name>
												</cfif>
											<cfelseif len(edu_part_name)>
												<cfset edu_part_name_degisken = edu_part_name>
											<cfelse>
												<cfset edu_part_name_degisken = "">
											</cfif>
											<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" style="width:150;" class="boxtext" value="#edu_part_name_degisken#" readonly>
											<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
											<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
											<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" value="#is_edu_continue#">
										</td>
										<td><a href="javascript://" title="<cf_get_lang no ='1158.Eğitim Bilgisi Güncelle'>" onclick="gonder_upd_edu('#currentrow#');"><img src="../../images/update_list.gif" alt="<cf_get_lang no ='1158.Eğitim Bilgisi Güncelle'>" border="0" /></a></td>
										<td><input  type="hidden" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#" value="1"><a href="javascript://" title="<cf_get_lang_main no ='51.Sil'>" onclick="sil_edu('#currentrow#');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ='51.Sil'>" /></a></td>		
									</tr>
								</cfoutput>
							</table>
						<cfelse>
							<table id="table_edu_info" border="0" style="width:100%;">
								<input type="hidden" name="row_edu" id="row_edu" value="0">
								<tr>
									<td class="txtboldblue"><cf_get_lang no='835.Okul Türü'></td>
									<td class="txtboldblue"><cf_get_lang no='520.Okul Adı'></td>
									<td>&nbsp;</td>
									<td class="txtboldblue"><cf_get_lang no='838.Başl Yılı'></td>
									<td class="txtboldblue"><cf_get_lang no='839.Bitiş Yılı'></td>
									<td class="txtboldblue"><cf_get_lang no='836.Not Ort'>.</td>
									<td class="txtboldblue"><cf_get_lang_main no='583.Bölüm'></td>
									<td><input type="hidden" name="record_numb_edu" id="record_numb_edu"  value="0"><a href="javascript://" title="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" alt="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" border="0" /></a></td>
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
							</table>
						</cfif>
					</td>
				</tr>
				<tr>
			 		<td colspan="2">
			  			<table border="0" style="width:100%;">
							<tr>
								<td colspan="6" class="txtbold" style="font-size:10px;"><cf_get_lang no='841.Yabancı Dilleriniz'></td>
							</tr>
							<tr>
								<td></td>
								<td class="txtboldblue"><cf_get_lang_main no='1584.Dil'></td>
								<td class="txtboldblue"><cf_get_lang no='842.Konuşma'></td>
								<td class="txtboldblue"><cf_get_lang no='843.Anlama'></td>
								<td class="txtboldblue"><cf_get_lang no='844.Yazma'></td>
								<td class="txtboldblue"><cf_get_lang no='845.Öğrenildiği Yer'></td>
							</tr>
							<cfloop query="get_app_lang">
                                <tr>
                                    <td><input type="hidden" name="lang_id<cfoutput>#currentrow#</cfoutput>" id="lang_id<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#id#</cfoutput>"></td>
                                    <td><select name="lang<cfoutput>#currentrow#</cfoutput>" id="lang<cfoutput>#currentrow#</cfoutput>" style="width:110px;">
                                            <option value=""><cf_get_lang no='846.Dil Seçiniz'>
                                            <cfoutput query="get_languages">
                                                <option value="#language_id#" <cfif get_languages.language_id eq get_app_lang.lang_id>selected</cfif>>#language_set# 
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#currentrow#</cfoutput>_speak" id="lang<cfoutput>#currentrow#</cfoutput>_speak" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#" <cfif get_app_lang.lang_speak eq knowlevel_id>selected</cfif>>#knowlevel# 
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#currentrow#</cfoutput>_mean" id="lang<cfoutput>#currentrow#</cfoutput>_mean" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#" <cfif get_app_lang.lang_mean eq knowlevel_id>selected</cfif>>#knowlevel#
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#currentrow#</cfoutput>_write" id="lang<cfoutput>#currentrow#</cfoutput>_write" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#" <cfif get_app_lang.lang_write eq knowlevel_id>selected</cfif>>#knowlevel# 
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><input type="text" class="input_1" name="lang<cfoutput>#currentrow#</cfoutput>_where"  id="lang<cfoutput>#currentrow#</cfoutput>_where" value="<cfoutput>#get_app_lang.lang_where#</cfoutput>" maxlength="50" style="width:120px;"></td>
                                </tr>
                            </cfloop>
                            <cfloop from="#get_app_lang.recordcount+1#" to="5" index="i">
                                <tr>
                                    <td><input type="hidden" name="lang_id<cfoutput>#i#</cfoutput>" id="lang_id<cfoutput>#i#</cfoutput>" value=""></td>
                                    <td><select name="lang<cfoutput>#i#</cfoutput>" id="lang<cfoutput>#i#</cfoutput>" style="width:110px;">
                                            <option value=""><cf_get_lang no='846.Dil Seçiniz'> 
                                            <cfoutput query="get_languages">
                                                <option value="#language_id#">#language_set# 
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#i#</cfoutput>_speak" id="lang<cfoutput>#i#</cfoutput>_speak" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#">#knowlevel#
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#i#</cfoutput>_mean" id="lang<cfoutput>#i#</cfoutput>_mean" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#">#knowlevel#
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><select name="lang<cfoutput>#i#</cfoutput>_write" id="lang<cfoutput>#i#</cfoutput>_write" style="width:110px;">
                                            <cfoutput query="know_levels">
                                                <option value="#knowlevel_id#">#knowlevel#
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td><input type="text" class="input_1"  name="lang<cfoutput>#i#</cfoutput>_where" id="lang<cfoutput>#i#</cfoutput>_where" value="" maxlength="50" style="width:120px;"></td>
                                </tr>
                            </cfloop>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table id="add_course_pro" border="0" style="width:100%;">
							<tr>
								<td class="txtbold" colspan="4" style="font-size:10px;">Kurs - Seminer ve Akademik Olmayan Programlar</td>
							</tr>
							<input type="hidden" name="extra_course" id="extra_course" value="<cfoutput>#get_emp_course.recordcount#</cfoutput>">
							<tr>
								<td class="txtboldblue"><cf_get_lang_main no='68.Konu'></td>
								<td class="txtboldblue"><cf_get_lang no='897.Yer'></td>
								<td class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
								<td class="txtboldblue"><cf_get_lang_main no='1043.Yıl'></td>
								<td class="txtboldblue"><cf_get_lang_main no='1716.Sure'></td>
								<td><a style="cursor:pointer" onclick="add_row_course();" title="Ekle"><img src="images/plus_list.gif" alt="Ekle"></a></td>
							</tr>
							<cfif isdefined("get_emp_course")>
								<cfoutput query="get_emp_course">
									<tr id="pro_course#currentrow#">
										<td><input type="text" name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#course_subject#" style="width:115px;"></td>
										<td><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#" style="width:115px;"></td>
										<td><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#course_explanation#" style="width:115px;"  maxlength="200"></td>
										<td><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" value="#left(course_year,4)#" style="width:115px;"></td>
										<td>
											<input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#" style="width:115px;">
											<input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
										</td>
										<td nowrap><a style="cursor:pointer" onclick="sil_('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
									</tr>
								</cfoutput>
							</cfif>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="txtbold" style="font-size:10px;"><cf_get_lang no='847.Bilgisayar Bilginiz'></td>
				</tr>
				<tr>
					<td colspan="6">
						<cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
						<textarea name="comp_exp" id="comp_exp" style="width:457px;height:60px;" maxlength="1000" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_app.comp_exp#</cfoutput></textarea>
					</td>
				</tr>
				<tr style="height:30px;">
					<cfsavecontent variable="alert"><cf_get_lang no ='1174.Kaydet ve İlerle'></cfsavecontent>
					<td colspan="6" style="text-align:right;">
						<!--- <cf_workcube_buttons is_upd='0' insert_info='#alert#' is_cancel='0'> --->
						<cf_workcube_buttons is_insert='1' insert_info='#alert#'	data_action="/V16/objects2/career/cfc/data_career:add_cv_4" next_page="#request.self#" >
					</td>
				</tr>
			</table>
   		</td>
	</tr>
</table>
</cfform>
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
<br/>
<script type="text/javascript">
	/*Eğitim Bilgileri*/
	row_edu = <cfoutput>#get_edu_info.recordcount#</cfoutput>;
	satir_say_edu=0;

	function sil_edu(sv)
	{   
		var my_element_edu = eval("document.getElementById('row_kontrol_edu"+sv+"')");
		my_element_edu.value = 0;
		var my_element_edu = eval("frm_row_edu"+sv);
		my_element_edu.style.display="none";
		satir_say_edu--;
	}
	
	function sil_(del)
	{
		var my_element_=eval("document.getElementById('del_course_prog"+del+"')");
		my_element_.value=0;
		var my_element_=eval("pro_course"+del);
		my_element_.style.display="none";
	}

	function gonder_upd_edu(count_new)
	{
		document.getElementById('edu_type_new').value = eval("document.getElementById('edu_type"+count_new+"')").value;//Okul Türü
		if(eval("document.getElementById('edu_id"+count_new+"')") != undefined && eval("document.getElementById('edu_id"+count_new+"')").value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
			document.getElementById('edu_id_new').value = eval("document.getElementById('edu_id"+count_new+"')").value;
		else
			document.getElementById('edu_id_new').value = '';
		
		if(eval("document.getElementById('edu_name"+count_new+"')") != undefined && eval("document.getElementById('edu_name"+count_new+"')").value != '')
			document.getElementById('edu_name_new').value = eval("document.getElementById('edu_name"+count_new+"')").value;
		else
			document.getElementById('edu_name_new').value = '';
		
		document.getElementById('edu_start_new').value = eval("document.getElementById('edu_start"+count_new+"')").value;
		document.getElementById('edu_finish_new').value = eval("document.getElementById('edu_finish"+count_new+"')").value;
		document.getElementById('edu_rank_new').value = eval("document.getElementById('edu_rank"+count_new+"')").value;
		if(eval("document.getElementById('edu_high_part_id"+count_new+"')") != undefined && eval("document.getElementById('edu_high_part_id"+count_new+"')").value != '')
			document.getElementById('edu_high_part_id_new').value = eval("document.getElementById('edu_high_part_id"+count_new+"')").value;
		else
			document.getElementById('edu_high_part_id_new').value = '';
			
		if(eval("document.getElementById('edu_part_id"+count_new+"')") != undefined && eval("document.getElementById('edu_part_id"+count_new+"')").value != '')
			document.getElementById('edu_part_id_new').value = eval("document.getElementById('edu_part_id"+count_new+"')").value;
		else
			document.getElementById('edu_part_id_new').value = '';
			
		if(eval("document.getElementById('edu_part_name"+count_new+"')") != undefined && eval("document.getElementById('edu_part_name"+count_new+"')").value != '')
			document.getElementById('edu_part_name_new').value = eval("document.getElementById('edu_part_name"+count_new+"')").value;
		else
			document.getElementById('edu_part_name_new').value = '';
		document.getElementById('is_edu_continue_new').value = eval("document.getElementById('is_edu_continue"+count_new+"')").value;
		windowopen('','medium','kryr_pop');
		documentform_edu_info.target='kryr_pop';
		documentform_edu_info.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
		documentform_edu_info.submit();	
	}
	
	function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
	{    
		if(ctrl_edu == 1)
		{  
			eval("document.getElementById('edu_type'+count_edu+'')").value=edu_type;
			if(eval("document.getElementById('edu_type'+count_edu+'')").value == 1)
				var edu_type_name = 'İlk Okul';
			else if(eval("document.getElementById('edu_type'+count_edu+'')").value == 2)
				var edu_type_name = 'Orta Okul';
			else if(eval("document.getElementById('edu_type'+count_edu+'')").value == 3)
				var edu_type_name = 'Lise';
			else if(eval("document.getElementById('edu_type'+count_edu+'')").value == 4)
				var edu_type_name = 'Üniversite';
			else if(eval("document.getElementById('edu_type'+count_edu+'')").value == 5)
				var edu_type_name = 'Yüksek Lisans';
			else if(eval("document.getElementById('edu_type'+count_edu+'')").value == 6)
				var edu_type_name = 'Doktora';
			else
				var edu_type_name = '';
			eval("document.getElementById('edu_type_name'+count_edu+'')").value=edu_type_name;
			eval("document.getElementById('edu_id'+count_edu+'')").value=edu_id;
			eval("document.getElementById('edu_high_part_id'+count_edu+'')").value=edu_high_part_id;
			eval("document.getElementById('edu_part_id'+count_edu+'')").value=edu_part_id;
			if(edu_id != '' && edu_id != -1)
			{
				var get_cv_edu_new = wrk_safe_query(obj2_get_cv_edu_new,'dsn',0,edu_id);
				if(get_cv_edu_new.recordcount)
					var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;		
				eval("document.getElementById('edu_name'+count_edu+'')").value=edu_name_degisken;
			}
			else
			{
				var edu_name_degisken = edu_name;
				eval("document.getElementById('edu_name'+count_edu+'')").value=edu_name_degisken;
			}
			eval("document.getElementById('edu_start'+count_edu+'')").value=edu_start;
			eval("document.getElementById('edu_finish'+count_edu+'')").value=edu_finish;
			eval("document.getElementById('edu_rank'+count_edu+'')").value=edu_rank;
			if(eval("document.getElementById('edu_high_part_id'+count_edu+'')") != undefined && eval("document.getElementById('edu_high_part_id'+count_edu+'')").value != '' && edu_high_part_id != -1)
			{
				var get_cv_edu_high_part_id = wrk_safe_query("obj2_get_cv_edu_high_part_id",'dsn',0,edu_high_part_id);
				if(get_cv_edu_high_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
				eval("document.getElementById('edu_part_name'+count_edu+'')").value=edu_part_name_degisken;
			}
			else if(eval("document.getElementById('edu_part_id'+count_edu+'')") != undefined && eval("document.getElementById('edu_part_id'+count_edu+'')").value != '' && edu_part_id != -1)
			{
				var get_cv_edu_part_id = wrk_safe_query("obj2_get_cv_edu_part_id",'dsn',0,edu_part_id);  
				if(get_cv_edu_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
				eval("document.getElementById('edu_part_name'+count_edu+'')").value=edu_part_name_degisken;
			}
			else
			{
				var edu_part_name_degisken = edu_part_name;
				eval("document.getElementById('edu_part_name'+count_edu+'')").value=edu_part_name_degisken;
			}
			eval("document.getElementById('is_edu_continue'+count_edu+'')").value=is_edu_continue;
		}
		else
		{  
			row_edu++;
			document.getElementById('row_edu').value = row_edu;
			satir_say_edu++;
			var new_Row_Edu;
			var new_Cell_Edu;
			new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
			new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
			new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
			new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
			new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);
			if(edu_type == 1)
				var edu_type_name = 'İlk Okul';
			else if(edu_type == 2)
				var edu_type_name = 'Orta Okul';
			else if(edu_type == 3)
				var edu_type_name = 'Lise';
			else if(edu_type == 4)
				var edu_type_name = 'Üniversite';
			else if(edu_type == 5)
				var edu_type_name = 'Yüksek Lisans';
			else if(edu_type == 6)
				var edu_type_name = 'Doktora';
			else
				var edu_type_name = '';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:80;" type="text" name="edu_type_name' + row_edu + '" id="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
			if(edu_id != '' && edu_id != -1)
			{
				var get_cv_edu_new = wrk_safe_query("obj2_get_cv_edu_new",'dsn',0,edu_id);
				if(get_cv_edu_new.recordcount)
					var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:185;" type="text" name="edu_name' + row_edu + '" id="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
			}
			else
			{
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:185;" type="text" name="edu_name' + row_edu + '" id="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
			}
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:10;" type="hidden" name="gizli' + row_edu + '" id="gizli' + row_edu + '" value="" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:50;" type="text" name="edu_start' + row_edu + '" id="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:50;" type="text" name="edu_finish' + row_edu + '" id="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:65;" type="text" name="edu_rank' + row_edu + '" id="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
			if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
			{
				var get_cv_edu_high_part_id = wrk_safe_query("obj2_get_cv_edu_high_part_id",'dsn',0,edu_high_part_id);
				if(get_cv_edu_high_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" id="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:150px;" class="boxtext" readonly>';
			}
			else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
			{
				var get_cv_edu_part_id = wrk_safe_query("obj2_get_cv_edu_part_id",'dsn',0,edu_part_id); 
				if(get_cv_edu_part_id.recordcount)
					var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" id="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:150px;" class="boxtext" readonly>';
			}
			else
			{
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" id="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" style="width:150px;" class="boxtext" readonly>';
			}
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><img src="/images/update_list.gif" alt="Güncelle" border="0" align="absbottom"></a>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" id="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_type' + row_edu + '" id="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_id' + row_edu + '" id="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_high_part_id' + row_edu + '" id="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" style="width:150px;" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_part_id' + row_edu + '" id="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" style="width:150px;" class="boxtext" readonly>';
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="hidden" name="is_edu_continue' + row_edu + '" id="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" style="width:150px;" class="boxtext" readonly>';
		} 
	}
	
	var extra_course = <cfif isdefined("get_emp_course")><cfoutput>'#get_emp_course.recordcount#'</cfoutput><cfelse>0</cfif>;
	
	function add_row_course()
	{
		extra_course++;
		document.getElementById('extra_course').value = extra_course;
		var newRow;
		var newCell;
		newRow = document.getElementById("add_course_pro").insertRow(document.getElementById("add_course_pro").rows.length);
		newRow.setAttribute("name","pro_course" + extra_course);
		newRow.setAttribute("id","pro_course" + extra_course);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kurs1_' + extra_course +'" id="kurs1_' + extra_course +'" style="width:115px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kurs1_yer' + extra_course +'" id="kurs1_yer' + extra_course +'"  style="width:115px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kurs1_exp' + extra_course +'" id="kurs1_exp' + extra_course +'" style="width:115px;"  maxlength="200">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kurs1_yil' + extra_course +'"  id="kurs1_yil' + extra_course +'"  style="width:115px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kurs1_gun' + extra_course +'"  id="kurs1_gun' + extra_course +'"  style="width:115px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + extra_course +'" id="del_course_prog' + extra_course +'"><a style="cursor:pointer" onclick="sil_(' + extra_course + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';
	}
</script>

