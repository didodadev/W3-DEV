<!---
    File: control_earchive.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-arşiv fatura PDF sorgulama
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<cfquery name="get_invoice" datasource="#dsn2#">
	SELECT 
      	I.INVOICE_NUMBER,
        I.INVOICE_ID,
		I.INVOICE_DATE,
        I.UUID
    FROM
        INVOICE I,
        EARCHIVE_RELATION ER,
        EARCHIVE_SENDING_DETAIL SI
    WHERE
        I.INVOICE_MULTI_ID = #attributes.invoice_multi_id# AND
        ER.ACTION_ID = I.INVOICE_ID AND
        ER.ACTION_TYPE = 'INVOICE' AND
        SI.ACTION_ID = I.INVOICE_ID AND
        SI.ACTION_TYPE = 'INVOICE' AND
        I.HOBIM_ID IS NULL AND
        ISNULL(I.IS_PDF,0) = 0 AND
        SI.OUTPUT_TYPE IN('0010','0011','0110','0111') AND
        SI.SENDING_DETAIL_ID = (SELECT MAX(ESD.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID=SI.ACTION_ID AND ESD.ACTION_TYPE = 'INVOICE')
</cfquery>
<cfquery name="GET_COMP_INFO" datasource="#dsn#">
    SELECT
        OC.TAX_NO
    FROM 
        OUR_COMPANY OC
    WHERE 
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset upd_invoice_array = ArrayNew(1)>
<cf_popup_box title="PDF Bulunamayan Faturalar">
	<table>
    <cfset row_count = 0>
	<cfoutput query="get_invoice">
       <cftry>
        	<cffile action="read" file="\\ftpserver\E-Arsiv\ING\#GET_COMP_INFO.TAX_NO#\#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#\#get_invoice.uuid#_#get_invoice.invoice_number#.pdf" variable="pdf_file" > 
			<cfset upd_invoice_array[Arraylen(upd_invoice_array)+1] = "UPDATE INVOICE SET IS_PDF = 1 WHERE INVOICE_ID = #get_invoice.invoice_id#">
            <cfcatch>
				<cfset row_count = row_count+1>
				<cfset upd_invoice_array[Arraylen(upd_invoice_array)+1] = "UPDATE INVOICE SET IS_PDF = 0 WHERE INVOICE_ID = #get_invoice.invoice_id#">
            	<tr>
                	<td>#row_count#</td>
                    <td>#get_invoice.invoice_number#</td>
                </tr>
            </cfcatch>
        </cftry>
    </cfoutput>
    </table>
    <cfif ArrayLen(upd_invoice_array)>
		<cfset upd_invoice_array = ArrayToList(upd_invoice_array,"#chr(13)&chr(10)#")>
        <cfquery name="upd_invoice" datasource="#dsn2#">
            #PreserveSingleQuotes(upd_invoice_array)#
        </cfquery>
    </cfif>
</cf_popup_box>