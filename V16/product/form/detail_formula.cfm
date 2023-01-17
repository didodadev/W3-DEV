<cfsetting showdebugoutput="no">
<cfquery name="get_conf_compenents" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_FORMULA_COMPONENTS WHERE PRODUCT_FORMULA_ID = #attributes.product_formula_id#
</cfquery>
<cfquery name="get_conf_variation" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_FORMULA_VARIATION WHERE PRODUCT_FORMULA_ID = #attributes.product_formula_id#
</cfquery>
<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_conf_compenents.recordcount#</cfoutput>">
<input type="hidden" name="record_num2" id="record_num2" value="<cfoutput>#get_conf_variation.recordcount#</cfoutput>">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58910.Ürün Özellikleri'></cfsavecontent>
<cf_seperator id="ozellikler" header="#message#">
<cf_form_list id="ozellikler">
    <thead>
        <tr>
            <th width="15"><a href="javascript://" onClick="add_row_compenent();"> <img src="/images/plus_list.gif"  style="cursor:pointer;" border="0" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></a></th>
            <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th width="150"><cf_get_lang dictionary_id='57632.Özellik'></th>
            <th width="150"><cf_get_lang dictionary_id='50801.Katsayı'>/<cf_get_lang dictionary_id='57673.Tutar'></th>
            <th width="150"><cf_get_lang dictionary_id='50801.Katsayı'>/<cf_get_lang dictionary_id='57673.Tutar Miktarı'> </th>
        </tr>
    </thead>
    <tbody id="table">
    <cfset all_row_count = 0>
    <cfoutput query="get_conf_compenents">
        <tr id="compenent_row_frm_row#currentrow#">
            <td><a href="javascript://" onClick="sil_compenent(#currentrow#);"> <img  src="images/delete_list.gif" border="0" align="absmiddle"></a></td>
            <td>
                <input type="hidden" name="row_control#currentrow#" id="row_control#currentrow#" value="1">
                <input type="text" name="order_no#currentrow#" id="order_no#currentrow#" value="#order_no#" style="width:30px;" class="moneybox">
            </td>
            <td nowrap="nowrap">
                <input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
                <cfif len(property_id)>
                    <cfquery name="get_property_name" datasource="#dsn1#">
                        SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID =#property_id#
                    </cfquery>
                    <cfset property_name =  get_property_name.PROPERTY>  
                <cfelse>
                    <cfset property_name =  ''>
                </cfif>
                <input type="text" readonly="yes" value="#property_name#" name="property#currentrow#" id="property#currentrow#" style="width:140px;">
                <a href="javascript://" onClick="pencere_pos(#currentrow#,1);"><img border="0" src="/images/plus_thin.gif" align="absmiddle" title="<cf_get_lang dictionary_id='58201.Özellik Seç'>"></a>
            </td>
            <td>
                <select name="amount_type#currentrow#" id="amount_type#currentrow#" style="width:180px;" onchange="show_variation(#currentrow#);">
                    <option value="1" <cfif amount_type eq 1>selected</cfif>><cf_get_lang dictionary_id='60469.Katsayı Girilecek'></option>
                    <option value="4" <cfif amount_type eq 4>selected</cfif>><cf_get_lang dictionary_id='60471.Varyasyonlardan Herhangi Biri'></option>
                </select>
            </td>
            <td><input type="text" id="amount#currentrow#" name="amount#currentrow#" class="moneybox" value="#tlformat(amount,4)#" onKeyUp="return(FormatCurrency(this,event,4));" style="width:150px;"></td>
       </tr> 
        <cfquery name="get_conf_variation_row" dbtype="query">
            SELECT * FROM get_conf_variation WHERE PRODUCT_COMPENENT_ID = #PRODUCT_FORMULA_COMPENENTS_ID#
        </cfquery>
        <tr class="nohover" id="compenent_row_frm_row2_#currentrow#" valign="top" <cfif amount_type neq 4 and amount_type neq 5>style="display=none;"</cfif>>
            <td colspan="8">
                <cf_form_list>
                    <thead>
                        <tr>
                        	<th>&nbsp;</th>
                            <th width="120"><cf_get_lang dictionary_id='37249.Varyasyon'></th>
                            <th class="txtboldblue"><cf_get_lang dictionary_id='50801.Katsayı'></th>
                        </tr>
                    </thead>
                    <tbody  id="table2_#currentrow#">
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
                                <td><a style="cursor:pointer" onClick="sil_variation_relation(#all_row_count#);"><img  src="images/delete12.gif" border="0" ></a><input type="hidden" id="row_property_id#all_row_count#" name="row_property_id#all_row_count#" value="#get_conf_compenents.property_id#"></td>
                                <td><input type="hidden" id="row_control2_#all_row_count#" name="row_control2_#all_row_count#" value="1"><input type="hidden" id="variation_id#all_row_count#" name="variation_id#all_row_count#" value="#get_conf_variation_row.variation_property_detail_id#"><input type="text" id="variation_name#all_row_count#" name="variation_name#all_row_count#" value="#property_detail_row#"></td>
                                <td><input type="text" id="variation_value#all_row_count#" name="variation_value#all_row_count#" value="#tlformat(get_conf_variation_row.variaton_property_value)#" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox"></td>
                            </tr>
                        </cfloop>
                    </tbody>
                </cf_form_list>
            </td>
        </tr>
    </cfoutput>
    </tbody>
</cf_form_list>
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
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_compenent(' + row_count + ');"> <img  src="images/delete_list.gif" border="0"></a>';
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML += '<input type="hidden" id="row_control' + row_count + '" name="row_control' + row_count + '" value="1"><input type="text" class="moneybox" id="order_no' + row_count + '" name="order_no' + row_count + '" onkeyup="return(FormatCurrency(this,event));" style="width:30px;" value="'+row_count+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" id="property_id' + row_count +'" name="property_id' + row_count +'"><input type="text" readonly="yes" value="" id="property' + row_count +'" name="property' + row_count +'" style="width:140px;"><a href="javascript://" onClick="pencere_pos(' + row_count + ',1);"> <img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='58201.Özellik Seç'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="amount_type' + row_count + '" style="width:180px;" onchange="show_variation(' + row_count + ');"><option value="1">Katsayı Girilecek</option><option value="4">Varyasyonlardan Herhangi Biri</option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML += '<input type="text" id="amount' + row_count + '" name="amount' + row_count + '" onkeyup="return(FormatCurrency(this,event,4));" style="width:150px;" class="moneybox">';

		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.setAttribute("id","variations_td_rel_" + row_count);
		newCell2.colSpan = 8;
		newCell2.innerHTML = '<table  id="table2_'+ row_count +'" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:55;"><tr class="color-list"><td><a onClick="add_row_variation_relation('+row_count+');"><img src="/images/plus_small.gif"  style="cursor:pointer;" border="0" alt="Varyasyon Ekle"></td><td width="120" class="txtboldblue">Varyasyon</td><td class="txtboldblue">Katsayı</td></tr></table>';	
		newRow2.style.display='none';
	}
	function sil_variation_relation(row_id)
	{
		document.getElementById('row_control2_'+row_id).value=0;
		document.getElementById('variation_row_frm_row_relation'+row_id).style.display = 'none';		
	}
	function add_row_variation_relation(row_)
	{
		if(eval("document.add_product_formula.property_id"+row_).value == '' || eval("document.add_product_formula.property"+row_).value == '')
		{
			alert("<cf_get_lang dictionary_id='58201.Lütfen Önce Özellik Seçiniz'> !");
			return false;
		}
		else
		{
			for(kk=1;kk<=row_count2;kk++)
			{
				if(eval("document.add_product_formula.property_id"+row_).value == eval("document.add_product_formula.row_property_id"+kk).value)
					sil_variation_relation(kk,row_);
			}
			get_property_detail = wrk_query('SELECT PROPERTY_DETAIL,PROPERTY_DETAIL_ID,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE IS_ACTIVE = 1 AND PRPT_ID ='+eval("document.add_product_formula.property_id"+row_).value,'dsn1');
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
				newCell.innerHTML = '<input type="text" id="variation_value' + row_count2 + '" name="variation_value' + row_count2 + '" onkeyup="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox">';
			}
		}
	}
	function show_property(row_no)
	{
		if(document.getElementById('price_type'+row_no).value == 3)
			document.getElementById('property_row_td'+row_no).style.display='';
		else
			document.getElementById('property_row_td'+row_no).style.display='none';
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
	}
	function pencere_pos(no,type)
	{
		if(type == 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&ajax_form=1&call_function=add_row_variation_relation&call_function_paremeter='+no+'&property=property'+no+'&property_id=property_id' + no,'list'); 
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&ajax_form=1&property=property_row'+no+'&property_id=property_id_row' + no,'list'); 
	}
</script>
