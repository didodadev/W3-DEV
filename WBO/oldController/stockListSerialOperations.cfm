<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cfparam name="attributes.process_id" default="">
    <cfparam name="attributes.process_number" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.employee" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.serial_no" default="">
    <cfparam name="attributes.lot_no" default="">
    <cfparam name="attributes.belge_no" default="">
    <cfparam name="attributes.group" default="">
    <cfparam name="attributes.date1" default="">
    <cfparam name="attributes.date2" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfif not isdefined("attributes.invoice_number") and not isdefined("url.service_id")>
        <cfparam name="attributes.process_cat_id" default="">
    <cfelse>
        <cfparam name="attributes.process_cat_id" default="">
    </cfif>
    <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
        <cf_date tarih="attributes.date2">
    <cfelse>
    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
        <cfset attributes.date2=''>
        <cfelse>
        <cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
    </cfif>
    </cfif>
    <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
        <cf_date tarih="attributes.date1">
    <cfelse>
    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
    <cfset attributes.date1=''>
    <cfelse>
        <cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
    </cfif>
    </cfif>
    <cfif isdefined("attributes.is_filtre")>
        <cfinclude template="../stock/query/get_serial_row_list.cfm">
    <cfelse>
        <cfset get_serial_row_list.recordcount = 0>
    </cfif>
    <cfset adres="&is_filtre=1">
    <cfif len(attributes.lot_no)>
        <cfset adres = "#adres#&lot_no=#attributes.lot_no#">
    </cfif>
    <cfif len(attributes.process_cat_id)>
        <cfset adres = "#adres#&process_cat_id=#attributes.process_cat_id#">
    </cfif>
    <cfif len(attributes.belge_no)>
        <cfset adres = "#adres#&belge_no=#attributes.belge_no#">
    </cfif>	
    <cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
        <cfset adres = "#adres#&invoice_number=#attributes.invoice_number#">
    </cfif>			
    <cfif isdate(attributes.date1)>
        <cfset adres = "#adres#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.date2)>
        <cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
    </cfif>
    <cfif len(attributes.company_id) and len(attributes.company)>
        <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
    <cfelseif len(attributes.consumer_id) and len(attributes.company)>
        <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
    </cfif>
    <cfif len(attributes.employee_id) and len(attributes.employee)>
        <cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
    </cfif>
    <cfif len(attributes.stock_id) and len(attributes.product_name)>
        <cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_name=#attributes.product_name#">
    </cfif>
    <cfif len(attributes.department_id) and len(attributes.department_name)>
        <cfset adres = "#adres#&department_id=#attributes.department_id#&department_name=#attributes.department_name#">
    </cfif>
    <cfif len(attributes.location_id) and len(attributes.department_name)>
        <cfset adres = "#adres#&location_id=#attributes.location_id#">
    </cfif>
    <cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
        <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_serial_row_list.recordCount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'addOther')>
    <cf_get_lang_set module_name='objects'>
	<cfif isDefined('session.ep')>
        <cf_xml_page_edit fuseact="objects.popup_upd_stock_serialno">
    </cfif>
    <cfset kontrol_seri_no = 1>
    <cfinclude template="../objects/query/get_product_name.cfm">
    <cfif product_name.recordcount eq 0>
        <script>
            alert("Seçilen Ürün İçin Seri No Takibi Yapılmamaktadır !");
            window.close();
        </script>
    </cfif>
    <cfinclude template="../objects/query/get_serial_info.cfm">
    <cfif not isdefined("attributes.recorded_count")><cfset attributes.recorded_count = 0></cfif>
    <cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id) and attributes.wrk_row_id neq 0>
        <cfquery name="get_seri_count" datasource="#dsn3#">
            SELECT 
                WRK_ROW_ID,
                SERIAL_NO
            FROM 
                SERVICE_GUARANTY_NEW 
            WHERE 
                WRK_ROW_ID = '#attributes.wrk_row_id#'
            GROUP BY
                WRK_ROW_ID,
                SERIAL_NO
            ORDER BY SERIAL_NO
        </cfquery>
    <cfelse>
        <cfquery name="get_seri_count" datasource="#dsn3#">
            SELECT 
                SERIAL_NO
            FROM 
                SERVICE_GUARANTY_NEW 
            WHERE 
                STOCK_ID = #attributes.stock_id#
                AND  PROCESS_ID = #attributes.process_id#
                AND PERIOD_ID = #session.ep.period_id#
        </cfquery>
    </cfif>
	<cfset attributes.recorded_count = get_seri_count.recordcount>
    <cfset range_number = attributes.product_amount - attributes.recorded_count>
    <cfif not isdefined("attributes.amount")><cfset attributes.amount = range_number></cfif>
    <cfif listfindnocase('171,76,74,73,114,110,1190',attributes.process_cat,',')>
        <cfquery name="get_stock_info" datasource="#dsn3#">
            SELECT S.PRODUCT_ID,S.SERIAL_BARCOD,STOCK_CODE FROM STOCKS S,PRODUCT_GUARANTY PG WHERE S.STOCK_ID = #attributes.STOCK_ID# AND S.PRODUCT_ID = PG.PRODUCT_ID AND PG.IS_LOCAL_SERIAL = 1
        </cfquery>
        <cfset stock_ = "#attributes.STOCK_ID#">
        <cfif get_stock_info.recordcount>
            <cfif x_serial_no_create_type eq 0>
                <cfif isdefined("x_serial_no_create_type_modify") and  x_serial_no_create_type_modify eq 1>
                    <cfset stock_ = stock_>
                <cfelse>
                    <cfloop from="1" to="#6-len(attributes.STOCK_ID)#" index="smk">
                        <cfset stock_ = "0" & stock_>
                    </cfloop>
                </cfif>
                <cfif len(get_stock_info.serial_barcod)>
                    <cfset seri_ = get_stock_info.serial_barcod + 1>
                <cfelse>
                    <cfset seri_ = 1>
                </cfif>
                <cfset my_seri_ = seri_>
                <cfloop from="1" to="#8-len(seri_)#" index="smk">
                    <cfset my_seri_ = "0" & my_seri_>
                </cfloop>
            <cfelseif x_serial_no_create_type eq 1>
                <cfset b_1_1 = left(PRODUCT_NAME.PRODUCT_CODE_2,10)>
                <cfloop from="1" to="#10-len(b_1_1)#" index="smk">
                    <cfset b_1_1 = "0" & b_1_1>
                </cfloop>
                <cfset b_1_2 = dateformat(now(),'yy')>
                
                <cfset b_2_1 = dateformat(now(),'mm')>
                <cfloop from="1" to="#2-len(b_2_1)#" index="smk">
                    #smk#
                    <cfset b_2_1 = "0" & b_2_1>
                </cfloop>
                
                <cfset b_2_2 = left(PRODUCT_NAME.SHELF_LIFE,2)>
                <cfloop from="1" to="#2-len(b_2_2)#" index="smk">
                    <cfset b_2_2 = "0" & b_2_2>
                </cfloop>
                
                <cfset stock_ = "#b_1_1##b_1_2#">
                <cfset my_seri_ = "#b_2_1##b_2_2#">
                
                <cfquery name="get_olds" datasource="#dsn3#">
                    SELECT TOP 1 SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO LIKE '#stock_#%' AND SERIAL_NO LIKE '%#my_seri_#' AND STOCK_ID = #attributes.STOCK_ID# ORDER BY SERIAL_NO DESC
                </cfquery>
                <cfif get_olds.recordcount>
                    <cfset serial_no_ = get_olds.serial_no>
                    <cfset serial_no_ = replace(serial_no_,'#stock_#','')>
                    <cfset serial_no_ = replace(serial_no_,'#my_seri_#','')>
                    <cfset serial_no_ = int(serial_no_)>
                    <cfset seri_ = serial_no_ + 1>
                <cfelse>
                    <cfset seri_ = 1>
                </cfif>
                <cfset seri_baslangic_ = seri_>
                <cfloop from="1" to="#6-len(seri_baslangic_)#" index="smk">
                    <cfset seri_baslangic_ = "0" & seri_baslangic_>
                </cfloop>
            <cfelseif x_serial_no_create_type eq 2>
                <cfquery name="get_ek_bilgi" datasource="#dsn3#">
                    SELECT TOP 1 PROPERTY19 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = #get_stock_info.PRODUCT_ID#
                </cfquery>
                <cfif get_ek_bilgi.recordcount and len(get_ek_bilgi.PROPERTY19)>
                    <cfset ek_bilgi_ = "#get_ek_bilgi.PROPERTY19#">
                <cfelse>
                    <cfset ek_bilgi_ = "000">
                </cfif>
                <cfset year_ = dateformat(now(),'yy')>
                <cfset my_seri_ = "#ek_bilgi_##year_#">
                <cfquery name="get_olds" datasource="#dsn3#">
                    SELECT TOP 1 SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO LIKE '#my_seri_#%' AND STOCK_ID = #attributes.STOCK_ID# ORDER BY SERIAL_NO DESC
                </cfquery>
                <cfif get_olds.recordcount>
                    <cfset serial_no_ = get_olds.serial_no>
                    <cfset serial_no_ = replace(serial_no_,'#my_seri_#','')>
                    <cfset serial_no_ = int(serial_no_)>
                    <cfset seri_ = serial_no_ + 1>
                <cfelse>
                    <cfset seri_ = 1>
                </cfif>
                
                <cfset seri_baslangic_ = seri_>
                <cfloop from="1" to="#6-len(seri_baslangic_)#" index="smk">
                    <cfset seri_baslangic_ = "0" & seri_baslangic_>
                </cfloop>
            </cfif>
            <cfset local_seri_kontrol = 1>
        <cfelse>
            <cfset stock_ = "">
            <cfset my_seri_ = "">
            <cfset local_seri_kontrol = 0>
            <cfset seri_ = "">
            <cfset seri_baslangic_ = "">
            <cfset b_1_1 = "">
            <cfset b_2_1 = "">
            <cfset b_2_2 = "">
        </cfif>
    <cfelse>
        <cfset stock_ = "">
        <cfset my_seri_ = "">
        <cfset local_seri_kontrol = 0>
        <cfset seri_ = "">
        <cfset seri_baslangic_ = "">
        <cfset b_1_1 = "">
        <cfset b_1_2 = "">
        <cfset b_2_1 = "">
        <cfset b_2_2 = "">
    </cfif>
    <!--- ekleme ekrani --->
	<cfif isdefined("attributes.loc_id")>
        <cfset attributes.loc_id = attributes.loc_id>
        <cfset attributes.dept_id = attributes.dept_id>	
    <cfelseif listfindnocase('76,77,82,84,86,140',attributes.process_cat,',') and not isdefined("attributes.loc_id")>  
        <cfset attributes.loc_id = attributes.location_in>
        <cfset attributes.dept_id = attributes.department_in>
    <cfelseif listfindnocase('70,71,72,83,85,141',attributes.process_cat,',')>  
        <cfset attributes.loc_id = attributes.location_out>
        <cfset attributes.dept_id = attributes.department_out>
    <cfelseif listfindnocase('81,811,113',attributes.process_cat,',')>  
        <cfset attributes.loc_id = attributes.location_out>
        <cfset attributes.dept_id = attributes.department_out>
        <cfset attributes.loc_id2 = attributes.location_in>
        <cfset attributes.dept_id2 = attributes.department_in>
    <cfelseif isdefined("attributes.location_in") and len(attributes.location_in)>
        <cfset attributes.loc_id = attributes.location_in>
        <cfset attributes.dept_id = attributes.department_in>
    <cfelseif isdefined("attributes.location_out")>
        <cfset attributes.loc_id = attributes.location_out>
        <cfset attributes.dept_id = attributes.department_out>
    </cfif>
    <cfif (range_number gte 0)>
		<cfinclude template="../objects/query/get_guaranty_cat.cfm">
    </cfif>   
    <cfquery name="get_product_guaranty" datasource="#dsn3#">
        SELECT SALE_GUARANTY_CAT_ID,TAKE_GUARANTY_CAT_ID FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    <cfquery name="get_alt_products" datasource="#dsn3#">
        SELECT PRODUCT_NAME, PROPERTY, STOCK_ID, PRODUCT_ID, IS_PRODUCTION FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND IS_SERIAL_NO = 1
    </cfquery>
    <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
        <cfquery name="get_product" datasource="#dsn3#">
            SELECT 
                SPECT_ROW_ID,
                SPECT_ID,
                PRODUCT_ID,
                STOCK_ID,
                AMOUNT_VALUE AS AMOUNT,
                IS_SEVK,
                PRODUCT_NAME,
                '' AS PROPERTY
            FROM
                SPECTS_ROW
            WHERE
                SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#"> AND
                IS_SEVK = 1
        </cfquery>
        <cfset is_result_ = 1>
    <cfelseif get_alt_products.recordcount and get_alt_products.IS_PRODUCTION>
        <cfquery name="get_product" datasource="#dsn3#">
            SELECT 
                PRODUCT_TREE.PRODUCT_TREE_ID,
                PRODUCT_TREE.RELATED_ID,
                S.PRODUCT_ID,
                S.STOCK_ID,
                PRODUCT_TREE.AMOUNT,
                PRODUCT_TREE.IS_SEVK,
                S.PRODUCT_NAME,
                S.PROPERTY
            FROM
                PRODUCT_TREE,
                STOCKS S
            WHERE
                S.STOCK_ID = PRODUCT_TREE.RELATED_ID AND
                PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
                PRODUCT_TREE.IS_SEVK = 1
        </cfquery>
        <cfset is_result_ = 1>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'printAll'>
	<cf_get_lang_set module_name='objects'>
    <cfsetting requesttimeout="3600">
    <cfsetting showdebugoutput="no">
    <cfif isdefined("attributes.barcode_file") and len(attributes.barcode_file)>
        <cfset CRLF = Chr(13) & Chr(10)>
        <cftry>
            <cfset file_name = createUUID()>
            <cffile action="upload" nameconflict="makeunique" filefield="barcode_file" destination="#upload_folder#objects">
            <cffile action="rename" source="#upload_folder#objects#dir_seperator##cffile.serverfile#" destination="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
            <!---Script dosyalarını engelle  02092010 FA-ND --->
            <cfset assetTypeName = listlast(cffile.serverfile,'.')>
            <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
            <cfif listfind(blackList,assetTypeName,',')>
                <cffile action="delete" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
                <script type="text/javascript">
                    alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
            <cfcatch>
                <script type="text/javascript">
                    alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cffile action="read" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#" variable="dosya">
        <cfscript>
            CRLF1 = Chr(13) & Chr(10);
            dosya1 = ListToArray(dosya,CRLF1);
            line_count = ArrayLen(dosya1);
        </cfscript>	
        <cffile action="delete" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
        <cfif line_count gt 500>
            <script type="text/javascript">
                alert('<cf_get_lang no ="1793.Dosyadan Gelen Barkod Sayısı"> : ' + <cfoutput>#line_count#</cfoutput> + '\n<cf_get_lang no ="1794.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> !');
                history.go(-1);
            </script>
            <cfabort>
        </cfif>
    <cfelseif isdefined("attributes.barcode_name") and len(attributes.barcode_name)>
        <cfset CRLF = Chr(13) & Chr(10)>
        <cffile action="read" file="#upload_folder#pda\label_print\#attributes.barcode_name#" variable="dosya">
        <cfscript>
            CRLF1 = Chr(13) & Chr(10);
            dosya1 = ListToArray(dosya,CRLF1);
            line_count = ArrayLen(dosya1);
        </cfscript>	
        <cfif line_count gt 500>
            <script type="text/javascript">
                alert('<cf_get_lang no ="1793.Dosyadan Gelen Barkod Sayısı"> : ' + <cfoutput>#line_count#</cfoutput> + '\n<cf_get_lang no ="1794.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> !');
                history.go(-1);
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT 
            * 
        FROM 
            PRICE_CAT
      <cfif isdefined("attributes.is_branch")>
        WHERE
            BRANCH LIKE '%,#listgetat(session.ep.user_location,2,"-")#,%'
      </cfif> 
        ORDER BY
            PRICE_CAT
    </cfquery>
    <cfif isdefined("attributes.is_branch")>
        <cfparam name="attributes.price_catid" default="#get_price_cat.price_catid#">
    <cfelse>
        <cfparam name="attributes.price_catid" default="-2">
    </cfif>
    <cfquery name="GET_DET_FORM" datasource="#DSN#">
        SELECT 
            SPF.TEMPLATE_FILE,
            SPF.FORM_ID,
            SPF.IS_DEFAULT,
            SPF.NAME,
            SPF.PROCESS_TYPE,
            SPF.MODULE_ID,
            SPFC.PRINT_NAME
        FROM 
            #dsn3_alias#.SETUP_PRINT_FILES SPF,
            SETUP_PRINT_FILES_CATS SPFC,
            MODULES MOD
        WHERE
            SPF.ACTIVE = 1 AND
            SPF.MODULE_ID = MOD.MODULE_ID AND
            SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
            SPFC.PRINT_TYPE = 192
        ORDER BY
            SPF.NAME
    </cfquery>
    <cfif (isdefined("attributes.barcode_file") and len(attributes.barcode_file)) or ( isdefined("attributes.barcode_name") and len(attributes.barcode_name))>
	<cfif not isDefined("attributes.seperator_type")><cfset attributes.seperator_type = ";"></cfif>
    <!--- barcode_file gozat ile gelenleri, barcode_name pda ile gelenleri ifade eder FB --->
        <script type="text/javascript">
            <cfloop list="#dosya#" index="i" delimiters="#CRLF#">
                <cfif listlen(i,'#attributes.seperator_type#') eq 2>
                    <cfif isnumeric(listgetat(i,2,'#attributes.seperator_type#'))>
                        <cfoutput>add_row('#trim(listfirst(i,'#attributes.seperator_type#'))#','#trim(listgetat(i,2,'#attributes.seperator_type#'))#','');</cfoutput>
                    </cfif>
                <cfelseif listlen(i,'#attributes.seperator_type#') eq 3>
                    <cfif isnumeric(listgetat(i,2,'#attributes.seperator_type#'))>
                        <cfoutput>add_row('#listfirst(i,'#attributes.seperator_type#')#','#listgetat(i,2,'#attributes.seperator_type#')#','#listgetat(i,3,'#attributes.seperator_type#')#');</cfoutput>
                    </cfif>
                </cfif>
            </cfloop>
        </script>
    <cfelseif isdefined("from_genius_barcode_file")>
        <cftry>
            <cfset CRLF = Chr(13) & Chr(10)>
            <cffile action="read" file="#from_genius_barcode_file#" variable="dosya">
            <cffile action="delete" file="#from_genius_barcode_file#">
            <script type="text/javascript">
            <cfloop list="#dosya#" index="i" delimiters="#CRLF#">
                <cfif isnumeric(listgetat(i,2,','))>
                    <cfoutput>add_row('#trim(listfirst(i))#','#trim(listgetat(i,2,','))#','#trim(listgetat(i,3,','))#');</cfoutput>
                </cfif>
            </cfloop>
            </script>
            <cfcatch>
                <script type="text/javascript">
                    alert("<cf_get_lang no='490.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    <cfelseif isdefined("from_inter_barcode_file")><!--- MPOS icin --->
        <cftry>
            <cfset CRLF = Chr(13) & Chr(10)>
            <cffile action="read" file="#from_inter_barcode_file#" variable="dosya">
            <script type="text/javascript">
            <cfloop list="#dosya#" index="i" delimiters="#CRLF#">
                    <cfoutput>add_row('#trim(Mid(i,4,13))#','1','#trim(Mid(i,37,20))#');</cfoutput>
            </cfloop>
            </script>
            <cfcatch>
                <script type="text/javascript">
                    alert("<cf_get_lang no='490.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    <cfelseif isdefined("from_ncr_barcode_file")><!--- ncr için --->
        <cftry>
            <cfset CRLF = Chr(13) & Chr(10)>
            <cffile action="read" file="#from_ncr_barcode_file#" variable="dosya">
            <script type="text/javascript">
            <cfloop list="#dosya#" index="i" delimiters="#CRLF#">
                    <cfoutput>add_row('#trim(Mid(i,4,13))#','1','#trim(Mid(i,37,20))#');</cfoutput>
            </cfloop>
            </script>
            <cfcatch>
                <script type="text/javascript">
                    alert("<cf_get_lang no='490.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		function input_control()
		{
			if((list_serial.process_cat_id.value.length == 0) && (list_serial.invoice_number.value.length == 0))
			{
				alert("<cf_get_lang no='323.İşlem Tipi Seçmeli veya Fatura No Girmelisiniz'>!");
				return false;
			}
				
			if((list_serial.serial_no.value.length == 0) && (list_serial.lot_no.value.length == 0) && 
				(list_serial.belge_no.value.length == 0) && (list_serial.date1.value.length == 0) && (list_serial.date2.value.length == 0) &&
				(list_serial.company.value.length == 0 || list_serial.company_id.value.length == 0) &&
				(list_serial.employee.value.length == 0 || list_serial.employee_id.value.length == 0) && (list_serial.process_cat_id.value.length == 0)) 
			{
			   alert ("<cf_get_lang no='322.En Az Bir Alanda Filtre Etmelisiniz'> !"); 
			   return false;
			}
			else
				return true;
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'addOther')>
	$(document).ready(function()
		{
			 ff=null;
			 eee=null;
			 sil=0;
			 tmp1= '';
			 tmp2= '';
		});
		
		
		function ttt()
		{
			try
			{
				i++;
				bb=tmp1;
				hwpage = i*100;
				bb += "&page=" + hwpage;
				AjaxPageLoad(bb,'PLACE_'+i);
				ff = setTimeout(ttt,500);
			}
			catch(e) {}
		}
		
		
		function kkk()
		{
			try
			{
				i++;
				cc=tmp2;
				hwpage = i*100;
				cc += "&page=" + hwpage;
				AjaxPageLoad(cc,'PLACE_'+i);
				eee = setTimeout(kkk,500);
			}
			catch(e) {}
		}
		function serileri_temizle()
	{
		if(confirm("<cf_get_lang no ='1572.Belgeye bağlı girilmiş olan tüm seriler silinecek Emin misiniz'>?"))
			<cfif isDefined('session.ep.userid')>
				document.location.href='<cfoutput>#request.self#?fuseaction=objects.upd_stock_serialno&all_delete=1&stock_id=#attributes.stock_id#&process_id=#attributes.process_id#&process_cat=#attributes.process_cat#</cfoutput>';
			<cfelse>
				document.location.href='<cfoutput>#request.self#?fuseaction=objects2.upd_stock_serialno&all_delete=1&stock_id=#attributes.stock_id#&process_id=#attributes.process_id#&process_cat=#attributes.process_cat#</cfoutput>';
			</cfif>
		else
			return false;
	}
	<cfif range_number gt 0>
	function chk_form()
	{
		if(document.add_guaranty_.method[0].checked)
		{
			var serial_no_ = '';
			if(document.add_guaranty_.m_type[0].checked && document.add_guaranty_.ship_start_no.value=="")
			{
				alert("<cf_get_lang no ='1465.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			else if(document.add_guaranty_.m_type[1].checked && document.add_guaranty_.ship_start_no_orta.value=="")
			{
				alert("<cf_get_lang no ='1465.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			else if(document.add_guaranty_.m_type[2].checked && document.add_guaranty_.ship_start_no_son.value=="")
			{
				alert("<cf_get_lang no ='1465.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			if(document.add_guaranty_.ship_start_no.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no.value;
			}
			if(document.add_guaranty_.ship_start_no_orta.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no_orta.value;
			}
			if(document.add_guaranty_.ship_start_no_son.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no_son.value;
			}
			if(serial_no_.length > 50)
			{
				alert("Seri No Karakter Sayısı En Fazla 50 Olmalıdır!");
				return false;
			}
		}
		if(document.add_guaranty_.method[1].checked)
		{
			if(document.add_guaranty_.ship_start_nos.value=="") 
			{
				alert("<cf_get_lang no ='1384.Seri No Girmelisiniz'>!");
				return false;
			}
			/*
			if(document.getElementById('ship_start_nos').value!='')
			{
				var inputStr=document.getElementById('ship_start_nos').value;
				alert(inputStr);
				if(inputStr.length>0)
				{
					for(var i=0;i < inputStr.length;i++)
					{
						var oneChar= inputStr.substring(i,i+1).charCodeAt();
						var deger = inputStr.substring(i,i+1);
						if(oneChar==13&&i>50||oneChar!=13&&i>50)
						{
							alert("deger: "+deger+"i: "+i+"oneChar: " +oneChar);
							//alert(i);
							//alert(oneChar);
							alert("Seri No Karakter Sayısı En Fazla 50 Olmalıdır!");
							i=0;
							return false;
						}
					}
				}
			}
			*/
		}
			
		if(document.add_guaranty_.method[3].checked)
		{
			if(document.add_guaranty_.lot_no.value=="")
			{
				alert("<cf_get_lang no ='1478.Lot No Girmelisiniz'>!");
				return false;
			}
		}
			
		if(document.add_guaranty_.guarantycat_id.value=="")
		{
			alert("<cf_get_lang no ='1479.Garanti Tipi Seçmelisiniz'>!");
			return false;
		}
	
		<cfif attributes.process_cat eq 86> //or attributes.process_cat eq 141
			if(document.add_guaranty_.out_ship_id.value=="")
			{
				alert("<cf_get_lang no ='1480.Dönüş İrsaliyesi Seçmelisiniz'>!");
				return false;
			}
		</cfif>
		return true;
	}
	</cfif>
	function chk_form2()
	{
		var satir = "<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>";
		if(satir > 1)
		{
			for (i=0; i < satir; i++)			
			{
				try
				{
					if(!document.add_guaranty.start_no[i].value.length)
					{
						alert("<cf_get_lang no ='1481.Eksik Seri No Girdiniz'>");
						return false;
					}
				}
				catch(e) {}
			}
		}
		else if(satir == 1)
		{
			if(!document.add_guaranty.start_no.value.length)
			{
				alert("<cf_get_lang no ='1481.Eksik Seri No Girdiniz'>!");
				return false;
			}
		}
		return true;
	}
	<cfif range_number gt 0>
		function kontrol(gelen)
		{
			if(gelen == 0)
			{
				document.getElementById('ardisik').style.display = 'block';
				document.getElementById('tek_tek').style.display = 'none';
			}
			else
			{
				document.getElementById('ardisik').style.display = 'none';
				document.getElementById('tek_tek').style.display = 'block';
			}
		}
		$(document).ready(function()
		{
			kontrol(0);
			<cfif isdefined("attributes.guaranty_method") and (attributes.guaranty_method eq 0)>
				kontrol(0);
			<cfelseif isdefined("attributes.guaranty_method") and (attributes.guaranty_method eq 1)>
				kontrol(1);
			</cfif>
		});
	</cfif>
		
	function record_sil(guaranty_id,index,catid)
	{
		var state = confirm("<cf_get_lang no ='1482.Seri No silmek İstediğinize Emin misiniz'>?");
		if (state)
		{ 
			siladres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_del_serial_info</cfoutput>";
			<cfif isdefined("attributes.is_line")>
				siladres +="&is_line=1";
			</cfif>
			siladres +="&catid="+catid;
			siladres +="&guaranty_id="+guaranty_id;
			AjaxPageLoad(siladres,'EMPTY_PLACE');	
			gizle(eval("satirim_"+index));
		}
	}
	
	function kayit_duzenle(guaranty_id,index)
	{
		info_alani.innerHTML = '<font color="red">Güncelleniyor!</font>';
		guncelleme_adres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_stock_serialno</cfoutput>";
		<cfif isdefined("attributes.is_line")>
			guncelleme_adres +="&is_line=1";
		</cfif>
		guncelleme_adres +="&guaranty_id="+guaranty_id;
		guncelleme_adres +="&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>";
		guncelleme_adres +="&satir_="+index;
		guncelleme_adres +="&sale_product=<cfoutput>#attributes.sale_product#</cfoutput>";
		guncelleme_adres +="&is_only_one=1";
		guncelleme_adres +="&seri_no="+eval("document.add_guaranty_.start_no_" + index).value;
		guncelleme_adres +="&lot_no="+eval("document.add_guaranty_.lot_no_" + index).value;
		<cfif isDefined('x_is_reference') and x_is_reference eq 1>
			guncelleme_adres +="&reference_no="+eval("document.add_guaranty_.reference_no_" + index).value;
		</cfif>
		<cfif isDefined('x_is_rma') and x_is_rma eq 1>
			guncelleme_adres +="&rma_no="+eval("document.add_guaranty_.rma_no_" + index).value;
		</cfif>
		guncelleme_adres +="&old_seri_no="+eval("document.add_guaranty_.old_start_no_" + index).value;
		guncelleme_adres +="&old_lot_no="+eval("document.add_guaranty_.old_lot_no_" + index).value;
		AjaxPageLoad(guncelleme_adres,'EMPTY_PLACE',1);
	}
	<cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 1>
		function degistir(type)
		{
			if(type==1)
			{
				new_deger_ = document.add_guaranty_.serial_year.value;
				document.add_guaranty_.ship_start_no.value = '<cfoutput>#b_1_1#</cfoutput>' + new_deger_;
			}
			else
			{
				new_deger_ = document.add_guaranty_.serial_mon.value;
				document.add_guaranty_.ship_start_no_son.value = new_deger_ + '<cfoutput>#b_2_2#</cfoutput>';
			}
			guncelleme_adres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_stock_serialno_creater</cfoutput>";
			guncelleme_adres +="&stock_="+document.add_guaranty_.ship_start_no.value;
			guncelleme_adres +="&my_seri_="+document.add_guaranty_.ship_start_no_son.value;
			guncelleme_adres +="&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>";
			AjaxPageLoad(guncelleme_adres,'serial_creater',1);
		}
	</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'printAll'>
		function kontrol()
		{
		
			if(document.getElementById('barcode_file').value == '')
			{
				alert("<cf_get_lang no='481.Belge Seçiniz'>!");
				return false;
			}
			return true;
		}
		
		function gonder(file_flag)
		{
			if(file_flag == 2 && print_barcode.form_type.value.length=='')
			{
				alert("<cf_get_lang no ='1795.Şablon Seçiniz'>!");
				return false;	
			}
				
			if(file_flag ==1)//kaydedilecekse buraya git
				print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_save_collected_barcodes</cfoutput>";			
			else if(file_flag == 2)//yazdırılacaksa buraya
				{
				print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popupflush_print_separated_lot</cfoutput>";
				print_barcode.submit();
					return false;
				}
			else
				print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popupflush_print_separated_lot</cfoutput>";
			
			if(print_barcode.barcode==undefined) 
				return false;
			
			
			if ((print_barcode.barcode_count.length != undefined) && (print_barcode.barcode_count.length > 500))
			{
				if(file_flag ==1)
					if(confirm('<cf_get_lang no ="1796.Yazdırmaya Çalıştığınız Barkod Sayısı"> : ' + print_barcode.barcode_count.length + '\n<cf_get_lang no ="1794.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> ! \n<cf_get_lang no ="1797.Dosyanızı 500 Satır Olacak Şekilde Bölmeniz Gerekiyor"> !')); else return false;
				else
				{		
					alert('<cf_get_lang no ="1796.Yazdırmaya Çalıştığınız Barkod Sayısı"> : ' + print_barcode.barcode_count.length + '\n\n<cf_get_lang no ="1794.500 den Fazla Barkod Aynı Anda Yazdırılamaz">!');
					return false;
				}
			}
		
			if (print_barcode.barcode.length != undefined) /* n tane*/
			{
				for (i=0; i < print_barcode.barcode.length; i++)
				{
					//if(print_barcode.barcode[i].value != parseFloat(print_barcode.barcode[i].value)) print_barcode.barcode[i].value = '';
					if(!(print_barcode.barcode[i].value.length>0))
					{
						alert("<cf_get_lang no='491.Barkod Alanını Kontrol Ediniz'>! ")
						return false;
					}								
				}
			}
			else /* 1 tane*/
			{			
				//burası sadece barkoada göre çalıştığı için kaldırdım artık stok koda görede çalışıcak.
				//if (print_barcode.barcode.value != parseFloat(print_barcode.barcode.value)) print_barcode.barcode.value = '';
				if(!(print_barcode.barcode.value.length>0))
				{
					alert("<cf_get_lang no='491.Barkod Alanını Kontrol Ediniz'>! ")
					return false;
				}					
			}		
			
			if (print_barcode.barcode_count.length != undefined) /* n tane*/
			{
				for (i=0; i < print_barcode.barcode_count.length; i++)
				{
				if(print_barcode.barcode_count[i].value != parseFloat(print_barcode.barcode_count[i].value)) print_barcode.barcode_count[i].value = '';
				if(!(print_barcode.barcode_count[i].value>0))
				{
					alert("<cf_get_lang no='492.Barkod Yazdırma Sayısını Kontrol Ediniz!'> ")
					return false;
					}					
				}
			}
			else /* 1 tane*/
			{
				if(print_barcode.barcode_count.value != parseInt(print_barcode.barcode_count.value)) print_barcode.barcode_count.value = '';
				if(!(print_barcode.barcode_count.value>0))
				{
					alert("<cf_get_lang no='492.Barkod Yazdırma Sayısını Kontrol Ediniz!'> ")
					return false;
				}	
			}		
			print_barcode.submit();
				return false;
		}	
		function add_row(lot_no,amount,seri_no)
	{
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);
		newRow.setAttribute("name","frm_row");
		newRow.setAttribute("NAME","frm_row");
					
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no" value="'+lot_no+'" style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="barcode_count" value="'+amount+'" maxlength="2" class="moneybox" style="width:40px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="seri_no" value="'+seri_no+'" style="width:150px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" class="eklebutton" onclick="table_1.deleteRow(this.parentNode.parentNode.rowIndex)"><img src="images/delete_list.gif" border="0"></a>';
	}
	
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_serial_operations.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'stock/display/list_serial_operations.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_upd_stock_serialno';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/upd_stock_serial_no.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_stock_serial_no.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';	
	
	WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';
	WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'objects/form/upd_stock_serial_no.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'objects/query/upd_stock_serialno.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';	
	
	WOStruct['#attributes.fuseaction#']['printAll'] = structNew();
	WOStruct['#attributes.fuseaction#']['printAll']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['printAll']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';
	WOStruct['#attributes.fuseaction#']['printAll']['filePath'] = 'objects/display/lot_no_separated.cfm';
	WOStruct['#attributes.fuseaction#']['printAll']['queryPath'] = 'objects/display/lot_no_seperated.cfm';
	WOStruct['#attributes.fuseaction#']['printAll']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations';	
	
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[221]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#PRODUCT_NAME.STOCK_ID#&is_terazi=#PRODUCT_NAME.IS_TERAZI#','medium')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#lang_array.item[1468]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['href'] = "#request.self#?fuseaction=objects.emptypopup_add_serial_to_file&product_amount=#attributes.product_amount#&recorded_count=#attributes.recorded_count#&product_id=#attributes.product_id#&stock_id=#attributes.stock_id#&process_number=#attributes.process_number#&process_cat=#attributes.process_cat#&process_id=#attributes.process_id#&is_serial_no=1&spect_id=#attributes.spect_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][2]['text'] = '#lang_array.item[1469]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_product_guaranty&pid=#attributes.product_id#','small')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][3]['text'] = '#lang_array.item[1470]#';
		if(isdefined("attributes.is_store") and attributes.is_store eq 1)
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_serial_no_search&product_id=#attributes.product_id#&is_store=1','small')";
		else
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_serial_no_search&product_id=#attributes.product_id#','small')";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.process_cat#&action_id=#attributes.process_id#&action_row_id=#attributes.STOCK_ID#&print_type=192','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockListSerialOperations';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SERVICE_GUARANTY_NEW';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-start_date','item-guarantycat_id','item3','item11','item12','item13']";
</cfscript>
