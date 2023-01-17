<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.product_formula_id")>
    <cfquery name="get_formula_rows" datasource="#dsn3#">
        SELECT * FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_FORMULA_ID = #attributes.product_formula_id#
    </cfquery>
    <cfquery name="get_property" datasource="#dsn3#">
        SELECT PP.PROPERTY_ID,PP.PROPERTY FROM SETUP_PRODUCT_FORMULA_COMPONENTS SPC,#dsn1_alias#.PRODUCT_PROPERTY PP WHERE PRODUCT_FORMULA_ID = #attributes.product_formula_id# AND SPC.PROPERTY_ID = PP.PROPERTY_ID
    </cfquery>
<cfelse>
    <cfquery name="get_formula_rows" datasource="#dsn3#">
        SELECT * FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id#
    </cfquery>
    <cfquery name="get_property" datasource="#dsn3#">
        SELECT PP.PROPERTY_ID,PP.PROPERTY FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS SPC,#dsn1_alias#.PRODUCT_PROPERTY PP WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id# AND SPC.PROPERTY_ID = PP.PROPERTY_ID
    </cfquery>
</cfif>
<input type="hidden" name="record_num_formula" id="record_num_formula" value="<cfoutput>#get_formula_rows.recordcount#</cfoutput>">
<cf_grid_list id="fiyat_hesaplama_formulu" sort="0">
    <thead>
        <tr><th colspan="10"><cf_get_lang dictionary_id='37141.Fiyat Hesaplama Formülü'></th></tr>
        <tr>
            <th width="15"><a href="javascript://" onClick="add_row_formula();"><i class="fa fa-plus" border="0" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a></th>
            <th><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='57632.Özellik'></th>
            <th><cf_get_lang dictionary_id='60473.İlişkili Satır'></th>
            <cfif isdefined("attributes.product_formula_id")>
                <th><cf_get_lang dictionary_id='32879.Sayı'></th>
            </cfif>
            <cfif not isdefined("attributes.product_formula_id")>
                <th><cf_get_lang dictionary_id='57692.İşlem'></th>
            </cfif>
                <th>2.<cf_get_lang dictionary_id='57632.Özellik'></th>
                <th><cf_get_lang dictionary_id='60473.İlişkili Satır'></th>
            <cfif isdefined("attributes.product_formula_id")>
                <th><cf_get_lang dictionary_id='32879.Sayı'></th>
                <th><cf_get_lang dictionary_id='57692.İşlem'></th>
            </cfif>
        </tr>
    </thead>
    <tbody id="table3">
        <cfoutput query="get_formula_rows">
            <tr class="color-list" id="compenent_row_frm_row1_#currentrow#">
                <td><a href="javascript://" onClick="sil_row_formula(#currentrow#);"><i class="fa fa-minus" border="0" align="absmiddle"></i></a></td>
                <td width="15">
                    <div class="form-group"><input type="hidden" name="row_control_formula#currentrow#" id="row_control_formula#currentrow#" value="1">
                    <input type="text" name="order_no_formula#currentrow#" id="order_no_formula#currentrow#" value="#order_no#" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>
                </td>
                <td>
                    <div class="form-group">
                        <select id="property_id_formula#currentrow#" name="property_id_formula#currentrow#">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_property">
                                <option value="#property_id#" <cfif property_id eq get_formula_rows.property_id>selected</cfif>>#property#</option>
                            </cfloop>
                        </select>        
                    </div>                           
                </td>
                <td><div class="form-group"><input type="text" class="moneybox" id="row_no_formula#currentrow#" name="row_no_formula#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#related_row#"></div></td>
                <cfif isdefined("attributes.product_formula_id")>
                    <td><div class="form-group"><input type="text" class="moneybox" id="number_formula#currentrow#" name="number_formula#currentrow#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(pro_amount,8)#"></div></td>
                </cfif>
                <cfif not isdefined("attributes.product_formula_id")>
                    <td>
                        <div class="form-group">
                            <select id="act_type#currentrow#" name="act_type#currentrow#">
                                <option value="1" <cfif get_formula_rows.act_type eq 1>selected</cfif>><cf_get_lang dictionary_id='60474.Topla'></option>
                                <option value="2" <cfif get_formula_rows.act_type eq 2>selected</cfif>><cf_get_lang dictionary_id='60475.Çarp'></option>
                                <option value="3" <cfif get_formula_rows.act_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60476.Böl'></option>
                            </select>
                        </div>
                    </td>
                </cfif>
                <td>
                    <div class="form-group">
                        <select id="property_id_formula2_#currentrow#" name="property_id_formula2_#currentrow#">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_property">
                                <option value="#property_id#" <cfif property_id eq get_formula_rows.property_id1>selected</cfif>>#property#</option>
                            </cfloop>
                        </select>        
                    </div>                           
                </td>
                <td><div class="form-group"><input type="text" class="moneybox" id="row_no_formula2_#currentrow#" name="row_no_formula2_#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#related_row1#"></div></td>
                <cfif isdefined("attributes.product_formula_id")>
                    <td><div class="form-group"><input type="text" class="moneybox" id="number_formula2_#currentrow#" name="number_formula2_#currentrow#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(pro_amount1,8)#"></div></td>
                    <td>
                        <div class="form-group">
                            <select id="act_type#currentrow#" name="act_type#currentrow#">
                                <option value="1" <cfif get_formula_rows.act_type eq 1>selected</cfif>><cf_get_lang dictionary_id='60474.Topla'></option>
                                <option value="2" <cfif get_formula_rows.act_type eq 2>selected</cfif>><cf_get_lang dictionary_id='60475.Çarp'></option>
                                <option value="3" <cfif get_formula_rows.act_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60476.Böl'></option>
                            </select>
                        </div>
                    </td>
                </cfif>
            </tr> 
        </cfoutput>
    </tbody>
</cf_grid_list>
<script type="text/javascript">
	row_count3='<cfoutput>#get_formula_rows.recordcount#</cfoutput>';
	function sil_row_formula(row_id)
	{
		document.getElementById('row_control_formula'+row_id).value=0;
		document.getElementById('compenent_row_frm_row1_'+row_id).style.display='none';
	}
	function add_row_formula()
	{
		row_count3++;
		document.all.record_num_formula.value = row_count3;
		var newRow;
		var newCell;
		newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);
		newRow.setAttribute("name","compenent_row_frm_row1_" + row_count3);
		newRow.setAttribute("id","compenent_row_frm_row1_" + row_count3);		
		newRow.setAttribute("NAME","compenent_row_frm_row1_" + row_count3);
		newRow.setAttribute("ID","compenent_row_frm_row1_" + row_count3);	

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_row_formula(' + row_count3 + ');"><i class="fa fa-minus" border="0"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML += '<div class="form-group"><input type="hidden" id="row_control_formula' + row_count3 + '" name="row_control_formula' + row_count3 + '" value="1"><input type="text" class="moneybox" id="order_no_formula' + row_count3 + '" name="order_no_formula' + row_count3 + '" onkeyup="return(FormatCurrency(this,event));" value="'+row_count3+'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="property_id_formula' + row_count3 +'" name="property_id_formula' + row_count3 +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_property"><option value="#property_id#">#property#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" id="row_no_formula' + row_count3 + '" name="row_no_formula' + row_count3 + '" onkeyup="return(FormatCurrency(this,event));" value=""></div>';
		<cfif isdefined("attributes.product_formula_id")>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" id="number_formula' + row_count3 + '" name="number_formula' + row_count3 + '" onkeyup="return(FormatCurrency(this,event,8));" value=""></div>';
		</cfif>
		<cfif not isdefined("attributes.product_formula_id")>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select id="act_type' + row_count3 +'" name="act_type' + row_count3 +'"><option value="1">Topla</option><option value="2"><cf_get_lang dictionary_id='60475.Çarp'></option><option value="3"><cf_get_lang dictionary_id='60476.Böl'></option></select></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="property_id_formula2_' + row_count3 +'" name="property_id_formula2_' + row_count3 +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_property"><option value="#property_id#">#property#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" id="row_no_formula2_' + row_count3 + '" name="row_no_formula2_' + row_count3 + '" onkeyup="return(FormatCurrency(this,event));" value=""></div>';
		<cfif isdefined("attributes.product_formula_id")>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" id="number_formula2_' + row_count3 + '" name="number_formula2_' + row_count3 + '" onkeyup="return(FormatCurrency(this,event,8));" value=""></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select id="act_type' + row_count3 +'" name="act_type' + row_count3 +'"><option value="1">Topla</option><option value="2"><cf_get_lang dictionary_id='60475.Çarp'></option><option value="3"><cf_get_lang dictionary_id='60476.Böl'></option></select></div>';
		</cfif>
	}
</script>
