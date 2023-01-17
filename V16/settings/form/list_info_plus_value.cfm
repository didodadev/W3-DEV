<cfsetting showdebugoutput="no">
<cfif listfind('-1,-2,-3,-4,-10,-13,-19,-20,-15,-18,-21,-23,-25', attributes.owner_type_id,',')>
	<cfset DB_ADI ="#DSN#">
	<cfset TABLO_ADI ="SETUP_INFOPLUS_VALUES">
	<cfset ALAN1 ="INFO_ID">
<cfelse>
	<cfset DB_ADI ="#DSN3#">
	<cfset TABLO_ADI ="SETUP_PRO_INFO_PLUS_VALUES">
	<cfset ALAN1 ="PRO_INFO_ID">
</cfif>
<cfquery name="GET_VALUES" datasource="#DB_ADI#">
	SELECT
    	SELECT_VALUE,
		INFO_ROW_ID
	FROM
		#TABLO_ADI#
	WHERE
		#ALAN1# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_id#"> AND 
        PROPERTY_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_no#">
	ORDER BY
		INFO_ROW_ID
</cfquery>

<cf_box closable="1">
<cf_grid_list>
	<input type="hidden" name="info_id_<cfoutput>#attributes.row_no#</cfoutput>" id="info_id" value="<cfoutput>#attributes.info_id#</cfoutput>">
	<input type="hidden" name="record_num_<cfoutput>#attributes.row_no#</cfoutput>" id="record_num" value="<cfoutput>#get_values.recordcount#</cfoutput>">
	<input type="hidden" name="row_no_<cfoutput>#attributes.row_no#</cfoutput>" id="row_no" value="<cfoutput>#attributes.row_no#</cfoutput>">
				<thead>
				<tr>
					<th style="width:30px;"><input type="button" class="eklebuton" title="" onclick="add_row();"></th>
					<th class="txtboldblue">&nbsp;<cf_get_lang_main no='821.Tanım'> *</th>
				</tr>
				</thead>
				<tbody id="link_table">
				<cfoutput query="get_values">
					<tr id="my_row_#currentrow#">
						<td></td>
						<td>
                        	<input type="hidden" name="info_row_id_#attributes.row_no#_#get_values.currentrow#" id="info_row_id_#get_values.currentrow#" value="#get_values.info_row_id#">
                        	<input type="text" name="value_#attributes.row_no#_#get_values.currentrow#" id="value_#get_values.currentrow#" value="#get_values.select_value#" maxlength="100" style="width:100px;">
                        </td>
					</tr>
				</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" style="text-align:right">
							<div id="show_info_xml_setup"></div>
							<input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang_main no='49.Kaydet'>" onclick="kontrol_form();">
						</td>		
					</tr>
				</tfoot>
</cf_grid_list>

<script language="javascript">
	row_count = "<cfoutput>#get_values.recordcount#</cfoutput>";
	row_no = "<cfoutput>#attributes.row_no#</cfoutput>";
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		document.getElementById('record_num').value=row_count;
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value_'+ row_no + "_" + row_count +'" id="value_'+ row_count +'" value="" maxlength="100" style="width:100px;">';
	}
	function kontrol_form()
	{
		for(kk=1;kk<=document.getElementById('record_num').value;kk++)
		{
			if(eval("document.getElementById('value_" + kk + "')").value == '')
			{
				alert("<cf_get_lang no='1240.Lütfen Tanım Giriniz'> ! <cf_get_lang_main no='1096.Satır'> :"+kk);
				return false;
			}
		}
		document.upd_pro_info.submit();
	}
</script>


