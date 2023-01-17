<cfquery name="get_contract" datasource="#DSN#">
	SELECT
		TOP 5
		EC.*,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_CONTRACT EC,
		EMPLOYEES E
	WHERE
		EC.RECORD_EMP = E.EMPLOYEE_ID AND
		EC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		CONTRACT_ID DESC
</cfquery>
<cf_ajax_list>
    <tbody>
    <cfif get_contract.recordcount>
        <cfoutput query="get_contract">		
            <tr>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_upd_employee_contract&cont_id=#CONTRACT_ID#','list')" class="tableyazi">#CONTRACT_NO#</a></td>
                <td>#dateformat(contract_date,dateformat_style)#</td>
                <td>#dateformat(contract_finishdate,dateformat_style)#</td>
                <td style="width:15px;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_upd_employee_contract&cont_id=#CONTRACT_ID#','list')" class="tableyazi"><img src="../images/update_list.gif" align="absmiddle" border="0" /></a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
    </tbody>		
</cf_ajax_list>
