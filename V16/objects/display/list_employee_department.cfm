<cfsetting showdebugoutput="no">
<cfquery name="get_branch_control" datasource="#dsn#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE BRANCH_ID = #attributes.branch_id# 
</cfquery>
<cfif get_branch_control.recordcount>
	<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
			SELECT 
				0 AS TYPE,
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				'' AS LOCATION_ID,
				'' AS COMMENT
			FROM 
				DEPARTMENT D
			WHERE
				D.BRANCH_ID = #attributes.branch_id# AND
				D.IS_STORE <> 2 AND
				D.DEPARTMENT_STATUS=1
		UNION ALL
			SELECT 
				1 AS TYPE,
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				SL.LOCATION_ID,
				SL.COMMENT
			FROM 
				DEPARTMENT D,
				STOCKS_LOCATION SL
			WHERE
				SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = #attributes.branch_id# AND
				D.IS_STORE <> 2 AND
				SL.STATUS=1
		ORDER BY
			DEPARTMENT_HEAD,
			DEPARTMENT_ID,
			TYPE ASC
	</cfquery>
	<cfquery name="get_olds" datasource="#dsn#">
		SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #attributes.position_code#
	</cfquery>
	<cfif get_olds.recordcount>
		<cfset loc_list = valuelist(get_olds.LOCATION_CODE)>
	</cfif>
	<table cellpadding="2" cellspacing="1">
		<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
		<input type="hidden" name="auth_emps_pos_codes" id="auth_emps_pos_codes" value="">
		<cfoutput query="GET_DEPARTMENT">
			<cfif TYPE eq 0>
			<tr>
				<td class="formbold"><input type="checkbox" class="#attributes.branch_id#" onchange="alllocations_(#currentrow#,$(this).attr('id'));" name="department_location_#attributes.branch_id#" id="department_location_#attributes.branch_id#_#currentrow#" value="#DEPARTMENT_ID#" <cfif isdefined("loc_list") and listfindnocase(loc_list,'#DEPARTMENT_ID#')>checked</cfif>><a href="javascript://" onclick="gizleme_islemi_dept(#DEPARTMENT_ID#);" class="txtbold">#department_head# <cfif currentrow neq get_department.recordcount and department_id eq get_department.department_id[currentrow+1]>(*)</cfif></a></td>
			</tr>
			<cfelse>
			<tr id="dept_#DEPARTMENT_ID#_#LOCATION_ID#" style="display:none;">
				<td><input type="checkbox" name="department_location_#attributes.branch_id#" id="department_location_#attributes.branch_id#_#currentrow#" value="#DEPARTMENT_ID#-#LOCATION_ID#" <cfif isdefined("loc_list") and listfindnocase(loc_list,'#DEPARTMENT_ID#-#LOCATION_ID#')>checked</cfif>>#department_head# - #comment#</td>
			</tr>
			</cfif>
		</cfoutput>
		<cfif GET_DEPARTMENT.recordcount>
		<tr>
			<td colspan="2"><input type="checkbox" name="check_all_depts_<cfoutput>#attributes.branch_id#</cfoutput>" id="check_all_depts_<cfoutput>#attributes.branch_id#</cfoutput>" value="1" onclick="check_all_depts_fnc_<cfoutput>#attributes.branch_id#</cfoutput>();"> <cf_get_lang dictionary_id="33746.hepsini seç"></td>
			<td height="30"  style="text-align:right;"> <input type="button" value="<cfoutput>#getLang('','Kaydet',59031)#</cfoutput>" class="ui-wrk-btn ui-wrk-btn-success" onclick="<cfoutput>islem_yap_dept_loc('#attributes.branch_id#','#GET_DEPARTMENT.recordcount#');</cfoutput>"></td>
		</tr>
		</cfif>
	</table>
<cfelse>
	<li><cf_get_lang dictionary_id='60100.İlgili Şube Yetkilendirilmeden Depo Yetkisi Veremezsiniz'>!</li>
</cfif>
<script type="text/javascript">
	<cfif get_branch_control.recordcount>
		function alllocations_(start_row,clickedid){
			true_false=$('#' + clickedid).is(":checked");
			<cfoutput query="GET_DEPARTMENT">
				if(#currentrow# >= (start_row+1))
				{
				value='##'+'department_location_#attributes.branch_id#_#currentrow#';
				control=$(value).val().includes("-");
				if(control==false)
				return false;
				$(value).prop('checked', true_false);
				}
			</cfoutput>
		}
		function check_all_depts_fnc_<cfoutput>#attributes.branch_id#</cfoutput>()
		{
			if(document.getElementById('check_all_depts_<cfoutput>#attributes.branch_id#</cfoutput>').checked==true)
				{
				<cfoutput query="GET_DEPARTMENT">
					document.getElementById('department_location_#attributes.branch_id#_#currentrow#').checked = true;
				</cfoutput>
				}
			else
				{
				<cfoutput query="GET_DEPARTMENT">
					document.getElementById('department_location_#attributes.branch_id#_#currentrow#').checked = false;
				</cfoutput>
				}
		}
		function gizleme_islemi_dept(dept_id)
			{
				<cfoutput query="GET_DEPARTMENT">
					var type_ = '#type#';
					var department_ = '#DEPARTMENT_ID#';
					if(type_=='1' && department_==dept_id)
						{
							gizle_goster(dept_#DEPARTMENT_ID#_#LOCATION_ID#);
						}
				</cfoutput>
			}
	</cfif>
</script>
