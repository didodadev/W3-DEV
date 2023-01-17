<cfsetting showdebugoutput="false">
<cfscript>
	if (isDefined('attributes.ay'))
		ay = attributes.ay;
	else
		ay = DateFormat(now(),'mm');
	
	if (isDefined('attributes.yil'))
		yil = attributes.yil;
	else
		yil = DateFormat(now(),'yyyy');
	
	oncekiyil = yil-1;
	sonrakiyil = yil+1;
	oncekiay = ay-1;
	sonrakiay = ay+1;
	
	if (ay eq 1)
		oncekiay=12;
		
	if (ay eq 12)
		sonrakiay=1;
		
	aylar = ay_list();
	tarih = createDate(yil,ay,1);
	bas = DayofWeek(tarih)-1;
	if (bas eq 0)
		bas=7;
	son = DaysinMonth(tarih);
	gun = 1;
	yer = '#request.self#?fuseaction=myhome.popup_time_cost_calendar';
	month_first = createDateTime(yil,ay,1,0,0,0);
	total_day = DaysinMonth(month_first);
	month_last = createDateTime(yil,ay,total_day,23,59,59);
</cfscript>
<cfquery name="get_time_costs" datasource="#dsn#">
	SELECT 
		TCC.TIME_COST_CAT_ID,
		TCC.COLOUR,
		YEAR(TC.EVENT_DATE) YIL,
		MONTH(TC.EVENT_DATE) AY,
		DAY(TC.EVENT_DATE) GUN,
		SUM(TC.EXPENSED_MINUTE) AS TOTAL_MIN
	FROM 
		TIME_COST TC
		LEFT JOIN TIME_COST_CAT TCC ON TC.TIME_COST_CAT_ID = TCC.TIME_COST_CAT_ID
	WHERE
		TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_first#">
		AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_last#">
	GROUP BY
		TCC.TIME_COST_CAT_ID,
		TCC.COLOUR,
		YEAR(TC.EVENT_DATE),
		MONTH(TC.EVENT_DATE),
		DAY(TC.EVENT_DATE)
</cfquery>
<cfsavecontent variable="txt">
	
</cfsavecontent>
<div id="body_calendar">
	<cfoutput>
		<a href="javascript://" onclick="list_calendar('#ay#','#oncekiyil#');"><i class="fa fa-caret-left" ></i></a>
		#Year(tarih)#
		<a href="javascript://" onclick="list_calendar('#ay#','#sonrakiyil#');"><i class="fa fa-caret-right"></i></a>&nbsp
		<a href="javascript://" onclick="list_calendar('#oncekiay#','<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>');"><i class="fa fa-caret-left"></i></a>
		#ListGetAt(aylar,Month(tarih))#
		<a href="javascript://" onclick="list_calendar('#sonrakiay#','<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>');"><i class="fa fa-caret-right"></i></a>
	</cfoutput>	
			<cf_grid_list>
				<thead>
					<tr class="color-header">
						<th height="22" class="text-center" width="14%" class="form-title"><cf_get_lang dictionary_id='57604.Pazartesi'></th>
						<th class="text-center" width="14%" class="form-title"><cf_get_lang dictionary_id='57605.Salı'></th>
						<th class="text-center" width="15%" class="form-title"><cf_get_lang dictionary_id='57606.Çarsamba'></th>
						<th class="text-center" width="15%" class="form-title"><cf_get_lang dictionary_id='57607.Perşembe'></th>
						<th class="text-center" width="14%" class="form-title"><cf_get_lang dictionary_id='57608.Cuma'></th>
						<th class="text-center" width="14%" class="form-title"><cf_get_lang dictionary_id='57609.Cumartesi'></th>
						<th class="text-center" width="14%" class="form-title"><cf_get_lang dictionary_id='57610.Pazar'></th>
					</tr>
				</thead>
				<cfset sayac = 0>
				<tr class="color-list">
					<cfloop index="x" from="1" to="#evaluate(bas-1)#">
						<td height="20">&nbsp;</td>
					</cfloop>
					<cfloop index="x" from="#bas#" to="7">
						<cfset add_date = '#yil#-#ay#-#gun#'>
						<td height="20" class="txtbold"><cfoutput><a href="javascript://" onclick="kapat('#year(add_date)#','#month(add_date)#','#day(add_date)#');">#gun#</a></cfoutput></td>
						<cfset gun = gun + 1>
						<cfset sayac = sayac + 1>
					</cfloop>
				</tr>
				<cfset gun = gun - sayac>
				<tr class="color-row">
					<cfloop index="x" from="1" to="#evaluate(bas-1)#">
						<td height="80">&nbsp;</td>
					</cfloop>
					<cfset gun=0>
					<cfloop index="x" from="#bas#" to="7">
						<cfset gun = gun + 1>
						<cfset add_date = '#yil#-#ay#-#gun#'>
						<cfoutput>
							<td height="80" valign="top" class="txtbold" style="text-align:center;">
								<cfset today_first = createDateTime(yil,ay,gun,0,0,0)>
								<cfset today_last = createDateTime(yil,ay,gun,23,59,59)>
								<cfquery name="get_today_time_cost" dbtype="query">
									SELECT * FROM get_time_costs WHERE YIL = #yil# AND AY = #ay# AND GUN = #gun#
								</cfquery>
								<cfif get_today_time_cost.recordcount>
									<cfloop query="get_today_time_cost">
										<cfif len(colour)>
											<cfset color_ = colour>
										<cfelse>
											<cfset color_="000000">
										</cfif>
										<a href="javascript://" onclick="kapat('#year(add_date)#','#month(add_date)#','#day(add_date)#');"><font color="#color_#"></br>#tlformat(total_min/60,2)#&nbsp<i class="fa fa-clock-o"></i></font></a>
									</cfloop>
								</cfif>
								&nbsp;
							</td>
						</cfoutput>
					</cfloop>
				<cfset gun = gun + 1>
				</tr>
				<cfset temp_day = total_day - gun + 1>
				<cfset day_mod = temp_day % 7>
				<cfif day_mod gt 0>
					<cfset week_count = (temp_day / 7) + 1>
				<cfelse>
					<cfset week_count = temp_day / 7>
				</cfif>
				
				<cfloop index=y from=1 to=#week_count#>
					<cfset sayac=0>
					<tr class="color-list">
						<cfloop index=x from=1 to=7>
							<cfif gun lte son>
								<cfset add_date = '#yil#-#ay#-#gun#'>
								<td height="20" class="txtbold"><cfoutput><a href="javascript://" onclick="kapat('#year(add_date)#','#month(add_date)#','#day(add_date)#');">#gun#</a></cfoutput></td>
							<cfelse>
								<td>&nbsp;</td>
							</cfif>
							<cfset gun = gun +1>
							<cfset sayac = sayac +1>
						</cfloop>
					</tr>
					<cfset gun=gun-sayac>
					<tr valign="top" class="color-row">
						<cfoutput>
							<cfloop index="x" from="1" to="7">
								<cfif gun lte son>
									<cfset add_date = '#yil#-#ay#-#gun#'>
									<td height="80" class="txtbold" style="text-align:center;">
										<cfquery name="get_today_time_cost" dbtype="query">
											SELECT * FROM get_time_costs WHERE YIL = #yil# AND AY = #ay# AND GUN = #gun#
										</cfquery>
										<cfloop query="get_today_time_cost">
											<cfif len(colour)>
												<cfset color_ = colour>
											<cfelse>
												<cfset color_="000000">
											</cfif>
											<a href="javascript://" onclick="kapat('#year(add_date)#','#month(add_date)#','#day(add_date)#');"><font color="#color_#"></br>#tlformat(total_min/60,2)#&nbsp<i class="fa fa-clock-o"></i></font></a><br>
										</cfloop>
									</td>
								<cfelse>
									<td height="80">&nbsp;</td>
								</cfif>
								<cfset gun = gun +1>
							</cfloop>
						</cfoutput>
					</tr>
				</cfloop>
			</cf_grid_list>
</div>
<script type="text/javascript">
	function list_calendar(ay,yil)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.popup_time_cost_calendar</cfoutput>&ay='+ay+'&yil='+yil,'body_calendar',1);
	}
	
	function kapat(yr,mn,dy)
	{
		if(mn.length == 1)
			mnth = '0'+mn;
		else
			mnth = mn;
		if(dy.length == 1)
			day = '0'+dy;
		else
			day = dy;
		window.location="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.time_cost&today="+day+'/'+mnth+'/'+yr;
	}
</script>