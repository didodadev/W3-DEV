<cfquery name="GET_MAX_ID" datasource="#DSN_GEN#">
	SELECT MAX(ID) MAX_ID FROM CUSTOMER_BONUS 
</cfquery>
<cfset bonus_max_id = get_max_id.max_id + 1>

<cfquery name="get_cus_cards" datasource="#dsn_gen#">
    SELECT CODE,ID,FK_CUSTOMER FROM CARD WHERE CODE = '#attributes.card#'
</cfquery>
<cfset card_no_ = attributes.card>

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
            '',
            0
        )
</cfquery>

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
            <cfif attributes.type eq 1>#attributes.amount#<cfelse>0</cfif>,
            <cfif attributes.type eq 2>#attributes.amount#<cfelse>0</cfif>
        )
</cfquery>

<cfquery name="bonus_ekle" datasource="#DSN_GEN#">
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
        #attributes.amount#,
        #get_cus_cards.ID#,
        0,
        #attributes.type#,
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

<!---
<cfquery name="get_card_bonus" datasource="#dsn_gen#">
	SELECT BONUS FROM CARD WHERE CODE = '#card_no_#'
</cfquery>
<cfif get_card_bonus.recordcount and len(get_card_bonus.BONUS)>
	<cfset eski_total = get_card_bonus.BONUS>
<cfelse>
	<cfset eski_total = 0>
</cfif>

<cfquery name="upd_" datasource="#dsn_gen#">
	UPDATE
    	CARD
    SET
    	BONUS = <cfif attributes.type eq 1>#eski_total + attributes.amount#<cfelse>#eski_total - attributes.amount#</cfif>
    WHERE
    	CODE = '#card_no_#'
</cfquery>
--->
<cfquery name="get_card_bonus" datasource="#dsn_gen#">
	SELECT BONUS FROM CUSTOMER WHERE ID = #get_cus_cards.FK_CUSTOMER#
</cfquery>
<cfif get_card_bonus.recordcount and len(get_card_bonus.BONUS)>
	<cfset eski_total = get_card_bonus.BONUS>
<cfelse>
	<cfset eski_total = 0>
</cfif>

<cfquery name="upd_" datasource="#dsn_gen#">
	UPDATE
    	CUSTOMER
    SET
    	BONUS = <cfif attributes.type eq 1>#eski_total + attributes.amount#<cfelse>#eski_total - attributes.amount#</cfif>
    WHERE
    	ID = #get_cus_cards.FK_CUSTOMER#
</cfquery>

<script type="text/javascript">
	//wrk_opener_reload();
	//window.close();
    alert('Kayıt yapıldı');
    history.back();
</script>