<!--- coklu urun girisi icin duzenlemeler yapildi, add_row haline donusturuldu
	  urun popupina is_related_products=1 parametresi gonderildi unutulmamali FBS 20080325
 --->
<cfquery name="GET_RELATED_PRODUCT" datasource="#DSN3#">
	SELECT 
    	RP.PRODUCT_ID, 
       	RP.RELATED_PRODUCT_ID, 
        RP.RELATED_PRODUCT_NO ,
        P.PRODUCT_NAME RELATED_PRODUCT_NAME
    FROM 
    	RELATED_PRODUCT RP
        LEFT JOIN PRODUCT P ON P.PRODUCT_ID = RP.RELATED_PRODUCT_ID
    WHERE 
    	RP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
    ORDER BY 
    	RP.RELATED_PRODUCT_NO
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','İlişkili Ürün Ekle',37037)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_product_relation" action="#request.self#?fuseaction=product.emptypopup_add_related_product" method="post">
        <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
        <input type="hidden" name="related_product_id" id="related_product_id" value="">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20">
                        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_related_product.recordcount#</cfoutput>">
						<a href="javascript://" onclick="pencere_ac_product();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a>
                    </th>
                    <th width="35"><cf_get_lang dictionary_id='37624.Sıra No'></th>
                    <th width="300"><cf_get_lang dictionary_id='57657.Ürün'></th>
                </tr>
            </thead>
            <tbody id="table1">
                <cfif get_related_product.recordcount>
					<cfoutput query="get_related_product">
                        <tr id="frm_row#currentrow#">
                            <td>
                                <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                <a href="javascript://" onClick="sil('#currentrow#');" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus"></i></a>
                            </td>
							<td>
								<div class="form-group">
									<input type="text" name="product_no#currentrow#" id="product_no#currentrow#" value="#related_product_no#" onkeyup="isNumber(this);"></td>
								</div>
							<td>
								<div class="form-group">
									<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#related_product_id#">
									<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#RELATED_PRODUCT_NAME#" readonly>
								</div>
							</td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
       	<cf_box_footer>
        	<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_et() && loadPopupBox('add_product_relation' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	<cfif get_related_product.recordcount>
		row_count=<cfoutput>#get_related_product.recordcount#</cfoutput>;
		satir_say=<cfoutput>#get_related_product.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
		satir_say=0;
	</cfif>

	function sil(sy)
	{
		var my_element=eval("add_product_relation.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		satir_say--;
	}
	function kontrol_et()
	{
		if(row_count ==0) 
		{
			alert("<cf_get_lang dictionary_id='37943.Ürün Seçmediniz'> !");
			return false;
		}
		return true;
	}
	
	function product_gonder(product_id,product_name)
	{
		row_count++;
		satir_say++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);

		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);	
			
		newRow.className = 'color-row';
		document.getElementById('record_num').value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="product_no' + row_count +'" id="product_no' + row_count +'" onkeyup="isNumber(this);"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+ product_id +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name +'"readonly></div>';
	}
	
	function pencere_ac_product()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=add_product_relation.related_product_id&field_name=add_product_relation.product_name&is_related_products=1');
	}
</script>
