<!---
    File: create_xml_earchive.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-arşiv fatura xml verisi oluşturma
    History:
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

<cfsetting showdebugoutput="no"> 
<cfset xml_error_codes = ArrayNew(1)><!--- Hata kodları bu alana yazılır. --->

<cfif not isdefined("array_row")>
	<cfset array_row = 0>
	<cfset output_type_array = QueryNew("uuid,output_type","VARCHAR,VARCHAR")>
</cfif>
<cfif not isdefined("count_xml_row")>
	<cfset count_xml_row = 0>
</cfif>
<cfif isdefined("count_row")>
	<cfset count_row = count_row + 1>
	<cfset all_count_row = all_count_row + 1>
</cfif>
<cfquery name="CHK_SEND_INV_ALL" datasource="#DSN2#">
	SELECT EARCHIVE_ID,STATUS_CODE,UUID FROM EARCHIVE_SENDING_DETAIL WHERE ACTION_ID = #attributes.action_id# AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> 
</cfquery>
<cfquery name="CHK_SEND_EINV" datasource="#DSN2#">
	SELECT EINVOICE_ID,STATUS_CODE,UUID FROM EINVOICE_SENDING_DETAIL WHERE STATUS_CODE = '1' AND ACTION_ID = #attributes.action_id# AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> 
</cfquery>
<cfquery name="CHK_SEND_INV" dbtype="query">
    SELECT EARCHIVE_ID FROM CHK_SEND_INV_ALL WHERE STATUS_CODE = '1'
</cfquery>

<cfscript>
	earchive_tmp= createObject("component","V16.e_government.cfc.earchieve");
	earchive_tmp.dsn = dsn;
	earchive_tmp.dsn2 = dsn2;
	earchive_tmp.dsn_alias = dsn_alias;
	earchive_tmp.dsn2_alias = dsn2_alias;
	earchive_tmp.dsn3_alias = dsn3_alias;
	get_our_company = earchive_tmp.get_our_company_fnc(company_id:session_base.company_id);	
</cfscript> 

<cfif chk_send_inv.recordcount and not isdefined("attributes.resend")>
	<cfset ArrayAppend(xml_error_codes,"#chk_send_inv.earchive_id# Fatura Daha Önceden Başarılı Bir Şekilde Kaydedilmiş !")>
    <cfif isdefined("attributes.is_multi")>
		<cfset kontrol_print = 1>
    </cfif>
</cfif>
<cfif chk_send_einv.recordcount>
	<cfset ArrayAppend(xml_error_codes,"#chk_send_einv.einvoice_id# Fatura Daha Önceden E-Fatura Olarak Gönderilmiş !")>
    <cfif isdefined("attributes.is_multi")>
		<cfset kontrol_print = 1>
    </cfif>
</cfif>

<cfset attributes.invoice_id = attributes.action_id>
<cfif attributes.action_type is 'INVOICE'>
    <cfquery name="GET_INV_UUID" datasource="#DSN2#">
        SELECT UUID,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID FROM INVOICE WHERE INVOICE_ID = #attributes.action_id#
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
<cfelse>
    <cfquery name="GET_INV_UUID" datasource="#DSN2#">
        SELECT UUID,CH_COMPANY_ID COMPANY_ID,CH_CONSUMER_ID CONSUMER_ID,CH_EMPLOYEE_ID EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #attributes.action_id#
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

<cfif get_inv_uuid.recordcount and len(get_inv_uuid.uuid) and not isdefined("attributes.resend")>
	<cfset GUIDStr = get_inv_uuid.uuid>
<cfelse>	
    <cfscript>
        uuidLibObj = createobject("java", "java.util.UUID");
        GUIDStr = uuidLibObj.randomUUID().toString(); 
    </cfscript>
    <cfif attributes.action_type is 'INVOICE'>
        <cfquery name="UPD_INV_UUID" datasource="#DSN2#">
            UPDATE INVOICE SET UUID = '#GUIDStr#' WHERE INVOICE_ID = #attributes.action_id#
        </cfquery>
    <cfelse>
        <cfquery name="UPD_INV_UUID" datasource="#DSN2#">
             UPDATE EXPENSE_ITEM_PLANS SET UUID = '#GUIDStr#' WHERE EXPENSE_ID = #attributes.action_id#
        </cfquery>
    </cfif>
</cfif>

<cfscript>
	get_comp_info = earchive_tmp.get_comp_info_fnc(company_id:session_base.company_id);
</cfscript>

<cfif attributes.action_type is 'INVOICE'>
	<cfscript>
		if (len (get_inv_uuid.company_id))
            get_invoice = earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,company_id:get_inv_uuid.company_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
        else if (len(get_inv_uuid.consumer_id))
            get_invoice =  earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,consumer_id:get_inv_uuid.consumer_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
		else if(len(get_inv_uuid.employee_id))
			get_invoice =  earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,employee_id:get_inv_uuid.employee_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
    </cfscript>
	<cfquery name="GET_RELATED_ORDER_1" datasource="#DSN2#">
        SELECT DISTINCT
			O.ORDER_NUMBER,
			O.ORDER_DATE,
			O.ORDER_ID
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
			O.ORDER_DATE,
			O.ORDER_ID
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
			ORDER_ID
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
	<cfquery name="GET_INVOICE_KDV" datasource="#DSN2#">
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
			SUM(TAXTOTAL) TAX_AMOUNT,
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
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)
                END AS TAXTOTAL,
            <cfelse>
                (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    (IR.TAXTOTAL/IM.RATE2)
                ELSE
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)/IM.RATE2
                END AS TAXTOTAL, 
            </cfif>
				ST.TAX_CODE_NAME,
				ST.TAX_CODE,
				IR.TAX
			FROM 
				INVOICE_ROW IR 
                    LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = #session_base.period_id#
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
				SETUP_TAX ST,
				INVOICE I
			WHERE 
				IR.TAX = ST.TAX 
				AND IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
				AND I.INVOICE_ID = IR.INVOICE_ID
				AND PP.TAX_CODE IS NULL 
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
                I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
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

    <cfquery name="GET_RELATED_ORDER" datasource="#DSN2#">
		SELECT DISTINCT
			O.ORDER_NUMBER,
			O.ORDER_DATE,
			O.ORDER_ID
		FROM
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDERS_INVOICE OI
		WHERE
			O.ORDER_ID = OI.ORDER_ID
			AND OI.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
			AND OI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
	</cfquery>
    
	<!--- sabit kıymet faturalarında urun secimi zorunlu olmadıgı icin joinler ile yazildi. FA--->
	<cfquery name="GET_INVOICE_ROW" datasource="#DSN2#">
		SELECT
			IR.INVOICE_ROW_ID,
			IR.AMOUNT,
			IR.TAX,
            IR.PRODUCT_ID,
        <cfif temp_currency_code>
            IR.NETTOTAL,
            ISNULL(IR.DISCOUNTTOTAL,0) DISCOUNTTOTAL,
            IR.TAXTOTAL,
            IR.PRICE,
        <cfelse>
            (IR.NETTOTAL/IM.RATE2) NETTOTAL,
            (ISNULL(IR.DISCOUNTTOTAL,0)/IM.RATE2) DISCOUNTTOTAL,
            (IR.TAXTOTAL/IM.RATE2) TAXTOTAL,
            IR.PRICE_OTHER PRICE,
        </cfif>
			CASE WHEN IR.NAME_PRODUCT IS NOT NULL THEN IR.NAME_PRODUCT ELSE DESCRIPTION END AS NAME_PRODUCT,
            IR.PRODUCT_NAME2,
			ST.TAX_CODE,
			CASE WHEN SU.UNIT_CODE IS NOT NULL THEN SU.UNIT_CODE ELSE 'C62' END AS UNIT_CODE,
            S.STOCK_CODE,
            S.BARCOD,
            S.STOCK_CODE_2,
            IR.DISCOUNT1,
            IR.DISCOUNT2,
            IR.DISCOUNT3,
            IR.DISCOUNT4,
            IR.DISCOUNT5,            
            IR.REASON_CODE,
            IR.REASON_NAME,
            IR.BSMV_RATE,
            IR.BSMV_AMOUNT,
            IR.BSMV_CURRENCY,
            IR.OIV_RATE,
            IR.OIV_AMOUNT,
            <cfif len(get_inv_uuid.company_id)>(SELECT TOP 1 COMPANY_STOCK_CODE FROM #dsn1_alias#.SETUP_COMPANY_STOCK_CODE WHERE COMPANY_ID = ISNULL(#get_invoice.company_id#,-1) AND STOCK_ID = IR.STOCK_ID) COMPANY_STOCK_CODE,</cfif>
            (PU.WEIGHT * IR.AMOUNT) AS WEIGHT
		FROM 
			INVOICE_ROW IR 
            	LEFT JOIN #dsn_alias#.SETUP_UNIT SU ON IR.UNIT = SU.UNIT 
				LEFT JOIN #dsn1_alias#.STOCKS S ON S.STOCK_ID = IR.STOCK_ID
            	LEFT OUTER JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
            	LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY
                LEFT JOIN SETUP_TAX ST ON ST.TAX = IR.TAX
                LEFT JOIN #dsn3_alias#.PRODUCT_UNIT AS PU ON IR.PRODUCT_ID = PU.PRODUCT_ID
		WHERE
			IR.INVOICE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			PP.TAX_CODE IS NULL<!--- İçerisinde vergi kodu seçilmemiş ürünler geliyor --->
            <cfif get_invoice.INVOICE_CAT neq 66>
                AND PU.IS_MAIN = 1
            </cfif>
        ORDER BY
            IR.INVOICE_ROW_ID
	</cfquery>
	<cfquery name="CONTROL_DAMGA" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) NETTOTAL FROM GET_INVOICE_KDV WHERE TYPE = 4
    </cfquery>
	<cfquery name="GET_INVOICE_TAX_ROW" datasource="#DSN2#">
		SELECT 
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
            	LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY 
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">,
			#DSN3_ALIAS#.SETUP_OTV SO
		WHERE 
			IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SO.TAX = IR.OTV_ORAN AND
			IR.OTV_ORAN != 0 AND
			PP.TAX_CODE IS NULL AND 
            SO.PERIOD_ID = #session_base.period_id#
		UNION 
		SELECT
			2 TYPE,
            IR.INVOICE_ROW_ID,
        <cfif temp_currency_code>
            CASE WHEN(IR.NETTOTAL = 0) THEN
				(IR.TAXTOTAL)
			ELSE
				((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL
			END AS TAXTOTAL,
        <cfelse>
            CASE WHEN(IR.NETTOTAL = 0) THEN
				(IR.TAXTOTAL/IM.RATE2)
			ELSE
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
			SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
	</cfquery>
    
    <cfquery name="get_stopaj_kdv" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE = 5
    </cfquery>
<cfelse>
	<cfscript>
		if (len (get_inv_uuid.company_id))
            get_invoice = earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,company_id:get_inv_uuid.company_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
        else if (len(get_inv_uuid.consumer_id))
            get_invoice = earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,consumer_id:get_inv_uuid.consumer_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
		else if(len(get_inv_uuid.employee_id))
			get_invoice = earchive_tmp.get_invoice_fnc(invoice_id:attributes.invoice_id,employee_id:get_inv_uuid.employee_id,temp_currency_code:temp_currency_code,action_type:attributes.action_type);
	</cfscript>

    <!--- 1-OTV, 2-KDV, 3-Tevkifat, 4-Urun Detayı Ozel Vergi Secimi, 5-Stopaj, 6-BSMV, 7-OIV --->
	<cfquery name="GET_INVOICE_KDV" datasource="#DSN2#">
		SELECT
        	1 TYPE,
            SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND(SUM(IR.AMOUNT_OTV/IM.RATE2),2) NETTOTAL,
            SO.TAX_CODE_NAME,
            SO.TAX_CODE,
            ROUND(SUM(IR.AMOUNT_OTV/IM.RATE2),2) TAX_AMOUNT,
            IR.OTV_RATE TAX 
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
            IR.MONEY_CURRENCY_ID
		UNION
		SELECT
        	2 TYPE,
            SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND(SUM(IR.AMOUNT_KDV/IM.RATE2),2) NETTOTAL,
            ST.TAX_CODE_NAME,
            ST.TAX_CODE,
            ROUND(SUM(IR.AMOUNT_KDV/IM.RATE2),2) TAX_AMOUNT,
            IR.KDV_RATE
       	FROM
        	EXPENSE_ITEMS_ROWS IR
            	LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID
            	LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = #session_base.period_id#,
          	SETUP_TAX ST
       	WHERE
        	IR.KDV_RATE = ST.TAX AND
            IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
            PP.TAX_CODE IS NULL
      	GROUP BY
        	IR.KDV_RATE,
            ST.TAX_CODE_NAME,
            ST.TAX_CODE
		UNION
		SELECT
        	3 TYPE,
            SUM(IR.TOTAL_AMOUNT/IM.RATE2) - ROUND((SUM(IR.AMOUNT_KDV/IM.RATE2)*(1-TEVKIFAT_ORAN)),2) NETTOTAL,
            ST.TEVKIFAT_CODE_NAME TAX_CODE_NAME,
		    ST.TEVKIFAT_CODE TAX_CODE,
            ROUND((SUM(IR.AMOUNT_KDV/IM.RATE2)*(1-TEVKIFAT_ORAN)),2) TAX_AMOUNT,
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
		UNION
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
			PP.PERIOD_ID = #session_base.period_id# AND
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
		GROUP BY
			PP.TAX_CODE_NAME,
			PP.TAX_CODE,
			IR.MONEY_CURRENCY_ID,
            PP.TAX
         UNION   
         SELECT
            5 TYPE,
            SUM(IR.TOTAL_AMOUNT/IM.RATE2) - SUM(I.STOPAJ/IM.RATE2) NETTOTAL,
            ST.TAX_CODE_NAME,
            ST.TAX_CODE,
            SUM(I.STOPAJ/IM.RATE2) TAX_AMOUNT,
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

	<cfquery name="GET_INVOICE_ROW" datasource="#DSN2#">
		SELECT
			IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID,
			IR.QUANTITY AMOUNT,
			(IR.AMOUNT/IM.RATE2) * IR.QUANTITY AS NETTOTAL,
			0 DISCOUNTTOTAL,
			(IR.AMOUNT_KDV/IM.RATE2) TAXTOTAL,
			IR.KDV_RATE TAX,
            IR.PRODUCT_ID,
			IR.DETAIL NAME_PRODUCT,
            '' PRODUCT_NAME2,
			(IR.AMOUNT/IM.RATE2) PRICE,
			ST.TAX_CODE,
			CASE WHEN SU.UNIT_CODE IS NOT NULL THEN SU.UNIT_CODE ELSE 'C62' END AS UNIT_CODE,
            '' STOCK_CODE,
            '' BARCOD,
            '' STOCK_CODE_2,
            '' REASON_CODE,
            '' REASON_NAME,
            IR.BSMV_RATE,
            IR.BSMV_CURRENCY,
            IR.AMOUNT_BSMV AS BSMV_AMOUNT,
            IR.OIV_RATE,
            IR.AMOUNT_OIV AS OIV_AMOUNT,
            '' COMPANY_STOCK_CODE
		FROM 
			EXPENSE_ITEMS_ROWS IR
                LEFT JOIN #dsn_alias#.SETUP_UNIT SU ON IR.UNIT = SU.UNIT 
                LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID
                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
			SETUP_TAX ST
		WHERE 
			IR.EXPENSE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			ST.TAX = IR.KDV_RATE AND
			PP.TAX_CODE IS NULL
        ORDER BY
            IR.EXP_ITEM_ROWS_ID
    </cfquery>
    
	<cfquery name="GET_INVOICE_TAX_ROW" datasource="#DSN2#">
		SELECT 
			1 TYPE,
			IR.AMOUNT_OTV TAX_TOTAL,
			CASE WHEN SO.TAX_TYPE = 1 THEN 0 ELSE IR.OTV_RATE END AS TAX,
            '' REASON_CODE,
            '' REASON_NAME,            
			SO.TAX_CODE,
			SO.TAX_CODE_NAME,
			IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID
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
			(IR.AMOUNT_KDV/IM.RATE2) TAX_TOTAL,
			IR.KDV_RATE TAX,
            '' REASON_CODE,
            '' REASON_NAME,            
			ST.TAX_CODE,
			ST.TAX_CODE_NAME,
			IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID
		FROM 
			EXPENSE_ITEMS_ROWS IR LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID
            LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = IR.EXPENSE_ID AND IM.MONEY_TYPE = IR.MONEY_CURRENCY_ID,
			SETUP_TAX ST
		WHERE 
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			ST.TAX = IR.KDV_RATE AND
			PP.TAX_CODE IS NULL
        UNION 
        SELECT
			3 TYPE, 
			IR.TOTAL_AMOUNT TAX_TOTAL,
			0 TAX,
            '' REASON_CODE,
            '' REASON_NAME,            
			PP.TAX_CODE,
			PP.TAX_CODE_NAME,
			IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID
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
			IR.AMOUNT_BSMV TAX_TOTAL,
			IR.BSMV_RATE TAX,
            REASON_CODE,
            REASON_NAME,
			SB.TAX_CODE,
			SB.TAX_CODE_NAME,
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID
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
			IR.AMOUNT_OIV TAX_TOTAL,
			IR.OIV_RATE TAX,
            REASON_CODE,
            REASON_NAME,
			SOI.TAX_CODE,
			SOI.TAX_CODE_NAME,
            IR.EXP_ITEM_ROWS_ID INVOICE_ROW_ID
		FROM 
			EXPENSE_ITEMS_ROWS IR 
            	LEFT JOIN EXPENSE_ITEMS PP ON IR.EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID,
			#DSN3_ALIAS#.SETUP_OIV SOI
		WHERE
			IR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
			SOI.TAX = IR.OIV_RATE AND
			IR.OIV_RATE != 0 AND
			PP.TAX_CODE IS NULL AND
            SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#" />
	</cfquery>
    
    <cfquery name="get_stopaj_kdv" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM GET_INVOICE_KDV WHERE TYPE = 5
    </cfquery>
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

<cfset invoice_emails = get_invoice.company_email />

<cfif get_invoice.earchive_sending_type Eq 1 And Len(get_invoice.COMPANY_ID)>
    <cfquery name="get_emails" datasource="#dsn#">
        SELECT
            COMPANY_PARTNER_EMAIL
        FROM
            COMPANY_PARTNER
        WHERE
            COMPANY_ID = #get_invoice.COMPANY_ID#
            AND IS_SEND_EARCHIVE_MAIL = 1
            AND COMPANY_PARTNER_STATUS = 1
            AND COMPANY_PARTNER_EMAIL IS NOT NULL
    </cfquery>
    <cfif get_emails.recordCount>
        <cfset invoice_emails = invoice_emails & ';' & valueList(get_emails.COMPANY_PARTNER_EMAIL,';') />
    </cfif>
</cfif>

<cfif get_invoice.earchive_sending_type Eq 1 And Not Len(invoice_emails)>
    <cfset ArrayAppend(xml_error_codes,"E-Arşiv Gönderim Tipi ELEKTRONİK Olan Müşterinin Email Adresi Dolu Olmalıdır!") />
</cfif>

<cfset CUSTOMER_NO  = '' />
<cfif Len(GET_INVOICE.COMPANY_ID)>
<cfquery name="get_company_period" datasource="#dsn2#">
    SELECT ACC.ACCOUNT_CODE FROM #DSN_ALIAS#.COMPANY_PERIOD AS ACC WHERE COMPANY_ID = #GET_INVOICE.COMPANY_ID# AND PERIOD_ID = #session_base.period_id#
</cfquery>
<cfset CUSTOMER_NO  = ListLast(get_company_period.ACCOUNT_CODE,'.') />
</cfif>

<cfif not get_invoice_row.recordcount>
    <cfset ArrayAppend(xml_error_codes,"Fatura Satırındaki Ürünleri Kontrol Ediniz. Faturada En Az Bir Satır Ürün Gitmelidir.")>
</cfif>

<cfif get_invoice.is_iptal eq 1>
	<cfset ArrayAppend(xml_error_codes,"İptal Edilen Faturayı Gönderemezsiniz !")>
</cfif>

<!--- <cfif get_invoice.is_internet eq 1>
	<cfinclude template="earchive_definition_workcube.cfm"> dosya sistemde mevcut değil, gerekli durumda detaylı incelenip aktif edilecek Mahmut-Gramoni
    <!--- İnternet satisi olmayan firmalarda bu blok acilir.
	<cfset ArrayAppend(xml_error_codes,"İnternet Satış Kanalına Ait Tanımlamalar Bulunmamaktadır ! (Şirket ID : #session_base.company_id#)")> 
	--->
</cfif> --->

<cfset mynumber = wrk_round(get_invoice.nettotal)>
<cfset mynumber1= wrk_round(get_invoice.nettotal) /><!--- AdditionalDocumentReference için eklendi mcifci 05.12.2019 --->
<cfset app_time = dateadd('h',session_base.time_zone,now())>
<cfset app_time = createodbcdatetime('#year(app_time)#-#month(app_time)#-#day(app_time)#')>
<cfif datediff('d',app_time,get_invoice.invoice_date) gt 0><!--- defaultta fatura tarihi bugünden sonra olamaz --->
	<cfset ArrayAppend(xml_error_codes,"Fatura Tarihi Bugünden Sonra Olamaz. Lütfen Fatura Tarihinizi Kontrol ediniz.")>
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
 <cfif ( isdefined("get_invoice.is_export_registered") and  get_invoice.is_export_registered eq 1 ) Or ( isdefined("get_invoice.is_export_product") and get_invoice.is_export_product Eq 1 )>
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
            <cfset ArrayAppend(xml_error_codes,"Belge Detayında KDV Değeri 0 olan satırlar için İstisna Nedeni Seçiniz ! ")>
        </cfif>	
        <cfquery name="GET_INVOICE_TAX_ROW_CONTROL4" dbtype="query">
            SELECT TAX FROM GET_INVOICE_TAX_ROW WHERE TAX <> 0 AND TYPE NOT IN(1,6,7) AND (REASON_CODE IS NOT NULL OR REASON_NAME IS NOT NULL)
        </cfquery>
        <cfif get_invoice_tax_row_control4.recordcount>
            <cfset ArrayAppend(xml_error_codes,"ISTISNA faturalarında satırdaki ürünlerin KDV Değeri 0 olmalıdır !")>
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
    if (Not GET_TAXAMOUNT.recordcount) {
        tax_amount_     = 0;
    }
    else {
        tax_amount_     = GET_TAXAMOUNT.TAX_AMOUNT;
    }

    if (Not Len(row_tax_amount_)) {
        row_tax_amount_ = 0;
    }
    if (Not Len(tax_amount_)) {
        tax_amount_     = 0;
    }

    if (get_taxamount.recordcount) {
        LmtTaxInclAmo   = GET_INVOICE.GROSSTOTAL-row_tax_amount_-GET_INVOICE.SA_DISCOUNT-GET_INVOICE.ROW_DISCOUNT+tax_amount_;
    }
    else {
        LmtTaxInclAmo   = LmtTaxInclAmo = GET_INVOICE.GROSSTOTAL-row_tax_amount_-GET_INVOICE.SA_DISCOUNT-GET_INVOICE.ROW_DISCOUNT;
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
        LegalMonetaryTotal.PayableAmount        = get_invoice.nettotal-get_invoice.TAXTOTAL;
    }
</cfscript>

<cfif not len(get_invoice.invoice_type_code)>
	<cfset ArrayAppend(xml_error_codes,"İşlem kategorileri tanımlamalarındaki Senaryo ve/veya Fatura Tipi değerlerini kontrol ediniz.")>
</cfif>
<cfif not get_invoice_kdv.recordcount>
	<cfset ArrayAppend(xml_error_codes,"KDV Oranı tanımlamalarındaki Vergi Kodu değerlerini kontrol ediniz.")>
</cfif>	

<cfquery name="CHK_UNIT" dbtype="query">
	SELECT NAME_PRODUCT FROM GET_INVOICE_ROW WHERE UNIT_CODE IS NULL
</cfquery>

<cfif chk_unit.recordcount>
	<cfloop query="chk_unit">
		<cfset ArrayAppend(xml_error_codes,"#xml_error_code# #CHK_UNIT.NAME_PRODUCT# adlı ürün için birim tanımı yapılmamış !")>
	</cfloop>
</cfif>
<cfif not len(get_invoice.city_name)>
	<cfset ArrayAppend(xml_error_codes,"#get_invoice.FULLNAME# Carinin İl Bilgisi Eksik ! ")>
</cfif>
<cfset member_tno = trim(get_invoice.taxno)>
<cfif get_invoice.is_person>
	<cfif Len(trim(get_invoice.COMPANY_PARTNER_NAME)) Lt 2 Or Len(trim(get_invoice.COMPANY_PARTNER_SURNAME)) Lt 2>
        <cfset ArrayAppend(xml_error_codes,"#get_invoice.FULLNAME# Ad-Soyad Minimum 2 Karakter Olmalıdır ! ")>
    </cfif>
	<cfif len(trim(get_invoice.taxno)) neq 11>
        <cfset ArrayAppend(xml_error_codes,"#get_invoice.FULLNAME# TCKN Bilgisi Eksik ! ")>
    </cfif>
<cfelse>
	<cfif len(trim(get_invoice.taxno)) neq 10>
        <cfset ArrayAppend(xml_error_codes,"#get_invoice.FULLNAME# VKN Bilgisi Eksik ! ")>
    </cfif>
</cfif>
<cfif get_invoice.payment_means_code eq 97 > <!--- Ödeme şekli DİĞER --->
    <cfif not len(get_invoice.note)>
        <cfset arrayAppend(xml_error_codes, "Ödeme Şekli Diğer Seçili Olan Faturalarda Açıklama Girmek Zorunludur !")>
    </cfif>
</cfif>
<cfif listfind('48,30,1', get_invoice.payment_means_code)> <!--- kredikarti/bankakarti - eft/havale - ödemearacisi  --->
    <cfif not len(get_invoice.due_date)>
        <cfset arrayAppend(xml_error_codes, "Ödeme Şekli #get_invoce.PAYMETHOD# Seçili Olan Faturalarda Ödeme Tarihi Girmek Zorunludur !")>
    </cfif>
</cfif>
<cfif len(get_invoice.earchive_id)>
	<cfset invoice_number = "#get_invoice.earchive_id#">
<cfelse>
	<cfif attributes.action_type is 'INVOICE'>
		<cfset type_info = 0>
	<cfelse>
		<cfset type_info = 1>
	</cfif>

    <cfif get_our_company.is_template_code eq 1> <!--- 1 olduğunda fatura ön ek manuel, 0 olduğunda entegratör tarafından otomatik oluşturulur. 20160503--->
		<cfif get_invoice.is_internet eq 1>
            <cfset type = 2><!--- internet --->
        <cfelse>
            <cfset type = 3><!--- mağaza --->
        </cfif>
		<cfscript>
            invoice_prefix      = get_invoice.serial_number;
            get_prefix_tmp      = createObject("component","V16.e_government.cfc.einvoice");
            get_prefix_tmp.dsn  = dsn;
            get_prefix_tmp.dsn2 = dsn2;
            get_prefix          = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:type);  // 2.parametre e-arsiv ön ek bilgilerini almak için kullanıldı
        </cfscript>
    </cfif>

	<cfif not len(trim(get_our_company.earchive_prefix))>
		<cfset ArrayAppend(xml_error_codes,"e-Arşiv Admin Panelinden Mağaza Satışı e-Arşiv Numarası tanımı yapınız!")>
	<cfelse>
		<cfif get_invoice.is_internet><!--- internet satışı için --->
        	<cfif get_our_company.is_template_code eq 1>
                <cfscript>
                    // Çoklu seri kullanılıyor ise ve ön ek tablosundan en az iki tane kayıt dönüyor ise Gramoni-Mahmut 12.12.2019
                    if (Len(get_our_company.IS_MULTIPLE_PREFIX) And get_our_company.IS_MULTIPLE_PREFIX And get_prefix.recordcount Eq 2) {
                        //Sıra no 1 olan ön eki alıyoruz
                        first_prefix        = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:2, prefix_order:1);

                        if (first_prefix.recordcount) {
                            //1 numaralı ön ekten kesilen son fatura tarihini alıyoruz
                            last_invoice_date   = get_prefix_tmp.get_last_earchive_date(ip_prefix=first_prefix.PREFIX);
                            invoice_prefix      = first_prefix.PREFIX;
                            if (isDate(last_invoice_date)) {
                                //bu fatura 1 numaralı ön ekten kesilen son fatura tarihinden eski mi kontrol ediyoruz
                                if (dateCompare(get_invoice.invoice_date,last_invoice_date) Eq -1) {
                                    //eski ise 2 numaralı ön eki çekiyoruz
                                    second_prefix   = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:2, prefix_order:2);
                                    if (second_prefix.recordcount) {
                                        //2 numaralı ön eki bu fatura için tayin ediyoruz
                                        invoice_prefix  = second_prefix.PREFIX;
                                    }
                                }
                            }
                        }
                    }
                </cfscript>
                <cfset invoice_number = "#invoice_prefix##session_base.period_year##type_info##left('0000000000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#">
            <cfelse>
            	<cfset invoice_number = "#get_our_company.earchive_prefix_internet##session_base.period_year##type_info##left('0000000000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#">
            </cfif>
        <cfelse>
            <cfif not len(trim(get_our_company.earchive_prefix_internet))>
                <cfset ArrayAppend(xml_error_codes,"e-Arşiv Admin Panelinden İnternet Satışı e-Arşiv Numarası tanımı yapınız!")>
            <cfelse><!--- mağaza satışı için --->
            	<cfif get_our_company.is_template_code eq 1>
                    <cfscript>
                        // Çoklu seri kullanılıyor ise ve ön ek tablosundan en az iki tane kayıt dönüyor ise Gramoni-Mahmut 12.12.2019
                        if (Len(get_our_company.IS_MULTIPLE_PREFIX) And get_our_company.IS_MULTIPLE_PREFIX And get_prefix.recordcount Eq 2) {
                            //Sıra no 1 olan ön eki alıyoruz
                            first_prefix        = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:3, prefix_order:1);
    
                            if (first_prefix.recordcount) {
                                //1 numaralı ön ekten kesilen son fatura tarihini alıyoruz
                                last_invoice_date   = get_prefix_tmp.get_last_earchive_date(ip_prefix=first_prefix.PREFIX);

                                invoice_prefix      = first_prefix.PREFIX;
                                if (isDate(last_invoice_date)) {
                                    //bu fatura 1 numaralı ön ekten kesilen son fatura tarihinden eski mi kontrol ediyoruz
                                    if (dateCompare(get_invoice.invoice_date,last_invoice_date) Eq -1) {
                                        //eski ise 2 numaralı ön eki çekiyoruz
                                        second_prefix   = get_prefix_tmp.get_prefix_fnc(company_id:session_base.company_id, type:3, prefix_order:2);
                                        if (second_prefix.recordcount) {
                                            //2 numaralı ön eki bu fatura için tayin ediyoruz
                                            invoice_prefix  = second_prefix.PREFIX;
                                        }
                                    }
                                }
                            }
                        }
                    </cfscript>
                    <cfset invoice_number = "#invoice_prefix##session_base.period_year##type_info##left('0000000000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#">
                <cfelse>
                	<cfset invoice_number = "#get_our_company.earchive_prefix##session_base.period_year##type_info##left('0000000000000',8-len(get_invoice.invoice_id))##get_invoice.invoice_id#">  
                </cfif>  
            </cfif>    
        </cfif>
    </cfif>
</cfif>

<cfif ArrayLen(xml_error_codes)>
	<cfif not isdefined("attributes.is_multi_update") and not isdefined("kontrol_print")>
        <div style="border-left:solid 1px;border-right:solid 1px;border-bottom:solid 1px;border-radius:5px;">
            <h3 style="border-top-left-radius:5px;border-top-right-radius:5px;background-color:#BF0500;color:#FFF;padding:3px 15px;">e-Arşiv Fatura Gönderilirken <cfif ArrayLen(xml_error_codes) eq 1>Hata<cfelseif ArrayLen(xml_error_codes) gt 1>Hatalar</cfif> Oluştu!</h3>
            <ul>
            <cfloop array="#xml_error_codes#" index="error_code">
                <cfoutput>
                    <li style="list-style-image:url(/images/caution_small.gif);margin-top:5px;">#error_code#</li>
                </cfoutput>
            </cfloop>
            </ul> 
        </div>
    </cfif>
	
    <cfif not isdefined("attributes.is_multi")>
        <cfabort>
    </cfif>
</cfif>    

<cfset directory_name = "#upload_folder#earchive_send#dir_seperator##session_base.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#">

<cfif not DirectoryExists(directory_name)>
	<cfdirectory action="create" directory="#directory_name#">
</cfif>

<cfif not len(get_invoice.earchive_sending_type)>
	<cfset ArrayAppend(xml_error_codes,"İlgili Carinin E-Arşiv Fatura Gönderim Tipi tanımlı değildir.Lütfen ilgili cari detayında tanımlamaları yapınız!")>
</cfif> 

<cfset new_invoice_number = ''>
<cfswitch expression="#get_our_company.earchive_type_alias#">
    <cfcase value = "dp">
        <cfinclude template="earchive_dp.cfm" />
    </cfcase>
    <cfcase value = "dgn">
        <cfinclude template="earchive_dgn.cfm" />
    </cfcase>
    <cfcase value = "spr">
        <cfinclude template="earchive_spr.cfm" />
    </cfcase>
    <cfdefaultcase>
        Lütfen entegrasyon yöntemi seçiniz!
        <cfabort>
    </cfdefaultcase>
</cfswitch>
<!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
<cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
    <!--- yeni oluşan fatura numarasına göre cari,muhasebe , irsaliye güncellemeleri yapılıyor --->
    <cfif isdefined("new_invoice_number") and len(new_invoice_number)>

        <!--- wex counter kaydı atılıyor --->
        <!--- <cftry>
            <cfset get_license = createObject("component","V16.settings.cfc.workcube_license").get_license_information()>
            <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                <cfhttpparam name="subscription_no" type="formfield" value="#get_license.WORKCUBE_ID#" />
                <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                <cfhttpparam name="product_id" type="formfield" value="8721" />
                <cfhttpparam name="amount" type="formfield" value="1" />
                <cfhttpparam name="process_type" type="formfield" value="#get_invoice.INVOICE_CAT#" />
                <cfhttpparam name="process_doc_no" type="formfield" value="#new_invoice_number#" />
                <cfhttpparam name="process_date" type="formfield" value="#dateFormat(get_invoice.INVOICE_DATE,dateformat_style)#" />
                <cfhttpparam name="wex_type" type="formfield" value="E-Arsiv" />
                <cfhttpparam name="tax_no" type="formfield" value="#get_comp_info.tax_no#">
                <cfhttpparam name="wex_integrator" type="formfield" value="#get_our_company.earchive_type_alias#" />
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
                <!--- Fatura ise cari, muhasebe, irsaliye ve bütçe işlemleri güncelleniyor --->
                <cfquery name="UPD_INVOICE_SALE" datasource="#DSN2#">
                    UPDATE INVOICE SET INVOICE_NUMBER = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE INVOICE_ID = #get_invoice.invoice_id#
                </cfquery>
                <cfquery name="UPD_CARI_ROWS" datasource="#DSN2#">
                    UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#' ,ACTION_NAME = ACTION_NAME + ' (E-ARŞİV)' WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE_ID = #get_invoice.invoice_cat#
                </cfquery>
                <cfquery name="UPD_ACCOUNT_CARD" datasource="#DSN2#">
                    UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#
                </cfquery>
                <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#DSN2#">
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
                <cfquery name="UPD_EXP_DETAIL" datasource="#DSN2#">
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
                <!--- Gelir fişi ise cari ,muhasebe güncelleniyor --->
                <cfquery name="GET_EXPENSE" datasource="#DSN2#">
                    SELECT EXPENSE_ID,ACTION_TYPE,PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #row_action_id#
                </cfquery>
                <cfquery name="UPD_EXPENSE" datasource="#DSN2#">
                    UPDATE EXPENSE_ITEM_PLANS SET PAPER_NO = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE EXPENSE_ID = #get_expense.expense_id#
                </cfquery>
                <cfquery name="UPD_CARI_ROWS" datasource="#DSN2#">
                    UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#',ACTION_NAME = ACTION_NAME + ' (E-ARŞİV)' WHERE ACTION_ID = #get_expense.expense_id# AND ACTION_TYPE_ID = #get_expense.action_type#
                </cfquery>
                <cfquery name="UPD_ACCOUNT_CARD" datasource="#DSN2#">
                    UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_expense.paper_no#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_expense.expense_id# AND ACTION_TYPE = #get_expense.action_type#
                </cfquery>
                <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#DSN2#">
                    UPDATE 
                        ACCOUNT_CARD_ROWS
                    SET 
                        DETAIL = LEFT(REPLACE(DETAIL,'#get_expense.paper_no#','#yeni_fatura_no#'),500)
                    WHERE 
                        CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_expense.expense_id# AND ACTION_TYPE = #get_expense.action_type#)
                </cfquery>
            </cfif>
            <!---  İşlem tamamlandığında ilişki tablosunda belge güncellendi alanını 1 set ediyoruz.--->
            <cfquery name="UPD_INV_REL" datasource="#DSN2#">
                UPDATE EARCHIVE_RELATION SET IS_PAPER_UPDATE = 1 WHERE INTEGRATION_ID = '#new_invoice_number#'
            </cfquery>
            <cfcatch type="any">
                <cfscript>
                    if(isDefined("application.bugLog")){
                        application.bugLog.notifyService(
                            message='#session_base.COMPANY# Şirketinde E-Arşiv Fatura Numaraları Güncellenemedi',
                            exception=cfcatch,
                            AppName='E-GOVERNMENT');
                    }
                </cfscript>
                E-Arşiv Fatura Gönderildi. Fatura Numaraları Güncellenemedi, Lütfen Giden E-Fatura Durum Kontrol Raporunu Çalıştırın!
                <script type="text/javascript">
                    window.opener.location.reload(true);
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    </cfif>

    <cfif not isdefined("attributes.is_multi")>
        <script type="text/javascript">
        <cfif STATUS_CODE eq 1>
            window.opener.location.reload(true);
        </cfif>
         self.close();
            window.opener.openDetails();
        </script>
    </cfif>
</cfif>