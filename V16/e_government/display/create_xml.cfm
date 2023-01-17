<!---
    File: create_xml_earchive.cfm
    Folder: e_government\display
    Author:
    Date:
    Description:
        E-fatura xml verisi oluşturma
    History:
        26.02.2014 ?? Odeme yontemi ve Kredi Karti Odeme yontemi ile ilgili degisiklik yapildi. PaymentMeansCode degerinin dolu gelmesi saglandi.
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        03.12.2019 Gramoni-Mahmut Çifçi - BSMV ve OIV gönderimi için gerekli düzenleme yapıldı
        13.04.21 farklı session değerleriyle kayıt atılacağız için tüm ep değerleri session base e çevirildi
    To Do:

--->

<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
<cfelseif isdefined("session.wp")>
    <cfset session_base = evaluate('session.wp')>
</cfif>

<cfsetting showdebugoutput="false" />

<!--- Gönderilmiş faturalari getiriyor --->
<cfscript>
    xml_error_codes         = ArrayNew(1);
	get_our_company_tmp     = createObject("component","V16.e_government.cfc.einvoice");
	get_our_company_tmp.dsn = dsn;
	get_our_company_tmp.dsn2= dsn2;
	chk_send_inv_all        = get_our_company_tmp.chk_send_inv_all_fnc(attributes.action_id,attributes.action_type);
</cfscript> 

<cfquery name="CHK_SEND_INV" dbtype="query">
    SELECT EINVOICE_ID FROM CHK_SEND_INV_ALL WHERE STATUS_CODE = '1'
</cfquery>

<cfif chk_send_inv.recordcount>
	<cfif isdefined('attributes.resend')><!--- ING tekrar gonderim bu parametre ile geliyor BK 20140120 --->
        <cfquery name="CHK_SEND_INV2" datasource="#DSN2#">
            SELECT RELATION_ID,INTEGRATION_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> AND STATUS <> 0
        </cfquery>
        <cfif chk_send_inv2.recordcount>
        	<cfset ArrayAppend(xml_error_codes, "#chk_send_inv.einvoice_id# Fatura Daha Önceden Başarılı Bir Şekilde Kaydedilmiş !")>
        </cfif>
    <cfelse>
		<cfset ArrayAppend(xml_error_codes,"#chk_send_inv.einvoice_id# Fatura Daha Önceden Başarılı Bir Şekilde Kaydedilmiş !")>
    </cfif>
</cfif>

<cfscript>
    get_our_company = get_our_company_tmp.get_our_company_fnc(company_id:session_base.company_id);

    //Microsoft/DCE standard for GUIDs that require a 8-4-4-4-12
    uuidLibObj = createobject("java", "java.util.UUID");
    GUIDStr = uuidLibObj.randomUUID().toString();
    
    attributes.invoice_id = attributes.action_id;
    get_comp_info = get_our_company_tmp.get_comp_info_fnc(company_id:session_base.company_id);
</cfscript>

<cfquery name="GET_SEND_DETAIL_XML" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="add_options.popup_send_detail">
</cfquery>
<cfset xml_einvoice_date_restriction = 1>
<cfif get_send_detail_xml.recordcount>
	<cfoutput query="get_send_detail_xml">
    	<cfif get_send_detail_xml.property_name eq 'xml_control_inv_date'>
        	<cfif get_send_detail_xml.property_value eq 1>
				<cfset xml_control_inv_date = 1>
			<cfelse>
				<cfset xml_control_inv_date = 0>
			</cfif>
       	<cfelseif get_send_detail_xml.property_name eq 'xml_get_unit2'>
        	<cfif get_send_detail_xml.property_value eq 1>
				<cfset xml_get_unit2 = 1>
			<cfelse>
				<cfset xml_get_unit2 = 0>
			</cfif>
       	<cfelseif get_send_detail_xml.property_name eq 'xml_einvoice_date_restriction'>
        	<cfif get_send_detail_xml.property_value eq 1>
				<cfset xml_einvoice_date_restriction = 1>
			<cfelse>
				<cfset xml_einvoice_date_restriction = 0>
			</cfif>
      	</cfif>
	</cfoutput>
</cfif>

<cfif attributes.action_type is 'INVOICE'>
	<cfquery name="GET_INV" datasource="#DSN2#">
    	SELECT COMPANY_ID, CONSUMER_ID, IS_IPTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> 
    </cfquery>
    <cfquery name="GET_INVOICE_OTHER_MONEY" datasource="#DSN2#">
        SELECT 
            I.OTHER_MONEY
        FROM
            INVOICE I
                LEFT JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
        WHERE
            I.OTHER_MONEY <> IR.OTHER_MONEY AND
            I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
    </cfquery>
    <cfif get_inv.is_iptal eq 1>
    	<cfset ArrayAppend(xml_error_codes,"İptal edilmiş olan bir faturayı E-Fatura olarak Gönderemezsiniz!")>
    </cfif>
<cfelse>
	<cfquery name="GET_INV" datasource="#DSN2#">
    	SELECT CH_COMPANY_ID COMPANY_ID, CH_CONSUMER_ID CONSUMER_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> 
    </cfquery>
	<cfquery name="GET_INVOICE_OTHER_MONEY" datasource="#DSN2#">
        SELECT 
            I.OTHER_MONEY
        FROM 
            EXPENSE_ITEM_PLANS I 
                LEFT JOIN EXPENSE_ITEMS_ROWS IR ON I.EXPENSE_ID = IR.EXPENSE_ID
        WHERE 
            I.OTHER_MONEY <> IR.MONEY_CURRENCY_ID AND
            I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
    </cfquery>     
</cfif>

<!--- kayit gelirse TRL fatura, kayit yoksa dovizli(INVOICE--OTHER_MONEY alani) olacak --->
<cfif get_invoice_other_money.recordcount>
	<cfset temp_currency_code = 1>
<cfelse>
	<cfset temp_currency_code = 0>
</cfif>
   
<cfif attributes.action_type is 'INVOICE'>
	<cfscript>
        get_invoice_tmp= createObject("component","V16.e_government.cfc.einvoice");
        get_invoice_tmp.dsn2 = dsn2;
        get_invoice_tmp.dsn_alias = dsn_alias;
        get_invoice_tmp.dsn3_alias = dsn3_alias;
        if (len (get_inv.company_id))
            get_invoice = get_invoice_tmp.get_invoice_fnc(action_id:attributes.action_id,action_type: 'INVOICE',company_id:get_inv.company_id,temp_currency_code:temp_currency_code);
        else if (len(get_inv.consumer_id))
            get_invoice = get_invoice_tmp.get_invoice_fnc(action_id:attributes.action_id,action_type: 'INVOICE',consumer_id:get_inv.consumer_id,temp_currency_code:temp_currency_code);
    </cfscript>

    <cfif get_invoice.IS_CIVIL eq 1 and listfind('KAMU',get_invoice.profile_id) and len(get_invoice.company_id)>
        <cfquery name = "get_payment_company_info" datasource = "#dsn#">
            SELECT
                C.TAXNO,
                C.FULLNAME,
                C.TAXOFFICE,
                SCI.CITY_NAME,
                SCO.COUNTRY_NAME,
                SC.COUNTY_NAME
            FROM
                #dsn#.COMPANY C
                LEFT JOIN #dsn#.SETUP_CITY SCI ON SCI.CITY_ID = C.CITY 
                LEFT JOIN #dsn#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = C.COUNTRY
                LEFT JOIN #dsn#.SETUP_COUNTY SC ON SC.COUNTY_ID = C.COUNTY
            WHERE
                C.COMPANY_ID = <cfif len(get_invoice.payment_company_id)>#get_invoice.payment_company_id#<cfelse>#get_invoice.company_id#</cfif>
        </cfquery>
    </cfif>

	<cfquery name="GET_RELATED_ORDER_1" datasource="#DSN2#">
        SELECT DISTINCT
			O.ORDER_NUMBER,
			O.ORDER_HEAD,
			O.ORDER_DATE,
			O.ORDER_ID,
            O.REF_NO
		FROM
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDERS_INVOICE OI
		WHERE
			O.ORDER_ID = OI.ORDER_ID AND 
            OI.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND 
            OI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
        UNION ALL
        SELECT DISTINCT
			O.ORDER_NUMBER,
			O.ORDER_HEAD,
			O.ORDER_DATE,
			O.ORDER_ID,
            O.REF_NO
		FROM
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDERS_SHIP OI,
			INVOICE_SHIPS ISS
		WHERE
			O.ORDER_ID = OI.ORDER_ID AND
            ISS.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
            ISS.SHIP_ID = OI.SHIP_ID AND
            OI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
	</cfquery>
   	<cfquery name="GET_RELATED_ORDER" dbtype="query">
    	SELECT
        	DISTINCT
			ORDER_NUMBER,
			ORDER_DATE,
			ORDER_ID,
            REF_NO
        FROM
        	GET_RELATED_ORDER_1
         ORDER BY
         	ORDER_DATE
    </cfquery>

    <cfquery name="GET_PERIOD_INVOICE" datasource="#DSN#" maxrows="2">
    	SELECT
        	PERIOD_YEAR,
            PERIOD_ID
        FROM
        	SETUP_PERIOD 
       	WHERE
        	OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND 
            PERIOD_YEAR <= <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_year#">  
        ORDER BY
        	PERIOD_YEAR DESC
    </cfquery>

	<cfquery name="GET_RELATED_SHIP" datasource="#DSN2#">
        <cfloop from="1" to="#get_period_invoice.recordcount#" index="i">
            SELECT DISTINCT
                S.SHIP_NUMBER,
                S.SHIP_ID,
                S.SHIP_DATE
            FROM
                #dsn#_#get_period_invoice.period_year[i]#_#session_base.company_id#.SHIP S,
                INVOICE_SHIPS ISS
            WHERE
                S.SHIP_ID = ISS.SHIP_ID AND 
                ISS.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND 
                S.IS_WITH_SHIP = 0 AND
                ISS.SHIP_PERIOD_ID = #get_period_invoice.period_id[i]#
           	<cfif i neq get_period_invoice.recordcount>
                UNION ALL
            </cfif>
        </cfloop>
	</cfquery>

    <!--- 1-OTV, 2-KDV, 3-Tevkifat, 4-Urun Detayı Ozel Vergi Secimi, 5-Stopaj, 6-BSMV, 7-OIV --->
	<cfquery name="GET_INVOICE_KDV" datasource="#dsn2#">
  		SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			SUM(TAXTOTAL) TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT
                1 TYPE,
            <cfif temp_currency_code>
                SUM(IR.NETTOTAL) NETTOTAL,
                ROUND(SUM(IR.OTVTOTAL),2) TAXTOTAL,
            <cfelse>
                SUM(IR.NETTOTAL/IM.RATE2) NETTOTAL,
                ROUND(SUM(IR.OTVTOTAL/IM.RATE2),2) TAXTOTAL,
            </cfif>                
                SO.TAX_CODE_NAME,
                SO.TAX_CODE,
                CASE WHEN SO.TAX_TYPE = 1 THEN 0 ELSE IR.OTV_ORAN END AS TAX
            FROM 
                INVOICE_ROW IR
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3_alias#.SETUP_OTV SO
            WHERE
                SO.TAX = IR.OTV_ORAN AND
                SO.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                IR.OTVTOTAL != 0
            GROUP BY
                IR.OTV_ORAN,
                SO.TAX_CODE_NAME,
                SO.TAX_CODE,
                SO.TAX_TYPE,
                IR.OTHER_MONEY
		)T1
		GROUP BY
			TYPE,
			TAX,
			TAX_CODE_NAME,
			TAX_CODE,
            TAXTOTAL
        UNION
        SELECT
            TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
            (CASE WHEN( SUM(NETTOTAL) = 0) THEN  
                SUM(TAXTOTAL) 
            ELSE 
                (SUM(TAXTOTAL) * (100-(( AVG(SA_DISCOUNT)/SUM(NETTOTAL) ) * 100))) / 100  
            END) AS TAX_AMOUNT,
			TAX
		FROM  
		(
			SELECT 
				2 TYPE, 
			<cfif temp_currency_code>
                IR.NETTOTAL NETTOTAL,
 				CASE WHEN(IR.NETTOTAL = 0) THEN
                    IR.TAXTOTAL
                ELSE
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)
                END AS TAXTOTAL,                
            <cfelse>
                (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    (IR.TAXTOTAL/IM.RATE2)
                ELSE
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)/IM.RATE2
                END AS TAXTOTAL,                
            </cfif>               
				ST.TAX_CODE_NAME,
				ST.TAX_CODE,
				IR.TAX,
                I.SA_DISCOUNT
			FROM 
				INVOICE_ROW IR 
					LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
				SETUP_TAX ST,
				INVOICE I
			WHERE 
				IR.TAX = ST.TAX AND 
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND 
                I.INVOICE_ID = IR.INVOICE_ID AND 
                PP.TAX_CODE IS NULL 
		)T1
		GROUP BY 
			TYPE,
			TAX,
			TAX_CODE_NAME,
			TAX_CODE
		UNION
		SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAXTOTAL TAX_AMOUNT,
			TAX
		FROM
		(
			SELECT DISTINCT
				3 TYPE,
                <cfif temp_currency_code>
				IR.NETTOTAL,
                IT.TEVKIFAT_TUTAR TAXTOTAL,
               	<cfelse>                
                (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                (IT.TEVKIFAT_TUTAR/IM.RATE2) TAXTOTAL,
                </cfif>
				ST.TEVKIFAT_CODE_NAME TAX_CODE_NAME,
				ST.TEVKIFAT_CODE TAX_CODE,
				((1-I.TEVKIFAT_ORAN)*100) TAX
			FROM
				INVOICE_ROW IR
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY
                LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">,
				#dsn3_alias#.SETUP_TEVKIFAT ST,
				INVOICE I,
				INVOICE_TAXES IT
			WHERE 
				ST.TEVKIFAT_ID = I.TEVKIFAT_ID AND
                I.INVOICE_ID = IR.INVOICE_ID AND
                I.INVOICE_ID = IT.INVOICE_ID AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                I.TEVKIFAT_ORAN != 0 AND
                PP.TAX_CODE IS NULL AND
				IT.TEVKIFAT_TUTAR <> 0 <!--- Tevkifat icin vergi kodu secilmemis ürünler cekilmeli --->
		)T1
		GROUP BY 
			TYPE,
			TAX,
			TAX_CODE_NAME,
			TAX_CODE,
            TAXTOTAL
        UNION
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT 
                4 TYPE,
                (IRR.NETTOTAL/IM.RATE2) NETTOTAL,
                PP.TAX_CODE_NAME,
                PP.TAX_CODE,
                ROUND((IR.NETTOTAL/IM.RATE2),2) TAX_AMOUNT,
                ISNULL(PP.TAX,0) TAX
            FROM 
                INVOICE_ROW IR
                LEFT JOIN INVOICE_ROW IRR ON IRR.INVOICE_ID = IR.INVOICE_ID AND IRR.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3_alias#.PRODUCT_PERIOD PP
            WHERE 
                PP.PRODUCT_ID = IR.PRODUCT_ID AND 
                PP.TAX_CODE IS NOT NULL AND
                PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
        ) T1
		GROUP BY 
			TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		UNION        
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT 
                5 TYPE,
			<cfif temp_currency_code>
                IR.NETTOTAL NETTOTAL,
            <cfelse>
               	(IR.NETTOTAL/IM.RATE2) NETTOTAL,
            </cfif>
                ST.TAX_CODE_NAME,
                ST.TAX_CODE,
                (I.STOPAJ/IM.RATE2) TAX_AMOUNT,
                I.STOPAJ_ORAN TAX 
            FROM 
                INVOICE_ROW IR
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                INVOICE I,
                #DSN2_ALIAS#.SETUP_STOPPAGE_RATES ST 
            WHERE
                ST.STOPPAGE_RATE = I.STOPAJ_ORAN AND
                I.STOPAJ_RATE_ID = ST.STOPPAGE_RATE_ID AND
                I.INVOICE_ID = IR.INVOICE_ID AND
                ISNULL(I.STOPAJ_ORAN,0) != 0 AND
                I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#" />
   		) T1
        GROUP BY
            TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
        UNION
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			SUM(TAX_AMOUNT),
			TAX
		FROM
		(
            SELECT
                6 TYPE,
			<cfif temp_currency_code>
                IR.NETTOTAL NETTOTAL,
            <cfelse>
               	(IR.NETTOTAL/IM.RATE2) NETTOTAL,
            </cfif>
                SB.TAX_CODE_NAME,
                SB.TAX_CODE,
                (IR.BSMV_AMOUNT/IM.RATE2) TAX_AMOUNT,
                IR.BSMV_RATE TAX
            FROM 
                INVOICE_ROW IR
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #DSN3_ALIAS#.SETUP_BSMV SB 
            WHERE 
                SB.TAX = IR.BSMV_RATE AND
                ISNULL(IR.BSMV_RATE,0) != 0 AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                SB.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
   		) T1
        GROUP BY
            TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX
        UNION        
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			SUM(TAX_AMOUNT),
			TAX
		FROM
		(
            SELECT
                7 TYPE,
			<cfif temp_currency_code>
                IR.NETTOTAL NETTOTAL,
            <cfelse>
               	(IR.NETTOTAL/IM.RATE2) NETTOTAL,
            </cfif>
                SOI.TAX_CODE_NAME,
                SOI.TAX_CODE,
                (IR.OIV_AMOUNT/IM.RATE2) TAX_AMOUNT,
                IR.OIV_RATE TAX
            FROM
                INVOICE_ROW IR
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #DSN3_ALIAS#.SETUP_OIV SOI
            WHERE
                SOI.TAX = IR.OIV_RATE AND
                ISNULL(IR.OIV_RATE,0) != 0 AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
   		) T1
        GROUP BY
            TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX
     </cfquery>

    <cfquery name="get_stopaj_kdv" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE = 5
    </cfquery>
    <!--- sabit kiymet faturalarında urun secimi zorunlu olmadıgı icin UNIT_CODE alanına C62 (Adet) degeri gonderildi. BK 20150727--->
	<cfquery name="GET_INVOICE_ROW" datasource="#DSN2#">
		SELECT
			IR.INVOICE_ROW_ID,
			IR.AMOUNT,
            IR.AMOUNT2,
			<cfif temp_currency_code>
			IR.NETTOTAL,
			IR.DISCOUNTTOTAL,
			IR.TAXTOTAL,
            IR.PRICE,
            <cfelse>
			(IR.NETTOTAL/IM.RATE2) NETTOTAL,
			(IR.DISCOUNTTOTAL/IM.RATE2) DISCOUNTTOTAL,
			(IR.TAXTOTAL/IM.RATE2) TAXTOTAL, 
            IR.PRICE_OTHER PRICE,           
            </cfif>
			IR.TAX,
			CASE WHEN IR.NAME_PRODUCT IS NOT NULL THEN IR.NAME_PRODUCT ELSE DESCRIPTION END AS NAME_PRODUCT,
            IR.PRODUCT_NAME2,
			ST.TAX_CODE,
			CASE 
            	WHEN (SU.UNIT_CODE IS NOT NULL OR (SU.UNIT_CODE IS NULL AND I.INVOICE_CAT <> 66)) THEN SU.UNIT_CODE
                WHEN (SU.UNIT_CODE IS NULL AND I.INVOICE_CAT = 66) THEN 'C62' 
           	END AS UNIT_CODE,       
            S.STOCK_CODE,
            S.BARCOD,
            PR.PRODUCT_CODE,
            PR.PRODUCT_CODE_2,
            PR.ORIGIN_ID,
            SEC.COUNTRY_NAME,
            SEC.COUNTRY_CODE,
            IR.DISCOUNT1,
            IR.DISCOUNT2,
            IR.DISCOUNT3,
            IR.DISCOUNT4,
            IR.DISCOUNT5,
            IR.REASON_CODE,
            IR.REASON_NAME,
            IR.DELIVERY_CONDITION,
            IR.CONTAINER_TYPE,
            IR.CONTAINER_NUMBER,
            IR.CONTAINER_QUANTITY,
            IR.DELIVERY_COUNTRY,
            IR.DELIVERY_CITY,
            IR.DELIVERY_COUNTY,
            IR.DELIVERY_TYPE,
            IR.GTIP_NUMBER,
            <cfif len(get_invoice.company_id)>
            (SELECT TOP 1 COMPANY_STOCK_CODE FROM #dsn1_alias#.SETUP_COMPANY_STOCK_CODE WHERE COMPANY_ID = ISNULL(#get_invoice.company_id#,-1) AND STOCK_ID = IR.STOCK_ID) COMPANY_STOCK_CODE,
            </cfif>
            IR.BSMV_RATE,
            IR.BSMV_AMOUNT,
            IR.BSMV_CURRENCY,
            IR.OIV_RATE,
            IR.OIV_AMOUNT,
            (PU.WEIGHT * IR.AMOUNT) AS WEIGHT
		FROM
        	INVOICE I,
			INVOICE_ROW IR
                LEFT JOIN #DSN_ALIAS#.SETUP_UNIT SU ON <cfif isdefined('xml_get_unit2') and xml_get_unit2 eq 1>IR.UNIT2 = SU.UNIT<cfelse>IR.UNIT = SU.UNIT</cfif>
                LEFT JOIN #dsn1_alias#.STOCKS S ON S.STOCK_ID = IR.STOCK_ID
                LEFT OUTER JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                LEFT JOIN #dsn3_alias#.PRODUCT PR ON PR.PRODUCT_ID = IR.PRODUCT_ID
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY
                LEFT JOIN SETUP_TAX ST ON ST.TAX = IR.TAX
                LEFT JOIN #dsn_alias#.SETUP_COUNTRY SEC ON SEC.COUNTRY_ID = PR.ORIGIN_ID
                LEFT JOIN #dsn3_alias#.PRODUCT_UNIT AS PU ON IR.PRODUCT_ID = PU.PRODUCT_ID
		WHERE
			IR.INVOICE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
            I.INVOICE_ID = IR.INVOICE_ID AND
			PP.TAX_CODE IS NULL<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
            <cfif get_invoice.INVOICE_CAT neq 66>
            AND PU.IS_MAIN = 1
            </cfif>
        ORDER BY
            IR.INVOICE_ROW_ID
	</cfquery>

	<cfquery name="GET_INVOICE_TAX_ROW" datasource="#DSN2#">
		SELECT
            TYPE,
            INVOICE_ROW_ID,
            TAX_TOTAL,
            TAX,
            REASON_CODE,
            REASON_NAME,
			TAX_CODE,
			TAX_CODE_NAME
        FROM
        (SELECT
			1 TYPE,
			IR.INVOICE_ROW_ID,
        <cfif temp_currency_code>
            IR.OTVTOTAL TAX_TOTAL,
        <cfelse>
            (IR.OTVTOTAL/IM.RATE2) TAX_TOTAL,
        </cfif>
            CASE WHEN SO.TAX_TYPE = 1 THEN 0 ELSE IR.OTV_ORAN END AS TAX,
            IR.REASON_CODE,
            IR.REASON_NAME,
			SO.TAX_CODE,
			SO.TAX_CODE_NAME
		FROM
			INVOICE_ROW IR
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
			#DSN3_ALIAS#.SETUP_OTV SO
		WHERE
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SO.TAX = IR.OTV_ORAN AND
			IR.OTV_ORAN != 0 AND
			PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
			SO.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
		UNION
		SELECT
			2 TYPE,
            IR.INVOICE_ROW_ID,
		<cfif temp_currency_code>
			CASE WHEN(IR.NETTOTAL = 0) THEN
				IR.TAXTOTAL
			ELSE
				--(((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)
				(((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)
			END AS TAXTOTAL,
        <cfelse>
			CASE WHEN(IR.NETTOTAL = 0) THEN
				(IR.TAXTOTAL/IM.RATE2)
			ELSE
				--(((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)/IM.RATE2
				(((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)/IM.RATE2
			END AS TAXTOTAL,
        </cfif>
			IR.TAX,
            IR.REASON_CODE,
            IR.REASON_NAME,            
			ST.TAX_CODE,
			ST.TAX_CODE_NAME			
		FROM 
			INVOICE_ROW IR 
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
			SETUP_TAX ST,
			INVOICE I
		WHERE 
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			IR.INVOICE_ID = I.INVOICE_ID AND
			ST.TAX = IR.TAX AND
			PP.TAX_CODE IS NULL<!--- İçerisinde vergi kodu seçilmemiş ürünler geliyor --->
		UNION 
        SELECT
			3 TYPE,
  			IR.INVOICE_ROW_ID,
			(IR.NETTOTAL/IM.RATE2) TAXTOTAL,
			0 TAX,
            IR.REASON_CODE,
            IR.REASON_NAME,             
			PP.TAX_CODE,
			PP.TAX_CODE_NAME
		FROM 
			INVOICE_ROW IR
            	LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
			#dsn3_alias#.PRODUCT_PERIOD PP
		WHERE 
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			PP.PRODUCT_ID = IR.PRODUCT_ID AND 
			PP.TAX_CODE IS NOT NULL AND
            PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
        UNION
        SELECT
			6 TYPE,
			IR.INVOICE_ROW_ID,
        <cfif temp_currency_code>
            IR.BSMV_AMOUNT TAX_TOTAL,
        <cfelse>
            (IR.BSMV_AMOUNT/IM.RATE2) TAX_TOTAL,
        </cfif>
        	IR.BSMV_RATE TAX,
            IR.REASON_CODE,
            IR.REASON_NAME,
			SB.TAX_CODE,
			SB.TAX_CODE_NAME
		FROM
			INVOICE_ROW IR
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
			#DSN3_ALIAS#.SETUP_BSMV SB
		WHERE
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SB.TAX = IR.BSMV_RATE AND
			IR.BSMV_RATE != 0 AND
			PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
            SB.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
        UNION
        SELECT
			7 TYPE,
			IR.INVOICE_ROW_ID,
        <cfif temp_currency_code>
            IR.OIV_AMOUNT TAX_TOTAL,
        <cfelse>
            (IR.OIV_AMOUNT/IM.RATE2) TAX_TOTAL,
        </cfif>
        	IR.OIV_RATE TAX,
            IR.REASON_CODE,
            IR.REASON_NAME,
			SOI.TAX_CODE,
			SOI.TAX_CODE_NAME
		FROM
			INVOICE_ROW IR
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
			#DSN3_ALIAS#.SETUP_OIV SOI
		WHERE
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SOI.TAX = IR.OIV_RATE AND
			IR.OIV_RATE != 0 AND
			PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
			SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">) TAX_QUERY
        ORDER BY
            REASON_CODE
    </cfquery>
    
    <cfif isdefined("get_invoice.BANK_ID") And get_invoice.BANK_ID Gt 0>
        <cfquery name="get_owner_customer_no" datasource="#dsn2#">
            SELECT 
            ACC.ACCOUNT_NAME,
            ACC.ACCOUNT_OWNER_CUSTOMER_NO,
            BB.BANK_NAME,
            BB.BANK_BRANCH_NAME,
            BB.SWIFT_CODE,
            BB.BANK_BRANCH_ADDRESS,
            ACC.ACCOUNT_CURRENCY_ID 
            FROM #dsn3_alias#.ACCOUNTS AS ACC 
            INNER JOIN #DSN3_ALIAS#.BANK_BRANCH BB ON ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
            WHERE ACC.ACCOUNT_STATUS = 1 AND ACCOUNT_ID = #get_invoice.BANK_ID#
        </cfquery>
    </cfif>
<cfelse>
	<cfscript>
        get_invoice_tmp= createObject("component","V16.e_government.cfc.einvoice");
        get_invoice_tmp.dsn2 = dsn2;
		get_invoice_tmp.dsn_alias = dsn_alias;
		get_invoice_tmp.dsn3_alias = dsn3_alias;
		if (len (get_inv.company_id))
        	get_invoice =get_invoice_tmp.get_invoice_fnc(action_id:attributes.action_id,action_type: 'EXPENSE',company_id:get_inv.company_id,temp_currency_code:temp_currency_code);
    	else if (len(get_inv.consumer_id))
        	get_invoice = get_invoice_tmp.get_invoice_fnc(action_id:attributes.action_id,action_type: 'EXPENSE',consumer_id:get_inv.consumer_id,temp_currency_code:temp_currency_code);
    </cfscript>

	<!--- 1-OTV, 2-KDV, 3-Tevkifat, 4-Urun Detayı Ozel Vergi Secimi, 5-Stopaj, 6-BSMV, 7-OIV --->
	<cfquery name="GET_INVOICE_KDV" datasource="#dsn2#">
  		SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			SUM(TAX_AMOUNT) TAX_AMOUNT,
			TAX
		FROM
		(     
            SELECT 
                1 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND(SUM(IR.AMOUNT_OTV/IM.RATE2),2) NETTOTAL,
                SO.TAX_CODE_NAME,
                SO.TAX_CODE,
                ROUND(SUM(IR.AMOUNT_OTV/IM.RATE2),2) TAX_AMOUNT,
                CASE WHEN SO.TAX_TYPE = 1 THEN 0 ELSE IR.OTV_RATE END AS TAX
            FROM 
                EXPENSE_ITEMS_ROWS IR
                	LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
              	#DSN3_ALIAS#.SETUP_OTV SO 
            WHERE 
                SO.TAX = IR.OTV_RATE AND 
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND 
                IR.AMOUNT_OTV != 0 
            GROUP BY 
                IR.OTV_RATE,
                SO.TAX_CODE_NAME,
                SO.TAX_CODE,
                SO.TAX_TYPE,
                IR.MONEY_CURRENCY_ID
		)T1
		GROUP BY 
			TYPE,
			TAX,
			TAX_CODE_NAME,
			TAX_CODE,
            TAX_AMOUNT
       	UNION
       	SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			SUM(TAX_AMOUNT) TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT 
                2 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND(SUM(IR.AMOUNT_KDV/IM.RATE2),2) NETTOTAL,
                ST.TAX_CODE_NAME,
                ST.TAX_CODE,
                ROUND(SUM(IR.AMOUNT_KDV/IM.RATE2),2) TAX_AMOUNT,
                IR.KDV_RATE TAX
            FROM 
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID
                LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">,
                SETUP_TAX ST
            WHERE
                IR.KDV_RATE = ST.TAX AND
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                PP.TAX_CODE IS NULL
            GROUP BY
                IR.KDV_RATE,
                ST.TAX_CODE_NAME,
                ST.TAX_CODE
      	)T1
        GROUP BY
			TYPE,
			TAX,
			TAX_CODE_NAME,
			TAX_CODE
		UNION
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT
                3 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND(((SUM(IR.AMOUNT_KDV/IM.RATE2)*(1-TEVKIFAT_ORAN))),2) NETTOTAL,
                ST.TEVKIFAT_CODE_NAME AS TAX_CODE_NAME,
				ST.TEVKIFAT_CODE AS TAX_CODE,
                ROUND(((SUM(IR.AMOUNT_KDV/IM.RATE2)*(1-TEVKIFAT_ORAN))),2) TAX_AMOUNT,
                ((1-I.TEVKIFAT_ORAN)*100) TAX
            FROM 
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
               	EXPENSE_ITEM_PLANS I,
                #DSN3_ALIAS#.SETUP_TEVKIFAT ST
            WHERE
                ST.TEVKIFAT_ID = I.TEVKIFAT_ID AND
                I.EXPENSE_ID = IR.EXPENSE_ID AND
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                TEVKIFAT_ORAN != 0 
            GROUP BY
                TEVKIFAT_ORAN,
                ST.TEVKIFAT_CODE_NAME,
                ST.TEVKIFAT_CODE
		)T1
		GROUP BY
            TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		UNION
        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		FROM
		(                
            SELECT 
                4 TYPE,
                SUM(IRR.TOTAL_AMOUNT/IM.RATE2) - ROUND(SUM(IR.TOTAL_AMOUNT/IM.RATE2),2) NETTOTAL,
                PP.TAX_CODE_NAME,
                PP.TAX_CODE,
                ROUND(SUM(IR.TOTAL_AMOUNT/IM.RATE2),2) TAX_AMOUNT,
                ISNULL(PP.TAX,0) TAX
            FROM 
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID
                LEFT JOIN EXPENSE_ITEMS_ROWS IRR ON IRR.INVOICE_ID = IR.INVOICE_ID AND IRR.EXP_ITEM_ROWS_ID <> IR.EXP_ITEM_ROWS_ID,
                #dsn3_alias#.PRODUCT_PERIOD PP
            WHERE 
                PP.PRODUCT_ID = IR.PRODUCT_ID AND 
                PP.TAX_CODE IS NOT NULL AND
                PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            GROUP BY 
                PP.TAX_CODE_NAME,
                PP.TAX_CODE,
                IR.MONEY_CURRENCY_ID,
                PP.TAX
        ) T1
		GROUP BY 
			TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX

        UNION

        SELECT
			TYPE,
			SUM(NETTOTAL) NETTOTAL,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX
		FROM
		(
            SELECT
                5 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - SUM(I.STOPAJ/IM.RATE2) NETTOTAL,
                ST.TAX_CODE_NAME,
                ST.TAX_CODE,
                SUM(I.STOPAJ/IM.RATE2) TAX_AMOUNT,
                'TRY' CURRENCY_CODE,
                I.STOPAJ_ORAN TAX
            FROM
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
               	EXPENSE_ITEM_PLANS I,
                #DSN2_ALIAS#.SETUP_STOPPAGE_RATES ST
            WHERE
                ST.STOPPAGE_RATE = I.STOPAJ_ORAN AND
                I.STOPAJ_RATE_ID = ST.STOPPAGE_RATE_ID AND
                I.EXPENSE_ID = IR.EXPENSE_ID AND
                I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                ISNULL(STOPAJ_ORAN,0) != 0
            GROUP BY
                I.STOPAJ,
                I.STOPAJ_ORAN,
                ST.TAX_CODE_NAME,
                ST.TAX_CODE
   		) T1
        GROUP BY
            TYPE,
			TAX_CODE_NAME,
			TAX_CODE,
			TAX_AMOUNT,
			TAX

        UNION

        SELECT
            TYPE,
            SUM(NETTOTAL) NETTOTAL,
            TAX_CODE_NAME,
            TAX_CODE,
            TAX_AMOUNT,
            TAX
        FROM
        (
            SELECT
                6 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - SUM(IR.AMOUNT_BSMV/IM.RATE2) NETTOTAL,
                SB.TAX_CODE_NAME,
                SB.TAX_CODE,
                SUM(IR.AMOUNT_BSMV/IM.RATE2) TAX_AMOUNT,
                IR.BSMV_RATE TAX
            FROM
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
                #DSN3_ALIAS#.SETUP_BSMV SB
            WHERE
                SB.TAX = IR.BSMV_RATE AND
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                ISNULL(BSMV_RATE,0) != 0 AND
                SB.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
            GROUP BY
                SB.TAX_CODE_NAME,
                SB.TAX_CODE,
                IR.BSMV_RATE
        ) T1
        GROUP BY
            TYPE,
            TAX_CODE_NAME,
            TAX_CODE,
            TAX_AMOUNT,
            TAX

        UNION

        SELECT
            TYPE,
            SUM(NETTOTAL) NETTOTAL,
            TAX_CODE_NAME,
            TAX_CODE,
            TAX_AMOUNT,
            TAX
        FROM
        (
            SELECT
                7 TYPE,
                SUM(IR.TOTAL_AMOUNT/IM.RATE2) - SUM(IR.AMOUNT_OIV/IM.RATE2) NETTOTAL,
                SOI.TAX_CODE_NAME,
                SOI.TAX_CODE,
                SUM(IR.AMOUNT_OIV/IM.RATE2) TAX_AMOUNT,
                IR.OIV_RATE TAX
            FROM
                EXPENSE_ITEMS_ROWS IR
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
                #DSN3_ALIAS#.SETUP_OIV SOI
            WHERE
                SOI.TAX = IR.OIV_RATE AND
                IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                ISNULL(OIV_RATE,0) != 0 AND
                SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
            GROUP BY
                SOI.TAX_CODE_NAME,
                SOI.TAX_CODE,
                IR.OIV_RATE
        ) T1
        GROUP BY
            TYPE,
            TAX_CODE_NAME,
            TAX_CODE,
            TAX_AMOUNT,
            TAX
	</cfquery>
	<!--- Gelir fisi belgelerinde urun birim secimi zorunlu olmadıgı icin UNIT_CODE alanına C62 (Adet) degeri gonderildi. BK 20150727--->
	<cfquery name="GET_INVOICE_ROW" datasource="#DSN2#">
		SELECT
			IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.QUANTITY AMOUNT,
            '' AMOUNT2,
			(IR.AMOUNT/IM.RATE2) * IR.QUANTITY AS NETTOTAL,
			0 DISCOUNTTOTAL,
			(IR.AMOUNT_KDV/IM.RATE2) TAXTOTAL,
			IR.KDV_RATE TAX,
			IR.DETAIL NAME_PRODUCT,
			(IR.AMOUNT/IM.RATE2) PRICE,
			ST.TAX_CODE,            
			CASE
            	WHEN SU.UNIT_CODE IS NOT NULL
                	THEN SU.UNIT_CODE 
               	ELSE 'C62' 
           	END AS UNIT_CODE,            
            '' STOCK_CODE,
            '' PRODUCT_NAME2,
            REASON_CODE,
            REASON_NAME,
            IR.BSMV_RATE,
            IR.BSMV_CURRENCY,
            IR.AMOUNT_BSMV AS BSMV_AMOUNT,
            IR.OIV_RATE,
            IR.AMOUNT_OIV AS OIV_AMOUNT,
            '' AS ORIGIN_ID,
            '' AS GTIP_NUMBER,
			'' AS COMPANY_STOCK_CODE
		FROM 
			EXPENSE_ITEMS_ROWS IR 
           		LEFT JOIN #dsn_alias#.SETUP_UNIT SU ON IR.UNIT = SU.UNIT
            	LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID
                LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			SETUP_TAX ST
		WHERE 
			IR.EXPENSE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			ST.TAX = IR.KDV_RATE AND
			PP.TAX_CODE IS NULL
        ORDER BY
            IR.EXP_ITEM_ROWS_ID
	</cfquery>
        
	<cfquery name="GET_INVOICE_TAX_ROW" datasource="#dsn2#">
		SELECT
            TYPE,
            INVOICE_ROW_ID,
            TAX_TOTAL,
            TAX,
            REASON_CODE,
            REASON_NAME,
			TAX_CODE,
			TAX_CODE_NAME
        FROM
        (SELECT
			1 TYPE,
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.AMOUNT_OTV TAX_TOTAL,
			CASE WHEN SO.TAX_TYPE = 1 THEN 0 ELSE IR.OTV_RATE END AS TAX,
            REASON_CODE,
            REASON_NAME,
			SO.TAX_CODE,
			SO.TAX_CODE_NAME
		FROM 
			EXPENSE_ITEMS_ROWS IR 
            	LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			#DSN3_ALIAS#.SETUP_OTV SO
		WHERE 
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SO.TAX = IR.OTV_RATE AND
			IR.OTV_RATE != 0 AND
			PP.TAX_CODE IS NULL
		UNION 
		SELECT
			2 TYPE, 
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.AMOUNT_KDV TAXTOTAL,
			IR.KDV_RATE TAX,
            REASON_CODE,
            REASON_NAME,                        
			ST.TAX_CODE,
			ST.TAX_CODE_NAME			
		FROM 
			EXPENSE_ITEMS_ROWS IR LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			SETUP_TAX ST
		WHERE 
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			ST.TAX = IR.KDV_RATE AND
			PP.TAX_CODE IS NULL
		UNION 
		SELECT
			3 TYPE, 
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.TOTAL_AMOUNT TAXTOTAL,
			0 TAX,
            REASON_CODE,
            REASON_NAME,                        
			PP.TAX_CODE,
			PP.TAX_CODE_NAME
		FROM 
			EXPENSE_ITEMS_ROWS IR,
			EXPENSE_ITEMS PP
		WHERE 
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			PP.EXPENSE_ITEM_ID = IR.EXPENSE_ITEM_ID AND 
			PP.TAX_CODE IS NOT NULL
        UNION
        SELECT
			6 TYPE,
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.AMOUNT_BSMV TAX_TOTAL,
			IR.BSMV_RATE TAX,
            REASON_CODE,
            REASON_NAME,
			SB.TAX_CODE,
			SB.TAX_CODE_NAME
		FROM 
			EXPENSE_ITEMS_ROWS IR 
            	LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			#DSN3_ALIAS#.SETUP_BSMV SB
		WHERE
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SB.TAX = IR.BSMV_RATE AND
			IR.BSMV_RATE != 0 AND
			PP.TAX_CODE IS NULL AND
            SB.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
        UNION
        SELECT
			7 TYPE,
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.AMOUNT_OIV TAX_TOTAL,
			IR.OIV_RATE TAX,
            REASON_CODE,
            REASON_NAME,
			SOI.TAX_CODE,
			SOI.TAX_CODE_NAME
		FROM 
			EXPENSE_ITEMS_ROWS IR 
            	LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			#DSN3_ALIAS#.SETUP_OIV SOI
		WHERE
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SOI.TAX = IR.OIV_RATE AND
			IR.OIV_RATE != 0 AND
			PP.TAX_CODE IS NULL AND
            SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />) TAX_QUERY
        ORDER BY
            REASON_CODE
	</cfquery>
    
    <cfquery name="get_stopaj_kdv" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE = 5
    </cfquery>

    <cfif isdefined("get_invoice.BANK_ID") And get_invoice.BANK_ID Gt 0>
        <cfquery name="get_owner_customer_no" datasource="#dsn2#">
            SELECT 
            ACC.ACCOUNT_NAME,
            ACC.ACCOUNT_OWNER_CUSTOMER_NO,
            BB.BANK_NAME,
            BB.BANK_BRANCH_NAME,
            BB.SWIFT_CODE,
            BB.BANK_BRANCH_ADDRESS,
            ACC.ACCOUNT_CURRENCY_ID 
            FROM #dsn3_alias#.ACCOUNTS AS ACC 
            INNER JOIN #DSN3_ALIAS#.BANK_BRANCH BB ON ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
            WHERE ACC.ACCOUNT_STATUS = 1 AND ACCOUNT_ID = #get_invoice.BANK_ID#
        </cfquery>
    </cfif>
</cfif>

<cfquery name="get_bank_accounts" datasource="#dsn2#">
    SELECT
        ACC.ACCOUNT_NAME,
        ACC.ACCOUNT_OWNER_CUSTOMER_NO AS IBAN,
        BB.BANK_NAME,
        BB.BANK_BRANCH_NAME,
        BB.SWIFT_CODE,
        BB.BANK_BRANCH_ADDRESS,
        ACC.ACCOUNT_CURRENCY_ID
    FROM
        #DSN3_ALIAS#.ACCOUNTS AS ACC
        INNER JOIN #DSN3_ALIAS#.BANK_BRANCH BB ON ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
    WHERE
        ACC.ACCOUNT_STATUS = 1
        AND ACC.IS_INTERNET = 1
        AND ACC.ACCOUNT_CURRENCY_ID = '#get_invoice.money#'
</cfquery>
<cfset CUSTOMER_NO  = '' />
<cfif Len(GET_INVOICE.COMPANY_ID)>
<cfquery name="get_company_period" datasource="#dsn2#">
    SELECT ACC.ACCOUNT_CODE FROM #DSN_ALIAS#.COMPANY_PERIOD AS ACC WHERE COMPANY_ID = #GET_INVOICE.COMPANY_ID# AND PERIOD_ID = #session_base.period_id#
</cfquery>
<cfset CUSTOMER_NO  = Trim(ListLast(get_company_period.ACCOUNT_CODE,'.')) />
</cfif>

<cfset mynumber = wrk_round(get_invoice.nettotal) />
<cfset mynumber1 = wrk_round(get_invoice.nettotal) /><!--- AdditionalDocumentReference için eklendi mcifci 05.12.2019 --->

<cfif datediff('d',createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),get_invoice.invoice_date) gt 0><!--- defaultta fatura tarihi bugünden sonra olamaz --->
	<cfset ArrayAppend(xml_error_codes, 'Fatura Tarihi Bugünden Sonra Olamaz. Lütfen Fatura Tarihinizi Kontrol ediniz.')>
</cfif>

<cfset get_prefix = get_our_company_tmp.get_prefix_fnc(company_id:session_base.company_id, type:1) />

<!---
	7 günlük süreden sonra düzenlenen faturalar
	hiç düzenlenmemiş sayılarak fatura tutarının
	%10 oranında özel usulsüzlük cezası kesilir.
	Edevlet tanımlarında çoklu seri tanımlı ise
	ve çoklu seri bilgileri girilmiş ise
	bazı durumlarda bu ceza göz önünde bulundurularak
	7 gün öncesine fatura kesilebilir.
	Mahmut Çifçi <mahmut.cifci@gramoni.com> 22.01.2021 --->
<cfif
	not isdefined('attributes.resend') and
	datediff('d',createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),get_invoice.invoice_date) lt -7 and
	xml_einvoice_date_restriction eq 1 And
	Not (Len(get_our_company.IS_MULTIPLE_PREFIX) And get_our_company.IS_MULTIPLE_PREFIX Eq 1 And get_prefix.recordcount Eq 2)><!--- defaultta fatura tarihi 7 gün önce olamaz --->
	<cfset ArrayAppend(xml_error_codes, '7 Gün Öncesine Fatura Gönderemezsiniz. Lütfen Fatura Tarihinizi Kontrol Ediniz.')>
</cfif>
<cfif not isdefined('attributes.resend') and isdefined('xml_control_inv_date') and xml_control_inv_date eq 1 and datediff('d',createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),get_invoice.invoice_date) lt 0><!--- xml de seçiliyse fatura tarihi bugünden önce olamaz --->
	<cfset ArrayAppend(xml_error_codes,'Fatura Tarihi Bugünden Önce Olamaz. Lütfen Fatura Tarihinizi Kontrol ediniz.')>
</cfif>

<cfset temp_InvoiceTypeCode = get_invoice.invoice_type_code />
<cfset temp_tax_amount = 0 />

<cfquery name="get_tevkifat_kdv" dbtype="query">
	SELECT * FROM GET_INVOICE_KDV WHERE TYPE = 3
</cfquery>

<cfif isdefined('get_tevkifat_kdv') and get_tevkifat_kdv.recordcount>
    <cfif temp_InvoiceTypeCode neq 'IADE'> 
	    <cfset temp_InvoiceTypeCode = 'TEVKIFAT'>
    </cfif>
    <cfset temp_tax_amount = temp_tax_amount+get_tevkifat_kdv.tax_amount>
</cfif>

<cfif isdefined('get_stopaj_kdv') and get_stopaj_kdv.recordcount>
	<cfset temp_tax_amount = temp_tax_amount+get_stopaj_kdv.tax_amount>
</cfif>
<!--- 20190717 --->
<cfif ( isdefined("get_invoice.is_export_registered") and get_invoice.is_export_registered eq 1 ) Or ( isDefined("get_invoice.is_export_product") and get_invoice.is_export_product Eq 1 ) >
    <cfquery name="GET_REASON_CODE" dbtype="query">
        SELECT REASON_CODE FROM GET_INVOICE_ROW WHERE REASON_CODE NOT IN (701,702,703)
    </cfquery>
    <cfquery name="GET_KDV_TAX" dbtype="query">
        SELECT TAX FROM GET_INVOICE_ROW WHERE TAX = 0
    </cfquery>
    <cfif GET_REASON_CODE.recordcount>
        <cfset ArrayAppend(xml_error_codes,'İstisna Nedeni alanından ilgili İhraç Kaydı nedenini seçiniz!')>
    </cfif>
    <cfif GET_KDV_TAX.recordcount>
        <cfset ArrayAppend(xml_error_codes,'İhraç Kayıtlı Fatura da KDV Değeri 0 olamaz!')>
    </cfif>
    <cfset temp_InvoiceTypeCode = 'IHRACKAYITLI'>
</cfif>
<!--- /20190717 --->

<!--- Fatura not alanında istisna nedenlerini göstermek için eklendi Gramoni-Mahmut 18.01.2020 --->
<cfquery name="GET_INVOICE_TAX_REASON_CODE" dbtype="query">
    SELECT REASON_CODE, REASON_NAME FROM GET_INVOICE_TAX_ROW WHERE TAX = 0 GROUP BY REASON_CODE, REASON_NAME
</cfquery>

<!--- Istisna Kurguları BK 20160219 --->
<cfif get_invoice.invoice_type_code neq 'IADE'>
    <cfquery name="GET_INVOICE_TAX_ROW_CONTROL" dbtype="query">
        SELECT TAX FROM GET_INVOICE_TAX_ROW WHERE TAX = 0 AND REASON_CODE <> 351 AND TYPE <> 1
    </cfquery>
    <cfquery name="GET_INVOICE_TAX_ROW_CONTROL2" dbtype="query">
        SELECT CAST(TAX AS VARCHAR) TAX FROM GET_INVOICE_TAX_ROW WHERE TAX_TOTAL = 0
    </cfquery>
    
    <cfset list_ReasonTax = valuelist(get_invoice_tax_row_control2.tax)>

    <cfif get_invoice_tax_row_control.recordcount>
        <cfset temp_InvoiceTypeCode = 'ISTISNA'>
        <cfquery name="GET_INVOICE_TAX_ROW_CONTROL3" dbtype="query">
            SELECT TAX FROM GET_INVOICE_TAX_ROW WHERE TAX = 0 AND (REASON_CODE IS NULL OR REASON_NAME IS NULL)
        </cfquery>
        <cfif get_invoice_tax_row_control3.recordcount>
            <cfset ArrayAppend(xml_error_codes,'Belge Detayında KDV Değeri 0 olan satırlar için İstisna Nedeni Seçiniz ! ')>
        </cfif>	
        <cfquery name="GET_INVOICE_TAX_ROW_CONTROL4" dbtype="query">
            SELECT TAX FROM GET_INVOICE_TAX_ROW WHERE TAX <> 0 AND TYPE NOT IN(1,6,7)
        </cfquery>
        <cfif get_invoice_tax_row_control4.recordcount>
            <cfset ArrayAppend(xml_error_codes,'ISTISNA faturalarında satırdaki ürünlerin KDV Değeri 0 olmalıdır ! ')>
        </cfif>	 
        <cfquery name="GET_INVOICE_ROW_CONTROL2" dbtype="query">
            SELECT TAX FROM GET_INVOICE_ROW WHERE TAX = 0 AND REASON_CODE = '351'
        </cfquery> 
        <cfif get_invoice_row_control2.recordcount>
            <cfset ArrayAppend(xml_error_codes,"ISTISNA faturalarında İstisna Nedeni 'İstisna Olmayan Diğer' olmamalıdır ! ")>
        </cfif>      
    <cfelse>
        <!--- İstisna Olmayan Diger Kontrolu --->
        <cfquery name="GET_INVOICE_ROW_CONTROL" dbtype="query">
            SELECT TAX FROM GET_INVOICE_ROW WHERE TAXTOTAL = 0 AND REASON_CODE <> '351'
        </cfquery>
        <cfif get_invoice_row_control.recordcount>
            <cfset ArrayAppend(xml_error_codes,"KDV Tutarı 0 olan belge satırı için İstisna Nedeni olarak 'İstisna Olmayan Diğer' seçiniz ! ")>
        </cfif>
    </cfif>
<cfelse>
    <cfquery name="GET_INVOICE_ROW_CONTROL5" dbtype="query">
        SELECT TAX FROM GET_INVOICE_ROW WHERE REASON_CODE IS NOT NULL OR REASON_NAME IS NOT NULL
    </cfquery>
	<cfif get_invoice_row_control5.recordcount>
		<cfset ArrayAppend(xml_error_codes,"Fatura Tipi 'IADE' olan belgelerde İstisna Nedeni Seçmeyiniz ! ")>
    </cfif>       
</cfif>

<cfquery name="GET_ROW_TAX" dbtype="query">
	SELECT SUM(TAX_AMOUNT) TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE = 4
</cfquery>
<cfif not get_row_tax.recordcount>
	<cfset row_tax_amount_ = 0>
<cfelse>
	<cfset row_tax_amount_ = get_row_tax.tax_amount>
</cfif>
<cfquery name="GET_TAXAMOUNT" dbtype="query">
	SELECT SUM(TAX_AMOUNT) TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE != 3
</cfquery>

<cfscript>
    if (get_taxamount.recordcount) {
        LmtTaxInclAmo   = get_invoice.grosstotal-row_tax_amount_-get_invoice.sa_discount-get_invoice.row_discount+get_taxamount.tax_amount;
    }
    else {
        LmtTaxInclAmo   = get_invoice.grosstotal-row_tax_amount_-get_invoice.sa_discount-get_invoice.row_discount;
    }

    LegalMonetaryTotal                      = structNew();
    LegalMonetaryTotal.LineExtensionAmount  = get_invoice.grosstotal-row_tax_amount_;
    LegalMonetaryTotal.TaxExclusiveAmount   = get_invoice.grosstotal-row_tax_amount_-(get_invoice.sa_discount+get_invoice.row_discount);
    if (LegalMonetaryTotal.TaxExclusiveAmount Lt 0) {//Kdv hariç tutar 0 dan küçük olamaz, iskonto tutarı için eklendi. Gramoni-Mahmut 15.04.2020
        LegalMonetaryTotal.TaxExclusiveAmount = LegalMonetaryTotal.LineExtensionAmount;
    }
    LegalMonetaryTotal.TaxInclusiveAmount   = get_invoice.nettotal+temp_tax_amount;
    LegalMonetaryTotal.AllowanceTotalAmount = get_invoice.row_discount+get_invoice.sa_discount;
    LegalMonetaryTotal.PayableAmount        = get_invoice.nettotal;
    LegalMonetaryTotal.PayableAmountTL      = get_invoice.nettotal * get_invoice.rate2;
    if (temp_InvoiceTypeCode Eq 'IHRACKAYITLI') {
        LegalMonetaryTotal.PayableAmount        = get_invoice.nettotal-(get_invoice.TAXTOTAL + get_invoice.OTV_TOTAL);
        if (Not listFind('TEMELFATURA,TICARIFATURA',get_invoice.profile_id)) {
            ArrayAppend(xml_error_codes,'İhraç Kayıtlı bir faturayı yalnızca TEMELFATURA veya TICARIFATURA olarak gönderebilirsiniz.'); 
        }
    }
</cfscript>

<cfif not len(get_invoice.invoice_type_code) or not len(get_invoice.profile_id)>
	<cfset ArrayAppend(xml_error_codes,'İşlem kategorileri tanımlarındaki Senaryo ve/veya Fatura Tipi degerlerini kontrol ediniz.')>
</cfif>
<cfif not get_invoice_kdv.recordcount>
	<cfset ArrayAppend(xml_error_codes,'KDV oranı tanımlarındaki Vergi Kodu değerlerini kontrol ediniz.')>
</cfif>	

<cfquery name="CHK_UNIT" dbtype="query">
	SELECT NAME_PRODUCT FROM GET_INVOICE_ROW WHERE UNIT_CODE IS NULL
</cfquery>
<cfif chk_unit.recordcount>
	<cfloop query="chk_unit">
		<cfset ArrayAppend(xml_error_codes,'#chk_unit.name_product# adlı ürün için birim tanımı yapılmamıs !')><!---#xml_error_code# --->
	</cfloop>
</cfif>

<cfif not len(get_invoice.city_name)>
	<cfset ArrayAppend(xml_error_codes,'#get_invoice.fullname# Carinin İl Bilgisi Eksik ! ')>
</cfif>
<cfif not len(get_invoice.county_name)>
	<cfset ArrayAppend(xml_error_codes,'#get_invoice.fullname# Carinin İlçe Bilgisi Eksik ! ')>
</cfif>

<cfquery name="GET_ALIAS" datasource="#DSN#">
    SELECT 
    	ALIAS,
        REGISTER_DATE
   	FROM 
    	EINVOICE_COMPANY_IMPORT 
    WHERE 
    	TAX_NO = 
        <cfif not get_invoice.is_person>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice.taxno#"> 
        <cfelse>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice.tc_identity#">
        </cfif>
		<cfif len(get_invoice.compbranch_alias)>AND ALIAS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice.compbranch_alias#"></cfif>
</cfquery>

<cfif get_alias.recordcount gt 1 and not listfind('IHRACAT,YOLCUBERABERFATURA,BEDELSIZIHRACAT',get_invoice.profile_id)>
	<cfset ArrayAppend(xml_error_codes,'#get_invoice.fullname# Carinin Birden Fazla Alias Tanımı Var. Şube Seçiniz! ')>
<cfelseif get_alias.recordcount eq 0 and not listfind('IHRACAT,YOLCUBERABERFATURA,BEDELSIZIHRACAT',get_invoice.profile_id)>   
	<cfset ArrayAppend(xml_error_codes,'#get_invoice.fullname# Carinin Alias Tanımı Yok. Kontrol Ediniz !')>
<cfelseif get_alias.recordcount eq 1 and datediff('d',get_invoice.invoice_date,get_alias.register_date) gt 0 and not listfind('IHRACAT,YOLCUBERABERFATURA,BEDELSIZIHRACAT',get_invoice.profile_id)>  
	<cfset ArrayAppend(xml_error_codes,'#get_invoice.fullname# Carinin Alias Kayıt Tarihini ve Fatura Tarihini Kontrol Ediniz !')>
</cfif>

<cfif not get_invoice_row.recordcount>
	<cfset ArrayAppend(xml_error_codes,'Fatura Satırındaki Ürünleri Kontrol Ediniz. Faturada En Az Bir Satır Ürün Gitmelidir.')>
</cfif>

<cfif get_invoice.IS_CIVIL eq 1 and not listfind('KAMU', get_invoice.profile_id)>
    <cfset ArrayAppend(xml_error_codes,"Kamu'ya Kesilen Faturaların Senaryosu KAMU olmalıdır!")>
<cfelseif listFind('KAMU', get_invoice.profile_id) and ( not isDefined("get_owner_customer_no") or not len(get_owner_customer_no.ACCOUNT_OWNER_CUSTOMER_NO) ) and get_invoice.IS_CIVIL eq 1 >
    <cfset ArrayAppend(xml_error_codes,"Kamu'ya Kesilen Faturalarda Banka Hesabı Seçmelisiniz!")>
<cfelseif get_invoice.IS_CIVIL neq 1 and listFind('KAMU', get_invoice.profile_id)>
    <cfset ArrayAppend(xml_error_codes,"Kamu Olmayan Carilerde KAMU Senaryosu Seçmemelisiniz!")>
</cfif>  

<cfif get_invoice.IS_CIVIL eq 1 and listfind('KAMU', get_invoice.profile_id)>
    <cfoutput query="GET_INVOICE_ROW">
        <cfif len(GET_INVOICE_ROW.ORIGIN_ID) AND ( not len(GET_INVOICE_ROW.COUNTRY_CODE) or not len(GET_INVOICE_ROW.COUNTRY_NAME) )>
            <cfset arrayAppend(xml_error_codes,"#currentrow#. satırdaki Menşei Gönderilecek Satır İçin Ülkeler Parametre Sayfasından Ülke Kodu Tanımını Yapmalısınız!")>
        </cfif>
    </cfoutput>
</cfif>

<cfif len(get_invoice.einvoice_id)>
	<cfset invoice_number = "#get_invoice.einvoice_id#">
<cfelse>
    <cfquery name="GET_MAX_EFATURA_NO" datasource="#DSN2#">
        SELECT EINVOICE_PREFIX,EINVOICE_NUMBER FROM EINVOICE_NUMBER
    </cfquery>
    <cfscript>
        if (attributes.action_type is 'INVOICE') {
            type_info = 0;
        }
        else {
            type_info = 1;
        }

        if (Not listfind('1,2',get_our_company.einvoice_type)) {
            if (get_our_company.is_template_code eq 1) {//1 olduğunda fatura ön ek manuel, 0 olduğunda entegratör tarafından otomatik oluşturulur. 20160503
                invoice_prefix      = get_invoice.serial_number;
                get_prefix_tmp      = createObject("component","V16.e_government.cfc.einvoice");
                get_prefix_tmp.dsn  = dsn;
                get_prefix_tmp.dsn2 = dsn2;
                get_prefix          = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:1); // 2.parametre e-fatura ön ek bilgilerini almak için kullanıldı

                // Çoklu seri kullanılıyor ise ve ön ek tablosundan en az iki tane kayıt dönüyor ise Gramoni-Mahmut 12.12.2019
                if (Len(get_our_company.IS_MULTIPLE_PREFIX) And get_our_company.IS_MULTIPLE_PREFIX And get_prefix.recordcount Eq 2) {
                    //Sıra no 1 olan ön eki alıyoruz
                    first_prefix        = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:1, prefix_order:1);

                    if (first_prefix.recordcount) {
                        //1 numaralı ön ekten kesilen son fatura tarihini alıyoruz
                        last_invoice_date   = get_prefix_tmp.get_last_invoice_date(ip_prefix=first_prefix.PREFIX);
                        invoice_prefix      = first_prefix.PREFIX;
                        if (isDate(last_invoice_date)) {
                            //bu fatura 1 numaralı ön ekten kesilen son fatura tarihinden eski mi kontrol ediyoruz
                            if (dateCompare(get_invoice.invoice_date,last_invoice_date) Eq -1) {
                                //eski ise 2 numaralı ön eki çekiyoruz
                                second_prefix   = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:1, prefix_order:2);
                                if (second_prefix.recordcount) {
                                    //2 numaralı ön eki bu fatura için tayin ediyoruz
                                    invoice_prefix  = second_prefix.PREFIX;
                                }
                            }
                        }
                    }
                }

                invoice_number = "#invoice_prefix##session_base.period_year##type_info##left('00000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#";
            }
            else {
                invoice_number = "#get_max_efatura_no.einvoice_prefix##session_base.period_year##type_info##left('00000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#";
            }
        }
        else {
            if (Not not len(trim(get_max_efatura_no.einvoice_number))) {
                ArrayAppend(xml_error_codes,'e-Fatura Admin Panelinden e-Fatura Numarası tanımı yapınız!');
            }
            else {
                einvoice_number = "#get_max_efatura_no.einvoice_number+1#";
                invoice_number = "#get_max_efatura_no.einvoice_number##session_base.period_year##type_info##left('00000000',8-len(einvoice_number))##einvoice_number#";
            }
        }
    </cfscript>
</cfif>
<cfif ArrayLen(xml_error_codes)>
        
    <div style="border-left:solid 1px;border-right:solid 1px;border-bottom:solid 1px;border-radius:5px;">
    	<h3 style="border-top-left-radius:5px;border-top-right-radius:5px;background-color:#BF0500;color:#FFF;padding:3px 15px;">e-Fatura Gönderilirken <cfif ArrayLen(xml_error_codes) eq 1>Hata<cfelseif ArrayLen(xml_error_codes) gt 1>Hatalar</cfif> Oluştu!</h3>
        <ul>
        <cfloop array="#xml_error_codes#" index="error_code">
            <cfoutput>
                <li style="list-style-image:url(/images/caution_small.gif);margin-top:5px;">#error_code#</li>
            </cfoutput>
        </cfloop>
        </ul> 
    </div>
	
    <cfif not isdefined("attributes.is_multi")>
        <cfabort>
    </cfif>
<cfelse>
    <!--- Gonderilen e-invoice kayit edilecek folder tanimlanir. --->
    <cfscript>
        temp_einvoice_folder = 'einvoice_send';
        temp_path            = '#temp_einvoice_folder#/#session_base.company_id#/#year(now())#/#numberformat(month(now()),00)#/#invoice_number#.xml';
        preview_invoice_xml  = 'documents/einvoice_send/#session_base.company_id#/#year(now())#/#numberformat(month(now()),00)#/#invoice_number#.xml';

        if (isdefined("attributes.is_multi")) {
            directory_name = "#upload_folder##temp_einvoice_folder##dir_seperator##session_base.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)##dir_seperator#multiple";
        }
        else {
            directory_name = "#upload_folder##temp_einvoice_folder##dir_seperator##session_base.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#";
        }

        if (Not DirectoryExists(directory_name)) {
            directoryCreate(directory_name);
        }

        new_invoice_number = '';//gib tarafından kaydedilen fatura numarası alınıp cari ve muhasebe update edilecek
        
        switch(get_our_company.einvoice_type_alias) {
            case "dp":
                include 'einvoice_digitalplanet.cfm';
            break;
            case "dgn":
                include 'einvoice_dogan.cfm';
            break;
            case "spr":
                include 'einvoice_spr.cfm';
            break;
            default:
                writeOutput("Lütfen entegrasyon yöntemi seçiniz!");
                abort;
            break;
        }
    </cfscript>

    <!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
    <cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
        <!--- yeni olusan fatura numarasina göre cari,muhasebe , irsaliye güncellemeleri yapılıyor --->
        <cfif isdefined("new_invoice_number") and len(new_invoice_number)>

            <!--- wex counter kaydı atılıyor --->
            <!--- <cftry>
                <cfset get_license = createObject("component","V16.settings.cfc.workcube_license").get_license_information()>
                <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                    <cfhttpparam name="subscription_no" type="formfield" value="#get_license.WORKCUBE_ID#" />
                    <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                    <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                    <cfhttpparam name="product_id" type="formfield" value="8719" />
                    <cfhttpparam name="amount" type="formfield" value="1" />
                    <cfhttpparam name="process_type" type="formfield" value="#get_invoice.INVOICE_CAT#" />
                    <cfhttpparam name="process_doc_no" type="formfield" value="#new_invoice_number#" />
                    <cfhttpparam name="process_date" type="formfield" value="#dateFormat(get_invoice.INVOICE_DATE,dateformat_style)#" />
                    <cfhttpparam name="wex_type" type="formfield" value="E-Fatura" />
                    <cfhttpparam name="tax_no" type="formfield" value="#get_our_company.tax_no#">
                    <cfhttpparam name="wex_integrator" type="formfield" value="#get_our_company.einvoice_type_alias#" />
                    <cfhttpparam name="counter_outgoing" type="formfield" value="1" />
                </cfhttp>
                <cfset responseService = result.FileContent>
                <cfset responseWex = deserializeJson(responseService) />
                <cfif responseWex.status neq 1>
                    <script type = "text/javascript">
                        alert('İşlem başarılı, ancak wex kaydı yapılamadı! Lütfen sistem yöneticinize bilgi veriniz!');
                    </script>
                </cfif>
                <cfcatch>
                    <cfdump var="#cfcatch#">
                </cfcatch>
            </cftry> --->
            <!--- //wex counter kaydı atılıyor --->

            <cftry>
                <cfset yeni_fatura_no="#new_invoice_number#">
                <cfif attributes.action_type is 'INVOICE'>
                    <!--- Fatura ise cari, muhasebe, irsaliye ve bütçe islemleri güncelleniyor --->
                    <cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
                        UPDATE INVOICE SET INVOICE_NUMBER = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE INVOICE_ID = #get_invoice.invoice_id#
                    </cfquery>
                    <cfquery name="UPD_CARI_ROWS" datasource="#dsn2#">
                        UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#', ACTION_NAME = ACTION_NAME + ' (E-FATURA)'  WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE_ID = #get_invoice.invoice_cat#
                    </cfquery>
                    <cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
                        UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#
                    </cfquery>
                    <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#dsn2#">
                        UPDATE 
                            ACCOUNT_CARD_ROWS 
                        SET 
                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                        WHERE 
                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#)
                    </cfquery>
                    <cfquery name="UPD_ACCOUNT_ROWS_IFRS" datasource="#DSN2#">
                        UPDATE 
                            ACCOUNT_ROWS_IFRS 
                        SET 
                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150)
                        WHERE 
                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#)
                    </cfquery>
                    <cfif len(get_invoice.is_cash) and get_invoice.is_cash eq 1>
                        <cfquery name="UPD_ACCOUNT_CARD_CASH" datasource="#dsn2#">
                            UPDATE 
                                ACCOUNT_CARD 
                            SET 
                                PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                            WHERE
                                ACTION_ID = #get_invoice.CASH_ID# 
                                AND ACTION_TYPE IN (34,35) 
                                AND ACTION_ID IN (SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID = #get_invoice.CASH_ID# )
                        </cfquery>
                        <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                            UPDATE 
                                ACCOUNT_CARD_ROWS 
                            SET 
                                DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                            WHERE 
                                CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD AC JOIN CASH_ACTIONS CA ON CA.ACTION_ID = AC.ACTION_ID WHERE AC.ACTION_ID = #get_invoice.CASH_ID# AND AC.ACTION_TYPE IN (34,35) )
                        </cfquery>
                    </cfif>
                    <cfquery name="UPD_EXP_DETAIL" datasource="#dsn2#">
                        UPDATE 
                            EXPENSE_ITEMS_ROWS 
                        SET 
                            DETAIL = REPLACE(CAST(DETAIL AS NVARCHAR),'#get_invoice.invoice_number#','#yeni_fatura_no#')
                        WHERE 
                            INVOICE_ID = #get_invoice.invoice_id#
                    </cfquery>
                    <cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
                        UPDATE 
                            SHIP 
                        SET 
                            SHIP_NUMBER= '#yeni_fatura_no#' 
                        FROM 
                            SHIP S,INVOICE_SHIPS ISH 
                        WHERE 
                            ISH.INVOICE_ID = '#get_invoice.invoice_id#' AND ISH.SHIP_ID = S.SHIP_ID AND ISNULL(ISH.IS_WITH_SHIP,0) = 1 
                    </cfquery>
                    <cfquery name="UPD_INVOICE_SHIPS" datasource="#dsn2#">
                        UPDATE INVOICE_SHIPS SET INVOICE_NUMBER = '#yeni_fatura_no#', SHIP_NUMBER = '#yeni_fatura_no#' WHERE INVOICE_ID = #get_invoice.invoice_id# AND ISNULL(IS_WITH_SHIP,0) = 1
                    </cfquery>
                    <cfquery name="UPD_INVOICE_SHIPS" datasource="#dsn2#">
                        UPDATE INVOICE_SHIPS SET INVOICE_NUMBER = '#yeni_fatura_no#' WHERE INVOICE_ID = #get_invoice.invoice_id# AND ISNULL(IS_WITH_SHIP,0) = 0
                    </cfquery>
                    <cfquery name="get_ship_info" datasource="#dsn2#">
                        SELECT
                            S.SHIP_TYPE,
                            S.COMPANY_ID,
                            S.SHIP_ID
                        FROM
                            SHIP S, INVOICE_SHIPS ISH
                        WHERE 
                            ISH.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.invoice_id#"> 
                            AND ISH.SHIP_ID = S.SHIP_ID AND ISNULL(ISH.IS_WITH_SHIP,0) = 1
                    </cfquery>
                    <cfif get_ship_info.recordCount>
                        <cfquery name="upd_serial_no" datasource="#dsn2#">
                            UPDATE #dsn3_alias#.SERVICE_GUARANTY_NEW 
                                SET PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#yeni_fatura_no#">
                            WHERE 
                                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.SHIP_TYPE#"> 
                                AND SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.COMPANY_ID#">
                                AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.SHIP_ID#">
                        </cfquery>
                    </cfif>

                    <cfquery name = "get_inv_cash_pos" datasource = "#dsn2#">
                        SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID = #get_invoice.invoice_id#
                    </cfquery>
                    <cfoutput query = "get_inv_cash_pos">
                        <cfif len(cash_id)>
                            <cfquery name = "get_acc_card" datasource = "#dsn2#">
                                SELECT
                                    CARD_ID
                                FROM
                                    ACCOUNT_CARD 
                                WHERE
                                    ACTION_ID = #cash_id# 
                                    AND ACTION_TYPE IN (35)
                            </cfquery>
                            <cfquery name="UPD_ACCOUNT_CARD_CASH_POS" datasource="#dsn2#">
                                UPDATE 
                                    ACCOUNT_CARD 
                                SET 
                                    PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                                WHERE
                                    CARD_ID = #get_acc_card.card_id#
                            </cfquery>
                            <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                UPDATE
                                    ACCOUNT_CARD_ROWS
                                SET
                                    DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                WHERE
                                    CARD_ID = #get_acc_card.card_id#
                            </cfquery>
                        </cfif>
                        <cfif len(pos_action_id)>
                            <cfquery name = "get_acc_card" datasource = "#dsn2#">
                                SELECT
                                    CARD_ID
                                FROM
                                    ACCOUNT_CARD 
                                WHERE
                                    ACTION_ID = #pos_action_id# 
                                    AND ACTION_TYPE IN (241)
                            </cfquery>
                            <cfquery name="UPD_ACCOUNT_CARD_CASH_POS" datasource="#dsn2#">
                                UPDATE 
                                    ACCOUNT_CARD 
                                SET 
                                    PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150)
                                WHERE
                                    CARD_ID = #get_acc_card.card_id#
                            </cfquery>
                            <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                UPDATE
                                    ACCOUNT_CARD_ROWS
                                SET
                                    DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                WHERE
                                    CARD_ID = #get_acc_card.card_id#
                            </cfquery>
                        </cfif>
                    </cfoutput>
                <cfelse>
                    <!--- Gelir fisi ise cari ,muhasebe güncelleniyor --->
                    <cfquery name="UPD_EXPENSE" datasource="#dsn2#">
                        UPDATE EXPENSE_ITEM_PLANS SET PAPER_NO = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE EXPENSE_ID = #get_invoice.invoice_id#
                    </cfquery>
                    <cfquery name="UPD_CARI_ROWS" datasource="#dsn2#">
                        UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#',ACTION_NAME = ACTION_NAME + ' (E-FATURA)' WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE_ID = #get_invoice.action_type#
                    </cfquery>
                    <cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
                        UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.action_type#
                    </cfquery>
                    <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#dsn2#">
                        UPDATE 
                            ACCOUNT_CARD_ROWS 
                        SET 
                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                        WHERE 
                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.action_type#)
                    </cfquery>
                    <cfif len(get_invoice.is_cash) and get_invoice.is_cash eq 1>
                        <cfquery name="UPD_ACCOUNT_CARD_CASH" datasource="#dsn2#">
                            UPDATE 
                                ACCOUNT_CARD 
                            SET 
                                PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                            WHERE
                                ACTION_ID = #get_invoice.CASH_ID# 
                                AND ACTION_TYPE IN (24,25,31,32) 
                                AND ACTION_ID IN (SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID = #get_invoice.CASH_ID# )
                        </cfquery>
                        <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                            UPDATE
                                ACCOUNT_CARD_ROWS
                            SET
                                DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                            WHERE
                                CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD AC JOIN CASH_ACTIONS CA ON CA.ACTION_ID = AC.ACTION_ID WHERE AC.ACTION_ID = #get_invoice.CASH_ID# AND AC.ACTION_TYPE IN (24,25,31,32) )
                        </cfquery>
                    </cfif>
                </cfif>
                <!---  islem tamamlandıgında iliski tablosunda belge güncellendi alanını 1 set ediyoruz.--->
                <cfquery name="upd_inv_rel" datasource="#dsn2#">
                    UPDATE EINVOICE_RELATION SET IS_PAPER_UPDATE = 1 WHERE INTEGRATION_ID = '#new_invoice_number#'
                </cfquery>
                <cfcatch type="any">
                    <cfscript>
                        if(isDefined("application.bugLog")){
                            application.bugLog.notifyService(
                                message='#session_base.COMPANY# Şirketinde E-Fatura Numaraları Güncellenemedi',
                                exception=cfcatch,
                                AppName='E-GOVERNMENT');
                        }
                    </cfscript>
                    E-Fatura Gönderildi. Fatura Numaraları Güncellenemedi, Lütfen Giden E-Fatura Durum Kontrol Raporunu Çalıştırın!
                    <cfif not isdefined("attributes.is_multi")>
                        <script type="text/javascript">
                            window.opener.location.reload(true);
                        </script>
                        <cfabort>
                    </cfif>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>
</cfif>
<!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
<cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
    <cfif get_our_company.einvoice_type neq 1 and not isdefined("attributes.is_multi")>
        <script type="text/javascript">
            <cfif STATUS_CODE eq 1>
                window.opener.location.reload(true);
            </cfif>
            self.close();
            window.opener.openDetails();
        </script>
    </cfif>
</cfif>