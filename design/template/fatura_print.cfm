<!--- Standart Fatura Baski --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="Get_Invoice" datasource="#dsn2#">
	SELECT 
    	COMPANY_ID,
        CONSUMER_ID,
        DEPARTMENT_ID,
        SHIP_METHOD,
        INVOICE_DATE,
        INVOICE_NUMBER,
        INVOICE_CAT,
        NOTE,
        INVOICE_ID,
        SHIP_ADDRESS,
        NETTOTAL,
        GROSSTOTAL,
        TAXTOTAL,
        SA_DISCOUNT,
        TEVKIFAT_ORAN,
        OTHER_MONEY,
        TEVKIFAT,
        TEVKIFAT_ID
    FROM 
    	INVOICE 
    WHERE 
	<cfif not isDefined("attributes.ID")>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
</cfquery>
<cfquery name="Get_Invoice_Row" datasource="#dsn2#">
    SELECT 
        IR.*,
        S.PROPERTY,
        IR.NAME_PRODUCT AS PRODUCT_NAME,
        S.STOCK_CODE
    FROM 
        INVOICE_ROW IR, 
        #dsn3_alias#.STOCKS S
    WHERE 
        IR.STOCK_ID = S.STOCK_ID AND
        <cfif not isDefined("attributes.ID")>
        	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> <!--- _sil neden integer i liste gibi kullaniyor? --->
        <cfelse>
        	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
    ORDER BY
        IR.INVOICE_ROW_ID 
</cfquery>
<cfif Len(Get_Invoice.TEVKIFAT_ID)>
    <cfquery name="Get_Setup_Tevkifat" datasource="#dsn3#">
        SELECT * FROM SETUP_TEVKIFAT WHERE TEVKIFAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.TEVKIFAT_ID#">
    </cfquery>
</cfif>
<cfquery name="Get_Sale_Order" datasource="#dsn2#">
	SELECT 
		O.ORDER_NUMBER 
	FROM 
		INVOICE I,
		INVOICE_SHIPS ISH,
		#dsn3_alias#.ORDERS_SHIP OS,
		#dsn3_alias#.ORDERS O
	WHERE
	<cfif not isDefined("attributes.id")>
		I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
	  	AND I.INVOICE_ID = ISH.INVOICE_ID
		AND ISH.SHIP_ID = OS.SHIP_ID
		AND O.ORDER_ID = OS.ORDER_ID
		AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
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
<cfset bakiye = "">
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
    <cfquery name="Get_Remainder" datasource="#dsn2#">
		SELECT 
        	*
        FROM 
        	COMPANY_REMAINDER 
        WHERE 
        	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Company_Id#">
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
            WORK_COUNTRY_ID MEMBER_COUNTRY,
            TC_IDENTY_NO TC_IDENTY_NO
        FROM
        	CONSUMER
        WHERE
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Consumer_Id#">
    </cfquery>
   	<cfquery name="Get_Remainder" datasource="#dsn2#">
		SELECT 
        	*
        FROM 
        	CONSUMER_REMAINDER 
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
    <cfif isdefined("Get_Member_Info.TC_IDENTY_NO") and len(Get_Member_Info.TC_IDENTY_NO)><cfset Member_Tc_No =  Get_Member_Info.TC_IDENTY_NO ><cfelseif isdefined("Get_Member_Info.TC_IDENTITY") and len(Get_Member_Info.TC_IDENTITY)><cfset Member_Tc_No =  Get_Member_Info.TC_IDENTITY ></cfif>
    <cfset bakiye = get_remainder.bakiye>
    
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
<cfif len(Get_Invoice.Department_Id)>
	<cfquery name="Get_Store" datasource="#dsn#">
		SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Department_Id#">
	</cfquery>
</cfif>
<cfif len(Get_Invoice.Ship_Method)>
	<cfquery name="Get_Method" datasource="#dsn#">
		SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Ship_Method#">
	</cfquery>
</cfif>
<cfset sepet.kdv_array = ArrayNew(2)>
<cfset invoice_bill_upd = arraynew(2)>
<cfset kdv_total = 0>
<cfset satir_toplam_indirim = 0>
<cfoutput query="Get_Invoice_Row">
	<cfset invoice_bill_upd[currentrow][1] = product_id >
	<cfif len(property) gt 1>
		<cfset invoice_bill_upd[currentrow][2] = "#product_name#-#property#" >
	<cfelse>
	  	<cfset invoice_bill_upd[currentrow][2] = "#product_name#">
	</cfif>
	<cfset invoice_bill_upd[currentrow][3] = stock_code>
	<cfset invoice_bill_upd[currentrow][4] = amount>
	<cfset invoice_bill_upd[currentrow][5] = unit>
	<cfset invoice_bill_upd[currentrow][35] = unit_id>	
	<cfset invoice_bill_upd[currentrow][6] = price>	
	<cfset invoice_bill_upd[currentrow][8] = discounttotal>
	<cfset invoice_bill_upd[currentrow][10] = stock_id>
	<cfset invoice_bill_upd[currentrow][14] = pay_method>
	<cfset invoice_bill_upd[currentrow][15] = amount*price>
	<cfset invoice_bill_upd[currentrow][16] = nettotal>	
	<cfset invoice_bill_upd[currentrow][18] = grosstotal>
	<cfset invoice_bill_upd[currentrow][17] = taxtotal>
	<cfset invoice_bill_upd[currentrow][19] = 0 >
	<cfset invoice_bill_upd[currentrow][20] = 0 > 
	<cfset invoice_bill_upd[currentrow][27] = 0 >
	<cfset invoice_bill_upd[currentrow][26] = spect_var_id>
	<cfset invoice_bill_upd[currentrow][39] = spect_var_name>
	<cfset invoice_bill_upd[currentrow][40] = LOT_NO>
	<cfset invoice_bill_upd[currentrow][41] = PRICE_OTHER>
	<cfset invoice_bill_upd[currentrow][28] = 0>
	<cfif len(TAX)>
		<cfset invoice_bill_upd[currentrow][7] = TAX>
		<!--- <cfset invoice_bill_upd[currentrow][17] = satir_tax_tutar> --->
		<cfelse>
			<cfif nettotal neq 0>
				<cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 >
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
		}
	}
	if (not kdv_flag)
	{
		sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
		sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
	}	
	</cfscript>
	<cfset kdv_total = kdv_total + invoice_bill_upd[currentrow][17]>   
</cfoutput>
<cfparam name="attributes.mode" default=23>
<cfscript>
	sayfa_toplam = 0;
	devreden_toplam = 0;	
</cfscript>
<cfset satir_indirim_toplam = 0>
<cfset toplam_indirim = 0>
<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
<cfif ((i mod attributes.mode eq 1)) or (i eq 1)>
<table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:279.3mm;">
	<tr>
		<td style="width:2mm;"></td>
		<td valign="top">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td style="height:94mm;">
                    <cfoutput>
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr><td colspan="2" style="height:36mm;"></td></tr>
                            <tr>
                                <td valign="top" style="width:137mm;height:62mm;">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width:115mm;height:30mm;" valign="top">
                                                <br/><strong>#Member_Name#</strong><br />
                                                #Get_Invoice.Ship_Address#
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:14mm;">
                                                    <tr>
                                                        <td style="width:20mm">&nbsp;</td>
                                                        <td style="width:52mm">#Member_TaxOffice#</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td><cfif (isdefined("get_member_info.TC_IDENTY_NO") and len(get_member_info.TC_IDENTY_NO)) or (isdefined("get_member_info.TC_IDENTITY") and len(get_member_info.TC_IDENTITY))  and not len(get_member_info.member_taxno)>#Member_Tc_No#<cfelse>#Member_TaxNo#</cfif></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td class="txtbold">#Member_Code#</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>				
                                </td>
                                <td valign="top">		   
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr><td style="height:37mm;">&nbsp;</td></tr>
                                        <tr>
                                            <td style="height:7mm;">
                                                <table>
                                                    <tr>
                                                        <td style="width:20mm">#dateformat(Get_Invoice.Invoice_Date,'dd.mm.yyyy')#</td>
                                                        <td><strong><cf_get_lang_main no='721.FT NO'>:</strong>&nbsp;#Get_Invoice.Invoice_Number#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>#timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</td>
                                                        <td><strong><cf_get_lang_main no='799.Sip No'> :#Get_Sale_Order.Order_Number#</strong>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:20mm">&nbsp;</td>
                                                        <td class="txtbold"><cfif Get_Invoice.invoice_cat eq 62><cf_get_lang_main no="1621.İade"> <cf_get_lang_main no="29.Faturası"></cfif></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </cfoutput>
                    </td>
                </tr>
                <tr>
                    <td style="height:108mm;" valign="top">
                        <table border="0" cellspacing="0" cellpadding="0">
                        </cfif>
                        <cfset DISC_TOTAL=0>
                        <cfoutput>			
                            <tr>
                                <td></td>
                                <td style="width:24mm;">#invoice_bill_upd[i][3]#</td>
                                <td style="width:110mm;" height="16">#invoice_bill_upd[i][2]#</td>
                                <td style="width:8mm;text-align:right;">#invoice_bill_upd[i][4]#</td>
                                <td style="width:23mm;text-align:right;">#TLFormat(invoice_bill_upd[i][6],4)#</td>
                                <td style="width:23mm;text-align:right;">#TLFormat((invoice_bill_upd[i][4]*invoice_bill_upd[i][6]))#</td>
                            </tr>
                            <cfset Disc_Total = Disc_Total + (invoice_bill_upd[i][15] - invoice_bill_upd[i][16])>
                            <cfset sayfa_toplam = sayfa_toplam + invoice_bill_upd[i][16]>
                            <cfset satir_indirim_toplam = satir_indirim_toplam + invoice_bill_upd[i][8]>
                            <cfset toplam_indirim = toplam_indirim + invoice_bill_upd[i][8]>
                        </cfoutput>
                        <cfif ((i mod attributes.mode eq 0)) or (i eq arraylen(invoice_bill_upd))>
                        </table>		 
                    </td>
                </tr>
                <cfif ((i mod attributes.mode eq 0)) and (i neq arraylen(invoice_bill_upd))>	
                <cfset all_total =  devreden_toplam +  sayfa_toplam> 
                <br/><br/>
                <table border="0" style="width:180mm;" cellspacing="0" cellpadding="0">
                    <tr>
                        <td></td>
                        <td style="text-align:right;">
                            <cfoutput>
                            <table>
                            <cfif i neq attributes.mode>
                                <tr>
                                    <td class="txtbold"><cf_get_lang_main no='622.Devreden'> <cf_get_lang_main no='80.Toplam'></td>
                                    <td style="text-align:right;">&nbsp;#TLFormat(devreden_toplam)#</td>
                                </tr>			  
                            </cfif>	
                            <tr>
                                <td class="txtbold"><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></td>
                                <td style="text-align:right;">&nbsp;#TLFormat(sayfa_toplam)#</td>
                            </tr>
                            <tr>
                                <td class="txtbold"><cf_get_lang_main no='237.İnd Toplam'></td>
                                <td style="text-align:right;">&nbsp;#TLFormat(satir_indirim_toplam)#</td>
                            </tr>
                            <cfif i neq attributes.mode>
                                <tr>
                                    <td class="txtbold"><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></td>
                                    <td style="text-align:right;">&nbsp;#TLFormat(all_total)#</td>
                                </tr>
                            </cfif>
                            </table>	
                            </cfoutput>	   
                        </td>
                    </tr>
                </table>
                <cfset devreden_toplam =  devreden_toplam +  sayfa_toplam>
                <cfset sayfa_toplam = 0>
                <cfset satir_indirim_toplam = 0>
                </cfif>		
                <cfif (i eq arraylen(invoice_bill_upd))>
                <br/><br/>
                <tr>
                    <td>
					<cfoutput>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td valign="top"><!--- style="width:145mm;" --->
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="height:13mm;" valign="top">
                                                <table border="0" style="width:110mm;" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td colspan="3">
                                                        <cfif isdefined("attributes.special_invoice_note") and len(attributes.special_invoice_note)>			
                                                            #attributes.special_invoice_note#<br/>
                                                        </cfif>
                                                        <cfif len(Get_Invoice.note)>#Get_Invoice.Note#<br/></cfif>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <b><cf_get_lang_main no='236.Kur'> : </b>&nbsp;#Get_Invoice.Other_Money#
                                                <cfquery name="Get_Money" datasource="#dsn2#">
                                                    SELECT 
                                                        RATE1,
                                                        RATE2 
                                                    FROM 
                                                        INVOICE_MONEY 
                                                    WHERE 
                                                        MONEY_TYPE = '#Get_Invoice.Other_Money#' AND 
                                                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Invoice_Id#">
                                                </cfquery>
                                                #Get_Money.RATE1# / #TLFormat(Get_Money.RATE2,4)#
                                            </td>
                                        <tr>
                                        <tr>
                                            <td style="height:10mm;">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <cfset mynumber = Get_Invoice.nettotal><br /><br /><br />
                                                <cfif session.ep.period_year eq 2004>
                                                    <cf_n2txt number="mynumber" para_birimi="TL">#mynumber# 'dir.
                                                <cfelse>
                                                    <cf_n2txt number="mynumber">#mynumber# 'dir.
                                                </cfif>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="text-align:right;">
                                    <table width="100%">
                                        <tr>
                                            <td class="txtbold" width="100"><cf_get_lang no='85.Brüt Toplam'></td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Grosstotal)#</td>
                                        </tr>
                                        <tr>
                                            <td style="height:2mm;"width="120" class="txtbold"><cf_get_lang_main no='266.Fatura Altı İndirim'></td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Sa_Discount)#</td>
                                        </tr>
                                        <tr>
                                            <td class="txtbold" style="height:2mm;"><cf_get_lang_main no='237.Toplam İndirim'></td>
                                            <td style="text-align:right;">#TLFormat(toplam_indirim+Get_Invoice.Sa_Discount)#</td>
                                        </tr>
                                        <tr>
                                            <td class="txtbold" style="height:2mm;">&nbsp;</td>
                                            <td style="text-align:right;">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td style="height:8mm;"width="100" class="txtbold">&nbsp; </td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Grosstotal-(toplam_indirim+Get_Invoice.Sa_Discount))#</td>
                                        </tr>
                                        <cfif Get_Invoice.tevkifat eq 1 and len(Get_Invoice.Tevkifat_Oran)>
                                        <tr>
                                            <td style="height:8mm;" class="txtbold">#Get_Invoice_Row.tax#</td>
                                            <td style="text-align:right;">#TLFormat(kdv_total)#</td>
                                        </tr>
                                        <tr>
                                            <td style="height:8mm;" class="txtbold"><!--- <strong>1/3 <cf_get_lang_main no='227.KDV'> <cf_get_lang_main no='610.Tevkifat'></strong> --->
                                            <cfif Len(Get_Invoice.TEVKIFAT)>
                                            	#Get_Setup_Tevkifat.STATEMENT_RATE_NUMERATOR#/#Get_Setup_Tevkifat.STATEMENT_RATE_DENOMINATOR#
                                            <cfelse>
                                            	&nbsp;
                                            </cfif>
                                            </td>
                                            <td style="text-align:right;">#TLFormat(kdv_total-((kdv_total*Get_Invoice.Tevkifat_Oran)/100))#</td>
                                        </tr>
                                        <tr>
                                            <td style="height:8mm;" class="txtbold"><cf_get_lang_main no='1032.Kalan'> <cf_get_lang_main no='227.Kdv'></td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Taxtotal)#</td>
                                        </tr>
                                        <cfelse>
                                        <tr>
                                            <td style="height:8mm;" class="txtbold">#Get_Invoice_Row.Tax#</td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Taxtotal)#</td>
                                        </tr>
                                        </cfif>
                                        <tr>
                                            <td style="height:8mm;" class="txtbold">&nbsp;</td>
                                            <td style="text-align:right;">#TLFormat(Get_Invoice.Nettotal)#</td>
                                        </tr>
                                    </table>	
                                </td>
                            </tr>
                        </table>
					</cfoutput>
                    </td>
                </tr>
                </cfif>		  
            </table>		
		</td>
	</tr>
</table>
</cfif>
</cfloop>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
