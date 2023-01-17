<!--- Standart Satinalma Teklif Formu ---> 
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfset my_server_name = listgetat(fusebox.server_machine_list,fusebox.server_machine,';')>
<cfset attributes.offer_id = attributes.action_id>
<cfset attributes.purchase_sales = 1>
<cfquery name="Our_Company" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		COMPANY_NAME,
		TEL_CODE,
		TEL,TEL2,
		TEL3,
		TEL4,
		FAX,
		TAX_OFFICE,
		TAX_NO,
		ADDRESS,
		WEB,
		EMAIL
	FROM 
	    OUR_COMPANY 
	WHERE 
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company#">
	</cfif>
</cfquery>
<cfquery name="get_main_offer_details" datasource="#dsn3#">
    SELECT
        ORW.OFFER_ID,
        SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
        O.PRICE,
        O.OTHER_MONEY,
        O.OTHER_MONEY_VALUE
    FROM
        OFFER O,
        OFFER_ROW ORW
    WHERE
        O.OFFER_ID = ORW.OFFER_ID AND
        O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    GROUP BY
        ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
</cfquery>
<cfquery name="Get_Offer" datasource="#dsn3#">
	SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="Get_Offer_Rows" datasource="#dsn3#">
	SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
		<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
			COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
			COMP_ID = #session.pp.company_id#
		<cfelseif isDefined("session.ww.our_company_id")>
			COMP_ID = #session.ww.our_company_id#
		<cfelseif isDefined("session.cp.our_company_id")>
			COMP_ID = #session.cp.our_company_id#
		</cfif> 
		</cfif> 
	</cfquery>
<cfquery name="Get_Moneys" datasource="#dsn#">
	SELECT MONEY_ID,MONEY,RATE2 FROM SETUP_MONEY WHERE MONEY = '#Get_Offer.Other_Money#' AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_main_offer_details" datasource="#dsn3#">
    SELECT
        ORW.OFFER_ID,
        SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
        O.PRICE,
        O.OTHER_MONEY,
        O.OTHER_MONEY_VALUE
    FROM
        OFFER O,
        OFFER_ROW ORW
    WHERE
        O.OFFER_ID = ORW.OFFER_ID AND
        O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    GROUP BY
        ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
</cfquery>
<cfif len(Get_Offer.Paymethod)>
	<cfset attributes.paymethod_id = Get_Offer.Paymethod>
	<cfquery name="Get_Paymethod" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Paymethod_id#">
	</cfquery>
</cfif>
<cfquery name="get_coming_offer_for_main" datasource="#dsn3#">
    SELECT OFFER_ID,OFFER_NUMBER,OFFER_HEAD,OFFER_DETAIL,OFFER_TO,OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE,REVISION_NUMBER FROM OFFER WHERE FOR_OFFER_ID = #get_offer.offer_id# ORDER BY OFFER_TO_PARTNER, REVISION_OFFER_ID, REVISION_NUMBER
</cfquery>
<cfquery name="get_finally_coming_offers" dbtype="query">
    SELECT OFFER_TO FROM get_coming_offer_for_main GROUP BY OFFER_TO
</cfquery>

<cfif len(Get_Offer.Ship_Method)>
	<cfset attributes.ship_method = Get_Offer.Ship_Method>
    <cfquery name="Get_Ship_Method" datasource="#dsn#">
        SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ship_Method#">
    </cfquery>
</cfif>
<cfset sepet_total = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_net_total = 0>
<cfset genel_toplam = 0>

<cfloop query="get_finally_coming_offers"> 
    <div style="page-break-after:always">
        <table style="width:210mm">
            <tr>
                <td>
                    <table width="100%">
                        <tr class="row_border">
                            <td class="print-head">
                                <table style="width:100%;">
                                    <tr>
                                        <td class="print_title"><cf_get_lang dictionary_id='31040.SATIN ALMA TEKLİFLERİ'></td>
                                            <td style="text-align:right;">
                                                <cfif len(check.asset_file_name2)>
                                                <cfset attributes.type = 1>
                                                    <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                                </cfif>
                                            </td>
                                        </td>
                                    </tr> 
                                </table>
                            </td>
                        </tr>
                
                        <cfquery name="get_finally_coming_offers_details" dbtype="query" maxrows="1">
                            SELECT * FROM get_coming_offer_for_main WHERE OFFER_TO = '#OFFER_TO#' ORDER BY REVISION_NUMBER DESC
                        </cfquery>
                        <cfquery name="get_coming_offer_details" datasource="#dsn3#">
                            SELECT
                                ORW.OFFER_ID,
                                SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
                                O.PRICE,
                                O.OTHER_MONEY,
                                O.OTHER_MONEY_VALUE
                            FROM
                                OFFER O,
                                OFFER_ROW ORW
                            WHERE
                                O.OFFER_ID = ORW.OFFER_ID AND
                                O.FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
                                O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_finally_coming_offers_details.OFFER_ID#">
                            GROUP BY
                                ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
                        </cfquery>
                        <cfquery name="get_techical_point" datasource="#dsn3#">
                            SELECT ISNULL(SUM(TECHNICAL_POINT),0) AS SUM_POINT, COUNT(TECHNICAL_POINT) AS COUNT_POINT FROM PURCHASE_TECHNICAL_POINT WHERE FOR_OFFER_ID = #attributes.offer_id# AND OFFER_ID = #get_finally_coming_offers_details.OFFER_ID# AND COMPANY_ID = #listdeleteduplicates(get_finally_coming_offers_details.offer_to)#
                        </cfquery>  
                        <tr class="row_border" class="row_border">
                            <td>
                                <table style="width:140mm" >
                                    <cfoutput>
                                        <tr>
                                            <td><b><cf_get_lang dictionary_id="57480.Konu"></td>
                                            <td>#Get_Offer.offer_head#</td> 
                                            <td><b><cfoutput>#getLang(1703,'Sevk Yöntemi',29500)#</cfoutput></b></td>
                                            <td><cfif len(Get_Offer.Ship_Method)>#Get_Ship_Method.Ship_Method# #Get_Offer.Ship_Address#</cfif></td>
                                        </tr>
                                        <tr>
                                            <td><b><cf_get_lang dictionary_id="58212.Teklif No"></b></td>
                                            <td>#get_finally_coming_offers_details.OFFER_NUMBER#</td>
                                            <td><b><cf_get_lang dictionary_id="32818.Teklif Tarihi"></td>
                                            <td>#dateformat(date_add('h',session.ep.time_zone,Get_Offer.offer_date),dateformat_style)#</td>
                                        </tr>
                                        <tr>
                                            <td><b><cf_get_lang dictionary_id="58607.Firma">/<cf_get_lang dictionary_id="57578.Yetkili"></b></td>
                                            <td>
                                                #get_par_info(listdeleteduplicates(get_finally_coming_offers_details.offer_to_partner),0,1,0,1)#/#get_par_info(listdeleteduplicates(get_finally_coming_offers_details.OFFER_TO_partner),0,-1,0)#
                                            
                                            </td>
                                            <td><b><cf_get_lang dictionary_id="57645.Teslim Tarihi"></td>
                                            <td>#dateformat(Get_Offer.Deliverdate,dateformat_style)#</td>
                                        </tr>
                                        <tr>
                                            <td><b><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></b></td>
                                            <td><cfif len(Get_Offer.Paymethod)>#Get_Paymethod.Paymethod#<cfelse>&nbsp;</cfif></b></td>
                                            <td><b><cf_get_lang dictionary_id="29775.Hazırlayan"></b></td>
                                            <td><cfif len(Get_Offer.Sales_Emp_id)>#get_emp_info(Get_Offer.Sales_Emp_id,0,0)#</cfif></td>
                                        </tr>
                                    
                                        <tr> 
                                            <td><b><cf_get_lang dictionary_id="57629.Açıklama"></b></td>
                                                <td>#Get_Offer.offer_detail#</td>
                                            <cfif isdefined("Get_Offer.valid_emp") and len(Get_Offer.valid_emp)>
                                                <cfif Get_Offer.valid eq 1>
                                                    <td><b><cf_get_lang dictionary_id="33302.Onaylayan"></b></td>
                                                    <td>#get_emp_info(Get_Offer.VALIDATOR_POSITION_CODE,1,0)#</td>
                                                </cfif>
                                            </cfif>
                                        </tr>
                                    </cfoutput>
                                </table>
                            </td>
                        </tr>
                        <table>
                            <td style="height:10mm;"><b><cf_get_lang dictionary_id="33929.Ürün Detay"></b></td>
                        </table>
                        <table class="print_border" style="width:140mm">
                            <tr>
                                <td><b><cf_get_lang dictionary_id="58221.Ürün Adı"></b></td>
                                <td><b><cf_get_lang dictionary_id="57635.Miktar"></b></td>
                                <td><b><cf_get_lang dictionary_id="57638.Birim Fiyat"></b></td>
                                <td><b><cf_get_lang dictionary_id="57639.Kdv"></b></td>
                            </tr>
                            <cfoutput query="Get_Offer_Rows">
                                <cfscript>
                                    if (not len(QUANTITY)) QUANTITY = 1;
                                    if (not len(PRICE)) price = 0;
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

                                <tr>
                                    <td>#PRODUCT_NAME#</td>
                                    <td style="text-align:right;">#QUANTITY# #UNIT#</td>
                                    <td style="text-align:right;">#TLFORMAT(PRICE)#&nbsp;#session.ep.money#</td>
                                    <td style="text-align:right;">#row_taxtotal#&nbsp;#session.ep.money#</td>
                                </tr>
                            </cfoutput>
                        </table>
                        <table>
                            <td style="height:10mm;"><b><cf_get_lang dictionary_id="37116.Ürün Detay"></b></td>
                        </table>
                        <tr class="row_border" class="row_border">
                            <td>
                                <table class="print_border" style="width:140mm">
                                        <tr>
                                            <td><b><cf_get_lang dictionary_id="38563.Kdv siz Toplam"></b></td>
                                            <td><b><cf_get_lang dictionary_id="51316.KDV Toplam"></b></td>
                                            <td><b><cf_get_lang dictionary_id='64359.Dövizli Toplam'></b></td>
                                        <tr>
                                            <cfoutput>
                                                <td style="text-align:right;">#TLFormat(get_coming_offer_details.NET_PRICE)#&nbsp;#session.ep.money#</td>
                                                <td style="text-align:right;">#TLFormat(get_coming_offer_details.PRICE)#&nbsp;#session.ep.money#</td>
                                                <td style="text-align:right;">#TLFormat(get_coming_offer_details.OTHER_MONEY_VALUE)#&nbsp;#session.ep.money#</td>
                                            </cfoutput>
                                        </tr>
                                </table>  
                            </td>
                        </tr>
                        <table  style="width:210mm">
                            <td valign="top" style="text-align:right;">
                                <b><cf_get_lang dictionary_id="33303.Teklifimizin işleme konması için lütfen onaylayınız"></b><br><br>
                                <cf_get_lang dictionary_id="57570.Ad Soyad"> - <cf_get_lang dictionary_id="58957.İmza"><br><br><br>
                            </td>
                        </table>
                        <table>
                            <tr class="fixed">
                                <td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
                            </tr>
                        
                        </table> 
                    </table>
                </td>
            </tr>
        </table>
    </div>
</cfloop>

