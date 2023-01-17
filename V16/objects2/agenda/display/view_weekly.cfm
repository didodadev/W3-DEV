<cfscript>
	if (isdefined('url.yil'))
		tarih = url.yil;
	else
		tarih = dateformat(now(),'yyyy');
	if (isdefined('url.ay'))
		tarih=tarih&'-'&url.ay;
	else
		tarih=tarih&'-'&dateformat(now(),'mm');
	
	if (isdefined('url.gun'))
		tarih=tarih&'-'&url.gun;
	else
		tarih=tarih&'-'&dateformat(now(),'d');
	
	fark = (-1)*(dayofweek(tarih)-2);
	// haftanın son gününe tıklandığında bir sonraki haftaya atlamaması için
	if (fark eq 1) fark = -6;

	last_week = date_add('d',fark-1,tarih);
	first_day = date_add('d',fark,tarih);
	second_day = date_add('d',1,first_day);
	third_day = date_add('d',2,first_day);
	fourth_day = date_add('d',3,first_day);
	fifth_day = date_add('d',4,first_day);
	sixth_day = date_add('d',5,first_day);
	seventh_day = date_add('d',6,first_day);
	next_week = date_add('d',7,first_day);
	attributes.to_day = date_add('h', -session.pp.time_zone, first_day);
</cfscript>
<cfinclude template="../query/get_weekly_events.cfm">
<cfinclude template="../query/get_weekly_works.cfm">
<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
  	<tr>
    	<td>
      		<table cellpadding="0" cellspacing="0">
        		<tr>
		  			<cfoutput>
            			<td style="width:15px;"><a href="#request.self#?fuseaction=objects2.view_weekly&yil=#dateformat(last_week,"yyyy")#&ay=#dateformat(last_week,"mm")#&gun=#dateformat(last_week,"dd")#" title="<cf_get_lang no='179.Önceki'> <cf_get_lang_main no='1322.Hafta'>"><img src="/images/previous20.gif" alt="<cf_get_lang no='179.Önceki'> <cf_get_lang_main no='1322.Hafta'>" border="0" align="absmiddle" style="width:15px; height:20px;"/></a></td>
            			<td class="headbold"> #dateformat(first_day,'dd/mm/yyyy')# - #dateformat(seventh_day,'dd/mm/yyyy')#</td>
            			<td style="width:15px;"><a href="#request.self#?fuseaction=objects2.view_weekly&yil=#dateformat(next_week,"yyyy")#&ay=#dateformat(next_week,"mm")#&gun=#dateformat(next_week,"dd")#" title="<cf_get_lang no='180.Sonraki'> <cf_get_lang_main no='1322.Hafta'>"><img src="/images/next20.gif" alt="<cf_get_lang no='180.Sonraki'> <cf_get_lang_main no='1322.Hafta'>" border="0" align="absmiddle" style="width:15px; height:20px;" /></a></td>
          			</cfoutput>
				</tr>
      		</table>
    	</td>
  	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="2" align="center" style="width:98%;">
  	<tr>
    	<td align="center" style="width:19%; vertical-align:top;">
      		<cfinclude template="left_agenda.cfm">
    	</td>
    	<td  style="text-align:right; vertical-align:top;">
      		<table cellspacing="0" cellpadding="0" border="0" style="width:98%;">
        		<tr class="color-border">
          			<td>
            			<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:325px;">
              				<tr class="color-header" style="height:22px;">  
								<cfoutput>
                                <td align="center" style="width:16%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(first_day,"yyyy")#&ay=#dateformat(first_day,"mm")#&gun=#dateformat(first_day,"dd")#" class="form-title"><cf_get_lang_main no='192.Pazartesi'></a></td>
                                <td align="center" style="width:16%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(second_day,"yyyy")#&ay=#dateformat(second_day,"mm")#&gun=#dateformat(second_day,"dd")#" class="form-title"><cf_get_lang_main no='193.Salı'></a></td>
                                <td align="center" style="width:16%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(third_day,"yyyy")#&ay=#dateformat(third_day,"mm")#&gun=#dateformat(third_day,"dd")#" class="form-title"><cf_get_lang_main no='194.Çarşamba'></a></td>
                                <td align="center" style="width:16%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(fourth_day,"yyyy")#&ay=#dateformat(fourth_day,"mm")#&gun=#dateformat(fourth_day,"dd")#" class="form-title"><cf_get_lang_main no='195.Perşembe'></a></td>
                                <td align="center" style="width:16%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(fifth_day,"yyyy")#&ay=#dateformat(fifth_day,"mm")#&gun=#dateformat(fifth_day,"dd")#" class="form-title"><cf_get_lang_main no='196.Cuma'></a></td>
                                <td align="center"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(sixth_day,"yyyy")#&ay=#dateformat(sixth_day,"mm")#&gun=#dateformat(sixth_day,"dd")#" class="form-title"><cf_get_lang_main no='197.Cumartesi'></a></td>
                				</cfoutput> 
                            </tr>
                            <tr class="color-row" style="height:220px;">
								<cfoutput>
                                <!--- hafta içi --->
                                <cfloop from="0" to="4" index="i">
                           			<cfset attributes.to_day = date_add('h',-session.pp.time_zone,date_add('d',i,first_day))>
                                  	<td rowspan="3" style="width:16%; vertical-align:top;">                                
                                      	<cfloop query="get_weekly_events">
											<cfif ((get_weekly_events.startdate gte attributes.to_day) and (get_weekly_events.startdate lt date_add('d',1,attributes.to_day))) or ((get_weekly_events.finishdate gte attributes.to_day) and (get_weekly_events.finishdate lt date_add('d',1,attributes.to_day)))>
                                                <cfset attributes.eventcat = get_weekly_events.eventcat>
                                                <cfinclude template="../query/get_eventcat_colour.cfm">
                                                <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi" style="color : #get_eventcat_colour.colour#">#eventcat#-#event_head#</a>, 
                                            </cfif>
                                      	</cfloop>
                                
                                      	<cfloop query="weekly_works">
											<cfif ((weekly_works.target_start gte attributes.to_day) and (weekly_works.target_start lt date_add('d',1,attributes.to_day))) or ((weekly_works.target_finish gte attributes.to_day) and (weekly_works.target_finish lt date_add('d',1,attributes.to_day)))>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                            </cfif>
                                      	</cfloop>&nbsp;
                                    </td>
                                </cfloop>
                                <!--- cumartesi / pazar --->
                                <cfset attributes.to_day = date_add("h",-session.pp.time_zone,sixth_day)>
                                <td style="width:20%; vertical-align:top;">
                                      <cfloop query="get_weekly_events">
                                        <cfif ((get_weekly_events.startdate gte attributes.to_day) and (get_weekly_events.startdate lt date_add('d',1,attributes.to_day))) or ((get_weekly_events.finishdate gte attributes.to_day) and (get_weekly_events.finishdate lt date_add('d',1,attributes.to_day)))>
                                            <cfset attributes.eventcat = get_weekly_events.eventcat>
                                            <cfinclude template="../query/get_eventcat_colour.cfm">
                                            <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi" style="color : #get_eventcat_colour.colour#">#eventcat#-#event_head#</a>, 
                                        </cfif>
                                      </cfloop>
                                
                                      <cfloop query="weekly_works">
                                        <cfif ((weekly_works.target_start gte attributes.to_day) and (weekly_works.target_start lt date_add('d',1,attributes.to_day))) or ((weekly_works.target_finish gte attributes.to_day) and (weekly_works.target_finish lt date_add('d',1,attributes.to_day)))>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                        </cfif>
                                      </cfloop>&nbsp;</td>
                                </cfoutput>
                            </tr>
                            <tr class="color-header" style="height:22px;"> 
								<cfoutput>
                              		<td align="center" style="width:20%;"><a href="#request.self#?fuseaction=objects2.view_daily&yil=#dateformat(seventh_day,"yyyy")#&ay=#dateformat(seventh_day,"mm")#&gun=#dateformat(seventh_day,"dd")#" class="form-title"><cf_get_lang_main no='198.Pazar'></a></td>
                            	</cfoutput> 
                            </tr>
                            <tr class="color-row">
								<cfoutput>
                            		<cfset attributes.to_day = date_add("h",-session.pp.time_zone,seventh_day)>
                            		<td style="vertical-align:top;">
                                        <cfloop query="get_weekly_events">
											<cfif ((get_weekly_events.startdate gte attributes.to_day) and (get_weekly_events.startdate lt date_add('d',1,attributes.to_day))) or ((get_weekly_events.finishdate gte attributes.to_day) and (get_weekly_events.finishdate lt date_add('d',1,attributes.to_day)))>
                                                <cfset attributes.eventcat = get_weekly_events.eventcat>
                                                <cfinclude template="../query/get_eventcat_colour.cfm">
                                                <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi" style="color : #get_eventcat_colour.colour#">#eventcat#-#event_head#</a>, 
                                            </cfif>
                                        </cfloop>
                                        
                                        <cfloop query="weekly_works">
											<cfif ((weekly_works.target_start gte attributes.to_day) and (weekly_works.target_start lt date_add('d',1,attributes.to_day))) or ((weekly_works.target_finish gte attributes.to_day) and (weekly_works.target_finish lt date_add('d',1,attributes.to_day)))>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                            </cfif>
                                        </cfloop>&nbsp;
                                    </td>
								</cfoutput>
                            </tr>
            			</table>
          			</td>
        		</tr>
      		</table>
    	</td>
  	</tr>
</table>
<br/>
