<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cf_grid_list>
			<thead>
				<tr>
					<input type="hidden" name="record_num1" id="record_num1" value="0">
					<th nowrap="nowrap"><a style="cursor:pointer" onclick="add_row();"><i class="fa fa-plus" alt="" border="0"></i></a></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='61787.Alım Günü'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='54821.Ödeme Günü'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='61788.Ödeme Ayı'></th>
				</tr>
			</thead>
			<tbody id="table1"></tbody>
		</cf_grid_list>
		<cfform name="add_payment" action="" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-group_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58969.Grup Adı'></label>
                        <div class="col col-4 col-sm-12">
							<input type="text" id="group_name" name="group_name" value="" />
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons add_function="kontrol()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	var row_count1= 0;
	
	function sil1(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row1"+sy);
		my_element.style.display="none";
	}
	
	function add_row()
	{
		row_count1++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
		newRow.setAttribute("name","frm_row1" + row_count1);
		newRow.setAttribute("id","frm_row1" + row_count1);
		document.getElementById("record_num1").value=row_count1;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count1+'" id="row_kontrol'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" border="0"></i></a>';
		
		<cfoutput>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="alim_start'+row_count1+'" id="alim_start'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#">#cc#</option></cfloop></select> <select name="alim_finish'+row_count1+'" id="alim_finish'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#">#cc#</option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="odeme_start'+row_count1+'" id="odeme_start'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#">#cc#</option></cfloop></select> <select name="odeme_finish'+row_count1+'" id="odeme_finish'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#">#cc#</option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="odeme_month'+row_count1+'" id="odeme_month'+row_count1+'" style="width:120px;"> <option value="0"><cf_get_lang dictionary_id='61789.Bu Ay'></option> <option value="1"><cf_get_lang dictionary_id='61790.Takip Eden Ay'></option> </select>';
		</cfoutput>
	}
	
	function kontrol()
	{
		if(document.getElementById('group_name').value == '')
		{
			alert('<cf_get_lang dictionary_id='61791.Grup Adı Giriniz'>!');
			return false;	
		}	
		
		if(row_count1 == 0)
		{
			alert('<cf_get_lang dictionary_id='61792.En Az 1 Satır Girmelisiniz'>!');
			return false;		
		}
		else
		{
			aktif_satir_ = 0;
			
			for(var i=1; i<= row_count1; i++)
			{
				if(document.getElementById('row_kontrol' + i).value == '1')
					aktif_satir_ = 1;
			}
			
			if(aktif_satir_ == 0)
			{
				alert('<cf_get_lang dictionary_id='61792.En Az 1 Satır Girmelisiniz'>!');
				return false;		
			}
		}
	}
</script>