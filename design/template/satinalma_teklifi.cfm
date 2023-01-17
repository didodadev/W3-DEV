<!--- Standart Satinalma Teklif Formu --->
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
<cfquery name="Get_Offer" datasource="#dsn3#">
	SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="Get_Offer_Rows" datasource="#dsn3#">
	SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="Get_Moneys" datasource="#dsn#">
	SELECT MONEY_ID,MONEY,RATE2 FROM SETUP_MONEY WHERE MONEY = '#Get_Offer.Other_Money#' AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(Get_Offer.Paymethod)>
	<cfset attributes.paymethod_id = Get_Offer.Paymethod>
	<cfquery name="Get_Paymethod" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Paymethod_id#">
	</cfquery>
</cfif>
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
<cfloop list="#Get_Offer.offer_to_partner#" index="f">
	<cfif len(trim(f))>
		<cfquery name="get_partner_info" datasource="#dsn#">
			SELECT * FROM COMPANY_PARTNER WHERE PARTNER_ID = #f#
		</cfquery>
		<cfquery name="company_info" datasource="#dsn#">
			SELECT * FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner_info.company_id#">
		</cfquery>
	</cfif>
    <table border="0" cellpadding="0" cellspacing="0" style="width:185mm;height:285mm;" bgcolor="FFFFFF">
        <tr>
            <td rowspan="30" style="width:10mm;">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td valign="top" style="height:25mm;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>&nbsp;</td>
                        <td valign="bottom">
                            <cfoutput>
                                <span class="headbold">#Our_Company.company_name#</span><br><br>
                                #Our_Company.address#<br>
                                <b><cf_get_lang dictionary_id="57499.Tel">:</b>(#Our_Company.tel_code#) - #Our_Company.tel#,#Our_Company.tel2#,#Our_Company.tel3#,#Our_Company.tel4# <b><cf_get_lang dictionary_id="57488.Fax">:</b>#Our_Company.fax#<br>
                                #Our_Company.web# - #Our_Company.email#
                            </cfoutput>
                        </td>
                        <td style="text-align:right;"><cfif len(Our_Company.asset_file_name2)><cf_get_server_file output_file="settings/#Our_Company.asset_file_name2#" output_server="#Our_Company.asset_file_name2_server_id#" output_type="5"></cfif></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top" style="height:25mm;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <cfoutput>
                	<tr>
                        <td style="width:25mm;font-weight:bold;height:6mm;"><cf_get_lang dictionary_id="58212.Teklif No"></td>
                        <td>#Get_Offer.Offer_Number#</td>
                        <td style="width:25mm;font-weight:bold;text-align:right;"><cf_get_lang dictionary_id="32818.Teklif Tarihi"></td>
                        <td style="width:20mm;text-align:center;">#dateformat(date_add('h',session.ep.time_zone,Get_Offer.offer_date),dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td style="width:25mm;font-weight:bold;height:6mm;"><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></td>
                        <td><cfif len(Get_Offer.Paymethod)>#Get_Paymethod.Paymethod#<cfelse>&nbsp;</cfif> </td>
                        <td style="width:25mm;font-weight:bold;text-align:right;"><cf_get_lang dictionary_id="57645.Teslim Tarihi"></td>
                        <td style="width:20mm;text-align:center;">#dateformat(Get_Offer.Deliverdate,dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td style="width:25mm;font-weight:bold;height:6mm;"><cfoutput>#getLang(1703,'Sevk Yöntemi',29500)#</cfoutput></td>
                        <td><cfif len(Get_Offer.Ship_Method)>#Get_Ship_Method.Ship_Method# #Get_Offer.Ship_Address#</cfif></td>                        
                    </tr>
                    <tr>
                        <td style="width:25mm;font-weight:bold;height:6mm;"><cf_get_lang dictionary_id="29775.Hazırlayan"></td>
                        <td><cfif len(Get_Offer.Sales_Emp_id)>#get_emp_info(Get_Offer.Sales_Emp_id,0,0)#</cfif></td>
                        <cfif isdefined("Get_Offer.valid_emp") and len(Get_Offer.valid_emp)>
                            <cfif Get_Offer.valid eq 1>
                                <td style="font-weight:bold;"><cf_get_lang dictionary_id="33302.Onaylayan"></td>
                                <td>#get_emp_info(Get_Offer.VALIDATOR_POSITION_CODE,1,0)#</td>
                            </cfif>
                        </cfif>
                    </tr>
				</cfoutput>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top" style="height:25mm;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
             	<cfoutput>
                	<tr>
                        <td style="font-weight:bold;height:6mm;"><cf_get_lang dictionary_id="58607.Firma">/<cf_get_lang dictionary_id="57578.Yetkili"></td>
                        <td style="font-weight:bold;">
                            <cfif len(get_partner_info.company_id)>
                                <cfquery name="company_info" datasource="#dsn#">
                                    SELECT * FROM COMPANY WHERE COMPANY_ID = #get_partner_info.company_id#
                                </cfquery>
                                <strong>#company_info.fullname# &nbsp; #get_partner_info.company_partner_name# #get_partner_info.company_partner_surname#</strong>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight:bold;height:6mm;"><cf_get_lang dictionary_id="57480.Konu"></td>
                        <td style="font-weight:bold;">#Get_Offer.offer_head#</td>
                    </tr>
                    <tr>
                        <td style="height:6mm;">&nbsp;</td>
                        <td>#Get_Offer.offer_detail#</td>
                    </tr>
				</cfoutput>
                </table>
			</td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="font-weight:bold;height:6mm;" bgcolor="CCCCCC"><cf_get_lang dictionary_id="57629.Açıklama"></td>
                        <td width="90" style="text-align:right;font-weight:bold;" bgcolor="CCCCCC"><cf_get_lang dictionary_id="57635.Miktar"></td>
                        <td width="90" style="text-align:right;font-weight:bold;" bgcolor="CCCCCC"><cf_get_lang dictionary_id="57638.Birim Fiyat"></td>
                        <td width="115" style="text-align:right;font-weight:bold;" bgcolor="CCCCCC"><cf_get_lang dictionary_id="57492.Toplam"></td>
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
                            <td style="text-align:right;height:6mm;">#QUANTITY# #UNIT#</td>
                            <td style="text-align:right;">#TLFORMAT(PRICE)#</td>
                            <td style="width:30mm;text-align:right;">#TLFORMAT(row_total)#</td>
                        </tr>
                    </cfoutput>
                    <tr>
                    	<td colspan="4" style="text-align:right;">
                        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<cfoutput>
                                <tr>
                                    <td style="height:6mm;text-align:right;font-weight:bold;"><cf_get_lang dictionary_id="57492.Toplam"></td>
                                    <td style="width:30mm;text-align:right;font-weight:bold;">#TLFormat(sepet_total)#</td>
                                </tr>
                                <tr>
                                    <td style="height:6mm;text-align:right;font-weight:bold;"><cf_get_lang dictionary_id="57643.KDV Toplam"></td>
                                    <td style="width:30mm;text-align:right;font-weight:bold;">#TLFormat(Get_Offer.Price-sepet_total)#</td>
                                </tr>
                                <tr>
                                    <td style="height:6mm;text-align:right;font-weight:bold;"><cf_get_lang dictionary_id="57680.Genel Toplam"></td>
                                    <td style="width:30mm;text-align:right;font-weight:bold;">#TLFormat(Get_Offer.Price)#</td>
                                </tr>
                            </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="4">
                        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                         		<tr><td colspan="2"><hr></td></tr>
                                <tr>
                                    <td valign="top"><!---  Fiyatlara KDV Dahil değildir --->.</td>
                                    <td valign="top" style="text-align:right;">
                                        <b><cf_get_lang dictionary_id="33303.Teklifimizin işleme konması için lütfen onaylayınız"></b><br><br>
                                        <cf_get_lang dictionary_id="57570.Ad Soyad"> - <cf_get_lang dictionary_id="58957.İmza"><br><br><br>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
			</td>
        </tr>
    </table>
</cfloop>
