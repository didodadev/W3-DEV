<!--- Urun Gider Dagitim Tablosu FBS 20110906 --->
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfif isDate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfform name="rapor" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
   <cfoutput>	    
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40758.Ürün Gider Dağıtım Raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
				<div class="row">
					<div class="col col-12 col-xs">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
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
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58834.Istasyon'></label>
											<cf_wrk_list_items table_name ='WORKSTATIONS' wrk_list_object_id='STATION_ID' wrk_list_object_name='STATION_NAME' sub_header_name="#getLang('main',1422)#" header_name="#getLang('main',1422)#" datasource ="#dsn3#">
										</div>
									</div>
								</div>		
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>    
								<input type="hidden" name="submitted" id="submitted" value="1">		  
								<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
							</div>
						</div>	
					</div>	
				</div>	
		</cf_report_list_search_area>
	</cf_report_list_search>     
	</cfoutput>
</cfform>
<cfif isdefined("attributes.submitted")>
	<cfquery name="Get_Production_Orders" datasource="#dsn3#">
		SELECT
			STATION_ID,
			STATION_NAME,
			UNIT2,
			SUM(ADD_UNIT_AMOUNT) ADD_UNIT_AMOUNT,
			SUM(MAIN_AMOUNT) MAIN_AMOUNT,
			STOCK_CODE,
			ISNULL(SUM(TOTAL_STATION_EXPENSE),0) TOTAL_STATION_EXPENSE,
			NAME_PRODUCT
		FROM
			(
				SELECT
					W.STATION_ID,
					W.STATION_NAME,
					W.REFLECTION_TYPE,<!--- Dagitim Anahtari : 3 Ek Birim --->
					W.UNIT2,
					CASE WHEN W.REFLECTION_TYPE = 3 THEN PORR.AMOUNT/ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = PORR.PRODUCT_ID AND ADD_UNIT = W.UNIT2),1) ELSE PORR.AMOUNT END ADD_UNIT_AMOUNT,
					PORR.AMOUNT MAIN_AMOUNT,
					(SELECT TOP 1 STOCK_CODE FROM STOCKS WHERE STOCK_ID = PORR.STOCK_ID) STOCK_CODE,
					PORR.STATION_REFLECTION_COST_SYSTEM*AMOUNT TOTAL_STATION_EXPENSE,
					PORR.NAME_PRODUCT
				FROM
					WORKSTATIONS W,
					PRODUCTION_ORDER_RESULTS POR,
					PRODUCTION_ORDER_RESULTS_ROW PORR
				WHERE
					PORR.TYPE = 1 AND <!--- 1 ana urun / 2 sarf / 3 fire --->
					<cfif Len(attributes.startdate)>
						POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					</cfif>
					<cfif Len(attributes.finishdate)>
						POR.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finishdate)#"> AND
					</cfif>
					<cfif ListLen(attributes.station_name) and ListLen(attributes.station_id)>
						POR.STATION_ID IN (#attributes.station_id#) AND
					</cfif>
					POR.STATION_ID IS NOT NULL AND
					W.STATION_ID = POR.STATION_ID AND
					POR.PR_ORDER_ID = PORR.PR_ORDER_ID
			) AS MAIN_QUERY
		GROUP BY
			STATION_ID,
			STATION_NAME,
			UNIT2,
			STOCK_CODE,
			NAME_PRODUCT
		ORDER BY
			STATION_NAME
	</cfquery>	
	<cfparam name="attributes.totalrecords" default='#Get_Production_Orders.recordcount#'>		
	<cfoutput query="Get_Production_Orders" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
		<cfif not isDefined("Total_Production_Amount_#Station_Id#")>
			<cfset "Total_Production_Amount_#Station_Id#" = 0>
			<cfset "Total_Expense_Amount_#Station_Id#" = 0>
		</cfif>
		<cfset "Total_Production_Amount_#Station_Id#" = Evaluate("Total_Production_Amount_#Station_Id#") + Add_Unit_Amount>
		<cfset "Total_Expense_Amount_#Station_Id#" = Evaluate("Total_Expense_Amount_#Station_Id#") + TOTAL_STATION_EXPENSE>
	</cfoutput>

	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = Get_Production_Orders.recordcount>
	</cfif>
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
					<th colspan="2">&nbsp;<!--- Stok Kodu - Urun Adi ---></th>
					<th><cf_get_lang dictionary_id='40541.Üretim Miktarı'><!--- Ana Birim ---></th>
					<!--- <th>Birimin Hacmi</td> --->
					<th><cf_get_lang dictionary_id='40559.Üretimin Toplam Hacmi'><!--- Istasyonda Dagitim Anahtarindaki Birime Gore Miktar ---></th>
					<th><cf_get_lang dictionary_id='40571.Maliyet Yükleme Haddi'><!--- Dagitilacak Giderler Toplami / Toplam Uretim Miktari ---></th>
					<th><cf_get_lang dictionary_id='40575.Üretime Yüklenen Maliyet'><!--- Uretim Miktari x Birim Basina Maliyet ---></th>
					<th><cf_get_lang dictionary_id='40576.Birim Başına Maliyet'><!--- Maliyet Yukleme Haddi * Uretimin Toplan Hacmi / Uretim Miktari ---></th>
				</tr>
			</thead>
				<cfif Get_Production_Orders.RecordCount>
					<cfset Round_Num = 8>
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						<cfset attributes.startrow=1>
						<cfset attributes.maxrows=Get_Production_Orders.recordcount>
					</cfif>
					<cfoutput query="Get_Production_Orders" group="Station_Name"  maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
						<tbody>
						<tr> 
							<td colspan="7">#Station_Name#</td>
						</tr>
						<tr> 
							<td colspan="6"><cf_get_lang dictionary_id='40577.Dağıtılacak Giderler Toplamı'></td>
							<td style="text-align:right;width:130px;">
								<!--- Istasyon Yansiyan Giderler Toplami --->
								<cfif isDefined("Total_Expense_Amount_#Station_Id#")>
									<cfset Total_Expense_Shift = Evaluate("Total_Expense_Amount_#Station_Id#")>
								<cfelse>
									<cfset Total_Expense_Shift = 0>
								</cfif>
								#TLFormat(Total_Expense_Shift,Round_Num)#
							</td>
						</tr>
						<tr> 
							<td colspan="6"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='40541.Üretim Miktarı'></td>
							<td style="text-align:right;">
								<!--- Istasyondaki Toplam Uretim Miktari (Dagitim Anahtarina Gore) --->
								<cfif isDefined("Total_Production_Amount_#Station_Id#")>
									<cfset Total_Production_Amount = Evaluate("Total_Production_Amount_#Station_Id#")>
								<cfelse>
									<cfset Total_Production_Amount = 0>
								</cfif>
								#TLFormat(Total_Production_Amount,Round_Num)#
							</td>
						</tr>
						<tr> 
							<td colspan="6"><cf_get_lang dictionary_id='40571.Maliyet Yükleme Haddi'></td>
							<td style="text-align:right;">
								<!--- Istasyon Yansiyan Giderler Toplami / Istasyondaki Toplam Uretim Miktari (Dagitim Anahtarina Gore) --->
								<cfif Total_Production_Amount gt 0>
									<cfset Total_Cost_Amount = Total_Expense_Shift/Total_Production_Amount>
								<cfelse>
									<cfset Total_Cost_Amount = 0>
								</cfif>
								#TLFormat(Total_Cost_Amount,Round_Num)#
							</td>
						</tr>
						<cfoutput>
						<cfset Total_Unit_Base_Cost = (Total_Cost_Amount*Add_Unit_Amount)/Main_Amount>
						<tr> 
							<td>#Stock_Code#</td>
							<td>#Name_Product#</td>
							<td style="text-align:right;">#TLFormat(Main_Amount,Round_Num)#</td>
							<!--- <td style="text-align:right;">&nbsp;</th> --->
							<td style="text-align:right;">#TLFormat(Add_Unit_Amount,Round_Num)#</td>
							<td style="text-align:right;">#TLFormat(Total_Cost_Amount,Round_Num)#</td>
							<td style="text-align:right;">#TLFormat(Total_Unit_Base_Cost*Main_Amount,2)#</td>
							<td style="text-align:right;">#TLFormat(Total_Unit_Base_Cost,Round_Num)#</td>
						</tr>
						</tbody>
						</cfoutput>
					</cfoutput>
				<cfelse>
					<tbody>
					<tr> 
						<td colspan="7"><cfif isdefined("attributes.submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse></cfif>!</td>
					</tr>
					</tbody>
				</cfif>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<!-- sil -->
			</cfif>
		</cf_report_list>	
</cfif>
<script>
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
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_product_expense_seller_report</cfoutput>";
			                                                           
	}
</script>
