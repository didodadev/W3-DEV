    <cfif attributes.type eq 0>
        <cfquery name="get_row" datasource="#dsn_dev#">
                UPDATE
                    PROCESS_ROWS 
                SET
                	STATUS = 0
                WHERE 
                    ROW_ID IN (#row_list_id#)
            </cfquery>
        </cfif>
    <cfif attributes.type eq 1>
        <cfquery name="get_row" datasource="#dsn_dev#">
           UPDATE 
                INVOICE_REVENUE_ROWS
           SET
                STATUS = 0 
           WHERE 
                C_ROW_ID IN (#listsort(row_list_id,'numeric','ASC')#)
        </cfquery>
    </cfif>
	<cfif attributes.type eq 2>
        <cfquery name="get_row" datasource="#dsn_dev#">
            UPDATE
            	INVOICE_FF_ROWS
            SET
            	STATUS = 0 
            WHERE 
                FF_ROW_ID IN (#row_list_id#)
        </cfquery>
    </cfif>
<script>
	alert('Gizleme İşlemleri Tamamlandı!');
	window.close();
</script>
<cfabort>