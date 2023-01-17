<cfsetting showdebugoutput="no">
<cfquery name="GET_ALL_ZONES" datasource="#dsn#">
	SELECT ZONE_NAME,ZONE_ID FROM ZONE WHERE IS_ORGANIZATION = 1 ORDER BY ZONE_NAME
</cfquery>
<cfquery name="GET_ALL_BRANCHES" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,ZONE_ID FROM BRANCH WHERE IS_ORGANIZATION = 1
</cfquery>
<cfquery name="GET_ALL_DEPARTMENT" datasource="#dsn#">
	SELECT CAST(DEPARTMENT_ID AS NVARCHAR(10)) AS DEPARTMENT_ID2,DEPARTMENT_ID,BRANCH_ID,DEPARTMENT_HEAD,HIERARCHY_DEP_ID FROM DEPARTMENT WHERE IS_ORGANIZATION = 1
</cfquery>
<table align="center" cellpadding="5" cellspacing="5" width="100%">
    <tr>
        <td class="headbold" valign="top">
            <a href="javascript://" onclick="gizle_goster_image('list_address_img3','list_address_img4','bolgeler');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_address_img4" style="display:;cursor:pointer;"></a>
            <a href="javascript://" onclick="gizle_goster_image('list_address_img3','list_address_img4','bolgeler');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_address_img3" style="display:none;cursor:pointer;"></a>
            <cf_get_lang dictionary_id ='33777.Bölgeler'>
        </td>
    </tr>
	<tr id="bolgeler" style="display:none;">
        <td valign="top">
            <ul style="list-style:none; padding:0; margin-left:-10px; float:left; vertical-align:top">
                <table width="95%">
        			<thead>
            			<tr>
							<cfloop query="get_all_zones">
                                <cfquery name="get_zone_branches" dbtype="query">
                                        SELECT * FROM GET_ALL_BRANCHES WHERE zone_id = #get_all_zones.zone_id#
                                </cfquery>
                                <th valign="top" nowrap="nowrap">
                                    <li style="float:left; width:auto; padding:3px; font-weight:bold;">
                                        <div style="width:300px;"><img src="/images/org_zone.gif" title="<cf_get_lang dictionary_id='57992.Bölge'>" align="absmiddle">&nbsp;<cfoutput><cfif get_zone_branches.recordcount><a href="javascript://" onclick="gizle_goster(branches_#get_all_zones.zone_id#);">#left(zone_name,40)#</a><cfelse><span style="color:##999;">#left(zone_name,40)#</span></cfif></cfoutput></div>
                                        <cfif get_zone_branches.recordcount>
                                            <table cellpadding="0" cellspacing="0" id="<cfoutput>branches_#get_all_zones.zone_id#</cfoutput>" style="display:none;">
                                                <cfloop query="get_zone_branches">
                                                    <cfquery name="get_branch_departments_ilk" dbtype="query">
                                                        SELECT * FROM get_all_department WHERE BRANCH_ID = #get_zone_branches.BRANCH_ID# AND HIERARCHY_DEP_ID = DEPARTMENT_ID2 ORDER BY DEPARTMENT_HEAD
                                                    </cfquery>
                                                    <tr>
                                                        <td width="10"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#get_zone_branches.BRANCH_ID#','medium');"><img src="/images/org_branch.gif" border="0" title="<cf_get_lang dictionary_id ='57453.Şube'>"></a></cfoutput></td>
                                                        <td nowrap><cfoutput><cfif get_branch_departments_ilk.recordcount><a href="javascript://" onclick="gizle_goster(department_#get_zone_branches.BRANCH_ID#);">#get_zone_branches.branch_name#</a><cfelse>#get_zone_branches.branch_name#</cfif></cfoutput></td>
                                                    </tr>
                                                    <cfif get_branch_departments_ilk.recordcount>
                                                        <tr id="<cfoutput>department_#get_zone_branches.BRANCH_ID#</cfoutput>" style="display:none;">
                                                            <td></td>
                                                            <td>
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <cfoutput query="get_branch_departments_ilk">
                                                                        <cfquery name="get_branch_departments" dbtype="query">
                                                                            SELECT * FROM get_all_department WHERE BRANCH_ID = #get_branch_departments_ilk.BRANCH_ID# AND HIERARCHY_DEP_ID IS NOT NULL AND HIERARCHY_DEP_ID LIKE '#get_branch_departments_ilk.DEPARTMENT_ID#.%'  ORDER BY HIERARCHY_DEP_ID
                                                                        </cfquery>
                                                                        <tr>
                                                                            <td nowrap valign="top"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#DEPARTMENT_ID#&is_organization=1','list');"><img src="/images/org_department.gif" title="<cf_get_lang dictionary_id ='57572.Departman'>" border="0" align="absmiddle"></a> #department_head#</td>
                                                                        </tr>
                                                                        <cfloop query="get_branch_departments">
                                                                            <tr>
                                                                                <td nowrap valign="top"><cfloop from="1" to="#listlen(get_branch_departments.HIERARCHY_DEP_ID,'.')-1#" index="i">&nbsp;&nbsp;</cfloop><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#get_branch_departments.DEPARTMENT_ID#&is_organization=1','list');"><img src="/images/org_department.gif" title="<cf_get_lang dictionary_id ='57572.Departman'>" border="0" align="absmiddle"></a> #get_branch_departments.department_head#</td>
                                                                            </tr>
                                                                        </cfloop>
                                                                    </cfoutput>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </cfif>
                                                </cfloop>
                                            </table>
                                        </cfif>
                                    </li>
                                  </th>
                            </cfloop>     
                        </tr>
                    </thead>    
                </table>
            </ul>
        </td>
	</tr>
</table>
