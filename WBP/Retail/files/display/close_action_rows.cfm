<cfif attributes.action_type eq 0>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT COST,ISNULL(COST_PAID,0) AS COST_PAID,COST - ISNULL(COST_PAID,0) AS KALAN,COMPANY_ID,PROJECT_ID  FROM PROCESS_ROWS WHERE ROW_ID = #action_id#
    </cfquery>
</cfif>
<cfif attributes.action_type eq 1>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT *,REVENUE_NET - ISNULL(REVENUE_PAID,0) AS KALAN FROM INVOICE_REVENUE_ROWS WHERE C_ROW_ID = #action_id#
    </cfquery>
</cfif>
<cfif attributes.action_type eq 2>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT *,FF_NET - ISNULL(FF_PAID,0) AS KALAN FROM INVOICE_FF_ROWS WHERE FF_ROW_ID = #action_id#
    </cfquery>
</cfif>

<cfquery name="get_invoice" datasource="#dsn2#">
	SELECT 
    	I.INVOICE_NUMBER,
        I.INVOICE_DATE 
   	FROM 
    	#dsn_dev_alias#.INVOICE_ROW_CLOSED IRC,
        INVOICE I 
    WHERE 
    	I.INVOICE_ID = IRC.INVOICE_ID AND
        IRC.TYPE = #attributes.action_type# AND
        IRC.RELATED_ROW_ID = #attributes.action_id#
</cfquery>
<cf_popup_box title="Dönemsel Uygulama İşlemi Bağlama">
	<table>
    	<tr>
        	<td class="formbold">İşlem Tipi</td>
            <td>
            	<cfif attributes.action_type eq 0>Dönemsel Uygulama</cfif>
                <cfif attributes.action_type eq 1>Ciro Primi</cfif>
                <cfif attributes.action_type eq 2>Fiyat Farkı</cfif>
            </td>
        </tr>
        <cfoutput>
        <tr>
        	<td class="formbold">Tutar</td>
            <td>
            	<cfif attributes.action_type eq 0>#tlformat(get_row.COST)#</cfif>
                <cfif attributes.action_type eq 1>#tlformat(get_row.REVENUE_NET)#</cfif>
                <cfif attributes.action_type eq 2>#tlformat(get_row.FF_NET)#</cfif>
            </td>
        </tr>
        <tr>
        	<td class="formbold">Kalan</td>
            <td>
            	<cfif attributes.action_type eq 0>#tlformat(get_row.COST-get_row.COST_PAID)#</cfif>
                <cfif attributes.action_type eq 1>#tlformat(get_row.REVENUE_NET-get_row.REVENUE_PAID)#</cfif>
                <cfif attributes.action_type eq 2>#tlformat(get_row.FF_NET-get_row.FF_PAID)#</cfif>
            </td>
        </tr>
        </cfoutput>
        <tr>
        	<td class="formbold">Fatura</td>
            <td>
            	<cfif get_invoice.recordcount>
                	<cfoutput query="get_invoice">#get_invoice.invoice_number# (#dateformat(get_invoice.invoice_date,'dd/mm/yyyy')#)</cfoutput>
                </cfif>
            </td>
        </tr>
    </table>
</cf_popup_box>