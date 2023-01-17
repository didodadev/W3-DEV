<!--- Standart Irsaliye Baski --->
<cfif not isdefined("attributes.action_id")><!--- Toplu Printte gelmesin diye eklendi --->
	<cf_get_lang dictionary_id="33255.Seçmiş Olduğunuz Şablon Bu İşlem İçin Uygun Değil">!
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.ship_id = attributes.action_id>
<cfquery name="Get_Ship_Type" datasource="#dsn2#">
	SELECT SHIP_TYPE FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery> 
<cfquery name="Get_Ship" datasource="#dsn2#">
	SELECT
		S.*,
		(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = S.PROJECT_ID) PROJECT_HEAD,
		(SELECT PP.PROJECT_NUMBER FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = S.PROJECT_ID) PROJECT_NUMBER,
		D.DEPARTMENT_HEAD
	FROM
		SHIP S,
		#dsn_alias#.DEPARTMENT D
	WHERE
		S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
		<cfif listfind("73,74,75,76,77,80,81,811,82,84,86,87,140",Get_Ship_Type.Ship_Type,",")>
			D.DEPARTMENT_ID = S.DEPARTMENT_IN
		<cfelse>
			D.DEPARTMENT_ID = S.DELIVER_STORE_ID
		</cfif>
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
<cfif isdefined("Get_Ship.Company_Id") and Len(Get_Ship.Company_Id)>
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
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Ship.Company_Id#">
    </cfquery>
<cfelseif isdefined("Get_Ship.Consumer_Id") and Len(Get_Ship.Consumer_Id)>
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
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Ship.Consumer_Id#">
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
<cfquery name="Get_Ship_Row" datasource="#dsn2#">
	SELECT
		SR.*,
		S.STOCK_CODE
	FROM
		SHIP_ROW SR,
		#dsn3_alias#.STOCKS S
	WHERE
		SR.STOCK_ID = S.STOCK_ID AND 
		SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
	ORDER BY
		SR.SHIP_ROW_ID
</cfquery>
<cfquery name="Get_Order_Num" datasource="#dsn3#">
	SELECT
		ORD.ORDER_NUMBER
	FROM
		ORDERS ORD,
		ORDERS_SHIP ORS
	WHERE
		ORD.ORDER_ID = ORS.ORDER_ID AND
		ORS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		ORS.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
	ORDER BY 
		ORD.ORDER_ID DESC
</cfquery>
<cfset Row_Start = 1>
<cfset Row_End = 27>
<cfset Page_Count = ceiling(Get_Ship_Row.RecordCount / Row_End)>
<cfif Page_Count eq 0><cfset Page_Count = 1></cfif>
<cfloop from="1" to="#Page_Count#" index="j">
    <table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:279.3mm;">
        <tr>
            <td style="width:1mm">&nbsp;</td>
            <td valign="top">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <cfoutput>
                            <tr><td colspan="2" style="height:42mm;"></td></tr>
                            <tr>
                                <td valign="top" style="width:135mm;height:62mm;">
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width:150mm;height:30mm;" valign="top">
                                            <b>#Member_Name#</b><br/>
                                            <strong><cf_get_lang dictionary_id='34252.Sevk Adresi'> :</strong> #Get_Ship.Address#<br/>                
                                            <strong><cf_get_lang dictionary_id='58138.İrsaliye No'> :</strong> #Get_Ship.Ship_Number#<br/>
                                            <strong><cf_get_lang dictionary_id='58211.Sipariş No'> :</strong><cfif Get_Order_Num.RecordCount> #Get_Order_Num.Order_Number#</cfif><br>
                                            <strong><cf_get_lang dictionary_id="33256.Proje İsmi"> :</strong> #Get_Ship.Project_Number#-#Get_Ship.Project_Head#<br>
                                            <strong><cf_get_lang dictionary_id="57775.Teslim Alan"> :</strong> #Get_Ship.Deliver_Emp#
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width:20mm;height:8mm;">&nbsp;</td>
                                                    <td style="width:55mm">#Member_TaxOffice#</td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td style="width:20mm;height:8mm;">&nbsp;</td>
                                                    <td>#Member_TaxNo#</td>
                                                    <td class="txtbold">#Member_Code#</td>
                                                </tr>
                                            </table>				
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table>
                                        <tr><td style="height:37mm;">&nbsp;</td></tr>
                                        <tr><td>#dateformat(Get_Ship.Ship_Date,dateformat_style)#</td></tr>
                                        <tr><td style="height:5mm">#dateformat(Get_Ship.Deliver_Date,dateformat_style)#</td></tr>
                                    </table>
                                </td>
                            </tr>
                            </cfoutput>
                        </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="height:120mm;">
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="bold"><cf_get_lang dictionary_id='57518.Inventory Code'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57657.Product'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57635.Quantity'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57636.Unit'></td>
                                </tr>
                            <cfloop from="#Row_Start#" to="#Row_End#" index="i">
                                <cfif i lte Get_Ship_Row.RecordCount>
                                    <cfscript>
                                        if(len(Get_Ship_Row.discount[i]))indirim = Get_Ship_Row.discount[i]; else indirim = 0;
                                        adim_1 = Get_Ship_Row.amount[i] * Get_Ship_Row.price[i];
                                        adim_2 = (adim_1/100)*(100-indirim);
                                        adim_3 = adim_2*(Get_Ship_Row.tax[i]/100);
                                        adim_4 = adim_2+adim_3;
                                    </cfscript>
                                    <tr>
                                    <cfoutput>
                                        <td style="width:25mm;">#Get_Ship_Row.Stock_Code[i]#</td>
                                        <td style="width:110mm;">#left(Get_Ship_Row.Name_Product[i],53)#</td>
                                        <td style="width:10mm;text-align:right;">#TLFormat(Get_Ship_Row.Amount[i])#</td>
                                        <td style="width:10mm;text-align:center;">#Get_Ship_Row.Unit[i]#</td>
                                    </cfoutput>
                                    </tr>
                                </cfif>
                            </cfloop>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <cfset Row_Start = Row_Start + 27>
    <cfset Row_End = Row_Start + 26>
</cfloop>
