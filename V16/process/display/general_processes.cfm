<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfif isdefined('attributes.is_submitted')>
    <cfquery name="get_general_processes" datasource="#dsn#">
        SELECT
            PM.PROCESS_MAIN_ID,
            #dsn#.Get_Dynamic_Language(PROCESS_MAIN_ID,'#session.ep.language#','PROCESS_MAIN','PROCESS_MAIN_HEADER',NULL,NULL,PROCESS_MAIN_HEADER) AS PROCESS_MAIN_HEADER,
            PM.PROJECT_ID,
            PM.RECORD_EMP,
            PM.RECORD_DATE
        FROM
            PROCESS_MAIN PM
        WHERE
			PM.PROCESS_MAIN_ID IS NOT NULL
			<cfif len(attributes.keyword)>
				AND PM.PROCESS_MAIN_HEADER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				AND PM.PROJECT_ID = #attributes.project_id#
			</cfif>
    </cfquery>
<cfelse>
	<cfset get_general_processes.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_general_processes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="header"><cf_get_lang dictionary_id="36293.Ana Süreçler"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#header#" closable="0">
		<cfform name="general_process" method="post"  action="#request.self#?fuseaction=process.general_processes" >
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" >
				</div>
				<div class="form-group" id="item-project">
					<div class="input-group">
						<cfoutput>
							<input type="hidden" name="project_id"  id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>">
							<input name="project_head" type="text" placeholder="<cf_get_lang dictionary_id='57416.Proje'>" id="project_head"  value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=add_process.project_head&project_id=add_process.project_id');"></span>		
						</cfoutput>
					</div>
				</div>  
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=process.general_processes&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a><!-- sil -->  
				</div>
			</cf_box_search>
		</cfform>
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="20"><i class="fa fa-sitemap"  alt="<cf_get_lang dictionary_id='36170.Visual Designer'>" title="<cf_get_lang dictionary_id='36170.Visual Designer'>"></i></th>
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=process.general_processes&event=add"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_general_processes.recordcount>
					<cfset project_list=''>
					<cfoutput query="get_general_processes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(project_id) and not listfind(project_list,project_id)>
							<cfset project_list = listappend(project_list,project_id)>
						</cfif>
					</cfoutput>
					<cfif len(project_list)>
						<cfset project_list=listsort(project_list,"numeric","ASC",",")>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
						</cfquery>
						<cfset project_list = listsort(listdeleteduplicates(valuelist(get_project.project_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfset employee_list=''>
					<cfoutput query="get_general_processes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_emp) and not listfind(employee_list,record_emp)>
							<cfset employee_list = listappend(employee_list,record_emp)>
						</cfif>
					</cfoutput>
					<cfif len(employee_list)>
						<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
						<cfquery name="get_emp" datasource="#dsn#">
							SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
					</cfif>       
					<cfoutput query="get_general_processes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
								#PROCESS_MAIN_ID#
							</td>
							<td valign="top" nowrap>
								<a style="cursor:pointer" onclick="window.location = '#request.self#?fuseaction=process.designer&event=main&main_process_id=#PROCESS_MAIN_ID#'" class="tableyazi">#PROCESS_MAIN_HEADER#</a>
							</td>
							<td valign="top" nowrap>
								<cfif len(project_id)>
									<a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_list,project_id,',')]#</a>
								</cfif>
							</td>
							<td valign="top" nowrap>
								<cfif len(employee_list)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">
										#get_emp.employee_name[listfind(employee_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_list,record_emp,',')]#
									</a>
								</cfif>
							</td>
							<td valign="top" nowrap>
								#dateformat(RECORD_DATE,dateformat_style)#
							</td>
							<td><a href='#request.self#?fuseaction=process.designer&event=main&main_process_id=#PROCESS_MAIN_ID#'><i class="fa fa-sitemap"  alt="<cf_get_lang dictionary_id='36170.Visual Designer'>" title="<cf_get_lang dictionary_id='36170.Visual Designer'>"
								style="color:black" title="<cf_get_lang dictionary_id='36299.Ana Süreç Tasarım'>"></i></a></td>
							<td><a href = '#request.self#?fuseaction=process.general_processes&event=upd&process_id=#PROCESS_MAIN_ID#'><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
			</cfif>
			
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="process.general_processes#url_str#&is_submitted=#attributes.is_submitted#">
				
					
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
