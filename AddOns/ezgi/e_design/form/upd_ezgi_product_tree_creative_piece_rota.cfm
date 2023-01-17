<cfquery name="get_operation_types" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE, OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_STATUS = 1
</cfquery>
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE_ROTA WHERE PIECE_ROW_ID = #attributes.piece_id# ORDER BY SIRA
</cfquery>
<cfif get_operations.recordcount>
	<cfset recordnum = get_operations.recordcount>
<cfelse>
	<cfset recordnum = 0>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2910.Parça Operasyonlarını Güncelle'></td>
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
            	<cfform name="upd_piece_rota" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_piece_rota">
                	<cfinput type="hidden" name="piece_id" value="#attributes.piece_id#">
                    <cfif isdefined('attributes.master_plan_id')>
                    	<cfinput type="hidden" name="master_plan_id" value="#attributes.master_plan_id#">
                    </cfif>
                    <div id="operation_" style="width:360px">
                    	<cf_seperator title="#getLang('prod',63)#" id="_operation" is_closed="1">
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
                                            	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(get_operations.amount,2)#" style="width:65px; text-align:right;">
                                          	</td>
                                        </tr>
                                    </cfoutput>
                                </cfif>
                            </tbody>
                        </cf_form_list>
                        <br />
                    </div>
                    <br />
                    <table>
                        <tr>
                            <td style="text-align:right; vertical-align:middle; height:25px">
                                <cfinput type="button" value="#getLang('main',50)#" name="cnc_buton" onClick="window.close();">&nbsp;
                                <cfinput type="button" value="#getLang('main',52)#" name="upd_buton" onClick="kontrol();">&nbsp;
                                <cfinput type="button" value="#getLang('main',51)#" name="del_buton" onClick="sil_kontrol();">
                            </td>
                        </tr>
                    </table>
                    
                    <!---<cf_form_box_footer>
                        <cf_workcube_buttons 
                         	is_upd='1' 
                        	delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_piece_rota&piece_id=#attributes.piece_id#'
                       		add_function='kontrol()'>
                    </cf_form_box_footer>--->
          		</cfform>
          	</cf_form_box>
      	</td>
  	</tr>
</table>
<script type="text/javascript">
	var row_count=document.upd_piece_rota.record_num.value;
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
		document.upd_piece_rota.record_num.value = row_count;
		
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
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:65px; text-align:right;">';
	}
	function sil(sy)
	{
		var element=eval("upd_piece_rota.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";
	} 
	function kontrol()
	{
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
			document.getElementById("upd_piece_rota").submit();
		}
		else
		return false;
	}
	function sil_kontrol()
	{
		sor = confirm("<cf_get_lang_main no='2991.Rotayı Silmek İstediğinizden Emin Misiniz'>?");
		if(sor==true)
		window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_piece_rota&piece_id=#attributes.piece_id#</cfoutput>";
		else
		return false;
	}
</script>