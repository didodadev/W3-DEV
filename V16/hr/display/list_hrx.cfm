<cf_xml_page_edit fuseact="hr.list_hr">
<cfinclude template="../query/get_titles.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<!--- Pozistyon ekleme sayfasının xml ine göre pozisyon alanını kapatıyoruz --->
<cfquery name="get_position_list_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'hr.form_add_position'
</cfquery>
<cfif (get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0><cfset show_position = 1><cfelse><cfset show_position = 0></cfif>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.list_hr%">
	ORDER BY 
		PTR.LINE_NUMBER 
</cfquery>
<cfif isdefined("attributes.keyword")>
	<cfset filtered = 1>
</cfif>
<cfparam name="attributes.position_cat_status" default="1">
<cfparam name="attributes.dep_status" default="1">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.organization_step_id" default="">
<cfparam name="attributes.duty_type" default="">
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfset url_str = "#url_str#&keyword2=#attributes.keyword2#">
<cfif len(attributes.hierarchy)>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif len(attributes.title_id)>
	<cfset url_str="#url_str#&title_id=#attributes.title_id#">
</cfif>
<cfif len(attributes.position_name)>
	<cfset url_str="#url_str#&position_name=#attributes.position_name#">
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.department")>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif isdefined("attributes.emp_status") and len(attributes.emp_status)>
	<cfset url_str = "#url_str#&emp_status=#attributes.emp_status#">
</cfif>
<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
	<cfset url_str = "#url_str#&func_id=#attributes.func_id#">
</cfif>
<cfif isdefined("attributes.organization_step_id") and len(attributes.organization_step_id)>
	<cfset url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#">
</cfif>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
</cfif>
<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
	<cfset url_str = "#url_str#&duty_type=#attributes.duty_type#">
</cfif>
<cfif isdefined("filtered")>
	<cfinclude template="../query/get_hrs.cfm">
<cfelse>
	<cfset recordcount.recct = 0>
  	<cfset get_hrs.recordcount = 0>
</cfif>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT 
</cfquery>
<cfquery name="get_organization_steps" datasource="#dsn#">
	SELECT ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT 
	WHERE
		<cfif len(attributes.position_cat_status)>
			<cfif attributes.position_cat_status eq 0>
				POSITION_CAT_STATUS is NULL
			<cfelseif attributes.position_cat_status eq 1>
				POSITION_CAT_STATUS = 1 
			</cfif>
	</cfif>
	ORDER 
		BY POSITION_CAT
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	<cfif attributes.is_active is 1>
		AND BRANCH.BRANCH_STATUS = #attributes.is_active#
	<cfelseif attributes.is_active is 0>
		AND BRANCH.BRANCH_STATUS = #attributes.is_active#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfinclude template="list_hr_search.cfm">
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
			<!-- sil --><th width="10"></th><!-- sil -->
			<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
			<!-- sil --><th width="30"></th><!-- sil -->
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<cfif is_ozel_kod>
				<th width="80"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
			</cfif>
			<th width="125"><cf_get_lang dictionary_id='57453.Şube'></th>
			<th width="125"><cf_get_lang dictionary_id='57572.Departman'></th>
			<th width="125"><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
			<cfif show_position eq 1>
				<th width="125"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
			</cfif>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='55738.Gruba Giriş'></th>
			<th><cf_get_lang dictionary_id ='55975.Son İşe Giriş'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id ='56398.Son İşten Çıkış'></th>
			<!-- sil -->
			<th class="header_icn_none"><cf_get_lang dictionary_id='58143.İletişim'></th>
			<th class="header_icn_none">
				<cfif not listfindnocase(denied_pages,'hr.form_add_emp')>
					<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=add" class="tableyazi">
						<img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>">
					</a>
				</cfif>
			</th>
			<th class="header_icn_none"><img src="/images/print2.gif" title="<cf_get_lang_main no='62.Yazdır'>"></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.totalrecords" default="0">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
		<cfif get_hrs.recordcount>
			<cfobject component="/V16/WMO/GeneralFunctions" name="GnlFunctions">
			<!---<cfparam name="attributes.totalrecords" default="#recordcount.recct#">--->
			<cfset attributes.totalrecords = get_hrs.recordcount>	
			<cfset employee_list = ''>
<!---			<cfset im_cats = ''>--->
			<cfset main_employee_list = ''>
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset employee_list = listappend(employee_list,get_hrs.employee_id,',')>
<!---				<cfif len(IMCAT_ID)>
						<cfset im_cats = listappend(im_cats,IMCAT_ID)>
					</cfif>
					<cfif len(IMCAT2_ID)>
						<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
				</cfif>--->
			</cfoutput>
			<!---<cfif listlen(im_cats)>
				<cfquery name="get_ims" datasource="#DSN#">
					SELECT IMCAT_ICON,IMCAT_LINK_TYPE,IMCAT_ID FROM SETUP_IM WHERE IMCAT_ID IN (#im_cats#)
				</cfquery>
				<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
			</cfif>	--->
			<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
			<cfquery name="GET_IN_OUTS" datasource="#dsn#">
				SELECT
					START_DATE,
					FINISH_DATE,
					IN_OUT_ID,
					EMPLOYEE_ID
				FROM
					EMPLOYEES_IN_OUT
				WHERE
					EMPLOYEE_ID IN (#employee_list#)
					<cfif not session.ep.ehesap>AND BRANCH_ID IN (#my_branch_list#)</cfif>
			</cfquery>
			<cfif attributes.ana_query neq 1>
				<cfquery name="GET_POSITIONS" datasource="#dsn#">
					SELECT  
						BRANCH.BRANCH_NAME,
						DEPARTMENT.DEPARTMENT_HEAD,
						EMPLOYEE_POSITIONS.EMPLOYEE_ID,
						EMPLOYEE_POSITIONS.POSITION_NAME,
						EMPLOYEE_POSITIONS.POSITION_ID,
						EMPLOYEE_POSITIONS.EMPLOYEE_ID,
						SETUP_POSITION_CAT.POSITION_CAT
					FROM
						EMPLOYEE_POSITIONS,
						DEPARTMENT,
						BRANCH,
						SETUP_POSITION_CAT
					WHERE
						SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
						EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
						EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
						EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_list#) AND
						EMPLOYEE_POSITIONS.IS_MASTER = 1
					ORDER BY
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
				</cfquery>
				<cfset main_employee_list = listsort(listdeleteduplicates(valuelist(GET_POSITIONS.EMPLOYEE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<cfquery name="GET_IN_OUT" dbtype="query" maxrows="1">
					SELECT
						START_DATE,
						FINISH_DATE
					FROM
						GET_IN_OUTS
					WHERE
						EMPLOYEE_ID = #EMPLOYEE_ID# 
					ORDER BY 
						START_DATE DESC,
						IN_OUT_ID DESC
				</cfquery>
				<tr>
					<td width="35">#currentrow#</td>
					<!-- sil --><td height="20" width="10" align="center" valign="middle"><CF_ONLINE id="#employee_id#" zone="ep"></td><!-- sil -->
					<td>#employee_no#</td>
					<!-- sil -->
					<td width="30"> 
						<cfif len(GET_HRS.photo) and len(GET_HRS.PHOTO_SERVER_ID)>
							<cf_get_server_file output_file="hr/#photo#" output_server="#PHOTO_SERVER_ID#" output_type="0" image_width="30" image_height="40" image_link="1">
						<cfelse>
							<cfif GET_HRS.sex eq 1>
								<img src="/images/male.jpg" width="30" height="40" title="<cf_get_lang_main no='1134.Yok'>">
							<cfelse>
								<img src="/images/female.jpg" width="30" height="40" title="<cf_get_lang_main no='1134.Yok'>">
							</cfif>
						</cfif>
					</td>
					<!-- sil -->
					<td <cfif len(LAST_SURNAME)>title="Kızlık Soyadı : #LAST_SURNAME#"</cfif>><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#TC_IDENTY_NO#</td>
					<cfif is_ozel_kod>
						<td style="mso-number-format:\@;">#hierarchy#</td>
					</cfif>
					<td><cfif attributes.ana_query>#branch_name#<cfelse>#GET_POSITIONS.branch_name[listfind(main_employee_list,employee_id,',')]#</cfif></td>
					<td><cfif attributes.ana_query>#department_head#<cfelse>#GET_POSITIONS.DEPARTMENT_HEAD[listfind(main_employee_list,employee_id,',')]#</cfif></td>
					<td><cfif attributes.ana_query><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" class="tableyazi">#POSITION_CAT#</a><cfelse><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#GET_POSITIONS.position_id[listfind(main_employee_list,employee_id,',')]#" class="tableyazi">#GET_POSITIONS.position_cat[listfind(main_employee_list,employee_id,',')]#</a></cfif></td>
						<cfif show_position eq 1>
					<td><cfif attributes.ana_query>#position_name#<cfelse>#GET_POSITIONS.position_name[listfind(main_employee_list,employee_id,',')]#</cfif></td>
						</cfif>
					<td>#dateformat(GROUP_STARTDATE,dateformat_style)#</td>
					<td><cfif GET_IN_OUT.RECORDCOUNT>#dateformat(GET_IN_OUT.start_date,dateformat_style)#</cfif></td>
					<td><cfif  GET_IN_OUT.RECORDCOUNT>#dateformat(GET_IN_OUT.finish_date,dateformat_style)#</cfif></td>
					<!-- sil -->
					<td align="center" nowrap>
						<cfif len(employee_email)><a href="mailto:#employee_email#"><img src="/images/mail.gif" title="#employee_email#"></a>&nbsp;</cfif>
						<cfif (len(mobilcode) and len(mobiltel)) or (len(mobilcode_spc) and len(mobiltel_spc))>
							<cfif session.ep.our_company_info.sms eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=employee&member_id=#EMPLOYEE_ID#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" title="#iif(Len(mobilcode_spc) and Len(mobiltel_spc),de('(#mobilcode_spc#) #mobiltel_spc#'),de('(#mobilcode#) #mobiltel#'))#"></a>
							<cfelse>
								<img src="/images/mobil.gif" title="#iif(Len(mobilcode_spc) and Len(mobiltel_spc),de('(#mobilcode_spc#) #mobiltel_spc#'),de('(#mobilcode#) #mobiltel#'))#">
							</cfif>
						</cfif>
						<cfif len(direct_telcode) and len(direct_tel)>
							<img src="/images/tel.gif" title="(#direct_telcode#) #direct_tel#">
						</cfif>
					</td>
					<td width="15"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi"><img src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
					<td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#GET_HRS.employee_id#&print_type=173','print_page','workcube_print');"><img src="/images/print2.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="16">
					<cfif not isdefined("filtered")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="hr.list_hr#url_str#">
<script language="javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
</script> 
