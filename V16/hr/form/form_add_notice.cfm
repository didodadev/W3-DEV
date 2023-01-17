<cf_papers paper_type="emp_notice">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset notice_no = system_paper_no>
<cfset attributes.start_date = DateFormat(now(),dateformat_style)>
<cfset attributes.finishdate = DateFormat(date_add('d',15,now()),dateformat_style)>
<cfif isdefined("attributes.per_req_id")><!---personel istek formundan oluşturuluyorsa--->
	<cfquery name="get_per_req" datasource="#dsn#">
		SELECT
			*
		FROM
			PERSONEL_REQUIREMENT_FORM
		WHERE
			PERSONEL_REQUIREMENT_ID = #attributes.per_req_id#
	</cfquery>
	<cfif len(get_per_req.our_company_id)>
		<cfquery name="get_dep" datasource="#dsn#">
			SELECT 
				ZONE.ZONE_NAME,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				DEPARTMENT.DEPARTMENT_ID,
				OUR_COMPANY.NICK_NAME,
				OUR_COMPANY.COMP_ID
			FROM 
				DEPARTMENT,
				BRANCH,
				ZONE,
				OUR_COMPANY
			WHERE 
				OUR_COMPANY.COMP_ID = #get_per_req.our_company_id# AND
				BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
				BRANCH.BRANCH_ID= #get_per_req.branch_id# AND
				DEPARTMENT_ID = #get_per_req.department_id# AND
				ZONE.ZONE_ID = BRANCH.ZONE_ID
		</cfquery>
	</cfif>
	<cfif len(get_per_req.POSITION_ID)>
		<cfquery name="get_position_name" datasource="#dsn#">
		SELECT
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.POSITION_CODE = #get_per_req.POSITION_ID#
		</cfquery>
		<cfset app_position = "#get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#">
	<cfelse>
		<cfset app_position = "-">
	</cfif>
	<cfif len(get_per_req.POSITION_CAT_ID)>
		<cfset attributes.POSITION_CAT_ID = get_per_req.POSITION_CAT_ID>
		<cfinclude template="../query/get_position_cat.cfm">
		<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
	<cfelse>
		<cfset POSITION_CAT = "">
	</cfif>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_notice" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_notice" enctype="multipart/form-data">
			<input type="hidden" name="system_paper_no" id="system_paper_no" value="<cfif isdefined('system_paper_no')><cfoutput>#system_paper_no#</cfoutput></cfif>">
			<input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfif isdefined('system_paper_no_add')><cfoutput>#system_paper_no_add#</cfoutput></cfif>">
			<cf_box_elements>
				<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-notice_no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55250.İlan No'>*</label>
						<div class="col col-9 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55250.ilan no'>!</cfsavecontent>
							<cfinput type="text" name="notice_no" id="notice_no" value="#notice_no#" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-notice_head">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55761.İlan Başlığı'>*</label>
						<div class="col col-9 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfsavecontent>
							<cfinput type="text" name="notice_head" id="notice_head" maxlength="100" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-pif_name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56204.Personel İstek Formu'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="pif_id" id="pif_id" value="<cfif isdefined("get_per_req.personel_requirement_id") and len(get_per_req.personel_requirement_id)><cfoutput>#get_per_req.personel_requirement_id#</cfoutput></cfif>">
								<input type="text" name="pif_name" id="pif_name" value="<cfif isdefined("get_per_req.personel_requirement_head") and len(get_per_req.personel_requirement_head)><cfoutput>#get_per_req.personel_requirement_head#</cfoutput></cfif>" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_personel_requirement&field_id=add_notice.pif_id&field_name=add_notice.pif_name</cfoutput>','list');" title="Seçim Listesi Seç"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-position_cat">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfif isdefined("get_per_req.position_cat_id") and len(get_per_req.position_cat_id)><cfoutput>#get_per_req.position_cat_id#</cfoutput></cfif>">
								<input type="text" name="position_cat" id="position_cat" value="<cfif isdefined("get_per_req.position_cat_id") and len(get_per_req.position_cat_id)><cfoutput>#position_cat#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_notice.position_cat_id&field_cat=add_notice.position_cat','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-app_position">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58497.Poziyon'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="position_id" id="position_id" value="<cfif isdefined("get_per_req.position_id") and len(get_per_req.position_id)><cfoutput>#get_per_req.position_id#</cfoutput></cfif>">
								<input type="text" name="app_position" id="app_position" value="<cfif isdefined("get_per_req.position_id") and len(get_per_req.position_id)><cfoutput>#app_position#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_notice.position_id&field_pos_name=add_notice.app_position&field_dep_name=add_notice.department&field_dep_id=add_notice.department_id&field_branch_name=add_notice.branch&field_branch_id=add_notice.branch_id&field_comp=add_notice.our_company&field_comp_id=add_notice.our_company_id&show_empty_pos=1','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
						<div class="col col-9 col-xs-12"> 
							<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_dep.department_id") and len(get_dep.department_id)><cfoutput>#get_dep.department_id#</cfoutput></cfif>">
							<input type="text" name="department" id="department" <cfif isdefined("get_dep.department_head") and len(get_dep.department_head)>value="<cfoutput>#get_dep.department_head#</cfoutput>"</cfif> readonly>
						</div>
					</div>
					<div class="form-group" id="item-interview_position">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55597.Bağlantı kurulacak Kişi'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="interview_position_code" id="interview_position_code" value="">
								<input type="hidden" name="interview_par" id="interview_par" value="">
								<cfinput type="text" name="interview_position" id="interview_position" value="">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_notice.interview_position_code&field_emp_name=add_notice.interview_position&field_partner=add_notice.interview_par&field_name=add_notice.interview_position&select_list=1,2','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-publish">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55516.Yayın Alanı'></label>
						<div class="col col-3 col-xs-12"> 
							<label><input type="checkbox" name="publish" id="publish" value="1"><cf_get_lang dictionary_id='55435.İnternet'></label>
						</div>
						<div class="col col-3 col-xs-12">
							<label><input type="checkbox" name="publish" id="publish" value="2"><cf_get_lang dictionary_id='29659.Intranet'></label>
						</div>
						<div class="col col-3 col-xs-12">
							<label><input type="checkbox" name="publish" id="publish" value="3"><cf_get_lang dictionary_id='58019.Extranet'></label>
						</div>
					</div>
					<div class="form-group" id="item-view_logo">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'></label>
						<div class="col col-3 col-xs-12"> 
							<label><input type="checkbox" name="view_logo" id="view_logo" value="1"> (<cf_get_lang dictionary_id='56314.Görünsün'>) - <cf_get_lang dictionary_id='57574.Şirket'></label> 
						</div>
						<div class="col col-3 col-xs-12"> 
							<label><input type="checkbox" name="view_company_name" id="view_company_name" value="1"> (<cf_get_lang dictionary_id='56314.Görünsün'>)</label>
						</div>
					</div>
					<div class="form-group" id="item-view_visual_notice">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56315.Görsel İlan'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="file" name="visual_notice" id="visual_notice">
								<span class="input-group-addon" href="javascript://" id="val_del_visual" onclick="del_visual_notice();"><i class="fa fa-minus"></i></span>							
							</div>
							<label><input type="checkbox" name="view_visual_notice" id="view_visual_notice" value="1">(<cf_get_lang dictionary_id='56314.Görünsün'>)</label>
						</div>
					</div>
					<div class="form-group" id="item-dates">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="31639.Yayın Tarihi"></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" value="#attributes.start_date#"  validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfinput type="text" name="finishdate" id="finishdate" value="#attributes.finishdate#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"> </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-status">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-9 col-xs-12"> 
							<input type="checkbox" name="status" id="status" value="1" checked>
						</div>
					</div>
					<div class="form-group" id="item-status_notice">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-9 col-xs-12"> 
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-staff_count">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56205.Kadro Sayısı'></label>
						<div class="col col-9 col-xs-12"> 
							<cfif isdefined("get_per_req.PERSONEL_COUNT")>
								<cfinput type="text" validate="integer" name="staff_count" id="staff_count" value="#get_per_req.PERSONEL_COUNT#" maxlength="2" message="Kadro Sayısını Giriniz!">
							<cfelse>
								<cfinput type="text" validate="integer" name="staff_count" id="staff_count" value="" maxlength="2" message="Kadro Sayısını Giriniz!">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" value="" name="company_id" id="company_id">
								<cf_wrk_members form_name='add_notice' member_name='company' company_id='company_id' select_list='2'>
								<input type="text" name="company" id="company" value="" onkeyup="get_member();" maxlength="100">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_notice.company_id&field_comp_name=add_notice.company&select_list=7','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-our_company">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-9 col-xs-12"> 
							<input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined("get_dep.comp_id") and len(get_dep.comp_id)><cfoutput>#get_dep.comp_id#</cfoutput></cfif>">
							<input type="text" name="our_company" id="our_company" value="<cfif isdefined("get_dep.comp_id") and len(get_dep.comp_id)><cfoutput>#get_dep.nick_name#</cfoutput></cfif>"readonly>
						</div>
					</div>
					<div class="form-group" id="item-branch">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-9 col-xs-12"> 
							<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("get_dep.branch_id") and len(get_dep.branch_id)><cfoutput>#get_dep.branch_id#</cfoutput></cfif>">
							<input type="text" name="branch" id="branch" value="<cfif isdefined("get_dep.branch_name") and len(get_dep.branch_name)><cfoutput>#get_dep.branch_name#</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-validator_position">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55282.Onaylayacak'>*</label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="validator_position_code" id="validator_position_code" value="">
								<input type="hidden" name="validator_par" id="validator_par" value="">
								<cfinput type="text" name="validator_position" id="validator_position" value="">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_notice.validator_position_code&field_emp_name=add_notice.validator_position&field_partner=add_notice.validator_par&field_name=add_notice.validator_position&select_list=1,2','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-city">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56209.Çalışılacak İller'></label>
						<div class="col col-9 col-xs-12"> 
							<cfquery name="get_city" datasource="#dsn#">
								SELECT CITY_ID, CITY_NAME, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
							</cfquery>
							<select name="city" id="city" multiple>
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0"><cf_get_lang dictionary_id='56175.Tüm Türkiye'></option>
								<cfoutput query="get_city">
									<option value="#city_id#">#city_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-notice_cat_id">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='56510.İlan Grubu'></label>
						<div class="col col-9 col-xs-12"> 
							<cf_wrk_combo 
								name="notice_cat_id"
								id="notice_cat_id"
								query_name="GET_NOTICE_GROUP"
								option_name="notice"
								option_value="notice_cat_id"
								width="150">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_elements vertical="1">
				<div class="col col-12 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-work_detail">
						<label class="bold"><cf_get_lang dictionary_id='56206.İşin Tanımı'></label> 
							<textarea name="work_detail" id="work_detail"><cfif isdefined("get_per_req.personel_detail") and len(get_per_req.personel_detail)><cfoutput>#get_per_req.personel_detail#</cfoutput></cfif></textarea>					
					</div>
					<div class="form-group" id="item-detail">
						<label class="bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarSet="WRKContent"
								basePath="/fckeditor/"
								instanceName="detail"
								valign="top"
								value=""
								width="490"
								height="270">
					</div>
				</div>							
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12"><cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">

function del_visual_notice()
	{
		document.getElementById('visual_notice').style.display='';	
		add_notice.visual_notice.value='';
	}
function kontrol()
{
	var notice_no = document.getElementById('notice_no').value;
	var get_notice_no_query = wrk_safe_query('hr_notice_no_qry','dsn',0,notice_no);

	var run_query = wrk_safe_query('hr_notice_detail','dsn',0,'<cfoutput>#paper_code#</cfoutput>');
	if(get_notice_no_query.recordcount)
	{
		alert("<cf_get_lang dictionary_id='35808.Aynı İlan No İle Kayıt Var'>! <cf_get_lang dictionary_id='55971.Yeni Numara Atanacaktır'>!");
		var run_query = wrk_safe_query('hr_notice_detail','dsn',0,'<cfoutput>#paper_code#</cfoutput>');
		var notice_num = parseFloat(run_query.BIGGEST_NUMBER) + 1;
		var notice_num_join = '<cfoutput>#paper_code#</cfoutput>' + '-' + notice_num;
		document.getElementById('notice_no').value = notice_num_join;
		document.getElementById('system_paper_no_add').value = notice_num;
	}
	
	/*if (add_notice.app_position.value.length == 0) add_notice.position_cat_id.value = "";*/
	if (document.getElementById('position_cat').value.length == 0) document.getElementById('position_cat_id').value = "";

	
	if((document.getElementById('department').value.length != 0) && (document.getElementById('company').value.length != 0))
	{
		alert("<cf_get_lang dictionary_id='56210.İlgili Firma veya Departmandan Birini Seçmelisiniz'> !");
		document.getElementById('department_id').value = "";
		document.getElementById('department').value = "";
		document.getElementById('branch').value = "";
		document.getElementById('branch_id').value = "";
		document.getElementById('company').value = "";
		document.getElementById('company_id').value = "";
		document.getElementById('company').value = "";
		document.getElementById('company_id').value = "";
		return false;
	}
	
	var validator_position_code_ =  document.getElementById('validator_position_code').value ;
	if (validator_position_code_ == '' )
	{
		alert("<cf_get_lang dictionary_id='53524.Onaylayacak Kişi Seçiniz'>!");
		return false;
	}
		
	if ((document.getElementById('work_detail').value.length)>1000)
	{
		alert("<cf_get_lang dictionary_id='56207.İş tanımı 1000 karakterden fazla olamaz'>!");
		return false;
	}
	return true;
}
</script>
