<cfquery name="get_all_workgroup_roles" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		WORKGROUP_EMP_PAR.* 
	FROM 
		EMPLOYEES, 
		WORKGROUP_EMP_PAR 
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID
		AND WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.WORKGROUP_ID#
		AND WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL
		AND WORKGROUP_EMP_PAR.IS_ORG_VIEW = 1
	UNION ALL
	SELECT 
		'' AS EMPLOYEE_ID,
		'' AS EMPLOYEE_NAME,
		'' AS EMPLOYEE_SURNAME,
		WORKGROUP_EMP_PAR.* 
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.WORKGROUP_ID# AND 
		WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NULL AND
		WORKGROUP_EMP_PAR.PARTNER_ID IS NULL AND
		WORKGROUP_EMP_PAR.POSITION_CODE IS NULL
		AND WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL
		AND WORKGROUP_EMP_PAR.IS_ORG_VIEW = 1
	ORDER BY WORKGROUP_EMP_PAR.HIERARCHY
</cfquery>
<cfset hierarchy_point_count = 2>
<cfset hierarchy_2_list = ''>

<cfloop query="get_all_workgroup_roles">
	<cfset my_point_count = listlen(get_all_workgroup_roles.hierarchy,'.')>
	<cfif my_point_count gt hierarchy_point_count>
		<cfset hierarchy_point_count = my_point_count>
	</cfif>
	<cfif not isdefined("hierarchy_#my_point_count#_list")>
		<cfset 'hierarchy_#my_point_count#_list' = ''>
	</cfif>
	<cfset 'hierarchy_#my_point_count#_list' = listappend(evaluate("hierarchy_#my_point_count#_list"),WRK_ROW_ID,',')>
</cfloop>

<cfloop from="2" to="#hierarchy_point_count#" index="i">
	<cfset deger = evaluate("hierarchy_#i#_list")>
	<cfoutput>____#deger#<br/></cfoutput>
</cfloop>


<cfquery name="get_my_workgroup" datasource="#dsn#">
	SELECT * FROM WORK_GROUP WHERE WORKGROUP_ID = #attributes.WORKGROUP_ID# AND IS_ORG_VIEW = 1
</cfquery>

<cfquery name="get_my_workgroup_roles" dbtype="query">
	SELECT * FROM get_all_workgroup_roles WHERE WORKGROUP_ID = #attributes.WORKGROUP_ID# ORDER BY HIERARCHY
</cfquery>
<table align="center" cellpadding="0" cellspacing="0" id="ana_tablo">
	<tr>
		<td align="center" colspan="<cfoutput>#listlen(hierarchy_2_list)#</cfoutput>">
				<table cellpadding="0" cellspacing="0" width="200" height="50">
					<tr>
						<td class="headbold" align="center" style="border: 1px solid #666666;">
							<cfoutput>#get_my_workgroup.WORKGROUP_NAME#
							<cfif len(get_my_workgroup.manager_position_code)><font class="formbold"><br/>#get_emp_info(get_my_workgroup.manager_position_code,1,0)#</cfif></font></cfoutput>
						</td>
					</tr>
				</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="<cfoutput>#listlen(hierarchy_2_list)#</cfoutput>"><img src="/images/cizgi_dik_1pix.gif"></td>
	</tr>
	<tr>
		<td height="1" colspan="<cfoutput>#(listlen(hierarchy_2_list))#</cfoutput>"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="1" id="yatay_cizgi"></td>
	</tr>
	<tr>
		<cfloop from="1" to="#listlen(hierarchy_2_list)#" index="j"><td align="center"><img src="/images/cizgi_dik_1pix.gif"></td></cfloop>
	</tr>
	<tr>
		<cfloop from="1" to="#listlen(hierarchy_2_list)#" index="j">
			<cfset my_son_hie = 2>
			<td align="center" valign="top">
				<cfquery name="get_group_bilgi" dbtype="query">
					SELECT * FROM get_all_workgroup_roles WHERE WRK_ROW_ID = #listgetat(hierarchy_2_list,j,',')#
				</cfquery>
				<cfoutput>
				<table cellpadding="0" cellspacing="0">
					<tr>
						<td align="center" style="border: 1px solid ##666666;" width="250">
							<table>
								<tr align="center">
									<td class="txtbold">#get_group_bilgi.ROLE_HEAD#&nbsp;<cfif get_group_bilgi.is_real eq 0>(V.)</cfif></td>
								</tr>
								<tr align="center">
									<td>#get_group_bilgi.EMPLOYEE_NAME# #get_group_bilgi.EMPLOYEE_SURNAME#&nbsp;</td>
								</tr>
								<tr>
									<td>#get_group_bilgi.hierarchy#</td>
								</tr>
							</table>
						</td>
					</tr>
					<cfquery name="get_kademe_bilgi" dbtype="query">
						SELECT * FROM get_all_workgroup_roles WHERE HIERARCHY LIKE '#get_group_bilgi.hierarchy#.%'
					</cfquery>
					<cfif (my_son_hie lt hierarchy_point_count) and get_kademe_bilgi.recordcount>
					<tr>
						<td>
						<cfloop from="#my_son_hie+1#" to="#hierarchy_point_count#" index="k">
							&nbsp;as das -------#my_son_hie+1#/// #hierarchy_point_count# <br/>
						</cfloop>
						</td>
					</tr>
					</cfif>
				</table>
				</cfoutput>
			</td>
		</cfloop>
	</tr>
</table>
