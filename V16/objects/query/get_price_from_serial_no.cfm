<cfsetting showdebugoutput="no">
<cfquery name="GET_SERIAL_NO_PRICES" datasource="#dsn2#">
    SELECT DISTINCT TOP 10 
        SHIP.SHIP_NUMBER,
        SHIP.PARTNER_ID,
        ISNULL(SHIP.OTHER_MONEY,'TL') OTHER_MONEY,
        SHIP.SHIP_DATE,
        (SHIP_ROW.PRICE/SHIP_ROW.AMOUNT) PRICE,
        (SHIP_ROW.PRICE_OTHER/SHIP_ROW.AMOUNT) PRICE_OTHER,
        SERVICE_GUARANTY_NEW.SERIAL_NO,
        CASE 
            WHEN SHIP.EMPLOYEE_ID IS NOT NULL THEN
                E.EMPLOYEE_NAME + ' '+ E.EMPLOYEE_SURNAME
            WHEN SHIP.CONSUMER_ID IS NOT NULL THEN
                C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME
            WHEN SHIP.PARTNER_ID IS NOT NULL THEN
                CP.COMPANY_PARTNER_NAME + ' ' +COMPANY_PARTNER_SURNAME 
        END AS NAME,
        SERVICE_GUARANTY_NEW.PROCESS_CAT
    FROM 
        SHIP
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = SHIP.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SHIP.PARTNER_ID
            LEFT JOIN #dsn_alias#.CONSUMER C ON C.CONSUMER_ID = SHIP.CONSUMER_ID,
        SHIP_ROW,
        #dsn3_alias#.SERVICE_GUARANTY_NEW
    WHERE
        SERVICE_GUARANTY_NEW.PROCESS_ID = SHIP.SHIP_ID AND
        SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
        SERVICE_GUARANTY_NEW.STOCK_ID = SHIP_ROW.STOCK_ID AND
        SERVICE_GUARANTY_NEW.PERIOD_ID = #session.ep.period_id# AND
        SERVICE_GUARANTY_NEW.SERIAL_NO IS NOT NULL
		<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
           AND SERVICE_GUARANTY_NEW.STOCK_ID  = #attributes.stock_id#
        </cfif>
        <cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
	        AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
        </cfif>
    ORDER BY
        SHIP_DATE DESC
</cfquery>

<cf_grid_list>
    <thead>
        <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
        <th><cf_get_lang dictionary_id='57637.Seri No'></th>
        <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
        <th><cf_get_lang dictionary_id='57796.Dövizli'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
    </thead>
    <cfoutput query="get_serial_no_prices" maxrows="10">
        <tbody>
            <tr>
                <td>#name#</td>
                <td>#ship_number# - #get_process_name(process_cat)#</td>
                <td>#serial_no#</td>
                <td><a href="##" onClick="set_opener_money('#price#', '#other_money#')" class="tableyazi">#TLFormat(price,session.ep.our_company_info.sales_price_round_num)#&nbsp;#other_money#</a></td>
                <td>#TLFormat(price_other)#</td>
                <td>#dateformat(ship_date,dateformat_style)#</td>
            </tr>
        </tbody>
    </cfoutput>
</cf_grid_list>
