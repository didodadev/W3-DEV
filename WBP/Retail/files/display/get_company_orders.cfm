<cfquery name="get_orders" datasource="#dsn3#">
	SELECT 
        ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ID = O.ORDER_ID),0) AS URUN_SAYISI,
        ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -1 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS ACIK_URUN_SAYISI,
        ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -6 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS SEVK_URUN_SAYISI,
        O.ORDER_NUMBER, 
        O.ORDER_CODE,
        O.RECORD_DATE, 
        O.ORDER_DATE,
        O.ORDER_HEAD,
        D.DEPARTMENT_HEAD,
        PTR.STAGE,
        COM.NICKNAME,
        PP.PROJECT_HEAD,
        EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME
    FROM 
        ORDERS O
        	LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON O.RECORD_EMP = EMP.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.DEPARTMENT D ON O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
            LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.ORDER_STAGE = PTR.PROCESS_ROW_ID
            LEFT JOIN #dsn_alias#.COMPANY COM ON O.COMPANY_ID = COM.COMPANY_ID
            LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON O.PROJECT_ID = PP.PROJECT_ID
    WHERE 
        O.COMPANY_ID = #listfirst(attributes.comp_code,'_')# AND
        ISNULL(O.PROJECT_ID,0) =  #listlast(attributes.comp_code,'_')# AND
        YEAR(O.ORDER_DATE) = #mid(attributes.order_date,5,4)# AND
        MONTH(O.ORDER_DATE) = #mid(attributes.order_date,3,2)# AND
        DAY(O.ORDER_DATE) = #mid(attributes.order_date,1,2)# AND
        O.ORDER_STAGE = #attributes.stage#
        <cfif isdefined("session.ep.admin") and session.ep.admin neq 1>
           AND 
           O.DELIVER_DEPT_ID IN 
            (
                SELECT 
                    DEPARTMENT_ID 
                FROM 
                    #dsn_alias#.DEPARTMENT 
                WHERE 
                    BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
           )
        </cfif>
    ORDER BY 
        O.ORDER_DATE ASC
</cfquery>

<cfoutput><b style="font-size:12px;">#get_orders.NICKNAME# <cfif len(get_orders.PROJECT_HEAD)>(#get_orders.PROJECT_HEAD#)</cfif></b></cfoutput>
<br /><br />
<cf_ajax_list>
	<thead>
    	<tr>
        	<th>İşlem Kodu</th>
            <th>No</th>
            <th>Belge Tarihi</th>
            <th>Konu</th>
            <th>Depo</th>
            <th>Kayıt Eden</th>
            <th>Süreç</th>
            <th>Ürün</th>
            <th>Onaysız</th>
            <th>Onaylı</th>
        </tr>
    </thead>
    <tbody>
    	<cfoutput query="get_orders">
        	<tr>
                <td>#order_code#</td>
                <td>#order_number#</td>
                <td>#dateformat(order_date,'dd/mm/yyyy')#</td>
                <td>#order_head#</td>
                <td>#DEPARTMENT_HEAD#</td>
                <td>#EMPLOYEE_NAME#</td>
                <td>#STAGE#</td>
                <td>#URUN_SAYISI#</td>
                <td>#ACIK_URUN_SAYISI#</td>
                <td>#SEVK_URUN_SAYISI#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_ajax_list>