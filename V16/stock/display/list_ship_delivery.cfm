<!--- Irsaliye Dagitim 20120927 hgul--->
<cf_xml_page_edit fuseact="stock.popup_list_ship_delivery">
	<cfquery name="get_ship_row_main" datasource="#dsn2#">
		SELECT
			SR.WRK_ROW_ID,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.NAME_PRODUCT,
			SR.PRODUCT_NAME2,
			SR.AMOUNT,
			SR.UNIT,
			SR.UNIT_ID,
			SR.DISCOUNTTOTAL,
			(SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = SR.ROW_PROJECT_ID) ROW_PROJECT_HEAD,
			SR.PRICE,
			SR.PRICE_OTHER,
			SR.GROSSTOTAL,
			SR.OTHER_MONEY,
			SR.DELIVER_DEPT,
			SR.DELIVER_LOC,
			SR.ROW_PROJECT_ID,
			SR.BASKET_EMPLOYEE_ID,
			SR.SHELF_NUMBER,
			ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID,
			ISNULL(SR.SPECT_VAR_NAME,0) SPECT_VAR_NAME,
			ISNULL(SR.EXTRA_COST,0) EXTRA_COST,
			ISNULL(SR.COST_PRICE,0) COST_PRICE,
			(SELECT SHELF_CODE+'-'+SHELF.SHELF_NAME FROM #dsn3_alias#.PRODUCT_PLACE,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PRODUCT_PLACE.SHELF_TYPE AND PLACE_STATUS=1 AND PRODUCT_PLACE_ID = SR.SHELF_NUMBER) AS SHELF_NAME,
			SHIP.DEPARTMENT_IN,
			SHIP.LOCATION_IN,
			SHIP.DELIVER_EMP_ID,
			SHIP.DELIVER_PAR_ID,
			SHIP.DELIVER_DATE,
			SHIP.SHIP_DATE,
			SHIP.SHIP_NUMBER,
			SHIP.PROJECT_ID,
			ST.STOCK_CODE,
			ST.BARCOD,
			ISNULL((SELECT SUM(SHIP_ROW.AMOUNT) FROM SHIP_ROW WHERE SR.WRK_ROW_ID IN (SHIP_ROW.WRK_ROW_RELATION_ID)),0) DISPATCH_AMOUNT,
			(SELECT O.ORDER_NUMBER FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE ORR.ORDER_ID = O.ORDER_ID AND SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID) ORDER_NUMBER
		FROM
			SHIP_ROW SR,
			SHIP,
			#dsn3_alias#.STOCKS ST
		WHERE
			SR.SHIP_ID = #attributes.ship_id#
			AND SHIP.SHIP_ID = SR.SHIP_ID
			AND SR.STOCK_ID = ST.STOCK_ID
			AND ST.IS_INVENTORY = 1<!--- envantere dahil olmayan ürünler stok hareketi yapmaz. hizmetin stoğu olmaz. --->
	</cfquery>
	<!--- Gerceklesen kisminda kullanildiginda is_dept_control xmli nedeniyle sorun oldugundan ayirdim fbs 20121130 --->
	<cfquery name="get_ship_row" dbtype="query">
		SELECT
			*
		FROM
			get_ship_row_main
			<cfif isdefined("is_dept_control") and is_dept_control eq 1>
				WHERE
				(
					(DEPARTMENT_IN <> DELIVER_DEPT AND LOCATION_IN <> DELIVER_LOC) OR
					(DEPARTMENT_IN = DELIVER_DEPT AND LOCATION_IN <> DELIVER_LOC) OR
					(DEPARTMENT_IN <> DELIVER_DEPT AND LOCATION_IN = DELIVER_LOC) 
				)
			</cfif>
	</cfquery>
	<cfsavecontent variable="title_">
		<cf_get_lang dictionary_id="59284.İrsaliye Dağıtım">: <cfoutput>#get_ship_row.ship_number#</cfoutput>
	</cfsavecontent>
	<cf_box title="#title_#">
		<!--- dagitimi bekleyen --->
		<cf_seperator is_closed="0" title="#getLang('stock',139)#" id="waiting_deliver">
			<cfform name="form_basket" method="post">
		<cf_grid_list id="waiting_deliver">
			<thead>
				<tr> 
					<th><cf_get_lang_main no='799.Sipariş No'></th>
					<cfif xml_row_project_head>
					<th><cf_get_lang_main no='4.Proje'></th>
					</cfif>
					<th style="width:120px;"><cf_get_lang_main no='106.Stok Kodu'></th>
					<th><cf_get_lang_main no='221.Barkod'></th>
					<th><cf_get_lang_main no='245.Ürün'></th>
					<th style="text-align:right;width:50px;"><cf_get_lang_main no='223.Miktar'></th>
					<th style="text-align:right;width:50px;"><cf_get_lang no='557.Kalan Miktar'></th>
					<th style="text-align:center"><cf_get_lang_main no='224.Birim'></th>
					<th style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></th>
					<th style="text-align:center"><cf_get_lang_main no='265.Döviz'></th>
					<th style="text-align:right;"><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></th>
					<th style="text-align:right;"><cf_get_lang_main no='232.Son Toplam'></th>
					<th><cf_get_lang_main no='234.Teslim Depo'></th>
					<th style="width:50px;"><cf_get_lang no='77.Raf No'></th>
					<th style="width:15px;"><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onClick="wrk_select_all('allSelectDemand','row_demand');"></th>
				</tr>
			</thead>
			
				<tbody>
					<cfif get_ship_row.recordcount>
						<cfoutput>
							<input type="hidden" name="row_list" id="row_list" value="">
							<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
							<input type="hidden" name="ship_department_id" id="ship_department_id" value="#get_ship_row.DELIVER_DEPT#">
							<input type="hidden" name="ship_location_id" id="ship_location_id" value="#get_ship_row.DELIVER_LOC#">
							<input type="hidden" name="deliver_date_frm" id="deliver_date_frm" value="#DateFormat(get_ship_row.deliver_date,dateformat_style)#">
							<input type="hidden" name="ship_date" id="ship_date" value="#DateFormat(get_ship_row.ship_date,dateformat_style)#">
							<input type="hidden" name="ship_number" id="ship_number" value="#get_ship_row.ship_number#">
							<input type="hidden" name="deliver_emp_id" id="deliver_emp_id" value="#get_ship_row.deliver_emp_id#">
							<input type="hidden" name="project_id" id="project_id" value="#get_ship_row.project_id#">
						</cfoutput>
						<cfoutput query="get_ship_row">
							<input type="hidden" name="row_id" id="row_id" value="#wrk_row_id#">
							<tr>		
								<td>#order_number#</td>
								<cfif xml_row_project_head>
								<td>#row_project_head#</td>
								</cfif>
								<td style="width:120px;">#stock_code#</td>
								<td>#barcod#</td>
								<td style="width:145px;">
									<input type="hidden" name="stock_id_#wrk_row_id#" id="stock_id_#wrk_row_id#" value="#stock_id#">
									<input type="hidden" name="discounttotal_#wrk_row_id#" id="discounttotal_#wrk_row_id#" value="#get_ship_row.discounttotal#">
									<input type="hidden" name="product_id_#wrk_row_id#" id="product_id_#wrk_row_id#" value="#product_id#">
									<input type="hidden" name="spect_var_id_#wrk_row_id#" id="spect_var_id_#wrk_row_id#" value="#spect_var_id#">
									<input type="hidden" name="spect_var_name_#wrk_row_id#" id="spect_var_name_#wrk_row_id#" value="#spect_var_name#">
									<input type="hidden" name="row_project_id_#wrk_row_id#" id="row_project_id_#wrk_row_id#" value="#row_project_id#">
									<input type="hidden" name="basket_employee_id_#wrk_row_id#" id="basket_employee_id_#wrk_row_id#" value="#basket_employee_id#">
									<input type="hidden" name="product_name2_#wrk_row_id#" id="product_name2_#wrk_row_id#" value="#product_name2#">
									<input type="text" name="name_product_#wrk_row_id#" id="name_product_#wrk_row_id#" value="#name_product#" style="width:130px;" readonly="yes" class="boxtext">
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+#product_id#+'&sid='+#stock_id#+'','list');"><img border="0" align="right" src="/images/plus_thin_p.gif" title="<cf_get_lang no='458.Ürün Detay'>"></a>
								</td>
								<td style="width:50px;text-align:right;">#TLFormat(amount)#</td>
								<td style="width:50px;text-align:right;">
									<input type="hidden" name="remainder_real_amount_#wrk_row_id#" id="remainder_real_amount_#wrk_row_id#" value="#TLFormat(amount-DISPATCH_AMOUNT)#">
									<input type="text" name="remainder_amount_#wrk_row_id#" id="remainder_amount_#wrk_row_id#" value="#TLFormat(amount-DISPATCH_AMOUNT)#" style="width:50px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,3));">
								</td>
								<td style="text-align:center">
									<input type="hidden" name="unit_id_#wrk_row_id#" id="unit_id_#wrk_row_id#" value="#unit_id#">
									<input type="hidden" name="unit_#wrk_row_id#" id="unit_#wrk_row_id#" value="#unit#">
									#unit#
								</td>
								<td style="text-align:right;">
									#tlFormat(price,4)#
									<input type="hidden" name="extra_cost_#wrk_row_id#" id="extra_cost_#wrk_row_id#" value="#EXTRA_COST#">
									<input type="hidden" name="cost_price_#wrk_row_id#" id="cost_price_#wrk_row_id#" value="#COST_PRICE#">
								</td>
								<td style="text-align:center">#other_money#</td>
								<td style="text-align:right;">#tlFormat(price_other,4)#</td>
								<td style="text-align:right;">#tlFormat(grosstotal,4)#</td>
								<td style="width:160px;">
									<cfif len(DELIVER_DEPT) and len(DELIVER_LOC)>
										<cfquery name="get_department" datasource="#dsn#">
											SELECT DISTINCT
												D.DEPARTMENT_ID,
												D.DEPARTMENT_HEAD,
												SL.COMMENT
											FROM
												DEPARTMENT D,
												STOCKS_LOCATION SL
											WHERE
												SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
												D.DEPARTMENT_ID = #DELIVER_DEPT# AND
												SL.LOCATION_ID = #DELIVER_LOC#
										</cfquery>
										 <cfset department_head = "#get_department.DEPARTMENT_HEAD#-#get_department.COMMENT#">
									<cfelse>
										<cfset department_head = ''>
									</cfif>
									<input type="hidden" name="row_department_id_#wrk_row_id#" id="row_department_id_#wrk_row_id#" value="#DEPARTMENT_IN#">
									<input type="hidden" name="row_location_id_#wrk_row_id#" id="row_location_id_#wrk_row_id#" value="#LOCATION_IN#">
									<input type="hidden" name="department_id_#wrk_row_id#" id="department_id_#wrk_row_id#" value="#DELIVER_DEPT#">
									<input type="hidden" name="location_id_#wrk_row_id#" id="location_id_#wrk_row_id#" value="#DELIVER_LOC#">
									<input type="text" name="department_name_#wrk_row_id#" id="department_name_#wrk_row_id#" style="width:140px;" readonly="readonly" value="#department_head#">
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name_#wrk_row_id#&field_location_id=location_id_#wrk_row_id#&field_id=department_id_#wrk_row_id#','list','shelf_list_page');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
								</td>
								<td style="width:95px;"><!--- raf bilgisi --->
									<input type="hidden" name="shelf_number_#wrk_row_id#" id="shelf_number_#wrk_row_id#" value="#shelf_number#">
									<input type="text" name="shelf_number_txt_#wrk_row_id#" id="shelf_number_txt_#wrk_row_id#" style="width:80px;" value="#shelf_name#">
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_shelves&kontrol_out=0&form_name=form_basket&shelf_product_id=#product_id#&shelf_stock_id=#stock_id#&field_code=shelf_number_txt_#wrk_row_id#&field_id=shelf_number_#wrk_row_id#&department_id='+document.getElementById('department_id_#wrk_row_id#').value+'&location_id='+document.getElementById('location_id_#wrk_row_id#').value+'','small','shelf_list_page');"><!--- &row_id=1&row_count=3 ---><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
								</td>
								<td style="width:15px;">
									<input type="checkbox" name="row_demand" id="row_demand" value="#wrk_row_id#" <cfif (amount-DISPATCH_AMOUNT) lte 0>disabled</cfif>>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="14"><cf_get_lang_main no='72.Kayıt Yok'></td>
						</tr>
					</cfif>
								
				</tbody>
			</cf_grid_list>
		
			<cf_box_footer>
				<div class="col col-sm-6 col-xs-12">
				<div class="col col-sm-6 col-xs-12">	
					<div class="form-group">
						<label class="col col-6"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
							<div class="col col-6">
								<cf_workcube_process_cat slct_width="120">
							</div>
					</div>
				</div>
					<div class="col col-sm-6 col-xs-12">	
					<cf_workcube_buttons is_upd="0" add_function="control_form(1)" type_format="1">
					</div>
				</div>
			</cf_box_footer>
				
		
	</cfform>
		<br/>
		<!--- dagitimi gerceklesen --->
	<cf_seperator is_closed="0" title="#getLang('stock',140)#" id="delivered">
	<cfform name="form_send_print" method="post">
		<cf_grid_list id="delivered">
			<cfset crnt_row = 0>
			<cfif len(get_ship_row_main.WRK_ROW_ID)>
				<cfset related_row_id = ValueList(get_ship_row_main.WRK_ROW_ID)>
				<cfquery name="get_related_row_id" datasource="#dsn2#">
					SELECT
						 WRK_ROW_ID 
					FROM 
						SHIP_ROW 
					WHERE
						WRK_ROW_RELATION_ID IN (	<cfloop list="#ValueList(get_ship_row_main.WRK_ROW_ID)#" index="ww">
														<cfset crnt_row = crnt_row +1>
														'#ww#' <cfif crnt_row neq listlen(ValueList(get_ship_row_main.WRK_ROW_ID))>,</cfif>
													</cfloop>
												  ) 
				</cfquery>
				<cfoutput query="get_related_row_id">
					<cfset related_row_id = listappend(related_row_id,get_related_row_id.WRK_ROW_ID)>
				</cfoutput>
				<cfset crnt_row = 0>
				<cfquery name="get_dispatch_ship" datasource="#dsn2#">
					SELECT
						SR.WRK_ROW_ID,
						SR.WRK_ROW_RELATION_ID,
						SR.ROW_PROJECT_ID,
						SR.STOCK_ID,
						SR.BASKET_EMPLOYEE_ID,
						SR.PRODUCT_ID,
						SR.NAME_PRODUCT,
						SR.PRODUCT_NAME2,
						SR.AMOUNT,
						SR.UNIT,
						SR.UNIT_ID,
						SR.PRICE,
						SR.PRICE_OTHER,
						SR.GROSSTOTAL,
						SR.OTHER_MONEY,
						SR.DELIVER_DEPT,
						SR.DELIVER_LOC,
						SR.SHELF_NUMBER,
						SR.DISCOUNTTOTAL,
						ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID,
						ISNULL(SR.SPECT_VAR_NAME,0) SPECT_VAR_NAME,
						ISNULL(SR.EXTRA_COST,0) EXTRA_COST,
						ISNULL(SR.COST_PRICE,0) COST_PRICE,
						(SELECT SHELF_CODE+'-'+SHELF.SHELF_NAME FROM #dsn3_alias#.PRODUCT_PLACE,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PRODUCT_PLACE.SHELF_TYPE AND PLACE_STATUS=1 AND PRODUCT_PLACE_ID = SR.SHELF_NUMBER) AS SHELF_NAME,
						SHIP.DELIVER_STORE_ID,
						SHIP.LOCATION,
						SHIP.DEPARTMENT_IN,
						SHIP.LOCATION_IN,
						SHIP.PROJECT_ID_IN,
						SHIP.DELIVER_EMP_ID,
						SHIP.DELIVER_PAR_ID,
						SHIP.DELIVER_DATE,
						SHIP.SHIP_DATE,
						SHIP.SHIP_NUMBER,
						SHIP.SHIP_ID,
						ST.STOCK_CODE,
						ST.BARCOD,
						ISNULL((SELECT SUM(SHIP_ROW.AMOUNT) FROM SHIP_ROW WHERE SR.WRK_ROW_ID IN (SHIP_ROW.WRK_ROW_RELATION_ID)),0) DISPATCH_AMOUNT,
						(SELECT O.ORDER_NUMBER FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE ORR.ORDER_ID = O.ORDER_ID AND SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID) ORDER_NUMBER,
						(SELECT TOP 1 SFR.FIS_ID FROM STOCK_FIS_ROW SFR WHERE SFR.WRK_ROW_RELATION_ID IN (SELECT SRR.WRK_ROW_ID FROM SHIP_ROW SRR WHERE SRR.SHIP_ID = SR.SHIP_ID)) FIS_ID,
						(SELECT TOP 1 SFR.FIS_NUMBER FROM STOCK_FIS_ROW SFR, STOCK_FIS WHERE SFR.FIS_ID = STOCK_FIS.FIS_ID AND SFR.WRK_ROW_RELATION_ID IN (SELECT SRR.WRK_ROW_ID FROM SHIP_ROW SRR WHERE SRR.SHIP_ID = SR.SHIP_ID)) FIS_NUMBER
					FROM
						SHIP_ROW SR,
						SHIP,
						#dsn3_alias#.STOCKS ST
					WHERE
						(
						SR.WRK_ROW_RELATION_ID IN (	<cfloop list="#related_row_id#" index="ww">
														<cfset crnt_row = crnt_row +1>
														'#ww#' <cfif crnt_row neq listlen(related_row_id)>,</cfif>
													</cfloop>
												  )
						)
						AND SHIP.SHIP_ID = SR.SHIP_ID
						AND SR.STOCK_ID = ST.STOCK_ID
						AND SHIP.SHIP_TYPE = 81
					ORDER BY
						SHIP.SHIP_ID
				</cfquery>	
			<cfelse>
				<cfset get_dispatch_ship.recordcount = 0>
			</cfif>
			<thead>
				<tr> 
					<th><cf_get_lang_main no='468.Belge No'></th>
					<th><cf_get_lang_main no='1831.Sarf Fişi'></th>
					<th><cf_get_lang_main no='106.Stok Kodu'></th>
					<th><cf_get_lang_main no='221.Barkod'></th>
					<th><cf_get_lang_main no='245.Ürün'></th>
					<th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
					<th style="text-align:center"><cf_get_lang_main no='224.Birim'></th>
					<th><cf_get_lang_main no='1631.Çıkış Depo'></th>
					<th><cf_get_lang no='96.Giriş Depo'></th>
					<th><cf_get_lang no='77.Raf No'></th>
					<th style="text-align:right;width:50px;"><cf_get_lang no="130.Kabul Miktarı"></th>
					<th style="width:80px;"><cf_get_lang no='552.Kalite'></th>
					<th align="center" width="20"><a href="javascript://" onClick="send_print();"><i class="fa fa-print" title="<cf_get_lang_main no='645.Toplu'><cf_get_lang_main no='62.Yazdır'>"></i></a></th>
					<th align="center" width="20"><input type="checkbox" name="allSelectDemand_" id="allSelectDemand_" onClick="wrk_select_all('allSelectDemand_','occured_row_demand');"></th>
				</tr>
			</thead>
		
				<tbody>
					<cfif get_dispatch_ship.recordcount>
						<cfset dept_id_list = ''>
						<cfset location_list = ''>
						<cfoutput query="get_dispatch_ship">
							<cfif isdefined('deliver_store_id') and len(deliver_store_id) and not listfind(dept_id_list,deliver_store_id)>
								<cfset dept_id_list=listappend(dept_id_list,deliver_store_id)>
							</cfif>
							<cfif isdefined('department_in') and len(department_in) and not listfind(dept_id_list,department_in)>
								<cfset dept_id_list=listappend(dept_id_list,department_in)>
							</cfif>
							<cfif len("#deliver_store_id#-#location#") and not listfind(location_list,"#deliver_store_id#-#location#")>
								<cfset location_list=listappend(location_list,"#deliver_store_id#-#location#")>
							</cfif>
							<cfif len("#department_in#-#location_in#") and not listfind(location_list,"#department_in#-#location_in#")>
								<cfset location_list=listappend(location_list,"#department_in#-#location_in#")>
							</cfif>
						</cfoutput>
						<cfif listlen(dept_id_list)>
							<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
							<cfquery name="GET_DEP_DETAIL" datasource="#DSN#">
								SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
							</cfquery>
							<cfset dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif ListLen(location_list)>
							<cfset location_list=listsort(location_list,'text','asc',',')>
							<cfquery name="get_location" datasource="#dsn#">
								SELECT
									ISNULL(SL.IS_QUALITY,0) IS_QUALITY,
									SL.COMMENT,
									CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
								FROM
									DEPARTMENT D,
									STOCKS_LOCATION SL
								WHERE
									D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
									D.IS_STORE <> 2 AND
									CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(location_list,"'",",")#)
								ORDER BY
									CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
							</cfquery>
							<cfset location_list = ListSort(ListDeleteDuplicates(ValueList(get_location.department_locations_,',')),"text","asc",",")>
						</cfif>
						
						<cfoutput>
							<input type="hidden" name="occured_row_list" id="occured_row_list" value="">
							<input type="hidden" name="occured_active_period" id="occured_active_period" value="#session.ep.period_id#">
							<input type="hidden" name="occured_ship_department_id" id="occured_ship_department_id" value="#get_dispatch_ship.DELIVER_DEPT#">
							<input type="hidden" name="occured_ship_location_id" id="occured_ship_location_id" value="#get_dispatch_ship.DELIVER_LOC#">
							<input type="hidden" name="occured_deliver_date_frm" id="occured_deliver_date_frm" value="#DateFormat(get_dispatch_ship.deliver_date,dateformat_style)#">
							<input type="hidden" name="occured_ship_date" id="occured_ship_date" value="#DateFormat(get_dispatch_ship.ship_date,dateformat_style)#">
							<input type="hidden" name="occured_ship_number" id="occured_ship_number" value="#get_dispatch_ship.ship_number#">
							<input type="hidden" name="occured_deliver_emp_id" id="occured_deliver_emp_id" value="#get_dispatch_ship.deliver_emp_id#">
							<input type="hidden" name="occured_project_id" id="occured_project_id" value="#get_dispatch_ship.project_id_in#">
						</cfoutput>
						
						<cfoutput query="get_dispatch_ship">
							<input type="hidden" name="occured_row_id" id="occured_row_id" value="#wrk_row_id#">
							
							<input type="hidden" name="occured_stock_id_#wrk_row_id#" id="occured_stock_id_#wrk_row_id#" value="#stock_id#">
							<input type="hidden" name="occured_discounttotal_#wrk_row_id#" id="occured_discounttotal_#wrk_row_id#" value="#DISCOUNTTOTAL#">
							<input type="hidden" name="occured_product_id_#wrk_row_id#" id="occured_product_id_#wrk_row_id#" value="#product_id#">
							<input type="hidden" name="occured_spect_var_id_#wrk_row_id#" id="occured_spect_var_id_#wrk_row_id#" value="#spect_var_id#">
							<input type="hidden" name="occured_spect_var_name_#wrk_row_id#" id="occured_spect_var_name_#wrk_row_id#" value="#spect_var_name#">
							<input type="hidden" name="occured_name_product_#wrk_row_id#" id="occured_name_product_#wrk_row_id#" value="#name_product#">
							<input type="hidden" name="occured_row_project_id_#wrk_row_id#" id="occured_row_project_id_#wrk_row_id#" value="#row_project_id#">
							<input type="hidden" name="occured_basket_employee_id_#wrk_row_id#" id="occured_basket_employee_id_#wrk_row_id#" value="#basket_employee_id#">
							<input type="hidden" name="occured_product_name2_#wrk_row_id#" id="occured_product_name2_#wrk_row_id#" value="#product_name2#">
							
							<input type="hidden" name="occured_extra_cost_#wrk_row_id#" id="occured_extra_cost_#wrk_row_id#" value="#EXTRA_COST#">
							<input type="hidden" name="occured_cost_price_#wrk_row_id#" id="occured_cost_price_#wrk_row_id#" value="#COST_PRICE#">
							
							<input type="hidden" name="occured_row_department_id_#wrk_row_id#" id="occured_row_department_id_#wrk_row_id#" value="#DEPARTMENT_IN#">
							<input type="hidden" name="occured_row_location_id_#wrk_row_id#" id="occured_row_location_id_#wrk_row_id#" value="#LOCATION_IN#">
							
							
							<input type="hidden" name="occured_shelf_number_#wrk_row_id#" id="occured_shelf_number_#wrk_row_id#" value="#shelf_number#">
							<input type="hidden" name="occured_shelf_number_txt_#wrk_row_id#" id="occured_shelf_number_txt_#wrk_row_id#" value="#shelf_name#">
							
							<input type="hidden" name="occured_deliver_store_id_#wrk_row_id#" id="occured_deliver_store_id_#wrk_row_id#" value="#DELIVER_STORE_ID#">
							<input type="hidden" name="occured_deliver_location_id_#wrk_row_id#" id="occured_deliver_location_id_#wrk_row_id#" value="#LOCATION#">
							<tr>	
								<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#ship_id#','wwide','');" class="tableyazi">#SHIP_NUMBER#</a></td>
								<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#fis_id#','wwide','');" class="tableyazi">#FIS_NUMBER#</a></td>
								<td>#stock_code#</td>
								<td>#BARCOD#</td>
								<td>#NAME_PRODUCT#</td>
								<td style="text-align:right">#TLFormat(amount)#</td>
								<td style="text-align:center">#unit#</td>
								<td><cfif len(deliver_store_id) and (deliver_store_id neq 0)>
										#get_dep_detail.department_head[listfind(dept_id_list,deliver_store_id,',')]# - #get_location.comment[ListFind(location_list,"#deliver_store_id#-#location#",',')]#
									</cfif>
								</td>
								<td><cfif len(department_in) and (department_in neq 0)>
										#get_dep_detail.department_head[listfind(dept_id_list,department_in,',')]# - #get_location.comment[ListFind(location_list,"#department_in#-#location_in#",',')]#
									</cfif>
								</td>
								<td>#SHELF_NAME#</td>
								<cfquery name="get_sub_ship_row" dbtype="query">
									SELECT AMOUNT,DELIVER_DEPT,DELIVER_LOC FROM get_ship_row_main WHERE WRK_ROW_ID = '#wrk_row_relation_id#'
								</cfquery>
								<!--- Teslim Depo Bagli Alim Irsaliyesi Satirindan Gelir --->
								<input type="hidden" name="occured_department_id_#wrk_row_id#" id="occured_department_id_#wrk_row_id#" value="#get_sub_ship_row.DELIVER_DEPT#">
								<input type="hidden" name="occured_location_id_#wrk_row_id#" id="occured_location_id_#wrk_row_id#" value="#get_sub_ship_row.DELIVER_LOC#">
								<input type="hidden" name="occured_department_name_#wrk_row_id#" id="occured_department_name_#wrk_row_id#" value="#get_sub_ship_row.DELIVER_DEPT#;#get_sub_ship_row.DELIVER_LOC#">
									
								<input type="hidden" name="occured_unit_id_#wrk_row_id#" id="occured_unit_id_#wrk_row_id#" value="#unit_id#">
								<input type="hidden" name="occured_unit_#wrk_row_id#" id="occured_unit_#wrk_row_id#" value="#unit#">
								<cfif get_location.is_quality[listfind(location_list,"#department_in#-#location_in#",',')]>
									<cfquery name="get_related_quality" datasource="#dsn3#">
										SELECT TOP 1
											QS.IS_SUCCESS_TYPE,
											QS.SUCCESS,
											ORQ.CONTROL_AMOUNT,
											ORQ.IS_ALL_AMOUNT
										FROM
											ORDER_RESULT_QUALITY ORQ,
											QUALITY_SUCCESS QS
										WHERE
											ORQ.SUCCESS_ID = QS.SUCCESS_ID AND
											ORQ.PROCESS_ID = #attributes.ship_id# AND 
											ORQ.SHIP_WRK_ROW_ID IN ('#wrk_row_relation_id#') AND
											ORQ.STAGE IN (SELECT PTR.PROCESS_ROW_ID FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = ORQ.STAGE AND PTR.IS_CONFIRM = 1) AND <!--- Asamasinin Onay Secili Olmasi Lazim --->
											ORQ.SHIP_PERIOD_ID = #session.ep.period_id#
										ORDER BY
											ISNULL(ORQ.UPDATE_DATE,ORQ.RECORD_DATE) DESC
									</cfquery>
									<!--- <cfdump var="#get_related_quality#"> --->
									<input type="hidden" name="occured_remainder_real_amount_#wrk_row_id#" id="occured_remainder_real_amount_#wrk_row_id#" value="<cfif get_related_quality.is_all_amount eq 1>#TLFormat(get_related_quality.control_amount)#<cfelse>#TLFormat(get_sub_ship_row.amount)#</cfif>">
									<input type="hidden" name="occured_remainder_amount_#wrk_row_id#" id="occured_remainder_amount_#wrk_row_id#" value="<cfif get_related_quality.is_all_amount eq 1>#TLFormat(get_related_quality.control_amount)#<cfelse>#TLFormat(get_sub_ship_row.amount)#</cfif>">
									<!--- 1 Kabul, 0 Red, 2 Yeniden Muayene --->
									<td style="text-align:right;"><cfif get_related_quality.is_all_amount eq 1>#TLFormat(get_related_quality.control_amount)#<cfelse>#TLFormat(get_sub_ship_row.amount)#</cfif></td>
									<td><cfif get_related_quality.is_success_type eq 1><cf_get_lang no="133.Kabul"><cfelseif get_related_quality.is_success_type eq 0><cf_get_lang_main no="1740.Red"><cfelseif get_related_quality.is_success_type eq 2><cf_get_lang no="142.Yeniden Muayeneden Geçiyor"><cfelse><cf_get_lang no="143.Kontrol Edilmeyi Bekliyor"></cfif></td>
								<cfelse>
									<!--- else durumunda hidden göndermediğimiz için hata veriyordu ekledim py 0914 --->
									<input type="hidden" name="occured_remainder_real_amount_#wrk_row_id#" id="occured_remainder_real_amount_#wrk_row_id#" value="#TLFormat(amount-DISPATCH_AMOUNT)#">
									<input type="hidden" name="occured_remainder_amount_#wrk_row_id#" id="occured_remainder_amount_#wrk_row_id#" value="#TLFormat(amount-DISPATCH_AMOUNT)#">
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</cfif>
								<input type="hidden" name="occured_quality_#wrk_row_id#" id="occured_quality_#wrk_row_id#" value="<cfif isDefined("get_related_quality")>#get_related_quality.is_success_type#</cfif>">
								<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#ship_id#&print_type=30','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang_main no='62.Yazdır'>"></i></a></td>
								<td align="center"><input type="checkbox" name="occured_row_demand" id="occured_row_demand" value="#wrk_row_id#"></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="14"><cf_get_lang_main no='72.Kayıt Yok'></td>
						</tr>
					</cfif>
				</tbody>
		</cf_grid_list>
				<cf_box_footer>
					<div class="col col-sm-6 col-xs-12">
					<div class="col col-sm-6 col-xs-12">	
						<div class="form-group">
							<label class="col col-6"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
								<div class="col col-6">
									<cf_workcube_process_cat slct_width="120">
								</div>
						</div>
					</div>
						<div class="col col-sm-6 col-xs-12">	
						<cf_workcube_buttons is_upd="0" add_function="control_form(2)" type_format="1">
						</div>
					</div>
				</cf_box_footer>
				 
	</cfform>
	</cf_box>
	<script type="text/javascript">
		function send_print()
		{
			<cfif not get_dispatch_ship.recordcount>
				alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
				return false;
			<cfelseif get_dispatch_ship.recordcount eq 1>
				if(document.form_send_print.occured_row_demand.checked == false)
				{
					alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
					return false;
				}
				else
				{
					ship_list_ = document.form_send_print.occured_row_demand.value;
				}
			<cfelseif get_dispatch_ship.recordcount gt 1>
				ship_list_ = "";
				for (i=0; i < document.form_send_print.occured_row_demand.length; i++)
				{
					if(document.form_send_print.occured_row_demand[i].checked == true)
						{
						ship_list_ = ship_list_ + document.form_send_print.occured_row_demand[i].value + ',';
						}	
				}
				if(ship_list_.length == 0)
					{
					alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
					return false;
					}
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=30&action_row_id='+ship_list_,'page');
		}
		function pencere_ac_project(no)
		{
			openBoxDraggable("<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id' + no +'&project_head=form_basket.project' + no </cfoutput>");
		}
		is_run_form = 0;//sayfa iki kez submit edilmesin diye eklendi
		function control_form(type)
		{
			if(is_run_form == 0)
			{
				is_run_form = 1;
				//Gerceklesen Icin (type=2) Formdaki Ogelerin Basina occured_ ekleniyor
				if(type == 2) var occ = "occured_"; else var occ = "";
				
				if(document.getElementsByName(occ+"row_demand").length != undefined)
				{
					var checked_item_ = document.getElementsByName(occ+"row_demand");
					for(var xx=0; xx < document.getElementsByName(occ+"row_demand").length; xx++)
					{
						if(checked_item_[xx].checked)
						{var is_selected_row = 1;}
					}
				}
				else if(document.getElementById(occ+"row_demand").checked)
					var is_selected_row = 1;
					
				if(is_selected_row == undefined)
				{
					alert("<cf_get_lang_main no ='313.Ürün Seçiniz'>!");
					is_run_form = 0;
					return false;
				}
				
				if(type == 2) var new_process_cat = document.form_send_print.process_cat.value; else var new_process_cat = document.form_basket.process_cat.value;
				if(new_process_cat == '')
				{
					alert("<cf_get_lang_main no ='1358.İşlem Tipi Seçiniz'>");
					is_run_form = 0;
					return false;
				}
				var ajxlist = '';
				document.getElementById(occ+'row_list').value = '';
				if(document.getElementsByName(occ+"row_demand").length != undefined)
				{
					var checked_item_ = document.getElementsByName(occ+"row_demand");
					for(var xx=0; xx < document.getElementsByName(occ+"row_demand").length; xx++)
					{
						var row_product_info='';
						if(checked_item_[xx].checked)
						{
							var wrk_rowid = checked_item_[xx].value;
							/*if(type == 2 && document.getElementById("occured_quality_"+wrk_rowid) != undefined && document.getElementById("occured_quality_"+wrk_rowid).value != 1)
							{
								alert("Kalite Kontrol İşlemi Tamamlanmadan Sevk Edemezsiniz!");
								is_run_form = 0;
								return false;
							}*/
							if(document.getElementById(occ+'department_name_'+wrk_rowid).value == '')
							{
								var satir = xx+1;
								alert(satir+ '. Satırda Departman Bilgisi Eksik. Lütfen Departman Giriniz!');
								is_run_form = 0;
								return false;
							}
							if((document.getElementById(occ+'department_id_'+wrk_rowid).value == document.getElementById(occ+'row_department_id_'+wrk_rowid).value) && (document.getElementById(occ+'location_id_'+wrk_rowid).value == document.getElementById(occ+'row_location_id_'+wrk_rowid).value))
							{
								var satir = xx+1;
								alert(satir+ '. Satırda Belge Deposu ile Satır Deposu Aynı. Lütfen Satırdaki Depoyu Değiştiriniz!');
								is_run_form =0;
								return false;
							}
							var row_product_info_list='';
							if(parseFloat(filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2)) > parseFloat(filterNum(document.getElementById(occ+'remainder_real_amount_'+wrk_rowid).value,2)) || parseFloat(filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2)) == 0)
							{
								alert("<cf_get_lang no ='75.Girilen Miktar, Kalan Miktardan Büyük Olamaz'>!");
								is_run_form =0;
								document.getElementById(occ+'remainder_amount_'+wrk_rowid).value = document.getElementById(occ+'remainder_real_amount_'+wrk_rowid).value;
								return false;
							}	
							var stock_id = document.getElementById(occ+'stock_id_'+wrk_rowid).value;
							var product_id = document.getElementById(occ+'product_id_'+wrk_rowid).value;
							var name_product = document.getElementById(occ+'name_product_'+wrk_rowid).value;
							var unit_id = document.getElementById(occ+'unit_id_'+wrk_rowid).value;
							var unit_ = document.getElementById(occ+'unit_'+wrk_rowid).value;
							var amount = filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2);
							if(type == 2 && document.getElementById("occured_quality_"+wrk_rowid) != undefined && document.getElementById("occured_quality_"+wrk_rowid).value != 1)
							{//Kalite red edilmisse giris yapılan depodan cikis yapılıp satırdaki cikis depoya giris yapılacak.
								var dept_id = document.getElementById(occ+'deliver_store_id_'+wrk_rowid).value;
								var loc_id = document.getElementById(occ+'deliver_location_id_'+wrk_rowid).value;
								var row_dept_id = document.getElementById(occ+'row_department_id_'+wrk_rowid).value;
								var row_loc_id = document.getElementById(occ+'row_location_id_'+wrk_rowid).value;
							}
							else
							{
								var dept_id = document.getElementById(occ+'department_id_'+wrk_rowid).value;
								var loc_id = document.getElementById(occ+'location_id_'+wrk_rowid).value;
								var row_dept_id = document.getElementById(occ+'row_department_id_'+wrk_rowid).value;
								var row_loc_id = document.getElementById(occ+'row_location_id_'+wrk_rowid).value;
							}
							var extra_cost = document.getElementById(occ+'extra_cost_'+wrk_rowid).value;
							var cost_price = document.getElementById(occ+'cost_price_'+wrk_rowid).value;
							var spect_var_id = document.getElementById(occ+'spect_var_id_'+wrk_rowid).value;
							var spect_var_name = document.getElementById(occ+'spect_var_name_'+wrk_rowid).value;
							var row_list_ = document.getElementById(occ+'row_list').value;
							var dispatch_ship_number = document.getElementById(occ+'ship_number').value;
							if(document.getElementById(occ+'row_project_id_'+wrk_rowid).value != '')
								var row_project_id = document.getElementById(occ+'row_project_id_'+wrk_rowid).value;
							else
								var row_project_id = 0;
							if(document.getElementById(occ+'basket_employee_id_'+wrk_rowid).value != '')
								var basket_employee_id = document.getElementById(occ+'basket_employee_id_'+wrk_rowid).value;
							else
								var basket_employee_id = 0;
							if(document.getElementById(occ+'product_name2_'+wrk_rowid).value != '')
								var product_name2 = document.getElementById(occ+'product_name2_'+wrk_rowid).value;
							else
								var product_name2 = 0;
							if(document.getElementById(occ+'discounttotal_'+wrk_rowid).value != '')
								var discounttotal = document.getElementById(occ+'discounttotal_'+wrk_rowid).value;
							else
								var discounttotal = 0;	
							if(document.getElementById(occ+'deliver_emp_id').value != '')
							{
								var deliver_emp_id_ = document.getElementById(occ+'deliver_emp_id').value;
							}
							else
							{
								alert("Belgedeki Teslim Alan Bilgisi Eksik. Lütfen Teslim Alan Bilgisini Giriniz!");
								is_run_form = 0;
								return false;
							}
							if(document.getElementById(occ+'shelf_number_'+wrk_rowid).value != '')
								var shelf_id = document.getElementById(occ+'shelf_number_'+wrk_rowid).value;
							else
								var shelf_id = 0;
							
							if(amount > 0 && document.getElementById(occ+'department_name_'+wrk_rowid).value != '')
							{
								var row_product_info=''+wrk_rowid+'§'+stock_id+'§'+product_id+'§'+amount+'§'+dept_id+'§'+loc_id+'§'+shelf_id+'§'+name_product+'§'+unit_id+'§'+unit_+'§'+extra_cost+'§'+cost_price+'§'+spect_var_id+'§'+spect_var_name+'§'+row_dept_id+'§'+row_loc_id+'§'+dispatch_ship_number+'§'+deliver_emp_id_+'§'+row_project_id+'§'+product_name2+'§'+basket_employee_id+'§'+discounttotal+'§'+ ''; // alt + 789 = §
								var row_product_info_list=''+row_list_+'█'+row_product_info+''; //alt + 987 = █
							}
							//document.getElementById('remainder_amount_'+wrk_rowid).value = document.getElementById('remainder_real_amount_'+wrk_rowid).value-document.getElementById('remainder_amount_'+wrk_rowid).value;
							document.getElementById(occ+'row_list').value = row_product_info_list;
						}
					}
				}		
				else if(document.getElementById(occ+"row_demand").checked)
				{
					
					var checked_item_ = document.getElementById(occ+"row_demand");
					var row_product_info='';
					if(checked_item_.checked)
					{
						var row_product_info_list='';
						var wrk_rowid = checked_item_.value;
						/*if(type == 2 && document.getElementById("occured_quality_"+wrk_rowid) != undefined && document.getElementById("occured_quality_"+wrk_rowid).value != 1)
						{
							alert("Kalite Kontrol İşlemi Tamamlanmadan Sevk Edemezsiniz!");
							is_run_form = 0;
							return false;
						}*/
						if(document.getElementById(occ+'department_name_'+wrk_rowid).value == '')
						{
							alert('Satırda Departman Bilgisi Eksik. Lütfen Departman Giriniz!');
							is_run_form = 0;
							return false;
						}
						if((document.getElementById(occ+'department_id_'+wrk_rowid).value == document.getElementById(occ+'row_department_id_'+wrk_rowid).value) && (document.getElementById(occ+'location_id_'+wrk_rowid).value == document.getElementById(occ+'row_location_id_'+wrk_rowid).value))
						{
							alert('Satırda Belge Deposu ile Satır Deposu Aynı. Lütfen Satırdaki Depoyu Değiştiriniz!');
							is_run_form = 0;
							return false;
						}
						if(parseFloat(filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2)) > parseFloat(filterNum(document.getElementById(occ+'remainder_real_amount_'+wrk_rowid).value,2)) || parseFloat(filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2)) == 0)
						{
							alert("<cf_get_lang no ='75.Girilen Miktar, Kalan Miktardan Büyük Olamaz'>!");
							is_run_form = 0;
							document.getElementById(occ+'remainder_amount_'+wrk_rowid).value = document.getElementById(occ+'remainder_real_amount_'+wrk_rowid).value;
							return false;
						}	
						var stock_id = document.getElementById(occ+'stock_id_'+wrk_rowid).value;
						var product_id = document.getElementById(occ+'product_id_'+wrk_rowid).value;
						var name_product = document.getElementById(occ+'name_product_'+wrk_rowid).value;
						var unit_id = document.getElementById(occ+'unit_id_'+wrk_rowid).value;
						var unit_ = document.getElementById(occ+'unit_'+wrk_rowid).value;
						var amount = filterNum(document.getElementById(occ+'remainder_amount_'+wrk_rowid).value,2);
						if(type == 2 && document.getElementById("occured_quality_"+wrk_rowid) != undefined && document.getElementById("occured_quality_"+wrk_rowid).value != 1)
						{//Kalite red edilmisse giris yapılan depodan cikis yapılıp satırdaki cikis depoya giris yapılacak.
							var dept_id = document.getElementById(occ+'deliver_store_id_'+wrk_rowid).value;
							var loc_id = document.getElementById(occ+'deliver_location_id_'+wrk_rowid).value;
							var row_dept_id = document.getElementById(occ+'row_department_id_'+wrk_rowid).value;
							var row_loc_id = document.getElementById(occ+'row_location_id_'+wrk_rowid).value;
						}
						else
						{
							var dept_id = document.getElementById(occ+'department_id_'+wrk_rowid).value;
							var loc_id = document.getElementById(occ+'location_id_'+wrk_rowid).value;
							var row_dept_id = document.getElementById(occ+'row_department_id_'+wrk_rowid).value;
							var row_loc_id = document.getElementById(occ+'row_location_id_'+wrk_rowid).value;
						}
						var extra_cost = document.getElementById(occ+'extra_cost_'+wrk_rowid).value;
						var cost_price = document.getElementById(occ+'cost_price_'+wrk_rowid).value;
						var spect_var_id = document.getElementById(occ+'spect_var_id_'+wrk_rowid).value;
						var spect_var_name = document.getElementById(occ+'spect_var_name_'+wrk_rowid).value;
						var row_list_ = document.getElementById(occ+'row_list').value;
						var dispatch_ship_number = document.getElementById(occ+'ship_number').value;
						if(document.getElementById(occ+'row_project_id_'+wrk_rowid).value != '')
							var row_project_id = document.getElementById(occ+'row_project_id_'+wrk_rowid).value;
						else
							var row_project_id = 0;
						if(document.getElementById(occ+'product_name2_'+wrk_rowid).value != '')
							var product_name2 = document.getElementById(occ+'product_name2_'+wrk_rowid).value;
						else
							var product_name2 = 0;
						if(document.getElementById(occ+'basket_employee_id_'+wrk_rowid).value != '')
							var basket_employee_id = document.getElementById(occ+'row_project_id_'+wrk_rowid).value;
						else
							var basket_employee_id = 0;
						if(document.getElementById(occ+'deliver_emp_id').value != '')
						{
							var deliver_emp_id_ = document.getElementById(occ+'deliver_emp_id').value;
						}
						else
						{
							alert("Belgedeki Teslim Alan Bilgisi Eksik. Lütfen Teslim Alan Bilgisini Giriniz!");
							is_run_form = 0;
							return false;
						}
						if(document.getElementById(occ+'shelf_number_'+wrk_rowid).value != '')
							var shelf_id = document.getElementById(occ+'shelf_number_'+wrk_rowid).value;
						else
							var shelf_id = 0;
							
						if(amount > 0 && document.getElementById(occ+'department_name_'+wrk_rowid).value != '')
						{
							var row_product_info=''+wrk_rowid+'§'+stock_id+'§'+product_id+'§'+amount+'§'+dept_id+'§'+loc_id+'§'+shelf_id+'§'+name_product+'§'+unit_id+'§'+unit_+'§'+extra_cost+'§'+cost_price+'§'+spect_var_id+'§'+spect_var_name+'§'+row_dept_id+'§'+row_loc_id+'§'+dispatch_ship_number+'§'+deliver_emp_id_+'§'+row_project_id+'§'+product_name2+'§'+basket_employee_id+'§'+discounttotal+'§'+''; // alt + 789 = §
							var row_product_info_list=''+row_list_+'█'+row_product_info+''; //alt + 987 = █
						}
						//document.getElementById('remainder_amount_'+wrk_rowid).value = document.getElementById('remainder_real_amount_'+wrk_rowid).value-document.getElementById('remainder_amount_'+wrk_rowid).value;
						document.getElementById(occ+'row_list').value = row_product_info_list;
					}
				}
				ajxlist+='&ship_number='+document.getElementById(occ+'ship_number').value+'&deliver_date_frm='+document.getElementById(occ+'deliver_date_frm').value+'&project_id='+document.getElementById(occ+'project_id').value+'&ship_date='+document.getElementById(occ+'ship_date').value+'&active_period='+document.getElementById(occ+'active_period').value+'';
				//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_sale&from_ship_delivery=1&'+ajxlist+'&process_cat='+new_process_cat+'&department_id='+document.getElementById(occ+'ship_department_id').value+'&location_id='+document.getElementById(occ+'ship_location_id').value+'&rows_=1&row_product_info_list='+row_product_info_list+'','list');	
				if(type == 2)
				{
					windowopen('','medium','shp_dlvry');
					form_send_print.action='<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_sale&from_ship_delivery=1&'+ajxlist+'&process_cat='+new_process_cat+'&department_id='+document.getElementById(occ+'ship_department_id').value+'&location_id='+document.getElementById(occ+'ship_location_id').value+'&rows_=1&row_product_info_list='+row_product_info_list+'';//şimdilk giden talimat sadce
					form_send_print.target='shp_dlvry';
					form_send_print.submit();
					form_send_print.action='<cfoutput>#request.self#?fuseaction=stock.popup_list_ship_delivery&ship_id=#attributes.ship_id#</cfoutput>';
					form_send_print.target='';
				}
				else
				{
					windowopen('','medium','shp_dlvry');
					form_basket.action='<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_sale&from_ship_delivery=1&'+ajxlist+'&process_cat='+new_process_cat+'&department_id='+document.getElementById(occ+'ship_department_id').value+'&location_id='+document.getElementById(occ+'ship_location_id').value+'&rows_=1&row_product_info_list='+row_product_info_list+'';//şimdilk giden talimat sadce
					form_basket.target='shp_dlvry';
					form_basket.submit();
					form_basket.action='<cfoutput>#request.self#?fuseaction=stock.popup_list_ship_delivery&ship_id=#attributes.ship_id#</cfoutput>';
					form_basket.target='';
				}		
				//AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_sale&from_ship_delivery=1&'+ajxlist+'&process_cat='+document.getElementById('process_cat').value+'&department_id='+document.getElementById('ship_department_id').value+'&location_id='+document.getElementById('ship_location_id').value+'&rows_=1&row_product_info_list='+row_product_info_list+'','ship_delivery');
				window.location.reload();
			}
		}
	</script>
	