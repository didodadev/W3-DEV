<cf_get_lang_set module_name="pos">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_NIELSENS" datasource="#DSN3#">
		SELECT 
			AC.ACNR_ID,
			AC.ACN_CODE,
			AC.STARTDATE,
			AC.FINISHDATE,
			AC.TOTAL_DAYS,
			AC.RECORD_EMP,
			AC.RECORD_DATE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			B.BRANCH_NAME
		FROM 
			ACNIELSEN_REPORTS AC,
			#dsn_alias#.EMPLOYEES E,
			#dsn_alias#.BRANCH B
		WHERE
			AC.RECORD_EMP = E.EMPLOYEE_ID AND
			AC.BRANCH_ID = B.BRANCH_ID
		<cfif len(attributes.start_date)>
			<cf_date tarih="attributes.start_date">
			AND AC.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cf_date tarih="attributes.finish_date">
			AND AC.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		ORDER BY 
			AC.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_nielsens.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_nielsens.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_acnielsen">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="#lang_array.item[2]#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='326.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif len(attributes.start_date)>
                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                        <cfelse>
                            <cfinput type="text" name="start_date" value="" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                        </cfif>
                        <cf_wrk_date_image date_field="start_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif len(attributes.finish_date)>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                        <cfelse>
                            <cfinput type="text" name="finish_date" value="" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                        </cfif>
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
        	<th><cf_get_lang_main no="1165.Sıra"></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th width="125"><cf_get_lang_main no='1278.Tarih Aralığı'></th>
            <th width="100"><cf_get_lang no='4.Toplam Gün'></th>
            <th><cf_get_lang_main no='487.Kaydeden'></th>
            <th width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=pos.popup_form_export_acnielsen</cfoutput>','small','acnielsen');"><img src="/images/plus_list.gif" title="<cf_get_lang no='1.rapor oluştur'>"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_nielsens.recordcount>
        <cfoutput query="get_nielsens" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
            	<td>#currentrow#</td>
                <td>#branch_name#</td>
                <td>#dateformat(startdate,"dd/mm/yyyy")#-#dateformat(finishdate,"dd/mm/yyyy")#</td>
                <td>#total_days#</td>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                <cfset new_record_date = date_add("h",session.ep.time_zone,record_Date)>
                <td>#dateformat(new_record_date,"dd/mm/yyyy")# (#timeformat(new_record_date,"HH:MM")#)</td>
                <td>
                    <a href="#file_web_path#report/acnielsen/#dateformat(startdate,'ddmmyyyy')#_#dateformat(finishdate,'ddmmyyyy')#/#ACN_CODE#_#dateformat(startdate,'ddmmyyyy')#_#dateformat(finishdate,'ddmmyyyy')#.wrk"><img src="/images/download.gif"></a>
                    <cfsavecontent variable="alert"><cf_get_lang no ='126.Kayıtlı Raporu Siliyorsunuz! Emin misiniz'></cfsavecontent>
                    <a href="javascript://" onClick="javascript:if(confirm('#alert#')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_acnielsen&ACNR_ID=#ACNR_ID#','small'); else return false;"><img src="/images/delete_list.gif"></a>
                </td>
            </tr>
        </cfoutput>
        <cfelse>
          <tr>
            <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
          </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset url_string = ''>
<cfif len(attributes.start_date)>
<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
</cfif>
<cfif len(attributes.finish_date)>
<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#fusebox.circuit#.list_acnielsen#url_string#">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">