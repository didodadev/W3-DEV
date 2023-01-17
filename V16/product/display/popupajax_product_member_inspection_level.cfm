<!--- Urun ve Urun Kategorilerinde Kullanilmak Uzere Hazirlanan Uye Muayene Seviyeleri Ajax FBS 20120927 --->

<cfsetting showdebugoutput="no">
<cfset get_inspection_level = createObject("component","V16.settings.cfc.setupInspectionLevel").getInspectionLevel(dsn3:dsn3,is_active:1)>
<cfif not isDefined("attributes.product_cat_id")><cfset attributes.product_cat_id = ""></cfif>
<cfif not isDefined("attributes.product_id")><cfset attributes.product_id = ""></cfif>
<cfset get_product_member_inspection_level = createObject("component","V16.product.cfc.get_product_member_inspection_level").getProductMemberInspectionLevel(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id)>
<cfif get_product_member_inspection_level.recordcount>
	<cfset row_count_query_mil = get_product_member_inspection_level.recordcount>
	<cfset is_upd_ = "1">
<cfelse>
	<cfset row_count_query_mil = 0>
	<cfset is_upd_ = "0">
</cfif>

<cfform name="member_inspection_level" method="post" action="#request.self#?fuseaction=product.emptypopupajax_product_member_inspection_level">
	<cfoutput>
	<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
	<input type="hidden" name="product_id" id="product_id" value="<cfif isDefined("attributes.product_id") and Len(attributes.product_id)>#attributes.product_id#</cfif>">
	</cfoutput>
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><input type="hidden" name="record_num_pmilevel" id="record_num_pmilevel" value="<cfoutput>#row_count_query_mil#</cfoutput>">
						<a title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row_pmilevel();"><i class="fa fa-plus"></i></a>
					</th>
					<th><cf_get_lang dictionary_id="57658.Üye"></th>
					<th width="120"><cf_get_lang dictionary_id="37457.Muayene Seviyesi"></th>
				</tr>
			</thead>
			<tbody id="table_pmilevel">
				<cfif row_count_query_mil>
					<cfoutput query="get_product_member_inspection_level">
					<tr id="tr_row_pmilevel#get_product_member_inspection_level.currentrow#">
						<td><input type="hidden" name="row_kontrol_pmilevel#currentrow#" id="row_kontrol_pmilevel#currentrow#" value="1">
							<a onclick="sil_pmilevel('#currentrow#');"><i class="fa fa-minus"></i></a>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
									<input type="text" name="company_name#currentrow#" id="company_name#currentrow#" value="#get_par_info(company_id,1,1,0)#" onFocus="auto_company('#currentrow#');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_company('#currentrow#');"></span>
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="inspection_level_id#currentrow#" id="inspection_level_id#currentrow#">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<cfloop query="get_inspection_level">
										<option value="#get_inspection_level.inspection_level_id#" <cfif get_inspection_level.inspection_level_id eq get_product_member_inspection_level.inspection_level_id>selected</cfif>>#get_inspection_level.inspection_level_name#</option>
									</cfloop>
								</select>
							</div>
						</td>
					</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
		<div class="ui-info-bottom">
			<div class="col col-6">
				<cf_record_info query_name='get_product_member_inspection_level'>
			</div>
			<div class="col col-6">
				<cf_workcube_buttons is_upd='#is_upd_#' is_delete='0' add_function='kontrol_pmilevel()' type_format="1">
			</div>
		</div>
	</div>
</cfform>
<script type="text/javascript">
row_count_pmilevel=<cfoutput>#row_count_query_mil#</cfoutput>;

function sil_pmilevel(sy)
{
	document.getElementById("row_kontrol_pmilevel"+sy).value = 0;
	document.getElementById("tr_row_pmilevel"+sy).style.display="none";
}
function add_row_pmilevel()
{
	row_count_pmilevel++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_pmilevel").insertRow(document.getElementById("table_pmilevel").rows.length);
	newRow.setAttribute("name","tr_row_pmilevel" + row_count_pmilevel);
	newRow.setAttribute("id","tr_row_pmilevel" + row_count_pmilevel);
	newRow.setAttribute("NAME","tr_row_pmilevel" + row_count_pmilevel);
	newRow.setAttribute("ID","tr_row_pmilevel" + row_count_pmilevel);		
	document.getElementById("record_num_pmilevel").value=row_count_pmilevel;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol_pmilevel' + row_count_pmilevel +'" id="row_kontrol_pmilevel' + row_count_pmilevel +'"><a onclick="sil_pmilevel(' + row_count_pmilevel + ');"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="company_id' + row_count_pmilevel +'" id="company_id' + row_count_pmilevel +'"><input type="text" name="company_name' + row_count_pmilevel +'" id="company_name' + row_count_pmilevel +'" onFocus="auto_company('+ row_count_pmilevel +');" autocomplete="off"> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_company('+ row_count_pmilevel +');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="inspection_level_id' + row_count_pmilevel  +'" id="inspection_level_id' + row_count_pmilevel  +'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_inspection_level"><option value="#inspection_level_id#">#inspection_level_name#</option></cfoutput></select></div>';
}

function auto_company(sy)
{
	AutoComplete_Create('company_name'+sy,'MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','COMPANY_ID','company_id'+sy+'','','3','250');
}

function open_company(sy)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=all.company_id' + sy +'&field_comp_name=all.company_name' + sy +'&field_comp_id=all.company_id' + sy +'&select_list=7');
}

function kontrol_pmilevel()
{
	if(document.getElementById("record_num_pmilevel").value == 0)
	{
		alert("Kaydetmek İçin En Az 1 Satır Girmelisiniz!");
		return false;	
	}
	for (var pml=1;pml<=document.getElementById("record_num_pmilevel").value;pml++)
	{
		if(document.getElementById("row_kontrol_pmilevel"+pml).value == 1)
		{
			
			if(document.getElementById("company_id"+pml).value == "" || document.getElementById("company_name"+pml).value == "")
			{
				alert(pml + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57658.Üye'>");
				return false;
			}
			if(document.getElementById("inspection_level_id"+pml).value == "")
			{
				alert(pml + ". <cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='37457.Muayene Seviyesi'>");
				return false;
			}
		}
	}
	
	//AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopupajax_product_quality_parameters&product_cat_id=#attributes.product_cat_id#</cfoutput>','show_product_quality_parameters',1);
	//AjaxFormSubmit('quality_parameters','show_product_quality_parameters','1','','','#request.self#?fuseaction=product.emptypopupajax_product_quality_parameters');
	return true;	
}
</script>
