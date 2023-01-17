<!--- Standart Tevkifatli Fatura --->
<cfsetting showdebugoutput="no">
<cfquery name="Get_Invoice" datasource="#dsn2#">
	SELECT * FROM INVOICE WHERE <cfif not isDefined("attributes.ID")>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IID#"><cfelse>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#"></cfif>
</cfquery>
<cfquery name="Get_Invoice_Row" datasource="#dsn2#">
    SELECT 
        INVOICE_ROW.*,
        STOCKS.PROPERTY,
        INVOICE_ROW.NAME_PRODUCT AS PRODUCT_NAME
    FROM 
        INVOICE_ROW, 
        #dsn3_alias#.STOCKS AS STOCKS
    WHERE 
        INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID AND
	<cfif not isDefined("attributes.ID")>
    	INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
    ORDER BY
        INVOICE_ROW_ID 
</cfquery>
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
<cfset Member_Tc_No = "">
<cfset comp = "comp">
<cfif isdefined("Get_Invoice.Company_Id") and Len(Get_Invoice.Company_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
            C.COMPANY_ID MEMBER_ID,
            C.MEMBER_CODE MEMBER_CODE,
            C.FULLNAME MEMBER_NAME,
            C.COMPANY_EMAIL MEMBER_EMAIL,
            C.TAXOFFICE MEMBER_TAXOFFICE,
            C.TAXNO MEMBER_TAXNO,
            C.COMPANY_TELCODE MEMBER_TELCODE,
            C.COMPANY_TEL1 MEMBER_TEL,
            C.COMPANY_FAX MEMBER_FAX,
            C.COMPANY_ADDRESS MEMBER_ADDRESS,
            C.SEMT MEMBER_SEMT,
            C.COUNTY MEMBER_COUNTY,
            C.CITY MEMBER_CITY,
            C.COUNTRY MEMBER_COUNTRY,
            C.IS_PERSON,
            CP.TC_IDENTITY
        FROM
            COMPANY C LEFT JOIN COMPANY_PARTNER CP ON C.COMPANY_ID = CP.COMPANY_ID
        WHERE
            C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Company_Id#">
	</cfquery>
<cfelseif isdefined("Get_Invoice.Consumer_Id") and Len(Get_Invoice.Consumer_Id)>
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
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Consumer_Id#">
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
    <cfset Member_Tc_No = Get_Member_Info.Tc_Identity>
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
<cfquery name="Get_With_Ship" datasource="#dsn2#">
	SELECT
		IS_WITH_SHIP,
		SHIP_NUMBER
	FROM
		INVOICE_SHIPS
	WHERE
	<cfif not isDefined("attributes.ID")>
    	INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfif>
</cfquery>
<cfset kdv_total = 0>
<cfset tevkifat_tutar = 0>
<cfset sayfa_toplam = 0>
<cfset devreden_toplam = 0>
<cfset Disc_Total = 0>
<cfset toplam_indirim = Get_Invoice.Sa_Discount>
<cfparam name="attributes.mode" default=23>
<cfset sepet.kdv_array = ArrayNew(2)>
<cfset invoice_bill_upd = arraynew(2)>
<cfoutput query="Get_Invoice_Row">
	<cfset invoice_bill_upd[currentrow][1] = product_id >
	<cfif len(property) gt 1>
		<cfset invoice_bill_upd[currentrow][2] = "#product_name#-#property#" >
	<cfelse>
	  	<cfset invoice_bill_upd[currentrow][2] = "#product_name#">
	</cfif>
	<cfset invoice_bill_upd[currentrow][4] = amount>
	<cfset invoice_bill_upd[currentrow][5] = unit>
	<cfset invoice_bill_upd[currentrow][35] = unit_id>	
	<cfset invoice_bill_upd[currentrow][6] = price>	
	<cfset invoice_bill_upd[currentrow][8] = discounttotal>
	<cfset invoice_bill_upd[currentrow][10] = stock_id>
	<cfset invoice_bill_upd[currentrow][14] = pay_method>
	<cfset invoice_bill_upd[currentrow][15] = amount*price>
	<cfset invoice_bill_upd[currentrow][16] = Nettotal>	
	<cfset invoice_bill_upd[currentrow][18] = grosstotal>
	<cfset invoice_bill_upd[currentrow][17] = Taxtotal>
	<cfset invoice_bill_upd[currentrow][19] = 0 >
	<cfset invoice_bill_upd[currentrow][20] = 0 > 
	<cfset invoice_bill_upd[currentrow][27] = 0 >
	<cfset invoice_bill_upd[currentrow][26] = spect_var_id>
	<cfset invoice_bill_upd[currentrow][39] = spect_var_name>
	<cfset invoice_bill_upd[currentrow][40] = lot_no>
	<cfset invoice_bill_upd[currentrow][41] = price_other>
	<cfset invoice_bill_upd[currentrow][28] = 0>
	<cfset  invoice_bill_upd[currentrow][29] = discount_cost>
	<cfset toplam_indirim = discounttotal + toplam_indirim>
	<cfif len(tax)>
		<cfset invoice_bill_upd[currentrow][7] = tax>
		<cfelse>
			<cfif Nettotal neq 0>
				<cfset invoice_bill_upd[currentrow][7] = (Taxtotal/Nettotal)*100 >
			<cfelse>	
				<cfset invoice_bill_upd[currentrow][7] = 0>
			</cfif>
	</cfif>		
	<cfscript>
	kdv_flag = 0;
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
	{
		if (sepet.kdv_array[k][1] eq invoice_bill_upd[currentrow][7])
		{
			kdv_flag = 1;
			sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + invoice_bill_upd[currentrow][17];
			sepet.kdv_array[k][3] = sepet.kdv_array[k][3] +	invoice_bill_upd[currentrow][16];			
		}
	}
	if (not kdv_flag)
	{
		sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
		sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
		sepet.kdv_array[arraylen(sepet.kdv_array)][3]=invoice_bill_upd[currentrow][16];
	}	
	</cfscript>
</cfoutput>
<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
	<cfif ((i mod attributes.mode eq 1)) or (i eq 1)>
        <table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:264mm;">
            <tr>
                <td style="width:7mm;">&nbsp;</td>
                <td valign="top">
                    <table border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr>
                            <td>
                            <cfoutput>
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr><td colspan="2" style="height:24mm;"></td></tr>
                                <tr>
                                    <td valign="top" style="width:156mm;height:72mm;">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width:90mm;">
                                            <tr><td style="width:90mm;height:47mm;"><strong>#Member_Name#</strong><br/>#Get_Invoice.Ship_Address#</td></tr>
                                            <tr>
                                                <td style="width:90mm;height:9mm;">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td style="width:26mm">&nbsp;</td>
                                                            <td style="width:56mm;">#Member_TaxOffice# <cfif Len(Member_TaxOffice) and (Len(Member_TaxNo) or len(Member_Tc_No))>/</cfif> <cfif get_member_info.is_person eq 1 and len(get_member_info.tc_identity) and not len(get_member_info.member_taxno)>#Member_Tc_No#<cfelse>#Member_TaxNo#</cfif></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>			
                                        </table>				
                                    </td>
                                    <td valign="top">		   
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr><td style="height:9mm;">#dateformat(Get_Invoice.Invoice_Date,'dd.mm.yyyy')#</td></tr>
                                            <tr><td style="height:9mm;"><cfloop query="Get_With_Ship">#Ship_Number#<cfif Get_With_Ship.RecordCount neq currentrow>,</cfif></cfloop></td></tr>
                                            <tr><td style="height:9mm;"></td></tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td height="100%" valign="top">
                                <table border="0" cellspacing="0" cellpadding="0">
                                </cfif>
                                <cfoutput>			
                                    <tr>
                                        <td style="width:2mm;">&nbsp;</td>
                                        <td style="width:99mm;" height="16">#invoice_bill_upd[i][2]#</td>
                                        <td style="width:7mm;">#invoice_bill_upd[i][4]#</td>
                                        <td style="width:8mm;">#invoice_bill_upd[i][5]#</td>
                                        <td style="width:20mm;text-align:right">#TLFormat(invoice_bill_upd[i][6])#</td>
                                        <td style="width:28mm;text-align:right">#TLFormat(invoice_bill_upd[i][15])#</tD>
                                        <td style="width:8mm;">&nbsp;</td>
                                    </tr>
                                    <cfset Disc_Total = Disc_Total + (invoice_bill_upd[i][15] - invoice_bill_upd[i][16])>
                                    <cfset sayfa_toplam = sayfa_toplam + invoice_bill_upd[i][16]>	
                                    <cfif len(get_invoice_row.Taxtotal)><cfset kdv_total = kdv_total + get_invoice_row.Taxtotal[i]></cfif>
                                </cfoutput>
                                <cfif ((i mod attributes.mode eq 0)) or (i eq arraylen(invoice_bill_upd))>
                                </table>
                                <cfif ((i mod attributes.mode eq 0)) and (i neq arraylen(invoice_bill_upd))>	
                                    <cfset all_total =  devreden_toplam +  sayfa_toplam> 
                                    <cfset tevkifat_tutar = kdv_total-((kdv_total*Get_Invoice.Tevkifat_Oran)/100)><br/><br/>
                                    <table border="0" style="width:165mm;" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td style="text-align:right">
                                            <cfoutput>
                                                <table>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang_main no='80.Ara Toplam'></td>
                                                        <td style="text-align:right">&nbsp;#TLFormat(sayfa_toplam)#</td>
                                                    </tr>
                                                    <cfif i neq attributes.mode>
                                                        <tr>
                                                            <td class="txtbold"><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></td><!--- Sayfaya Kadar ki Toplam --->
                                                            <td style="text-align:right">&nbsp;#TLFormat(all_total)#</td>
                                                        </tr>
                                                    </cfif>
                                                </table>	
                                            </cfoutput>	   
                                            </td>
                                        </tr>
                                    </table>
                                    <cfset devreden_toplam =  devreden_toplam +  sayfa_toplam>
                                    <cfset sayfa_toplam = 0>
                                </cfif>		
                                <cfif (i eq arraylen(invoice_bill_upd))><br/><br/>
                                    <table border="0" style="width:164mm; text-align:right;" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td style="text-align:right;">
                                            <cfoutput>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang_main no='80.Ara Toplam'></td>
                                                        <td style="width:28mm;text-align:right">&nbsp;#TLFormat(Get_Invoice.Nettotal - Get_Invoice.Taxtotal)#</td>
                                                    </tr>
                                                    <cfif (Get_Invoice.Nettotal-Get_Invoice.Taxtotal+Get_Invoice.Sa_Discount) neq 0>
                                                        <cfset kdvcarpan = 1- (Get_Invoice.Sa_Discount/(Get_Invoice.Nettotal-Get_Invoice.Taxtotal+Get_Invoice.Sa_Discount))>
                                                    <cfelse>
                                                        <cfset kdvcarpan = 1>
                                                    </cfif>
                                                    <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
                                                        <tr>
                                                            <td class="txtbold"><cf_get_lang_main no='227.KDV'> % #sepet.kdv_array[m][1]#</td>
                                                            <td style="width:28mm;text-align:right">&nbsp;#TLFormat(sepet.kdv_array[m][2]*kdvcarpan)#</td>
                                                        </tr>						 
                                                    </cfloop>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang_main no='610.Tevkifat'></td>
                                                        <td style="width:28mm;text-align:right">&nbsp;<cfif Len(tevkifat_tutar)>#TLFormat(tevkifat_tutar)#</cfif></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang_main no="2219.Yekün"></td>
                                                        <td style="width:28mm;text-align:right">&nbsp;
                                                        <cfif Len(tevkifat_tutar)>
                                                            #TLFormat(Get_Invoice.Nettotal-Get_Invoice.Taxtotal+kdv_total-tevkifat_tutar)#
                                                        <cfelse>
                                                            #TLFormat(Get_Invoice.Nettotal-Get_Invoice.Taxtotal+kdv_total)#
                                                        </cfif>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang_main no='612.Beyan Edl'> <cf_get_lang_main no='227.Kdv'> </td>
                                                        <td style="width:28mm;text-align:right">&nbsp;<cfif Len(tevkifat_tutar)>#TLFormat(kdv_total-tevkifat_tutar)#<cfelse>#TLFormat(kdv_total)#</cfif></td>
                                                    </tr>
                                                </table>	
                                            </cfoutput>
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" style="width:170mm;" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td><strong><cf_get_lang_main no="2220.Yalnız"> : </strong>
                                                <cfset mynumber = Get_Invoice.Nettotal>
                                                <cfif session.ep.period_year eq 2004>
                                                    <cf_n2txt number="mynumber" para_birimi="TL"> <cfoutput>#mynumber#</cfoutput> 'dir.
                                                <cfelse>
                                                    <cf_n2txt number="mynumber"><cfoutput>#mynumber#</cfoutput> 'dir.
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txtbold">
                                            <cfquery name="Get_Money" datasource="#dsn2#">
                                                SELECT Rate1,Rate2,Money_Type FROM INVOICE_MONEY WHERE Money_Type = '#Get_Invoice.Other_Money#' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.INVOICE_ID#">
                                            </cfquery>
                                            <cfif Get_Money.Money_Type neq session.ep.money>
                                                <cfoutput>#Get_Invoice.Other_Money# #Get_Money.Rate1# / #TLFormat(Get_Money.Rate2,4)#</cfoutput>
                                            </cfif>
                                            </td>
                                        <tr>
                                    </table><br/>
                                    <table border="0" style="width:170mm;" cellspacing="0" cellpadding="0">
                                    <cfoutput>
                                        <tr>
                                            <td colspan="2">
                                                <cfif isdefined("attributes.Special_Invoice_Note") and len(attributes.Special_Invoice_Note)>			
                                                    #attributes.Special_Invoice_Note#<br/>
                                                </cfif>
                                                <cfif len(Get_Invoice.note)>#Get_Invoice.note#<br/></cfif>
                                            </td>
                                        </tr>
                                    </cfoutput>
                                    </table>
                                </cfif>
                            </td>
                        </tr>		  
                    </table>		
                </td>
            </tr>
        </table>
    </cfif>
</cfloop>
