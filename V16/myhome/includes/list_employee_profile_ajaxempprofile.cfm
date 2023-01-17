<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.search_type")>
	<cfparam name="attributes.emp_pro_selection" default="#attributes.search_type#">
<cfelse>
	<cfparam name="attributes.emp_pro_selection" default="1">
</cfif>
<cfquery name="get_education_level" datasource="#dsn#">
	SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE IS_ACTIVE = 1 AND EDU_LEVEL_ID IN(SELECT DISTINCT LAST_SCHOOL FROM EMPLOYEES_DETAIL WHERE LAST_SCHOOL IS NOT NULL ) ORDER BY EDU_LEVEL_ID
</cfquery>
<cfquery name="get_org_step" datasource="#dsn#">
    SELECT 
        OS.ORGANIZATION_STEP_NAME,
        OS.ORGANIZATION_STEP_NO, 
        OS.ORGANIZATION_STEP_ID,           
        COUNT(EP.POSITION_ID) AS SAYAC
    FROM 
 		EMPLOYEES E INNER JOIN EMPLOYEE_POSITIONS EP 
        ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
        INNER JOIN SETUP_ORGANIZATION_STEPS OS
        ON EP.ORGANIZATION_STEP_ID = OS.ORGANIZATION_STEP_ID
    WHERE
        EP.EMPLOYEE_ID <>0 AND EP.EMPLOYEE_ID IS NOT NULL AND
        EP.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE FINISH_DATE IS NULL) AND
        E.EMPLOYEE_STATUS = 1
    GROUP BY 
        OS.ORGANIZATION_STEP_NAME, OS.ORGANIZATION_STEP_ID, OS.ORGANIZATION_STEP_NO
   	ORDER BY
    	OS.ORGANIZATION_STEP_NO
</cfquery>
<cfinclude template="../query/get_list_employee_profile.cfm">
<cfinclude template="../query/get_emp_profile_queries.cfm">
<div id="div_company_details">
<cfform name="emp_profile" method="post" action="">
	<div class="ui-form-list flex-end">
		<div class="form-group">
			<select name="emp_pro_selection" id="emp_pro_selection" onChange="change_profile_det(this.value);">
				<option value="1" <cfif attributes.emp_pro_selection eq 1>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
				<option value="2" <cfif attributes.emp_pro_selection eq 2>selected</cfif>><cf_get_lang_main no='1029.Kan Grubu'></option>
				<option value="3" <cfif attributes.emp_pro_selection eq 3>selected</cfif>><cf_get_lang no='748.Yaş'></option>
				<option value="4" <cfif attributes.emp_pro_selection eq 4>selected</cfif>><cf_get_lang no='642.Kıdem'></option> 
				<option value="5" <cfif attributes.emp_pro_selection eq 5>selected</cfif>><cf_get_lang dictionary_id=' 51783.Eğitim Durumu'></option>
				<option value="6" <cfif attributes.emp_pro_selection eq 6>selected</cfif>><cf_get_lang_main no='1298.Kademe'></option> 
			</select>
		</div>
	</div>
<cf_flat_list>
	<thead>
		<tr id="emp_pro_selection_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>>
			<th>&nbsp;</th>
			<th colspan="2"><cf_get_lang_main no='1085.Pozisyon'></th>
			<th colspan="2"><cf_get_lang_main no='164.Çalışan'></th>
			<th colspan="2"><cf_get_lang no='171.Yaka Tipi'></th>
			<!---<th width="20%" colspan="5"><cf_get_lang no='172.Öğrenim Durumu'></th>--->
		</tr>
	</thead>
	<tbody>
	<tr id="emp_pro_selection_1_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>>
		<td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
		<td><cf_get_lang no='176.Dolu'></td>
		<td><cf_get_lang no='184.Boş'></td>
		<td><cf_get_lang_main no='1546.Kadın'></td>
		<td><cf_get_lang_main no='1547.Erkek'></td>
		<td><cfoutput>#getLang('hr',981)#</cfoutput></td>
		<td><cfoutput>#getLang('hr',980)#</cfoutput></td>
		<!---<cfoutput query="get_education_level">
			<td>#Left(education_name,1)#</td>
		</cfoutput>--->
	</tr>
	<tr id="emp_pro_selection_2" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif>>
		<td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
		<td>0 RH(+)</td>
		<td>0 RH(-)</td>
		<td>A RH(+)</td>
		<td>A RH(-)</td>
		<td>B RH(+)</td>
		<td>B RH(-)</td>
		<td>AB RH(+)</td>
		<td>AB RH(-)</td>
	</tr>
	<tr id="emp_pro_selection_3" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif>>
		<td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
		<td>18'<cf_get_lang no='206.den Küçük'></td>
		<td>18-25 <cf_get_lang no='748.Yaş'></td>
		<td>25 - 35 <cf_get_lang no='748.Yaş'></td>
		<td>35 - 50 <cf_get_lang no='748.Yaş'></td>
		<td>50 <cf_get_lang_main no='1976.Üstü'></td>
	</tr>
	<tr id="emp_pro_selection_4" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif>>
		<td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
		<td>0-1 <cf_get_lang_main no='1043.Yıl'></td>
		<td>1 -3 <cf_get_lang_main no='1043.Yıl'></td>
		<td>3-5 <cf_get_lang_main no='1043.Yıl'></td>
		<td>5 - 9 <cf_get_lang_main no='1043.Yıl'></td>
		<td>9 <cf_get_lang_main no='1043.Yıl'> <cf_get_lang_main no='1976.Üstü'></td>
	</tr>
    <tr id="emp_pro_selection_5" <cfif attributes.emp_pro_selection neq 5>style="display:none;"</cfif>>
        <td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
                <cfoutput query="get_education_level">
            <td>#education_name#</td>
        </cfoutput>
    </tr>
    <tr id="emp_pro_selection_6" <cfif attributes.emp_pro_selection neq 6>style="display:none;"</cfif>>
        <td><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='164.Çalışan'> : <cfoutput>#get_emp_positions_det.recordcount#</cfoutput></td>
        <cfoutput query="get_org_step">
        <td>#ORGANIZATION_STEP_NAME#</td>
        </cfoutput>
    </tr>
	</tbody>
	<cfoutput>
		<tr id="emp_pro_selection_1_" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>
			<cfif attributes.emp_pro_selection eq 1>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_dolu=1','list')">#get_total_full_positions.employee_number#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_empty=1','list')">#get_total_empty_positions.employee_number#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_female=1','list')">#get_total_emp_women.employee_number#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_male=1','list')">#get_total_emp_men.employee_number#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&collar_type=2','list')">#get_total_white_collar.employee_number#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&collar_type=1','list')">#get_total_blue_collar.employee_number#</a></td>
				<!---<cfloop query="get_education_level">
					<cfquery name="get_total_emp_edu" dbtype="query">
						SELECT COUNT(LAST_SCHOOL) EMPLOYEE_NUMBER FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id#
					</cfquery>
					<td><cfif get_total_emp_edu.recordcount>#get_total_emp_edu.EMPLOYEE_NUMBER#<cfelse>0</cfif></td>
				</cfloop>--->
			</cfif>
		</tr>
		<tr id="emp_pro_selection_2_" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>
			<cfif attributes.emp_pro_selection eq 2>
				<cfloop from="0" to="7" index="kk">
					<cfquery name="get_emp_age_blood_" dbtype="query">
						SELECT COUNT_BLOOD_TYPE FROM get_emp_age_blood WHERE BLOOD_TYPE = #kk#
					</cfquery>
					<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&blood_type=#kk#','list')">#get_emp_age_blood_.COUNT_BLOOD_TYPE#</a></td>
				</cfloop>
			</cfif>
		</tr>
		<tr id="emp_pro_selection_3_" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>
			<cfif attributes.emp_pro_selection eq 3>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_18=1','list')">#get_emp_age_18.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_18_25=1','list')">#get_emp_age_25.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_25_35=1','list')">#get_emp_age_35.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_50=1','list')">#get_emp_age_50.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_50_=1','list')">#get_emp_age_50_ustu.recordcount#</a></td>
			</cfif>
		</tr>
		<tr id="emp_pro_selection_4_" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>
			<cfif attributes.emp_pro_selection eq 4>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem1=1','list')">#get_emp_kidem_1.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem2=1','list')">#get_emp_kidem_3.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem3=1','list')">#get_emp_kidem_5.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem4=1','list')">#get_emp_kidem_9.recordcount#</a></td>
				<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem5=1','list')">#get_emp_kidem_9_ustu.recordcount#</a></td>
			</cfif>
		</tr>
		<tr id="emp_pro_selection_5_" <cfif attributes.emp_pro_selection neq 5>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>	
			<cfloop query="get_education_level">
					<cfquery name="get_total_emp_edu" dbtype="query">
						SELECT LAST_SCHOOL FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id#
					</cfquery>
					<td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&edu_level_id=#get_education_level.edu_level_id#','list')">#get_total_emp_edu.recordcount#</a></td>
				</cfloop>
        </tr>
		<tr id="emp_pro_selection_6_" <cfif attributes.emp_pro_selection neq 6>style="display:none;"</cfif>>
			<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>	
            <cfif attributes.emp_pro_selection eq 6>
			<cfloop query="get_org_step">
            	<cfquery name="get_total_org_step" dbtype="query">
                    SELECT COUNT_STEP_ID FROM get_emp_age_blood WHERE ORGANIZATION_STEP_ID = #ORGANIZATION_STEP_ID#
                </cfquery>
                <td><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&org_step=#get_org_step.ORGANIZATION_STEP_NO#','list')">#get_total_org_step.COUNT_STEP_ID#</a></td>
            </cfloop>
            </cfif>
        </tr>
	</cfoutput>
</tbody>
</cf_flat_list>
<table width="98%" cellpadding="2" cellspacing="1" border="0">
	<tr valign="top">
		 <td height="100%" align="left" width="100%">
			<cfif attributes.emp_pro_selection eq 1>
				<cfsavecontent variable="dolu"><cf_get_lang no='176.Dolu'></cfsavecontent>
				<cfsavecontent variable="bos"><cf_get_lang no='184.Boş'></cfsavecontent>
				<cfsavecontent variable="kadin"><cf_get_lang_main no='1546.Kadın'></cfsavecontent>
				<cfsavecontent variable="erkek"><cf_get_lang_main no='1547.Erkek'></cfsavecontent>
				<cfsavecontent variable="beyaz"><cfoutput>#getLang('hr',981)#</cfoutput></cfsavecontent>
				<cfsavecontent variable="mavi"><cfoutput>#getLang('hr',980)#</cfoutput></cfsavecontent>
				<cfset label_list = '#dolu#,#bos#'><!--- ,#kadin#,#erkek#,#beyaz#,#mavi# --->
				<cfset label_list2 = '#kadin#,#erkek#'>
				<cfset label_list3 = '#beyaz#,#mavi#'>
				<!---<cfloop query="get_education_level" startrow="1" endrow="5">
					<cfset label_list = listappend(label_list,education_name)>
				</cfloop>--->
				<cfset label_list_value = ''>
				<cfset label_list_value2 = ''>
				<cfset label_list_value3 = ''>
			<cfelseif  attributes.emp_pro_selection eq 2>
				<cfset label_list = '0 Rh(+),0 Rh(-),A Rh(+),A Rh(-),B Rh(+),B Rh(-),AB Rh(+),AB Rh(-)'>
				<cfset label_list_value = ''> 
			<cfelseif  attributes.emp_pro_selection eq 3>
				<cfsavecontent variable="yas1">18'<cf_get_lang no='206.den Küçük'></cfsavecontent>
				<cfsavecontent variable="yas2">18-25 <cf_get_lang no='748.Yaş'></cfsavecontent>
				<cfsavecontent variable="yas3">25 - 35 <cf_get_lang no='748.Yaş'></cfsavecontent>
				<cfsavecontent variable="yas4">35 - 50 <cf_get_lang no='748.Yaş'></cfsavecontent>
				<cfsavecontent variable="yas5">50 <cf_get_lang_main no='1976.Üstü'></cfsavecontent>
				<cfset label_list = '#yas1#,#yas2#,#yas3#,#yas4#,#yas5#'>
				<cfset label_list_value = ''> 
			<cfelseif  attributes.emp_pro_selection eq 4>
				<cfsavecontent variable="yil1">0-1 <cf_get_lang_main no='1043.Yıl'></cfsavecontent>
				<cfsavecontent variable="yil2">1 -3 <cf_get_lang_main no='1043.Yıl'></cfsavecontent>
				<cfsavecontent variable="yil3">3-5 <cf_get_lang_main no='1043.Yıl'></cfsavecontent>
				<cfsavecontent variable="yil4">5 - 9 <cf_get_lang_main no='1043.Yıl'></cfsavecontent>
				<cfsavecontent variable="yil5">9 <cf_get_lang_main no='1043.Yıl'> <cf_get_lang_main no='1976.Üstü'></cfsavecontent>
				<cfset label_list = '#yil1#,#yil2#,#yil3#,#yil4#,#yil5#'>
				<cfset label_list_value = ''> 
			<cfelseif attributes.emp_pro_selection eq 5>
				<cfset label_list = valuelist(get_education_level.education_name,',')>
				<cfset label_list_value = "">
				<!---<cfset label_list_value = '0,0,0,0,0,0,0,0,0,0,0,0'>--->
			<cfelseif attributes.emp_pro_selection eq 6>
				<cfset label_list = valuelist(get_org_step.ORGANIZATION_STEP_NAME,',')>
				<cfset label_list_value = "">
            </cfif>
			<cfif attributes.emp_pro_selection eq 1>
				<cfoutput query="get_all_emp">
					<cfset label_list_value = ListAppend(label_list_value,employee_number)>
					<!--- <cfset label_list_value2 = listsetat(label_list_value2,type,employee_number)>
					<cfset label_list_value3 = listsetat(label_list_value3,type,employee_number)> --->
					
				</cfoutput>
				<cfoutput query="get_all_emp2">
					<!--- <cfset label_list_value = listsetat(label_list_value,type,employee_number)> --->
					<cfset label_list_value2 = ListAppend(label_list_value2,employee_number)>
					<cfif get_all_emp2.recordcount lte 1>
						<cfset label_list_value2 = ListAppend(label_list_value2,0)>
					</cfif>
					<!--- <cfset label_list_value3 = listsetat(label_list_value3,type,employee_number)> --->
				</cfoutput>
				<cfoutput query="get_all_emp3">
					<!--- <cfset label_list_value = listsetat(label_list_value,type,employee_number)>
					<cfset label_list_value2 = listsetat(label_list_value2,type,employee_number)> --->
					<cfset label_list_value3 = ListAppend(label_list_value3,employee_number)>
					<cfif get_all_emp3.recordcount lte 1>
						<cfset label_list_value3 = ListAppend(label_list_value3,0)>
					</cfif>
				</cfoutput>
			<cfelseif  attributes.emp_pro_selection eq 2>
				<cfloop from="1" to="8" index="kk">
					<cfquery name="get_emp_age_blood_" dbtype="query">
						SELECT COUNT_BLOOD_TYPE,BLOOD_TYPE FROM get_emp_age_blood WHERE BLOOD_TYPE = #kk-1#
					</cfquery>
					<cfif len(get_emp_age_blood_.COUNT_BLOOD_TYPE)>
						<cfset label_list_value = ListAppend(label_list_value,get_emp_age_blood_.COUNT_BLOOD_TYPE)>
					<cfelse>
						<cfset label_list_value = ListAppend(label_list_value,0)>
					</cfif>
				</cfloop> 
			<cfelseif  attributes.emp_pro_selection eq 3>
				<cfloop from="1" to="5" index="kk">
					<cfquery name="get_age_" dbtype="query">
						SELECT TYPE,COUNT_AGE FROM get_all_age WHERE TYPE = #kk-1#
					</cfquery>
					<cfif len(get_age_.TYPE)>
						<cfset label_list_value = ListAppend(label_list_value,get_age_.COUNT_AGE)>
					<cfelse>
						<cfset label_list_value = ListAppend(label_list_value,0)>
					</cfif>
				</cfloop> 
			<cfelseif  attributes.emp_pro_selection eq 4>
				<cfloop from="1" to="5" index="kk">
					<cfquery name="get_kidem_" dbtype="query">
						SELECT TYPE,COUNT_KIDEM FROM get_all_kidem WHERE TYPE = #kk#
					</cfquery>
					<cfif len(get_kidem_.TYPE)>
						<cfset label_list_value = ListAppend(label_list_value,get_kidem_.count_kidem)>
					<cfelse>
						<cfset label_list_value = ListAppend(label_list_value,0)>
					</cfif>
				</cfloop>
			<cfelseif attributes.emp_pro_selection eq 5>
				<cfloop query="get_education_level">
                    <CFQUERY name="get_" dbtype="query">
                        SELECT LAST_SCHOOL FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id#
                    </cfquery>
                    <cfset label_list_value = listappend(label_list_value,get_.recordcount)>
				</cfloop>
			<cfelseif attributes.emp_pro_selection eq 6>
				<cfloop query="get_org_step">
					<cfset label_list_value = listappend(label_list_value,sayac)>
				</cfloop>
			</cfif>
			<cfloop list="#label_list#" index="kk">
				<cfset item	="#kk#"> 
				<cfset value="#listgetat(label_list_value,listfind(label_list,kk))#">
			</cfloop>

				<script src="JS/Chart.min.js"></script>
				<div class="col col-4 col-xs-12">
				<canvas id="myChartemployee" style="float:left;max-height:250px;max-width:250px;margin-right:10px;"></canvas></div>
								<script>
									var ctx = document.getElementById('myChartemployee');
										var myChartemployee = new Chart(ctx, {
											type: 'pie',
											data: {
												labels: [<cfloop list="#label_list#" index="kk">
																<cfoutput>"#kk#"</cfoutput>,</cfloop>],
												datasets: [{
													label: " ",
													backgroundColor: [<cfloop list="#label_list#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
													data: [<cfloop list="#label_list#" index="kk"><cfoutput>"#listgetat(label_list_value,listfind(label_list,kk))#"</cfoutput>,</cfloop>],
												}]
											},
											options: {
												legend: {
													display: false
												}
											}
									});
								</script>
								
				<cfif isDefined("variables.label_list2")>
					<div class="col col-4 col-xs-12"><canvas id="myChartemployee2" style="float:left;max-height:250px;max-width:250px;margin-right:10px;"></canvas></div>
					<script>
						var ctx = document.getElementById('myChartemployee2');
							var myChartemployee = new Chart(ctx, {
								type: 'pie',
								data: {
									labels: [<cfloop list="#label_list2#" index="kk">
													<cfoutput>"#kk#"</cfoutput>,</cfloop>],
									datasets: [{
										label: " ",
										backgroundColor: [<cfloop list="#label_list2#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop list="#label_list2#" index="kk"><cfoutput>"#listgetat(label_list_value2,listfind(label_list2,kk))#"</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
					
					<div class="col col-4 col-xs-12">
					<canvas id="myChartemployee3" style="float:left;max-height:250px;max-width:250px;"></canvas></div>
					<script>
						var ctx = document.getElementById('myChartemployee3');
							var myChartemployee = new Chart(ctx, {
								type: 'pie',
								data: {
									labels: [<cfloop list="#label_list3#" index="kk">
													<cfoutput>"#kk#"</cfoutput>,</cfloop>],
									datasets: [{
										label: " ",
										backgroundColor: [<cfloop list="#label_list3#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop list="#label_list3#" index="kk"><cfoutput>"<cfif len(label_list_value3)>#listgetat(label_list_value3,listfind(label_list3,kk))#</cfif>"</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
				</cfif>		      
			
			</td> 
		<td width="5%">&nbsp;</td>
	</tr>
</table> 
</cfform>
</div>
<script language="javascript">
	function load_our_company()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_company_details&search_type='+document.emp_profile.emp_pro_selection.value+'</cfoutput>','div_company_details',1);
		return true;
	}
	function change_profile_det(selection)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_employee_profile_ajaxempprofile&emp_pro_selection='+selection+'</cfoutput>','div_company_details',1);
		return true;
	}
</script>
