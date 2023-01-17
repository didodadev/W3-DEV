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
<cfparam name="attributes.time_type" default="2">
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
		attributes.day = date_add('h', -session.ep.time_zone, first_day);
</cfscript>

<cfset temp_adres = "">
<cfif len(attributes.assetpcatid)>
	<cfset temp_adres = "#temp_adres#&assetpcatid=#attributes.assetpcatid#">
</cfif>
<cfif len(attributes.asset_id)>
	<cfset temp_adres = "#temp_adres#&asset_id=#attributes.asset_id#">
</cfif>
<cfif len(attributes.asset_cat)>
	<cfset temp_adres = "#temp_adres#&asset_cat=#attributes.asset_cat#">
</cfif>
<cfif len(attributes.department_id)>
	<cfset temp_adres = "#temp_adres#&department_id=#attributes.department_id#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset temp_adres = "#temp_adres#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.official_emp_id)>
	<cfset temp_adres = "#temp_adres#&official_emp_id=#attributes.official_emp_id#">
</cfif>
<cfset adres="#temp_adres#&time_type=#attributes.time_type#">

<!---  BK 20130522 90 güne silinsin <cfset adres="assetpcatid=#attributes.assetpcatid#&official_emp=#attributes.official_emp#&asset_id=#attributes.asset_id#&asset_cat=#attributes.asset_cat#&department_id=#attributes.department_id#&branch_id=#attributes.branch_id#&time_type=#attributes.time_type#&official_emp_id=#attributes.official_emp_id#"> --->
<cfoutput>
<br/>
<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td class="dpht"><cf_get_lang no='111.Haftalık Bakım Planı'></td>
        <!-- sil -->
        <td class="dphb">
            <table>
                <tr>
                    <td width="15"><a href="#request.self#?fuseaction=assetcare.list_weekly_report&yil=#dateformat(last_week,"yyyy")#&ay=#dateformat(last_week,"mm")#&gun=#dateformat(last_week,"dd")##adres#"><img src="/images/previous20.gif" border="0" align="absmiddle"></a></td>
                    <td width="auto" class="headbold"> #dateformat(first_day,dateformat_style)# - #dateformat(seventh_day,dateformat_style)#</td>
                    <td width="15"><a href="#request.self#?fuseaction=assetcare.list_weekly_report&yil=#dateformat(next_week,"yyyy")#&ay=#dateformat(next_week,"mm")#&gun=#dateformat(next_week,"dd")##adres#"><img src="/images/next20.gif" border="0" align="absmiddle"></a></td>
                </tr>
            </table>
        </td>
	</tr>
</table>
<table width="99%" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td colspan="2"><cfinclude template="dsp_care_calender_search.cfm"></td>
    </tr>
    <!-- sil -->
</table>

<table cellspacing="0" cellpadding="0" width="98%">
    <tr class="color-border">
        <td>          
        <table cellspacing="1" cellpadding="2" width="100%" border="0" height="325">
            <tr height="22" class="color-header">
                <td align="center" width="16%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(first_day,"yyyy")#&ay=#dateformat(first_day,"mm")#&gun=#dateformat(first_day,"dd")#" class="form-title">#dateformat(first_day,"dd")# - <cf_get_lang_main no='192.Pazartesi'></a></td>
                <td align="center" width="16%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(second_day,"yyyy")#&ay=#dateformat(second_day,"mm")#&gun=#dateformat(second_day,"dd")#" class="form-title">#dateformat(second_day,"dd")# - <cf_get_lang_main no='193.Salı'></a></td>
                <td align="center" width="16%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(third_day,"yyyy")#&ay=#dateformat(third_day,"mm")#&gun=#dateformat(third_day,"dd")#" class="form-title">#dateformat(third_day,"dd")# - <cf_get_lang_main no='194.Çarşamba'></a></td>
                <td align="center" width="16%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(fourth_day,"yyyy")#&ay=#dateformat(fourth_day,"mm")#&gun=#dateformat(fourth_day,"dd")#" class="form-title">#dateformat(fourth_day,"dd")# - <cf_get_lang_main no='195.Perşembe'></a></td>
                <td align="center" width="16%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(fifth_day,"yyyy")#&ay=#dateformat(fifth_day,"mm")#&gun=#dateformat(fifth_day,"dd")#" class="form-title">#dateformat(fifth_day,"dd")# - <cf_get_lang_main no='196.Cuma'></a></td>
                <td align="center" width="20%" class="form-title"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(sixth_day,"yyyy")#&ay=#dateformat(sixth_day,"mm")#&gun=#dateformat(sixth_day,"dd")#" class="form-title">#dateformat(sixth_day,"dd")# - <cf_get_lang_main no='197.Cumartesi'></a></cfoutput></td>
            </tr>
            <tr class="color-row">
                <cfoutput>
                <cfloop from="0" to="4" index="i">
                    <cfset attributes.day = date_add('d',i,first_day)>
                    <cfset acreatdate = attributes.day>
                    <td height="175" rowspan="3" valign="top" width="16%">
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
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif asset_care_start eq period_time_now>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="6">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 2 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="7">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 3 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#)" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="8">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 4 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="9">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 6 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="10">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 12 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="11">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 24 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="12">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 36 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                                <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="13">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 48 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                                <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="14">
                                        <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                        <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                        <cfset period_time_now=day(acreatdate)>
                                        <cfif (asset_care_start eq period_time_now) and (care_date_period mod 60 is 0)>
                                            <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                                <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                            <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                        </cfif>
                                    </cfcase>
                                    <cfcase value="">
                                        <cfset asset_care_start=get_asset_cares_all.period_time>
                                        <cfset period_time_now=acreatdate>
                                        <cfif (asset_care_start is period_time_now)>
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
                </cfloop>
                <cfset attributes.day = sixth_day>
                <cfset acreatdate = attributes.day>
                <td valign="top" width="20%" height="220">
                    <cfinclude template="../query/get_asset_cares_all.cfm">
                    <cfoutput>
                    <cfloop query="get_asset_cares_all">
                        <cfif len(get_asset_cares_all.period_time) and dateformat(get_asset_cares_all.period_time,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>

                            <cfswitch expression="#get_asset_cares_all.period_id#">
                                <cfcase value="1">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfif care_date_period mod 7 is 0>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="2">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfif care_date_period mod 15 is 0>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="3">
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
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif asset_care_start eq period_time_now>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="6">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 2 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="7">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 3 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="8">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 4 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="9">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 6 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="10">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 12 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>							
                                </cfcase>
                                <cfcase value="11">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 24 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="12">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 36 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="13">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 48 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="14">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 60 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="">
                                    <cfset asset_care_start=get_asset_cares_all.period_time>
                                    <cfset period_time_now=acreatdate>
                                    <cfif (asset_care_start is period_time_now)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" class="tableyazi">#assetp#</a> 
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
            </tr>
            <tr class="color-header">
                <td height="22" align="center" width="20%" class="form-title"><cfoutput><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&yil=#dateformat(seventh_day,"yyyy")#&ay=#dateformat(seventh_day,"mm")#&gun=#dateformat(seventh_day,"dd")#" class="form-title">#dateformat(seventh_day,"dd")# - <cf_get_lang_main no='198.Pazar'></a></cfoutput></td>
            </tr>
            <tr class="color-row">
                <cfset acreatdate = seventh_day>
                <td valign="top" width="20%">
                    <cfinclude template="../query/get_asset_cares_all.cfm">
                    <cfoutput>
                    <cfloop query="get_asset_cares_all">
                        <cfif len(get_asset_cares_all.period_time) and dateformat(get_asset_cares_all.period_time,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>			  

                            <cfswitch expression="#get_asset_cares_all.period_id#">
                                <cfcase value="1">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfif care_date_period mod 7 is 0>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="2">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfif care_date_period mod 15 is 0>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="3">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfif care_date_period mod 21 is 0>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="5">
                                    <cfset care_date_period=datediff("d",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif asset_care_start eq period_time_now>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="6">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 2 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="7">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 3 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="8">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 4 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="9">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 6 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="10">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 12 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                       <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="11">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 24 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                       <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="12">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 36 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="13">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 48 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="14">
                                    <cfset care_date_period=datediff("m",get_asset_cares_all.period_time,acreatdate)>
                                    <cfset asset_care_start=day(get_asset_cares_all.period_time)>
                                    <cfset period_time_now=day(acreatdate)>
                                    <cfif (asset_care_start eq period_time_now) and (care_date_period mod 60 is 0)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>-
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                                <cfcase value="">
                                    <cfset asset_care_start=get_asset_cares_all.period_time>
                                    <cfset period_time_now=acreatdate>
                                    <cfif (asset_care_start is period_time_now)>
                                        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" <cfif isdefined("GET_ASSET_CARES_ALL.calender_date") and acreatdate eq GET_ASSET_CARES_ALL.calender_date>style="color:red"<cfelse>class="tableyazi"</cfif>>#assetp#</a>- 
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#','medium')" class="tableyazi">#get_asset_cares_all.asset_care#</a>
                                        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif><br/>
                                    </cfif>
                                </cfcase>
                            </cfswitch>
                        </cfif>
                    </cfloop>
                    </cfoutput>
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table> 
<br/>