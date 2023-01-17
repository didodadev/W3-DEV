<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID, SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT 
</cfquery>

<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Servis Ekle</td>
	</tr>
</table>
<cfform name="form_add_crm" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_service_act">
    <table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%" class="color-border">
        <tr>
            <td class="color-row">
                <table style="width:100%">
                    <tr>
                        <td style="width:30%;"><cf_get_lang_main no='74.Kategori'></td>
                        <td colspan="2">
                            <select name="appcat" id="appcat" onchange="showAltKategori(this.value);" style="width:250px;">
                                <cfoutput query="get_service_appcat">
                                    <option value="#servicecat_id#" <cfif listgetat(default_category_ids,1,',') eq servicecat_id>selected</cfif>>#servicecat#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>						
                        <td>Alt Kategori*</td>
                        <td colspan="2">
                            <div id="sub_cat_place">
                                <cfif ((isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)) or (isDefined('default_category_ids') and len(listgetat(default_category_ids,1,','))))>
                                    <cfquery name="GET_SERVICE_SUB_APPCAT" datasource="#DSN3#">
                                        SELECT 
                                         	SERVICECAT_SUB_ID,
                                            SERVICECAT_SUB 
                                        FROM 
                                        	SERVICE_APPCAT_SUB 
                                        WHERE
                                        	<cfif len(listgetat(default_category_ids,1,','))>
                                            	SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(default_category_ids,1,',')#">
                                            <cfelse>  
                                        		SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_id#">
                                    		</cfif>
                                    	ORDER BY
                                        	SERVICECAT_SUB
                                    </cfquery>
                                </cfif>
                                <select name="appcat_sub_id" id="appcat_sub_id" onchange="showAltTreeKategori(this.value);" style="width:250px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif (isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)) or (isDefined('default_category_ids') and len(listgetat(default_category_ids,2,',')))>
                                        <cfoutput query="get_service_sub_appcat">
                                        <option value="#servicecat_sub_id#" <cfif (isDefined('get_service_detail') and servicecat_sub_id eq get_service_detail.servicecat_sub_id) or (listgetat(default_category_ids,2,',') eq servicecat_sub_id)>selected</cfif>>#servicecat_sub#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>	
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Alt Tree Kategori*</td>
                        <td>
                            <div id="sub_cat_tree_place">
                                <cfif (isdefined("get_service_detail.servicecat_sub_id") and len(get_service_detail.servicecat_sub_id)) or (isDefined('default_category_ids') and len(listgetat(default_category_ids,2,',')))>
                                    <cfquery name="GET_SERVICE_SUB_STATUS_APPCAT" datasource="#DSN3#">
                                    	SELECT 
                                         	SERVICECAT_SUB_STATUS_ID,
                                            SERVICECAT_SUB_STATUS 
                                        FROM 
                                         	SERVICE_APPCAT_SUB_STATUS 
                                        WHERE
                                          	<cfif len(listgetat(default_category_ids,2,','))>
                                            	SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(default_category_ids,2,',')#">
                                            <cfelse>  
                                            	SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_id#">
                                            </cfif> 
                                        ORDER BY
                                        	SERVICECAT_SUB_STATUS 
                                    </cfquery>
                                </cfif>
                                <select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:250px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif (isdefined("get_service_detail.servicecat_sub_status_id") and len(get_service_detail.servicecat_sub_status_id)) or (isDefined('default_category_ids') and len(listgetat(default_category_ids,2,',')))>
                                        <cfoutput query="get_service_sub_status_appcat">
                                        <option value="#servicecat_sub_status_id#" <cfif servicecat_sub_status_id eq (isDefined('get_service_detail') and get_service_detail.servicecat_sub_status_id)>selected</cfif>>#servicecat_sub_status#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>	
                            </div>
                        </td>
                        <td>
                            <input type="text" name="search_sub_cat" id="search_sub_cat" value="" style="width:184px;" autocomplete="off">
                           <a href="javascript://" onclick="get_search_sub_cat_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="3"><div id="sub_cat_div"></div></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1705.Sistem No'> *</td>
                        <td colspan="2">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id")><cfoutput>#attributes.project_id#</cfoutput></cfif>" />
                            <input type="hidden" name="subscription_id" id="subscription_id"  value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
                            <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:184px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,MEMBER_NAME','get_subscription','1','SUBSCRIPTION_ID,COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_TYPE,MEMBER_NAME','subscription_id,company_id,company_name,member_id,member_type,member_name','','3','164');" autocomplete="off">
                            <!---field_project_id=add_service.project_id&field_project_name=add_service.project_head&field_partner=&--->
                    <!---&field_member_id=add_service.member_id&field_member_name=add_service.member_name&field_member_type=add_service.member_type&field_company_id=add_service.company_id&field_company_name=add_service.company_name&field_ship_address=add_service.service_address&field_ship_city_id=add_service.service_city_id&field_ship_county_id=add_service.service_county_id&field_ship_county_name=add_service.service_county_name--->
                            <cfset str_subscription_link="field_id=form_add_crm.subscription_id&field_no=form_add_crm.subscription_no">
                            <!---<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscription&#str_subscription_link#'</cfoutput>,'list','popup_list_subscription');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>--->
                            <a href="javascript://" onclick="get_subscriptions_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr><td colspan="2" style="vertical-align:top;"><div id="subscription_div"></div></td></tr>
                    <cfif isDefined('attributes.is_serial_no') and attributes.is_serial_no eq 1>
                        <tr>
                            <td><cf_get_lang_main no='225.Seri No'> *</td>
                            <td colspan="2">
                                <cfsavecontent variable="message"><cf_get_lang no='577.Seri No Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="seri_no" id="seri_no" style="width:200px;" required="yes" message="#message#!">
                            </td>
                        </tr>
                    </cfif>
                    <cfif isDefined('attributes.is_main_serial_no') and attributes.is_main_serial_no eq 1>
                        <tr>
                            <td><cf_get_lang no='596.Ana Seri No'></td>
                            <td colspan="2"><input type="text" name="main_serial_no" id="main_serial_no" value="" style="width:200px;"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <td style="vertical-align:top;">Arıza Tanımı</td>
                        <td colspan="2"><textarea name="crm_detail" id="crm_detail"></textarea></td>
                    </tr>
                    <cfif isDefined('attributes.is_bring_name') and attributes.is_bring_name eq 1>
                        <tr>
                            <td><cf_get_lang no='606.Getiren'></td>
                            <td colspan="2"><input type="text" name="bring_name" id="bring_name" value="" maxlength="150" style="width:200px;"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <td><cf_get_lang_main no='87.Telefon'></td>
                        <td colspan="2"><input type="text" name="bring_tel_no" id="bring_tel_no" value="" maxlength="150" style="width:200px;"></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;">Sevk Adresi</td>
                        <td colspan="2"><textarea name="service_address" id="service_address"></textarea></td>
                    </tr>
                    <cfif isDefined('attributes.is_accessory_detail') and attributes.is_accessory_detail eq 1>
                        <tr>
                            <td style="vertical-align:top;"><cf_get_lang no='583.Aksesuar'></td>
                            <td colspan="2"><textarea name="accessory_detail" id="accessory_detail" rows="3" cols="27"></textarea></td>
                        </tr>
                    </cfif>
                    <cfif isDefined('attributes.is_inside_detail') and attributes.is_inside_detail eq 1>
                        <tr>
                            <td style="vertical-align:top;"><cf_get_lang no='598.Fiziki Hasar'></td>
                            <td colspan="2"><textarea name="inside_detail" id="inside_detail" rows="3" cols="27"></textarea></td>
                        </tr>
                    </cfif>
                    <tr>
                        <td colspan="2"></td>
                        <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br/>
</cfform>
       
<script language="javascript">
	function showAltKategori()	
	{
		var appcat_id_ = document.getElementById('appcat').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_app_sub_cat_ajax&appcat_id="+appcat_id_;
		AjaxPageLoad(send_address,'sub_cat_place',1,'İlişkili Kategoriler');
	}
	
	function showAltTreeKategori()	
	{
		var appcat_sub_id_ = document.getElementById('appcat_sub_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_app_sub_cat_ajax&appcat_sub_id="+appcat_sub_id_;
		AjaxPageLoad(send_address,'sub_cat_tree_place',1,'İlişkili Kategoriler');
	}

	function add_subscription_div(subscription_id,subscription,project_id)
	{
		document.getElementById('project_id').value = project_id;
		document.getElementById('subscription_id').value = subscription_id;
		document.getElementById('subscription_no').value = subscription;
		gizle(subscription_div);
	}
	
	function get_subscriptions_div()
	{
		if(document.getElementById('subscription_no').value.length < 3)
		{
			alert("Lütfen sistem alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(subscription_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_subscription_div&keyword='+document.getElementById('subscription_no').value+'','subscription_div');		
		return false;
	}
	
	function get_search_sub_cat_div()
	{
		/*if(document.getElementById('search_sub_cat').value.length < 3)
		{
			alert("Lütfen arama alanı için en az 3 karakter giriniz !");
			return false;
		}*/
		goster(sub_cat_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_subcat_div&keyword='+document.getElementById('search_sub_cat').value+'&sub_app_cat='+document.getElementById('appcat_sub_id').value+'','sub_cat_div');		
		return false; 
	}
	function kontrol()
	{
		if(document.getElementById('project_id').value == '' || document.getElementById('subscription_no').value == '')
		{
			alert('Lütfen projesi olan bir sistem vseçiniz!');
			return false;
		}
		if(document.getElementById('appcat_sub_status_id').value.length == 0 || document.getElementById('appcat_sub_id').value.length == 0)
		{
			alert('Lütfen kategori seçiniz!');
			return false;
		}
	}
	// process_cat_control();
</script>

