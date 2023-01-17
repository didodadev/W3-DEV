<!---TolgaS 20060406 Siparişi Spec li bi şekilde basan datateknik sipariş printi--->
<cfif not isdefined("attributes.action_id")><!--- Toplu Printte gelmesin diye eklendi --->
	<cf_get_lang dictionary_id="33255.Seçmiş Olduğunuz Şablon Bu İşlem İçin Uygun Değil">!
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.order_id = attributes.action_id>
<cfquery name="Our_Company" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
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
	<cfif isDefined("SESSION.EP.Company_Id")>
		COMP_ID = #SESSION.EP.Company_Id#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = #SESSION.PP.COMPANY#
	</cfif>
</cfquery>
<cfquery name="Get_Order" datasource="#dsn3#">
	SELECT O.* FROM ORDERS O WHERE O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfquery name="Get_Order_Row" datasource="#dsn3#">
	SELECT
		ORR.*,
		0 SPECT_ROW_ID,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		'' SPECT_NAME,
		0 SPECT_AMOUNT
	FROM
		ORDER_ROW ORR,
		STOCKS S
	WHERE
		ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		AND ORR.STOCK_ID = S.STOCK_ID
UNION ALL
	SELECT
        ORR.* ,
        SR.SPECT_ROW_ID,
        S.PROPERTY,
        S.STOCK_CODE,
        S.BARCOD,
        S.MANUFACT_CODE,
        S.IS_INVENTORY,
        S.IS_PRODUCTION,
        SR.PRODUCT_NAME ,
        SR.AMOUNT_VALUE SPECT_AMOUNT
    FROM
        ORDER_ROW ORR,
        STOCKS S,
        SPECTS_ROW SR
    WHERE
        SR.SPECT_ID = ORR.SPECT_VAR_ID
        AND ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
        AND SR.STOCK_ID = S.STOCK_ID AND
        SR.IS_SEVK = 1
UNION ALL
	SELECT
        ORR.* ,
        1 SPECT_ROW_ID,
        S.PROPERTY,
        S.STOCK_CODE,
        S.BARCOD,
        S.MANUFACT_CODE,
        S.IS_INVENTORY,
        S.IS_PRODUCTION,
        S.PRODUCT_NAME,
        PT.AMOUNT SPECT_AMOUNT	
    FROM
        ORDER_ROW ORR,
        PRODUCT_TREE PT,
        STOCKS S
    WHERE
        ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
        ORR.SPECT_VAR_ID IS NULL AND
        PT.STOCK_ID = ORR.STOCK_ID AND 
        S.STOCK_ID = PT.RELATED_ID AND
        PT.IS_SEVK = 1
	ORDER BY 
		ORR.ORDER_ROW_ID,
		SPECT_ROW_ID
</cfquery>
<cfset Row_Start = 1>
<cfset Row_End = 23>
<cfset yazilan_satir = 1>
<cfif Get_Order_Row.recordcount>
	<cfset Page_Count = Ceiling((Get_Order_Row.recordcount)/Row_End)>
<cfelse>
	<cfset Page_Count = 1>
</cfif>
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
<cfif len(Get_Order.Order_Employee_Id)>
	<cfquery name="Get_Order_Emp" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES E
		WHERE 
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Order_Employee_Id#">
	</cfquery>
	<cfset satis_yapan = GET_ORDER_EMP.EMPLOYEE_NAME&' '&GET_ORDER_EMP.EMPLOYEE_SURNAME>
<cfelse>
	<cfset satis_yapan="">
</cfif>
<cfif len(Get_Order.Paymethod)>
    <cfquery name="Get_Paymethod" datasource="#dsn#">
        SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Paymethod#">
    </cfquery>
</cfif>
<cfif len(Get_Order.Deliver_Dept_Id)>
    <cfquery name="Get_Store" datasource="#dsn#">
    	SELECT DEPARTMENT_HEAD,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Deliver_Dept_Id#">
    </cfquery>
</cfif>
<cfscript>
	sepet_total = 0;
	sepet_toplam_indirim = 0;
	sepet_total_tax = 0;
	sepet_net_total = 0;
</cfscript>
<cfloop from="1" to="#Page_Count#" index="i">
    <table style="width:205mm;height:290mm;" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td style="width:5mm;">&nbsp;</td>
            <td valign="top">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top">
                            <table width="100%"  border="0">
                                <tr>
                                    <td style="width:60mm;">&nbsp;</td>
                                    <td align="center" class="headbold"><cf_get_lang dictionary_id="33307.SİPARİŞ FORMU"></td>
                                    <td style="width:60mm;text-align:right;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td><strong><cf_get_lang dictionary_id='34125.Satışı Yapan'>:</strong> <cfoutput>#satis_yapan#</cfoutput></td>
                                    <td align="center" class="formbold"><cfif isdefined("GET_STORE.DEPARTMENT_HEAD")><cfoutput>#UCase(GET_STORE.DEPARTMENT_HEAD)#</cfoutput></cfif></td>
                                    <td>
                                        <table align="center">
                                        <cfoutput>
                                        	<tr>
                                                <td><cfif len(Get_Order.order_number)>#Get_Order.order_number#</cfif></b><br/>
                                                    <cfif len(Get_Order.record_date)>#dateformat(date_add('h',session.ep.time_zone,Get_Order.record_date),dateformat_style)#</cfif>
                                                </td>
                                            </tr>
										</cfoutput>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td rowspan="2">
                                                <cfif len(Get_Order.Company_Id)>
                                                    <cfquery name="Company_Info" datasource="#dsn#">
                                                        SELECT * FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Company_Id#">
                                                    </cfquery>
                                                    <cfoutput query="Company_Info">
                                                        <strong>#FULLNAME# (#MEMBER_CODE#)</strong>
                                                        <br/>#Get_Order.SHIP_ADDRESS#
                                                        <br/><cf_get_lang dictionary_id='57499.Telefon'>:(#COMPANY_TELCODE#) #COMPANY_TEL1# #COMPANY_TEL2#
                                                        <br/><cf_get_lang dictionary_id='57488.Fax'>:(#COMPANY_TELCODE#) #COMPANY_FAX#
                                                    </cfoutput>
                                                </cfif>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="text-align:right;">
                                        <table align="center">
                                        <cfoutput>
                                            <tr>
                                                <td><strong><cf_get_lang dictionary_id='57645.Teslim Tarihi'></strong>
                                                    <cfif len(Get_Order.DELIVERDATE)>
                                                        <br/>#DateFormat(Get_Order.DELIVERDATE,dateformat_style)#
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="height:205mm;">
                            <table align="center" width="100%">
                                <tr bgcolor="CCCCCC">
                                    <td class="formbold" width="70"><cf_get_lang dictionary_id='57633.Barkod'></td>
                                    <td class="formbold" width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
                                    <td class="formbold"><cf_get_lang dictionary_id='57657.Ürün'></td>
                                    <td class="formbold" width="45" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
                                    <td class="formbold" width="70" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'>&nbsp;</td>
                                    <td class="formbold" width="40"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                                    <td class="formbold" width="70" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
                                </tr>
                                <cfoutput query="Get_Order_Row" startrow="#Row_Start#" maxrows="#Row_End#">
                                    <cfif SPECT_ROW_ID eq 0>
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
                                            row_nettotal = wrk_round((row_total/10000000000) * indirim_carpan);
                                            row_taxtotal = wrk_round(row_nettotal * (tax_percent/100));
                                            row_lasttotal = row_nettotal + row_taxtotal;
                                            //SİMDİLİK ORDERDAKİ TOPLAMLARI YAZIYOR ANCAK BİR SÜRE DURSUN SORUN OLURSA AÇILIR
                                            //sepet_total = sepet_total + row_total; //subtotal_
                                            //sepet_toplam_indirim = sepet_toplam_indirim + wrk_round(row_total) - wrk_round(row_nettotal); //discount_
                                            //sepet_total_tax = sepet_total_tax + row_taxtotal; //totaltax_
                                            //sepet_net_total = sepet_net_total + row_lasttotal; //nettotal_
                                        </cfscript>
                                        <cfset yazilan_satir = yazilan_satir + 1>
                                        <tr>
                                            <td>#Barcod#</td>
                                            <td>#Stock_Code#</td>
                                            <td>#Product_Name#</td>
                                            <td style="text-align:right;">#Quantity# #Unit#</td>
                                            <td style="text-align:right;">#TLFormat(Price)#</td>
                                            <td>#session.ep.money#</td>
                                            <td style="text-align:right;">#TLFormat(row_nettotal)#</td>
                                        </tr>
                                    <cfelse>
                                        <cfset yazilan_satir=yazilan_satir+1>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>#Stock_Code#</td>
                                            <td>#Spect_Name#</td>
                                            <td style="text-align:right;">#Quantity*Spect_Amount#</td>
                                            <td style="text-align:right;" colspan="3">&nbsp;</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <cfif i eq Page_Count>
                        <tr>
                            <td>
                                <table border="0" style="width:170mm;" cellspacing="0" cellpadding="0">
                                    <tr><td><strong><cf_get_lang dictionary_id='30017.Yalnız'> : </strong><cfset mynumber = Get_Order.NETTOTAL><cf_n2txt number="mynumber"> <cfoutput>#mynumber#</cfoutput> 'dir.</td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="98%">
                                    <tr valign="top">
                                        <td>
                                            <table>
                                            <cfoutput>
                                                <tr>
                                                    <td><strong><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></strong></td>
                                                    <td>:<cfif len(Get_Order.PAYMETHOD)>#GET_PAYMETHOD.PAYMETHOD#</cfif></td>
                                                </tr>
                                                <tr>
                                                    <td><strong><cf_get_lang dictionary_id='38499.Ek Açıklama'> </strong></td>
                                                    <td width="300">:#Get_Order.Order_Detail#</td>
                                                </tr>
                                                <tr>
                                                    <td><strong><cf_get_lang dictionary_id='33314.Kur Bilgisi'> </strong></td>
                                                    <td>:#Get_Order.other_money#
                                                        <cfquery name="GET_MONEY" datasource="#DSN3#">
                                                            SELECT RATE1,RATE2 FROM ORDER_MONEY WHERE MONEY_TYPE = '#Get_Order.other_money#' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.order_id#">
                                                        </cfquery>
                                                        #GET_MONEY.RATE1# / #TLFormat(GET_MONEY.RATE2,4)#
                                                    </td>
                                                </tr>
                                            </cfoutput>
                                            </table>
                                        </td>
                                        <td height="97" style="text-align:right;">
                                            <table>
                                            <cfoutput>
                                                <tr>
                                                    <td width="100"><cf_get_lang dictionary_id='57673.Tutar'></td>
                                                    <td class="txtbold" style="text-align:right;">#TLFORMAT(Get_Order.GROSSTOTAL)#</td>
                                                </tr>
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='57641.İskonto'></td>
                                                    <td class="txtbold" style="text-align:right;">#TLFORMAT(Get_Order.DISCOUNTTOTAL)#</td>
                                                </tr>
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='53332.Vergi'></td>
                                                    <td class="txtbold" style="text-align:right;">#TLFORMAT(Get_Order.TAXTOTAL)#</td>
                                                </tr>
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='29534.Toplam Tutar'></td>
                                                    <td class="txtbold" style="text-align:right;">#TLFORMAT(Get_Order.NETTOTAL)#</td>
                                                </tr>
                                            </cfoutput>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr><td valign="top" height="50">&nbsp;</td></tr>
                    <cfelse>
                    </cfif>
                </table>
            </td>
            <td style="width:10mm">&nbsp;</td>
        </tr>
    </table>
	<cfset Row_Start = Row_End + Row_Start>
</cfloop>
