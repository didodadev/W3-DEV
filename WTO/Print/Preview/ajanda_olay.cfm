<!--- Standart Ajanda Olay --->
<cfquery name="get_result" datasource="#DSN#">
	SELECT 
    	RECORD_EMP,
        RECORD_DATE,
        EVENT_RESULT 
	FROM 
		EVENT_RESULT 
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.action_id#">
</cfquery>
<cfif get_result.Recordcount>
<table style="height:295mm;width:195mm;">
	<tr>
		<td style="width:5mm;" rowspan="30">&nbsp;</td>
		<td style="height:20mm;">&nbsp;</td>
	</tr>
	<tr>
		<td valign="top">
            <table width="99%" border="0" cellpadding="3" cellspacing="0">
                <tr>
                    <td style="width:130mm;">&nbsp;</td>
                    <td>
                        <table>
                            <cfoutput>
                                <tr>
                                    <td><strong><cf_get_lang_main no='71.Kayit'>:&nbsp;</strong>#get_emp_info(get_result.record_emp,0,0)#</td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong><cf_Get_lang_main no='215.Kayit Tarihi'>: &nbsp;</strong>
                                        #dateformat(dateadd('h',session.ep.time_zone,get_result.record_date),dateformat_style)# 
                                        #timeformat(dateadd('h',session.ep.time_zone,get_result.record_date),timeformat_style)#
                                    </td>
                                </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                    <td align="center" colspan="2"><strong><font style="font-size:12px;"><cf_get_lang_main no='3.Ajanda'> <cf_get_lang_main no='179.Olay Tutanağı'></font></strong></td>
                </tr>
                <tr style="height:150mm;">
                    <td valign="top" colspan="2"> <cfoutput>#get_result.event_result#</cfoutput></td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</cfif>
