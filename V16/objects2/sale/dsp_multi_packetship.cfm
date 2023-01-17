<cfsetting showdebugoutput="no">
<cfset x_equipment_planning_info = 1>
<!--- 
	Not : SHIP_RESULT tablosundaki IS_TYPE alani siparis detayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
		O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
	Not 2: Bu sayfada dogtas icin xml e bagli degisiklikler yapildi, bana danisilabilir FBS 20091101
 --->
<cfquery name="GET_SHIP_RESULTS_ALL" datasource="#DSN2#">
	SELECT
		SR.*,
		SM.SHIP_METHOD
	FROM
		SHIP_RESULT SR,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		SR.MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_ship_fis_no#"> AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
        AND SR.SHIP_RESULT_ID IN(	SELECT
                                    	SHIP_RESULT_ID
									FROM
										SHIP_RESULT_ROW SRR,
										#dsn3_alias#.ORDERS O
									WHERE
										SRR.ORDER_ID = O.ORDER_ID
										AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                           		 )
	ORDER BY
		SR.SHIP_RESULT_ID		
</cfquery>
<cfquery name="GET_SHIP_RESULT" dbtype="query" maxrows="1">
	SELECT * FROM GET_SHIP_RESULTS_ALL ORDER BY SHIP_RESULT_ID DESC
</cfquery>

<cfif not GET_SHIP_RESULT.recordcount>
<script language="JavaScript">
	alert("Şirketinize ait böyle bir sevkiyat kaydı bulunmamaktadır!");
	history.back();
</script>
<cfabort>
</cfif>

<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
	<cfoutput>
	<tr class="color-row">
		<td valign="top">
		<table width="100%">
			<tr height="15%">
				<td width="100" class="txtboldblue"><cf_get_lang_main no='70.Aşama'></td>
				<td width="210">
                	<cfquery name="get_process" datasource="#dsn#">
                        SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.ship_stage#">
                    </cfquery>
                    #get_process.stage#
                </td>
				<td width="110" class="txtboldblue"><cf_get_lang no='454.Sevkiyat No'></td>
				<td>#get_ship_result.main_ship_fis_no#</td>
                <!-- sil --> <td align="right" rowspan="2"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'></td> <!-- sil --> 
			</tr>  
			<tr>
				<td class="txtboldblue"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
				<td><cfif Len(get_ship_result.ship_method_type)>#get_ship_result.ship_method#</cfif></td>
				<td class="txtboldblue"><cf_get_lang_main no='1382.Referans No'></td>
				<td>#get_ship_result.reference_no#</td>
			</tr>
			<tr>
				<td class="txtboldblue"><cf_get_lang_main no='304.Tasiyici'></td>
				<td>#get_par_info(get_ship_result.service_company_id,1,0,0)#</td>
				<cfif x_equipment_planning_info eq 0>
					<td class="txtboldblue"><cf_get_lang_main no='304.Tasiyici'><cf_get_lang_main no='468.Belge No'></td>
					<td>#get_ship_result.deliver_paper_no#</td>
				<cfelse>
					<cfquery name="get_planning_info" datasource="#dsn3#">
						SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.equipment_planning_id#">
					</cfquery>
					<td class="txtboldblue">Ekip-Araç *</td>
					<td>#get_planning_info.team_code#</td>
				</cfif>
			</tr>
			<tr>
				<td class="txtboldblue"><cf_get_lang no='1462.Tasiyici Yetkilisi'></td>
				<td>#get_par_info(get_ship_result.service_member_id,0,-1,0)#</td>
				<cfif x_equipment_planning_info eq 0>
					<td class="txtboldblue"><cf_get_lang_main no='233.Teslim Tarih'></td>
					<td>#dateformat(get_ship_result.delivery_date,'dd/mm/yyyy')# - #hour(get_ship_result.delivery_date)#:#minute(get_ship_result.delivery_date)#</td>
				<cfelse>
					<td rowspan="2" valign="top" class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
					<td rowspan="2" valign="top">#get_ship_result.note#</td>
				</cfif>
			</tr>
			<tr>
				<cfif x_equipment_planning_info eq 0>
					<td class="txtboldblue"><cf_get_lang no='285.Arac'></td>
					<td><cfif len(get_ship_result.assetp_id)>
							<cfquery name="GET_ASSETP" datasource="#DSN#">
								SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.assetp_id#">
							</cfquery>
                            #get_assetp.assetp#
						</cfif>
					</td>
				</cfif>
				<td class="txtboldblue"><cf_get_lang_main no='1631.Depo Çıkış'></td>
				<td>#dateformat(get_ship_result.out_date,'dd/mm/yyyy')# - #hour(get_ship_result.out_date)#:#minute(get_ship_result.out_date)#</td>
			</tr>
			<tr>
				<cfif x_equipment_planning_info eq 0>
					<td class="txtboldblue"><cf_get_lang no='481.Arac Yetkilisi'></td>
					<td>#get_emp_info(get_ship_result.deliver_emp,0,0)#</td>
				</cfif>
				<td class="txtboldblue"><cfif x_equipment_planning_info eq 0><cf_get_lang no='455.Teslim Eden'><cfelse>Planlayan</cfif></td>
				<td>#get_emp_info(get_ship_result.deliver_pos,0,0)#</td>
			</tr>
			<tr>
				<cfif x_equipment_planning_info eq 0>
					<td class="txtboldblue"><cf_get_lang_main no='1656.Plaka'></td>
					<td>#get_ship_result.plate#</td>
				</cfif>
				<td class="txtboldblue"><cf_get_lang_main no='1631.Cikis Depo'></td>
				<td><cfset location_info_ = get_location_info(get_ship_result.department_id,get_ship_result.location_id,1,1)>
					<cfset department_head_ = "">
					<cfif len(get_ship_result.department_id)>
						<cfquery name="get_department" datasource="#dsn#">
							SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.department_id#">
						</cfquery>
						<cfset department_head_ = get_department.department_head>
					</cfif>
					#listfirst(location_info_,',')#
				</td>
			</tr>
			<cfif x_equipment_planning_info eq 0>
				<tr>
					<td rowspan="2" valign="top" class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
					<td rowspan="2" valign="top">#get_ship_result.note#</td>
					<td>Hesaplama Yöntemi</td>
					<td><input type="radio" name="calculate_type" id="calculate_type" disabled="disabled" value="1" <cfif get_ship_method_price.calculate_type eq 1>checked</cfif>><cf_get_lang no='370.Kümülatif'>&nbsp;
						<input type="radio" name="calculate_type" id="calculate_type" disabled="disabled" value="2" <cfif get_ship_method_price.calculate_type eq 2>checked</cfif>><cf_get_lang no='371.Paket'>
					</td>	
				</tr>
				<tr>
					<td class="txtboldblue"><cf_get_lang_main no ='80.Toplam'><cf_get_lang no='1461.Maliyet Tutari'></td>
					<td>#TlFormat(sum_ship_result.cost_value)#&nbsp;#session_base.money#
						#TlFormat(sum_ship_result.cost_value2)#&nbsp;#session_base.money2#
					</td>			
				</tr>
			</cfif>		
			</cfoutput>
		</table>
		</td>
	</tr>
	<cfquery name="GET_ROW" datasource="#DSN2#">
		SELECT 
			SRW.*,
			ISNULL(SRW.ORDER_ROW_AMOUNT,0) ORDER_ROW_AMOUNT_,
			ISNULL(SRW.SHIP_RESULT_ROW_AMOUNT,0) SHIP_ROW_AMOUNT_,
			SR.COMPANY_ID,
			SR.PARTNER_ID,
			SR.CONSUMER_ID,
			SR.COST_VALUE,
			SR.COST_VALUE2,
			SR.SHIP_FIS_NO
		FROM
			SHIP_RESULT_ROW SRW,
			SHIP_RESULT SR
		WHERE 
			SRW.SHIP_RESULT_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
			SRW.SHIP_RESULT_ID = SR.SHIP_RESULT_ID AND
            SRW.ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
		ORDER BY
			SR.SHIP_RESULT_ID
	</cfquery>
	<tr class="color-row">
		<td>
		<table id="table1" width="100%">
			<cfif x_equipment_planning_info eq 0>
			<cfelse><!--- Siparis --->
				<tr class="color-list" height="20">
					<td width="75" class="txtboldblue">Sipariş No</td>
					<td width="80" class="txtboldblue">Sipariş Tarihi</td>
					<cfif isdefined('attributes.is_order_deliver') and attributes.is_order_deliver eq 1><td width="80" class="txtboldblue">Teslim Tarihi</td></cfif>
					<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1><td width="80" class="txtboldblue" align="center">Stok Kodu</td></cfif>
					<td class="txtboldblue">Ürün</td>
					<cfif isdefined('attributes.is_order_head') and attributes.is_order_head eq 1><td class="txtboldblue">Sipariş Konusu</td></cfif>
					<td class="txtboldblue">Spec</td>
					<cfif isdefined('attributes.is_order_desc') and attributes.is_order_desc eq 1><td class="txtboldblue">Açıklama</td></cfif>
					<td width="50" align="right" class="txtboldblue">Plan</td>
					<td width="50" align="right" class="txtboldblue">Yüklenen</td>
					<td class="txtboldblue">Belge</td>
				</tr>
				<cfset Diff_Amount_ = 0>
				<cfoutput query="get_row">
					<tr>
						<cfquery name="Get_Orders_Info" datasource="#dsn3#">
							SELECT
								O.ORDER_ID,
								O.PURCHASE_SALES,
								O.ORDER_ZONE,
								O.ORDER_NUMBER,
								O.ORDER_DATE,
								O.COMPANY_ID,
								O.CONSUMER_ID,
								O.ORDER_HEAD,
								ISNULL(OW.DELIVER_DATE,O.DELIVERDATE) DELIVER_DATE_,
								OW.ORDER_ROW_ID,
								OW.WRK_ROW_ID,
								OW.PRODUCT_NAME,
								OW.SPECT_VAR_ID,
								OW.SPECT_VAR_NAME,
								OW.PRODUCT_NAME2,
								S.STOCK_CODE,
								(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE
							FROM
								ORDERS O,
								STOCKS S,
								ORDER_ROW OW
							WHERE
								OW.STOCK_ID = S.STOCK_ID AND
								O.ORDER_ID = OW.ORDER_ID AND
								OW.ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
						</cfquery>
						<td>#Get_Orders_Info.Order_Number#</td>
						<td align="center">#DateFormat(Get_Orders_Info.Order_Date,'dd/mm/yyyy')#</td>
						<cfif isdefined('attributes.is_order_deliver') and attributes.is_order_deliver eq 1><td align="center">#DateFormat(Get_Orders_Info.Deliver_Date_,'dd/mm/yyyy')#</td></cfif>
						<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1><td align="center">#Get_Orders_Info.Stock_Code#</td></cfif>
						<td>#Get_Orders_Info.Product_Name#</td>
						<cfif isdefined('attributes.is_order_head') and attributes.is_order_head eq 1><td>#Get_Orders_Info.Order_Head#</td></cfif>
						<td><cfif len(Get_Orders_Info.spect_var_name) and Get_Orders_Info.spect_var_name neq Get_Orders_Info.PRODUCT_NAME>#Get_Orders_Info.Spect_Var_Name#</cfif></td>
						<cfif isdefined('attributes.is_order_desc') and attributes.is_order_desc eq 1><td class="txtboldblue">#Get_Orders_Info.Product_Name2#</td></cfif>
						<td align="right">#TLFormat(get_row.Order_Row_Amount)#</td>
						<td align="right">#TLFormat(SHIP_RESULT_ROW_AMOUNT)#</td>
						<td nowrap>
							<cfquery name="Get_Ship_Info" datasource="#dsn2#">
								SELECT PURCHASE_SALES,SHIP_ID,SHIP_NUMBER FROM SHIP WHERE SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_orders_info.wrk_row_id#"> AND AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#get_row.ship_row_amount_#">) AND SHIP_ID = <cfif len(Ship_Id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#"><cfelse>0</cfif>
							</cfquery>
							<cfif Len(Get_Ship_Info.Ship_Id) and is_problem neq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_detail_ship&ship_id=#Get_Ship_Info.Ship_Id#','list','popup_detail_ship');" class="tableyazi">#Get_Ship_Info.Ship_Number#</a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</cfif>
		</table>
		</td>
	</tr>
</table>
