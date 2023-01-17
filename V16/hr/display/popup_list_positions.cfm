<cfif isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.show_empty_pos" default='0'>
<cfif arama_yapilmali>
	<cfinclude template="../query/get_positions_.cfm">
<cfelse>
	<cfset GET_POSITIONS.recordcount=0>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID	
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
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
		BRANCH_NAME
</cfquery>
<cfscript>
url_string = '';
if (isdefined('attributes.field_emp_name')) url_string = '#url_string#&field_emp_name=#field_emp_name#';
if (isdefined('attributes.position_employee')) url_string = '#url_string#&position_employee=#position_employee#';
if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#field_branch_id#';
if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#field_dep_id#';
if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#field_comp#';
if (isdefined('attributes.show_empty_pos')) url_string = '#url_string#&show_empty_pos=#attributes.show_empty_pos#';
if (isdefined('attributes.field_table')) url_string = '#url_string#&field_table=#field_table#';
if (isdefined('attributes.field_pos')) url_string = '#url_string#&field_pos=#field_pos#';
if (isdefined('attributes.field_pos_table')) url_string = '#url_string#&field_pos_table=#field_pos_table#';
if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#field_id#";
if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
</cfscript>

<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword ="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=hr.popup_list_positions#url_string#" method="post" name="search_positions">
		<cf_box_search>
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('main','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
			</div>
			<div class="form-group" id="item-branch_id">
				<select name="branch_id" id="branch_id">
					<option value=""><cf_get_lang dictionary_id='57453.Sube'></option>
					<cfoutput query="get_branch">
						<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
					</cfoutput>
				</select>
			</div>    
			<div class="form-group" id="item-branch_id">
				<select name="POSITION_CAT_ID" id="POSITION_CAT_ID">
					<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
					<cfoutput query="get_position_cats">
					<option value="#POSITION_CAT_ID#" <cfif isdefined("attributes.POSITION_CAT_ID") and attributes.POSITION_CAT_ID eq POSITION_CAT_ID>selected</cfif>>#POSITION_CAT#
					</cfoutput>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_positions' , #attributes.modal_id#)"),DE(""))#"> 
			</div>
		</cf_box_search>	
    </cfform>
	<cf_flat_list>
		<cfif attributes.show_empty_pos eq 0>
			<thead>
			<tr>
				<!-- sil --><th width="30"><cf_get_lang dictionary_id='57487.No'></th><!-- sil -->
				<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th><cf_get_lang dictionary_id='57574.Sirket'></th>
				<th><cf_get_lang dictionary_id='57992.Bölge'></th>
				<th><cf_get_lang dictionary_id='57453.Sube'></th>
				<th><cf_get_lang dictionary_id='57572.Departman'></th>
				<!-- sil --><th width="20"><i class="icon-detail"></i></th><!-- sil -->
			</tr>
			</thead>
			<cfif get_positions.recordcount>
				<tbody>
					<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<!-- sil --><td> <CF_ONLINE id="#employee_id#" zone="ep"> </td><!-- sil -->
						<td>
						<cfif not isdefined("url.trans")>
							<a href="javascript://" onClick="add_pos_func('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#', '#position_name#','#NICK_NAME#','#COMP_ID#','#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
							<cfelse>
							#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
						</cfif>
						</td>
						<td>
						<cfif isdefined("url.trans")>
							<a href="javascript://" onClick="add_pos_func('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#', '#position_name#','#NICK_NAME#','#COMP_ID#','#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')">#POSITION_NAME#</a>
							<cfelse>
							<cfif is_master eq 1>
								#POSITION_NAME# 
							<cfelse>
								#POSITION_NAME# (EK)
							</cfif>
						</cfif>
						</td>
						<td>#NICK_NAME#</td>
						<td>#ZONE_NAME# </td>
						<td>#BRANCH_NAME#</td>
						<td>#DEPARTMENT_HEAD#</td>
						<!-- sil --><td>
						<cfif attributes.show_empty_pos eq 0>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&pos_id=#POSITION_CODE##url_string#','medium','popup_emp_det')"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
						</cfif>
						</td><!-- sil -->
					</tr>
					</cfoutput>
			<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
				</tbody>
				</cfif>
		<cfelse>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th><cf_get_lang dictionary_id='57574.Sirket'></th>
						<th><cf_get_lang dictionary_id='57992.Bölge'></th>
						<th><cf_get_lang dictionary_id='57453.Sube'></th>
						<th><cf_get_lang dictionary_id='57572.Departman'></th>
					</tr>
				</thead>
				<cfif get_positions.recordcount>
					<tbody>
						<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
							<cfif not isdefined("url.trans")>
								<a href="##"  onClick="add_pos_func('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#','#position_name#','#NICK_NAME#','#COMP_ID#','#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')">#POSITION_NAME#</a>
							<cfelse>
								<cfif is_master eq 1>
									#POSITION_NAME# 
								<cfelse>
									#POSITION_NAME# (EK)
								</cfif>
							</cfif>
							<cfif EMPLOYEE_ID eq 0>
							-<font color="##FF0000">Bos</font>
							<cfelseif EMPLOYEE_ID gt 0>
							-<font color="##FF0000">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</font>
							</cfif>
							</td>
							<td>#NICK_NAME#</td>
							<td>#ZONE_NAME# </td>
							<td>#BRANCH_NAME#</td>
							<td>#DEPARTMENT_HEAD#</td>
						</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
						</tr>
					</tbody></cfif>
				
		</cfif>
	</cf_flat_list>
	<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
		<cfset url_string = "#url_string#&POSITION_CAT_ID=#POSITION_CAT_ID#">
	</cfif>
	<cfif (isdefined("attributes.branch_id") and len(attributes.branch_id))>
		<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
	</cfif>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="hr.popup_list_positions#url_string#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cf_box>

<script type="text/javascript">
	document.search_positions.keyword.focus();

function add_pos_func(id,name,code,emp_id,branch_name,branch_id,dep_name,dep_id,mail,pos_name,company,company_id,position_employee)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id#</cfoutput>.value += "," + id + ",";    /*position_id*/
	</cfif>
	<cfif isdefined("attributes.field_partner")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner#</cfoutput>.value = "";
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_code#</cfoutput>.value = code;    /*position_code*/
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_pos_name#</cfoutput>.value = pos_name;
	</cfif>
	<cfif isdefined("attributes.field_emp_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_emp_mail")>
		if (mail.length)    
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_emp_mail#</cfoutput>.value = mail;			 
		else{
			 alert("<cf_get_lang dictionary_id='55268.Maili olmayan birini seçtiniz!'> <cf_get_lang dictionary_id='55269.Başka birini seçiniz!'>");
			 return false;
		}		
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp#</cfoutput>.value = company;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isDefined("attributes.field_table")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos_table")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+pos_name+"</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos#</cfoutput>.value += "," + code + ",";
	</cfif>
	<cfif isdefined("attributes.field_id2")>
	   <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id2#</cfoutput>.value += "," + id + ",";
	</cfif>
	<cfif isdefined("attributes.position_employee")>
	    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.position_employee#</cfoutput>.value = position_employee;
	</cfif>
	<cfif isdefined("attributes.ssk_healty")>
	  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=popup_ssk_healty_print.ill_name&field_surname=popup_ssk_healty_print.ill_surname&field_relative=popup_ssk_healty_print.ill_relative&field_birth_date=popup_ssk_healty_print.ill_bdate&field_birth_place=popup_ssk_healty_print.ill_bplace&employee_id=emp_id','medium','employee_relative_ssk');
	</cfif>
	<cfif isdefined("attributes.call_function")>
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
	</cfif>
	get_note = wrk_safe_query('obj_get_note_emp','dsn',0,emp_id);
	if(get_note.recordcount)
		window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_company_note&emp_id='+emp_id+'','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");

	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
function reloadopener(){
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	
}
</script>
