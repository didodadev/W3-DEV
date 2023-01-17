<!--- Standart Satis Teklifi --->
<cfset attributes.offer_id = attributes.action_id>
<cfset attributes.purchase_sales = 1>
<cfquery name="Our_Company" datasource="#dsn#">
    SELECT 
        ASSET_FILE_NAME1,
		ASSET_FILE_NAME1_SERVER_ID,
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
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
</cfquery>
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
        SALES_EMP_ID,
		OTHER_MONEY
    FROM 
    	OFFER 
    WHERE 
    	OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Offer_Id#">
</cfquery>
<cfquery name="Get_Offer_Row" datasource="#dsn3#">
    SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Offer_Id#"> ORDER BY OFFER_ROW_ID
</cfquery>
<cfif len(Get_Offer.Paymethod)>
	<cfset attributes.Paymethod_id = Get_Offer.Paymethod>
    <cfquery name="Get_Paymethod" datasource="#dsn#">
        SELECT Paymethod FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Paymethod_Id#">
    </cfquery>
</cfif>
<cfif len(Get_Offer.Ship_Method)>
	<cfset attributes.Ship_Method = Get_Offer.Ship_Method>
    <cfquery name="Get_Ship_Method" datasource="#dsn#">
        SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ship_Method#">
    </cfquery>
</cfif>
<cfscript>
	sepet_total = 0;
	sepet_toplam_indirim = 0;
	sepet_total_tax = 0;
	sepet_net_total = 0;
	genel_toplam = 0;
	genel_toplam_doviz = 0;
</cfscript>
<table bgcolor="FFFFFF" width="720">
	<cfoutput>
        <tr>
            <td width="20" height="10">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td valign="bottom">
                <span class="headbold">#Our_Company.company_name# </span><br/><br/>
                #Our_Company.address#<br/>
                <b><cf_get_lang_main no="87.Tel">:</b>(#Our_Company.tel_code#) - #Our_Company.tel#,#Our_Company.tel2#,#Our_Company.tel3#,#Our_Company.tel4# <b><cf_get_lang_main no="76.Fax">:</b>#Our_Company.fax#<br/>
                #Our_Company.web# - #Our_Company.email#
            </td>
            <td style="text-align:right">
				<cfif len(Our_Company.asset_file_name1)>
                    <cf_get_server_file output_file="settings/#Our_Company.asset_file_name1#" output_server="#Our_Company.asset_file_name1_server_id#" output_type="5">
                </cfif>
	            <!---<img src="http://#cgi.http_host#/#file_web_path#settings/#Our_Company.asset_file_name1#" border="0">--->
            </td>
        </tr>
    </cfoutput>
</table><br/><br/>
<table width="720">
	<cfoutput>
        <tr>
            <td rowspan="20" width="20"></td>
            <td width="100" class="txtbold"><cf_get_lang_main no='800.Teklif No'></td>
            <td width="275">#Get_Offer.offer_number#</td>
            <td width="80" class="txtbold"><cf_get_lang no='428.Teklif Tarihi'></td>
            <td>#dateformat(date_add('h',session.ep.time_zone,Get_Offer.offer_date),dateformat_style)#</td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
            <td><cfif len(Get_Offer.Paymethod)>#Get_Paymethod.Paymethod#<cfelse>&nbsp;</cfif> </td>
            <td width="125" class="txtbold"><cf_get_lang_main no='1212.Geçerlilik Tarihi'></td>
            <td>#dateformat(Get_Offer.finishdate,dateformat_style)#</td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang no="925.Teslim Bilgisi"></td>
            <td><cfif len(Get_Offer.Ship_Method)>#Get_Ship_Method.Ship_Method#</cfif> #Get_Offer.Ship_Address#</td>
            <td class="txtbold"><cf_get_lang_main no='233.Teslim Tarihi'></td>
            <td>#dateformat(Get_Offer.deliverdate,dateformat_style)# </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang no='957.Hazirlayan'></td>
            <td><cfif len(Get_Offer.Sales_Emp_Id)>#get_emp_info(Get_Offer.Sales_Emp_Id,0,0)#</cfif></td>
            <cfif isdefined("Get_Offer.valid_emp") and len(Get_Offer.valid_emp)>
                <cfif Get_Offer.valid eq 1>
                    <td class="txtbold"><cf_get_lang no="912.Onaylayan"></td>
                    <td>#get_emp_info(Get_Offer.VALIDATOR_POSITION_CODE,1,0)#</td>
                </cfif>
            </cfif>
        </tr>
    </cfoutput>
</table><br/><br/>
<table width="720">
	<cfoutput>
        <tr>
            <td width="20" rowspan="4">&nbsp;</td>
            <td colspan="2"><hr></td>
        </tr>
        <tr>
            <td width="100" class="txtbold"><cf_get_lang_main no='1195.Firma'>/<cf_get_lang_main no='166.Yetkili'></td>
            <td class="txtbold">
            <cfif len(Get_Offer.PARTNER_ID)>
                <cfset contact_type = "p">
                #get_par_info(Get_Offer.PARTNER_ID,0,0,0)#
            </cfif>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
            <td class="txtbold">#Get_Offer.offer_head#</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>#Get_Offer.offer_detail#</td>
        </tr>
    </cfoutput>
</table><br/><br/>
<table width="720" cellpadding="3" cellspacing="3">
    <tr class="formbold">
        <td width="18" rowspan="100"></td>
        <td bgcolor="CCCCCC"><cf_get_lang_main no='217.Açıklama'></td>
        <td width="90" style="text-align:right" bgcolor="CCCCCC"><cf_get_lang_main no='223.Miktar'></td>
        <td width="90" style="text-align:right" bgcolor="CCCCCC"><cf_get_lang_main no='226.BirimFiyat'></td>
        <td width="115" style="text-align:right"  bgcolor="CCCCCC"><cf_get_lang_main no='80.Toplam'></td>
    </tr>
    <cfoutput query="Get_Offer_Row">
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
			genel_toplam_doviz = genel_toplam_doviz + (price*quantity); //genel_toplam doviz
        </cfscript>
        <tr>
            <td>#PRODUCT_NAME#</td>
            <td style="text-align:right">#QUANTITY# #UNIT#</td>
            <td style="text-align:right">#TLFORMAT(price)#</td>
			<td style="text-align:right">#TLFORMAT(price*QUANTITY)#</td>
        </tr>
    </cfoutput>
</table>
<table width="720" cellpadding="3" cellspacing="3">
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="3">&nbsp;</td>
        <td style="text-align:right">&nbsp;</td>
        <td style="text-align:right">
            <cf_get_lang_main no='268.Genel Toplam'> : &nbsp;&nbsp;
            <cfoutput>#TLFormat(genel_toplam_doviz)# TL</cfoutput>
        </td>
    </tr>
</table>
<table width="720">
    <tr>
        <td width="20">&nbsp;</td>
        <td colspan="2"><hr></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td width="250" valign="top"> <cf_get_lang no="926.Fiyatlara KDV Dahil değildir">. </td>
        <td valign="top" style="text-align:right"><b><cf_get_lang no="913.Teklifimizin işleme konması için lütfen onaylayınız"></b><br/><br/>
            <cf_get_lang_main no='158.Ad Soyad'>- <cf_get_lang_main no='1545.Imza'><br/><br/><br/>
        </td>
    </tr>
</table>
