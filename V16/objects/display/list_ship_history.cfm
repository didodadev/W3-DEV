<cfquery name="GET_SHIP_HISTORY" datasource="#DSN2#">
	SELECT 
    	 SHIP_HISTORY.RECORD_DATE UPDATE_DATE,
         (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=SHIP_HISTORY.RECORD_EMP) AS UPDATE_NAME,* 
    FROM 
    	SHIP_HISTORY 
    WHERE 
    	SHIP_ID = #attributes.ship_id# 
    ORDER BY 
    	RECORD_DATE DESC
</cfquery>
<cfquery name="get_ship_row_history" datasource="#dsn2#">
		SELECT 
       		* 
        FROM 
        	SHIP_ROW_HISTORY,
            #DSN1_ALIAS#.PRODUCT P,
            #DSN1_ALIAS#.STOCKS S 
        WHERE 
            SHIP_ROW_HISTORY.PRODUCT_ID=P.PRODUCT_ID AND
            SHIP_ROW_HISTORY.STOCK_ID=S.STOCK_ID AND
        	SHIP_ID = #attributes.ship_id# 
        ORDER BY 
            SHIP_ROW_HISTORY.STOCK_ID,
            SHIP_ROW_ID
</cfquery>
<cfquery name="GET_LOCATION_NAME" datasource="#DSN#">
	SELECT LOCATION_ID,DEPARTMENT_ID,COMMENT FROM STOCKS_LOCATION
</cfquery>
<cfoutput query="get_ship_history">
	<cfset 'id_#ship_history_id#' = 0>
</cfoutput>
<cfsavecontent variable="title_"><cf_get_lang dictionary_id='57473.Tarihçe'>:</cfsavecontent>
<cf_box title="#title_#"> 
    <cfif get_ship_history.recordcount>
       
        <cfset temp_ = 0>
            <cfset process_catid_list = "">
            <cfset project_id_list = "">
            <cfset department_in_list = "">				
            <cfset department_out_list = "">
            <cfset record_emp_list = "">
            <cfoutput query="get_ship_history">
             
                <cfquery name = "GET_ROW_HISTORY" dbtype="query">
                    SELECT 
                        *
                    FROM 
                        get_ship_row_history
                    WHERE 
                        SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#"> AND 
                        SHIP_HISTORY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_history_id#">
                </cfquery>
            
                <cfif len(process_cat) and not listfind(process_catid_list,process_cat)>
                    <cfset process_catid_list=listappend(process_catid_list,process_cat)>
                </cfif>
                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                    <cfset project_id_list=listappend(project_id_list,project_id)>
                </cfif>
                <cfif len(department_in) and not listfind(department_in_list,department_in)>
                    <cfset department_in_list=listappend(department_in_list,department_in)>
                </cfif>
                <cfif len(deliver_store_id) and not listfind(department_out_list,deliver_store_id)>
                    <cfset department_out_list=listappend(department_out_list,deliver_store_id)>
                </cfif>
                <cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
                    <cfset record_emp_list=listappend(record_emp_list,record_emp)>
                </cfif>
        
            <cfif len(process_catid_list)>
                <cfquery name="get_process_cat" datasource="#dsn3#">
                    SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_catid_list#) ORDER BY PROCESS_CAT_ID
                </cfquery>
                <cfset process_catid_list = listsort(listdeleteduplicates(valuelist(get_process_cat.process_cat_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(project_id_list)>
                <cfquery name="get_project_name" datasource="#dsn#">
                    SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                </cfquery>
                <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(department_in_list)>
                <cfquery name="get_department_in" datasource="#dsn#">
                    SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_in_list#) ORDER BY DEPARTMENT_ID
                </cfquery>
                <cfset department_in_list = listsort(listdeleteduplicates(valuelist(get_department_in.department_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(department_out_list)>
                <cfquery name="get_department_out" datasource="#dsn#">
                    SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_out_list#) ORDER BY DEPARTMENT_ID
                </cfquery>
                <cfset department_out_list = listsort(listdeleteduplicates(valuelist(get_department_out.department_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(record_emp_list)>
                <cfquery name="get_record_name" datasource="#dsn#">
                    SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
                <cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_name.employee_id,',')),'numeric','ASC',',')>
            </cfif>           
            <cfset temp_ = temp_ +1>
            <cfif isDefined("location") and len(location)>
                <cfquery name="get_loc_out" dbtype="query">
                    SELECT * FROM get_location_name WHERE DEPARTMENT_ID = #deliver_store_id# AND LOCATION_ID = #location#
                </cfquery>
            </cfif>
            <cfif isDefined("location_in") and len(location_in)>
                <cfquery name="get_loc_in" dbtype="query">
                    SELECT * FROM get_location_name WHERE DEPARTMENT_ID = #department_in# AND LOCATION_ID = #location_in#
                </cfquery>
            </cfif>
            <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <cf_ajax_list id="history_#temp_#">
                <tbody>	
                    <tr>
                        <td width="100"><b><cf_get_lang dictionary_id ='57800.İşlem Tipi'></b></td>
                        <td width="100">#get_process_cat.process_cat[listfind(process_catid_list,process_cat,',')]#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='58138.İrsaliye No'></b></td>
                        <td width="100">#ship_number#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='57742.Tarih'></b></td>
                        <td width="100">#DateFormat(ship_date,dateformat_style)#</td>
                        <td width="100"><b><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
                            <td width="100">#deliver_emp#</td>
                    </tr>
                    <tr>
                        <td  width="100"><b><cf_get_lang dictionary_id ='34140.Fiili Sevk Tarihi'></b></td>
                        <td width="100">#DateFormat(deliver_date,dateformat_style)#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='34141.Özel Durum'></b></td>
                        <td width="100"><cfif is_ship_iptal eq 1><cf_get_lang dictionary_id='45679.İrsaliye İptal'></cfif><cfif is_delivered eq 1><br/><cf_get_lang dictionary_id='45216.Teslim Al'></b></cfif></td>
                        <td width="100"><b><cf_get_lang dictionary_id='58784.Referans'></td>
                        <td width="100">#ref_no#</td>
                        <td></td>
                        <td></td>              
                    </tr>
                    <tr>
                        <td width="100"><b><cf_get_lang dictionary_id ='57416.Proje'></b></td>
                        <td width="100"><cfif len(project_id)>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                        <td width="100"><b><cf_get_lang dictionary_id='29428.Çıkış Depo'></b></td>                          
                        <td width="100"><cfif len(department_out_list)>#get_department_out.department_head[listfind(department_out_list,deliver_store_id,',')]# - #get_loc_out.comment# </cfif></td>
                        <td width="100"><b><cf_get_lang dictionary_id ='33658.Giriş Depo'></b></td>
                        <td width="100"><cfif len(department_in_list)>#get_department_in.department_head[listfind(department_in_list,department_in,',')]# - #get_loc_in.comment#</cfif></td>
                        <td></td>
                        <td></td>
                    </tr> 
                    <tr>
                        <td width="100"><b><cf_get_lang dictionary_id ='57891.Guncelleyen'></b></td>
                        <td width="100">#get_record_name.employee_name[listfind(record_emp_list,record_emp,',')]# #get_record_name.employee_surname[listfind(record_emp_list,record_emp,',')]#</td>
                        <td width="100"><b><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></b></td>
                        <td width="100">#DateFormat(record_date,dateformat_style)#</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                                          	
                                <cfif GET_ROW_HISTORY.recordcount>
                                    <tr>                
                                        <th width="20"><b><cf_get_lang dictionary_id='57487.No'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='57518.Stok Kodu'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='57657.Ürün'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='57635.Miktar'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='57636.Birim'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='58084.Fiyat'></b></th>
                                        <th width="100"><b><cf_get_lang dictionary_id='57677.Döviz'></b></th>
                                            <th></th>
                                    </tr>        
                                    <cfloop QUERY="GET_ROW_HISTORY">
                                    <tr>                
                                        <td width="20">#currentrow#</td>
                                        <td>#stock_code#</td>
                                        <td>#product_name#</td>
                                        <td>#TLFormat(amount,4)#</td>
                                        <td>#unit#</td>
                                        <td>#TLFormat(price,4)#</td>
                                        <td>#other_money#</td>
                                    </tr>
                                        
                                            <tr class="nohover">
                                                <td height="2" colspan="8"></td>
                                            </tr>
                                        
                                    </cfloop>    
                                </cfif>
                    </tr>
                </tbody>   
        </cf_ajax_list>
    </cfoutput>
        <cfelse>
            <tr>
                <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
            </tr>
    </cfif>
</cf_box>

