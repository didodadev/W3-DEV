<cfinclude template="../form/care_period_options.cfm">
<cfquery name="GET_CARE_TYPE" datasource="#DSN#">
	SELECT 
		ASSET_CARE_CAT.*,
		ASSET_P_CAT.MOTORIZED_VEHICLE 
	FROM 
		ASSET_CARE_CAT,
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_ID = #attributes.asset_id# AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_CARE_CAT.ASSETP_CAT
</cfquery>
<cfquery name="get_motos" datasource="#dsn#">
	SELECT 
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		ASSET_P.ASSETP_ID 
	FROM 
		ASSET_P_CAT,
		ASSET_P
	WHERE
		ASSET_P.ASSETP_ID = #attributes.asset_id#
		AND ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID  
</cfquery> 
<cfform name="add_care_state" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_care_states" method="post">
    <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
    <input type="hidden" name="is_motorized" id="is_motorized" value="<cfif get_motos.motorized_vehicle eq 1>1<cfelse>0</cfif>">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="15" class="text-center"><input name="record_num" id="record_num" type="hidden" value="0"><a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                <th><cf_get_lang dictionary_id='33171.Bakım Tipi'>  *</th>
				<th width="150px"><cf_get_lang dictionary_id='29473.İstasyonlar'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
                <th style="min-width:160px"><cf_get_lang dictionary_id='57569.Görevli'></th>
                <th style="min-width:175px"><cf_get_lang dictionary_id='29513.Süre'></th>
                <cfif get_motos.motorized_vehicle eq 1>
                    <th><cf_get_lang dictionary_id='48527.Periyot/KM'></th>
                </cfif>
                <th><cf_get_lang dictionary_id='47952.Periyot'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>	
				<th style="min-width:200px"><cf_get_lang dictionary_id='62802.Erteleme Sebebi'></th>				 
            </tr>
        </thead>
        <tbody id="table1"></tbody>
    </cf_grid_list>
	<cf_box_footer>
		<tr>
			<td colspan="8">
				<cf_workcube_buttons is_upd='0' type_format="1" is_cancel="0" add_function='kontrol_care()'>
			</td>
		</tr>
	</cf_box_footer>
</cfform>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol'+sy)");
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function add_row()
	{
		//$("#table1").last().append("<tr><td>New row</td></tr>");
		row_count++;
		var newRow;
		var newCell;
					
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
					
		$('#record_num').val(row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group text-center"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><div class="form-group"><select name="care_type' + row_count +'" id="care_type' + row_count +'" style="width:150px"><option value=""></option><cfoutput query="get_care_type"><option value="#asset_care_id#">#asset_care#</option></cfoutput></select></div>';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden"  name="station_id' + row_count +'" id="station_id' + row_count +'" value=""><input type="hidden"  name="station_company_id' + row_count +'" id="station_company_id' + row_count +'" value=""><input type="text"  name="station_name' + row_count +'" id="station_name' + row_count +'" readonly="readonly" value="">&nbsp;<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_workstation&field_name=upd_care_state.station_name' + row_count +'&field_id=upd_care_state.station_id'+ row_count +'&field_comp_id=upd_care_state.station_company_id'+row_count+' \');"></span>';
		

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="care_date' + row_count +'" id="care_date' + row_count +'" class="text" maxlength="10" value=""><span class="input-group-addon" id="care_date' + row_count +'_td"></span></div></div>';
		wrk_date_image('care_date' + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="official_emp_id' + row_count +'" id="official_emp_id' + row_count +'"><div class="form-group"><div class="input-group"><input type="text" name="official_emp' + row_count +'" id="official_emp' + row_count +'" style="width:100px"> <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_care_state.official_emp_id' + row_count +'&field_name=add_care_state.official_emp' + row_count +' &select_list=1 \');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-4"><select name="gun' + row_count +'" id="gun' + row_count +'" style="width:40px"><cfoutput><option value=""><cf_get_lang dictionary_id='57490.Gün'></option><cfloop from="1" to="30" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></div><div class="col col-4"><select name="saat' + row_count +'" style="width:40px"><option value=""><cf_get_lang dictionary_id='57491.Saat'></option><cfoutput><cfloop from="0" to="24" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></div><div class="col col-4"><select name="dakika'+ row_count +'" style="width:40px"> <option value=""><cf_get_lang dictionary_id='58827.Dk'></option><cfoutput><cfloop from="0" to="60" index="i" step="5"><option value="#i#">#i#</option></cfloop></cfoutput></select></div></div>';
		
		<cfif get_motos.motorized_vehicle eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="care_km_period' + row_count +'" id="care_km_period' + row_count +'" class="moneybox" onKeyUp="FormatCurrency(this,event)" style="width:70px"></div>' 
		</cfif>
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="care_type_period' + row_count +'" id="care_type_period' + row_count +'" style="100px;"><option value=""><cf_get_lang dictionary_id='47952.Periyot'></option><cfoutput><cfloop  array = "#period_list#" index="my_period_data"> <option value="#my_period_data[1]#">#my_period_data[2]#</option></cfloop></cfoutput></select></div>';
					
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" value="" name="aciklama' + row_count +'" style="width:150px"></div>'; 

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden" value=""  name="care_period_time_new' + row_count +'" ><select name="care_delay_cause' + row_count + '" id="care_delay_cause' + row_count + '"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><option value="1"><cf_get_lang dictionary_id='62795.Planlanan Tarih Hatası'></option><option value="2"><cf_get_lang dictionary_id='62796.Finansal Gecikme'></option><option value="3"><cf_get_lang dictionary_id='62797.Satınalma Gecikmesi'></option><option value="4"><cf_get_lang dictionary_id='62798.Tedarikçi Gecikmesi'></option><option value="5"><cf_get_lang dictionary_id='62799.Personel Yetersizliği'></option></select></div>';
	}		
	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_care_state.care_date' + no ,'date');
	}
	
	function kontrol_care()
	{
		if(document.getElementById('record_num').value > 0)
		{
			row_temp = 0;
			for(r=1;r<=document.getElementById('record_num').value;r++)
			{
				
				temp_care_type = eval("document.getElementById('care_type'+r)");
				if(eval("document.getElementById('row_kontrol'+r)").value == 1)			
				{
					row_temp++;
					x = temp_care_type.selectedIndex;
					if (temp_care_type[x].value == "")
					{ 
						alert (row_temp +  ".<cf_get_lang dictionary_id='48492.Satırda Bakım Tipi Seçiniz'> !");
						return false;
					}
					
					if(eval("document.getElementById('care_date'+r)").value == "")
					{
						alert(row_temp +  ".<cf_get_lang dictionary_id='48491.Satırda Bakım Tarihi Giriniz'> !");
						return false;
					}				
				}
			}
		}
		
		for(x=1; x < row_count+1; x++)
		{
			<cfif get_motos.motorized_vehicle eq 1>
				deneme = eval('filterNum(add_care_state.care_km_period'+x+'.value)');
				eval('document.add_care_state.care_km_period'+x+'.value = deneme' );
			</cfif>
		}
		
		return true;	
	}
</script>
