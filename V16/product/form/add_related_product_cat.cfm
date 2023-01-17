<cfquery name="GET_RELATED_CAT" datasource="#dsn1#">
	SELECT 
    	PRC.PRODUCT_CAT_ID,
        PC.PRODUCT_CAT,
        PC.HIERARCHY
    FROM 
    	RELATED_PRODUCT_CAT PRC,
        PRODUCT_CAT PC
    WHERE 
    	PRC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
        PC.PRODUCT_CATID = PRC.PRODUCT_CAT_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','İlişkili Ürün Kategorisi Ekle',37070)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_product_relation" action="#request.self#?fuseaction=product.emptypopup_add_related_product_cat&pid=#attributes.pid#" method="post">
		<input type="hidden" name="related_product_id" id="related_product_id" value="">
		<input type="hidden" name="row_count" id="row_count" value="<cfif GET_RELATED_CAT.recordcount><cfoutput>#GET_RELATED_CAT.recordcount#</cfoutput></cfif>">					
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><a href="javascript://" onclick="pencere_ac_product();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
					<th width="150"><cf_get_lang dictionary_id='29401.Urun kategorisi'></th>
				</tr>
			</thead>
			<tbody name="table1" id="table1">
				<cfif GET_RELATED_CAT.recordcount>
					<cfoutput query="GET_RELATED_CAT">
						<tr id="frm_row#currentrow#">
							<td><input  type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
							<td>
							<div class="form-group">
								<input type="hidden" name="product_cat_id#currentrow#" id="product_cat_id#currentrow#" value="#PRODUCT_CAT_ID#">
								<input type="text" name="product_cat_name#currentrow#" id="product_cat_name#currentrow#" value="#HIERARCHY# #PRODUCT_CAT#" readonly>
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
	<cfif GET_RELATED_CAT.recordcount>
		var row_count=<cfoutput>#GET_RELATED_CAT.recordcount#</cfoutput>;
	<cfelse>
		var row_count=0;
	</cfif>
	function sil(sy)
	{
		var my_element=eval("add_product_relation.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		
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
	function product_cat_gonder(sayac,product_cat_id,product_cat_name)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.getElementById('row_count').value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_cat_id' + row_count +'" id="product_cat_id' + row_count +'" value="'+ product_cat_id +'"><input type="text" name="product_cat_name' + row_count +'" id="product_cat_name' + row_count +'" value="'+ product_cat_name +'" readonly></div>';
	}
	function pencere_ac_product()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_multi_selection=1&call_function=product_cat_gonder');
	}
</script>
