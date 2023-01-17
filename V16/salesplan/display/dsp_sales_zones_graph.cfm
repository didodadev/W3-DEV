<cfscript>
	deep_level = 0;
	
	function get_sub_deps(HIERARCHY_DEP_ID)
		{
			SQLStr = "SELECT SZ_HIERARCHY,SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY LIKE '#HIERARCHY_DEP_ID#.%'";
			query1 = CFQUERY(SQLString : SQLStr, Datasource : DSN);
			str1="";
			str_send="";
			for(s=1; s lte query1.recordcount ; s=s+1){
				str1="#SZ_HIERARCHY#.#query1.SZ_ID[s]#";  
				if(str1 eq 	query1.SZ_HIERARCHY[s]){
					if(len(str_send)){
						str_send=str_send & "," & query1.SZ_HIERARCHY[s];
					}else{
						str_send= query1.SZ_HIERARCHY[s];
					}
				}
			}
			return str_send;
			
		}
	function writeDepRow(hier_dep_id,sub_hier_id,deep_level_,sayac)
	{
		SQLStr = "SELECT * FROM SALES_ZONES WHERE SZ_HIERARCHY ='#sub_hier_id#'";		
		query2 = cfquery(SQLString : SQLStr, Datasource : DSN);
		leftSpace = RepeatString('&nbsp;', deep_level_*3);
		if (sayac eq 0){
			writeoutput('#leftSpace# <a href="#request.self#?fuseaction=salesplan.form_upd_sales_zone&sz_id=#query2.SZ_ID#" target="_top"><img  border=0 src="/images/tree_1.gif"></a><font class="txtbold">#query2.SZ_NAME#</font><br/>');
		}else{
			leftSpace = RepeatString('&nbsp;', 3)& leftSpace;
			writeoutput('#leftSpace# <a href="#request.self#?fuseaction=salesplan.form_upd_sales_zone&sz_id=#query2.SZ_ID#" target="_top"><img  border=0 src="/images/tree_3.gif"></a>&nbsp;<font class="txtbold">#query2.SZ_NAME#</font><br/>');		
		}
	}
	
	lst="";
	function writeDepTree(hier_dep_id,sayac)
	{
		var i = 1;
		var sub_deps = get_sub_deps(hier_dep_id);;
		deep_level = deep_level + 1;

		WriteOutput("<table><tr><td nowrap > ");
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
<br/>
<cfquery name="ZONES" datasource="#DSN#">
	SELECT SZ_ID, SZ_NAME, SZ_HIERARCHY, SZ_HIERARCHY FROM SALES_ZONES WHERE SZ_HIERARCHY = ( SELECT MIN(SZ_HIERARCHY) FROM SALES_ZONES)
</cfquery>
<table class="dph">
	<tr>
	  <td class="dpht"><cf_get_lang_main no='355.Satış Bölgeleri'></td>
	</tr>
</table>
<table cellspacing="0" cellpadding="0" width="99%">
	<!--- table bolgeler ana--->
    <tr>
        <cfloop from="1" to="#zones.recordcount#" index="k">
            <cfquery name="BRANCH" datasource="#dsn#">
            SELECT * FROM SALES_ZONES WHERE SZ_ID <> #ZONES.SZ_ID[K]# AND SZ_HIERARCHY LIKE '#ZONES.SZ_HIERARCHY#%'
            </cfquery>
            <td  valign="top" colspan="<cfoutput>#branch.Recordcount#</cfoutput>" align="center">
                <table width="100%" align="center">
                    <tr  style="cursor:pointer;">
                        <td align="center" height="35">
                            <a href="<cfoutput>#request.self#?fuseaction=salesplan.form_upd_sales_zone&sz_id=#zones.SZ_ID[k]#</cfoutput>" target="_top"><img src="/images/tree_1.gif" border="0" align="absmiddle"></a>
                            <b>
                                <cfif branch.Recordcount><a href="javascript://" onClick="gizle_goster(a<cfoutput>#k#</cfoutput>b);"></cfif>
                                    <cfoutput>#zones.SZ_NAME[k]#</cfoutput>
                                <cfif branch.Recordcount></a></cfif>
                            </b>
                        </td>
                    </tr>
                    <cfif branch.Recordcount>
                        <tr id="a<cfoutput>#k#</cfoutput>b" style="display:none;">
                            <td>
                                <div style="border:1px solid #CCC;"></div>
                                <table cellspacing="0" cellpadding="0">
                                    <tr>
                                        <cfloop from="1" to="#branch.Recordcount#" index="i">
                                            <cfquery name="DEPARTMENT_ROWS" datasource="#dsn#">
                                                SELECT * FROM SALES_ZONES WHERE SZ_ID <> #BRANCH.SZ_ID# AND SZ_HIERARCHY LIKE '#BRANCH.SZ_HIERARCHY#%'
                                            </cfquery>
                                            <cfif department_rows.recordcount eq 1>
                                                <cfset clspn=department_rows.recordcount+1>
                                            <cfelseif  not department_rows.recordcount >
                                                <cfset clspn=1>
                                            <cfelse>
                                                <cfset clspn=department_rows.recordcount>
                                            </cfif>
                                            <td  align="center" colspan="<cfoutput>#clspn#</cfoutput>" height="35">
                                            <div style="border:1px solid #CCC;"></div>
                                            </td>
                                        </cfloop>
                                    </tr>
                                    <tr>
                                        <cfoutput query="branch">
                                            <cfquery name="DEPARTMENTS" datasource="#dsn#">
                                                SELECT * FROM SALES_ZONES WHERE SZ_ID<>#BRANCH.SZ_ID# AND SZ_HIERARCHY LIKE '#BRANCH.SZ_HIERARCHY#%'
                                            </cfquery>
                                            <cfquery name="DEPARTMENTS_SUB" datasource="#dsn#">
                                            SELECT * FROM SALES_ZONES WHERE SZ_ID<>#BRANCH.SZ_ID# AND SZ_HIERARCHY LIKE '#BRANCH.SZ_HIERARCHY#%'
                                            </cfquery>
                                            <cfif departments_sub.recordcount eq 1>
                                                <cfset clspn_ = departments_sub.recordcount+1>
                                            <cfelseif not departments_sub.recordcount >
                                                <cfset clspn_ = 1>
                                            <cfelse>
                                                <cfset clspn_ = departments_sub.recordcount>
                                            </cfif>
                                            <td nowrap valign="top" align="center" colspan="#clspn#">
                                                <table align="center" cellspacing="0" cellpadding="0">
                                                    <tr  style="cursor:pointer;">
                                                        <td align="center" valign="top" nowrap><br/>
                                                            <a href="#request.self#?fuseaction=salesplan.form_upd_sales_zone&sz_id=#BRANCH.SZ_ID#" target="_top"> <img src="/images/tree_1.gif" border="0" align="absmiddle"></a>
                                                            <b>
                                                                <cfif departments.recordcount><a  onClick="gizle_goster(dep<cfoutput>#branch.sz_id#</cfoutput>no);"  href="javascript://" ></cfif>
                                                                    #branch.sz_name#
                                                                <cfif departments.recordcount>
                                                                    </a>
                                                                </cfif>
                                                            </b>
                                                        </td>
                                                    </tr>
                                                    <tr  id="dep<cfoutput>#branch.sz_id#</cfoutput>no" style="display:none;">
                                                        <td align="center">
                                                            <cfif departments.recordcount>
                                                                <div style="border:1px solid ##CCC;"></div>
                                                                <table cellspacing="0" cellpadding="0" height="25">
                                                                    <tr>
                                                                        <cfloop from="1" to="#departments.recordcount#" index="i">
                                                                            <td align="center" height="35px">
                                                                            	<div style="border:1px solid ##CCC;"></div>
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
                                                                                            writeDepTree(departments.SZ_HIERARCHY[i],0);
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

