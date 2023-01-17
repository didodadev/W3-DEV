<cfquery name="get_hist" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
        IN_OUT_ID,
        START_DATE,
        FINISH_DATE,
        DAY_TYPE,
		ISNULL(UPDATE_DATE,RECORD_DATE) UPDATE_DATE,
		ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,
        DETAIL,
        IS_WEEK_REST_DAY
	FROM
		 EMPLOYEE_DAILY_IN_OUT_HISTORY
	WHERE 
		ROW_ID = #attributes.row_id# 
	ORDER BY 
		UPDATE_DATE DESC
</cfquery>
<cf_popup_box title="<cf_get_lang dictionary_id='57473.Tarihçe'>">
	<cfif get_hist.recordcount>
		<cfset temp_ = 0>
        <cfoutput query="get_hist">
			<cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(UPDATE_DATE,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#) - #get_emp_info(UPDATE_EMP,0,0)#" is_closed="1">
           	<table id="history_#temp_#" style="display:none;">
				<tr>
                    <td><cf_get_lang dictionary_id="57576.Çalışan"></td>
                    <td>#get_emp_info(EMPLOYEE_ID,0,0)#</td>
				</tr>
                <tr>
                    <td><cf_get_lang dictionary_id="29496.Gün Tipi"></td>
                    <td>
						<cfif not Len(get_hist.IS_WEEK_REST_DAY)>Çalışma Günü
                        <cfelseif get_hist.IS_WEEK_REST_DAY eq 0>Hafta Tatili
                        <cfelseif get_hist.IS_WEEK_REST_DAY eq 1>Genel Tatil
                        <cfelseif get_hist.IS_WEEK_REST_DAY eq 2>Genel Tatil Hafta Tatili
                        <cfelseif get_hist.IS_WEEK_REST_DAY eq 3>Ücretli İzin Hafta Tatili
                        <cfelseif get_hist.IS_WEEK_REST_DAY eq 4>Ücretsiz İzin Hafta Tatili
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td width="60"><cf_get_lang dictionary_id="57628.Giriş Tarihi"></td>
                    <td>#dateformat(get_hist.start_date,dateformat_style)# - #timeformat(get_hist.start_date,timeformat_style)#</td>
                </tr>
                <tr>
                	<td><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></td>		
                    <td>#dateformat(get_hist.finish_date,dateformat_style)# - #timeformat(get_hist.finish_date,timeformat_style)#</td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id="57629.Açıklama"></td>
                    <td>#get_hist.detail#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57891.Güncelleyen'></td>
                    <td>#get_emp_info(UPDATE_EMP,0,0)#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57703.Güncelleme'></td>
                    <td>#dateformat(UPDATE_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#</td>
                </tr>
            </table>
    	</cfoutput>
   	<cfelse>
	<cf_get_lang dictionary_id="58486.Kayıt yok">!
	</cfif>
</cf_popup_box>
