<!--- Üretim Sonucu Oluşturma --->
<cf_xml_page_edit fuseact="production.form_add_production_order">
<cfif not isnumeric(attributes.upd)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfquery name="get_order" datasource="#dsn3#">
	SELECT 
		PO.P_ORDER_ID,
		PO.P_ORDER_NO,
		PO.STATION_ID,
		PO.FINISH_DATE,
		PO.IS_DEMONTAJ,
		S.PRODUCT_NAME,
		S.STOCK_ID,
		PO.SPECT_VAR_NAME,
		PO.QUANTITY,
		PO.SPECT_VAR_ID,
		PO.SPEC_MAIN_ID,
		PO.PO_RELATED_ID,
		ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID
					AND POO.P_ORDER_ID = PO.P_ORDER_ID
					AND POR_.TYPE = 1
					AND POO.IS_STOCK_FIS = 1
					AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
				),0) ROW_RESULT_AMOUNT,
		(SELECT TOP 1 MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID) AS MAIN_UNIT,
		(SELECT TOP 1 PRODUCT_CATID FROM #dsn1_alias#.PRODUCT PRODUCT WHERE PRODUCT.PRODUCT_ID = S.PRODUCT_ID) PRODUCT_CATID
	FROM 
		PRODUCTION_ORDERS PO,
		STOCKS S
	WHERE 
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		S.STOCK_ID = PO.STOCK_ID
</cfquery>
<cfif not get_order.RECORDCOUNT>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="get_prod_pause_type" datasource="#dsn3#">
		SELECT DISTINCT
			SPPT.PROD_PAUSE_TYPE_ID,
			SPPT.PROD_PAUSE_TYPE
		FROM
			SETUP_PROD_PAUSE_TYPE SPPT,
			SETUP_PROD_PAUSE_TYPE_ROW SPPTR
		WHERE
			SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
			SPPTR.PROD_PAUSE_PRODUCTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.product_catid#">
	</cfquery>
	<cfquery name="GET_ROW" datasource="#dsn3#">
		SELECT
			ORDER_NUMBER,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
		FROM
			PRODUCTION_ORDERS_ROW,
			ORDERS
		WHERE
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
			PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
	</cfquery>
	<cfif len(get_order.station_id)>
		<cfquery name="get_w" datasource="#dsn3#">
			SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
		</cfquery>
		<cfquery name="get_relation_physical_asset" datasource="#dsn#">
			SELECT 
				ASSET_P.ASSETP_ID, 
				ASSET_P.ASSETP, 
				RELATION_PHYSICAL_ASSET_STATION.STATION_ID	
			FROM 
				ASSET_P, 
				RELATION_PHYSICAL_ASSET_STATION 
			WHERE 
				ASSET_P.ASSETP_ID = RELATION_PHYSICAL_ASSET_STATION.PHYSICAL_ASSET_ID AND 
				RELATION_PHYSICAL_ASSET_STATION.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
		</cfquery>
	<cfelse>
		<cfset get_w.recordcount = 0>
		<cfset get_relation_physical_asset.recordcount = 0>
	</cfif>
	<cfquery name="get_serial" datasource="#dsn3#">	
		SELECT 
			SERIAL_NO,
			GUARANTY_ID 
		FROM 
			SERVICE_GUARANTY_NEW 
		WHERE 
			PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
			PROCESS_CAT = 1194 AND
			PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order.p_order_no#">
	</cfquery>
	<cfif len(get_order.station_id)>
		<cfquery name="GET_STATION_INFO" datasource="#dsn3#">
			SELECT 
				DEPARTMENT,
				STATION_NAME,
				EXIT_DEP_ID,
				EXIT_LOC_ID,
				ENTER_DEP_ID,
				ENTER_LOC_ID,
				PRODUCTION_DEP_ID,
				PRODUCTION_LOC_ID
			FROM 
				WORKSTATIONS 
			WHERE 
				STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
		</cfquery>
	<cfelse>
		<cfset get_station_info.recordcount = 0>
	</cfif>
	<cfif GET_STATION_INFO.recordcount and len(GET_STATION_INFO.DEPARTMENT)>
		<cfquery name="get_employees" datasource="#dsn#">
			SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.DEPARTMENT#"> AND EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0
		</cfquery>
	<cfelse>
		<cfset get_employees.recordcount = 0>
		<cfset get_employees.EMPLOYEE = ''>
		<cfset get_employees.EMPLOYEE_ID = ''>
	</cfif>
	<cfquery name="get_operations" datasource="#dsn3#">
		SELECT * FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
	</cfquery>
	<cfquery name="get_serial_count" dbtype="query">
		SELECT 
			COUNT(WRK_ROW_ID),
			EMPLOYEE_ID,
			ASSET_ID,
			AMOUNT,
			SERIAL_NO,
			WRK_ROW_ID
		FROM 
			get_operations 
		WHERE 
			TYPE = 1
		GROUP BY 
			SERIAL_NO,
			EMPLOYEE_ID,
			ASSET_ID,
			AMOUNT,
			WRK_ROW_ID
		ORDER BY 
			WRK_ROW_ID
	</cfquery>
	
	<cfif not get_serial_count.recordcount>
		<link rel="stylesheet" type="text/css" href="css/temp/multiselect_check/jquery.multiselect.css">
		<script type="text/javascript" src="JS/jquery-ui-1.8.14.custom.min.js"></script>
		<script type="text/javascript" src="JS/temp/multiselect/jquery.multiselect.filter.js"></script>
		<script type="text/javascript" src="JS/temp/multiselect/jquery.multiselect.js"></script>
	</cfif>
	<cfquery name="GET_PROD_RESULT_XML" datasource="#DSN#">
		SELECT PROPERTY_NAME,PROPERTY_VALUE FROM FUSEACTION_PROPERTY where FUSEACTION_NAME = 'prod.upd_prod_order_result' and OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cf_box>
		<cfform name="production_order" method="post" action="#request.self#?fuseaction=production.form_add_production_order&upd=#attributes.upd#">
			<input type="hidden" name="start_date" id="start_date" value="">
			<input type="hidden" name="record_num" id="record_num" value="">
			<cf_grid_list class="ajax_list">
				<cfoutput query="get_order">
					<cf_grid_list class="ajax_list">
						<tr>
							<td class="box_yazi"><cf_get_lang dictionary_id='38046.EMİR NO'></td>
							<td class="box_yazi_td" style="width:100px;color:OrangeRed">#p_order_no#</td>
							<td class="box_yazi"><cf_get_lang dictionary_id='38047.SİPARİŞ NO'></td>
							<td class="box_yazi_td" style="width:100px;color:OrangeRed">#get_row.order_number#</td>
							<td class="box_yazi"><cf_get_lang dictionary_id='38048.ANA EMİR NO'></td>
							<td class="box_yazi_td" style="width:100px;color:OrangeRed">
								<cfif len(get_order.PO_RELATED_ID)>
									<cfquery name="get_related" datasource="#dsn3#">
										SELECT TOP 1 P_ORDER_ID,P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.PO_RELATED_ID#">
									</cfquery>
									#get_related.P_ORDER_NO#
								</cfif>
							</td>
							<td class="box_yazi"><cf_get_lang dictionary_id='38049.İSTASYON ADI'></td>
							<td class="box_yazi_td" style="width:100px;color:OrangeRed"><cfif len(get_order.station_id)>#get_w.station_name#</cfif></td>
							<td><div style="position:absolute;" id="open_order_"></div></td>
							<td class="box_yazi"><cf_get_lang dictionary_id='58763.Depo'></td>
							<td class="box_yazi_td" style="width:100px;color:OrangeRed">
								<cfif get_station_info.recordcount and len(get_station_info.EXIT_DEP_ID)>
									<cfquery name="get_department" datasource="#dsn#">
										SELECT 
											D.DEPARTMENT_HEAD 
										FROM 
											DEPARTMENT D,
											STOCKS_LOCATION SL 
										WHERE 
											D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND 
											D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.EXIT_DEP_ID#"> AND
											SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.EXIT_LOC_ID#">
									</cfquery>
									#get_department.DEPARTMENT_HEAD#
								</cfif>
							</td>
							<td><a href="javascript:history.go(-1);"><span class="icn-md fa fa-arrow-left" border="0" title="<cf_get_lang dictionary_id='57432.Geri'>"></span></a></td>
							<td>
								<a href="javascript://" onClick="goster(open_order_);open_order();"><span class="icn-md icon-settings" border="0" title="<cf_get_lang dictionary_id='51318.Üretim Emirleri'>"></span></a>
							</td>
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.upd#&print_type=281','page');"><span class="icn-md fa fa-print" border="0"></span></a>
							</td>
						</tr>
					</cf_grid_list>
				</cfoutput>
					<cf_grid_list>
						<tr height="30">
							<td class="box_yazi_td2" style="width:210px;text-align:center"><cf_get_lang dictionary_id='38050.Üretilen Ürün Adı'></td>
							<td class="box_yazi_td2" style="width:210px;text-align:center"><cf_get_lang dictionary_id='38051.Üretilen Ürün Spec'></td>
							<td class="box_yazi_td2" style="width:180px;text-align:center"><cf_get_lang dictionary_id='38052.Ü E  Adedi'></td>
							<td class="box_yazi_td2" style="width:180px;text-align:center"><cf_get_lang dictionary_id='58444.Kalan'></td>
							<td class="box_yazi_td2" style="width:180px;text-align:center"><cf_get_lang dictionary_id='57636.Birim'></td>
							<td><cf_workcube_process_cat slct_width="140"></td>
						</tr>
						<tr height="30">
							<cfoutput query="get_order">
								<td class="box_yazi_td" style="width:210px;color:OrangeRed;text-align:center">#PRODUCT_NAME#</td>
								<td class="box_yazi_td" style="width:210px;color:OrangeRed;text-align:center">#SPECT_VAR_NAME#</td>
								<td class="box_yazi_td" style="width:180px;color:OrangeRed;text-align:center">#QUANTITY#</td>
								<td class="box_yazi_td" style="width:180px;color:OrangeRed;text-align:center">
									#QUANTITY - ROW_RESULT_AMOUNT#
									<input type="hidden" name="remaining"  id="remaining" value="#QUANTITY - ROW_RESULT_AMOUNT#" />
								</td>
								<td class="box_yazi_td" style="width:180px;color:OrangeRed;text-align:center">#MAIN_UNIT#</td>
								<td><a href="javascript://" onclick="control();"><span class="icn-md icon-add" border="0"></span></a></td>
								<td style="display:none;"><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'></td>
							</cfoutput>
						</tr>
						<tr>
							<td colspan="6">
								<cfquery name="get_amount" datasource="#dsn3#">
									SELECT SUM(AMOUNT) AMOUNT FROM (SELECT AMOUNT,WRK_ROW_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND TYPE=1 GROUP BY AMOUNT,WRK_ROW_ID)T1
								</cfquery>
								<input type="hidden" name="toplam_tutar" id="toplam_tutar" value="<cfoutput>#get_amount.AMOUNT#</cfoutput>">
							</td>
						</tr>
						<tr style="text-align:center">
							<td colspan="6">
								<cf_grid_list class="ajax_list" id="cf_grid_list1">
									<input type="hidden" name="record_num_2" id="record_num_2" value="">
									<cfif get_serial_count.recordcount>
										<input type="hidden" name="count_" id="count_" value="<cfoutput>#get_serial_count.recordcount#</cfoutput>" />
										<cfoutput query="get_serial_count">
											<cfquery name="get_type" datasource="#dsn3#">
												SELECT TOP 1 TYPE,START_COUNTER,FINISH_COUNTER FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_serial_count.WRK_ROW_ID#"> ORDER BY RECORD_DATE DESC
											</cfquery>
											<cfset cols_ = 6>
											<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
												<cfset cols_ = cols_ + 2>
											</cfif>
											<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
												<tr id="frm_row#currentrow#"<cfif get_type.type eq 2>style="display:none"</cfif>>
													<td  colspan="#cols_#"><strong><cf_get_lang dictionary_id='38053.Başlangıç Sayacı'></strong><input type="text" name="start_counter_#currentrow#"  id="start_counter_#currentrow#" value="#get_type.START_COUNTER#" onkeyup="isNumber(this);"  placeholder="<cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>"> <strong><cf_get_lang dictionary_id='38054.Bitiş Sayacı'></strong><input type="text" name="finish_counter_#currentrow#" id="finish_counter_#currentrow#" value="#get_type.FINISH_COUNTER#" onkeyup="isNumber(this);" placeholder="<cf_get_lang dictionary_id='38054.Bitiş Sayacı'>"></td>
												</tr>
											</cfif>
											<cfif (isdefined("xml_is_material") and xml_is_material eq 1) or (isdefined("xml_is_operation") and xml_is_operation eq 1)>
												<tr id="frm_row_1#currentrow#"<cfif get_type.type eq 2>style="display:none"</cfif>>
													<td >
														<cfif isdefined("xml_is_material") and xml_is_material eq 1><input type="button" name="materials#currentrow#" id="materials#currentrow#" onClick="gizle_goster(open_material_#currentrow#);open_material(#currentrow#,'#wrk_row_id#');" style="font-size:18px;font:bold;width:210px;height:44px;" value="<cf_get_lang dictionary_id='38055.MALZEME İHTİYAÇLARI'>"></cfif>
														<cfif isdefined("xml_is_operation") and xml_is_operation eq 1><input type="button" name="operations#currentrow#" id="operations#currentrow#" onClick="form_operation(#currentrow#,'#wrk_row_id#');" style="font-size:18px;font:bold;width:210px;height:44px;" value="<cf_get_lang dictionary_id='38056.OPERASYONLAR'>"></cfif>
													</td>
												</tr>
											</cfif>
											<tr id="frm_row_2#currentrow#"<cfif get_type.type eq 2>style="display:none"</cfif>>
												<td style="height:100px;text-align:center" colspan="#cols_#" nowrap="nowrap">
													<cfset currentrow_ = currentrow>
													<input type="hidden" name="row_count_1#currentrow#" id="row_count_1#currentrow#" value="">
													<input type="button" name="p_start#currentrow#" id="p_start#currentrow#" <cfif get_type.type eq 1 or get_type.type eq 2>disabled="disabled"</cfif>  style="font-size:18px;font:bold;width:210px;height:44px;" value="<cfif get_type.type eq 1><cf_get_lang dictionary_id='38057.ÜRETİM BAŞLADI'><cfelseif get_type.type eq 0><cf_get_lang dictionary_id='38058.ÜRETİME DEVAM ET'><cfelse><cf_get_lang dictionary_id='38059.ÜRETİME BAŞLA'></cfif>" onclick="production_start(#currentrow#,'#wrk_row_id#');">
													<input type="button" name="p_stop#currentrow#" id="p_stop#currentrow#" <cfif get_type.type eq 0 or get_type.type eq 2>disabled="disabled"</cfif> style="font-size:18px;font:bold;width:210px;height:44px;" value="<cfif get_type.type eq 0><cf_get_lang dictionary_id='38060.ÜRETİM DURDU'><cfelse><cf_get_lang dictionary_id='38061.ÜRETİMİ DURDUR'></cfif>" onclick="production_stop(#currentrow#,'#wrk_row_id#');">
													<input type="button" name="p_finish#currentrow#" id="p_finish#currentrow#" <cfif get_type.type eq 0 or get_type.type eq 2>disabled="disabled"</cfif> style="font-size:18px;font:bold;width:210px;height:44px;" value="<cfif get_type.type eq 2><cf_get_lang dictionary_id='38062.ÜRETİM SONLANDIRILIYOR'><cfelse><cf_get_lang dictionary_id='38063.ÜRETİMİ SONLANDIR'></cfif>" onclick="production_finish(#currentrow#,'#wrk_row_id#');">
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TLFormat(amount)#" readonly="yes" onkeyup="return(FormatCurrency(this,event));" style="font-size:28px;width:150px;height:44px;">
													<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
												</td>
											</tr>
											<tr id="frm_row_3#currentrow#" <cfif get_type.type eq 2>style="display:none"</cfif>>
												<td style="width:40px;"></td>
												<td style="text-align:center" class="box_yazi" nowrap="nowrap"><strong><cf_get_lang dictionary_id='57576.Çalışan'></strong>
													<cf_multiselect_check
														name="employee#currentrow#"
														disabled="disabled"
														query_name ="get_employees"
														option_name="EMPLOYEE"
														option_value="EMPLOYEE_ID"
														width="200"
														value="#get_serial_count.EMPLOYEE_ID#">
													<!---<select name="employee#currentrow#" id="employee#currentrow#" disabled="disabled" multiple="multiple" style="width:200px;height:70px;font-size:18px">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfif get_employees.recordcount>
															<cfloop query="get_employees">
																<option value="#EMPLOYEE_ID#" <cfif EMPLOYEE_ID eq get_serial_count.EMPLOYEE_ID>selected</cfif>>#EMPLOYEE#</option>
															</cfloop>
														</cfif>
													</select>--->
												</td>
												<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
													<td class="box_yazi" style="width:210px;" nowrap="nowrap"><strong><cf_get_lang dictionary_id='58833.Fiziki Varlık'></strong>
														<select name="asset#currentrow#" id="asset#currentrow#" disabled="disabled" style="width:200px;height:25px;font-size:18px">
															<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
															<cfif get_relation_physical_asset.recordcount>
																<cfloop query="get_relation_physical_asset">
																	<option value="#ASSETP_ID#" <cfif assetp_id eq get_serial_count.asset_id>selected</cfif>>#assetp#</option>
																</cfloop>
															</cfif>
														</select>
													</td>
												</cfif>
												<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
													<td class="box_yazi" style="width:60px;"><strong><cf_get_lang dictionary_id='57637.Seri No'></strong></td>
													<td style="width:210px;" nowrap="nowrap">
														<div style="width:200;" id="serial_no_place#currentrow#"></div>
														<input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#wrk_row_id#" />
														<input type="hidden" name="serial_ajax#currentrow#" id="serial_ajax#currentrow#" value="1"/>
													</td>
												</cfif>
												<td style="width:40px;"></td>
											</tr>
											<cfif isdefined("xml_is_material") and xml_is_material eq 1>
												<tr id="frm_row_4#currentrow#" <cfif get_type.type eq 2>style="display:none"</cfif>>
													<td colspan="7"><div style="width:200;" id="open_material_#currentrow#"></div></td>
												</tr>
											</cfif>
										<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
											<cfquery name="get_row_product" datasource="#dsn3#">
												SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,AMOUNT FROM PRODUCTION_ORDER_OPERATIONS_PRODUCT WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_serial_count.WRK_ROW_ID#"> ORDER BY RECORD_DATE DESC
											</cfquery>
											<cfif get_row_product.recordcount>
												<input type="hidden" name="get_row_product#currentrow#" id="get_row_product#currentrow#" value="#get_row_product.recordcount#"/>
												<tr id="frm_row_5#currentrow#" <cfif get_type.type eq 2>style="display:none"</cfif>>		
													<td colspan="5">
														<cf_grid_list>
														<cfloop query="get_row_product">
															<tr>
																<td nowrap="nowrap">
																	<div align="center">
																		<input type="hidden" name="row_kontrol_2#currentrow_#_#currentrow#" id="row_kontrol_2#currentrow_#_#currentrow#" value="#currentrow#">
																		<input type="text" name="amount_product#currentrow_#_#currentrow#" id="amount_product#currentrow_#_#currentrow#" value="#get_row_product.amount#" maxlength="10" onkeyup="return(FormatCurrency(this,event));" title="<cf_get_lang dictionary_id='57635.Miktar'>" style="font-size:22px;width:150px;height:30px;">
																		<input type="hidden" name="product_id#currentrow_#_#currentrow#" id="product_id#currentrow_#_#currentrow#" value="#get_row_product.product_id#">
																		<input  type="hidden" name="stock_id#currentrow_#_#currentrow#" id="stock_id#currentrow_#_#currentrow#" value="#get_row_product.stock_id#">
																		<input type="text" name="product_name#currentrow_#_#currentrow#" id="product_name#currentrow_#_#currentrow#" value="#get_row_product.product_name#" title="<cf_get_lang dictionary_id='57657.Ürün'>" style="font-size:22px;width:450px;height:30px;">
																	</div>
																</td>
															</tr>
														</cfloop>
														</cf_grid_list>
													</td>
												</tr>
											</cfif>
										</cfif>
									</cfoutput>
									</cfif>
								</cf_grid_list>
							</td>
						</tr>									
					</cf_grid_list>
			</cf_grid_list>	
		</cfform>	
	</cf_box>					
	<script type="text/javascript">
		var row_count=<cfoutput>#get_serial_count.recordcount#</cfoutput>;
		document.production_order.record_num.value = row_count;
		function sil(sy)
		{
			var my_element=eval("production_order.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			<cfif (isdefined("xml_is_material") and xml_is_material eq 1) or (isdefined("xml_is_operation") and xml_is_operation eq 1)>
				var my_element_1=eval("frm_row_1"+sy);
				my_element_1.style.display="none";
			</cfif>
			my_element.style.display="none";
			var my_element_2=eval("frm_row_2"+sy);
			my_element_2.style.display="none";
			var my_element_3=eval("frm_row_3"+sy);
			my_element_3.style.display="none";
			var my_element_4=eval("frm_row_4"+sy);
			my_element_4.style.display="none";
			for(i=1;i<=document.getElementById('row_count_1'+sy).value; ++i)
			{
				var my_element_5=eval("production_order.row_kontrol_2"+sy+'_'+i);
				my_element_5.value=0;
				var my_element_5=eval("frm_row_5"+sy+'_'+i);
				my_element_5.style.display="none";
			}
			<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
				var serial_no_ = eval("document.production_order.serial_no"+sy).value;
			<cfelse>
				var serial_no_ = "";
			</cfif>
			var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
			var wrk_row_id = "";
			var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
			wrk_row_id = sy+'_'+p_order_id_+'_'+userid_;
	
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results&wrk_row_id='+wrk_row_id+'&is_del=1&p_order_id='+p_order_id_+'&serial_no='+serial_no_+'',1);	
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results&wrk_row_id='+wrk_row_id+'&is_del=1&p_order_id='+p_order_id_+'&serial_no='+serial_no_+'','list');	
			toplam_kontrol();
		}
		function add_row()
		{
			row_count++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("align","center"); 
			document.production_order.record_num.value=row_count;
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.colSpan = 7;
				newCell.height = "80";
				newCell.style.verticalAlign= 'bottom';
				newCell.align = "center";
				newCell.innerHTML = '<div align="center"><strong><cf_get_lang dictionary_id="38053.Başlangıç Sayacı"></strong><input type="text" name="start_counter_'+row_count+'" id="start_counter_'+row_count+'" value="" onkeyup="isNumber(this);" placeholder="<cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>" style="font-size:26px;width:200px;height:40px;"> <strong><cf_get_lang dictionary_id='38054.Bitiş Sayacı'></strong><input type="text" name="finish_counter_'+row_count+'" id="finish_counter_'+row_count+'" value="" onkeyup="isNumber(this);" placeholder="<cf_get_lang dictionary_id='38054.Bitiş Sayacı'>" style="font-size:26px;width:200px;height:40px;"></div>';
			</cfif>
			<cfif (isdefined("xml_is_material") and xml_is_material eq 1) or (isdefined("xml_is_operation") and xml_is_operation eq 1)>
				newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
				newRow.setAttribute("name","frm_row_1" + row_count);
				newRow.setAttribute("id","frm_row_1" + row_count);
				newRow.setAttribute("align","center");
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.colSpan = 7;
				newCell.height = "80";
				newCell.align = "center";
				newCell.style.verticalAlign= 'bottom';	
				newCell.innerHTML = '<div align="center"><cfif isdefined("xml_is_material") and xml_is_material eq 1><input type="button" name="materials'+row_count+'" id="materials'+row_count+'" style="font-size:18px;font:bold;width:210px;height:44px;color:blue" value="<cf_get_lang dictionary_id='38055.MALZEME İHTİYAÇLARI'>" onClick="gizle_goster(open_material_' + row_count + ');open_material(' + row_count + ');"> </cfif><cfif isdefined("xml_is_operation") and xml_is_operation eq 1><input type="button" name="operations'+row_count+'" id="operations'+row_count+'" onClick="form_operation(' + row_count + ');" style="font-size:18px;font:bold;width:210px;height:44px;color:blue" disabled="disabled" value="<cf_get_lang dictionary_id='38056.OPERASYONLAR'>"> </cfif></div>';
			</cfif>
			newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
			newRow.setAttribute("name","frm_row_2" + row_count);
			newRow.setAttribute("id","frm_row_2" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.colSpan = 7;
			newCell.height = "100";
			newCell.align = "center";
			newCell.innerHTML = '<div align="center"><input type="hidden" name="get_row_product'+row_count+'" id="get_row_product'+row_count+'" value=""/><input type="hidden" name="row_count_1'+row_count+'" id="row_count_1'+row_count+'" value=""><input type="button" name="p_start'+row_count+'" id="p_start'+row_count+'" style="font-size:18px;font:bold;width:210px;height:44px;color:blue" value="<cf_get_lang dictionary_id='38059.ÜRETİME BAŞLA'>" onclick="production_start('+ row_count +');"> <input type="button" name="p_stop'+row_count+'" id="p_stop'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:210px;height:44px;color:blue"value="<cf_get_lang dictionary_id='38061.ÜRETİMİ DURDUR'>" onclick="production_stop(' + row_count + ');"> <input type="button" name="p_finish'+row_count+'" id="p_finish'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:210px;height:44px;color:blue" value="<cf_get_lang dictionary_id='38063.ÜRETİMİ SONLANDIR'>" onclick="production_finish(' + row_count + ');"> <input type="text" name="amount'+row_count+'" id="amount'+row_count+'" value="1" <cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>readonly</cfif> style="font-size:28px;width:150px;height:44px;" onkeyup="return(FormatCurrency(this,event));"><input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a onclick="sil(' + row_count + ');"><span  class="icn-md fa fa-minus"></span></a></div>';
			//newCell = newRow.insertCell(newRow.cells.length);
			//newCell.innerHTML = '';
			newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
			newRow.setAttribute("name","frm_row_3" + row_count);
			newRow.setAttribute("id","frm_row_3" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.width = "40";
			newCell.innerHTML = '<td></td>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.fontSize = "16px";
			newCell.style.fontWeight = "bold";
			newCell.align = "center";
			newCell.setAttribute("nowrap","nowrap");
				b = '<div style="font-size:16px" align="center"><cf_get_lang dictionary_id="57576.Çalışan"><select name="employee' + row_count  +'" id="employee' + row_count  +'" class="multiColmn" multiple="multiple" style="width:200px;height:70px;font-size:18px">';
				<cfif get_employees.recordcount>
					<cfoutput query="get_employees">
						if('#employee_id#' == #session.ep.userid#)
							b += '<option value="#employee_id#" selected>#employee#</option>';
						else
							b += '<option value="#employee_id#">#employee#</option>';
					</cfoutput>
				</cfif>
				newCell.innerHTML =b+ '</select></div>';
				newCell.width = "700";
				try{
					$(".multiColmn")
						.multiselect({
							minWidth:200, 
							checkAllText:" <cf_get_lang dictionary_id="58693.Seç"> ",
							uncheckAllText:" <cf_get_lang dictionary_id="29695.Kaldır"> ",
							noneSelectedText: '<cf_get_lang dictionary_id="57734.Seçiniz">',
							selectedText: '# / # <cf_get_lang dictionary_id="29808.Kayıt Seçildi"> '
						});
						$(".multiColmn").multiselect();
						$(".multiColmn").multiselect({
						open: function () {
							$("input[type='search']").focus();                   
						}
					});
					var $widget = $(".multiColmn").multiselect(),  
					state = true;
				}catch(err){};
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.fontSize = "16px";
				newCell.width = "210";
				newCell.style.fontWeight = "bold";
				newCell.setAttribute("nowrap","nowrap");
					c = '<cf_get_lang dictionary_id="58833.Fiziki Varlık"><select name="asset' + row_count  +'" id="asset' + row_count  +'" style="width:200px;height:25px;font-size:18px">';
					<cfif get_relation_physical_asset.recordcount>
						<cfoutput query="get_relation_physical_asset">
							c += '<option value="#ASSETP_ID#">#ASSETP#</option>';
						</cfoutput>
					</cfif>
					newCell.innerHTML =c+ '</select>';
			</cfif>
			<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.fontSize = "16px";
				newCell.style.fontWeight = "bold";
				newCell.width = "60";
				newCell.innerHTML = '<td><cf_get_lang dictionary_id='57637.Seri No'></td>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.width = "210";
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style="width:200;" id="serial_no_place'+row_count+'"></div>';
			</cfif>
			<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<td><a href="javascript://" style="vertical-align:bottom" onclick="add_product_row('+ row_count +');"><span class="icn-md icon-add" border="0"></span></a></td>';
			</cfif>
			newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
			newRow.setAttribute("name","frm_row_4" + row_count);
			newRow.setAttribute("id","frm_row_4" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.colSpan = 7;
			newCell.innerHTML = '<td><div style="width:200;" id="open_material_' + row_count  +'"></div></td>';
			toplam_kontrol();
			serial_control(row_count,2);
		}
	
		var row_count_2=0;
		document.getElementById('record_num_2').value = row_count_2;
		function add_product_row(no)
		{
			if (document.getElementById('record_num').value > no)
			{
				alert("<cf_get_lang dictionary_id='38064.Farklı Üretim Satırı Bulunduğu için Ürün Ekleyemezsiniz'>!");
				return false;
			}
			row_count_2++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("cf_grid_list1").insertRow(document.getElementById("cf_grid_list1").rows.length);
			newRow.setAttribute("name","frm_row_5" + no + "_" + row_count_2);
			newRow.setAttribute("id","frm_row_5" + no + "_" +  row_count_2);
			newRow.setAttribute("align","center");
			document.getElementById('record_num_2').value=row_count_2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.height = "55";
			newCell.colSpan = 6;//alert(no);alert(row_count_2);
			document.getElementById('row_count_1'+no).value = row_count_2;
			newCell.innerHTML = '<div align ="center"> <input type="hidden" name="row_kontrol_2'+no+'_' +row_count_2+'" id="row_kontrol_2'+no+'_' +row_count_2+'" value="1"><input type="text" name="amount_product'+no+'_' +row_count_2+'" id="amount_product'+no+'_' +row_count_2+'" value="1" maxlength="10" onkeyup="return(FormatCurrency(this,event));" title="<cf_get_lang dictionary_id='57635.Miktar'>" style="font-size:22px;width:100px;height:30px;"><input type="hidden" name="product_id'+no+'_' +row_count_2+'" id="product_id'+no+'_' +row_count_2+'" value=""><input  type="hidden" name="stock_id'+no+'_' +row_count_2+'" id="stock_id'+no+'_' +row_count_2+'" value=""><input type="text" name="product_name'+no+'_' +row_count_2+'" value="" id="product_name'+no+'_' +row_count_2+'" title="<cf_get_lang dictionary_id='57657.Ürün'>" style="font-size:22px;width:450px;height:30px;" style="width:145px;" value=""><ul class="ui-icon-list"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count_2+"').value+'&sid='+document.getElementById('stock_id"+row_count_2+"').value+'','list');"+'"><span class="input-group-addon icon-ellipsis"  alt="<cf_get_lang dictionary_id='32848.Ürün Detay'>" style="display:none;" id="product_info'+no+'_' +row_count_2+'"></span></a><li><a href="javascript://" onClick="pencere_ac_product('+no+','+ row_count_2 +');"> <span class="input-group-addon icon-ellipsis"></span></a></li><li><a onclick="sil_product('+no+','+ row_count_2 +');"><span  class="icn-md fa fa-minus"></span></a></li></ul></div>';
		}
		function pencere_ac_product(no,row_)
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=all.product_id'+no+'_'+row_+'&field_id=all.stock_id'+no+'_'+row_+'&field_name=all.product_name'+no+'_'+row_);
		}
	
		function toplam_kontrol()
		{	
			var row_no=0;
			row_no=document.getElementById('record_num').value;
			total_amount(row_no);
			return true;
		}
		function total_amount(no)
		{	
			var toplam_1=0;
			for(var i=1; i <= no; i++)
			{
				if(eval("document.getElementById('amount'+i)").value != '' && eval("document.production_order.row_kontrol"+i).value == 1)
				{
					var ara_toplam=filterNum(eval("document.getElementById('amount'+i)").value,2);
					if(ara_toplam!= null && ara_toplam.value != "")
					{
						toplam_1 = parseFloat(toplam_1 + parseFloat(ara_toplam));
						document.production_order.toplam_tutar.value=toplam_1;
					}
				}
			}
		}
	
		function sil_product(no,row_)
		{
			var my_element_5=eval('production_order.row_kontrol_2'+no+'_'+row_);
			my_element_5.value=0;
			var my_element_5=eval('frm_row_5'+no+'_'+row_);
			my_element_5.style.display="none";
		}
		
		function control()
		{
			var production_count = 0;
			for(i=1;i<=document.getElementById('record_num').value;++i)
			{
				if(document.getElementById('frm_row_2'+i).style.display =='')
					var production_count = parseFloat(production_count) + parseFloat(filterNum(eval("document.getElementById('amount'+i)").value,2));	
					//document.production_order.last_amount.value=production_count;
			} 
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				if(document.getElementById('remaining').value <= production_count)
				{

					alert("<cf_get_lang dictionary_id='38065.Satırlardaki Toplam Miktar Kalan Miktardan Fazla'>!");
					return false;
				}
			</cfif>
			add_row();
		}
		function control2()
		{
			var production_count_ = 0;
			for(i=1;i<=document.getElementById('record_num').value;++i)
			{
				if(document.getElementById('frm_row_2'+i).style.display =='')
					var production_count_ = parseFloat(production_count_) + parseFloat(filterNum(document.getElementById('amount'+i).value,2));
			} 
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				if(document.getElementById('remaining').value < production_count_)
				{
					alert("<cf_get_lang dictionary_id='38065.Satırlardaki Toplam Miktar Kalan Miktardan Fazla'>!");
					return false;
				}
			</cfif>
			return true;
		}
		function addLoadEvent(func)
		{
			var oldonload = window.onload;
			if (typeof window.onload != 'function')
			{
				window.onload = func;
			}
			else
			{
				window.onload = function() 
				{
					if (oldonload)
					{
						oldonload();
					}
					func();
				}
			}
		}
		addLoadEvent
		(
			function bbb() 
			{
				if(document.getElementById('count_') != undefined)
				{
					var record_count = document.getElementById('count_').value;
					for(rr=1;rr<=record_count;rr++)
					{
						if(document.getElementById('serial_ajax'+rr) != undefined && document.getElementById('serial_ajax'+rr).value == 1)
						serial_control(rr,1);
					}
				}
			}
		)
		function serial_control(no,type)
		{
			if(document.getElementById('wrk_row_id_'+no) != undefined)
			var _wrkrowid_ = document.getElementById('wrk_row_id_'+no).value;
			var send_address = "<cfoutput>#request.self#?fuseaction=production.emptypopup_get_serial_no_ajax&p_order_id=#attributes.upd#&p_order_no=#get_order.p_order_no#</cfoutput>&wrk_row_id="+_wrkrowid_+"&row_="+no+"&type=";
			send_address += type;
			AjaxPageLoad(send_address,'serial_no_place'+no);
		}	
		function serialno_control(no)
		{
			for(yy=1;yy<=document.getElementById('record_num').value;yy++)
			{
				if(yy!= no)
				{
					if(document.getElementById('serial_no'+yy).value == document.getElementById('serial_no'+no).value)
					{
						alert("<cf_get_lang dictionary_id='38066.Seçilen Seri No Kullanılmıştır'>!");
						document.getElementById('serial_no'+no).value ="";
					}
				}
			}
		}
		function production_start(no,wrkrow)
		{//üretime başla denilmiş ise
			if(control2())
			{
				/*var last__ = parseFloat(document.getElementById('last_amount').value) + parseFloat(filterNum(eval("document.getElementById('amount'+no)").value,2));
				if(document.getElementById('remaining').value < last__)
				{
					alert("Satırlardaki Toplam Miktar Kalan Miktardan Fazla!");
					return false;
				}*/
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang dictionary_id='38067.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38068.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang dictionary_id='58835.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38069.Miktar Girmelisiniz'>!");
					return false;
				}
				document.getElementById('p_finish'+no+'').disabled=false;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
				document.getElementById('p_stop'+no+'').disabled=false;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=false;
				</cfif>
				my_temp_name = '#employee'+no;
				var employee_ =$(my_temp_name).val();
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					var serial_no_ = eval("document.getElementById('serial_no'+no)").value;
				<cfelse>
					var serial_no_ = "";
				</cfif>
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					var asset_id_ = eval("document.getElementById('asset'+no)").value;
				<cfelse>
					var asset_id_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var url='';
				<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
					for(i=1;i<=row_count_2;++i)
					{
						if(document.getElementById('product_id'+no+'_'+i).value !='' && document.getElementById('stock_id'+no+'_'+i).value !='' && document.getElementById('amount_product'+no+'_'+i).value !='')
						{
							product_id_ = document.getElementById('product_id'+no+'_'+i).value;
							stock_id_ = document.getElementById('stock_id'+no+'_'+i).value;
							product_name_ = document.getElementById('product_name'+no+'_'+i).value;
							amount_value_ = document.getElementById('amount_product'+no+'_'+i).value;
							amount_product_ = filterNum(amount_value_,'#session.ep.our_company_info.rate_round_num#');
							row_kontrol_ = document.getElementById('row_kontrol_2'+no+'_'+i).value;
							row_ = no +'_'+i;
							url += '&product_id'+row_+'='+product_id_+'&stock_id'+row_+'='+stock_id_+'&product_name'+row_+'='+product_name_+'&amount'+row_+'='+amount_product_+'&row_kontrol'+row_+'='+row_kontrol_+'';
						}
						else
						{
							alert(i+'. <cf_get_lang dictionary_id="38070.Satırda bilgiler eksik">');
							return false;
						}
					}
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results'+url+'&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'');	
				//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results'+url+'&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'','list');	
				document.getElementById('p_start'+no+'').value = "<cf_get_lang dictionary_id='38057.ÜRETİM BAŞLADI'>";
				document.getElementById('p_stop'+no+'').value = "<cf_get_lang dictionary_id='38061.ÜRETİMİ DURDUR'>";
				document.getElementById('p_start'+no+'').disabled=true;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
				document.getElementById('p_stop'+no+'').disabled=false;
				document.getElementById('employee'+no+'').disabled=true;
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					document.getElementById('asset'+no+'').disabled=true;
				</cfif>
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					document.getElementById('serial_no'+no+'').disabled=true;
				</cfif>
				alert("<cf_get_lang dictionary_id='38039.Üretimler Başlatıldı'>!");
			}
			else
				return false;
		}
		
		function production_stop(no,wrkrow)
		{//üretimi durdur
			if(control2())
			{
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				<cfif get_prod_pause_type.recordcount eq 0>
					alert("<cf_get_lang dictionary_id='38071.Ürün Kategorisinde Duraklama Tipi Tanımlı Değil! Duraklama Tipi Tanımlayınız'>!");
					return false;
				</cfif>
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang dictionary_id='38067.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38068.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang dictionary_id='58835.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38069.Miktar Girmelisiniz'>!");
					return false;
				}
				document.getElementById('p_stop'+no+'').disabled=true;
				document.getElementById('p_finish'+no+'').disabled=true;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=true;
				</cfif>
				document.getElementById('p_start'+no+'').disabled=false;
				document.getElementById('p_stop'+no+'').value = 'ÜRETİM DURDU';
				document.getElementById('p_start'+no+'').value = 'ÜRETİME DEVAM ET';
				my_temp_name = '#employee'+no;
				var employee_ =$(my_temp_name).val();
				//var employee_ = eval("document.getElementById('employee'+no)").value;
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					var serial_no_ = eval("document.getElementById('serial_no'+no)").value;
				<cfelse>
					var serial_no_ = "";
				</cfif>
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					var asset_id_ = eval("document.getElementById('asset'+no)").value;
				<cfelse>
					var asset_id_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				var product_catid_ = '<cfoutput>#get_order.PRODUCT_CATID#</cfoutput>'; //Ürün Kategorisi
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_prod_operations&is_oper_row=0&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&is_del=0&type=0&p_order_id='+p_order_id_+'&product_catid='+product_catid_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'','small');
			}
			else
				return false;
		}
		
		function production_finish(no,wrkrow)
		{//üretimi sonlandır
			if(control2())
			{
				if(!chk_process_cat('production_order')) return false;
				if(!process_cat_control()) return false;
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				url_= '/V16/production/cfc/get_production_operations.cfc?method=get_production_operation_control&wrk_row_id='+ encodeURIComponent(wrk_row_id_);		
				prod_operation = 0;
				$.ajax({
						url: url_,
						dataType: "text",
						cache:false,
						async: false,
						success: function(read_data) {
						data_ = jQuery.parseJSON(read_data);
						if(data_.DATA.length != 0)
						{
							alert("<cf_get_lang dictionary_id='38072.Sonlandırılmamış Operasyonlar Bulunmaktadır'>!");
							prod_operation = 1;
							//return false;
						}
					}
				});
				if(prod_operation == 1)
					return false;
				
				/*var get_operation_control = wrk_query("SELECT WRK_ROW_ID FROM P_ORDER_OPERATIONS_ROW WHERE P_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM P_ORDER_OPERATIONS_ROW POR WHERE P_ORDER_OPERATIONS_ROW.WRK_ROW_ID = POR.WRK_ROW_ID AND TYPE IN (2)) AND WRK_ROW_RELATION_ID = '"+wrk_row_id_+"'","dsn3");	
				alert(get_operation_control.recordcount);
				if(get_operation_control.recordcount)
				{
					alert("<cf_get_lang dictionary_id='38072.Sonlandırılmamış Operasyonlar Bulunmaktadır'>!");
					return false;
				}*/
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang dictionary_id='38067.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38068.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang dictionary_id='58835.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='38069.Miktar Girmelisiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					if (eval("document.getElementById('start_counter_'+no)").value != '' && eval("document.getElementById('finish_counter_'+no)").value == '')
					{
						alert("<cf_get_lang dictionary_id='38073.Bitiş Sayacı Giriniz'>!");
						return false;
					}
				</cfif>
				var j_url_str = "" ;//
				var process_cat = document.getElementById('process_cat').length//işlem kategorisi
				if(process_cat < 2){
					alert("<cf_get_lang dictionary_id='38074.Bu İşlemi Yapabilmek İçin İşlem Kategorisine Yetkili Olmalısınız'>!");
					return false;
				}
				process_cat = document.getElementById('process_cat').value;
				var process_stage= document.getElementById('process_stage').value;//Süreç
				if(process_stage == ""){
					alert("<cf_get_lang dictionary_id='38075.Bu İşlemi Yapabilmek İçin Sürece Yetkili Olmasılısınız'>!");
					return false;
				}
				<cfif get_prod_pause_type.recordcount>
					var pause_type_id = '<cfoutput>#get_prod_pause_type.PROD_PAUSE_TYPE_ID#</cfoutput>'; //duraklama tipi
				<cfelse>
					var pause_type_id = '';
				</cfif>
				j_url_str +='&process_cat='+process_cat+'&process_stage='+process_stage+'';
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById('p_stop'+no+'').disabled=true;
				document.getElementById('p_start'+no+'').disabled=true;
				document.getElementById('p_finish'+no+'').disabled=true;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=true;
				</cfif>
				document.getElementById('p_finish'+no+'').value = "<cf_get_lang dictionary_id='38062.ÜRETİM SONLANDIRILIYOR'>";
				var product_url='';
				<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
					if (document.getElementById('get_row_product'+no) != undefined && document.getElementById('get_row_product'+no).value != '')
					{
						var row_count_2 = document.getElementById('get_row_product'+no).value;
					}
					else
					{
						var row_count_2 = document.getElementById('record_num_2').value;
					}
					for(i=1;i<=row_count_2;++i)
					{
						if(document.getElementById('product_id'+no+'_'+i).value !='' && document.getElementById('stock_id'+no+'_'+i).value !='' && document.getElementById('amount_product'+no+'_'+i).value !='')
						{
							stock_id_ = document.getElementById('stock_id'+no+'_'+i).value;
							amount_value_ = document.getElementById('amount_product'+no+'_'+i).value;
							amount_product_ = filterNum(amount_value_,'#session.ep.our_company_info.rate_round_num#');
							row_kontrol_ = document.getElementById('row_kontrol_2'+no+'_'+i).value;
							row_ = no +'_'+i;
							product_url += '&stock_id'+row_+'='+stock_id_+'&amount'+row_+'='+amount_product_+'&row_kontrol'+row_+'='+row_kontrol_+'';
						}
						else
						{
							alert(i+'. <cf_get_lang dictionary_id="38070.Satırda bilgiler eksik">');
							return false;
						}
					}
				</cfif>
				str_ = "";
				// üretim sonuçları xml i gönderiliyor PY
				<cfloop query="GET_PROD_RESULT_XML">
					str_ = str_ + <cfoutput>'&#PROPERTY_NAME#=#PROPERTY_VALUE#'</cfoutput>;
				</cfloop>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_prod_order_result_group&employee='+eval("document.getElementById('employee'+no)").value+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&is_prod=1&no='+no+'&type=2'+j_url_str+'&p_order_id_list='+p_order_id_+'&amount='+amount_+'&pause_type_id='+pause_type_id+''+product_url+''+str_,'prod_order',1);	
				//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_prod_order_result_group&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&is_prod=1&no='+no+'&type=2'+j_url_str+'&p_order_id_list='+p_order_id_+'&pause_type_id='+pause_type_id+''+product_url+'','list');	
			}
			else
				return false;
		}
		function open_order()
		{  
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_production_orders_list','open_order_',1);
		}
		function open_material(no)
		{  
			var this_production_amount = '<cfoutput>#get_order.QUANTITY#</cfoutput>';
			var send_material_address = "<cfoutput>#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&p_order_id=#attributes.upd#&stock_id=#get_order.STOCK_ID#&order_amount=#get_order.quantity#&spect_main_id=#get_order.SPEC_MAIN_ID#&spect_var_id=#get_order.SPECT_VAR_ID#&from_upd_production_page=1&this_production_amount=#get_order.QUANTITY#&is_production=1</cfoutput>";
			AjaxPageLoad(send_material_address,'open_material_'+no);
		}
		function form_operation(no,wrkrow)
		{
			if(control2())
			{
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				var production_amount_ = '<cfoutput>#get_order.QUANTITY#</cfoutput>';
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				windowopen('<cfoutput>#request.self#?fuseaction=production.form_add_production_operation&production_amount='+production_amount_+'&wrk_row_id='+wrk_row_id_+'&prod_id=#attributes.upd#</cfoutput>','longpage');
			}
			else
				return false;
		}
	</script>
</cfif>
    