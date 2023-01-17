<cfset xfa.upd= "hr.emptypopup_upd_app_pos">
<cfset xfa.del= "hr.emptypopup_del_app_pos">
<cfquery name="get_app" datasource="#dsn#"><!---gerekli query--->
	SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=#attributes.app_pos_id#
</cfquery>
<cfif isdefined('attributes.empapp_id')>
  <cfquery name="get_empapp" datasource="#dsn#">
  SELECT EMPAPP_ID,NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID=#attributes.empapp_id#
  </cfquery>
</cfif>
<cfif get_app.recordcount or get_empapp.recordcount>
	<cfif len(GET_APP.POSITION_ID)>
		<cfset attributes.POSITION_CODE = GET_APP.POSITION_ID>
		<cfquery name="get_position" datasource="#dsn#">
			SELECT
				POSITION_ID,
				POSITION_CODE,
				POSITION_NAME,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			FROM
				EMPLOYEE_POSITIONS
			WHERE
				POSITION_CODE = #GET_APP.POSITION_ID#
		</cfquery>
		<cfset app_position = "#GET_POSITION.POSITION_NAME#">
	<cfelse>
		<cfset attributes.POSITION_CODE = "">
		<cfset app_position = "">
	</cfif>
	<cfif len(GET_APP.POSITION_CAT_ID)>
		<cfset attributes.position_cat_id = GET_APP.POSITION_CAT_ID>
		<cfinclude template="../query/get_position_cat.cfm">
		<cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
	<cfelse>
		<cfset attributes.position_cat_id = "">
		<cfset position_cat = "">
	</cfif>
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_commethods.cfm">
<!--- Sayfa ana kısım  --->
<cfset pageHead = #getLang('hr',31)# &" : " &get_empapp.name & " " &get_empapp.surname>
<cf_catalystHeader>
<!---Geniş alan: içerik--->
<cfform action="#request.self#?fuseaction=#xfa.upd#" name="emp_pos_detail" method="post" enctype="multipart/form-data">
	<div class="row">
		<div class="col col-9 col-xs-12 uniqueRow">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="33130.Başvuru Detay"></cfsavecontent>
			<cf_box title="#message#" closable="0">
				<cf_box_elements>
					<input type="hidden" value="<cfoutput>#attributes.app_pos_id#</cfoutput>" name="app_pos_id" id="app_pos_id">
					<input type="hidden" value="<cfoutput>#get_app.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
						<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-app_pos">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55247.Başvuru No'></label>
								<div class="col col-8 col-xs-12">
									<label><cfoutput>#get_app.app_pos_id#</cfoutput></label>
								</div>
							</div>
							<div class="form-group" id="item-app_pos">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="empapp_name" id="empapp_name" value="<cfif isdefined('attributes.empapp_id')><cfoutput>#get_empapp.name# #get_empapp.surname#</cfoutput></cfif>" readonly>
								</div>
							</div>
							<div class="form-group" id="item-process_stage">
								<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value ='#get_app.app_stage#' process_cat_width='150' is_detail='1'>
								</div>
							</div>
							<div class="form-group" id="item-notice_head">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55159.İlan'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_app.notice_id)>
											<cfquery name="get_notice" datasource="#dsn#">
												SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_app.notice_id#
											</cfquery>
											<input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#get_app.notice_id#</cfoutput>">
											<input type="hidden" name="notice_no" id="notice_no" value="<cfoutput>#get_notice.NOTICE_NO#</cfoutput>">
											<input type="text" name="notice_head" id="notice_head" value="<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>" style="width:150px;">
										<cfelse>
											<input type="hidden" name="notice_id" id="notice_id" value="">
											<input type="hidden" name="notice_no" id="notice_no" value="">
											<input type="text" name="notice_head" id="notice_head" value="" style="width:150px;">
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=emp_pos_detail.notice_id&field_no=emp_pos_detail.notice_no&field_name=emp_pos_detail.notice_head&field_comp=emp_pos_detail.company&field_comp_id=emp_pos_detail.company_id&field_department_id=emp_pos_detail.department_id&field_department=emp_pos_detail.department&field_branch_id=emp_pos_detail.branch_id&field_branch=emp_pos_detail.branch&&field_our_company_id=emp_pos_detail.our_company_id&field_pos_id=emp_pos_detail.position_id&field_pos_name=emp_pos_detail.app_position');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-position_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#get_app.position_cat_id#</cfoutput>">
										<input type="text" name="position_cat" id="position_cat" style="width:150px;" value="<cfoutput>#POSITION_CAT#</cfoutput>" readonly>
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=emp_pos_detail.position_cat_id&field_cat=emp_pos_detail.position_cat');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-app_position">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="Hidden" name="position_id" id="position_id" value="<cfoutput>#get_app.position_id#</cfoutput>" maxlength="50">
										<input type="text" name="app_position" id="app_position" style="width:150px;" value="<cfoutput>#app_position#</cfoutput>" readonly>
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=emp_pos_detail.position_id&field_pos_name=emp_pos_detail.app_position&show_empty_pos=1');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-department">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_app.department_id) and len(get_app.our_company_id)>
											<cfquery name="get_our_company" datasource="#dsn#">
												SELECT BRANCH.BRANCH_NAME, BRANCH.BRANCH_ID, DEPARTMENT.DEPARTMENT_HEAD, DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT, BRANCH WHERE BRANCH.COMPANY_ID=#get_app.our_company_id# AND BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID AND BRANCH.BRANCH_ID=#get_app.branch_id# AND DEPARTMENT.DEPARTMENT_ID=#get_app.department_id#
											</cfquery>
										</cfif>
										<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#get_app.our_company_id#</cfoutput>">
										<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_app.department_id#</cfoutput>">
										<input type="text" name="department" id="department" value="<cfif IsDefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>" style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=emp_pos_detail.department_id&field_name=emp_pos_detail.department&field_branch_name=emp_pos_detail.branch&field_branch_id=emp_pos_detail.branch_id&field_our_company_id=emp_pos_detail.our_company_id</cfoutput>');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-company">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" value="<cfoutput>#get_app.company_id#</cfoutput>" name="company_id" id="company_id">
										<input type="text" name="company" id="company" value="<cfif len(get_app.company_id)><cfoutput>#get_par_info(get_app.company_id,1,0,0)#</cfoutput></cfif>" style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=emp_pos_detail.company_id&field_comp_name=emp_pos_detail.company&select_list=7');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-detail_app">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58649.Ön Yazı'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail_app" id="detail_app" style="width:450px;height:30px;"><cfif len(get_app.detail)><cfoutput>#get_app.detail#</cfoutput></cfif></textarea>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-app_pos_status">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-8 col-xs-12">
									<label><input type="Checkbox" name="app_pos_status" id="app_pos_status" value="1" <cfif get_app.app_pos_status eq 1>checked</cfif>></label>
								</div>
							</div>
							<div class="form-group" id="item-app_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55434.Başvuru Tarihi'>*</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55434.Başvuru Tarihi'></cfsavecontent>
										<cfinput type="text" style="width:150px;" name="app_date" value="#dateformat(get_app.app_date,dateformat_style)#" required="yes" validate="#validate_style#" maxlength="10" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="app_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-salary_wanted_money">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55740.İstenen Ücret'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="salary_wanted" style="width:100px;" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(get_app.salary_wanted)#" class="moneybox">
										<span class="input-group-addon width">
											<select name="salary_wanted_money" id="salary_wanted_money" style="width:48px;">
												<cfoutput query="get_moneys">
												<option value="#money#" <cfif get_app.salary_wanted_money eq money>selected</cfif>>#money# 
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-STARTDATE_IF_ACCEPTED">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55154.İşe Başlama Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='55327.kabul edildiğiniz takdirde işe başlayabileceğiniz tarih'></cfsavecontent>
										<cfinput type="text" name="STARTDATE_IF_ACCEPTED" style="width:150px;" value="#dateformat(get_app.STARTDATE_IF_ACCEPTED,dateformat_style)#" validate="#validate_style#" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="STARTDATE_IF_ACCEPTED"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-branch">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_app.branch_id#</cfoutput>">
									<input type="text" name="branch" id="branch" value="<cfif IsDefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.branch_name#</cfoutput></cfif>" style="width:150px;" readonly>
								</div>
							</div>
							<div class="form-group" id="item-commethod_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
								<div class="col col-8 col-xs-12">
									<select name="commethod_id" id="commethod_id" style="width:150px;">
										<cfoutput query="get_commethods">
											<option value="#commethod_id#" <cfif get_app.commethod_id eq commethod_id>selected</cfif>>#commethod# 
										</cfoutput>
									</select>
								</div>
							</div>
							<!--- <tr>
							<td><cf_get_lang no='719.Onay Durumu'></td>
							<td>
								<input type="hidden" name="validator_position_code" id="validator_position_code" value="<cfoutput>#get_APP.validator_position_code#</cfoutput>">
								<cfif len(get_APP.validator_position_code)>
									<cfset attributes.position_code = get_APP.validator_position_code>
									<cfset attributes.employee_id = "">
									<cfinclude template="../query/get_position.cfm">
									<cfset pos_temp = "#get_position.employee_name# #get_position.employee_surname#">
									<cfelse>
									<cfset pos_temp = "">
								</cfif>
								<cfinput type="text" name="position" style="width:150px;"  value="#pos_temp#" maxlength="50">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=emp_pos_detail.validator_position_code&field_emp_name=emp_pos_detail.position','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> </td>
							<td><!--- <cf_get_lang_main no='70.Aşama'> ---></td>
							<td>
								<!--- <cf_workcube_process 
									is_upd='0' 
									select_value ='0'
									process_cat_width='150'
									is_detail='1'> --->
							</td>
							</tr> --->
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6 col-xs-12">
							<cf_record_info query_name="get_app">
						</div>
						<div class="col col-6 col-xs-12">
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
						</div>
					</cf_box_footer>
			</cf_box>
			<cf_box 
				id="all_app"
				closable="0"
				title="#getlang('','Tüm Başvurular','35223')#"
				box_page="#request.self#?fuseaction=hr.emptypopup_hr_reference_ajax&app_pos_id=#attributes.app_pos_id#&empapp_id=#attributes.empapp_id#"
				add_href="#request.self#?fuseaction=hr.apps&event=add&app_pos_id=#attributes.app_pos_id#&empapp_id=#attributes.empapp_id#"></cf_box>
			<cf_box
				id="corr_"
				title="#getlang('','Yazışmalar','57459')#"
				closable="0"
				box_page="#request.self#?fuseaction=hr.emptypopup_hr_correspon_ajax&empapp_id=#attributes.empapp_id#"
				add_href="openBoxDraggable('#request.self#?fuseaction=hr.popup_app_add_mail&empapp_id=#attributes.empapp_id#')"></cf_box>
		</div>
		<div class="col col-3 col-xs-12">
			<div class="row">
				<cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='EMPLOYEES_APP_ID' action_id='#empapp_id#'>
				<cf_get_workcube_note action_section='EMPLOYEES_APP_ID' action_id='#empapp_id#'>
				<!---form generator daki değerlendirme formları kullanılacak py 20121001--->
				<!---<cfif isdefined('attributes.empapp_id')>
					<cfset url_adress="#request.self#?fuseaction=hr.popup_app_empapp_list_quizs&empapp_id=#attributes.empapp_id#&form_type=2&is_cv=1">
				<cfelse>
					<cfset url_adress ="#request.self#?fuseaction=hr.popup_app_empapp_list_quizs&form_type=2&is_cv=1">
				</cfif>
				<cf_box
					id="analyse"
					closable="0"
					title="Değerlendirmeler"
					box_page="#request.self#?fuseaction=hr.emptypopup_hr_assessment_ajax&empapp_id=#attributes.empapp_id#"
					add_href="#url_adress#"></cf_box>--->
			</div>
		</div>
	</div>
</cfform>
<cfelse>
	<label class="bold"><cf_get_lang dictionary_id='56182.Kayıt Silinmiş Olabilir Detayı Gösterilemiyor'>..</label>
</cfif>
<script type="text/javascript">
function kontrol()
{
	if ((document.emp_pos_detail.detail_app.value.length)>1000)
	{
		alert("<cf_get_lang dictionary_id='56180.Ön yazı alanının uzunluğu 1000 karakterden az olmalıdır'>!");
		return false;
	}
	document.emp_pos_detail.salary_wanted.value = filterNum(document.emp_pos_detail.salary_wanted.value);
	/*return  process_cat_control(); aşama kontrol*/
	return true;
}
</script>

