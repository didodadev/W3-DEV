<cfif attributes.type_id gt 0>
    <cfquery name="upd_" datasource="#dsn_dev#">
        UPDATE
            PRICE_TYPES
        SET
            TYPE_NAME = '#attributes.TYPE_NAME#',
            TYPE_CODE = '#attributes.TYPE_CODE#',
            IS_STANDART = <cfif isdefined("attributes.is_standart")>1<cfelse>0</cfif>,
            IS_PURCHASE_SALE = <cfif isdefined("attributes.IS_PURCHASE_SALE")>1<cfelse>0</cfif>,
            IS_CASH_OUT = <cfif isdefined("attributes.IS_CASH_OUT")>1<cfelse>0</cfif>,
            LABEL_TYPE_ID = <cfif len(attributes.label_type_id)>#attributes.label_type_id#<cfelse>NULL</cfif>,
            UPDATE_DATE = #NOW()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.REMOTE_ADDR#'
        WHERE
            TYPE_ID = #attributes.type_id#
    </cfquery>
<cfelse>
	<cfquery name="upd_" datasource="#dsn_dev#">
        INSERT INTO
            PRICE_TYPES
        	(
            TYPE_NAME,
            TYPE_CODE,
            IS_STANDART,
            IS_PURCHASE_SALE,
            IS_CASH_OUT,
            LABEL_TYPE_ID,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
            )
        VALUES
        	(
            '#attributes.TYPE_NAME#',
            '#attributes.TYPE_CODE#',
            <cfif isdefined("attributes.is_standart")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.IS_PURCHASE_SALE")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.IS_CASH_OUT")>1<cfelse>0</cfif>,
            <cfif len(attributes.label_type_id)>#attributes.label_type_id#<cfelse>NULL</cfif>,
            #NOW()#,
            #session.ep.userid#,
            '#cgi.REMOTE_ADDR#'
            )
    </cfquery>
</cfif>
<script>
	window.opener.location.reload();
	window.close();
</script>