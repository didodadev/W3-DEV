<!--- Aktarım İşlemi Boyunca Her Şube Geçişinde  Aşağıdaki Listeye Yeni Şubeler Eklenecektir. --->
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_NAME, BRANCH_ID FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_TR" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES ORDER BY TR_NAME
</cfquery>
<cf_box title="#getLang('','Toplu Pozisyon Görevi Değiştir',52133)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_change_position_mission" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_change_position_mission">
	<cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52134.Boyuta da Aktar'> *</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_boyut" id="is_boyut"></div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="branch_id" id="branch_id">
						<cfoutput query="get_branch">
							<option value="#branch_id#">#branch_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57894.Statü'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="tr_status" id="tr_status">
                        <option value=""><cf_get_lang_main no='482.Statü'></option>
                        <cfoutput query="get_tr">
                            <option value="#tr_id#">#tr_name#</option>
                        </cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='688.Eski Görevli'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="eski_gorevli_id" id="eski_gorevli_id" value="">
						<input type="text" name="eski_gorevli" id="eski_gorevli" value="" readonly>
						<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_position_mission.eski_gorevli_id&field_name=add_change_position_mission.eski_gorevli&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>
					</div>
				</div>
				<!--- ?<td><cf_get_lang no='689.Boyut Kodu'></td> --->
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='690.Yeni Görevli'> *</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="yeni_gorevli_id" id="yeni_gorevli_id" value="">
						<input type="text" name="yeni_gorevli" id="yeni_gorevli" readonly="" value="">
						<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_position_mission.yeni_gorevli_id&field_name=add_change_position_mission.yeni_gorevli&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52136.Boyut Kodu'> </label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="yeni_boyut" validate="integer" required="yes" maxlength="3" >
					</div>
			</div>
			<div class="form-group">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<input type="checkbox" name="is_sifir" id="is_sifir"><cf_get_lang no='691.Eski Pozisyon Kodu Sıfır Olan Müşterilerinde Pozisyonlarını Değiştir'></label>
					
			</div>
			<div class="form-group">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><hr></label>
			</div>
			<div class="form-group">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no='692.Aşağıdaki Görevler İçin Pozisyon Görevi Aktar'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_sales" id="is_sales" checked><cf_get_lang no='693.Bölge Satış'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<input type="checkbox" name="is_telefon" id="is_telefon"><cf_get_lang no='694.Telefonla Satış'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_saha" id="is_saha"><cf_get_lang no='695.Saha Satış'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_itriyat" id="is_itriyat"><cf_get_lang no='696.Itriyat Satış'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_tahsilat" id="is_tahsilat"><cf_get_lang_main no='433.Tahsilat'></label>
			</div>
			<div class="form-group">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><hr></label>
			</div>
			<div class="form-group">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no='698.Aşağıdaki Kriterlere Göre Pozisyon Değişimini Gerçekleştir'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="radio" name="is_type" id="is_type" value="1" checked="checked"><cf_get_lang no='699.Seçilmiş Olan Depoya Göre'></label>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="radio" name="is_type" id="is_type" value="2"><cf_get_lang no='700.Seçilmiş Olan Müşterilere Göre'></label>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><input type="radio" name="is_type" id="is_type" value="3"><cf_get_lang no='701.Seçilmiş Olan IMS Kodlarına Göre'></label>
			</div>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_ajax_list  id="table1">
					<thead>
						<tr>								
							<th width="10"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="pencere_ac_company();"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='58673.Müşteriler'></th>	
						</tr>
						<tbody>
							<tr>

							</tr>
						</tbody>
					</thead>			
				</cf_ajax_list>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_ajax_list id="table2">
					<thead>
						<tr>								
							<th width="10"><input name="record_num1" id="record_num1" type="hidden" value="0"><a href="javascript://" onClick="add_row1();"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='52159.IMS Brickleri'></th>	
						</tr>
						<tbody>
							<tr>

							</tr>
						</tbody>
					</thead>			
				</cf_ajax_list>
			</div>
		</div>
	</cf_box_elements>
    <cf_box_footer><cf_workcube_buttons is_upd='0' add_function="kontrol() && loadPopupBox('add_change_position_mission')"></cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(add_change_position_mission.yeni_gorevli_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='52149.Lütfen Yeni Görevliyi Giriniz'> !");
		return false;
	}
	if(add_change_position_mission.is_type[1].checked == true)
	{
		if(document.add_change_position_mission.record_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='52021.Lütfen Müşteri Seçiniz'>!");
			return false;
		}
	}
	if(add_change_position_mission.is_type[2].checked == true)
	{
		if(document.add_change_position_mission.record_num1.value == 0)
		{
			alert("<cf_get_lang no='52160.Lütfen IMS Kodu Seçiniz'>!");
			return false;
		}
	}
	if(add_change_position_mission.yeni_boyut.value == "")
	{
		alert("<cf_get_lang dictionary_id='65153.Lütfen Sayısal Eski Görevlinin Boyut Kodunu Giriniz'> !");
		return false;
	}
	<cfif isdefined("attributes.draggable")>
	loadPopupBox('add_change_position_mission' , <cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelse>
	return true;
	</cfif>
}
row_count=0;
row_count1=0;

function sil(sy)
{
	var my_element=eval("add_change_position_mission.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function sil1(sy)
{
	var my_element1=eval("add_change_position_mission.row_kontrol1"+sy);
	my_element1.value=0;
	var my_element1=eval("frm_row1"+sy);
	my_element1.style.display="none";
}
function kontrol_et()
{
	if(row_count ==0)
		return false;
	else
		return true;
}

function kontrol_et1()
{
	if(row_count1 ==0)
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
	document.add_change_position_mission.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="company_id' + row_count +'"><input type="text" name="company_name' + row_count +'" ><a href="javascript://" onClick="pencere_ac('+ row_count +');"><img  src="images/plus_thin.gif" border="0" align="absmiddle"></a>';
}

function add_row1()
{
	row_count1++;
	var newRow1;
	var newCell1;
	newRow1 = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
	newRow1.setAttribute("name","frm_row1" + row_count1);
	newRow1.setAttribute("id","frm_row1" + row_count1);		
	newRow1.setAttribute("NAME","frm_row1" + row_count1);
	newRow1.setAttribute("ID","frm_row1" + row_count1);		
	document.add_change_position_mission.record_num1.value=row_count1;
	newCell1 = newRow1.insertCell(newRow1.cells.length);
	newCell1.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol1' + row_count1 +'" ><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
	newCell1 = newRow1.insertCell(newRow1.cells.length);
	newCell1.innerHTML = '<input type="hidden" name="ims_code_id' + row_count1 +'"><input type="text" name="ims_code_name' + row_count1 +'" ><a href="javascript://" onClick="pencere_ims('+ row_count1 +');"><img  src="images/plus_thin.gif" border="0" align="absmiddle"></a>';
}

function pencere_ac(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=add_change_position_mission.company_id'+ no +'&field_comp_name=add_change_position_mission.company_name'+ no +'&is_single=1');
}

function pencere_ims(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_id=add_change_position_mission.ims_code_id'+ no +'&field_name=add_change_position_mission.ims_code_name'+ no );
}

function pencere_ac_company(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&record_num_=' + add_change_position_mission.record_num.value +'&is_first=1&is_position=1');
}
</script>
