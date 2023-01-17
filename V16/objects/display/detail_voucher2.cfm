<cfquery name="get_voucher" datasource="#dsn#">
	SELECT FROM_CHEQUE_VOUCHER_ID FROM CHEQUE_VOUCHER_COPY_REF WHERE TO_PERIOD_ID = #session.ep.period_id# AND TO_CHEQUE_VOUCHER_ID = #attributes.iid# AND IS_CHEQUE = 0
</cfquery>
<cfif get_voucher.recordcount>
	<cfset attributes.iid = get_voucher.from_cheque_voucher_id>
	<cfquery name="get_period" datasource="#dsn3#">
		SELECT PERIOD_ID FROM ORDER_VOUCHER_RELATION WHERE VOUCHER_ID = #attributes.iid# AND PERIOD_ID IS NOT NULL
	</cfquery>
	<cfif get_period.recordcount>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #get_period.period_id#
		</cfquery>
		<cfset new_dsn2 = '#dsn#_#get_company.period_year#_#get_company.our_company_id#'>
		<cfquery name="get_new_period" datasource="#dsn#">
			SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_company.our_company_id# AND PERIOD_YEAR = #get_company.period_year+1#
		</cfquery>
		<cfif get_new_period.recordcount>
			<cfset new_dsn2_1 = '#dsn#_#get_company.period_year+1#_#get_company.our_company_id#'>
		</cfif>
	<cfelse>
		<cfset get_new_period.recordcount = 0>
		<cfset new_dsn2 = '#dsn2#'>
	</cfif>
<cfelse>
	<cfset get_new_period.recordcount = 0>
	<cfset new_dsn2 = '#dsn2#'>	
</cfif>
<cfquery name="get_voucher_detail" datasource="#new_dsn2#">
	SELECT
		VOUCHER.VOUCHER_STATUS_ID,
		VOUCHER.VOUCHER_ID,
		VOUCHER.VOUCHER_NO,
		VOUCHER.CURRENCY_ID,
		VOUCHER.VOUCHER_DUEDATE,
		VOUCHER.VOUCHER_CODE,
		VOUCHER.VOUCHER_VALUE,
		VOUCHER.DELAY_INTEREST_SYSTEM_VALUE,
		VOUCHER_PAYROLL.PAYROLL_NO,
		VOUCHER_PAYROLL.COMPANY_ID,
		VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID,
		VOUCHER_PAYROLL.PAYROLL_CASH_ID,
		VOUCHER_PAYROLL.PAYMENT_INVOICE_ID,
		VOUCHER_PAYROLL.PAYMENT_ORDER_ID,
		VOUCHER_PAYROLL.PAYMENT_OFFER_ID,
		VOUCHER_PAYROLL.COMPANY_ID,
		VOUCHER_PAYROLL.CONSUMER_ID,
		SP.DELAY_INTEREST_DAY,
		SP.DELAY_INTEREST_RATE,
		SP.IN_ADVANCE,
		SP.DUE_MONTH,
		SP.DUE_DATE_RATE
	FROM
		VOUCHER VOUCHER,
		VOUCHER_PAYROLL VOUCHER_PAYROLL,
		#dsn_alias#.SETUP_PAYMETHOD SP
	WHERE
		VOUCHER.VOUCHER_ID IS NOT NULL AND
		VOUCHER_PAYROLL.PAYMETHOD_ID = SP.PAYMETHOD_ID AND 
		VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
		VOUCHER.VOUCHER_ID=#attributes.iid#
</cfquery>
<cfquery name="get_order_id" datasource="#dsn3#">
	SELECT ORDER_ID FROM ORDER_VOUCHER_RELATION WHERE ORDER_ID = #get_voucher_detail.payment_order_id#
</cfquery>
<cfif len(get_order_id.ORDER_ID)>
	<cfquery name="get_sale_vouchers" datasource="#new_dsn2#">
		SELECT 
			VP.PAYROLL_NO,
			VP.ACTION_ID,
			V.VOUCHER_ID,
			V.VOUCHER_VALUE,
			V.VOUCHER_DUEDATE,
			V.OTHER_MONEY_VALUE
		FROM 
			VOUCHER V, 
			VOUCHER_PAYROLL VP 
		WHERE 
			V.VOUCHER_PAYROLL_ID = VP.ACTION_ID AND 
			VP.PAYMENT_ORDER_ID = #get_order_id.ORDER_ID#
	</cfquery>
	<cfquery name="get_order_detail" datasource="#dsn3#">
		SELECT
			*
		FROM
			ORDERS
		WHERE
			ORDER_ID = #get_order_id.ORDER_ID#
	</cfquery>
	<cfset location_info_ = get_location_info(get_order_detail.deliver_dept_id,get_order_detail.location_id,1,1)>
	<cfquery name="get_order_row" datasource="#dsn3#">
		SELECT
			ORDER_ROW.*,
			S.STOCK_CODE
		FROM
			ORDER_ROW,
			STOCKS S
		WHERE
			ORDER_ID = #get_order_id.ORDER_ID#	AND
			ORDER_ROW.STOCK_ID=S.STOCK_ID
		ORDER BY
			ORDER_ROW.ORDER_ROW_ID
	</cfquery>
	<cfquery name="GET_ORDER_MONEY" datasource="#dsn3#">
		SELECT * FROM ORDER_MONEY WHERE ACTION_ID = #get_order_id.ORDER_ID# AND IS_SELECTED=1
	</cfquery>
	<cfif len(get_voucher_detail.COMPANY_ID) and get_voucher_detail.COMPANY_ID neq 0>
		<cfset adres = ''>
		<cfset county_id = ''>
		<cfset city_id = ''>
		<cfset country_id = ''>
		<cfset musteri = ''>
		<cfset Kategori = ''>
		<cfset vergi_no = ''>
		<cfset vergi_dairesi = ''>
		<cfquery name="get_comp_name" datasource="#dsn#">
			SELECT 
				TAXOFFICE,
				TAXNO,
				COMPANY_ADDRESS,
				COUNTY,
				CITY,
				COUNTRY,
				COMPANY.FULLNAME,
				MEMBER_CODE 
			FROM 
				COMPANY 
			WHERE 
				COMPANY.COMPANY_ID=#get_voucher_detail.COMPANY_ID#
		</cfquery>
		<cfset musteri = get_comp_name.FULLNAME>
		<cfset adres = get_comp_name.company_address>
		<cfset county_id = get_comp_name.county>
		<cfset city_id = get_comp_name.city>
		<cfset country_id = get_comp_name.country>
		<cfset Kategori = 'Kurumsal Üye'>
		<cfset vergi_no = get_comp_name.taxno>
		<cfset vergi_dairesi = get_comp_name.taxoffice>
	<cfelseif len(get_voucher_detail.CONSUMER_ID)>
		<cfquery name="GET_CONS_NAME" datasource="#dsn#">
			SELECT 
				TAX_OFFICE,
				TAX_NO,
				MEMBER_CODE,
				WORK_COUNTY_ID,
				WORK_CITY_ID,
				WORK_COUNTRY_ID,
				WORKADDRESS,
				CONSUMER_ID 
			FROM 
				CONSUMER 
			WHERE 
				CONSUMER_ID=#get_voucher_detail.CONSUMER_ID#
		</cfquery>
		<cfset musteri = get_cons_info(GET_CONS_NAME.CONSUMER_ID,0,0)>
		<cfset adres = get_cons_name.workaddress>
		<cfset county_id = get_cons_name.work_county_id>
		<cfset city_id = get_cons_name.work_city_id>
		<cfset country_id = get_cons_name.work_country_id>
		<cfset Kategori = 'Bireysel Üye'>
		<cfset vergi_no = get_cons_name.tax_no>
		<cfset vergi_dairesi = get_cons_name.tax_office>
	</cfif>
	<table width="100%"  border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
	  <tr class="color-list">
		<td height="35">
		<table style="text-align:right;" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td class="headbold"><cf_get_lang dictionary_id ='58502.Senet Numarası'> : <cfoutput>#get_voucher_detail.VOUCHER_NO#</cfoutput></td> 
				<td  style="text-align:right;"></td>
			</tr>
		</table>
		</td>
	  </tr>
	  <tr class="color-row">
		<td valign="top" colspan="2">
		<cfoutput>
		  <table>
		  		<tr>
				  <td width="100" class="txtbold"><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
				  <td width="200">
					#musteri#
				  </td>
				  <td class="txtbold"><cf_get_lang dictionary_id ='33498.Satış Tarihi'></td>
				  <td>#dateformat(get_order_detail.order_date,dateformat_style)#</td>
				</tr>
				<tr>
		  		  <td class="txtbold"><cf_get_lang dictionary_id ='58609.Üye Kategorisi'></td>
				  <td>#Kategori#</td>
				  <td class="txtbold"><cf_get_lang dictionary_id ='39653.Satış No'></td>
				  <td>#get_order_detail.order_number#</td>
				</tr>
				<tr>
		  		  <td class="txtbold"><cf_get_lang dictionary_id ='57752.Vergi No'></td>
				  <td>#vergi_no#</td>
				  <td class="txtbold"><cf_get_lang dictionary_id ='58763.Depo'></td>
				  <td>#listfirst(location_info_,',')#</td>
				</tr>
				<tr>
		  		  <td class="txtbold"><cf_get_lang dictionary_id ='58762.Vergi Dairesi'></td>
				  <td>#vergi_dairesi#</td>
				  <td class="txtbold">&nbsp;</td>
				  <td></td>
				</tr>
				<tr>
		  		  <td class="txtbold"><cf_get_lang dictionary_id ='58723.Adres'></td>
				  <td>
				  	#adres#
					<cfif len(county_id)>
					<cfquery name="GET_COUNTY" datasource="#dsn#">
						SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #county_id#
					</cfquery> - #GET_COUNTY.COUNTY_NAME#
					</cfif>
					<cfif len(city_id)>
					  <cfquery name="GET_CITY" datasource="#dsn#">
						SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #city_id#
					  </cfquery> - #GET_CITY.CITY_NAME#
					</cfif>
				  </td>
				  <td>&nbsp;</td>
				  <td></td>
				</tr>
		  </table>
		  </cfoutput>
		  <br/>
		  <br/>
		  <table width="100%"  border="0" cellspacing="1" cellpadding="2">
			<tr class="color-header">
			  <td clasS="form-title" width="100"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
			  <td width="60"  clasS="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
			  <td clasS="form-title" width="95"><cf_get_lang dictionary_id ='34128.KDVli Birim Fiyat'></td>
			  <td width="80"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id ='34129.Taksit Sayısı'></td>
			  <td width="60"  clasS="form-title" style="text-align:right;"><cf_get_lang dictionary_id ='58501.Vade Farkı'></td>
			  <td clasS="form-title" width="110"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></td> 
			  <td width="70"  clasS="form-title" style="text-align:right;"><cf_get_lang dictionary_id ='57644.Son Toplam'></td>
			  <td width="70"  clasS="form-title" style="text-align:right;"><cf_get_lang dictionary_id ='57642.Net Toplam'></td>
			</tr>
			<cfset toplam_indirim_miktari = 0>	
			<cfoutput query="get_order_row">
			<tr>
				<td>#PRODUCT_NAME#</td>
				<td>#STOCK_CODE#</td>
				<td>&nbsp;</td>
				<td  style="text-align:right;">#NUMBER_OF_INSTALLMENT#</td>
				<td>&nbsp;</td>
				<td><cfif len(BASKET_EMPLOYEE_ID)>#get_emp_info(BASKET_EMPLOYEE_ID,0,0)#</cfif></td>
				<td>&nbsp;</td>
				<td  style="text-align:right;">#TLFormat(NETTOTAL)#</td>
			</tr>
			<cfset indirim = DISCOUNT_1 + DISCOUNT_2 + DISCOUNT_3 + DISCOUNT_4 + DISCOUNT_5 + DISCOUNT_6 + DISCOUNT_7 + DISCOUNT_8 + DISCOUNT_9 + DISCOUNT_10>
			<cfset toplam_indirim_miktari = toplam_indirim_miktari + indirim>
			</cfoutput>		
		  </table>
		  <br/>
		  <br/>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td width="45%"  style="text-align:right;">
			  <cfoutput>
				<table border="0">
				  <tr>
					<td></td>
					<td class="txtbold" width="100"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td width="100"  style="text-align:right;">&nbsp;#TLFormat(get_order_detail.grosstotal)#</td>
					<td width="80"  style="text-align:right;">
					&nbsp;&nbsp;#TLFormat(wrk_round(get_order_detail.grosstotal/GET_ORDER_MONEY.RATE2))#
					</td>
				  </tr>
				  <tr>
				  <cfif not len(get_order_detail.DISCOUNTTOTAL)><cfset get_order_detail.DISCOUNTTOTAL = 0></cfif>
					<td></td>
					<td class="txtbold" width="100"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
					<td width="100"  style="text-align:right;">&nbsp;#TLFormat(toplam_indirim_miktari+get_order_detail.DISCOUNTTOTAL)#</td>
					<td width="80"  style="text-align:right;">
					<cfset doviz_indirim = (toplam_indirim_miktari+get_order_detail.DISCOUNTTOTAL)>
					&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_indirim)#
					</td>
				  </tr>					  
				  <tr>
					<td></td>
					<td class="txtbold" width="100"><cf_get_lang dictionary_id='58765.Satıraltı İndirim'></td>
					<td  style="text-align:right;">&nbsp;#TLFormat(get_order_detail.DISCOUNTTOTAL)#</td>
					<td width="80"  style="text-align:right;">#TLFormat(wrk_round(get_order_detail.DISCOUNTTOTAL/GET_ORDER_MONEY.RATE2))#</td>
				  </tr>
				  <tr>
					<td></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57643.KDV Toplam'></td>
					<td  style="text-align:right;">&nbsp;#TLFormat(get_order_detail.taxtotal)#</td>
					<td width="80"  style="text-align:right;">
					<cfset doviz_toplamkdv = wrk_round(get_order_detail.taxtotal/GET_ORDER_MONEY.RATE2)>
					&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_toplamkdv)#
					</td>
				  </tr>
				  <tr>
					<td></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
					<td  style="text-align:right;">&nbsp;#TLFormat(get_order_detail.nettotal)#</td>
					<td width="80"  style="text-align:right;">
					<cfset doviz_tutar = wrk_round(get_order_detail.nettotal/GET_ORDER_MONEY.RATE2)>
					&nbsp;&nbsp;#TLFormat(doviz_tutar)#
					</td>
				  </tr>
				</table>
			  </cfoutput>
			  </td>
			  <td width="55%"  valign="top" style="text-align:right;">
				  <table>
				  	<tr>
						<td class="txtbold" width="100" align="center"><cf_get_lang dictionary_id='57673.Tutar'></td>
						<td class="txtbold" align="center"><cf_get_lang dictionary_id='57881.Vade Tarihi'></td>
					</tr>
				  	<cfoutput query="get_sale_vouchers">
					<tr>
						<td style="width:21mm;" >#TLFormat(OTHER_MONEY_VALUE)#</td>
						<td style="width:21mm;" align="center">#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
					</tr>
				    </cfoutput>
				 </table>
			  </td>
			</tr>
		  </table>
		</td>
	  </tr>
</table>
<cfelse>
	<br/>
	<b>
	<cf_get_lang dictionary_id ='34132.Sipariş Kaydı Bulunamadı'>..
	</b>
</cfif>

