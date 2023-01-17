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
	attributes.to_day = date_add('h', -session.pda.time_zone, first_day);
</cfscript>

<cfparam name="attributes.event_id" default="">
<cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
</cfquery>
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
<cfset gun_isimleri = "">
<cfloop from="1" to="7" index="c">
	<cfif	c eq 1><cfsavecontent variable="dil_">Pazartesi</cfsavecontent>
	<cfelseif c eq 2><cfsavecontent variable="dil_">Salı</cfsavecontent>
	<cfelseif c eq 3><cfsavecontent variable="dil_">Çarşamba</cfsavecontent>
	<cfelseif c eq 4><cfsavecontent variable="dil_">Perşembe</cfsavecontent>
	<cfelseif c eq 5><cfsavecontent variable="dil_">Cuma</cfsavecontent>
	<cfelseif c eq 6><cfsavecontent variable="dil_">Cumartesi</cfsavecontent>
	<cfelseif c eq 7><cfsavecontent variable="dil_">Pazar</cfsavecontent>
	</cfif>
	<cfset gun_isimleri = listappend(gun_isimleri,'#dil_#')>
</cfloop>
<cfinclude template="../query/get_weekly_events.cfm">
<cfinclude template="../query/get_weekly_works.cfm">
<cfinclude template="../query/get_event_plan_rows.cfm">
<cfinclude template="agenda_tr.cfm">

<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
	<tr>
    	<td>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<cfoutput>
					<td class="infotag">Haftalık</td>
					<td width="15"><a href="#request.self#?fuseaction=pda.weekly&yil=#dateformat(last_week,"yyyy")#&ay=#dateformat(last_week,"mm")#&gun=#dateformat(last_week,"dd")#" title="Önceki"><img src="/images/previous20.gif" width="15" height="20" border="0" align="absmiddle" title="Önceki" alt="Önceki"></a></td>
					<td class="infotag"> #dateformat(first_day,'dd/mm/yyyy')# - #dateformat(seventh_day,'dd/mm/yyyy')#</td>
					<td width="15"><a href="#request.self#?fuseaction=pda.weekly&yil=#dateformat(next_week,"yyyy")#&ay=#dateformat(next_week,"mm")#&gun=#dateformat(next_week,"dd")#" title="Sonraki"><img src="/images/next20.gif" width="15" height="20" border="0" align="absmiddle" title="Sonraki" alt="Sonraki"></a></td>
					</cfoutput>
				</tr>
			</table>
		</td>
    	<td align="right" style="vertical-align:bottom"></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">
	<cfoutput>
		<cfloop from="0" to="6" index="i">
			<cfset attributes.to_day = date_add('d',i,first_day)>
			<tr class="color-row" style="height:20px;">
				<td style="width:33%">
					<a href="#request.self#?fuseaction=pda.daily&yil=#dateformat(attributes.to_day,"yyyy")#&ay=#dateformat(attributes.to_day,"mm")#&gun=#dateformat(attributes.to_day,"dd")#" class="infotag">#dateformat(attributes.to_day,"dd")# - #listgetat(gun_isimleri,i+1)#</a>
				</td>
				<td <cfif date_list contains (date_add('d',i+1,first_day))> class="color-list"</cfif> style="vertical-align:top">
					<cfloop query="get_event_plan">
						<cfif len(is_sales)>
							<cfset value_is_sales = is_sales>
						<cfelse>
							<cfset value_is_sales = 0>
						</cfif>
						<cfif dateformat(attributes.to_day,'dd/mm/yyyy') eq dateformat(get_event_plan.start_date,'dd/mm/yyyy')> 
							<cfif event_plan_id eq "">
								<li></li>
							<cfelse>
								<cfif len(result_record_emp)>
									<li><a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi"><cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> - <font color="##990000">Ziyaret</font></li>
								<cfelse>
									<li><a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi"><cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> - <font color="##990000">Ziyaret</font></li>
								</cfif>
							</cfif>
							<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#company_id#" title="Sipariş Al"><img src="/images/plus_small.gif" align="absmiddle" border="0" alt="Sipariş Al" title="Sipariş Al"></a>
						</cfif>
					</cfloop>
					<cfloop query="get_weekly_events">
						<cfif ((dateformat(attributes.to_day,"dd") eq Day(get_weekly_events.startdate)) or (dateformat(attributes.to_day,"dd") eq Day(get_weekly_events.finishdate)))>
							<cfset attributes.eventcat = get_weekly_events.eventcat>
							<li style="margin-left:20px;">
								<a href="#request.self#?fuseaction=pda.form_upd_event&event_id=#event_id#" class="tableyazi">
								#timeformat(date_add('h',session.pda.time_zone,startdate),'HH:mm')#-#eventcat#-#event_head#</a>							
								<cfif not len(get_weekly_events.event_place_id)>
									<cfelseif get_weekly_events.event_place_id eq 1><font color=red>(Ofis içi)
									<cfelseif get_weekly_events.event_place_id eq 2><font color=red>(Ofis Dışı)
									<cfelseif get_weekly_events.event_place_id eq 3><font color=red>(3.Parti Kurum)
								</cfif>
							</li>
						</cfif>
					</cfloop>
					<cfloop query="weekly_works">
						<cfif ((weekly_works.target_start gte attributes.to_day) and (weekly_works.target_start lt date_add('d',1,attributes.to_day))) or ((weekly_works.target_finish gte attributes.to_day) and (weekly_works.target_finish lt date_add('d',1,attributes.to_day)))>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=project.popup_updwork&id=#work_id#','medium');return false;" class="tableyazi">#timeformat(date_add('h',session.pda.time_zone,weekly_works.target_start),'HH:mm')#-<cf_get_lang no='7.iş'> - #work_head#</a></li>
						</cfif>
					</cfloop>
					&nbsp;
				</td>
			</tr>
		</cfloop>
	</cfoutput>
</table>
<br/>
<script type="text/javascript">
	<cfoutput>
	function pencere_ac_upd(event_plan_id,event_plan_row_id,partner_id,company_id,type)
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
