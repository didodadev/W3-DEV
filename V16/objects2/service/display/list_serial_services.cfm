<cfquery name="GET_SERVICE" datasource="#DSN3#">
	SELECT
		SERVICE.APPLY_DATE,
		SERVICE_APPCAT.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		SS.SERVICE_SUBSTATUS
	FROM
		SERVICE,
		SERVICE_APPCAT,
		#dsn_alias#.SETUP_PRIORITY AS SP,
		SERVICE_SUBSTATUS SS
	WHERE 		
		<cfif isdefined("session.ww.userid")>
			SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.pp.userid")>
			SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		<cfelse>
			1 = 0 AND
		</cfif>
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
		SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE.SERVICE_SUBSTATUS_ID = SS.SERVICE_SUBSTATUS_ID AND
		PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<table cellspacing="2" cellpadding="2" border="0" style="width:100%;">
  	<tr style="height:22px;">
		<td class="formbold" colspan="7"><cf_get_lang no='642.Seri No Ait Başvurular'></td>
  	</tr>
  	<tr class="color-list" style="height:22px;">
		<td class="txtboldblue" style="width:80px;"><cf_get_lang_main no='330.Tarih'></td>
		<td class="txtboldblue" style="width:60px;"><cf_get_lang_main no='70.Aşama'></td>
		<td class="txtboldblue"><cf_get_lang_main no='68.Konu'></td>
		<td class="txtboldblue" style="width:100px;"><cf_get_lang_main no='74.Kategori'></td>
		<td class="txtboldblue" style="width:100px;"><cf_get_lang no='40.Başvuru Sahibi'></td>
		<td class="txtboldblue" style="width:100px;"><cf_get_lang_main no='157.Görevli'></td>
  	</tr>
  	<cfif get_service.recordcount>
		<cfoutput query="get_service">
	  		<tr class="color-row" style="height:20px;">
				<cfif len(apply_date)>
		  			<cfset h=datepart("h",apply_date)>
				</cfif>
				<td>
		  		<cfif len(apply_date)>
					#dateformat(apply_date,'dd/mm/yyyy')# #h#:00
		  		</cfif>
				</td>
                <td>#service_substatus#</td>
                <td><a href="#request.self#?fuseaction=objects2.upd_service&service_id=#service_id#" class="tableyazi">#service_head#</a></td>
                <td>#servicecat#</td>
                <td >
                    <cfif len(get_service.service_partner_id[currentrow]) and (get_service.service_partner_id[currentrow] neq 0)>
                        #get_par_info(service_partner_id,0,0,0)#
                    </cfif>
                    <cfif len(get_service.service_consumer_id[currentrow]) and  get_service.service_consumer_id[currentrow] neq 0>
                        #get_cons_info(service_consumer_id,2,0)#
                    </cfif>
                    <cfif len(get_service.service_employee_id[currentrow]) and (get_service.service_employee_id[currentrow] neq 0)>
                        #get_emp_info(service_employee_id,0,0)#
                    </cfif>
                </td>
                <cfset col=color>
                <td>
		  		<cfset attributes.service_id=get_service.service_id[currentrow]>
		  		<cfinclude template="../query/get_service_task.cfm">
		  		<cfif get_service_task.recordcount>
                    <cfloop query="get_service_task">
                      <cfif (get_service_task.outsrc_partner_id neq 0) and len(get_service_task.outsrc_partner_id)>
                        #get_par_info(outsrc_partner_id,0,0,1)#
                      </cfif>
                      <cfif (get_service_task.project_emp_id neq 0) and len(get_service_task.project_emp_id)>
                        #get_emp_info(project_emp_id,0,0)#
                        <cfif get_workcube_app_user(project_emp_id,0).recordcount and isdefined("session_base.userid")>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_messages&employee_id=#project_emp_id#','small');"><img src="/images/onlineuser.gif" border="0" title="<cf_get_lang_main no='1899.Mesaj Gönder'>" align="absmiddle"></a>
                        <cfelse>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_nott&public=1&employee_id=#project_emp_id#','small');"><img src="/objects2/image/ok.gif" border="0" title="<cf_get_lang no ='1140.Not Bırak'>" align="absmiddle"></a>
                        </cfif>
                      </cfif>
                    </cfloop>
		  		</cfif>
				</td>
	  		</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
	  		<td td colspan="11"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
  	</cfif>
</table>

