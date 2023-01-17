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
	gun_sayisi = daysinmonth(tarih);
	tarih_son_ = createDate(yil,ay,gun_sayisi);
	bas = DayofWeek(tarih)-1;
	if (bas eq 0)
		bas=7;
	son = DaysinMonth(tarih);
	gun = 1;
	yer = '#request.self#?fuseaction=service.dsp_service_calender_monthly';
	
	attributes.day = date_add("h",-session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
</cfscript>

<cfparam name="attributes.care_type" default="3">
<cfquery name="GET_ASSET_CARES_ALL" datasource="#DSN#">
	SELECT 
		SERVICE_CARE.PRODUCT_CARE_ID, 
		SERVICE_CARE.COMPANY_AUTHORIZED_TYPE,
		SERVICE_CARE.COMPANY_AUTHORIZED, 
		SERVICE_CARE.START_DATE,
		SERVICE_CARE.FINISH_DATE,
		SERVICE_CARE.SERIAL_NO,
		SERVICE_CARE.PRODUCT_ID, 
		SERVICE_CARE.SERVICE_EMPLOYEE, 
		SERVICE_CARE.SERVICE_EMPLOYEE2,
		CARE_STATES.PERIOD_ID, 
		CARE_STATES.CARE_STATE_ID ,
		(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = SERVICE_CARE.PRODUCT_ID) PRODUCT_NAME,
		SERVICE_CARE_CAT.*
	FROM 
		#dsn3_alias#.SERVICE_CARE AS SERVICE_CARE, 
		CARE_STATES AS CARE_STATES,
		#dsn3_alias#.SERVICE_CARE_CAT AS SERVICE_CARE_CAT
	WHERE 
		SERVICE_CARE.STATUS=1 AND 
		SERVICE_CARE.PRODUCT_CARE_ID=CARE_STATES.SERVICE_ID AND
		SERVICE_CARE_CAT.SERVICE_CARECAT_ID=CARE_STATES.CARE_STATE_ID AND
		SERVICE_CARE.START_DATE <= #tarih_son_# AND
		(SERVICE_CARE.FINISH_DATE >= #tarih# OR SERVICE_CARE.FINISH_DATE IS NULL)
	ORDER BY 
		SERVICE_CARE.PRODUCT_CARE_ID
</cfquery>
<cfquery name="GET_SERVICE_REQUEST" datasource="#DSN#">
	SELECT 
	  SERVICE_ID, 
	  OUTSRC_PARTNER_ID AS TASK_PARTNER_ID, 
	  OUTSRC_CMP_ID AS TASK_CMP_ID,
	  PROJECT_EMP_ID AS TASK_EMP_ID,
	  TARGET_START AS START_DATE, 
	  TARGET_FINISH AS FINISH_DATE 
  FROM 
	  PRO_WORKS
  WHERE
	  SERVICE_ID IS NOT NULL AND
	  OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfsavecontent variable="head">
<table>
	<tr>
		<td class="headbold"><cf_get_lang no='161.Aylık Servis Takvimi'></td>
		<cfoutput>
			<td style="text-align:left"><a href="#yer#&ay=#ay#&yil=#oncekiyil#&care_type=#attributes.care_type#"><img src="/images/previous20.gif" width="15" height="20" border="0" align="absmiddle"></a></td>
			<td class="headbold" style="text-align:center; width:10px;">#Year(tarih)#</td>
			<td style="text-align:right;"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#&care_type=#attributes.care_type#"><img src="/images/next20.gif" width="15" height="20" border="0" align="absmiddle"></a></td>
			<td  style="text-align:left;"><a href="#yer#&ay=#oncekiay#&care_type=#attributes.care_type#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>"><img src="/images/previous20.gif" width="15" height="20" border="0" align="absmiddle"></a></td>
			<td class="headbold" style="text-align:center; width:10px;">#ListGetAt(aylar,Month(tarih))#</td>
			<td><a href="#yer#&ay=#sonrakiay#&care_type=#attributes.care_type#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>"><img src="/images/next20.gif" width="15" height="20" border="0" align="absmiddle"></a></td>
		</cfoutput>
	</tr>
</table>
</cfsavecontent>
<cf_big_list_search title="#head#">
<cf_big_list_search_area>
<cfform name="service_date" action="">
<table>
	<tr>
		<td>
			<select name="care_type" id="care_type" style="width:60px;" onChange="reload_(this.value);">
				<option value="1" <cfif attributes.care_type eq 1>selected</cfif>>Bakım</option>
				<option value="2" <cfif attributes.care_type eq 2>selected</cfif>>Servis</option>
				<option value="3" <cfif attributes.care_type eq 3>selected</cfif>>Hepsi</option>
			</select>
		</td>
		<td>
			<select name="url" id="url" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
				<cfoutput>
					<option><cf_get_lang no='129.Servis Periyodu'></option>
					<option value="#request.self#?fuseaction=service.dsp_service_calender"><cf_get_lang_main no='1045.Günlük'></option>
					<option value="#request.self#?fuseaction=service.dsp_service_calender_weekly"><cf_get_lang_main no='1046.Haftalık'></option>
					<option value="#request.self#?fuseaction=service.dsp_service_calender_monthly"><cf_get_lang_main no='1520.Aylık'></option>
				</cfoutput>
			</select>
		</td>
	</tr>
</table>
</cfform>
</cf_big_list_search_area>
</cf_big_list_search>
<table border="0" cellspacing="0" cellpadding="2" style="text-align:center; width:99%">
	<tr>
		<td style=" vertical-align:top; width:100%;text-align:right;">
		<table cellspacing="0" cellpadding="0" border="0" style="width:100%">
			<tr class="color-border">
				<td>
				<table cellspacing="1" cellpadding="2" border="0" style="text-align:center; width:100%">
					<tr class="color-header" style="height:22px;">
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='192.Pazartesi'></td>
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='193.Salı'></td>
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='194.Çarşamba'></td>
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='195.Perşembe'></td>
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='196.Cuma'></td>
						<td class="form-title" style="width:14%; text-align:center;"><cf_get_lang_main no='197.Cumartesi'></td>
						<td class="form-title" style="text-align:center"><cf_get_lang_main no='198.Pazar'></td>
					</tr>
					<cfset sayac =0>
					<tr class="color-list" style="height:20px;">
						<cfloop index="x" from="1" to="#Evaluate(bas-1)#">
							<td>&nbsp;</td>
						</cfloop>
						<cfloop index="x" from="#bas#" to="7">
							<td class="txtbold"><cfoutput>#gun#</cfoutput></td>
							<cfset gun = gun +1>
							<cfset sayac = sayac +1>
						</cfloop>
					</tr>
					<cfset gun = gun - sayac>
					<tr class="color-row" style="height:79px; vertical-align:top">
						<cfloop index="x" from="1" to="#Evaluate(bas-1)#">
							<td></td>
						</cfloop>
						<cfloop index="x" from="#bas#" to="7">
						<cfoutput>
							<td>
								<cfset attributes.day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
								<cfset acreatdate = date_add("d", 1, attributes.day )>
								<cfif attributes.care_type eq 2 or attributes.care_type eq 3>
									<cfloop query="get_service_request">
										<cfif (dateformat(get_service_request.start_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd")) or (dateformat(get_service_request.finish_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd"))>
											#dateformat(start_date,"dd/mm")#- #dateformat(finish_date,"dd/mm")#
											<cfquery name="GET_SERVICE" datasource="#DSN3#">
												SELECT SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
											</cfquery>
											<a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#get_service.service_head#</a> - 
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_contract','list');"><font color="990000">[Servis]</font></a><br/>
										</cfif>
									</cfloop>
								</cfif>
								<cfif attributes.care_type eq 1 or attributes.care_type eq 3> 
								<cfoutput>
									<cfif dateformat(get_asset_cares_all.start_date,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>
										<cfloop query="get_asset_cares_all">
											<cfswitch expression="#get_asset_cares_all.period_id#">
												<cfcase value="1">
													<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
													<cfif care_date_period mod 7 is 0>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="2">
													<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
													<cfif care_date_period mod 14 is 0>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="3">
													<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif asset_care_start eq start_date_now>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="4">
													<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="5">
													<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="6">
													<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="7">
													<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
												<cfcase value="8">
													<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
													<cfset asset_care_start=day(get_asset_cares_all.start_date)>
													<cfset start_date_now=day(acreatdate)>
													<cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
													</cfif>
												</cfcase>
											</cfswitch>
										</cfloop>
									</cfif>
								</cfoutput>
								</cfif>
							</td>
						</cfoutput>
						<cfset gun = gun +1>
						</cfloop>
					</tr>
					<cfloop index="y" from=2 to=6>
						<cfset sayac=0>
						<tr class="color-list" style="height:20px;">
							<cfloop index=x from=1 to=7>
								<cfif gun lte son>
									<td class="txtbold"><cfoutput>#gun#</cfoutput></td>
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
							<cfloop index="x" from=1 to=7>
								<cfif gun lte son>
									<td>
										<cfset attributes.day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
										<cfset acreatdate = date_add("d", 1, attributes.day )>
										<cfif attributes.care_type eq 2 or attributes.care_type eq 3>
											<cfloop query="get_service_request">
												<cfif (dateformat(get_service_request.start_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd")) or (dateformat(get_service_request.finish_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd"))>
												  #dateformat(start_date,"dd/mm")#- #dateformat(finish_date,"dd/mm")#
												  <cfquery name="GET_SERVICE" datasource="#DSN3#">
												 	 SELECT SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
												  </cfquery>
												  <a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#get_service.service_head#</a> - 
												  <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_contract','list');"><font color="990000">[Servis]</font></a><br/>
												</cfif>
											</cfloop>
										</cfif>
										<cfoutput>
											<cfif dateformat(get_asset_cares_all.start_date,"yyyymmdd") lte dateformat(acreatdate,"yyyymmdd")>
												<cfif attributes.care_type eq 1 or attributes.care_type eq 3>
													<cfloop query="get_asset_cares_all">
														<cfquery name="GET_SERVICE_CARE_REPORT" datasource="#DSN3#">
															SELECT 
																SC.PRODUCT_ID
															 FROM 
																SERVICE_CARE SC,
																SERVICE_CARE_REPORT SCR
															WHERE 
																SCR.PRODUCT_ID = SC.PRODUCT_ID AND 
																SC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_cares_all.product_id#">
														</cfquery>
														<cfswitch expression="#get_asset_cares_all.period_id#">
															<cfcase value="1">
																<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
																<cfif care_date_period mod 7 is 0>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="2">
																<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
																<cfif care_date_period mod 14 is 0>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="3">
																<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif asset_care_start eq start_date_now>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="4">
																<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="5">
																<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="6">
																<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="7">
																<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
															<cfcase value="8">
																<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
																<cfset asset_care_start=day(get_asset_cares_all.start_date)>
																<cfset start_date_now=day(acreatdate)>
																<cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name# - #get_asset_cares_all.serial_no# -</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#-</a>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.list_care&event=add&id=#product_care_id#','list');"><font color="330066">[Bakım]</font></a><br/>
																</cfif>
															</cfcase>
														</cfswitch>
													</cfloop>
												</cfif>
											</cfif>
										</cfoutput>
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
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
	function reload_(gelen)
	{
		service_date.action = <cfoutput>'#request.self#?fuseaction=service.dsp_service_calender_monthly&ay=#ay#&yil=#yil#</cfoutput>';
		service_date.submit();
	}
</script>
