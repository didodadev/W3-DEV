<!--- <cfscript>session_basket_kur_ekle(process_type:0);</cfscript> --->
<table cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">Sayım Dosyası</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
        	<cfform name="add_ship_dispatch" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_stock_count_file" enctype="multipart/form-data"> 
			<table> 
				<tr>
					<td style="width:70px;">Tarih *</td>
					<td style="width:200px;">
						<cfinput type="text" name="process_date" id="process_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:60px;">
						<cf_wrk_date_image date_field="process_date">
					</td>
				</tr>
				<tr>
					<td>Depo*</td>
					<td><cfinclude template="../query/get_department_location.cfm">
						<cfoutput>
						<input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
						<input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
						<input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
						<cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
						<cfinput type="text" name="department_location" id="department_location" value="#attributes.department_location#" required="yes" message="#message#" style="width:120px;">
						<a href="javascript://" onClick="get_turkish_letters_div('document.add_sale.department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="get_location_all_div('open_all_div','add_sale','branch_id','department_id','location_id','department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td colspan="2"><div id="open_all_div"></div></td>
				</tr>
				<tr>
					<td>Barkod</td>
					<td><div id="show_prod_dsp">
							<input type="hidden" name="row_count" id="row_count" value="0">
							<input type="text" name="search_product" id="search_product" style="width:120px;" <cfif session.pda.use_onkeydown_enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value);}">
							<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</div>
					</td>
				</tr>
				<div id="mydiv">
                    <tr>
                        <td colspan="2">
                            <cfloop from="1" to="50" index="no">
                            <cfoutput>
                                <div id="n_my_div#no#" style="display:none">
                                <table cellpadding="1" cellspacing="0">
                                    <tr>
                                        <td><input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
                                            <input type="hidden" name="sid#no#" id="sid#no#" value="">
                                            <input type="hidden" name="row_ship_id#no#" id="row_ship_id#no#" value="">
                                            <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="">
                                            <input type="text" name="amount#no#" id="amount#no#" value="1" style="width:62px;" class="moneybox" onKeyUp="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:120px;">
                                            <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                            <a href="javascript://" onclick="gizle_goster('tr_product_name#no#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                        </td>
                                    </tr>
                                    <tr id="tr_product_name#no#" style="display:none;">
                                        <td><input type="text" name="product_name#no#" id="product_name#no#" value="" style="width:191px;" readonly></td>
                                    </tr>
                                </table>
                                </div>
                            </cfoutput>
                            </cfloop>
                        </td>
                    </tr>
				</div>
				<tr>
					<td colspan="2" align="center"><input type="button" value="Kaydet" onClick="control_inputs();"></td>
				</tr>
            </table>
			</cfform>
		</td>
	</tr>
</table>
<br/>
<cfinclude template="basket_js_functions.cfm"><!--- basket_js_functions_ship_dispatch kaldirilarak ortak hale getirildi FBS 20111001 --->
