<!--- Standart Satinalma Siparis Depolu --->
<cfset attributes.order_id = attributes.action_id>
<cfquery name="Get_Stores" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_ID,
		B.BRANCH_ID,
		D.DEPARTMENT_HEAD
	FROM 
		DEPARTMENT D,
		BRANCH B 
	WHERE 
		B.BRANCH_ID = D.BRANCH_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.IS_STORE <> 2 AND 	  
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif isDefined('attributes.order_id')>
	<cfquery name="Get_Order" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_EMAIL,			
			O.*
		FROM 
			#dsn3_alias#.ORDERS O, 
			EMPLOYEES E
		WHERE 
			O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
			E.EMPLOYEE_ID = O.RECORD_EMP
	</cfquery>
</cfif>
<cfquery name="Get_Order_Rows" datasource="#dsn3#">
    SELECT * FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<!--- Uye bilgileri --->
<cfset Member_Code = "">
<cfset Member_Name = "">
<cfset Member_Mail = "">
<cfset Member_TaxOffice = "">
<cfset Member_TaxNo = "">
<cfset Member_TelCode = "">
<cfset Member_Tel = "">
<cfset Member_Fax = "">
<cfset Member_Address = "">
<cfset Member_Semt = "">
<cfset Member_County = "">
<cfset Member_City = "">
<cfset Member_Country = "">
<cfif isdefined("Get_Order.Company_Id") and Len(Get_Order.Company_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
            COMPANY_ID MEMBER_ID,
            MEMBER_CODE MEMBER_CODE,
            FULLNAME MEMBER_NAME,
            COMPANY_EMAIL MEMBER_EMAIL,
            TAXOFFICE MEMBER_TAXOFFICE,
            TAXNO MEMBER_TAXNO,
            COMPANY_TELCODE MEMBER_TELCODE,
            COMPANY_TEL1 MEMBER_TEL,
            COMPANY_FAX MEMBER_FAX,
            COMPANY_ADDRESS MEMBER_ADDRESS,
            SEMT MEMBER_SEMT,
            COUNTY MEMBER_COUNTY,
            CITY MEMBER_CITY,
            COUNTRY MEMBER_COUNTRY
        FROM
            COMPANY
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Company_Id#">
	</cfquery>
<cfelseif isdefined("Get_Order.Consumer_Id") and Len(Get_Order.Consumer_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
        SELECT
        	CONSUMER_ID MEMBER_ID,
            MEMBER_CODE MEMBER_CODE,
            CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
            CONSUMER_EMAIL MEMBER_EMAIL,
            TAX_OFFICE MEMBER_TAXOFFICE,
            TAX_NO MEMBER_TAXNO,
            CONSUMER_WORKTELCODE MEMBER_TELCODE,
            CONSUMER_WORKTEL MEMBER_TEL,
            CONSUMER_FAXCODE + '' + CONSUMER_FAX MEMBER_FAX,
            WORKADDRESS MEMBER_ADDRESS,
            WORKSEMT MEMBER_SEMT,
            WORK_COUNTY_ID MEMBER_COUNTY,
            WORK_CITY_ID MEMBER_CITY,
            WORK_COUNTRY_ID MEMBER_COUNTRY
        FROM
        	CONSUMER
        WHERE
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Consumer_Id#">
	</cfquery>
</cfif>
<cfif isdefined("Get_Member_Info") and Get_Member_Info.RecordCount>
	<cfset Member_Code = Get_Member_Info.Member_Code>
    <cfset Member_Name = Get_Member_Info.Member_Name>
    <cfset Member_Mail = Get_Member_Info.Member_Email>
    <cfset Member_TaxOffice = Get_Member_Info.Member_TaxOffice>
    <cfset Member_TaxNo = Get_Member_Info.Member_TaxNo>
    <cfset Member_TelCode = Get_Member_Info.Member_TelCode>
    <cfset Member_Tel = Get_Member_Info.Member_Tel>
    <cfset Member_Fax = Get_Member_Info.Member_Fax>
    <cfset Member_Address = Get_Member_Info.Member_Address>
    <cfset Member_Semt = Get_Member_Info.Member_Semt>
    
	<cfif Len(Get_Member_Info.Member_County)>
		<cfquery name="Get_County_Name" datasource="#dsn#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
		</cfquery>
		<cfset Member_County = Get_County_Name.County_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_City)>
		<cfquery name="Get_City_Name" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
		</cfquery>
		<cfset Member_City = Get_City_Name.City_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_Country)>
		<cfquery name="Get_Country_Name" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
		</cfquery>
		<cfset Member_Country = Get_Country_Name.Country_Name>
	</cfif>
</cfif>
<cfset attributes.order_row_id = Get_Order_Rows.order_row_id>
<cfset attributes.department_id = Get_Stores.department_id>
<cfquery name="Get_Loc" datasource="#dsn3#">
	SELECT * FROM ORDER_ROW_DEPARTMENTS WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.DEPARTMENT_ID#"> AND ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.ORDER_ROW_ID#">
</cfquery>

<cfset sepet_total = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_net_total = 0>
<style>
	table,td{font-size:11px;font-family:Arial, Helvetica, sans-serif;}
	.bold{font-weight:bold;}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="width:185mm;height:200mm;" align="center">
	<tr>
		<td valign="top" height="50">
            <table border="0" width="100%">
                <tr><td style="height:25mm;font-weight:bold;text-align:center;"><cf_get_lang no="917.SİPARİŞ FORMU"></td></tr>
            </table>
            <table border="0" align="right">
                <tr>
                	<td valign="top" style="text-align:right; height:14mm;">
                    	<table border="0" cellpadding="0" cellspacing="0">
                        <cfoutput>
                        	<tr><td style="height:7mm;" class="bold">#Get_Order.Order_Number#</td></tr>
                            <tr><td style="height:7mm;" class="bold">#dateformat(Get_Order.Order_Date,dateformat_style)#</td></tr>
						</cfoutput>
                        </table>
                    </td>
                </tr>
            </table>
            <table border="0" width="85%">
            <cfoutput>
            	<tr><td colspan="2" class="bold">#Member_Name#</td></tr>
                <tr><td colspan="2">#Get_Order.Ship_Address#</td></tr>
                <tr>
                	<td class="bold" style="width:10mm;">Tel : </td>
                    <td><cfif Len(Member_Tel)>(#Member_TelCode#) #Member_Tel#</cfif></td>
                </tr>
                <tr>
                	<td class="bold">Fax : </td>
                    <td><cfif Len(Member_Tel)>(#Member_TelCode#) #Member_Fax#</cfif></td>
                </tr>
			</cfoutput>
            </table>
		</td>
	</tr>
	<tr>
		<td valign="top">
            <table border="0" cellpadding="2" cellspacing="2">
                <tr valign="bottom">
                    <td class="bold"><cf_get_lang no='1512.Stok Adı'></td>
                    <td class="bold" width="50"><cf_get_lang_main no='224.Birim'></td>
                    <td class="bold" width="50"><cf_get_lang_main no='223.Miktar'></td>
                    <cfoutput query="Get_Stores">
                        <td class="bold" style="writing-mode:tb-rl;filter: fliph() flipV();" nowrap>#Department_Head#</td>
                    </cfoutput>		
                    <td class="bold" width="125" style="text-align:right;"><cf_get_lang_main no='226.BirimFiyat'></td>
                    <td class="bold" width="125" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
                </tr>
                <cfoutput query="Get_Order_Rows">
                    <cfset attributes.Stock_id = Get_Order_Rows.Stock_id>
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
                        net_maliyet = COST_PRICE;
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
                    </cfscript>
                    <tr>
                        <td nowrap>#Product_Name#</td>
                        <td>#Unit#</td>
                        <td>#Quantity#</td>
                        <cfloop query="Get_Stores">
                            <td <cfif currentrow mod 2>bgcolor="cccccc"</cfif>>
                                #Get_Loc.Amount#
                            </td>
                        </cfloop>
                        <td style="text-align:right;">#TLFormat(Price)#</td>
                        <td style="text-align:right;">#TLFormat(row_nettotal)#</td>
                    </tr>
                </cfoutput>
            </table>
		</td>
	</tr>
	<tr>
        <td height="25">
            <table border="0" align="right">
			<cfoutput>
                <tr>
                    <td width="100"><cf_get_lang_main no="153.Ara"> <cf_get_lang_main no="80.Toplam"></td>
                    <td class="bold">#TLFormat(sepet_total)#</td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='229.İskonto'></td>
                    <td class="bold">#TLFormat(sepet_toplam_indirim)#</td>
                </tr>
                <tr>
                    <td><cf_get_lang no="914.Vergi"></td>
                    <td class="bold">#TLFormat(sepet_total_tax)#</td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1737.Toplam Tutar'></td>
                    <td class="bold">#TLFormat(sepet_net_total)#</td>
                </tr>
            </cfoutput>
            </table>
		</td>
	</tr>
	<tr>
		<td valign="top" height="50">
            <table border="0" align="center">
                <tr height="25">
                    <td align="center" class="bold" width="33%"><cf_get_lang no="918.SATINALMA SORUMLUSU"></td>
                    <td align="center" class="bold" width="33%"><cf_get_lang no="919.SATINALMA MÜDÜRÜ"></td>
                    <td align="center" class="bold" width="34%"><cf_get_lang no="920.BİLGİ İŞLEM MÜDÜRÜ"></td>
                </tr>
                <tr>
                    <td align="center" class="bold" width="33%" height="50">&nbsp;</td>
                    <td align="center" class="bold" width="33%">&nbsp;</td>
                    <td align="center" class="bold" width="34%">&nbsp;</td>
                </tr>
            </table>
		</td>
	</tr>	
</table>
