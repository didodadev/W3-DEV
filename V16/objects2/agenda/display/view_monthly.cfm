<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralık'></cfsavecontent>
<cfscript>
	if (isDefined('url.ay'))
		ay = url.ay;
	else if (isDefined('attributes.ay'))
		ay = attributes.ay;
	else
		ay = DateFormat(now(),'mm');
	
	if (isDefined('url.yil'))
		yil = url.yil;
	else if (isDefined('attributes.yil'))
		yil = attributes.yil;
	else
		yil = DateFormat(now(),'yyyy');
	
	if (not isdefined('attributes.mode'))
		attributes.mode = '';
	
	oncekiyil = yil-1;
	sonrakiyil = yil+1;
	oncekiay = ay-1;
	sonrakiay = ay+1;
	
	if (ay eq 1)
		oncekiay=12;
	
	if (ay eq 12)
		sonrakiay=1;
	aylar = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
	/*
	if (isLeapYear(yil))
		aylar=listSetAt(aylar,2,29);
	*/
	tarih = createDate(yil,ay,1);
	bas = DayofWeek(tarih)-1;
	if (bas EQ 0)
		bas=7;
	son = DaysinMonth(tarih);
	gun = 1;
	yer = '#request.self#?fuseaction=objects2.view_monthly';
	
	attributes.to_day = date_add("h",-session.pp.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
</cfscript>

<cfinclude template="../query/get_monthly_events.cfm">
<cfinclude template="../query/get_monthly_works.cfm">

<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
  	<tr>
    	<td>
      		<table cellpadding="0" cellspacing="0" style="height:20px;">
        		<tr> 
					<cfoutput>
            		<td align="left"><a href="#yer#&ay=#ay#&yil=#oncekiyil#" title="<cf_get_lang_main no='528.Önceki Yıl'>"><img src="/images/previous20.gif" alt="<cf_get_lang_main no='528.Önceki Yıl'>" border="0" align="absmiddle" style="width:15px; height:20px;"/></a></td>
            		<td align="center" class="headbold" style="width:10px;">#Year(tarih)#</td>
                    <td  style="text-align:right;"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#" title="<cf_get_lang_main no='533.Sonraki Yıl'>"><img src="/images/next20.gif" alt="<cf_get_lang_main no='533.Sonraki Yıl'>" style="width:15px; height:20px;" border="0" align="absmiddle"/></a></td>
                    <td align="left"><a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>" title="<cf_get_lang_main no='529.Önceki Ay'>"><img src="/images/previous20.gif" alt="<cf_get_lang_main no='529.Önceki Ay'>" style="width:15px; height:20px;" border="0" align="absmiddle"/></a></td>
                    <td align="center" class="headbold" style="width:10px;">#ListGetAt(aylar,Month(tarih))#</td>
                    <td><a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>" title="<cf_get_lang_main no='532.Sonraki Ay'>"><img src="/images/next20.gif" alt="<cf_get_lang_main no='532.Sonraki Ay'>" style="width:15px; height:20px;" border="0" align="absmiddle"/></a></td>
          			</cfoutput> 
                </tr>
      		</table>
    	</td>
    	<td  style="text-align:right; vertical-align:bottom;">
      		<cfinclude template="form_search.cfm">
    	</td>
  	</tr>
</table>

<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
	<tr class="color-border">
  		<td>
    		<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
      			<tr class="color-header" style="height:22px;">
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='192.Pazartesi'></td>
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='193.Salı'></td>
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='194.Çarşamba'></td>
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='195.Perşembe'></td>
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='196.Cuma'></td>
                    <td align="center" class="form-title" style="width:15%;"><cf_get_lang_main no='197.Cumartesi'></td>
                    <td align="center" class="form-title"><cf_get_lang_main no='198.Pazar'></td>
      			</tr>
      			<cfset sayac =0>
      			<tr class="color-list" style="height:20px;">
                    <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
						<td>&nbsp;</td>
                    </cfloop>
                    <cfloop index="x" from="#bas#" to="7">
                      	<td class="txtbold"><cfoutput><a href="#request.self#?fuseaction=objects2.view_daily&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
                      	<cfset gun = gun +1>
                      	<cfset sayac = sayac +1>
                    </cfloop>
      			</tr>
      			<cfset gun = gun - sayac>
              	<tr class="color-row" style="height:79px;">
                	<cfloop index="x" from="1" to="#Evaluate(bas-1)#">
                  		<td>&nbsp;</td>
                	</cfloop>
                	<cfloop index="x" from="#bas#" to="7">
                		<cfoutput>
                            <td style="vertical-align:top;">
								<cfset attributes.to_day = date_add("h",-session.pp.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
                                <cfloop query="get_monthly_events">
                                	<cfif ((get_monthly_events.startdate gte attributes.to_day) and (get_monthly_events.startdate lt date_add('d',1,attributes.to_day))) or ((get_monthly_events.finishdate gte attributes.to_day) and (get_monthly_events.finishdate lt date_add('d',1,attributes.to_day)))>
                                		<cfset attributes.eventcat = eventcat>
                                		<cfinclude template="../query/get_eventcat_colour.cfm">
                                		<a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi" style="color : #get_eventcat_colour.colour#">#eventcat#-#event_head#</a>, 
                                	</cfif>
                                </cfloop>                                
                                <cfset gun = gun +1>
                                <cfloop query="monthly_works">
									<cfif ((monthly_works.target_start gte attributes.to_day) and (monthly_works.target_start lt date_add('d',1,attributes.to_day))) or ((monthly_works.target_finish gte attributes.to_day) and (monthly_works.target_finish lt date_add('d',1,attributes.to_day)))>
                                    	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#&id=#project_id#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                    </cfif>
                                </cfloop>
                            	&nbsp;
                            </td>
                		</cfoutput>
                	</cfloop>
              	</tr>
              	<cfloop index=y from=2 to=6>
                	<cfset sayac=0>
                	<tr class="color-list" style="height:20px;">
                        <cfloop index=x from=1 to=7>
                        	<cfif gun lte son>
                        		<td class="txtbold"><cfoutput><a href="#request.self#?fuseaction=objects2.view_daily&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
                        	<cfelse>
                        		<td>&nbsp;</td>
                        	</cfif>
                        	<cfset gun = gun +1>
                        	<cfset sayac = sayac +1>
                        </cfloop>
                	</tr>
                	<cfset gun=gun-sayac>
                	<tr class="color-row" style="vertical-align:top; height:80px;">
                		<cfoutput>
                            <cfloop index=x from=1 to=7>
                                <cfif gun lte son>
                                	<td>
                    					<cfset attributes.to_day = date_add("h",-session.pp.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
                                		<cfloop query="get_monthly_events">
                                			<cfif ((get_monthly_events.startdate gte attributes.to_day) and (get_monthly_events.startdate lt date_add('d',1,attributes.to_day))) or ((get_monthly_events.finishdate gte attributes.to_day) and (get_monthly_events.finishdate lt date_add('d',1,attributes.to_day)))>
                                				<cfset attributes.eventcat = get_monthly_events.eventcat>
                                				<cfinclude template="../query/get_eventcat_colour.cfm">
                                				<a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi" style="color : #get_eventcat_colour.colour#">#eventcat#-#event_head#</a>, 
                                			</cfif>
                                		</cfloop>
                                
                                		<cfloop query="monthly_works">
                                			<cfif ((monthly_works.target_start gte attributes.to_day) and (monthly_works.target_start lt date_add('d',1,attributes.to_day))) or ((monthly_works.target_finish gte attributes.to_day) and (monthly_works.target_finish lt date_add('d',1,attributes.to_day)))>
                                				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#&id=#project_id#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                			</cfif>
                                		</cfloop> 
                      				</td>
                      			<cfelse>
                      				<td>&nbsp;</td>
                    			</cfif>
                    			<cfset gun = gun +1>
                  			</cfloop>
                		</cfoutput>
                	</tr>
      			</cfloop>
    		</table>
  		</td>
	</tr>
</table>
<br/>
