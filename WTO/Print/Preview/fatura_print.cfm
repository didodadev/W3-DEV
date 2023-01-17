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
	<cfset invoice_bill_upd[currentrow][2] = product_name>
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
 <link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
<cfif ((i mod attributes.mode eq 1)) or (i eq 1)>
    <table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='58917.FATURALAR'></b></td>
										<td style="text-align:right;">
											<cfif len(check.asset_file_name2)>
											<cfset attributes.type = 1>
												<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
											</cfif>
										</td>
									</td>
								</tr> 
							</table>
						</td>
                    </tr> 
                    <tr class="row_border">
                        <td> 
                            <cfoutput>
                                <table style="width:140mm"> 
                                    <tr>
                                       <td   style="width:140px"> <b><cf_get_lang_main dictionary_id='58133.FT NO'></b></td><td>#Get_Invoice.Invoice_Number#</td>
                                           <td   style="width:140px"> <b><cf_get_lang dictionary_id='58762.Vergi Dairesi'></b> </td>
                                            <td>#Member_TaxOffice#</td> 
                                    </tr>
                                    <tr>
                                       <td   style="width:140px"> <b><cf_get_lang dictionary_id='57558.Üye no'></b> </td>
                                        <td>#Member_Code#</td> 
                                    
                                       <td   style="width:140px"> <b><cf_get_lang dictionary_id='57752.Vergi No'></b> </td>
                                        <td>#Member_TaxNo#</td> 
                                        <!---  <td>&nbsp;</td>
                                        <td><cfif (isdefined("get_member_info.TC_IDENTY_NO") and len(get_member_info.TC_IDENTY_NO)) or (isdefined("get_member_info.TC_IDENTITY") and len(get_member_info.TC_IDENTITY))  and not len(get_member_info.member_taxno)>#Member_Tc_No#<cfelse>#Member_TaxNo#</cfif></td>
                                        <td>&nbsp;</td> --->
                                    </tr>
                                    
                                    <tr>
                                       <td   style="width:140px"> <b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></td>
                                        <td >
                                            #Member_Name#
                                            <!---   #Get_Invoice.Ship_Address# --->
                                        </td>
                                       <td   style="width:140px"> <b><cf_get_lang dictionary_id='58759 .fatura tarihi'></b> </td>
                                        <td >#dateformat(Get_Invoice.Invoice_Date,'dd.mm.yyyy')##timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</td>
                                    </tr>
                                    <table style="width:210mm" height="35px">
                                        <tr>   
                                           <td   style="width:140px"> <b><cf_get_lang dictionary_id='30516.sevk adresi'></b> </td>
                                            <td >#Get_Invoice.SHIP_ADDRESS#</td>
                                        </tr>
                                    </table>
                                </table>
                            </cfoutput>
                        </td>
                    </tr>
                    <table>
                        <tr>
                            <td style="height:35px;"><b><cf_get_lang dictionary_id='33929.ÜRÜN DETAY"'></b></td>
                        </tr> 
                    </table>
                    <table class="print_border" style="width:190mm">
                        <cfset DISC_TOTAL=0>   <tr>
                            <th><b><cf_get_lang dictionary_id='57518.stok kodu'></b></td>
                            <th ><b><cf_get_lang dictionary_id='38019.ürün ismi'></b></td>
                            <th><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
                            <th ><b><cf_get_lang dictionary_id='58083.Net'></b> <b><cf_get_lang dictionary_id='58084.Fiyat'></b></td>
                            <th><b><cf_get_lang dictionary_id='57639.KDV'></b></th>
                                <!---  <th><b><cf_get_lang dictionary_id='58560.İNDİRİM'></b></th> --->
                            <th><b><cf_get_lang dictionary_id='57673.Tutar'></b></th> 
                        </tr></cfif><cfoutput>
                        <tr>
                            <td >#invoice_bill_upd[i][3]#</td>
                            <td>#invoice_bill_upd[i][2]#</td>
                            <td  style="text-align:right;">#invoice_bill_upd[i][4]# #invoice_bill_upd[i][5]#</td>
                            <td style="text-align:right;">#TLFormat(invoice_bill_upd[i][6])#&nbsp;#session.ep.money#</td>
                            <td style="text-align:right;">#TLFormat(invoice_bill_upd[i][17])#&nbsp;#session.ep.money#</td>
                            <!---  <td style="text-align:right;">#TLFormat(satir_indirim_toplam)#&nbsp;#session.ep.money#</td> --->
                            <td style="text-align:right;">#TLFormat(invoice_bill_upd[i][18])#&nbsp;#session.ep.money#</td>

                            <!---  <td>#TLFormat((invoice_bill_upd[i][4]*invoice_bill_upd[i][6]))#</td> --->
                        </tr> 
                        <cfset Disc_Total = Disc_Total + (invoice_bill_upd[i][15] - invoice_bill_upd[i][16])>
                        <cfset sayfa_toplam = sayfa_toplam + invoice_bill_upd[i][16]>
                        <cfset satir_indirim_toplam = satir_indirim_toplam + invoice_bill_upd[i][8]>
                        <cfset toplam_indirim = toplam_indirim + invoice_bill_upd[i][8]>
                        </cfoutput> <cfif ((i mod attributes.mode eq 0)) or (i eq arraylen(invoice_bill_upd))>
                    </table>
                    <cfif ((i mod attributes.mode eq 0)) and (i neq arraylen(invoice_bill_upd))>	
                    <cfset all_total =  devreden_toplam +  sayfa_toplam> 
            
                        <!---  <table border="0" style="width:180mm;" cellspacing="0" cellpadding="0">
                            <tr>
                                <td></td>
                                <td >
                                    <cfoutput>
                                    <table>
                                    <cfif i neq attributes.mode>
                                        <tr>
                                            <td ><cf_get_lang_main no='622.Devreden'> <cf_get_lang_main no='80.Toplam'></b></td>
                                            <td style="text-align:right;">&nbsp;#TLFormat(devreden_toplam)#</td>
                                        </tr>			  
                                    </cfif>	
                                    <tr>
                                       <td   style="width:140px"> <b><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></b></td>
                                        <td style="text-align:right;">&nbsp;#TLFormat(sayfa_toplam)#</td>
                                    </tr>
                                    <tr>
                                       <td   style="width:140px"> <b><cf_get_lang_main no='237.İnd Toplam'></b></td>
                                        <td style="text-align:right;">&nbsp;#TLFormat(satir_indirim_toplam)#</td>
                                    </tr>
                                    <cfif i neq attributes.mode>
                                        <tr>
                                           <td   style="width:140px"> <b><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></b></td>
                                            <td style="text-align:right;">&nbsp;#TLFormat(all_total)#</td>
                                        </tr>
                                    </cfif>
                                    </table>	 --->
                                    <!--- </cfoutput>	
                        </table>    --->
            
                    <cfset devreden_toplam =  devreden_toplam +  sayfa_toplam>
                    <cfset sayfa_toplam = 0>
                    <cfset satir_indirim_toplam = 0>
                    </cfif>		
                    <!--- <cfif (i eq arraylen(invoice_bill_upd))>
                    <br/><br/> --->
                    <!--- <table border="0" cellspacing="0" cellpadding="0" width="100%">
                        
                            
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
                            </td> --->
                    <cfoutput>
                        <table>
                            <tr>
                                <td  style="height:35px;"><b><cf_get_lang dictionary_id='33016.fiyat detay'></b></td>
                            </tr>
                        </table>
                        <table class="print_border" style="width:100mm">
                            <tr>
                                <th ><b>  <cf_get_lang dictionary_id='58083.Net'></b> <b><cf_get_lang dictionary_id='58084.Fiyat'><cf_get_lang dictionary_id='58659.Tutar'></b></th>
                               <!---  <th><b><cf_get_lang dictionary_id='57649.Toplam İndirim'></b></th>
                                <th><b><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'></b></th> --->
                                <th><b><cf_get_lang dictionary_id='31169.Toplam KDV'></b></th>
                                <th ><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></th>
                            </tr>
                            <tr>
                                <td style="text-align:right;">#TLFormat(Get_Invoice.Grosstotal)#&nbsp;#session.ep.money#</td>
                                 <!---  <td style="text-align:right;">#TLFormat(satir_indirim_toplam)#&nbsp;#session.ep.money#</td>
                                <td style="text-align:right;">#TLFormat(toplam_indirim+Get_Invoice.Sa_Discount)#&nbsp;#session.ep.money#</td> --->
                               
                                    <td style="text-align:right;">#TLFormat(Get_Invoice.Taxtotal)#&nbsp;#session.ep.money#</td>
                                    <td style="text-align:right;">#TLFormat(Get_Invoice.Nettotal)#&nbsp;#session.ep.money#</td>
                                <!---  
                                    <td style="text-align:right;">#TLFormat(Get_Invoice.Grosstotal-(toplam_indirim+Get_Invoice.Sa_Discount))#&nbsp;#session.ep.money#</td>
                            
                                <cfif Get_Invoice.tevkifat eq 1 and len(Get_Invoice.Tevkifat_Oran)>
                            
                                    <td> #Get_Invoice_Row.tax#</td>
                                    <td style="text-align:right;">#TLFormat(kdv_total)#</td>
                            
                            
                                    <td ><!--- <strong>1/3 <cf_get_lang_main no='227.KDV'> <cf_get_lang_main no='610.Tevkifat'></strong> --->
                                    <cfif Len(Get_Invoice.TEVKIFAT)>
                                        #Get_Setup_Tevkifat.STATEMENT_RATE_NUMERATOR#/#Get_Setup_Tevkifat.STATEMENT_RATE_DENOMINATOR#
                                    <cfelse>
                                        &nbsp;
                                    </cfif>
                                    </td>
                                    <td style="text-align:right;">#TLFormat(kdv_total-((kdv_total*Get_Invoice.Tevkifat_Oran)/100))#</td>
                            
                                
                                    <td style="text-align:right;">#TLFormat(Get_Invoice.Taxtotal)#</td>
                            
                                <cfelse>
                                 <!--- </cfif> --->
                                        --->
                                <!---  <td style="text-align:right;">#TLFormat(Get_Invoice.Nettotal)#&nbsp;#session.ep.money#</td> --->
                            </tr>
                        </table>
                        <table>
                            </br>
                                <tr class="fixed">
                                   <td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
                                </tr>
                            </br>
                        </table>	
                    </cfoutput>
                    <!---  </cfif> --->
                </table>		
		    </td>
	    </tr>
    </table>
</cfif>
</cfloop>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
