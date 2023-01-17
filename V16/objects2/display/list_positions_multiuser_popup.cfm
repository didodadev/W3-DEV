<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.select_list" default="1,2,3,4,5,6">
<cfquery name="GET_BRANCHES" datasource="#DSN#">
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
		<cfif isDefined('session.pp.our_company_id')>
			OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isDefined('session.pda.our_company_id')>
			OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND		
		</cfif>
		BRANCH.BRANCH_ID IS NOT NULL AND 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
		BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
	<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
		SELECT 
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,		
			ZONE.ZONE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			OUR_COMPANY.NICK_NAME 
		FROM 
			DEPARTMENT,
			BRANCH,
			ZONE,
			EMPLOYEE_POSITIONS,
			OUR_COMPANY
		WHERE
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			DEPARTMENT.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			ZONE.ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.ZONE_ID = ZONE.ZONE_ID AND
			DEPARTMENT.ADMIN1_POSITION_CODE  = EMPLOYEE_POSITIONS.POSITION_CODE AND
			BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>	
	UNION ALL
		SELECT 
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			ZONE.ZONE_NAME,
			'' AS EMPLOYEE_NAME,
			'' AS EMPLOYEE_SURNAME,
			OUR_COMPANY.NICK_NAME 
		FROM 
			DEPARTMENT,
			BRANCH,
			ZONE,
			OUR_COMPANY
		WHERE
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			DEPARTMENT.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			ZONE.ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.ZONE_ID = ZONE.ZONE_ID AND
			DEPARTMENT.ADMIN1_POSITION_CODE IS NULL AND
			BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY
			BRANCH_NAME,
			DEPARTMENT_HEAD
	</cfquery>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfif isdefined("attributes.form_submit")>
	<cfset attributes.company_id = session_base.our_company_id>
	<cfinclude template="../../objects/query/get_positions.cfm">
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">	
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
		<cfif isdefined("attributes.to_title") and len(attributes.to_title)>
			to_title = <cfoutput>#attributes.to_title#</cfoutput>;
		<cfelse>
			to_title=1;
		</cfif>
		<cfif isdefined("attributes.row_count")>
			rowCount = parseInt(window.opener.document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value);
		</cfif>
		function add_checked()
		{
			var counter = 0;
			<cfif get_positions.recordcount gt 1 and attributes.maxrows neq 1>
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
						return false;
					}
			<cfelseif get_positions.recordcount eq 1 or attributes.maxrows eq 1>
				if (document.getElementById('emp_ids').checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
					return false;
				}
			</cfif>

			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_emp_id")  and attributes.maxrows neq 1>
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++)
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
						var emp_ids = document.form_name.emp_ids[i].value;
						var pos_id = document.form_name.position_id[i].value;
						if (to_title ==1 )
							var name = document.form_name.employee_name[i].value+' '+document.form_name.employee_surname[i].value;
						else
							var name = document.form_name.position_name[i].value;
						var pos_code =document.form_name.position_code[i].value;
						<cfif isDefined('attributes.row_count')>
							rowCount = rowCount + 1;					
						</cfif>
						var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);
					}
				<cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif>
				<cfif isDefined('attributes.row_count')>
					window.opener.document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;	
				</cfif>
			<cfelseif (get_positions.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_emp_id")>	
				var emp_ids = document.getElementById('emp_ids').value;
				var pos_id = document.getElementById('position_id').value;
				if (to_title == 1)
					var name = document.getElementById('employee_name').value + ' ' + document.getElementById('employee_surname').value;
				else
					var name = document.getElementById('position_name').value;
				rowCount = rowCount + 1;
				var pos_code = document.getElementById('position_code').value;
				var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);			
				window.opener.document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;
				<cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif>
			</cfif>
			<cfif isDefined("attributes.url_direction")>
				<cfoutput>
				document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&'+document.getElementById('url_string').value;
				</cfoutput>
				document.form_name.submit();
			<cfelse>
				/*window.close();*/
			</cfif>
		}
		
		<cfif isdefined("attributes.table_name")>
			function ekle_str(str_ekle,int_id,int_id2,int_id3)
			{
				var newRow;
				var newCell;
				<cfoutput>
					newRow =window.opener.document.getElementById("#attributes.table_name#").insertRow();	
					newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
					newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
					newRow.setAttribute("style","display:''");	
					newCell = newRow.insertCell();
					str_html = '';
					<cfif isdefined("attributes.field_emp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_emp_id#" id="#attributes.field_emp_id#" value="' + int_id + '"><input type="hidden" name="#attributes.field_pos_id#" value="' + int_id2 + '">';	
						str_html = str_html + '<input type="hidden" name="#attributes.field_pos_code#" id="#attributes.field_pos_code#" value="' + int_id3 + '">';	
					</cfif>
					<cfif isdefined("attributes.field_comp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_comp_id#" id="#attributes.field_comp_id#" value=""><input type="hidden" name="#attributes.field_par_id#" value="">';
					</cfif>
					<cfif isdefined("attributes.field_cons_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_cons_id#" id="#attributes.field_cons_id#" value="">';
					</cfif>
					str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" value="">';
					str_del = '<a href="javascript://"  onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><img src="/images/delete_list.gif" align="absmiddle" border="0"></a>&nbsp;';
					newCell.innerHTML = str_del + str_html + str_ekle  ;
				</cfoutput>
				return 1;
			 }
			 //sadece safari için kullanılır...
			 function id_ekle()
			 {
				<cfoutput>
					 if('#attributes.function_row_name#'=='workcube_cc_delRow')
					 {
						if(window.opener.document.all.cc_emp_ids.length==undefined)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc_emp_ids"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc_pos_codes"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc_pos_ids"));
						}
						else
						{
							for(var i=0;i<window.opener.document.all.cc_emp_ids.length;i++)
							{
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc_emp_ids[i]);
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc_pos_codes[i]);
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc_pos_ids[i]);
							}
						}
					}
					else if('#attributes.function_row_name#'=='workcube_cc2_delRow')
					{
						if(window.opener.document.all.cc2_emp_ids.length==undefined)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc2_emp_ids"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc2_pos_codes"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc2_pos_ids"));
						}
						else
						{
							for(var i=0;i<window.opener.document.all.cc2_emp_ids.length;i++)
							{
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc2_emp_ids[i]);
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc2_pos_codes[i]);
								window.opener.document.upd_work.appendChild(window.opener.document.all.cc2_pos_ids[i]);
							}
						}
					}
					else
					{
						if(window.opener.document.all.to_emp_ids.length==undefined)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("to_emp_ids"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("to_pos_codes"));
							window.opener.document.upd_work.appendChild(window.opener.document.getElementById("to_pos_ids"));
						}
						else
						{
							for(var i=0;i<window.opener.document.all.to_emp_ids.length;i++)
								{
									window.opener.document.upd_work.appendChild(window.opener.document.all.to_emp_ids[i]);
									window.opener.document.upd_work.appendChild(window.opener.document.all.to_pos_codes[i]);
									window.opener.document.upd_work.appendChild(window.opener.document.all.to_pos_ids[i]);
								}
							}
					}
				</cfoutput>
			}
		</cfif>
	</script>
</cfif>

<cfset url_string = ''>
<cfif IsDefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_string = '#url_string#&company_id=#attributes.company_id#'>
</cfif>
<cfif len(attributes.branch_id)>
	<cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
</cfif>
<cfif len(attributes.department)>
	<cfset url_string = '#url_string#&department=#attributes.department#'>
</cfif>
<cfif len(attributes.select_list)>
	<cfset url_string = '#url_string#&select_list=#attributes.select_list#'>
</cfif>
<cfif isDefined('attributes.field_emp_id') and len(attributes.field_emp_id)>
	<cfset url_string = '#url_string#&field_emp_id=#attributes.field_emp_id#'>
</cfif>
<cfif isDefined('attributes.field_pos_id') and len(attributes.field_pos_id)>
	<cfset url_string = '#url_string#&field_pos_id=#attributes.field_pos_id#'>
</cfif>
<cfif isDefined('attributes.field_pos_code') and len(attributes.field_pos_code)>
	<cfset url_string = '#url_string#&field_pos_code=#attributes.field_pos_code#'>
</cfif>
<cfif isDefined('attributes.field_par_id') and len(attributes.field_par_id)>
	<cfset url_string = '#url_string#&field_par_id=#attributes.field_par_id#'>
</cfif>
<cfif isDefined('attributes.field_company_id') and len(attributes.field_company_id)>
	<cfset url_string = '#url_string#&field_company_id=#attributes.field_company_id#'>
</cfif>
<cfif isDefined('attributes.field_cons_id') and len(attributes.field_cons_id)>
	<cfset url_string = '#url_string#&field_cons_id=#attributes.field_cons_id#'>
</cfif>
<cfif isDefined('attributes.table_name') and len(attributes.table_name)>
	<cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
</cfif>
<cfif isDefined('attributes.table_row_name') and len(attributes.table_row_name)>
	<cfset url_string = '#url_string#&table_row_name=#attributes.table_row_name#'>
</cfif>
<cfif isDefined('attributes.field_grp_id') and len(attributes.field_grp_id)>
	<cfset url_string = '#url_string#&field_grp_id=#attributes.field_grp_id#'>
</cfif>
<cfif isdefined('attributes.field_wgrp_id') and len(attributes.field_wgrp_id)>
	<cfset url_string = '#url_string#&field_wgrp_id=#attributes.field_wgrp_id#'>
</cfif>
<cfif isdefined('attributes.function_row_name') and len(attributes.function_row_name)>
	<cfset url_string = '#url_string#&function_row_name=#attributes.function_row_name#'>
</cfif>
<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfset url_string = '#url_string#&row_count=#attributes.row_count#'>
</cfif>
<cfif isdefined('attributes.url_direction') and len(attributes.url_direction)>
	<cfset url_string = '#url_string#&url_direction=#attributes.url_direction#'>
</cfif>
<cfif ListFind(attributes.select_list,9) and isDefined('session.pp.userid')>
	<cfset url_string = '#url_string#&comp_id_list=#session.pp.company_id#'>
    <cfset url_string = '#url_string#&related_comp_id=1'>
</cfif> 
<!-- sil -->
<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:100%">
	<tr class="color-row">
		<cfoutput>
            <td>&nbsp;</td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=A">A</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=B">B</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=C">C</a></td>
         	<td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ç">Ç</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=D">D</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=E">E</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=F">F</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=G">G</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ğ">Ğ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=H">H</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=I">I</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=İ">İ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=J">J</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=K">K</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=L">L</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=M">M</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=N">N</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=O">O</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ö">Ö</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=P">P</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Q">Q</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=R">R</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=S">S</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ş">Ş</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=T">T</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=U">U</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ü">Ü</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=V">V</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=W">W</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Y">Y</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
		</cfoutput>
	</tr>
</table>
<cfform name="search" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
    <table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">
                <cfoutput>
                    <select name="categories" id="categories" onchange="location.href=this.value;">
						<cfif ListFind(attributes.select_list,1)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_positions_multiuser'>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,2)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>>C. <cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,3)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_cons_multiuser'>selected</cfif>>C. <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,4)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_grps_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_grps_multiuser'>selected</cfif>><cf_get_lang no='326.Gruplar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,5)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_cons_multiuser'>selected</cfif>>P <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,6)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_pars_multiuser'>selected</cfif>>P <cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,7)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_pars_multiuser'>selected</cfif>><cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,8)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_cons_multiuser'>selected</cfif>><cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,9)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>><cf_get_lang no='281.Kurumsal Üyemin Çalışanları'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,10)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_pars_multiuser'>selected</cfif>>Kurumsal Üyelerim</option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,11)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_cons_multiuser'>selected</cfif>>Bireysel Üyelerim</option>
                        </cfif>
                    </select>
                </cfoutput>
            </td>
            <td class="headbold">			
                <table align="right">
                    <input type="hidden" name="form_submit" id="form_submit" value="1">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" style="width:80px;"></td>
                        <td><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
                        <td>
                            <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_position_cats">
                                    <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>

<!-- sil -->
<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%">	
	<tr class="color-header" style="height:22px;">
		<th class="form-title"></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='158.Ad Soyad'></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='1085.Pozisyon'></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='377.Özel Kod'></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='580.Bölge'></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='41.Şube'></th>
		<th class="form-title" style="width:15%;"><cf_get_lang_main no='160.Departman'></th>
		<th class="form-title" style="width:3%;"><cfif get_positions.recordcount><input type="Checkbox" name="all_" id="all_" value="1" onclick="javascript: hepsi();"></cfif></td>
	</tr>
	<form action="" method="post" name="form_name">
		<cfif get_positions.recordcount>
            <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td align="center" style="width:25px;"><cf_online id="#employee_id#" zone="ep"></td>
                    <td>#employee_name# #employee_surname#</td>
                    <td>#position_name#</td>
                    <td>#ozel_kod#</td>
                    <td>#zone_name#</td>
                    <td>#branch_name#</td>
                    <td>#department_head#</td>
                    <td>
                        <input type="checkbox" name="emp_ids" id="emp_ids" value="#employee_id#">
                        <input type="hidden" name="employee_name" id="employee_name" value="#employee_name#">
                        <input type="hidden" name="employee_surname" id="employee_surname" value="#employee_surname#">
                        <input type="hidden" name="employee_email" id="employee_email" value="#employee_email#">
                        <input type="hidden" name="position_id" id="position_id" value="#position_id#">
                        <input type="hidden" name="position_name" id="position_name" value="#position_name#">
                        <input type="hidden" name="position_code" id="position_code" value="#position_code#">
                        <input type="hidden" name="branch_name" id="branch_name" value="#branch_name#">
                        <input type="hidden" name="department_head" id="department_head" value="#department_head#">
                    </td>
                </tr>
            </cfoutput>
            <tr class="color-list">
                <td style="text-align:right;" colspan="8"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onclick="add_checked();"></td>
            </tr>
        <cfelse>
            <tr class="color-row">
                <td colspan="8" align="left"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
            </tr>
        </cfif>
        <input type="hidden" name="record_type" id="record_type" value="employee">
	</form>
</table>

<cfif len(attributes.keyword)>
	<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_string = '#url_string#&position_cat_id=#attributes.position_cat_id#'>
</cfif>

<cfif attributes.totalrecords gt attributes.maxrows>
	<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px;">
		<tr>
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##url_string#&form_submit=1"></td>
			<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.form_submit")>
		function hepsi()
		{
			if (document.getElementById('all_').checked)
			{
				<cfif get_positions.recordcount gt 1 and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = true;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.getElementById('emp_ids').checked = true;
				</cfif>
			}
			else
			{
				<cfif get_positions.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = false;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.getElementById('emp_ids').checked = false;
				</cfif>
			}
		}
	</cfif>

	document.getElementById('keyword').focus();
</script>
