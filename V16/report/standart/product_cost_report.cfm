<!--- Urun Maliyet Raporu FBS 20110906 --->
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.station_name" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.prod_order" default="">
<cfparam name="attributes.prod_order_number" default="">
<cfif isdefined("attributes.submitted")>
	<cfif isDate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isDate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	<cfquery name="Get_Production_Orders_Main" datasource="#dsn3#"><!--- TYPE : 1 ana urun / 2 sarf / 3 fire --->
		SELECT
			TYPE,
			ISNULL(SUM(AMOUNT),0) AMOUNT,
			ISNULL(SUM(PRODUCT_COST),0) PRODUCT_COST,
			ISNULL(SUM(REFLECTION_COST),0) REFLECTION_COST,
			ISNULL(SUM(LABOR_COST),0) LABOR_COST,
			PRODUCT_ID,
			STOCK_CODE,
			NAME_PRODUCT,
			UNIT_NAME,
			SPECT_MAIN_ID
		FROM
			(
				SELECT
					1 TYPE,
					SUM(PORR.AMOUNT) AMOUNT,
					SUM((PORR.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*PORR.AMOUNT) PRODUCT_COST,
					SUM(PORR.STATION_REFLECTION_COST_SYSTEM*PORR.AMOUNT) REFLECTION_COST,
					SUM(PORR.LABOR_COST_SYSTEM*PORR.AMOUNT) LABOR_COST,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					(SELECT PO.SPEC_MAIN_ID FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) SPECT_MAIN_ID,
					S.PRODUCT_NAME AS NAME_PRODUCT,
					PORR.UNIT_NAME
				FROM
					STOCKS S,
					PRODUCTION_ORDER_RESULTS POR,
					PRODUCTION_ORDER_RESULTS_ROW PORR
				WHERE
					PORR.TYPE = 1 AND
					(SELECT PO.IS_DEMONTAJ FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) = 0 AND
					<cfif Len(attributes.startdate)>
						POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					</cfif>
					<cfif Len(attributes.finishdate)>
						POR.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finishdate)#"> AND
					</cfif>
					<cfif ListLen(attributes.station_name) and ListLen(attributes.station_id)>
						POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#" list="yes">) AND
					</cfif>
					<cfif isdefined("attributes.product_id") and Len(attributes.product_id) and len(attributes.product_name)>
						S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
					</cfif>
					<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
						S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%"> AND
					</cfif>
					<cfif isdefined("attributes.prod_order_number") and Len(attributes.prod_order_number) and len(attributes.prod_order)>
						POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_order_number#"> AND
					</cfif>
					S.STOCK_ID = PORR.STOCK_ID AND
					POR.PR_ORDER_ID = PORR.PR_ORDER_ID
				GROUP BY
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PRODUCT_NAME,
					PORR.UNIT_NAME,
					POR.P_ORDER_ID
				
				UNION ALL
				
				SELECT
					2 TYPE,
					SUM(PORR.AMOUNT) AMOUNT,
					SUM((PORR.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*PORR.AMOUNT) PRODUCT_COST,
					SUM(PORR.STATION_REFLECTION_COST_SYSTEM*PORR.AMOUNT) REFLECTION_COST,
					SUM(PORR.LABOR_COST_SYSTEM*PORR.AMOUNT) LABOR_COST,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					(SELECT PO.SPEC_MAIN_ID FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) SPECT_MAIN_ID,
					S.PRODUCT_NAME AS NAME_PRODUCT,
					PORR.UNIT_NAME
				FROM
					STOCKS S,
					PRODUCTION_ORDER_RESULTS POR,
					PRODUCTION_ORDER_RESULTS_ROW PORR
				WHERE
					PORR.TYPE = 2 AND
					(SELECT PO.IS_DEMONTAJ FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) = 0 AND
					<cfif Len(attributes.startdate)>
						POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					</cfif>
					<cfif Len(attributes.finishdate)>
						POR.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finishdate)#"> AND
					</cfif>
					<cfif ListLen(attributes.station_name) and ListLen(attributes.station_id)>
						POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#" list="yes">) AND
					</cfif>
					<cfif isdefined("attributes.product_id") and Len(attributes.product_id) and len(attributes.product_name)>
						POR.PR_ORDER_ID IN (
							SELECT 
								P2.PR_ORDER_ID
							FROM
								PRODUCTION_ORDER_RESULTS_ROW P2 
							WHERE 
								P2.TYPE = 1
								AND P2.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
						) AND
					</cfif>
					<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
						POR.PR_ORDER_ID IN (
							SELECT 
								P2.PR_ORDER_ID
							FROM
								PRODUCTION_ORDER_RESULTS_ROW P2,
								STOCKS S2
							WHERE 
								P2.TYPE = 1
								AND S2.STOCK_ID = P2.STOCK_ID 
								AND S2.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%"> 
						) AND
					</cfif>
					<cfif isdefined("attributes.prod_order_number") and Len(attributes.prod_order_number) and len(attributes.prod_order)>
						POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_order_number#"> AND
					</cfif>
					S.STOCK_ID = PORR.STOCK_ID AND
					POR.PR_ORDER_ID = PORR.PR_ORDER_ID
				GROUP BY
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PRODUCT_NAME,
					PORR.UNIT_NAME,
					POR.P_ORDER_ID
				
				UNION ALL
			
				SELECT
					3 TYPE,
					SUM(PORR.AMOUNT) AMOUNT,
					SUM((PORR.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*PORR.AMOUNT) PRODUCT_COST,
					SUM(PORR.STATION_REFLECTION_COST_SYSTEM*PORR.AMOUNT) REFLECTION_COST,
					SUM(PORR.LABOR_COST_SYSTEM*PORR.AMOUNT) LABOR_COST,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					(SELECT PO.SPEC_MAIN_ID FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) SPECT_MAIN_ID,
					S.PRODUCT_NAME AS NAME_PRODUCT,
					PORR.UNIT_NAME
				FROM
					STOCKS S,
					PRODUCTION_ORDER_RESULTS POR,
					PRODUCTION_ORDER_RESULTS_ROW PORR
				WHERE
					PORR.TYPE = 3 AND
					(SELECT PO.IS_DEMONTAJ FROM PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.P_ORDER_ID) = 0 AND
					<cfif Len(attributes.startdate)>
						POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					</cfif>
					<cfif Len(attributes.finishdate)>
						POR.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finishdate)#"> AND
					</cfif>
					<cfif ListLen(attributes.station_name) and ListLen(attributes.station_id)>
						POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#" list="yes">) AND 
					</cfif>
					<cfif isdefined("attributes.product_id") and Len(attributes.product_id) and len(attributes.product_name)>
						POR.PR_ORDER_ID IN (
							SELECT 
								P2.PR_ORDER_ID
							FROM
								PRODUCTION_ORDER_RESULTS_ROW P2 
							WHERE 
								P2.TYPE = 1
								AND P2.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
						) AND
					</cfif>
					<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
						POR.PR_ORDER_ID IN (
							SELECT 
								P2.PR_ORDER_ID
							FROM
								PRODUCTION_ORDER_RESULTS_ROW P2,
								STOCKS S2
							WHERE 
								P2.TYPE = 1
								AND S2.STOCK_ID = P2.STOCK_ID 
								AND S2.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%"> 
						) AND
					</cfif>
					<cfif isdefined("attributes.prod_order_number") and Len(attributes.prod_order_number) and len(attributes.prod_order)>
						POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_order_number#"> AND
					</cfif>
					S.STOCK_ID = PORR.STOCK_ID AND
					POR.PR_ORDER_ID = PORR.PR_ORDER_ID
				GROUP BY
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PRODUCT_NAME,
					PORR.UNIT_NAME,
					POR.P_ORDER_ID
				
			) AS MAIN_QUERY
		GROUP BY
			TYPE,
			PRODUCT_ID,
			STOCK_CODE,
			NAME_PRODUCT,
			UNIT_NAME,
			SPECT_MAIN_ID
		ORDER BY
			SPECT_MAIN_ID,
			TYPE,
			STOCK_CODE
	</cfquery>
</cfif>
<cfform name="rapor" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="40757.Ürün Maliyet Raporu"></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs">
					<div class="row formContent">
						<div class="row" type="row">
							<cfoutput>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
													<cfinput type="text" name="startdate" value="#DateFormat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="startdate">
													</span> 
												</div>
											</div> 
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="finishdate" value="#DateFormat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finishdate">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58834.İstasyon"></label>
											<cf_wrk_list_items table_name ='WORKSTATIONS' wrk_list_object_id='STATION_ID' wrk_list_object_name='STATION_NAME' sub_header_name="#getLang('main',1422)#" header_name="#getLang('main',1422)#" datasource ="#dsn3#">
										</div>
										<div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                            <div class="col col-12">
                                                <div class="input-group"> 
                                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                                    <cfinput type="text" name="product_name" id="product_name"  value="#attributes.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','120');" style="width:150px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=rapor.product_id&field_name=rapor.product_name','list');"></span>
                                                </div>    
                                            </div>    
                                        </div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="cat" id="cat" value="<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
													<input type="text" name="category_name" id="category_name" style="width:150px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','cat','','3','200');" value="<cfif isdefined("attributes.cat") and len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.cat&field_name=rapor.category_name</cfoutput>','list');"></span>
												</div>
											</div>		
										</div>
										<div class="form-group" >
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='49884.Üretim Emri'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="prod_order_number" id="prod_order_number" value="#attributes.prod_order_number#">
													<input type="text" name="prod_order" id="prod_order" value="#attributes.prod_order#">
													<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=stock.popup_list_prod_order&is_result=0&field_id=rapor.prod_order_number&field_name=rapor.prod_order</cfoutput>','list');"></span>
												</div>
											</div>
										</div>
									</div>
								</div>					
							</cfoutput>    
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<input type="hidden" name="submitted" id="submitted" value="1"/>  
						<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
					</div>
				</div> 
				</div>         
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.submitted")>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
	</cfif>
		<cf_report_list> 
			<thead>
				<tr> 
					<th colspan="2">&nbsp;</th>
					<th><cf_get_lang dictionary_id='40578.Kullanım Oranı'></th>
					<th><cf_get_lang dictionary_id='40579.Kullanım Miktarı'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='40204.Birim Maliyet'></th>
					<th><cf_get_lang dictionary_id='40203.Toplam Maliyet'></th>
				</tr>
			</thead>
			<cfset Round_Num = 8>
			<cfset Main_Amount = 0>
			<cfset Price_Product_Cost = 0>
			<cfset Total_Sarf_Cost = 0>
			<cfset Price_Reflection_Cost = 0>
			<cfset Price_Labor_Cost = 0>
			<cfif Get_Production_Orders_Main.recordcount>
				<cfoutput query="Get_Production_Orders_Main">
					<cfif Type eq 1>
						<cfquery name="Get_Product_Unit" datasource="#dsn3#">
							SELECT PRODUCT_ID,MAIN_UNIT,ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Production_Orders_Main.Product_Id#"> AND IS_MAIN = 0
						</cfquery>
						<cfset Main_Amount = Amount>
						<cfset Price_Product_Cost = Product_Cost>
						<cfset Price_Reflection_Cost = Reflection_Cost>
						<cfset Price_Labor_Cost = Labor_Cost>
						<thead>
							<tr> 
								<th style="mso-number-format:\@;">#Stock_Code#</th>
								<th>#Name_Product#</th>
								<th>&nbsp;<!--- Kullanim Orani ---></th>
								<th>
									<!--- Kullanim Miktari --->
									#TLFormat(Amount)#
									<cfloop from="1" to="2" index="pu">
										<cfif Len(Get_Product_Unit.Add_Unit[pu]) and Get_Product_Unit.Multiplier[pu] gt 0><br/>#TLFormat(Amount/Get_Product_Unit.Multiplier[pu])#<cfelse><br/>#TLFormat(Amount)#</cfif>
									</cfloop>
								</th>
								<th>
									#Unit_Name#
									<cfloop from="1" to="2" index="pu">
										<cfif Len(Get_Product_Unit.Add_Unit[pu])><br/>#Get_Product_Unit.Add_Unit[pu]#</cfif>
									</cfloop>
								</th>
								<th>#TLFormat((Price_Product_Cost+Price_Reflection_Cost+Price_Labor_Cost)/Amount,6)#<!--- Birim Maliyet ---></th>
								<th>#TLFormat(Price_Product_Cost+Price_Reflection_Cost+Price_Labor_Cost)#<!--- Toplam Maliyet ---></th>
							</tr>
						</thead>
					</cfif>
					<tbody>
						<cfif Type neq 1>
							<tr>
								<td style="text-align:center;">#Stock_Code#</td>
								<td style="text-align:center;">#Name_Product#</td>
								<td style="text-align:center;"><cfif Type eq 2><cfif Main_Amount gt 0>#TLFormat(Amount/Main_Amount)#<cfelse>#TLFormat(0)#</cfif></cfif><!--- Kullanim Orani ---></td>
								<td style="text-align:center;">#TLFormat(Amount)#<!--- Kullanim Miktari ---></td>
								<td style="text-align:center;">#Unit_Name#<!--- Birim ---></td>
								<td style="text-align:center;"><cfif Amount gt 0>#TLFormat(Product_Cost/Amount,6)#<cfelse>#TLFormat(0)#</cfif><!--- Birim Maliyet ---></td>
								<td style="text-align:center;">#TLFormat(Product_Cost)#<!--- Toplam Maliyet ---></td>
							</tr>
							<cfset Total_Sarf_Cost = Total_Sarf_Cost + Product_Cost>
						</cfif>
						<cfif Type[CurrentRow+1] eq 1 or CurrentRow eq Get_Production_Orders_Main.recordcount>
							<tr> 
								<td colspan="2" style="text-align:center;"><cf_get_lang dictionary_id='40580.Genel Üretim Gider Payı'></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td style="text-align:center;">#TLFormat(Price_Reflection_Cost)#</td>
							</tr>
							<tr> 
								<td colspan="2" style="text-align:center;"><cf_get_lang dictionary_id='57784.İşçilik'></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td style="text-align:center;">#TLFormat(Price_Labor_Cost)#</td>
							</tr>
						</cfif>
					</tbody>	
				</cfoutput>	
			<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse></cfif>!</td>
			</tr>
		</cfif>
	</cf_report_list>
</cfif>
<script language="javascript">
	function control()
	{
		if(!date_check(rapor.startdate,rapor.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_product_cost_report</cfoutput>";
	}
</script>
