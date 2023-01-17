<!---
    File: create_multiple_earchive_xml.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-arşiv fatura gönderimi
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->
<cfset ajax_count = 1>
<cfset zip_xml_count = 100>
<cfset row_count = ajax_count*zip_xml_count>
<cfquery name="GET_MULTIPLE" datasource="#DSN2#" maxrows="#row_count#">
	SELECT 
		ROW_NUMBER() OVER (ORDER BY INVOICE_ID) ROW_NUMBER,
		INVOICE_ID,
		INVOICE_MULTI_ID,
		INVOICE_DATE 
	FROM 
		INVOICE
	WHERE 
		INVOICE_MULTI_ID = #attributes.action_id# 
		AND INVOICE_ID NOT IN(SELECT ACTION_ID FROM EARCHIVE_RELATION WHERE ACTION_TYPE = 'INVOICE')
        <cfif isdefined("attributes.send_error") and attributes.send_error eq 1>
			AND INVOICE_ID NOT IN(SELECT ACTION_ID FROM EARCHIVE_SENDING_DETAIL WHERE ACTION_TYPE = 'INVOICE')
        </cfif>
	ORDER BY 
		INVOICE_ID
</cfquery>
<cfset main_multi_id = attributes.action_id>
<cfif get_multiple.recordcount mod zip_xml_count eq 0>
	<cfset loop_count = int(get_multiple.recordcount/zip_xml_count)>
<cfelse>
	<cfset loop_count = int(get_multiple.recordcount/zip_xml_count)+1>
</cfif>
<cf_box title="#getLang('','E-Arşiv',64127)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="send_inv_form" id="send_inv_form" action="">
    <table width="100%">
    <input type="hidden" name="send_error" id="send_error" value="<cfif isdefined("attributes.send_error")><cfoutput>#attributes.send_error#</cfoutput></cfif>">
    <input type="hidden" name="inv_count" id="inv_count" value="0">
   <!---  Start:<cfdump var="#now()#"><br> --->
    <cfif get_multiple.recordcount>
        <cfoutput>
            <cfloop from="1" to="#loop_count#" index="loop_index">
                <cfset startrow = (loop_index-1)*zip_xml_count+1>
                <cfset finishrow = (loop_index-1)*zip_xml_count+zip_xml_count>
                <cfquery name="get_row" dbtype="query">
                    SELECT * FROM GET_MULTIPLE WHERE ROW_NUMBER BETWEEN #startrow# AND #finishrow#
                </cfquery>
                <cfset "row_invoice_list_#loop_index#" = valuelist(get_row.invoice_id)>
                <tr id="inv_detail_#loop_index#" valign="top" height="22">
                    <td colspan="2">
                        <div id="inv_detail_#loop_index#_"></div>
                    </td>
                </tr>
                <cfif listlen(evaluate("row_invoice_list_#loop_index#"))>
                    <script type="text/javascript">
                        AjaxPageLoad('#request.self#?fuseaction=invoice.emptypopup_create_multiple_earchive_xml_row&ajax_count=#ajax_count#&main_multi_id=#main_multi_id#&zip_xml_count=#zip_xml_count#&row_no=#loop_index#&inv_id_list=#evaluate("row_invoice_list_#loop_index#")#','inv_detail_#loop_index#_',1,'Faturalar Gönderiliyor');	
                    </script>
                </cfif>
            </cfloop>
        </cfoutput>
    <cfelse>
        <br />
        <cf_get_lang dictionary_id="30505.Tüm faturalar gönderildi , listeden hata alan faturaları kontrol ediniz"> !
    </cfif>
    </table>
    </cfform>
</cf_box>
<script type="text/javascript">
	<cfif get_multiple.recordcount>
		function open_zip(file_name)
		{
			file_= "<cfoutput>documents/earchive_send/#session.ep.company_id#/#session.ep.period_year#/#numberformat(month(get_multiple.invoice_date),00)#/zip/</cfoutput>"+file_name;
			get_wrk_message_div("<cfoutput>#getLang('main',1931)#</cfoutput>","Zip",file_)
		}
	</cfif>
</script>
