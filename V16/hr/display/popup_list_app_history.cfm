<cfinclude template="../query/get_app_history.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_app_history.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55831.İş Başvuru Tarihçesi"></cfsavecontent>
    <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!---Ücret Tarihçesi--->
        <cfset title_list = "">
        <cfif get_app_history.recordcount>
            <cfset temp_ = 0>
            <cfoutput query="get_app_history" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfset temp_ = temp_ +1>
                <cf_seperator id="history_#temp_#" header="#dateformat(record_date,dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#) - #employee_name# #employee_surname#" is_closed="1">
                <div id="history_#temp_#">
                    <div class="form-group" id="item-name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">#name# #surname#</div>
                    </div>
                    <div class="form-group" id="item-stage">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">#step_name#</div>
                    </div>
                    <div class="form-group" id="item-isealindi">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='55832.İşe Alındı'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfif STARTED><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></div>
                    </div>
                    <div class="form-group" id="item-durum">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfif APP_STATUS><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></div>
                    </div>
                    <!---            <tr>
                                    <td><cf_get_lang_main no='487.Kaydeden'></td>
                                    <td>#employee_name# #employee_surname#</td>
                                </tr>
                                <tr>
                                    <td width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
                                    <td>#dateformat(record_date,dateformat_style)#</td>
                                </tr> ---> 
                </div>
            </cfoutput>              
            
        <cfelse>
            <div>
                <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
            </div>
        </cfif>
    </cf_box>
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="97%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
	<td><cf_pages page="#attributes.page#"
	  maxrows="#attributes.maxrows#"
	  totalrecords="#attributes.totalrecords#"
	  startrow="#attributes.startrow#"
	  adres="hr.popup_list_app_history&empapp_id=#empapp_id#"> </td>
	<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
   
