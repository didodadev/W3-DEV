<!--- TolgaS 20051021 
posisyona bağlı dep , branch , company ve headquarters ı forma göndermek için. departmana,şube, şirket veya grup başkalnlı birbirine bağlı olmasa bile ayrı querylerle getiriyor
show_empty_pos= boş posizyonları getirmesi için
diğre değerler
field_id,field_emp_id,field_code,field_pos_name,field_emp_name,field_dep_name,field_dep_id,field_branch_name,field_branch_id,field_comp,field_comp_id,field_head,field_head_id,

query dönerken diğer bilgiler q of q la yapıldı listeye döncek
--->
<cfif isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
	<cfquery name="ALL_BRANCHES" datasource="#DSN#">
		SELECT 
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			COMPANY_ID
		FROM
			BRANCH
		WHERE
			1=1
			<!---BRANCH.SSK_NO IS NOT NULL AND
			BRANCH.SSK_OFFICE IS NOT NULL AND
			BRANCH.SSK_BRANCH IS NOT NULL AND
			BRANCH.SSK_NO <> '' AND
			BRANCH.SSK_OFFICE <> '' AND
			BRANCH.SSK_BRANCH <> ''--->
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

<cfparam name="attributes.keyword" default="">
<cfif arama_yapilmali>
	<cfif not ALL_BRANCHES.recordcount>
	<cfset get_positions.recordcount = 0>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		#dsn#.Get_Dynamic_Language(EMPLOYEE_POSITIONS.POSITION_ID,'#session.ep.language#','EMPLOYEE_POSITIONS','POSITION_NAME',NULL,NULL,EMPLOYEE_POSITIONS.POSITION_NAME) AS POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		DEPARTMENT.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.NICK_NAME,
		OUR_COMPANY.HEADQUARTERS_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		AND BRANCH.COMPANY_ID=OUR_COMPANY.COMP_ID
	<cfif isdefined("attributes.show_empty_pos") and (attributes.show_empty_pos eq 0)>
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL
	</cfif>
	<cfif not session.ep.ehesap>
		AND DEPARTMENT.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE# )
	</cfif>
	<cfif isdefined("attributes.status") and (attributes.status eq 0)>
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 0		  
	<cfelseif isdefined("attributes.status") and (attributes.status eq 1)>
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
	<cfelse>
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif len(attributes.keyword) eq 1>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '#attributes.keyword#%'
		<cfelse>
			AND
			(
			EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND BRANCH.BRANCH_ID=#attributes.branch_id#
	</cfif>
	ORDER BY 
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_NAME
</cfquery>
	<cfset head_list=listdeleteduplicates(valuelist(get_positions.headquarters_id,','))>
	<cfif listlen(head_list,',')>
		<cfquery name="all_head" datasource="#dsn#">
			SELECT
				HEADQUARTERS_ID,
				NAME
			FROM
				SETUP_HEADQUARTERS
			WHERE
				HEADQUARTERS_ID IN(#head_list#)
		</cfquery>
	</cfif>
<cfelse>
	<cfset GET_POSITIONS.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_pos(id,name,code,emp_id,branch_name,branch_id,dep_name,dep_id,pos_name,company,company_id,head,head_id)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_id#</cfoutput>.value += "," + id + ",";    /*position_id*/
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_code")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_code#</cfoutput>.value = code;    /*position_code*/
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_pos_name#</cfoutput>.value = pos_name;
	</cfif>
	<cfif isdefined("attributes.field_emp_name")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_emp_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_comp#</cfoutput>.value = company;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isdefined("attributes.field_head")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_head#</cfoutput>.value = head;
	</cfif>
	<cfif isdefined("attributes.field_head_id")>
		<cfif isdefined("attributes.draggable")>document.<cfelse>opener.</cfif><cfoutput>#field_head_id#</cfoutput>.value = head_id;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
function reloadopener(){
	wrk_opener_reload();
	window.close();
}
</script>
<cfscript>
url_string = '';
if (isdefined('attributes.field_emp_name')) url_string = '#url_string#&field_emp_name=#attributes.field_emp_name#';
if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#attributes.field_emp_mail#';
if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#attributes.field_emp_id#';
if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#attributes.field_pos_name#';
if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#attributes.field_code#';
if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#attributes.field_branch_name#';
if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#attributes.field_branch_id#';
if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#attributes.field_dep_name#';
if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#attributes.field_dep_id#';
if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#attributes.field_comp_id#';
if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#attributes.field_comp#';
if (isdefined('attributes.field_head_id')) url_string = '#url_string#&field_head_id=#attributes.field_head_id#';
if (isdefined('attributes.field_head')) url_string = '#url_string#&field_head=#attributes.field_head#';
if (isdefined('attributes.show_empty_pos')) url_string = '#url_string#&show_empty_pos=#attributes.show_empty_pos#';
</cfscript>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" uidrop="1">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=hr.popup_list_positions_all#url_string#" method="post" name="search">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" value="#attributes.keyword#" name="keyword" placeholder="#getLang('','Filtre',57460)#" maxlength="255">
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</div>
				<div class="form-group medium" id="item-branch_id">
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id='57453.Sube'></option>
						<cfoutput query="ALL_BRANCHES">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search', #attributes.modal_id#)"),DE(""))#">     
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<!-- sil -->
			<thead>		
				<tr>
					<th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th width="120"><cf_get_lang dictionary_id="57574.Şirket"></th>
					<th width="120"><cf_get_lang dictionary_id="31765.Grup Başkanlığı"></th>
					<th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="15"><cf_get_lang dictionary_id='57572.Departman'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_positions.recordcount>
					<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(get_positions.headquarters_id)>
							<cfquery name="get_headquarters" dbtype="query">
								SELECT
									*
								FROM
									ALL_HEAD
								WHERE
									HEADQUARTERS_ID=#get_positions.headquarters_id#
							</cfquery>
						</cfif>
						<tr>
							<td>
								<cfif not isdefined("url.trans")>
									<a href="javascript://" onClick="add_pos('#get_positions.position_id#','#get_positions.employee_name# #get_positions.employee_surname#','#get_positions.position_code#','#get_positions.employee_id#','#get_positions.branch_name#','#get_positions.branch_id#','#get_positions.department_head#','#get_positions.department_id#','#get_positions.position_name#','#get_positions.NICK_NAME#','#get_positions.COMP_ID#','<cfif len(get_positions.headquarters_id)>#get_headquarters.NAME#</cfif>','#get_positions.headquarters_id#')">#POSITION_NAME# <cfif EMPLOYEE_ID eq 0>
										-Boş
									<cfelseif EMPLOYEE_ID gt 0>
										-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
									</cfif></a>
								<cfelse>
									#POSITION_NAME#
								</cfif>
								
							</td>
							<td>#NICK_NAME#</td>
							<td><cfif len(get_positions.headquarters_id)>#get_headquarters.NAME#</cfif></td>
							<td>#BRANCH_NAME#</td>
							<td>#DEPARTMENT_HEAD#</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>	
		<cfif get_positions.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
			</div>
		</cfif>
		<cfif (isdefined("attributes.branch_id") and len(attributes.branch_id))>
			<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="hr.popup_list_positions_all#url_string#">
		</cfif>
	</cf_box>         
</div>               
					
					
			


<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
