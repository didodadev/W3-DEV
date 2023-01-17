<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT
		PROPERTY_DETAIL_ID,
		PROPERTY_DETAIL
	FROM
		PRODUCT_PROPERTY_DETAIL
	WHERE
		IS_ACTIVE = 1 AND
		PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#">
	ORDER BY
		PROPERTY_DETAIL
</cfquery>
<cfif isdefined("form_name")>
<cfif form_name is 'add_related_features'>
	<cf_xml_page_edit fuseact="product.popup_form_add_product_dt_property">
<cfelseif form_name is 'upd_related_features'>
	<cf_xml_page_edit fuseact="product.popup_form_upd_product_dt_property">
</cfif>
</cfif>

<script type="text/javascript">
	<cfoutput>
		<cfif isdefined("form_name")>
		row_count = <cfif isdefined("attributes.draggable")>#attributes.form_name#<cfelse>opener.document.all</cfif>.record_num.value;
		<cfelse>
		row_count = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.record_num.value;
		</cfif>
		row_count++;
		var newRow;
		var newCell;
		newRow = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById("table1").insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		<cfif isdefined("form_name")>
		<cfif isdefined("attributes.draggable")>#attributes.form_name#<cfelse>opener.document.all</cfif>.record_num.value=row_count;
		<cfelse>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.record_num.value=row_count;
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="property_id' + row_count +'" id="property_id' + row_count +'" value="#attributes.property_id#"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1" ><input type="text" name="property' + row_count +'" id="property' + row_count +'" readonly="yes" value="#attributes.property#">&nbsp;<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_pos(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif IsDefined("attributes.xml_auto_product_code_2") and attributes.xml_auto_product_code_2 EQ 0>
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="variation_id' + row_count +'" id="variation_id' + row_count +'" value=""><input type="text" name="variation' + row_count +'" id="variation' + row_count +'" readonly="yes" value="">&nbsp;<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_var(' + row_count + ');"></span></div></div>';
		<cfelse>
		newCell.innerHTML = '<div class="form-group"><select name="variation_id' + row_count +'" id="variation_id' + row_count +'"><option value=""><cf_get_lang dictionary_id='37249.Varyasyon'></option><cfloop query="get_property_detail"><option value="#property_detail_id#">#property_detail#</option></cfloop></select></div>';
		</cfif>
		<cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="product_property_id' + row_count +'" id="product_property_id' + row_count +'" value=""><input type="text" name="product_property' + row_count +'" id="product_property' + row_count +'"  value="">&nbsp;<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_product_property(' + row_count + ');"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="detail' + row_count +'" id="detail' + row_count +'" value="" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cf_get_lang dictionary_id ="37038.Açıklama Alanına En Fazla 300 Karakter Girilebilir">!"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="line_row' + row_count +'" id="line_row' + row_count +'" value="" class="moneybox" maxlength="2" onKeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="col col-6 pl-0"><input type="text" name="total_max' + row_count +'" id="total_max' + row_count +'"  onKeyup="return(FormatCurrency(this,event));"> / </div><div class="col col-6 pr-0"><input type="text" name="total_min' + row_count +'" onKeyup="return(FormatCurrency(this,event));"></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'"  onKeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_optional' + row_count +'" id="is_optional' + row_count +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_exit' + row_count +'" id="is_exit' + row_count +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_internet' + row_count +'" id="is_internet' + row_count +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i  class="fa fa-minus"></i></a>';
	</cfoutput>
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
</script>
