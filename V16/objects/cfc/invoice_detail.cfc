<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset DSN2=#DSN#&"_"&#session.ep.period_year#&"_"&#session.ep.company_id#>
    <cfset DSN3=#DSN#&"_"&#session.ep.company_id#>
        <cffunction name="get_invoice" access="remote" returntype="query" output="yes">
            <cfargument name="invoice_id" required="yes" type="numeric">
                 <cfquery name="Get_Invoice_Query" datasource="#dsn2#">
                    SELECT
                        INVOICE_ID,
                        PARTNER_ID,
                        COMPANY_ID,
                        CONSUMER_ID,
                        EMPLOYEE_ID,
                        DUE_DATE,
                        INVOICE_NUMBER,
                        SHIP_ADDRESS,
                        SHIP_DATE,
                        INVOICE_DATE,
                        RECORD_DATE,
                        UPDATE_DATE,
                        TEVKIFAT,
                        TEVKIFAT_ORAN,
                        STOPAJ,
                        STOPAJ_ORAN,
                        NOTE,
                        PROJECT_ID,
                        OTV_TOTAL,
                        GROSSTOTAL INV_ARA_TOPLAM,
                        TAXTOTAL INV_KDV_TOPLAM,
                        SA_DISCOUNT INV_INDIRIM_TOPLAM,
                        ISNULL(NETTOTAL,0) INV_GENEL_TOPLAM,
                        OTHER_MONEY,
                        OTHER_MONEY_VALUE INV_GENEL_TOPLAM_DOVIZ,
                        PAY_METHOD ODEME_YONTEMI,
                        CARD_PAYMETHOD_ID KART_ODEME_YONTEMI
                    FROM
                        INVOICE 
                    WHERE
                        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#">
                </cfquery>
            <cfreturn Get_Invoice_Query>
        </cffunction>
   		<!--- Ürün Basket Kısmı --->
        <cffunction name="get_invoice_row" access="remote" returntype="query" output="yes">
            <cfargument name="invoice_id" required="yes" type="numeric">
                        <cfquery name="Get_Invoice_Row_Query" datasource="#dsn2#">
                            SELECT 
                                IR.DISCOUNT1,
                                IR.DISCOUNT2,
                                IR.DISCOUNT3,
                                IR.DISCOUNT4,
                                IR.DISCOUNT5,
                                IR.DISCOUNT6,
                                IR.DISCOUNT7,
                                IR.DISCOUNT8,
                                IR.DISCOUNT9,
                                IR.DISCOUNT10,
                                IR.PRODUCT_ID,
                                IR.NAME_PRODUCT ROW_PRODUCT_NAME,
                                IR.AMOUNT ROW_MIKTAR,
                                IR.UNIT ROW_BIRIM,
                                IR.TAX ROW_KDV,
                                IR.PRICE,
                                IR.PRICE_OTHER,
                                IR.OTHER_MONEY,
                                IR.GROSSTOTAL INV_ARA_TOPLAM,
                                IR.NETTOTAL ROW_SON_TOPLAM,
                                IR.TAXTOTAL ROW_KDV_TOPLAM,
                                IR.DISCOUNTTOTAL ROW_INDIRIM_TOPLAM_YTL,
                                IR.ROW_PROJECT_ID,
                                S.STOCK_CODE
                            FROM
                                INVOICE_ROW IR,
                                #dsn3#.STOCKS S
                            WHERE
                                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND
                                IR.STOCK_ID = S.STOCK_ID
                            ORDER BY
                                IR.INVOICE_ROW_ID
                       </cfquery> 
                    <cfreturn Get_Invoice_Row_Query>
        </cffunction>
        <cffunction name="get_member_info" access="remote" returntype="query" output="yes">
            <cfargument name="consumer_id" required="yes" type="string">
            <cfargument name="company_id" required="yes" type="string">
            <cfif Len(Get_Invoice_Query.consumer_id)>
                <cfquery name="Get_Member_Info_Query" datasource="#dsn#">
                    SELECT
                        'CONSUMER' TYPE,                        
                        CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
                        MEMBER_CODE,
                        TAX_OFFICE MEMBER_TAXOFFICE,
                        TAX_NO MEMBER_TAXNO,
                        CONSUMER_WORKTELCODE,
                        CONSUMER_WORKTEL,
                        CONSUMER_FAXCODE,
                        CONSUMER_FAX,
                        MOBIL_CODE,
                        MOBILTEL,
                        TAX_ADRESS MEMBER_ADDRESS,
                        TAX_COUNTY_ID,
                        TAX_CITY_ID, 
                        TAX_COUNTRY_ID,
                        TAX_POSTCODE MEMBER_POSTCODE,
                        ISNULL(C.MOBIL_CODE,'')+C.MOBILTEL MOBILTEL,
                        SC.CITY_NAME,
                        SCO.COUNTY_NAME,
                        SD.DISTRICT_NAME
                    FROM
                        CONSUMER
                            LEFT JOIN SETUP_CITY SC ON CONSUMER.TAX_CITY_ID = SC.CITY_ID
                            LEFT JOIN SETUP_COUNTY SCO ON CONSUMER.TAX_COUNTY_ID = SCO.COUNTY_ID
                            LEFT JOIN SETUP_DISTRICT SD ON CONSUMER.TAX_DISTRICT_ID = SD.DISTRICT_ID
                    WHERE
                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                     </cfquery>
                    <cfreturn Get_Member_Info_Query>
                <cfelse>
                    <cfquery name="Get_Member_Info_Query" datasource="#dsn#">
                   SELECT 
                        'COMPANY' TYPE, 
                        FULLNAME MEMBER_NAME, 
                        MEMBER_CODE, 
                        TAXOFFICE MEMBER_TAXOFFICE, 
                        TAXNO MEMBER_TAXNO, 
                        COMPANY_TELCODE, 
                        COMPANY_TEL1, 
                        COMPANY_FAX_CODE, 
                        COMPANY_FAX, 
                        MOBIL_CODE, 
                        MOBILTEL, 
                        COMPANY_ADDRESS MEMBER_ADDRESS, 
                        COUNTY, 
                        SC.CITY_NAME, 
                        COUNTRY, 
                        COMPANY_POSTCODE MEMBER_POSTCODE
                    FROM 
                        COMPANY 
                            LEFT JOIN SETUP_CITY SC ON COMPANY.CITY= SC.CITY_ID 
                            LEFT JOIN SETUP_COUNTY SCO ON COMPANY.COUNTY = SCO.COUNTY_ID 
                            LEFT JOIN SETUP_DISTRICT SD ON COMPANY.DISTRICT_ID = SD.DISTRICT_ID 
                    WHERE 
                        COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                  </cfquery>
                <cfreturn Get_Member_Info_Query>
             </cfif>
        </cffunction>
         <cffunction name="get_invoice_ships" access="remote" returntype="any" output="yes"> 
         <cfargument name="invoice_id" required="yes" type="numeric">
         <cfargument name="company_id" required="yes" type="string"> 
			<!---  Irsaliyeler varsa  --->
                <cfquery name="Get_Invoice_Ships_Query" datasource="#dsn2#">
                    SELECT 
                        ISH.SHIP_ID,
                        ISH.SHIP_NUMBER,
                        S.SHIP_NUMBER,
                        S.DELIVER_DATE
                    FROM 
                        INVOICE I,
                        INVOICE_SHIPS ISH,
                        SHIP S
                    WHERE
                        I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND
                        I.INVOICE_ID = ISH.INVOICE_ID AND
                        ISH.SHIP_ID = S.SHIP_ID
                </cfquery><cfreturn Get_Invoice_Ships_Query>
            <cfif Get_Invoice_Ships_Query.recordcount>
                <cfset ship_list = valuelist(Get_Invoice_Ships_Query.ship_id)>
                <cfset ship_list2 = valuelist(Get_Invoice_Ships_Query.ship_number)>
                        <cfquery name="Get_Sale_Ship_Query" datasource="#dsn2#">
                            SELECT 
                            	SHIP_DATE,
                                SHIP_NUMBER,
                                DELIVER_DATE 
                            FROM 
                            	SHIP 
                            WHERE 
                            	SHIP_ID IN (#ship_list#)
                        </cfquery>
						<cfset fiili_sevk_trh = valuelist(Get_Invoice_Ships_Query.DELIVER_DATE)>
                    <cfreturn Get_Sale_Ship_Query>
				</cfif>
           	</cffunction>
            <cffunction name="get_invoice_money" access="public" returntype="query" output="yes">
             <!--- Kur Bilgisi --->
                    <cfquery name="Get_Invoice_Money_Query" datasource="#dsn2#">
                        SELECT 
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            IS_SELECTED 
                        FROM 
                            INVOICE_MONEY 
                        WHERE 
                            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> 
                            AND IS_SELECTED = 1
                    </cfquery>
                <cfreturn Get_Invoice_Money_Query>
            </cffunction>
            <!--- Kurumsal Üyeye Ait Bilgileri Getirir --->
            <cffunction name="get_partner_" access="public" returntype="query" output="yes">
                    <cfquery name="Get_Partner_Query" datasource="#DSN#">
                        SELECT 
                            CP.PARTNER_ID,
                            CP.COMPANY_PARTNER_NAME,
                            CP.COMPANY_PARTNER_SURNAME,
                            CP.TC_IDENTITY
                        FROM
                            COMPANY_PARTNER CP, 
                            COMPANY C
                        WHERE 
                            CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                            CP.COMPANY_ID = C.COMPANY_ID AND
                            COMPANY_PARTNER_STATUS = 1
                        ORDER BY 
                            CP.COMPANY_PARTNER_NAME
                    </cfquery> 
            	<cfreturn Get_Partner_Query>
            </cffunction>
</cfcomponent>
