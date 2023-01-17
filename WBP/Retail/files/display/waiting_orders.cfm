<cf_big_list_search title="Talepler"></cf_big_list_search>

<cfquery name="get_talepler" datasource="#dsn3#">
	SELECT 
    	O.*,
        C.FULLNAME,
        D.DEPARTMENT_HEAD,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
    FROM
    	ORDERS O,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C,
        #dsn_alias#.EMPLOYEES E
    WHERE
    	O.ORDER_STAGE = 43 AND
        O.ORDER_STATUS = 1 AND
        D.DEPARTMENT_ID = O.DELIVER_DEPT_ID AND
        C.COMPANY_ID = O.COMPANY_ID AND
        O.RECORD_EMP = E.EMPLOYEE_ID
    ORDER BY
    	O.ORDER_DATE DESC,
        D.DEPARTMENT_HEAD,
        C.FULLNAME
</cfquery>

<cf_big_list>
    <thead>
        <tr>
        	<th width="35">Sıra</th>
            <th>Sipariş No</th>
            <th>Sipariş Başlık</th>
            <th>Tedarikçi</th>
            <th>Departman</th>
            <th>Sipariş T.</th>
            <th>Sipariş K.</th>
            <th>Kayıt Eden.</th>
        </tr>
    </thead>
    <tbody>
        <cfif get_talepler.recordcount>
            <cfoutput query="get_talepler">
                <tr>
                	<td>#currentrow#</td>
                    <td><a href="#request.self#?fuseaction=retail.speed_manage_product&order_id=#order_id#&is_form_submitted=1" class="tableyazi">#ORDER_NUMBER#</a></td>
                    <td><a href="#request.self#?fuseaction=retail.speed_manage_product&order_id=#order_id#&is_form_submitted=1" class="tableyazi">#ORDER_HEAD#</a></td>
                    <td>#FULLNAME#</td>
                    <td>#DEPARTMENT_HEAD#</td>
                    <td>#dateformat(order_date,'dd/mm/yyyy')#</td>
                    <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
               </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>