<!---
    File: create_multiple_earchive_xml_row.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-arşiv fatura gönderimi
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<cfquery name="GET_MULTIPLE" datasource="#DSN2#">
	SELECT 
    	ROW_NUMBER() OVER (ORDER BY INVOICE_ID) ROW_NUMBER,
    	INVOICE_ID,
        INVOICE_MULTI_ID+#attributes.row_no# INVOICE_MULTI_ID,
        INVOICE_DATE 
    FROM 
    	INVOICE 
    WHERE 
    	INVOICE_ID IN(#attributes.inv_id_list#)
</cfquery>
<cfsetting showdebugoutput="no">
<cfscript>
	zip_xml_count		= get_multiple.recordcount;
	all_count_row		= 0;
	count_row			= 0;
	count_xml_row		= 0;
	array_row			= 0;
	output_type_array	= QueryNew("uuid,output_type","VARCHAR,VARCHAR");
	all_count			= get_multiple.recordcount;
</cfscript>
<table>
	<tr>
		<td><b>Paket</b></td>
		<td><b>Fatura Sayısı</b></td>
	</tr>
	<cfloop query="GET_MULTIPLE">
		<cfset attributes.action_id = GET_MULTIPLE.INVOICE_ID>
		<cfset attributes.action_type = 'INVOICE'>
		<cfset attributes.is_multi = 1>
		<cfinclude template="create_xml_earchive.cfm">
		<cfif (((isdefined("count_row") and count_row eq zip_xml_count) or (isdefined("all_count") and all_count eq all_count_row)) or not isdefined("count_row")) and isdefined("zip_filename")>
		   <cfoutput>
				<tr valign="top">
					<td><a href="javascript://" onclick="open_zip('#zip_filename#')" class="tableyazi">#zip_filename#</a></td>
					<td style="text-align:right">#count_row#</td>
				</tr>
			</cfoutput>
		</cfif>
		<cfif count_row eq zip_xml_count><cfset count_row = 0></cfif>
	</cfloop>
	<!--- Finish:<cfdump var="#now()#"><br> --->
</table>
<script type="text/javascript">
	document.getElementById('inv_count').value = parseInt(document.getElementById('inv_count').value) + 1;
	if(document.getElementById('inv_count').value == "<cfoutput>#attributes.ajax_count#</cfoutput>")
	{
		document.getElementById('send_error').value = 1;
		document.getElementById('send_inv_form').submit();
	}
</script>