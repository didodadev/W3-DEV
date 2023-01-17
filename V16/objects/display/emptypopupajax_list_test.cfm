<cfsetting showdebugoutput="no">
<cftry>
    <cfquery name="TestPaperRecord" datasource="workcube_worknet">
        SELECT 
            RECORD_DATE,
            RECORD_EMP,
            CHECK_ID 
        FROM 
            TEST_CHECK_MAIN 
        WHERE
            <cfif  isdefined("attributes.work_id")>
                WORK_ID = #attributes.work_id#
            <cfelse>
            (
                MODUL_SHORT_NAME = '#attributes.modul_short_name#' AND FUSEACTION='#attributes.faction#'
                OR
                    WORK_ID IN
                    (
                        SELECT 
                            WORK_ID
                        FROM  
                            PRO_WORKS PW
                        WHERE 
                            WORK_FUSEACTION = '#attributes.fuseaction#'
                        AND
                            WORK_CIRCUIT='#attributes.modul_short_name#'
                    )
                )
            </cfif>
        ORDER BY 
            RECORD_DATE DESC
    </cfquery>
 	<cfcatch>
    	<cfset TestPaperRecord.recordcount = 0>
    </cfcatch>
</cftry>      
<cf_ajax_list>
<tbody>
<cfif TestPaperRecord.recordcount>
	<cfoutput query="TestPaperRecord">
		<tr id="check_#currentrow#">
			<td  style="text-align:left;" nowrap>
				<a style="cursor:pointer;" class="tableyazi" onClick="windowopen('http://worknet.workcube.com/index.cfm?fuseaction=objects.popup_detail_check_list&check_id=#check_id#','wwide');">#get_emp_info(record_emp,0,0)#&nbsp;(#dateformat(record_date,'dd-mm-yyyy')#&nbsp;#TimeFormat(dateadd("h",session.ep.time_zone,record_date),timeformat_style)#)</a>&nbsp;
			</td>
			<td style="text-align:right;">
                <cfif not listfindnocase(denied_pages,'objects.emptypopup_del_test')>
                    <cfsavecontent variable="silmekicineminmsn"><cf_get_lang dictionary_id='57533.Silmek İstediğinizden Emin Misiniz?'></cfsavecontent>
                    <cfsavecontent variable="sil"><cf_get_lang dictionary_id='57463.Sil'></cfsavecontent>
					<a href="javascript://" class="tableyazi" onClick="javascript:if(confirm('#silmekicineminmsn#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_test&check_id=#check_id#','small'); else return false;"><img src="/images/delete_list.gif" alt="#sil#" title="#sil#"  align="middle" border="0"></a>
				</cfif>
			</td>
		</tr>
	</cfoutput>
<cfelse>
	<cfoutput>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
		</tr>
	</cfoutput>	
</cfif>
</tbody>
</cf_ajax_list>
