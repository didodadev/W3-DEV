<!--- Urun ve Urun Kategorilerinde Kullanilmak Uzere Duzenlenen Kalite Kontrol Tipleri Ajax FBS&IA 20121005 --->
<cfset get_quality_control_type = createObject("component","V16.settings.cfc.setupQualityControlType").getQualityControlType(dsn3:dsn3,is_active:1)>
<cfif not isDefined("attributes.product_cat_id")><cfset attributes.product_cat_id = ""></cfif>
<cfif not isDefined("attributes.product_id")><cfset attributes.product_id = ""></cfif>
<cfset get_product_quality_types = createObject("component","V16.product.cfc.get_product_quality_types").getProductQualityTypes(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id)>
<cfif get_product_quality_types.recordcount>
	<cfset is_upd_ = "1">
<cfelse>
	<cfset is_upd_ = "0">
</cfif>
<cfset get_product_list_action = createObject("component", "V16.product.cfc.get_product")/>
<cfset get_product_list_action.dsn1 = dsn1>
<cfset get_product_list_action.dsn_alias = dsn_alias>
<cfset 	GET_PRODUCT = get_product_list_action.get_product_(pid : attributes.product_id,p_catid : attributes.product_cat_id) />

<cfform name="quality_definitions" method="post" action="#request.self#?fuseaction=product.emptypopupajax_product_quality_definition">
	<cfoutput>
		<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
		<input type="hidden" name="product_id" id="product_id" value="<cfif isDefined("attributes.product_id") and Len(attributes.product_id)>#attributes.product_id#</cfif>">
	</cfoutput>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20">
						<input type="hidden" name="record_num_qt" id="record_num_qt" value="<cfoutput>#get_product_quality_types.recordcount#</cfoutput>"/>
						<a title="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="add_row_quality_type();"><i class="fa fa-plus"></i></a>
					</th>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th width="350" nowrap><cf_get_lang dictionary_id='37665.Kontrol Tipi'></th>
				<th width="130" ><cf_get_lang dictionary_id="57800.İşlem Tipi"></th>
				</tr>
			</thead>
			<tbody id="table_qt" name="table_qt">
				<cfif get_product_quality_types.recordcount>
					<cfoutput query="get_product_quality_types">
						<tr id="tr_row_qt#currentrow#">
							<td><input type="hidden" name="row_kontrol_qt#currentrow#" id="row_kontrol_qt#currentrow#" value="1" /><a onclick="sil_quality_type(#currentrow#);"><i class="fa fa-minus"></i></a></td>
							<td><div class="form-group"><input type="text" name="order_no#currentrow#" id="order_no#currentrow#" value="#order_no#" /></div></td>
							<td>
								<div class="form-group">
									<select name="quality_type_id#currentrow#" id="quality_type_id#currentrow#" onchange="change_process_cat('#currentrow#',this.value);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_quality_control_type">
										<option value="#type_id#" <cfif get_quality_control_type.type_id eq get_product_quality_types.quality_type_id>selected</cfif>>#quality_control_type#<cfif isDefined('type_description') and Len(type_description)> - #type_description#</cfif></option>
										</cfloop>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="process_cat#currentrow#" id="process_cat#currentrow#">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="76" <cfif get_product_quality_types.process_cat eq 76>selected</cfif>><cf_get_lang dictionary_id="29581.Mal Alım İrsaliyesi"></option>
										<option value="171" <cfif get_product_quality_types.process_cat eq 171>selected</cfif>><cf_get_lang dictionary_id="29651.Üretim Sonucu"></option>
										<option value="811" <cfif get_product_quality_types.process_cat eq 811>selected</cfif>><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></option>
										<option value="-2" <cfif get_product_quality_types.process_cat eq -2>selected</cfif>><cf_get_lang dictionary_id="37158.Servisler"></option>
										<option value="-3" <cfif get_product_quality_types.process_cat eq -3>selected</cfif>><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></option>
									</select>
								</div>
							</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
	<cf_box_footer>
		<cf_record_info query_name='get_product_quality_types'>
			<cf_workcube_buttons is_upd='#is_upd_#' is_delete='0' type_format="1" add_function="fields_control()">
	</cf_box_footer>
</cfform>

<script language="javascript">
var row_count_qt = <cfoutput>#get_product_quality_types.recordcount#</cfoutput>;
function sil_quality_type(sy)
{
	document.getElementById("row_kontrol_qt"+sy).value = 0;
	document.getElementById("tr_row_qt"+sy).style.display="none";
}

function add_row_quality_type()
{
	row_count_qt++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_qt").insertRow(document.getElementById("table_qt").rows.length);
	newRow.setAttribute("name","tr_row_qt" + row_count_qt);
	newRow.setAttribute("id","tr_row_qt" + row_count_qt);
	document.getElementById("record_num_qt").value=row_count_qt;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol_qt'+row_count_qt+'" id="row_kontrol_qt'+row_count_qt+'" value="1"><a onclick="sil_quality_type(' + row_count_qt + ');"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="order_no'+row_count_qt+'" id="order_no'+row_count_qt+'" value="'+row_count_qt+'"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="quality_type_id'+row_count_qt+'" id="quality_type_id'+row_count_qt+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_quality_control_type"><option value="#type_id#">#quality_control_type#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="process_cat'+row_count_qt+'" id="process_cat'+row_count_qt+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option value="76">Mal Alım İrsaliyesi</option><option value="171">Üretim Sonucu</option><option value="811">İthal Mal Girişi</option><option value="-2"><cf_get_lang dictionary_id="37158.Servisler"></option><option value="-3"><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></option></select></div>';
}
function change_kontrol()
{
alert("Alan Tipini Değiştirmeniz Durumunda Mevcut Verilerinizi Kaybedebilirsiniz!");
}
function open_operation(row_,pid)
{  
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_operation_list&rows='+row_+'&product_id='+pid+'');
}

function fields_control() {
	for(r=1;r<=record_num_qt.value;r++)
	{
		if(document.getElementById("row_kontrol_qt"+r).value == 1)
		{
			if( document.getElementById("quality_type_id"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='37665.Kontrol Tipi'>");
					return false;
				}
		}
	}
}

</script>
