<cfinclude template="../query/get_service_detail.cfm">
<cfoutput>
	<table cellspacing="1" cellpadding="2" class="color-border" style="width:100%">
    	<tr class="color-row">
			<td>
                <table cellpadding="0" cellspacing="0" style="width:98%">
                  	<tr style="height:35px;">
                    	<td class="headbold">Başvuru : (#get_service_detail.service_no#) - #get_service_detail.service_head#</td>
                    	<!-- sil -->
                    	<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
                    	<!-- sil -->
               	 	</tr>   
                </table>
				<table cellpadding="3" cellspacing="3" border="0" style="width:98%">
                    <tr>
                        <td class="formbold" style="width:30%"><cf_get_lang_main no='45.Müşteri'></td>
                        <td>
							<cfif len(get_service_detail.service_partner_id)>
                                #get_par_info(get_service_detail.service_partner_id,0,1,0)#
                            <cfelse>
                                #get_cons_info(get_service_detail.service_consumer_id,2,0)#
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='166.Yetkili'></td>
                        <td>#get_service_detail.applicator_name#</td>
                    </tr>
                   <tr>
                        <td class="formbold"><cf_get_lang_main no='74.Kategori'></td>
                        <td>
							<cfif len(get_service_detail.servicecat_id)>
                                <cfset attributes.servicecat_id = get_service_detail.servicecat_id>
                                <cfinclude template="../../objects2/service/query/get_service_appcat.cfm">
                                #get_service_detail.servicecat#
                            </cfif>
                        </td>
                    </tr> 
                    <cfif isDefined('is_servicecat_sub_id') and is_servicecat_sub_id eq 1>
                        <tr>
                            <td class="formbold">Alt Kategori</td>
                            <td>
                                <cfif len(get_service_detail.servicecat_sub_id)>
                                    <cfquery name="GET_SUBCAT" datasource="#DSN3#">
                                        SELECT SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_sub_id#">
                                    </cfquery>
                                    #get_subcat.servicecat_sub#
                                </cfif>
                            </td>
                        </tr> 
                    </cfif>
                    <cfif isDefined('is_servicecat_sub_status_id') and is_servicecat_sub_status_id eq 1>
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
                      	<cfform name="upd_service_stage" action="#request.self#?fuseaction=objects2.emptypopup_upd_service_stage&service_id=#attributes.id#" method="post">
                          	<tr>
                                <td class="txtbold"><cf_get_lang_main no="1447.Süreç"></td>
                                <td><cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='130' is_detail='1'>&nbsp;&nbsp;
                                <cf_workcube_buttons is_upd='1' is_delete='0'></td>
                          	</tr>
                      	</cfform>
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
                            <td class="formbold"><cf_get_lang_main no='70.Aşama'></td>
                            <td>>#get_process_name.stage#</td>
				  		</tr>
			   		</cfif>
					<tr>
                        <td class="formbold"><cf_get_lang_main no='1561.Alt Aşama'></td>
                        <td>
                            <cfif len(get_service_detail.service_substatus_id)>
                                <cfset attributes.service_substatus_id = get_service_detail.service_substatus_id>
                                <cfinclude template="../../objects2/service/query/get_service_substatus.cfm">
                                #get_service_substatus.service_substatus#
                            </cfif>
                        </td>
                    </tr>
					<cfif len(get_service_detail.commethod_id)>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='731.İletişim'></td>
                            <td>
                                <cfset attributes.commethod_id = get_service_detail.commethod_id>
                                <cfinclude template="../../objects2/service/query/get_com_method.cfm">
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
                        <td class="formbold">Kabul Tarihi</td>
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
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='68.Başlık'></td>
                        <td>#get_service_detail.service_head#</td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang_main no='217.Açıklama'></td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">#get_service_detail.service_detail#</td>
                    </tr>
                    <cfif isDefined('is_bring_name') and is_bring_name eq 1>
                        <tr>
                            <td class="formbold">Getiren</td>
                            <td>#get_service_detail.bring_name#</td>
                        </tr>
                    </cfif>
                    <cfif isDefined('is_telephone') and is_telephone eq 1>
                        <tr>
                            <td class="formbold"><cf_get_lang_main no='87.Telefon'></td>
                            <td>#get_service_detail.bring_tel_no#</td>
                        </tr>
                    </cfif>
                    <cfif isDefined('is_service_address') and is_service_address eq 1>
                        <tr>
                            <td class="formbold" style="vertical-align:top;">Servis Adresi</td>
                            <td>#get_service_detail.service_address#</td>
                        </tr>
                    </cfif>
                    <!---<tr>
                        <td colspan="2" class="txtbold">
                          <cf_get_lang_main no='71.Kayıt'> : 
                          <cfif len(get_service_detail.record_member)>#get_emp_info(get_service_detail.record_member,0,0)# - 
                          <cfelseif len(get_service_detail.record_par)>#get_par_info(get_service_detail.record_par,0,-1,0)# - 
                          <cfelseif len(get_service_detail.record_cons)>#get_cons_info(get_service_detail.record_cons,0,0)# - 
                          </cfif>
                            #dateformat(get_service_detail.record_date,'dd/mm/yyyy')# #timeformat(date_add('h' ,session.pda.time_zone, get_service_detail.record_date),'HH:MM')#
                        </td>
                    </tr>--->
                    <tr>
                    	<td colspan="2"><cf_record_info query_name='get_service_detail' record_emp="record_member" update_emp="update_member"></td>
                    </tr>
                </table>
			<br>
		</td>
  	</tr>
</table>
</cfoutput>
