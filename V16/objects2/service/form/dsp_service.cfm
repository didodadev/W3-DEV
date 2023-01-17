<cfinclude template="../query/get_pro_guaranty.cfm">
<cfform name="upd_service_stage" action="#request.self#?fuseaction=objects2.emptypopup_upd_service&service_id=#attributes.service_id#" method="post">
<input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
<cfoutput>
	<table border="0" cellspacing="1" cellpadding="2" class="color-border" style="width:100%;">
	  	<tr class="color-row">
			<td>
				<table cellpadding="0" cellspacing="0" border="0" style="width:98%;">
                  	<tr style="height:35px;">
                    	<td class="headbold"><cf_get_lang no='426.Başvuru'> : (#get_service_detail.service_no#) - #get_service_detail.service_head#</td>
                    	<!-- sil -->
                    	<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
                    	<!-- sil -->
                	</tr>   
				</table>
				<table cellpadding="3" cellspacing="3">
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='45.Müşteri'></td>
                        <td>
                  			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_service_detail.service_company_id#</cfoutput>">
                            <input type="hidden" name="company_name"  id="company_name" value="<cfoutput>#get_par_info(get_service_detail.service_company_id,1,1,0)#</cfoutput>">
							<cfoutput>
                                <cfif len(get_service_detail.service_partner_id)>
                                    #get_par_info(get_service_detail.service_partner_id,0,1,0)#
                                <cfelse>
                                    #get_cons_info(get_service_detail.service_consumer_id,2,0)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='166.Yetkili'></td>
                        <td>
                            <input type="hidden" name="member_name" id="member_name" value="<cfoutput>#get_service_detail.applicator_name#</cfoutput>">
                            <cfoutput>#get_service_detail.applicator_name#</cfoutput>
                       	</td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='74.Kategori'></td>
                        <td>
							<cfif len(get_service_detail.servicecat_id)>
                                <cfset attributes.servicecat_id = get_service_detail.servicecat_id>
                                <cfinclude template="../query/get_service_appcat.cfm">
                                #get_service_appcat.servicecat#
                            </cfif>
                        </td>
                    </tr>
					<cfif isDefined('attributes.is_servicecat_sub_id') and (attributes.is_servicecat_sub_id eq 1 or attributes.is_servicecat_sub_id eq 2)>
                        <tr>
                            <td class="formbold">Alt Kategori</td>
                            <td>
                            	<cfif attributes.is_servicecat_sub_id eq 1>
									<cfif len(get_service_detail.servicecat_sub_id)>
                                        <cfquery name="GET_SUBCAT" datasource="#DSN3#">
                                            SELECT SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_id#">
                                        </cfquery>
                                        #get_subcat.servicecat_sub#
                                    </cfif>
                                <cfelse>
									<cfif len(get_service_detail.servicecat_sub_id)>
                                        <cfquery name="GET_SUBCAT" datasource="#DSN3#">
                                            SELECT SERVICECAT_SUB_ID, SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_id#">
                                        </cfquery>
                                        <select name="servicecat_sub" id="servicecat_sub">
                                        	<cfoutput query="get_subcat">
                                            	<option value="#servicecat_sub_id#">#servicecat_sub#</option>
                                            </cfoutput>
                                        </select>
                                    </cfif>
                                </cfif>
                            </td>
                        </tr> 
                    </cfif>
					<cfif isDefined('attributes.is_servicecat_sub_status_id') and attributes.is_servicecat_sub_status_id eq 1>
                        <tr>
                            <td class="formbold">Alt Ağaç Kategori</td>
                            <td>
                                <cfif len(get_service_detail.servicecat_sub_status_id)>
                                    <cfquery name="GET_SUB_STATUS_CAT" datasource="#DSN3#">
                                        SELECT SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_status_id#">
                                    </cfquery>
                                    #get_sub_status_cat.servicecat_sub_status#
                                </cfif>
                            </td>
                        </tr> 
                    </cfif>
					<cfif isdefined('attributes.is_service_stage_view') and attributes.is_service_stage_view eq 1>
                      		<tr>
                        		<td class="txtbold"><cf_get_lang_main no="1447.Süreç"></td>
                        		<td><cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='130' is_detail='1'>&nbsp;&nbsp;
                        		</td>
                      		</tr>
			   		<cfelse>
                        <cfquery name="GET_PROCESS_NAME" datasource="#DSN#">
                            SELECT
                                PROCESS_ROW_ID,
                                STAGE
                            FROM
                                PROCESS_TYPE_ROWS
                            WHERE
                                PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_status_id#">
                        </cfquery>
				 		<tr>
							<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
							<td><cfoutput>#get_process_name.stage#</cfoutput></td>
				  		</tr>
			   		</cfif>
					<tr>
                        <td class="formbold"><cf_get_lang_main no='1561.Alt Aşama'></td>
                        <td>
                            <cfif len(get_service_detail.service_substatus_id)>
                                <cfset attributes.service_substatus_id = get_service_detail.service_substatus_id>
                                <cfinclude template="../query/get_service_substatus.cfm">
                                #get_service_substatus.service_substatus#
                            </cfif>
                        </td>
					</tr>
					<cfif len(get_service_detail.commethod_id)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='731.İletişim'></td>
                            <td>
                                <cfset attributes.commethod_id = get_service_detail.commethod_id>
                                <cfinclude template="../query/get_com_method.cfm">
                                #get_com_method.commethod#
                            </td>
                        </tr>	
                	</cfif>			
					<cfif len(get_service_detail.product_name)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='245.Ürün'></td>
                            <td>#get_service_detail.product_name#</td>
                        </tr>
                	</cfif>
					<cfif len(get_service_detail.pro_serial_no)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='225.Seri No'></td>
                            <td>#get_service_detail.pro_serial_no#</td>
                        </tr>
                    </cfif>
					<cfif len(get_service_detail.main_serial_no)>
                        <tr>
                            <td class="formbold"><cf_get_lang no='596.Ana Seri No'></td>
                            <td>#get_service_detail.main_serial_no#</td>
                        </tr>
                    </cfif>
                    <tr>
                        <td class="formbold"><cf_get_lang no='605.Kabul Tarihi'></td>
                        <td>
                            <cfif len(get_service_detail.apply_date) and isdate(get_service_detail.apply_date)>
                                #dateformat(get_service_detail.apply_date,'dd/mm/yyyy')#
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
                        <td>
                            <cfif len(get_service_detail.finish_date) and isdate(get_service_detail.finish_date)>
                                <cfset fdate=date_add('h',session.pp.time_zone,get_service_detail.finish_date)>
                                <cfset fhour=datepart('h',fdate)>
                                #dateformat(fdate,'dd/mm/yyyy')# #timeformat(fdate,'HH:MM')#
                            </cfif>
                        </td>
                    </tr>
                    <cfif isDefined('attributes.is_service_head') and (attributes.is_service_head eq 1 or attributes.is_service_head eq 2)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='68.Başlık'></td>
                            <td>
                                <cfif attributes.is_service_head eq 2>
                                	<input type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" />
                                <cfelseif attributes.is_service_head eq 1>
                                	#get_service_detail.service_head#
                                </cfif>
                            </td>
                        </tr>
                    </cfif>
                    <cfif isDefined('attributes.is_service_detail') and (attributes.is_service_detail eq 1 or attributes.is_service_detail eq 2)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='217.Açıklama'></td>
                            <td>&nbsp;</td>
                        </tr>
                        <cfif attributes.is_service_detail eq 2>
                            <tr>
                                <td colspan="2">
                                	<textarea name="service_detail" id="service_detail" style="width:465px;height:85px;">#get_service_detail.service_detail#</textarea>
                                </td>
                            </tr>
                        <cfelseif attributes.is_service_detail eq 1>
                        	<tr>
                                <td colspan="2">
                        			#get_service_detail.service_detail#
                        		</td>
                            </tr>
                        </cfif>
                    </cfif>
                    <tr>
                        <td class="formbold"><cf_get_lang no='606.Getiren'></td>
                        <td>#get_service_detail.bring_name#</td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='87.Telefon'></td>
                        <td>#get_service_detail.bring_tel_no#</td>
                    </tr>
                    <tr>
                        <td class="formbold" style="vertical-align:top;"><cf_get_lang no='575.Servis Adresi'></td>
                        <td>
                        	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_service_detail.service_address#</cfoutput>">
                        	#get_service_detail.service_address#
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="txtbold">
                          <cf_get_lang_main no='71.Kayıt'> : 
                          <cfoutput>
                          <cfif len(get_service_detail.record_member)>#get_emp_info(get_service_detail.record_member,0,0)# - 
                          <cfelseif len(get_service_detail.record_par)>#get_par_info(get_service_detail.record_par,0,-1,0)# - 
                          <cfelseif len(get_service_detail.record_cons)>#get_cons_info(get_service_detail.record_cons,0,0)# - 
                          </cfif>
                            #dateformat(get_service_detail.record_date,'dd/mm/yyyy')# #timeformat(date_add('h' ,session_base.time_zone, get_service_detail.record_date),'HH:MM')#
                          </cfoutput>
                        </td>
                    </tr>
                    <tr>
                    	<td align="right"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>	
                </table>
                <br/>
            </td>
            <td style="vertical-align:top;">
                <cfif isdefined("get_pro_guaranty.recordcount") and get_pro_guaranty.recordcount>
                	<cfinclude template="upd_quaranty_service.cfm">
                </cfif>
            </td>
        </tr>
    </table>
</cfoutput>
</cfform>

<script language="javascript">		
	function add_adress(type)
	{
		if(!(document.getElementById('company_id').value==""))
		{
			if(type == 1)
			{
				str_adrlink = '&field_long_adres=upd_service_stage.service_address';
				str_adrlink = str_adrlink+'&field_city=upd_service_stage.service_city_id';
				str_adrlink = str_adrlink+'&field_county=upd_service_stage.service_county_id';
				str_adrlink = str_adrlink+'&field_county_name=upd_service_stage.service_county_name';
				<cfif isDefined('is_county_related_company') and is_county_related_company>
					str_adrlink = str_adrlink+'&is_county_related_company=1';
					//str_adrlink = str_adrlink+'&related_company_id=upd_service_stage.related_company_id';
					//str_adrlink = str_adrlink+'&related_company=upd_service_stage.related_company';
				</cfif>
			}
			else
				str_adrlink = '&field_long_adres=upd_service_stage.bring_detail';
			
			if(document.getElementById('company_id').value!="")
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(document.getElementById('company_name').value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(document.getElementById('member_name').value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='45.Müşteri'>");
			return false;
		}
	}
	
	function pencere_ac(no)
	{
		if (document.upd_service_stage.service_city_id[document.upd_service_stage.service_city_id.selectedIndex].value == "")
			alert("<cf_get_lang no='14.İlk Olarak İl Seçiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_service_stage.service_county_id&field_name=upd_service_stage.service_county_name&city_id=' + document.getElementById('service_city_id').value,'small');
	}
</script>
