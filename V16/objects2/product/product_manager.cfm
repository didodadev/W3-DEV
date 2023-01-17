<cfquery name="GET_CAT_MANAGER" datasource="#DSN3#">
	SELECT POSITION_CODE FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_catid#">
</cfquery>
<cfif isdefined("get_product.product_manager") and len(get_product.product_manager)>
<cfset attributes.position_code = get_product.product_manager>
	<cfquery name="GET_PRODUCT_MANAGER" datasource="#DSN#">
		SELECT 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID, 
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.EMPLOYEE_EMAIL
		FROM
			EMPLOYEES,
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
			AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
	</cfquery>
<cfelseif len(get_cat_manager.position_code)>
	<cfquery name="GET_PRODUCT_MANAGER" datasource="#DSN#">
		SELECT 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID, 
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.EMPLOYEE_EMAIL
		FROM
			EMPLOYEES,
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
			AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cat_manager.position_code#">
	</cfquery>
</cfif>
<cfif isdefined("get_product_manager.recordcount") and get_product_manager.recordcount>		
	<cfoutput>
        <table>
            <tr>
                <td colspan="4"><hr style="height:0.2px;" color="CCCCCC"></td>
            </tr>
            <tr>
                <td class="txtbold" style="width:125px;"><cf_get_lang_main no='1036.Ürün Sorumlusu'></td>
                <td>
                    <cfif isdefined("session.pp.userid") AND get_workcube_app_user(get_product_manager.employee_id, 0).recordcount>
                      <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#get_product_manager.employee_id#','small');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang_main no='1899.Mesaj Gönder'>"></a>
                    <cfelse>
                      <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_nott&public=1&employee_id=#get_product_manager.employee_id#','small');"><img src="../documents/images/visit_note.gif"  border="0" title="<cf_get_lang no ='1140.Not Bırak'>"></a>
                    </cfif>
                </td>
                <td>#get_product_manager.employee_name# #get_product_manager.employee_surname# / </td>
                <td><a href="mailto:#get_product_manager.employee_email#" class="tableyazi">#get_product_manager.employee_email#</a></td>
            </tr>
            <tr>
                <td colspan="4"><hr style="height:0.2px;" color="CCCCCC"></td>
            </tr>
        </table>
	</cfoutput>
</cfif>

