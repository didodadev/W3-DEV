<cfquery name="STORE_EXPENSE_TYPE" datasource="#dsn#">
	SELECT 
        EXPENSE_TYPE_ID, 
        #dsn#.Get_Dynamic_Language(EXPENSE_TYPE_ID,'#session.ep.language#','STORE_EXPENSE_TYPE','EXPENSE_TYPE',NULL,NULL,EXPENSE_TYPE) AS EXPENSE_TYPE,
        EXPENSE_TYPE_DETAIL, 
        ACCOUNT_CODE, 
        RECORD_DATE, 
        RECORD_IP,
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
        STORE_EXPENSE_TYPE 
    ORDER BY
        EXPENSE_TYPE
</cfquery>
<table>
    <cfif STORE_EXPENSE_TYPE.recordcount>
		<cfoutput query="STORE_EXPENSE_TYPE">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_store_expense_type&expense_type_id=#expense_type_id#" class="tableyazi">#expense_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>

