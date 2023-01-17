<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfif isDefined("attributes.product_id") and Len(attributes.product_id)><cf_xml_page_edit fuseact="product.product_quality"></cfif>
<!--- Ürün Kalite Kontrol --->
<cfset get_quality_control_type = createObject("component","V16.product.cfc.product_quality_control_types").getQualityControlType(dsn3:dsn3,is_active:1)>
<cfset get_product_info = createObject("component","V16.product.cfc.product_quality_control_types").get_product_info(dsn3:dsn3,product_id:attributes.product_id)>
<cfif len(get_product_info.PRODUCT_CATID)>
	<cfset attributes.product_cat_id = get_product_info.PRODUCT_CATID>
</cfif>

<cfset get_product_quality_types = createObject("component","V16.product.cfc.product_quality_control_types").getProductCatQualityTypes(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id)>
<cfif get_product_quality_types.recordcount>
	<cfset is_upd_ = "1">
<cfelse>
	<cfset is_upd_ = "0">
</cfif>
<cfset get_products_quality = createObject("component","V16.product.cfc.product_quality_control_types").getProductQuality(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id)>

<cfform name="quality_definitions" method="post" action="V16/product/cfc/product_quality_control_types.cfc?method=add_quality_types">
	<cfoutput>
		<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
		<input type="hidden" name="product_id" id="product_id" value="<cfif isDefined("attributes.product_id") and Len(attributes.product_id)>#attributes.product_id#</cfif>">
		<cfinput type="hidden" name="is_upd" id="is_upd" value="#is_upd_#">
	</cfoutput>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
		<div class="col col-6 col-md-8 col-sm-10 col-xs-12">
			<div class="ui-info-bottom">
				<cfoutput query="get_product_info">
					<div class="form-group col col-6 col md-6 col-sm-6 col-xs-6">
						<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57518.Stok Kodu'> :</label>
						<label class="col col-8 col-xs-12">#PRODUCT_CODE#</label>
					</div>
					<div class="form-group col col-6 col md-6 col-sm-6 col-xs-6">
						<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57657.Ürün'> :</label>
						<label class="col col-8 col-xs-12">#PRODUCT_NAME#</label>
					</div>
				</cfoutput>
			</div>
		</div>
	</div>
	<div class="col col-12 margin-top-20 margin-left-10">
		<cf_box_elements>
			<div class="form-group col col-5 col-md-5 col-sm-6 col-xs-12" id="quality_startdate_tr">
				<label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='51015.Kalite Kontrol Başlangıç Tarihi'>*</label>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="input-group">                                
						<cfif len(get_product_info.quality_start_date)>
							<cfinput type="text" name="quality_startdate" id="quality_startdate" onchange="change_date()" maxlength="10" validate="#validate_style#" value="#dateformat(get_product_info.quality_start_date,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="quality_startdate" id="quality_startdate" onchange="change_date()" maxlength="10" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="quality_startdate"></span>
					</div>
				</div>
			</div>
		</cf_box_elements>
	</div>
	<div class="col col-6 col-md-8 col-sm-10 col-xs-12">
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
						<td><a onclick="sil_quality_type(#currentrow#);"><i class="fa fa-minus"></i></a></td>
						<td>#currentrow#
							<cfinput type="hidden" name="q_id#currentrow#" id="q_id#currentrow#" value="#PRODUCT_QUALITY_ID#">
							<input type="hidden" name="row_kontrol_qt#currentrow#" id="row_kontrol_qt#currentrow#" value="1" />
						</td>
						<td>
							<div class="form-group">
								<select name="quality_type_id#currentrow#" id="quality_type_id#currentrow#">
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
									<cfif isDefined("xml_show_quality_type_operation_info") and xml_show_quality_type_operation_info eq 1 ><option value="-1" <cfif get_product_quality_types.process_cat eq -1>selected</cfif>><cf_get_lang dictionary_id="37156.Operasyonlar"></option></cfif>
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
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
		<cf_box_footer>
			<cf_record_info query_name='get_product_quality_types'>
			<cf_workcube_buttons extraButton="1"  extraButtonText="#getLang('','Ekle','57582')#"  extraFunction="fields_control()" update_status="0">
		</cf_box_footer>
	</div>
</cfform>

<cfform name="quality_definitions_params" method="post" action="V16/product/cfc/product_quality_control_types.cfc?method=add_quality_type_rows">
	<input type="hidden" name="q_start_date" id="q_start_date" value="">
	<div class="col col-10 col-md-12 col-sm-12 col-xs-12" >
		<cf_seperator id="sub_parameters" title="#getLang('','Parametreler','57693')#">
		<div id="sub_parameters">
			<cfset current_row = 0>
			<cfset rowcount_ = 0>
			<cfloop query="get_product_quality_types">
				<cfset control_type_id = get_product_quality_types.QUALITY_TYPE_ID>
				<cfset get_quality_sub_cat= createObject("component","V16.product.cfc.product_quality_control_types").getProductSubCatQualityTypes(dsn3:dsn3,product_cat_id:attributes.product_cat_id,product_id:attributes.product_id,control_type:control_type_id)>
				<div class="ui-info-bottom">
					<cfif isDefined('content_id') and len(content_id)>
						<a  target="_blank" href="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#get_product_quality_types.content_id#</cfoutput>"><i class="fa fa-file-text" style="color:#DAA520" ></i></a>
					<cfelse>
						<a href="javascript://"><i class="fa fa-file-text" style="color:#C2B280"></i></a>
					</cfif>
					<cfoutput>
						&nbsp<font color="red">#get_product_quality_types.quality_control_type#</font>
					</cfoutput>
				</div>
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
							<th width="150"><cf_get_lang dictionary_id='64052.Parametre'></th>
							<th width="100" class="text-center"><cf_get_lang dictionary_id='63477.Örneklem'></th>
							<th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="100" class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
							<th width="100" class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
							<th  width="100" class="text-right"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
							<th width="25" class="text-center"><=></th>
							<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						</tr>
					</thead>
					<tbody>
						<cfset rowcount_ = rowcount_+ get_quality_sub_cat.recordcount>
						<cfif get_quality_sub_cat.recordcount>
							<cfset current_r= 0>
							<cfoutput query="get_quality_sub_cat"> 
								<cfset current_row = current_row + 1>
								<cfset q_ids= get_quality_sub_cat.QUALITY_CONTROL_ROW_ID>
								<cfset product_q_id= get_product_quality_types.PRODUCT_QUALITY_ID>
								<cfset get_quality_id= createObject("component","V16.product.cfc.product_quality_control_types").get_quality_id(dsn3:dsn3,q_ids:q_ids,product_id:attributes.product_id,product_q_id:product_q_id)>
								<cfif get_quality_id.recordcount>
									<cfset is_upd_sub_cat="1">
									<cfset pro_q_id = get_quality_id.PRODUCT_QUALITY_CONTROL_ROW_ID>
								<cfelse>
									<cfset is_upd_sub_cat="0">
								</cfif>
								<cfif is_upd_sub_cat eq 0>
									<tr>
										<td>
											<cfinput type="hidden" name="is_upd_sub_cat#current_row#" id="is_upd_sub_cat#current_row#" value="#is_upd_sub_cat#">
											<cfinput type="hidden" name="row_id#current_row#" id="row_id#current_row#" value="#QUALITY_CONTROL_ROW_ID#">
											<cfinput type="hidden" name="q_id#current_row#" id="q_id#current_row#" value="#get_product_quality_types.PRODUCT_QUALITY_ID#">
											<cfinput type="hidden" name="quality_type_id_#current_row#" id="quality_type_id_#current_row#" value="#QUALITY_CONTROL_TYPE_ID#">
											<cfif get_quality_id.recordcount>
												<cfinput type="hidden" name="pro_q_id#current_row#" id="pro_q_id#current_row#" value="#pro_q_id#">
											</cfif>
											#currentrow#
										</td>
										<td>#QUALITY_CONTROL_TYPE#</td><cfinput type="hidden" name="quality_type_name_#current_row#" id="quality_type_name_#current_row#" value="#QUALITY_CONTROL_TYPE#">
										<td>
											<div class="form-group">
												<div class="col col-8">
													<cfif isDefined('sample_number')><input type="text" name="sample_number_#current_row#" id="sample_number_#current_row#" value="#TLFormat(sample_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
												</div>
												<div class="col col-4">
													<cfif isDefined('sample_method')>
														<input type="text" name="samp" id="samp" value="<cfif sample_method eq 1>R<cfelseif sample_method eq 2>%<cfelseif sample_method eq 3>K</cfif>" title="<cfif sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif sample_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
														<input type="hidden" name="sample_method_#current_row#" id="sample_method_#current_row#" value="#sample_method#">
													</cfif>
												</div>
											</div>
										</td>
										<td>
											<div class="form-group">
												<div class="col col-8">
													<input type="text" name="amount_#current_row#" id="amount_#current_row#" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
												</div>
												<div class="col col-4">
													<cfif isDefined('unit')>
														<input type="text" name="units" id="units" readonly value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">
														<input type="hidden" name="unit_#current_row#" id="unit_#current_row#" value="#unit#">
													</cfif>
												</div>
											</div>
										</td>
										<td class="text-right"><input type="text" name="min_limit_#current_row#" id="min_limit_#current_row#" value="#TLFormat(TOLERANCE_2)#" class="moneybox"/></td>
										<td class="text-right"><input type="text" name="max_limit_#current_row#" id="max_limit_#current_row#" value="#TLFormat(TOLERANCE)#" class="moneybox"/></td>
										<td class="text-right"><input type="text" name="standart_value_#current_row#" id="standart_value_#current_row#" value="#TLFormat(QUALITY_VALUE)#" class="moneybox"/></td>
										<td>
											<select name="control_operator_#current_row#" id="control_operator_#current_row#" class="text-center"> 
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif isDefined('control_operator') and control_operator eq 1>selected</cfif>>=</option>
												<option value="2" <cfif isDefined('control_operator') and control_operator eq 2>selected</cfif>>></option>
												<option value="3" <cfif isDefined('control_operator') and control_operator eq 3>selected</cfif>><</option>
												<option value="4" <cfif isDefined('control_operator') and control_operator eq 4>selected</cfif>>=></option>
												<option value="5" <cfif isDefined('control_operator') and control_operator eq 5>selected</cfif>>=<</option>
											</select>
										</td>
										
										<td><input type="text" name="type_description_#current_row#" id="type_description_#current_row#" value="#TYPE_DESCRIPTION#" /></td>
									</tr>
								<cfelseif is_upd_sub_cat eq 1>
									<tr>
										<td>
											<cfset current_r= current_r+1>
											<cfinput type="hidden" name="is_upd_sub_cat#current_row#" id="is_upd_sub_cat#current_row#" value="#is_upd_sub_cat#">
											<cfinput type="hidden" name="row_id#current_row#" id="row_id#current_row#" value="#get_quality_id.QUALITY_CONTROL_ROW_ID#">
											<cfinput type="hidden" name="q_id#current_row#" id="q_id#current_row#" value="#get_quality_id.PRODUCT_QUALITY_ID#">
											<cfinput type="hidden" name="quality_type_id_#current_row#" id="quality_type_id_#current_row#" value="#get_quality_id.QUALITY_TYPE_ID#">
											<cfif get_quality_id.recordcount>
												<cfinput type="hidden" name="pro_q_id#current_row#" id="pro_q_id#current_row#" value="#pro_q_id#">
											</cfif>
											#current_r#
										</td>
										<td>#get_quality_id.PRODUCT_QUALITY_CONTROL_TYPE#</td><cfinput type="hidden" name="quality_type_name_#current_row#" id="quality_type_name_#current_row#" value="#get_quality_id.PRODUCT_QUALITY_CONTROL_TYPE#">
										<td>
											<div class="form-group">
												<div class="col col-8">
													<cfif isDefined('get_quality_id.sample_number')><input type="text" name="sample_number_#current_row#" id="sample_number_#current_row#" value="#TLFormat(get_quality_id.sample_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
												</div>
												<div class="col col-4">
													<cfif isDefined('get_quality_id.sample_method')>
														<input type="text" name="samp" id="samp" value="<cfif get_quality_id.sample_method eq 1>R<cfelseif get_quality_id.sample_method eq 2>%<cfelseif get_quality_id.sample_method eq 3>K</cfif>" title="<cfif get_quality_id.sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif get_quality_id.sample_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif get_quality_id.sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
														<input type="hidden" name="sample_method_#current_row#" id="sample_method_#current_row#" value="#get_quality_id.sample_method#">
													</cfif>
												</div>
											</div>
										</td>
										<td>
											<div class="form-group">
												<div class="col col-8">
													<input type="text" name="amount_#current_row#" id="amount_#current_row#" value="#TLFormat(get_quality_id.amount)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
												</div>
												<div class="col col-4">
													<cfif isDefined('unit')>
														<input type="text" name="units" id="units" readonly value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">

														<input type="hidden" name="unit_#current_row#" id="unit_#current_row#" value="#unit#">
													</cfif>
												</div>
											</div>
										</td>
										<td class="text-right"><input type="text" name="min_limit_#current_row#" id="min_limit_#current_row#" value="#TLFormat(get_quality_id.MIN_LIMIT)#" class="moneybox"/></td>
										<td class="text-right"><input type="text" name="max_limit_#current_row#" id="max_limit_#current_row#" value="#TLFormat(get_quality_id.MAX_LIMIT)#" class="moneybox"/></td>
										<td class="text-right"><input type="text" name="standart_value_#current_row#" id="standart_value_#current_row#" value="#TLFormat(get_quality_id.STANDART_VALUE)#" class="moneybox"/></td>
										<td>
											<select name="control_operator_#current_row#" id="control_operator_#current_row#" class="text-center"> 
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif isDefined('get_quality_id.control_operator') and get_quality_id.control_operator eq 1>selected</cfif>>=</option>
												<option value="2" <cfif isDefined('get_quality_id.control_operator') and get_quality_id.control_operator eq 2>selected</cfif>>></option>
												<option value="3" <cfif isDefined('get_quality_id.control_operator') and get_quality_id.control_operator eq 3>selected</cfif>><</option>
												<option value="4" <cfif isDefined('get_quality_id.control_operator') and get_quality_id.control_operator eq 4>selected</cfif>>=></option>
												<option value="5" <cfif isDefined('get_quality_id.control_operator') and get_quality_id.control_operator eq 5>selected</cfif>>=<</option>
											</select>
										</td>
										
										<td><input type="text" name="type_description_#current_row#" id="type_description_#current_row#" value="#get_quality_id.DESCRIPTION#" /></td>
									</tr>
								</cfif>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<cfif get_quality_sub_cat.recordcount eq 0>
					<div class="ui-info-bottom">
						<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
					</div>
				</cfif>
			</cfloop>
			<cfinput type="hidden" name="rowcount_" id="rowcount_" value="#rowcount_#">
			<cfinput type="hidden" name="product_id" id="product_id" value="#attributes.product_id#">
		</div>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
		<cf_box_footer>
			<cf_workcube_buttons is_delete='0' add_function="control()">
		</cf_box_footer>
	</div>
</cfform>

<script language="javascript">
var row_count_qt = <cfoutput>#get_product_quality_types.recordcount#</cfoutput>;
function sil_quality_type(sy)
{
	document.getElementById("row_kontrol_qt"+sy).value = 0;
	document.getElementById("tr_row_qt"+sy).style.display="none";
}

function change_date() {
	$("#q_start_date").val($("#quality_startdate").val());
}

function control() {
	if($("#q_start_date").val() == ''){
		alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='51015.Kalite Kontrol Başlangıç Tarihi'>!");
		return false;
	}
	loadPopupBox('quality_definitions_params','quality_box_');
	return false;
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
	newCell.innerHTML = '<input type="hidden" name="row_kontrol_qt'+row_count_qt+'" id="row_kontrol_qt'+row_count_qt+'" value="2"><a onclick="sil_quality_type(' + row_count_qt + ');"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="order_no'+row_count_qt+'" id="order_no'+row_count_qt+'" value="'+row_count_qt+'"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="quality_type_id'+row_count_qt+'" id="quality_type_id'+row_count_qt+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_quality_control_type"><option value="#type_id#">#quality_control_type#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="process_cat'+row_count_qt+'" id="process_cat'+row_count_qt+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option value="76">Mal Alım İrsaliyesi</option><option value="171">Üretim Sonucu</option><option value="811">İthal Mal Girişi</option><cfif isDefined("xml_show_quality_type_operation_info") and xml_show_quality_type_operation_info eq 1 ><option value="-1"><cf_get_lang dictionary_id="37156.Operasyonlar"></option></cfif><option value="-2"><cf_get_lang dictionary_id="37158.Servisler"></option><option value="-3"><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></option></select></div>';
}


function fields_control() {
	for(r=1;r<=record_num_qt.value;r++)
	{
		if($("#row_kontrol_qt"+r).val() == 2)
		{
			if($("#quality_type_id"+r).val() == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='37665.Kontrol Tipi'>(" +r+". <cf_get_lang dictionary_id='58508.Satır'>)");
					return false;
				}
		}
	}
	loadPopupBox('quality_definitions','quality_box');
}

</script>
