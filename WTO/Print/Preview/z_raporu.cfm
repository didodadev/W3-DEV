<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
	SELECT 
		IRS.*,
		IRS.NETTOTAL,
		S.IS_SERIAL_NO,
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.STOCK_CODE,
		S.BARCOD,
		S.PROPERTY,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.MANUFACT_CODE,
		PRODUCT_NAME AS NAME_PRODUCT,
		'' BASKET_EMPLOYEE_ID,
		'' SHIP_ID,
		'' KARMA_PRODUCT_ID,
		'' DISCOUNT1,
		'' DISCOUNT2,
		'' DISCOUNT3,
		'' DISCOUNT4,
		'' DISCOUNT5,
		'' DISCOUNT6,
		'' DISCOUNT7,
		'' DISCOUNT8,
		'' DISCOUNT9,
		'' DISCOUNT10,
		'' COST_PRICE,
		'' MARGIN,
		'' EXTRA_COST,
		'' UNIQUE_RELATION_ID,
		'' PROM_RELATION_ID,
		'' PRODUCT_NAME2,
		'' UNIT2,
		'' AMOUNT2,
		'' EXTRA_PRICE,
		'' EK_TUTAR_PRICE,
		'' EXTRA_PRICE_TOTAL,
		'' EXTRA_PRICE_OTHER_TOTAL,
		'' SHELF_NUMBER,
		'' BASKET_EXTRA_INFO_ID,
		'' SELECT_INFO_EXTRA,
        '' DETAIL_INFO_EXTRA,
		'' PRODUCT_MANUFACT_CODE,
		'' DUE_DATE,
		'' OTVTOTAL,
		'' DELIVER_DATE,
		'' DELIVER_LOC,
		'' DELIVER_DEPT,
		'' SPECT_VAR_ID,
		'' SPECT_VAR_NAME,
		'' LOT_NO,
		'' OTV_ORAN,
		'' PROM_COMISSION,
		'' PROM_COST,
		'' DISCOUNT_COST,
		'' IS_PROMOTION,
		'' PROM_STOCK_ID,
		'' IS_COMMISSION,
		'' LIST_PRICE,
		'' PRICE_CAT,
		'' NUMBER_OF_INSTALLMENT	
	FROM 
		INVOICE_ROW_POS IRS,
		#dsn3_alias#.STOCKS AS S
	WHERE
		IRS.INVOICE_ID=#attributes.IID# AND
		IRS.STOCK_ID=S.STOCK_ID
	ORDER BY
		INVOICE_ROW_ID
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #session.pp.company_id#
	</cfif> 
</cfquery>
<cfquery name="control_cashes" datasource="#dsn2#">
	SELECT 
		CASH.CASH_NAME,
		CASH.CASH_CURRENCY_ID,		
		INVOICE_CASH_POS.KASA_ID,
		CASH_ACTIONS.*
	FROM
		CASH,
		INVOICE_CASH_POS,
		CASH_ACTIONS
	WHERE
		CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID 
		AND CASH.CASH_ID = INVOICE_CASH_POS.KASA_ID
		AND INVOICE_CASH_POS.INVOICE_ID= #attributes.IID#
	ORDER BY 
		INVOICE_CASH_POS.KASA_ID DESC
</cfquery>
<cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#">
	SELECT 
		CREDITCARD_PAYMENT_TYPE.CARD_NO,
		INVOICE_CASH_POS.*,
		CREDIT_CARD_BANK_PAYMENTS.*
	FROM
		#dsn3_alias#.CREDITCARD_PAYMENT_TYPE CREDITCARD_PAYMENT_TYPE,	
		INVOICE_CASH_POS,
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
	WHERE
		INVOICE_CASH_POS.POS_ACTION_ID= CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
		AND CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID=CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID 
		AND INVOICE_CASH_POS.INVOICE_ID = #attributes.IID#
		AND INVOICE_CASH_POS.POS_PERIOD_ID = 6
	ORDER BY
		INVOICE_CASH_POS.POS_ACTION_ID	
</cfquery>
<cfquery name="GET_SALE_DET" datasource="#DSN2#">
	SELECT * FROM INVOICE WHERE INVOICE_CAT  = 69 AND INVOICE_ID = #attributes.iid#
</cfquery>
<cfquery name="get_pos_equipment" datasource="#DSN3#">
	SELECT EQUIPMENT, POS_ID FROM POS_EQUIPMENT WHERE POS_ID = #get_sale_det.pos_cash_id#
</cfquery>
<cfquery name="get_department" datasource="#DSN#">
	SELECT 
		SL.COMMENT,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID
	FROM
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE
		SL.LOCATION_ID = #get_sale_det.DEPARTMENT_LOCATION# AND
		SL.DEPARTMENT_ID = #get_sale_det.DEPARTMENT_ID# AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID	
</cfquery>
<cfif isdefined("attributes.iid")>
	<cfif len(get_sale_det.expense_center_id)>
		<cfquery name="get_exp_center" datasource="#dsn2#">
			SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_sale_det.expense_center_id#
		</cfquery>
		<cfset exp_center_id = get_sale_det.expense_center_id>
		<cfset exp_center_name = get_exp_center.expense>
	<cfelse>
		<cfset exp_center_id = ''>
		<cfset exp_center_name = ''>
	</cfif>
	<cfif len(get_sale_det.expense_item_id)>
		<cfquery name="get_exp_item" datasource="#dsn2#">
			SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_sale_det.expense_item_id#
		</cfquery>
		<cfset exp_item_id = get_sale_det.expense_item_id>
		<cfset exp_item_name = get_exp_item.expense_item_name>
	<cfelse>
		<cfset exp_item_id = ''>
		<cfset exp_item_name = ''>
	</cfif>
<cfelse>
	<cfset exp_center_id = ''>
	<cfset exp_center_name = ''>
	<cfset exp_item_id = ''>
	<cfset exp_item_name = ''>
</cfif>
<cfset sayfa_sayisi = ceiling(get_invoice_row.recordcount /12)>
<cfif sayfa_sayisi eq 0>
	<cfset sayfa_sayisi = 1>
</cfif>
 <cfscript>
	ara_toplam = 0;
	sayfa_toplam = 0;
	satir_start = 1;
	satir_end = 12;
	kdv_toplam = 0;
	kasa_toplam = 0;
	tahsilat_fark = 0;
	pos_toplam = 0;
	indirim_toplam = 0;
</cfscript>

<cfloop from="1" to="#sayfa_sayisi#" index="j">
<table style="width:190mm;" border="0"  align="center" cellspacing="0" cellpadding="0"><!--- style="width:190mm;" --->
	<tr style="height:5mm;">
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	<td colspan="3">
		<table width="100%">
		<tr>
		<cfif len(CHECK.asset_file_name3)>
			<td align="left"  style="width:45mm;">
			<cfoutput>
				<cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
			</cfoutput>
			</td>
		</cfif>
		<td colspan="2" valign="top">
			<cfoutput query="CHECK">
				<strong style="font-size:14px;">#company_name#</strong><br/>
				#address#<br/>
				<b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# &nbsp;&nbsp;&nbsp;
				<b><cf_get_lang_main no='76.'Fax>: </b> #fax# <br/>
				<b><cf_get_lang no='556.VD/VNO'>: </b> #TAX_OFFICE#/#TAX_NO#<br/>
				#web# - #email#
			</cfoutput>
		</td>
		</tr>
		</table>
	</td> 
	</tr>
	<tr>
		<td colspan="3"><hr></td>
	</tr>
	<tr height="30"><!--- z raporu belge_no vs. --->
		<td colspan="3" align="center">
			<table border="0" width="100%">
				<tr style="height:8mm;">
					<td colspan="5" align="center" class="formbold">
						<cfoutput><font size="+1"><b><cf_get_lang_main no='1026.Z Raporu'></b></font></cfoutput>
					</td>
				</tr>
				<tr style="height:5mm;">
					<td style="width:25mm;"><strong><cf_get_lang_main no='330.Tarih'> : </strong></td>
					<td style="width:30mm;" align="left"><cfoutput>#dateformat(get_sale_det.invoice_date,dateformat_style)#</cfoutput></td>			
					<td>&nbsp;</td>
					<td style="width:25mm;" style="text-align:right;"><strong><cf_get_lang_main no='108.Kasa'> : </strong></td>
					<td style="width:30mm;" align="left"><cfoutput>#get_pos_equipment.equipment#</cfoutput></td>			
				</tr>
				<tr style="height:5mm;">
					<td style="width:25mm;"><strong><cf_get_lang_main no='468.Belge No'> : </strong></td>
					<td style="width:30mm;" align="left"><cfoutput>#get_sale_det.invoice_number#</cfoutput></td>			
					<td>&nbsp;</td>
					<td style="width:25mm;" style="text-align:right;"><strong><cf_get_lang_main no='1351.Depo'> : </strong></td>
					<td style="width:55mm;" align="left" nowrap><cfoutput>#get_department.department_head#(#get_department.comment#)</cfoutput></td>							
				</tr>				
			</table>	
		</td>
	</tr>
	<tr><!--- ürünler satırı --->
		<td colspan="3">
		<table align="center" width="100%">
			<tr bgcolor="CCCCCC">
				<td style="width:22mm;" class="formbold" align="center"><cf_get_lang_main no='106.Stok Kodu'></td>
				<td style="width:71mm;" class="formbold" align="center"><cf_get_lang_main no='245.Ürün'></td>
				<td style="width:22mm;" class="formbold" align="center"><cf_get_lang_main no='223.Miktar'></td>
				<td style="width:20mm;" class="formbold" align="center"><cf_get_lang_main no='226.Birim Fiyat'></td>
				<td style="width:15mm;" class="formbold" align="center"><cf_get_lang_main no='77.Para Birimi'></td>
				<td style="width:20mm;" class="formbold" align="center"></td>
				<td style="width:20mm;" class="formbold" align="center"><cf_get_lang_main no='261.Tutar'></td>
			</tr>
			<cfoutput query="get_invoice_row" startrow="#satir_start#" maxrows="#satir_end#">
				<tr>
					<td style="width:22mm;" align="center">#get_invoice_row.stock_code#</td><!--- stok kodu --->
					<td style="width:71mm;" align="left">&nbsp;&nbsp;&nbsp;#get_invoice_row.name_product#</td><!--- ürün --->
					<td style="width:22mm;" align="center">#get_invoice_row.amount# #get_invoice_row.unit#</td><!--- miktar --->
 					<td style="width:20mm;" style="text-align:right;">#TLFormat(get_invoice_row.price)#</td><!--- birim fiyat --->
					<td style="width:15mm;" align="left">#session.ep.money#</td><!--- para birimi --->
					<td style="width:20mm;" align="center">%#get_invoice_row.tax#</td><!--- KDV --->
					<td style="width:20mm;" align="center">#TLFormat(get_invoice_row.amount*get_invoice_row.price)#</td><!--- tutar --->
 				</tr>
				<cfset ara_toplam = ara_toplam + (get_invoice_row.amount*get_invoice_row.price)>
				<cfset kdv_toplam = kdv_toplam + get_invoice_row.taxtotal>
				<cfset sayfa_toplam = sayfa_toplam + get_invoice_row.nettotal>
				<cfset indirim_toplam = indirim_toplam + (get_invoice_row.discounttotal)>
			</cfoutput>
		</table>
		</td>
	</tr>
	<tr style="height:5mm;">
		<td>&nbsp;</td>
	<tr style="height:6mm;">
		<td style="width:110mm;">&nbsp;</td>
		<td style="text-align:right;" style="width:40mm;"><strong><cf_get_lang_main no="153.Ara"> <cf_get_lang_main no="80.Toplam"> : </strong></td>
		<td style="text-align:right;" style="width:40mm;"><cfoutput><strong>#TLFormat(ara_toplam)# #session.ep.money#</strong></cfoutput></td>
	</tr>	
	<tr style="height:6mm;">
	</tr>
	<tr style="height:6mm;">
		<td style="width:110mm;">&nbsp;</td>
		<td style="text-align:right;" style="width:40mm;"><strong><cf_get_lang_main no='1148.Indirim'><cf_get_lang_main no='80.Toplam'> : </strong></td>
		<td style="text-align:right;" style="width:40mm;"><cfoutput><strong>#TLFormat(indirim_toplam)# #session.ep.money#</strong></cfoutput></td>
	</tr>	
	<tr style="height:6mm;">
		<td style="width:110mm;">&nbsp;</td>
		<td style="text-align:right;" style="width:40mm;"><strong><cf_get_lang_main no='227.KDV'><cf_get_lang_main no='80.Toplam'> : </strong></td>
		<td style="text-align:right;" style="width:40mm;"><cfoutput><strong>#TLFormat(kdv_toplam)# #session.ep.money#</strong></cfoutput></td>
	</tr>	
	<tr style="height:6mm;">
		<td style="width:110mm;">&nbsp;</td>
		<td style="text-align:right;" style="width:40mm;"><strong><cf_get_lang_main no='80.Toplam'> : </strong></td>
		<td style="text-align:right;" style="width:40mm;"><cfoutput><strong>#TLFormat(sayfa_toplam + kdv_toplam)# #session.ep.money#</strong></cfoutput></td>
	</tr>
	<tr valign="top">
		<td colspan="3"><hr></td>
	</tr>
	<tr style="width:190mm;"><!--- ödemeler --->
		<td colspan="3">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td width="50%" valign="top">
					<table border="0" width="100%">
						<tr style="height:6mm;">
							<td align="left" colspan="2" valign="top"><strong><cf_get_lang_main no="108.KASA"> <cf_get_lang_main no="435.ÖDEME"></strong></td>
						</tr>
						<cfif control_cashes.recordcount><!--- kasa --->
							<cfloop query="control_cashes">
								<cfquery name="get_money" datasource="#dsn2#">
									SELECT * FROM INVOICE_MONEY WHERE MONEY_TYPE = '#control_cashes.CASH_CURRENCY_ID#' AND ACTION_ID = #attributes.IID#
								</cfquery>
								<cfoutput>
									<tr>
										<td align="left">#cash_name# #cash_currency_id#</td>
										<td style="text-align:right;" style="width:40mm;">#TLFormat(cash_action_value)# #cash_action_currency_id#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									</tr>
									<cfset kasa_toplam= kasa_toplam + (cash_action_value*get_money.RATE2)>
								</cfoutput>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
						</cfif>	
					</table>
					</td>
					<td width="50%" valign="top">
					<table border="0" width="100%">
						<tr style="height:6mm;">
								<td align="left" colspan="2"valign="top"><strong><cf_get_lang_main no="267.POS"> <cf_get_lang_main no="435.ÖDEME"></strong></td>
						</tr>
						<cfif CONTROL_POS_PAYMENT.recordcount><!--- kredi kartı --->	
							<cfloop query="CONTROL_POS_PAYMENT">
								<cfoutput>
									<tr>
										<td align="left">#card_no# </td>
										<td style="text-align:right;" style="width:40mm;">#TLFormat(sales_credit)#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									</tr>
									<cfset pos_toplam = sales_credit + pos_toplam>
								</cfoutput>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
						</cfif>	
					</table>
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top">
					<table border="0" width="100%">
						<tr>
							<td align="left"><strong><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no="108.KASA"> <cf_get_lang_main no="433.TAHSİLAT"></strong></td>
							<td style="text-align:right;" style="width:40mm;"><strong><cfoutput>#TLFormat(kasa_toplam)#</cfoutput></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
						<tr valign="top">
							<td colspan="3"><hr></td>
						</tr>
					</table>
					</td>
					<td width="50%" valign="top">
					<table border="0" width="100%">
						<tr>
							<td align="left"><strong><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no="267.POS"> <cf_get_lang_main no="433.TAHSİLAT"></strong></td>
							<td style="text-align:right;"><strong><cfoutput>#TLFormat(pos_toplam)#</cfoutput></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
						<tr valign="top">
							<td colspan="2"><hr></td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table align="center" width="100%">
				<cfquery name="usd_money" datasource="#DSN2#"><!--- her zaman ytl ve usd gelmesi gerektigi için yazıldı. --->
					SELECT 
						* 
					FROM 
						INVOICE_MONEY
					WHERE 
						MONEY_TYPE ='USD'
						AND ACTION_ID = #attributes.IID#	
				</cfquery>
				<cfoutput>
					<tr>
						<td class="formbold" style="text-align:right;">&nbsp;</td>
						<td class="formbold" style="text-align:right;"><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="36.Satış"></td>
						<td class="formbold" style="text-align:right;"><cf_get_lang_main no="1233.Nakit"> <cf_get_lang_main no="433.Tahsilat"></td>
						<td class="formbold" style="text-align:right;"><cf_get_lang_main no='424.Kredi Kartı Tahsilat'></td>
						<td class="formbold" style="text-align:right;"><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="433.Tahsilat"></td>
						<td class="formbold" style="text-align:right;"><cf_get_lang_main no="36.Satış"> <cf_get_lang_main no="433.Tahsilat"> <cf_get_lang_main no="1171.Farkı"></td>
					</tr>
					<tr>
						<td style="text-align:right;">#session.ep.money#</td>
						<td style="text-align:right;">#TLFormat(sayfa_toplam + kdv_toplam)#</td>
						<td style="text-align:right;">#TLFormat(kasa_toplam)#</td>
						<td style="text-align:right;">#TLFormat(pos_toplam)#</td>
						<td style="text-align:right;">#TLFormat(pos_toplam+kasa_toplam)#</td>
						<cfset tahsilat = sayfa_toplam + kdv_toplam>
						<cfset tahsilat_fark = pos_toplam +  kasa_toplam>
						<td style="text-align:right;">-#TLFormat(tahsilat_fark-tahsilat)#</td>
					</tr>
					<tr>
						<td style="text-align:right;">#session.ep.money2#</td>
						<td style="text-align:right;">#TLFormat((sayfa_toplam + kdv_toplam)/usd_money.rate2)#</td>
						<td style="text-align:right;">#TLFormat(kasa_toplam/usd_money.rate2)#</td>
						<td style="text-align:right;">#TLFormat(pos_toplam/usd_money.rate2)#</td>
						<td style="text-align:right;">#TLFormat(tahsilat_fark/usd_money.rate2)#</td>
						<td style="text-align:right;">-#TLFormat((tahsilat_fark-tahsilat)/usd_money.rate2)#</td>
					</tr>
					<tr valign="top">
						<td colspan="6"><hr></td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table>
				<cfif len(get_sale_det.expense_center_id)>
				<tr>
					<td style="width:95mm;" align="left"><strong><cf_get_lang_main no='1265.Gelir'>-<cf_get_lang_main no='1048.Masraf Merkezi'></strong></td>
					<td style="width:95mm;" align="left"><cfoutput>#exp_center_name#</cfoutput></td>	
				</tr>
				<cfelse>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				</cfif>
				<cfif len(get_sale_det.expense_item_id)>
				<tr>
					<td style="width:95mm;" align="left"><strong><cf_get_lang_main no='1265.Gelir'>-<cf_get_lang_main no='1139.Gider Kalemi'></strong></td>
					<td style="width:95mm;" align="left"><cfoutput>#exp_item_name#</cfoutput></td>
				</tr>
				<cfelse>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>				
				</cfif>
			</table>
		</td>
	</tr>	
</table>
	<cfset satir_start = satir_start + 12>
	<cfset satir_end = satir_start + 11>
</cfloop>
