<cf_catalystHeader>
<cfquery name="GET_SETUP_SCENARIO" datasource="#DSN#">
    SELECT SCENARIO_ID,SCENARIO FROM SETUP_SCENARIO
</cfquery>
<cfinclude template="../query/get_money.cfm">
<cf_box>
    <cfform name="add_expense" id="add_expense" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_scen_expense"> 
		<div class="row" >
		<div class="col col-12" type="column" index="1" sort="false">
                    	<div class="row" id="item-record_num">
                    		<cf_grid_list>
                            <input type="hidden" name="record_num" id="record_num" value="0">
                                <thead>
                                    <tr>
                                        <th><a style="cursor:pointer" onclick="add_row();"><i class="fa fa-plus"></i></a></th>
                                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                                        <th><cf_get_lang no='97.Periyot'></th>
                                        <th><cf_get_lang_main  no='217.Açıklama'>*</th>
                                        <th style="width:110px;"><cf_get_lang_main no='330.Tarih'>*</th>
										<th ><cf_get_lang dictionary_id='57416.Proje'></th>
                                        <th><cf_get_lang no='96.Tekrar'>*</th>
                                        <th><cf_get_lang_main no='261.Tutar'>*</th>
                                        <th><cf_get_lang no='171.Senaryo Tipi'></th>
                                    </tr>
                                </thead>
                                <tbody id="table1"></tbody>
                            </cf_grid_list>
        				</div>
                    </div>
				</div>
               <cf_box_footer>
                	<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
var row_count=0;
function sil(sy)
{
	var my_element = document.getElementById("row_kontrol"+sy);
	my_element.value=0;
	var my_element = document.getElementById("frm_row"+sy);
	my_element.style.display="none";
}

function add_row(expense_date,detail)
{
	if(expense_date == undefined)expense_date = '';
	if(detail == undefined)detail = '';
	
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.getElementById("record_num").value=row_count;	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden" name="row_kontrol'+ row_count +'" id="row_kontrol'+ row_count +'" value="1"><a style="cursor:pointer" onclick="sil('+ row_count +');"><i class="fa fa-minus"></i></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="extype_'+ row_count +'" id="extype_'+ row_count +'" style="width:100px;"><option value="0"><cf_get_lang_main no='1266.Gider'></option><option value="1"><cf_get_lang_main no='1265.Gelir'></option></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="period_type_'+ row_count +'" id="period_type_'+ row_count +'" style="width:100px;"> <option value="1" selected><cf_get_lang no='166.Her Hafta'></option> <option value="2"><cf_get_lang no='167.Her Ay'></option> <option value="6"><cf_get_lang no='572.Her 2 Ayda Bir'></option> <option value="3"><cf_get_lang no='168.Her 3 Ayda Bir'></option> <option value="4"><cf_get_lang no='169.Her 6 Ayda Bir'></option> <option value="5"><cf_get_lang no='164.Her Sene'></option></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="detail_'+ row_count +'" id="detail_'+ row_count +'" maxlength="50" style="width:100px;"></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","expense_date_" + row_count + "_td");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="expense_date'+ row_count +'" id="expense_date'+ row_count +'" class="text" maxlength="10" style="width:75px;" value="'+ expense_date +'"><span class="input-group-addon" id="expense_date'+row_count + '_td'+'"></span></div></div> ';
	wrk_date_image('expense_date' + row_count);
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'"><input type="text" placeholder="<cfoutput>#getlang('','Proje','57416')#</cfoutput>" name="project_name'+ row_count +'" id="project_name'+ row_count +'"><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>"'+
	'onClick='+"openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_expense.project_name" + row_count + "&project_id=add_expense.project_id" + row_count + "');"+'></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="repitition'+ row_count +'" id="repitition'+ row_count +'" class="moneybox" maxlength="2" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0));"></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="period_'+ row_count +'" id="period_'+ row_count +'" value="0"><input type="text" name="period_value_'+ row_count +'" id="period_value_'+ row_count +'" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> <span class="input-group-addon width"><select name="currency_' + row_count +'" id="currency_' + row_count +'"><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select></span></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="scenario_type_'+ row_count +'" id="scenario_type_'+ row_count +'" style="width:100px;"><option value="0"><cf_get_lang_main no ="322.Seçiniz"></option><cfoutput query="GET_SETUP_SCENARIO"><option value="#SCENARIO_ID#">#SCENARIO#</option></cfoutput></select></div>';
}

function kontrol()
{
	for(i=1;i<=add_expense.record_num.value;i++)
	{
		if(document.getElementById("row_kontrol"+i).value==1)
		{
			if (document.getElementById("detail_"+i).value == "")
			{ 
				alert ("<cf_get_lang no ='1.Lütfen Açıklama Giriniz'>!");
				return false;
			}
			if (document.getElementById("expense_date"+i).value == "")
			{ 
				alert ("<cf_get_lang_main no='1091.Lütfen Tarih Giriniz'>!");
				return false;
			}
			if (document.getElementById("repitition"+i).value == "")
			{ 
				alert ("<cf_get_lang no='234.Lütfen Tekrar Giriniz'>!");
				return false;
			}						
			if (document.getElementById("period_value_"+i).value == "")
			{ 
				alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>!");
				return false;
			}						
		}
	}
}
</script>
