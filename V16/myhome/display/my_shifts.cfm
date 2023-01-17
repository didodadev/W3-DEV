<!---
    File: list_emp_daily_in_out_shift.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 14/09/2020
    Description:
        Çalışanın İK İşlemleri altından vardiyalarını görüntüleyebileceği sayfadır
    History:
        
    To Do:

--->
<cfsavecontent variable = "my_shifts">
    <cf_get_lang dictionary_id='61206.Vardiyalarım'>    
</cfsavecontent>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif len(attributes.start_date)>
    <cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
    <cf_date tarih="attributes.finish_date">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset get_shift_cmp = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfset get_shift_employee = get_shift_cmp.GET_SHIF_EMPLOYEES(
        employee_id : session.ep.userid,
        employee_name : session.ep.name,
        is_shift : 1,
        start_date : attributes.start_date,
        finish_date : attributes.finish_date,
        is_myshift : 1
    )>
<cfparam name="attributes.totalrecords" default="#get_shift_employee.recordcount#">
<cf_box scroll="0">
        <cfform name="shits_search" method="post" action="#request.self#?fuseaction=myhome.my_shifts">
            <input type="hidden" name="form_submited" id="form_submited" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.başlama tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi',58053)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi',57700)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4"> 	
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
<cf_box title="#my_shifts#" hide_table_column="1"  uidrop="1">
    <cf_ajax_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="29831.Kişi"></th>
                <th><cf_get_lang dictionary_id="56566.Vardiya"></th>
                <th><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></th>
                <th><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_shift_employee.recordcount>
                <cfoutput query="get_shift_employee"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr id="table_tr_#currentrow#">
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    #get_emp_info(employee_id,0,0)# 
                                </div>
                            </div>
                        </td>
                        <td>
                            <cfset get_shifts = get_shift_cmp.get_shifts(shift_id : shift_id)>
                            #get_shifts.shift_name# (#get_shifts.start_hour#-#get_shifts.end_hour#)
                        </td>
                        <td>
                            #dateformat(start_date,dateformat_style)#
                        </td>
                        <td>
                            #dateformat(finish_date,dateformat_style)#
                        </td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_str = "myhome.my_shifts">
        <cfif len(attributes.start_date)>
            <cfset url_str = url_str&"&start_date=#attributes.start_date#">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cfset url_str = url_str&"&finish_date=#attributes.finish_date#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#url_str#">
    </cfif>
</cf_box>