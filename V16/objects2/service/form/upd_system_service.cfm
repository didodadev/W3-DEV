<cfinclude template="../query/get_service_appcat.cfm">
<cfinclude template="../query/get_service_status.cfm">
<cfinclude template="../query/get_sale_add_options.cfm">

<cfform name="add_service" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_system_service&id=#url.service_id#">	 
	<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:100%;">
	  	<tr class="color-row">  
			<td>
				<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
			 		<cfoutput>
			  			<tr style="height:35px;">
							<td class="headbold"><cf_get_lang no='426.Başvuru'> : #get_service_detail.service_no#</td>
							<td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_service_application_print_form&service_id=#get_service_detail.service_id#','page');"><img src="/images/print.gif" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a></td>
			  			</tr>
			  		</cfoutput>
				</table>
				<table>
                    <tr>
                        <td><cf_get_lang_main no='45.Müşteri'></td>
                        <td class="txtbold">
							<cfoutput>
                                <cfif len(get_service_detail.service_partner_id)>
                                    #get_par_info(get_service_detail.service_partner_id,0,1,0)#
                                <cfelse>
                                    #get_cons_info(get_service_detail.service_consumer_id,1,0)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='166.Yetkili'></td>
                        <td class="txtbold"><cfoutput>#get_service_detail.applicator_name#</cfoutput></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1420.Abone'></td>
                        <td>
                        	<input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_service_detail.subscription_id#</cfoutput>">
                          	<input type="text" name="subscription_no" id="subscription_no" value="<cfif len(get_service_detail.subscription_id)><cfoutput>#get_subs.subscription_no#</cfoutput></cfif>" readonly style="width:180px;">
                          	<cfset str_subscription_link="field_partner=&field_id=add_service.subscription_id&field_no=add_service.subscription_no&field_ship_address=add_service.service_address">
                          	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='468.Başvuru Tarihi'></td>
                        <td><input type="text" value="<cfoutput>#dateformat(get_service_detail.apply_date,'dd/mm/yyyy')#</cfoutput>" style="width:200px;" readonly></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='68.Başlık'></td>
                        <td><cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" maxlength="100" style="width:200px;"></td>
                     </tr>
                    <tr>
                        <td><cf_get_lang_main no='74.Kategori'></td>
                        <td>
                            <select name="appcat_id" id="appcat_id" style="width:200px;">
                                <cfoutput query="get_service_appcat">
                                    <cfif is_internet eq 1>
                                        <option value="#servicecat_id#" <cfif get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='432.Özel Tanım'></td>
                        <td>
                            <select name="sale_add_option_id" id="sale_add_option_id" style="width:200px;">
								<cfoutput query="get_sale_add_options">
                                    <option value="#sales_add_option_id#" <cfif get_service_detail.sale_add_option_id eq sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang no='477.Sevk Adresi'></td>
                        <td><textarea name="service_address" id="service_address" style="width:200px;height:60px;"><cfoutput>#get_service_detail.service_address#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang no='597.Arıza Tanımı'></td>
                        <td><textarea name="service_detail" id="service_detail" style="width:300px;height:60px;"><cfoutput>#get_service_detail.service_detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="txtbold"><cf_get_lang_main no='71.kayıt'> :
							<cfoutput>
								<cfif len(get_service_detail.record_member)>#get_emp_info(get_service_detail.record_member,0,0)# - </cfif>
                                <cfif len(get_service_detail.record_par)>#get_par_info(get_service_detail.record_par,0,-1,0)# - </cfif>
                                <cfif len(get_service_detail.record_cons)>#get_cons_info(get_service_detail.record_cons,0,0)# - </cfif>
                                #dateformat(date_add('h',session_base.time_zone,get_service_detail.record_date),'dd/mm/yyyy')#
                                #timeformat(date_add('h' ,session_base.time_zone, get_service_detail.record_date),'HH:MM')#&nbsp;
                            </cfoutput>
                            <cfif len(get_service_detail.update_member) or len(get_service_detail.update_par)>
                            	<br/><cf_get_lang_main no='479.Güncelleyen'> :
                            </cfif>
                            <cfoutput>
								<cfif len(get_service_detail.update_member)>#get_emp_info(get_service_detail.update_member,0,0)# - 
                                <cfelseif len(get_service_detail.update_par)> #get_par_info(get_service_detail.update_par,0,-1,0)# - 
                                <cfelseif len(get_service_detail.update_cons)> #get_cons_info(get_service_detail.update_cons,0,0)# - 
                                </cfif>
                                <cfif len(get_service_detail.update_date)>
                                #dateformat(date_add('h',session_base.time_zone,get_service_detail.update_date),'dd/mm/yyyy')#&nbsp;
                                #timeformat(date_add('h',session_base.time_zone, get_service_detail.update_date),'HH:MM')#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right" style="text-align:right;">
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='chk_form()'>
                        </td>
		      		</tr>
				</table>
			</td>
			<cfif isdefined("get_pro_guaranty.recordcount") and get_pro_guaranty.recordcount>
				<td style="vertical-align:top;">
					<cfinclude template="upd_quaranty_service.cfm">
				</td>
			</cfif>
  		</tr>
	</table>
</cfform>
<script type="text/javascript">
	function chk_form()
	{
		if(document.getElementById('appcat_id').value=="")
		{
			alert("<cf_get_lang no='572.Service Kategorisini Giriniz'>!");
			return false;
		}
	}
</script>
