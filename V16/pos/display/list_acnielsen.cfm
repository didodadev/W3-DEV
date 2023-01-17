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

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="#request.self#?fuseaction=pos.list_acnielsen">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <div class ="input-group">
                        <cfsavecontent  variable="message1"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif len(attributes.start_date)>
                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#message1#">
                        <cfelse>
                            <cfinput type="text" name="start_date" value="" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#message1#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message1"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif len(attributes.finish_date)>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#message1#">
                        <cfelse>
                            <cfinput type="text" name="finish_date" value="" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#message1#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                       <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='36002.AC Nielsen Raporları'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='58690.Tarih Aralığı'></th>
                    <th><cf_get_lang dictionary_id='36004.Toplam Gün'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=pos.list_acnielsen&event=add</cfoutput>','small','acnielsen');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36001.rapor oluştur'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_nielsens.recordcount>
                <cfoutput query="get_nielsens" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#branch_name#</td>
                        <td>#dateformat(startdate,dateformat_style)#-#dateformat(finishdate,dateformat_style)#</td>
                        <td>#total_days#</td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                        <cfset new_record_date = date_add("h",session.ep.time_zone,record_Date)>
                        <td>#dateformat(new_record_date,dateformat_style)# (#timeformat(new_record_date,timeformat_style)#)</td>
                        <td>
                            <a href="#file_web_path#report/acnielsen/#dateformat(startdate,'ddmmyyyy')#_#dateformat(finishdate,'ddmmyyyy')#/#ACN_CODE#_#dateformat(startdate,'ddmmyyyy')#_#dateformat(finishdate,'ddmmyyyy')#.wrk"><img src="/images/download.gif"></a>
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='36127.Kayıtlı Raporu Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <a href="javascript://" onClick="javascript:if(confirm('#alert#')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_acnielsen&ACNR_ID=#ACNR_ID#','small'); else return false;"><img src="/images/delete_list.gif"></a>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                  <tr>
                    <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                  </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<cfset url_string = ''>
<cfif len(attributes.start_date)>
<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
</cfif>
<cfif len(attributes.finish_date)>
<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="pos.list_acnielsen#url_string#">

