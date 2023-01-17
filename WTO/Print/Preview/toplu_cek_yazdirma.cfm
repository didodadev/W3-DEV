<!--- standart toplu cek yazdirma 20131024 --->
<cfsetting showdebugoutput="no">
<cfquery name="Get_Cheques" datasource="#dsn2#">
	SELECT
		CHEQUE.COMPANY_ID,
		CHEQUE.CHEQUE_CITY,
		CHEQUE.CHEQUE_DUEDATE,
		CHEQUE.CHEQUE_VALUE,
		CHEQUE.CURRENCY_ID,
		CHEQUE.ENDORSEMENT_MEMBER
	FROM
		CHEQUE
	WHERE 
		CHEQUE.CHEQUE_ID IN (#attributes.action_id#)
		ORDER BY CHEQUE.CHEQUE_ID ASC
</cfquery>
<style>
	table,td{font-size:12px;}
	.font{font-size:11px;}
</style>
<cfloop query="Get_Cheques">
<table border="0" cellpadding="0" cellspacing="0" style="width:210mm;height:76mm">
    <tr><td style="width:22mm;" rowspan="20">&nbsp;</td></tr> 
    <tr>
        <td style="width:5mm;">&nbsp;</td>
        <td valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="width:170mm;height:58mm;">
            <tr>
                <td style="width:66mm;height:12mm;" valign="top"><br>&nbsp;</td>
                <td style="width:70mm;height:19mm;text-align:left;" valign="top">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr style="height:5mm;">
                            <td style="width:60mm;text-align:center;" colspan="2" valign="top">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; IST <cfoutput>#dateformat(Get_Cheques.cheque_duedate,dateformat_style)#</cfoutput></td>
                            <td style="width:10mm;">&nbsp;</td>
                        </tr>
                        <tr style="height:5mm;">
                        	<td style="width:60mm; text-align:center;" colspan="2"><!---<cfoutput>#dateformat(Get_Cheques.cheque_duedate,dateformat_style)#</cfoutput>---></td>
                            <td style="width:10mm;">&nbsp;</td>
						</tr>
                        <tr style="height:5mm;">
                            <td style="width:60mm;text-align:left;" colspan="2" valign="top">#<cfoutput>#TLFormat(Get_Cheques.cheque_value)#</cfoutput>#</td>
                            <td style="width:10mm;">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height:20mm" colspan="2" valign="top">
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr style="height:6mm;">
                        <td style="width:100mm;" valign="top">
                            <cfif len(Get_Cheques.company_id)>
                                <cfoutput> #get_par_info(Get_Cheques.company_id,1,1,0)# </cfoutput>
                            <cfelse>
                                <cf_get_lang no='96.Hamiline'>
                            </cfif>
                        </td>
                    </tr>
                    <tr style="height:6mm">
                        <td style="width:150mm;" colspan="2">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="height:6mm;" valign="top" style="font-size:11px;">
                                    <cfset txt_total_value = Get_Cheques.cheque_value>
                                    # <cfif txt_total_value gt 999999.99 and txt_total_value lt 2000000>Bir</cfif>
                                    <cfoutput><cf_n2txt number="txt_total_value"> #txt_total_value#</cfoutput>
                                </td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                <table border="0">
                    <tr>
                        <td style="width:20mm;">&nbsp;</td>
                        <td style="width:90mm;height:7mm;" valign="bottom">&nbsp;</td>
                    </tr>
                </table>
                </td>
            </tr>      
        </table>
        </td>
    </tr>
</table>
</cfloop>
