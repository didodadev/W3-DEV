<cfinclude template="../../../../V16/production_plan/query/get_branch.cfm">
<cfinclude template="../../../../V16/production_plan/query/get_money.cfm">
<cfinclude template="../../../../V16/production_plan/query/get_workstation.cfm">
<cfif isdefined('attributes.keyword')>
	<cfif attributes.keyword is "branch">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='1167.Sube Seçmediniz'>");
		</script>
	</cfif>
	<cfif attributes.keyword is "employee">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='3439.Görevli Seçmediniz !'>");
		</script>
	</cfif>
</cfif>
<cfquery name="GET_WORKSTATION_DETAIL" datasource="#DSN3#">
	SELECT * FROM WORKSTATIONS WHERE STATION_ID = #attributes.station_id#
</cfquery>
<cfset dep_id_list =''>
<cfset loc_id_list =''>
<cfif len(GET_WORKSTATION_DETAIL.exit_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_WORKSTATION_DETAIL.exit_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_WORKSTATION_DETAIL.exit_loc_id,',')>
</cfif>
<cfif len(GET_WORKSTATION_DETAIL.production_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_WORKSTATION_DETAIL.production_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_WORKSTATION_DETAIL.production_loc_id,',')>
</cfif>
<cfif len(GET_WORKSTATION_DETAIL.enter_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_WORKSTATION_DETAIL.enter_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_WORKSTATION_DETAIL.enter_loc_id,',')>
</cfif>
<cfif len(dep_id_list)>
    <cfquery name="GET_DEP" datasource="#DSN#">
        SELECT DEPARTMENT_HEAD, DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dep_id_list#)
    </cfquery>
	<cfif len(loc_id_list)> 
        <cfquery name="GET_LOC" datasource="#DSN#">
            SELECT
                COMMENT,
                LOCATION_ID,
                DEPARTMENT_ID
            FROM
                STOCKS_LOCATION
            WHERE
                LOCATION_ID IN (#loc_id_list#) AND
                DEPARTMENT_ID IN (#dep_id_list#)
        </cfquery>
</cfif>
<cfset exit_dep_name = ''>
<cfset production_dep_name = ''>
<cfset enter_dep_name = ''>
<cfloop query="GET_DEP">
	<cfif GET_WORKSTATION_DETAIL.exit_dep_id eq DEPARTMENT_ID>
        <cfset exit_dep_name = DEPARTMENT_HEAD>
    </cfif>
    <cfif GET_WORKSTATION_DETAIL.production_dep_id eq DEPARTMENT_ID>
        <cfset production_dep_name = DEPARTMENT_HEAD>
    </cfif>
    <cfif GET_WORKSTATION_DETAIL.enter_dep_id eq DEPARTMENT_ID>
        <cfset enter_dep_name = DEPARTMENT_HEAD>
    </cfif>
</cfloop>
<cfset exit_loc_comment = ''>
<cfset production_loc_comment = ''>
<cfset enter_loc_comment = ''>
<cfloop query="GET_LOC">
	<cfif GET_WORKSTATION_DETAIL.exit_loc_id eq LOCATION_ID and GET_WORKSTATION_DETAIL.exit_dep_id eq DEPARTMENT_ID>
		<cfset exit_loc_comment = COMMENT>
	</cfif>
    <cfif GET_WORKSTATION_DETAIL.production_loc_id eq LOCATION_ID and GET_WORKSTATION_DETAIL.production_dep_id eq DEPARTMENT_ID>
		<cfset production_loc_comment =  COMMENT>
	</cfif>
    <cfif GET_WORKSTATION_DETAIL.enter_loc_id eq LOCATION_ID and GET_WORKSTATION_DETAIL.enter_dep_id eq DEPARTMENT_ID>
		<cfset enter_loc_comment = COMMENT>
	</cfif>
</cfloop>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht"><cfoutput>#getLang('prod',40)#</cfoutput>: <cfoutput>#get_workstation_detail.station_name#</cfoutput></td>
        <td class="dphb">
			<cfif not listfindnocase(denied_pages,'product.popup_list_product_workstations')><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_product_workstations&station_id=#attributes.station_id#&station_name=#GET_WORKSTATION_DETAIL.STATION_NAME#</cfoutput>','page');"><img src="/images/hand.gif" border="0" title="<cf_get_lang_main no='3440.İş İstasyonu Masraf ve Muhasebe Kodları'>" /></a></cfif>	
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#attributes.station_id#</cfoutput>','list');"><img src="/images/cuberelation.gif" border="0" title="<cf_get_lang_main no='3441.İlişkili Üretim Emirleri'>"></a>
            <cf_np tablename="WORKSTATIONS" primary_key = "STATION_ID" pointer="STATION_ID=#attributes.station_id#" dsn_var="DSN3"> 
            <a href="javascript://" Onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_workstation</cfoutput>','wide');"> <img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
        </td>
    </tr>
</table>
<cfform name="upd_workstation" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_workstation" onsubmit="return (unformat_fields());">
 <input type="hidden" name="STATION_ID" id="STATION_ID" value="<cfoutput>#attributes.station_id#</cfoutput>" />
  <table class="dpm">
  	<tr>
    	<td class="dpml">
            <cf_form_box width="100%">
                    <cf_area width="700">
                        <table>
                            <tr>
                                <td><cfoutput>#getLang('prod',66)#</cfoutput></td>
                                <td>
                                	<input type="checkbox" name="is_capacity" id="is_capacity" <cfif get_workstation_detail.is_capacity eq 1>checked</cfif> />&nbsp;&nbsp;
                            		<cf_get_lang_main no='81.Aktif'>    
                                	<input type="checkbox" name="active" id="active"<cfif get_workstation_detail.active eq 1>checked</cfif> />
                                </td>
                                <td><cfoutput>#getLang('contract',101)#</cfoutput> *</td>
                                <cfsavecontent variable="message_katsayi"><cf_get_lang_main no='782.Zorunlu Alan'> :<cf_get_lang_main no='3361.Katsayı'></cfsavecontent>
                                <td><cfinput type="text" name="ezgi_katsayi" value="#TlFormat(get_workstation_detail.EZGI_KATSAYI,2)#" required="yes" message="#message_katsayi#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:58px;"></td>
                           </tr>
                            <tr>
                                <td width="80"><cfoutput>#getLang('prod',86)#</cfoutput></td>
                                <td width="220">
                                    <select name="up_station" id="up_station" style="width:170px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_workstation">
											<cfif not len(up_station)>
												<option value="#station_id#" <cfif get_workstation_detail.up_station eq station_id>selected</cfif>>#station_name#</option>
											</cfif>
                                        </cfoutput>
                                    </select>
                                </td>
                                <td><cf_get_lang_main no='3362.Enerji Tüketimi'> *</td>
                                <td nowrap>
                                <cfinclude template="../../../../V16/production_plan/query/get_basic_types.cfm">
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3362.Enerji Tüketimi'></cfsavecontent>
                                <cfinput name="energy" type="text" value="#TlFormat(get_workstation_detail.energy)#" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event,2));" class="moneybox" style="width:58px;">
                                <select name="BASIC_TYPE" id="BASIC_TYPE"  style="width:110px;">
                                    <cfoutput query="get_b_type">
                                    <option value="#basic_input_id#" <cfif get_workstation_detail.basic_input_id eq  basic_input_id>selected</cfif>>#basic_input#</option>
                                    </cfoutput>
                                </select>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='1422.Istasyon'> *</td>
                                <td><cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1422.Istasyon'></cfsavecontent>
                                    <cfinput type="text" name="STATION_NAME" id="STATION_NAME" value="#GET_WORKSTATION_DETAIL.STATION_NAME#" required="yes" message="#message#" style="width:165px;">
                                </td>
                                <td><cf_get_lang_main no='3363.Adam Saat Maliyet'></td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3363.Adam Saat Maliyet'></cfsavecontent>
                                    <cfinput type="text" name="cost" value="#TlFormat(get_workstation_detail.cost,2)#" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:102px;">
                                    <select name="COST_MONEY" id="COST_MONEY" style="width:65px;">
                                        <cfoutput query="get_money">
                                        <option value="#money#" <cfif get_workstation_detail.cost_money eq money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                    <input type="hidden" name="HID_COST_MONEY" id="HID_COST_MONEY" />
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='41.Sube'>*</td>
                                <td><select name="branch_id_sta" id="branch_id_sta" style="width:170px;" onchange="get_departments(this.value);">
                                        <option value=""><cf_get_lang_main no='41.Sube'></option>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#" <cfif get_branch.branch_id eq get_workstation_detail.branch>selected</cfif>>#branch_name#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                                <td><cfoutput>#getLang('prod',101)#</cfoutput></td>
                                <td><input name="employee_number" id="employee_number" type="text" value="<cfif len(get_workstation_detail.employee_number)><cfoutput>#TlFormat(get_workstation_detail.employee_number,0)#</cfoutput></cfif>" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:170px;" /></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='160.Departman'> *</td>
                                <td>
                                   <select name="department_id" id="department_id" style="width:170px;">
                                          <option value=""><cf_get_lang_main no='160.Departman'></option>
                                    </select>
                                </td>
                                <td><cfoutput>#getLang('prod',103)#</cfoutput></td>
                                <td>
                                    <input name="setting_period_hour" id="setting_period_hour" type="hidden" value="" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:55px;" />
                                    <input name="setting_period_minute" id="setting_period_minute" type="hidden" value="" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:55px;" />
                                    <input name="ezgi_setup" id="ezgi_setup" type="text" value="<cfif len(get_workstation_detail.EZGI_SETUP_TIME)><cfoutput>#TlFormat(get_workstation_detail.EZGI_SETUP_TIME,0)#</cfoutput></cfif>" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:55px;" /> <cf_get_lang_main no='3223.Sn'>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='3364.Ortalama Yıl Kapasite'></td>
                                <td>
                                    <cfif len(get_workstation_detail.avg_capacity_day)>
                                        <cfset CAPACITY_DAY=get_workstation_detail.avg_capacity_day>
                                    <cfelse>
                                        <cfset CAPACITY_DAY="">
                                    </cfif>
                                    <cfif len(get_workstation_detail.avg_capacity_hour)>
                                        <cfset CAPACITY_HOUR=get_workstation_detail.avg_capacity_hour>
                                    <cfelse>
                                        <cfset CAPACITY_HOUR="">
                                    </cfif>
                                    <cfsavecontent variable="message">#getLang('prod',431)#</cfsavecontent>
                                    <cfinput name="avg_capacity_day" type="text" validate="integer" range="1,365" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#TlFormat(capacity_day,0)#" class="moneybox" style="width:85px;">
                                    <cfinput name="avg_capacity_hour" type="text" validate="integer" range="1,24" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#TlFormat(CAPACITY_HOUR,0)#" class="moneybox" style="width:82px;">
                                    <cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'>
                                </td>
                                <td><cfoutput>#getLang('prod',96)#</cfoutput></td>
                                <td>
                                    <cfif len(get_workstation_detail.outsource_partner)>
                                        <cfquery name="GET_PARTNER" datasource="#DSN#">
                                            SELECT 
                                                C.FULLNAME AS FULLNAME2, 
                                                CP.COMPANY_PARTNER_NAME,
                                                CP.COMPANY_PARTNER_SURNAME 
                                            FROM 
                                                COMPANY C,
                                                COMPANY_PARTNER CP 
                                            WHERE 
                                                CP.PARTNER_ID = #get_workstation_detail.outsource_partner# AND 
                                                CP.COMPANY_ID = C.COMPANY_ID
                                        </cfquery>
                                        <input type="hidden" name="comp_id" id="comp_id" />
                                        <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_partner.fullname2#</cfoutput>" readonly style="width:170px;" />
                                    <cfelse>
                                        <input type="hidden" name="comp_id" id="comp_id" />
                                        <input type="text" name="comp_name" id="comp_name" value="" readonly style="width:170px;" />
                                    </cfif>
                                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1,2,3,4,5,6&field_name=upd_workstation.partner_name&field_partner=upd_workstation.partner_id&field_comp_name=upd_workstation.comp_name&field_comp_id=upd_workstation.comp_id</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle" /></a>
                                </td>
                            </tr>
                            <tr>
                                <td><cfoutput>#getLang('prod',208)#</cfoutput></td>
                                <td>
                                    <input type="text" name="ws_avg_cost" id="ws_avg_cost" onKeyup="return(FormatCurrency(this,event));" value="<cfoutput>#tlformat(get_workstation_detail.AVG_COST)#</cfoutput>" class="moneybox" style="width:170px;" /> <cfoutput>#get_workstation_detail.cost_money#</cfoutput>
                                </td>
                                <td><cf_get_lang_main no='166.Yetkili'></td>
                                <td>
                                    <cfif len(get_workstation_detail.outsource_partner)>
                                        <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_workstation_detail.outsource_partner#</cfoutput>" />
                                        <input type="text" name="partner_name" id="partner_name" style="width:170px;" readonly VALUE="<cfoutput>#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</cfoutput>" />
                                    <cfelse>
                                        <input type="hidden" name="partner_id" id="partner_id" value="" />
                                        <input type="text" name="partner_name" id="partner_name" value="" style="width:170px;" readonly />
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cfoutput>#getLang('prod',448)#</cfoutput></td>
                                <td>
                                    <cfif len(get_workstation_detail.exit_dep_id) and len(get_workstation_detail.exit_loc_id)>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="exit_location_id,exit_department,exit_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldName="exit_department"
                                            fieldId="exit_location_id"
                                            department_fldId="exit_department_id"
                                            department_id="#get_workstation_detail.exit_dep_id#"
                                            location_id="#get_workstation_detail.exit_loc_id#"
                                            location_name="#exit_dep_name# - #exit_loc_comment#"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            branch_fldId="branch_fldId"
                                            line_info = 1
                                            width="170">
                                    <cfelse>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="exit_location_id,exit_department,exit_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldName="exit_department"
                                            fieldId="exit_location_id"
                                            department_fldId="exit_department_id"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            branch_fldId="branch_fldId"
                                            line_info = 1
                                            width="170">
                                    </cfif>
                                </td>
                                 <td><cfoutput>#getLang('prod',450)#</cfoutput></td>
                                <td>
                                    <cfif len(get_workstation_detail.production_dep_id) and len(get_workstation_detail.production_loc_id)>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="production_location_id,production_department,production_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldId="production_location_id"
                                            fieldName="production_department"
                                            department_fldId="production_department_id"
                                            department_id="#get_workstation_detail.production_dep_id#"
                                            location_id="#get_workstation_detail.production_loc_id#"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            line_info = 2
                                            width="170">
                                    <cfelse>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="production_location_id,production_department,production_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldId="production_location_id"
                                            fieldName="production_department"
                                            department_fldId="production_department_id"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            line_info = 2
                                            width="170">
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cfoutput>#getLang('prod',451)#</cfoutput></td>
                                <td>
                                    <cfif len(get_workstation_detail.enter_dep_id) and len(get_workstation_detail.enter_loc_id)>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="enter_location_id,enter_department,enter_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldId="enter_location_id"
                                            fieldName="enter_department"
                                            department_fldId="enter_department_id"
                                            department_id="#get_workstation_detail.enter_dep_id#"
                                            location_id="#get_workstation_detail.enter_loc_id#"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            line_info = 3
                                            width="170">
                                    <cfelse>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="enter_location_id,enter_department,enter_department_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                            fieldId="enter_location_id"
                                            fieldName="enter_department"
                                            department_fldId="enter_department_id"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            line_info = 3
                                            width="170">
                                    </cfif>
                                </td>
                                <td>A x B x H</td>
                                <td>
                                    <input type="text" style="width:50px" name="width" id="width" value="<cfoutput>#get_workstation_detail.WIDTH#</cfoutput>" />
                                    <input type="text" style="width:50px" name="length" id="length" value="<cfoutput>#get_workstation_detail.LENGTH#</cfoutput>" /> 
                                    <input type="text" style="width:50px" name="height" id="height" value="<cfoutput>#get_workstation_detail.HEIGHT#</cfoutput>" /> 
                                </td>
                            </tr>
                            <tr>
                                <td valign="top"><cf_get_lang_main no='217.Açiklama'></td>
                                <td valign="top" colspan="3"><textarea name="comment" id="comment" style="width:503px; height:65px;"><cfoutput>#get_workstation_detail.comment#</cfoutput></textarea></td>
                            </tr>
                        </table>
                    </cf_area>
                    <cf_area>
                            <cfsavecontent variable="info"><cf_get_lang_main no='157.Görevli'> *</cfsavecontent>
                            <cf_workcube_to_cc 
                            is_update="1" 
                            cc_dsp_name="#info#" 
                            form_name="upd_workstation" 
                            str_list_param="1" 
                            action_dsn="#dsn3#"
                            str_action_names="EMP_ID as CC_EMP"
                            action_table="WORKSTATIONS"
                            action_id_name="STATION_ID"
                            action_id="#attributes.station_id#"
                            data_type="1"
                            str_alias_names="">
                    </cf_area>
                <cf_form_box_footer>
                    <cf_record_info query_name='get_workstation_detail'><cf_workcube_buttons is_upd='1' is_delete='0' add_function ='control()' type_format='1'>
                </cf_form_box_footer>
             </cf_form_box>
             <br />
                <cfsavecontent variable="message"><cf_get_lang_main no='3471.Alt İstasyonlar'></cfsavecontent>
                <cf_box 
                    id="dsp_sub_stat"
                    box_page="#request.self#?fuseaction=prod.emptypopup_ajax_dsp_sub_station&station_id=#attributes.station_id#"
                    title="#message#"
                    add_href="#request.self#?fuseaction=prod.popup_add_workstation&stat_id=#station_id#"
                    closable="0"></cf_box>
        </td>
        <td class="dpmr">
            <cfsavecontent variable="message"><cf_get_lang_main no='1422.İstasyon'>-<cf_get_lang_main no='3367.Kapasite'>/<cf_get_lang_main no='79.Saat'></cfsavecontent>
			<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='35' action_section='STATION_ID' action_id='#attributes.station_id#'>
			<cf_box 
				id="list_product_ws"
				box_page="#request.self#?fuseaction=prod.emptypopup_list_product_ws_ajaxproduct&upd=#attributes.station_id#"
				add_href="#request.self#?fuseaction=prod.popup_add_ws_product&is_upd_workstation=1&ws_id=#attributes.station_id#"
				title="#message#" add_href_size="wwide1"
				closable="0">
            </cf_box>
            <cfsavecontent variable="message"><cf_get_lang_main no='3442.İlişkili Fiziki Varlıklar'></cfsavecontent>
			<cf_box 
				id="rel_phy_asset"
				info_href="#request.self#?fuseaction=assetcare.popup_list_relation_assetp&station_id=#attributes.station_id#"
				title="#message#"
				box_page="#request.self#?fuseaction=prod.emptypopup_ajax_dsp_physical_assets&station_id=#attributes.station_id#"
				closable="0"></cf_box>
          </td>
       </tr>
  </table>
</cfform>  
<cfset attributes.department_id= GET_WORKSTATION_DETAIL.DEPARTMENT>
<script type="text/javascript">
	function get_departments(branch_id){
		var get_dep=workdata('get_branch_dep',branch_id);
		document.upd_workstation.department_id.options.length=0;
		document.upd_workstation.department_id.options[0] = new Option('Departman','');
		if (get_dep.recordcount)
		{
			for(var jj=0;jj<get_dep.recordcount;jj++)
			document.upd_workstation.department_id.options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
		}
	}
	<cfoutput>
	get_departments('#GET_WORKSTATION_DETAIL.BRANCH#');
	<cfif len(GET_WORKSTATION_DETAIL.DEPARTMENT)>
		document.upd_workstation.department_id.value='#GET_WORKSTATION_DETAIL.DEPARTMENT#';	
	</cfif>
	</cfoutput>
	var my_moneys=document.upd_workstation.COST_MONEY.options.length;
	var money=new Array(my_moneys);
	<cfset count=0>
	<cfloop query="get_money">
		<cfset count=count+1>
		money[<cfoutput>#count#</cfoutput>]=<cfoutput>#Evaluate(rate2/rate1)#</cfoutput>;
	</cfloop>
	
	function unformat_fields()
	{
		document.upd_workstation.energy.value = filterNum(document.upd_workstation.energy.value);
		document.upd_workstation.cost.value = filterNum(document.upd_workstation.cost.value);
		document.upd_workstation.employee_number.value = filterNum(document.upd_workstation.employee_number.value,0);
		document.upd_workstation.setting_period_hour.value = filterNum(document.upd_workstation.setting_period_hour.value,0);
		document.upd_workstation.ezgi_setup.value = filterNum(document.upd_workstation.ezgi_setup.value,0);
		document.upd_workstation.ezgi_katsayi.value = filterNum(document.upd_workstation.ezgi_katsayi.value);
		document.upd_workstation.setting_period_minute.value = filterNum(document.upd_workstation.setting_period_minute.value,0);
		document.upd_workstation.avg_capacity_day.value = filterNum(document.upd_workstation.avg_capacity_day.value,0);
		document.upd_workstation.avg_capacity_hour.value = filterNum(document.upd_workstation.avg_capacity_hour.value,0);
		document.upd_workstation.ws_avg_cost.value = filterNum(document.upd_workstation.ws_avg_cost.value);
	}
	function control(){
	/*	if(document.upd_workstation.deliver_get_id.value==''){
			alert("<cf_get_lang no ='600.Görevli Seçiniz'>!");
			return false;
		}*/
		if(document.getElementById('cc_emp_ids') == undefined)
		{
			alert("<cf_get_lang_main no='3443.Görevli Seçiniz'>!");
			return false;
		}
		if (document.upd_workstation.branch_id_sta.value== 0 || document.upd_workstation.department_id.value==0){
			alert("<cf_get_lang_main no='3444.Şube ve Departmanı Eksiksiz Seçiniz'>");	
			return false;
		}
		return true;
	}
</script>