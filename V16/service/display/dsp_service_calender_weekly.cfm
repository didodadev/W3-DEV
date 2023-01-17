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
		SERVICE_CARE_CAT.*,
		(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = SERVICE_CARE.PRODUCT_ID) PRODUCT_NAME
	FROM 
		#dsn3_alias#.SERVICE_CARE AS SERVICE_CARE, 
		CARE_STATES AS CARE_STATES,
		#dsn3_alias#.SERVICE_CARE_CAT AS SERVICE_CARE_CAT
	WHERE 
		SERVICE_CARE.STATUS=1 AND 
		SERVICE_CARE.PRODUCT_CARE_ID=CARE_STATES.SERVICE_ID AND
		SERVICE_CARE_CAT.SERVICE_CARECAT_ID=CARE_STATES.CARE_STATE_ID  AND
		SERVICE_CARE.START_DATE <= #first_day# AND
		(SERVICE_CARE.FINISH_DATE >= #sixth_day# OR SERVICE_CARE.FINISH_DATE IS NULL)
	ORDER BY 
		SERVICE_CARE.PRODUCT_CARE_ID
</cfquery>
<cfquery name="GET_SERVICE_REQUEST" datasource="#DSN#">
	SELECT 
		PW.SERVICE_ID, 
		PW.OUTSRC_PARTNER_ID AS TASK_PARTNER_ID,
		PW.OUTSRC_CMP_ID AS TASK_CMP_ID,
		PW.PROJECT_EMP_ID AS TASK_EMP_ID,
		PW.TARGET_START AS START_DATE, 
		PW.TARGET_FINISH AS FINISH_DATE,
		S.SERVICE_HEAD
	FROM
		PRO_WORKS PW,
		#dsn3_alias#.SERVICE S
	WHERE
		PW.SERVICE_ID = S.SERVICE_ID AND
		PW.SERVICE_ID IS NOT NULL AND
		PW.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfsavecontent variable="head">
<table>
	<tr>
		<td class="headbold"><cf_get_lang no='160.Haftalık Servis Takvimi'></td>
		<cfoutput>
			<cfif not listfindnocase(denied_pages,'service.dsp_service_calender_weekly')>
				<td>
					<a href="#request.self#?fuseaction=service.dsp_service_calender_weekly&yil=#dateformat(last_week,'yyyy')#&ay=#dateformat(last_week,'mm')#&gun=#dateformat(last_week,'dd')#&care_type=#attributes.care_type#"><img src="/images/previous20.gif" width="15" height="20" border="0" align="absmiddle"></a>
				</td>
			</cfif>
			<td class="headbold">#dateformat(first_day,dateformat_style)# - #dateformat(seventh_day,dateformat_style)#</td>
			<cfif not listfindnocase(denied_pages,'service.dsp_service_calender_weekly')>
				<td>
					<a href="#request.self#?fuseaction=service.dsp_service_calender_weekly&yil=#dateformat(next_week,'yyyy')#&ay=#dateformat(next_week,'mm')#&gun=#dateformat(next_week,'dd')#&care_type=#attributes.care_type#"><img src="/images/next20.gif" width="15" height="20" border="0" align="absmiddle"></a>
				</td>
			</cfif>
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
				<select name="care_type" id="care_type"  style="width:60px;" onChange="reload_(this.value);">
					<option value="1" <cfif attributes.care_type eq 1>selected</cfif>>Bakım</option>
					<option value="2" <cfif attributes.care_type eq 2>selected</cfif>>Servis</option>
					<option value="3" <cfif attributes.care_type eq 3>selected</cfif>>Hepsi</option>
				</select>
			</td>
			<td>
				<select name="url" id="url" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
					<cfoutput>
						<option>Servis Periyodu</option>
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
<table border="0" cellspacing="0" cellpadding="2" style="width:99%; text-align:center">
  	<tr>
		<td style=" vertical-align:top; width:100%;text-align:right;">
      		<table cellspacing="0" cellpadding="0" width="100%" border="0">
       	 		<tr class="color-border">
          			<td>
            			<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:325px;">
              				<tr class="color-header" style="height:22px;">
			  				<cfoutput>
							  	<td class="form-title" style="width:16%; text-align:center"><cf_get_lang_main no='192.Pazartesi'></td>
							  	<td class="form-title" style="width:16%; text-align:center"><cf_get_lang_main no='193.Salı'></td>
							  	<td class="form-title" style="width:16%; text-align:center"><cf_get_lang_main no='194.Çarşamba'></td>
							  	<td class="form-title" style="width:16%; text-align:center"><cf_get_lang_main no='195.Perşembe'></td>
							  	<td class="form-title" style="width:16%; text-align:center"><cf_get_lang_main no='196.Cuma'></td>
							  	<td class="form-title" style="width:20%; text-align:center"><cf_get_lang_main no='197.Cumartesi'></td>
                			</cfoutput>
							</tr>
              				<tr class="color-row" style="height:135px;">
			  					<cfoutput>
									<cfloop from="0" to="4" index="i">
										<cfset attributes.to_day = date_add('h',-session.ep.time_zone,date_add('d',i,first_day))>
										<cfset acreatdate = date_add("d", 1, attributes.to_day)> 
										<td rowspan="3" style="vertical-align:top; width:16%">
										<cfif attributes.care_type eq 2 or attributes.care_type eq 3>
											<cfloop query="get_service_request">
												<cfif (dateformat(get_service_request.start_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd")) or (dateformat(get_service_request.finish_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd"))>
													#dateformat(start_date,"dd/mm")#- #dateformat(finish_date,"dd/mm")#
													<a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_head#</a> -<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_contract','list');"><font color="##990000">[Servis]</font></a><br/>
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
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="2">
														<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
														<cfif care_date_period mod 14 is 0>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="3">
														<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif asset_care_start eq start_date_now>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="4">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="5">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="6">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="7">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="8">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
												</cfswitch>
												</cfloop>
											</cfif>
											</cfoutput>
										</cfif>
										</td>
									</cfloop>
									<cfset attributes.to_day = date_add("h",-session.ep.time_zone,sixth_day)>
									<cfset acreatdate = date_add("d", 1, attributes.to_day)>
									<td style="vertical-align:top; width:20%">
									<cfif attributes.care_type eq 2 or attributes.care_type eq 3>
										<cfloop query="get_service_request">
											<cfif (dateformat(get_service_request.start_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd")) or (dateformat(get_service_request.finish_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd"))>
												#dateformat(start_date,"dd/mm")#- #dateformat(finish_date,"dd/mm")#
												<a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_head#</a> -<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_asset_care','list');"><font color="##990000">[Servis]</font></a><br/>
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
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="2">
															<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
															<cfif care_date_period mod 14 is 0>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="3">
															<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif asset_care_start eq start_date_now>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="4">
															<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="5">
															<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="6">
															<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="7">
															<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
														<cfcase value="8">
															<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
															<cfset asset_care_start=day(get_asset_cares_all.start_date)>
															<cfset start_date_now=day(acreatdate)>
															<cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
															</cfif>
														</cfcase>
													</cfswitch>
												</cfloop>
											</cfif>
										</cfoutput>
									</cfif>
								</td>
							</cfoutput>
							</tr>
							<tr class="color-header" style="height:22px;">
								<cfoutput>
									<td style="text-align:center; width:20%"><a href="#request.self#?fuseaction=agenda.view_daily&yil=#dateformat(seventh_day,"yyyy")#&ay=#dateformat(seventh_day,"mm")#&gun=#dateformat(seventh_day,"dd")#" class="form-title"><cf_get_lang_main no='198.Pazar'></a></td>
								</cfoutput> 
							</tr>
							<tr class="color-row">
								<cfoutput>
								<cfset attributes.to_day = date_add("h",-session.ep.time_zone,seventh_day)>
								<cfset acreatdate = date_add("d", 1, attributes.to_day)>
								<td style="vertical-align:top; width:20%">
									<cfif attributes.care_type eq 2 or attributes.care_type eq 3>
										<cfloop query="get_service_request">
											<cfif (dateformat(get_service_request.start_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd")) or (dateformat(get_service_request.finish_date,"yyyymmdd") eq  dateformat(acreatdate,"yyyymmdd"))>
												#dateformat(start_date,"dd/mm")#- #dateformat(finish_date,"dd/mm")#
												<a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_head#</a> -<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_asset_care','list');"><font color="##990000">[Servis]</font></a><br/>
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
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="2">
														<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
														<cfif care_date_period mod 14 is 0>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="3">
														<cfset care_date_period=datediff("d",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif asset_care_start eq start_date_now>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="4">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 2 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="5">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 3 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="6">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 4 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="7">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 6 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
													<cfcase value="8">
														<cfset care_date_period=datediff("m",get_asset_cares_all.start_date,acreatdate)>
														<cfset asset_care_start=day(get_asset_cares_all.start_date)>
														<cfset start_date_now=day(acreatdate)>
														<cfif (asset_care_start eq start_date_now) and (care_date_period mod 12 is 0)>
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_asset_cares_all.product_id#','list');" class="tableyazi">#product_name#</a> - #get_asset_cares_all.serial_no# -
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_upd_service_care&id=#product_care_id#','list');" class="tableyazi">#get_asset_cares_all.service_care#</a>-
															<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_report&id=#product_care_id#','list');"><font color="##330066">[Bakım]</font></a><br/>
														</cfif>
													</cfcase>
												</cfswitch>
												</cfloop>
											</cfif>
										</cfoutput>
									</cfif>
				  				</td>
                				</cfoutput>
							</tr>
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
		service_date.action = <cfoutput>'#request.self#?fuseaction=service.dsp_service_calender_weekly&yil=#dateformat(first_day,'yyyy')#&ay=#dateformat(first_day,'mm')#&gun=#dateformat(first_day,'dd')#</cfoutput>';
		service_date.submit();
	}
</script>
