<cfparam name="attributes.related_year" default="#session.ep.period_year#">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_ext_worktime" datasource="#dsn#">
    SELECT
        EMPLOYEES_EXT_WORKTIMES.START_TIME,
        EMPLOYEES_EXT_WORKTIMES.END_TIME,
        EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
        EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME,
        YEAR(EMPLOYEES_EXT_WORKTIMES.START_TIME) AS PERIOD,
        EMPLOYEES_EXT_WORKTIMES.RECORD_DATE,
        EMPLOYEES_EXT_WORKTIMES.RECORD_EMP,
        EMPLOYEES_EXT_WORKTIMES.RECORD_IP,
        EMPLOYEES_EXT_WORKTIMES.EWT_ID,
        EMPLOYEES_EXT_WORKTIMES.UPDATE_DATE,
        EMPLOYEES_EXT_WORKTIMES.UPDATE_EMP,
        EMPLOYEES_EXT_WORKTIMES.VALID_DETAIL,
		EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE,
		EMPLOYEES_EXT_WORKTIMES.WORKTIME_WAGE_STATU,
		EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME
    FROM
        EMPLOYEES_EXT_WORKTIMES,
        EMPLOYEES
    WHERE
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
		AND EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        AND YEAR(EMPLOYEES_EXT_WORKTIMES.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#">
</cfquery>
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.popup_add_emp_ext_worktimes%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_EMP_DET" datasource="#dsn#">
	SELECT
		*
	FROM
	 EMPLOYEES_IN_OUT EIO
	 LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
	WHERE
        EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		AND (EIO.FINISH_DATE IS NOT NULL AND E.EMPLOYEE_STATUS = 0)
</cfquery>
<cf_box title="#getLang('','Fazla Mesailer',56018)# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

		<cf_box_search>
			<cfform name="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_add_emp_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
				<cf_box_search>
					<div class="form-group">
						<select name="related_year" id="related_year">
							<cfloop from="#year(now())+2#" to="2008" index="i" step="-1">
							<cfoutput>
								<option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
							</cfoutput>
							</cfloop>
						</select>
					</div>
					<div class="form-group">
						<!--- Ücret Odenek Ajaxından --->
						<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
							<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
							<label id="ajax_label" style="display:none!important;"></label>
							<cf_wrk_search_button search_function="ajax_function()">
						<cfelse>
							<cf_wrk_search_button search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#" button_type="4">
						</cfif>
					</div>
				</cf_box_search>
			</cfform>
		</cf_box_search>
		<cfsavecontent variable="cf_wrktimeformat_info"><cf_wrkTimeFormaT name='start_hour' value='9'></cfsavecontent>
		<div id="cf_wrktimeformat" style="display:none;"><cfoutput>#cf_wrktimeformat_info#</cfoutput></div>
		<cfsavecontent variable="cf_wrktimeformat_info_2"><cf_wrkTimeFormaT name='end_hour' value='17'></cfsavecontent>
		<div id="cf_wrktimeformat_2" style="display:none;"><cfoutput>#cf_wrktimeformat_info_2#</cfoutput></div>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="52970.Fazla Mesailer"></cfsavecontent>
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_emp_ext_worktime">
				<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
				<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
				<input type="hidden" name="rowCount" id="rowCount" value="">
				<input type="hidden" name="rowCount_sabit" id="rowCount_sabit" value="<cfoutput>#get_ext_worktime.recordcount#</cfoutput>">
				<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
					<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
				</cfif>
				<cf_grid_list id="table_list" sort="0">
					<thead>
						<tr>
						<cfif not get_emp_det.recordCount><th width="35"><a onClick="add_row();"><i class="fa fa-plus" title="Ekle"></i></th></cfif>
						<th width="100"><cf_get_lang dictionary_id='55753.Çalışma Günü'>*</th>
						<th  width="100"><cf_get_lang dictionary_id='60723.Bordro Tarihi'>*</th>
						<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
						<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
						<th  width="115"><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th width="130"><cf_get_lang dictionary_id='64573.Mesai Karşılığı'></th>
						<th><cf_get_lang dictionary_id='53599.Mesai Türü'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						</tr>
					</thead>
					<cfoutput query="get_ext_worktime" group="PERIOD">
						<tbody id="my_div_#PERIOD#">
							<cfoutput>
							<input type="hidden" name="sabit_worktimes_id#currentrow#" id="sabit_worktimes_id#currentrow#" value="#EWT_ID#">
							<input type="hidden" name="sabit_row_kontrol_#currentrow#" id="sabit_row_kontrol_#currentrow#" value="1">
							<tr id="sabit_my_row_#currentrow#" title="<cfif len(record_date)>Kayıt : #get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif>  <cfif len(update_date)> &nbsp;&nbsp;&nbsp;&nbsp; Güncelleme : #get_emp_info(update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif>">
								<cfif not get_emp_det.recordCount><td width="35"><a style="cursor:pointer;" onClick="sabit_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" border="0"></i></a></td></cfif>
								<td>
									<div class="form-group">
										<div class="input-group">	
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>					
											<cfinput type="text" name="sabit_work_startdate#currentrow#" id="sabit_work_startdate#currentrow#"  value="#dateformat(get_ext_worktime.work_start_time,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
											<span class="input-group-addon"><cf_wrk_date_image date_field="sabit_work_startdate#currentrow#"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group">	
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>					
											<cfinput type="text" name="sabit_startdate#currentrow#" id="sabit_startdate#currentrow#" value="#dateformat(get_ext_worktime.start_time,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
											<span class="input-group-addon"><cf_wrk_date_image date_field="sabit_startdate#currentrow#"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="col col-6 col-xs-6">
											<cf_wrkTimeFormat name="sabit_my_row_start_hour" id="sabit_my_row_start_hour" index="#currentrow#" value="#timeformat(get_ext_worktime.start_time,'HH')#">	
										</div>
										<div class="col col-6 col-xs-6">
											<select name="sabit_my_row_start_min#currentrow#" id="sabit_my_row_start_min#currentrow#">
												<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
												<cfloop from="1" to="59" index="i">
													<option value="#i#"<cfif timeformat(get_ext_worktime.start_time,'MM') eq i>selected</cfif>>#i#</option>
												</cfloop>
											</select>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="col col-6 col-xs-6">
											<cf_wrkTimeFormat name="sabit_my_row_end_hour" id="sabit_my_row_end_hour" index="#currentrow#" value="#timeformat(get_ext_worktime.end_time,'HH')#">
										</div>
										<div class="col col-6 col-xs-6">
											<select name="sabit_my_row_end_min#currentrow#" id="sabit_my_row_end_min#currentrow#">
												<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
												<cfloop from="1" to="59" index="i">
													<option value="#i#"<cfif timeformat(get_ext_worktime.end_time,'MM') eq i>selected</cfif>>#i#</option>
												</cfloop>
											</select>
										</div>
								</td>
								<td>
									<div class="form-group">
										<select name="sabit_process_stage#currentrow#" id="sabit_process_stage#currentrow#">
											<cfloop query="get_process_stage">
												<option value="#process_row_id#" <cfif get_ext_worktime.process_stage eq process_row_id>selected</cfif>>#stage#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="sabit_Shift_Status#currentrow#" id="sabit_Shift_Status#currentrow#">
											<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif get_ext_worktime.WORKTIME_WAGE_STATU EQ 1>selected</cfif>><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
											<option value="2" <cfif get_ext_worktime.WORKTIME_WAGE_STATU EQ 2>selected</cfif>><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="sabit_my_row_day_type#currentrow#" id="sabit_my_row_day_type#currentrow#">
											<option value="0" <cfif get_ext_worktime.DAY_TYPE EQ 0>selected</cfif>><cf_get_lang dictionary_id='53014.Normal Gün'></option>
											<option value="1" <cfif get_ext_worktime.DAY_TYPE EQ 1>selected</cfif>><cf_get_lang dictionary_id='53015.Hafta Sonu'></option>
											<option value="2" <cfif get_ext_worktime.DAY_TYPE EQ 2>selected</cfif>><cf_get_lang dictionary_id='53016.Resmi Tatil'></option>
											<option value="3" <cfif get_ext_worktime.DAY_TYPE EQ 3>selected</cfif>><cf_get_lang dictionary_id='54251.Gece Çalışması'></option>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<textarea name="sabit_my_row_valid_detail#currentrow#" id="sabit_my_row_valid_detail#currentrow#" style="width:90px;height:30px;">#get_ext_worktime.valid_detail#</textarea>
									</div>
								</td>
							</tr>
							</cfoutput>
						</tbody>
					</cfoutput>
				</cf_grid_list>
				<cf_box_footer>
					<cf_record_info query_name="get_ext_worktime">
					<cfif not get_emp_det.recordCount><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></cfif>
				</cf_box_footer>
			</cfform>
</cf_box>
<script type="text/javascript">
	rowCount_sabit = <cfif get_ext_worktime.recordcount><cfoutput>#get_ext_worktime.recordcount#</cfoutput><cfelse>0</cfif>;
	rowCount = 0;
	sayac=1;
	function add_row()
	{
		sayac++;
		rowCount++;
		var newRow;
		var newCell;
		newRow = table_list.insertRow();
		newRow.className = 'color-row';
		newRow.setAttribute("name","my_row_" + rowCount);
		newRow.setAttribute("id","my_row_" + rowCount);		
		newRow.setAttribute("NAME","my_row_" + rowCount);
		newRow.setAttribute("ID","my_row_" + rowCount);	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a  onClick="sil(' + rowCount + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id="57463.Sil">" border="0"></i></a>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.noWrap = true;
		newCell.setAttribute("id","work_startdate" + rowCount + "_td");
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_' + rowCount +'" id="row_kontrol_' + rowCount +'" value="1"><input type="text" id="work_startdate' + rowCount +'" name="work_startdate' + rowCount +'" class="text" maxlength="10" style="width:70px;" value=""> ';
		wrk_date_image('work_startdate' + rowCount);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","startdate" + rowCount + "_td");
		newCell.innerHTML = '<input type="text" id="startdate' + rowCount +'" name="startdate' + rowCount +'" class="text" maxlength="10" style="width:70px;" value=""> ';
		wrk_date_image('startdate' + rowCount);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.noWrap = true;
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-xs-6">'+document.getElementById("cf_wrktimeformat").innerHTML+'</div><div class="col col-6 col-xs-6"><select name="start_min' + rowCount +'" id="start_min' + rowCount +'"><option value="0"><cf_get_lang dictionary_id="58827.Dk"></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#">#i#</option></cfoutput></cfloop></select></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.noWrap = true;
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-xs-6">'+document.getElementById("cf_wrktimeformat_2").innerHTML+'</div><div class="col col-6 col-xs-6"><select name="end_min' + rowCount +'" id="end_min' + rowCount +'"><option value="0"><cf_get_lang dictionary_id="58827.Dk"></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#">#i#</option></cfoutput></cfloop></select></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage' + rowCount +'"  id="process_stage' + rowCount +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';

		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<div class="form-group"><select name="Shift_Status' + rowCount +'" id="Shift_Status' + rowCount +'"><option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option><option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option></select></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="day_type' + rowCount +'" id="day_type' + rowCount +'"><option value="0"><cf_get_lang dictionary_id="53014.Normal Gün"></option><option value="1"><cf_get_lang dictionary_id="53015.Hafta Sonu"></option><option value="2"><cf_get_lang dictionary_id="53016.Resmi Tatil"></option><option value="3"><cf_get_lang dictionary_id="54251.Gece Çalışması"></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><textarea name="valid_detail' + rowCount +'" id="valid_detail' + rowCount +'" style="width:90px;height:30px;"></textarea></div>';
		document.getElementById('start_hour').setAttribute('name', 'start_hour'+sayac);
		 $("select[name = start_hour]").each(function(){

					$(this).attr("name", "start_hour" + rowCount);
		
			});
			document.getElementById('end_hour').setAttribute('name', 'end_hour'+sayac);
		 $("select[name = end_hour]").each(function(){

					$(this).attr("name", "end_hour" + rowCount);
		
			});
				
	}
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function sabit_sil(sy)
	{
		var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("sabit_my_row_"+sy);
		my_element.style.display="none";
	}	
	function kontrol()
	{	
		form_basket.rowCount.value = rowCount;
		
		for(i=1; i <= $("#rowCount").val(); i++)
		{
			if($("#work_startdate"+i).val() == '' && $("#row_kontrol_"+i).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='61649.Çalışma Günü Tarihi'>!");
				return false;
			}
			if($("#Shift_Status"+i).val() == '' && $("#row_kontrol_"+i).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='64573.Mesai Karşılığı'>!");
				return false;
			}
			if($("#day_type"+i).val() == '' && $("#row_kontrol_"+i).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53599.Mesai Türü'>!");
				return false;
			}
		}
		for(j=1; j <= $("#rowCount_sabit").val();j++)
		{
			if($("#sabit_work_startdate"+j).val() == '' && $("#sabit_row_kontrol_"+j).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='61649.Çalışma Günü Tarihi'>!");
				return false;
			}
			if($("#sabit_Shift_Status"+j).val() == '' && $("#sabit_row_kontrol_"+j).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='64573.Mesai Karşılığı'>!");
				return false;
			}
			if($("#sabit_my_row_day_type"+j).val() == '' && $("#sabit_row_kontrol_"+j).val() == 1)
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53599.Mesai Türü'>!");
				return false;
			}
		}

		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			loadPopupBox('form_basket' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;

		<cfelse>
			return true;
		</cfif>
	}	
	function ajax_function()
	{
		related_year = $("#related_year").val();

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_emp_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&related_year='+related_year,'ajax_right');

		return false;
	}
</script>
