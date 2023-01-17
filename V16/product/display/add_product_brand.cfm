<cfoutput>
<cf_grid_list>
	<thead>
		<tr>
			<th width="20"><a href="javascrript://" onclick="addRowBrand();"  title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a></th>
            <th><cf_get_lang dictionary_id='58847.Marka'></th>
        </tr>
    </thead>
    <tbody id="table_list">
	<cfif isdefined("get_product_cat_brands")>
		<cfloop query="get_product_cat_brands">
			<tr id="frm_row#currentrow#">
				<td><a href="javascript://" onclick="delRowBrand(#currentrow#);"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='57698.Sıfırla'>" align="absbottom" border="0"></a></td>
				<td nowrap="nowrap">
					<div class="form-group">
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="brand_id_#currentrow#" id="brand_id_#currentrow#" value="#brand_id#">
								<input type="text" name="brand_name_#currentrow#" id="brand_name_#currentrow#" value="#brand_name#" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac(#currentrow#);"></span>
							</div>
						</div>
					</div>			
				</td>
			</tr>
		</cfloop>
	</cfif>
	<cfif isdefined("get_product_cat_brands.recordcount")>
		<input type="hidden" name="rowcount_brand" id="rowcount_brand" value="#get_product_cat_brands.recordcount#">
	<cfelse>
		<input type="hidden" name="rowcount_brand" id="rowcount_brand" value="5">
	</cfif>
    </tbody>
</cf_grid_list>
<script type="text/javascript">
	<cfif isdefined("get_product_cat_brands.recordcount")>
		rowCount_Brand = #get_product_cat_brands.recordcount#;
	<cfelse>
		rowCount_Brand = 0;
	</cfif>
	var money2_js = '#session.ep.money2#';
	
	function kontrol()
	{
		if(!kontrol2())/*20050331*/
		{
			setTimeout("product_cat.wrk_submit_button.disabled=false",10);
			return false;
		}
		return true;
	}
	
	function pencere_ac(row)
	{
		//	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id='+document.getElementById('brand_id_'+row)+'&brand_name='+document.getElementById('brand_name_'+row)+'&keyword='+encodeURIComponent(eval(document.getElementById('brand_name_'+row).value)),'small');
		windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_id=document.product_cat.brand_id_'+row+'&brand_name=document.product_cat.brand_name_'+row+'&keyword='+encodeURIComponent(eval('document.product_cat.brand_name_'+row+'.value')),'small');
	}
	
	function delRowBrand(yer)
	{
		document.getElementById("brand_id_" + yer).value=0;
		document.getElementById("frm_row" + yer).style.display="none";
	}
	
	function addRowBrand()
	{
		rowCount_Brand++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.setAttribute("name","frm_row" + rowCount_Brand);
		newRow.setAttribute("id","frm_row" + rowCount_Brand);
		document.getElementById('rowcount_brand').value = rowCount_Brand;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript://" onClick="delRowBrand(' + rowCount_Brand + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap')
		newCell.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="hidden" name="brand_id_' + rowCount_Brand +'" id="brand_id_' + rowCount_Brand +'"><input type="text" name="brand_name_' + rowCount_Brand +'" id="brand_name_' + rowCount_Brand +'" value="" readonly><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(' + rowCount_Brand + ');"></span></div></div></div>';
	}
</script>
</cfoutput>
