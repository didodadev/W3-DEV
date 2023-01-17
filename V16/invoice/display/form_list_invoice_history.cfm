<cfquery name="GET_INVOICE_HISTORY" datasource="#DSN2#">
	SELECT 
    	 INVOICE_HISTORY.UPDATE_DATE,
         (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=INVOICE_HISTORY.UPDATE_EMP) AS UPDATE_NAME,* 
    FROM 
    	INVOICE_HISTORY 
    WHERE 
    	INVOICE_ID = #attributes.act_id# AND INVOICE_HISTORY.UPDATE_DATE IS NOT NULL
    ORDER BY 
    INVOICE_HISTORY.UPDATE_DATE DESC
</cfquery>
<cfquery name="get_invoice_row_history" datasource="#dsn2#">
		SELECT 
       		* 
        FROM 
        	INVOICE_ROW_HISTORY,
            #DSN1_ALIAS#.PRODUCT P,
            #DSN1_ALIAS#.STOCKS S 
        WHERE 
            INVOICE_ROW_HISTORY.PRODUCT_ID=P.PRODUCT_ID AND
            INVOICE_ROW_HISTORY.STOCK_ID=S.STOCK_ID AND
        	INVOICE_ID = #attributes.act_id# 
        ORDER BY 
            INVOICE_ROW_HISTORY.STOCK_ID,
            INVOICE_ROW_ID
</cfquery>
<cfquery name="GET_LOCATION_NAME" datasource="#DSN#">
	SELECT LOCATION_ID,DEPARTMENT_ID,COMMENT FROM STOCKS_LOCATION
</cfquery>
<cfoutput query="get_invoice_history">
	<cfset 'id_#invoice_history_id#' = 0>
</cfoutput>
    <cfif get_invoice_history.recordcount>
       
        <cfset temp_ = 0>
            <cfset process_catid_list = "">
            <cfset project_id_list = "">
            <cfset department_in_list = "">	
            <cfset record_emp_list = "">
            <cfoutput query="get_invoice_history">
             
                <cfquery name = "GET_ROW_HISTORY" dbtype="query">
                    SELECT 
                        *
                    FROM 
                        get_invoice_row_history
                    WHERE 
                        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#"> 
                </cfquery>
            
                <cfif len(process_cat) and not listfind(process_catid_list,process_cat)>
                    <cfset process_catid_list=listappend(process_catid_list,process_cat)>
                </cfif>
                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                    <cfset project_id_list=listappend(project_id_list,project_id)>
                </cfif>
                <cfif len(department_id) and not listfind(department_in_list,department_id)>
                    <cfset department_in_list=listappend(department_in_list,department_id)>
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
            <cfif len(record_emp_list)>
                <cfquery name="get_record_name" datasource="#dsn#">
                    SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
                <cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_name.employee_id,',')),'numeric','ASC',',')>
            </cfif>           
            <cfset temp_ = temp_ +1>
                <cfquery name="get_loc_out" dbtype="query">
                    SELECT * FROM get_location_name WHERE DEPARTMENT_ID = #department_id# AND LOCATION_ID = #department_location#
                </cfquery>
            <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <div id="history_#temp_#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'> :</label>
                            <div class="col col-8 col-sm-12">
                                #get_process_cat.process_cat[listfind(process_catid_list,process_cat,',')]#
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57637.Serial No'> :</label>
                            <div class="col col-8 col-sm-12">
                                #serial_number#-#serial_no#
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58759.Fatura Tarih'> :</label>
                            <div class="col col-8 col-sm-12">
                                #DateFormat(invoice_date,dateformat_style)#
                            </div>                
                        </div> 
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'> :</label>
                            <div class="col col-8 col-sm-12">
                                #DateFormat(process_date,dateformat_style)#
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58784.Referans'> :</label>
                            <div class="col col-8 col-sm-12">
                                #ref_no#
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> :</label>
                            <div class="col col-8 col-sm-12">
                                #get_emp_info(deliver_emp,0,0)#
                            </div>                
                        </div> 
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57416.Proje'> :</label>
                            <div class="col col-8 col-sm-12">
                                <cfif len(project_id)>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#</cfif>
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58763.Depo'> :</label>
                            <div class="col col-8 col-sm-12">
                                <cfif len(department_in_list)>#get_loc_out.comment#</cfif>
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57899.Kaydeden'> :</label>
                            <div class="col col-8 col-sm-12">
                                #get_record_name.employee_name[listfind(record_emp_list,record_emp,',')]# #get_record_name.employee_surname[listfind(record_emp_list,record_emp,',')]#
                            </div>                
                        </div> 
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'> :</label>
                            <div class="col col-8 col-sm-12">
                                #DateFormat(record_date,dateformat_style)#
                            </div>                
                        </div> 
                    </div>
                </cf_box_elements>
                <cf_grid_list>
                    <cfif GET_ROW_HISTORY.recordcount>
                        <thead>   
                            <tr>            
                                <th width="20"><b><cf_get_lang dictionary_id='57487.No'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='57636.Birim'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='54859.Toplam Tutar'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='51316.KDVli Toplam Tutar'></th>
                                <th width="100"><b><cf_get_lang dictionary_id='57677.Döviz'></th>
                                <th></th>
                            </tr> 
                        </thead>        
                        <cfloop QUERY="GET_ROW_HISTORY">
                            <tbody>
                                <tr>                
                                    <td>#currentrow#</td>
                                    <td>#stock_code#</td>
                                    <td>#product_name#</td>
                                    <td class="text-right">#TLFormat(amount,2)#</td>
                                    <td>#unit#</td>
                                    <td class="text-right">#TLFormat(taxtotal,2)#</td>
                                    <td class="text-right">#TLFormat(nettotal,2)#</td>
                                    <td class="text-right">#TLFormat(grosstotal,2)#</td>
                                    <td>#other_money#</td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </cfloop>    
                    </cfif>
                </cf_grid_list>
            </div>
    </cfoutput>
        <cfelse>
            <tr>
                <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
            </tr>
        </cfif>

