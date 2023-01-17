
<div class="col col-12 col-xs-12">
	<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
		<cfinclude template="../display/list_printers.cfm">
</div>
	<cf_box title="#getLang('','settings',42168)#" add_href="#request.self#?fuseaction=settings.form_add_printer" is_blank="0"><!--- Yazıcılar --->
		<cfform name="printer" action="#request.self#?fuseaction=settings.emptypopup_upd_printer" method="post" >
			<cf_box_elements>
				<input type="Hidden" name="PRINTER_ID" id="PRINTER_ID" value="<cfoutput>#URL.ID#</cfoutput>">
				<cfquery name="GET_PRINTER" datasource="#dsn#">
					SELECT 
        	            PRINTER_ID, 
                        PRINTER_NAME, 
                        IS_DEFAULT 
                    FROM 
    	                SETUP_PRINTER 
                    WHERE 
	                    PRINTER_ID=#URL.ID#
				</cfquery>
				<cfquery name="get_company" datasource="#dsn#">
					SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY
				</cfquery>
               
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
						<div class="form-group" id="item-IS_DEFAULT">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input type="checkbox" name="IS_DEFAULT" id="IS_DEFAULT" value="1" <cfif GET_PRINTER.IS_DEFAULT eq 1>checked</cfif>><cf_get_lang dictionary_id='42475.Aktif Yazıcı'>
						</div>
					</div>
					<div class="form-group" id="item-printer_name">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42474.Yazıcı Adı'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='43745.Yazıcı Adı Girmelisiniz'>!</cfsavecontent>
							<cfinput type="Text" name="printer_name" style="width:150px;" value="#GET_PRINTER.PRINTER_NAME#" maxlength="50" required="Yes" message="#message#">
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
							<cfset my_count = 0>
							<cfoutput query="get_company">
								<cfset my_comp_id = get_company.comp_id>
								<cfset new_dsn3 = '#dsn#_#comp_id#'>
								<cfquery name="get_papers_no" datasource="#new_dsn3#">
									SELECT 
        	                            PAPER_ID, 
                                        REVENUE_RECEIPT_NO, 
                                        REVENUE_RECEIPT_NUMBER, 
                                        INVOICE_NO, 
                                        INVOICE_NUMBER, 
                                        E_INVOICE_NO, 
                                        E_INVOICE_NUMBER, 
                                        SHIP_NO, 
                                        SHIP_NUMBER, 
                                        EMPLOYEE_ID, 
                                        OFFER_NO, 
                                        OFFER_NUMBER, 
                                        ORDER_NO, 
                                        ORDER_NUMBER, 
                                        PAPER_TYPE, 
                                        PRINTER_ID 
                                    FROM 
    	                                PAPERS_NO 
                                    WHERE 
	                                    PRINTER_ID = #URL.ID#
								</cfquery>
								<cfif get_papers_no.recordcount>
									<cfset my_count = my_count + 1>
									<tr id="frm_row#my_count#" name="frm_row#my_count#">
										<td><input type="hidden" name="row_kontrol#my_count#" id="row_kontrol#my_count#" value="1"><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#my_count#);"><i class="fa fa-minus"></i></a></td>
										<td><div class="form-group"><select name="our_company#my_count#" id="our_company#my_count#" style="width:100px;" onchange="kontrol_row(#my_count#);">
												<option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option>
												<cfloop query="get_company">
													<option value="#get_company.comp_id#"<cfif get_company.comp_id eq my_comp_id>selected</cfif>>#get_company.company_name#</option>
												</cfloop>
											</select>
										</div>
										</td>
										<td><div class="form-group"><div class="col-8"><input type="text" name="revenue_receipt_no#my_count#" id="revenue_receipt_no#my_count#"  style="width:80px;" value="#get_papers_no.revenue_receipt_no#"> 
										</div><div class="col-4 col">
											<input type="text" name="revenue_receipt_number#my_count#" id="revenue_receipt_number#my_count#"  style="width:50px;" value="#get_papers_no.revenue_receipt_number#" onKeyUp="isNumber(this);"></td>
										</div>
											<td><div class="form-group"><div class="col-8"><input type="text" name="invoice_no#my_count#" id="invoice_no#my_count#" style="width:80px;" value="#get_papers_no.invoice_no#"> 
                                        	</div><div class="col-4 col">
											<input type="text" name="invoice_number#my_count#" id="invoice_number#my_count#" style="width:50px;" value="#get_papers_no.invoice_number#" onKeyUp="isNumber(this);"></td>
											</div>
											<cfif session.ep.our_company_info.is_efatura>
											<td><div class="form-group"><div class="col-4"><input type="text" name="e_invoice_no#my_count#" id="e_invoice_no#my_count#" style="width:30px;" maxlength="3" value="#get_papers_no.e_invoice_no#"> 
											</div><div class="col-8 col">
												<input type="text" name="e_invoice_number#my_count#" id="e_invoice_number#my_count#" style="width:60px;" maxlength="9" value="#numberformat(get_papers_no.e_invoice_number,000000000)#" onKeyUp="isNumber(this);"></td>
											</div>
											</cfif>
										<td><div class="form-group"><div class="col-8"><input type="text" name="ship_no#my_count#" id="ship_no#my_count#"  style="width:80px;" value="#get_papers_no.ship_no#"> 
										</div><div class="col-4 col">
											<input type="text" name="ship_number#my_count#" id="ship_number#my_count#"  style="width:50px;" value="#get_papers_no.ship_number#" onKeyUp="isNumber(this);"></td>
										</div>
										</tr>
								</cfif>
							</cfoutput>
							<input type="hidden" name="counter" id="counter" value="<cfoutput>#my_count#</cfoutput>">
				           <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#my_count#</cfoutput>">
						</tbody>
					</cf_flat_list>
				   </div>
				</div>
				<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="3" sort="true"></div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="4" sort="true">
						<cfsavecontent variable="txt_1">&nbsp;<cf_get_lang dictionary_id='58992.Kullanıcılar'></cfsavecontent>
						<cf_workcube_to_cc
							is_update="1"
							to_dsp_name="#txt_1#"
							form_name="printer"
							str_list_param="1"
							action_dsn="#DSN#"
							str_action_names = "PRINTER_EMP_ID AS TO_EMP"
							str_alias_names = "TO_EMP"
							action_table="SETUP_PRINTER_USERS"
							action_id_name="PRINTER_ID"
							data_type="2"
							action_id="#URL.ID#">
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_printer&printer_id=#URL.ID#'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	for(i=1;i<=row_count;i++)
	{
		if (eval("printer.row_kontrol"+i).value == 1 && eval("printer.our_company"+i).value=='')
		{	
			alert("<cf_get_lang dictionary_id ='43892.Lütfen Her Satırda Şirket Seçiniz'> !");
			return false;
		}
		if( eval("printer.e_invoice_number"+i).value.length !=0 ||  eval("printer.e_invoice_no"+i).value.length != 0)
		{
			if(eval("printer.e_invoice_no"+i).value.length < 3)
			{
				alert('E-Fatura Ön Eki 3 Karakter Olmalıdır !');
				return false;
			} 
			if( eval("printer.e_invoice_number"+i).value.length < 9)
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
	my_comp = eval("printer.our_company"+my_row);
	for(i=1;i<=row_count;i++)
	{
		if ( i != my_row && eval("printer.row_kontrol"+i).value == 1 && my_comp.value == eval("printer.our_company"+i).value)
		{	
			alert("<cf_get_lang dictionary_id ='43891.Aynı Şirkete Birden Fazla Belge Numarası Ekleyemezsiniz'>!");
			my_comp.value = '';
			return false;
		}
		if(eval("printer_form.e_invoice_no"+i).value.length !=0 && eval("printer_form.e_invoice_no"+i).value.length != 3)
		{
			alert('Fatura Ön Eki 3 Karakter Olmalıdır !');
			return false;
		} 
		if(eval("printer_form.e_invoice_number"+i).value.length !=0 && eval("printer_form.e_invoice_number"+i).value.length !=9)
		{
			alert('Fatura Numarası 9 Karakter Olmalıdır !');
			return false;
		}
	}
	return true;
}
var row_count=document.printer.record_num.value;
function sil(sy)
{
	var my_element=eval("printer.row_kontrol"+sy);
	my_element.value=0;
	document.printer.counter.value=filterNum(document.printer.counter.value)-1;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	document.printer.counter.value=parseFloat(filterNum(document.printer.counter.value))+1;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	document.printer.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
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
