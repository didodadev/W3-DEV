<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sort_type" default="2">
<cfparam name="attributes.is_in_package" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.durum_emir" default="">
<!---<cfparam name="attributes.process_stage" default="">--->
<cfparam name="attributes.master_plan_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.PRODUCT_TYPE" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfset kapasite_kullanim_orani = 0>
<cfset makine_sayisi = 0>
<cfquery name="get_master_plan" datasource="#dsn3#">
	SELECT        
    	MASTER_PLAN_ID, 
        MASTER_PLAN_NUMBER, 
        MASTER_PLAN_DETAIL
	FROM            
    	EZGI_IFLOW_MASTER_PLAN
  	<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
        WHERE 
            MASTER_PLAN_CAT_ID =    
            
                    (
                        SELECT        
                            MASTER_PLAN_CAT_ID
                        FROM       
                            EZGI_IFLOW_MASTER_PLAN AS M
                        WHERE        
                            MASTER_PLAN_ID = #attributes.master_plan_id#
                    )
    </cfif>
	ORDER BY 
    	MASTER_PLAN_NUMBER
</cfquery>
<cfquery name="get_station" datasource="#dsn3#">
	SELECT        
    	W.STATION_ID, 
        W.STATION_NAME
	FROM            
      	WORKSTATIONS W
	WHERE        
    	W.UP_STATION IS NULL AND 
        W.STATION_ID IN 
        				(
                        	SELECT        
                            	PO.STATION_ID
							FROM            
                            	EZGI_IFLOW_MASTER_PLAN AS M INNER JOIN
                        		EZGI_IFLOW_MASTER_PLAN AS M1 ON M.MASTER_PLAN_CAT_ID = M1.MASTER_PLAN_CAT_ID INNER JOIN
                        		EZGI_IFLOW_PRODUCTION_ORDERS AS POL ON M1.MASTER_PLAN_ID = POL.MASTER_PLAN_ID INNER JOIN
                        		PRODUCTION_ORDERS AS PO ON POL.LOT_NO = PO.LOT_NO
							WHERE   
                            	(NOT (PO.STATION_ID IS NULL)) 
                                <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
                                	AND M.MASTER_PLAN_ID = #attributes.master_plan_id#
                              	</cfif>
							GROUP BY 
                            	PO.STATION_ID
                        )
	ORDER BY 
    	W.STATION_NAME
</cfquery>
<cfoutput query="get_station">
	<cfset 'STATION_NAME_#STATION_ID#' = STATION_NAME>
</cfoutput>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_ezgi_iflow_production_order.cfm">
    <cfif get_production_orders.recordcount>
    	<cfset iflow_p_order_list = ValueList(get_production_orders.iflow_p_order_id)>
   		<cfset iflow_p_order_list = ListDeleteDuplicates(iflow_p_order_list,',')>
        <cfif attributes.list_type eq 1>
        	<cfset iflow_order_list = ValueList(get_production_orders.order_id)>
            <cfquery name="get_orders" datasource="#dsn3#">
                SELECT        
                    ORDER_ID, 
                    ORDER_HEAD, 
                    ORDER_NUMBER, 
                    ORDER_DATE,
                    DELIVERDATE,
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
                            AS UNVAN
                FROM            
                    ORDERS AS O
                WHERE        
                    ORDER_ID IN (#iflow_order_list#)
            </cfquery>
            <cfoutput query="get_orders">
                <cfset 'ORDER_NUMBER_#ORDER_ID#' = ORDER_NUMBER>
                <cfset 'ORDER_DATE_#ORDER_ID#' = ORDER_DATE>
                <cfset 'UNVAN_#ORDER_ID#' = UNVAN>
                <cfset 'DELIVERDATE_#ORDER_ID#' = DELIVERDATE>
            </cfoutput>
        <cfelseif attributes.list_type eq 3 or attributes.list_type eq 4 or attributes.list_type eq 5>
        	<cfquery name="get_group" dbtype="query">
            	SELECT
                	COUNT(*) AS SAY,
                    STOCK_ID
              	FROM
                	get_production_orders
              	WHERE
               		IS_GROUP_LOT = 1 	
              	GROUP BY
                	<cfif attributes.list_type eq 3>
                        LOT_NO,STOCK_ID
                    <cfelseif attributes.list_type eq 4>  
                        P_ORDER_PARTI_NUMBER,STOCK_ID
                    <cfelseif attributes.list_type eq 5>
                        STOCK_ID
                  	</cfif>
       		</cfquery>
            <cfif get_group.recordcount>
				<cfoutput query="get_group">
                    <cfset 'SAY_#STOCK_ID#' = SAY>
                </cfoutput>
            	<cfset gurup_button = 1>
            <cfelse>
                <cfset gurup_button = 0>    
            </cfif>
        <cfelse>
        	<cfquery name="get_orders" datasource="#dsn3#">
            	SELECT        
                	EP.IFLOW_P_ORDER_ID, 
                    O.ORDER_NUMBER
				FROM            
               		EZGI_IFLOW_PRODUCTION_ORDERS AS EP INNER JOIN
                 	PRODUCTION_ORDERS AS PO ON EP.LOT_NO = PO.LOT_NO INNER JOIN
                 	PRODUCTION_ORDERS_ROW AS POR ON PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID INNER JOIN
                 	ORDERS AS O ON POR.ORDER_ID = O.ORDER_ID
				WHERE        
                	EP.IFLOW_P_ORDER_ID IN (#iflow_p_order_list#)
              	GROUP BY 
                	EP.IFLOW_P_ORDER_ID, 
                    O.ORDER_NUMBER
            </cfquery>
            <cfoutput query="get_orders">
                <cfset 'ORDER_NUMBER_#IFLOW_P_ORDER_ID#' = ORDER_NUMBER>
            </cfoutput>
        </cfif>
    </cfif>
	<cfset arama_yapilmali = 0>
    <cfif attributes.list_type eq 3 or attributes.list_type eq 4 or attributes.list_type eq 4>
    	<cfquery name="get_production_orders" dbtype="query">
        	SELECT * FROM get_production_orders ORDER BY LOT_NO, PRODUCT_NAME
        </cfquery>
    <cfelseif attributes.list_type eq 2>
    	<cfquery name="get_production_orders" dbtype="query">
        	SELECT 
            	* 
           	FROM 
            	get_production_orders 
           	WHERE
            	1=1
          		<cfif isdefined('attributes.is_in_package') and len(attributes.is_in_package)>
					<cfif attributes.is_in_package eq 1>
                    	AND PACKAGE_NUMBER <= 0
                	<cfelseif attributes.is_in_package eq 2>    
                    	AND PACKAGE_NUMBER > 0
                 	</cfif>
           		</cfif>
            ORDER BY 
            	LOT_NO, 
                PRODUCT_NAME
        </cfquery>
    </cfif>
<cfelse>
	<cfset get_production_orders.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_STATUS = 1 ORDER BY OPERATION_TYPE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_production_orders.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   	<cf_big_list_search title="#getLang('main',3452)#" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr height="20px">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:120px;" value="#attributes.keyword#" maxlength="500"></td>
                    <td>
                    	<select name="list_type" id="list_type" style="width:100px; height:20px" onchange="change_list_type()">
                           	<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang_main no='3275.Üst Emirler'></option>
                         	<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang_main no='3276.Alt Emirler'></option>
                            <option value="3" <cfif attributes.list_type eq 3>selected</cfif>><cfoutput>#getLang('objects',116)# #getLang('prod',502)#</cfoutput></option>
                            <option value="4" <cfif attributes.list_type eq 4>selected</cfif>><cf_get_lang_main no='3468.Parti Grupla'></option>
                            <option value="5" <cfif attributes.list_type eq 5>selected</cfif>><cfoutput>#getLang('report',1055)# #getLang('prod',502)#</cfoutput></option>
                     	</select>
                    </td>
                    <td><select name="sort_type" id="sort_type" style="width:160px;height:20px">
                        <option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cfoutput>#getLang('product',945)#</cfoutput></option>
                        <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cfoutput>#getLang('product',946)#</cfoutput></option>
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cfoutput>#getLang('main',3268)#</cfoutput></option>
                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cfoutput>#getLang('main',3269)#</cfoutput></option>
                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cfoutput>#getLang('main',3270)#</cfoutput></option>
                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cfoutput>#getLang('main',3271)#</cfoutput></option>
                        <option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cfoutput>#getLang('main',3469)#</cfoutput></option>
                        </select>
                    </td>
                    <!---<td id="product_type_" style="<cfif attributes.list_type eq 2>display:none</cfif>">
                    	<select name="product_type" id="product_type" style="width:100px">
                        	<option value="" <cfif attributes.PRODUCT_TYPE eq ''>selected</cfif>>Tümü</option>
                            <option value="2" <cfif attributes.PRODUCT_TYPE eq 2>selected</cfif>>Modül</option>
                            <option value="3" <cfif attributes.PRODUCT_TYPE eq 3>selected</cfif>>Paket</option>
                            <option value="4" <cfif attributes.PRODUCT_TYPE eq 4>selected</cfif>>Parça</option>
                        </select>
                    </td>--->
                    <td>
                    	<select name="durum_emir" id="durum_emir" style="width:100px;height:20px">
                         	<option value=""><cf_get_lang_main no='296.Tümü'></option>
                           	<option value="1" <cfif attributes.durum_emir eq 1>selected</cfif>><cfoutput>#getLang('main',3272)# #getLang('main',116)#</cfoutput></option>
                         	<option value="2" <cfif attributes.durum_emir eq 2>selected</cfif>><cfoutput>#getLang('main',1305)# #getLang('main',116)#</cfoutput></option>
                     	</select>
                    </td>
                    <td>
                    	<select name="master_plan_id" style="width:150px;height:20px">
                        	<option value="" <cfif attributes.master_plan_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_master_plan">
                            	<option value="#MASTER_PLAN_ID#" <cfif attributes.master_plan_id eq MASTER_PLAN_ID>selected</cfif>>#MASTER_PLAN_NUMBER# - #MASTER_PLAN_DETAIL#</option>
                            </cfoutput>
                     	</select>
                    </td>
                    <td>
                    	<select name="station_id" style="width:150px;height:20px">
                        	<option value="" <cfif attributes.station_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_station">
                            	<option value="#STATION_ID#" <cfif attributes.station_id eq STATION_ID>selected</cfif>>#STATION_NAME#</option>
                            </cfoutput>
                     	</select>
                    </td>
					<td>
                    	<select name="is_in_package" id="is_in_package" style="width:100px;height:20px">
                         	<option value=""><cf_get_lang_main no='296.Tümü'></option>
                           	<option value="1" <cfif attributes.is_in_package eq 1>selected</cfif>><cfoutput>#getLang('report',1441)#</cfoutput></option>
                         	<option value="2" <cfif attributes.is_in_package eq 2>selected</cfif>><cfoutput>#getLang('report',1440)#</cfoutput></option>
                     	</select>
                    </td>
					<td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,2500" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="4" style="width:35px;">
                    </td>
                    <td><cf_wrk_search_button search_function='input_control()'></td>
				</tr>
			</table>
        </cf_big_list_search_area>
     	
   		<cf_big_list_search_detail_area>
			<table>
				<tr valign="middle">
                	<!---<td>
                    	<select name="member_cat_type" id="member_cat_type" style="width:180px;height:20px">
                                <option value="" selected><cfoutput>#getLang('prod',78)#</cfoutput></option>
                                <option value="1" <cfif attributes.member_cat_type eq 1>selected</cfif>><cf_get_lang_main no='627.Kurumsal Üye Kategorileri'></option>
                                <cfoutput query="get_company_cat">
                                    <option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
                                </cfoutput>
                                <option value="2" <cfif attributes.member_cat_type eq 2>selected</cfif>><cf_get_lang_main no='628.Bireysel Üye Kategorileri'></option>
                                <cfoutput query="get_consumer_cat">
                                    <option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                </cfoutput>
                            </select>
                    </td>--->
                	<td><cf_get_lang_main no='107.Cari Hesap'></td>
                	<td>
                    	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                   		<input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                       	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                      	<input type="text"   name="member_name" id="member_name" style="width:175px;height:20px"  value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','250');" autocomplete="off">
                      	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search.consumer_id&field_comp_id=search.company_id&field_member_name=search.member_name&field_type=search.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search.member_name.value),'list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                	<td><cf_get_lang_main no='487.Kaydeden'></td>
					<td>
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:150px;height:20px" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search.record_emp_id&field_name=search.record_emp_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search.record_emp_name.value),'list','popup_list_positions');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
					</td>
                    <td><cf_get_lang_main no='74.Kategori'></td>
					<td>
						<input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
						<input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
						<input name="category_name" type="text" id="category_name" style="width:170px;height:20px" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
						<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search.cat_id&field_code=search.cat&field_name=search.category_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
					</td>
                    <td><cf_get_lang_main no='3204.İlişkili Operasyonlar'></td>
                 	<td>
                            <select name="operation_type_id" id="operation_type_id" style="width:190px; height:20px">
                            	<option value="" <cfif attributes.operation_type_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_operations">
                                	<option value="#OPERATION_TYPE_ID#" <cfif attributes.operation_type_id eq OPERATION_TYPE_ID>selected</cfif>>#OPERATION_TYPE#</option>
                                </cfoutput>
                            </select>
                            <cf_get_lang_main no='2259.Olmayanlar'>
                            <input name="reverse_answer" type="checkbox" <cfif isdefined('attributes.reverse_answer')>selected</cfif>>
                	</td>
                </tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
	
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr valign="middle">
                <th style="width:25px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1165.Sıra'></th>
                <th style="width:65px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='711.Planlama'><br /><cf_get_lang_main no='1181.Tarihi'></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('report',1055)#<br />#getLang('main',75)#</cfoutput></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('main',3273)#<br />#getLang('main',75)#</cfoutput></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('report',148)#<br />#getLang('main',75)#</cfoutput></th>
                <cfif attributes.list_type eq 1>
                	<th style="width:50px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='245.Ürün'><br /><cf_get_lang_main no='3019.Tipi'></th>
                <cfelse>
                	<th style="width:20px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='218.Tip'></th>
                	<th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('prod',343)#<br />#getLang('main',75)#</cfoutput></th>
                    <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('report',233)#<br />#getLang('report',148)# #getLang('main',75)#</cfoutput></th>
                    <th style="width:50px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='3203.Paket No'></th>
                </cfif>
                
                <th style="text-align:center; vertical-align:middle" ><cf_get_lang_main no='245.Ürün'></th>
                <th style="width:95px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='3274.Kesim'><br /><cf_get_lang_main no='90.Bitiş'></th>
                <th style="width:95px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='2903.Paket'><br /><cf_get_lang_main no='3297.Teslim'></th>
                <cfif attributes.list_type eq 2>
                <th style="width:70px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='799.Sipariş No'></th>
                </cfif>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='223.Miktar'></th>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('prod',295)#</cfoutput></th>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1032.Kalan'></th>
             	<cfif attributes.list_type eq 1>
                	<th style="width:70px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='799.Sipariş No'></th>
                    <th style="width:70px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1704.Sipariş Tarihi'></th>
                    <th style="width:70px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='3093.Termin Tarihi'></th>
                    <th style="width:200px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='45.Müşteri'></th>
                <cfelse>
                    <th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" ></th>
                </cfif>
                
                <!-- sil -->
                <th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" >
                	<cfif attributes.list_type eq 1 or attributes.list_type eq 2>
                		<a href="javascript://" onClick="secim(-2);"><img src="../images/print.gif" border="0"></a>
                    </cfif>
                </th>
               	<th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" >
                	<input type="checkbox" alt="<cf_get_lang_main no='3009.Hepsini Seç'>" onClick="secim(-1);">
                </th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_production_orders.recordcount>
                <cfoutput query="get_production_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                	<cfif attributes.list_type eq 2 or attributes.list_type eq 3 or attributes.list_type eq 4 or attributes.list_type eq 5>
						<cfif isdefined('AMOUNT_#IFLOW_P_ORDER_ID#_#PRODUCT_TYPE#_#STOCK_ID#')>
                            <cfset amount_result = Evaluate('AMOUNT_#IFLOW_P_ORDER_ID#_#PRODUCT_TYPE#_#STOCK_ID#')>
                        <cfelse>
                            <cfset amount_result = 0>
                        </cfif>
                    <cfelse>
                    	<cfif isdefined('AMOUNT_#IFLOW_P_ORDER_ID#')>
                        	<cfset amount_result = Evaluate('AMOUNT_#IFLOW_P_ORDER_ID#')>
                        <cfelse>
                        	<cfset amount_result = 0>
                        </cfif>
                    </cfif>
                    <tr>
                        <td style="text-align:right;">#CURRENTROW#</td>
                        <td style="text-align:center;" nowrap>#DateFormat(PLANNING_DATE, 'DD/MM/YYYY')#</td>
                        <td style="text-align:center;">#MASTER_PLAN_NUMBER#</td>
                        <td style="text-align:center;">#P_ORDER_PARTI_NUMBER#</td>
                        <td style="text-align:center;">#LOT_NO#</td>
                        <cfif attributes.list_type eq 1>
                            <td style="text-align:center;">
                                <cfif PRODUCT_TYPE eq 1><cf_get_lang_main no='1099.Takım'>
                                <cfelseif PRODUCT_TYPE eq 2><cf_get_lang_main no='2944.Modül'>
                                <cfelseif PRODUCT_TYPE eq 3><cf_get_lang_main no='2903.Paket'>
                                <cfelseif PRODUCT_TYPE eq 4><cf_get_lang_main no='2848.Parça'>
                                <cfelse><cf_get_lang_main no='3207.Hammadde'>
                                </cfif>
                            </td>
                        <cfelse>
                        	<td style="text-align:center;">
                            	<cfif PIECE_TYPE eq 1>
                                    <img src="/images/butcegider.gif" title="<cf_get_lang_main no='2865.Yonga Levha'>"><span style="display:none">1</span>
                                <cfelseif PIECE_TYPE eq 2>
                                    <img src="/images/arrow_up.png" title="<cf_get_lang_main no='3205.Genel Reçete'>"><span style="display:none">2</span>
                                <cfelseif PIECE_TYPE eq 3>
                                    <img src="/images/elements.gif" title="<cf_get_lang_main no='3206.Montaj Ürünü'>"><span style="display:none">3</span>
                                <cfelseif PIECE_TYPE eq 4>
                                    <img src="/images/promo_multi.gif" title="<cf_get_lang_main no='3207.Hammadde'>"><span style="display:none">4</span>
                                <cfelseif PIECE_TYPE eq 0>
                                	<img src="/images/package.gif" title="<cf_get_lang_main no='2903.Paket'>"><span style="display:none">0</span>
                                </cfif>
                            </td>
                         	<td style="text-align:center;">
                            	<cfif attributes.list_type eq 2>
                            		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#','longpage');" class="tableyazi">
                                    	#P_ORDER_NO#
                                  	</a>
                                <cfelse>
                                	#P_ORDER_NO#
                                </cfif>
                          	</td> 
                            <td style="text-align:center;">#GROUP_LOT_NO#</td>  
                            <td style="text-align:center;">#PACKAGE_NUMBER#</td> 
                        </cfif>
                        <td style="text-align:left;" nowrap="nowrap">#Left(PRODUCT_NAME,80)#<cfif len(PRODUCT_NAME) gt 80>...</cfif></td>
                        <td style="text-align:center;" nowrap>
                        	<cfif len(CUTTING_FINISH_DATE)>
                        		#DateFormat(CUTTING_FINISH_DATE, 'DD/MM/YYYY')# - (#TimeFormat(CUTTING_FINISH_DATE, 'HH:MM')#)
                            </cfif>
                       	</td>
                        <td style="text-align:center;" nowrap>
                        	<cfif len(FINISH_DATE)>
                        		#DateFormat(FINISH_DATE, 'DD/MM/YYYY')# - (#TimeFormat(finish_date, 'HH:MM')#)
                          	</cfif>
                       	</td>
                        <cfif attributes.list_type eq 1>
                            <td style="text-align:right;">#AmountFormat(QUANTITY)#</td>
                            <td style="text-align:right;">#AmountFormat(amount_result)#</td>
                            <td style="text-align:right;">#AmountFormat((QUANTITY)-amount_result)#</td>
                            <td style="text-align:center;" nowrap="nowrap">
                            	<cfif isdefined('ORDER_NUMBER_#ORDER_ID#')>
                                	#Evaluate('ORDER_NUMBER_#ORDER_ID#')#
                                </cfif>
                            </td>
                            <td style="text-align:center;">
                            	<cfif isdefined('ORDER_DATE_#ORDER_ID#')>
                                	#DateFormat(Evaluate('ORDER_DATE_#ORDER_ID#'),'DD/MM/YYYY')#
                                </cfif>
                            </td>
                            <td style="text-align:center;">
                            	<cfif isdefined('DELIVERDATE_#ORDER_ID#')>
                                	#DateFormat(Evaluate('DELIVERDATE_#ORDER_ID#'),'DD/MM/YYYY')#
                                </cfif>
                            </td>
                            <td style="text-align:center;">
                            	<cfif isdefined('UNVAN_#ORDER_ID#')>
                                	#Evaluate('UNVAN_#ORDER_ID#')#
                                </cfif>
                            </td>
                            <!-- sil --> 
                            <td style="text-align:center;">
                                <cfif IS_STAGE eq 4>
                                    <img src="/images/blue_glob.gif" title="<cf_get_lang_main no='3278.Onaylanmadı'>">
                                <cfelseif IS_STAGE eq 0>
                                    <img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                                <cfelseif IS_STAGE eq 1>
                                    <img src="/images/green_glob.gif" title="<cf_get_lang_main no='3201.Başladı'>">
                                <cfelseif IS_STAGE eq 2>
                                    <img src="/images/red_glob.gif" title="<cf_get_lang_main no='3108.Bitti'>">
                                <cfelseif IS_STAGE eq 3>
                                    <img src="/images/grey_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                                </cfif>
                            </td>
                            <!-- sil -->
                        <cfelse>
                        	<td style="text-align:center;" nowrap="nowrap">
                            	<cfif isdefined('ORDER_NUMBER_#IFLOW_P_ORDER_ID#')>
                                	#Evaluate('ORDER_NUMBER_#IFLOW_P_ORDER_ID#')#
                                </cfif>
                            </td>
                        	<td style="text-align:right;">#AmountFormat(QUANTITY)#</td>
                            <td style="text-align:right;">#AmountFormat(AMOUNT)#</td>
                            <td style="text-align:right;">#AmountFormat(QUANTITY-AMOUNT)#</td>
                        	<td style="text-align:center;" nowrap>
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_iflow_production_order_result&p_order_id=#p_order_id#','small');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                            </td>
                            <!-- sil -->
                            <td style="text-align:center;">
                                <cfif AMOUNT eq 0>
                                    <img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                               	<cfelseif QUANTITY-AMOUNT eq 0>
                                    <img src="/images/red_glob.gif" title="<cf_get_lang_main no='3108.Bitti'>">
                                <cfelseif AMOUNT gt 0>
                                    <img src="/images/green_glob.gif" title="<cf_get_lang_main no='3201.Başladı'>">
                                </cfif>
                            </td>
                            
                            <!-- sil -->
                        </cfif>
                        <!-- sil -->
                        <cfif attributes.list_type eq 1>
                        	<td style="text-align:center;"><input type="checkbox" name="select_sub_plan" value="#PRODUCT_TYPE#-#IFLOW_P_ORDER_ID#"></td> 
                       	<cfelse>
                        	<td style="text-align:center; <cfif PRINT_COUNT gt 0>background-color:orange</cfif>">
                            	<cfif attributes.list_type eq 2 or ((attributes.list_type eq 3 or attributes.list_type eq 4 or attributes.list_type eq 5))>
                            		<input type="checkbox" name="select_sub_plan" value="#P_ORDER_ID#">
                              	</cfif>
                          	</td> 
                        </cfif>
                        <!-- sil -->
                    </tr>
                </cfoutput>
              	<tfoot>
                 	<tr>
                     	<td colspan="20" style="height:35px; text-align:right">
                       		<cfif attributes.list_type neq 1 and attributes.list_type neq 2>
                            	<cfif gurup_button eq 0>
                                	<button type="button" name="secim_button" id="secim_button" onclick="secim(-3);" style="width:100px; height:30px; text-align:center;font-size:10px; font-weight:bold">
                                        <img src="/images/action_plus.gif" alt="Gurupla" border="0">&nbsp;<cfoutput>#getLang('prod',502)#</cfoutput>
                                    </button>
                              	<cfelse>
                                	<button type="button" name="secim_button" id="secim_button" onclick="secim(-4);" style="width:100px; height:30px; text-align:center;font-size:10px; font-weight:bold">
                                        <img src="/images/action.gif" alt="<cf_get_lang_main no='3280.Grup Çöz'>" border="0">&nbsp;<cf_get_lang_main no='3280.Grup Çöz'>
                                    </button>
                                </cfif>
                        	<cfelse>
                            	<cfif attributes.list_type eq 2>
                                	<button type="button" name="operation_button" id="operation_button" onclick="secim(-6);" style="width:200px; height:30px; text-align:center;font-size:10px; font-weight:bold">
                                        <img src="/images/action.gif" alt="<cf_get_lang_main no='3426.Operasyon Bilgisi Güncelle'>" border="0">&nbsp;<cf_get_lang_main no='3426.Operasyon Bilgisi Güncelle'>
                                    </button>
                                
                                
                                    <button type="button" name="material_button" id="material_button" onclick="secim(-5);" style="width:100px; height:30px; text-align:center;font-size:10px; font-weight:bold">
                                        <img src="/images/forklift.gif" alt="<cf_get_lang_main no='3247.Malzeme'>" border="0">&nbsp;<cf_get_lang_main no='3247.Malzeme'>
                                    </button>
                                    </cfif>
                        	</cfif>
                    	</td>
               		</tr>
           		</tfoot>
            <cfelse>
                <tr> 
                    <td colspan="20" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	</cf_big_list>
</cfform>  
<cfset adres = url.fuseaction>
<cfif len(attributes.cat) and len(attributes.category_name)>
  <cfset adres = '#adres#&cat=#attributes.cat#&category_name=#attributes.category_name#'>
</cfif>
<cfif isDefined('attributes.company_id') and len(attributes.company_id) and isDefined('attributes.company') and len(attributes.company)>
  <cfset adres = '#adres#&company_id=#attributes.company_id#&company=#attributes.company#'>
</cfif>		
<cfif len(attributes.keyword)>
  <cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
</cfif>
<cfif len(attributes.sort_type)>
	<cfset adres = '#adres#&sort_type=#attributes.sort_type#'>
</cfif>
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&is_form_submitted=1">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		return true;	
	}
	function change_list_type()
	{
		if(document.getElementById('list_type').value == 2)
		{
			document.getElementById('product_type').style.display = 'none';
			document.getElementById('sort_type').style.display = '';
		}
		else if(document.getElementById('list_type').value == 3 || document.getElementById('list_type').value == 4 || document.getElementById('list_type').value == 5)
		{
			document.getElementById('product_type').style.display = 'none';
			document.getElementById('sort_type').style.display = 'none';
		}
		else if(document.getElementById('list_type').value == 1)
		{
			document.getElementById('product_type').style.display = '';
			document.getElementById('sort_type').style.display = '';
		}
	}	
	function secim(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		p_order_id_list = '';
		chck_leng = document.getElementsByName('select_sub_plan').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_sub_plan[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_sub_plan;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					p_order_id_list +=my_objets.value+',';
			}
		}
		p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(p_order_id_list,','))
		{
			if(type == -2)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=286</cfoutput>&action_id='+p_order_id_list,'wide');	
			else if(type == -3)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_production_order_group&gurupla=1&master_plan_id=#attributes.master_plan_id#&list_type=#attributes.list_type#</cfoutput>&p_order_id_list='+p_order_id_list,'small');
			else if(type == -4)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_production_order_group&gurupla=0&master_plan_id=#attributes.master_plan_id#&list_type=#attributes.list_type#</cfoutput>&p_order_id_list='+p_order_id_list,'small');
			else if(type == -5)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_dsp_ezgi_iflow_product_metarial_need&master_plan_id=#attributes.master_plan_id#</cfoutput>&p_order_id_list='+p_order_id_list,'longpage');
			else if(type == -6)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_dsp_ezgi_iflow_product_operation_revision</cfoutput>&p_order_id_list='+p_order_id_list,'wide');
		}
	}
</script>