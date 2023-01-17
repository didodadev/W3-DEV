<cfif not isdefined("attributes.table_code")>
	<cfset attributes.table_code = attributes.print_table_code>
</cfif>

<cfparam name="attributes.print_note" default="">
<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<cfoutput query="get_price_types">
	<cfset 'j_price_type_#TYPE_ID#' = '#TYPE_code#'>
</cfoutput>


<cfquery name="get_search_layouts" datasource="#dsn_dev#">
SELECT
    LAYOUT_ID,
    LAYOUT_NAME
FROM
    SEARCH_TABLES_LAYOUTS_NEW
ORDER BY
   	LAYOUT_NAME
</cfquery>

<cfif isdefined("session.ep.userid")>
    <cfquery name="get_user_layout" datasource="#dsn_dev#">
        SELECT LAYOUT_ID FROM SEARCH_TABLES_LAYOUTS_USERS WHERE USER_ID = #session.ep.userid#
    </cfquery>
    <cfif get_user_layout.recordcount>
        <cfset layout_ = get_user_layout.LAYOUT_ID>
    <cfelse>
        <cfset layout_ = ''>
    </cfif>
<cfelse>
	<cfset layout_ = ''>
</cfif>

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
        ISNULL(D.IS_PRODUCTION,0) = 0 
        <cfif isdefined("session.ep.userid")>
        AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
        </cfif>
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>


<cfif not isdefined("attributes.layout_id")>
	<cfset attributes.company_id = "">
    <cfset attributes.project_id = "">
    
    <cfset new_basket = DeserializeJSON(attributes.print_note)>
    <cfset eleman_sayisi = arraylen(new_basket)>
    
    <cfif eleman_sayisi gt 0>
    	<cfset comp_code_ = new_basket[1].company_code>
        
        <cfif len(comp_code_)>
            <cfset attributes.company_id = listfirst(comp_code_,'_')>
            <cfset attributes.project_id = listlast(comp_code_,'_')>
        <cfelse>
            <cfset attributes.company_id = ''>
            <cfset attributes.project_id = ''>
        </cfif>
    <cfelse>
    	Yazdırılacak Satır Bulunamadı!
        <cfexit method="exittemplate">
    </cfif>
	
    <cf_box>
    <cfform name="print_page" action="#request.self#?fuseaction=retail.popup_print_speed_manage_product" method="post">
    <textarea name="print_note" id="print_note" style="display:none;"><cfoutput>#attributes.print_note#</cfoutput></textarea>
    <textarea name="row_list" id="row_list" style="display:none;"><cfoutput>#listdeleteduplicates(attributes.row_list)#</cfoutput></textarea>
    <cfinput type="hidden" value="#attributes.table_code#" name="table_code" style="width:55px;" readonly="yes">
        <table width="100%">
            <tr>
                <td style="text-align:right;">
                    <select name="layout_id">
						<cfoutput query="get_search_layouts">
                            <option value="#layout_id#" <cfif layout_ eq layout_id>selected</cfif>>#layout_name#</option>
                        </cfoutput>
                    </select>
                    <select name="print_type">
						<option value="print">Yazdır</option>
                        <option value="excel">Excel Al</option>
                    </select>
                    <input type="submit" value="Çalıştır"/>
                </td>
            </tr>
        </table>
        

        <cfif len(attributes.company_id)>
            <cfquery name="get_rows" datasource="#dsn_dev#">
                SELECT
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    PR.*,
                    STPT.TYPE_NAME,
                    D.DEPARTMENT_HEAD,
                    ISNULL(COST_PAID,0) AS ODENEN
                FROM
                    #dsn_alias#.EMPLOYEES E,
                    #dsn_alias#.DEPARTMENT D,
                    SEARCH_TABLE_PROCESS_TYPES STPT,
                    PROCESS_ROWS PR
                WHERE
                    <cfif len(attributes.project_id)>
                        ISNULL(PR.PROJECT_ID,0) = #listfirst(attributes.project_id)# AND
                    </cfif>
                    PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    PR.COMPANY_ID IN (#attributes.company_id#) AND
                    PR.RECORD_EMP = E.EMPLOYEE_ID AND
                    STPT.TYPE_ID = PR.PROCESS_TYPE AND
                    PR.COST IS NOT NULL AND
                    PR.COST > 0
               ORDER BY
               		PR.RECORD_DATE DESC,
                    PR.COST_PAID ASC,
                    PR.PROCESS_STARTDATE ASC,
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
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(dateadd("h",session.ep.time_zone,record_date),'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#DEPARTMENT_HEAD#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#TYPE_NAME#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#PROCESS_DETAIL#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#QUANTITY#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#period#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#dateformat(PAID_DATE,'dd/mm/yyyy')#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#tlformat(COST)#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>#tax#</td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>>
                        <cfset paid_ = ODENEN>
                        #tlformat(paid_)#
                        </td>
                        <td <cfif ODENEN gt 0>style="color:red;"</cfif>><cfif len(COST)>#tlformat(COST - paid_)#</cfif></td>
                        <td><input type="checkbox" name="process_row_ids" value="#ROW_ID#"/></td>
                    </tr>
                    </cfoutput>
                    </tbody>
            </cf_medium_list>
        </cfif>
    </cfform>
    </cf_box>
<cfelse>
	<cfset new_basket = DeserializeJSON(attributes.print_note)>
	<cfquery name="get_headers_all" datasource="#dsn_dev#">
        SELECT  
            *,
            (ROW_ID - 1)  AS KOLON_SIRA,
            1 AS KOLON_SHOW
        FROM 
            SEARCH_TABLES_COLOUMS 
        ORDER BY 
            KOLON_SIRA ASC
    </cfquery>
    
    <cfif len(attributes.layout_id)>
        <cfquery name="get_layout_info" datasource="#dsn_dev#">
            SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW WHERE LAYOUT_ID = #attributes.layout_id#
        </cfquery>
        <cfif get_layout_info.recordcount and len(get_layout_info.sort_list)>
                <cfset sort_list = get_layout_info.sort_list>
                
                <cfoutput query="get_headers_all">
                    <cfset sira_ = row_id>
    
                    <cfif sira_ lte listlen(sort_list)>
                        <cfset ozellik_ = listgetat(sort_list,sira_)>
                        
                        <cfset row_sira_ = listgetat(ozellik_,2,'*')>
                        <cfset row_show_ = listgetat(ozellik_,3,'*')>
                        <cfset querysetcell(get_headers_all,'KOLON_SIRA',row_sira_,currentrow)>
                        
                        <cfif row_show_ is 'hide'>
                            <cfset querysetcell(get_headers_all,'KOLON_SHOW','0',currentrow)>
                        <cfelse>
                            <cfset querysetcell(get_headers_all,'KOLON_SHOW','1',currentrow)>
                        </cfif>
                    </cfif>
                </cfoutput>
        </cfif>
    </cfif>
    
    <cfquery name="get_headers" dbtype="query">
        SELECT * FROM get_headers_all ORDER BY KOLON_SIRA ASC
    </cfquery>
<style>
	@media print{@page {size: landscape}}
</style> 

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
</cfif>

<cfsavecontent variable="print_icerik">  
<style>
	table{font-size:10px;};
	table tr{font-size:10px;};
	table tr td{font-size:10px;};
</style>
    <cfoutput>
    <table width="99%" align="center">
        <tr>
            <td style="font-size:15px; font-weight:bold;">#market_name# Satınalma Sözleşmesi Dökümü</td>
            <td style="text-align:right;">Düzenleme Tarihi : #dateformat(now(),'dd/mm/yyyy')#</td>
        </tr>
        <tr>
            <td colspan="2"><hr /></td>
        </tr>
        <tr>
            <td style="font-size:12px; font-weight:bold;"><i>Satnalma Yapan Firma</i> : <cfif isdefined("session.ep.COMPANY")>#session.ep.COMPANY#<cfelse>#session.pp.our_name#</cfif></td>
            <td style="text-align:right;">&nbsp;</td>
        </tr>
        <tr>
            <td style="font-size:12px; font-weight:bold;"><i>Satıcı Firma</i> : #new_basket[1].company_name#</td>
            <td style="text-align:right;">
            <cfif isdefined("attributes.table_code") and len(attributes.table_code)>
                <table align="right">
                    <tr>
                        <td class="formbold" style="font-size:12px;">Sirkü No:</td>
                        <td width="100" style="font-size:12px;">#attributes.table_code#</td>
                        <td class="formbold" style="font-size:12px;">Haz. Tarihi:</td>
                        <td width="100" style="font-size:12px;">#dateformat(get_table.ISLEM_TARIHI,'dd/mm/yyyy')#</td>
                        <td class="formbold" style="font-size:12px;">Hazırlayan :</td>
                        <td width="100" style="font-size:12px;">#get_emp_info(get_table.ISLEM_YAPAN,0,0)#</td>
                    </tr>
                </table>
            <cfelse>
            	<table align="right">
                    <tr>
                        <td class="formbold" style="font-size:12px;">Sirkü No:</td>
                        <td width="100" style="font-size:12px;">.....</td>
                        <td class="formbold" style="font-size:12px;">Haz. Tarihi:</td>
                        <td width="100" style="font-size:12px;">#dateformat(now(),'dd/mm/yyyy')#</td>
                        <td class="formbold" style="font-size:12px;">Hazırlayan :</td>
                        <td width="100" style="font-size:12px;"><cfif isdefined("session.ep.userid")>#get_emp_info(session.ep.userid,0,0)#<cfelse>#session.pp.name# #session.pp.surname#</cfif></td>
                    </tr>
                </table>
            </cfif>
            </td>
        </tr>
    </table>
    </cfoutput>
    <br />
    <table cellpadding="2" cellspacing="0" border="1" width="99%">
    	<tr>
        	<cfoutput query="get_headers">
				<cfif KOLON_SHOW eq 1><td>#kolon_ozelad#</td></cfif>
			</cfoutput>
        </tr>
        <cfloop from="1" to="#arraylen(new_basket)#" index="ccc">
        <cfif listfind(attributes.row_list,(ccc-1))>
        <tr>
        	<cfoutput query="get_headers">
            	<cfif KOLON_SHOW eq 1 and kolon_ad is not 'stok_yeterlilik_suresi_order'>
                <td style='<cfif len(kolon_format) and listfind('c2,p',kolon_format)>text-align:right;<cfelse>mso-number-format:"\@"</cfif>'>
					<cfset deger_ = evaluate("new_basket[#ccc#].#kolon_ad#")>
					<cfif kolon_format is 'c2'> 
                        <cfif len(deger_)>#tlformat(deger_)#</cfif>
                    <cfelseif kolon_format is 'p'>
                    	<cfif len(deger_)>% #tlformat(deger_)#</cfif>
					<cfelseif kolon_format is 'dd/MM/yyyy'>
                    	<cfset deger_ = evaluate("new_basket[#ccc#].#kolon_ad#")>
						
						<cfif len(deger_) and deger_ is not 'null' and len(deger_) gt 10>
                        	<cfset tarih_ = createodbcdatetime(createdate(listgetat(deger_,1,'-'),listgetat(deger_,2,'-'),left(listgetat(deger_,3,'-'),2)))>
							<cfif not deger_ contains 'T00:00'>
                                <cfset tarih_ = dateadd('d',1,tarih_)>
                            </cfif>
                            #dateformat(tarih_,'dd/mm/yyyy')#
                        <cfelseif len(deger_) and deger_ is not 'null'>
                        	#deger_#
                        </cfif>                        
                    <cfelseif kolon_filtre_tipi is 'bool'>
                    	<cfif deger_ is 'YES'>E<cfelse>H</cfif>
                    <cfelse>
                        <cfif kolon_ad contains 'price_type'>
                        	<cfif len(new_basket[ccc].price_type_id)>
                            	#evaluate("j_price_type_#new_basket[ccc].price_type_id#")#
                            </cfif>
                        <cfelse>
                        	#deger_#
                        </cfif>
                    </cfif>
                </td>
                </cfif>
            </cfoutput>
        </tr>
        </cfif>
        </cfloop>
    </table>
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