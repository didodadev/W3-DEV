	<cfif isdefined("attributes.is_submit")>
		<cfinclude template="../query/add_location_management.cfm">
	<cfelse>	
		<cfquery name="get_stock_locations" datasource="#dsn#">
			SELECT
				SL.COMMENT,
				SL.DEPARTMENT_ID,
				SL.LOCATION_ID,
				PP.SHELF_CODE,
				PP.PRODUCT_PLACE_ID
			FROM 
				STOCKS_LOCATION SL,
				#dsn3_alias#.PRODUCT_PLACE PP
			WHERE
				SL.LOCATION_ID = PP.LOCATION_ID AND
				SL.DEPARTMENT_ID = PP.STORE_ID
			ORDER BY
				SL.COMMENT,
				SL.LOCATION_ID,
				PP.SHELF_CODE
		</cfquery>

		<cfparam name="attributes.task_in_out" default="0">
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfset attributes.company = get_par_info(attributes.company_id,-1,0,0)>
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			<cfset attributes.project_head = get_project_name(attributes.project_id)>
		<cfelse>
			<cfset attributes.project_head = "">
			<cfset attributes.project_id= "">
		</cfif>
			<cfquery name="get_company_products" datasource="#dsn3#">
				SELECT 
					S.*,
					PC.PRODUCT_CAT,
					ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = S.PRODUCT_ID),1) AS PALLET_MIKTAR
				FROM 
					STOCKS S,
					#dsn1_alias#.PRODUCT P,
					PRODUCT_CAT PC
				WHERE
					S.PRODUCT_ID = P.PRODUCT_ID AND
					S.PRODUCT_CATID = PC.PRODUCT_CATID
				ORDER BY
					PC.PRODUCT_CAT,
					S.PRODUCT_NAME
			</cfquery>
		<cfif isdefined("session.ep.userid")><cf_catalystHeader></cfif>
		<cf_box>
		<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=stock.location_management&event=add_service">
			<cf_box_elements>
			<input type="hidden" name="is_submit" id="is_submit" value="1">						
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-task_in_out" style="display:none;">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61806.????lem Tipi'> </label>
									<div class="col col-9 col-xs-12">
										<select name="task_in_out">
											<option value="0" <cfif attributes.task_in_out eq 0>selected</cfif>><cf_get_lang dictionary_id="63877.Receiving"></option>
											<option value="1" <cfif attributes.task_in_out eq 1>selected</cfif>><cf_get_lang dictionary_id="63876.Shipment"></option>
											<option value="2" <cfif attributes.task_in_out eq 2>selected</cfif>><cf_get_lang dictionary_id="63874.Say??m Sonucu"></option>
											<option value="3" <cfif attributes.task_in_out eq 3>selected</cfif>><cf_get_lang dictionary_id="63875.Say??m"></option>
										</select>
									</div>
								</div>
									<div class="form-group" id="item-company">
										<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
										<div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" readonly style="width:150px;">
												<cfset str_linke_ait="&field_comp_id=add_packet_ship.company_id&field_comp_name=add_packet_ship.company">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item_project_head">
										<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57416.Proje"></label>
										<div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
												<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
											</div>
										</div>
									</div>
								<div class="form-group" id="item-action_date">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
									<div class="col col-9 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57742.Tarih"> !</cfsavecontent>
											<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
											<cfoutput>
												<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
											</cfoutput>
										</div>
									</div>
								</div>
								<cfif isdefined("session.ep.userid")>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57576.??al????an"></label>
									<div class="col col-9 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
											<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly style="width:150px;">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.employee_id&field_name=add_packet_ship.employee_name&select_list=1','list');"></span>
										</div>
									</div>
								</div>
								</cfif>
							</div>
						</cf_box_elements>
							<div class="row" id="item-employee_id">
								<div class="col col-6 col-xs-6">
											<cf_grid_list>
											<thead>
												<tr>
													<th width="150"><cf_get_lang dictionary_id="63902.From Area"></th>
													<th width="150"><cf_get_lang dictionary_id="57657.??r??n"></th>
													<th width="50"><cf_get_lang dictionary_id="57635.Miktar"></th>
													<th width="150"><cf_get_lang dictionary_id="63903.Area To"></th>
													<th width="20"></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td width="150">
														<div class="form-group">
														<select name="from_pp_id" id="from_pp_id" style="width:150px;">
															<option value=""><cf_get_lang dictionary_id="57734.Se??iniz"></option>
															<option value="-1"><cf_get_lang dictionary_id="63904.Receiving Area"></option>
															<option value="-2"><cf_get_lang dictionary_id="63905.Shipping Area"></option>
															<cfoutput query="get_stock_locations" group="comment">
																<optgroup label="#comment#"></optgroup>
																<cfoutput>
																	<option value="#product_place_id#">#shelf_code#</option>
																</cfoutput>
															</cfoutput>
														</select>
													</div>
													</td>
													<td width="150">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="product_id" id="product_id">
															<input type="text" readonly name="urun" id="urun">
															<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac();"></span>
														</div>
													</div>
													</td>
													<td width="50">
													<cfinput type="text" name="product_amount" value="" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0,'float'));">
													</td>
													<td width="150">
														<div class="form-group">
														<select name="to_pp_id" id="to_pp_id" style="width:150px;">
															<option value=""><cf_get_lang dictionary_id="57734.Se??iniz"></option>
															<option value="-1"><cf_get_lang dictionary_id="63904.Receiving Area"></option>
															<option value="-2"><cf_get_lang dictionary_id="63905.Shipping Area"></option>
															<cfoutput query="get_stock_locations" group="comment">
																<optgroup label="#comment#"></optgroup>
																<cfoutput>
																	<option value="#product_place_id#">#shelf_code#</option>
																</cfoutput>
															</cfoutput>
														</select>
													</div>
													</td>													
													<td>
														<a title="<cf_get_lang dictionary_id="57582.Ekle">" onclick="add_row();"><i class="fa fa-plus"></i></a>
													</td>
												</tr>
											</tbody>
											</cf_grid_list>
								</div>	
							</div>					
						<div class=" row">
						<cf_seperator title="#getlang('','ITEMS','63900')#" id="items" is_closed="0">
							<div id="items">
							<div class="col col-6">
							<cfinput type="hidden" name="product_count" value="0">
							<cf_grid_list>
							<thead>
								<tr>
									<th width="150"><cf_get_lang dictionary_id="63902.From Area"></th>
									<th width="150"><cf_get_lang dictionary_id="57657.??r??n"></th>
									<th width="50"><cf_get_lang dictionary_id="57635.Miktar"></th>
									<th width="150"><cf_get_lang dictionary_id="63903.Area To"></th>
									<th width="20"><a href="javascript://"><i class="fa fa-minus"></i></a></th>
								</tr>
							</thead>
							<tbody id="pp_table"></tbody>
							</cf_grid_list></div>
						</div></div>
						<cf_box_footer>
								<cf_workcube_buttons is_upd='0'  add_function='control()'>
						</cf_box_footer>
		</cfform>
	</cf_box>
		<script type="text/javascript">
			function control()
			{
				if($("#company_id").val() == '') {
				alert('<cf_get_lang dictionary_id="41056.Cari Hesap girmelisiniz">!');
				return false;
				}
				return true;
			}
			
			function add_row()
			{
				product_id_ = document.getElementById('product_id').value;
				amount_ = document.getElementById('product_amount').value;
				from_pp_id_ = document.getElementById('from_pp_id').value;
				to_pp_id_ = document.getElementById('to_pp_id').value;
				
				if(product_id_ == '' || amount_ == '' || from_pp_id_ == '' || to_pp_id_ == '')
				{
					alert('<cfoutput>#getlang('','L??tfen T??m alanlar?? doldurun','63399')#</cfoutput>');
					return false;
				}
				
				if(from_pp_id_ == to_pp_id_)
				{
					alert('<cfoutput>#getlang('','Farkl?? Alanlar Se??iniz!','63745')#</cfoutput>');
					return false;
				}
				
				
				
				p_name_ = document.getElementById('urun').value;
				from_pp_ = document.getElementById('from_pp_id').options[document.getElementById('from_pp_id').selectedIndex].text;
				to_pp_ = document.getElementById('to_pp_id').options[document.getElementById('to_pp_id').selectedIndex].text;
				
				sayi_ = parseInt(document.getElementById('product_count').value) + 1;
				
				table = document.getElementById("pp_table");
				row = table.insertRow(0);

				row.id = "row_" + sayi_;
				row.ID = "row_" + sayi_;
				
				cell1 = row.insertCell(0);
				cell2 = row.insertCell(1);
				cell3 = row.insertCell(2);
				cell4 = row.insertCell(3);
				cell5 = row.insertCell(4);
				
				cell1.innerHTML = from_pp_;
				cell2.innerHTML = p_name_;
				cell3.innerHTML = amount_;
				cell4.innerHTML = to_pp_;
				
				cell5.innerHTML = '';
				cell5.innerHTML += '<input type="hidden" name="product_id_' + sayi_ + '" value="' + list_getat(product_id_,1,"-") + '">';
				cell5.innerHTML += '<input type="hidden" name="stock_id_' + sayi_ + '" value="' + list_getat(product_id_,2,"-") + '">';
				cell5.innerHTML += '<input type="hidden" name="product_amount_' + sayi_ + '" value="' + amount_ + '">';
				cell5.innerHTML += '<input type="hidden" name="from_pp_id_' + sayi_ + '" value="' + from_pp_id_ + '">';
				cell5.innerHTML += '<input type="hidden" name="to_pp_id_' + sayi_ + '" value="' + to_pp_id_ + '">';
				cell5.innerHTML += '<input type="hidden" name="is_active_' + sayi_ + '" id="is_active_' + sayi_ + '" value="1"><a href="javascript://" onclick="delete_row(' + sayi_ + ')"><i class="fa fa-minus"></i></a>';
				
				document.getElementById('product_count').value = sayi_;
				document.getElementById('product_id').value = '';
				document.getElementById('product_amount').value = '';
				document.getElementById('to_pp_id').value = '';
				document.getElementById('urun').value = '';	
			}
			
			function delete_row(row_id)
			{
				document.getElementById('is_active_' + row_id).value = 0;
				hide('row_' + row_id);
			}
			function pencere_ac(no)
			{
				if(add_packet_ship.company_id.value != '')
				openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&3pl=1&company_id="+add_packet_ship.company_id.value+"&product_id=add_packet_ship.product_id&field_name=add_packet_ship.urun");
				else
				alert("<cf_get_lang dictionary_id='33557.Cari Hesap Se??melisiniz'>!");
			}
		</script>
	</cfif>