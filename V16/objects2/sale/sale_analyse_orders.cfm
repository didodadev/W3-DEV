<!--- ! ! ! Satıs analiz ! ! !
sale_analyse_report_2.cfm (kar bilgisi göstermeyen detayli satis analizi raporu)
	attributes.report_type 1 : Kategori Bazında
	attributes.report_type 2 : Ürün Bazında
	attributes.report_type 3 : Stok Bazında
	attributes.report_type 9 : Marka Bazında
	attributes.report_type 17 : Belge ve Stok Bazında
 --->
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.report_sort"  default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_kdv" default="0">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_prom" default="0" >
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_money2" default="0" >
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.is_discount" default="0">
<cfparam name="attributes.kontrol" default="0">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_iptal" default="">
<script type="text/javascript">
function degistir_action()
{
	if(document.rapor.is_excel.checked==false)
		document.rapor.action="<cfoutput>#request.self#?fuseaction=objects2.sale_analyse_orders</cfoutput>";
	else
		document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_sale_analyse_report_orders</cfoutput>";
}
</script>
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_sale_analyse_orders.cfm">
<cfelse>
	<cfset get_total_purchase.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_total_purchase.recordcount>
</cfif>
<cfset toplam_satis = 0>
<cfset toplam_miktar = 0>
<cfif isdate(attributes.date1)>
	<cfset attributes.date1 = dateformat(attributes.date1, "dd/mm/yyyy")>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, "dd/mm/yyyy")>
</cfif>
<cfquery name="get_cancel_type" datasource="#dsn3#">
	SELECT
		*
	FROM 
		SETUP_SUBSCRIPTION_CANCEL_TYPE
	ORDER BY
		SUBSCRIPTION_CANCEL_TYPE
</cfquery>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
<!-- sil -->
<tr>
	<td colspan="2">
		<table width="100%" border="0" cellpadding="2" cellspacing="1" height="100%">
		 <tr>
            <td height="100" valign="top">			
				<table border="0">
				<cfform name="rapor" action="#request.self#?fuseaction=objects2.sale_analyse_orders" method="post">
				<input type="hidden" name="form_submitted" id="form_submitted" value="">
			    <tr>
					<td class="txtbold" width="100"><cf_get_lang_main no='162.Şirket'></td>
					<td width="235"><cfoutput>#session.pp.company#</cfoutput></td>
					<td>
						<input type="hidden" name="kontrol" id="kontrol" value="0">
						<input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1 and attributes.kontrol eq 0>checked</cfif>>Ciro ya Göre
						<input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2 and attributes.kontrol eq 0>checked</cfif>>Miktar a Göre			
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='330.Tarih'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
						<cfinput value="#attributes.date1#" type="text" maxlength="10" name="date1" validate="eurodate" required="yes" message="#message#" style="width:75px;">
						<cf_wrk_date_image date_field="date1"> /
						<cfinput value="#attributes.date2#" type="text" maxlength="10" name="date2" validate="eurodate" required="yes" message="#message#" style="width:75px;" >
						<cf_wrk_date_image date_field="date2">					
					</td>
					<td id="is_other_money">
						<input name="is_prom" id="is_prom" value="1" type="checkbox" <cfif attributes.is_prom eq 1 >checked</cfif>>Bedava Promosyonlar
						<input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked</cfif>>İşlem Dovizli
					</td>
				</tr>
				<tr>
				 	<td>Rapor Tipi</td>
					<td>
						<select name="report_type" id="report_type" style="width:203px;">
							<option value="1" <cfif attributes.report_type eq 1>selected</cfif>> Kategori Bazında</option>
							<option value="2" <cfif attributes.report_type eq 2>selected</cfif>> Ürün Bazında</option>
							<option value="3" <cfif attributes.report_type eq 3>selected</cfif>> Stok Bazında</option>
							<option value="9" <cfif attributes.report_type eq 9>selected</cfif>> Marka Bazında</option>
							<option value="17" <cfif attributes.report_type eq 17>selected</cfif>>Belge ve Stok Bazında</option>
						</select>					
					</td>
					<td>	 
						<input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1>checked</cfif>>İsk Göster
						<input name="is_kdv" id="is_kdv" value="1" type="checkbox" <cfif attributes.is_kdv eq 1 >checked</cfif>>KDV Dahil					
					 	<cfif isdefined("session.pp.money2")><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput>#session.pp.money2#</cfoutput> Göster</cfif>
						<input name="is_iptal" id="is_iptal" value="1" type="checkbox" <cfif attributes.is_iptal eq 1 >checked</cfif>>İptaller Düşsün
					</td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td>
						<select name="graph_type" id="graph_type" style="width:90px;">
							<option value="" selected>Grafik Format</option>
							<option value="cylinder" <cfif attributes.graph_type eq 'cylinder'> selected</cfif>>Cylinder</option>
							<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>>Pasta</option>
							<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
						</select>
						<select name="status" id="status" style="width:50px;">
							<option value=""><cf_get_lang_main no='296.Tümü'></option>
							<option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
							<option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
						</select>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
						<cf_wrk_search_button button_type='1'>
					</td>
				</tr>
				</cfform>
              </table>
            </td>
         </tr>	
		</table>	
	</td>
</tr>
<!-- sil -->
</table>
<cfquery name="get_product_units" datasource="#dsn#">
	SELECT * FROM SETUP_UNIT
</cfquery>
<cfset toplam_miktar = 0>
<cfoutput query="get_product_units">
	<cfset unit_ = replace(get_product_units.unit,'/','','all')>
	<cfset unit__ = replace(unit_,' ','','all')>
	<cfset unit__ = replace(unit__,'.','','all')>
	<cfset unit__ = replace(unit__,'%','','all')>
	<cfset 'toplam_#unit__#' = 0>
	<cfset 'toplam_giden_#unit__#' = 0>
	<cfset 'toplam_kalan_#unit__#' = 0>
</cfoutput>
<cfif isdefined("attributes.form_submitted")>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr class="color-border">
	<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<cfif attributes.page neq 1>
			<cfset order_id_list = ''>
			<cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
				<cfif isdefined("order_id") and len(order_id) and not listfind(order_id_list,order_id)>
					<cfset order_id_list=listappend(order_id_list,order_id)>
				</cfif>  
			</cfoutput>
			<cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
				<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>  
				<cfif listfind('17,2,3',attributes.report_type)>
					<cfif len(PRODUCT_STOCK)>
						<cfset unit_ = replace(birim,'/','','all')>
						<cfset unit__ = replace(unit_,' ','','all')>
						<cfset unit__ = replace(unit__,'.','','all')>
						<cfset unit__ = replace(unit__,'%','','all')>	
						<cfset 'toplam_#unit__#' = evaluate('toplam_#unit__#') +PRODUCT_STOCK>	
					</cfif> 
				<cfelseif attributes.report_type neq 1>
					 <cfif len(PRODUCT_STOCK)>
					 	 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
					 </cfif> 
				</cfif>
				<cfif attributes.report_type eq 17>
					<cfset order_id_list=listsort(ListDeleteDuplicates(order_id_list),"numeric","asc",",")>
					<cfquery name="get_orders_ship" datasource="#dsn3#">
						SELECT
							ORDERS_SHIP.PERIOD_ID AS SHIP_PERIOD_ID,
							'' AS INVOICE_PERIOD_ID
						FROM
							ORDERS_SHIP 
						WHERE
							ORDERS_SHIP.ORDER_ID IN(#order_id_list#)
					UNION
						SELECT
							'' SHIP_PERIOD_ID,
							ORDERS_INVOICE.PERIOD_ID AS INVOICE_PERIOD_ID
						FROM
							ORDERS_INVOICE
						WHERE
							ORDERS_INVOICE.ORDER_ID IN(#order_id_list#)
					</cfquery>
					<cfset ship_list="">
					<cfset invoice_list="">
					<cfset period_list_ship = "">
					<cfset period_list_invoice = "">
					<cfif get_orders_ship.recordcount>
						<cfif len(get_orders_ship.SHIP_PERIOD_ID) and get_orders_ship.SHIP_PERIOD_ID neq 0>
							<cfset period_list_ship = listsort(valuelist(get_orders_ship.SHIP_PERIOD_ID),"numeric","asc",",")>
							<cfquery name="get_period_ship_dsns" datasource="#dsn3#">
								SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_ship#)
							</cfquery>
						</cfif>
						<cfif len(get_orders_ship.INVOICE_PERIOD_ID) and get_orders_ship.INVOICE_PERIOD_ID neq 0>
							<cfset period_list_invoice = listsort(valuelist(get_orders_ship.INVOICE_PERIOD_ID),"numeric","asc",",")>
							<cfquery name="get_period_invoice_dsns" datasource="#dsn3#">
								SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_invoice#)
							</cfquery>
						</cfif>
					</cfif>
					<cfif get_orders_ship.recordcount>
						<cfif len(period_list_ship)>
							<cfquery name="get_ship_det" datasource="#DSN3#">
								<cfloop query="get_period_ship_dsns">
									SELECT
										S.SHIP_ID,S.SHIP_DATE,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER,ROW_ORDER_ID AS ORDER_ID
									FROM
										 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP S,
										 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
									WHERE
										SR.SHIP_ID=S.SHIP_ID AND
										SR.ROW_ORDER_ID IN(#order_id_list#)
									GROUP BY
										S.SHIP_ID,S.SHIP_DATE,STOCK_ID,SHIP_NUMBER,SR.ROW_ORDER_ID
								<cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
								</cfloop>	
								ORDER BY S.SHIP_ID ASC
							</cfquery>
						<cfset ship_list=listsort(ListDeleteDuplicates(valuelist(get_ship_det.SHIP_ID)),"numeric","asc",",")>
						</cfif>
						<cfif len(period_list_invoice)>
							<cfquery name="get_inv_det" datasource="#DSN3#">
								<cfloop query="get_period_invoice_dsns">
									SELECT
										I.INVOICE_ID,I.INVOICE_DATE,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,INVOICE_NUMBER,IR.ORDER_ID AS ORDER_ID
									FROM
										#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE I,
										#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
									WHERE
										IR.INVOICE_ID = I.INVOICE_ID AND
										IR.ORDER_ID IN(#order_id_list#)
									GROUP BY
										I.INVOICE_ID,I.INVOICE_DATE,STOCK_ID,INVOICE_NUMBER,IR.ORDER_ID
								<cfif currentrow neq get_period_invoice_dsns.recordcount> UNION ALL </cfif>
								</cfloop>				
							</cfquery>
							<cfset invoice_list=listsort(ListDeleteDuplicates(valuelist(get_inv_det.INVOICE_ID)),"numeric","asc",",")>
						</cfif>
						<!--- siparisin cekildigi irsaliye, bir faturaya cekilmiş ve o fatura da ithal mal girişine cekilmiş mi kontrol ediliyor  --->
						<cfif len(ship_list)>
							<cfquery name="GET_IMPORTS_INVOICE" datasource="#dsn2#">
								SELECT 
									INV_S.IMPORT_INVOICE_ID,
									INV_S.SHIP_ID,
									S.SHIP_NUMBER
								FROM 
									INVOICE_SHIPS INV_S,
									SHIP S
								WHERE 
									S.SHIP_ID = INV_S.SHIP_ID AND 
									INV_S.IMPORT_INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#ship_list#) )
									AND INV_S.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
								ORDER BY 
									INV_S.IMPORT_INVOICE_ID
							</cfquery>
							<cfif GET_IMPORTS_INVOICE.recordcount>
								<cfset customs_ship_list=listsort(valuelist(GET_IMPORTS_INVOICE.SHIP_ID),"numeric","asc",",")>
								<cfset import_invoice_list=listsort(valuelist(GET_IMPORTS_INVOICE.IMPORT_INVOICE_ID),"numeric","asc",",")>
								<cfquery name="get_customs_ship" datasource="#DSN2#">
									SELECT
										SHIP.SHIP_ID,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER,SHIP_ROW.IMPORT_INVOICE_ID
									FROM
					
										SHIP,
										SHIP_ROW
									WHERE
										SHIP_ROW.SHIP_ID=SHIP.SHIP_ID AND
										SHIP_ROW.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
										SHIP_ROW.IMPORT_INVOICE_ID IN (#import_invoice_list#) AND
										SHIP.SHIP_ID IN (#customs_ship_list#)
									GROUP BY
										SHIP.SHIP_ID,SHIP_ROW.IMPORT_INVOICE_ID,STOCK_ID,SHIP_NUMBER
									ORDER BY 		
										SHIP_ROW.IMPORT_INVOICE_ID
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
					<cfset irs_top=0>
					<cfset inv_top=0>
					<cfif get_orders_ship.recordcount>
						<cfif len(ship_list)>
							<cfloop list="#ship_list#" index="z">
								<cfquery name="get_amount_shp" dbtype="query">
									SELECT IRS_AMOUNT,SHIP_ID FROM  get_ship_det WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#z#"> AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
								</cfquery>
								<cfif get_amount_shp.recordcount neq 0 and len(get_amount_shp.IRS_AMOUNT)>
									<cfset irs_top=irs_top+get_amount_shp.IRS_AMOUNT>
								</cfif>
							</cfloop>
						</cfif>
						<cfif len(invoice_list)>
							<cfloop list="#invoice_list#" index="a">
								<cfquery name="get_amount_inv" dbtype="query">
									SELECT IRS_AMOUNT,INVOICE_ID FROM  get_inv_det WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#a#"> AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
								</cfquery>
								<cfif get_amount_inv.recordcount neq 0 and len(get_amount_inv.IRS_AMOUNT)>
									<cfset inv_top=inv_top+get_amount_inv.IRS_AMOUNT>
								</cfif>
							</cfloop>
						</cfif>
					</cfif>
					<cfset 'toplam_giden_#unit__#' = evaluate('toplam_giden_#unit__#') + irs_top + inv_top>	
					<cfset 'toplam_kalan_#unit__#' = evaluate('toplam_kalan_#unit__#') + (product_stock - (irs_top + inv_top))>	
				</cfif>
			</cfoutput>				  
		</cfif>
		<cfif attributes.report_type eq 17 and get_total_purchase.recordcount>
			<cfset order_id_list = ''>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(order_id) and not listfind(order_id_list,order_id)>
					<cfset order_id_list=listappend(order_id_list,order_id)>
				</cfif>  
			</cfoutput>	
			<cfset order_id_list=listsort(ListDeleteDuplicates(order_id_list),"numeric","asc",",")>
			<cfquery name="get_orders_ship" datasource="#dsn3#">
				SELECT
					ORDERS_SHIP.PERIOD_ID AS SHIP_PERIOD_ID,
					'' AS INVOICE_PERIOD_ID
				FROM
					ORDERS_SHIP 
				WHERE
					ORDERS_SHIP.ORDER_ID IN(#order_id_list#)
			UNION
				SELECT
					'' SHIP_PERIOD_ID,
					ORDERS_INVOICE.PERIOD_ID AS INVOICE_PERIOD_ID
				FROM
					ORDERS_INVOICE
				WHERE
					ORDERS_INVOICE.ORDER_ID IN(#order_id_list#)
			</cfquery>
			<cfset ship_list="">
			<cfset invoice_list="">
			<cfset period_list_ship = "">
			<cfset period_list_invoice = "">
			<cfif get_orders_ship.recordcount>
				<cfif len(get_orders_ship.SHIP_PERIOD_ID) and get_orders_ship.SHIP_PERIOD_ID neq 0>
					<cfset period_list_ship = listsort(valuelist(get_orders_ship.SHIP_PERIOD_ID),"numeric","asc",",")>
					<cfquery name="get_period_ship_dsns" datasource="#dsn3#">
						SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_ship#)
					</cfquery>
				</cfif>
				<cfif len(get_orders_ship.INVOICE_PERIOD_ID) and get_orders_ship.INVOICE_PERIOD_ID neq 0>
					<cfset period_list_invoice = listsort(valuelist(get_orders_ship.INVOICE_PERIOD_ID),"numeric","asc",",")>
					<cfquery name="get_period_invoice_dsns" datasource="#dsn3#">
						SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_invoice#)
					</cfquery>
				</cfif>
			</cfif>
			<cfif get_orders_ship.recordcount>
				<cfif len(period_list_ship)>
					<cfquery name="get_ship_det" datasource="#DSN3#">
						<cfloop query="get_period_ship_dsns">
							SELECT
								S.SHIP_ID,S.SHIP_DATE,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER,SR.ROW_ORDER_ID AS ORDER_ID
							FROM
								 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP S,
								 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
							WHERE
								SR.SHIP_ID=S.SHIP_ID AND
								SR.ROW_ORDER_ID IN(#order_id_list#)
							GROUP BY
								S.SHIP_ID,S.SHIP_DATE,STOCK_ID,SHIP_NUMBER,SR.ROW_ORDER_ID
						<cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
						</cfloop>	
						ORDER BY S.SHIP_ID ASC
					</cfquery>
				<cfset ship_list=listsort(ListDeleteDuplicates(valuelist(get_ship_det.SHIP_ID)),"numeric","asc",",")>
				</cfif>
				<cfif len(period_list_invoice)>
					<cfquery name="get_inv_det" datasource="#DSN3#">
						<cfloop query="get_period_invoice_dsns">
							SELECT
								I.INVOICE_ID,I.INVOICE_DATE,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,INVOICE_NUMBER,IR.ORDER_ID AS ORDER_ID
							FROM
								#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE I,
								#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
							WHERE
								IR.INVOICE_ID = I.INVOICE_ID AND
								IR.ORDER_ID IN(#order_id_list#)
							GROUP BY
								I.INVOICE_ID,I.INVOICE_DATE,STOCK_ID,INVOICE_NUMBER,IR.ORDER_ID
						<cfif currentrow neq get_period_invoice_dsns.recordcount> UNION ALL </cfif> 
						</cfloop>				
					</cfquery>
					<cfset invoice_list=listsort(ListDeleteDuplicates(valuelist(get_inv_det.INVOICE_ID)),"numeric","asc",",")>
				</cfif>
				<!--- siparisin cekildigi irsaliye, bir faturaya cekilmiş ve o fatura da ithal mal girişine cekilmiş mi kontrol ediliyor  --->
				<cfif len(ship_list)>
					<cfquery name="GET_IMPORTS_INVOICE" datasource="#dsn2#">
						SELECT 
							INV_S.IMPORT_INVOICE_ID,
							INV_S.SHIP_ID,
							S.SHIP_NUMBER
						FROM 
							INVOICE_SHIPS INV_S,
							SHIP S
		
						WHERE 
							S.SHIP_ID = INV_S.SHIP_ID AND 
							INV_S.IMPORT_INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#ship_list#) )
							AND INV_S.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
						ORDER BY 
							INV_S.IMPORT_INVOICE_ID
					</cfquery>
					<cfif GET_IMPORTS_INVOICE.recordcount>
						<cfset customs_ship_list=listsort(valuelist(GET_IMPORTS_INVOICE.SHIP_ID),"numeric","asc",",")>
						<cfset import_invoice_list=listsort(valuelist(GET_IMPORTS_INVOICE.IMPORT_INVOICE_ID),"numeric","asc",",")>
						<cfquery name="get_customs_ship" datasource="#DSN2#">
							SELECT
								SHIP.SHIP_ID,STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER,SHIP_ROW.IMPORT_INVOICE_ID
							FROM
			
								SHIP,
								SHIP_ROW
							WHERE
								SHIP_ROW.SHIP_ID=SHIP.SHIP_ID AND
								SHIP_ROW.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
								SHIP_ROW.IMPORT_INVOICE_ID IN (#import_invoice_list#) AND
								SHIP.SHIP_ID IN (#customs_ship_list#)
							GROUP BY
								SHIP.SHIP_ID,SHIP_ROW.IMPORT_INVOICE_ID,STOCK_ID,SHIP_NUMBER
							ORDER BY 		
								SHIP_ROW.IMPORT_INVOICE_ID
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfif get_total_purchase.recordcount and attributes.report_type eq 1>
			<tr class="color-header">
				<td class="txtbold">Kategori Kod</td>
				<td class="txtbold" height="22"><cf_get_lang_main no='74.Kategori'></td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#HIERARCHY#</td>
				<td>#PRODUCT_CAT#</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#</td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		<cfelseif get_total_purchase.recordcount and listfind('2,3',attributes.report_type,',')>
			<tr class="color-header" height="22">
				<td class="txtbold">Kategori Kod</td>
				<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
				<td class="txtbold">Ürün Kod</td>
				<td class="txtbold"><cf_get_lang_main no='221.Barkod'></td>
				<td class="txtbold"><cf_get_lang_main no='245.Ürün'> </td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
		<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#HIERARCHY#</td>
				<td>#PRODUCT_CAT#</td>
				<cfif attributes.report_type eq 2>
					<td>#PRODUCT_CODE#</td><td>#BARCOD#</td>
					<td>#PRODUCT_NAME#</td>
				<cfelseif attributes.report_type eq 3>
					<td>#PRODUCT_CODE#</td><td>#BARCOD#</td>
					<td>#PRODUCT_NAME# #PROPERTY#</td>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)# #BIRIM#
				<cfif len(PRODUCT_STOCK)>
					<cfset unit_ = replace(birim,'/','','all')>
					<cfset unit__ = replace(unit_,' ','','all')>
					<cfset unit__ = replace(unit__,'.','','all')>
					<cfset unit__ = replace(unit__,'%','','all')>	
					<cfset 'toplam_#unit__#' = evaluate('toplam_#unit__#') +PRODUCT_STOCK>	
				</cfif>
				</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>

					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#
				</cfif>
				<td align="right" style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		<cfelseif get_total_purchase.recordcount and attributes.report_type eq 9>
			<tr class="color-header" height="22" >
				<td class="txtbold">Marka</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>  
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#BRAND_NAME#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
					<cfif len(PRODUCT_STOCK)>
					    <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
					</cfif>
				</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#</td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		<cfelseif get_total_purchase.recordcount and attributes.report_type eq 17>
			<tr class="color-header" height="22">
				<td class="txtbold">Sipariş No</td>
				<td class="txtbold">Sipariş Tarihi</td>
				<td class="txtbold">Aşama</td>
				<td class="txtbold">Müşteri</td>
				<td class="txtbold">Açıklama</td>
				<td class="txtbold">Ürün Kod</td>
				<td class="txtbold">Üretici Kodu</td>
				<td class="txtbold"><cf_get_lang_main no='245.Ürün'> </td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Teslim Edilen</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Kalan</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>
				<cfif fusebox.circuit is 'store'>
					<cfset fuse_type = 'store'>
				<cfelse>
					<cfset fuse_type = 'sales'>
				</cfif>
				<cfif is_instalment eq 1>
					<cfset page_type = 'upd_fast_sale'>
				<cfelse>
					<cfset page_type = 'detail_order'>
				</cfif>
				#ORDER_NUMBER#
				</td>
				<td>#dateformat(ORDER_DATE,'dd/mm/yyyy')#</td>
				<td><cfif order_row_currency eq -8>Fazla Teslimat
					<cfelseif order_row_currency eq -7>Eksik Teslimat
					<cfelseif order_row_currency eq -6>Sevk
					<cfelseif order_row_currency eq -5>Üretim
					<cfelseif order_row_currency eq -4>Kısmi Üretim
					<cfelseif order_row_currency eq -3>Kapatıldı
					<cfelseif order_row_currency eq -2>Tedarik
					<cfelseif order_row_currency eq -1>Açık
					</cfif>				
				</td>
				<td>#MUSTERI#</td>
				<td>#ORDER_DETAIL#</td>
				<td>#PRODUCT_CODE#</td>
				<td>#MANUFACT_CODE#</td>
				<td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)# #BIRIM#
				<cfif len(PRODUCT_STOCK)>
					<cfset unit_ = replace(birim,'/','','all')>
					<cfset unit__ = replace(unit_,' ','','all')>
					<cfset unit__ = replace(unit__,'.','','all')>
					<cfset unit__ = replace(unit__,'%','','all')>	
					<cfset 'toplam_#unit__#' = evaluate('toplam_#unit__#') +PRODUCT_STOCK>	
				</cfif>
				</td>
				<cfset irs_top=0>
				<cfset inv_top=0>
				<cfif get_orders_ship.recordcount>
					<cfif len(ship_list)>
						<cfloop list="#ship_list#" index="z">
							<cfquery name="get_amount_shp" dbtype="query">
								SELECT IRS_AMOUNT,SHIP_ID FROM  get_ship_det WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#z#"> AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
							</cfquery>
							<cfif get_amount_shp.recordcount neq 0 and len(get_amount_shp.IRS_AMOUNT)>
								<cfset irs_top=irs_top+get_amount_shp.IRS_AMOUNT>
							</cfif>
						</cfloop>
					</cfif>
					<cfif len(invoice_list)>
						<cfloop list="#invoice_list#" index="a">
							<cfquery name="get_amount_inv" dbtype="query">
								SELECT IRS_AMOUNT,INVOICE_ID FROM  get_inv_det WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#a#"> AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
							</cfquery>
							<cfif get_amount_inv.recordcount neq 0 and len(get_amount_inv.IRS_AMOUNT)>
								<cfset inv_top=inv_top+get_amount_inv.IRS_AMOUNT>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#irs_top+inv_top#</td>
				<td align="right" style="text-align:right;">#product_stock-irs_top-inv_top#</td>
				<cfset 'toplam_giden_#unit__#' = evaluate('toplam_giden_#unit__#') + irs_top + inv_top>	
				<cfset 'toplam_kalan_#unit__#' = evaluate('toplam_kalan_#unit__#') + (product_stock - (irs_top + inv_top))>	
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#</td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		</cfif>
		<cfoutput>
			<tr height="20" class="color-list">
			<cfif attributes.report_type neq 7 and attributes.report_type neq 18>
				<td colspan="
				<cfif listfind('2,3',attributes.report_type)><cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>5<cfelse>5</cfif><cfelse><cfif attributes.is_discount>5<cfelse>5</cfif></cfif>
				<cfelseif attributes.report_type eq 17>8
				<cfelseif listfind('16,15,14,13,12,11,10,9,8,4,6,5',attributes.report_type)>1
				<cfelse><cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>6<cfelse>5</cfif><cfelse><cfif attributes.is_discount>3<cfelse>3</cfif></cfif>
				</cfif>" class="txtbold">
				<cf_get_lang_main no='80.Toplam'></td>
				<cfif attributes.report_type eq 17>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">							
							<cfset unit_ = replace(get_product_units.unit,'/','','all')>
							<cfset unit__ = replace(unit_,' ','','all')>
							<cfset unit__ = replace(unit__,'.','','all')>
							<cfset unit__ = replace(unit__,'%','','all')>	
							<cfif evaluate('toplam_#unit__#') gt 0>
								#Tlformat(evaluate('toplam_#unit__#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">							
							<cfset unit_ = replace(get_product_units.unit,'/','','all')>
							<cfset unit__ = replace(unit_,' ','','all')>
							<cfset unit__ = replace(unit__,'.','','all')>
							<cfset unit__ = replace(unit__,'%','','all')>	
							<cfif evaluate('toplam_giden_#unit__#') gt 0>
								#Tlformat(evaluate('toplam_giden_#unit__#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">							
							<cfset unit_ = replace(get_product_units.unit,'/','','all')>
							<cfset unit__ = replace(unit_,' ','','all')>
							<cfset unit__ = replace(unit__,'.','','all')>
							<cfset unit__ = replace(unit__,'%','','all')>	
							<cfif evaluate('toplam_kalan_#unit__#') gt 0>
								#Tlformat(evaluate('toplam_kalan_#unit__#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<td colspan="
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>4<cfelse>3</cfif><cfelse>1</cfif>">
					</td>
				<cfelseif listfind('16,15,14,13,12,11,10,9,8,4,6,5',attributes.report_type)>
					<td align="right" class="txtbold" style="text-align:right;">
						#TLFormat(toplam_miktar)#
					</td>
					<td colspan="
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>4<cfelse>3</cfif><cfelse>1</cfif>">
					</td>
				<cfelseif listfind('2,3',attributes.report_type)>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">							
							<cfset unit_ = replace(get_product_units.unit,'/','','all')>
							<cfset unit__ = replace(unit_,' ','','all')>
							<cfset unit__ = replace(unit__,'.','','all')>
							<cfset unit__ = replace(unit__,'%','','all')>	
							<cfif evaluate('toplam_#unit__#') gt 0>
								#Tlformat(evaluate('toplam_#unit__#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<td colspan="
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>4<cfelse>3</cfif><cfelse>1</cfif>">
					</td>
				</cfif>
				<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #session.pp.money#</td>
				<cfif attributes.is_discount eq 1>
					<td></td>
				</cfif>
				<td align="right" class="txtbold" style="text-align:right;"><cfif butun_toplam neq 0>#TLFormat(toplam_satis*100/butun_toplam)#</cfif></td>
			<cfelseif attributes.report_type eq 7>
				<td class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
				<td align="right" class="txtbold" style="text-align:right;"><cfif isdefined('emp_total_')>#TLFormat(emp_total_)#<cfelse>#TLFormat(0)#</cfif></td>
				<cfif isdefined('emp_total_')>
					<cfset toplam=emp_total_>
				<cfelse>
					<cfset toplam=0>
				</cfif>
				<cfif isdefined('branch_list')>
				<cfloop list="#branch_list#" index="branch_index" delimiters=";">
					<td align="right" class="txtbold" style="text-align:right;">
						#TLFormat(evaluate('branch_total_#ReplaceList(branch_index," ,/,-,\,&","_,_,_,_,_")#'))#
					</td>
					<cfset toplam=toplam+evaluate('branch_total_#ReplaceList(branch_index," ,/,-,\,&","_,_,_,_,_")#')>
				</cfloop>
				</cfif>
				<td class="txtbold"></td>
				</tr>
				<tr height="25" class="color-list">
					<td class="txtbold">Genel Toplam</td>
					<td colspan="<cfif isdefined('branch_list')>#listlen(branch_list,';')+2#<cfelse>2</cfif>" align="right" class="txtbold" style="text-align:right;" >#TLFormat(toplam)# #session.pp.money#</td>
				</tr>
			<cfelse>
				<td class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
				<cfset toplam=0>
				<cfif isdefined('emp_list')>
				<cfloop list="#emp_list#" index="emp_index" delimiters=";">
					<td align="right" class="txtbold" style="text-align:right;">
						#TLFormat(evaluate('emp_total_#ReplaceList(emp_index," ,/,-,\,&","_,_,_,_,_")#'))#
					</td>
					<cfset toplam=toplam+evaluate('emp_total_#ReplaceList(emp_index," ,/,-,\,&","_,_,_,_,_")#')>
				</cfloop>
				</cfif>
				<td class="txtbold"></td>
				</tr>
				<tr height="25" class="color-list">
					<td class="txtbold">Genel Toplam</td>
					<td colspan="<cfif isdefined('emp_list')>#listlen(emp_list,';')+2#<cfelse>2</cfif>" align="right" class="txtbold" style="text-align:right;" >#TLFormat(toplam)# #session.pp.money#</td>
				</tr>
			</cfif>
			</tr>
		</cfoutput>
		</table>
	</td>
	</tr>
</table>
</cfif>
<cfif attributes.report_type neq 7 and attributes.report_type neq 18>
	<cfset adres = "">
	<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset adres = "#attributes.fuseaction#&form_submitted=1">	
		<cfif len(attributes.report_sort)>
			<cfset adres = "#adres#&report_sort=#attributes.report_sort#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.date1)>
			<cfset adres = "#adres#&date1=#attributes.date1#">
		</cfif>
		<cfif len(attributes.date2)>
			<cfset adres = "#adres#&date2=#attributes.date2#">
		</cfif>
		<cfif len(attributes.report_type)>
			<cfset adres = "#adres#&report_type=#attributes.report_type#">
		</cfif>
		<cfif isDefined("attributes.is_kdv") and len(attributes.is_kdv)>
			<cfset adres = "#adres#&is_kdv=#attributes.is_kdv#">
		</cfif>
		<cfif isDefined("attributes.is_prom") and len(attributes.is_prom)>
			<cfset adres = "#adres#&is_prom=#attributes.is_prom#">
		</cfif>
		<cfif isDefined("attributes.is_other_money") and len(attributes.is_other_money)>
			<cfset adres = "#adres#&is_other_money=#attributes.is_other_money#">
		</cfif>
		<cfif isDefined("attributes.is_money2") and len(attributes.is_money2)>
			<cfset adres = "#adres#&is_money2=#attributes.is_money2#">
		</cfif>
		<cfif isDefined("attributes.is_iptal") and len(attributes.is_iptal)>
			<cfset adres = "#adres#&is_iptal=#attributes.is_iptal#">
		</cfif>
		<cfif isDefined("attributes.is_discount") and len(attributes.is_discount)>
			<cfset adres = "#adres#&is_discount=#attributes.is_discount#">
		</cfif>
		<cfif isDefined("attributes.kontrol") and len(attributes.kontrol)>
			<cfset adres = "#adres#&kontrol=#attributes.kontrol#">
		</cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			<cfset adres = "#adres#&status=#attributes.status#">
		</cfif>
		<cfif len(attributes.graph_type)>
			<cfset adres = "#adres#&graph_type=#attributes.graph_type#">
		</cfif>
		<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
			<tr>
			<td><cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"></td>
			<!-- sil -->
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
<br/>
<cfif isdefined("attributes.form_submitted") and len(attributes.graph_type) and isdefined('get_total_purchase.recordcount') and get_total_purchase.recordcount>
<table width="98%" cellpadding="2" cellspacing="1" border="0" align="center" class="color-border">
		<tr class="color-row">
			<td align="center">
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "cylinder">
			</cfif>
		    <cfchart
				show3d="yes"
				backgroundcolor="#colorrow#"
				tipbgcolor="#colorrow#"
				labelformat="number"
				pieslicestyle="solid"
				scaleto="100"
				format="flash"
				chartwidth="800"
				chartheight="400"
				scalefrom="100000"
				seriesplacement="default"
				>
				<cfchartseries type="#graph_type#" paintstyle="light">
				<cfoutput query="get_total_purchase"startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset 'sum_of_total#currentrow#' =  NumberFormat(PRICE*100/butun_toplam,'00.00')>
					<!--- Kategori Bazında ise --->
					<cfif attributes.report_type eq 1>
						<cfset item_value = PRODUCT_CAT >
					<!--- Ürün Bazında ise --->
					<cfelseif attributes.report_type eq 2>
						<cfset item_value = left(PRODUCT_NAME,30)>
					<!--- Stok Bazında --->
					<cfelseif attributes.report_type eq 3>
						<cfset item_value = left('#PRODUCT_NAME#&nbsp;#PROPERTY#',30)>
					<!--- Marka Bazında --->
					<cfelseif attributes.report_type eq 9>
						<cfset item_value = left(BRAND_NAME,30)>
					<!---Belge ve Stok Bazında --->
					<cfelseif attributes.report_type eq 17>
						<cfset item_value = left(ORDER_NUMBER,30)>
					</cfif>
					<cfchartdata item="#item_value#" value="#Evaluate("sum_of_total#currentrow#")#">
				 </cfoutput>
				</cfchartseries>
			</cfchart>
			</td>
		</tr>
</table>
</cfif>
<script type="text/javascript">
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
</script>
