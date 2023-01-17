<cfif attributes.type eq 0>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT 
        	SUM(COST) AS COST,
            SUM(ISNULL(COST_PAID,0)) AS COST_PAID,
            SUM(COST - ISNULL(COST_PAID,0)) AS KALAN,
            COMPANY_ID,
            PROJECT_ID  
        FROM 
        	PROCESS_ROWS 
        WHERE 
        	ROW_ID IN (#row_list_id#)
        GROUP BY
        	COMPANY_ID,
            PROJECT_ID
    </cfquery>
</cfif>
<cfif attributes.type eq 1>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT 
        	SUM(REVENUE_NET) AS REVENUE_NET,
            SUM(REVENUE_PAID) REVENUE_PAID,
            SUM(REVENUE_NET - ISNULL(REVENUE_PAID,0)) AS KALAN,
            COMPANY_ID,
            PROJECT_ID 
       FROM 
       		INVOICE_REVENUE_ROWS 
       WHERE 
       		C_ROW_ID IN (#listsort(row_list_id,'numeric','ASC')#)
       GROUP BY
        	COMPANY_ID,
            PROJECT_ID
    </cfquery>
</cfif>
<cfif attributes.type eq 2>
	<cfquery name="get_row" datasource="#dsn_dev#">
    	SELECT 
        	SUM(FF_NET) AS FF_NET,
            SUM(FF_PAID) AS FF_PAID,
            SUM(FF_NET - ISNULL(FF_PAID,0)) AS KALAN,
            COMPANY_ID,
            PROJECT_ID 
       	FROM 
        	INVOICE_FF_ROWS 
        WHERE 
        	FF_ROW_ID IN (#row_list_id#)
        GROUP BY
        	COMPANY_ID,
            PROJECT_ID
    </cfquery>
</cfif>
<cfquery name="get_invoices" datasource="#dsn_dev#">
    SELECT DISTINCT INVOICE_ID,PERIOD_ID FROM INVOICE_ROW_CLOSED WHERE TYPE = #attributes.type# AND RELATED_ROW_ID IN (#row_list_id#)
</cfquery>
<cfset fatura_list_ = "">
<cfoutput query="get_invoices">
	<cfset period_id_ = PERIOD_ID>
    <cfquery name="get_p" datasource="#dsn#">
    	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id_#
    </cfquery>
    <cfquery name="get_inv" datasource="#dsn#_#get_p.period_year#_#get_p.our_company_id#">
    	SELECT INVOICE_DATE,INVOICE_NUMBER,INVOICE_ID,INVOICE_CAT FROM INVOICE WHERE INVOICE_ID = #INVOICE_ID#
    </cfquery>
    <cfif get_inv.recordcount>
    	<cfset fatura_list_ = listappend(fatura_list_,'#get_inv.INVOICE_NUMBER#/#dateformat(get_inv.INVOICE_DATE,"dd.mm.yyyy")#/#get_inv.INVOICE_ID#/#get_inv.INVOICE_CAT#')>
    </cfif>
</cfoutput>

<cf_popup_box title="Dönemsel Uygulama İşlemi Gizleme">
<cfform name="upd_" action="#request.self#?fuseaction=retail.emptypopup_hide_action_group_rows" method="post">
<cfinput type="hidden" value="#attributes.type#" name="type">
<cfinput type="hidden" value="#row_list_id#" name="row_list_id">
	<table>
    	<tr>
        	<td class="formbold">İşlem Tipi</td>
            <td>
            	<cfif attributes.type eq 0>Dönemsel Uygulama</cfif>
                <cfif attributes.type eq 1>Ciro Primi</cfif>
                <cfif attributes.type eq 2>Fiyat Farkı</cfif>
            </td>
        </tr>
        <cfoutput>
        <tr>
        	<td class="formbold">Tutar</td>
            <td>
            	<cfif attributes.type eq 0>#tlformat(get_row.COST)#</cfif>
                <cfif attributes.type eq 1>#tlformat(get_row.REVENUE_NET)#</cfif>
                <cfif attributes.type eq 2>#tlformat(get_row.FF_NET)#</cfif>
            </td>
        </tr>
        <tr>
        	<td class="formbold">Kalan</td>
            <td>
            	<cfif attributes.type eq 0>#tlformat(get_row.COST-get_row.COST_PAID)#</cfif>
                <cfif attributes.type eq 1>#tlformat(get_row.REVENUE_NET-get_row.REVENUE_PAID)#</cfif>
                <cfif attributes.type eq 2>#tlformat(get_row.FF_NET-get_row.FF_PAID)#</cfif>
            </td>
        </tr>
        <tr>
        	<td class="formbold">Fatura</td>
            <td>
            	<cfif listlen(fatura_list_)>
                	<cfloop list="#fatura_list_#" index="ccc">
                        #listgetat(ccc,1,'/')# (#listgetat(ccc,2,'/')#) - <b>#get_process_name(listgetat(ccc,4,'/'))#</b>
                        <br />
                    </cfloop>
                </cfif>
            </td>
        </tr>
        </cfoutput>
    </table>
    <input type="submit" value="Gizleme İşlemi Yap"/>
</cfform>
</cf_popup_box>