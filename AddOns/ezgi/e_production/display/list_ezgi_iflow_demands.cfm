<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_catid" default=''>
<cfparam name="attributes.search_company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.list_order_no" default="6,7,8">
<cfparam name="attributes.product_type" default="">
<cfparam name="attributes.durum_action" default="0">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date_order" default="">
<cfparam name="attributes.finish_date_order" default="">
<cfparam name="attributes.priority" default="">
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,'-')# AND IS_STORE = 3
</cfquery>
<cfset department_id_list = Valuelist(get_department.DEPARTMENT_ID)>
<cfif attributes.is_filter>
	<cfif attributes.action_type eq 1> <!---E-Planingten Çağırma İse--->
        <cfquery name="get_orders" datasource="#DSN3#">
        	SELECT 
            	*
          	FROM
            	(
                SELECT 
                	'' AS UNVAN,
                    'Planlama Talebi'  AS ACTION_TYPE_DETAIL,     
                    ISNULL((SELECT TOP(1) SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = E.STOCK_ID ORDER BY SPECT_MAIN_ID DESC),0) AS SPECT_MAIN_ID,
                    ISNULL(E.QUANTITY,0) - ISNULL(SUM(EPR.QUANTITY), 0) AS KALAN, 
                    EPD.EZGI_DEMAND_ID AS ACTION_ID,
                    EPD.DEMAND_DETAIL ACTION_DETAIL,
                    E.STOCK_ID, 
                    EPD.DEMAND_NUMBER AS ACTION_NUMBER,
                    EPD.DEMAND_DATE AS ACTION_DATE,
                    EPD.DEMAND_DELIVER_DATE AS ACTION_DELIVER_DATE,
                    E.EZGI_DEMAND_ROW_ID AS ACTION_ROW_ID, 
                    ISNULL(E.PRODUCT_TYPE,0) AS TYPE, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE as STOCK_CODE,
                    E.QUANTITY AS ACTION_QUANTITY,
                    (
                        SELECT        
                            MAIN_UNIT
                        FROM            
                            PRODUCT_UNIT
                        WHERE        
                            PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND 
                            IS_MAIN = 1
                    ) as UNIT,
                    EPD.DEMAND_HEAD HEAD
                FROM            
                    STOCKS AS S INNER JOIN
                    EZGI_PRODUCTION_DEMAND_ROW AS E ON S.STOCK_ID = E.STOCK_ID INNER JOIN
                    EZGI_PRODUCTION_DEMAND AS EPD ON E.EZGI_DEMAND_ID = EPD.EZGI_DEMAND_ID LEFT OUTER JOIN
                    EZGI_IFLOW_PRODUCTION_ORDERS AS EPR ON E.EZGI_DEMAND_ROW_ID = EPR.ACTION_ID
                WHERE  
                	1=1
                    <cfif ListLen(department_id_list)>
                    	AND EPD.DEMAND_DEPARTMENT_ID IN (#department_id_list#)
                    </cfif>
                    <cfif len(attributes.keyword)>
                        AND 
                            ( 
                                S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                                S.PRODUCT_CODE LIKE '%#attributes.keyword#%'
                            )
                    </cfif>
                    <cfif len(attributes.product_catid)>
                        AND S.PRODUCT_CATID = #attributes.product_catid#
                    </cfif>
                GROUP BY 
                    E.STOCK_ID, 
                    EPD.EZGI_DEMAND_ID,
                    EPD.DEMAND_DETAIL,
                    EPD.DEMAND_NUMBER , 
                    EPD.DEMAND_DATE, 
                    EPD.DEMAND_DELIVER_DATE,
                    E.EZGI_DEMAND_ROW_ID, 
                    E.PRODUCT_TYPE, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE,
                    S.PRODUCT_UNIT_ID, 
                    E.QUANTITY,
                    EPD.DEMAND_HEAD
                HAVING
                    ISNULL(E.QUANTITY,0) - ISNULL(SUM(EPR.QUANTITY), 0) > 0
           		) AS TB
            WHERE        
            	TYPE > 0
                <cfif len(attributes.keyword)>
                	AND 
                    	(
                            PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                            STOCK_CODE LIKE '%#attributes.keyword#%'
                     	)
                </cfif>
			ORDER BY
            	HEAD,
                TYPE,
            	PRODUCT_NAME 
     	</cfquery>
 	<cfelseif attributes.action_type eq 2> <!---Siparişten Çağırma İse--->
    	<cfquery name="get_orders" datasource="#DSN3#">
        	SELECT 
            	*
           	FROM
            	(
                SELECT DISTINCT
                	CASE
                        WHEN O.COMPANY_ID IS NOT NULL THEN
                           (
                            SELECT     
                                NICKNAME
                            FROM         
                                #dsn_alias#.COMPANY
                            WHERE     
                                COMPANY_ID = O.COMPANY_ID
                            )
                        WHEN O.CONSUMER_ID IS NOT NULL THEN      
                            (	
                            SELECT     
                                CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                            FROM         
                                #dsn_alias#.CONSUMER
                            WHERE     
                                CONSUMER_ID = O.CONSUMER_ID
                            )
                        WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                            (
                            SELECT     
                                EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
                            FROM         
                                #dsn_alias#.EMPLOYEES
                            WHERE     
                                EMPLOYEE_ID = O.EMPLOYEE_ID
                            )
                   	END
                    	AS UNVAN,
                	O.ORDER_HEAD AS HEAD,
                    'Sipariş Emri'  AS ACTION_TYPE_DETAIL, 
                    ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID =ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                    ORR.QUANTITY-ISNULL((SELECT SUM(PO.QUANTITY) QUANTITY FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID = ORR.ORDER_ROW_ID AND PO.IS_STAGE<>-1 AND ORR.STOCK_ID = PO.STOCK_ID),0) AS KALAN,
                    ORR.ORDER_ROW_ID AS ACTION_ROW_ID,
                    ORR.QUANTITY AS ACTION_QUANTITY, 
                    ORR.DELIVER_DATE AS ACTION_DELIVER_DATE,
                    ORR.UNIT,
                    S.PROPERTY, 
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    S.PRODUCT_CODE as STOCK_CODE,
                    O.ORDER_ID AS ACTION_ID,
                    O.ORDER_NUMBER AS ACTION_NUMBER,
                    O.ORDER_DATE AS ACTION_DATE, 
                    S.PRODUCT_ID,
                    ORR.PRODUCT_NAME2 ACTION_DETAIL,
                    CASE
                        WHEN
                            ISNULL((SELECT TOP (1) DESIGN_MAIN_ROW_ID FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = S.STOCK_ID),0) > 0
                        THEN
                            2
                        WHEN
                            ISNULL((SELECT TOP (1) PACKAGE_ROW_ID FROM EZGI_DESIGN_PACKAGE_ROW WHERE PACKAGE_RELATED_ID = S.STOCK_ID),0) > 0
                        THEN
                            3
                        WHEN
                            ISNULL((SELECT TOP (1) PIECE_ROW_ID FROM EZGI_DESIGN_PIECE_ROWS WHERE PIECE_RELATED_ID = S.STOCK_ID),0) > 0
                        THEN
                            4
                        ELSE
                            0
                     END AS TYPE
                FROM 
                    ORDERS O,
                    ORDER_ROW ORR, 
                    STOCKS S,
                    PRODUCT_UNIT PU
                WHERE
                    ((O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) ) AND <!--- SADECE SATIŞ SİPARİŞLER ---> 
                    PU.PRODUCT_ID = S.PRODUCT_ID AND
                    ORR.STOCK_ID = S.STOCK_ID AND
                    ORR.PRODUCT_ID = S.PRODUCT_ID AND
                    (S.IS_PRODUCTION = 1 OR S.IS_KARMA = 1) AND
                    ORR.ORDER_ID = O.ORDER_ID AND
                    O.ORDER_STATUS = 1
                    <cfif len(attributes.keyword)>
                        AND 
                            ( 
                                S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                                S.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
                                O.ORDER_NUMBER LIKE '%#attributes.keyword#%'
                            )
                    </cfif>
                    <cfif len(attributes.product_catid)>
                        AND S.PRODUCT_CATID = #attributes.product_catid#
                    </cfif>
                    <cfif attributes.durum_action eq 1>
                        AND ORR.ORDER_ROW_ID IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE<>-1)
                    <cfelseif attributes.durum_action eq 0>
                        AND ORR.ORDER_ROW_ID NOT IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE<>-1)
                        AND	ORR.ORDER_ROW_CURRENCY = -5
                    <cfelseif attributes.durum_action eq 2>
                        AND ORR.ORDER_ROW_ID IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE=-1)
                    <cfelseif attributes.durum_action eq 3>
                        AND ORR.ORDER_ROW_ID NOT IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE=-1)
                    <cfelseif attributes.durum_action eq 4>
                        AND ORR.ORDER_ROW_ID NOT IN (SELECT ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ROW_ID IS NOT NULL)
                        AND	ORR.ORDER_ROW_CURRENCY = -5
                    <cfelseif attributes.durum_action eq 5>
                        AND ORR.ORDER_ROW_ID IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE<>-1)
                        AND ORR.QUANTITY > (SELECT SUM(PO.QUANTITY) QUANTITY FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID = ORR.ORDER_ROW_ID AND PO.IS_STAGE<>-1 AND ORR.STOCK_ID = PO.STOCK_ID)
                    <cfelseif attributes.durum_action eq 6>
                        AND ORR.ORDER_ROW_ID IN (SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE=-1)
                        AND ORR.QUANTITY > (SELECT SUM(PO.QUANTITY) QUANTITY FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID = ORR.ORDER_ROW_ID AND PO.IS_STAGE=-1 AND ORR.STOCK_ID = PO.STOCK_ID)
                    <cfelse>
                        AND	ORR.ORDER_ROW_CURRENCY = -5
                    </cfif>
                    <cfif len(attributes.start_date)>
                        AND O.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                    </cfif>
                    <cfif len(attributes.finish_date)>
                        AND O.DELIVERDATE < #DATEADD('d',1,attributes.finish_date)#
                    </cfif>
                    <cfif len(attributes.start_date_order)>
                        AND O.ORDER_DATE >= #attributes.start_date_order#
                    </cfif>
                    <cfif len(attributes.finish_date_order)>
                        AND O.ORDER_DATE < #DATEADD('d',1,attributes.finish_date_order)#
                    </cfif>
                    <cfif len(attributes.priority)>
                        AND O.PRIORITY_ID = #attributes.priority#
                    </cfif>
             	) AS TBL
          	WHERE
            	TYPE > 0
          	ORDER BY
            	HEAD,
            	PRODUCT_NAME                
		</cfquery>
  	<cfelseif attributes.action_type eq 3> <!---Plan Transfer İse--->
    	<cfquery name="get_orders" datasource="#DSN3#">
        	SELECT
            	* 
         	FROM
            	(
                SELECT     
                    CASE
                        WHEN O.COMPANY_ID IS NOT NULL THEN
                               (
                                SELECT     
                                    NICKNAME
                                FROM         
                                    #dsn_alias#.COMPANY
                                WHERE     
                                    COMPANY_ID = O.COMPANY_ID
                                )
                        WHEN O.CONSUMER_ID IS NOT NULL THEN      
                                (	
                                SELECT     
                                    CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                                FROM         
                                    #dsn_alias#.CONSUMER
                                WHERE     
                                    CONSUMER_ID = O.CONSUMER_ID
                                )
                        WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                                (
                                SELECT     
                                    EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
                                FROM         
                                    #dsn_alias#.EMPLOYEES
                                WHERE     
                                    EMPLOYEE_ID = O.EMPLOYEE_ID
                                )
                    END AS UNVAN,  
                    'Transfer İş Emri'  AS ACTION_TYPE_DETAIL,  
                    EMP.MASTER_PLAN_ID, 
                    EMP.MASTER_PLAN_DETAIL, 
                    EMP.MASTER_PLAN_NUMBER ACTION_NUMBER, 
                    EFOP.P_ORDER_PARTI_NUMBER, 
                    EFPO.IFLOW_P_ORDER_ID AS ACTION_ROW_ID, 
                    EFPO.LOT_NO, 
                    EFPO.STOCK_ID, 
                    EFPO.QUANTITY AS ACTION_QUANTITY,  
                    EFPO.QUANTITY AS KALAN,
                    EFPO.SPECT_MAIN_ID,
                    S.PRODUCT_ID,
                    S.PRODUCT_CODE as STOCK_CODE, 
                    S.PRODUCT_NAME,
                    S.PROPERTY, 
                    O.ORDER_DATE AS ACTION_DATE,
                    ORR.PRODUCT_NAME2 AS ACTION_DETAIL,
                    ORR.DELIVER_DATE AS ACTION_DELIVER_DATE,
                    ORR.UNIT,
                    O.ORDER_HEAD HEAD,
                    ISNULL((
                            SELECT TOP (1)       
                                1 AS IS_STAGE
                            FROM            
                                EZGI_OPERATION_M
                            WHERE        
                                LOT_NO = EFPO.LOT_NO AND 
                                (IS_STAGE = 2 OR IS_STAGE = 1)
                    ), 0) AS IS_STAGE, 
                    ISNULL((
                            SELECT TOP (1)     
                                1 AS STAGE
                            FROM            
                                EZGI_OPERATION_M AS EZGI_OPERATION_M_1
                            WHERE        
                                LOT_NO = EFPO.LOT_NO AND 
                                (STAGE = 3 OR STAGE = 1)
                    ), 0) AS STAGE,
                    CASE
                            WHEN
                                ISNULL((SELECT TOP (1) DESIGN_MAIN_ROW_ID FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = S.STOCK_ID),0) > 0
                            THEN
                                2
                            WHEN
                                ISNULL((SELECT TOP (1) PACKAGE_ROW_ID FROM EZGI_DESIGN_PACKAGE_ROW WHERE PACKAGE_RELATED_ID = S.STOCK_ID),0) > 0
                            THEN
                                3
                            WHEN
                                ISNULL((SELECT TOP (1) PIECE_ROW_ID FROM EZGI_DESIGN_PIECE_ROWS WHERE PIECE_RELATED_ID = S.STOCK_ID),0) > 0
                            THEN
                                4
                            ELSE
                                0
                    END AS TYPE
                FROM            
                    ORDERS AS O INNER JOIN
                    ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID RIGHT OUTER JOIN
                    EZGI_IFLOW_PRODUCTION_ORDERS_PARTI AS EFOP INNER JOIN
                    EZGI_IFLOW_PRODUCTION_ORDERS AS EFPO ON EFOP.P_ORDER_PARTI_ID = EFPO.REL_P_ORDER_ID INNER JOIN
                    EZGI_IFLOW_MASTER_PLAN AS EMP ON EFPO.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID INNER JOIN
                    STOCKS AS S ON EFPO.STOCK_ID = S.STOCK_ID ON ORR.ORDER_ROW_ID = EFPO.ORDER_ROW_ID
                WHERE        
                    EMP.MASTER_PLAN_CAT_ID = #attributes.cat_id# AND 
                    EMP.MASTER_PLAN_STATUS = 1 AND 
                    EMP.MASTER_PLAN_PROCESS = 1
            	) AS TRF_TBL
        	WHERE
            	IS_STAGE = 0
                <cfif len(attributes.keyword)>
                	AND 
                    	(
                        	UNVAN LIKE '%#attributes.keyword#%' OR
                            PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                            STOCK_CODE LIKE '%#attributes.keyword#%' OR
                            HEAD LIKE '%#attributes.keyword#%'
                     	)
                </cfif>
    	</cfquery>
  	</cfif>
<cfelse>
	<cfset get_orders.recordcount = 0>
</cfif>
<cfquery name="get_cat" datasource="#dsn3#">
        SELECT      
            PRODUCT_CATID, 
            HIERARCHY, 
            PRODUCT_CAT
        FROM            
            PRODUCT_CAT
        WHERE
            PRODUCT_CATID IN 
            (
                SELECT        
                    PRODUCT_CATID
                FROM            
                    PRODUCT
                GROUP BY 
                    PRODUCT_CATID
            )
            <cfif isdefined('attributes.list_order_no') and len(attributes.list_order_no)>
                AND       
                    LIST_ORDER_NO IN (#attributes.list_order_no#)
            </cfif>
        ORDER BY
            PRODUCT_CAT
</cfquery>
<cfparam name="attributes.maxrows" default="#SESSION.EP.MAXROWS#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_orders.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.list_order_no") and len(attributes.list_order_no)>
	<cfset url_str = "#url_str#&list_order_no=#attributes.list_order_no#">
</cfif>
<cfif isdefined('attributes.product_type')>
	<cfset url_str1 = "&product_type=#attributes.product_type#">
<cfelse>
	<cfset url_str1 =''>
</cfif>
<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfset url_str2 = "&product_catid=#attributes.product_catid#&product_cat=#PRODUCT_CAT#">
<cfelse>
	<cfset url_str2 =''>
</cfif>
<cfform name="price_cat" action="#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=#attributes.action_type##url_str##url_str2#" method="post">
	<cfif attributes.action_type eq 3>
    	<cfinput type="hidden" name="cat_id" id="cat_id" value="#attributes.cat_id#">	
    </cfif>
    <input type="hidden" name="is_filter" id="is_filter" value="1">
    <cfif attributes.action_type eq 1>
		<cfset baslik = '#getLang('main',3265)#'> 
    <cfelse>
    	<cfset baslik = '#getLang('main',3266)#'>
    </cfif>
    	<cf_medium_list_search title='#baslik#'>
		<cf_medium_list_search_area>
			<table>
				<tr> 
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" style="width:100px;"></td>
                    <cfinput type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
                    <cfinput type="hidden" name="product_cat" id="product_catid" value="#attributes.product_cat#">
                    <td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
                    <td></td>
					<td style="text-align:right;">
                    	<cf_wrk_search_button search_function='input_control()'>
                   	</td>
				</tr>       
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_area width="150px">
	<table width="100%">
		<cfif get_cat.recordcount>
        	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="text-align:right;cursor: pointer;<cfif isdefined('attributes.product_catid') and attributes.product_catid eq ''>background-color:LightGray</cfif>" >
             	<td width="20%">0</td>
              	<td width="80%">
                 	<a href=<cfoutput>"#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=#attributes.action_type#&keyword=#attributes.keyword#</cfoutput>&is_filter=1">
                    	<cf_get_lang_main no='1739.Tüm Kategoriler'>
                	</a>
              	</td>
         	</tr>
			<cfoutput query="get_cat">
            	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="text-align:right;cursor: pointer;<cfif isdefined('attributes.product_catid') and attributes.product_catid eq PRODUCT_CATID>background-color:LightGray</cfif>" >
                	<td>#currentrow#</td>
                    <td>
                    	<a href="#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=#attributes.action_type#&keyword=#attributes.keyword#&product_catid=#PRODUCT_CATID#&product_cat=#PRODUCT_CAT#&is_filter=1">
                    		#PRODUCT_CAT#
                    	</a>
                    </td>
                </tr>
            </cfoutput>
		</cfif>
  	</table>
</cf_area>
<cf_area width="500px">
<cf_medium_list>
	<thead>
		<tr>
        	<cfif attributes.action_type eq 3>
            	<th width="80px"><cf_get_lang_main no='3499.Plan No'></th>
            <cfelse>
        		<th width="80px"><cf_get_lang_main no='799.Sipariş No'></th>
            </cfif>
            <th width="150px"><cf_get_lang_main no='45.Müşteri'></th>
            <th width="80px"><cf_get_lang_main no='1408.Başlık'></th>
            <th width="70px"><cf_get_lang_main no='330.Tarih'></th>
            <th width="70px"><cfoutput>#getLang('prod',485)#</cfoutput></th>
            <th width="50px"><cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='3019.Tipi'></th>
			<th width="100px"><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='245.Ürün'></th>
            <th width="65px"><cf_get_lang_main no='223.Miktar'></th>
            <th width="30px"><cf_get_lang_main no='224.Birim'></th>
            <th width="65px"><cf_get_lang_main no='1032.Kalan'></th>
            <th><cf_get_lang_main no='217.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_orders.recordcount>
			<cfoutput query="get_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <cfif type eq 1>
                    <cfset type_detail = '#getLang('main',1099)#'>
                <cfelseif type eq 2>
                    <cfset type_detail = '#getLang('main',2944)#'>
                <cfelseif type eq 3>
                    <cfset type_detail = '#getLang('main',2903)#'>
                <cfelseif type eq 4>
                    <cfset type_detail = '#getLang('main',2848)#'>
                </cfif>
                <cfscript>
                    temp_prod_property=replace(PROPERTY,'"','','all');
                    temp_prod_property=replace(temp_prod_property,"'","","all");
                    temp_prod_property=replace(temp_prod_property,";","","all");
                    temp_prod_name=replace(product_name,'"','','all');
                    temp_prod_name=replace(temp_prod_name,"'","","all");
                    temp_prod_name=replace(temp_prod_name,";","","all");
                </cfscript>
                <form name="product#currentrow#" method="post" action="">
                    <input type="Hidden" name="product_id" id="product_id" value="#product_id#">
                    <input type="Hidden" name="type" id="type" value="#type#">
                    <input type="Hidden" name="product_name" id="product_name" value="#product_name#"><!--- #&nbsp;#property# --->
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" style="cursor:pointer" class="tableyazi" onClick="javascript:opener.add_row(#STOCK_ID#,'#temp_prod_property#','#currentrow#','#product_id#','#temp_prod_name#','#STOCK_CODE#','#type#','#type_detail#','#unit#','0','TL','0','#ACTION_ROW_ID#','#kalan#','#attributes.action_type#','#ACTION_TYPE_DETAIL#',#SPECT_MAIN_ID#);"> 
                        <td style="text-align:center">#action_number#</td> 
                        <td style="text-align:center">#UNVAN#</td> 
                        <td style="text-align:center">#HEAD#</td>   
                        <td style="text-align:center">#DateFormat(action_date,'DD/MM/YYYY')#</td>
                        <td style="text-align:center">#DateFormat(ACTION_DELIVER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center">#type_detail#</td>      
                        <td>#STOCK_CODE#</td>
                        <td>#product_name# #property#</td> 
                        <td style="text-align:right">#Tlformat(ACTION_QUANTITY,2)#</td>
                        <td width="15">#unit#</td>
                        <td style="text-align:right">#Tlformat(kalan,2)#</td> 
                        <td style="text-align:left">#action_detail#</td> 
                    </tr>
                </form>
            </cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="12">
					<cfif attributes.is_filter>
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					<cfelse>
						<cf_get_lang_main no='289.Filtre Ediniz'>!
					</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
</cf_area>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%">
	  <tr> 
		<td>
			<cfset adres = "prod.popup_list_ezgi_iflow_demands&action_type=#attributes.action_type#">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
			</cfif>
            <cfif isdefined("attributes.list_order_no") and len(attributes.list_order_no)>
				<cfset adres = "#adres#&list_order_no=#attributes.list_order_no#">
            </cfif>

            <cfif isdefined('attributes.product_type') and len(attributes.product_type)>
                <cfset adres = "#adres#&product_type=#attributes.product_type#">
            </cfif>

			<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		  </td>
		  <!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
		  </td><!-- sil -->
	  </tr>
	</table>
</cfif>
<script type="text/javascript">
	price_cat.keyword.focus();
	function input_control()
	{
	<cfif not session.ep.our_company_info.unconditional_list>
		if (price_cat.keyword.value.length == 0 && price_cat.product_cat.value.length == 0 && (price_cat.employee_id.value.length == 0 || price_cat.employee.value.length == 0) && (price_cat.search_company_id.value.length == 0 || price_cat.search_company.value.length == 0) )
			{
				alert('<cf_get_lang_main no='1538.En Az Bir Alanda Filtre Etmelisiniz'> !');
				return false;
			}
		else return true;
	<cfelse>
		return true;
	</cfif>
	}
	function gonder(stock_id,product_name)
	{
		window.opener.add_ezgi_row(stock_id,product_name);
		self.close();
	}
</script>