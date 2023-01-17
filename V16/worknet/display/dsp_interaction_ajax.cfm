<cfsetting showdebugoutput="no">
<cfset start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
<cfset finish_date = date_add('d',7,start_date)>
<cfset finish_date = date_add('h',23,finish_date)>
<cfset finish_date = date_add('n',59,finish_date)>
<cfquery name="get_interaction" datasource="#dsn#">
	SELECT 
		TOP(10) 
		CUS_HELP_ID,
		CH.DETAIL,
		CH.IS_REPLY_MAIL,
		CH.APPLICANT_NAME,
		CH.RECORD_DATE,
        CH.INTERACTION_DATE,
		PTR.STAGE
	FROM 
		CUSTOMER_HELP CH
        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = CH.PROCESS_STAGE
     WHERE
		CH.INTERACTION_DATE >= #start_date# AND
		CH.INTERACTION_DATE <= #finish_date# 
	ORDER BY 
		CH.RECORD_DATE DESC
</cfquery>
<!--- Etkilesimler Ajax --->
<cf_ajax_list>
	<cfif get_interaction.recordcount>
    	<thead>
            <tr>
                <th><cf_get_lang_main no='485.Adı'></th>
                <th><cf_get_lang_main no='1717.Başvuru Yapan'></th>
                <th><cf_get_lang_main no='344.Durum'></th>
                <th colspan="2"><cf_get_lang_main no='330.Tarih'></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_interaction">
                <tr>
                    <td><a href="#request.self#?fuseaction=call.upd_helpdesk&cus_help_id=#cus_help_id#" class="tableyazi">#detail#</a></td>
                    <td>#applicant_name#</td>
                    <td><cfif is_reply_mail eq 0><font color="FFF0000"><cf_get_lang no="299.Cevaplandırılmadı"></font><cfelse><cf_get_lang no="300.Cevaplandırıldı"></cfif></td>
                    <td>#dateformat(record_date,dateformat_style)#</td>
                    <td width="15"><a href="#request.self#?fuseaction=call.upd_helpdesk&cus_help_id=#cus_help_id#"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
            </cfoutput>
            <tr>
                <td colspan="5" style="text-align:right;" class="txtbold">
                    <a href="<cfoutput>#request.self#?fuseaction=call.helpdesk&form_submitted=1&ordertype=3</cfoutput>"><cf_get_lang_main no="296.Tümü"></a>
                </td>
            </tr>
        </tbody>	
	<cfelse>
    	<tbody>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </tbody>
	</cfif>
</cf_ajax_list>
