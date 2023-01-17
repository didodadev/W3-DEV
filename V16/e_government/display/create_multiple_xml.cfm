<!---
    File: create_multiple_xml.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-fatura gönderimi
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->
<cf_box title="#getLang('','E-Fatura',29872)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfsetting showdebugoutput="no">
<cfflush interval="10">
<cfif fileExists("#upload_folder#einvoice_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#\multiple_invoice.zip")>
	<cffile action="delete" file="#upload_folder#einvoice_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#/multiple_invoice.zip">
</cfif>

<cfquery name="GET_MULTIPLE" datasource="#DSN2#">
	SELECT INVOICE_ID FROM INVOICE WHERE INVOICE_MULTI_ID = #attributes.action_id#
</cfquery>

<cfif get_multiple.recordcount>
    <cfloop query="GET_MULTIPLE">
        <cfset attributes.action_id = GET_MULTIPLE.INVOICE_ID>
        <cfset attributes.action_type = 'INVOICE'>
        <cfset url.action_id = GET_MULTIPLE.INVOICE_ID>
        <cfset url.action_type = 'INVOICE'>
        <cfset attributes.is_multi = 1>
        <cfinclude template="create_xml.cfm"><br /><br />
        <cfif GET_OUR_COMPANY.EINVOICE_TYPE neq 1 and (not ArrayLen(xml_error_codes) or isdefined("attributes.is_multi_update"))>
			<table>
                <tr>
                    <td><b>E-Fatura ID</b></td>
                    <td><b>Gönderim Tarihi</b></td>
                    <td><b>Fatura Durumu</b></td>
                    <td><b>Fatura Hata Açıklaması</b></td>
                </tr><cfoutput>
                <tr valign="top">
                    <td>#invoice_number#</td>
                    <td style="width:90px;">#DATEFORMAT(NOW(),'DD/MM/YYYY')# #TIMEFORMAT(NOW(),'HH:MM')#</td>
                    <td><cfif SERVICE_RESULT neq 'Successful'><font color="FF0000">#STATUS_DESCRIPTION#</font><cfelse>#STATUS_DESCRIPTION#</cfif></td>
                    <td>#SERVICE_RESULT_DESCRIPTION#</td>
                </tr></cfoutput>
            </table>
        </cfif>
    </cfloop>
	<cfif GET_OUR_COMPANY.EINVOICE_TYPE eq 1><!--- create_xml.cfm den geliyor Portal kullanılıyorsa --->
        <cfzip file="#upload_folder#einvoice_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#/multiple_invoice.zip" source="#directory_name#">
        
        <!--- olusturulan zipleri bir ust klasore tasiyor --->
        <cfdirectory directory="#directory_name#" name="xxxx" action="list">
        
        <cfloop query="xxxx">
            <cffile action="move" source="#xxxx.directory#\#xxxx.NAME#" destination="#upload_folder#einvoice_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#">
        </cfloop>
        <cffile action="delete" file="#directory_name#">
        
        <cfinclude template="../../fbx_download.cfm">
        
        <cfset file_path ="#listgetat(fusebox.server_machine_list,1)#/documents/einvoice_send/#session.ep.company_id#/#year(now())#/#month(now())#">
        <script>
            wrk_down_dosya_ver('<cfoutput>#file_path#/multiple_invoice.zip</cfoutput>','5');
        </script>
    </cfif>
<cfelse>
<br />
   <cf_get_lang dictionary_id='54647.Fatura Bulunamadı'><cf_get_lang dictionary_id='54649.Toplu Faturayı Yeniden Oluşturunuz'>
</cfif>
<cfabort>
</cf_box>