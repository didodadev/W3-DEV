<!--- Faturayi Urunun spec ve urun agacindaki tüm bilesenleri ile birlikte basan print --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="Get_Invoice" datasource="#dsn2#">
	SELECT * FROM INVOICE WHERE <cfif not isDefined("attributes.ID")>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IID#"><cfelse>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#"></cfif>
</cfquery>
<cfquery name="Get_Sale_Order" datasource="#dsn2#">
	SELECT 
		O.ORDER_NUMBER,
		O.ORDER_ID
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
<cfquery name="Get_Invoice_Row" datasource="#dsn3#">
	SELECT
		IR.*,
		0 SPECT_ROW_ID,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		'' SPECT_NAME,
		0 SPECT_AMOUNT,
		'' PRODUCT_DETAIL
	FROM
		#dsn2_alias#.INVOICE_ROW IR,
		STOCKS S
	WHERE
	<cfif not isdefined('attributes.id')>
    	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
    	AND IR.STOCK_ID = S.STOCK_ID
	
	UNION ALL
	
	SELECT
			IR.*,
			SR.SPECT_ROW_ID,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			SR.PRODUCT_NAME ,
			SR.AMOUNT_VALUE SPECT_AMOUNT,
			S.PRODUCT_DETAIL
		FROM
			#dsn2_alias#.INVOICE_ROW IR,
			STOCKS S,
			SPECTS_ROW SR
		WHERE
			SR.SPECT_ID = IR.SPECT_VAR_ID AND 
			<cfif not isdefined('attributes.id')>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
            <cfelse>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
            </cfif>
			AND SR.STOCK_ID = S.STOCK_ID
	UNION ALL
	
	 SELECT
			IR.*,
			1 SPECT_ROW_ID,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.PRODUCT_NAME ,
			PT.AMOUNT SPECT_AMOUNT,
			S.PRODUCT_DETAIL
		FROM
			#dsn2_alias#.INVOICE_ROW IR,
			STOCKS S,
			PRODUCT_TREE PT
		WHERE
			PT.STOCK_ID=IR.STOCK_ID
			AND IR.SPECT_VAR_ID IS NULL	AND 
			<cfif not isdefined('attributes.id')>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
            <cfelse>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
            </cfif>
			AND PT.RELATED_ID = S.STOCK_ID
	ORDER BY 
		IR.INVOICE_ROW_ID,
		SPECT_ROW_ID
</cfquery>
<cfset Row_Start = 1>
<cfset Row_End = 23>
<cfif Get_Invoice_Row.RecordCount><cfset Page_Count = Ceiling(Get_Invoice_Row.RecordCount/Row_End)><cfelse><cfset Page_Count = 1></cfif>

<cfset kdv_total = 0>
<cfset sayfa_toplam = 0>
<cfset toplam_indirim = 0>
<cfset satir_indirim_toplami = 0>
<cfloop from="1" to="#Page_Count#" index="i">
<table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:279.3mm;">
	<tr>
		<td style="width:2mm">&nbsp;</td>
		<td valign="top">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0">
                        <cfoutput>
                            <tr><td colspan="2" style="height:42mm;"></td></tr>
                            <tr>
                                <td valign="top" style="width:135mm;height:62mm;">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width:115mm;height:30mm;" valign="top">
                                                <br/><b>#Member_Name#</b>
                                                <br />#Get_Invoice.Ship_Address#
                                            </td>				
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <table border="0" cellpadding="0" cellspacing="0" style="height:14mm;" width="100%">
                                                    <tr>
                                                        <td style="width:20mm">&nbsp;</td>
                                                        <td style="width:52mm">#Member_TaxOffice#</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td><cfif get_member_info.is_person eq 1 and len(get_member_info.tc_identity) and not len(get_member_info.member_taxno)>#Member_Tc_No#<cfelse>#Member_TaxNo#</cfif></td>
                                                        <td class="txtbold">#Member_Code#</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>          
                                </td>
                                <td valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr><td style="height:38mm;">&nbsp;</td></tr>
                                        <tr>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td style="width:20mm">#dateformat(Get_Invoice.Invoice_Date,'dd.mm.yyyy')# </td>
                                                        <td><strong><cf_get_lang_main no='721.FT NO'>:</strong>&nbsp;#Get_Invoice.Invoice_Number#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>#timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</td>
                                                        <td><strong><cf_get_lang_main no='799.Sip No'>:</strong>&nbsp;#Get_Sale_Order.Order_Number#</td>
                                                    </tr>
                                                    <tr><td>&nbsp;</td></tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </cfoutput>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="height:113mm" valign="top">
                        <table>
                        <cfset fatura_alti_indirim=0>
                        <cfif len(Get_Invoice.Sa_Discount)><cfset fatura_alti_indirim = Get_Invoice.Sa_Discount></cfif>
                        <cfoutput query="Get_Invoice_Row" startrow="#Row_Start#" maxrows="#Row_End#">
                            <cfif Get_Invoice_Row.Spect_Row_Id eq 0>
                                <tr>
                                    <td style="width:24mm;">#Stock_Code#</td>
                                    <td style="width:110mm;">#Name_Product#</td>
                                    <td style="width:8mm;">#Amount#</td>
                                    <td style="width:23mm; text-align:right">#TLFormat(Price)#</td>
                                    <td style="width:21mm; text-align:right">#TLFormat(Amount * Price)#</td>
                                </tr>
                                <cfif len(Discounttotal)>
                                    <cfset satir_indirim_toplami = satir_indirim_toplami + Discounttotal>
                                </cfif>
                                <cfif len(Taxtotal)><cfset kdv_total = kdv_total + Taxtotal></cfif>
                                <cfset sayfa_toplam = sayfa_toplam + ((Amount*Price))>
                                <cfset toplam_indirim = toplam_indirim + Discounttotal>
                            <cfelse>
                                <tr>
                                    <td>&nbsp;&nbsp;#Stock_Code#</td>
                                    <td><cfif len(Product_Detail)>#Product_Detail#<cfelse>#Spect_Name#</cfif></td>
                                    <td>#Amount * Spect_Amount#</td>
                                </tr>
                            </cfif>
                        </cfoutput>
                        </table>
                    </td>
                </tr>
                <cfif i eq Page_Count>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <cfoutput>
                                <tr>
                                    <td style="width:145mm;" valign="top">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td style="height:13mm;" valign="top">
                                                    <table border="0" style="width:110mm;" cellspacing="0" cellpadding="0">
                                                        <tr><td colspan="2"><cfif len(Get_Invoice.Note)>#Get_Invoice.Note#</cfif></td></tr>
                                                    </table>		 
                                                </td>
                                            </tr>			
                                            <tr>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <cfset mynumber = wrk_round(Get_Invoice.Nettotal)>
                                                <cf_n2txt number="mynumber"> #mynumber# 'dir.
                                                <cfquery name="Get_Money" datasource="#dsn2#">
                                                    SELECT
                                                        RATE1,
                                                        RATE2,
                                                        MONEY_TYPE
                                                    FROM
                                                        INVOICE_MONEY
                                                    WHERE
                                                        MONEY_TYPE = '#Get_Invoice.Other_Money#' AND
                                                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Invoice_Id#">
                                                </cfquery>
                                                <cfif Get_Money.Money_Type neq session.ep.money>
                                                    <b><cf_get_lang_main no='236.Kur'> :</b>&nbsp;#Get_Invoice.Other_Money#
                                                    #Get_Money.Rate1# / #TLFormat(Get_Money.Rate2,4)#
                                                </cfif>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="text-align:right">
                                        <table width="100%">
                                            <tr>
                                                <td class="txtbold" width="100"><cf_get_lang no='85.Brüt Toplam'></td>
                                                <td style="text-align:right">#TLFormat(Get_Invoice.Grosstotal)#</td>
                                            </tr>
                                            <tr>
                                                <td style="height:2mm;" width="120" class="txtbold"><cf_get_lang_main no='266.Fatura Altı İndirim'></td>
                                                <td style="text-align:right">#TLFormat(Get_Invoice.Sa_Discount)#</td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" width="100"><cf_get_lang_main no='237.Toplam İndirim'></td>
                                                <td style="text-align:right">#TLFormat(toplam_indirim+Get_Invoice.Sa_Discount)#</td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" style="height:2mm;">&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="height:8mm;" width="100" class="txtbold">&nbsp;</td>
                                                <td style="text-align:right">#TLFormat(Get_Invoice.Grosstotal-(toplam_indirim+Get_Invoice.Sa_Discount))#</td>
                                            </tr>
                                            <cfif Get_Invoice.Tevkifat eq 1 and len(Get_Invoice.Tevkifat_Oran)>
                                                <tr>
                                                    <td style="height:8mm;" class="txtbold">#Get_Invoice_Row.Tax#</td>
                                                    <td style="text-align:right">#TLFormat(kdv_total)#</td>
                                                </tr>
                                                <tr>
                                                    <td style="height:8mm;" class="txtbold"><strong>1/3 <cf_get_lang_main no='227.KDV'> <cf_get_lang_main no='610.Tevkifat'></strong></td>
                                                    <td style="text-align:right">#TLFormat(kdv_total-((kdv_total*Get_Invoice.Tevkifat_Oran)/100))#</td>
                                                </tr>
                                                <tr>
                                                    <td style="height:8mm;" class="txtbold"><cf_get_lang_main no='1032.Kalan'> <cf_get_lang_main no='227.Kdv'></td>
                                                    <td style="text-align:right">#TLFormat(Get_Invoice.Taxtotal)#</td>
                                                </tr>
                                            <cfelse>
                                                <tr>
                                                    <td style="height:8mm;" class="txtbold">#get_invoice_row.tax#</td>
                                                    <td style="text-align:right">#TLFormat(Get_Invoice.Taxtotal)#</td>
                                                </tr>
                                            </cfif>
                                            <tr>
                                                <td style="height:8mm;" class="txtbold">&nbsp;</td>
                                                <td style="text-align:right">#TLFormat(Get_Invoice.Nettotal)#</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </cfoutput>
                            </table>
                        </td>
                    </tr>
                <cfelse>
                    <tr>
                    <td style="text-align:right;">
                        <table>
                        <cfoutput>
                            <tr>
                                <td class="txtbold"><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></td>
                                <td>:&nbsp;#tlformat(sayfa_toplam)#</td>
                            </tr>
                            <tr>	
                                <td class="txtbold"><cf_get_lang_main no='237.İnd Toplam'></td>
                                <td>:&nbsp;#tlformat(satir_indirim_toplami)#</td>
                            </tr>
                        </cfoutput>
                        </table>
                    </td>
                    </tr>
                    <cfset sayfa_toplam = 0>
                    <cfset satir_indirim_toplami = 0>
                </cfif>
            </table>
		</td>
	</tr>
</table>
<cfset Row_Start = Page_Count + Row_Start>
</cfloop>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
