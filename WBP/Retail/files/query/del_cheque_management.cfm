<cf_date tarih = "attributes.action_startdate">
<cf_date tarih = "attributes.action_finishdate">
<cf_date tarih = "attributes.action_islem_tarihi">
<cftransaction>
    <cfquery name="get_table" datasource="#dsn_Dev#">
        SELECT TABLE_ID FROM PAYMENT_TABLE WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfquery name="del_" datasource="#dsn_dev#">
        DELETE FROM PAYMENT_TABLE_ROWS WHERE TABLE_ID = #get_table.TABLE_ID#
    </cfquery>
    <cfquery name="del_" datasource="#dsn_dev#">
        DELETE FROM PAYMENT_TABLE_GROUPS WHERE TABLE_ID = #get_table.TABLE_ID#
    </cfquery>
    <cfquery name="del_" datasource="#dsn_dev#">
        DELETE FROM PAYMENT_TABLE WHERE TABLE_ID = #get_table.TABLE_ID#
    </cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=retail.list_cheque_management" addtoken="no">