<cf_xml_page_edit fuseact="assetcare.dsp_care_calender">
<cfparam name="attributes.official_emp_id" default="">
<cfparam name="attributes.assetpcatid" default="">
<cfparam name="attributes.official_emp" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.time_type" default="3">
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
		tarih = createDate(yil,ay,1);
		bas = DayofWeek(tarih)-1;
	if (bas eq 0)
		bas = 7;
		son = DaysinMonth(tarih);
		gun = 1;
		yer = '#request.self#?fuseaction=assetcare.list_monthly_report';
		attributes.day = date_add("h",-session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
</cfscript>
<cfset adres="assetpcatid=#attributes.assetpcatid#&official_emp=#attributes.official_emp#&asset_id=#attributes.asset_id#&asset_cat=#attributes.asset_cat#&department_id=#attributes.department_id#&branch_id=#attributes.branch_id#&time_type=#attributes.time_type#&official_emp_id=#attributes.official_emp_id#">
<cfoutput>
<br/>
<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td class="dpht"><cf_get_lang_main no='1520.Aylık'><cf_get_lang_main no='1885.Bakım Planı'></td>
        <!-- sil -->
        <td class="dphb">
		<table>
			<tr>
				<td height="20" align="left"><a href="#yer#&ay=#ay#&yil=#oncekiyil#&#adres#"><img alt="" src="/images/previous20.gif" border="0" align="absmiddle"></a></td>
				<td align="center" width="10" class="headbold">#Year(tarih)#</td>
				<td style="text-align:right;"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#&#adres#"><img src="/images/next20.gif" border="0" alt="" align="absmiddle"></a></td>
				<td align="left"><a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>&#adres#"><img src="/images/previous20.gif" alt="" border="0" align="absmiddle"></a></td>
				<td align="center" width="10" class="headbold">#ListGetAt(aylar,Month(tarih))#</td>
				<td><a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>&#adres#"><img src="/images/next20.gif" border="0" alt="" align="absmiddle"></a></td>
			</tr>
		</table>
        </td>
	</tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td colspan="2"><cfinclude template="dsp_care_calender_search.cfm"></td>
    </tr>
    <!-- sil -->
</table>
</cfoutput>
<table cellspacing="0" cellpadding="0" width="98%" align="center">
	<tr class="color-border">
    	<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-header">
				<td height="22" align="center" width="14%" class="form-title"><cf_get_lang_main no='192.Pazartesi'></td>
				<td align="center" width="14%" class="form-title"><cf_get_lang_main no='193.Salı'></td>
				<td align="center" width="14%" class="form-title"><cf_get_lang_main no='194.Çarşamba'></td>
				<td align="center" width="14%" class="form-title"><cf_get_lang_main no='195.Perşembe'></td>
				<td align="center" width="14%" class="form-title"><cf_get_lang_main no='196.Cuma'></td>
				<td align="center" width="14%" class="form-title"><cf_get_lang_main no='197.Cumartesi'></td>
				<td align="center" class="form-title"><cf_get_lang_main no='198.Pazar'></td>
			</tr>
			<cfset sayac =0>
			<tr class="color-list">
			<cfloop index="x" from="1" to="#Evaluate(bas-1)#">
			  	<td height="20">&nbsp;</td>
			</cfloop>
			<cfloop index="x" from="#bas#" to="7">
			  	<td height="20" class="txtbold"><cfoutput><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
				<cfset gun = gun +1>
				<cfset sayac = sayac +1>
			</cfloop>
			</tr>
			<cfset gun = gun - sayac>
			<tr class="color-row">
			<cfloop index="x" from="1" to="#Evaluate(bas-1)#">
			  	<td height="79"></td>
			</cfloop>
			<cfloop index="x" from="#bas#" to="7">
			  <cfoutput>
				<td height="79" valign="top">
				  <cfset attributes.day = CreateODBCDatetime('#yil#-#ay#-#gun#')>
				  <cfset acreatdate = attributes.day>
				  <cfinclude template="../query/get_asset_cares_all.cfm">
				 <cfoutput>
					<cfloop query="get_asset_cares_all">
					  <cfif len(get_asset_cares_all.period_time) and dateformat(get_asset_cares_all.period_time,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>

                        <cfif get_asset_cares_all.it_asset eq 1>
							<cfset assetp_link = "list_asset_it&event=upd">
                        <cfelseif get_asset_cares_all.motorized_vehicle eq 1>
                            <cfset assetp_link = "list_vehicles&event=upd">
                        <cfelseif get_asset_cares_all.motorized_vehicle neq 1 and get_asset_cares_all.it_asset neq 1>
                            <cfset assetp_link = "list_assetp&event=upd">
                        </cfif>
						<cfswitch expression="#get_asset_cares_all.period_id#">
						  <cfcase value="1">
						  <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
						  <cfif care_date_period mod 7 is 0>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="4">
							<cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
							  <cfif care_date_period mod 15 is 0>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp# </a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
						  </cfcase>

                            <cfcase value="2">
                                <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                <cfif care_date_period mod 21 is 0>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp# </a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
						  <cfcase value="5">
						  <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif asset_care_start eq start_date_now>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="6">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="7">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="8">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="9">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="10">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						  <cfcase value="11">
						  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
						  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
						  <cfset start_date_now=day(acreatdate)>
						  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 24 is 0)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
                            <cfcase value="12">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 36 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
                            <cfcase value="13">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 48 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
                            <cfcase value="14">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 60 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
						  <cfcase value="">
						  <cfset asset_care_start=get_asset_cares_all.period_time>
						  <cfset start_date_now=acreatdate>
						  <cfif (asset_care_start is start_date_now)>
							<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
							<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
							<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
						  </cfif>
						  </cfcase>
						</cfswitch>
					  </cfif>
					</cfloop>
				  </cfoutput>
				 </td>
			  </cfoutput>
			  <cfset gun = gun +1>
			</cfloop>
			</tr>
			<cfloop index=y from=2 to=6>
			<cfset sayac=0>
			<tr class="color-list">
			  <cfloop index=x from=1 to=7>
				<cfif gun lte son>
				  <td height="20" class="txtbold"><cfoutput><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
				  <cfelse>
				  <td>&nbsp;</td>
				</cfif>
				<cfset gun = gun +1>
				<cfset sayac = sayac +1>
			  </cfloop>
			</tr>
			<cfset gun=gun-sayac>
			<tr valign="top" class="color-row"> <cfoutput>
				<cfloop index=x from=1 to=7>
				  <cfif gun lte son>
					<td height="80">
					  <cfset attributes.day = CreateODBCDatetime('#yil#-#ay#-#gun#')>
					  <cfset acreatdate = attributes.day>
					  <cfinclude template="../query/get_asset_cares_all.cfm">
					  <cfoutput>
						<cfloop query="get_asset_cares_all">
						 <cfif len(get_asset_cares_all.period_time) and dateformat(get_asset_cares_all.period_time,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>
						<cfif get_asset_cares_all.it_asset eq 1>
								<cfset assetp_link = "list_asset_it&event=upd">
                            <cfelseif get_asset_cares_all.motorized_vehicle eq 1>
                                <cfset assetp_link = "list_vehicles&event=upd">
                            <cfelseif get_asset_cares_all.motorized_vehicle neq 1 and get_asset_cares_all.it_asset neq 1>
                                <cfset assetp_link = "list_assetp&event=upd">
                            </cfif>

						<cfswitch expression="#get_asset_cares_all.period_id#">
							  <cfcase value="1">
							  <cfset care_date_period = datediff("d",get_asset_cares_all.period_time,acreatdate)>
							  <cfif care_date_period mod 7 is 0>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="4">
							  <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
							  <cfif care_date_period mod 15 is 0>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
                            <cfcase value="2">
                                <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                <cfif care_date_period mod 21 is 0>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
							  <cfcase value="5">
							  <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif asset_care_start eq start_date_now>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="6">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="7">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="8">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="9">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="10">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							  <cfcase value="11">
							  <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
							  <cfset asset_care_start=day(get_asset_cares_all.period_time)>
							  <cfset start_date_now=day(acreatdate)>
							  <cfif (asset_care_start eq start_date_now) and (care_date_period mod 24 is 0)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
                            <cfcase value="12">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 36 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
                            <cfcase value="13">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 48 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
                            <cfcase value="14">
                                <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                <cfset start_date_now=day(acreatdate)>
                                <cfif (asset_care_start eq start_date_now) and (care_date_period mod 60 is 0)>
                                    <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                    <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                </cfif>
                            </cfcase>
							  <cfcase value="">
							  <cfset asset_care_start=get_asset_cares_all.period_time>
							  <cfset start_date_now=acreatdate>
							  <cfif (asset_care_start is start_date_now)>
								<a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
								<a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
								<cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
							  </cfif>
							  </cfcase>
							</cfswitch>
						  </cfif>
						</cfloop>
					  </cfoutput>
					  </td>
					<cfelse>
					<td height="80">&nbsp;</td>
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
