<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="0">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="GET_BRANCH_INFO" datasource="#DSN#">
	SELECT
		OUR_COMPANY.NICK_NAME, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		ZONE.ZONE_NAME
	FROM
		BRANCH,		
		ZONE,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID = #attributes.branch_id#
		AND BRANCH.ZONE_ID= ZONE.ZONE_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID 
</cfquery>
<cfquery name="GET_POSITIONS" datasource="#DSN#">
	SELECT
		DEPARTMENT.DEPARTMENT_HEAD DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME BRANCH_NAME,
		EMPLOYEE_POSITIONS.POSITION_NAME POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE POSITION_CODE,
		DEPARTMENT.DEPARTMENT_ID DEPARTMENT_ID,
		ZONE.ZONE_NAME ZONE_NAME
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.BRANCH_ID = #attributes.branch_id#
		AND BRANCH.ZONE_ID=ZONE.ZONE_ID		
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		AND DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID 
	<cfif len(attributes.KEYWORD)>
		AND
		(
			EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
 	ORDER BY POSITION_NAME
</cfquery>
<cfset url_str = "">
<cfoutput>
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.branch_id)>
  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
</cfoutput>
<cfsavecontent variable="title_"><cfoutput>#get_branch_info.nick_name#</cfoutput></cfsavecontent>
<cf_box title="#title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=objects.popup_list_branch_position" method="post" name="search">
		<cf_box_search>
			<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small" id="item-maxrows">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="5"><cfoutput>#get_branch_info.zone_name# / #get_branch_info.branch_name#</cfoutput></th>
			</tr>
			<tr>
				<th width="15">&nbsp;</th>
				<th width="150" nowrap><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th width="100"><cf_get_lang dictionary_id='57576.Çalisan'></th>
				<th width="100"><cf_get_lang dictionary_id='35449.Department'></th>
			</tr>
		</thead>
		<tbody>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfif get_positions.recordcount>
				<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="15"><CF_ONLINE id="#employee_id#" zone="ep"></td>
					<td width="130"> 
						#POSITION_NAME#
					</td>               
					<td>
					<cfif not isdefined("url.trans")>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&DEPARTMENT_ID=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&POS_ID=#POSITION_CODE##url_str#')">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
					<cfelse>
							#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
					</cfif>
					</td>
					<td>#DEPARTMENT_HEAD#</td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
				</tr>				
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_branch_position#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
