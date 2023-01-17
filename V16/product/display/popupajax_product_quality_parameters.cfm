<!--- Urun ve Urun Kategorilerinde Kullanilmak Uzere Hazirlanan Kalite Kontrol Parametreleri Ajax FBS 20120925 --->
<cfsetting showdebugoutput="no">
<cfset get_inspection_level = createObject("component","V16.settings.cfc.setupInspectionLevel").getInspectionLevel(dsn3:dsn3,is_active:1)>
<cfif not isDefined("attributes.product_cat_id")><cfset attributes.product_cat_id = ""></cfif>
<cfif not isDefined("attributes.product_id")><cfset attributes.product_id = ""></cfif>
<cfset get_quality_parameters = createObject("component","V16.product.cfc.get_product_quality_parameters").getQualityParameters(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id)>
<cfif get_quality_parameters.recordcount>
	<cfquery name="get_quality_parameters_group" dbtype="query">
		SELECT LINE_NUMBER, MIN_QUANTITY, MAX_QUANTITY FROM get_quality_parameters GROUP BY LINE_NUMBER, MIN_QUANTITY, MAX_QUANTITY
	</cfquery>
	<cfset row_count_query_qcp = get_quality_parameters_group.recordcount>
	<cfset is_upd_ = "1">
<cfelse>
	<cfset row_count_query_qcp = 0>
	<cfset is_upd_ = "0">
</cfif>
<cfform name="quality_parameters" method="post" action="#request.self#?fuseaction=product.emptypopupajax_product_quality_parameters">
	<cfoutput>
	<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
	<input type="hidden" name="product_id" id="product_id" value="<cfif isDefined("attributes.product_id") and Len(attributes.product_id)>#attributes.product_id#</cfif>">
	</cfoutput>
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th></th>
					<th colspan="2"><cf_get_lang dictionary_id="37452.Parti Büyüklüğü"></th>
					<cfoutput query="get_inspection_level">
						<!--- <th colspan="3">#inspection_level_name#</th> --->
						<th colspan="3">#inspection_level_id#.<cf_get_lang dictionary_id="56192.Seviye"><cf_get_lang dictionary_id="57201.Kontrol"></th>
					</cfoutput>
				</tr>
				<tr>
					<th width="20"><input type="hidden" name="record_num_qcp" id="record_num_qcp" value="<cfoutput>#row_count_query_qcp#</cfoutput>">
						<a title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row_quality();"><i class="fa fa-plus"></i></a>
					</th>
					<th><cf_get_lang dictionary_id="58908.Min"></th>
					<th><cf_get_lang dictionary_id="58909.Max"></th>
					<cfoutput query="get_inspection_level">
						<th><cf_get_lang dictionary_id="37453.Numune Sayısı"></th>
						<th><cf_get_lang dictionary_id="37039.Kabul"></th>
						<th><cf_get_lang dictionary_id="29537.Red"></th>
					</cfoutput>
				</tr>
			</thead>
			<tbody id="table_qcp">
				<cfif row_count_query_qcp>
					<cfoutput query="get_quality_parameters_group">
					<tr id="tr_row_qcp#get_quality_parameters_group.currentrow#">
						<td><input type="hidden" name="row_kontrol_qcp#get_quality_parameters_group.currentrow#" id="row_kontrol_qcp#get_quality_parameters_group.currentrow#" value="1">
							<a onclick="sil_quality('#get_quality_parameters_group.currentrow#');"><i class="fa fa-minus"></i></div></a>
						</td>
						<td><div class="form-group"><input type="text" name="min_quantity#get_quality_parameters_group.currentrow#" id="min_quantity#get_quality_parameters_group.currentrow#" value="#min_quantity#" onkeyup="isNumber(this);" maxlength="5"></div></td>
						<td><div class="form-group"><input type="text" name="max_quantity#get_quality_parameters_group.currentrow#" id="max_quantity#get_quality_parameters_group.currentrow#" value="#max_quantity#" onkeyup="isNumber(this);" maxlength="5"></div></td>
						<cfloop query="get_inspection_level">
							<cfquery name="get_quality_parameters_sub" dbtype="query">
								SELECT LINE_NUMBER,SAMPLE_QUANTITY, ACCEPTANCE_QUANTITY, REJECTION_QUANTITY FROM get_quality_parameters WHERE LINE_NUMBER = <cfqueryparam cfsqltype="cf_sql_float" value="#get_quality_parameters_group.line_number#"> AND INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inspection_level.inspection_level_id#">
							</cfquery>
							<td><div class="form-group"><input type="text" name="sample_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" id="sample_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" value="#get_quality_parameters_sub.sample_quantity#" onkeyup="isNumber(this);" maxlength="5"></div></td>
							<td><div class="form-group"><input type="text" name="acceptance_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" id="acceptance_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" value="#get_quality_parameters_sub.acceptance_quantity#" onkeyup="isNumber(this);" maxlength="5"></div></td>
							<td><div class="form-group"><input type="text" name="rejection_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" id="rejection_#get_inspection_level.inspection_level_id#_quantity#get_quality_parameters_group.currentrow#" value="#get_quality_parameters_sub.rejection_quantity#" onkeyup="isNumber(this);" maxlength="5"></div></td>
						</cfloop>
					</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<div class="ui-info-bottom">
			<div class="col col-6">
				<cf_record_info query_name='get_quality_parameters'>
			</div>
			<div class="col col-6">
				<cf_workcube_buttons is_upd='#is_upd_#' is_delete='0' add_function='kontrol_quality()' type_format="1">
			</div>
		</div>
	</div>
</cfform>
<script type="text/javascript">
function sil_quality(sy)
{
	document.getElementById("row_kontrol_qcp"+sy).value = 0;
	document.getElementById("tr_row_qcp"+sy).style.display="none";
}

var row_count_qcp = parseInt(<cfoutput>#row_count_query_qcp#</cfoutput>);
function add_row_quality()
{
	row_count_qcp++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_qcp").insertRow(document.getElementById("table_qcp").rows.length);
	newRow.setAttribute("name","tr_row_qcp" + row_count_qcp);
	newRow.setAttribute("id","tr_row_qcp" + row_count_qcp);
	newRow.setAttribute("NAME","tr_row_qcp" + row_count_qcp);
	newRow.setAttribute("ID","tr_row_qcp" + row_count_qcp);		
	document.getElementById("record_num_qcp").value = row_count_qcp;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol_qcp' + row_count_qcp +'" id="row_kontrol_qcp' + row_count_qcp +'"><a onclick="sil_quality(' + row_count_qcp + ');"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="min_quantity' + row_count_qcp +'" id="min_quantity' + row_count_qcp +'" onkeyup="isNumber(this);" maxlength="5"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="max_quantity' + row_count_qcp +'" id="max_quantity' + row_count_qcp +'" onkeyup="isNumber(this);" maxlength="5"></div>';
	<cfoutput query="get_inspection_level">
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="sample_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" id="sample_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" onkeyup="isNumber(this);" maxlength="5"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="acceptance_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" id="acceptance_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" onkeyup="isNumber(this);" maxlength="5"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="rejection_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" id="rejection_#get_inspection_level.inspection_level_id#_quantity' + row_count_qcp +'" onkeyup="isNumber(this);" maxlength="5"></div>';
	</cfoutput>
}
function kontrol_quality()
{
	if(document.getElementById("record_num_qcp").value == 0)
	{
		alert("<cf_get_lang dictionary_id='60434.Kaydetmek İçin En Az 1 Satır Girmelisiniz'>!");
		return false;	
	}
	var min_quantity_control = 0;
	var max_quantity_control = 0;
	var sample_quantity_value = 0;
	var acceptance_quantity_value = 0;
	var rejection_quantity_value = 0;
	for (var qcp=1;qcp<=document.getElementById("record_num_qcp").value;qcp++)
	{
		if(document.getElementById("row_kontrol_qcp"+qcp).value == 1)
		{
			
			min_quantity_value = document.getElementById("min_quantity"+qcp).value;
			max_quantity_value = document.getElementById("max_quantity"+qcp).value;
			
			if(min_quantity_value == "")
			{
				alert(qcp + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58908.Min'> <cf_get_lang dictionary_id='37452.Parti Büyüklüğü'>");
				return false;
			}
			if(max_quantity_value == "")
			{
				alert(qcp + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='37452.Parti Büyüklüğü'>");
				return false;
			}
			if(parseFloat(min_quantity_value) > parseFloat(max_quantity_value))
			{
				alert("Parti Büyüklüğü Değeri Max > Min Olmalıdır!");
				return false;
			}
			<cfoutput query="get_inspection_level">
				sample_quantity_value = document.getElementById("sample_#get_inspection_level.inspection_level_id#_quantity"+qcp).value;
				acceptance_quantity_value = document.getElementById("acceptance_#get_inspection_level.inspection_level_id#_quantity"+qcp).value;
				rejection_quantity_value = document.getElementById("rejection_#get_inspection_level.inspection_level_id#_quantity"+qcp).value;
				
				if(sample_quantity_value == "")
				{
					alert(qcp + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'>: #get_inspection_level.inspection_level_name#, <cf_get_lang dictionary_id='37453.Numune Sayısı'>");
					return false;
				}
				//alert(parseFloat(document.getElementById("acceptance_#get_inspection_level.inspection_level_id#_quantity"+qcp).value) - 1);
				if(acceptance_quantity_value == "")
				{
					alert(qcp + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'>: #get_inspection_level.inspection_level_name#, <cf_get_lang dictionary_id='57064.Kabul'>");
					return false;
				}
				if(rejection_quantity_value == "")
				{
					alert(qcp + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'>: #get_inspection_level.inspection_level_name#, Red");
					return false;
				}
				if((parseFloat(sample_quantity_value) < parseFloat(acceptance_quantity_value)) || (parseFloat(sample_quantity_value) < parseFloat(rejection_quantity_value)))
				{
					alert(qcp + ". <cf_get_lang dictionary_id='60435.Kabul ve Red Değeri Numune Sayısından Küçük Olmalıdır'>!");
					return false;
				}
				if(parseFloat(max_quantity_value) < parseFloat(sample_quantity_value))
				{
					alert(qcp + ". <cf_get_lang dictionary_id='60436.Numune Sayısı Max Değerinden Küçük Olmalıdır'>!");
					return false;
				}
			</cfoutput>
			
			if(parseFloat(min_quantity_value) <= parseFloat(max_quantity_control))
			{
				alert("Parti Büyüklüğü Max ve Min Değerleri Sıralı Olmalıdır!");
				return false;
			}
			min_quantity_control = min_quantity_value;
			max_quantity_control = max_quantity_value;
		}
	}
	
	//AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopupajax_product_quality_parameters&product_cat_id=#attributes.product_cat_id#</cfoutput>','show_product_quality_parameters',1);
	//AjaxFormSubmit('quality_parameters','show_product_quality_parameters','1','','','#request.self#?fuseaction=product.emptypopupajax_product_quality_parameters');
	return true;	
}
</script>
