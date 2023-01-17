<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_employees_out" datasource="#dsn#">
		SELECT 
			EIO.EMPLOYEE_ID,
			EIO.FINISH_DATE,
			D.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			EMPLOYEES_IN_OUT  EIO,
			DEPARTMENT D,
			BRANCH B
		WHERE
			EIO.FINISH_DATE IS NOT NULL AND
			EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			EIO.BRANCH_ID = B.BRANCH_ID AND
			B.BRANCH_ID = D.BRANCH_ID AND
		<cfif len(attributes.department)>
			D.DEPARTMENT_ID = #attributes.department#
		<cfelse>
			B.BRANCH_ID = D.BRANCH_ID
		</cfif>	
		<cfif len(attributes.keyword)>
			AND
			(
				EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME LIKE '%#attributes.keyword#%')
				OR
				EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
				OR
				B.BRANCH_NAME  LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif not session.ep.ehesap>
			AND B.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = #session.ep.position_code# AND
									DEPARTMENT_ID IS NULL
								)
		</cfif>
		ORDER BY 
			FINISH_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_employees_out.recordcount=0>
</cfif>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
			<cfparam name="attributes.totalrecords" default=#get_employees_out.recordcount#>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfform name="search" action="#request.self#?fuseaction=hr.list_out_employees" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="55212.Mülakatlar"></cfsavecontent>
				<cf_big_list_search title="#message#">
					<cf_big_list_search_area>
						<table>
							<tr> 
								<td><cf_get_lang dictionary_id='57460.Filtre'></td>
								<td><cfinput type="text" id="keyword" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
								<td> 
								  <select name="department" id="department" style="width:160;">
									<!--- <cfinclude template="../query/get_departments.cfm"> --->
									<cfinclude template="../query/get_all_departments.cfm">
									<option value=""><cf_get_lang dictionary_id='57572.Departman'>
									<cfoutput query="ALL_DEPARTMENTS">
										<option value="#department_id#" <cfif isdefined('attributes.department') and attributes.department eq department_id >Selected</cfif>>&nbsp;#BRANCH_NAME# / #DEPARTMENT_HEAD#</option>
									</cfoutput> 
								  </select>
								</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
								</td>
								<td><cf_wrk_search_button></td>
							</tr>
						</table>
					</cf_big_list_search_area>
				</cf_big_list_search>
				</cfform>
				<cf_big_list> 
					<thead>
						<tr> 
							<th><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th width="250"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
							<th width="110"><cf_get_lang dictionary_id='55931.İşten Çıkış Tarihi'></th>
							<!-- sil -->
							<cfoutput>
							<th class="header_icn_none">
							</th>
							</cfoutput>
							<!-- sil -->
						</tr>
					</thead>
					<tbody>
						<cfif get_employees_out.RecordCount>
							<cfset employee_id_list = ''>
							<cfoutput query="get_employees_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif not listfind(employee_id_list,EMPLOYEE_ID)>
									<cfset employee_id_list = listappend(employee_id_list,EMPLOYEE_ID,',')>
								</cfif>
							</cfoutput>
							<cfset employee_id_list=listsort(employee_id_list,"numeric")>
							<cfif listlen(employee_id_list)>
								<cfquery name="get_employees" datasource="#dsn#">
									SELECT 
										EMPLOYEE_ID,
										EMPLOYEE_NAME,
										EMPLOYEE_SURNAME
									FROM 
										EMPLOYEES
									WHERE 
										EMPLOYEE_ID IN (#employee_id_list#)
									ORDER BY 
										EMPLOYEE_ID
								</cfquery>
								<cfset employee_id_list = listsort(valuelist(get_employees.EMPLOYEE_ID,','),"numeric","ASC",',')>
							</cfif>
							<cfoutput query="get_employees_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td width="40">#currentrow#</td>
								<td><cfif listlen(employee_id_list)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#get_employees.EMPLOYEE_NAME[listfind(employee_id_list,EMPLOYEE_ID,',')]# #get_employees.EMPLOYEE_SURNAME[listfind(employee_id_list,EMPLOYEE_ID,',')]#</a></cfif><!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#employee_name# #employee_surname#</a> ---></td>
								<td>
									<cfquery name="GET_EMP_POS" datasource="#dsn#" maxrows="1">
										SELECT
											HISTORY_ID,
											POSITION_NAME,
											EMPLOYEE_ID,
											POSITION_STATUS,
											DEPARTMENT_ID
										FROM
											EMPLOYEE_POSITIONS_HISTORY
										WHERE
											EMPLOYEE_ID=#EMPLOYEE_ID# AND
											POSITION_STATUS=1
										ORDER BY 
											HISTORY_ID DESC
									</cfquery>
									#get_emp_pos.position_name#
								</td>
								<td>
									#BRANCH_NAME#
								</td>
								<td>
									#dateformat(FINISH_DATE,dateformat_style)#
								</td>
								<!-- sil -->
								<td nowrap="nowrap">
									<cfquery name="control" datasource="#dsn#">
										SELECT 
											INTERVIEW_ID,
											QUIZ_ID
										FROM
											EMPLOYEES_INTERVIEW
										WHERE
											EMPLOYEE_ID = #EMPLOYEE_ID#
									</cfquery>
									<cfif CONTROL.RECORDCOUNT>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_emp_interview&employee_id=#employee_id#&quiz_id=#CONTROL.quiz_id#','list');"><img src="images/update_list.gif"></a>
									</cfif>
								<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_emp_interview&employee_id=#employee_id#','medium');"><img src="images/plus_thin.gif" border="0"></a>
								--->
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_app_position_list_quizs&employee_id=#employee_id#&form_type=5&popup_page=1','list');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>		 
								</td>
								<!-- sil -->
							</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
							</tr>
						</cfif>
					</tbody>
				</cf_big_list>   
<cfparam name="attributes.adres" default="hr.list_timecost">
<cfset adres = "hr.list_out_employees" >
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#" >
</cfif>
<cfif isdefined("attributes.department") and len(attributes.department)>
	<cfset adres = "#adres#&department=#attributes.department#" >
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#" >
</cfif>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#">
    <script type="text/javascript">
    	document.getElementById('keyword').focus();
    </script>
