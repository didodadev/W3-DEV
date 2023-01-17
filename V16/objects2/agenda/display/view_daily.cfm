<cfscript>
	if (isdefined('url.gun')) 
		gun = url.gun;
	else
		gun = dateformat(now(), 'dd');
	
	if (isdefined('url.ay'))
		ay = url.ay;
	else
		ay = dateformat(now(),'mm');
		
	if (isdefined('url.yil'))
		yil = url.yil;
	else
		yil = dateformat(now(),'yyyy');
	
	tarih = '#gun#/#ay#/#yil#';
	try
	{
		temp_tarih = tarih;
		attributes.to_day = date_add('h',-session.pp.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
	}
	catch(Any excpt)
	{
		tarih = '1/#ay#/#yil#';
		temp_tarih = tarih;
		attributes.to_day = date_add('h',-session.pp.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
	}
</cfscript>
<cf_date tarih="tarih">
<cfset tarih_degeri=tarih>
<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<cfoutput>
						<td style="width:15px;"><a href="#request.self#?fuseaction=objects2.view_daily&gun=#Dateformat(DateAdd('d',-1,tarih),'dd')#&ay=#Dateformat(DateAdd('d',-1,tarih),'mm')#&yil=#Dateformat(DateAdd('d',-1,tarih),'yyyy')#" title="<cf_get_lang no='179.Önceki'> <cf_get_lang_main no='78.Gün'>"><img src="/images/previous20.gif" alt="<cf_get_lang no='179.Önceki'> <cf_get_lang_main no='78.Gün'>" border=0 align="absmiddle" style="width:15px; height:20px;"/></a></td>
						<td class="headbold">#temp_tarih# -  <cfmodule template="tr_tarih.cfm" output="1" format="dddd" tarih="#tarih#"></td>
						<td style="width:15px;"><a href='#request.self#?fuseaction=objects2.view_daily&gun=#Dateformat(DateAdd("d",1,tarih),"dd")#&ay=#Dateformat(DateAdd("d",1,tarih),"mm")#&yil=#Dateformat(DateAdd("d",1,tarih),"yyyy")#' title="<cf_get_lang no='180.Sonraki'> <cf_get_lang_main no='78.Gün'>"><img src="/images/next20.gif" alt="<cf_get_lang no='180.Sonraki'> <cf_get_lang_main no='78.Gün'>" border=0 align="absmiddle" style="width:15px; height:20px;"/></a></td>
				  	</cfoutput>
				 </tr>
			</table>
		</td>
  	</tr>
</table>
<cfinclude template="../query/get_daily_events.cfm">
<cfinclude template="../query/get_daily_works.cfm">
<table align="center" cellpadding="0" cellspacing="0" style="width:98%;">
  	<cf_date tarih="temp_tarih">
  	<tr>
		<td class="headbold" style="width:175px; vertical-align:top;"><cfinclude template="left_agenda.cfm"></td>
    	<td  style="text-align:right; vertical-align:top;">
      		<table cellspacing="0" cellpadding="0" border="0" style="width:98%;">
				<tr class="color-border">
					<td>
                        <table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
                            <cfloop from="8" to="20" index="i">
                                <tr <cfif not(i mod 2)>class="color-row"<cfelse>class="color-list"</cfif> style="height:25px;"> 
                                    <cfoutput>
                                        <td class="txtbold" style="width:30px;">
                                            <cfif not isdefined("session.agenda_userid")><a href="#request.self#?fuseaction=objects2.form_add_event&date=#dateformat(tarih_degeri,'dd/mm/yyyy')#&hour=#i#"></cfif>#i#.00 <cfif not isdefined("session.agenda_userid")></a></cfif>
                                        </td>
                                        <cfscript>
                                            i = i - session.pp.time_zone;
                                            if (i eq (24))
                                                attributes.hourstart=date_add('d',1,temp_tarih);
                                            else
                                                attributes.hourstart=date_add('h',i,temp_tarih);
                                            if (i eq (23))
                                                attributes.hourfinish=date_add('d',1,temp_tarih);
                                            else
                                                attributes.hourfinish=date_add('h',i+1,temp_tarih);
                                        </cfscript>
                                        <td>
                                        <!--- Olaylar --->
                                        <cfloop query="get_daily_events">
											<cfif ((get_daily_events.startdate gte attributes.hourstart) and (get_daily_events.startdate lt attributes.hourfinish)) or ((get_daily_events.finishdate gte attributes.hourstart) and (get_daily_events.finishdate lt attributes.hourfinish))>
                                                    <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">#eventcat#-#event_head#</a>, 
                                            </cfif>
                                        </cfloop>
                                        <!--- İşlerim --->
                                        <cfloop query="daily_works">
                                    		<cfif ((daily_works.target_start gte attributes.hourstart) and (daily_works.target_start lt attributes.hourfinish)) or ((daily_works.target_finish gte attributes.hourstart) and (daily_works.target_finish lt attributes.hourfinish))>
                                     			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                             </cfif>
                                        </cfloop>&nbsp;</td> 
                                 	</tr>
                                </cfoutput>
                          	</cfloop>
                        </table>
                    </td>
                </tr>
          	</table>
      		<!---Saate tikladigimizda alttaki table gözükecek. Table normalde gizli olacak! --->
            <table onClick="gizle_goster(gizli);" border="0" cellpadding="0" cellspacing="0" style="cursor:pointer; width:98%;">
              	<tr style="height:22px;">
                  	<td style="width:21px;"><img src="/images/time.gif" alt="<cf_get_lang no='734.Günün Diğer Saatlerini Göster'>" title="<cf_get_lang no='734.Günün Diğer Saatlerini Göster'>" style="width:19px; height:21px;"/></td>
                  	<td class="txtbold"><cf_get_lang no='734.Günün Diğer Saatlerini Göster'></td>
              	</tr>
            </table>
            <table cellspacing="0" cellpadding="0" border="0" id="gizli" style="display:none; width:98%;">
              	<tr class="color-border">
                  	<td>
                  		<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
                      		<cfloop from="21" to="31" index="i">
								<cfset j = i mod 24>
                                <tr <cfif not(i mod 2)>class="color-row"<cfelse>class="color-list"</cfif> style="height:25px;"> 
								  <cfoutput>
                                      <td class="txtbold" style="width:30px;">
                                          <cfif not isdefined("session.agenda_userid")><a href="#request.self#?fuseaction=objects2.form_add_event&date=#dateformat(tarih_degeri,'dd/mm/yyyy')#&hour=#j#"></cfif>#j#.00<cfif not isdefined("session.agenda_userid")></a></cfif>
                                       </td>
                                       <cfscript>
                                            if ((j-session.pp.time_zone) eq (24))
                                                attributes.hourstart = date_add('d',1,temp_tarih);
                                            else
                                                attributes.hourstart = date_add('h',j-session.pp.time_zone,temp_tarih);
                                            if ((j-session.pp.time_zone) eq (23))
                                                attributes.hourfinish=date_add('d',1,temp_tarih);
                                            else
                                                attributes.hourfinish=date_add('h',j+1-session.pp.time_zone,temp_tarih);
                                        </cfscript>
                                        <td>
                                        <!--- Olaylar --->
                                        <cfloop query="get_daily_events">
                                            <cfif ((get_daily_events.startdate gte attributes.hourstart) and (get_daily_events.startdate lt attributes.hourfinish)) or ((get_daily_events.finishdate gte attributes.hourstart) and (get_daily_events.finishdate lt attributes.hourfinish))>
                                                <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">#eventcat#-#event_head#</a>, 
                                            </cfif>
                                        </cfloop>
                                        <!--- İşlerim --->
                                        <cfloop query="daily_works">
                                            <cfif ((daily_works.target_start gte attributes.hourstart) and (daily_works.target_start lt attributes.hourfinish)) or ((daily_works.target_finish gte attributes.hourstart) and (daily_works.target_finish lt attributes.hourfinish))>
                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','medium');return false;" class="tableyazi"><cf_get_lang_main no='1033.İŞ'> - #work_head#</a>, 
                                            </cfif>
                                        </cfloop>&nbsp;</td>
                                    </cfoutput>
                            	</tr>
                            </cfloop>
                        </table>
                    </td>
                </tr>
            </table>
    	</td>
  	</tr>
</table>
<br/>
