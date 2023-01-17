<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
    <cfquery name="get_department" datasource="#dsn#">
        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id#
    </cfquery>
	<cfif get_department.recordcount gt 0>
    <cfset departmen_head = #get_department.DEPARTMENT_HEAD# >
    <cfelse>
    <cfset departmen_head = '' >
    </cfif>
</cfif>
<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
    <cfquery name="get_product" datasource="#dsn1#">
        SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.product_id#
    </cfquery>
        <cfif get_product.recordcount gt 0>
        <cfset product_name = #get_product.product_name# >
        <cfelse>
        <cfset product_name = '' >
        </cfif>
<cfelseif isdefined("attributes.stock_id") and len(attributes.stock_id)>
    <cfquery name="get_property" datasource="#dsn1#">
        SELECT PROPERTY FROM STOCKS WHERE  STOCK_ID = #attributes.stock_id#
    </cfquery>
        <cfif get_property.recordcount gt 0>
        <cfset product_name = #get_property.property# >
        <cfelse>
        <cfset product_name = '' >
        </cfif>
</cfif>
<cfquery name="get_orders" datasource="#dsn3#">
	SELECT
    	O.ORDER_NUMBER,
        O.ORDER_DATE,
        O.ORDER_ID,
        ORR.NETTOTAL,
        ORR.QUANTITY,
        ORR.STOCK_ID,
        ORR.PRODUCT_ID,
        (SELECT PROPERTY FROM STOCKS WHERE STOCK_ID = ORR.STOCK_ID ) AS NAME_PRODUCT,
        D.DEPARTMENT_HEAD,
        C.FULLNAME,
        (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = O.PROJECT_ID) AS PROJECT_HEAD
    FROM
    	ORDERS O,
        ORDER_ROW ORR,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C
    WHERE
    	O.PURCHASE_SALES = 0 AND
        O.COMPANY_ID = C.COMPANY_ID AND
        O.DELIVER_DEPT_ID = D.DEPARTMENT_ID AND
        O.ORDER_ID = ORR.ORDER_ID AND  
        ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND   
        O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
        O.ORDER_DATE <= #bugun_# 
        <cfif isdefined("attributes.department_id") and len(attributes.department_id)> AND O.DELIVER_DEPT_ID = #attributes.department_id#</cfif>
        <cfif isdefined("attributes.product_id") and len(attributes.product_id)> AND ORR.PRODUCT_ID = #attributes.product_id#</cfif>
        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)> AND ORR.STOCK_ID = #attributes.stock_id#</cfif>
    ORDER BY
    	O.ORDER_DATE DESC
</cfquery>	
<cfsavecontent variable="header_"><a href="javascript://" onclick="show_hide('standart_fiyat_table2')">Yoldaki Stok</a> : <cfoutput><font color="FF0000">#product_name#</font></cfoutput>   <cfif isdefined("attributes.department_id") and len(attributes.department_id)>Departman : <cfoutput><font color="FF0000">#departmen_head#</font></cfoutput></cfif></cfsavecontent>
<cf_medium_list_search title="#header_#"></cf_medium_list_search>
<cf_medium_list> 
<thead>             
    <tr> 
        <th>Stok Adı </th>
        <th>Şube </th>
        <th>Sip. Tarih</th>
        <th>Sip miktar</th>
        <th>Anlaşılan Fiyat</th>
        <th>Sipariş Fiyatı</th>
        <th>Sipariş No</th>
        <th>Cari</th>                    
    </tr>
</thead>
<tbody>
<cfif get_orders.recordcount gt 0>
	<cfoutput query="get_orders">                  
    <tr>            	
        <td style="background-color:##E0FFFF; ">#NAME_PRODUCT#</td>
        <td style="background-color:##E0FFFF; ">#department_head#</td>
        <td style="background-color:##E0FFFF; ">#dateformat(order_date,'dd/mm/yyyy')#</td>
        <td style="background-color:##FC6; ">#quantity#</td> 
        <td align="right">#tlformat(get_daily_cost_price(product_id,year(order_date),month(order_date),day(order_date)))#</td>
        <td align="right" style="background-color:##CF3; ">#tlformat(NETTOTAL / QUANTITY)#</td>
        <td style="background-color:##FAEBD7; "><a href="#request.self#?fuseaction=purchase.detail_order&order_id=#order_id#" class="tableyazi" target="parent">#order_number#</a></td>
        <td>#FULLNAME# #PROJECT_HEAD#</td>                
    </tr>
    </cfoutput>           
<cfelse>
    <tr>            	
        <td colspan="8">Kayıt Yok</td>                
    </tr>
</cfif>
</tbody>
</cf_medium_list> 