<cfset attributes.calc_today=1>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		COMPANY_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
<cfquery name="GET_WORKSTATION" datasource="#DSN3#">
	SELECT
		STATION_ID,
        STATION_NAME 
	FROM
		WORKSTATIONS
	WHERE
		STATION_ID IS NOT NULL AND
		UP_STATION IS NULL AND
		ACTIVE = 1
		<cfif isdefined("attributes.station_id") and len(attributes.station_id)>
			AND STATION_ID <> #attributes.station_id#
		</cfif>
	ORDER BY
		STATION_NAME
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
        BRANCH_ID,
        IS_PRODUCTION,
        DEPARTMENT_HEAD
	FROM
		DEPARTMENT
	WHERE
		BRANCH_ID IS NOT NULL AND
		IS_PRODUCTION = 1
		<cfif isDefined("attributes.branch_id")>
			<cfif attributes.branch_id NEQ 0>
		AND
			BRANCH_ID = #attributes.branch_id#
			</cfif>
		</cfif>
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_ID,
        BRANCH_NAME
	FROM
		BRANCH
	WHERE 
		IS_PRODUCTION=1
		AND COMPANY_ID = #session.ep.company_id#
		AND BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.keyword")>
  <cfif attributes.keyword eq "branch">
    <script language="JavaScript">
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='41.Şube'> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='160.Departman'>");
	</script>
  </cfif>
  <cfif attributes.keyword eq "employee">
    <script language="JavaScript">
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='157.Görevli'>");
	</script>
  </cfif>
</cfif>
<cf_popup_box title="#getLang('prod',357)#">
<cfform name="add_workstation" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_workstation" onsubmit="return ( unformat_fields());">
	<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
		 <tr>
			<td valign="top" style="width:80%">
				<table width="729">
					<tr>
						<td width="111"><cfoutput>#getLang('prod',66)#</cfoutput></td>
                        <cfsavecontent variable="message_katsayi"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3361.Katsayı'></cfsavecontent>
						<td width="227">
                        	<input type="checkbox" name="is_capacity" id="is_capacity">&nbsp;&nbsp;
                      		<cf_get_lang_main no='81.Aktif'>
                          	<input type="checkbox" name="active" id="active" checked>
                        </td>
						<td width="125"><cf_get_lang_main no='3361.Katsayı'> *</td>
						<td width="246" style="width:246px">
                        	<cfinput type="text" name="ezgi_katsayi" value="#TlFormat(1,2)#" required="yes" message="#message_katsayi#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:58px;">
                        </td>
					</tr>
					<tr>
						<td style="width:84px"><cfoutput>#getLang('prod',86)#</cfoutput></td>
						<td style="width:227px">
							<select name="up_station" id="up_station" style="width:175px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_workstation">
									<option value="#station_id#" <cfif isdefined("attributes.stat_id") and  attributes.stat_id eq station_id>selected</cfif>>#station_name#</option>
								</cfoutput>
							</select>
						</td>
					  <td nowrap="nowrap" valign="top"><cfoutput>#getLang('prod',451)#</cfoutput></td>
						<td valign="top">
							<cf_wrkdepartmentlocation
								returninputvalue="enter_location_id,enter_department,enter_department_id,enter_branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="enter_department"
								branch_fldid="enter_branch_id"
								fieldid="enter_location_id"
								department_fldid="enter_department_id"
                                boxwidth="290"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 1
								width="175">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1422.İstasyon'> *</td>
						<td>
							<cfinput type="text" name="station_name" maxlength="50" id="station_name"  style="width:175px;">
						</td>
						<td><cfoutput>#getLang('prod',450)#</cfoutput></td>
						<td nowrap="nowrap">
							<cf_wrkdepartmentlocation
								returninputvalue="production_location_id,production_department,production_department_id,production_branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="production_department"
								branch_fldid="production_branch_id"
								fieldid="production_location_id"
								department_fldid="production_department_id"
                                boxwidth="290"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 2
								width="175">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='41.Şube'> *</td>
						<td>
							<select name="branch_id" id="branch_id" style="width:175px;" onchange="redirect(this.options.selectedIndex)">
								<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_branch">
									<cfif isDefined("attributes.department_id") and attributes.branch_id eq branch_id><cfset cat_id = currentrow></cfif>
									<option value="#branch_id#">#branch_name#</option>
								</cfoutput>
							</select>
						</td>
						<td style="width:99px"><cfoutput>#getLang('prod',448)#</cfoutput></td>
						<td nowrap="nowrap">
							<cf_wrkdepartmentlocation
								returninputvalue="exit_location_id,exit_department,exit_department_id,exit_branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="exit_department"
								branch_fldid="exit_branch_id"
								fieldid="exit_location_id"
								department_fldid="exit_department_id"
                                boxwidth="290"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 3
								width="175">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='160.Departman'> *</td>
						<td>
							<select name="department_id" id="department_id" style="width:175px;">
								<option value="0"><cfoutput>#getLang('prod',90)#</cfoutput></option>
							</select>
						</td>
						<td><cfoutput>#getLang('prod',94)#</cfoutput> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3362.Enerji Tüketimi'></cfsavecontent>
							<cfinput type="text" name="energy" maxlength="10" required="yes" message="#message#" onKeyup="return(formatcurrency(this,event,2));" class="moneybox" style="width:72px;">
							<cfinclude template="../../../../V16/production_plan/query/get_basic_types.cfm">
							<select name="BASIC_TYPE" id="BASIC_TYPE" style="width:100px;">
								<cfoutput query="get_b_type">
									<option  value="#basic_input_id#">#basic_input#</option>
								</cfoutput>
							</select>				  
						</td>
					</tr>
				   <tr>
						<td><cfoutput>#getLang('prod',212)#</cfoutput> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3363.Adam Saat Maliyet'></cfsavecontent>
							<cfinput type="text" name="cost" required="yes" maxlength="10" message="#message#" onKeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox" style="width:100px;">
							<select name="COST_MONEY" id="COST_MONEY"  style="width:72px;">
								<cfoutput query="get_money">
									<option value="#money#">#money#</option>
								</cfoutput>
							</select>
						</td>
						<td><cfoutput>#getLang('prod',101)#</cfoutput></td>
						<td><input type="text" name="employee_number" id="employee_number" maxlength="10" onkeyup="return(FormatCurrency(this,event,0,'int'));" class="moneybox" style="width:175px;"></td>
					</tr>
					<tr>
						<td><cfoutput>#getLang('prod',96)#</cfoutput></td>
						<td><input type="hidden" name="comp_id" id="comp_id">
							<input type="text" name="comp_name" id="comp_name" readonly style="width:175px;">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=add_workstation.partner_name&field_partner=add_workstation.partner_id&field_comp_name=add_workstation.comp_name&field_comp_id=add_workstation.comp_id</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
						<td><cfoutput>#getLang('prod',87)#</cfoutput></td>
						<td nowrap="nowrap">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3364.Ortalama Yıl Kapasite'></cfsavecontent>
							<cfinput name="avg_capacity_day" type="text" range="1,365" maxlength="10" message="#message#" onKeyup="return(formatcurrency(this,event,0));" class="moneybox" style="width:85px;">
							<cfinput name="avg_capacity_hour" type="text" range="1,24" maxlength="10" message="#message#" onKeyup="return(formatcurrency(this,event,0));" class="moneybox" style="width:85px;">
							<cf_get_lang_main no='78.Saat'>/<cf_get_lang_main no='79.Saat'>                  
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='166.Yetkili'></td>
						<td>
							<input type="hidden" name="partner_id" id="partner_id">
							<input type="text" name="partner_name" id="partner_name" readonly style="width:175px;">
						</td>
						<td>A x B x H</td>
						<td>
							<input type="text" style="width:40px" maxlength="5" name="width" id="width" value="" />
							<input type="text" style="width:40px" maxlength="5" name="length" id="length" value="" /> 
							<input type="text" style="width:40px" maxlength="5" name="height" id="height" value="" />
						</td>
					</tr>
					<tr>
						<td><cfoutput>#getLang('prod',103)#</cfoutput></td>
						<td nowrap>
							<input name="setting_period_hour" id="setting_period_hour" type="hidden" onkeyup="return(FormatCurrency(this,event,0,'int'));" maxlength="10" class="moneybox" style="width:53px;">
							<input name="setting_period_minute" id="setting_period_minute" type="hidden" onkeyup="return(FormatCurrency(this,event,0,'int'));" maxlength="5" class="moneybox" style="width:53px;">
                            <input name="ezgi_setup" id="ezgi_setup" type="text" onkeyup="return(FormatCurrency(this,event,0,'int'));" maxlength="5" class="moneybox" style="width:53px;"> <cf_get_lang_main no='3223.Sn'>.
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
						<td><textarea name="comment" id="comment" style="width:175px; height:30px;" maxlength="200" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cf_get_lang_main no='3470.Açıklama 200 karakterden uzun olamaz'>"></textarea></td>
						<td></td>
						<td></td>
					</tr>
				</table>
			</td>
			<td style="vertical-align:top;width:20%">
				<cfsavecontent variable="info"><cf_get_lang_main no='157.Görevli'> *</cfsavecontent>
				<cf_workcube_to_cc
					is_update="0"
					cc_dsp_name="#info#"
					form_name="add_workstation"
					str_list_param="1"
					data_type="2">
			</td>
		</tr>
	 </table>
	<cf_popup_box_footer>
    	<cf_workcube_buttons is_upd='0' add_function ='control()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script language="JavaScript">
	var groups=document.add_workstation.branch_id.options.length;
	var group=new Array(groups);
	for (i=0; i<groups; i++)
		group[i]=new Array();
	<cfset sayac = 1>
	<cfloop query="get_branch">
		<cfset attributes.branch_id = branch_id>
		<cfset attributes.names=1>
		<cfquery name="GET_DEPARTMENT_ROW" dbtype="query">
			SELECT
				*
			FROM
				GET_DEPARTMENT
			WHERE
				BRANCH_ID IS NOT NULL AND
				IS_PRODUCTION = 1
				<cfif isDefined("attributes.branch_id")>
					<cfif attributes.branch_id NEQ 0>
				AND
					BRANCH_ID = #attributes.branch_id#
					</cfif>
				</cfif>
			ORDER BY
				DEPARTMENT_HEAD
		</cfquery> 
	
		group[<cfoutput>#sayac#</cfoutput>][0]=new Option("Seçiniz","0");
	
			<cfoutput query="get_department_row">
				  <cfif isDefined("attributes.department_id")>
					<cfif attributes.department_id eq department_id>
						<cfset id = currentrow>
					</cfif>
				  </cfif>
				group[#sayac#][#currentrow#]=new Option("#department_head#","#department_id#");
			</cfoutput>
	
		<cfset sayac = sayac + 1>
	</cfloop>
	var temp=document.add_workstation.department_id;
	
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
			temp.options[m]=null;
		for (i=0;i<group[x].length;i++)
		{
			temp.options[i]=new Option(group[x][i].text,group[x][i].value);
		}
		temp.options[0].selected=true;
	}
	<cfif isDefined("attributes.department_id")>
		document.add_workstation.branch_id.selectedIndex = <cfoutput>#cat_id#</cfoutput>;
		redirect(<cfoutput>#cat_id#</cfoutput>);
		document.add_workstation.department_id.selectedIndex = <cfoutput>#id#</cfoutput>;
	</cfif>
	function unformat_fields()
	{
		document.add_workstation.energy.value = filterNum(document.add_workstation.energy.value);
		document.add_workstation.cost.value = filterNum(document.add_workstation.cost.value);
		document.add_workstation.employee_number.value = filterNum(document.add_workstation.employee_number.value,0);
		document.add_workstation.setting_period_hour.value = filterNum(document.add_workstation.setting_period_hour.value,0);
		document.add_workstation.setting_period_minute.value = filterNum(document.add_workstation.setting_period_minute.value,0);
		document.add_workstation.avg_capacity_day.value = filterNum(document.add_workstation.avg_capacity_day.value,0);
		document.add_workstation.avg_capacity_hour.value = filterNum(document.add_workstation.avg_capacity_hour.value,0);
		document.add_workstation.ezgi_setup.value = filterNum(document.add_workstation.ezgi_setup.value,0);
		document.add_workstation.ezgi_katsayi.value = filterNum(document.add_workstation.ezgi_katsayi.value);
	}
	function control()
	{
		if(document.add_workstation.station_name.value=='')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1422.İstasyon'>");
			return false;
		}
		if (document.add_workstation.branch_id.value== 0 || document.add_workstation.department_id.value==0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='41.Şube'> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='160.Departman'>");	
			return false;
		}
		if ((document.add_workstation.comment.value.length) > 250)
		{
			alert("<cf_get_lang_main no='3365.En Fazla 250 Karakter Açıklama Girebilirsiniz.'>");	
			return false;
		}
		if(isNaN(document.add_workstation.length.value))
		{
			alert("<cf_get_lang_main no='3366.Hatalı Veri Girişi : En / Boy / Yükseklik'>");
			return false;
		}
		if(document.getElementById('cc_emp_ids') == undefined)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='157.Görevli'>");
			return false;
		}
		return true;
	}
</script>