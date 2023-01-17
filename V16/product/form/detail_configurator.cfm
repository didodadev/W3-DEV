<cfsetting showdebugoutput="no">
<cfquery name="get_conf_compenents" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id#
</cfquery>
<cfquery name="get_conf_variation" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id#
</cfquery>
<cfquery name="get_formula" datasource="#dsn3#">
	SELECT SF.* FROM SETUP_PRODUCT_FORMULA SF,SETUP_PRODUCT_CONFIGURATOR SP WHERE SP.PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id# AND SP.CONFIGURATOR_STOCK_ID = SF.FORMULA_STOCK_ID
</cfquery>
<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_conf_compenents.recordcount#</cfoutput>">
<input type="hidden" name="record_num2" id="record_num2" value="<cfoutput>#get_conf_variation.recordcount#</cfoutput>">
<cf_grid_list id="ozellikler" sort="0">
	<thead>
		<tr><th colspan="10"><cf_get_lang dictionary_id='58910.Ürün Özellikleri'></th></tr>
		<tr>
			<th width="15"><a href="javascript://" onClick="add_row_compenent();"><i class="fa fa-plus" border="0" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></i></a></th>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57632.Özellik'></th>
			<th><cf_get_lang dictionary_id='50801.Katsayı'>/<cf_get_lang dictionary_id='57673.Tutar'></th>
			<th><cf_get_lang dictionary_id='50801.Katsayı'>/<cf_get_lang dictionary_id='57673.Tutar'></th>
			<th><cf_get_lang dictionary_id='29801.Zorunlu'> / <cf_get_lang dictionary_id='58564.Var'>/<cf_get_lang dictionary_id='58546.Yok'></th>
			<th><cf_get_lang dictionary_id='60467.Fiyat Kriteri'></th>
			<th><cf_get_lang dictionary_id='58028.Formül'></th>
			<th id="property_row_th"><cf_get_lang dictionary_id='60468.Fiyat Kriter Özelliği'></th>
		</tr>
	</thead>
	<tbody id="table">
	<cfset all_row_count = 0>
	<cfoutput query="get_conf_compenents">
		<tr id="compenent_row_frm_row#currentrow#" valign="top">
			<td><a href="javascript://" onclick="sil_compenent(#currentrow#);"><i class="fa fa-minus" border="0" align="absmiddle"></i></a></td>
			<td>
				<div class="form-group"><input type="hidden" name="row_control#currentrow#" id="row_control#currentrow#" value="1">
				<input type="text" name="order_no#currentrow#" id="order_no#currentrow#" value="#order_no#" class="moneybox"></div>
			</td>
			<td nowrap>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
						<cfif len(property_id)>
							<cfquery name="get_property_name" datasource="#dsn1#">
								SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID =#property_id#
							</cfquery>
							<cfset property_name =  get_property_name.PROPERTY>  
						<cfelse>
							<cfset property_name =  ''>
						</cfif>
						<input type="text" readonly="yes" value="#property_name#" name="property#currentrow#" id="property#currentrow#">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_pos(#currentrow#,1);" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></span>
					</div>
				</div>
			</td>
			<td>
				<div class="form-group">
					<select name="amount_type#currentrow#" id="amount_type#currentrow#" style="width:180px;" onchange="show_variation(#currentrow#);">
						<option value="1" <cfif amount_type eq 1>selected</cfif>><cf_get_lang dictionary_id='60469.Katsayı Girilecek'></option>
						<option value="2" <cfif amount_type eq 2>selected</cfif>><cf_get_lang dictionary_id='60470.Katsayı Tanımlanan'></option>
						<option value="3" <cfif amount_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
						<option value="4" <cfif amount_type eq 4>selected</cfif>><cf_get_lang dictionary_id='60471.Varyasyonlardan Herhangi Biri'></option>
						<option value="5" <cfif amount_type eq 5>selected</cfif>><cf_get_lang dictionary_id='60472.Varyasyonların Çarpımı'></option>
						<option value="6" <cfif amount_type eq 6>selected</cfif>><cf_get_lang dictionary_id='58028.Formül'></option>
					</select>
				</div>
			</td>
			<td><input type="text" id="amount#currentrow#" name="amount#currentrow#" class="moneybox" value="#tlformat(amount,4)#" onkeyup="return(FormatCurrency(this,event,4));" style="width:150px;"></td>
			<td>
				<div class="form-group">
					<select name="req_type#currentrow#" id="req_type#currentrow#">
						<option value="1" <cfif require_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29801.Zorunlu'></option>
						<option value="2" <cfif require_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58564.Var'>/<cf_get_lang dictionary_id='58546.Yok'></option>
					</select>
				</div>
			</td>
			<td>
				<div class="form-group">
					<select name="price_type#currentrow#" id="price_type#currentrow#" onchange="show_property(#currentrow#);">
						<option value="1" <cfif price_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57638.Birim Fiyat'></option>
						<option value="2" <cfif price_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
						<option value="3" <cfif price_type eq 3>selected</cfif>><cf_get_lang dictionary_id='59106.Özellik'></option>
					</select>
				</div>
			</td>
			<td id="formula_row_td#currentrow#">
				<div class="form-group">
					<select name="formula_id#currentrow#" id="formula_id#currentrow#" <cfif amount_type neq 6>disabled="true"</cfif>>
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop query="get_formula">
							<option value="#product_formula_id#" <cfif get_conf_compenents.formula_id eq product_formula_id>selected</cfif>>#formula_name#</option>
						</cfloop>
					</select>
				</div>
			</td>
			<td <cfif price_type neq 3>style="display=none;"</cfif> id="property_row_td#currentrow#">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="property_id_row#currentrow#" id="property_id_row#currentrow#" value="#property_id_row#">
						<cfif len(property_id_row)>
							<cfquery name="get_property_name" datasource="#dsn1#">
								SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID =#property_id_row#
							</cfquery>
							<cfset property_name_row =  get_property_name.PROPERTY>  
						<cfelse>
							<cfset property_name_row =  ''>
						</cfif>
						<input type="text" value="#property_name_row#" name="property_row#currentrow#" id="property_row#currentrow#" style="width:130px;">
						<span class="input-group-addon icon-ellipsis btnPointer"onClick="pencere_pos(#currentrow#,2);" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></span>
					</div>
				</div>
			</td>
		</tr> 
		<cfquery name="get_conf_variation_row" dbtype="query">
			SELECT * FROM get_conf_variation WHERE PRODUCT_COMPENENT_ID = #PRODUCT_CONFIGURATOR_COMPENENTS_ID#
		</cfquery>
		<tr id="compenent_row_frm_row2_#currentrow#" valign="top" <cfif amount_type neq 4 and amount_type neq 5>style="display=none;"</cfif>>
			<td colspan="9">
				<table id="table2_#currentrow#" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:55;">
					<tr>
						<td></td>
						<td><cf_get_lang dictionary_id='37249.Varyasyon'></td><td class="txtboldblue"><cf_get_lang dictionary_id='50801.Katsayı'></td>
					</tr>
					<cfloop query="get_conf_variation_row">
						<cfset all_row_count = all_row_count + 1>
						<tr id="variation_row_frm_row_relation#all_row_count#">
							<cfif len(get_conf_variation_row.variation_property_detail_id)>
								<cfquery name="get_property_row_name" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID =#get_conf_variation_row.variation_property_detail_id#
								</cfquery>
								<cfset property_detail_row =  get_property_row_name.PROPERTY_DETAIL>  
							<cfelse>
								<cfset property_detail_row =  ''>
							</cfif>
							<td><a onclick="sil_variation_relation(#all_row_count#);"><i class="fa fa-minus" border="0"></i></a><input type="hidden" id="row_property_id#all_row_count#" name="row_property_id#all_row_count#" value="#get_conf_compenents.property_id#"></td>
							<td><input type="hidden" id="row_control2_#all_row_count#" name="row_control2_#all_row_count#" value="1"><input type="hidden" id="variation_id#all_row_count#" name="variation_id#all_row_count#" value="#get_conf_variation_row.variation_property_detail_id#"><input type="text" id="variation_name#all_row_count#" name="variation_name#all_row_count#" value="#property_detail_row#"></td>
							<td><input type="text" id="variation_value#all_row_count#" name="variation_value#all_row_count#" value="#tlformat(get_conf_variation_row.variaton_property_value,4)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
	</cfoutput>
	</tbody>
</cf_grid_list>
<script type="text/javascript">
	row_count='<cfoutput>#get_conf_compenents.recordcount#</cfoutput>';
	row_count2='<cfoutput>#get_conf_variation.recordcount#</cfoutput>';
	function sil_compenent(row_id)
	{
		document.getElementById('row_control'+row_id).value=0;
		document.getElementById('compenent_row_frm_row'+row_id).style.display='none';
	}
	function add_row_compenent()
	{
		row_count++;
		document.all.record_num.value = row_count;
		var newRow;
		var newCell;
		newRow = document.getElementById("table").insertRow(document.getElementById("table").rows.length);
		newRow.setAttribute("name","compenent_row_frm_row" + row_count);
		newRow.setAttribute("id","compenent_row_frm_row" + row_count);		
		newRow.setAttribute("NAME","compenent_row_frm_row" + row_count);
		newRow.setAttribute("ID","compenent_row_frm_row" + row_count);	

		newRow2 = document.getElementById("table").insertRow(document.getElementById("table").rows.length);
		newRow2.setAttribute("name","compenent_row_frm_row2_" + row_count);
		newRow2.setAttribute("id","compenent_row_frm_row2_" + row_count);		
		newRow2.setAttribute("NAME","compenent_row_frm_row2_" + row_count);
		newRow2.setAttribute("ID","compenent_row_frm_row2_" + row_count);	

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_compenent(' + row_count + ');"><i class="fa fa-minus" border="0"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML += '<div class="form-group"><input type="hidden" id="row_control' + row_count + '" name="row_control' + row_count + '" value="1"><input type="text" class="moneybox" id="order_no' + row_count + '" name="order_no' + row_count + '" onkeyup="return(FormatCurrency(this,event));" value="'+row_count+'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="property_id' + row_count +'" name="property_id' + row_count +'"><input type="text" readonly="yes" value="" name="property' + row_count +'" id="property' + row_count +'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_pos(' + row_count + ',1);" title="<cf_get_lang dictionary_id='58201.Özellik Seç'>"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="amount_type' + row_count + '" id="amount_type' + row_count + '" onchange="show_variation(' + row_count + ');"><option value="1"><cf_get_lang dictionary_id='60469.Katsayı Girilecek'></option><option value="2"><cf_get_lang dictionary_id='60470.Katsayı Tanımlanan'></option><option value="3">Tutar</option><option value="4"><cf_get_lang dictionary_id='60471.Varyasyonlardan Herhangi Biri'></option><option value="5"><cf_get_lang dictionary_id='60472.Varyasyonların Çarpımı'></option><option value="6"><cf_get_lang dictionary_id='58028.Formül'></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML += '<div class="form-group"><input type="text" id="amount' + row_count + '" name="amount' + row_count + '" onkeyup="return(FormatCurrency(this,event,4));" style="width:150px;" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="req_type' + row_count + '" style="width:110px;"><option value="1"><cf_get_lang dictionary_id='29801.Zorunlu'></option><option value="2">Var/Yok</option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="price_type' + row_count + '" id="price_type' + row_count + '" onchange="show_property(' + row_count + ');"><option value="1"><cf_get_lang dictionary_id='57638.Birim Fiyat'></option><option value="2"><cf_get_lang dictionary_id='57673.Tutar'></option><option value="3"><cf_get_lang dictionary_id='59106.Özellik'></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="formula_id' + row_count +'" name="formula_id' + row_count +'" style="width:140px;" disabled><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_formula"><option value="#product_formula_id#">#formula_name#</option></cfoutput></select></div>';
		newCell.setAttribute("id","formula_row_td" + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="property_id_row' + row_count +'" name="property_id_row' + row_count +'"><input type="text" value="" name="property_row' + row_count +'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_pos(' + row_count + ',2);" title="<cf_get_lang dictionary_id='58201.Özellik Seç'>"></span></div></div>';
		//newCell.style.display='none';
		newCell.setAttribute("id","property_row_td" + row_count);

		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.setAttribute("id","variations_td_rel_" + row_count);
		newCell2.colSpan = 9;
		newCell2.innerHTML = '<table  id="table2_'+ row_count +'" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:55;"><tr class="color-list"><td></td><td width="120" class="txtboldblue">Varyasyon</td><td class="txtboldblue"><cf_get_lang dictionary_id='50801.Katsayı'></td></tr></table>';	
		newRow2.style.display='none';
	}
	function sil_variation_relation(row_id)
	{
		document.getElementById('row_control2_'+row_id).value=0;
		document.getElementById('variation_row_frm_row_relation'+row_id).style.display = 'none';		
	}
	function add_row_variation_relation(row_)
	{
		if(eval("document.add_product_configuration.property_id"+row_).value == '' || eval("document.add_product_configuration.property"+row_).value == '')
		{
			alert("<cf_get_lang dictionary_id='58201.Özellik Seç'> !");
			return false;
		}
		else
		{
			for(kk=1;kk<=row_count2;kk++)
			{
				if(eval("document.add_product_configuration.property_id"+row_).value == eval("document.add_product_configuration.row_property_id"+kk).value)
					sil_variation_relation(kk,row_);
			}
			get_property_detail = wrk_query('SELECT PROPERTY_DETAIL,PROPERTY_DETAIL_ID,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE IS_ACTIVE = 1 AND PRPT_ID ='+eval("document.add_product_configuration.property_id"+row_).value,'dsn1');
			for(kk=0;kk<get_property_detail.recordcount;kk++)
			{
				row_count2++;
				document.all.record_num2.value = row_count2;
				var newRow;
				var newCell;
				newRow = document.getElementById("table2_"+row_).insertRow(document.getElementById("table2_"+row_).rows.length);
				newRow.setAttribute("name","variation_row_frm_row_relation" + row_count2);
				newRow.setAttribute("id","variation_row_frm_row_relation" + row_count2);		
				newRow.setAttribute("NAME","variation_row_frm_row_relation" + row_count2);
				newRow.setAttribute("ID","variation_row_frm_row_relation" + row_count2);	
				newRow.className = 'color-row';
				
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_variation_relation(' + row_count2 + ');"><img  src="images/delete12.gif" border="0" ></a><input type="hidden" id="row_property_id' + row_count2 + '" name="row_property_id' + row_count2 + '" value="'+get_property_detail.PRPT_ID[kk]+'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" id="row_control2_' + row_count2 + '" name="row_control2_' + row_count2 + '" value="1"><input type="hidden" id="variation_id' + row_count2 + '" name="variation_id' + row_count2 + '" value="'+get_property_detail.PROPERTY_DETAIL_ID[kk]+'"><input type="text" id="variation_name' + row_count2 + '" name="variation_name' + row_count2 + '" value="'+get_property_detail.PROPERTY_DETAIL[kk]+'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" id="variation_value' + row_count2 + '" name="variation_value' + row_count2 + '" onkeyup="return(FormatCurrency(this,event,4));" style="width:50px;" class="moneybox">';
			}
		}
	}
	function show_property(row_no)
	{
		if(document.getElementById('price_type'+row_no).value == 3)
		{
			document.getElementById('property_row_td'+row_no).style.display='';
			document.getElementById('property_row_th').style.display='';
		}	
		else
		{
			document.getElementById('property_row_td'+row_no).style.display='none';
			document.getElementById('property_row_th').style.display='none';
		}	
	}
	function show_variation(row_no)
	{
		if(document.getElementById('amount_type'+row_no).value == 4 || document.getElementById('amount_type'+row_no).value == 5)
		{
			document.getElementById('compenent_row_frm_row2_'+row_no).style.display='';
			add_row_variation_relation(row_no);
		}
		else
			document.getElementById('compenent_row_frm_row2_'+row_no).style.display='none';
		
		if(document.getElementById('amount_type'+row_no).value == 6)
			document.getElementById('formula_id'+row_no).disabled=false;
		else
			document.getElementById('formula_row_td'+row_no).disabled=true;
	}
	function pencere_pos(no,type)
	{
		if(type == 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&ajax_form=1&call_function=add_row_variation_relation&call_function_paremeter='+no+'&property=property'+no+'&property_id=property_id' + no,'list'); 
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&ajax_form=1&property=property_row'+no+'&property_id=property_id_row' + no,'list'); 
	}
</script>
