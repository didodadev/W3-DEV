<cf_xml_page_edit fuseact="product.popup_add_anative_product">
	<cfparam name="attributes.tree_stock_id" default="">
	<cfparam name="attributes.modal_id" default="">
	<cfquery name="get_product_name" datasource="#dsn3#">
		SELECT 
			PRODUCT_NAME,
			PRODUCT_CATID 
		FROM 
			STOCKS 
		WHERE 
			1=1
			<cfif isdefined('attributes.pid')>
				AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			</cfif>
			<cfif isdefined('attributes.sid')>
				AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
			</cfif>
	</cfquery>
	<cfif isdefined('attributes.sid') and not isdefined('attributes.pid')>
		<cfquery name="get_pid" datasource="#dsn3#">
			SELECT TOP 1 PRODUCT_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		</cfquery>
		<cfset attributes.pid = get_pid.PRODUCT_ID>
	</cfif>
	<cfquery name="get_alternative" datasource="#dsn3#">
		SELECT 
			AP.*,
			S.PRODUCT_NAME,
			S.STOCK_CODE,
			S.STOCK_ID
		FROM 
			ALTERNATIVE_PRODUCTS AP,
			STOCKS S
		WHERE 
			S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
			S.STOCK_ID = AP.STOCK_ID
			<cfif isdefined('attributes.pid') and len(attributes.pid)>
			   AND AP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			</cfif> 
			<cfif x_is_product_tree eq 1>
				<cfif isdefined('attributes.question_id') and len(attributes.question_id) and attributes.question_id neq 0>
				   AND AP.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
				</cfif>
				<cfif isdefined('attributes.tree_stock_id') and len(attributes.tree_stock_id)>
				   AND TREE_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_stock_id#">
				</cfif>        
			</cfif>
			<cfif isdefined('attributes.product_tree_id') and len(attributes.product_tree_id)>
				AND PRODUCT_TREE_ID = #attributes.product_tree_id#
			</cfif>
		ORDER BY ALTERNATIVE_PRODUCT_NO
	</cfquery>
	
	<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
		SELECT
			PP.PROPERTY_ID,
			PP.PROPERTY,
			PPD.PROPERTY_DETAIL_ID,
			PPD.PROPERTY_DETAIL,
			PPD.PRPT_ID,
			SAQ.PROPERTY_ID
		FROM 
			PRODUCT_PROPERTY as pp
			LEFT JOIN #DSN#.SETUP_ALTERNATIVE_QUESTIONS AS SAQ ON SAQ.PROPERTY_ID=PP.PROPERTY_ID
			LEFT JOIN  PRODUCT_PROPERTY_DETAIL as PPD ON PPD.PRPT_ID=PP.PROPERTY_ID
			WHERE <cfif isdefined('attributes.question_id') and len(attributes.question_id)>SAQ.QUESTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">AND</cfif>
			SAQ.PROPERTY_ID=PP.PROPERTY_ID
	</cfquery>
	<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
		<cfquery name="GET_QUES_NAME" datasource="#dsn#">
			SELECT QUESTION_ID,QUESTION_NAME,PROPERTY_ID FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
		</cfquery>
	</cfif>
	<cfset product_id_list = listdeleteduplicates(ValueList(get_alternative.ALTERNATIVE_PRODUCT_ID,','))>
	<cfsavecontent variable="header_">
		<cfoutput>
			<cf_get_lang dictionary_id='37718.Alternatif Ürün'> : #get_product_name.product_name#
			
		</cfoutput>
	</cfsavecontent>
	<cfparam name="attributes.modal_id" default="">
	<cf_box title="#header_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_product_alternative" action="#request.self#?fuseaction=product.emptypopup_add_anative_product&call_function=yeni_yukle" method="post">
			<cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
			<div class="col col-12 col-xs-12">
				<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
					<div class="ui-info-bottom">
						<cfoutput><cf_get_lang dictionary_id="58810.Soru"> : #GET_QUES_NAME.QUESTION_NAME#</cfoutput>
					</div>
				</cfif>
				<cf_grid_list>
					<thead style="display:none;">
						<tr>
							<td>
								<cfoutput>
									<input type="hidden" name="pid" id="pid" value="#attributes.pid#">
									<input type="hidden" name="x_is_product_tree" id="x_is_product_tree" value="#x_is_product_tree#">
									<input name="record_num" id="record_num" type="hidden" value="#get_alternative.recordcount#">
									<input type="hidden" name="product_tree_id" id="product_tree_id"  value="<cfif isdefined('attributes.product_tree_id')>#attributes.product_tree_id#</cfif>">
									<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
									<input type="hidden" name="question_id" id="question_id" value="#attributes.question_id#"></cfif>
									<input type="hidden" name="tree_stock_id" id="tree_stock_id" value="<cfif isdefined('attributes.tree_stock_id')>#attributes.tree_stock_id#</cfif>">
									<input type="hidden" name="company_id" id="company_id" value="">
								</cfoutput>
								<cf_wrk_members form_name='add_product_alternative' member_name='company' company_id='company_id' select_list='2'>
							</td>
						</tr>
					</thead>
					<cfset company_list="">
					<cfset spect_main_list="">
					<cfif get_alternative.recordcount>
						<cfset alternative_product_id_list =""> 
						<cfoutput query="get_alternative">
						<input type="hidden" name="tree_stock_id#currentrow#" id="tree_stock_id#currentrow#" value="#get_alternative.TREE_STOCK_ID#">
							<cfif len(COMPANY_ID) and not listfind(company_list,COMPANY_ID)><cfset company_list = ListAppend(company_list,COMPANY_ID)></cfif>
							<cfif len(SPECT_MAIN_ID) and not listfind(spect_main_list,SPECT_MAIN_ID)><cfset spect_main_list = ListAppend(spect_main_list,SPECT_MAIN_ID)></cfif>
						</cfoutput>
						<cfif len(alternative_product_id_list)>
							<cfquery name="get_product_name" datasource="#dsn1#">
								SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#alternative_product_id_list#) ORDER BY PRODUCT_ID
							</cfquery>
							<cfset alternative_product_id_list = listsort(listdeleteduplicates(valuelist(get_product_name.product_id,',')),'numeric','ASC',',')>
						</cfif>
					</cfif>
					<cfif len(company_list)>
						<cfset company_list=listsort(company_list,"numeric","ASC",",")>
						<cfquery name="get_company_name" datasource="#dsn#">
							SELECT
								FULLNAME,
								COMPANY_ID
							FROM
								COMPANY
							WHERE
								COMPANY_ID IN(#company_list#)
							ORDER BY
								COMPANY_ID
						</cfquery>
						<cfset company_list = listsort(listdeleteduplicates(valuelist(get_company_name.COMPANY_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(spect_main_list)>
						<cfset spect_main_list=listsort(spect_main_list,"numeric","ASC",",")>
						<cfquery name="get_spect_name" datasource="#dsn3#">
							SELECT
								SPECT_MAIN_ID,
								SPECT_MAIN_NAME
							FROM
								SPECT_MAIN
							WHERE
								SPECT_MAIN_ID IN(#spect_main_list#)
							ORDER BY
								SPECT_MAIN_ID
						</cfquery>
						<cfset spect_main_list = listsort(listdeleteduplicates(valuelist(get_spect_name.SPECT_MAIN_ID,',')),'numeric','ASC',',')>
					</cfif>
					<thead>
						<tr>
							<th width="20">
								<input type="hidden" name="product_id_list" id="product_id_list" value="<cfoutput>#product_id_list#</cfoutput>">
								<a href="javascript://" onclick="pencere_ac_product();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a>
							</th>
							<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='37700.Ürün Açıklama'></th>
							<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
								<th  width="200"><cf_get_lang dictionary_id='57647.Spec'></th>
								<cfif len(GET_PROPERTY_CAT.PROPERTY)><th width="100px"><cfoutput>#GET_PROPERTY_CAT.PROPERTY#</cfoutput></th></cfif>
								<th><cf_get_lang dictionary_id='40578.Kullanım Oranı'>%</th>
							</cfif>
							
							<th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
							
								<cfif isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1>
									<th><cf_get_lang dictionary_id='37793.Alternatif Miktarı'>/<cf_get_lang dictionary_id ='58671.Oranı'></th>
								</cfif>
								<cfif isdefined('is_view_alternative_date') and is_view_alternative_date eq 1>
									<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
									<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
								</cfif>
								<cfif isdefined('is_view_useage_product_amount') and is_view_useage_product_amount eq 1>
									<th><cf_get_lang dictionary_id ='37794.Kullanım Miktarı'></th>
								</cfif>
							<cfif (isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1) and isdefined('is_view_alternative_fire') and is_view_alternative_fire eq 1>
								<th><cf_get_lang dictionary_id ='37273.Fire Miktar'></th>
								<th><cf_get_lang dictionary_id ='37295.Fire Oranı'></th>
							</cfif>
							<cfif isdefined('x_is_phantom') and x_is_phantom eq 1>
								<th width="20" class="text-center" title="Phantom">P</th>
							</cfif>
						</tr>
					</thead>
					<tbody id="table1">
						<cfoutput query="get_alternative">
							<tr id="frm_row#currentrow#">
								<td align="center">
									<a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a>
									<cfinput type="hidden" name="is_delete_alternative_id#currentrow#" id="is_delete_alternative_id#currentrow#" value="1">
									<cfinput type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
								</td>
								<td>
									<div class="form-group" width="30">
										<cfinput type="text" name="alternative_product_no#currentrow#"  id="alternative_product_no#currentrow#" value="#ALTERNATIVE_PRODUCT_NO#" onkeyup="isNumber(this);" >
									</div>
								</td>
								<td>
									<div class="form-group">
										<cfinput type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#stock_code#" readonly="">
									</div>
								</td>						
								<td>
									<div class="form-group">
										<cfinput type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
										<cfinput type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#alternative_product_id#">
										<cfinput type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name#" readonly="">
									</div>
								</td>
								<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
									<td>
										<div class="form-group">
											<div class="input-group">
												<div class="col col-3">
												<cfinput type="text" name="spect_main_id#currentrow#" id="spect_main_id#currentrow#" value="#spect_main_id#">
												</div>
												<div class="col col-9">
												<input type="text" name="spect_main_name#currentrow#" id="spect_main_name#currentrow#" value="<cfif len(spect_main_id)>#get_spect_name.SPECT_MAIN_NAME[listfind(spect_main_list,get_alternative.spect_main_id,',')]#</cfif>" readonly="">
												</div>
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec('#currentrow#');"></span>
											</div>
										</div>
									</td>
									<cfif len(GET_PROPERTY_CAT.PROPERTY)>
										<td>
											<div class="form-group">
												<select name="property_id#currentrow#" id="property_id#currentrow#">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="GET_PROPERTY_CAT" >
														<option value="#PROPERTY_DETAIL_ID#"<cfif PROPERTY_DETAIL_ID eq get_alternative.property_id>selected</cfif>>#PROPERTY_DETAIL#</option>
													</cfloop>
												</select>
											</div>
		
										</td>
									</cfif>
									<td>
										<div class="form-group">
											<cfinput type="text" name="usage_rate#currentrow#" id="usage_rate#currentrow#" value="#TLFormat(usage_rate,4)#"  onkeyup="return(FormatCurrency(this,event,4));">
										</div>
									</td>	
								</cfif>					
								<td>
									<div class="form-group">
										<div class="input-group">
											<cfinput type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#COMPANY_ID#">
											<input type="text" name="company#currentrow#" id="company#currentrow#" value="<cfif len(company_id)>#get_company_name.FULLNAME[listfind(company_list,get_alternative.company_id,',')]#</cfif>">
											<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=add_product_alternative.company#currentrow#&field_comp_id=add_product_alternative.company_id#currentrow#&select_list=2&is_form_submitted=1&keyword='+decodeURIComponent(document.add_product_alternative.company#currentrow#.value));"></span>
										</div>
									</div>
								</td>
								<cfif isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1>
									<td>
										<div class="form-group">
											<cfinput type="text" name="alternative_product_amount#currentrow#" id="alternative_product_amount#currentrow#" value="#TLFormat(ALTERNATIVE_PRODUCT_AMOUNT)#" onkeyup="return(FormatCurrency(this,event,8));"></td>
										</div>
								</cfif>
								<cfif isdefined('is_view_alternative_date') and is_view_alternative_date eq 1>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="text" name="start_date#currentrow#" id="start_date#currentrow#" value="<cfif len(START_DATE)>#DateFormat(START_DATE,dateformat_style)#</cfif>"  maxlength="10">
												<cf_wrk_date_image date_field="start_date#currentrow#">
											</div>
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="text" name="finish_date#currentrow#" id="finish_date#currentrow#" value="<cfif len(FINISH_DATE)>#DateFormat(FINISH_DATE,dateformat_style)#</cfif>"  maxlength="10">
												<cf_wrk_date_image date_field="finish_date#currentrow#">
											</div>
										</div>
									</td>
								</cfif>
								<cfif isdefined('is_view_useage_product_amount') and is_view_useage_product_amount eq 1>
									<td>
										<div class="form-group">
											<cfinput type="text" name="useage_product_amount#currentrow#" id="useage_product_amount#currentrow#" value="#TLFormat(USEAGE_PRODUCT_AMOUNT,8)#" onkeyup="return(FormatCurrency(this,event,8));"></td>
										</div>
									</td>
								</cfif>
								<cfif (isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1) and isdefined('is_view_alternative_fire') and is_view_alternative_fire eq 1>
									<td>
										<div class="form-group">
											<cfinput type="text" name="alternative_fire_amount#currentrow#" id="alternative_fire_amount#currentrow#" value="#TLFormat(ALTERNATIVE_FIRE_AMOUNT)#" onkeyup="return(FormatCurrency(this,event,8));">
										</div>
									</td>
									<td>
										<div class="form-group">
											<cfinput type="text" name="alternative_fire_rate#currentrow#" id="alternative_fire_rate#currentrow#" value="#TLFormat(ALTERNATIVE_FIRE_RATE)#" onkeyup="return(FormatCurrency(this,event,4));">
										</div>
									</td>
								</cfif>
								<cfif isdefined('x_is_phantom') and x_is_phantom eq 1>
									<td>
										<div class="form-group">
											<input type="checkbox" name="is_phantom#currentrow#" id="is_phantom#currentrow#" value="1"<cfif is_phantom eq 1>checked</cfif>>
										</div>
									</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
				<input type="hidden" name="product_id_list" id="product_id_list" value="">				
				<cf_box_footer>
					<cf_record_info 
						query_name="get_alternative"
						record_emp="record_emp" 
						record_date="record_date"
						update_emp="update_emp"
						update_date="update_date">
					<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("control() && loadPopupBox('add_product_alternative' , #attributes.modal_id#)"),DE(""))#">
				</cf_box_footer>
			</div>
		</cfform>
	</cf_box>		
	<script type="text/javascript">
		<cfif get_alternative.recordcount>
			row_count=<cfoutput>#get_alternative.recordcount#</cfoutput>;
			satir_say=<cfoutput>#get_alternative.recordcount#</cfoutput>;
		<cfelse>
			row_count=0;
			satir_say=0;
		</cfif>
		function control()
		{
			var product_spect_list = '';
			var same_product_code_list = '';
			for(var k=1;k<=document.add_product_alternative.record_num.value;k++)
			{
				if(document.getElementById('row_kontrol'+k).value == 1)
				{
					if(document.getElementById('alternative_fire_amount'+k) != undefined && document.getElementById('alternative_fire_amount'+k).value != "" && document.getElementById('alternative_fire_rate'+k).value != "")
					{
						alert("<cf_get_lang dictionary_id='36383.Fire Miktarı ve Fire Oranı Birlikte Girilemez'>!");
						return false;
					}
					if(document.getElementById('spect_main_id'+k).value == '')
						spect_main_id_ = 0;
					else
						spect_main_id_ = document.getElementById('spect_main_id'+k).value;
					stock_spect_id = document.getElementById('stock_id'+k).value+'_'+spect_main_id_;
					if(product_spect_list == '')
					{
						product_spect_list = stock_spect_id;
					}
					else
					{
						if(! list_find(product_spect_list,stock_spect_id))
							product_spect_list = product_spect_list+','+stock_spect_id;
						else
						{
							if(same_product_code_list == '')
								same_product_code_list = document.getElementById('stock_code'+k).value;
							else
								same_product_code_list = same_product_code_list+','+document.getElementById('stock_code'+k).value;
						}
					}
					if(document.getElementById('useage_product_amount'+k) != null)
						document.getElementById('useage_product_amount'+k).value=filterNum(document.getElementById('useage_product_amount'+k).value,8);
					if(document.getElementById('alternative_product_amount'+k) != null)
						document.getElementById('alternative_product_amount'+k).value=filterNum(document.getElementById('alternative_product_amount'+k).value);
					if(document.getElementById('alternative_fire_amount'+k) != null)
						document.getElementById('alternative_fire_amount'+k).value=filterNum(document.getElementById('alternative_fire_amount'+k).value);
					if(document.getElementById('alternative_fire_rate'+k) != null)
						document.getElementById('alternative_fire_rate'+k).value=filterNum(document.getElementById('alternative_fire_rate'+k).value);
				}
			}
			if(same_product_code_list != '')
			{
				alert("<cf_get_lang dictionary_id='60441.Aynı Ürün Birden Fazla Seçilemez'>. <cf_get_lang dictionary_id='60442.Lütfen Aşağıdaki Ürünleri Kontrol Ediniz'> ! \n "+same_product_code_list);
				return false;
			}
			
			for(var xx=1;xx<=document.add_product_alternative.record_num.value;xx++)
			{	//Ondalik Hane icin
				document.getElementById("usage_rate"+xx).value = filterNum(document.getElementById("usage_rate"+xx).value,4);
			}
			return true;	
		}
		function sil(sy)
		{
			eval(("add_product_alternative.is_delete_alternative_id"+sy).value = 0);
			var my_element=eval("add_product_alternative.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			satir_say--;
		}
		function product_gonder(product_id,product_name,stock_code,stock_id)
		{
			QueryTextSpec = 'prdp_get_main_spec_id_3';
			var get_main_spec_id_ = wrk_safe_query(QueryTextSpec,'dsn3',0,stock_id);
			if(get_main_spec_id_.recordcount)
			{
				spect_main_id = get_main_spec_id_.SPECT_MAIN_ID ;
				spect_main_name = get_main_spec_id_.SPECT_MAIN_NAME ;
			}
			else
			{
				spect_main_id = "" ;
				spect_main_name = "";
			}
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
			document.add_product_alternative.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="alternative_product_no' + row_count +'" id="alternative_product_no' + row_count +'" value=""  style="width:30px;" onkeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+stock_code+'" readonly>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+ product_id +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+ stock_id +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name +'" onkeyup="isNumber(this);" readonly>';
			<cfif isdefined('attributes.question_id') and len(attributes.question_id)>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><input type="text" name="spect_main_id'+ row_count +'" id="spect_main_id'+ row_count +'" value="'+spect_main_id+'" readonly> <div class="input-group"><input type="text" name="spect_main_name'+ row_count +'" id="spect_main_name'+ row_count +'" value="'+spect_main_name+'" readonly><span class="input-group-addon icon-ellipsis"  onClick="open_spec('+ row_count +');" align="absmiddle"></span></div></div>';
				<cfif len(GET_PROPERTY_CAT.PROPERTY)>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="property_id' + row_count + '" id="property_id' + row_count + '"  ><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="GET_PROPERTY_CAT"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="usage_rate' + row_count +'" id="usage_rate' + row_count +'" onkeyup="return(FormatCurrency(this,event,4));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="" onkeyup=""><input type="text" name="company' + row_count +'" id="company' + row_count +'" value="" onkeyup=""> <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_product_alternative.company'+row_count+'&field_comp_id=add_product_alternative.company_id'+row_count+'&select_list=2&is_form_submitted=1&keyword=\'+document.add_product_alternative.company'+row_count+'.value);" align="absmiddle"></span></div></div>';
			<cfif isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="alternative_product_amount' + row_count +'" id="alternative_product_amount' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">';
			</cfif>
			<cfif isdefined('is_view_alternative_date') and is_view_alternative_date eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","start_date" + row_count + "_td");
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="text" name="start_date' + row_count+'" id="start_date' + row_count+'" maxlength="10" value="">';
				wrk_date_image('start_date' + row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","finish_date" + row_count + "_td");
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML =  '<input type="text" name="finish_date' + row_count+'" id="finish_date' + row_count+'" maxlength="10" value="">';
				wrk_date_image('finish_date' + row_count);
			</cfif>
			<cfif isdefined('is_view_useage_product_amount') and is_view_useage_product_amount eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="useage_product_amount' + row_count +'" id="useage_product_amount' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,8));">';
			</cfif>
			<cfif (isdefined('is_view_alternative_product_amount') and is_view_alternative_product_amount eq 1) and isdefined('is_view_alternative_fire') and is_view_alternative_fire eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="alternative_fire_amount' + row_count +'" id="alternative_fire_amount' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,4));">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="alternative_fire_rate' + row_count +'" id="alternative_fire_rate' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,4));">';
			</cfif>
			<cfif isdefined('x_is_phantom') and x_is_phantom eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('align','center');
				newCell.innerHTML = '<input type="checkbox" name="is_phantom' + row_count +'" id="is_phantom' + row_count +'" value="1">';
			</cfif>
		}
		function pencere_ac_product()
		{
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_products_only&stock_id=add_product_alternative.stock_id&product_catid=#get_product_name.product_catid#</cfoutput>&is_alternative_products=1&product_id=add_product_alternative.anative_product_id&field_name=add_product_alternative.product_name&call_function=get_product_main_spec_row&call_function_parameter='+row_count+'&row_info='+row_count+'');
		}
		function open_spec(row_info)
		{
			if(document.getElementById('stock_id'+row_info).value.length > 0 && document.getElementById('product_name'+row_info).value.length > 0)
			{
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&basket_id=1&field_name=add_product_alternative.spect_main_name'+row_info+'&field_main_id=add_product_alternative.spect_main_id'+row_info+'&stock_id='+document.getElementById('stock_id'+row_info).value);
			}	
			else
				alert("<cf_get_lang dictionary_id ='36677.Ürün Seçmelisiniz'>!");
		}
		function get_product_main_spec_row(row_info)
		{
			if(document.getElementById('stock_id'+row_info).value != "" && document.getElementById('product_name'+row_info).value != "")
			{
				var listParam = document.getElementById('stock_id'+row_info).value;
				QueryTextSpec = 'prdp_get_main_spec_id_3';
				var get_main_spec_id = wrk_safe_query(QueryTextSpec,'dsn3',0,listParam);
				if(get_main_spec_id.recordcount)
				{
					document.getElementById('spect_main_id'+row_info).value = get_main_spec_id.SPECT_MAIN_ID ;
					document.getElementById('spect_main_name'+row_info).value = get_main_spec_id.SPECT_MAIN_NAME ;
				}
				else
				{
					document.getElementById('spect_main_id'+row_info).value = "";
					document.getElementById('spect_main_name'+row_info).value = "";
				}
			}	
			else
				alert('<cf_get_lang dictionary_id="36831.Önce Ürün Seçiniz">');
		}
	</script>
	