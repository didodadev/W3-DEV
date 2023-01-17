<!---20050923 TolgaS in_out tan çalışanları alıyor
field_in_out_id =in_out id
field_emp_id =employee_id
field_emp_name =employee_name
field_dep_name =department_name
field_dep_id =department_id
field_branch_name = branch_name
field_branch_id =branch_id
field_branch_and_dep = department ve branch ismini atıyor
field_comp =company_name
field_comp_id =company_id
windowopen('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id&field_emp_name=add_ext_salary.employee&field_emp_id=add_ext_salary.employee_id&field_branch_and_dep=add_ext_salary.department'
--->
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
	</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.keyword")>
	<cfquery name="GET_EMP_IN_OUT" datasource="#dsn#">
		SELECT
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.EMPLOYEE_NO,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.HIERARCHY_DEP_ID,
			DEPARTMENT.ADMIN1_POSITION_CODE,
			DEPARTMENT.ADMIN2_POSITION_CODE,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.NICK_NAME,
			EMPLOYEES_IN_OUT.IN_OUT_ID,
			EMPLOYEES_IN_OUT.FINISH_DATE,
			EMPLOYEES_IN_OUT.START_DATE,
			EMPLOYEES_IDENTY.EMPLOYEE_ID,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES_IN_OUT.LAW_NUMBERS
		FROM
			EMPLOYEES_IN_OUT
			INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
			INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
			INNER JOIN OUR_COMPANY ON OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
			INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		WHERE
			EMPLOYEES.EMPLOYEE_ID > 0
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				<cfif database_type is "MSSQL">
					EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
					EMPLOYEES.EMPLOYEE_NO LIKE '%#attributes.keyword#%'
				<cfelseif database_type is "DB2">
					EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
					EMPLOYEES.EMPLOYEE_NO LIKE '%#attributes.keyword#%'
				</cfif>
				)
			</cfif>
			<cfif not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (
									SELECT
										BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES
									WHERE
										POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
									)
			</cfif>
			<cfif isdefined("attributes.is_shift") and len(attributes.is_shift) and attributes.is_shift eq 1>
				AND 
					(
						IS_VARDIYA = 1
						OR
						IS_VARDIYA = 2
					)
			</cfif>
			<cfif isdefined("attributes.is_dep_power_control") and len(attributes.is_dep_power_control) and attributes.is_dep_power_control eq 1>
				AND 
				(
					
					(EMPLOYEES_IN_OUT.DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) )
					OR
					(
						(
							DEPARTMENT.HIERARCHY_DEP_ID LIKE  CONCAT('%.',(select D.DEPARTMENT_ID from DEPARTMENT D LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)),'.%')
							OR
							DEPARTMENT.HIERARCHY_DEP_ID LIKE  CONCAT((select D.DEPARTMENT_ID from DEPARTMENT D LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)),'.%')
						)
					)
				)
			</cfif>
			<cfif isdefined("attributes.is_active") and len(attributes.is_active) and attributes.is_active eq 1>
				AND 
				(
					(EMPLOYEES_IN_OUT.FINISH_DATE IS NULL AND EMPLOYEE_STATUS = 1)
					OR (EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL AND EMPLOYEE_STATUS = 1)
				)
			</cfif>
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_emp_in_out.recordcount=0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp_in_out.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfscript>
	url_string = '';
	if (isdefined('attributes.field_emp_name')) url_string = '#url_string#&field_emp_name=#attributes.field_emp_name#';
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#attributes.field_emp_id#';
	if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#attributes.field_branch_name#';
	if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#attributes.field_branch_id#';
	if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#attributes.field_dep_name#';
	if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#attributes.field_dep_id#';
	if (isdefined('attributes.field_branch_and_dep')) url_string = '#url_string#&field_branch_and_dep=#attributes.field_branch_and_dep#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#attributes.field_comp_id#';
	if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#attributes.field_comp#';
	if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_in_out_id")) url_string = "#url_string#&field_in_out_id=#attributes.field_in_out_id#";
	if (isdefined("attributes.field_start_date")) url_string = "#url_string#&field_start_date=#attributes.field_start_date#";
	if (isdefined("attributes.field_tcno")) url_string = "#url_string#&field_tcno=#attributes.field_tcno#";
	if (isdefined("attributes.field_emp_no")) url_string = "#url_string#&field_emp_no=#attributes.field_emp_no#";
	if (isdefined("attributes.is_shift") and len(attributes.is_shift)) url_string = "#url_string#&is_shift=#attributes.is_shift#";
	if (isdefined("attributes.is_dep_power_control") and len(attributes.is_dep_power_control)) url_string = "#url_string#&is_dep_power_control=#attributes.is_dep_power_control#";
	if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
	if (isdefined("attributes.is_active")) url_string = "#url_string#&is_active=#attributes.is_active#";
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=hr.popup_list_emp_in_out#url_string#" method="post" name="search">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</div> 
				<div class="form-group" id="branch_id">
					<select name="branch_id" id="branch_id" style="width:200;">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="ALL_BRANCHES">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</div>   
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
					<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
				</div>     
			</cf_box_search>     
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id ='58768.Giriş-Çıkış Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th><cf_get_lang dictionary_id ='45829.Kanun No'></th>
					<th width="20"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_emp_in_out.recordcount>
					<cfoutput query="GET_EMP_IN_OUT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
							<a href="javascript://" class="tableyazi" onClick="add_pos('#get_emp_in_out.employee_name# #get_emp_in_out.employee_surname#','#get_emp_in_out.employee_id#','#get_emp_in_out.branch_name#','#get_emp_in_out.branch_id#','#get_emp_in_out.department_head#','#get_emp_in_out.department_id#', '#get_emp_in_out.nick_name#','#get_emp_in_out.comp_id#','#get_emp_in_out.in_out_id#','#dateformat(get_emp_in_out.start_date,dateformat_style)#','#get_emp_in_out.tc_identy_no#','#get_emp_in_out.employee_no#')"><cfif len(finish_date)><font color="FF0000"></cfif>#employee_name# #employee_surname#<cfif len(finish_date)></font></cfif></a>
							</td>
							<td>#dateformat(start_date,dateformat_style)#<cfif len(finish_date)>-#dateformat(finish_date,dateformat_style)#</cfif></td>
							<td>#get_emp_in_out.nick_name#</td>
							<td>#get_emp_in_out.branch_name#</td>
							<td>#get_emp_in_out.department_head#</td>
							<td><cfif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'5921')>5921
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'574680')>5746 (% 80)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'574690')>
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'5921')>5746 (% 90)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'574695')>5746 (% 95)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'5746100')>5746 (% 100)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'6111')>6111
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'5084')>5084
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'5763')>5763
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'6486')>6486
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'6322')>6322
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'25510')>25510
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'4691')>4691
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'14857')>14857
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'6645')>6645
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'46486')>46486
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'56486')>56486
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'66486')>66486
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'68750')>687 (%50)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'687100')>687 (%100)
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'17103')>17103
								<cfelseif len(get_emp_in_out.law_numbers) and listfindnocase(get_emp_in_out.law_numbers,'27103')>27103
								<cfelse>
								</cfif>
							</td>
							<td class="text-center">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#get_emp_in_out.department_id#&emp_id=#get_emp_in_out.employee_id##url_string#','medium')"><img src="/images/report_square2.gif"></a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7" class="color-row"><cfif isdefined("attributes.keyword") and len(attributes.keyword)><cf_get_lang_main no ='1074.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif (isdefined("attributes.branch_id") and len(attributes.branch_id))>
			<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="hr.popup_list_emp_in_out#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	
function add_pos(name,emp_id,branch_name,branch_id,dep_name,dep_id,company,company_id,in_out_id,start_date,tcno,emp_no)
{
	<cfif isdefined("attributes.field_in_out_id")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#attributes.field_in_out_id#</cfoutput>.value =in_out_id;    /*in_out_id*/
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_emp_name")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_emp_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_and_dep")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_branch_and_dep#</cfoutput>.value = branch_name+'/'+dep_name;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_comp#</cfoutput>.value = company;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isdefined("attributes.field_start_date")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_start_date#</cfoutput>.value = start_date;
	</cfif>
	<cfif isdefined("attributes.field_tcno")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_tcno#</cfoutput>.value = tcno;
	</cfif>
	<cfif isdefined("attributes.field_emp_no")>
		<cfif isdefined("attributes.draggable")>window.document.all<cfelse>window.opener.document.all</cfif>.<cfoutput>#field_emp_no#</cfoutput>.value = emp_no;
	</cfif>
	<cfif isdefined("attributes.call_function") and len(attributes.call_function)>
		<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
}
function reloadopener(){
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
}
</script>

