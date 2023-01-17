<!--- Standart Satinalma Siparis Formu --->
<cfquery name="Our_Company" datasource="#dsn#">
	SELECT 
        ASSET_FILE_NAME3,
        ASSET_FILE_NAME3_SERVER_ID, 
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
    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.Company_id#">
</cfquery>
<cfquery name="Get_Internaldemand" datasource="#dsn3#">
	SELECT 
		IR.PRODUCT_NAME,
		IR.QUANTITY,
		IR.UNIT,
		IR.PRICE,
		IR.PRODUCT_MANUFACT_CODE,
		I.INTERNAL_ID,
		I.INTERNAL_NUMBER,
		I.RECORD_DATE,
		IR.TAX,
		IM.MONEY_TYPE,
		IR.DISCOUNT_1,
		IR.DISCOUNT_2,
		IR.DISCOUNT_3,
		IR.STOCK_ID,
		I.TO_POSITION_CODE,
		I.FROM_POSITION_CODE,
		I.NOTES
	FROM 
		INTERNALDEMAND I,
		INTERNALDEMAND_ROW IR,
		INTERNALDEMAND_MONEY IM
	WHERE
		I.INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		AND I.INTERNAL_ID = IR.I_ID
		AND I.INTERNAL_ID = IM.ACTION_ID
		AND IM.IS_SELECTED = 1
</cfquery>
<cfset Row_Start = 1>
<cfset Row_End = 25>
<cfset Page_Count = ceiling(Get_Internaldemand.RecordCount / Row_End)>
<cfif Page_Count eq 0><cfset Page_Count = 1></cfif>

<cfset sepet_total = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_net_total = 0>
<cfloop from="1" to="#Page_Count#" index="j">
	<table border="0" cellspacing="0" cellpadding="0" style="width:210mm;">
		<tr>
			<td style="width:8mm" rowspan="20">&nbsp;</td>
            <td style="height:10mm;">&nbsp;</td>
		</tr>
        <tr>
        	<td valign="top">
			<table border="0" cellspacing="0" cellpadding="0">
				<cfoutput>
                <tr>
					<td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td style="height:42mm;width:70mm;">
                                <cf_get_server_file 
                                    output_file="settings/#Our_Company.ASSET_FILE_NAME3#"
                                    output_server="#Our_Company.ASSET_FILE_NAME3_SERVER_ID#">
                                </td>
                                <td class="headbold"><font face="Times New Roman, Times, serif" size="+2">Satınalma Talebi</font></td>
                            </tr>
                            <tr>
                                <td valign="top" style="height:30mm;">
                                    <b>#Our_Company.company_name#</b><br><br>#Our_Company.address#<br>
                                    <b><cf_get_lang_main no='87.Telefon'>:</b>(#Our_Company.tel_code#) - #Our_Company.tel#  #Our_Company.tel2#  #Our_Company.tel3# #Our_Company.tel4# <b><cf_get_lang_main no='76.Fax'>:</b>#Our_Company.fax#<br>
                                    #Our_Company.web# - #Our_Company.email#
                                </td>
                                <td valign="top">
                                    <table>
                                    <font face="Times New Roman, Times, serif" size="+1">
                                        <tr>
                                            <td style="height:5mm;font-weight:bold;">Talep No</td>
                                            <td style="font-weight:bold;">#Get_Internaldemand.internal_number#</td>
                                        </tr>
                                        <tr>
                                            <td style="height:5mm;font-weight:bold;"><cf_get_lang_main no='330.Tarih'></td>
                                            <td style="font-weight:bold;">#dateformat(Get_Internaldemand.RECORD_DATE,dateformat_style)#</td>
                                        </tr>
                                    </font>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" style="height:15mm;">
                                    <table>
                                        <font face="Times New Roman, Times, serif" size="+1">
                                        <tr>
                                            <td style="font-weight:bold;"><cf_get_lang no='970.Talep Eden'></td>
                                            <td>#get_emp_info(Get_Internaldemand.FROM_POSITION_CODE,0,0)#</td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight:bold;">Talep Edilen</td>
                                            <td>#get_emp_info(Get_Internaldemand.TO_POSITION_CODE,1,0)#</td>
                                        </tr> 
                                        <cfif Len(Get_Internaldemand.Notes)>
                                            <tr>
                                                <td style="font-weight:bold;"><cf_get_lang_main no='217.Açıklama'></td>
                                                <td>#Get_Internaldemand.Notes#</td>
                                            </tr>
                                        </cfif>
                                        </font>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
					</td>
				</tr>
				</cfoutput>
				<tr>
					<td valign="top" style="width:185mm;height:40mm;">
                        <table border="0">
                            <tr>
                                <td style="font-weight:bold;width:100mm;"><cf_get_lang_main no='245.Ürün'></td>
                                <td style="font-weight:bold;width:45mm;">Üretici Ürün Kodu</td>
                                <td style="font-weight:bold;width:35mm;"><cf_get_lang_main no='106.Stok Kodu'></td>
                                <td style="font-weight:bold;width:15mm;"><cf_get_lang_main no='223.Miktar'></td>
                                <td style="font-weight:bold;width:15mm;"><cf_get_lang_main no='224.Birim'></td>
                                <td style="font-weight:bold;width:35mm;text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
                                <td style="font-weight:bold;width:35mm;text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
                            </tr>
                            <tr><td colspan="7" style="font-weight:bold;"><hr></td></tr>
                            <cfoutput query="Get_Internaldemand" startrow="#Row_Start#" maxrows="#Row_End#">
                                <cfscript>
                                    if (not len(QUANTITY)) QUANTITY = 1;
                                    if (not len(PRICE)) price = 0; 
                                    if (not len(discount_1)) indirim1 = 0; else indirim1 = discount_1;
                                    if (not len(discount_2)) indirim2 = 0; else indirim2 = discount_2;
                                    if (not len(discount_3)) indirim3 = 0; else indirim3 = discount_3;
                                    
                                    indirim6 = 0;
                                    indirim7 = 0;
                                    indirim8 = 0;
                                    indirim9 = 0;
                                    indirim10 = 0;
                                    indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3);
                                    tax_percent = Get_Internaldemand.TAX;
                                    row_total = QUANTITY * price;
                                    row_nettotal = wrk_round((row_total/1000000) * indirim_carpan);
                                    row_taxtotal = wrk_round(row_nettotal * (tax_percent/100));//kdv toplam
                                    row_lasttotal = row_nettotal + row_taxtotal; //kdvli toplam
                                    sepet_total = sepet_total + row_total;
                                    sepet_toplam_indirim = sepet_toplam_indirim + wrk_round(row_total) - wrk_round(row_nettotal);		
                                    sepet_total_tax = sepet_total_tax + row_taxtotal;
                                    sepet_net_total = sepet_net_total + row_lasttotal;
                                </cfscript>		
                                <tr>
                                    <td>#Product_Name#</td>
                                    <td>#Product_Manufact_Code#</td>
                                    <td><cfquery name="Get_Stock_Code" datasource="#dsn3#">
                                            SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Stock_id#">
                                        </cfquery>
                                        <cfif Get_Stock_Code.RecordCount>#Get_Stock_Code.Stock_Code#</cfif>
                                    </td>
                                    <td>#Quantity#</td>
                                    <td>#Unit#</td>
                                    <td style="text-align:right;">&nbsp;#TLFormat(Price)#</td>
                                    <td style="text-align:right;">&nbsp;#TLFormat(row_total)#</td>
                                </tr>
                            </cfoutput>
                        </table>
					</td>
				</tr>	
				<cfoutput>
				<tr>
					<td valign="top" align="right">
                        <table>
                            <tr>
                                <td style="font-weight:bold;">Alt Toplam</td>
                                <td>&nbsp;&nbsp;&nbsp;#TLFormat(sepet_total)#</td>
                            </tr>
                            <tr>
                                <td style="font-weight:bold;"><cf_get_lang_main no='231.KDV Toplam'></td>
                                <td>&nbsp;&nbsp;&nbsp;#TLFormat(sepet_total_tax)#</td>
                            </tr>
                            <tr>
                                <td  style="font-weight:bold;"><cf_get_lang_main no='80.Toplam'></td>
                                <td>&nbsp;&nbsp;&nbsp;#TLFormat(sepet_net_total)#</td>
                            </tr>
                        </table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
                            <tr>
                                <td width="60" style="font-weight:bold;">Para Cinsi</td>
                                <td>#Get_Internaldemand.Money_Type#</td>
                            </tr>
						</table>
					</td>
				</tr>
				</cfoutput> 
				<tr><td height="15">&nbsp;</td></tr>
				<tr><td style="font-weight:bold;"><cf_get_lang_main no='10.NOTLAR'><hr></td></tr>
				<tr><td>USD kurundan TL 'ye dönüşümde TCMB USD satış kuru esas alınır.</td></tr>
			</table>
			</td>
        </tr>
	</table>
	<cfif Page_Count neq j>
        <div style="page-break-after: always"></div>
    </cfif>
    <cfset Row_Start = Row_Start + Row_End>
</cfloop>
