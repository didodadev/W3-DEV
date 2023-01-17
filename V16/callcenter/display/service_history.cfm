<cfsetting showdebugoutput="no">
<cfquery name="GET_SERVICE_HISTORY" datasource="#DSN#">
	SELECT
		SH.UPDATE_DATE,
		SH.RECORD_DATE,
		SH.SERVICECAT_ID,
		SH.SERVICE_STATUS_ID,
		SH.UPDATE_MEMBER,
		SH.RECORD_MEMBER,
		SH.RECORD_PAR,
		SH.UPDATE_PAR,
		SH.SERVICE_DETAIL,
		SH.SERVICE_HISTORY_ID,
		S.SERVICE_NO,
		S.SERVICE_BRANCH_ID
	FROM
		G_SERVICE_HISTORY SH,
		G_SERVICE S
	WHERE
        SH.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.service_id#"> AND 
		S.SERVICE_ID = SH.SERVICE_ID
	ORDER BY
		SH.SERVICE_HISTORY_ID DESC
</cfquery>

<cfquery name="GET_CAT" datasource="#DSN#">
  	SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT 
</cfquery>
<cfif get_cat.recordcount>
  	<cfset cat_ids = valuelist(get_cat.servicecat_id)>
  	<cfset cat_names = valuelist(get_cat.servicecat)>
</cfif>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS 
</cfquery>
<!---<cfif get_status.recordcount>
  <cfset status_ids = valuelist(get_status.process_row_id)>
  <cfset status_names = valuelist(get_status.stage)>
</cfif>--->

<cf_ajax_list>
	<thead>
		<tr>
			<th width="50"><cf_get_lang_main no='75.No'></th>
			<th width="100"><cf_get_lang_main no='330.Tarih'></th>
			<th width="110"><cf_get_lang_main no='41.Şube'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>		  
			<th width="75"><cf_get_lang_main no='70.Aşama'></th>
			<th width="125"><cf_get_lang_main no='1174.İşlem Yapan'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
			<th width="15"></th>   
		</tr>
	</thead>
	<tbody>
   		<cfset counter = 1>
    	<cfif get_service_history.recordcount>
	    	<cfoutput query="get_service_history"> 
         		<tr>
					<td>
						#service_no#
					</td>
					<td>
						<cfif len(get_service_history.update_date)>
			  				#dateformat(update_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)
			  			<cfelseif len(get_service_history.record_date)>
			  				#dateformat(get_service_history.record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
			 			</cfif>
				  	</td>
				  	<td>
						<cfif len(service_branch_id)>
			  				<cfset attributes.branch_id = service_branch_id>
							<cfinclude template="../query/get_branch.cfm">
							#get_branch.branch_name#
			  			</cfif>
				  	</td>
				  	<td>
						<!---#GET_CAT.SERVICECAT#--->
						<cfif listfindnocase(cat_ids,servicecat_id) neq 0 and (listlen(cat_names) neq 0)>
					  		#listgetat(cat_names,listfindnocase(cat_ids,servicecat_id))#
						</cfif>
				  	</td>			  
				  	<td>
						<!---#GET_STATUS.SERVICE_STATUS#--->
						<!--- <cfif listfindnocase(status_ids,service_status_id) neq 0 and (listlen(status_names) neq 0)>
							#listgetat(status_names,listfindnocase(status_ids,service_status_id))#
						</cfif> --->
                        <cfif len(service_status_id)>
                            <cfquery name="GET_STATUS_ROW" dbtype="query">
                                SELECT * FROM GET_STATUS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_status_id#">
                            </cfquery>
                            <cfif get_status_row.recordcount>
                                #get_status_row.stage#
                            </cfif>
                        </cfif>
				  	</td>
                  	<td>
				   		<cfif len(get_service_history.update_member)>
							#get_emp_info(get_service_history.update_member,0,0)#
		   				<cfelseif len(get_service_history.update_par)>
				        	#get_par_info(get_service_history.update_par,0,0,1)#
				  		<cfelseif len(get_service_history.record_member)>
				 	 		#get_emp_info(get_service_history.record_member,0,0)#
						<cfelseif len(record_par)>
                            #get_par_info(get_service_history.record_par,0,-1,0)#
				   		</cfif>
					  </td>
					<cfset service_detail_ = replace(service_detail,'<p>','','all')>
                    <cfset service_detail_ = replace(service_detail_,'</p>','','all')>
			  		<td title="#service_detail_#">&nbsp;#left(service_detail,50)#</td>
			  		<td>
			  			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=call.list_service&event=upd_history&service_history_id=#service_history_id#','small');"><img src="/images/update_list.gif" border="0"></a>
			  		</td>
		 		 </tr>
		   		<cfset counter = counter +1>
        	</cfoutput> 
		<cfelse>
          	<tr> 
		  		<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  	</tr>
		</cfif>
	</tbody>
</cf_ajax_list>

