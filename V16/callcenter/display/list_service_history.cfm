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
        SH.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND 
		S.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	ORDER BY
		SH.SERVICE_HISTORY_ID DESC
</cfquery>

<cfquery name="GET_SUB_CAT_HISTORIES" datasource="#DSN#">
    SELECT 
        SERVICE_SUB_CAT_ID,
        SERVICECAT_ID,
        SERVICE_SUB_STATUS_ID,
        SERVICE_ID,
        HISTORY_ID
    FROM 
        G_SERVICE_APP_ROWS_HIST
    WHERE
    	SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
  	SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT 
</cfquery>
<cfquery name="GET_SERV_APPCAT_SUBS" datasource="#DSN#"><!--- Alt Kategori --->
	SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB ORDER BY SERVICE_SUB_CAT
</cfquery>
<cfquery name="GET_SERV_APPCAT_SUB_STATS" datasource="#DSN#"><!--- Alt Tree Kategori --->
	SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS ORDER BY SERVICE_SUB_STATUS
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

<cfif get_service_history.recordcount>
	<cfset record_list = "">
	<cfoutput query="get_service_history">
 		<cfif len(update_member) and not listfind(record_list,update_member)>
			<cfset record_list=listappend(record_list,update_member)>
		</cfif>  
 		<cfif len(record_member) and not listfind(record_list,record_member)>
			<cfset record_list=listappend(record_list,record_member)>
		</cfif> 
    </cfoutput>
</cfif>
<cf_box title="#getLang('call',116)#" draggable="1" closable="1">
	<cfset temp_ = 0>
    <cfoutput query="get_service_history">  
    	<cfquery name="GET_SUB_CAT_HISTORY" dbtype="query">
        	SELECT * FROM GET_SUB_CAT_HISTORIES WHERE HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_history_id#">
        </cfquery>
    	<cfset temp_ = temp_ +1>
		<cfif len(record_list)>
            <cfset record_list = listsort(record_list,'numeric','ASC',',')>
            <cfquery name="GET_RECORD" datasource="#DSN#">
                 SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
            <cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif currentrow eq get_service_history.recordcount>
            <cfsavecontent variable="txt">
                #DateFormat(record_date,dateformat_style)# <cfif len(record_date)>(#TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif> -
                <!---(#TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#) ----> 
                <cfif len(record_member)>
                    #get_record.employee_name[listfind(record_list,record_member,',')]# #get_record.employee_surname[listfind(record_list,record_member,',')]#
                </cfif>
            </cfsavecontent>
		<cfelse>    
            <cfsavecontent variable="txt">
                #DateFormat(update_date,dateformat_style)# <cfif len(update_date)>(#TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif> -
                <!---(#TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#) ----> 
                <cfif len(update_member)>
                    #get_record.employee_name[listfind(record_list,update_member,',')]# #get_record.employee_surname[listfind(record_list,update_member,',')]#
                </cfif>
            </cfsavecontent>
        </cfif>
        <cf_seperator id="history_#temp_#" header="#txt#" is_closed="1">
        <cf_flat_list id="history_#temp_#" style="display:none;">
            <tr>
                <td class="bold" style="width:200px;"><cf_get_lang_main no='75.No'></td>
                <td style="width:200px;">#service_no#</td>
                <td class="bold" style="width:200px;"><cf_get_lang_main no='330.Tarih'></td>
                <td style="width:200px;">
                    <cfif len(get_service_history.update_date)>
                        #DateFormat(update_date,dateformat_style)# (#TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)
                    <cfelseif len(get_service_history.record_date)>
                        #dateformat(get_service_history.record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
                    </cfif>
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang_main no='41.Şube'></td>
                <td>
					<cfif len(service_branch_id)>
                        <cfset attributes.branch_id = service_branch_id>
                        <cfinclude template="../query/get_branch.cfm">
                        #get_branch.branch_name#
                    </cfif>
                </td>
                <td class="bold"><cf_get_lang_main no='74.Kategori'></td>
                <td>
                    <cfif listfindnocase(cat_ids,servicecat_id) neq 0 and (listlen(cat_names) neq 0)>
                        #listgetat(cat_names,listfindnocase(cat_ids,servicecat_id))#
                    </cfif>
                </td>
            </tr>
            <tr>
                <td class="bold" style="vertical-align:top;"><cf_get_lang no='3.Alt Kategori'></td>
                <td>
                    <cfif len(get_sub_cat_history.service_sub_cat_id)>
                        <cfloop query="get_sub_cat_history">
                             <cfquery name="GET_SERV_APPCAT_SUB" dbtype="query">
                                SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERV_APPCAT_SUBS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sub_cat_history.service_sub_cat_id#">
                            </cfquery> 
                            #get_serv_appcat_sub.service_sub_cat# <br/>                  
                        </cfloop>
                    </cfif>
                </td>
                <td class="bold" style="vertical-align:top;"><cf_get_lang no='5.Alt Tree Kategori'></td>
                <td>  
                    <cfif len(get_sub_cat_history.service_sub_status_id)>
                        <cfloop query="get_sub_cat_history">
                            <cfquery name="GET_SERV_APPCAT_SUB_STAT" dbtype="query">
                                SELECT SERVICE_SUB_STATUS_ID, SERVICE_SUB_STATUS FROM GET_SERV_APPCAT_SUB_STATS WHERE SERVICE_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sub_cat_history.service_sub_status_id#">
                            </cfquery>
                            #get_serv_appcat_sub_stat.service_sub_status# <br/>                  
                        </cfloop>
                    </cfif>             
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang_main no='70.Aşama'></td>
                <td>
					<cfif len(service_status_id)>
                        <cfquery name="GET_STATUS_ROW" dbtype="query">
                            SELECT * FROM GET_STATUS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_status_id#">
                        </cfquery>
                        <cfif get_status_row.recordcount>
                            #get_status_row.stage#
                        </cfif>
                    </cfif>
                </td>
                <td class="bold"><cf_get_lang_main no='1174.İşlem Yapan'></td>
                <td>
					<cfif len(get_service_history.update_member)>
                        #get_emp_info(get_service_history.update_member,0,0)#
		   			<cfelseif len(get_service_history.update_par)>
                        #get_par_info(get_service_history.update_par,0,0,1)#
                    <cfelseif len(get_service_history.record_member)>
                        #get_emp_info(get_service_history.record_member,0,0)#
                    <cfelseif len(get_service_history.record_par)>
						#get_par_info(get_service_history.record_par,0,0,1)#
                    </cfif>
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang_main no='217.Açıklama'></td>
                <td colspan="3">#service_detail#</td>
            </tr>
        </cf_flat_list>
    </cfoutput>
</cf_box> 
