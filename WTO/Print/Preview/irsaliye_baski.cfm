<!--- Standart Irsaliye Baski --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
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
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
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
    <table style="width:210mm">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td class="print-head">
                            <table style="width100%;">
                                <tr>
                                    <td class="print_title"><cf_get_lang dictionary_id='61638.Genel İrsaliye'></td>
                                    <td style="text-align:right;">
                                        <cfif len(check.asset_file_name2)>
                                        <cfset attributes.type = 1>
                                            <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="row_border"class="row_border">
                        <td>
                            <table style="width:160mm">
                                <cfoutput>
                                    <tr>
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='57558.Üye no'></b> </td>
                                        <td >#Member_Code#</td> 
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='58211.Sipariş No'> </b></td>
                                        <td> #Get_Order_Num.Order_Number#</td>
                                    </tr>
                                    <tr >
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='57519. Cari Hesap'></b></td>
                                        <td>#Member_Name#</td> 
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id="33256.Proje İsmi"></b></td>
                                        <td>#Get_Ship.Project_Number#&nbsp;#Get_Ship.Project_Head#</td>
                                    </tr>
                                    <tr>
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='57752.Vergi No'></b> </td>
                                        <td>#Member_TaxNo#</td> 
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id="57775.Teslim Alan"> 
                                        </td><td>#Get_Ship.Deliver_Emp#</td>
                                    </tr> 
                                    </tr> 
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='58762.Vergi Dairesi'></b> </td>
                                        <td>#Member_TaxOffice#</td> 
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='30631.Tarih'></b> </td>
                                        <td>#dateformat(Get_Ship.Ship_Date,dateformat_style)#</td>
                                    </tr>
                                    <tr>           
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='58138.İrsaliye No'></b> </td>
                                        <td>#Get_Ship.Ship_Number#</td>
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='34140.Fiili sevk Tarihi'></b></td><td>#dateformat(Get_Ship.Deliver_Date,dateformat_style)#</td>
                                    </tr>
                                    <table width="100%" style="height:40px;">
                                    <tr>
                                        <td   style="width:140px"><b><cf_get_lang dictionary_id='34252.Sevk Adresi'></b> </td>
                                        <td > #Get_Ship.Address#</td>     
                                    </tr>
                                </table>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <table>
                        <tr>
                            <td style="height:40px;"><b><cf_get_lang dictionary_id='33929.Ürün Detay'></b></td>
                        </tr>
                    </table>
                    <table class="print_border" style="width:160mm">
                        <tr>
                            <td   style="width:140px"><b><cf_get_lang dictionary_id='57518.Inventory Code'></b></td>
                            <td   style="width:140px"><b><cf_get_lang dictionary_id='57657.ÜRÜN'></b></td>
                            <td   style="width:140px"><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
                            <td   style="width:140px"><b><cf_get_lang dictionary_id='57636.Adet'></b></td>
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
                                    <td>#Get_Ship_Row.Stock_Code[i]#</td>
                                    <td>#left(Get_Ship_Row.Name_Product[i],53)#</td>
                                    <td  style="text-align:right;">#Get_Ship_Row.Amount[i]#</td>
                                    <td>#Get_Ship_Row.Unit[i]#</td>
                                </cfoutput>
                                </tr>
                            </cfif>
                        </cfloop>
                    </table>
                    <table>
                        <tr class="fixed">
                            <td style="font-size:9px!important;" height="35"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
                        </tr>
                    </table>
                </table>
            </td>
        </tr>
    </table>
    <cfset Row_Start = Row_Start + 27>
    <cfset Row_End = Row_Start + 26>
</cfloop>
