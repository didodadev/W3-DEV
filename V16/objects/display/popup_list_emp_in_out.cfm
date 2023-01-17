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
show_rel_pos=1 -> iliskili calisanlar gotuntulensin
windowopen('#request.self#?fuseaction=objects.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id&field_emp_name=add_ext_salary.employee&field_emp_id=add_ext_salary.employee_id&field_branch_and_dep=add_ext_salary.department'
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
									POSITION_CODE = #SESSION.EP.POSITION_CODE#
								)
	</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfif isdefined('attributes.show_rel_pos') and attributes.show_rel_pos eq 1>
        <cfquery name="get_control_val" datasource="#dsn#">
            SELECT 
                 PROPERTY_VALUE,
                 PROPERTY_NAME
           FROM
                 FUSEACTION_PROPERTY
            WHERE
                 OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                 FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="myhome.welcome"> AND
                 PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="xml_rel_pos">
        </cfquery>
    </cfif>
	<cfquery name="GET_EMP_IN_OUT" datasource="#dsn#">
		SELECT
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
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
			EMPLOYEES_IDENTY.TC_IDENTY_NO
		FROM
			EMPLOYEES_IN_OUT,
			EMPLOYEES
            <cfif isdefined('attributes.show_rel_pos') and attributes.show_rel_pos eq 1 and isdefined('get_control_val') and get_control_val.property_value eq 1>
            LEFT JOIN WORKGROUP_EMP_PAR ON WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID</cfif>,
			DEPARTMENT,
			BRANCH,	
			OUR_COMPANY,
			EMPLOYEES_IDENTY
		WHERE
			EMPLOYEES.EMPLOYEE_ID=EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
			EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			EMPLOYEES_IN_OUT.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND BRANCH.BRANCH_ID = #attributes.branch_id#
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
									POSITION_CODE = #SESSION.EP.POSITION_CODE#
								)
		</cfif>
		<cfif isdefined('attributes.upper_position_code') and len(attributes.upper_position_code)>
			AND (EMPLOYEES.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND (UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#">   
				<cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
					OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' 
					</cfif>)
            </cfif> 
			OR UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"> OR POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
		
        <cfif isdefined('attributes.show_rel_pos') and attributes.show_rel_pos eq 1 and isdefined('get_control_val') and get_control_val.property_value eq 1>
       		OR (WORKGROUP_EMP_PAR.EMPLOYEE_ID = #session.ep.userid# AND WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID IS NOT NULL))
		<cfelse>
        	OR 1=0)
		</cfif>
		</cfif>
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
			
	</cfquery>
<cfelse>
<cfset GET_EMP_IN_OUT.RECORDCOUNT=0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_EMP_IN_OUT.RECORDCOUNT#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
function add_pos(name,emp_id,branch_name,branch_id,dep_name,dep_id,company,company_id,in_out_id,start_date,tcno)
{
	<cfif isdefined("attributes.field_in_out_id")>
		window.opener.document.all.<cfoutput>#attributes.field_in_out_id#</cfoutput>.value =in_out_id;    /*in_out_id*/
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
		window.opener.document.all.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_emp_name")>
		window.opener.document.all.<cfoutput>#field_emp_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		window.opener.document.all.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		window.opener.document.all.<cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
		window.opener.document.all.<cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
		window.opener.document.all.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_and_dep")>
		window.opener.document.all.<cfoutput>#field_branch_and_dep#</cfoutput>.value = branch_name+'/'+dep_name;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
		window.opener.document.all.<cfoutput>#field_comp#</cfoutput>.value = company;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		window.opener.document.all.<cfoutput>#field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isdefined("attributes.field_start_date")>
		window.opener.document.all.<cfoutput>#field_start_date#</cfoutput>.value = start_date;
	</cfif>
	<cfif isdefined("attributes.field_tcno")>
		window.opener.document.all.<cfoutput>#field_tcno#</cfoutput>.value = tcno;
	</cfif>
	window.close();
}
function reloadopener(){
	wrk_opener_reload();
	window.close();
}
</script>

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
if (isdefined("attributes.upper_position_code")) url_string = "#url_string#&upper_position_code=#attributes.upper_position_code#";
if (isdefined("attributes.is_form_submitted")) url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#";
if (isdefined('attributes.show_rel_pos')) url_string = '#url_string#&show_rel_pos=#attributes.show_rel_pos#';
if (isdefined("attributes.is_position_assistant")) url_string = "#url_string#&is_position_assistant=#attributes.is_position_assistant#";
if (isdefined("attributes.module_id")) url_string = "#url_string#&module_id=#attributes.module_id#";
</cfscript>
<!-- sil -->
<table class="harfler">
	<tr>
		<td>
			<cfoutput>
				<td>&nbsp;</td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=A">A</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=B">B</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=C">C</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Ç">Ç</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=D">D</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=E">E</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=F">F</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=G">G</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Ğ">Ğ</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=H">H</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=I">I</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=İ">İ</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=J">J</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=K">K</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=L">L</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=M">M</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=N">N</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=O">O</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Ö">Ö</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=P">P</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Q">Q</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=R">R</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=S">S</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Ş">Ş</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=T">T</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=U">U</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Ü">Ü</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=V">V</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=W">W</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Y">Y</a></td>
				<td><A href="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#&keyword=Z">Z</a></td>
				<td>&nbsp;</td>
			</cfoutput>
		</td>
	</tr>
</table>
<!-- sil -->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58875.Çalışanlar'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
	<!-- sil --> 
	<cfform action="#request.self#?fuseaction=objects.popup_list_emp_in_out#url_string#" method="post" name="search">
		<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50"></td>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				<td>
					<select name="branch_id" id="branch_id" style="width:200;">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="ALL_BRANCHES">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>          
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>          
			</tr>
		</table>
	<!-- sil -->
	</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th width="120"><cf_get_lang dictionary_id='58768.Giriş-Çıkış Tarihi'></th>
			<th width="120"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
			<th width="80"><cf_get_lang dictionary_id='57572.Departman'></th>
			<th width="15"></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_EMP_IN_OUT.RECORDCOUNT>
			<cfoutput query="GET_EMP_IN_OUT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>
					<a href="javascript://" class="tableyazi"  onClick="add_pos('#get_emp_in_out.employee_name# #get_emp_in_out.employee_surname#','#get_emp_in_out.employee_id#','#get_emp_in_out.branch_name#','#GET_EMP_IN_OUT.BRANCH_ID#','#GET_EMP_IN_OUT.DEPARTMENT_HEAD#','#GET_EMP_IN_OUT.DEPARTMENT_ID#', '#GET_EMP_IN_OUT.NICK_NAME#','#GET_EMP_IN_OUT.COMP_ID#','#GET_EMP_IN_OUT.IN_OUT_ID#','#DATEFORMAT(GET_EMP_IN_OUT.START_DATE,dateformat_style)#','#GET_EMP_IN_OUT.TC_IDENTY_NO#')"><cfif len(finish_date)><font color="FF0000"></cfif>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<cfif len(finish_date)></font></cfif></a>
					</td>
					<td>#dateformat(start_date,dateformat_style)#<cfif len(finish_date)>-#dateformat(finish_date,dateformat_style)#</cfif></td>
					<td>#get_emp_in_out.nick_name#</td>
					<td>#get_emp_in_out.branch_name#</td>
					<td>#get_emp_in_out.department_head#</td>
					<td>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#GET_EMP_IN_OUT.DEPARTMENT_ID#&emp_id=#GET_EMP_IN_OUT.EMPLOYEE_ID##url_string#','medium')"><img src="/images/report_square2.gif"></a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6" class="color-row"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id ='58486.kayıt bulunamadı'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif (isdefined("attributes.branch_id") and len(attributes.branch_id))>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td><cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_emp_in_out#url_string#"> </td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif><br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

