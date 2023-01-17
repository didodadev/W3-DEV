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
    <cf_woc_header>
    <cf_woc_elements>
        <cf_wuxi id="travel-id" data="#get_emp_info(Get_Internaldemand.FROM_POSITION_CODE,0,0)#" label="33360" type="cell">
        <cf_wuxi id="employee-id" data="#get_emp_info(Get_Internaldemand.TO_POSITION_CODE,1,0)#" label="56535" type="cell">
        <cf_wuxi id="employee-id" data="#Get_Internaldemand.Notes#" label="57629" type="cell">
    </cf_woc_elements>
    <table style="width:210mm">
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                            <table border="0">
                                <tr>
                                    <td style="font-weight:bold;width:100mm;"><cf_get_lang dictionary_id='57657.Ürün'></td>
                                    <td style="font-weight:bold;width:45mm;"><cf_get_lang dictionary_id='44232.Üretici ürün kodu'></td>
                                    <td style="font-weight:bold;width:35mm;"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
                                    <td style="font-weight:bold;width:15mm;"><cf_get_lang dictionary_id='57635.Miktar'></td>
                                    <td style="font-weight:bold;width:15mm;"><cf_get_lang dictionary_id='57636.Birim'></td>
                                    <td style="font-weight:bold;width:35mm;text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
                                    <td style="font-weight:bold;width:35mm;text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
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
                                        <td width="60" style="font-weight:bold;"><cf_get_lang dictionary_id='57489.Currency'></td>
                                        <td>#Get_Internaldemand.Money_Type#</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </cfoutput> 
                    <tr><td height="15">&nbsp;</td></tr>
                    <tr><td style="font-weight:bold;"><cf_get_lang_main no='10.NOTLAR'><hr></td></tr>
                    <tr><td><cf_get_lang dictionary_id='65221.USD kurundan TL ''ye dönüşümde TCMB USD satış kuru esas alınır.'></td></tr>
                </table>
			</td>
        </tr>
	</table>
	<cfif Page_Count neq j>
        <div style="page-break-after: always"></div>
    </cfif>
    <cfset Row_Start = Row_Start + Row_End>
</cfloop>
