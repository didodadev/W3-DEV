<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	SETUP_POS_PAYMETHODS
  		(
        CODE,
        HEADER,
        SYMBOL,
        PAY_LIMIT,
        DECIMAL_COUNT,
        DAILY_RATE,
        PROVISITION,
        PAY_SELECTS,
        RECORD_IP,
        RECORD_EMP,
        RECORD_DATE
        )
        SELECT
            CODE + ' KOPYA',
            HEADER + ' KOPYA',
            SYMBOL,
            PAY_LIMIT,
            DECIMAL_COUNT,
            DAILY_RATE,
            PROVISITION,
            PAY_SELECTS,
            '#cgi.remote_addr#',
            #session.ep.userid#,
            #now()#
        FROM
        	SETUP_POS_PAYMETHODS
        WHERE
    		ROW_ID = #attributes.row_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=retail.list_pos_pay_methods" addtoken="no">