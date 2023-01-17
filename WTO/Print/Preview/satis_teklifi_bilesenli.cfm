<!--- Standart Satis Teklifi Bilesenli --->
<cfquery name="Our_Company" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME1,
		COMPANY_NAME, 
		TEL_CODE, 
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL 
	FROM 
		OUR_COMPANY 
	WHERE 
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset attributes.Offer_Id = attributes.action_id>
<cfset attributes.Purchase_Sales = 1>
    <cfquery name="Get_Offer" datasource="#dsn3#">
        SELECT 
            OFFER_ID,
            PARTNER_ID,
            OFFER_DETAIL,
            OFFER_HEAD,
            OFFER_NUMBER,
            OFFER_DATE,
            FINISHDATE,
            SHIP_ADDRESS,
            DELIVERDATE,
            PAYMETHOD,
            SHIP_METHOD,
            SALES_EMP_ID
        FROM 
            OFFER 
        WHERE 
            OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Offer_Id#">
    </cfquery>
<cfif len(get_offer.paymethod)>
<cfset attributes.paymethod_id = get_offer.paymethod>
    <cfquery name="Get_Paymethod" datasource="#dsn#">
       SELECT Paymethod FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Paymethod_Id#">
    </cfquery>
</cfif>
<cfif len(get_offer.Ship_Method)>
<cfset attributes.Ship_Method = Get_Offer.Ship_Method>
	<cfquery name="Get_Ship_Method" datasource="#dsn#">
		SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
	</cfquery>
</cfif> 
<cfquery name="Get_Offer_Rows" datasource="#dsn3#">
    SELECT
        ORR.*,
        0 SPECT_ID,
        '' MONEY_CUR,
        '' SPECT_NAME,
        0 AS SPECT_PRICE,
        0 SPECT_AMOUNT
    FROM
        OFFER_ROW ORR,
        STOCKS S
    WHERE
        ORR.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Offer_Id#">
        AND ORR.STOCK_ID = S.STOCK_ID	
        
	UNION ALL
    
    SELECT
        ORR.* ,
        SR.SPECT_ID,
        SR.MONEY_CURRENCY AS MONEY_CUR,
        SR.PRODUCT_NAME ,
        SR.TOTAL_VALUE AS SPECT_PRICE,
        SR.AMOUNT_VALUE SPECT_AMOUNT
    FROM
        OFFER_ROW ORR,
        STOCKS S,
        SPECTS_ROW SR
    WHERE
        SR.SPECT_ID = ORR.SPECT_VAR_ID
        AND ORR.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Offer_Id#">
        AND SR.STOCK_ID = S.STOCK_ID
    ORDER BY 
        OFFER_ROW_ID,
        SPECT_ID	
</cfquery>
<cfscript>
	sepet_total = 0;
	sepet_toplam_indirim = 0;
	sepet_total_tax = 0;
	sepet_net_total = 0;
	genel_toplam = 0;
</cfscript>
<table border="0" bgcolor="FFFFFF" width="720" cellpadding="0" cellspacing="0">
<cfoutput>
	<tr>
		<td width="20" height="10">&nbsp;</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td valign="bottom"> <span class="headbold">#Our_Company.company_name# </span><br/><br/>
			#Our_Company.address#<br/>
			<b><cf_get_lang_main no='87.Telefon'>:</b>(#Our_Company.tel_code#) - #Our_Company.tel#,#Our_Company.tel2#,#Our_Company.tel3#,#Our_Company.tel4# <b><cf_get_lang_main no='76.Fax'>:</b>#Our_Company.fax#<br/>
			#Our_Company.web# - #Our_Company.email# 
        </td>
		<td style="text-align:right"><img src="#file_web_path#settings/#Our_Company.asset_file_name1#" border="0"></td>
	</tr>
</cfoutput>
</table>
<br/><br/>
<table border="0" width="720">
<cfoutput>
	<tr>
		<td rowspan="20" width="20">&nbsp;</td>
		<td class="txtbold" width="100"> <cf_get_lang_main no='800.Teklif No'></td>
		<td width="275">#Get_Offer.Offer_Number#</td>
		<td width="80" class="txtbold"><cf_get_lang no='428.Teklif Tarihi'></td>
		<td>#dateformat(Get_Offer.Offer_Date,dateformat_style)#</td>
	</tr>
	<tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
		<td><cfif len(Get_Offer.Paymethod)>#Get_Paymethod.Paymethod#<cfelse>&nbsp;</cfif> </td>
		<td width="125" class="txtbold"><cf_get_lang_main no='1212.Geçerlilik Tarihi'></td>
		<td>#dateformat(Get_Offer.Finishdate,dateformat_style)# </td>
	</tr>
	<tr>
		<cfif len(Get_Offer.Ship_Method)>
            <td class="txtbold"><cf_get_lang no="925.Teslim Bilgisi"></td>
            <td>#Get_Ship_Method.Ship_Method# #Get_Offer.Ship_Address#</td>
		</cfif>
		<td class="txtbold"><cf_get_lang_main no='233.Teslim Tarihi'></td>
		<td>#dateformat(Get_Offer.Deliverdate,dateformat_style)# </td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='957.Hazirlayan'></td>
		<td><cfif len(Get_Offer.Sales_Emp_Id)>#get_emp_info(Get_Offer.Sales_Emp_Id,0,0)#</cfif></td>
		<cfif isdefined("get_offer.valid_emp") and len(Get_Offer.valid_emp)>
			<cfif Get_Offer.valid eq 1>
				<td class="txtbold"><cf_get_lang no="912.Onaylayan"></td>
				<td>#get_emp_info(Get_Offer.VALIDATOR_POSITION_CODE,1,0)#</td>
			</cfif>
		</cfif>
	</tr>
</cfoutput>
</table><br/><br/>
<table border="0" width="720">
<cfoutput>
	<tr>
		<td width="20" rowspan="4"></td>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td width="100" class="txtbold"><cf_get_lang_main no='1195.Firma'>/<cf_get_lang_main no='166.Yetkili'></td>
		<td class="txtbold"><cfif len(Get_Offer.Partner_Id)><cfset contact_type = "p">#get_par_info(Get_Offer.Partner_Id,0,0,0)#</cfif></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
		<td class="txtbold">#Get_Offer.Offer_Head#</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>#Get_Offer.Offer_Detail#</td>
	</tr>
</cfoutput>
</table><br/><br/>
<table border="0" width="720" cellpadding="3" cellspacing="3">
	<tr class="formbold">
		<td width="18" rowspan="100">&nbsp;</td>
		<td bgcolor="CCCCCC"><cf_get_lang_main no='217.Açıklama'></td>
		<td style="text-align:right" width="90" bgcolor="CCCCCC"><cf_get_lang_main no='223.Miktar'></td>
		<td style="text-align:right" width="90" bgcolor="CCCCCC"><cf_get_lang_main no='226.BirimFiyat'></td>
		<td style="text-align:right" width="115" bgcolor="CCCCCC"><cf_get_lang_main no='80.Toplam'></td>
	</tr>
	<cfoutput query="Get_Offer_Rows">
		<cfscript>
			if (not len(QUANTITY)) QUANTITY = 1;
			if (not len(PRICE)) 
			price = 0;
			tax_percent = TAX;
			if (not len(discount_1)) indirim1 = 0; else indirim1 = discount_1;
			if (not len(discount_2)) indirim2 = 0; else indirim2 = discount_2;
			if (not len(discount_3)) indirim3 = 0; else indirim3 = discount_3;
			if (not len(discount_4)) indirim4 = 0; else indirim4 = discount_4;
			if (not len(discount_5)) indirim5 = 0; else indirim5 = discount_5;
			indirim6 = 0;
			indirim7 = 0;
			indirim8 = 0;
			indirim9 = 0;
			indirim10 = 0;
			indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5);
			
			other_money_value = price_other;	
			other_money_price = OTHER_MONEY_VALUE;
			net_maliyet = NET_MALIYET;
			marj = MARJ;
			if(len(price_other))
			other_money_rowtotal = price_other;
			else
			other_money_rowtotal = price;
			row_total = QUANTITY * price;
			row_nettotal = round((row_total/10000000000) * indirim_carpan);
			row_taxtotal = round(row_nettotal * (tax_percent/100));
			row_lasttotal = row_nettotal + row_taxtotal;
			sepet_total = sepet_total + row_total; //subtotal_
			sepet_toplam_indirim = sepet_toplam_indirim + (round(row_total) - round(row_nettotal)); //discount_
			sepet_total_tax = sepet_total_tax + row_taxtotal; //totaltax_
			sepet_net_total = sepet_net_total + row_lasttotal; //nettotal_
			genel_toplam = genel_toplam + row_nettotal; //genel_toplam
		</cfscript>
		<cfif SPECT_ID eq 0>
		<tr>
			<td>#PRODUCT_NAME#</td>
			<td style="text-align:right">#QUANTITY# #UNIT#</td>
			<td style="text-align:right">#TLFORMAT(PRICE)#</td>
			<td style="text-align:right">#TLFORMAT(row_nettotal)#</td>
		</tr>
		<cfelse>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;#SPECT_NAME#</td>
			<td style="text-align:right">#QUANTITY*SPECT_AMOUNT# #UNIT#</td>
			<td style="text-align:right">#TLFORMAT(SPECT_PRICE)# #MONEY_CUR#</td>
		</tr>
		</cfif>
	</cfoutput>
</table>
<table border="0" width="720" cellpadding="3" cellspacing="3">
	<tr>
		<td></td>
		<td></td>
		<td colspan="3"></td>
		<td style="text-align:right"></td>
		<td style="text-align:right"><cf_get_lang_main no='268.Genel Toplam'> : &nbsp;&nbsp;<cfoutput>#TLFormat(genel_toplam)# #session.ep.money#</cfoutput></td>
	</tr>
</table>
<table border="0" width="720">
	<tr>
		<td width="20"></td>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td></td>
		<td width="250" valign="top"><cf_get_lang no="926.Fiyatlara KDV Dahil değildir">.</td>
		<td valign="top" style="text-align:right"><b><cf_get_lang no="913.Teklifimizin işleme konması için lütfen onaylayınız"></b><br/><br/><cf_get_lang_main no='158.Ad Soyad'> - <cf_get_lang_main no='1545.Imza'><br/><br/><br/></td>
	</tr>
</table>
