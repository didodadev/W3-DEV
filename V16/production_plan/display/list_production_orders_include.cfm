<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID,
		STATION_NAME,
		ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,
		ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,
		ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
		ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
	FROM 
		#dsn3_alias#.WORKSTATIONS 
	WHERE 
		DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# ) 
	ORDER BY 
		STATION_NAME ASC
</cfquery>
<cfif not isdefined("attributes.is_demand")><cfset attributes.is_demand = 0></cfif>
<cfif not isdefined('attributes.is_group_page')>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
			<!-- sil --><th width="20"></th><!-- sil -->
			<th><cf_get_lang dictionary_id='57611.Sipariş'></th>
			<th><cf_get_lang dictionary_id='40294.Satış Çalışanı'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='36787.Teslim'></th>
			<cfif is_show_stock_code eq 1>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<cfif isdefined("is_order_detail") and is_order_detail eq 1><th><cf_get_lang dictionary_id="36708.Sipariş Açıklaması"></th></cfif>
			<cfif isdefined('is_show_spec') and is_show_spec eq 1 or not isdefined('is_show_spec')>
				<th><cf_get_lang dictionary_id='57647.spec'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th><cf_get_lang dictionary_id='57636.Birim'></th>
			<cfif isdefined('is_show_unit2') and is_show_unit2 eq 1 or not isdefined('is_show_unit2')>
				<th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='36418.Verilen Talep'></th>
			<th><cf_get_lang dictionary_id ='36800.Verilen Ü E'></th>
			<th><cf_get_lang dictionary_id ='58444.Kalan'></th>
			<cfif is_show_work_prog eq 1>
				<th><cf_get_lang dictionary_id ='36432.Çalışma Prog'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			<!-- sil -->
			<th width="240" title="<cf_get_lang dictionary_id='57655.Başlama Tarihi'>">
				<div class="form-group">
					<div class="col col-6">
						<div class="input-group">
							<input type="text" name="temp_date" id="temp_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" onchange="change_date_info();" validate="<cfoutput>#validate_style#</cfoutput>" message="<cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !">
							<span class="input-group-addon"><cf_wrk_date_image date_field="temp_date"></span>
						</div>
					</div>
					<div class="col col-6">
					<div class="col col-6">
						<input type="text" name="temp_hour" id="temp_hour" value="00" onKeyUp="isNumber(this);" onBlur="change_date_info();" validate="integer" message="<cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !">
					</div>
					<div class="col col-6">
						<input type="text" name="temp_min" id="temp_min" value="00" onKeyUp="isNumber(this);" onBlur="change_date_info();" validate="integer" message="<cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !">
					</div>
				</div>
				</div>
			</th>
			<!-- sil -->
			<th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id ='36824.Sipariş Print'>" alt="<cf_get_lang dictionary_id ='36824.Sipariş Print'>"></i></th>
			<th width="20" style="text-align:center;">
				<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1) and(isdefined("attributes.is_submitted") eq 1)>
					<input type="checkbox" name="allSelectOrder" id="allSelectOrder" onclick="wrk_select_all('allSelectOrder','is_active');">
				 </cfif>
			</th>
		</tr>
	</thead>
	<cfif get_orders.recordcount>
		<cfset company_name_list =''>
		<cfset consumer_name_list =''>
		<cfset spect_name_list =''>
		<cfset order_row_id_list=''>
		<cfset stock_id_list=''>
		<cfoutput query="get_orders">
			<cfif len(ORDER_ROW_ID)>
				<cfset order_row_id_list = ListAppend(order_row_id_list,ORDER_ROW_ID)>
			</cfif>
			<cfif len(COMPANY_ID) and not listfind(company_name_list,COMPANY_ID)>
				<cfset company_name_list = ListAppend(company_name_list,COMPANY_ID)>
			</cfif>
			<cfif len(CONSUMER_ID) and not listfind(consumer_name_list,CONSUMER_ID)>
				<cfset consumer_name_list = ListAppend(consumer_name_list,CONSUMER_ID)>
			</cfif>
			<cfif len(SPECT_VAR_ID) and not listfind(spect_name_list,SPECT_VAR_ID)>
				<cfset spect_name_list = ListAppend(spect_name_list,SPECT_VAR_ID)>
			</cfif>
			<cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
				<cfset stock_id_list = listappend(stock_id_list,STOCK_ID)>
			</cfif>
		</cfoutput>
		<cfif len(stock_id_list)>
			<cfquery name="GET_STOCK_STATIONS" datasource="#DSN3#">
				SELECT
					WP.STOCK_ID,
					0 AS MAIN_STOCK_ID ,
					W.STATION_ID AS STATION_ID_ ,
					W.STATION_NAME,
					WP.OPERATION_TYPE_ID,
					ISNULL(WP.PRODUCTION_TIME,0) P_TIME
				FROM 
					WORKSTATIONS W,
					WORKSTATIONS_PRODUCTS WP
				WHERE
					W.STATION_ID = WP.WS_ID 
					AND WP.STOCK_ID IN (#stock_id_list#)
					AND WP.OPERATION_TYPE_ID IS NULL
			UNION ALL
				SELECT
					WP.STOCK_ID,
					WP.MAIN_STOCK_ID,
					W.STATION_ID AS STATION_ID_ ,
					W.STATION_NAME,
					WP.OPERATION_TYPE_ID,
					ISNULL(WP.PRODUCTION_TIME,0) P_TIME
				FROM 
					WORKSTATIONS W,
					WORKSTATIONS_PRODUCTS WP
				WHERE
					W.STATION_ID = WP.WS_ID 
					AND WP.MAIN_STOCK_ID IN (#stock_id_list#)
			</cfquery>
			<cfloop query="GET_STOCK_STATIONS">
				<cfif not isdefined('stock_defined_stations_list_#STOCK_ID#')>
					<cfset 'stock_defined_stations_list_#STOCK_ID#' = STATION_ID_>
				<cfelse>
					<cfset 'stock_defined_stations_list_#STOCK_ID#' = listdeleteduplicates(ListAppend(Evaluate('stock_defined_stations_list_#STOCK_ID#'),STATION_ID_,','))>
				</cfif>
			</cfloop>
		</cfif>
		<cfif len(company_name_list)>
			<cfset company_name_list=listsort(company_name_list,"numeric","ASC",",")>
			<cfquery name="get_company_name" datasource="#DSN#">
				SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
			</cfquery>
			<cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.COMPANY_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(consumer_name_list)>
			<cfset consumer_name_list=listsort(consumer_name_list,"numeric","ASC",",")>
			<cfquery name="get_consumer_name" datasource="#DSN#">
				SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME AS CONSUMER_NAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.CONSUMER_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(order_row_id_list)>
			<cfset order_row_id_list=listsort(order_row_id_list,"numeric","ASC",",")>
			<cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
				SELECT 
					ISNULL(SUM(PO.QUANTITY),0) AS QUANTITY,
					POR.ORDER_ROW_ID,
					ISNULL(POR.TYPE,1) AS TYPE 
				FROM 
					PRODUCTION_ORDERS PO,
					PRODUCTION_ORDERS_ROW POR,
					ORDER_ROW OR_
				WHERE
					OR_.ORDER_ROW_ID =POR.ORDER_ROW_ID AND
					OR_.STOCK_ID = PO.STOCK_ID AND
					PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID
					AND POR.ORDER_ROW_ID IN (#order_row_id_list#)
				GROUP BY 
					POR.ORDER_ROW_ID,
					POR.TYPE
			</cfquery>
			<cfscript>
				for(gpi_ind=1;gpi_ind lte GET_PRODUCTION_INFO.recordcount;gpi_ind=gpi_ind+1){//ayrı ayrı göstereceğimiz için grupladık
					if(GET_PRODUCTION_INFO.TYPE[gpi_ind] eq 1)
						'verilen_uretim_emri_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
					else
						'verilen_talep_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
					if(not isdefined('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#'))
						'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' =GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
					else
						'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = Evaluate('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#')+GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
				}
			</cfscript>
		</cfif>
		<cfif len(spect_name_list)>
			<cfset spect_name_list=listsort(spect_name_list,"numeric","ASC",",")>
			<cfquery name="GET_SPECT_NAME" datasource="#DSN3#">
				SELECT SPECT_VAR_NAME,SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID IN (#spect_name_list#) ORDER BY SPECT_VAR_ID
			</cfquery>
			<cfset spect_name_list = listsort(listdeleteduplicates(valuelist(GET_SPECT_NAME.SPECT_VAR_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
		<cfquery name="get_station_times" datasource="#dsn#">
			SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
		</cfquery>
		<cfset works_prog = get_station_times.SHIFT_NAME>
		<cfset works_prog_id = get_station_times.SHIFT_ID>
		<cfoutput query="get_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(SPECT_VAR_ID)>
				<cfset _spect_main_id = GET_SPECT_NAME.SPECT_MAIN_ID[listfind(spect_name_list,get_orders.SPECT_VAR_ID,',')]>
				<cfset _spect_name = GET_SPECT_NAME.SPECT_VAR_NAME[listfind(spect_name_list,get_orders.SPECT_VAR_ID,',')]> 
			<cfelse>
				<cfset _spect_main_id = '' >
				<cfset _spect_name = ''>
			</cfif>
			<tbody>
			<cfif isdefined('toplam_#ORDER_ROW_ID#')>
				<cfset kalan_uretim_emri = QUANTITY-Evaluate('toplam_#ORDER_ROW_ID#')>
			<cfelse>
				<cfset kalan_uretim_emri = QUANTITY>
			</cfif>
			<tr>
				<td width="1%">#currentrow#</td>
				<!-- sil -->
					<td class="iconL" align="center" id="order_row#currentrow#" onClick="gizle_goster(order_stocks_detail#currentrow#);connectAjax('#currentrow#','#PRODUCT_ID#','#STOCK_ID#','#kalan_uretim_emri#','#ORDER_ID#','#_spect_main_id#');gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
						<a id="order_row#currentrow#"><i class="fa fa-caret-right" title="<cf_get_lang dictionary_id ='58596.Göster'>" /></i></a>
					</td>
				<!-- sil -->
				<td nowrap="nowrap">
				<cfif attributes.fuseaction eq 'prod.popuptracking'>
					<a onClick="send_to_production(#order_id#,#order_row_id#,'#unit#','#attributes.is_demand#','#currentrow#')">#order_number#</a>
				<cfelse>
					<a href="#request.self#?fuseaction=prod.tracking&event=det&unit_name=#unit#&order_id=#order_id#&order_row_id=#order_row_id#" target="_blank">#order_number#</a>
				</cfif>
				</td>
				<td>#get_emp_info(ORDER_EMPLOYEE_ID,0,0)#</td>
				<td>#dateformat(order_date,dateformat_style)#</td>
				<td>
					<cfif is_show_delivery_date eq 1 and len(row_deliver_date)>
						#dateformat(row_deliver_date,dateformat_style)#
					<cfelse>
						#dateformat(deliverdate,dateformat_style)#
					</cfif>
				</td>
				<cfif is_show_stock_code eq 1>
					<td>#STOCK_CODE#</td>
				</cfif>
				<td>
					<a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#stock_id#">#product_name# #property#</a>
				</td>
				<cfif isdefined("is_order_detail") and is_order_detail eq 1><td>#order_detail#</td></cfif>
				<cfif isdefined('is_show_spec') and is_show_spec eq 1 or not isdefined('is_show_spec')>
				 <td>
					<cfif len(SPECT_VAR_ID)>
						<cfif is_show_spec_no eq 1>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&stock_id=#stock_id#','list');">
								#_spect_main_id#-#spect_var_id#
							</a>
						<cfelse>
							#_spect_name#	
						</cfif>
					</cfif>
				</td>
				</cfif>
				<td>
				<cfif len(COMPANY_ID)>
					#get_company_name.FULLNAME[listfind(company_name_list,get_orders.COMPANY_ID,',')]#
				<cfelseif len(CONSUMER_ID)>
					#get_consumer_name.CONSUMER_NAME[listfind(consumer_name_list,get_orders.CONSUMER_ID,',')]#
				</cfif>
				</td>
				<td style="text-align:right;">#tlformat(quantity)#</td>
				<td>#unit#</td>
				<cfset attributes.stock_id=stock_id>
				<cfset attributes.order_id=order_id>
				<cfif isdefined('is_show_unit2') and is_show_unit2 eq 1 or not isdefined('is_show_unit2')>
				 <td>#AMOUNT2# #UNIT2#</td>
				</cfif>
				<td style="text-align:right;">
					<cfif isdefined('verilen_talep_#ORDER_ROW_ID#')>
						#Evaluate('verilen_talep_#ORDER_ROW_ID#')#
					<cfelse>
						0
					</cfif>
				</td>
				<td style="text-align:right;">
					<cfif isdefined('verilen_uretim_emri_#ORDER_ROW_ID#')>
						#Evaluate('verilen_uretim_emri_#ORDER_ROW_ID#')#
					<cfelse>
						0
					</cfif>
				</td>
				<td nowrap style="text-align:right;">
					<cfif isdefined('toplam_#ORDER_ROW_ID#')>
						<cfset kalan_uretim_emri = QUANTITY-Evaluate('toplam_#ORDER_ROW_ID#')>
					<cfelse>
						<cfset kalan_uretim_emri = QUANTITY>
					</cfif>
					#kalan_uretim_emri#
				</td>
				<!-- sil -->
				<td style="display:none;">
				<cfset _stock_id_ = STOCK_ID>
					<select name="station_id_#currentrow#" id="station_id_#currentrow#" style="width:120px;">
						<cfloop query="get_w">
							<cfif isdefined('stock_defined_stations_list_#_stock_id_#') and ListFind(Evaluate('stock_defined_stations_list_#_stock_id_#'),get_w.station_id,',')>
								<option value="#station_id#,0,0,0,-1,#EXIT_DEP_ID#,#EXIT_LOC_ID#,#PRODUCTION_DEP_ID#,#PRODUCTION_LOC_ID#">#station_name#</option>
							</cfif>
						</cfloop>
					</select>
				</td>
				<!-- sil -->
				<cfif attributes.fuseaction contains 'autoexcelpopuppage'>
					<cfif is_show_work_prog eq 1>
						<td>#works_prog#</td>
					</cfif>
				<cfelse>
					<cfif is_show_work_prog eq 1>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="work_prog_#currentrow#" id="work_prog_#currentrow#" readonly value="#works_prog#" style="width:120px;">
									<input type="hidden" name="work_prog_id_#currentrow#" id="work_prog_id_#currentrow#" value="#works_prog_id#">
									<span class="input-group-addon icon-ellipsis" onClick="goster(open_works_prog_#currentrow#);openBoxDraggable('#request.self#?fuseaction=prod.popup_list_work_prog&rows=#currentrow#&divId=open_works_prog_#currentrow#&fieldName=work_prog_#currentrow#&fieldId=work_prog_id_#currentrow#','open_works_prog_#currentrow#');"></span>
									<div style="position:absolute; margin-left:-150px; margin-top:10px; vertical-align:top;" id="open_works_prog_#currentrow#"></div>
								</div>
							</div>
						</td>
					<cfelse>
						<input type="hidden" name="work_prog_#currentrow#" id="work_prog_#currentrow#" readonly value="#works_prog#" style="width:120px;">
						<input type="hidden" name="work_prog_id_#currentrow#" id="work_prog_id_#currentrow#" value="#works_prog_id#">
					</cfif>
				</cfif>
				<cfif attributes.fuseaction contains 'autoexcelpopuppage'>
					<td><cfif kalan_uretim_emri lt 0>#tlformat(0)#<cfelse>#tlformat(kalan_uretim_emri)#</cfif></td>
					<td>
						#DateFormat(_now_,dateformat_style)#
					</td>
				<cfelse>
					<td><input type="text" name="production_amount_#currentrow#" id="production_amount_#currentrow#" style="width:65px;" value="<cfif kalan_uretim_emri lt 0>#tlformat(0)#<cfelse>#tlformat(kalan_uretim_emri)#</cfif>" class="moneybox" onKeyup="return(FormatCurrency(this,event,3));"></td>
					<!-- sil -->
					<td>
						<div class="form-group">
							<div class="col col-6">
								<div class="input-group">
									<input maxlength="10" type="text" name="production_start_date_#currentrow#" id="production_start_date_#currentrow#" validate="#validate_style#" style="width:65px;" value="#DateFormat(_now_,dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="production_start_date_#currentrow#"></span>
								</div>
							</div>
							<div class="col col-6">
							<div class="col col-6">
								<cf_wrkTimeFormat name="production_start_h_#currentrow#" id="production_start_h_#currentrow#" value="0">	
							</div>
							<div class="col col-6">
								<select name="production_start_m_#currentrow#" id="production_start_m_#currentrow#">
									<cfloop from="0" to="59" index="i">
										<option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
									</cfloop>
								</select>
							</div>
						</div>
						</div>
					</td>
					<!-- sil -->
				</cfif>
				<!-- sil -->
					<cfif attributes.fuseaction neq 'prod.popuptracking'>
						<td class="text-center"><a target="_blank" href="#request.self#?fuseaction=objects.popup_print_files&action_id=#order_id#&alt_module_name=sales&print_type=73"><i class="fa fa-print" title="<cf_get_lang dictionary_id ='36824.Sipariş Print'>" alt="<cf_get_lang dictionary_id ='36824.Sipariş Print'>"></i></a></td>
					</cfif>
					<td class="text-center"><input type="checkbox" name="is_active" id="is_active" value="#order_id#-#order_row_id#-#_spect_main_id#-#unit#-#stock_code#"/></td>
						
				<!-- sil -->
			</tr>
			<tr id="order_stocks_detail#currentrow#" style="display:none;" class="nohover">
				<td colspan="#colspan_info_new#">
					<div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
				</td>
			</tr>
		</tbody>
		</cfoutput>
		<!-- sil -->
	<cfelse>
		<tbody>
			<tr>
				<td colspan="<cfoutput>#colspan_info_new#</cfoutput>"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</tbody>
	</cfif>
<cfelse>
	<cfif GET_ORDERS.recordcount>
		<cfset order_id_list = ValueList(GET_ORDERS.ORDER_ID,',')>
		<cfset order_row_id_list = ValueList(GET_ORDERS.ORDER_ROW_ID,',')>
		<cfquery name="get_order_inv_periods" datasource="#dsn3#">
			SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID IN(#order_id_list#)
		</cfquery>

		<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
		<cfquery name="get_station_times" datasource="#dsn#">
			SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
		</cfquery>
		<cfset works_prog = get_station_times.SHIFT_NAME>
		<cfset works_prog_id = get_station_times.SHIFT_ID>
		<cfif get_order_inv_periods.recordcount>
			<cfset orders_ship_period_list = valuelist(get_order_inv_periods.PERIOD_ID)>
			<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
				<cfquery name="get_processed_amount" datasource="#dsn2#">
					SELECT
						SUM(IR.AMOUNT) AS SHIP_AMOUNT,
						IR.STOCK_ID,
						ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID=IR.INVOICE_ID
						AND IR.ORDER_ID IN(#order_id_list#)
					GROUP BY
						IR.STOCK_ID,
						IR.SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0)
				</cfquery>
			<cfelse>
				<cfquery name="get_period_dsns" datasource="#dsn#">
					SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
				</cfquery>
				<cfquery name="get_processed_amount" datasource="#dsn2#">
					SELECT
						SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
						A1.STOCK_ID,
						A1.SPECT_VAR_ID,
						A1.WRK_ROW_RELATION_ID
					FROM
					(
					<cfloop query="get_period_dsns">
						SELECT
							SUM(IR.AMOUNT) AS SHIP_AMOUNT,
							IR.STOCK_ID,
							ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
						FROM
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
						WHERE
							I.INVOICE_ID=IR.INVOICE_ID
							AND IR.ORDER_ID IN(#order_id_list#)
						GROUP BY
							IR.STOCK_ID,
							IR.SPECT_VAR_ID,
							ISNULL(IR.WRK_ROW_RELATION_ID,0)
						<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>
					</cfloop> ) AS A1
						GROUP BY
							A1.STOCK_ID,
							A1.SPECT_VAR_ID,
							A1.WRK_ROW_RELATION_ID
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="get_order_ship_periods" datasource="#dsn3#">
				SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN(#order_id_list#)
			</cfquery>
			<cfif get_order_ship_periods.recordcount>
				<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
				<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
					<cfquery name="get_processed_amount" datasource="#dsn2#">
						SELECT
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL(SR.SPECT_VAR_ID,0) AS SPECT_VAR_ID
						FROM
							SHIP S,
							SHIP_ROW SR
						WHERE
							S.SHIP_ID=SR.SHIP_ID
							AND SR.ROW_ORDER_ID IN(#order_id_list#)
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID
					</cfquery>
				<cfelse>
						<cfquery name="get_period_dsns" datasource="#dsn2#">
							SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
						</cfquery>
						<cfquery name="get_processed_amount" datasource="#dsn2#">
							SELECT
								SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
								A1.STOCK_ID,
								A1.SPECT_VAR_ID
							FROM
							(
							<cfloop query="get_period_dsns">
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.SPECT_VAR_ID,0) AS SPECT_VAR_ID
								FROM
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID IN(#order_id_list#)
								GROUP BY
									SR.STOCK_ID,
									SR.SPECT_VAR_ID
								<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>
							</cfloop> ) AS A1
								GROUP BY
									A1.STOCK_ID,
									A1.SPECT_VAR_ID
						</cfquery>
					</cfif>
			<cfelse>
				<cfset get_order_ship_periods.recordcount =0>
			</cfif>
		</cfif>
		<cfscript>
			if(isdefined("get_processed_amount"))
				for(xxx=1; xxx lte get_processed_amount.recordcount; xxx=xxx+1)
					'processed_amount_#get_processed_amount.STOCK_ID[xxx]#_#get_processed_amount.SPECT_VAR_ID[xxx]#' = get_processed_amount.SHIP_AMOUNT[xxx];
		</cfscript>
	</cfif>
	<cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfif isdefined("attributes.is_submitted")>
		<cfsavecontent variable="lang_message"><cf_get_lang dictionary_id='36916.Teslim Tarihini Hesapla'></cfsavecontent>
		<cfset scrap_location = ''>
		<cfquery name="get_scrap_locations" datasource="#dsn#">
			SELECT
				SL.LOCATION_ID,
				SL.DEPARTMENT_ID
			FROM 
				STOCKS_LOCATION SL,
				DEPARTMENT D
			WHERE
				SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
		</cfquery>
		<cfif get_scrap_locations.recordcount>
			<cfsavecontent variable="scrap_location">
				<cfoutput>
				<cfloop query="get_scrap_locations">
					AND NOT ( STORE_LOCATION = #LOCATION_ID# AND STORE = #DEPARTMENT_ID#)
				</cfloop>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		<cfscript>
			stock__list ='';specm__list ='';
			for(o_ind=attributes.startrow;o_ind lt attributes.startrow+attributes.maxrows and GET_ORDERS.recordcount gte o_ind;o_ind=o_ind+1){
					
					'add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#'=GET_ORDERS.QUANTITY[o_ind];
					row_dsp_amount_ = 0;
					if(isdefined('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') and len(evaluate('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#')) and evaluate('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') gt 0 ){
						if (evaluate('add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') gt 0 and evaluate('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') gte evaluate('add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#'))
							row_dsp_amount_=row_dsp_amount_+evaluate('add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#');
						else if (evaluate('add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') gt 0 and evaluate('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#') lt evaluate('add_product_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#'))
							row_dsp_amount_=row_dsp_amount_+evaluate('processed_amount_#GET_ORDERS.STOCK_ID[o_ind]#_#GET_ORDERS.SPECT_VAR_ID[o_ind]#');
					}
					SPECT_MAIN_ID_G = GET_ORDERS.SPECT_MAIN_ID[o_ind];
					STOCK_ID_G =GET_ORDERS.STOCK_ID[o_ind];
					if(not isdefined('order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#')){
						ORDER_NUMBER_G = GET_ORDERS.ORDER_NUMBER[o_ind];
						ORDER_ROW_ID_G = GET_ORDERS.ORDER_ROW_ID[o_ind];
						ORDER_ID_G = GET_ORDERS.ORDER_ID[o_ind];
						PRODUCT_NAME_G = '#GET_ORDERS.PRODUCT_NAME[o_ind]# #GET_ORDERS.PROPERTY[o_ind]#';
						QUANTITY_G = GET_ORDERS.QUANTITY[o_ind]-row_dsp_amount_;//sipariş miktarından sevk edilenler düşülüyor..
						STOCK_CODE_G = GET_ORDERS.STOCK_CODE[o_ind];
						stock__list = ListAppend(stock__list,STOCK_ID_G,',');
						specm__list = ListAppend(specm__list,SPECT_MAIN_ID_G,',');
					}	
					else{
						ORDER_NUMBER_G = '#GET_ORDERS.ORDER_NUMBER[o_ind]#,#ListGetAt(Evaluate('order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#'),1,'§')#';
						ORDER_ROW_ID_G = '#GET_ORDERS.ORDER_ROW_ID[o_ind]#,#ListGetAt(Evaluate('order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#'),2,'§')#';
						ORDER_ID_G = '#GET_ORDERS.ORDER_ID[o_ind]#,#ListGetAt(Evaluate('order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#'),3,'§')#';
						QUANTITY_G = '#GET_ORDERS.QUANTITY[o_ind]-row_dsp_amount_+ListGetAt(Evaluate('order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#'),5,'§')#';
					}
					//'order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#' = '#ORDER_NUMBER_G#§#ORDER_ROW_ID_G#§#ORDER_ID_G#§#PRODUCT_NAME_G#§#QUANTITY_G#§#STOCK_CODE_G#';
					'order_row_g_#STOCK_ID_G#_#SPECT_MAIN_ID_G#' = '#ORDER_NUMBER_G#§#ORDER_ROW_ID_G#§#ORDER_ID_G#§#GET_ORDERS.PRODUCT_NAME[o_ind]# #GET_ORDERS.PROPERTY[o_ind]#§#QUANTITY_G#§#GET_ORDERS.STOCK_CODE[o_ind]#§#GET_ORDERS.PRODUCT_ID[o_ind]#';
			}
			if(listlen(stock__list,',')){
				//stok stratejileri
					sqlStrStrategy = '
						SELECT
							DISTINCT
							STOCK_ID,
							ISNULL(MAXIMUM_STOCK,0) AS MAXIMUM_STOCK,
							ISNULL(PROVISION_TIME,0) AS PROVISION_TIME ,
							ISNULL(REPEAT_STOCK_VALUE,0) AS REPEAT_STOCK_VALUE,
							ISNULL(MINIMUM_STOCK,0) AS MINIMUM_STOCK,
							ISNULL(MINIMUM_ORDER_STOCK_VALUE,0) AS MINIMUM_ORDER_STOCK_VALUE
						FROM
							STOCK_STRATEGY
						WHERE
							STOCK_ID IN(#stock__list#) AND
							DEPARTMENT_ID IS NULL
						';
					getStockStrategy = cfquery(SQLString : sqlStrStrategy, Datasource : dsn3);
					for(strteg_ind=1;strteg_ind lte getStockStrategy.recordcount;strteg_ind=strteg_ind+1)
						'stock_strategy#getStockStrategy.STOCK_ID[strteg_ind]#'='#getStockStrategy.MINIMUM_STOCK[strteg_ind]#';//'#getStockStrategy.MAXIMUM_STOCK[strteg_ind]#,#getStockStrategy.PROVISION_TIME[strteg_ind]#,#getStockStrategy.REPEAT_STOCK_VALUE[strteg_ind]#,#getStockStrategy.MINIMUM_ORDER_STOCK_VALUE[strteg_ind]#';
					sqlStr = 'SELECT 
								SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
								STOCK_ID
							FROM 
								STOCKS_ROW SR 
							WHERE 
								STOCK_ID IN (#stock__list#) 
								#scrap_location#
							GROUP BY
								 STOCK_ID';
					getProductStock = cfquery(SQLString : sqlStr, Datasource : dsn2);
					for(r_ind=1;r_ind lte getProductStock.recordcount;r_ind=r_ind+1){
						//'product_stock_#getProductStock.STOCK_ID[r_ind]#_#getProductStock.SPECT_MAIN_ID[r_ind]#'= getProductStock.PRODUCT_STOCK[r_ind];
						'product_stock_#getProductStock.STOCK_ID[r_ind]#'= getProductStock.PRODUCT_STOCK[r_ind];
						}
				 //--ürünün gerçek stokları	
				 //Ürünün Beklenen Sipariş ve Üretimleri
				 //siparişler için query
				 SqlStrStockRezer='
								SELECT
									SUM(STOCK_ARTIR) AS ARTAN,
									STOCK_ID
								FROM
									GET_STOCK_RESERVED
								WHERE
									STOCK_ID IN (#stock__list#)
								GROUP BY STOCK_ID';
				 getStockRezer = cfquery(SQLString : SqlStrStockRezer, Datasource : dsn3);
				SqlStrStockRezer2='
								SELECT
									SUM(STOCK_AZALT) AS ARTAN,
									STOCK_ID
								FROM
									GET_STOCK_RESERVED
								WHERE
									STOCK_ID IN (#stock__list#)
								GROUP BY STOCK_ID';
				getStockRezer2 = cfquery(SQLString : SqlStrStockRezer2, Datasource : dsn3);
				for(rez_ind=1;rez_ind lte getStockRezer.recordcount;rez_ind=rez_ind+1)
				{
					'rezerved_orders#getStockRezer.STOCK_ID[rez_ind]#'= getStockRezer.ARTAN[rez_ind];
				}
				for(rez_ind=1;rez_ind lte getStockRezer2.recordcount;rez_ind=rez_ind+1)
				{
					'all_rezerved_orders#getStockRezer2.STOCK_ID[rez_ind]#'= getStockRezer2.ARTAN[rez_ind];
				}
				//Üretimler için Rezerve					
				SqlStrProdRezer	='			
								SELECT
									SUM(STOCK_ARTIR) AS ARTAN,
									STOCK_ID
								FROM
									GET_PRODUCTION_RESERVED
								WHERE
									STOCK_ID IN (#stock__list#)
								GROUP BY STOCK_ID';
				getProdRezer = cfquery(SQLString : SqlStrProdRezer, Datasource : dsn3);	
				for(pro_r_ind=1;pro_r_ind lte getStockRezer.recordcount;pro_r_ind=pro_r_ind+1)
					'rezerved_prod#getProdRezer.STOCK_ID[pro_r_ind]#'= getProdRezer.ARTAN[pro_r_ind];
				 //---Ürünün Beklenen Sipariş ve Üretimleri
				if(is_show_total_order eq 1)
					new_td = '<th class="form-title" width="80" style="text-align:right;" title="Toplam Sipariş Miktarı">Toplam Sipariş Miktarı</th>';
				else
					new_td = '';
			}
			else
				new_td = '';
			if(isdefined('is_show_spec') and is_show_spec eq 1 or not isdefined('is_show_spec'))
				spect_td_ = '<th width="50" class="form-title">Main Spec</th>';
			else
				spect_td_ = '';
			parametreler = "'allSelectOrder','multi_is_active'";
			writeoutput('
			<thead>
				<tr>
					<!-- sil --><th width="20"></th><!-- sil -->
					<th>#getLang('','Sipariş',57611)#</th>
					<th>#getLang('','Stok Kodu',57518)#</th>
					<th>#getLang('','Ürün Adı',58221)#</th>
					#spect_td_#
					<th width="20" class="text-center" title="#getLang('','Gruplanmış Sipariş Sayısı',495)#" class="form-title">#getLang('','Sipariş Miktarı',38564)#</th>
					<th class="text-right" title="#getLang('','Sipariş Miktarı',38564)#-#getLang('','Sevk Edilen Miktar',33101)#">#getLang('','Sipariş Toplamı',496)#</th>
					#new_td#
					<th class="text-right">#getLang('','Gerçek Stok',58120)#</th>
					<th class="text-right" title="#getLang('','Acil İhtiyaç',497)# : #getLang('','Sipariş Toplamı',496)# - #getLang('','Gerçek Stok',58120)#">#getLang('','Acil İhtiyaç',497)#</th>
					<th class="text-right" title="#getLang('','Stok Stratejisinde Tanımlanan Min Seviye',498)#">#getLang('','Min Seviye',499)#</th>
	
	
					<th class="text-right" title="#getLang('','Acil İhtiyaç',497)#+#getLang('','Min Seviye',499)#">#getLang('','İhtiyaç Miktarı',500)#</th>
					<th class="text-right" title="#getLang('','Beklenen Üretim',60171)#">#getLang('','Üretim',57456)#</th>
					<th class="text-right" title="#getLang('','Beklenen Satınalma Siparişleri',502)#">#getLang('','Sipariş',57611)#</th>
					<!--- <th class="text-right" title="#getLang('','Diğer Satış Siparişleri',62751)#">#getLang('','Satış Siparişi',57232)#</th> --->
					<th class="text-right" title="#getLang('','Optimum İhtiyaç',503)#=#getLang('','İhtiyaç Miktarı',500)#-#getLang('','Üretim',57456)#-#getLang('','Sipariş',57611)#">#getLang('','Optimum Üretim Miktarı',62752)#</th>
					<!-- sil -->
						<th width="20" class="text-center"></th>
						<th width="20" class="text-center"></th>
						<th width="20" class="text-center">
							<cfif not(isdefined("attributes.is_excel") and attributes.is_excel eq 1) and(isdefined("attributes.is_submitted") eq 1)>
								<input type="checkbox" name="allSelectOrder" id="allSelectOrder" onclick="wrk_select_all(#parametreler#);">
							</cfif>
						</th>
					<!-- sil -->
				</tr>
			</thead>	
			');
			if(listlen(stock__list,',')){
				for(ss_ind=1;ss_ind lte listlen(stock__list,',');ss_ind=ss_ind+1){
					_stock_id_ = ListGetAt(stock__list,ss_ind,',');
					_spec_main_id_ = ListGetAt(specm__list,ss_ind,',');
					all_values = Evaluate("order_row_g_#_stock_id_#_#_spec_main_id_#");
					siparis_toplami = ListGetAt(all_values,5,'§');//
					order_row_ids_ =ListGetAt(all_values,2,'§');
					order_ids_ = ListGetAt(all_values,3,'§');
					stock_code = ListGetAt(all_values,6,'§');
					product_name = ListGetAt(all_values,4,'§');
					product_id = ListGetAt(all_values,7,'§');
					if(not isdefined('rezerved_prod#_stock_id_#'))
						'rezerved_prod#_stock_id_#' =0;
					if(not isdefined('rezerved_orders#_stock_id_#'))
						'rezerved_orders#_stock_id_#'=0;
					if(not isdefined('all_rezerved_orders#_stock_id_#'))
						'all_rezerved_orders#_stock_id_#'=0;
					if(isdefined('stock_strategy#_stock_id_#'))	min_seviye= Evaluate('stock_strategy#_stock_id_#');	else min_seviye= 0;	
					if(not isdefined('product_stock_#_stock_id_#'))
						gercek_stok = 0; else gercek_stok = Evaluate('product_stock_#_stock_id_#');
						
					if(isdefined("is_calc_total_order") and is_calc_total_order eq 1)
						ihtiyac_miktari = evaluate("all_rezerved_orders#_stock_id_#")-gercek_stok+min_seviye;//Üretilecek miktar = ÜrünMiktarı-GerçekStok+MinStok		
					else
						ihtiyac_miktari = siparis_toplami-gercek_stok+min_seviye;//Üretilecek miktar = ÜrünMiktarı-GerçekStok+MinStok
					
						
					if(ihtiyac_miktari lte 0) 
					{
						if(isdefined("is_calc_total_order") and is_calc_total_order eq 1)
							ihtiyac_miktari = evaluate("all_rezerved_orders#_stock_id_#");
						else
							ihtiyac_miktari = siparis_toplami;
					}
					satir_siparisler = ListGetAt(all_values,1,'§');
					if(_spec_main_id_ lte 0){//siparişte ürün için spec seçilmemiş ise bu listede ürünün ağacındaki mevcut varyasyonundaki spec'i ile gösteriliyor.
						_xxxxxx_ = get_main_spect_id(_stock_id_);
						if(len(_xxxxxx_.SPECT_MAIN_ID)){
							s_link = "&upd_main_spect=1&spect_main_id=#_xxxxxx_.SPECT_MAIN_ID#";
							_spec_main_id_ = _xxxxxx_.SPECT_MAIN_ID;
						}
						else
						s_link = "";
					}
					else
						s_link = '&upd_main_spect=1&spect_main_id=#_spec_main_id_#';
					if(isdefined("is_calc_total_order") and is_calc_total_order eq 1)
						acil_ihtiyac = evaluate("all_rezerved_orders#_stock_id_#")-gercek_stok;//Siparişteki toplam Miktar - Ürünün gerçek stoğu,eğer siparişteki miktarlar ürünün gerçek stoğundan küçük ise,acil ihtiyaç - değer olmasın diye 0 atıyoruz.
					else
						acil_ihtiyac = siparis_toplami-gercek_stok;//Siparişteki toplam Miktar - Ürünün gerçek stoğu,eğer siparişteki miktarlar ürünün gerçek stoğundan küçük ise,acil ihtiyaç - değer olmasın diye 0 atıyoruz.
					acil_ihtiyac_txt_color = 'red';
					if(acil_ihtiyac lte 0)
					{
							acil_ihtiyac = 0; acil_ihtiyac_txt_color ='';
							if(isdefined("is_calc_total_order") and is_calc_total_order eq 1)
								ihtiyac_miktari = min_seviye + evaluate("all_rezerved_orders#_stock_id_#") - gercek_stok;
							else
								ihtiyac_miktari = min_seviye + siparis_toplami - gercek_stok;
					}
					
					//Üretim için gerekli miktarı gerekli miktardan ürünün verilmiş olan üretim emirlerini ve satınalma siparişlerindkei rezerve miktarlarının çıkartarak
					//burda yeniden set ediyoruz.Bunu yapmamızın sebebi stoğun şişmesini engellemek...İhtiyaç:200 Ür:50 Sip:150 olsun..200 üretitsem siparişten ve önceki üretimden toplam 350 tane daha stoğuma girer bu durumda fazladan stoğum olmuş olur..İşte bunu engelliyoruz..
					optimum_ihtiyac = ihtiyac_miktari-Evaluate("rezerved_prod#_stock_id_#")-Evaluate("rezerved_orders#_stock_id_#");	
					if(optimum_ihtiyac lte 0)	//eğerki ihtiyaç miktarı 0 ise optimum ihtiyaçda 0 olmalıdır...
						optimum_ihtiyac =0;
					if(is_show_total_order eq 1)
						new_td = '<td style="text-align:right;">#tlformat(evaluate("all_rezerved_orders#_stock_id_#"))#</td>';
					else
						new_td = '';
					if(is_add_order eq 1 or is_add_demand eq 1)
					{
						order_td = '<td nowrap>';
						if(is_add_order eq 1)
						{
							order_td = '#order_td# <a onclick="send_to_production_group(#ss_ind#);"><i class="icon-forward" title="Üretime Gönder"></i></a>';
						}
						if(is_add_demand eq 1)
						{
							order_td = '#order_td# <a onclick="send_to_production_group(#ss_ind#,1);"><i class="fa fa-share-square-o" title="Talep Oluştur"></i></a>';
						}
						order_td = '#order_td#</td>';
					}
					else
						order_td = '';
					if(isdefined('is_show_spec') and is_show_spec eq 1 or not isdefined('is_show_spec'))
						spect_td = '<td style="text-align:right;"><a onClick=windowopen("#request.self#?fuseaction=objects.popup_upd_spect#s_link#","list"); style="cursor:pointer;">#_spec_main_id_#</a></td>';
					else
						spect_td = '';
					funcParameters = "#order_ids_#-#order_row_ids_#-' '-1-#ss_ind#-1";
					SqlWorkstation_Products='
								SELECT TOP 1
									W.STATION_ID,
									W.STATION_NAME,
									ISNULL(W.EXIT_DEP_ID,0) AS EXIT_DEP_ID,
									ISNULL(W.EXIT_LOC_ID,0) AS EXIT_LOC_ID,
									ISNULL(W.PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
									ISNULL(W.PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
								FROM 
									WORKSTATIONS W,
									WORKSTATIONS_PRODUCTS WP
								WHERE
									W.STATION_ID = WP.WS_ID 
									AND WP.STOCK_ID IN (#_stock_id_#)
									AND WP.OPERATION_TYPE_ID IS NULL';
				 	getWorkStationProducts = cfquery(SQLString : SqlWorkstation_Products, Datasource : dsn3);
					writeoutput('<tbody>
									<tr height="20" onMouseOver=this.className="color-light"; onMouseOut=this.className="color-row"; class="color-row">
									<!-- sil -->
									<td align="center" id="order_row#ss_ind#" class="color-row" onClick="gizle_goster(order_stocks_detail#ss_ind#);connectAjax(#ss_ind#,0,#_stock_id_#,#optimum_ihtiyac#,0,#_spec_main_id_#,#optimum_ihtiyac#);gizle_goster(siparis_goster#ss_ind#);gizle_goster(siparis_gizle#ss_ind#);">
										<input type="hidden" name="order_ids_#ss_ind#" id="order_ids_#ss_ind#" value="#order_ids_#">
										<input type="hidden" name="order_row_ids_#ss_ind#" id="order_row_ids_#ss_ind#" value="#order_row_ids_#">
										<img id="siparis_goster#ss_ind#" src="/images/listele.gif" border="0" alt="Göster" style="cursor:pointer;">
										<img id="siparis_gizle#ss_ind#" src="/images/listele_down.gif" border="0" alt="Gizle" style="cursor:pointer;display:none">
									</td>
									<!-- sil -->
									<td>
										<a style="cursor:pointer;" onClick="show_order_detail(#ss_ind#);">#left(satir_siparisler,7)#....</a>
										<!-- sil -->
										<div style="width:200px;position:absolute;" id="order_det_info#ss_ind#" class="nohover_div"></div>
										<!-- sil -->
									</td>
									<td width="150"><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#">#stock_code#</a></td>
									<td width="350"><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#_stock_id_#">#product_name#</a></td>
									#spect_td#
									<td style="text-align:right;">#listlen(satir_siparisler,',')#</td>
									<td style="text-align:right;">#tlformat(siparis_toplami)#</td>
									#new_td#
									<td style="text-align:right;">#tlformat(gercek_stok)#</td>
									<td style="text-align:right;"><font color="#acil_ihtiyac_txt_color#">#tlformat(acil_ihtiyac)#</font></td>
									<td style="text-align:right;">#tlformat(min_seviye)#</td>
									<td style="text-align:right;">#tlformat(ihtiyac_miktari)#<input type="hidden" value="#optimum_ihtiyac#" name="production_amount#ss_ind#" id="production_amount#ss_ind#"></td>
									<td style="text-align:right;">
										<div>
											<div style="position:absolute;z-index:2;margin-left:-300px;width:300px; vertical-align:top;" id="deliver_date_info#ss_ind#"></div>
											<div style="margin-left:-400px;height:200px;position:absolute;overflow:auto;height:200px;" id="show_rezerved_orders_detail#ss_ind#"></div>
											<div style="margin-left:-700px;height:200px; position:absolute; overflow:auto;height:200px;" id="show_rezerved_prod_detail#ss_ind#"></div>
										</div>
										<a style="cursor:pointer;" onClick="show_rezerved_prod_detail(#ss_ind#,#_stock_id_#);">#tlformat(Evaluate("rezerved_prod#_stock_id_#"))#</a>
									</td>
									<td style="text-align:right;"><a style="cursor:pointer;" onClick="show_rezerved_orders_detail(#ss_ind#,#_stock_id_#,0);">#tlformat(Evaluate("rezerved_orders#_stock_id_#"))#</a></td>
									<td style="text-align:right;">#tlformat(optimum_ihtiyac)#
									<input type="hidden" name="production_amount_#ss_ind#" id="production_amount_#ss_ind#" value="#tlformat(optimum_ihtiyac)#">
									</td>
									<!-- sil -->
									<td>
										<a onClick="calc_deliver_date(#ss_ind#,#_stock_id_#,#optimum_ihtiyac#,#_spec_main_id_#);" alt="#lang_message#"><i class="fa fa-calendar-o" title="#lang_message#"></i></a>
									</td>
									#order_td#
									<td width="1%" align="center">
										<input type="hidden" name="multi_station_id_#ss_ind#" id="multi_station_id_#ss_ind#" value="#getWorkStationProducts.station_id#,0,0,0,-1,#getWorkStationProducts.EXIT_DEP_ID#,#getWorkStationProducts.EXIT_LOC_ID#,#getWorkStationProducts.PRODUCTION_DEP_ID#,#getWorkStationProducts.PRODUCTION_LOC_ID#">
										<input type="hidden" name="multi_order_ids_#ss_ind#" id="multi_order_ids_#ss_ind#" value="#order_ids_#">
										<input type="hidden" name="multi_work_prog_id_#ss_ind#" id="multi_work_prog_id_#ss_ind#" value="#works_prog_id#">
										<input type="hidden" name="multi_order_row_ids_#ss_ind#" id="multi_order_row_ids_#ss_ind#" value="#order_row_ids_#">
										<input type="hidden" name="multi_production_amount_#ss_ind#" id="multi_production_amount_#ss_ind#" value="#tlformat(optimum_ihtiyac)#">
										<input type="hidden" name="multi_production_start_date_#ss_ind#" id="multi_production_start_date_#ss_ind#" value="#DateFormat(_now_,"dd/mm/yyyy")#">
										<input type="hidden" name="multi_production_start_h_#ss_ind#" id="multi_production_start_h_#ss_ind#" value="0">
										<input type="hidden" name="multi_production_start_m_#ss_ind#" id="multi_production_start_m_#ss_ind#" value="0">
										<input type="checkbox" name="multi_is_active" id="multi_is_active" value="#funcParameters#"/>
									</td>
									<!-- sil -->
									<div id="multi_user_message_" style="display:none;"></div>
								</tr>
								<!-- sil -->
								<tr id="order_stocks_detail#ss_ind#" style="display:none" class="nohover">
									<td colspan="19">
										<div align="left" id="DISPLAY_ORDER_STOCK_INFO#ss_ind#">
										</div>
									</td>
								</tr>
								<!-- sil -->
								</tbody>
								');
				}
				writeoutput('
					<cfif is_add_order eq 1>
					<tfoot>
						<form name="multi_add_production_demand" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_production_order_all_sub">
							<tr>
								<td colspan="14" style="text-align:right;">
									<cf_workcube_process_info fuseaction="prod.order"><!--- Surec Gonderiliyor --->
									<input name="is_multi" id="is_multi" type="hidden" value="1">
									<input name="multi_process_stage" id="multi_process_stage" type="hidden" value="0">
									<input name="multi_demand_no" id="multi_demand_no" type="hidden" value="">
									<input name="multi_is_time_calculation" id="multi_is_time_calculation" type="hidden" value="#is_time_calculation#">
									<input name="multi_is_time_calculation" id="multi_is_time_calculation" type="hidden" value="#is_time_calculation#">
									<input name="multi_is_cue_theory" id="multi_is_cue_theory" type="hidden" value="#is_cue_theory#">
									<input name="multi_is_add_multi_demand" id="multi_is_add_multi_demand" type="hidden" value="#is_add_multi_demand#">
									<input name="multi_station_id_list" id="multi_station_id_list" type="hidden" value="">
									<input name="multi_works_prog_id_list" id="multi_works_prog_id_list" type="hidden" value="">
									<input name="multi_production_amount_list" id="multi_production_amount_list" type="hidden" value="">
									<input name="multi_order_row_id" id="multi_order_row_id" type="hidden" value="">
									<input name="multi_order_id" id="multi_order_id" type="hidden" value="">
									<input name="multi_is_select_sub_product" id="multi_is_select_sub_product" type="hidden" value="#is_select_sub_product#">
									<input name="multi_production_start_date_list" id="multi_production_start_date_list" type="hidden" value="">
									<input name="multi_production_start_h_list" id="multi_production_start_h_list" type="hidden" value="">
									<input name="multi_production_start_m_list" id="multi_production_start_m_list" type="hidden" value="">
									<input name="multi_is_demand" id="multi_is_demand" type="hidden" value="0">
								</td>
								<td colspan="4" class="text-center"><input type="button" name="multi_send_to_production_" id="multi_send_to_production_" class="ui-wrk-btn ui-wrk-btn-success" value="#getLang("prod",512)#" onClick="multi_send_to_production();"></td>
							</tr>
						</form>
					</tfoot>
					</cfif>');
			}
			else
			writeoutput('<tbody><tr class="color-row"><td colspan="19">Kayıt Bulunamadı!</td></tr></tbody>');
		</cfscript>
	</cfif>
</cfif>
<script type="text/javascript">
	function calc_deliver_date(row_id,stock_id,amount,spec_main_id){
		document.getElementById('deliver_date_info'+row_id+'').style.display='';
		stock_id_list=''+stock_id+'-'+spec_main_id+'-'+amount+'-1';
		openBoxDraggable(<cfoutput>'#request.self#?fuseaction=prod.popup_ajax_deliver_date_calc&from_p_order_list=1&row_id='+row_id+'&stock_id_list='+stock_id_list+''</cfoutput>,'deliver_date_info'+row_id+'',1,"<cf_get_lang dictionary_id ='36915.Teslim Tarihi Hesaplanıyor'>");
	}
	function show_order_detail(row_id){
		order_ids =document.getElementById('order_ids_'+row_id).value;
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ajax_list_order_comp_det&order_ids='+order_ids+'&row_id='+row_id+'&order_row_id='+document.getElementById('order_row_ids_'+row_id).value+'','order_det_info'+row_id);
	}
	function show_rezerved_orders_detail(row_id,stock_id,type){
		document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&taken='+type+'&sid='+stock_id+'&row_id='+row_id+'&order_row_id='+document.getElementById('order_row_ids_'+row_id).value+'','show_rezerved_orders_detail'+row_id+'',1);
	}
	function show_rezerved_prod_detail(row_id,stock_id){
		document.getElementById('show_rezerved_prod_detail'+row_id+'').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_production_orders&type=1&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_prod_detail'+row_id+'',1);
	}
	function send_to_production_group(row_id,_type)
	{
		if(_type != undefined && _type == 1)
			demand_ = '&is_demand=1';
		else
			demand_ = '';
		window.location="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order&event=add&production_amount="+document.getElementById('production_amount'+row_id).value+"&order_row_id="+document.getElementById('order_row_ids_'+row_id).value+"&order_id="+document.getElementById('order_ids_'+row_id).value+""+demand_;
	}

	function multi_send_to_production()
	{
		//Aslinda Direkt Alttaki Kullanilabilir Ancak Daha Sonra Topluda Farkli Bir Parametre Lazim Olabilir
		send_to_production(0,0,' ',-1,0,1);
	}

	function send_to_production(order_id,order_row_id,unit_name,_type,row,isMulti)
	{
		if(_type != undefined)// && _type == 1
		{
			if(_type == 1)
				demand_ = '&is_demand=1';
			else
				demand_ = '';
		}
		else
			demand_ = '';
		if(isMulti != undefined)
			multiParam_ = "multi_";
		else
			multiParam_ = "";

		if(order_id >0 && order_row_id > 0)
		{	//sadece 1 siparişe tıklanıyorsa 
			if(document.getElementById(multiParam_+'production_amount_'+row).value == "" || filterNum(document.getElementById(multiParam_+'production_amount_'+row).value) == 0)
			{
				alert("<cf_get_lang dictionary_id ='36442.Girilen Miktar 0 Olamaz'>...");
				document.getElementById(multiParam_+'production_amount_'+row).focus();
				return false;
			}
			row_amount = document.getElementById(multiParam_+'production_amount_'+row).value;
			window.opener.location="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order&event=add&production_amount="+row_amount+"&unit_name="+unit_name+"&order_row_id="+order_row_id+"&order_id="+order_id+""+demand_;
			window.close();
			return false;
		}
		else if(document.getElementsByName(multiParam_+'is_active').length > 0)
		{
			var order_row_id_list="";
			var order_id_list="";
			var station_id_list = "";
			var production_start_date_list = "";
			var production_start_h_list = "";
			var production_start_m_list = "";
			var works_prog_id_list = "";
			var spect_main_id_list ="";
			var production_amount_list = "";
			var unit_name = "";
			production_amount_ = 0;
			if(document.getElementsByName(multiParam_+'is_active').length == 1)
			{
				is_active_val = document.getElementById(multiParam_+'is_active').value;
				order_id_list+=list_getat(is_active_val,1,'-')+',';
				order_row_id_list+=list_getat(is_active_val,2,'-')+',';
				spect_main_id_list+=list_getat(is_active_val,3,'-')+',';
				if(document.getElementById(multiParam_+'station_id_1').value != "")
					station_id_list += document.getElementById(multiParam_+'station_id_1').value+'@';
				else
					station_id_list +='0,0,0,0,0,0,0,0,0@';
				production_start_date_list += document.getElementById(multiParam_+'production_start_date_1').value+',';
				production_start_h_list += document.getElementById(multiParam_+'production_start_h_1').value+',';
				production_start_m_list += document.getElementById(multiParam_+'production_start_m_1').value+',';
				works_prog_id_list+= document.getElementById(multiParam_+'work_prog_id_1').value+',';
				if(filterNum(document.getElementById(multiParam_+'production_amount_1').value) == 0 || document.getElementById(multiParam_+'production_amount_1').value == "")
				{
					alert("<cf_get_lang dictionary_id ='36442.Girilen Miktar 0 Olamaz'>..");
					document.getElementById(multiParam_+'production_amount_1').focus();return false;
				}
				else
					production_amount_list+=filterNum(document.getElementById(multiParam_+'production_amount_1').value,3)+',';
				production_amount_=parseFloat(production_amount_)+parseFloat(filterNum(document.getElementById(multiParam_+'production_amount_1').value,3));
				var unit_name = list_getat(is_active_val,4,'-');
			}
			 else
			{
				unit_name+=list_getat(document.getElementsByName(multiParam_+'is_active')[0].value,4,'-')+',';
				<cfoutput>
					for (i=0;i< document.getElementsByName(multiParam_+'is_active').length;i++)
					{
						is_active_val = document.getElementsByName(multiParam_+'is_active')[i].value;
						if(list_getat(is_active_val,3,'-') == "")
							var _spec_main_id = -1;
						else
							var _spec_main_id = list_getat(is_active_val,3,'-');
							
						if(document.getElementsByName(multiParam_+'is_active')[i].checked==true)
						{
							order_id_list+=list_getat(document.getElementsByName(multiParam_+'is_active')[i].value,1,'-')+',';//1.ci alan order id'yi tutuyor
							order_row_id_list+=list_getat(document.getElementsByName(multiParam_+'is_active')[i].value,2,'-')+',';//2.ci alan order_row id'yi tutuyor
							new_row_number = parseInt(#attributes.startrow#+i);
							if(document.getElementById(multiParam_+'station_id_'+new_row_number).value != "")
								station_id_list+=document.getElementById(multiParam_+'station_id_'+new_row_number).value+'@';
							else
								station_id_list +='0,0,0,0,0,0,0,0,0@';
							if(document.getElementById(multiParam_+'production_start_date_'+new_row_number) != undefined)
							{
								production_start_date_list+=document.getElementById(multiParam_+'production_start_date_'+new_row_number).value+',';
								production_start_h_list +=document.getElementById(multiParam_+'production_start_h_'+new_row_number).value+',';
								production_start_m_list +=document.getElementById(multiParam_+'production_start_m_'+new_row_number).value+',';
								works_prog_id_list+=document.getElementById(multiParam_+'work_prog_id_'+new_row_number).value+',';
							}
							else
							{
								production_start_date_list+=''+',';
								production_start_h_list +=''+',';
								production_start_m_list +=''+',';
								works_prog_id_list+=''+',';
							}
							if(document.getElementById(multiParam_+'production_amount_'+new_row_number).value == "" || filterNum(document.getElementById(multiParam_+'production_amount_'+new_row_number).value) == 0)
							{
								alert("<cf_get_lang dictionary_id ='36442.Girilen Miktar 0 Olamaz'>...");
								document.getElementById(multiParam_+'production_amount_'+new_row_number).focus();
								return false;
							}
							else
								production_amount_list+=filterNum(document.getElementById(multiParam_+'production_amount_'+new_row_number).value,3)+',';
							
							production_amount_=parseFloat(production_amount_)+parseFloat(filterNum(document.getElementById(multiParam_+'production_amount_'+new_row_number).value,3));
							if(!list_find(spect_main_id_list,_spec_main_id,','))
								spect_main_id_list+=_spec_main_id+',';
						}
					}
				</cfoutput>
			}
			if(list_len(order_row_id_list,',') > 1)
			{	//sipariş seçilmiş ise
				order_id_list = order_id_list.substr(0,order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
				order_row_id_list = order_row_id_list.substr(0,order_row_id_list.length-1);
				station_id_list = station_id_list.substr(0,station_id_list.length-1);
				production_start_date_list = production_start_date_list.substr(0,production_start_date_list.length-1);
				production_start_h_list = production_start_h_list.substr(0,production_start_h_list.length-1);
				production_start_m_list = production_start_m_list.substr(0,production_start_m_list.length-1);
				works_prog_id_list = works_prog_id_list.substr(0,works_prog_id_list.length-1);
				production_amount_list= production_amount_list.substr(0,production_amount_list.length-1);
				spect_main_id_list = spect_main_id_list.substr(0,spect_main_id_list.length-1);
				unit_name = unit_name.substr(0,unit_name.length-1);
				<cfif attributes.fuseaction neq 'prod.popuptracking'>
						process_stage = document.getElementById(multiParam_+'process_stage').value;
						demand_no = document.getElementById(multiParam_+'demand_no').value;
						if(demand_no =="" && _type != undefined && _type == 1)
						{
							alert("<cf_get_lang dictionary_id ='36438.Talep Numarası'>");
							document.getElementById(multiParam_+'demand_no').focus();
							return false;
						}
						if(process_stage =="")
						{
							alert("<cf_get_lang dictionary_id ='58859.Süreç'>");
							document.getElementById(multiParam_+'process_stage').focus();
							return false;
						}
						is_ok = 1;
						if(_type != undefined && _type == 1){
							var get_demend_control = wrk_safe_query('prdp_get_demend_control','dsn3',0,demand_no);
							if(get_demend_control.recordcount){
								if(confirm("<cf_get_lang dictionary_id='60528.Bu Talep Numarası Daha Önceden Kullanılmış,Devam Ederseniz Seçtiğiniz Siparişler Bu Talep Numarasına Eklenecektir.Devam Etmek İstiyormusunuz?'>"))
									is_ok = 1;
								else
									is_ok = 0;
							}
						}
						if(is_ok == 1)
						{
							document.getElementById(multiParam_+'is_demand').value = _type;
							document.getElementById(multiParam_+'station_id_list').value = station_id_list;
							document.getElementById(multiParam_+'works_prog_id_list').value = works_prog_id_list;
							document.getElementById(multiParam_+'production_amount_list').value = production_amount_list;
							document.getElementById(multiParam_+'order_row_id').value = order_row_id_list;
							document.getElementById(multiParam_+'order_id').value = order_id_list;
							document.getElementById(multiParam_+'production_start_m_list').value = production_start_m_list;
							document.getElementById(multiParam_+'production_start_h_list').value = production_start_h_list;
							document.getElementById(multiParam_+'production_start_date_list').value = production_start_date_list;
							if(document.getElementById(multiParam_+'demand_create_') != undefined)
								document.getElementById(multiParam_+'demand_create_').disabled=true;
							if(document.getElementById(multiParam_+'send_to_production_') != undefined)
								document.getElementById(multiParam_+'send_to_production_').disabled=true;
							if(_type==1)
								document.getElementById(multiParam_+'user_message_').innerHTML = '<cf_get_lang dictionary_id='510.Talepler Oluşturuluyor'>..<cf_get_lang dictionary_id='509.Sayfayı Yenilemeyiniz..Lütfen Bekleyiniz...'>';
							else if(_type==0)
								document.getElementById(multiParam_+'user_message_').innerHTML = '<cf_get_lang dictionary_id='511.Üretime Gönderiliyor'>...<cf_get_lang dictionary_id='509.Sayfayı Yenilemeyiniz..Lütfen Bekleyiniz...'>';
							document.getElementById(multiParam_+'user_message_').style.display='';
							if(multiParam_ != "")
								document.multi_add_production_demand.submit();
							else
								document.add_production_demand.submit();
						}
				<cfelse>
					var get_order_control = wrk_safe_query('prdp_get_order_control','dsn3',0,order_row_id_list);
					if(get_order_control.recordcount == 1)
					{
						<cfif isdefined("attributes.draggable")>window.document<cfelse>window.opener</cfif>.location="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.order&event=add&production_amount="+production_amount_+"&unit_name="+unit_name+"&order_row_id="+order_row_id_list+"&order_id="+order_id_list+""+demand_;
						window.close();
					}
					else
					{
						alert("<cf_get_lang dictionary_id ='36443.Farklı Ürün veya Spec İçin Seçim Yapamazsınız'> !");
						return false;
					}
				</cfif>
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='36827.Üretime Göndermek İçin Sipariş Seçiniz'>");
				return false;
			}
		}
	}
	
	function demand_convert_to_production(type)
	{
		
		if(type==4)// type 4 ise
		{
			
			document.getElementById("production_material_all").value='<cfoutput>#getLang("main",293)#</cfoutput>';
			document.getElementById("production_material_all").disabled = true;
			window.go_stock_list.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_materials_total";
			document.go_stock_list.submit();
		}
		else if(type==3)
		{
			if(document.getElementById('is_active').value.length > 0)
			{
				var row_stock_all_list ="";
				var row_spect_all_list = "";
				var row_amount_all_list = "";
				if(document.getElementById('is_active').value.length ==1)
				{
					var actv_val = document.getElementById('is_active').value;
					actv_val = actv_val.split("-");
					actv_val = actv_val[2];
					if( actv_val == "")
						{
							var _spec_main_id = 0;
						}
					else
						var _spec_main_id = list_getat(document.getElementsByName('is_active').value,3,'-');
					row_spect_all_list+=_spec_main_id+',';
					row_stock_all_list+=list_getat(document.getElementsByName('is_active').value,5,'-')+',';
					if(filterNum(document.getElementById('production_amount_1').value) == 0 || document.getElementById('production_amount_1').value == "")
					{
						alert("<cf_get_lang dictionary_id ='36442.Girilen Miktar 0 Olamaz'>..");
						document.getElementById('production_amount_1').focus();
						return false;
					}
					else
						row_amount_all_list+=filterNum(document.getElementById('production_amount_1').value,3)+',';
				}
				else
				{
					<cfoutput>
						for (i=0;i<document.getElementsByName('is_active').length;i++)
						{
							if( list_getat(document.getElementsByName('is_active')[i].value,3,'-') == "")
								var _spec_main_id = 0;
							else
								var _spec_main_id = list_getat(document.getElementsByName('is_active')[i].value,3,'-');
							
							if(document.getElementsByName('is_active')[i].checked==true)
							{
								new_row_number = parseInt(#attributes.startrow#+i);
								if(document.getElementById('production_amount_'+new_row_number).value == "" || filterNum(document.getElementById('production_amount_'+new_row_number).value) == 0)
								{
									alert("<cf_get_lang dictionary_id ='36442.Girilen Miktar 0 Olamaz'>...");
									document.getElementById('production_amount_'+new_row_number).focus();
									return false;
								}
								else
									row_amount_all_list+=filterNum(document.getElementById('production_amount_'+new_row_number).value,3)+',';
								
								row_spect_all_list+=_spec_main_id+',';
								row_stock_all_list+=list_getat(document.getElementsByName('is_active')[i].value,5,'-')+',';
							}
						}
					</cfoutput>
				}
				
				if(list_len(row_stock_all_list,',') > 1)
				{
					document.getElementById("production_material").value='<cfoutput><cf_get_lang dictionary_id="57705.İşleniyor"></cfoutput>';
					document.getElementById("production_material").disabled = true;
					document.getElementById('row_stock_all_').value = row_stock_all_list;
					document.getElementById('row_spect_all_').value = row_spect_all_list;
					document.getElementById('row_amount_all_').value = row_amount_all_list;
					window.go_stock_list2.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_materials_total";
					document.go_stock_list2.submit();
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='57725.Ürün Seçiniz '>");
				return false;
			}	
		}
	}
	function product_control(){/*Ürün seçmeden spec seçemesin.*/
		if(document.getElementById('stock_id_').value=="" || document.getElementById('product_name').value == "" ){
			alert("<cf_get_lang dictionary_id ='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search.spect_main_id&field_name=search.spect_name&is_display=1&stock_id='+document.getElementById('stock_id_').value,'list');
	}
</script>