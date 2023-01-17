<!--- fuseaction:myhome.payment_request_approve --->
<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.process_status" default="2">
<cfparam name="attributes.process_status_2" default="2">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_payment_list_approve.cfm">
<cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32000.Avans Talep Edenler'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cfform name = "search_form" method="post" action=""> 
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="process_status">
                        <option value="2" <cfif attributes.process_status eq 2>selected</cfif>><cf_get_lang dictionary_id='61148.İK Sürecini Bekleyenler'></option>
                        <option value="1" <cfif attributes.process_status eq 1>selected</cfif>><cf_get_lang dictionary_id='61149.IK Tarafından Onaylananlar'></option>
                        <option value="0" <cfif attributes.process_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61150.IK Tarafından Red Edilenler'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></td>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    <th><cf_get_lang dictionary_id="41129.Süreç/Aşama"></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <!-- sil --><th width="20"></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_reserve_requests.recordcount>
                    <cfoutput query="get_reserve_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif fusebox.circuit eq 'myhome'>
                            <cfset ID_ = contentEncryptingandDecodingAES(isEncode:1,content:ID,accountKey:'wrk')>
                        <cfelse>
                            <cfset ID_ = ID>
                        </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td><a class="tableyazi" href="#request.self#?fuseaction=myhome.payment_request_approve&event=upd&id=#ID_#">#SUBJECT#</a></td>
                            <td style="text-align:right;">#TLFormat(AMOUNT)#</td>
                            <td>#money#</td>
                            <td>#STAGE#</td>
                            <td>#dateformat(DUEDATE,dateformat_style)#</td>
                            <!-- sil --><td><a  href="#request.self#?fuseaction=myhome.payment_request_approve&event=upd&id=#ID_#" class="tableyazi" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
    <!--- <cf_box title="#getLang('myhome',1243)#" closable="0">
        <cf_ajax_list id="payment4">
            <thead>
                <tr>
                    <th width="15"><cf_get_lang_main no='1165.Sıra'></th>
                    <th><cf_get_lang_main no='68.Konu'></th>
                    <th width="200"><cf_get_lang_main no='164.Çalışan'></th>
                    <th width="200"><cf_get_lang_main no='487.Kaydeden'></th>		
                    <th width="200"><cf_get_lang_main no='261.Tutar'></th>
                    <th width="200"><cf_get_lang_main no='344.Durum'></th>
                    <th width="200"><cf_get_lang_main no='330.Tarih'></th>
                    <!-- sil --><th width="15">&nbsp;</th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_reserve_other_requests.recordcount>
                    <cfoutput query="get_reserve_other_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif fusebox.circuit eq 'myhome'>
                            <cfset SPGR_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:SPGR_ID,accountKey:'wrk')>
                        <cfelse>
                            <cfset SPGR_ID_ = SPGR_ID>
                        </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request_valid&id=#SPGR_ID_#','small');" >#DETAIL#</a></td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td style="text-align:right;">#TLFormat(AMOUNT_GET)# </td>
                            <td><cfif IS_VALID eq 1><cf_get_lang_main no='170.Onaylandı'><cfelseif IS_VALID eq 0><cf_get_lang_main no='1740.Red'><cfelse><cf_get_lang no='355.Bekliyor'></cfif></td>
                            <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                            <td>#get_emp_info(get_reserve_other_requests.record_emp,0,0)#</td>
                            <!-- sil --><td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request_valid&id=#SPGR_ID_#','small');" ><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_ajax_list>
    </cf_box> --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31897.Gözetimdeki Avans Talepleri'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cfform name = "search_form_2" method="post" action=""> 
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="process_status_2">
                        <option value="2" <cfif attributes.process_status_2 eq 2>selected</cfif>><cf_get_lang dictionary_id='61148.İK Sürecini Bekleyenler'></option>
                        <option value="1" <cfif attributes.process_status_2 eq 1>selected</cfif>><cf_get_lang dictionary_id='61149.IK Tarafından Onaylananlar'></option>
                        <option value="0" <cfif attributes.process_status_2 eq 0>selected</cfif>><cf_get_lang dictionary_id='61150.IK Tarafından Red Edilenler'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    <th><cf_get_lang dictionary_id="41129.Süreç/Aşama"></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_info_requests.recordcount>
                    <cfoutput query="get_info_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#SUBJECT#</td>
                            <td style="text-align:center">#money#</td>
                            <td style="text-align:right;">#TLFormat(AMOUNT)# </td>
                            <td>#STAGE#</td>
                            <td>#dateformat(DUEDATE,dateformat_style)#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
