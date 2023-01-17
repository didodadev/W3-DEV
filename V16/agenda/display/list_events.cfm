<cfparam name="attributes.eventcat_id" default="">
<cfparam name="attributes.startdate1" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate1" default="">
<cfparam name="attributes.finishdate2" default="">
<cfif len(attributes.startdate1)><cf_date tarih="attributes.startdate1"></cfif>
<cfif len(attributes.startdate2)><cf_date tarih="attributes.startdate2"></cfif>
<cfif len(attributes.finishdate1)><cf_date tarih="attributes.finishdate1"></cfif>
<cfif len(attributes.finishdate2)><cf_date tarih="attributes.finishdate2"></cfif>
<cfif isdefined("attributes.form_varmi") and attributes.form_varmi eq 1>
	<cfinclude template="../query/get_event_search.cfm">
<cfelse>
	<cfset get_event_search.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_event_search.recordcount#'>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
	<cfinclude template="form_search.cfm">
</cf_box>
<cf_box title="#getLang('','main', 30468)#" uidrop="1" hide_table_column="1" >
	<cf_box_elements>

<cf_grid_list>
         <thead>
                <tr>
                    <th><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no='68.Başlık'></th>
                    <th><cfoutput>#getLang('agenda', 26)#</cfoutput></th>
                    <th><cfoutput>#getLang('agenda', 15)#</cfoutput></th>
                    <th><cf_get_lang_main no='4.Proje'></th>
                    <th><cf_get_lang_main no='41.Şube'></th>
                    <th><cf_get_lang_main no='70.Aşama'></th>
                    <th><cf_get_lang_main no='243.Başlama Tarihi'></th>
                    <th><cf_get_lang_main no='288.Bitiş Tarihi'></th>
                    <th><cf_get_lang_main no='272.Sonuç'></th>
                </tr>
         </thead>
         <tbody>
            <cfset project_name_list = ''>
			<cfif get_event_search.recordcount>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(project_id) and not listfind(project_name_list,project_id)>
						<cfset project_name_list = Listappend(project_name_list,project_id)>
					</cfif>
				</cfoutput>
				<cfif len(project_name_list)>
					<cfquery name="get_project_name" datasource="#dsn#">
						SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
					</cfquery>
					<cfset project_name_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfset get_result_row_list = ''>
				<cfset get_record_emp_list = ''>
				<cfset get_record_par_list = ''>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(event_id) and not listfind(get_result_row_list,event_id)>
						<cfset get_result_row_list = listappend(get_result_row_list,event_id,',')>
					</cfif>
					<cfif len(record_emp) and not listfind(get_record_emp_list,record_emp)>
						<cfset get_record_emp_list = listappend(get_record_emp_list,record_emp,',')>
					</cfif>
					<cfif len(record_par) and not listfind(get_record_par_list,record_par)>
						<cfset get_record_par_list = listappend(get_record_par_list,record_par,',')>
					</cfif>
				</cfoutput>
				<cfif ListLen(get_result_row_list)>
					<cfquery name="get_result_row" datasource="#dsn#">
						SELECT EVENT_ID,EVENT_RESULT_ID FROM EVENT_RESULT WHERE EVENT_ID IN (#get_result_row_list#) ORDER BY EVENT_ID
					</cfquery>
					<cfset get_result_row_list = listsort(ValueList(get_result_row.event_id,','),'numeric','ASC',',')>
				</cfif>
				<cfif ListLen(get_record_emp_list)>
					<cfquery name="get_record_emp" datasource="#dsn#">
						SELECT 
							EP.EMPLOYEE_ID, 
							EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS NAME_SURNAME, 
							B.BRANCH_NAME
						FROM
							EMPLOYEE_POSITIONS EP, 
							DEPARTMENT D,
							BRANCH B
						WHERE
							IS_MASTER = 1 AND
							EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
							B.BRANCH_ID = D.BRANCH_ID AND
							EP.EMPLOYEE_ID IN (#get_record_emp_list#)
						ORDER BY 
							EMPLOYEE_ID
					</cfquery>
					<cfset get_record_emp_list = listsort(ValueList(get_record_emp.employee_id,','),'numeric','ASC',',')>
				</cfif>
				<cfif ListLen(get_record_par_list)>
					<cfquery name="get_record_par" datasource="#dsn#">
						SELECT COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME AS PAR_NAME_SURNAME, PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#get_record_par_list#) ORDER BY PARTNER_ID
					</cfquery>
					<cfset get_record_par_list = listsort(ValueList(get_record_par.partner_id,','),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#event_id#</td>
						<td style="mso-number-format:'\@'"><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#
								<cfif not len(EVENT_PLACE_ID)>
								<cfelseif EVENT_PLACE_ID eq 1><font color=red>(#getLang('agenda', 6)#)
								<cfelseif EVENT_PLACE_ID eq 2><font color=red>(#getLang('agenda', 10)#)
								<cfelseif EVENT_PLACE_ID eq 3><font color=red>(#getLang('agenda', 12)#)
								</cfif>
							</a>
						</td>
						<td>#eventcat#</td>
						<td><cfif len(record_emp)>#get_record_emp.name_surname[listfind(get_record_emp_list,record_emp,',')]#<cfelseif len(record_par)>#get_record_par.par_name_surname[listfind(get_record_par_list,record_par,',')]#</cfif></td>
						<td>
							<cfif len(project_id) and project_id neq 0>
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#get_project_name.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#get_project_name.project_head[listfind(project_name_list,project_id,',')]#</a>
							<cfelse>
								<cf_get_lang_main no='1047.projesiz'>
							</cfif>
                        </td>
						<td><cfif len(record_emp)>#get_record_emp.branch_name[listfind(get_record_emp_list,record_emp,',')]#</cfif></td>
						<td>#stage#</td>
						<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#</td>
						<td>#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
						<td>
							<cfif listfind(get_result_row_list,event_id,',')>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#event_id#','page');" class="tableyazi"><cf_get_lang_main no='179.Olay Tutanagi'></a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="10"><cfif isdefined("attributes.form_varmi")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
</cf_grid_list>

<cfset url_str = "">
<cfset url_str = "#url_str#&form_varmi=1" >
<cfif len(attributes.startdate1)><cfset url_str = "#url_str#&startdate1=#Dateformat(attributes.startdate1,dateformat_style)#"></cfif>
<cfif len(attributes.startdate2)><cfset url_str = "#url_str#&startdate2=#Dateformat(attributes.startdate2,dateformat_style)#"></cfif>
<cfif len(attributes.finishdate1)><cfset url_str = "#url_str#&finishdate1=#Dateformat(attributes.finishdate1,dateformat_style)#"></cfif>
<cfif len(attributes.finishdate2)><cfset url_str = "#url_str#&finishdate2=#Dateformat(attributes.finishdate2,dateformat_style)#"></cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
<cfif isDefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_head") and Len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#URLDecode(attributes.project_head)#">
</cfif>
<cfif isdefined("attributes.eventcat_id") and len(attributes.eventcat_id)>
	<cfset url_str = "#url_str#&eventcat_id=#attributes.eventcat_id#">
</cfif>
<cfif isdefined("attributes.event_id") and len(attributes.event_id)>
	<cfset url_str = "#url_str#&event_id=#attributes.event_id#">
</cfif>
<cfif isdefined("attributes.event_result_id") and len(attributes.event_result_id)>
	<cfset url_str = "#url_str#&event_result_id=#attributes.event_result_id#">
</cfif>
<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
	<cfset url_str= "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
	<cfset url_str= "#url_str#&par_id=#attributes.par_id#">
</cfif>
<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
	<cfset url_str= "#url_str#&cons_id=#attributes.cons_id#">
</cfif>
<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
	<cfset url_str= "#url_str#&member_type=#attributes.member_type#">
</cfif>
<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
	<cfset url_str= "#url_str#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.is_event_result") and len(attributes.is_event_result)>
	<cfset url_str= "#url_str#&is_event_result=#attributes.is_event_result#">
</cfif>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cfset url_str= "#url_str#&process_stage=#attributes.process_stage#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str= "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.department") and len(attributes.department)>
	<cfset url_str= "#url_str#&department=#attributes.department#">
</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows>
    <table width="99%">
        <tr> 
            <td>
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="agenda.view_daily&event=search#url_str#"> 
            </td>
        </tr>
    </table>
    </cfif>
</cf_box_elements>
</cf_box>