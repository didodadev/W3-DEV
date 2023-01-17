<cfquery name="get_search_layouts" datasource="#dsn_dev#">
SELECT
    LAYOUT_ID,
    LAYOUT_NAME
FROM
    SEARCH_TABLES_LAYOUTS
ORDER BY
   	LAYOUT_NAME
</cfquery>
<cfparam name="attributes.search_department_id" default="">


<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfif not isdefined("attributes.layout_id")>
    <cfset attributes.company_id = "">
    <cfset attributes.project_id = "">
    
    <cfquery name="get_comp_id" datasource="#dsn_dev#">
        SELECT TOP 1 ATT_VALUE FROM SEARCH_TABLES_ROWS WHERE (ATT_NAME LIKE '%company_id%' OR ATT_NAME LIKE '%COMPANY_ID%') AND ATT_VALUE <> '' AND TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfquery name="get_project_id" datasource="#dsn_dev#">
        SELECT TOP 1 ATT_VALUE FROM SEARCH_TABLES_ROWS WHERE (ATT_NAME LIKE '%project_id%' OR ATT_NAME LIKE '%PROJECT_ID%') AND ATT_VALUE <> ''  AND TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    
    <cfif get_comp_id.recordcount><cfset attributes.company_id = get_comp_id.ATT_VALUE></cfif>
    <cfif get_project_id.recordcount><cfset attributes.project_id = get_project_id.ATT_VALUE></cfif>
    
    <cfif attributes.table_code is '00000291'>
    	<cfset attributes.company_id = 72>
    </cfif>
    
    <cf_box>
    <cfform name="print_page" action="#request.self#?fuseaction=retail.popup_print_layout" method="post">
    <cfinput type="hidden" name="search_startdate" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#">
    <cfinput type="hidden" name="search_finishdate" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#">
    <cfinput type="hidden" name="in_table_product_list" value="#attributes.product_list#">
        <table width="100%">
            <tr>
                <td style="text-align:right;">
                    Tablo Kodu
                    <cfinput type="text" value="#attributes.table_code#" name="table_code" style="width:55px;" readonly="yes">
                    	<cf_multiselect_check 
                            query_name="get_departments_search"  
                            name="search_department_id"
                            option_text="Departman" 
                            width="180"
                            option_name="department_head" 
                            option_value="department_id"
                            value="#attributes.search_department_id#">
                    <select name="layout_id">
                        <option value="">Görünüm Seçiniz</option>
						<cfoutput query="get_search_layouts">
                            <option value="#layout_id#">#layout_name#</option>
                        </cfoutput>
                    </select>
                    <select name="print_type">
						<option value="print">Yazdır</option>
                        <option value="excel">Excel Al</option>
                    </select>
                    <select name="order_type">
						<option value="0">Hepsi</option>
                        <option value="1">Siparişi Olanlar</option>
                    </select>
                    <input type="submit" value="Çalıştır"/>
                </td>
            </tr>
        </table>
        
        <br />
        <cfquery name="get_fiyatlar" datasource="#dsn_dev#">
        	SELECT 
            	DISTINCT TOP 20 
                	ACTION_CODE,
                    STARTDATE,
                    FINISHDATE,
                    P_STARTDATE,
                    P_FINISHDATE,
                    (SELECT PTY.TYPE_CODE FROM PRICE_TYPES PTY WHERE PTY.TYPE_ID = PRICE_TYPE) AS FIYAT_TIPI
            FROM
            	PRICE_TABLE
            WHERE
            	TABLE_CODE = '#ATTRIBUTES.TABLE_CODE#' AND
                PRODUCT_ID IN (#attributes.product_list#)
            ORDER BY
            	STARTDATE DESC
        </cfquery>
        <cf_medium_list>
        	<thead>
            	<tr>
                	<th><input type="radio" name="action_code" value="0"/>Tüm Kodlar</th>
                    <th>Fiyat Tipi</th>
                    <th>Satış Başlangıç</th>
                    <th>Satış Bitiş</th>
                    <th>Alış Başlangıç</th>
                    <th>Alış Bitiş</th>
                </tr>            
            </thead>
            <tbody>
            	<cfoutput query="get_fiyatlar">
                <tr>
                	<td><input type="radio" name="action_code" value="#ACTION_CODE#" <cfif currentrow eq 1>checked</cfif>/>&nbsp;&nbsp;#ACTION_CODE#</td>
                    <td>#FIYAT_TIPI#</td>
                    <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(P_STARTDATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(P_FINISHDATE,'dd/mm/yyyy')#</td>
                </tr>
                </cfoutput>
            </tbody>
        </cf_medium_list>
        <br />
        <cfif len(attributes.company_id)>
            <cfquery name="get_rows" datasource="#dsn_dev#">
                SELECT
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    PR.*,
                    STPT.TYPE_NAME,
                    D.DEPARTMENT_HEAD
                FROM
                    #dsn_alias#.EMPLOYEES E,
                    #dsn_alias#.DEPARTMENT D,
                    SEARCH_TABLE_PROCESS_TYPES STPT,
                    PROCESS_ROWS PR
                WHERE
                    <cfif len(attributes.project_id)>
                        PR.PROJECT_ID = #listfirst(attributes.project_id)# AND
                    </cfif>
                    PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    PR.COMPANY_ID IN (#attributes.company_id#) AND
                    PR.RECORD_EMP = E.EMPLOYEE_ID AND
                    STPT.TYPE_ID = PR.PROCESS_TYPE AND
                    PR.COST IS NOT NULL AND
                    PR.COST > 0
               ORDER BY
                    PR.PROCESS_STARTDATE,
                    D.DEPARTMENT_HEAD
            </cfquery>

            <cf_medium_list id="manage_table">
                <thead>
                    <tr>
                        <th>Sıra</th>
                        <th>Kayıt</th>
                        <th>Mağaza</th>
                        <th>Uygulama Tipi</th>
                        <th>Açıklama</th>
                        <th>Adet</th>
                        <th>Dönem</th>
                        <th>Uyg. Başlangıç</th>
                        <th>Uyg. Bitiş</th>
                        <th>Yapılış</th>
                        <th>Bitiş</th>
                        <th>Ödeme T.</th>
                        <th>Ödendiği T.</th>
                        <th>Fiyat</th>
                        <th>KDV</th>
                        <th>Ödeme</th>
                        <th>Bakiye</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_rows">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#dateformat(dateadd("h",session.ep.time_zone,record_date),'dd/mm/yyyy')#</td>
                        <td>#DEPARTMENT_HEAD#</td>
                        <td>#TYPE_NAME#</td>
                        <td>#PROCESS_DETAIL#</td>
                        <td>#QUANTITY#</td>
                        <td>#period#</td>
                        <td>#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PAID_DATE,'dd/mm/yyyy')#</td>
                        <td>#tlformat(COST)#</td>
                        <td>#tax#</td>
                        <td>
                        <cfset paid_ = 0>
                        #tlformat(paid_)#
                        </td>
                        <td><cfif len(COST)>#tlformat(COST - paid_)#</cfif></td>
                        <td><input type="checkbox" name="process_row_ids" value="#ROW_ID#"/></td>
                    </tr>
                    </cfoutput>
                    </tbody>
            </cf_medium_list>
        </cfif>
    </cfform>
    </cf_box>
<cfelse>

<br />
<br />
<cfif isdefined("attributes.table_code")>
    <cfquery name="get_table" datasource="#dsn_dev#">
    	SELECT
        	TABLE_INFO,
            TABLE_ID
        FROM
        	SEARCH_TABLES
        WHERE
        	TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfset attributes.table_info = get_table.TABLE_INFO>
    <cfset attributes.table_id = get_table.TABLE_ID>
</cfif>
<cfset is_purchase_type = 0> 
<cfparam name="attributes.gun" default="30">
<cfparam name="attributes.gun2" default="60">
<cfparam name="attributes.add_stock_gun" default="15">
<cfquery name="get_departments" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
        <cfif len(attributes.search_department_id)>
        	AND D.DEPARTMENT_ID IN (#attributes.search_department_id#)
        </cfif>
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	TYPE_ID ASC
</cfquery>
<cfinclude template="../form/coloum_positions.cfm">



<cfif isdefined("attributes.ACTION_CODE") and len(attributes.ACTION_CODE)>
     <cfif attributes.action_code eq 0>
     	<cfquery name="get_rows" datasource="#dsn_dev#">
        	SELECT * FROM SEARCH_TABLES_PRODUCTS WHERE TABLE_ID = #attributes.table_id#
        </cfquery>
        <cfset attributes.in_table_product_list = listdeleteduplicates(valuelist(get_rows.product_id))>
     <cfelse>
        <cfquery name="get_price_all" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                PRICE_TABLE
            WHERE
                ACTION_CODE = '#attributes.ACTION_CODE#'
        </cfquery>
        <cfif get_price_all.recordcount>
            <cfset attributes.in_table_product_list = listdeleteduplicates(valuelist(get_price_all.product_id))>
        </cfif>
     </cfif>
</cfif>

<cfinclude template="../query/get_products.cfm">

<cfquery name="get_stocks_only" dbtype="query">
	SELECT DISTINCT STOCK_ID FROM get_products ORDER BY PRODUCT_NAME
</cfquery>
<cfset dept_count_ = listlen(listdeleteduplicates(valuelist(get_departments.department_id)))>
	<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
        <cfquery name="get_table" datasource="#dsn_dev#">
            SELECT
                TABLE_INFO,
                ISNULL(UPDATE_DATE,RECORD_DATE) ISLEM_TARIHI,
                ISNULL(UPDATE_EMP,RECORD_EMP) ISLEM_YAPAN
            FROM
                SEARCH_TABLES
            WHERE
                TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfset attributes.table_info = get_table.TABLE_INFO>
        <cfquery name="get_table_info_sql" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                SEARCH_TABLES_ROWS
            WHERE
                TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfoutput query="get_table_info_sql">
            <cfset 'get_table_info.#att_name#' = "#att_value#">
        </cfoutput>
    </cfif>

<style>
	@media print{@page {size: landscape}}
</style>

    <cfsavecontent variable="print_icerik">
	<cfset attributes.print_action = 1>
    	<cfquery name="get_comp_name" dbtype="query" maxrows="1">
        	SELECT ATT_VALUE FROM get_table_info_sql WHERE ATT_NAME LIKE '%company_name%' OR ATT_NAME LIKE '%COMPANY_NAME%'
        </cfquery>
        
        <cfif isdefined("attributes.table_code") and len(attributes.table_code)>
			<cfoutput>
            <table width="99%" align="center">
                <tr>
                    <td style="font-size:15px; font-weight:bold;">Satınalma Sözleşmesi Dökümü</td>
                    <td style="text-align:right;">Düzenleme Tarihi : #dateformat(now(),'dd/mm/yyyy')#</td>
                </tr>
                <tr>
                    <td colspan="2"><hr /></td>
                </tr>
                <tr>
                    <td style="font-size:12px; font-weight:bold;"><cfif get_comp_name.recordcount>#get_comp_name.ATT_VALUE#</cfif></td>
                    <td style="text-align:right;">
                        <table align="right">
                            <tr>
                                <td class="formbold">Sirkü No:</td>
                                <td width="100">#attributes.table_code#</td>
                                <td class="formbold">Haz. Tarihi:</td>
                                <td width="100">#dateformat(get_table.ISLEM_TARIHI,'dd/mm/yyyy')#</td>
                                <td class="formbold">Hazırlayan :</td>
                                <td width="100">#get_emp_info(get_table.ISLEM_YAPAN,0,0)#</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </cfoutput>
            <br />
        </cfif>
        <cfinclude template="../form/speed_manage_product_table.cfm">
        <br />
        <cfif isdefined("attributes.process_row_ids")>
        	<cfquery name="get_rows" datasource="#dsn_dev#">
                SELECT
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    PR.*,
                    STPT.TYPE_NAME,
                    D.DEPARTMENT_HEAD
                FROM
                    #dsn_alias#.EMPLOYEES E,
                    #dsn_alias#.DEPARTMENT D,
                    SEARCH_TABLE_PROCESS_TYPES STPT,
                    PROCESS_ROWS PR
                WHERE
                	PR.ROW_ID IN (#attributes.process_row_ids#) AND
                    PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    PR.RECORD_EMP = E.EMPLOYEE_ID AND
                    STPT.TYPE_ID = PR.PROCESS_TYPE
               ORDER BY
                    PR.PROCESS_STARTDATE,
                    D.DEPARTMENT_HEAD
            </cfquery>

            <table id="manage_table" cellpadding="2" cellspacing="1" style="background:#99F;">
                <thead>
                   <tr class="color-header" id="manage_table_header">
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Sıra</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Kayıt</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Mağaza</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Uygulama Tipi</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Açıklama</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Adet</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Dönem</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Yapılış</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Bitiş</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Ödeme T.</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Fiyat</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">KDV</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Ödeme</th>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :#000000; height:20px;">Bakiye</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_rows">
                    <tr class="color-list">
                        <td>#currentrow#</td>
                        <td>#dateformat(dateadd("h",session.ep.time_zone,record_date),'dd/mm/yyyy')#</td>
                        <td>#DEPARTMENT_HEAD#</td>
                        <td>#TYPE_NAME#</td>
                        <td>#PROCESS_DETAIL#</td>
                        <td>#QUANTITY#</td>
                        <td>#period#</td>
                        <td>#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
                        <td>#tlformat(COST)#</td>
                        <td>#tax#</td>
                        <td>
                        <cfset paid_ = 0>
                        #tlformat(paid_)#
                        </td>
                        <td>#tlformat(COST - paid_)#</td>
                    </tr>
                    </cfoutput>
                    </tbody>
            </table>
        </cfif>
    </cfsavecontent>
	<cfif attributes.print_type is 'print'>
        <cfdocument format="pdf" marginleft="0" marginbottom="0" margintop="0" marginright="0" pagetype="a4" orientation="landscape" scale="85">
			<cfoutput>#print_icerik#</cfoutput>	
        </cfdocument>
		<script>
			//window.print();
		</script>
    <cfelse>
    		<!--- kirli dosya oluşmasın diye --->
    		<cfif isdefined("session.ep.userid")>
				<cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')##session.ep.userid#">
            <cfelse>
                <cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
            </cfif>	
            <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
            <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
                <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
            </cfif>
            <cfdirectory action="list" name="get_ds" directory="#upload_folder#reserve_files">
            <cfif get_ds.recordcount>
                <cfoutput query="get_ds">
                    <cfif type is 'dir' and name is not drc_name_>
                        <cftry>
                            <cfset d_name_ = name>
                            <cfdirectory action="list" name="get_ds_ic" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                                <cfif get_ds_ic.recordcount>
                                    <cfloop query="get_ds_ic">
                                        <cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##d_name_##dir_seperator##get_ds_ic.name#">
                                    </cfloop>
                                </cfif>
                            <cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                        <cfcatch></cfcatch>
                        </cftry>
                    </cfif>
                </cfoutput>
            </cfif>
            <!--- kirli dosya oluşmasın diye --->
            <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.xls" output="#print_icerik#" charset="utf-16"/>
            
            <script type="text/javascript">
				get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1934.Excel'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.xls</cfoutput>");
			</script>
    </cfif>
</cfif>