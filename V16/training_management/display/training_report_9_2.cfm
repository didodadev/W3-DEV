<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
    <tr>
    	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
    </tr>
    <tr>
        <td valign="top" height="100%">
            <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<cfif isdefined("attributes.kapak_bas")>
                    <tr>
                        <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
                    </tr>
                <cfelse>
                    <tr>
                        <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='37.Eğitim Sonucu'></font></td>
                    </tr>
                </cfif>
            </table>
            <table>
                <cfloop list="#attributes.class_id_list#" index="i">
                    <cfset attributes.class_id= i>
                    <cfinclude template="../query/get_report_queries.cfm">
                    <cfinclude template="../query/get_upd_class_queries.cfm">
                    <cfquery name="get_result" datasource="#DSN#">
                    	SELECT 
                        	* 
                        FROM 
                        	TRAINING_CLASS_RESULT_REPORT 
                        WHERE 
                        	CLASS_ID = #attributes.CLASS_ID#
                    </cfquery>
                    <tr>
                        <td>&nbsp;<cfoutput>#get_class.class_name#</cfoutput></td>
                        <td>
                        	<cfoutput>#get_result.RESULT_DETAIL#</cfoutput>
                        </td>
                    </tr>
                </cfloop>
            </table>
        </td>
    </tr>
    <tr>
    	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
    </tr>
</table>
