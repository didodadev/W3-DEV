<cfquery name="Upd_Payment_Group" datasource="#dsn_dev#">
	SELECT
    	PAYMENT_GROUP_ID,
        PAYMENT_GROUP_NAME
	FROM
    	PAYMENT_GROUP 
    WHERE
		PAYMENT_GROUP_ID = #attributes.group_id#               
</cfquery>
<cfquery name="Upd_Payment_Group_Row" datasource="#dsn_dev#">
	SELECT
    	*
	FROM
    	PAYMENT_GROUP_ROW
	WHERE
		PAYMENT_GROUP_ID = #attributes.group_id#
</cfquery>

<cf_form_box title="Grup Güncelle">
	<cfform name="upd_payment" action="" method="post">
		<table>
        	<tr>
            	<td>Grup Adı</td>
            	<td>
                	<input type="hidden" id="group_id" name="group_id" value="<cfoutput>#attributes.Group_Id#</cfoutput>" />
	                <input type="text" id="group_name" name="group_name" value="<cfoutput>#Upd_Payment_Group.Payment_Group_Name#</cfoutput>" />
				</td>
            </tr>
        </table>
        <table align="left">
            <tr>
                <td>
                    <cf_form_list>
                        <thead>
                            <tr>
                                <input type="hidden" name="record_num1" id="record_num1" value="<cfoutput>#Upd_Payment_Group_Row.RecordCount#</cfoutput>">
                                <th nowrap="nowrap"><a style="cursor:pointer" onclick="add_row1();"><img src="images/plus_list.gif" alt="" border="0"></a></th>
                                <th nowrap="nowrap">Alım Gün</th>
                                <th nowrap="nowrap">Ödeme Gün</th>
                                <th nowrap="nowrap">Ödeme Ayı</th>
                            </tr>
                        </thead>
                        <tbody id="table1">
                        <cfif Upd_Payment_Group_Row.Recordcount>
                            <cfoutput query="Upd_Payment_Group_Row">
                                <tr id="frm_row1#currentrow#">
                                	<td>
										<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                       					<input type="hidden" value="#payment_group_row_id#" name="payment_group_row_id#currentrow#" id="payment_group_row_id#currentrow#">
                                        <a style="cursor:pointer" onclick="sil1(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>
                                    </td>
                                    <td>
                                        <select name="alim_start#currentrow#" id="alim_start#currentrow#" style="width:120px;">
                                            <cfloop from="1" to="31" index="cc">
                                                <option value="#cc#" <cfif Upd_Payment_Group_Row.alim_start eq cc> selected</cfif>>#cc#</option>
                                            </cfloop>
                                        </select>
                                        <select name="alim_finish#currentrow#" id="alim_finish#currentrow#" style="width:120px;">
                                            <cfloop from="1" to="31" index="cc">
                                                <option value="#cc#" <cfif Upd_Payment_Group_Row.alim_finish eq cc> selected</cfif>>#cc#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="odeme_start#currentrow#" id="odeme_start#currentrow#" style="width:120px;">
                                            
                                            <cfloop from="1" to="31" index="cc">
                                                <option value="#cc#" <cfif Upd_Payment_Group_Row.odeme_start eq cc> selected</cfif>>#cc#</option>
                                            </cfloop>
                                        </select>
                                        <select name="odeme_finish#currentrow#" id="odeme_finish#currentrow#" style="width:120px;">
                                            <cfloop from="1" to="31" index="cc">
                                                <option value="#cc#" <cfif Upd_Payment_Group_Row.odeme_finish eq cc> selected</cfif>>#cc#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                    	<select name="odeme_month#currentrow#" id="odeme_month#currentrow#" style="width:120px;">
                                            <option value="0" <cfif Upd_Payment_Group_Row.odeme_month eq 0>selected</cfif>>Bu Ay</option> 
                                            <option value="1" <cfif Upd_Payment_Group_Row.odeme_month eq 1>selected</cfif>>Takip Eden Ay</option> 
                                        </select>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfif>
                        </tbody>
                    </cf_form_list>
                </td>
            </tr>
        </table>
        <cf_form_box_footer>
	        <cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_payment_group&group_id=#attributes.group_id#"> 
        </cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	var row_count1 = <cfoutput>#Upd_Payment_Group_Row.recordcount#</cfoutput>;
	
	function sil1(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row1"+sy);
		my_element.style.display="none";
	}

	function add_row1()
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count1+'" id="row_kontrol'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		
		<cfoutput>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="alim_start'+row_count1+'" id="alim_start'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#" <cfif Upd_Payment_Group_Row.alim_start eq cc> selected</cfif>>#cc#</option></cfloop></select> <select name="alim_finish'+row_count1+'" id="alim_finish'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#" <cfif Upd_Payment_Group_Row.alim_finish eq cc> selected</cfif>>#cc#</option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="odeme_start'+row_count1+'" id="odeme_start'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#" <cfif Upd_Payment_Group_Row.odeme_start eq cc> selected</cfif>>#cc#</option></cfloop></select> <select name="odeme_finish'+row_count1+'" id="odeme_finish'+row_count1+'" style="width:120px;"><cfloop from="1" to="31" index="cc"><option value="#cc#" <cfif Upd_Payment_Group_Row.odeme_finish eq cc> selected</cfif>>#cc#</option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="odeme_month'+row_count1+'" id="odeme_month'+row_count1+'" style="width:120px;"> <option value="0" <cfif Upd_Payment_Group_Row.odeme_month eq 0>selected</cfif>>Bu Ay</option> <option value="1" <cfif Upd_Payment_Group_Row.odeme_month eq 1>selected</cfif>>Takip Eden Ay</option> </select>';
		</cfoutput>
	}
	
	function kontrol()
	{
		if(document.getElementById('group_name').value == '')
		{
			alert('Grup Adı Giriniz!');
			return false;	
		}	
		
		if(row_count1 == 0)
		{
			alert('En Az 1 Satır Girmelisiniz!');
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
				alert('En Az 1 Satır Girmelisiniz!');
				return false;		
			}
		}
	}
</script>