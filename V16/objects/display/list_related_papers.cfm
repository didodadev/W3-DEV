<cfparam name="attributes.sec" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.sales_position_codee" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='34134.İlişkili Belgeler'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
	<table>
    	<tr>
        	<td>
                <cfform name="form_search" action="#request.self#?fuseaction=objects.popup_list_related_papers" method="post">
                    <cfoutput>
                        <input type="hidden" value="1" name="form_varmi" id="form_varmi">
                       <select name="sec" id="sec" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> </option>
                            <option value="1" <cfif attributes.sec is "1">selected</cfif>><cf_get_lang dictionary_id='58917.Faturalar'></option>
                            <option value="2" <cfif attributes.sec is "2">selected</cfif>><cf_get_lang dictionary_id='32784.Siparişler'></option>
                            <option value="3" <cfif attributes.sec is "3">selected</cfif>><cf_get_lang dictionary_id='33905.Teklifler'></option>
                       </select>
                      &nbsp;<cf_get_lang dictionary_id ='57658.Üye'>
                          <input type="text" name="member_name" id="member_name" value="<cfif len(attributes.member_name)>#attributes.member_name#</cfif>" style="width:175px;">
                          <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">	
                          <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                          <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")>#attributes.member_type#</cfif>">
                          <cfset str_linke_ait="&field_consumer=form_search.consumer_id&field_comp_id=form_search.company_id&field_member_name=form_search.member_name&field_type=form_search.member_type">
                          <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&select_list=7,8&keyword='+encodeURIComponent(document.form_search.member_name.value),'list');">
                          <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                      &nbsp;<cf_get_lang dictionary_id ='57576.Çalışan'>
                          <input type="hidden" name="sales_position_code" id="sales_position_code" value="<cfif len(attributes.employee) and len(attributes.sales_position_code)><cfoutput>#attributes.sales_position_code#</cfoutput></cfif>">
                          <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee_id#</cfif>">
                          <input type="text" name="employee" id="employee" value="<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee#</cfif>"style="width:100px;">	
                          <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_search.employee_id&field_name=form_search.employee&field_code=form_search.sales_position_code&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>		   
                      &nbsp;<cf_get_lang dictionary_id ='57880.Belge No'>
                           <input type="text" name="belge_no" id="belge_no" style="width:85px;" value="<cfif isdefined("attributes.belge_no")><cfoutput>#attributes.belge_no#</cfoutput></cfif>" maxlength="30">
                           <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58745.Başlama Tarihi Girmelisiniz '></cfsavecontent>
                           <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#alert#" required="yes">
                           <cf_wrk_date_image date_field="start_date"> 
                            <cfsavecontent variable="alert2"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent> 
                           <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#alert2#" required="yes">
                           <cf_wrk_date_image date_field="finish_date">
                           <cfsavecontent variable="message"><cf_get_lang dictionary_id ='34135.Sayı Hatası Mesaj'></cfsavecontent>
                           <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
                           <cfsavecontent variable="runn"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                           <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#runn#'></cfoutput>
                </cfform>
             </td>
         </tr>
    </table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
	<!--- Faturalar --->
<cfif isdefined("attributes.sec") and attributes.sec eq 1>
        <cfinclude template="invoice_list.cfm">
    </cfif>
    
    <!--- Siparişler --->
    <cfif isdefined("attributes.sec") and attributes.sec eq 2>
      <cfinclude template="orders_list.cfm">
    </cfif>
    
    <!--- Teklifler --->
    <cfif isdefined("attributes.sec") and attributes.sec eq 3>
        <cfinclude template="offers_list.cfm">
    </cfif>

