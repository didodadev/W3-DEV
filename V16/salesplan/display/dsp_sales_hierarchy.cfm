<cfinclude template="../query/get_sales_zone.cfm">
<cfquery name="GET_SALES_SUB_ZONE" datasource="#DSN#">
	SELECT 
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		IS_ACTIVE,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES,
		BRANCH B
	WHERE 
		SZ_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND 
		SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_zone.sz_hierarchy#.%"> AND
		B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID
</cfquery>
<!---ListCompare fonksiyonumuz zaten var ektsra buna gerek yok--->
<!--- 
<cfscript>
function ListCompare(List1, List2)
{
  var TempList = "";
  var j = 0;
  for (j=1; j lte ListLen(List1); j=j+1) {
	if (not ListFindNoCase(List2, ListGetAt(List1, j))){
	 TempList = ListAppend(TempList, ListGetAt(List1, j));
	}
  }
  return TempList;
}
</cfscript> --->
<cf_ajax_list>  
    <tbody>
		<cfif get_sales_sub_zone.recordcount>
			<cfoutput query="get_sales_sub_zone">
				<cfif (listlen(ListCompare(replace(get_sales_sub_zone.sz_hierarchy, '.', ',', 'all'),replace(get_sales_zone.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
                    <tr>
                    	<td valign="top"><a href="#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#sz_id#" class="tableyazi">#sz_name# / #branch_name#</a></td>
                    </tr>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr>
            	<td valign="top"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>