<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:35px;">
		<td class="headbold">Toplu Barkod Dosyası Oluştur</td>
		<td align="right"></td> 
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
			<cfform name="add_barcode_file" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_label_print_file" enctype="multipart/form-data"> 
           	<table> 
				<tr>
					<td style="width:70px;">Barkod</td>
					<td style="width:200px;">
						<div id="show_prod_dsp">
							<input type="text" name="search_product" id="search_product" style="width:130px;" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,add_barcode_file.search_product.value);}">
							<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,add_barcode_file.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
							<input type="hidden" name="row_count" id="row_count" value="0">
						</div>												
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="mydiv">
							<cfloop from="1" to="200" index="no">
								<cfoutput>
								<div id="n_my_div#no#" style="display:none"><input  type="hidden" value="0" name="row_kontrol#no#" id="row_kontrol#no#" ><a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0"></a><input type="text" style="width:150px;" name="barcode#no#" id="barcode#no#" value=""><input style="width:30px;" type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();"></div><!---  onBlur="stock_reserve(#no#)" ---><!--- <input type="hidden" value="" name="sid#no#"> --->
								</cfoutput>
							</cfloop>
						</div>
					</td>
				</tr>
                <tr>
                    <td align="center" colspan="2">
                        <input type="button" value="Kaydet" onClick="control_inputs();">
                    </td>
                </tr>	
			</table>
			</cfform>
        </td>
	</tr>
</table>
<br/>
<cfinclude template="basket_js_functions_label_print.cfm">
<script type="text/javascript">
	document.getElementById('search_product').focus();
</script>
