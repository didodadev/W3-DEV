<cfscript>
	deep_level = 0;
	function get_sub_deps(HIERARCHY_DEP_ID)
		{
			SQLStr = "SELECT HIERARCHY_DEP_ID,DEPARTMENT_ID FROM DEPARTMENT WHERE HIERARCHY_DEP_ID LIKE '#HIERARCHY_DEP_ID#.%' AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1";
			query1 = CFQUERY(SQLString : SQLStr, Datasource : DSN);
			str1="";
			str_send="";
			for(s=1; s lte query1.recordcount ; s=s+1){
				str1="#HIERARCHY_DEP_ID#.#query1.DEPARTMENT_ID[s]#";  
				if(str1 eq 	query1.HIERARCHY_DEP_ID[s]){
					if(len(str_send)){
						str_send=str_send & "," & query1.HIERARCHY_DEP_ID[s];
					}else{
						str_send= query1.HIERARCHY_DEP_ID[s];
					}
				}
			}
			return str_send;
			
		}
	function writeDepRow(hier_dep_id,sub_hier_id,deep_level_,sayac)
	{
		SQLStr = "SELECT * FROM DEPARTMENT WHERE HIERARCHY_DEP_ID ='#sub_hier_id#' AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1";		
		query2 = cfquery(SQLString : SQLStr, Datasource : DSN);
		leftSpace = RepeatString('&nbsp;', deep_level_*3);
		if (sayac eq 0){
			writeoutput('#leftSpace# <a href="javascript://" onclick="windowopen(''#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#query2.DEPARTMENT_ID#'',''list'');"><img  border=0 src="/images/tree_1.gif"></a><font class="txtbold">#query2.DEPARTMENT_HEAD#</font>   <br/>');
		}else{
			leftSpace = RepeatString('&nbsp;', 3)& leftSpace;
			writeoutput('  #leftSpace#<a href="javascript://" onclick="windowopen(''#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#query2.DEPARTMENT_ID#'',''list'');"><img  border=0 src="/images/tree_3.gif"></a>&nbsp;<font class="txtbold">#query2.DEPARTMENT_HEAD#</font>   <br/>');		
		}
	}
	lst="";
	function writeDepTree(hier_dep_id,sayac)
	{
		var i = 1;
		var sub_deps = get_sub_deps(hier_dep_id);;
		deep_level = deep_level + 1;

		WriteOutput("<table ><tr><td nowrap > ");
		if(lst neq hier_dep_id){
			writeDepRow(hier_dep_id, hier_dep_id, deep_level,sayac);
		}
		for (i=1; i lte listlen(sub_deps,","); i = i+1)
			{
				writeDepRow(hier_dep_id, listgetat(sub_deps, i), deep_level,1);
				lst=listgetat(sub_deps, i);
				writeDepTree(listgetat(sub_deps, i),1);
			}
		WriteOutput("</td></tr></table>");
		deep_level = deep_level-1;
	}		
</cfscript>
<cfsetting showdebugoutput="no">
<cffunction name="get_sub_dep">
  <cfargument  name="dep_id">
  <cfquery name="GET_SUB_DEPARTMENTS" datasource="#dsn#">
  SELECT * FROM DEPARTMENT WHERE HIERARCHY_DEP_ID LIKE '#dep_id#.%' AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1
  </cfquery>
  <cfset list_val=ValueList(GET_SUB_DEPARTMENTS.DEPARTMENT_ID)>
  <cfreturn #list_val#>
</cffunction>
<cffunction name="GET_NAME">
  <cfargument  name="dep_id">
  <cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
  	SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID=#dep_id# AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1
  </cfquery>
  <cfset list_val=GET_DEPARTMENTS.DEPARTMENT_HEAD>
  <cfreturn #list_val#>
</cffunction>
<br/>
<cfset sb_dep=ArrayNew(3)>
<cfquery name="OUR_COMPANIES" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1
</cfquery>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td class="headbold" valign="top">
      <table cellspacing="0" cellpadding="0">
        <tr class="color-list">
          <td height="20" class="txtboldblue" align="center"><cf_get_lang dictionary_id='29531.Şirketler'></td>
        </tr>
        <tr>
          <td>
            <table cellspacing="0" cellpadding="0">
              <!--- table bolgeler ana--->
              <tr>
                <cfloop from="1" to="#OUR_COMPANIES.recordcount#" index="k">
                  <cfquery name="BRANCH" datasource="#dsn#">
                  	SELECT 
				  		* 
					FROM 
						BRANCH 
					WHERE 
						COMPANY_ID = #OUR_COMPANIES.COMP_ID[K]# AND 
						BRANCH_STATUS = 1 AND 
						IS_ORGANIZATION = 1
						<cfif session.ep.ehesap neq 1>AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID	FROM EMPLOYEE_POSITION_BRANCHES	WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#)</cfif>
                  </cfquery>
                  <td  valign="top" colspan="<cfoutput>#branch.Recordcount#</cfoutput>" align="center">
                    <table>
                      <tr  style="cursor:pointer;" >
                        <td align="center" height="35"> <br/>
                          <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_zone&id=#OUR_COMPANIES.COMP_ID[k]#</cfoutput>','medium');"><img src="/images/tree_1.gif" border="0" align="absmiddle"></a><b>
                          <cfif branch.Recordcount >
                          <a href="javascript://" onClick="gizle_goster(a<cfoutput>#k#</cfoutput>b);">
                          </cfif>
                          <cfoutput>#our_companies.nick_name[k]#</cfoutput>
                          <cfif branch.recordcount >
                          </a>
                          </cfif>
                          </b> </td>
                      </tr>
                      <cfif branch.Recordcount>
                      
                      <tr id="a<cfoutput>#k#</cfoutput>b" style="display:none;" >
                        <td>
                          <DIV style="Z-INDEX: 1002;  POSITION: absolute;  ">
                            <HR width="100%"  color="##000033" noShade>
                          </DIV>
                          <table cellspacing="0" cellpadding="0" >
                            <tr>
                              <cfloop from="1" to="#branch.Recordcount#" index="i">
                                <cfquery name="DEPARTMENT_ROWS" datasource="#dsn#">
                                SELECT BRANCH_ID FROM DEPARTMENT WHERE BRANCH_ID=#BRANCH.BRANCH_ID# AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1
                                </cfquery>
                                <cfif department_rows.recordcount eq 1>
                                  <cfset clspn=department_rows.recordcount+1>
                                  <cfelseif  not department_rows.recordcount >
                                  <cfset clspn=1>
                                  <cfelse>
                                  <cfset clspn=department_rows.recordcount>
                                </cfif>
                                <td  align="center"  colspan="<cfoutput>#clspn#</cfoutput>" height="35">
                                  <DIV style="Z-INDEX: 1002; WIDTH: 2px;   height=19px; BACKGROUND-COLOR: 000033; layer-background-color: red"> </DIV>
                                </td>
                              </cfloop>
                            </tr>
                            <tr> <cfoutput query="branch">
                                <cfquery name="DEPARTMENTS" datasource="#dsn#">
                                	SELECT * FROM DEPARTMENT WHERE BRANCH_ID=#BRANCH.BRANCH_ID# AND (HIERARCHY_DEP_ID = CAST(DEPARTMENT_ID AS VARCHAR) OR HIERARCHY_DEP_ID NOT LIKE '%.%') AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1
                                </cfquery>
                                <cfquery name="DEPARTMENTS_SUB" datasource="#dsn#">
                                	SELECT * FROM DEPARTMENT WHERE BRANCH_ID=#BRANCH.BRANCH_ID# AND DEPARTMENT_STATUS = 1 AND IS_ORGANIZATION = 1
                                </cfquery>
                                <cfif DEPARTMENTS_SUB.recordcount eq 1>
                                  <cfset clspn_=DEPARTMENTS_SUB.recordcount+1>
                                  <cfelseif not DEPARTMENTS_SUB.recordcount >
                                  <cfset clspn_=1>
                                  <cfelse>
                                  <cfset clspn_=DEPARTMENTS_SUB.recordcount>
                                </cfif>
                                <td   nowrap valign="top" align="center" colspan="#clspn#">
                                  <table align="center" cellspacing="0" cellpadding="0">
                                    <tr  style="cursor:pointer;"   >
                                      <td align="center" valign="top" nowrap> <br/>
                                        <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#branch.branch_ID#','medium');"> <img src="/images/tree_1.gif" border="0" align="absmiddle"></a><B>
										                    <cfif departments.recordcount>
                                        <a  onClick="gizle_goster(dep<cfoutput>#branch.branch_ID#</cfoutput>no);"  href="javascript://" >
                                        </cfif>
                                        #branch.branch_name#-
                                        <cfif departments.recordcount>
                                        </a>
                                        </cfif>
                                        </B> </td>
                                    </tr>
                                    <tr id="dep<cfoutput>#branch.branch_ID#</cfoutput>no" style="display:none;" >
                                      <td align="center">
                                        <cfif departments.recordcount>
                                          <DIV style="Z-INDEX: 1002;  POSITION: absolute;  HEIGHT: 10px">
                                            <HR width="100%" color=red noShade>
                                          </DIV>
                                          <table cellspacing="0" cellpadding="0" height="25">
                                            <tr>
                                              <cfloop from="1" to="#departments.recordcount#" index="i">
                                                <td align="center" height="35px">
                                                  <DIV  style="Z-INDEX: 1002; WIDTH: 2px;   height=19px; BACKGROUND-COLOR: red; layer-background-color: red"></DIV>
                                                </td>
                                              </cfloop>
                                            </tr>
                                            <tr>
                                              <cfloop from="1" to="#departments.recordcount#" index="i">
                                                <td align="center" valign="top" nowrap>
                                                  <table cellspacing="0" cellpadding="0" height="25">
                                                    <tr>
                                                      <td  height="100%" width="100%" nowrap>
                                                        <cfscript>
															 	                        writeDepTree(departments.HIERARCHY_DEP_ID[i],0);
														                           </cfscript>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </cfloop>
                                            </tr>
                                          </table>
                                        </cfif>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </cfoutput> 
							  </tr>
                          </table>
                        </td>
                      </tr>
                      </cfif>
                    </table>
                  </td>
                </cfloop>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
