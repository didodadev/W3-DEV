<cfscript>
//	structdelete(session, "report");
</cfscript>
<cfinclude template="../query/get_query.cfm">
<cfscript>
	sql_query = get_query.report_query;
	group_bys = '';
	column_names = '';
	column_names_tr = '';
	COUNTER_ = 0;
</cfscript>
<cfloop list="#get_query.column_ids#" index="item" delimiters=",">
  <cfset attributes.column_id = item>
  <cfinclude template="../query/get_report_column.cfm">
	<cfscript>
	COUNTER_ = COUNTER_+1;
	column_names_tr = listappend(column_names_tr, '#get_report_column.nick_name_tr#.#get_report_column.column_name_tr#', ',');
	column_names = listappend(column_names, get_report_column.column_name, ',');
	if (listgetat(get_query.COLUMN_FUNCTIONS, COUNTER_, ',') eq '_')
		{
		if (get_report_column.period_year eq 1)
			group_bys = listappend(group_bys, '#dsn_alias#.#get_report_column.table_name#.#get_report_column.column_name#', ',');
		else
			group_bys = listappend(group_bys, '#dsn#_#get_report_column.period_year#.#get_report_column.table_name#.#get_report_column.column_name#', ',');
		}
	</cfscript>
</cfloop>
<cfif (listLEN(GROUP_BYS,',') neq listlen(get_query.column_ids,',')) and len(group_bys)>
  <cfset sql_query = "#sql_query# GROUP BY #group_bys#">
</cfif>

<cfquery name="query_result" datasource="#dsn2#">
#preservesinglequotes(sql_query)#
</cfquery>
<cfif query_result.recordcount>
<table height="35">
<tr>
<td class="headbold"><cfoutput>#get_report_queries.query_name#</cfoutput></td>
</tr>
</table>
<table width="98%">
	  <cfoutput query="query_result">
        <tr>
          <td height="20">#currentrow#</td>
          <cfset j = 0>
          <cfloop list="#column_names#" index="item" delimiters=",">
            <cfset j = j+1>
            <td>
              <cfif listgetat(get_query.FORMAT_TYPES,j,';') is "date">
                #dateformat(evaluate('query_result.#item#'),listgetat(get_query.FORMATS,j,';'))#
                <cfelseif listgetat(get_query.FORMAT_TYPES,j,';') is "money">
                #lsnumberformat(evaluate('query_result.#item#'),listgetat(get_query.FORMATS,j,';'))#
                <cfelse>
                #evaluate('query_result.#item#')#
              </cfif>
            </td>
          </cfloop>
        </tr>
      </cfoutput>
    </table>
</cfif>
