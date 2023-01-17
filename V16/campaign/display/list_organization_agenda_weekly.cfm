<cfset tarih_bugun=dateformat(now(),"yyyy-mm-dd")>
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
if (fark EQ 1) fark = -6;

last_week = date_add('d',fark-1,tarih);
first_day = date_add('d',fark,tarih);
second_day = date_add('d',1,first_day);
third_day = date_add('d',2,first_day);
fourth_day = date_add('d',3,first_day);
fifth_day = date_add('d',4,first_day);
sixth_day = date_add('d',5,first_day);
seventh_day = date_add('d',6,first_day);
next_week = date_add('d',7,first_day);
attributes.to_day = date_add('h', -session.ep.time_zone, first_day);
</cfscript>
<cfparam name="attributes.event_id" default="">
<cfquery name="GET_WEEKLY_OFFTIMES" datasource="#DSN#">
	SELECT 
		START_DATE,
		FINISH_DATE
	FROM 
		SETUP_GENERAL_OFFTIMES
	WHERE
		START_DATE <= #seventh_day# AND
		FINISH_DATE >= #first_day#		
</cfquery>
<cfset date_list = " ">
<cfloop query="get_weekly_offtimes">
	<cfif (datediff("d", start_date, first_day) gte 0) and (datediff("d", first_day, finish_date) gte 0)><cfset date_list = listappend(date_list, first_day, ",")></cfif>
	<cfif (datediff("d", start_date, second_day) gte 0) and (datediff("d", second_day, finish_date) gte 0)><cfset date_list = listappend(date_list, second_day, ",")></cfif>
	<cfif (datediff("d", start_date, third_day) gte 0) and (datediff("d", third_day, finish_date) gte 0)><cfset date_list = listappend(date_list, third_day, ",")></cfif>
	<cfif (datediff("d", start_date, fourth_day) gte 0) and (datediff("d", fourth_day, finish_date) gte 0)><cfset date_list = listappend(date_list, fourth_day, ",")></cfif>
	<cfif (datediff("d", start_date, fifth_day) gte 0) and (datediff("d", fifth_day, finish_date) gte 0)><cfset date_list = listappend(date_list, fifth_day, ",")></cfif>
	<cfif (datediff("d", start_date, sixth_day) gte 0) and (datediff("d", sixth_day, finish_date) gte 0)><cfset date_list = listappend(date_list, sixth_day, ",")></cfif>
	<cfif (datediff("d", start_date, seventh_day) gte 0) and (datediff("d", seventh_day, finish_date) gte 0)><cfset date_list = listappend(date_list, seventh_day, ",")></cfif>
</cfloop>
<cfset date_list = listsort(date_list, "text", "asc", ",")>
<div class="col col-3 col-md-3 col-sm-4 col-xs-12">
	<cfinclude template="left_agenda.cfm">
</div>
<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="7">
					<cfoutput>
						<div class="input-group">
							<span class="input-group-addon"><a href="#cgi.script_name#?fuseaction=#attributes.fuseaction#&page_type=0&mode=&yil=#dateformat(last_week,"yyyy")#&ay=#dateformat(last_week,"mm")#&gun=#dateformat(last_week,"dd")#"><i class="fa fa-caret-left" alt=""></i></a></span>
							<span class="input-group-addon">#dateformat(first_day,dateformat_style)# - #dateformat(seventh_day,dateformat_style)#</span>
							<span class="input-group-addon"><a href="#cgi.script_name#?fuseaction=#attributes.fuseaction#&page_type=0&mode=&yil=#dateformat(next_week,"yyyy")#&ay=#dateformat(next_week,"mm")#&gun=#dateformat(next_week,"dd")#"><i class="fa fa-caret-right" alt=""></i></a></span>
						</div>
					</cfoutput>
				</th>
			</tr>
			<tr height="22">
				<cfoutput>
				<th align="center" width="14%">#dateformat(first_day,"dd")# - <cf_get_lang_main no='192.Pazartesi'></th>
				<th align="center" width="14%">#dateformat(second_day,"dd")# - <cf_get_lang_main no='193.Salı'></th>
				<th align="center" width="14%">#dateformat(third_day,"dd")# - <cf_get_lang_main no='194.Çarşamba'></th>
				<th align="center" width="14%">#dateformat(fourth_day,"dd")# - <cf_get_lang_main no='195.Perşembe'></th>
				<th align="center" width="14%">#dateformat(fifth_day,"dd")# - <cf_get_lang_main no='196.Cuma'></th>
				<th align="center" width="14%">#dateformat(sixth_day,"dd")# - <cf_get_lang_main no='197.Cumartesi'></th>
				<th align="center" width="14%">#dateformat(seventh_day,"dd")# - <cf_get_lang_main no='198.Pazar'></th>
				</cfoutput> 
			</tr>
		</thead>
		<tr> 
		  <cfloop from="1" to="7" index="x">
			<cfoutput>
          	<td height="150" valign="top" class="label">
				<cfswitch expression="#x#">
					<cfcase value=1>
						<cfset yil = dateformat(first_day,"yyyy")>
						<cfset ay = dateformat(first_day,"mm")>
						<cfset gun = dateformat(first_day,"dd")>
					</cfcase>
					<cfcase value=2>
						<cfset yil = dateformat(second_day,"yyyy")>
						<cfset ay = dateformat(second_day,"mm")>
						<cfset gun = dateformat(second_day,"dd")>
					</cfcase>
					<cfcase value=3>
						<cfset yil = dateformat(third_day,"yyyy")>
						<cfset ay = dateformat(third_day,"mm")>
						<cfset gun = dateformat(third_day,"dd")>
					</cfcase>
					<cfcase value=4>
						<cfset yil = dateformat(fourth_day,"yyyy")>
						<cfset ay = dateformat(fourth_day,"mm")>
						<cfset gun = dateformat(fourth_day,"dd")>
					</cfcase>
					<cfcase value=5>
						<cfset yil = dateformat(fifth_day,"yyyy")>
						<cfset ay = dateformat(fifth_day,"mm")>
						<cfset gun = dateformat(fifth_day,"dd")>
					</cfcase>
					<cfcase value=6>
						<cfset yil = dateformat(sixth_day,"yyyy")>
						<cfset ay = dateformat(sixth_day,"mm")>
						<cfset gun = dateformat(sixth_day,"dd")>
					</cfcase>
					<cfcase value=7>
						<cfset yil = dateformat(seventh_day,"yyyy")>
						<cfset ay = dateformat(seventh_day,"mm")>
						<cfset gun = dateformat(seventh_day,"dd")>
					</cfcase>
				</cfswitch>
				<cfset attributes.to_day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
                <cfset compare_tarih="#yil#-#numberformat(ay,'00')#-#numberformat(gun,'00')#">
                <cfset attributes.tarih_egitim = '#yil#-#ay#-#gun#'>
					  
				<cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >
				<cfinclude  template="../query/get_todays_organizations.cfm">
				<cfloop query="get_tr">
					<cfif not len(get_tr.finish_date[currentrow]) and not len(get_tr.start_date[currentrow])>
						<cfset color_="000000">
					<cfelse>
						<cfset compare_tarih=dateformat(get_tr.finish_date[currentrow],"yyyy-mm-dd")>
						<cfset start_tarih=dateformat(get_tr.start_date[currentrow],"yyyy-mm-dd")>
						<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih lt tarih_bugun and compare_tarih gt tarih_bugun )>
							<cfset color_="FF0000">
						<cfelse>
							<cfset color_="FF00FF">
						</cfif>
					</cfif>
					<cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
						<cfif is_project_current eq 1>
							<cfif len(company_id) and len(company_id_list)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_partner_detail.nickname[listfind(company_id_list,partner_id,',')]#</a>-
							<cfelseif len(consumer_id) and len(consumer_id_list)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
							</cfif>
						</cfif>
						<a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#get_tr.organization_id#" ><font color="#color_#">#get_tr.organization_head#</font></a>
						<cfif compare_tarih eq start_tarih ><img src="/images/starton.gif" border="0" alt="<cf_get_lang_main no='1055.Start'>"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"> <img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='90.Bitiş'>" align="absmiddle">
						<cfelseif attributes.tarih_egitim eq compare_tarih ><img src="/images/stop.gif" border="0" alt="<cf_get_lang_main no='90.Bitiş'>" title="<cf_get_lang_main no='90.Bitiş'>" align="absmiddle"> <img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"></cfif><br/>
						</cfif>	
				</cfloop>	
				</cfoutput>	 
			</cfloop>
		  	</tr>
	</cf_grid_list>
</div>
<script type="text/javascript">
<cfoutput>
function pencere_ac_upd(event_plan_id,event_plan_row_id,partner_id,company_id,result_id,type)
{
	if(type == 1)
		windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id,'medium');	
	else
	{
		document.location.href = '#request.self#?fuseaction=crm.detail_company&cpid=' + company_id +'&is_visit=1';
		windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id,'medium');
	}
}
function pencere_ac(event_plan_id,event_plan_row_id,partner_id,company_id,type)
{
	if(type == 1)
		windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id,'medium');		
	else
	{
		document.location.href = '#request.self#?fuseaction=crm.detail_company&cpid=' + company_id +'&is_visit=1';
		windowopen('#request.self#?fuseaction=objects.popup_add_event_plan_result&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id,'medium');
	}
}
</cfoutput>
</script>
