<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (#my_branch_list#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>
<table>
	<tr>
    	<td colspan="2" class="formbold">Mağazalar</td>
    </tr>
    <cfoutput query="get_departments_search">
    <cfif currentrow mod 2 eq 1>
    	<tr>
    </cfif>
    	<td><input type="checkbox" name="p_department_id" id="p_department_id_#department_id#" value="#department_id#" <cfif isdefined("attributes.dept_list") and listfind(attributes.dept_list,department_id)>checked</cfif>/>#department_Head#</td>
    <cfif currentrow mod 2 eq 0>
   		</tr>
    </cfif>
    </cfoutput>
</table>
<input type="button" value="Gönder" onclick="send_manage_price_table();"/>
<script>
function send_manage_price_table()
{
	sayi_ = <cfoutput>#get_departments_search.recordcount#</cfoutput>;
	deger_list_ = '';
	<cfoutput query="get_departments_search">
		if(document.getElementById('p_department_id_#department_id#').checked == true)
		{
			if(deger_list_ == '')
				deger_list_ = document.getElementById('p_department_id_#department_id#').value;
			else
				deger_list_ += ',' + document.getElementById('p_department_id_#department_id#').value;
		}
	</cfoutput>
	<cfif attributes.row_id lt 0>
		<cfoutput>
		document.getElementById('head_price_departments').value = deger_list_;
		</cfoutput>
	<cfelse>
		<cfoutput>
		$('##jqxgrid').jqxGrid('setcellvalue',#attributes.row_id#,'price_departments',deger_list_);
		</cfoutput>
	</cfif>
	hide('message_div_main');
}	
</script>