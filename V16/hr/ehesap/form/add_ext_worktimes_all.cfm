<cfparam  name="attributes.department" default="">
<cfparam  name="attributes.branch_id" default="">
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN 
		(
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = #SESSION.EP.POSITION_CODE#
		)
	</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_department_positions" datasource="#DSN#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME
		FROM
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EMPLOYEE_POSITIONS EP,
			</cfif>
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EP.IS_MASTER = 1 AND
			EP.COLLAR_TYPE = #attributes.collar_type# AND
			</cfif>
			E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
			<cfif isdefined("attributes.department") and len(attributes.department)>
				D.DEPARTMENT_ID = #attributes.department# AND
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				B.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			D.BRANCH_ID=B.BRANCH_ID AND
			EIO.FINISH_DATE IS NULL
		ORDER BY
			E.EMPLOYEE_NAME
	</cfquery>
</cfif>
<cfquery name="GET_PROCESS_STAGE" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.IS_STAGE_BACK,
		PTR.LINE_NUMBER
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.list_ext_worktimes%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53596.Fazla Mesai Toplu Giriş"></cfsavecontent>
<cfset pageHead = "#message#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_worktime_search" action="" method="post">
			<input name="is_submit" id="is_submit" type="hidden" value="1">
			<cf_box_search plus="0">
				<div class="form-group" id="item-branch_id">
					<div id="BRANCH_PLACE">
						<select name="branch_id" id="branch_id" onchange="showDepartment(this.value)">
							<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
							<cfoutput query="ALL_BRANCHES" group="branch_id">
								<option value="#branch_id#"<cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div id="DEPARTMENT_PLACE">
						<select name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='53200.Departman Seçiniz'></option>
							<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
								<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
									SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_department">
									<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group">
					<select name="collar_type" id="collar_type">
						<option value=""><cf_get_lang dictionary_id ='54054.Yaka Tipi'></option>
						<option value="1" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='54055.Mavi Yaka'></option> 
						<option value="2" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='54056.Beyaz Yaka'></option>
					</select> 
				</div>
				<div class="form-group">
					<label><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box>
		<cfform name="add_worktime" action="#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_all" method="post">
			<input name="record_num" id="record_num" type="hidden" value="1">
			<cf_grid_list id="link_table">
				<thead>
					<tr>
						<cfoutput>
							<th colspan="2"></th>
							<th><cf_get_lang dictionary_id='53598.Toplu Tarih Ekleme'></th>
							<th width="100">
								<div class="form-group">
									<div class="input-group">
										<input  type="hidden"  value="1"  name="row_kontrol_0" id="row_kontrol_0">						
										<cfinput type="text" name="startdate0" value="" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="startdate0" call_function="hepsi_startdate"></span>
									</div>
								</div>
							</th>
							<th width="100">
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="start_hour0"  value="0" onChange="hepsi(row_count,'start_hour');">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="start_min0" id="start_min0"  onChange="hepsi(row_count,'start_min');">
											<option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
											<cfloop from="0" to="59" index="i">
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</th>
							<th width="100">
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="end_hour0" value="0" onChange="hepsi(row_count,'end_hour');">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="end_min0" id="end_min0" onChange="hepsi(row_count,'end_min');">
											<option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
											<cfloop from="0" to="59" index="i">
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</th>
							<th>
								<div class="form-group">
									<select name="process_stage0" id="process_stage0" onChange="hepsi(row_count,'process_stage');">
										<cfloop query="get_process_stage">
											<option value="#process_row_id#">#stage#</option>
										</cfloop>
									</select>
								</div>
							</th>
							<th>
								<div class="form-group">
									<select name="Shift_Status0" id="Shift_Status0" onclick="tik();" onChange="hepsi(row_count,'Shift_Status');">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
										<option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
									</select>
								</div>
							</th>
							<th width="100">
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53014.Normal Gün'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type0" id="day_type0" value="0" checked onClick="hepsi_check(row_count,'day_type');"></div>
							</th>
							<th width="100">
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53015.Hafta Sonu'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type0" id="day_type0" value="1" onClick="hepsi_check(row_count,'day_type');"></div>
							</th>
							<th width="100">
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53016.Resmi Tatil'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type0" id="day_type0" value="2" onClick="hepsi_check(row_count,'day_type');"></div>
							</th>
							<th width="130">
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='54251.Gece Çalışması'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type0" id="day_type0" value="3" onClick="hepsi_check(row_count,'day_type');"></div>
							</th>
							<th>
								<div class="form-group" id="item-Working_Location">
									<select name="Working_Location0" id="Working_Location0" onChange="hepsi(row_count,'Working_Location');">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang Dictionary_id='38672.Kurum İçi'></option>
										<option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
										<option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
										<option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
									</select>
								</div>
							</th>
						</cfoutput>
					</tr>
					<tr>
						<th width="10"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th width="120"><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='53066.Başlangıç Saati'></th>
						<th><cf_get_lang dictionary_id='53067.Bitiş Saati'></th>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></th>
						<th colspan="4" class="text-center"><cf_get_lang dictionary_id='53599.Mesai Türü'></th>
						<th width="80"><cf_get_lang dictionary_id='32327.Çalışmak istediği yer'></th>
					</tr>
				</thead>
				<tbody>
					<cfif isdefined("get_department_positions.recordcount") and get_department_positions.recordcount>
						<cfoutput query="get_department_positions">
						<tr id="my_row_#currentrow#">
							<td><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
										<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#">
										<input name="employee#currentrow#" id="employee#currentrow#" type="text" value="#employee_name# #employee_surname#" onFocus="AutoComplete_Create('employee#currentrow#','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD','employee_id#currentrow#,employee_in_out_id#currentrow#,department#currentrow#','add_worktime','3','225');">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.employee_in_out_id#currentrow#&field_emp_name=add_worktime.employee#currentrow#&field_emp_id=add_worktime.employee_id#currentrow#&field_branch_and_dep=add_worktime.department#currentrow#&is_active=1');"></span>
									</div>
								</div>
							</td>
							<td><div class="form-group"><input name="department#currentrow#" id="department#currentrow#" type="text" readonly value="#branch_name# / #department_head#"></div></td>
							<td>
								<input type="hidden"  value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>						
								<cfinput type="text" name="startdate#currentrow#" value="" maxlength="10" validate="#validate_style#" message="#alert#">
								<cf_wrk_date_image date_field="startdate#currentrow#">
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="start_hour#currentrow#" value="0">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="start_min#currentrow#" id="start_min#currentrow#">
											<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
											<cfloop from="1" to="59" index="i">
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="end_hour#currentrow#" value="0">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="end_min#currentrow#" id="end_min#currentrow#">
											<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
											<cfloop from="1" to="59" index="i">
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="process_stage#currentrow#" id="process_stage#currentrow#">
										<cfloop query="get_process_stage">
											<option value="#process_row_id#">#stage#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="Shift_Status#currentrow#" id="Shift_Status#currentrow#" onclick="tik();">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
										<option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
									</select>
								</div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53489.NG'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type#currentrow#" id="day_type#currentrow#" value="0" checked></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53490.HT'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type#currentrow#" id="day_type#currentrow#" value="1"></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53491.GT'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type#currentrow#" id="day_type#currentrow#" value="2"></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='54251.Gece Çalışması'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type#currentrow#" id="day_type#currentrow#" value="3"></div>
							</td>
							<td>
								<div class="form-group" id="item-Working_Location">
									<select name="Working_Location#currentrow#" id="Working_Location#currentrow#">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang Dictionary_id='38672.Kurum İçi'></option>
										<option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
										<option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
										<option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
									</select>
								</div>
							</td>
						</tr>
						</cfoutput>
					<cfelse>
						<tr id="my_row_1">
							<td><a onclick="sil(1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id1" id="employee_id1" value="">
										<input type="hidden" name="employee_in_out_id1" id="employee_in_out_id1" value="">
										<input name="employee1" type="text" id="employee1" onFocus="AutoComplete_Create('employee1','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD','employee_id1,employee_in_out_id1,department1','add_worktime','3','225');">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.employee_in_out_id1&field_emp_name=add_worktime.employee1&field_emp_id=add_worktime.employee_id1&field_branch_and_dep=add_worktime.department1&is_active=1');"></span>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<input name="department1" id="department1" type="text" readonly value="">
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input  type="hidden"  value="1"  name="row_kontrol_1" id="row_kontrol_1">						
										<cfinput type="text" name="startdate1" value="" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="startdate1"></span>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="start_hour1"value="0">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="start_min1" id="start_min1">
											<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
											<cfloop from="1" to="59" index="i">
												<cfoutput>
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-xs-12">
										<cf_wrkTimeFormat name="end_hour1" value="0">
									</div>
									<div class="col col-6 col-xs-12">
										<select name="end_min1" id="end_min1">
											<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
												<cfloop from="1" to="59" index="i">
												<cfoutput>
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="process_stage1" id="process_stage1">
										<cfoutput query="get_process_stage">
											<option value="#process_row_id#">#stage#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="Shift_Status1" id="Shift_Status1" onclick="tik();">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
										<option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
									</select>
								</div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53489.NG'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type1" id="day_type1" value="0" checked></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53490.HT'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type1" id="day_type1" value="1"></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='53491.GT'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type1" id="day_type1" value="2"></div>
							</td>
							<td>
								<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='54251.Gece Çalışması'></label>
								<div class="col col-3 col-xs-12"><input type="radio" name="day_type1" id="day_type1" value="3"></div>
							</td>
							<td>
								<div class="form-group" id="item-Working_Location">
									<select name="Working_Location1" id="Working_Location1">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang Dictionary_id='38672.Kurum İçi'></option>
										<option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
										<option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
										<option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
									</select>
								</div>
							</td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("get_department_positions") and get_department_positions.recordcount>
		row_count=<cfoutput>#get_department_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=1;
	</cfif>
	function hepsi_startdate()
	{
		hepsi(row_count,'startdate');
	}
	function hepsi(satir,nesne)
	{
		deger=eval("document.add_worktime."+nesne+"0");
		
		for(var i=1;i<=satir;i++)
		{
			nesne_tarih=eval("document.add_worktime."+nesne+i);
			nesne_tarih.value=deger.value;
		}
	}
	function tik()
	{
		
		if (document.getElementById('Shift_Status'+row_count).value == 1)
		{  
			document.getElementById('is_puantaj_off').checked = true;
		}
		else
		{
			document.getElementById('is_puantaj_off').checked = false;
		}
		
	}
	
	function hepsi_check(satir,nesne)
	{
		deger=eval(document.add_worktime.day_type0)
		for(var j=0;j<=deger.length-1;j++)
		{
			if(deger[j].checked==true)
			{
				sec=deger[j].value;
			}
		}
		for(var i=1;i<=satir;i++)
		{
			nesne_check=eval("document.add_worktime.day_type"+i);
			nesne_check[sec].checked=true;
		}
	}

	function sil(sy)
	{
		var my_element=eval("add_worktime.row_kontrol_"+sy);
		my_element.value=0;
		/*row_count--;*/
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;		
		document.add_worktime.record_num.value=row_count;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"><input type="hidden" value="" id="employee_id' + row_count +'" name="employee_id' + row_count +'">';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="hidden" id="employee_in_out_id' + row_count +'" value="" name="employee_in_out_id' + row_count +'"><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" value="" onFocus="AutoComplete_Create(\'employee' + row_count + '\',\'FULLNAME\',\'FULLNAME,BRANCH_NAME\',\'get_in_outs_autocomplete\',\'\',\'EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD\',\'employee_id' + row_count + ',employee_in_out_id' + row_count + ',department' + row_count + '\',\'add_worktime\',\'3\',\'225\');"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_worktime.employee_in_out_id'+ row_count + '&field_emp_name=add_worktime.employee'+ row_count + '&field_emp_id=add_worktime.employee_id'+ row_count + '&is_active=1&field_branch_and_dep=add_worktime.department'+ row_count + '\');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="department'+row_count+'" id="department' + row_count +'" type="text" readonly value=""></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","startdate" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="startdate' + row_count +'" name="startdate' + row_count +'" class="text" maxlength="10" value=""> ';
		wrk_date_image('startdate' + row_count);
		
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="startdate' + row_count +'" name="startdate' + row_count +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="edate_'+row_count+'"></span></div></div>';		
		wrk_date_image('startdate' + row_count);
		$('#edate_'+row_count).append($('#startdate'+row_count+'_image'));

		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-xs-12"><cf_wrktimeformat name="start_hour' + row_count + '"></div><div class="col col-6 col-xs-12"><select name="start_min' + row_count + '"><option value="0"><cf_get_lang dictionary_id='58827.Dk'></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-xs-12"><cf_wrktimeformat name="end_hour' + row_count + '"></div><div class="col col-6 col-xs-12"><select name="end_min' + row_count + '"><option value="0"><cf_get_lang dictionary_id='58827.Dk'></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage' + row_count +'"  id="process_stage' + row_count +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<div class="form-group"><select name="Shift_Status' + row_count +'" id="Shift_Status' + row_count +'" onclick="tik();"><option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option><option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option></select></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id="53489.NG"></label><div class="col col-3 col-xs-12"><input type="radio" name="day_type' + row_count + '" value="0" checked></div>';
			
		newCell = newRow.insertCell(newRow.cells.length); 
		newCell.innerHTML = '<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id="53490.HT"></label><div class="col col-3 col-xs-12"><input type="radio" name="day_type' + row_count + '" value="1"></div>';

		newCell = newRow.insertCell(newRow.cells.length); 
		newCell.innerHTML = '<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id="53491.GT"></label><div class="col col-3 col-xs-12"><input type="radio" name="day_type' + row_count + '" value="2"></div>';

		newCell = newRow.insertCell(newRow.cells.length); 
		newCell.innerHTML = '<label class="col col-9 col-xs-12"><cf_get_lang dictionary_id="54251.Gece Çalışması"></label><div class="col col-3 col-xs-12"><input type="radio" name="day_type' + row_count + '" value="3"></div>';

		newCell = newRow.insertCell(newRow.cells.length); 
		newCell.innerHTML = '<div class="form-group"><select name="Working_Location' + row_count +'" id="Working_Location' + row_count +'"><option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang Dictionary_id='38672.Kurum İçi'></option><option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option><option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option><option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option></select></div>';
	}

	function kontrol()
	{
		document.add_worktime.record_num.value=row_count;
		if(row_count == 0)
		{
		alert("<cf_get_lang dictionary_id='53600.Fazla Mesai Girişi Yapmadınız'>!");
		return false;
		}

		for(var j=0;j<=row_count;j++)
		{
			tarih_nesne=eval("document.add_worktime.startdate"+j);
			if(!CheckEurodate(tarih_nesne.value,j+'. Tarih'))
			{ 
			tarih_nesne.focus();
			return false;
			}
		}
		return true;
	}	
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="54322.İlişkili Departmanlar">');
		}
	}
</script>
