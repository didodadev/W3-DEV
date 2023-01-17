<br />
<cfset get_operations.recordcount = 0>
<cfquery name="get_operation_types" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE, OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_STATUS = 1
</cfquery>
<cfquery name="get_max" datasource="#dsn3#">
	SELECT MAX(PIECE_DEFAULT_ID) AS MAX_ID FROM EZGI_DESIGN_PIECE_DEFAULTS
</cfquery>
<cfif not len(get_max.max_id)>
	<cfset  sira = '0001'>
<cfelseif len(get_max.max_id) eq 1>
	<cfset  sira = '000#get_max.max_id+1#'>
<cfelseif len(get_max.max_id) eq 2>
	<cfset  sira = '00#get_max.max_id+1#'>
<cfelseif len(get_max.max_id) eq 3>
	<cfset  sira = '0#get_max.max_id+1#'>
<cfelse>
	<cfset  sira = '#get_max.max_id+1#'>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2830.Default Parça Ekle'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="add_default_piece" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_default_piece">
                	<cfif isdefined('attributes.is_piece')>
                    	<cfinput type="hidden" name="is_piece" value="1">
                    </cfif>
                	 <table>
                     	<tr height="25px"  id="design_name_">
                            <td width="100px" valign="top" style="font-weight:bold"><cf_get_lang_main no='81.Aktif'></td>
                            <td width="250px" valign="top">
                                <cfinput type="checkbox" id="status" name="status" value="1" checked="yes">
                            </td>
                      	</tr>
                     	<tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('main',2848)# #getLang('objects',256)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_code" id="default_code" readonly="yes" value="#sira#" maxlength="20" style="width:50px;" >
                            </td>
                      	</tr>
                        <tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('main',2848)# #getLang('main',485)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_type" id="default_type" value="" maxlength="50" style="width:240px;" >
                            </td>
                      	</tr>
                    </table>
                    <div id="operation_" style="width:380px">
                    	<cf_seperator title="#getLang('campaign',244)# #getLang('settings',1133)# #getLang('prod',63)#" id="_operation" is_closed="1">
                        <cf_form_list id="_operation">
                            <thead>
                                <tr>
                                    <th width="20px">
                                        <input type="hidden" name="record_num" id="record_num" value="0">
                                        <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="openOperatios();">
                                   	</th>
                                    <th width="40px"><cf_get_lang_main no='1165.Sıra'></th>
                                    <th width="230px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                                    
                                    <th width="60px"><cf_get_lang_main no='223.Miktar'></th>
                                </tr>
                            </thead>
                            <tbody name="new_row" id="new_row">
                                <cfif get_operations.recordcount>
                                    <cfoutput query="get_operations">
                                        <tr name="frm_row" id="frm_row#currentrow#">
                                            <td></td>
                                            <td>
                                            	<select id="current_id#currentrow#" name="current_id#currentrow#" style="width:40px">
                                                    <cfloop query="get_operation_types">
                                                    	<option value="#currentrow#">#currentrow#</option>
                                                    </cfloop>
                                                </select>
                                                <input type="text" name="current_id#currentrow#" id="current_id#currentrow#" value="#currentrow#" readonly="readonly" style="width:25px; text-align:right;">
                                            </td>
                                            <td nowrap="nowrap">
                                            	<select id="operation_type_id#currentrow#" name="operation_type_id#currentrow#" style="width:220px">
                                                	<option value="0">Seçiniz</option>
                                                    <cfloop query="get_operation_types">
                                                    	<option value="#OPERATION_TYPE_ID#">#OPERATION_CODE# - #OPERATION_TYPE#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                            <td>
                                            	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#get_operations.amount#" onkeyup="isNumber(this);" style="width:85px; text-align:right;">
                                          	</td>
                                        </tr>
                                    </cfoutput>
                                </cfif>
                            </tbody>
                        </cf_form_list>
                        <br />
                    </div>
                    <cf_form_box_footer>
                        <cf_workcube_buttons is_upd='0' is_cancel='1' add_function='kontrol()'>
                    </cf_form_box_footer>
          		</cfform>
          	</cf_form_box>
      	</td>
  	</tr>
</table>
<script type="text/javascript">
	document.getElementById('default_type').focus();
	var row_count=document.add_default_piece.record_num.value;
	function openOperatios()
	{
		window.open("<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_operations</cfoutput>","_blank","width=250,height=600,left=700,top=300");
	}
	function add_row(operation_type_id,operation_type)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		
		document.add_default_piece.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="current_id' + row_count +'" name="current_id' + row_count +'" value="' + row_count +'" readonly="readonly"  style="width:40px; text-align:right;"</select>';
			
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="operation_type_id'+row_count+'" name="operation_type_id'+row_count+'" value="'+operation_type_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="operation_type' + row_count + '" style="width:220px;" value="'+operation_type+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:60px; text-align:right;"  onkeyup="isNumber(this);">';
	}
	function sil(sy)
	{
	

		var element=eval("add_default_piece.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";		
	} 
	function kontrol()
	{
		if(document.getElementById("default_type").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='1622.Operasyon'> <cf_get_lang_main no='485.Adı'> !");
			document.getElementById('default_type').focus();
			return false;
		}
		if(document.getElementById("record_num").value > 0)
		{
			sayi = document.getElementById("record_num").value;
			for (i = 1; i <= sayi; i++)
			{
				if(document.getElementById("quantity"+i).value <=0 && document.getElementById("row_kontrol"+i).value == 1)
				{
					alert(i+'. <cf_get_lang_main no='2957.Satırdaki Operasyonun Miktarı Sıfırdan Büyük Olmalıdır'> !');
					document.getElementById("quantity"+i).focus();
					return false;
				}
				if(document.getElementById("operation_type_id"+i).value <=0 && document.getElementById("row_kontrol"+i).value == 1)
				{
					alert(i+'. <cf_get_lang_main no='2958.Satırdaki Operasyon Seçilmemiştir'> !');
					document.getElementById("operation_type_id"+i).focus();
					return false;
				}
			}
		}
	}
</script>