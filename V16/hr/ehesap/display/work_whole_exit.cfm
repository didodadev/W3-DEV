<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.department_id" default="">
 <cfquery name="get_branch" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,
		SSK_OFFICE,
		SSK_NO
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
						)
		</cfif>
	ORDER BY
		BRANCH_NAME,
		SSK_OFFICE
</cfquery>
<cfquery name="fire_reasons" datasource="#dsn#">
	SELECT REASON_ID,#dsn#.Get_Dynamic_Language(REASON_ID,'#session.ep.language#','SETUP_EMPLOYEE_FIRE_REASONS','REASON',NULL,NULL,REASON) AS REASON FROM SETUP_EMPLOYEE_FIRE_REASONS ORDER BY REASON
</cfquery>
<cfparam name="attributes.exitdate" default="">
<cf_catalystHeader>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Toplu','58057')#&nbsp#getLang('','İşten Çıkarmalar','52993')#">
		<cfform name="whole_exit_form" action="#request.self#?fuseaction=ehesap.emptypopup_work_exit" method="post">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<select name="branch" id="branch" onChange="listele();showDepartment(this.value);hide()">
								<option value=""><cf_get_lang dictionary_id='30126.Şube seçiniz'></option>
								<cfoutput query="get_branch">
									<cfif len(SSK_OFFICE) and len(SSK_NO)>
									<option value="#BRANCH_ID#">#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
									</cfif>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-departments">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" id="DEPARTMENT_PLACE">
							<select name="department" id="department" onchange="listele();hide()">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif attributes.branch eq 0 or attributes.branch eq ''>
								<cfelseif isdefined('attributes.branch') and attributes.branch is not "all">
									<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
										SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-exitdate">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'> *</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="exitdate" maxlength="10" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="exitdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-reason_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53643.Şirket İçi Gerekçe'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<select name="reason_id" id="reason_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="fire_reasons">
									<option value="#reason_id#">#reason#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-explanation_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52990.Gerekçe'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<select name="explanation_id" id="explanation_id">
								<cfloop list="#reason_order_list()#" index="ccc">
								<cfset value_name_ = listgetat(reason_list(),ccc,';')>
								<cfset value_id_ = ccc>
								<cfoutput><option value="#value_id_#">#value_name_#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-exit_detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='1687.Fazla karakter sayısıss'></cfsavecontent>
							<textarea name="exit_detail" id="exit_detail" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:330px;;height:60px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-IS_EMPTY_POSITION">
						<label class="bold"><input type="checkbox" name="IS_EMPTY_POSITION" id="IS_EMPTY_POSITION" value="1"><cf_get_lang dictionary_id='53419.Çıkış İşlemi Tamamlandığında Çalışan Pozisyonlarını da Boşalt'></label>
					</div>
					<div class="form-group" id="item-pass_branch">
						<label><input type="checkbox" name="pass_branch" id="pass_branch" onClick="gizle_goster('aktar');" value="1"><cf_get_lang dictionary_id='54197.Başka Bir Şubeye Giriş Yapmak İstiyorum'>.</label>
					</div>
					<div id="aktar" style="display:none">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
							</div>
						</div>
						<div class="form-group" id="item-entry_date">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="entry_date" style="width:180px;" maxlength="10" validate="#validate_style#" value="">
									<span class="input-group-addon"><cf_wrk_date_image date_field="entry_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<input type="hidden" name="branch_id" id="branch_id" value="">
								<input type="text" name="branch_" id="branch_" value="" readonly>
							</div>
						</div>
						<div class="form-group" id="item-department_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'>*</label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="department_id" id="department_id" value="">
									<cfinput type="text" name="department1" value="" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=whole_exit_form.department_id&field_name=whole_exit_form.department1&field_branch_name=whole_exit_form.branch_&field_branch_id=whole_exit_form.branch_id&is_all_departments=1</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_salary">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53211.Ücret Bilgileri Aktarılsın mı'></label>
							<label class="col col-3 col-xs-12"><input type="checkbox" name="is_salary" id="is_salary" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
						</div>
						<div class="form-group" id="item-is_salary_detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53225.Ödenek,Kesinti ve İstisnalar Aktarılsın mı?'></label>
							<label class="col col-3 col-xs-12"><input type="checkbox" name="is_salary_detail" id="is_salary_detail" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
						</div>
						<div class="form-group" id="item-is_accounting">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59550.Muhasebe Bilgileri Aktarılsın mı?'></label>
							<label class="col col-3 col-xs-12"><input type="checkbox" name="is_accounting" id="is_accounting" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
						</div>
						<div class="form-group" id="item-is_update_position">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53418.Pozisyon bilgileri güncellensin mi'>?</label>
							<label class="col col-3 col-xs-12"><input type="checkbox" name="is_update_position" id="is_update_position" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div id="list_branch_employee"></div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					
				</div>
				
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_workcube_buttons is_upd='0' add_function='list_control()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function listele()
{
		if(document.whole_exit_form.branch.value != '')
		{
			dep = '';
			if(document.getElementById('department').value!='')
			{
			dep = '&department_id='+document.getElementById('department').value;
			}
			var send_adress='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_work_exit_list&is_include=1&branch_id='+document.whole_exit_form.branch.value+dep</cfoutput>
			AjaxPageLoad(send_adress,'list_branch_employee',1,'Şube Çalışanları Listeleniyor.');
		}
	
		
}
function list_control()
{
	if(isDefined('worker_count')==false)
	{
	alert("<cf_get_lang dictionary_id='54602.Seçtiğiniz Şubede Çalışan Bulunamadı'>!");
	return false;
	}
	if(document.whole_exit_form.branch.value=='')
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57453.Şube'>");
		return false;
	}
	if(document.whole_exit_form.exitdate.value=='')
	{
		alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="29438.Çıkış Tarihi">');
		return false;
	}
	if(document.whole_exit_form.pass_branch.checked == true)
	{
		if(document.whole_exit_form.entry_date.value == '' || document.whole_exit_form.department_id.value == '')
			{
				alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="57628.Giriş Tarihi"> - <cf_get_lang dictionary_id="57453.Şube">');
				return false; 
			}
	}
}

function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&onchange_func=listele&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="54322.İlişkili Departmanlar">');
		}
	}
function hide() {
	$("#handle_id").remove();
}
</script>
