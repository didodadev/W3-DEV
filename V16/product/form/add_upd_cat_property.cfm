<!--- Ekleme ve Guncelleme Sayfalari Ayni Oldugundan Ortak Hale Getirildi FBS 20100624 --->
<cfquery name="get_control" datasource="#DSN1#" maxrows="1">
	SELECT PRODUCT_CAT_ID FROM PRODUCT_CAT_PROPERTY WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfset is_upd_ = 0>
<cfquery name="category" datasource="#dsn1#">
	SELECT PRODUCT_CATID,HIERARCHY FROM PRODUCT_CAT WHERE  PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfset ust_cat_code=listdeleteat(category.hierarchy,ListLen(category.hierarchy,"."),".")>
<cfif get_control.recordcount>
	<cfset is_upd_ = 1>
	<cfquery name="get_product_cat_related_property" datasource="#dsn1#">
		SELECT * FROM PRODUCT_CAT_PROPERTY WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> ORDER BY  LINE_VALUE,PROPERTY_ID
	</cfquery>
	<cfset row_no = get_product_cat_related_property.recordCount>
<cfelse>
	<cfquery name="get_product_cat_related_property" datasource="#dsn3#">
		SELECT
			*
		FROM
			PRODUCT_CAT,
			#dsn1_alias#.PRODUCT_CAT_PROPERTY PRODUCT_CAT_PROPERTY
		WHERE
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID AND
			PRODUCT_CAT.HIERARCHY = '#ust_cat_code#'
		ORDER BY
        LINE_VALUE,
			PRODUCT_CAT_PROPERTY.PROPERTY_ID
	</cfquery>
	<cfset row_no = get_product_cat_related_property.recordCount>
</cfif>
<cfform name="related_property" method="post" action="#request.self#?fuseaction=product.emptypopup_add_upd_cat_property">
	<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfoutput>#attributes.id#</cfoutput>">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20">
						<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#row_no#</cfoutput>">
						<a href="javascrript://" onclick="addRowProperty();"  title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a>
					</th>
                    <th><cf_get_lang dictionary_id='57632.Özellik'></th>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='37250.Değer'></th>		
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='37171.Input'></th>
                    <th><cf_get_lang dictionary_id='37172.Web'></th>
                </tr>
            </thead>
            <tbody name="table_property" id="table_property">
				<cfif row_no gt 0>
                    <cfoutput query="get_product_cat_related_property">	
                        <cfquery name="GET_PROPERTY" datasource="#DSN1#">
                            SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID = #PROPERTY_ID#
                        </cfquery>
                        <tr id="frm_row_property#currentrow#" align="center">
                            <td><a onclick="delRowProperty('#currentrow#');"><i class="fa fa-minus"></i></a></td>
							<td>
								<div class="form-group">
                                    <div class="input-group">								
										<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
										<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#PROPERTY_ID#">
										<input type="text" name="property#currentrow#" id="property#currentrow#" value="#GET_PROPERTY.PROPERTY#" readonly="yes">
										<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_pos('#currentrow#');"></span>
									</div>
								</div>
                            </td>
							<td>
								<div class="form-group">
									<input type="text" name="line_row#currentrow#" id="line_row#currentrow#" value="#tlformat(line_value,0)#" onKeyup="return(FormatCurrency(this,event));" maxlength="2">
								</div>
							</td>
                            <td><input type="checkbox" name="worth#currentrow#" id="worth#currentrow#" <cfif IS_WORTH eq 1>checked</cfif>></td>
                            <td><input type="checkbox" name="optional#currentrow#" id="optional#currentrow#" <cfif IS_OPTIONAL eq 1>checked</cfif>></td>
                            <td><input type="checkbox" name="amount#currentrow#" id="amount#currentrow#" <cfif IS_AMOUNT eq 1>checked</cfif>></td>
                            <td><input type="checkbox" name="is_internet#currentrow#" id="is_internet#currentrow#" <cfif IS_INTERNET eq 1>checked</cfif>></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
		</cf_grid_list>
		<div class="ui-info-bottom flex-end">
			<cf_workcube_buttons is_upd='#is_upd_#' is_delete='0' add_function='kontrol()&&control_old_list()' type_format="1">
		</div>
</cfform>
<script type="text/javascript">
row_count=<cfoutput>#row_no#</cfoutput>;
function delRowProperty(sy)
{
	document.getElementById("row_kontrol"+sy).value = 0;
	document.getElementById("frm_row_property"+sy).style.display="none";
}
function addRowProperty()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_property").insertRow(document.getElementById("table_property").rows.length);
	newRow.setAttribute("name","frm_row_property" + row_count);
	newRow.setAttribute("id","frm_row_property" + row_count);
	newRow.setAttribute("NAME","frm_row_property" + row_count);
	newRow.setAttribute("ID","frm_row_property" + row_count);		
	document.related_property.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a onclick="delRowProperty(' + row_count + ');"><i class="fa fa-minus"></i></a>';	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="product_cat_id' + row_count +'" id="product_cat_id' + row_count +'"><input type="hidden" name="property_id' + row_count +'" id="property_id' + row_count +'"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="text" readonly="yes" name="property' + row_count +'" id="property' + row_count +'"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_pos(' + row_count + ');"></span>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="line_row' + row_count +'" id="line_row' + row_count +'" onKeyup="return(FormatCurrency(this,event));" maxlength="2"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="worth' + row_count +'" id="worth' + row_count +'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="amount' + row_count +'" id="amount' + row_count +'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="optional' + row_count +'" id="optional' + row_count +'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="is_internet' + row_count +'" id="is_internet' + row_count +'">';
}
function pencere_pos(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&property=related_property.property' + no + '&property_id=related_property.property_id' + no + '&is_select=1','list');
}
function kontrol()
{
	if(related_property.record_num.value == "")
	{
		alert("<cf_get_lang dictionary_id='37173.Lütfen Satir Giriniz'> !");
		return false;
	}
	for (var r=1;r<=related_property.record_num.value;r++)
	{
		value_line_row = eval('related_property.line_row'+r);
		value_line_row.value = filterNum(value_line_row.value);
	}
}
</script>
