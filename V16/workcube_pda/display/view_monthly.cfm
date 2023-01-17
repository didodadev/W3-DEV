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
	
	aylar = 'Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık';
	list_gunler = 'Pz,Pzt,Sl,rs,Prs,Cm,Cts';	
	
	if(yil mod 4 eq 0)
	{
		aygun_list = '31,29,31,30,31,30,31,31,30,31,30,31';
	}
	else
	{
		aygun_list = '31,28,31,30,31,30,31,31,30,31,30,31';
	}
	tarih = createDate(yil,ay,1);
	bas = DayofWeek(tarih)-1;
	if (bas eq 0)
		bas=7;
	son = DaysinMonth(tarih);
	gun = 1;
	yer = '#request.self#?fuseaction=pda.monthly';
	attributes.to_day = CreateODBCDatetime('#yil#-#ay#-#gun#');
	tarih1 = CreateODBCDatetime('#yil#-#ay#-1');
	tarih2 = CreateODBCDatetime('#yil#-#ay#-#son#');
	fark = (-1)*(dayofweek(tarih)-2);
	if (fark eq 1) fark = -6;
	first_day = date_add('d',fark,tarih);
	attributes.to_day = date_add('h', -session.pda.time_zone, date_add('d',fark,tarih));
</cfscript>
<cfinclude template="../query/get_monthly_events.cfm">
<cfinclude template="../query/get_monthly_works.cfm"> 
<cfinclude template="../query/get_event_plan_rows.cfm">
<cfquery name="GET_MEMBER_ANALY_RES" datasource="#DSN#">
	SELECT COMPANY_ID, PARTNER_ID, ANALYSIS_ID FROM MEMBER_ANALYSIS_RESULTS
</cfquery>
<cfinclude template="agenda_tr.cfm">
<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
  	<tr>
    	<td>
      		<table cellpadding="0" cellspacing="0">
				<tr class="color-row"> 
					<cfoutput>
						<td class="infotag">Aylık</td>
						<td nowrap class="infotag">
							<a href="#yer#&ay=#ay#&yil=#oncekiyil#"><img src="/images/previous20.gif" border="0" align="absmiddle"></a>#Year(tarih)#<a href="#yer#&ay=#ay#&yil=#sonrakiyil#"><img src="/images/next20.gif" border="0" align="absmiddle"></a>
							<a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>"><img src="/images/previous20.gif" border="0" align="absmiddle"></a>#ListGetAt(aylar,Month(tarih))#<a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>"><img src="/images/next20.gif" border="0" align="absmiddle"></a>
						</td>
					</cfoutput> 
				</tr>
      		</table>
    	</td>
  	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">
	<cfset date_list = "">
	<cfoutput>
		<cfset sayac=0> 
		<cfloop from="1" to="#listgetat(aygun_list,ay,',')#" index="i">
			<tr class="color-row" style="height:20px;">
				<cfif gun lte son><td style="width:20%"><a href="#request.self#?fuseaction=pda.daily&yil=#yil#&ay=#ay#&gun=#gun#" class="infotag">#gun# - #listgetat(list_gunler,dayofweek(createdatetime(yil,ay,i,0,0,0)),',')#</a></td></cfif>
				<cfset attributes.my_day = date_add('d',-1,createdate(yil,ay,gun))>
				<cfset gun = gun +1> 
				<cfset sayac = sayac +1>
				<cfset attributes.to_day = date_add('h',-session.pda.time_zone,date_add('d',i-1,first_day))>
				<td <cfif date_list contains (date_add('d',i,first_day))> class="color-list"</cfif> >
					<cfloop query="get_event_plan">
						<cfif len(is_sales)>
							<cfset value_is_sales = is_sales>
						<cfelse>
							<cfset value_is_sales = 0>
						</cfif>
						<cfif dateformat(date_add("d",1,attributes.my_day),'dd/mm/yyyy') eq dateformat(get_event_plan.start_date,'dd/mm/yyyy')>										
							<cfif not len(event_plan_id)>
								<li></li>
							<cfelse>
								<cfif len(result_record_emp)>
									<li style="margin-left:20px;">
										<a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi"><cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> - 
										<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#company_id#"><img src="/images/plus_small.gif" align="absmiddle" border="0" title="Sipariş Al" class="form_icon"></a>
									</li>
								<cfelse>
									<li style="margin-left:20px;">
										<a href="#request.self#?fuseaction=pda.form_upd_event&event_id=#event_plan_id#" class="tableyazi"><cfif len(get_event_plan.warning_id[currentrow])><cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[get_event_plan.warning_id[currentrow]]#<cfelse>#get_cat.visit_type[get_event_plan.warning_id[currentrow]]#</cfif></cfif> - #fullname# - #company_partner_name# #company_partner_surname#</a> -
										<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#company_id#"><img src="/images/order.bmp" align="absmiddle" border="0" title="Sipariş Al"></a>
										<cfquery name="GET_ANALYSE_RES" dbtype="query">
											SELECT * FROM GET_MEMBER_ANALY_RES WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#"> AND ANALYSIS_ID = 1
										</cfquery>
										<cfif get_analyse_res.recordcount>
											<a href="#request.self#?fuseaction=pda.form_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#"><img src="/images/label.gif" border="0" align="absmiddle" title="Ziyaret Sonucu"></a>										
										<cfelse>
											<a href="#request.self#?fuseaction=pda.form_add_member_analysis_result&analysis_id=1&member_type=partner&company_id=#company_id#&partner_id=#partner_id#"><img src="/images/form_icon.bmp" border="0" align="absmiddle" title="Ziyaret Formu"></a>
										</cfif>
									</li>
								</cfif>
							</cfif>
							<!---<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#company_id#"><img src="/images/plus_small.gif" align="absmiddle" border="0" title="Sipariş Al"></a>--->
						</cfif>
					</cfloop>
					<cfloop query="get_monthly_events">
						<cfif (day(get_monthly_events.startdate) eq day(date_add("d",1,attributes.my_day)) and (month(get_monthly_events.startdate) eq month(date_add("d",1,attributes.my_day))) and (year(get_monthly_events.startdate) eq year(date_add("d",1,attributes.my_day))))>
							<cfset attributes.eventcat = get_monthly_events.eventcat>
							<li style="margin-left:20px;"><a href="#request.self#?fuseaction=pda.form_upd_event&event_id=#event_id#" class="tableyazi"><font color="000000" class="infotag">#timeformat(date_add('h',session.pda.time_zone,startdate),'HH:mm')#-</font>#eventcat#-#event_head#</a></li> 
						</cfif>
					</cfloop>	
				</td>
			</tr>
		</cfloop>
	</cfoutput>
</table>
<br/>
