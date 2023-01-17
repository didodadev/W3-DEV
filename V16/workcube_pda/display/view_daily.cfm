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
			attributes.to_day = date_add('h', -session.pda.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
		}
	catch(Any excpt)
		{
			tarih = '1/#ay#/#yil#';
			temp_tarih = tarih;
			attributes.to_day = date_add('h', -session.pda.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
		}
</cfscript>
<cf_date tarih="tarih">
<cfinclude template="agenda_tr.cfm">
<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
	<tr>
    	<td>
			<table cellpadding="0" cellspacing="0">
				<cfoutput>
					<tr class="color-row">
						<td class="infotag">Günlük</td>
						<td class="infotag">
							<a href="#request.self#?fuseaction=pda.daily&gun=#Dateformat(dateadd("d",-1,tarih),"dd")#&ay=#Dateformat(dateadd("d",-1,tarih),"mm")#&yil=#Dateformat(dateadd("d",-1,tarih),"yyyy")#" title="Önceki"><img src="/images/previous20.gif" border="0" align="absmiddle" title="Önceki" alt="Öncelik"></a>
							#temp_tarih# - <cfmodule template="tr_tarih.cfm" output="1" format="dddd" tarih="#tarih#">
							<a href="#request.self#?fuseaction=pda.daily&gun=#Dateformat(dateadd("d",1,tarih),"dd")#&ay=#Dateformat(dateadd("d",1,tarih),"mm")#&yil=#Dateformat(dateadd("d",1,tarih),"yyyy")#" title="Sonraki"><img src="/images/next20.gif" border=0 align="absmiddle" title="Sonraki" alt="Sonraki"></a>
						</td>
					</tr>
				</cfoutput>
			</table>
   		</td>
    	<td align="right" style="vertical-align:bottom"></td>
	</tr>
</table>
<cfinclude template="../query/get_daily_events.cfm">
<cf_date tarih="temp_tarih">
<cfinclude template="../query/get_event_plan_rows.cfm">
<cfset tarih_degeri=tarih>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">
  	<cfset tarih=tarih_degeri>
  	<cfloop from="8" to="20" index="i">
		<tr <cfif not(i mod 2)>class="color-row"</cfif> class="color-row" style="height:25px;"> 
		<cfoutput>
			<td style="width:30px;" class="infotag">#i#.00</td>
			<td>
				<cfscript>
					i = i - session.pda.time_zone;
					if (i eq (24)) attributes.hourstart=date_add('d',1,temp_tarih);
					else attributes.hourstart=date_add('h',i,temp_tarih);
					if (i eq (23)) attributes.hourfinish=date_add('d',1,temp_tarih);
					else attributes.hourfinish=date_add('h',i+1,temp_tarih);
					attributes.hourstart=date_add('h',i,temp_tarih);
					attributes.hourfinish=date_add('h',i+1,temp_tarih);
				</cfscript>
				<cfloop query="get_event_plan">
					<cfif len(is_sales)>
						<cfset value_is_sales = is_sales>
					<cfelse>
						<cfset value_is_sales = 0>
					</cfif>				
					<cfif ((get_event_plan.start_date gte date_add('h',session.pda.time_zone,attributes.hourstart)) and (get_event_plan.start_date lt date_add('h',session.pda.time_zone,attributes.hourfinish))) or ((get_event_plan.finish_date gte date_add('h',session.pda.time_zone,attributes.hourstart)) and (get_event_plan.finish_date lt date_add('h',session.pda.time_zone,attributes.hourfinish)))>
						<cfif not len(event_plan_id)>
							<li></li>
						<cfelse>
							<cfif len(result_record_emp)>
								<li><a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi"><cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> - <font color="##990000">Ziyaret</font></li>
							<cfelse>
								<li><a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi"> <cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> - <font color="##990000">Ziyaret</font></li>
							</cfif>
						</cfif>
						<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#company_id#" title="Sipariş Al"><img src="/images/plus_small.gif" align="absmiddle" border="0" alt="Sipariş Al" title="Sipariş Al"></a>
					</cfif>
				</cfloop>
				<cfloop query="get_daily_events">
					<cfif ((get_daily_events.startdate gte attributes.hourstart) and (get_daily_events.startdate lt attributes.hourfinish)) or ((get_daily_events.finishdate gte attributes.hourstart) and (get_daily_events.finishdate lt attributes.hourfinish)) >
						<cfset attributes.eventcat = eventcat>
						<li style="margin-left:20px;"><a href="#request.self#?fuseaction=pda.form_upd_event&event_id=#event_id#" class="tableyazi">#eventcat#-#event_head#</a></li>
					</cfif>
				</cfloop>
			</td>
		</tr>
		</cfoutput>
	</cfloop>
</table>
<br/>

