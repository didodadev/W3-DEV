<script type="text/javascript">
	<cfoutput>
		row_count_exit = #attributes.record_num_exit#;
		row_count_exit++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		opener.document.all.record_num_exit.value = row_count_exit;
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_exit' + row_count_exit +'" ><a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="hidden" name="process_id' + row_count_exit +'" value="#attributes.operation_type_id#"><input type="text" name="process' + row_count_exit +'" style="width:300px;" value="#attributes.operation_type#" readonly="">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="time' + row_count_exit +'" class="moneybox" onBlur="hesapla_deger(' + row_count_exit +',2);" style="width:60px;" value="#attributes.o_hour#" onKeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="minute' + row_count_exit +'" class="moneybox" onBlur="hesapla_deger(' + row_count_exit +',3);" style="width:60px;" value="#attributes.o_minute#" onKeyup="return(FormatCurrency(this,event));">';
		window.close();
	</cfoutput>
</script>
