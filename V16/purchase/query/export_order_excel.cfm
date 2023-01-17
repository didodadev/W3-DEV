<!--- bu sayfanin ersan icin add_options ta aynisi var yapilacak degisiklikler orada da uygulanmalidir FBS 20080806 --->
<cfsetting showdebugoutput="no">
<cfquery name="get_order" datasource="#dsn3#">
	SELECT * FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfquery name="get_order_rows" datasource="#dsn3#">
	SELECT 
		O.*,
		(O.QUANTITY) AS ROW_QUANTITY,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.STOCK_CODE_2
	FROM 
		ORDER_ROW O,
		STOCKS S
	WHERE 
		O.ORDER_ID = #attributes.order_id# AND
		O.STOCK_ID = S.STOCK_ID
	ORDER BY
		O.ORDER_ROW_ID
</cfquery>

<cfset sepet_total = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_net_total = 0>

<cfset filename = "#createuuid()#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="application/vnd.msexcel;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
<style type="text/css">table,td{font-size:12px;font:Verdana, Arial, Helvetica, sans-serif;}</style>
<table>
	<cfoutput>
	<tr align="left">
		<td colspan="2">Firma Adı</td>
		<td colspan="11"><cfif len(GET_ORDER.company_id)>
				#get_par_info(GET_ORDER.company_id,1,0,0)#
			<cfelseif len(GET_ORDER.consumer_id)>
				#get_cons_info(GET_ORDER.consumer_id,1,0)#
			</cfif>
		</td>
	</tr>
	<tr align="left">
		<td colspan="2">Şube Adı - Adresi</td>
		<td colspan="11">#GET_ORDER.SHIP_ADDRESS#</td>
	</tr>
	<tr align="left">
		<td colspan="2">Sipariş Tarihi</td>
		<td colspan="11"><cfif len(GET_ORDER.ORDER_DATE)>#dateformat(GET_ORDER.ORDER_DATE,dateformat_style)#</cfif></td>
	</tr>
	<tr align="left">
		<td colspan="2">Teslim Tarihi</td>
		<td colspan="11"><cfif len(GET_ORDER.DELIVERDATE)>#dateformat(GET_ORDER.DELIVERDATE,dateformat_style)#</cfif></td>
	</tr>
	<tr align="left">
		<td colspan="2">SV No</td>
		<td colspan="10">#GET_ORDER.ORDER_NUMBER#</td>
	</tr>
	</cfoutput>
	<tr align="left">
		<td colspan="13">&nbsp;</td>
	</tr>
	<tr align="left">
		<td colspan="13">&nbsp;</td>
	</tr>
	<tr align="left">
		<th>Barkod</th>
		<th>Tedarikçi Kodu</th>
		<th style="width:40mm;" align="left">Stok Adı</th>
		<th>Koli Adedi</th>
		<th>Birim</th>
		<th>Miktar</th>
		<th style="width:20mm;">B. Fiyat</th>
		<th style="width:15mm;" align="right">İsk. 1</th>
		<th style="width:15mm;" align="right">İsk. 2</th>
		<th style="width:15mm;" align="right">İsk. 3</th>
		<th style="width:15mm;" align="right">İsk. 4</th>
		<th style="width:15mm;" align="right">İsk. 5</th>
		<th>Maliyet</th>
	</tr>
	<cfset t_quantity = 0>
	<cfoutput query="get_order_rows">
    	<cfscript>
			tax_percent = TAX;

			if (not len(discount_1)) indirim1 = 0; else indirim1 = discount_1;
			if (not len(discount_2)) indirim2 = 0; else indirim2 = discount_2;
			if (not len(discount_3)) indirim3 = 0; else indirim3 = discount_3;
			if (not len(discount_4)) indirim4 = 0; else indirim4 = discount_4;
			if (not len(discount_5)) indirim5 = 0; else indirim5 = discount_5;
			indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5);
										
			row_net_price = price/10000000000 * indirim_carpan;
			row_total = Quantity * price;
			row_nettotal = QUANTITY * row_net_price;
			row_taxtotal = row_nettotal * (tax_percent/100);	
			row_lasttotal = row_total + row_taxtotal;
			sepet_total = sepet_total + row_total;
			sepet_total_tax = sepet_total_tax + row_taxtotal; 
			sepet_net_total = sepet_net_total + row_nettotal; 
			sepet_toplam_indirim = sepet_toplam_indirim + row_total - row_nettotal; //discount_
		</cfscript>
    
		<cfset t_quantity = t_quantity + quantity>
		<cfquery name="get_koli" datasource="#dsn3#" maxrows="1">
			SELECT 
				MULTIPLIER
			FROM
				PRODUCT_UNIT
			WHERE 
				PRODUCT_ID = #product_id#
				AND ADD_UNIT='Koli'
			ORDER BY
				PRODUCT_UNIT_ID DESC
		</cfquery>
		<tr>
			<td>#barcod#</td>
			<td><cfif len(manufact_code)>#manufact_code#<cfelse>-</cfif></td>
			<td>#product_name#</td>
			<td><cfif len(get_koli.multiplier)>#TLFormat(quantity/get_koli.multiplier)#<cfelse>-</cfif></td>
			<td>#unit#</td>
			<td align="center">#quantity#</td>
			<td align="right" style="text-align:right;">#TLFormat(price)#</td>
			<td align="right" style="text-align:right;">#TLFormat(discount_1)#</td>
			<td align="right" style="text-align:right;">#TLFormat(discount_2)#</td>
			<td align="right" style="text-align:right;">#TLFormat(discount_3)#</td>
			<td align="right" style="text-align:right;">#TLFormat(discount_4)#</td>
			<td align="right" style="text-align:right;">#TLFormat(discount_5)#</td>
			<td align="right" style="text-align:right;">
				<cfif len(cost_price) and extra_cost>
					#TLFormat(cost_price + extra_cost)#
				<cfelseif len(extra_cost)>	
					#TLFormat(extra_cost)#
				<cfelseif len(cost_price)>
					#TLFormat(cost_price)#
				<cfelse>
					#TLFormat(0)#
				</cfif>
			</td>
		</tr>
	</cfoutput>
	<cfoutput>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="9">&nbsp;</td>
			<th align="left" colspan="2">Ara Toplam</th>
			<th align="right" colspan="2">#TLFormat(sepet_total)#</th>
		</tr>
		<tr>
			<td colspan="9">&nbsp;</td>
			<th align="left" colspan="2">İskonto</th>
			<th align="right" colspan="2">#TLFormat(sepet_toplam_indirim)#</th>
		</tr>
		<tr>
			<td colspan="9">&nbsp;</td>
			<th align="left" colspan="2">Vergi</th>
			<th align="right" colspan="2">#TLFormat(sepet_total_tax)#</th>
		</tr>
		<tr>
			<td colspan="9">&nbsp;</td>
			<th align="left" colspan="2">Toplam Tutar</th>
			<th align="right" colspan="2">#TLFormat(sepet_total-sepet_toplam_indirim+sepet_total_tax,2)#</th>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="3">Satınalma Uzmanı</td>
			<td colspan="2">&nbsp;</td>
			<td align="center" colspan="4">Satınalma Müdürü</td>
			<td>&nbsp;</td>
		</tr>
	</cfoutput>
</table>
