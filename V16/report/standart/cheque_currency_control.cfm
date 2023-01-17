<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfquery name="get_cheques" datasource="#dsn2#">
    SELECT 
    	CHEQUE.CHEQUE_ID,
    	CHEQUE.CHEQUE_NO,
        CHEQUE.CHEQUE_DUEDATE,
        ISNULL(CHEQUE_HISTORY.ACT_DATE,CHEQUE_HISTORY.RECORD_DATE) AS ACT_DATE,
        CHEQUE.CHEQUE_STATUS_ID,
        CHEQUE_HISTORY.STATUS,
        CHEQUE.CHEQUE_VALUE,
        CHEQUE.CURRENCY_ID,
        CHEQUE.OTHER_MONEY_VALUE,
        CHEQUE.OTHER_MONEY,
        ISNULL(CHEQUE.OTHER_MONEY_VALUE2,CHEQUE.OTHER_MONEY_VALUE) OTHER_MONEY_VALUE2,
        ISNULL(CHEQUE.OTHER_MONEY2,CHEQUE.OTHER_MONEY) OTHER_MONEY2,
		(SELECT ISNULL(CHH.ACT_DATE,CHH.RECORD_DATE) FROM CHEQUE_HISTORY CHH WHERE CHH.HISTORY_ID = (SELECT MIN(C_H.HISTORY_ID) FROM CHEQUE_HISTORY C_H WHERE C_H.CHEQUE_ID = CHEQUE.CHEQUE_ID)) AS ACT_DATE1,
        CHEQUE_HISTORY.OTHER_MONEY_VALUE AS HISTORY_VALUE,
        CHEQUE_HISTORY.OTHER_MONEY AS HISTORY_MONEY,
        ISNULL(CHEQUE_HISTORY.OTHER_MONEY_VALUE2,CHEQUE_HISTORY.OTHER_MONEY_VALUE) AS HISTORY_VALUE2,
        ISNULL(CHEQUE_HISTORY.OTHER_MONEY2,CHEQUE_HISTORY.OTHER_MONEY) AS HISTORY_MONEY2,
        CHEQUE.COMPANY_ID,
        CHEQUE.CONSUMER_ID
    FROM
    	CHEQUE,
        CHEQUE_HISTORY
    WHERE  
    	CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID AND
		(CHEQUE_HISTORY.STATUS = 3  OR CHEQUE_HISTORY.STATUS = 4)
    ORDER BY
    	CHEQUE.CHEQUE_DUEDATE
</cfquery>
<cfset company_id_list = ''>
<cfset consumer_id_list = ''>
<cfif get_cheques.recordcount>
	<cfoutput query="get_cheques">
		<cfif len(COMPANY_ID) and not listfind(company_id_list,COMPANY_ID)>
			<cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
		</cfif>
        <cfif len(CONSUMER_ID) and not listfind(consumer_id_list,CONSUMER_ID)>
			<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
		</cfif>
	</cfoutput> 
	<cfif len(company_id_list)>
		<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT FULLNAME	FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
		</cfquery>
	</cfif>
    <cfif len(consumer_id_list)>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfquery name="get_consumer" datasource="#dsn#">
			SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
		</cfquery>
	</cfif>
</cfif>
<cfquery name="get_money_history" datasource="#dsn#">
	SELECT 
	    MONEY_HISTORY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        VALIDATE_DATE, 
        COMPANY_ID, 
        PERIOD_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP
    FROM 
    	MONEY_HISTORY
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39640.Çek Tahsil ve Ciro Kur Farkları'></cfsavecontent>
<cf_report_list_search title="#title#">
    <div id="displayDivId" style="display: none;"><cf_wrk_report_search_button is_excel='1'></div></cf_report_list_search>
<cf_report_list>   
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id ='57487.No'></th>
                <th width="10%"><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
                <th><cf_get_lang dictionary_id ='58007.Çek'><cf_get_lang dictionary_id ='57487.No'></th>
                <th><cf_get_lang dictionary_id ='58007.Çek'><cf_get_lang dictionary_id ='57640.Vade'> </th>
                <th><cf_get_lang dictionary_id ='57628.Giriş Tarihi'></th>
                <th><cf_get_lang dictionary_id ='40328.Giriş Kuru'></th>
                <th><cf_get_lang dictionary_id ='30010.Ciro'>/<cf_get_lang dictionary_id ='40329.Tahsil Tarihi'></th>
                <th><cf_get_lang dictionary_id ='40330.Tahsil Kuru'></th>
                <th><cf_get_lang dictionary_id ='57490.Gün'></th>
                <th><cf_get_lang dictionary_id ='58007.Çek'><cf_get_lang dictionary_id='57894.Statü'> </th>
                <th><cf_get_lang dictionary_id ='58007.Çek'><cf_get_lang dictionary_id='58660.Değeri'></th>
                <th align="center"><cf_get_lang dictionary_id ='58474.P Birim'></th>
                <th><cf_get_lang dictionary_id ='40331.Giriş İşlem Pr'></th>
                <th align="center"><cf_get_lang dictionary_id ='58474.P Birim'></th>
                <th><cf_get_lang dictionary_id ='30020.Tahsil'>/<cf_get_lang dictionary_id ='40332.ciro İşlem Pr'></th>
                <th align="center"><cf_get_lang dictionary_id ='58474.P Birim'></th>
                <th><cf_get_lang dictionary_id ='57554.Giriş'>/<cf_get_lang dictionary_id ='40333.Tahsil Farkı'></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_cheques">
                 <tr>
                    <td>#get_cheques.currentrow#</td>
                    <td width="180">
						<cfif len(company_id_list)>
                        	#get_company.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#
                        </cfif>
                        <cfif len(consumer_id_list)>
                        	#get_consumer.FULLNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
                        </cfif>
                    </td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&ID=#GET_CHEQUES.CHEQUE_ID#','horizantal');"><font color="##339900">#get_cheques.CHEQUE_NO#</font></a></td>
                    <td>#dateformat(get_cheques.cheque_duedate,dateformat_style)#</td>
                    <td>#dateformat(get_cheques.act_date1,dateformat_style)#</td>
                    <cfquery name="get_first_rate" dbtype="query">
                        SELECT RATE2 FROM get_money_history WHERE VALIDATE_DATE =  #createodbcdate(act_date1)# AND MONEY = '#other_money2#'
                    </cfquery>
                    <td>#TLFormat(get_first_rate.rate2,session.ep.our_company_info.rate_round_num)#</td>
                    <td>#dateformat(get_cheques.act_date,dateformat_style)#</td>
                    <cfquery name="get_last_rate" dbtype="query">
                        SELECT RATE2 FROM get_money_history WHERE VALIDATE_DATE =  #createodbcdate(act_date)# AND MONEY = '#other_money2#'
                    </cfquery>
                    <td>#TLFormat(get_last_rate.rate2,session.ep.our_company_info.rate_round_num)#</td>
                    <td>#datediff('d',get_cheques.act_date,get_cheques.cheque_duedate)#</td>
                    <td><cfset status = get_cheques.status>
                        <cfswitch expression="#status#">
                          <cfcase value="1"><font color="##003399"><cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
                          <cfcase value="2"><font color="##993366"><cf_get_lang dictionary_id='50250.Bankada'></font></cfcase>
                          <cfcase value="3"><cf_get_lang dictionary_id ='39650.Tahsil Edildi'></cfcase>
                          <cfcase value="4"><font color="##339900"><cf_get_lang dictionary_id='39651.Ciro Edildi'></font></cfcase>
                          <cfcase value="5"><font color="##FF0000"><cf_get_lang dictionary_id='39482.Karşılıksız'></font></cfcase>
                          <cfcase value="6"><font color="##FF0000"><cf_get_lang dictionary_id='50254.Ödenmedi'></font></cfcase>
                          <cfcase value="7"><font color="##006600"><cf_get_lang dictionary_id='50255.Ödendi'></font></cfcase>
                          <cfcase value="8"><font color="##006600"><cf_get_lang dictionary_id='58506.İptal'></font></cfcase>
                          <cfcase value="9"><font color="##006600"><cf_get_lang dictionary_id='50335.İade'></font></cfcase>
                        </cfswitch>
                     </td>
                    <td style="text-align:right;">#TLFormat(get_cheques.cheque_value)#</td>
                    <td align="center">#get_cheques.currency_id#</td>
                    <td style="text-align:right;">#TLFormat(get_cheques.other_money_value2)# </td>
                    <td align="center">#get_cheques.other_money2#</td>
                    <td style="text-align:right;">#TLFormat(get_cheques.history_value2)#</td>
                    <td align="center">#get_cheques.history_money2#</td>
                    <td style="text-align:right;">#TLFormat(get_cheques.history_value2 - get_cheques.other_money_value2)#</td>
                 </tr>
            </cfoutput>
        </tbody>    
</cf_report_list>
<script>
$(".rotate").click(function (){
  document.getElementById("rotate").removeAttribute("href"); 
});
</script>