<cfquery name="get_hist" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
        IN_OUT_ID,
        START_TIME,
        END_TIME,
        DAY_TYPE,
		ISNULL(UPDATE_DATE,RECORD_DATE) UPDATE_DATE,
		ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,
        WORKTIME_WAGE_STATU
	FROM
		 EMPLOYEES_EXT_WORKTIMES_HISTORY
	WHERE 
		EWT_ID = #attributes.EWT_ID# 
	ORDER BY 
		UPDATE_DATE DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57473.Tarihçe"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif get_hist.recordcount>
		<cfset temp_ = 0>
        <cfoutput query="get_hist">
			<cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(UPDATE_DATE,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#) - #get_emp_info(UPDATE_EMP,0,0)#" is_closed="1">
               <table id="history_#temp_#" style="display:none;">
                    <tbody>
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                            <td>:&nbsp;#get_emp_info(EMPLOYEE_ID,0,0)#</td>
                        </tr>
                        <tr>
                            <td class="bold col col-12">&nbsp;</td>
                            <td>:
                                <cfif DAY_TYPE EQ 0><cf_get_lang dictionary_id='53014.Normal Gün'>
                                <cfelseif DAY_TYPE EQ 1><cf_get_lang dictionary_id='53015.Hafta Sonu'>
                                <cfelseif DAY_TYPE EQ 2><cf_get_lang dictionary_id='53016.Resmi Tatil'>
                                <cfelseif DAY_TYPE EQ 3><cf_get_lang dictionary_id='54251.Gece Çalışması'>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" class="bold col col-12"><cf_get_lang dictionary_id='57742.Tarih'></td>
                            <td>:&nbsp;#dateformat(start_time,dateformat_style)#</td>
                        </tr>
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='30961.Başlangıç Saati'></td>		
                            <td>:&nbsp;#timeformat(start_time,timeformat_style)#</td>
                        </tr>
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='30959.Bitiş Saati'></td>		
                            <td>:&nbsp;#timeformat(end_time,timeformat_style)#</td>
                        </tr>
                    
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='57891.Güncelleyen'></td>
                            <td>:&nbsp;#get_emp_info(UPDATE_EMP,0,0)#</td>
                        </tr>
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='57703.Güncelleme'></td>
                            <td>:&nbsp;#dateformat(UPDATE_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#</td>
                        </tr>
                        <tr>
                            <td class="bold col col-12"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></td>
                            <td>:&nbsp;
                                <cfif WORKTIME_WAGE_STATU eq 1>
                                    <cf_get_lang dictionary_id='63585.Serbest Zaman'>
								<cfelse>
                                    <cf_get_lang dictionary_id='59683.Ucret eklensin'>
                                </cfif>
                            </td>
                        </tr>
                    </tbody>
            </table>
    	</cfoutput>
   	<cfelse>
	<cf_get_lang dictionary_id='57484.Kayıt yok'> !
	</cfif>
</cf_box>
