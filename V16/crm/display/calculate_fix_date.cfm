<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ortalama Vade Hesaplayıcı','51917')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_cargo" method="post" action="">
			<div class="col col-6 col-md-6 col-sm-10 col-xs-12">
				<cf_grid_list id="table1">
					<thead>
						<tr>
							<th width="15" align="center"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onclick="add_row()"><i class="fa fa-plus"></i></a></th>
							<th width="140" nowrap="nowrap"><cf_get_lang_main no='330.Tarih'></th>
							<th width="200" nowrap="nowrap"><cf_get_lang_main no='261.Tutar'></th>
						</tr>
					</thead>
					<tbody  id="frm_row"></tbody>
				</cf_grid_list>
			</div>
			<div class="col col-6 col-md-6 col-sm-10 col-xs-12">
				<cf_grid_list>
					<thead>
						<tr>
						<th><cf_get_lang dictionary_id='57942.Bugün'></th>
						<th><cf_get_lang dictionary_id='51926.Ortalama Gün'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td width="85">
								<div class="form-group">
									<input type="text" name="bugun" id="bugun" class="box" readonly="" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:85;">
								</div>
							</td>
							<td width="150" nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="ortalama_gun" id="ortalama_gun" class="moneybox" readonly="" value="0" style="width:110;">&nbsp;<input type="hidden" name="para_sistem" id="para_sistem" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:37;">
										<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
				<cf_grid_list>
					<thead>
						<tr>
							<th colspan="2"><cf_get_lang dictionary_id='51927.Çek veya Faturaların Ortalama İadesi'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2" nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="ortalama_iade" id="ortalama_iade" class="moneybox" readonly="" value="0" style="width:200; ">&nbsp;<input type="hidden" name="para_sistem"  id="para_sistem" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:37;">
										<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
				<cf_grid_list>
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="total_amount" id="total_amount" class="moneybox" readonly="" value="0" style="width:200; ">&nbsp;<input type="hidden" name="para_sistem" id="para_sistem" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:37;">
										<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
row_count=0;
function sil(sy)
{
	var my_element=eval("add_cargo.row_kontrol"+sy);
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
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.add_cargo.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="open_date' + row_count +'" id="open_date' + row_count + '" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" readonly=""><span class="input-group-addon" id="open_date' + row_count + '_td"></span></div></div>';
	wrk_date_image('open_date' + row_count);
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="risk_limit' + row_count +'" onKeyup="return(FormatCurrency(this,event));" value="0" style="width:100px;" class="moneybox" onBlur="expense_topla(' + row_count +');"><span class="input-group-addon width"><select name="money_type' + row_count +'" style="width:47px;" onBlur="expense_topla(' + row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></span></div></div>';
}
function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_cargo.open_date'+no+'&call_function=expense_topla()','date');
}
function expense_topla(deger)
{
	toplam_deger = 0;
	toplam_deger_gun = 0;
	toplam_vade = 0;
	toplam_row_count = 0;
	for (var p=1;p<=row_count;p++)
	{
		alan_tarih = eval('add_cargo.open_date'+p);
		alan_miktar = eval('add_cargo.risk_limit'+p);
		alan_para_birimi = 	eval('add_cargo.money_type'+p);
		alan_row_kontrol = 	eval('add_cargo.row_kontrol'+p);
		if(alan_row_kontrol.value == 1)
		{
			alan_miktar.value = filterNum(alan_miktar.value);
			deger_para_birimi = alan_para_birimi.value.split(',');
			deger_para_birimi_ilk = deger_para_birimi[1];
			deger_para_birimi_son = deger_para_birimi[2]; 
			if(alan_miktar.value == "") { alan_miktar.value = 0; }
			
			toplam_row_count = toplam_row_count + 1;
			
			if(alan_tarih.value != "")
			{
				bugun_yıl = add_cargo.bugun.value.substr(6,4);
				bugun_ay  = add_cargo.bugun.value.substr(3,2);
				bugun_gun = add_cargo.bugun.value.substr(0,2);
				
				deger_bugun_yıl = alan_tarih.value.substr(6,4);
				deger_bugun_ay  = alan_tarih.value.substr(3,2);
				deger_bugun_gun = alan_tarih.value.substr(0,2);
				
				tarih_farki = ((parseFloat(bugun_yıl) - parseFloat(deger_bugun_yıl))*365) + ((parseFloat(bugun_ay) - parseFloat(deger_bugun_ay))*30) + (parseFloat(bugun_gun) - parseFloat(deger_bugun_gun));
				toplam_deger_gun = toplam_deger_gun + tarih_farki;
				toplam_deger = toplam_deger + parseFloat(alan_miktar.value) * (parseFloat(deger_para_birimi_son)/parseFloat(deger_para_birimi_ilk));
				alan_miktar.value = commaSplit(alan_miktar.value);
				toplam_vade = toplam_vade + (parseFloat(alan_miktar.value) * (parseFloat(deger_para_birimi_son)/parseFloat(deger_para_birimi_ilk)))*parseFloat(tarih_farki);
			}
		}
	}
	add_cargo.total_amount.value = commaSplit(toplam_deger);
	add_cargo.ortalama_gun.value = commaSplit(toplam_deger_gun/toplam_row_count);
	if(toplam_deger_gun != 0)
	{
		add_cargo.ortalama_iade.value = commaSplit(toplam_vade/toplam_deger_gun);
	}
	else
	{
		add_cargo.ortalama_iade.value = commaSplit(0);
	}
}	
</script>
