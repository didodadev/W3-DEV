<cfinclude template="../query/get_pro_guaranty.cfm">
<cfoutput>
<table width="100%" border="0" cellspacing="1" cellpadding="2" class="color-border">
  <tr class="color-row">
	<td>
		<table width="98%" cellpadding="0" cellspacing="0" border="0">
		  <tr>
			<td height="35" class="headbold"><cf_get_lang no='426.Başvuru'> : (#get_service_detail.service_no#) - #get_service_detail.service_head#</td>
		  </tr>
		</table>
		<table cellpadding="3" cellspacing="3">
			<tr>
				<td class="formbold"><cf_get_lang_main no='45.Müşteri'></td>
				<td><cfoutput>
						<cfif len(get_service_detail.service_partner_id)>
							<a href="#request.self#?fuseaction=objects2.upd_my_member&company_id=#get_service_detail.service_company_id#" class="tableyazi">#get_par_info(get_service_detail.service_partner_id,0,1,0)#</a>
						<cfelse>
							#get_cons_info(get_service_detail.service_consumer_id,2,0)#
						</cfif>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td class="formbold"><cf_get_lang_main no='166.Yetkili'></td>
				<td><cfoutput>#get_service_detail.applicator_name#</cfoutput></td>
			</tr>
			<tr>
				<td class="formbold"><cf_get_lang_main no='1420.Abone'></td>
				<td><cfif len(get_service_detail.subscription_id)>
						<cfoutput><a href="#request.self#?fuseaction=objects2.dsp_subscription&subscription_id=#get_service_detail.subscription_id#" class="tableyazi">#get_subs.subscription_no#</a></cfoutput>
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="formbold"><cf_get_lang_main no='74.Kategori'></td>
				<td>
				<cfif len(get_service_detail.SERVICECAT_ID)>
					<cfset attributes.SERVICECAT_ID = get_service_detail.SERVICECAT_ID>
					<cfinclude template="../query/get_service_appcat.cfm">
					#GET_SERVICE_APPCAT.servicecat#
				</cfif>
				</td>
			</tr>
			<tr>
				<td class="formbold"><cf_get_lang no='432.Özel Tanım'></td>
				<td>
				<cfif len(get_service_detail.sale_add_option_id)>
					<cfquery name="get_sale_" datasource="#dsn3#">
						SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.sale_add_option_id#">
					</cfquery>
					#get_sale_.SALES_ADD_OPTION_NAME#
				</cfif>
				</td>
			</tr>
			<cfif isdefined('attributes.is_service_stage_view') and attributes.is_service_stage_view eq 1>
			<cfif (isdefined("list_comp_hier") and len(list_comp_hier)) or (isdefined("attributes.type") and attributes.type eq 3)>
			  <cfform name="upd_service_stage" action="#request.self#?fuseaction=objects2.emptypopup_upd_service&service_id=#attributes.id#&list_comp_hier=#list_comp_hier#" method="post">
			  <tr>
				<td class="formbold"><cf_get_lang_main no="1447.Süreç"></td>
				<td><cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='130' is_detail='1'>&nbsp;&nbsp;
				<cf_workcube_buttons is_upd='1' is_delete='0'></td>
			  </tr>
			  </cfform>
			</cfif>
			<cfelse>
			   	 <cfquery name="get_process_name" datasource="#dsn#">
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
					<td><cfoutput>#get_process_name.STAGE#</cfoutput></td>
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
			<tr>
				<td class="formbold"><cf_get_lang_main no='731.İletişim'></td>
				<td>
					<cfif len(get_service_detail.COMMETHOD_ID)>
						<cfset attributes.COMMETHOD_ID = get_service_detail.COMMETHOD_ID>
						<cfinclude template="../query/get_com_method.cfm">
						#GET_COM_METHOD.COMMETHOD#
					</cfif>
				</td>
			</tr>
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
				<td><cfif len(get_service_detail.finish_date) and isdate(get_service_detail.finish_date)>
						#dateformat(get_service_detail.finish_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone, get_service_detail.finish_date),'HH:MM')#
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
		  <tr>
			<td valign="top" class="formbold"><cf_get_lang no='575.Servis Adresi'></td>
			<td>#get_service_detail.service_address#</td>
		  </tr>
		  <tr>
			<!--- <td colspan="2" class="txtbold">
			  Kayıt : 
			  <cfoutput>
			  <cfif len(get_service_detail.record_member)>#get_emp_info(get_service_detail.record_member,0,0)# - 
			  <cfelseif len(get_service_detail.record_par)>#get_par_info(get_service_detail.record_par,0,-1,0)# - 
			  <cfelseif len(get_service_detail.record_cons)>#get_cons_info(get_service_detail.record_cons,0,0)# - 
			  </cfif>
				#dateformat(get_service_detail.record_date,'dd/mm/yyyy')# #timeformat(date_add('h' ,session_base.time_zone, get_service_detail.record_date),'HH:MM')#
			  </cfoutput>
			</td> --->
		</tr>
		</table>
		<br/>
	</td>
  </tr>
</table>
</cfoutput>
