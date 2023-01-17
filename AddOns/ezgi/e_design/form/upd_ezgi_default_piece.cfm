<cfquery name="get_operation_types" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE, OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_STATUS = 1
</cfquery>
<cfquery name="get_upd" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE_DEFAULTS WHERE PIECE_DEFAULT_ID = #attributes.piece_id#
</cfquery>
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE_DEFAULTS_ROTA WHERE PIECE_DEFAULT_ID = #attributes.piece_id#
</cfquery>
<cfquery name="get_delete_control" datasource="#dsn3#">
	SELECT PIECE_ROW_ID FROM EZGI_DESIGN_PIECE WHERE MASTER_PRODUCT_ID = #attributes.piece_id#
</cfquery>
<cfif get_upd.recordcount>
	<cfset recordnum = get_operations.recordcount>
<cfelse>
	<cfset recordnum = 0>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2831.Default Parça Güncelle'></td>
        <td class="dphb">
        	<cfoutput>
				<a href="#request.self#?fuseaction=prod.add_ezgi_default_piece">
                	<img src="/images/plus_list.gif" style="text-align:center" title="#getLang('main',2830)#">
             	</a>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="upd_default_piece" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_default_piece">
                	<cfinput type="hidden" name="piece_id" value="#attributes.piece_id#">
                	 <table>
                     	<tr height="25px"  id="design_name_">
                            <td width="100px" valign="top" style="font-weight:bold"><cf_get_lang_main no='81.Aktif'></td>
                            <td width="290px" valign="top">
                                <cfinput type="checkbox" id="status" name="status" value="1" checked="yes">
                            </td>
                      	</tr>
                     	<tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='2945.Kodu'> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_code" id="default_code" readonly="yes" value="#get_upd.PIECE_DEFAULT_CODE#" maxlength="20" style="width:50px;" >
                            </td>
                      	</tr>
                        <tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='485.Adı'> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_type" id="default_type" value="#get_upd.PIECE_DEFAULT_NAME#" maxlength="50" style="width:240px;" >
                                <cf_language_info 
                                    table_name="EZGI_DESIGN_PIECE_DEFAULTS" 
                                    column_name="PIECE_DEFAULT_NAME" 
                                    column_id_value="#attributes.piece_id#" 
                                    maxlength="500" 
                                    datasource="#dsn3#" 
                                    column_id="PIECE_DEFAULT_ID" 
                                    control_type="0">
                            </td>
                      	</tr>
                    </table>
                    <div id="operation_" style="width:380px">
                    	<cf_seperator title="#getLang('campaign',244)# #getLang('settings',1133)# #getLang('prod',63)#" id="_operation" is_closed="1">
                        <cf_form_list id="_operation">
                            <thead>
                                <tr>
                                    <th width="20px">
                                        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#recordnum#</cfoutput>">
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
                                    	<tr name="frm_row#currentrow#" id="frm_row#currentrow#">
                                        	<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                            <td>
                                            	<a style="cursor:pointer" onclick="sil(#currentrow#);" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>
                                            
                                            </td>
                                            <td>
                                                <input type="text" name="current_id#currentrow#" id="current_id#currentrow#" value="#currentrow#" readonly="readonly" style="width:25px; text-align:right;">
                                            </td>
                                            <td nowrap="nowrap">
                                            	<select id="operation_type_id#currentrow#" name="operation_type_id#currentrow#" style="width:220px">
                                                	<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfloop query="get_operation_types">
                                                    	<option value="#OPERATION_TYPE_ID#" <cfif get_operations.OPERATION_TYPE_ID eq OPERATION_TYPE_ID>selected</cfif>>#OPERATION_CODE# - #OPERATION_TYPE#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                            <td>
                                            	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(get_operations.QUANTITY,2)#" onkeyup="isNumber(this);" style="width:85px; text-align:right;">
                                          	</td>
                                        </tr>
                                    </cfoutput>
                                </cfif>
                            </tbody>
                        </cf_form_list>
                        <br />
                    </div>
                    <cf_form_box_footer>
                    	<cfif not get_delete_control.recordcount>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_default_piece&piece_id=#attributes.piece_id#'
                                add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete = '0' 
                                add_function='kontrol()'>
                        </cfif>
                        <cf_record_info 
                            query_name="get_upd"
                            record_emp="RECORD_EMP" 
                            record_date="record_date"
                            update_emp="UPDATE_EMP"
                            update_date="update_date">
                    </cf_form_box_footer>
          		</cfform>
          	</cf_form_box>
      	</td>
  	</tr>
</table>
<script type="text/javascript">
	document.getElementById('default_type').focus();
	var row_count=document.upd_default_piece.record_num.value;
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
		document.upd_default_piece.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="current_id' + row_count +'" name="current_id' + row_count +'" value="' + row_count +'" readonly="readonly"  style="width:25px; text-align:right;">';
			
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="operation_type_id'+row_count+'" name="operation_type_id'+row_count+'" value="'+operation_type_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="operation_type' + row_count + '" style="width:220px;" value="'+operation_type+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:85px; text-align:right;"  onkeyup="isNumber(this);">';
	}
	function sil(sy)
	{
		var element=eval("upd_default_piece.row_kontrol"+sy);
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