<cfinclude template="../form/care_period_options.cfm">
<cfinclude template="../../assetcare/query/get_care_type.cfm">
<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
<cfquery name="CARE_STATES" datasource="#DSN#">
	SELECT 
		CS.CARE_ID, 
		CARE_STATE_ID, 
		PERIOD_ID, 
		CARE_DAY,
		CARE_HOUR, 
		CARE_MINUTE,
		CARE_KM,
		ASSET_ID,
		DETAIL,
		CARE_TYPE_ID,
        OUR_COMPANY_ID,
		PERIOD_TIME,
		OFFICIAL_EMP_ID,
        STATION_ID,
        (SELECT STATION_NAME FROM #dsn3_alias#.WORKSTATIONS WHERE STATION_ID =CS.STATION_ID) STATION_NAME,
		CARE_DELAY.*
	FROM 
		CARE_STATES CS
	left join CARE_DELAY on (CS.CARE_ID = CARE_DELAY.CARE_ID and CARE_DELAY.RECORD_DATE = (select max(RECORD_DATE) from CARE_DELAY where CARE_ID = CS.CARE_ID))
	WHERE
		CARE_TYPE_ID = 2 AND 
		ASSET_ID = #attributes.ASSET_ID# AND 
		IS_ACTIVE = 1
</cfquery>
<cfquery name="get_motos" datasource="#dsn#">
	SELECT 
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		ASSET_P.ASSETP_ID 
	FROM 
		ASSET_P_CAT,
		ASSET_P
	WHERE
		ASSET_P.ASSETP_ID = #attributes.asset_id# AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID  
</cfquery>
<cfset row = care_states.recordcount>
<cfform name="upd_care_state" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_assetp_care_states">
	<cf_grid_list>
		<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
		<input type="hidden" name="is_motorized" id="is_motorized" value="<cfif get_motos.motorized_vehicle eq 1>1<cfelse>0</cfif>">
		<cfinput type="hidden" name="care_id" id="care_id" value="#CARE_STATES.CARE_ID#">
		<thead>
			<tr>
				<th width="20"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<th><cf_get_lang dictionary_id='33171.Bakım Tipi'> *</th>
				<cfif xml_add_station_info eq 1><th width="150px"><cf_get_lang dictionary_id='29473.İstasyonlar'></th></cfif>
				<th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
				<th style="min-width:160px"><cf_get_lang dictionary_id='57569.Görevli'></th>
				<th style="min-width:175px"><cf_get_lang dictionary_id='29513.Süre'></th>
				<cfif get_motos.motorized_vehicle eq 1><th width="70"><cf_get_lang dictionary_id='48527.Periyot/KM'></th></cfif>
				<th><cf_get_lang dictionary_id='47952.Periyot'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th style="min-width:200px"><cf_get_lang dictionary_id='62802.Erteleme Sebebi'></th>
				<th><cf_get_lang dictionary_id='48109.Bakım Sonucu Ekle'></th>						
			</tr>
		</thead>
		<tbody id="table1">
			<cfoutput query="care_states">
			<cfset kilometers = CARE_KM> 
				<tr id="frm_row#currentrow#">
					<td><a onclick="sil_sor('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
					<td nowrap>
						<input type="hidden" value="#CARE_ID#" name="CARE_ID#currentrow#" id="CARE_ID#currentrow#">
						<input type="hidden" value="#care_delay_id#" name="care_delay_id#currentrow#" id="care_delay_id#currentrow#">
						<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
							<select name="care_type#currentrow#" id="care_type#currentrow#">
							<cfset care_state_id_ = care_states.care_state_id>
							<cfloop query="get_care_type">
							<option value="#asset_care_id#" <cfif len(care_state_id_) and (care_state_id_ eq asset_care_id)>selected</cfif>>#asset_care#</option>
							</cfloop>
						</select>
					</td>
						<cfif xml_add_station_info eq 1>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="station_id#currentrow#" id="station_id#currentrow#" value="#station_id#">
										<input type="hidden" name="station_company_id#currentrow#" id="station_company_id#currentrow#" value="#our_company_id#">
										<input type="text" name="station_name#currentrow#" id="station_name#currentrow#" value="#station_name#" readonly="readonly">
										<span class="input-group-addon icon-ellipsis" alt="<cf_get_lang dictionary_id='29473.İstasyonlar'>" title="<cf_get_lang dictionary_id='29473.İstasyonlar'>" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=prod.popup_list_workstation&field_name=upd_care_state.station_name#currentrow#&field_id=upd_care_state.station_id#currentrow#&field_comp_id=upd_care_state.station_company_id#currentrow#')"></span> 
									</div>
								</div>
							</td>
						</cfif>
					<td nowrap>
						<input type="text" name="care_date#currentrow#" id="care_date#currentrow#" value="<cfif len(period_time)>#dateformat(period_time,'dd/mm/yyyy')#</cfif>" style="width:70px">
						<cf_wrk_date_image date_field="care_date#currentrow#">
					</td>
					<td nowrap>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="official_emp_id#currentrow#" id="official_emp_id#currentrow#" value="<cfif len(care_states.official_emp_id)>#care_states.official_emp_id#</cfif>">
								<input type="text" name="official_emp#currentrow#" id="official_emp#currentrow#" value="<cfif len(official_emp_id)>#get_emp_info(care_states.official_emp_id,0,0)#</cfif>">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id2=upd_care_state.official_emp_id#currentrow#&field_name=upd_care_state.official_emp#currentrow#&select_list=1');"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="col col-4">
								<select name="gun#currentrow#" id="gun#currentrow#">
									<option value=""><cf_get_lang dictionary_id='57490.Gün'></option>
									<cfloop from="1" to="30" index="i">
									<option value="#i#" <cfif len(care_day) and (care_day eq i)>selected</cfif>>#i#</option>
									</cfloop>
								</select>
							</div>
							<div class="col col-4">
								<select name="saat#currentrow#" id="saat#currentrow#">
									<option value=""><cf_get_lang dictionary_id='57491.Saat'></option>
									<cfloop from="0" to="24" index="i">
									<option value="#i#" <cfif len(care_hour) and (care_hour eq i)>selected</cfif>>#i#</option>
									</cfloop>
								</select>
							</div>
							<div class="col col-4">
								<select name="dakika#currentrow#" id="dakika#currentrow#">
									<option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
									<cfloop from="0" to="60" index="i" step="5">
									<option value="#i#" <cfif len(care_minute) and (care_minute eq i)>selected</cfif>>#i#</option></cfloop>
								</select>
							</div>
						</div>
					</td>
					<cfif get_motos.motorized_vehicle eq 1>
						<td><input name="care_km_period#currentRow#" id="care_km_period#currentRow#" value="#tlformat(kilometers)#"  class="moneybox" onKeyUp="FormatCurrency(this,event);" style="width:65px"></td>
					</cfif>
					<td nowrap>
						<select name="care_type_period#currentrow#" id="care_type_period#currentrow#" style="100px;">
							<!---<option value=""><cf_get_lang dictionary_id='47952.Periyot'></option>
							<option value="1" <cfif len(period_id) and (period_id eq 1)>selected</cfif>><cf_get_lang dictionary_id='47947.Haftada Bir'></option>
							<option value="2" <cfif len(period_id) and (period_id eq 2)>selected</cfif>><cf_get_lang dictionary_id='48518.15 Günde Bir'></option>
							<option value="3" <cfif len(period_id) and (period_id eq 3)>selected</cfif>><cf_get_lang dictionary_id='47949.Ayda Bir'></option>
							<option value="4" <cfif len(period_id) and (period_id eq 4)>selected</cfif>><cf_get_lang dictionary_id='48519.2 Ayda Bir'></option>
							<option value="5" <cfif len(period_id) and (period_id eq 5)>selected</cfif>><cf_get_lang dictionary_id='48520.3 Ayda Bir'></option>
							<option value="6" <cfif len(period_id) and (period_id eq 6)>selected</cfif>><cf_get_lang dictionary_id='48521.4 Ayda Bir'></option>
							<option value="7" <cfif len(period_id) and (period_id eq 7)>selected</cfif>><cf_get_lang dictionary_id='48522.6 Ayda Bir'></option>
							<option value="8" <cfif len(period_id) and (period_id eq 8)>selected</cfif>><cf_get_lang dictionary_id='47950.Yılda Bir'></option>
							<option value="9" <cfif len(period_id) and (period_id eq 9)>selected</cfif>><cf_get_lang dictionary_id='48523.2 Yılda Bir'></option>
							--->
							<option value=""><cf_get_lang dictionary_id='47952.Periyot'></option>
							<cfloop array = "#period_list#" index="my_period_data">
								<option value="#my_period_data[1]#" <cfif len(period_id) and (period_id eq my_period_data[1])>selected</cfif>>#my_period_data[2]#</option>
							</cfloop>
						</select>
					</td>
					<td nowrap><input type="text"  value="<cfif len(detail)>#detail#</cfif>" name="aciklama#currentrow#" id="aciklama#currentrow#"></td>
					
					
					<td nowrap>
						<div class="form-group">
							<div class="col col-6">
								<div class="input-group">
									<input type="text" name="care_period_time_new#currentrow#" id="care_period_time_new#currentrow#" value="<cfif len(care_period_time_new)>#dateformat(care_period_time_new,'dd/mm/yyyy')#</cfif>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="care_period_time_new#currentrow#"></span>
								</div>
							</div>
							<div class="col col-6">
								<select name="care_delay_cause#currentrow#" id="care_delay_cause#currentrow#">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1" <cfif len(care_delay_cause) and (care_delay_cause eq 1)>selected</cfif>><cf_get_lang dictionary_id='62795.Planlanan Tarih Hatası'></option>
								<option value="2" <cfif len(care_delay_cause) and (care_delay_cause eq 2)>selected</cfif>><cf_get_lang dictionary_id='62796.Finansal Gecikme'></option>
								<option value="3" <cfif len(care_delay_cause) and (care_delay_cause eq 3)>selected</cfif>><cf_get_lang dictionary_id='62797.Satınalma Gecikmesi'></option>
								<option value="4" <cfif len(care_delay_cause) and (care_delay_cause eq 4)>selected</cfif>><cf_get_lang dictionary_id='62798.Tedarikçi Gecikmesi'></option>
								<option value="5" <cfif len(care_delay_cause) and (care_delay_cause eq 5)>selected</cfif>><cf_get_lang dictionary_id='62799.Personel Yetersizliği'></option>
								<option value="6" <cfif len(care_delay_cause) and (care_delay_cause eq 6)>selected</cfif>><cf_get_lang dictionary_id='62800.Firma Araştırılıyor'></option>
								<option value="7" <cfif len(care_delay_cause) and (care_delay_cause eq 7)>selected</cfif>><cf_get_lang dictionary_id='62801.Bakımı Yapılacak'></option>
								</select>
							</div>
						</div>
					</td>
					<td align="center"><a href="javascript://" onclick="location.href='#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#asset_ID#&care_state_id=#care_state_id#&care_id=#care_id#';" name="bakimsonucuekle#currentrow#" id="bakimsonucuekle#currentrow#"><i class="fa fa-plus" title="Bakım Sonucu Ekle"></i></a>
				</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
	<cf_box_footer>
		<tr>
			<td colspan="10"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol_care()' type_format="1"></td>
		</tr>
	</cf_box_footer>
</cfform>
<script type="text/javascript">
row_count=<cfoutput>#row#</cfoutput>;
function sil(sy)
{
	var my_element=eval("upd_care_state.row_kontrol"+sy);
	my_element.value = 0;

	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}
function kontrol_et()
{
	if(row_count ==0)
		return false;
	else
		return true;
}

function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
				
	document.upd_care_state.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';						

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden" value="0"  name="CARE_ID' + row_count +'" ><input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><select name="care_type' + row_count +'"><option value=""></option><cfoutput query="get_care_type"><option value="#asset_care_id#">#asset_care#</option></cfoutput></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	 <cfif xml_add_station_info eq 1>
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden"  name="station_id' + row_count +'" id="station_id' + row_count +'" value=""><input type="hidden"  name="station_company_id' + row_count +'" id="station_company_id' + row_count +'" value=""><input type="text"  name="station_name' + row_count +'" id="station_name' + row_count +'" readonly="readonly" value="">&nbsp;<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_workstation&field_name=upd_care_state.station_name' + row_count +'&field_id=upd_care_state.station_id' + row_count +' &field_comp_id=upd_care_state.station_company_id'+row_count+' \');"></span>';
	newCell=newRow.insertCell(newRow.cells.length);
	</cfif>
	
	newCell.setAttribute("id","care_date" + row_count + "_td");
	newCell.innerHTML = '<input type="text" name="care_date' + row_count +'" id="care_date' + row_count +'" class="text" maxlength="10" value="" style="width:70px">&nbsp;';
	wrk_date_image('care_date' + row_count);

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="official_emp_id' + row_count +'"><input type="text" name="official_emp' + row_count +'"> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=upd_care_state.official_emp_id' + row_count +'&field_name=upd_care_state.official_emp' + row_count +' &select_list=1  \');"></span></div></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="col col-4"><select name="gun' + row_count +'"><cfoutput><option value=""><cf_get_lang dictionary_id='57490.Gün'></option><cfloop from="1" to="30" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></div><div class="col col-4"> <select name="saat' + row_count +'"><option value=""><cf_get_lang dictionary_id='57491.Saat'></option><cfoutput><cfloop from="0" to="24" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></div><div class="col col-4"> <select name="dakika'+ row_count +'"><option value=""><cf_get_lang dictionary_id='58827.Dk'></option><cfoutput><cfloop from="0" to="60" index="i" step="5"><option value="#i#">#i#</option></cfloop></cfoutput></select></div></div>';

	/* eger motorlu arac ise*/
	<cfif get_motos.motorized_vehicle eq 1>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input name="care_km_period' + row_count +'" type="text" onKeyUp="FormatCurrency(this,event)" style="width:65px"></div>' 
	</cfif>
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="care_type_period' + row_count +'"><option value=""><cf_get_lang dictionary_id='47952.Periyot'></option><cfoutput query="care_states"><cfloop array = "#period_list#" index="my_period_data"><option value="#my_period_data[1]#" <cfif len(period_id) and (period_id eq my_period_data[1])>selected</cfif>>#my_period_data[2]#</option></cfloop></cfoutput></select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="text"  value=""  name="aciklama' + row_count +'"></div>';
	

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden" value=""  name="care_period_time_new' + row_count +'" ><select name="care_delay_cause' + row_count + '" id="care_delay_cause' + row_count + '"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang dictionary_id='62795.Planlanan Tarih Hatası'></option><option value="2"><cf_get_lang dictionary_id='62796.Finansal Gecikme'></option><option value="3"><cf_get_lang dictionary_id='62797.Satınalma Gecikmesi'></option><option value="4"><cf_get_lang dictionary_id='62798.Tedarikçi Gecikmesi'></option><option value="5"><cf_get_lang dictionary_id='62799.Personel Yetersizliği'></option></select></div>';
}		

function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=upd_care_state.care_date' + no ,'date');
}
function sil_sor(param)
{
	if(confirm("<cf_get_lang dictionary_id='48604.Silmek İstediğinizden Emin misiniz'>?"))
		sil(param);	
	else
		return false;
}


function kontrol_care()
{
	if(document.upd_care_state.record_num.value > 0)
	{
		row_temp = 0;
		for(r=1;r<=upd_care_state.record_num.value;r++)
		{
			
			temp_care_type = eval("document.upd_care_state.care_type"+r);
			if(eval("document.upd_care_state.row_kontrol"+r).value == 1)			
			{
				row_temp++;
				x = temp_care_type.selectedIndex;
				if (temp_care_type[x].value == "")
				{ 
					alert (row_temp +  ".<cf_get_lang dictionary_id='48492.Satırda Bakım Tipi Seçiniz'>!");
					return false;
				}
				
				if(eval("document.upd_care_state.care_date"+r).value == "")
				{
					alert(row_temp +  ".<cf_get_lang dictionary_id='48491.Satırda Bakım Tarihi Giriniz'> !");
					return false;
				}
				
				if(eval("document.upd_care_state.care_period_time_new"+r).value != "" && eval("document.upd_care_state.care_period_time_new"+r).value != eval("document.upd_care_state.care_date"+r).value && eval("document.upd_care_state.care_delay_cause"+r).value == "")
				{
					alert(row_temp +  " <cf_get_lang dictionary_id='62803.Numaralı Satırda Bakım Planı Erteleme Sebebi Seçmelisiniz'>!");
					return false;
				}	
			}
		}
	}
	
	for(x=1; x < row_count+1; x++)
	{
		<cfif get_motos.motorized_vehicle eq 1>
			deneme = eval('filterNum(upd_care_state.care_km_period'+x+'.value)');
			eval('document.upd_care_state.care_km_period'+x+'.value = deneme' );
		</cfif>
	}

	return true;	
}
</script>
