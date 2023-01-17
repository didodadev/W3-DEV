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
        I.INVOICE_NUMBER = '#attributes.invoice_number#'
</cfquery>
<cfif get_invoice.recordcount>
	<cfquery name="get_rows" datasource="#dsn_dev#">
        SELECT 
            *
        FROM
            INVOICE_ROW_CLOSED IRC
        WHERE
            IRC.INVOICE_ID = #get_invoice.invoice_id# AND
            IRC.PERIOD_ID = #session.ep.period_id#
    </cfquery>
</cfif>
<table style="float:left; padding-left:10px;">
<tr>
<td width="452">
    <cf_form_box title="Fatura - Dönemsel Bağlantı Silme">
    <cfform name="form_basket" action="#request.self#?fuseaction=retail.emptypopup_delete_invoice_relations" method="post">
        <table>
            <tr>
                <td width="75">Fatura No</td>
                <td><cfinput type="text" name="invoice_number" value="#attributes.invoice_number#" readonly="yes"></td>
            </tr>
            <cfif get_invoice.recordcount>
            <tr>
                <td width="75">Fatura Tarihi</td>
                <td><cfinput type="text" name="invoice_date" value="#dateformat(get_invoice.invoice_date,'dd/mm/yyyy')#" readonly="yes"></td>
            </tr>
            <tr>
                <td width="75">Fatura Carisi</td>
                <td>
                <cfinput type="text" name="invoice_company" value="#get_invoice.FULLNAME#" style="width:325px;" readonly="yes">
                <cfinput type="hidden" name="invoice_id" value="#get_invoice.invoice_id#">
                </td>
            </tr>
            </cfif>
        </table>
        <cf_form_box_footer>
        <cfif get_invoice.recordcount>
            <cfif get_rows.recordcount>
                <cfsavecontent variable="message">Fatura Bağlantılarını Sil</cfsavecontent>
                <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' insert_alert='Bu İşlemi Geri Alamazsınız!\nSilmek İstediğinize Emin misiniz?' insert_info='#message#'>
        	<cfelse>
            	<font style="color:red">&nbsp;Faturaya Bağlı Satır Bulunamadı!</font>
            	<input type="button" value="Geri Dön" onclick="history.back();"/>
            </cfif>
        <cfelse>
        	<font style="color:red">&nbsp;İlgili Dönemde Bu Fatura Bulunamadı!</font>
            <input type="button" value="Geri Dön" onclick="history.back();"/>
        </cfif>
        </cf_form_box_footer>
    </cfform>
    </cf_form_box>
</td>
</tr>
</table>