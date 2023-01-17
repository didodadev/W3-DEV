<cfinclude template="../query/get_position_detail.cfm">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="GET_POSITION_COST" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_POSITIONS_COST WHERE POSITION_ID = #url.position_id#
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Pozisyon Maliyeti',55150)# #get_position_detail.POSITION_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_pos_money" action="#request.self#?fuseaction=hr.upd_position_money&id=#url.position_id#" method="post">
		<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#url.position_id#</cfoutput>">		
		<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position_detail.position_code#</cfoutput>">
		<input type="Hidden" id="counter" name="counter">
		<cf_box_elements>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-MONEY_ID">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55556.Öngörülen Ücret/Ay'></label>
					<div class="col col-6 col-xs-12">
						<cfinput name="ONGR_UCRET" type="text"  value="#TLFormat(get_position_detail.ONGR_UCRET)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
					</div>  
					<div class="col col-2 col-xs-12">
						<select name="MONEY_ID" id="MONEY_ID" value="">
							<cfoutput query="GET_MONEY">
								<option value="#MONEY_ID#" <cfif len(get_position_detail.money_id) and MONEY_id eq get_position_detail.money_id>selected<cfelseif money eq session.ep.money>selected</cfif>>#MONEY#
							</cfoutput>
						</select>
					</div>              
				</div>
				<div class="form-group require" id="item-ON_HOUR">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55142.Aylık Çalışma Saati'>*</label>
					<div class="col col-8 col-xs-12">
						<cfinput name="ON_HOUR" type="text" onkeyup="return(FormatCurrency(this,event));" class="moneybox" value="#TLFormat(get_position_detail.ON_HOUR)#" validate="float" message="Aylık Çalışma Saati Sayısal Olmalıdır!">
					</div>   
				</div>
				<div class="form-group require" id="item-ON_HOUR_DAILY">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55376.Günlük Çalışma Saati'></label>
					<div class="col col-8 col-xs-12">
						<cfinput name="ON_HOUR_DAILY" type="text" onkeyup="return(FormatCurrency(this,event));" class="moneybox" value="#TLFormat(get_position_detail.ON_HOUR_DAILY)#" validate="float" message="Günlük Çalışma Saati Sayısal Olmalıdır!">
					</div>   
				</div>
				<div class="form-group require" id="item-time_cost_control">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55692.Zaman harcaması kontrolü yapılmasın'></label>
					<div class="col col-8 col-xs-12">
						<input type="checkbox" name="time_cost_control" id="time_cost_control" <cfif get_position_detail.time_cost_control eq 1>checked</cfif>>
					</div>   
				</div>
			</div>
		</cf_box_elements>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_position_cost.recordcount#</cfoutput>"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id='55486.Rakam'></th>
				</tr>
			</thead>
			<tbody name="table1_" id="table1_">
				<cfoutput query="get_position_cost">
				<tr id="frm_row#currentrow#">
					<td><input  type="hidden" value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
					<td><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#detail#"></div></td>
					<td>
						<div class="form-group">
							<select name="period#currentrow#" id="period#currentrow#" onChange="add_toplam();">
								<option value="1" <cfif get_position_cost.cost_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
								<option value="2" <cfif get_position_cost.cost_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
							</select>
						</div>
					</td>
					<td><div class="form-group"><input name="rakam#currentrow#" id="rakam#currentrow#" type="Text" class="moneybox" value="#tlformat(position_cost)#" onBlur="add_toplam();" onkeyup="return(FormatCurrency(this,event));"></div></td>
				</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_elements>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-ON_HOUR">
					<label class="col col-4"><cf_get_lang dictionary_id='55431.Aylık Pozisyon Maliyeti'></label>
					<div class="col col-8">
						<cfinput name="ON_MALIYET" type="Text" class="moneybox" value="#TLFormat(get_position_detail.ON_MALIYET)#" onkeyup="return(FormatCurrency(this,event));">
					</div>   
				</div>
				<div class="form-group require" id="item-ON_HOUR">
					<label class="col col-4"><cf_get_lang dictionary_id='55437.Yıllık Pozisyon Maliyeti'></label>
					<div class="col col-8">
						<cfinput name="ON_MALIYET_YIL" type="Text" class="moneybox" value="#TLFormat(get_position_detail.ON_MALIYET_YIL)#" onkeyup="return(FormatCurrency(this,event));">
					</div>   
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("UnformatFields() && loadPopupBox('upd_pos_money' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>

<script type="text/javascript">
row_count=<cfoutput>#get_position_cost.recordcount#</cfoutput>;
function sil(sy)
{
	var my_element=eval("upd_pos_money.row_kontrol"+sy);
	my_element.value=0;
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
	newRow = document.getElementById("table1_").insertRow(document.getElementById("table1_").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.upd_pos_money.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="detail' + row_count +'"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="period' + row_count +'" onChange="add_toplam();"><option value="1"><cf_get_lang dictionary_id='58932.Aylık'></option><option value="2"><cf_get_lang dictionary_id='29400.Yıllık'></option></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input name="rakam' + row_count +'" type="Text"  class="moneybox"  value="0" onBlur="add_toplam();" onkeyup="return(FormatCurrency(this,event));"></div>';
}
function add_toplam()
{
	toplam_deger_aylik = 0;
	toplam_deger_yillik = 0;
	for (var p=1;p<=row_count;p++)
	{
		alan_row_kontrol = eval('upd_pos_money.row_kontrol'+p);
		alan_period = eval('upd_pos_money.period'+p);
		alan_rakam = eval('upd_pos_money.rakam'+p);
		
		if( alan_rakam.value == "") { alan_rakam.value = 0; }
		alan_rakam.value = filterNum(alan_rakam.value);
		if(alan_row_kontrol.value == 1)
		{
			if(alan_period.value == 1)
			{
				toplam_deger_aylik = toplam_deger_aylik + parseFloat(alan_rakam.value);
				toplam_deger_yillik = toplam_deger_yillik + (parseFloat(alan_rakam.value) * 12);
			}
			else
			{
				toplam_deger_aylik = toplam_deger_aylik + (parseFloat(alan_rakam.value)/12);
				toplam_deger_yillik = toplam_deger_yillik + parseFloat(alan_rakam.value);
			}
		}
		alan_rakam.value = commaSplit(alan_rakam.value);
	}
	upd_pos_money.ON_MALIYET.value = commaSplit(toplam_deger_aylik);
	upd_pos_money.ON_MALIYET_YIL.value = commaSplit(toplam_deger_yillik);
}
function UnformatFields()
{ 	
	if(upd_pos_money.ON_HOUR.value.length < 1)
	{
		alert("<cf_get_lang dictionary_id='55910.Aylık Çalışma Saati Girmelisiniz'>");
		return false;
	}
	upd_pos_money.ON_MALIYET.value=filterNum(upd_pos_money.ON_MALIYET.value);
	upd_pos_money.ON_MALIYET_YIL.value=filterNum(upd_pos_money.ON_MALIYET_YIL.value);
	upd_pos_money.ONGR_UCRET.value=filterNum(upd_pos_money.ONGR_UCRET.value);
	for (var p=1;p<=row_count;p++)
	{	
		alan_row_kontrol = eval('upd_pos_money.row_kontrol'+p);
		alan_rakam = eval('upd_pos_money.rakam'+p);
		if(alan_row_kontrol.value == 1)
		{
			alan_rakam.value=filterNum(alan_rakam.value);
		}
	}
	document.upd_pos_money.ON_HOUR.value = filterNum(document.upd_pos_money.ON_HOUR.value);
	document.upd_pos_money.ON_HOUR_DAILY.value = filterNum(document.upd_pos_money.ON_HOUR_DAILY.value);
	return true;
}
</script>
