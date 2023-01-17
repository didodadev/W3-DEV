<cfquery name="get_invoice" datasource="#dsn2#">
	SELECT
    	I.INVOICE_DATE,
        C.FULLNAME,
        I.INVOICE_ID
    FROM
    	INVOICE I,
        #dsn_alias#.COMPANY C
    WHERE
    	I.COMPANY_ID = C.COMPANY_ID AND
        I.INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfset attributes.action_id = attributes.invoice_id>

<cfquery name="add_" datasource="#dsn_Dev#">
	INSERT INTO
    	INVOICE_ROW_CLOSED_DELETES
        (
        ROW_ID,
        INVOICE_ID,
        PERIOD_ID,
        INVOICE_ROW_ID,
        WRK_ROW_ID,
        TYPE,
        RELATED_ROW_ID,
        PAID_COST,
        CODE,
        RECORD_EMP,
        RECORD_DATE,
        DELETE_EMP,
        DELETE_DATE
        )
        SELECT
        	ROW_ID,
            INVOICE_ID,
            PERIOD_ID,
            INVOICE_ROW_ID,
            WRK_ROW_ID,
            TYPE,
            RELATED_ROW_ID,
            PAID_COST,
            CODE,
            RECORD_EMP,
            RECORD_DATE,
            #session.ep.userid#,
            #now()#
        FROM
        	INVOICE_ROW_CLOSED
        WHERE
        	INVOICE_ID = #attributes.invoice_id# AND
        	PERIOD_ID = #session.ep.period_id#
</cfquery>

<cfquery name="get_rows_donem" datasource="#dsn_dev#">
    SELECT * FROM INVOICE_ROW_CLOSED WHERE INVOICE_ID = #attributes.action_id# AND PERIOD_ID = #session.ep.period_id# AND TYPE = 0
</cfquery>

<cfquery name="get_rows_ciro" datasource="#dsn_dev#">
    SELECT * FROM INVOICE_ROW_CLOSED WHERE INVOICE_ID = #attributes.action_id# AND PERIOD_ID = #session.ep.period_id# AND TYPE = 1
</cfquery>

<cfquery name="get_rows_ff" datasource="#dsn_dev#">
    SELECT * FROM INVOICE_ROW_CLOSED WHERE INVOICE_ID = #attributes.action_id# AND PERIOD_ID = #session.ep.period_id# AND TYPE = 2
</cfquery>

<cfquery name="upd_" datasource="#dsn_dev#">
    DELETE FROM INVOICE_ROW_CLOSED WHERE INVOICE_ID = #attributes.action_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>

<cfif get_rows_donem.recordcount>
    <cfquery name="upd_" datasource="#dsn_dev#">
        UPDATE
            PROCESS_ROWS
        SET
            COST_PAID = ISNULL((SELECT SUM(IRC.PAID_COST) FROM INVOICE_ROW_CLOSED IRC WHERE IRC.TYPE = 0 AND IRC.RELATED_ROW_ID = PROCESS_ROWS.ROW_ID),0)
        WHERE
            ROW_ID IN (#valuelist(get_rows_donem.RELATED_ROW_ID)#)
    </cfquery>
</cfif>

<cfif get_rows_ciro.recordcount>
    <cfquery name="upd_" datasource="#dsn_dev#">
        UPDATE
            INVOICE_REVENUE_ROWS
        SET
            REVENUE_PAID = ISNULL((SELECT SUM(IRC.PAID_COST) FROM INVOICE_ROW_CLOSED IRC WHERE IRC.TYPE = 1 AND IRC.RELATED_ROW_ID = INVOICE_REVENUE_ROWS.C_ROW_ID),0)
        WHERE
            C_ROW_ID IN (#valuelist(get_rows_ciro.RELATED_ROW_ID)#)
    </cfquery>
</cfif>

<cfif get_rows_ff.recordcount>
    <cfquery name="upd_" datasource="#dsn_dev#">
        UPDATE
            INVOICE_FF_ROWS
        SET
            FF_PAID = ISNULL((SELECT SUM(IRC.PAID_COST) FROM INVOICE_ROW_CLOSED IRC WHERE IRC.TYPE = 2 AND IRC.RELATED_ROW_ID = INVOICE_FF_ROWS.FF_ROW_ID),0)
        WHERE
            FF_ROW_ID IN (#valuelist(get_rows_ff.RELATED_ROW_ID)#)
    </cfquery>
</cfif>

<cfquery name="del_" datasource="#dsn_dev#">
	DELETE FROM INVOICE_ROW_CLOSED
    	WHERE
    		INVOICE_ID = #attributes.invoice_id# AND
        	PERIOD_ID = #session.ep.period_id#
</cfquery>
<script>
	alert('İşlemler Tamamlandı');
	window.location.href = 'index.cfm?fuseaction=retail.delete_invoice_relations';
</script>
<cfabort>