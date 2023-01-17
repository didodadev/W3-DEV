<cf_xml_page_edit fuseact="product.popup_form_add_product_dt_property">
	<cfquery name="get_product_properties_rec" datasource="#dsn1#">
		SELECT PRODUCT_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	
	<cfquery name="category" datasource="#dsn1#">
		SELECT * FROM PRODUCT_CAT PC,PRODUCT P WHERE P.PRODUCT_ID = #attributes.pid# AND PC.PRODUCT_CATID = P.PRODUCT_CATID
	</cfquery>
	<cfset ust_cat_code=listdeleteat(category.hierarchy,ListLen(category.hierarchy,"."),".")>
	<!--- Kayitlar tekrarli geldigi icin unionda duzenleme yapildi FBS 20100531 --->
	<cfquery name="GET_PROPERTY" datasource="#dsn1#">
		SELECT
			PCP.IS_WORTH ,
			PCP.IS_OPTIONAL,
			PCP.IS_AMOUNT,
			PCP.IS_INTERNET,
			PCP.LINE_VALUE,
			PP.PROPERTY PROPERTY,
			PP.PROPERTY_ID ID_VALUE
			 <cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
			,PPD.PROPERTY_DETAIL_ID
			,PPD.PROPERTY_DETAIL
			</cfif>
		FROM
			PRODUCT_CAT_PROPERTY PCP
				LEFT JOIN PRODUCT_PROPERTY PP ON  PP.PROPERTY_ID = PCP.PROPERTY_ID 
				LEFT JOIN PRODUCT P ON PCP.PRODUCT_CAT_ID = P.PRODUCT_CATID 
			<cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
				LEFT JOIN PRODUCT_PROPERTY_DETAIL PPD ON PP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID AND PPD.IS_ACTIVE = 1 
			</cfif>
		WHERE
			   P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif IsDefined("xml_is_parent_cat") and xml_is_parent_cat eq 1>
			UNION ALL
			SELECT
				PCP.IS_WORTH ,
				PCP.IS_OPTIONAL,
				PCP.IS_AMOUNT,
				PCP.IS_INTERNET,
				PCP.LINE_VALUE,
				PP.PROPERTY PROPERTY,
				PP.PROPERTY_ID ID_VALUE
				<cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
				,PPD.PROPERTY_DETAIL_ID
				,PPD.PROPERTY_DETAIL
				</cfif>
			FROM
				PRODUCT_CAT_PROPERTY PCP
				LEFT JOIN PRODUCT_CAT PC ON PCP.PRODUCT_CAT_ID = PC.PRODUCT_CATID 
				LEFT JOIN PRODUCT_PROPERTY PP ON  PP.PROPERTY_ID = PCP.PROPERTY_ID 
			<cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
				 JOIN PRODUCT_PROPERTY_DETAIL PPD ON PP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID  AND PPD.IS_ACTIVE = 1
			   </cfif>
			WHERE
				 PC.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ust_cat_code#">                   
		</cfif>
	   ORDER BY
	   LINE_VALUE, 
			ID_VALUE
	</cfquery>
	<cfif GET_PROPERTY.recordcount>
	<cfquery name="GET_VARIATION_CAT" datasource="#DSN1#">
		SELECT
			PRPT_ID,
			PROPERTY_DETAIL_ID,
			PROPERTY_DETAIL
			
		FROM
			PRODUCT_PROPERTY_DETAIL
		WHERE
			IS_ACTIVE = 1 AND
			PRPT_ID IN (#valueList(get_property.id_value)#)
		ORDER BY
			PROPERTY_DETAIL
	</cfquery>
	<cfelse>
	<cfset GET_VARIATION_CAT.recordcount = 0>
	</cfif>
	<cfparam name="attributes.modal_id" default="">
	<cf_box title="#getLang('','Ürün Özellikleri',37408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_related_features" method="post" action="#request.self#?fuseaction=product.emptypopup_add_product_dt_property">
		<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
		<input type="hidden" name="auto_product_code_2" id="auto_product_code_2" value="<cfoutput>#xml_auto_product_code_2#</cfoutput>">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="120"><cf_get_lang dictionary_id='57632.Özellik'></th>
					<th width="120"><cf_get_lang dictionary_id='37249.Varyasyon'></th>
					<cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
						<th width="130"><cf_get_lang dictionary_id='57657.Ürün'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th  width="120"><cf_get_lang dictionary_id='37250.Değer'></th>
					<th  width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th  width="20"><cf_get_lang dictionary_id='37171.Input'></th>
					<th  width="20"><cf_get_lang dictionary_id='37100.Output'></th>
					<th  width="20"><cf_get_lang dictionary_id='37172.Web'></th>
					<th width="20">
						<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_property.recordcount#</cfoutput>">
						<a onClick="pencere_pos_kontrol();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
					</th>
				</tr>
			</thead>
			<tbody id="table1">
				<cfoutput query="get_property">
				<cfquery name="GET_VARIATION" dbtype="query">
					SELECT
						PROPERTY_DETAIL_ID,
						PROPERTY_DETAIL
					FROM
						GET_VARIATION_CAT
					WHERE
						PRPT_ID = #get_property.id_value#
					ORDER BY
						PROPERTY_DETAIL
				</cfquery>
				<tr id="frm_row#currentrow#">
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
								<input type="text" name="property#currentrow#" id="property#currentrow#" value="#property#">
								<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#id_value#"/>
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_pos('#currentrow#');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<cfif xml_auto_product_code_2 eq 1>
								<select name="variation_id#currentrow#" id="variation_id#currentrow#">
									<option value=""><cf_get_lang dictionary_id ='37249.Varyasyon'></option>
									<cfloop query="get_variation">
										<option value="#property_detail_id#">#property_detail#</option>
									</cfloop>
								</select>
							<cfelse>
								<div class="input-group">
									<input type="hidden" name="variation_id#currentrow#" id="variation_id#currentrow#" value="#get_property.property_detail_id#">
									<input type="text" name="variation#currentrow#" id="variation#currentrow#" value="#get_property.property_detail#">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_var('#currentrow#');" title="<cf_get_lang dictionary_id='33615.Varyasyon'> "></span>
								</div>
							</cfif>
						</div>
					</td>
					<cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
						<td>
							<div class="form-group" id="product_property">
								<div class="input-group">
									<input type="hidden" name="product_property_id#currentrow#" id="product_property_id#currentrow#" value="">
									<input type="text" name="product_property#currentrow#" id="product_property#currentrow#" value="">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_product_property('#currentrow#');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
								</div>
							</div>
						</td>
					</cfif>
					<td>
						<div class="form-group">
							<input type="text" name="detail#currentrow#" id="detail#currentrow#" value="">
						</div>
					</td>
					<td><div class="form-group"><input type="text" name="line_row#currentrow#" id="line_row#currentrow#" value="#line_value#" class="moneybox" maxlength="2" onKeyup="return(FormatCurrency(this,event));"></div></td>
					<td>
						<div class="form-group">
							<div class="col col-6 pl-0">
								<input type="text" name="total_max#currentrow#" id="total_max#currentrow#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" maxlength="10"> /
							</div>
							<div class="col col-6 pr-0">
								<input type="text" name="total_min#currentrow#" id="total_min#currentrow#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" maxlength="10">
							</div>
						</div>
					</td>
					<td><div class="form-group"><input type="text" name="amount#currentrow#" id="amount#currentrow#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" maxlength="10"></div></td>
					<td><div class="form-group"><input type="checkbox" name="is_optional#currentrow#" id="is_optional#currentrow#" <cfif is_optional eq 1>checked</cfif>></div></td>
					<td><div class="form-group"><input type="checkbox" name="is_exit#currentrow#" id="is_exit#currentrow#" <cfif is_optional eq 1>checked</cfif>></div></td>
					<td><div class="form-group"><input type="checkbox" name="is_internet#currentrow#" id="is_internet#currentrow#" <cfif is_internet eq 1>checked</cfif>></div></td>
					<td width="20"><a onclick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
				</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_related_features' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
		</cfform>
	</cf_box>
	
	<script type="text/javascript">
		row_count=<cfoutput>#get_property.recordcount#</cfoutput>;
		function sil(sy)
		{
			var my_element=eval("add_related_features.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
	
		function fillVariation(no)
		{
			$("#variation_id"+no).empty();
			var listParam = $("#property_id"+no).val();
			var columns = wrk_safe_query('variation control','DSN1',0,listParam);
			$("#variation_id"+no).append('<option value=""><cf_get_lang dictionary_id='37249.Varyasyon'></option>');
			if(columns.recordcount)
			{
				for ( var i = 0; i < columns.recordcount; i++ ) {
				$("#variation_id"+no).append('<option value='+columns.PROPERTY_DETAIL_ID[i]+'>'+columns.PROPERTY_DETAIL[i]+'</option>');
				}
			}
		}
		function select_var(crntrw)
		{
			<cfoutput>
				windowopen('#request.self#?fuseaction=product.popup_list_variations_property&property_id=' + eval('document.getElementById("property_id' + crntrw + '")').value + '&record_num_value=' + crntrw + '','list'); 
			</cfoutput>
		}
	
		function pencere_pos(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&property=add_related_features.property' + no + '&property_id=add_related_features.property_id' + no + '&is_select=1&is_product_property=1&value_deger='+no,'list');
		}
		function pencere_product_property(no)
		{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_related_features.product_property_id' + no + '&field_name=add_related_features.product_property' + no );
		}
		
								   
		function pencere_pos_kontrol()
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties<cfif xml_auto_product_code_2 eq 0>&xml_auto_product_code_2=0</cfif>&form_name=add_related_features&record_num_value=' + document.add_related_features.record_num.value);
		}
		function kontrol()
		{
			if(add_related_features.record_num.value == "")
			{
				alert("<cf_get_lang dictionary_id ='37173.Lütfen Satir Giriniz'> !");
				return false;
			}
			for (var r=1;r<=add_related_features.record_num.value;r++)
			{
				value_line = eval('add_related_features.line_row'+r);
				value_amount = eval('add_related_features.amount'+r);
				value_total_max = eval('add_related_features.total_max'+r);
				value_total_min = eval('add_related_features.total_min'+r);
				value_line.value = filterNum(value_line.value);
				value_amount.value = filterNum(value_amount.value);
				value_total_max.value = filterNum(value_total_max.value);
				value_total_min.value = filterNum(value_total_min.value);
				/*value_detail = eval('add_related_features.detail'+r);
				if(value_detail.value.length >300)
				{
					alert("<cf_get_lang dictionary_id ='37038.Açıklama Alanına En Fazla 300 Karakter Girilebilir'>!");
					return false;
				}*/
			}
			return true;
		}
	</script>
	