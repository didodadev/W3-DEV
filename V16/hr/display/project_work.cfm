<cfset work_group_row=GET_EMPS.recordcount>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55497.Grup Çalışanları"></cfsavecontent>
<cf_box title="#message#">
	<cf_grid_list>
		<thead>
			<input type="hidden" name="add_workgroup" id="add_workgroup" value="<cfoutput>#work_group_row#</cfoutput>">
			<tr>
				<th width="35"><cf_get_lang dictionary_id="58585.Kod"></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id="57569.Görevli">*</th>
				<th><cf_get_lang dictionary_id="55478.Rol"></th>
				<th><cf_get_lang dictionary_id="55600.Hizmet/Ürün">*</th>
				<th><cf_get_lang dictionary_id="57636.Birim"></th>
				<th><cf_get_lang dictionary_id="57638.Birim Fiyat"></th>
				<th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
				<th width="20" class="text-center"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='39741.Grafik'>" alt="<cf_get_lang dictionary_id='39741.Grafik'>"></i></th>
				<th width="20" class="text-center"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>    
		<tbody id="work_group">
			<cfif GET_EMPS.recordcount>
				<cfoutput query="GET_EMPS">
					<tr id="frm_row#currentrow#">
						<td><div class="form-group"><input type="text" name="code#currentrow#" id="code#currentrow#" value="#hierarchy#"></div></td>
						<td nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<cfif len(EMPLOYEE_ID)>
										<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_emp_info(EMPLOYEE_ID,0,0)#">
										<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
									<cfelseif len(CONSUMER_ID)>
										<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_cons_info(CONSUMER_ID,1,0)#">
										<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
									<cfelseif len(PARTNER_ID)>
										<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_par_info(PARTNER_ID,0,0,0)#">
										<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
									<cfelse>
										<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="">
										<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
									</cfif>
										<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
										<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#consumer_id#">
										<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
										<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
									<span class="input-group-addon icon-ellipsis" href="javascript://" title="üye seç" onClick="pencere_ac1(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="role_head#currentrow#" id="role_head#currentrow#" value="#role_head#" maxlength="100">
								<input type="hidden" name="role_id#currentrow#" id="role_id#currentrow#" value=""><!---<a href="javascript://" onClick="pencere_ac2(#currentrow#);" style="cursor:pointer;"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Rol Seç"></a></td>--->
							</div>
						<td>
						<cfif len(product_id)>
							<div class="form-group">
								<div class="input-group">
									<input type="text" value="#get_product_name(product_id)#" name="product#currentrow#" id="product#currentrow#">
									<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#"><input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_product(#currentrow#);"></span>
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<div class="input-group">
									<input type="text" value="" name="product#currentrow#" id="product#currentrow#">
									<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#">
									<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_product(#currentrow#);"></span>
								</div>
							</div>
						</cfif>
						</td>
						<td><div class="form-group"><input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#PRODUCT_UNIT#" readonly></div></td>
						<td><div class="form-group"><input type="text" name="price#currentrow#" id="price#currentrow#" value="#TLFormat(product_unit_price)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div></td>
						<td>
							<div class="form-group">
								<select name="money_type#currentrow#" id="money_type#currentrow#">
									<cfloop query="get_money">
										<option value="#get_money.money#" <cfif get_money.money eq GET_EMPS.PRODUCT_MONEY>selected</cfif>>#get_money.money#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td><a href="javascript://" onClick="copy_row(#currentrow#);"><i class="fa fa-bar-chart" title="Grafik"></i></a></td>
						<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
							<a style="cursor:pointer" onclick="sil(#currentrow#);"><i class="fa fa-minus" title="Sil" alt="sil"></i></a>
						</td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="9">
					<input type="hidden" name="record" id="record" value="">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()' type_format="1">
				</td>
			</tr>
		</tfoot>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
		//_work_group_row=<cfoutput>#work_group_row#</cfoutput>;
		row_count=<cfoutput>#work_group_row#</cfoutput>;
		document.getElementById('record').value=row_count;
	function add_row(code)
	{
		if(code == undefined)code ="";
		row_count++;
		//_work_group_row++;
		var newRow;
		var newCell;
		document.getElementById('record').value=row_count;
		newRow = document.getElementById("work_group").insertRow(document.getElementById("work_group").rows.length);	
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="code'+ row_count +'" value="'+code+'"></div>';
				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="member_name'+ row_count +'" value="" readonly="yes"><input type="hidden" name="consumer_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" value=""><input type="hidden" name="partner_id'+ row_count +'" value=""><input type="hidden" name="member_type'+ row_count +'" value=""><input type="hidden" name="employee_id'+ row_count +'" value=""><span title="üye seç" class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac1('+ row_count +');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="role_head'+ row_count +'" value="" maxlength="100"><input type="hidden" name="role_id'+ row_count +'" value=""><span title="rol seç" class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac2('+ row_count +');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" value="" name="product' + row_count +'"><input type="hidden" name="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_product(' + row_count + ');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="unit_name' + row_count +'" value="" readonly></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));"></div>';
				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="money_type' + row_count +'"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript://" onClick="copy_row('+row_count+');"><i class="fa fa-bar-chart" title="Grafik"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count + '"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="Sil"></i></a>';
	}
	function copy_row(no)
	{	
		code = eval('add_workgroup.code' + no).value;
		add_row(code);
	}
	function pencere_ac1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_consumer=add_workgroup.consumer_id'+no+'&field_comp_id=add_workgroup.company_id'+no+'&field_partner=add_workgroup.partner_id'+no+'&field_name=add_workgroup.member_name'+no+'&field_emp_id=add_workgroup.employee_id'+no+'&field_type=add_workgroup.member_type'+no+'&select_list=1,2,3'</cfoutput>);
	}
	function pencere_ac2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_list_position_names&field_name=add_workgroup.role_head'+no+'</cfoutput>');
	}
	function pencere_ac_product(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit&field_stock_id=add_workgroup.stock_id'+ no +'&field_id=add_workgroup.product_id'+ no +'&field_name=add_workgroup.product'+ no +'&field_unit=add_workgroup.unit_name'+ no+'&field_price=add_workgroup.price'+ no+'&field_money=add_workgroup.money_type'+ no +''</cfoutput>);
	}
	function grafik_ciz()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#attributes.workgroup_id#'</cfoutput>,'list','popup_draw_workgroup');
	}
	function fiyat_hesapla(satir)
		{
			if(eval("add_workgroup.price"+satir).value.length != 0 && eval("add_workgroup.amount"+satir).value.length != 0)
			{
				eval("add_workgroup.total_price" + satir).value =  filterNum(eval("document.add_workgroup.price"+satir).value) * filterNum(eval("document.add_workgroup.amount"+satir).value);
				eval("add_workgroup.total_price" + satir).value = commaSplit(eval("add_workgroup.total_price" + satir).value);
			}
			return true;
		}
	function sil(no)
	{	
	
		var my_element=eval("document.add_workgroup.row_kontrol"+no);
		my_element.value=0;
		
		var my_element=eval("frm_row"+no);
		my_element.style.display="none";
	}

	function control()
	{
		if(row_count==0 && kontrol_row_count=='')
		{
			alert("<cf_get_lang dictionary_id='38410.En Az Bir Grup Çalışan Kaydı Giriniz'>!");
			return false;
		}
		for(row_=1;row_<=row_count;row_++)
		{
			if(eval("document.add_workgroup.row_kontrol"+row_).value == 1)
			{
				_member_name=eval("document.add_workgroup.member_name"+row_);
				_product=eval("document.add_workgroup.product"+row_);
					
				if(_member_name.value=="")
				{
					alert("<cf_get_lang dictionary_id='36878.Görevli İsimlerini Kontrol Ediniz'>!");
					return false;
				}
				if(_product.value=="")
				{
					alert("<cf_get_lang dictionary_id='38412.Hizmet/Ürün Seçiniz'>!");
					return false;
				}
			}
		}
	}
</script>
