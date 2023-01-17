<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY
</cfquery>
<div class="col col-12 col-xs-12">
	<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
		<cfinclude template="../display/list_printers.cfm">
</div>
	<cf_box title="#getLang('','settings',42168)#" add_href="#request.self#?fuseaction=settings.form_add_printer"><!--- Yazıcılar --->
		<cfform name="printer_form" action="#request.self#?fuseaction=settings.emptypopup_add_printer" method="post">
			<cf_box_elements>
				<input type="hidden" name="record_num" id="record_num" value="0">
				<input type="hidden" name="counter" id="counter" value="0">
				
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
						<div class="form-group" id="item-time_cost_cat">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input type="checkbox" name="is_default" id="is_default" value="1" align="left"><cf_get_lang dictionary_id='42475.Aktif Yazıcı'>
						</div>
					</div>
					<div class="form-group" id="item-time_cost_cat">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42474.Yazıcı Adı'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinput type="Text" name="printer_name"  value="">
						</div>
					</div>
				   </div>
				   <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_flat_list>
						<thead>
							<th style="width:10px;"><a style="cursor:pointer" title="<cf_get_lang dictionary_id='44630.Ekle'>" onclick="add_row();"><i class="fa fa-plus"></i></a></th>
							<th style="width:105px;" class="txtboldblue"><cf_get_lang dictionary_id='57574.Şirket'></th>
							<th style="width:135px;" class="txtboldblue" nowrap><cf_get_lang dictionary_id='42502.Tahsilat Makbuzu No'></th>
							<th style="width:135px;" class="txtboldblue" nowrap><cf_get_lang dictionary_id='58133.Fatura No'></th>
							<cfif session.ep.our_company_info.is_efatura>
								<th style="width:100px;" class="txtboldblue" nowrap>E-<cf_get_lang dictionary_id='58133.Fatura No'></th>
							</cfif>
							<th style="width:135px;" class="txtboldblue" nowrap><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
						</thead>
						<tbody name="table1" id="table1">
						</tbody>
					</cf_flat_list>
				   </div>
				</div>
				<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="3" sort="true"></div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="4" sort="true">
					<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58992.Kullanıcılar'></cfsavecontent>
					<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_2#" form_name="printer_form" str_list_param="1" data_type="1"> 
				</div>
			</cf_box_elements>
			<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	if(printer_form.printer_name.value == "")
	{
		alert("<cf_get_lang dictionary_id ='43745.Yazıcı Adı Girmelisiniz'> !");
		return false;
	}
	for(i=1;i<=row_count;i++)
	{
		
		if (eval("printer_form.row_kontrol"+i).value == 1 && eval("printer_form.our_company"+i).value=='')
		{	
			alert("<cf_get_lang dictionary_id ='43892.Lütfen Her Satırda Şirket Seçiniz'> !");
			return false;
		}
		
		if( eval("printer_form.e_invoice_number"+i).value.length !=0 ||  eval("printer_form.e_invoice_no"+i).value.length != 0)
		{
			if(eval("printer_form.e_invoice_no"+i).value.length < 3)
			{
				alert('E-Fatura Ön Eki 3 Karakter Olmalıdır !');
				return false;
			} 
			if( eval("printer_form.e_invoice_number"+i).value.length < 9)
			{
				alert('E-Fatura Numarası 9 Karakter Olmalıdır !');
				return false;
			}
		}
	} 
	return true;
}
function kontrol_row(my_row)
{
	my_comp = eval("printer_form.our_company"+my_row);
	for(i=1;i<=row_count;i++)
	{
		if ( i != my_row && eval("printer_form.row_kontrol"+i).value == 1 && my_comp.value == eval("printer_form.our_company"+i).value)
		{	
			alert("<cf_get_lang dictionary_id ='43891.Aynı Şirkete Birden Fazla Belge Numarası Ekleyemezsiniz'>!");
			my_comp.value = '';
			return false;
		}
		
	}
	return true;
}
var row_count=0;
function sil(sy)
{
var my_element=eval("printer_form.row_kontrol"+sy);
my_element.value=0;
document.printer_form.counter.value=filterNum(document.printer_form.counter.value)-1;
var my_element=eval("frm_row"+sy);
my_element.style.display="none";
}
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	document.printer_form.counter.value=parseFloat(filterNum(document.printer_form.counter.value))+1;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.printer_form.record_num.value=row_count;
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="our_company'+row_count+'"  onchange="kontrol_row(' + row_count +');"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option><cfoutput query="get_company"><option value="#comp_id#">#company_name#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="col-8"><input type="text" name="revenue_receipt_no'+row_count+'" > </div><div class="col-4 col"><input type="text" name="revenue_receipt_number'+row_count+'"  onKeyUp="isNumber(this);"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class=" col-8"><input type="text" name="invoice_no'+row_count+'"></div><div class="col-4 col"> <input type="text" name="invoice_number'+row_count+'"  onKeyUp="isNumber(this);"></div>';
	<cfif session.ep.our_company_info.is_efatura>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class=" col-4"><input type="text" name="e_invoice_no'+row_count+'"  maxlength="3"></div><div class="col-8 col"> <input type="text" name="e_invoice_number'+row_count+'" onKeyUp="isNumber(this);" maxlength="9"></div>';
	</cfif>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class=" col-8"><input type="text" name="ship_no'+row_count+'" > </div><div class="col-4 col"><input type="text" name="ship_number'+row_count+'"  onKeyUp="isNumber(this);"></div>';
}
</script>
