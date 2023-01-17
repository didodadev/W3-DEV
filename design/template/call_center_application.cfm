<cf_get_lang_set module_name="call">
<cfquery name="GET_SERVICE_DETAIL" datasource="#dsn#">
	SELECT * FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_SERVICE_APP_ROWS" datasource="#dsn#"><!--- Basvuru Satirlari- Kategori Bilgileri --->
	SELECT SERVICE_SUB_CAT_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn#"><!--- Kategori --->
	SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT WHERE SERVICECAT_ID = #get_service_detail.servicecat_id#
</cfquery>
<cfif len(GET_SERVICE_APP_ROWS.SERVICE_SUB_CAT_ID)>
	<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#dsn#"><!--- Alt Kategori --->
		SELECT SERVICE_SUB_CAT, SERVICE_SUB_CAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICE_SUB_CAT_ID = #GET_SERVICE_APP_ROWS.SERVICE_SUB_CAT_ID#
	</cfquery>
</cfif>
<cfoutput>
<table width="100%" align="center">
	<tr>
		<td align="center" height="35" class="headbold">
			<cf_get_lang no='97.Başvuru No'> : <cfif len(get_service_detail.service_no)>#get_service_detail.service_no#</cfif>
		</td>
	</tr>
</table>
<br/>
<table width="98%" align="center">
	<tr>
		<td class="txtbold"><cf_get_lang_main no='1717.Başvuru Yapan'></td>
		<td>#get_service_detail.applicator_name#</td>
		<td class="txtbold"><cf_get_lang_main no='73.Öncelik'></td>
		<td><cfquery name="GET_PRIORITY" datasource="#dsn#">
				SELECT PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID = #get_service_detail.priority_id#
			</cfquery>
			#get_priority.priority#
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='102.Başvuru Tarihi'></td>
		<td><cfif len(get_service_detail.apply_date)>
			  <cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
			  <cfset ahour=datepart("H",adate)>
			  #dateformat(get_service_detail.apply_date,dateformat_style)# #TimeFormat(ahour,timeformat_style)#
			</cfif>
			#dateformat(get_service_detail.apply_date,dateformat_style)# #TimeFormat(ahour,timeformat_style)#
		</td>
		<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
		<td><cfquery name="GET_STATUS" datasource="#dsn#">
				SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_service_detail.service_status_id#
			</cfquery>
			#get_status.stage#
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='103.Kabul Tarihi'></td>
		<td><cfif len(get_service_detail.start_date)>
				<cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
				<cfset shour=datepart("H",sdate)>
				#dateformat(get_service_detail.start_date,dateformat_style)# #TimeFormat(shour,timeformat_style)#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
		<td>#get_service_appcat.servicecat#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
		<td><cfif len(get_service_detail.finish_date)>
				<cfset fdate=date_add("H",session.ep.time_zone,get_service_detail.finish_date)>
				<cfset fhour=datepart("H",fdate)>
				#dateformat(get_service_detail.finish_date,dateformat_style)#  #TimeFormat(fhour,timeformat_style)#
			</cfif>
		</td>
		<td class="txtbold" valign="top"><cf_get_lang no='3.Alt Kategori'></td>
		<td>
			<cfif isdefined('GET_SERVICE_APPCAT_SUB') and len(GET_SERVICE_APPCAT_SUB)>
				<cfloop query="GET_SERVICE_APPCAT_SUB">
					#GET_SERVICE_APPCAT_SUB.service_sub_cat#
					<br/>
				</cfloop>
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='731.İletişim'></td>
		<td>
			<cfif len(get_service_detail.commethod_id)>
				<cfquery name="GET_COM_METHOD" datasource="#dsn#">
					SELECT COMMETHOD FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = #get_service_detail.commethod_id#
				</cfquery>
				#get_com_method.commethod#
			</cfif>
		</td>
	</tr>
	<tr height="35">
		<td class="txtbold" colspan="4">
			<cf_get_lang_main no='71.Kayıt'> : 
			<cfif len(get_service_detail.record_member)>
				<cfquery name="GET_EMP" datasource="#dsn#">
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=#get_service_detail.record_member#
				</cfquery>
				#get_emp.employee_name# #get_emp.employee_surname#
			<cfelseif len(get_service_detail.record_par)>
				<cfquery name="GET_PAR" datasource="#dsn#">
					SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID=#get_service_detail.record_par#
				</cfquery>
				#get_par.company_partner_name# #get_par.company_partner_surname#
			</cfif>
			&nbsp; - &nbsp;
			<cfset rdate=date_add("H",session.ep.time_zone,get_service_detail.record_date)>
			<cfset rhour=datepart("H",rdate)>
			<cfset mhour=datepart("n",rdate)>
			#dateformat(get_service_detail.record_date,dateformat_style)# #rhour#:#mhour#
		</td>
	</tr>
	<tr>
		<td colspan="4" class="txtbold"><hr></td>
	</tr>
</table>
<table width="98%" align="center">
	<tr>
		<td class="formbold">#get_service_detail.service_head#</td>
	</tr>
	<tr>
		<td>#get_service_detail.service_detail#</td>
	</tr>
</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
