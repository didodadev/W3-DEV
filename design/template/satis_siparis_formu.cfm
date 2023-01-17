<!--- Standart Satis Siparis Formu --->
<!---<cfif not isdefined("attributes.action_id")><!--- Toplu Printte gelmesin diye eklendi --->
	<cf_get_lang dictionary_id="865.Seçmiş Olduğunuz Şablon Bu İşlem İçin Uygun Değil">!
	<cfexit method="exittemplate">
</cfif>--->
<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.order_id = listdeleteduplicates(attributes.iid)>
<cfelse>
	<cfset attributes.order_id = attributes.action_id>
</cfif>
<cfif not isDefined("attributes.data_source")><cfset attributes.data_source = dsn></cfif><!--- Baska sayfalardan include edildiginde sorun olmamasi adina eklendi fbs20130412 --->
<cfquery name="Our_Company" datasource="#attributes.data_source#">
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
	   #dsn_alias#.OUR_COMPANY 
	WHERE 
	<cfif isDefined("SESSION.EP.Company_Id")>
		COMP_ID = #SESSION.EP.Company_Id#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = #SESSION.PP.COMPANY#
	</cfif>
</cfquery>
<cfif isDefined('attributes.Order_id')>
	<cfquery name="Get_Order" datasource="#attributes.data_source#">
		SELECT 
        	O.DELIVERDATE,
            O.SHIP_METHOD,
            O.ORDER_NUMBER,
            O.ORDER_DATE,
            O.ORDER_EMPLOYEE_ID,
            O.SHIP_ADDRESS,
            O.PAYMETHOD,
            O.ORDER_DETAIL,
            O.ORDER_ID,
            O.OTHER_MONEY,
            C.FULLNAME,            
            C.COMPANY_TEL1,
            C.COMPANY_TELCODE,             
            CP.COMPANY_PARTNER_NAME,
            CP.COMPANY_PARTNER_SURNAME,
            SHIP_METHOD.SHIP_METHOD AS SHIP_METHOD_
       	FROM 
        	#dsn3_alias#.ORDERS O 
            LEFT JOIN COMPANY C ON C.COMPANY_ID = O.COMPANY_ID
			LEFT JOIN COMPANY_PARTNER CP ON CP.COMPANY_ID = C.COMPANY_ID AND CP.PARTNER_ID = O.PARTNER_ID
            LEFT JOIN #dsn_alias#.SHIP_METHOD ON SHIP_METHOD_ID =  O.SHIP_METHOD
        WHERE ORDER_ID IN ( #attributes.Order_id# )
	</cfquery>
</cfif>
<cfquery name="Get_Order_Row" datasource="#attributes.data_source#">
	SELECT
		ORR.*,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION
	FROM
		#dsn3_alias#.ORDER_ROW ORR,
		#dsn3_alias#.STOCKS S
	WHERE
		ORR.ORDER_ID IN ( #attributes.Order_id# )
        AND
		ORR.STOCK_ID = S.STOCK_ID
	ORDER BY
		ORR.ORDER_ROW_ID
</cfquery>
<!---<cfif len(Get_Order.Order_Employee_id)>
	<cfquery name="Get_Order_Emp" datasource="#attributes.data_source#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			#dsn_alias#.EMPLOYEES E
		WHERE 
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Order_Employee_id#">
	</cfquery>
	<cfset satis_yapan = Get_Order_Emp.Employee_Name&' '&Get_Order_Emp.Employee_Surname>
<cfelse>
	<cfset satis_yapan = "">
</cfif>--->
<!--- Odeme Yontemi --->
<!---<cfif len(Get_Order.Paymethod)>
	<cfquery name="Get_Paymethod_Name" datasource="#attributes.data_source#">
		SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Paymethod#">
	</cfquery>
</cfif>
	 <cfif len(Get_Order.Card_Paymethod_id)>
	<cfquery name="get_card_paymethod_name" datasource="#attributes.data_source#">
		SELECT CARD_NO FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Card_Paymethod_id#">
	</cfquery>
</cfif>--->
<!--- // --->
<!--- Sevk Yontemi --->
<!----<cfif len(Get_Order.Ship_Method)>
	<cfquery name="Get_Ship_Method" datasource="#attributes.data_source#">
		SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Ship_Method#">
	</cfquery>
</cfif>--->
<!--- Uye bilgileri --->
<!----<cfset Member_Code = "">
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
	<cfquery name="Get_Member_Info" datasource="#attributes.data_source#">
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
            #dsn_alias#.COMPANY
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Company_Id#">
	</cfquery>
<cfelseif isdefined("Get_Order.Consumer_Id") and Len(Get_Order.Consumer_Id)>
	<cfquery name="Get_Member_Info" datasource="#attributes.data_source#">
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
        	#dsn_alias#.CONSUMER
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
		<cfquery name="Get_County_Name" datasource="#attributes.data_source#">
			SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
		</cfquery>
		<cfset Member_County = Get_County_Name.County_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_City)>
		<cfquery name="Get_City_Name" datasource="#attributes.data_source#">
			SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
		</cfquery>
		<cfset Member_City = Get_City_Name.City_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_Country)>
		<cfquery name="Get_Country_Name" datasource="#attributes.data_source#">
			SELECT COUNTRY_NAME FROM #dsn_alias#.SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
		</cfquery>
		<cfset Member_Country = Get_Country_Name.Country_Name>
	</cfif>
</cfif>
<cfif len(Get_Order.Partner_id)>
    <cfquery name="Get_Partner" datasource="#attributes.data_source#">
        SELECT COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME PARTNER_NAME FROM #dsn_alias#.COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Partner_id#">
    </cfquery>
	<cfset Partner_Name = Get_Partner.PARTNER_NAME>
</cfif>--->
<!--- //Uye bilgileri --->
<cfquery name="Get_Upper_Position" datasource="#attributes.data_source#">
	SELECT UPPER_POSITION_CODE FROM #dsn_alias#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
</cfquery>
<cfif Len(Get_Upper_Position.UPPER_POSITION_CODE)>
    <cfquery name="Get_Chief1_Name" datasource="#attributes.data_source#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Upper_Position.UPPER_POSITION_CODE#">
    </cfquery>
</cfif>
<cfset sepet_total = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_net_total = 0>
<cfset Row_Start = 1>
<cfset Row_End = 23>
<!---<cfif Get_Order_Row.RecordCount><cfset Page_Count = Ceiling(Get_Order_Row.RecordCount/Row_End)><cfelse><cfset Page_Count = 1></cfif>--->
<cfset Page_Count = 1>
 <style>
	.box_yazi {border : 0px none #e1ddda;border-width : 0px 0px 0px 0px;border-bottom-width : 0px;background-color : transparent;background-color:#FFFFFF;text-align: left;font:Arial, Helvetica, sans-serif;font-size:12px;} 
	.bold{font-weight:bold;}
	table,td{font-size:11px;font-family:Arial, Helvetica, sans-serif;}
	.color-bg {border:0px solid #333; width:190mm;height:285mm;}
	.color-bg table {border-collapse:collapse;}
</style>
<cfoutput query="get_order">
<cfloop from="1" to="#Page_Count#" index="i">
<div class="color-bg">
    <table>
        <tr>
            <td style="width:10mm;" rowspan="10">&nbsp;</td>
            <td style="height:10mm;">&nbsp;</td>
        </tr>
         <tr valign="top">
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="16">
                            <td align="left" width="60%"><img src="#user_domain##file_web_path#settings/#our_company.asset_file_name3#" border="0"></td>
                            <td style="text-align:right;">
                                <b>#Our_Company.company_name#</b><br/>
                                #Our_Company.address#<br/>
                                <cf_get_lang dictionary_id='57499.Telefon'>: #Our_Company.tel_code# #Our_Company.tel#<br/>
                                <cf_get_lang dictionary_id='57488.Fax'>: #Our_Company.tel_code# #Our_Company.fax#<br/>
                                #Our_Company.web#&nbsp;&nbsp;#Our_Company.email#
                            </td>
                    </tr>
                    <tr><td colspan="2" style="height:10mm;">&nbsp;</td></tr>
                </table>
                <table cellpadding="3" cellspacing="0" border="1" width="100%">
                    <tr>
                        <td style="width:60mm;"bgcolor="000000"><font color="FFFFFF" size="+2"><cf_get_lang dictionary_id="58207.SATIŞ SİPARİŞ"></font></td>
                        <td style="text-align:left;"><b><cf_get_lang dictionary_id='57880.Belge No'> :</b> #Get_Order.order_number#</td>
                        <td style="text-align:right;"><b><cf_get_lang dictionary_id='57742.Tarih'> :</b> #dateformat(Get_Order.order_date,dateformat_style)#</td>
                    </tr>
                </table>
                <table border="0" cellspacing="0" cellpadding="0" style="width:180mm; height:45mm;">
                    <tr><td colspan="4" style="height:10mm;">&nbsp;</td></tr>
                    <tr style="height:7mm;">
                        <td style="width:20mm;" class="txtbold"><cf_get_lang dictionary_id='58607.Firma'></td>
                        <td style="width:70mm;">: #fullname#</td>
                        <td style="width:30mm;" class="txtbold"><cf_get_lang dictionary_id='29775.Hazırlayan'></td>
                        <td style="width:70mm;">:
                            <cfquery name="Get_Emp_Info" datasource="#attributes.data_source#">
                                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEE_ID = <cfif len(Get_Order.Order_Employee_id)>#Get_Order.Order_Employee_id#<cfelse>#GET_ORDER.record_emp#</cfif>
                            </cfquery><!---???--->
                           <cfif Get_Emp_Info.recordcount>#Get_Emp_Info.employee_name# #Get_Emp_Info.employee_surname#</cfif>
                        </td>
                    </tr>
                    <tr style="height:7mm;">
                        <td class="txtbold"><cf_get_lang dictionary_id='57578.Yetkili'></td>
                        <td>: <cfif len(company_partner_name) and len(company_partner_surname)>#company_partner_name# #company_partner_surname#</cfif></td>
                        <td class="txtbold"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
                        <td>: <cfif len(DELIVERDATE)>#DateFormat(DELIVERDATE,dateformat_style)#</cfif></td>
                    </tr>
                    <tr style="height:7mm;">
                        <td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'></td>
                        <td>: <cfif Len(Company_Tel1)>#Company_TelCode# #Company_Tel1#</cfif></td>
                        <td class="txtbold"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
                        <td>: <cfif len(Get_Order.ship_method_)>#Get_Order.Ship_Method_#</cfif></td>
                    </tr>
                    <tr>
                        <td class="txtbold" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
                        <td style="width:70mm;height:7mm;" valign="top">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>:</td>
                                    <td>#Ship_Address#</td>
                                </tr>
                            </table>
                        </td>
                        <cfif len(Get_Order.Paymethod)>
							<cfquery name="Get_Paymethod_Name" datasource="#attributes.data_source#">
								SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order.Paymethod#">
							</cfquery>
						</cfif>
                        <td class="txtbold"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
                        <td>: <cfif len(Paymethod)>#Get_Paymethod_Name.Paymethod#</cfif></td>
                    </tr>
                    <tr style="height:7mm;">
                         <td class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                         <td>: <cfif len(Order_Detail)>#Order_Detail#</cfif></td>
                         <td>&nbsp;</td>
                         <td>&nbsp;</td>
                    </tr>
                 </table>
            </td>
        </tr>
        <tr style="height:6mm;"><td>&nbsp;</td></tr>
        <tr>
            <td valign="top">
                <table align="center" width="100%">
                    <tr bgcolor="CCCCCC">
                        <td class="bold" style="height:5mm;"><cf_get_lang dictionary_id='58585.KOD'></td>
                        <td class="bold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                        <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
                        <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id='58084.Fiyat'></td>
                        <td class="bold" style="text-align:right;width:30mm;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    </tr>
                    <cfquery name="get_current_rows" dbtype="query">
                    	SELECT * FROM Get_Order_Row WHERE ORDER_ID = #GET_ORDER.ORDER_ID#
                    </cfquery>
                    <cfloop query="get_current_rows">
                        <cfif not IsDefined('ilk_urun_id')><cfset ilk_urun_id=PRODUCT_ID></cfif>
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
                            sepet_total = sepet_total + row_total; //subtotal_
                            sepet_toplam_indirim = sepet_toplam_indirim + wrk_round(row_total) - wrk_round(row_nettotal); //discount_
                            sepet_total_tax = sepet_total_tax + row_taxtotal; //totaltax_
                            sepet_net_total = sepet_net_total + row_lasttotal; //nettotal_
                        </cfscript>                        
                        <tr>
                            <td style="width:25mm; height:5mm;">#STOCK_CODE#</td>
                            <td style="width:65mm;">#PRODUCT_NAME#</td>
                            <td style="text-align:right;">#QUANTITY# #UNIT#</td>
                            <td style="text-align:right;width:30mm;"><cfif QUANTITY neq 0>#TLFormat(row_nettotal/QUANTITY)#<cfelse>#TLFormat(row_nettotal)#</cfif></td>
                            <td style="text-align:right;width:30mm;">#TLFormat(row_nettotal)#</td>
                        </tr>
                    </cfloop>
                </table>
            </td>
        </tr>        		
        <tr style="height:6mm;"><td>&nbsp;</td></tr>
        <tr valign="top">
            <td>
                <table border="0" cellpadding="0" cellspacing="0" align="left">
                    <tr style="height:7mm;">
                        <td style="width:15mm;" class="bold"><cf_get_lang dictionary_id='57422.Notlar'> :</td>
                        <td style="width:45mm;"><input type="text" class="box_yazi" style="width:45mm; font-size:12px;"/></td>
                    </tr>
                </table>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <cfif i eq Page_Count>
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" align="right">
                                <tr>
                                    <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
                                    <td style="text-align:right;width:30mm;">#TLFormat(sepet_total)#</td>
                                </tr>
                                <tr>
                                    <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57641.İskonto'></td>
                                    <td style="text-align:right;width:30mm;">#TLFormat(sepet_toplam_indirim)#</td>
                                </tr>
                                <tr>
                                    <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='33304.Vergi'></td>
                                    <td style="text-align:right;width:30mm;">#TLFormat(sepet_total_tax)#</td>
                                </tr>
                                <tr>
                                    <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='29534.Toplam Tutar'></td>
                                    <td style="text-align:right;width:30mm;">#TLFormat(sepet_net_total)#</td>
                                </tr>
                                <tr>
                                    <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id="33314.Kur Bilgisi"></td>
                                    <td style="text-align:right;width:30mm;">#Get_Order.other_money#
                                        <cfquery name="Get_Money" datasource="#attributes.data_source#">
                                            SELECT RATE1,RATE2 FROM #dsn3_alias#.ORDER_MONEY WHERE MONEY_TYPE = '#Get_Order.other_money#' AND ACTION_ID = #Get_Order.order_id#
                                        </cfquery>
                                        #Get_Money.RATE1# / #TLFormat(Get_Money.RATE2,4)#
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                <cfelse>
                    <tr><td style="text-align:right;">&nbsp;</td></tr>
                </cfif>        
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr><td colspan="3" style="height:5mm;">&nbsp;</td></tr>
                    <tr style="height:7mm;">
                        <td class="bold"><cf_get_lang dictionary_id="33306.ONAYLAR"></td>
                    </tr>
                    <tr style="height:7mm;">
                        <td style="width:50mm;" class="bold"><cf_get_lang dictionary_id='29511.YÖNETİCİ'><cf_get_lang dictionary_id='57500.ONAY'></td>
                        <td style="width:50mm;" class="bold"><cf_get_lang dictionary_id='29511.YÖNETİCİ'><cf_get_lang dictionary_id='57500.ONAY'></td>
                    </tr>
                    <tr style="height:7mm;">
                        <td><cfif len(Get_Upper_Position.UPPER_POSITION_CODE)>#Get_Chief1_Name.EMPLOYEE_NAME# #Get_Chief1_Name.EMPLOYEE_SURNAME#</cfif></td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr> 
        <tr><td>&nbsp;</td></tr>
    </table>
</div>
<cfset Row_Start = Row_End + Row_Start>
</cfloop>
</cfoutput>
