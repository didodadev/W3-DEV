<cfinclude template="../query/get_service_plus.cfm">
<!--- <div style="display:none;z-index:999;" id="add_takip"></div> --->
<cfsavecontent variable="text"><cf_get_lang dictionary_id='49307.Takipler'></cfsavecontent>
<cf_box id="Takipler_box" title="#text#" collapsed="1" closable="0" add_href="#request.self#?fuseaction=call.popup_add_service_plus&service_id=#attributes.service_id#&plus_type=service&url=#iif(isdefined('get_service_detail.fuseaction') and len(get_service_detail.fuseaction),DE(get_service_detail.fuseaction),DE(""))#&subscription_id=#iif(isdefined('get_service_detail.subscription_id') and len(get_service_detail.subscription_id),DE(get_service_detail.subscription_id),DE(""))#">
    <cfoutput query="get_service_plus">
        <div class="ui-card">
            <div class="ui-card-item">
                <div class="ui-info-text padding-left-10">
                    #plus_content#
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_box_footer>
                        <div class="col col-10 col-md-10 col-sm-10 col-xs-12">  
                            <p>
                                <cfif len(record_emp) or len(record_par)>
                                    <b><cf_get_lang dictionary_id='57483.Kayıt'></b>: 
                                </cfif>
                                <cfif len(record_emp)>#get_emp_info(record_emp,0,0)#<cfelseif len(record_par)>#get_par_info(record_par,0,0,0)#</cfif>
                                <cfif len(record_date)> - #Dateformat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</cfif>
                            </p>
                            <cfif len(MAIL_SENDER)>
                                <p><b><cf_get_lang dictionary_id='30883.Bildirimler'></b>: #mail_sender#</p>
                            </cfif>
                            <cfif len(update_emp)>
                                <p>
                                    <b><cf_get_lang dictionary_id='57703.Güncelleme'></b>: #get_emp_info(update_emp,0,0)#
                                    <cfif len(update_date)> - #Dateformat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#</cfif>
                                </p>
                            </cfif>
                        </div>
                        <cfif not listfindnocase(denied_pages,'call.popup_upd_service_plus')>
                          <div class="col col-2 col-xs-12">  <a href="javascript://" class="pull-right ui-wrk-btn ui-wrk-btn-success" onClick="windowopen('#request.self#?fuseaction=call.popup_upd_service_plus&service_id=#attributes.service_id#&service_plus_id=#service_plus_id#&plus_type=service','medium');"><cf_get_lang dictionary_id='57464.Güncelle'></a></div>
                        </cfif>
                    </cf_box_footer>
                </div>
            </div>
        </div>
    </cfoutput>
</cf_box> 
<script type="text/javascript">
   /*  function open_takip(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('margin-left',$("#tabMenu").position().left);
		$("#"+id).css('margin-top',$("#tabMenu").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	} */
</script>
