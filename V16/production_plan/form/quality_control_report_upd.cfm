<cfset get_product_quality_types = createObject("component","V16.product.cfc.product_quality_control_types").getProductCatQualityTypes(dsn3:dsn3,OR_Q_ID:attributes.OR_Q_ID,product_id:attributes.pid)>
<cfset current_row = 0>
<cfset rowcount_ = 0>
<cfloop query="get_product_quality_types">
	<cfset control_type_id = get_product_quality_types.CONTROL_TYPE_ID>
	<cfset get_quality_sub_cat= createObject("component","V16.product.cfc.product_quality_control_types").getProductSubCatQualityTypes(dsn3:dsn3,control_type:control_type_id,product_id:attributes.pid, or_q_id:attributes.or_q_id)>
	<div class="ui-info-bottom col col-12">
		<cfif isDefined('content_id') and len(content_id)>
			<a  target="_blank" href="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#get_product_quality_types.content_id#</cfoutput>"><i class="fa fa-file-text" style="color:#DAA520" ></i></a>
		<cfelse>
			<a href="javascript://"><i class="fa fa-file-text" style="color:#C2B280"></i></a>
		</cfif>
		<cfoutput>
			&nbsp<font color="red">#get_product_quality_types.quality_control_type#</font>
		</cfoutput>
	</div>
	<div class="ui-info-right">
		<div class="checkbox checbox-switch">
			<label>
                <cfoutput>
				    <input type="checkbox" name="accepted_#currentrow#" id="accepted_#currentrow#" value="1" onchange="change_val('#currentrow#')" <cfif MAIN_QUALITY_VALUE eq 1>checked</cfif>/>
                </cfoutput>
				<span></span>
			</label>
		</div>
	</div>
	<cf_grid_list id="list_#get_product_quality_types.currentrow#">
		<thead>
			<tr>
				<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="150"><cf_get_lang dictionary_id='64052.Parametre'></th>
				<th width="100" class="text-center"><cf_get_lang dictionary_id='63477.Örneklem'></th>
				<th width="150"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="100" class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
				<th width="100" class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
				<th  width="100" class="text-right"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
				<th width="15" class="text-center"><=></th>
				<th><cf_get_lang dictionary_id='59085.Sonuç'></th>
				<th>&nbsp</th>
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
					<cfset get_quality_id= createObject("component","V16.product.cfc.product_quality_control_types").get_quality_id(dsn3:dsn3,q_ids:q_ids,product_id:attributes.pid,product_q_id:product_q_id)>
						<tr>
							<td>
								<cfset current_r= current_r+1>
								<cfinput type="hidden" class="q_row" name="q_row_accept_#current_row#" id="q_row_accept_#current_row#" value="">
								<cfinput type="hidden" name="q_control_row_id_#current_row#" id="q_control_row_id_#current_row#" value="#get_quality_id.QUALITY_CONTROL_ROW_ID#">
								<cfinput type="hidden" name="quality_type_id_#current_row#" id="quality_type_id_#current_row#" value="#get_quality_id.QUALITY_TYPE_ID#">
								#current_r#
							</td>
							<td>#QUALITY_CONTROL_TYPE#</td>
							<cfinput type="hidden" name="quality_type_name_#current_row#" id="quality_type_name_#current_row#" value="#get_quality_id.PRODUCT_QUALITY_CONTROL_TYPE#">
							<td>
								<div class="form-group">
									<div class="col col-8">
										<cfif isDefined('get_quality_id.sample_number')><input type="text" readonly name="sample_number_#current_row#" id="sample_number_#current_row#" value="#TLFormat(get_quality_id.sample_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
									</div>
									<div class="col col-4">
										<cfif isDefined('get_quality_id.sample_method')>
											<input type="text" name="samp" id="samp" readonly value="<cfif get_quality_id.sample_method eq 1>R<cfelseif get_quality_id.sample_method eq 2>%<cfelseif get_quality_id.sample_method eq 3>K</cfif>" title="<cfif get_quality_id.sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif get_quality_id.sample_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif get_quality_id.sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
											<input type="hidden" name="sample_method_#current_row#" id="sample_method_#current_row#" value="#get_quality_id.sample_method#">
										</cfif>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="col col-8">
										<input type="text" name="amount_#current_row#" id="amount_#current_row#" value="#get_quality_id.amount#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
									</div>
									<div class="col col-4">
										<cfset unit= get_quality_id.unit>
										<cfif isDefined('unit')>
											<input type="text" name="units" id="units" value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">
											<input type="hidden" name="unit_#current_row#" id="unit_#current_row#" value="#unit#">
										</cfif>
									</div>
								</div>
							</td>
							<td class="text-right"><input type="text" name="min_limit_#current_row#" id="min_limit_#current_row#" value="#TLFormat(get_quality_id.MIN_LIMIT)#" readonly class="moneybox"/></td>
							<td class="text-right"><input type="text" name="max_limit_#current_row#" id="max_limit_#current_row#" value="#TLFormat(get_quality_id.MAX_LIMIT)#" readonly class="moneybox"/></td>
							<td class="text-right"><input type="text" name="standart_value_#current_row#" id="standart_value_#current_row#" value="#TLFormat(get_quality_id.STANDART_VALUE)#" readonly class="moneybox"/></td>
							<td >
								<input class="text-center" type="text" readonly name="control_operators" id="control_operators" value="<cfif get_quality_id.control_operator eq 1>= <cfelseif get_quality_id.control_operator eq 2> > <cfelseif get_quality_id.control_operator eq 3><<cfelseif get_quality_id.control_operator eq 4>=><cfelseif get_quality_id.control_operator eq 5>=<</cfif>">
								<input type="hidden" name="control_operator_#current_row#" id="control_operator_#current_row#" value="#get_quality_id.control_operator#">
							</td>
							<td>
								<input type="text" name="result_#current_row#" id="result_#current_row#" value="#TLFormat(CONTROL_RESULT)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
							</td>
							<td>
								<div class="checkbox checbox-switch">
									<label>
										<input type="checkbox" name="accept_#current_row#" id="accept_#current_row#" value="1" <cfif ROW_QUALITY_VALUE eq 1>checked</cfif>>
										<span></span>
									</label>
								</div>
							</td>
							<td><input type="text" readonly name="type_description_#current_row#" id="type_description_#current_row#" value="#get_quality_id.DESCRIPTION#" /></td>
						</tr>
				</cfoutput>
			<cfelse>
				<tr> 
					<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cfloop>
<cfinput type="hidden" name="rowcount_" id="rowcount_" value="#rowcount_#">

<script>
	function change_val(row) {
		if($('#accepted_'+row).is(':checked')) {
			var table_length =$('#list_'+row+ ' tr .q_row').length;
			for ( i = 0; i < table_length; i++) {
				var tr_id = $('#list_'+row+ ' tr .q_row')[i].id;
				$('#'+tr_id).val(1);
			} 
		}
	}

</script>