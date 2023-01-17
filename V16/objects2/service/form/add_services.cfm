<cfinclude template="../../login/send_login.cfm">

<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID, SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT 
</cfquery>
<table cellpadding="1" cellspacing="0" style="width:100%">
	<tr>
		<td>
			<cfform name="form_add_crm" method="post" action="#request.self#?fuseaction=objects2.add_service_act">
            	<input type="text" name="is_serial_no" id="is_serial_no" value="<cfif isDefined('attributes.is_serial_no')><cfoutput>#attributes.is_serial_no#</cfoutput></cfif>">
				<table style="width:100%">
		  			<tr>
						<td style="width:100px;"><cf_get_lang_main no='74.Kategori'></td>
						<td>
			  				<select name="appcat" id="appcat" style="width:200px;" onchange="showAltKategori(this.value);">
								<cfoutput query="get_service_appcat">
                                    <option value="#servicecat_id#">#servicecat#</option>
                                </cfoutput>
			  				</select>
						</td>
		  			</tr>
                    <tr>						
						<td>Alt Kategori*</td>
						<td>
							<div id="sub_cat_place">
								<cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
									<cfquery name="GET_SERVICE_SUB_APPCAT" datasource="#DSN3#">
										 SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_id#">
									</cfquery>
								</cfif>
								<select name="appcat_sub_id" id="appcat_sub_id" style="width:200px;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
										<cfoutput query="get_service_sub_appcat">
										<option value="#servicecat_sub_id#" <cfif servicecat_sub_id eq get_service_detail.servicecat_sub_id>selected</cfif>>#servicecat_sub#</option>
										</cfoutput>
									</cfif>
								</select>	
							</div>
						</td>
					</tr>
                    <tr>
                    	<td>Alt Ağaç Kategori*</td>
                    	<td>
							<div id="sub_cat_tree_place">
								<cfif isdefined("get_service_detail.servicecat_sub_id") and len(get_service_detail.servicecat_sub_id)>
									<cfquery name="GET_SERVICE_SUB_STATUS_APPCAT" datasource="#DSN3#">
										 SELECT SERVICECAT_SUB_STATUS_ID,SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_id#">
									</cfquery>
								</cfif>
								<select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:200px;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<cfif isdefined("get_service_detail.SERVICECAT_SUB_STATUS_ID") and len(get_service_detail.servicecat_sub_status_id)>
										<cfoutput query="get_service_sub_status_appcat">
										<option value="#servicecat_sub_status_id#" <cfif servicecat_sub_status_id eq get_service_detail.servicecat_sub_status_id>selected</cfif>>#servicecat_sub_status#</option>
										</cfoutput>
									</cfif>
								</select>	
							</div>
						</td>
					</tr>
                    <tr>
                    	<td><cf_get_lang_main no='1705.Sistem No'></td>
                    	<td>
                            <input type="hidden" name="subscription_id" id="subscription_id"  value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
                            <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:184px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,MEMBER_NAME','get_subscription','1','SUBSCRIPTION_ID,COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_TYPE,MEMBER_NAME','subscription_id,company_id,company_name,member_id,member_type,member_name','','3','164');" autocomplete="off">
							<!---field_project_id=add_service.project_id&field_project_name=add_service.project_head&field_partner=&--->
					<!---&field_member_id=add_service.member_id&field_member_name=add_service.member_name&field_member_type=add_service.member_type&field_company_id=add_service.company_id&field_company_name=add_service.company_name&field_ship_address=add_service.service_address&field_ship_city_id=add_service.service_city_id&field_ship_county_id=add_service.service_county_id&field_ship_county_name=add_service.service_county_name--->
                            <cfset str_subscription_link="field_id=form_add_crm.subscription_id&field_no=form_add_crm.subscription_no">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    	</td>
                    </tr>
                    <cfif isDefined('attributes.is_serial_no') and attributes.is_serial_no eq 1>
                        <tr>
                            <td><cf_get_lang_main no='225.Seri No'> *</td>
                            <td>
                                <cfsavecontent variable="message"><cf_get_lang no='577.Seri No Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="seri_no" id="seri_no" style="width:200px;" required="yes" message="#message#!">
                            </td>
                        </tr>
                    </cfif>
                    <cfif isDefined('attributes.is_main_serial_no') and attributes.is_main_serial_no eq 1>
                        <tr>
                            <td><cf_get_lang no='596.Ana Seri No'></td>
                            <td><cfinput type="text" name="main_serial_no" id="main_serial_no" style="width:200px;"></td>
                        </tr>
                    </cfif>
		  			<tr>
						<td style="vertical-align:top;"><cf_get_lang no='597.Arıza Tanımı'></td>
						<td><textarea name="crm_detail" id="crm_detail" style="width:300px; height:75px;"></textarea></td>
		  			</tr>
                    <cfif isDefined('attributes.is_bring_name') and attributes.is_bring_name eq 1>
                        <tr>
                            <td><cf_get_lang no='606.Getiren'></td>
                            <td><cfinput type="text" name="bring_name" id="bring_name" value="" maxlength="150" style="width:200px;"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <td><cf_get_lang_main no='87.Telefon'></td>
                        <td><cfinput type="text" name="bring_tel_no" id="bring_tel_no" value="" maxlength="150" style="width:200px;"></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang no='477.Sevk Adresi'></td>
                        <td><textarea name="service_address" id="service_address" style="width:200px;height:70px;"></textarea></td>
                    </tr>
                    <cfif isDefined('attributes.is_accessory_detail') and attributes.is_accessory_detail eq 1>
                        <tr>
                            <td style="vertical-align:top;"><cf_get_lang no='583.Aksesuar'></td>
                            <td><textarea name="accessory_detail" id="accessory_detail" rows="3" cols="27" style="width:200px;"></textarea></td>
                        </tr>
                    </cfif>
                    <cfif isDefined('attributes.is_inside_detail') and attributes.is_inside_detail eq 1>
                        <tr>
                            <td style="vertical-align:top;"><cf_get_lang no='598.Fiziki Hasar'></td>
                            <td><textarea name="inside_detail" id="inside_detail" rows="3" cols="27" style="width:200px;"></textarea></td>
                        </tr>
                    </cfif>
		  			<tr>
						<td></td>
						<td><cf_workcube_buttons is_upd='0'></td>
		  			</tr>
				</table>
            </cfform>
		</td>
	</tr>
</table>
<script language="javascript">
	function showAltKategori()	
	{
		var appcat_id_ = document.getElementById('appcat').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.get_app_sub_cat_ajax&appcat_id="+appcat_id_;
		AjaxPageLoad(send_address,'sub_cat_place',1,'İlişkili Kategoriler');
	}
	
	function showAltTreeKategori()	
	{
		var appcat_sub_id_ = document.getElementById('appcat_sub_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.get_app_sub_cat_ajax&appcat_sub_id="+appcat_sub_id_;
		AjaxPageLoad(send_address,'sub_cat_tree_place',1,'İlişkili Kategoriler');
	}
</script>

