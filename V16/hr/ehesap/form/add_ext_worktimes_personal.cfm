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
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53601.Çalışana Toplu Fazla Mesai"></cfsavecontent>
<cfset pageHead = "#message#">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_worktime" action="#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_personal" method="post">
				<input name="record_sayisi" id="record_sayisi" type="hidden" value="1">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-employee">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="employee_id" id="employee_id" value="">
									<input type="hidden" name="in_out_id" id="in_out_id" value="">
									<cfinput name="employee" id="employee" type="text" required="yes" message="#getLang('','Çalışan girmelisiniz',29498)#" onFocus="AutoComplete_Create('employee','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID','employee_id,in_out_id','add_worktime','3','225');">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.in_out_id&field_emp_name=add_worktime.employee&field_emp_id=add_worktime.employee_id&is_active=1');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_puantaj_off">
							<label class="col col-4 col-xs-12 hide"></label>
							<div class="col col-8 col-xs-12">
								<label><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_grid_list sort="0">
					<thead>
						<tr>
							<th width="20"><a href="javascript://" onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
							<th width="120"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th width="115"><cf_get_lang dictionary_id='30961.Başlangıç Saati'></th>
							<th width="115"><cf_get_lang dictionary_id='30959.Bitiş Saati'></th>
							<th  width="115"><cf_get_lang dictionary_id='58859.Süreç'></th>
							<th width="130"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></th>
							<th width="600" class="text-center"><cf_get_lang dictionary_id='53599.Mesai Türü'></th>
						</tr>	
					</thead>
					<tbody id="link_table">	  
						<tr id="my_row_0">
							<td></td>
							<td width="120">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" id="row_kontrol_1"  value="1"  name="row_kontrol_1">						
										<input type="text" id="startdate0" name="startdate0" value="" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="startdate0" call_function="hepsi_startdate"></span>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-6 col-xs-6">
										<cf_wrkTimeFormat name="start_hour0" value="0" onChange="hepsi(row_count,'start_hour');">
									</div>
									<div class="col col-6 col-xs-6">
										<select name="start_min0" id="start_min0" onChange="hepsi(row_count,'start_min');">
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
									<div class="col col-6 col-xs-6">
										<cf_wrkTimeFormat name="end_hour0" value="0" onChange="hepsi(row_count,'end_hour');">
									</div>
									<div class="col col-6 col-xs-6">
										<select name="end_min0" id="end_min0" onChange="hepsi(row_count,'end_min');">
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
									<select name="process_stage0" id="process_stage0" onChange="hepsi(row_count,'process_stage');">
										<cfoutput query="get_process_stage">
											<option value="#process_row_id#">#stage#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="Shift_Status0" id="Shift_Status0" onclick="tik();" onChange="hepsi(row_count,'Shift_Status');">
										<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
										<option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<label class="col col-1">
										<input type="radio" name="day_type0" id="day_type0" value="0" checked onClick="hepsi_check(row_count,'day_type');"> 
									</label>
									<label class="col col-2"><cf_get_lang dictionary_id='53014.Normal Gün'></label>
									<label class="col col-1">
										<input type="radio" name="day_type0" id="day_type0" value="1" onClick="hepsi_check(row_count,'day_type');"> 
									</label>
									<label class="col col-2"><cf_get_lang dictionary_id='53015.Hafta Sonu'></label>
									<label class="col col-1">
										<input type="radio" name="day_type0" id="day_type0" value="2" onClick="hepsi_check(row_count,'day_type');">
									</label>
									<label class="col col-2"> <cf_get_lang dictionary_id='53016.Resmi Tatil'></label>
									<label class="col col-1">
										<input type="radio" name="day_type0" id="day_type0" value="3" onClick="hepsi_check(row_count,'day_type');">
									</label>
									<label class="col col-2"><cf_get_lang dictionary_id="54251.Gece Çalışması"></label>
								</div>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
				<cf_box_footer>
					<div class="col col-12">
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					</div>
				</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">

	row_count=0;
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

	function hepsi_startdate()
	{
		hepsi(row_count,'startdate');
	}
	function hepsi(satir,nesne)
	{
		deger= eval("document.add_worktime."+nesne+"0");
		for(var i=1;i<=satir;i++)
		{
			nesne_tarih=eval("document.add_worktime."+nesne+i);
			nesne_tarih.value=deger.value;
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
					
		document.add_worktime.record_sayisi.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a><input type="hidden"  value="1"  name="row_kontrol_' + row_count + '">';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","startdate" + row_count + "_td");
		
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="startdate' + row_count +'" name="startdate' + row_count +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="edate_'+row_count+'"></span></div></div>';		
		wrk_date_image('startdate' + row_count);
		$('#edate_'+row_count).append($('#startdate'+row_count+'_image'));
		
		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<div class="form-group"><div class="col col-6"><cf_wrktimeformat name="start_hour' + row_count + '"></div><div class="col col-6"><select name="start_min' + row_count + '"><option value="0"><cf_get_lang dictionary_id='58827.Dk'></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-6"><cf_wrktimeformat name="end_hour' + row_count + '"></div><div class="col col-6"><select name="end_min' + row_count + '"><option value="0"><cf_get_lang dictionary_id='58827.Dk'></option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage' + row_count +'"  id="process_stage' + row_count +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<div class="form-group"><select name="Shift_Status' + row_count +'" id="Shift_Status' + row_count +'" onclick="tik();"><option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option><option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option></select></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><label class="col col-1"><input type="radio" name="day_type' + row_count + '" value="0" checked></label><label class="col col-2"> <cf_get_lang dictionary_id='53014.Normal Gün'></label><label class="col col-1"><input type="radio" name="day_type' + row_count + '" value="1"></label><label class="col col-2"> <cf_get_lang dictionary_id='53015.Hafta Sonu'></label><label class="col col-1"> <input type="radio" name="day_type' + row_count + '" value="2"></label> <label class="col col-2"><cf_get_lang dictionary_id='53016.Resmi Tatil'></label><label class="col col-1"> <input type="radio" name="day_type' + row_count + '" value="3"> </label><label class="col col-2"><cf_get_lang dictionary_id="54251.Gece Çalışması"></label></div>';
	}


function kontrol()
{
		if(row_count == 0)
		{
		alert("<cf_get_lang dictionary_id='53600.Fazla Mesai Girişi Yapmadınız'>!");
		return false;
		}
}		
</script>
