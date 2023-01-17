<cfinclude template="../query/get_offtime_cats.cfm">
<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.offtimes%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.branch_id") or isdefined("attributes.department") or isdefined("attributes.company_id")>
	<cfquery name="get_department_positions" datasource="#DSN#">
		SELECT 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			EIO.EMPLOYEE_ID,
			EIO.START_DATE,
			EIO.DEPARTMENT_ID,
			EIO.BRANCH_ID,
			OC.COMP_ID,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_ID,
			D.BRANCH_ID,
			D.OUR_COMPANY_ID,
			B.BRANCH_NAME,
			B.BRANCH_ID,
			B.COMPANY_ID,
			EI.TC_IDENTY_NO,
			EI.EMPLOYEE_ID
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			OUR_COMPANY OC,
			DEPARTMENT D WITH (NOLOCK),
			BRANCH B,
			EMPLOYEES_IDENTY EI
		WHERE
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = OC.COMP_ID AND
			EIO.FINISH_DATE IS NULL 
			<cfif isdefined("attributes.company_id")>
				 AND OC.COMP_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.department")>
				 AND D.DEPARTMENT_ID = #attributes.department#
			</cfif>
			<cfif isdefined("attributes.branch_id")>
				 AND B.BRANCH_ID=#attributes.branch_id# 
			</cfif>
		ORDER BY
			E.EMPLOYEE_NAME
	</cfquery>
</cfif>
<cfquery name="ALL_COMPANIES" datasource="#DSN#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<script>
	function get_used_offtime(aa)
	{
		var emp_id_ = eval("document.add_offtime.employee_id" + aa + '.value');
		var emp_in_out_ = eval("document.add_offtime.employee_in_out_id" + aa + '.value');
		var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&emp_id='+emp_id_;
		send_address+='&emp_in_out='+emp_in_out_;
		send_address+='&type='+2; 
		send_address+='&active_row='+aa; 
		div_id_ = 'used_off' + aa;
		AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
	}
</script>
<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='54278.İzin Planlama'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title#">
		<cfform name="add_offtime" action="#request.self#?fuseaction=ehesap.emptypopup_add_offtime_plan" method="post">
			<input name="record_num" id="record_num" type="hidden" value="<cfif isdefined("attributes.branch_id") or isdefined("attributes.department") or isdefined("attributes.company_id")><cfoutput>#get_department_positions.recordcount#</cfoutput><cfelse>1</cfif>">
			<input name="process_stage" id="process_stage" type="hidden" value="<cfoutput>#GET_PROCESS_STAGE.PROCESS_ROW_ID#</cfoutput>">	
			<cf_box_search more="0">
				<div class="form-group">
					<select name="company_id" id="company_id" onChange="showBranch(this.value)">
						<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
						<cfoutput query="ALL_COMPANIES">
							<option value="#COMP_ID#"<cfif isdefined("attributes.company_id") and (comp_id eq attributes.company_id)>selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="BRANCH_PLACE">
					<select name="branch_id" id="branch_id" onchange="showDepartment(branch_id);">
						<cfif not isdefined("attributes.company_id")>
							<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
							<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
							<cfquery name="get_branchs" dbtype="query">
								SELECT BRANCH_ID, BRANCH_NAME FROM get_our_comp_and_branchs WHERE COMP_ID = #attributes.company_id#
							</cfquery>
							<cfoutput query="get_branchs">
								<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>
				<div class="form-group large" id="DEPARTMENT_PLACE">
					<select name="department" id="department">
						<cfif not isdefined("attributes.branch_id")>
							<option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
						<cfelseif isdefined('attributes.branch_id') and len(attributes.branch_id)>
							<option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
							<cfquery name="get_department" datasource="#dsn#">
								SELECT 
									DEPARTMENT_ID, 
									DEPARTMENT_HEAD
								FROM 
									DEPARTMENT 
								WHERE 
									BRANCH_ID = #attributes.branch_id# and DEPARTMENT_STATUS =1 AND IS_STORE <> 1 
								ORDER BY 
									DEPARTMENT_HEAD
							</cfquery>
							<cfoutput query="get_department">
								<option value="#department_id#"<cfif isdefined('attributes.department') and (department_id eq attributes.department)>selected</cfif>>#DEPARTMENT_HEAD#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>							
				<cfoutput>
					<div class="form-group small" id="item-"> 
						<select name="calc_offtime" id="calc_offtime" onchange="get_offtime_calc();">
							<option value="0"><cf_get_lang dictionary_id='59562.İzin Günü Hesapla'></option>
							<cfloop from="1" to="12" index="cc">								
								<option value="#cc#"<cfif isdefined("attributes.calc_offtime") and attributes.calc_offtime eq cc>selected</cfif>>#cc#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group" id="item-">
						 <cfsavecontent  variable="head"><cf_get_lang dictionary_id='53598.Toplu Tarih Ekleme'></cfsavecontent>
						<div class="input-group">
							<input  type="hidden"  value="1"  name="row_kontrol_0" id="row_kontrol_0">						
							<input type="text" name="startdate0" id="startdate0" readonly="yes" value="" placeHolder="#head#" maxlength="10">                					
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate0" call_function="hepsi_startdate"></span>
						</div>
					</div>
					<div class="form-group small" id="item-">
						<select name="start_hour0" id="start_hour0" onChange="hepsi(row_count,'start_hour');">
							<option value="0">s</option>
							<cfloop from="1" to="23" index="i">
								<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small" id="item-">
						<select name="start_min0" id="start_min0"  onChange="hepsi(row_count,'start_min');">
							<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
							<cfloop from="1" to="59" index="i">
								<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group" id="item-">
						<div class="input-group">					
							<input type="text" name="finishdate0" id="finishdate0" readonly value="" maxlength="10" placeHolder="#head#">									
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate0" call_function="hepsi_finishdate"></span>
						</div>
					</div>
					<div class="form-group small" id="item-">
						<select name="end_hour0" id="end_hour0" onChange="hepsi(row_count,'end_hour');">
							<option value="0">s</option>
							<cfloop from="1" to="23" index="i">
								<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small" id="item-">
						<select name="end_min0" id="end_min0" onChange="hepsi(row_count,'end_min');">
							<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
							<cfloop from="1" to="59" index="i">
								<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group" id="item-">
						<label><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>			
					</div>			
				</cfoutput>
				<div class="form-group">
					<cf_wrk_search_button search_function="open_form_ajax()" button_type="4">							
				</div>
			</cf_box_search>
			<cf_grid_list sort="0">
				<thead>
					<tr>
						<th width="20"><i class="fa fa-plus" onClick="add_row();"></i></th>
						<th width="120"><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th style="width:80px"><cf_get_lang dictionary_id='54265.TC No'></th>
						<th style="width:80px"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
						<th><cf_get_lang dictionary_id='53348.İşe giriş tarihi'></th>
						<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
						<th width="100"><cf_get_lang dictionary_id='53066.Başlangıç saati'></th>
						<th width="130"><cf_get_lang dictionary_id='57700.bitiş tarihi'></th>
						<th width="100"><cf_get_lang dictionary_id='53067.Bitiş saati'></th>
						<th width="30"><cf_get_lang dictionary_id='54269.izin günü'></th>
						<th><cf_get_lang dictionary_id='59563.Kullanılan'> - <cf_get_lang dictionary_id ='58444.Kalan'></th>
						<th style="width:80px"><cf_get_lang dictionary_id='54109.İzin Kategorisi'></th>
					</tr>
				</thead>
				<tbody id="link_table"> 
					<cfif isdefined("attributes.branch_id") or isdefined("attributes.department") or isdefined("attributes.company_id")>
						<cfoutput query="get_department_positions">
							<input type="hidden"  value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
							<tr id="my_row_#currentrow#">
								<td class="text-center"><a onclick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
								<td>
									<div class="form-group">
                                        <div class="input-group">
											<cfinput type="hidden" required="yes" id="employee_id#currentrow#" message="Alanı boş bırakmayın" name="employee_id#currentrow#" value="#employee_id#">
											<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#">																
											<input name="employee#currentrow#" id="employee#currentrow#" type="text" value="#employee_name# #employee_surname#" onFocus="AutoComplete_Create('employee#currentrow#','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD,TC_IDENTY_NO,START_DATE','employee_id#currentrow#,employee_in_out_id#currentrow#,department#currentrow#,tcno#currentrow#,work_startdate#currentrow#','add_offtime','3','225');"> 
											<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="calisan_popup_ac(#currentrow#);"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="tcno#currentrow#" id="tcno#currentrow#" maxlength="11" value="#TC_IDENTY_NO#"/>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input name="department#currentrow#" id="department#currentrow#" type="text" readonly value="#branch_name# / #department_head#">
									</div>
								</td>
								<td><!---İşe Giriş Tarihi--->
									<div class="form-group">
                                        <div class="input-group">
											<cfsavecontent variable="alert"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>						
											<cfinput type="text" name="work_startdate#currentrow#" value="#dateformat(start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#alert#">
											<cf_wrk_date_image date_field="work_startdate#currentrow#">
										</div>
									</div>
								</td>
								<td><!---Başlangıç tarihi--->
									<div class="form-group">
                                        <div class="input-group">
											<cfsavecontent variable="alert"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>						
											<cfinput type="text" name="startdate#currentrow#" value="" maxlength="10" validate="#validate_style#" message="#alert#">
											<cf_wrk_date_image date_field="startdate#currentrow#">
										</div>
									</div>
								</td>
								<td><!---Başlangıç Saati--->
									<div class="form-group">
										<div class="col col-6 col-sm-6">
											<select name="start_hour#currentrow#" id="start_hour#currentrow#">
												<option value="0">s</option>
												<cfloop from="1" to="23" index="i">
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfloop>
											</select>
										</div>
										<div class="col col-6 col-sm-6">
											<select name="start_min#currentrow#" id="start_min#currentrow#">
												<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
												<cfloop from="1" to="59" index="i">
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfloop>
											</select>
										</div>
									</div>
								</td>
								<td><!---Bitiş Tarihi--->
									<div class="form-group">
                                        <div class="input-group">
											<cfsavecontent variable="alert"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>			
											<div id="finish_time#currentrow#">	
												<cfif isdefined("attributes.off_day")>	
													<cf_date tarih="attributes.start_date">
													<cfset yeni_tarih=dateadd('d',attributes.off_day,attributes.start_date)>		
													<input type="text" name="finishdate#currentrow#" id="finishdate#currentrow#" readonly="yes" value="<cfoutput>#yeni_tarih#</cfoutput>" maxlength="10">
												<cfelse>
													<input type="text" name="finishdate#currentrow#" id="finishdate#currentrow#" readonly="yes" value="" maxlength="10">
												</cfif>
											<cf_wrk_date_image date_field="finishdate#currentrow#" call_function="get_offtime_day" call_parameter="#currentrow#"></div></td>
										</div>
									</div>
								<td><!---Bitiş Saati--->
									<div class="form-group">
										<div class="col col-6 col-sm-6">
											<select name="end_hour#currentrow#" id="end_hour#currentrow#">
												<option value="0">s</option>
												<cfloop from="1" to="23" index="i">
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfloop>
											</select>
										</div>
										<div class="col col-6 col-sm-6">
											<select name="end_min#currentrow#" id="end_min#currentrow#">
												<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
												<cfloop from="1" to="59" index="i">
													<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
												</cfloop>
											</select>
										</div>
									</div>
								</td>
								<td><!---izin günü--->
									<div class="form-group">
										<div id="offtime#currentrow#">
											<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")>
												<cf_date tarih="attributes.start_date">
												<cf_date tarih="attributes.finish_date">
												<cfset diff=datediff('d',attributes.start_date,attributes.finish_date)>
												<input type="text" name="offtime_day#currentrow#" id="offtime_day#currentrow#" value="#diff#" onblur="get_finishdate(#currentrow#);" />
											<cfelse>
												<input type="text" name="offtime_day#currentrow#" id="offtime_day#currentrow#" value="" onblur="get_finishdate(#currentrow#);" />
											</cfif>
										</div>
									</div>	
									<!---<input type="text" name="offtime_day#currentrow#" />--->
								</td>
								<td><!---kullanılan izin--->
									<div class="form-group">
                                        <div class="input-group">
											<div id="used_off#currentrow#">
												<input type="text" name="used_offtime#currentrow#" id="used_offtime#currentrow#" value="" /> 
												<input type="text" name="remain_offtimes#currentrow#" id="remain_offtimes#currentrow#" value="" /> 
												<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="get_used_offtime(#currentrow#);"></span>
											</div>
										</div>
									</div>
								</td>
								<td><!---izin kategorisi--->
									<div class="form-group">
										<select name="offtimecat_id#currentrow#" id="offtimecat_id#currentrow#">
											<cfloop query="get_offtime_cats">
												<option value="#offtimecat_id#">#offtimecat#</option>
											</cfloop>
										</select>
									</div>
								</td>
							</tr>
							<script>
								get_used_offtime(#currentrow#);
							</script>
						</cfoutput>
					<cfelse>
						<input  type="hidden"  value="1"  name="row_kontrol_1" id="row_kontrol_1">
						<tr id="my_row_1">
							<td class="text-center"><a onclick="sil(1);" ><i class="fa fa-minus"></i></a></td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id1" id="employee_id1" value="">
										<input type="hidden" name="employee_in_out_id1" id="employee_in_out_id1" value="">		
										<input name="employee1" type="text" id="employee1" onFocus="AutoComplete_Create('employee1','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD,TC_IDENTY_NO,START_DATE','employee_id1,employee_in_out_id1,department1,tcno1,work_startdate1','add_offtime','3','225');"> 
										<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="calisan_popup_ac(1);"></span>
									</div>
								</div>
							</td>
							<td><input type="text" name="tcno1" id="tcno1" maxlength="11" value="" /></td>
							<td>
								<input name="department1" id="department1" type="text" readonly value="">
							</td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<cfinput type="text" name="work_startdate1" readonly="yes" value="" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate1"></span>
									</div>
								</div>	
							</td>
							<td>		
								<div class="form-group">
									<div class="input-group">			
										<cfinput type="text" name="startdate1" value="" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="startdate1"></span>
									</div>
								</div>	
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
										<select name="start_hour1" id="start_hour1">
											<option value="0">s</option>
											<cfloop from="1" to="23" index="i">
											<cfoutput>
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfoutput>
											</cfloop>
										</select>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
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
							<div id="finish_time1">	
								<div class="form-group">
									<div class="input-group">
										<cfif isdefined("attributes.off_day")>	
											<cf_date tarih="attributes.start_date">
											<cfset yeni_tarih=dateadd('d',attributes.off_day,attributes.start_date)>		
											<cfinput type="text" name="finishdate1" value="#yeni_tarih#" maxlength="10">
										<cfelse>
											<cfinput type="text" name="finishdate1" value="" maxlength="10">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate1" call_function="get_offtime_day" call_parameter="1"></span>
									</div>
								</div>
							</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
										<select name="end_hour1" id="end_hour1">
											<option value="0">s</option>
											<cfloop from="1" to="23" index="i">
											<cfoutput>
												<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
											</cfoutput>
											</cfloop>
										</select>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
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
							<td><!---izin günü--->
								<div id="offtime1">
									<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")>
										<cf_date tarih="attributes.start_date">
										<cf_date tarih="attributes.finish_date">
										<cfset diff=datediff('d',attributes.start_date,attributes.finish_date)>
										<input type="text" name="offtime_day1" id="offtime_day1" value="<cfoutput>#diff#</cfoutput>" onblur="get_finishdate(1);" />
									<cfelse>
										<input type="text" name="offtime_day1" id="offtime_day1" value="" onblur="get_finishdate(1);" />
									</cfif>
								</div>
							</td>
							<td><!---kullanılan izin--->
								<div id="used_off1">
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="used_offtime1" id="used_offtime1" value="" /> 
											<input type="text" name="remain_offtimes1" id="remain_offtimes1" value="" /> 
											<span class="input-group-addon" href="javascript://" onclick="get_used_offtime(1)"><i class="fa fa-bookmark-o"></i></span>
										</div>
									</div>
								</div>
							</td>
							<td>
								<select name="offtimecat_id1" id="offtimecat_id1">
								<cfoutput query="get_offtime_cats">
									<option value="#offtimecat_id#">#offtimecat#</option>
								</cfoutput>
								</select>
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
	function get_offtime_day(aa)
	{
			
		var start_ = eval("document.add_offtime.startdate"+ aa + ' .value');
		var finish_ = eval("document.add_offtime.finishdate"+ aa + ' .value'); 
		var izinType = eval("document.add_offtime.offtimecat_id"+ aa + ' .value');
		if(start_ != ''){
			var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&start_date='+start_;
			send_address+='&finish_date='+finish_;
			send_address+='&type='+0; 
			send_address+='&active_row='+aa; 
			send_address+='&izinType='+izinType; 
			div_id_ = 'offtime' + aa;
			AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
		}else{
			alert("<cf_get_lang dictionary_id='41039.Başlangıç Tarihi Giriniz'>!");
			return false;
		}
	}
	
	function get_finishdate(aa)
	{		
		var off_day=eval('document.add_offtime.offtime_day'+ aa +'.value');
		var start_ = eval('document.add_offtime.startdate'+ aa + ' .value');
		var izinType = eval("document.add_offtime.offtimecat_id"+ aa + ' .value');
		if(off_day != '' && start_!= '')
		{
			var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&start_date='+start_;
			send_address+='&off_day='+off_day;
			send_address+='&type='+1;
			send_address+='&active_row='+aa;
			send_address+='&izinType='+izinType;
			div_id_ = 'finish_time'+aa;
			AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
		}else{
			if(start_ == '')
			{ 
				alert("<cf_get_lang dictionary_id='41039.Başlangıç Tarihi Giriniz'>");
			}else if(off_day == ''){
				alert("<cf_get_lang dictionary_id='54269.İzin Günü'>!");	
			}
			return false;
		}			
	}
	
	function calisan_popup_ac(sira_no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_offtime.employee_in_out_id'+ sira_no + '&field_emp_name=add_offtime.employee'+ sira_no + '&field_emp_id=add_offtime.employee_id'+ sira_no + '&field_branch_and_dep=add_offtime.department'+ sira_no + '&field_start_date=add_offtime.work_startdate'+ sira_no + '&field_tcno=add_offtime.tcno'+ sira_no +'&call_function=get_used_offtime('+sira_no+')');
	}
	
	function get_offtime_calc()
	{
		for(var j=1;j<=row_count;j++)
		{
			var emp_id = eval("document.add_offtime.employee_id" + j + '.value');
			var emp_in_out_no = eval("document.add_offtime.employee_in_out_id" + j + '.value');
			var off_calc=eval(document.add_offtime.calc_offtime.value);
			if(off_calc<1 || off_calc>12)
			{
				alert("<cf_get_lang dictionary_id='54629.Lütfen 1-12 değerleri arası bir rakam giriniz'>!");
			}
			else
			{
				var get_offtime_plan = wrk_safe_query('hr_offtime_plan','dsn',j,emp_in_out_no);
				if(get_offtime_plan.recordcount)
				{
					var tarih=date_format(get_offtime_plan.FINISHDATE);
					tarih = date_add("m",off_calc,tarih);
					var start = eval('document.add_offtime.startdate'+j);
					start.value=tarih;
				}
				else
				{
					var get_offtime_in_out = wrk_safe_query('hr_offtime_in_out','dsn',j,emp_in_out_no);
					if(get_offtime_in_out.recordcount)
					{
						var tarih=date_format(get_offtime_in_out.START_DATE);
						tarih = date_add("m",off_calc,tarih);
						var start = eval('document.add_offtime.startdate'+j);
						start.value=tarih;
					}
					else
						alert("<cf_get_lang dictionary_id='54631.Böyle bir kayıt yok'>");
					
				}
			}
		}
	}
	
	function showDepartment(branch_id)	
	{
		var branch_id = document.add_offtime.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
			myList.appendChild(txtFld);
		}
	}
	function showBranch(comp_id)	
	{
		var comp_id = document.getElementById('company_id').value;
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
		}
		else
		{
			document.getElementById('branch_id').value = "";document.getElementById('department').value ="";
			var myList = document.getElementById("branch_id");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57453.Şube">'));
			myList.appendChild(txtFld);
		}
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="55770.İlişkili Departmanlar">');
	}	

	function hepsi_startdate()
	{
		hepsi(row_count,'startdate');
	}
	function hepsi_finishdate()
	{
		hepsi(row_count,'finishdate');
	}
	function hepsi(satir,nesne)
	{
		deger=eval("document.add_offtime."+nesne+"0");
		
		for(var i=1;i<=satir;i++)
		{
			nesne_tarih=eval("document.add_offtime."+nesne+i);
			nesne_tarih.value=deger.value;
			if(nesne=='finishdate')
				{
				get_offtime_day(i);
				}
		}
	}

	function sil(sy)
	{
		var my_element=eval("add_offtime.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
					
		document.add_offtime.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="1" name="row_kontrol_' + row_count +'"><input type="hidden" value="" id="employee_id' + row_count +'"  name="employee_id' + row_count +'"><input type="hidden" value="" name="employee_in_out_id' + row_count +'"><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" value="" onFocus="AutoComplete_Create(\'employee\' + row_count,\'FULLNAME\',\'FULLNAME,BRANCH_NAME\',\'get_in_outs_autocomplete\',\'\',\'EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD,TC_IDENTY_NO,START_DATE\',\'employee_id\' + row_count + \',employee_in_out_id\' + row_count + \',department\' + row_count + \',tcno\' + row_count + \',work_startdate\'+ row_count,\'add_offtime\',\'3\',\'225\');"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="calisan_popup_ac(' + row_count + ');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" maxlength="11" name="tcno' + row_count +'"></div>';		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="department'+row_count+'" type="text" readonly value=""></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","work_startdate" + row_count + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="work_startdate' + row_count +'" name="work_startdate' + row_count +'" readonly="yes" maxlength="10" value=""><span class="input-group-addon btn_Pointer" id="sdate_'+row_count+'"></span></div></div>';
		wrk_date_image('work_startdate' + row_count);
		$('#sdate_'+row_count).append($('#work_startdate'+row_count+'_image'));

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","startdate" + row_count + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="startdate' + row_count +'" name="startdate' + row_count +'" maxlength="10" value=""><span class="input-group-addon btn_Pointer" id="mdate_'+row_count+'"></span></div></div>';
		wrk_date_image('startdate' + row_count);
		$('#mdate_'+row_count).append($('#startdate'+row_count+'_image'));

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-sm-6"><select name="start_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div><div class="col col-6 col-sm-6"><select name="start_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","finishdate" + row_count + "_td");
		newCell.setAttribute("name","finishdate" + row_count + "_td");
		newCell.innerHTML = '<div id="finish_time'+row_count+'">';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><cfif isdefined("attributes.off_day")><cf_date tarih="attributes.start_date"><cfset yeni_tarih=dateadd('d',attributes.off_day,attributes.start_date)><input type="text" id="finishdate'+ row_count +'" name="finishdate'+ row_count +'" value="<cfoutput>#yeni_tarih#</cfoutput>" maxlength="10"><cfelse><input type="text" id="finishdate'+ row_count +'" name="finishdate'+ row_count +'" value="" maxlength="10" style="width:65px"></cfif><span class="input-group-addon btn_Pointer" id="fdate_'+row_count+'"></span></div></div> ';
		newCell.innerHTML+= '</div>';
		wrk_date_image('finishdate' + row_count,'get_offtime_day('+ row_count+')');
		$('#fdate_'+row_count).append($('#finishdate'+row_count+'_image'));

	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-sm-6"><select name="end_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div><div class="col col-6 col-sm-6"><select name="end_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="offtime_day' + row_count +'">';
		newCell.innerHTML = '<div id="offtime'+row_count+'"><div class="form-group"><cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")><cf_date tarih="attributes.start_date"><cf_date tarih="attributes.finish_date"><cfset diff=datediff('d',attributes.start_date,attributes.finish_date)><input type="text" name="offtime_day'+ row_count +'" value="<cfoutput>#diff#</cfoutput>" onblur="get_finishdate('+ row_count +');" />
		<cfelse><input type="text" name="offtime_day'+ row_count +'" value="" onblur="get_finishdate('+ row_count +');" /></cfif></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div id="used_off'+ row_count +'"><div class="input-group"><input type="text" value="" name="used_offtime' + row_count +'"><input type="text" name="remain_offtimes' + row_count +'" value=""/><span class="input-group-addon" href="javascript://" onclick="get_used_offtime('+ row_count +')"><i class="fa fa-bookmark-o"></i></span></div></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="offtimecat_id' + row_count + '"><cfoutput query="get_offtime_cats"><option value="#offtimecat_id#">#offtimecat#</option></cfoutput></select></div>';
		
	}

	function kontrol()
	{
		document.add_offtime.record_num.value=row_count;
		if(row_count == 0)
		{
		alert("<cf_get_lang dictionary_id='54281.İzin planlama Girişi Yapmadınız'>!");
		return false;
		}
		
		
		for(var j=1;j<=row_count;j++)
		{
			if(eval('document.add_offtime.row_kontrol_'+j+'.value')==1)
			{
				var emp = eval('document.add_offtime.employee_id'+j+'.value');
				if(emp == '')
				{
					alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="57576.Çalışan">');
					return false;
				}
			
				var start_tarih = eval('document.add_offtime.startdate'+j+'.value');
				if(start_tarih == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>");
					return false;
				}
			
				var finish_tarih = eval('document.add_offtime.finishdate'+j+'.value');
				if(finish_tarih == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'>");
					return false;
				}
			}
		}
		return true;
	}	
	function open_form_ajax()
	{	
			var adres_='<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=add-plan</cfoutput>';
			
			if(document.add_offtime.branch_id.value != '')
				{
					adres_ = adres_ + '&branch_id=' + document.add_offtime.branch_id.value;
				}
			if(document.add_offtime.department.value != '')
				{
					adres_ = adres_ + '&department=' + document.add_offtime.department.value;
				}
			if(document.add_offtime.company_id.value != '')
				{
					adres_ = adres_ + '&company_id=' + document.add_offtime.company_id.value;
				}
			window.location.href=adres_;
			return false;
 	}	
</script>
<div style="background-color:#000000;"></div>