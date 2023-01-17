<cfif attributes.ROWSCOUNT lte 1>
	<script>
		alert('İşlem Yapılacak Kart Girmediniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>

<cfquery name="add_" datasource="#dsn_dev#" result="add_point">
	INSERT INTO
    	GENIUS_POINT_ADDS
        (
        WRK_ID,
        RECORD_EMP,
        RECORD_DATE,
        DETAIL,
        IS_CLEAR
        )
        VALUES
        (
        '#wrk_id#',
        #session.ep.userid#,
        #now()#,
        '#attributes.detail#',
        <cfif isdefined("attributes.is_clear")>1<cfelse>0</cfif>
        )
</cfquery>

<cfloop from="2" to="#attributes.ROWSCOUNT#" index="ppp">
	<cfset add_ = evaluate("attributes.puan_ekle_#ppp#")>
    <cfset del_ = evaluate("attributes.puan_cikar_#ppp#")>
    <cfset card_no_ = wrk_eval("attributes.card_no_#ppp#")>
    <cfquery name="add_rows_" datasource="#dsn_dev#">
    	INSERT INTO
        	GENIUS_POINT_ADDS_ROWS
            (
            ROW_ID,
            WRK_ID,
            CARD_NO,
            ADD_POINT,
            DEL_POINT
            )
            VALUES
            (
            #add_point.IDENTITYCOL#,
            '#wrk_id#',
            '#card_no_#',
            <cfif len(add_)>#filternum(add_)#<cfelse>0</cfif>,
            <cfif len(del_)>#filternum(del_)#<cfelse>0</cfif>
            )
    </cfquery>
    <cfquery name="get_card_info" datasource="#dsn_gen#">
        SELECT * FROM CARD WHERE CODE = '#card_no_#'
    </cfquery>
	<cfif get_card_info.recordcount><!--- geniusta kart var mı --->
    	<cfif len(add_)>
            <cfquery name="get_cons_info" datasource="#dsn_gen#">
                SELECT * FROM CUSTOMER WHERE ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
           <cfquery name="upd_" datasource="#dsn_gen#">
                UPDATE
                    CUSTOMER
                SET
                    BONUS = #get_cons_info.BONUS + filternum(add_)#
                WHERE
                    ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
            <cfquery name="get_cons_info" datasource="#dsn_gen#">
                SELECT * FROM CUSTOMER WHERE ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
        </cfif>
        
        <cfif len(del_)>
            <cfquery name="get_cons_info" datasource="#dsn_gen#">
                SELECT * FROM CUSTOMER WHERE ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
            <cfquery name="upd_" datasource="#dsn_gen#">
                UPDATE
                    CUSTOMER
                SET
                    BONUS = #get_cons_info.BONUS - filternum(del_)#
                WHERE
                    ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
        </cfif>
        
        <cfif isdefined("attributes.is_clear")>
            <cfquery name="upd_" datasource="#dsn_gen#">
                UPDATE
                    CUSTOMER
                SET
                    BONUS = 0
                WHERE
                    ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
        </cfif>
        
        <cfif not isdefined("attributes.is_clear")>
            <cfif len(add_) and filternum(add_) gt 0>
            	<cfquery name="GET_MAX_ID" datasource="#DSN_GEN#">
                    SELECT MAX(ID) MAX_ID FROM CUSTOMER_BONUS 
                </cfquery>
                <cfset bonus_max_id = get_max_id.max_id + 1>
                <cfquery name="add_" datasource="#dsn_gen#">
                    INSERT INTO
                        CUSTOMER_BONUS
                        (
                        ID,
                        AMOUNT,
                        FK_CARD,
                        FK_POS,
                        FK_REASON_TYPE,
                        FK_STORE,
                        POS_SEQUENCE_NUMBER,
                        POS_TRANSACTION_DATE,
                        TRANSACTION_DATE,
                        WRK_ID,
                        CHEQUE_RETURN_PARAM
                        )
                        VALUES
                        (
                        #bonus_max_id#,
                        #filternum(add_)#,
                        #get_card_info.ID#,
                        0,
                        1,
                        0,
                        0,
                        0,
                        #createODBCDate(now())#,
                        '#wrk_id#',
                        ''
                        )
                </cfquery>
                <cfquery name="upd_" datasource="#DSN_GEN#">
                    UPDATE
                        SEQUENCE
                    SET
                        ID = #bonus_max_id#,
                        UPDATESEQ = #bonus_max_id#
                    WHERE
                        DESCRIPTION = 'CUSTOMER_BONUS'
                </cfquery>
            </cfif>
            <cfif len(del_) and filternum(del_) gt 0>
                <cfquery name="GET_MAX_ID" datasource="#DSN_GEN#">
                    SELECT MAX(ID) MAX_ID FROM CUSTOMER_BONUS 
                </cfquery>
                <cfset bonus_max_id = get_max_id.max_id + 1>
                <cfquery name="add_" datasource="#dsn_gen#">
                    INSERT INTO
                        CUSTOMER_BONUS
                        (
                        ID,
                        AMOUNT,
                        FK_CARD,
                        FK_POS,
                        FK_REASON_TYPE,
                        FK_STORE,
                        POS_SEQUENCE_NUMBER,
                        POS_TRANSACTION_DATE,
                        TRANSACTION_DATE,
                        WRK_ID,
                        CHEQUE_RETURN_PARAM
                        )
                        VALUES
                        (
                        #bonus_max_id#,
                        #filternum(del_)#,
                        #get_card_info.ID#,
                        0,
                        2,
                        0,
                        0,
                        0,
                        #createODBCDate(now())#,
                        '#wrk_id#',
                        ''
                        )
                </cfquery>
                <cfquery name="upd_" datasource="#DSN_GEN#">
                    UPDATE
                        SEQUENCE
                    SET
                        ID = #bonus_max_id#,
                        UPDATESEQ = #bonus_max_id#
                    WHERE
                        DESCRIPTION = 'CUSTOMER_BONUS'
                </cfquery>
            </cfif>
        </cfif>
   </cfif>
</cfloop>
<script>
	alert('İşlemler Tamamlandı');
	window.location.href = 'index.cfm?fuseaction=retail.card_multi_list';
</script>
<cfabort>