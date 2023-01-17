<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.document_number" default="">
    <cfparam name="attributes.ship_method" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date=wrk_get_today()>
        </cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_date=''>
        <cfelse>
        <cfset attributes.finish_date = date_add('d',1,now())>
        </cfif>
    </cfif>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.ship_method_id" default="">
    <cfparam name="attributes.ship_method_name" default="">
    <cfparam name="attributes.ship_stage" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.transport_comp_id" default="">
    <cfparam name="attributes.transport_comp_name" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county" default="">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfif x_equipment_planning_info eq 1>
        <cfparam name="attributes.team_code" default="">
        <cfparam name="attributes.planning_date" default="#dateFormat(now(),'dd/mm/yyyy')#">
        <cf_date tarih="attributes.planning_date">
        <cfquery name="get_planning_info" datasource="#dsn3#">
            SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING <cfif isdate(attributes.planning_date) and len(attributes.planning_date)>WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"></cfif>
        </cfquery>
    </cfif>
    <cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_packetship%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
            SELECT 
                SR.MAIN_SHIP_FIS_NO,
                SR.OUT_DATE, 
                SR.DELIVERY_DATE, 
                SR.SHIP_METHOD_TYPE, 
                SR.SHIP_STAGE,
                SR.EQUIPMENT_PLANNING_ID,
                SMT.SHIP_METHOD ,
                PTR.STAGE,
                DTP.TEAM_CODE,
                CAST(SR.NOTE AS NVARCHAR(500)) NOTE
            FROM 
                #dsn_alias#.SHIP_METHOD SMT,
                SHIP_RESULT SR
                LEFT JOIN #DSN_ALIAS#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = SR.SHIP_STAGE
                LEFT JOIN #DSN3_ALIAS#.DISPATCH_TEAM_PLANNING DTP ON DTP.PLANNING_ID = SR.EQUIPMENT_PLANNING_ID
            WHERE 
                SR.SHIP_METHOD_TYPE = SMT.SHIP_METHOD_ID AND
                SR.MAIN_SHIP_FIS_NO IS NOT NULL
                <cfif x_equipment_planning_info eq 1>
                    AND SR.IS_ORDER_TERMS = 1
                    <cfif isdate(attributes.planning_date) and len(attributes.planning_date)>
                        AND SR.OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
                    </cfif>
                    <cfif Len(attributes.team_code)>
                        AND SR.EQUIPMENT_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_code#">
                    </cfif>
                    <cfif len(attributes.document_number) or (len(attributes.company_id) and len(attributes.company)) or (len(attributes.consumer_id) and len(attributes.company))><!--- Siparis Numarasina Gore Arama --->
                        AND SHIP_RESULT_ID IN(	SELECT
                                                    SHIP_RESULT_ID
                                                FROM
                                                    SHIP_RESULT_ROW SRR,
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    SRR.ORDER_ID = O.ORDER_ID
                                                    <cfif len(attributes.document_number)>
                                                        AND O.ORDER_NUMBER LIKE '%#attributes.document_number#%'
                                                    </cfif>
                                                    <cfif len(attributes.company_id) and len(attributes.company)>
                                                        AND O.COMPANY_ID = #attributes.company_id#
                                                    <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                                                        AND O.CONSUMER_ID = #attributes.consumer_id#
                                                    </cfif>
                                            )
                    </cfif>
                <cfelse>
                    AND SR.IS_ORDER_TERMS IS NULL
                    <cfif len(attributes.document_number)><!---  Irsaliye numarasina gore arama (xml de dikkate alinarak) --->
                        AND SHIP_RESULT_ID IN(	SELECT
                                                    SHIP_RESULT_ID
                                                FROM
                                                    SHIP_RESULT_ROW
                                                WHERE
                                                    SHIP_ID IN (SELECT SHIP_ID FROM SHIP WHERE SHIP_NUMBER LIKE '%#attributes.document_number#%') OR SHIP_ID IS NULL
                                            )		  
                    </cfif>
                    <cfif len(attributes.company_id) and len(attributes.company)>
                        AND SR.COMPANY_ID = #attributes.company_id#
                    <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                        AND SR.CONSUMER_ID = #attributes.consumer_id#
                    </cfif>
                </cfif>	  
                <cfif len(attributes.keyword)>
                    AND (SR.SHIP_FIS_NO LIKE '%#attributes.keyword#%' OR SR.REFERENCE_NO LIKE '%#attributes.keyword#%')
                </cfif>
                <cfif len(attributes.process_stage_type)>
                    AND SR.SHIP_STAGE = #attributes.process_stage_type#</cfif>
                <cfif len(attributes.start_date)>
                    AND SR.OUT_DATE >= #attributes.start_date#
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND SR.OUT_DATE <= #attributes.finish_date#
                </cfif>
                <cfif len(attributes.ship_method_name) and len(attributes.ship_method_id)>
                    AND SR.SHIP_METHOD_TYPE = #attributes.ship_method_id#
                </cfif>
                <cfif isdefined("attributes.department_id") and len(attributes.department_id) and isdefined("attributes.department_name") and len(attributes.department_name)>
                    AND SR.DEPARTMENT_ID = #attributes.department_id#
                </cfif>
                <cfif len(attributes.transport_comp_id) and len(attributes.transport_comp_name)>
                    AND SR.SERVICE_COMPANY_ID = #attributes.transport_comp_id#
                </cfif>
            GROUP BY 
                SR.MAIN_SHIP_FIS_NO,
                SR.OUT_DATE, 
                SR.DELIVERY_DATE, 
                SR.SHIP_METHOD_TYPE, 
                SR.SHIP_STAGE, 
                SR.EQUIPMENT_PLANNING_ID,
                SMT.SHIP_METHOD	,
                PTR.STAGE,
                DTP.TEAM_CODE,
                CAST(SR.NOTE AS NVARCHAR(500))
        </cfquery>
    <cfelse>
        <cfset get_ship_result.recordCount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
    <cfinclude template="../stock/query/get_moneys.cfm">
    <cfinclude template="../stock/query/get_package_type.cfm">
    <cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
        <cfquery name="ADD_LOGISTIC" datasource="#DSN2#">
            SELECT
                1 MEMBER_TYPE,
                C.COMPANY_ID MEMBER_ID,
                S.LOCATION,
                S.COMPANY_ID,
                S.PARTNER_ID,
                S.CONSUMER_ID,
                S.SHIP_ID,
                S.SHIP_NUMBER,
                (SELECT ORDER_NUMBER FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = OS.ORDER_ID) ORDER_NUMBER,
                S.SHIP_DATE,
                S.SHIP_METHOD,
                S.ADDRESS,
                S.ORDER_ID,
                S.DELIVER_STORE_ID,
                S.IS_DISPATCH,
                (SELECT DEPARTMENT_HEAD FROM  #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = S.DELIVER_STORE_ID) AS DEPARTMENT_HEAD,
                C.FULLNAME MEMBER_NAME,
                C.NICKNAME MEMBER_NAME2
            FROM 
                SHIP S,
                #dsn_alias#.COMPANY C,
                #dsn3_alias#.ORDERS_SHIP OS
            WHERE
                OS.ORDER_ID IN (#attributes.is_logistic#) AND
                OS.SHIP_ID = S.SHIP_ID AND
                OS.PERIOD_ID = #session.ep.period_id# AND
                S.COMPANY_ID = C.COMPANY_ID
    
            UNION ALL
            
            SELECT
                2 MEMBER_TYPE,
                C.CONSUMER_ID MEMBER_ID,
                S.LOCATION,
                S.COMPANY_ID,
                S.PARTNER_ID,
                S.CONSUMER_ID,
                S.SHIP_ID,
                S.SHIP_NUMBER,
                (SELECT ORDER_NUMBER FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = OS.ORDER_ID) ORDER_NUMBER,
                S.SHIP_DATE,
                S.SHIP_METHOD,
                S.ADDRESS,
                S.ORDER_ID,
                S.DELIVER_STORE_ID,
                S.IS_DISPATCH,
                (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = S.DELIVER_STORE_ID) AS DEPARTMENT_HEAD,
                C.CONSUMER_NAME + ' '+ C.CONSUMER_SURNAME MEMBER_NAME,
                C.CONSUMER_NAME + ' '+ C.CONSUMER_SURNAME MEMBER_NAME2
            FROM
                SHIP S,
                #dsn_alias#.CONSUMER C,
                #dsn3_alias#.ORDERS_SHIP OS
            WHERE
                OS.ORDER_ID IN (#attributes.is_logistic#) AND
                OS.SHIP_ID = S.SHIP_ID AND
                OS.PERIOD_ID = #session.ep.period_id# AND
                S.CONSUMER_ID = C.CONSUMER_ID
            ORDER BY
                MEMBER_TYPE,
                MEMBER_ID
        </cfquery>
        <cfquery name="GET_CONTROL_" dbtype="query">
            SELECT SHIP_NUMBER FROM ADD_LOGISTIC WHERE IS_DISPATCH = 1
        </cfquery>
        <!--- Tasiyici bilgileri icin --->
        <cfquery name="GET_COMPANY_SEVK" datasource="#DSN#">
            SELECT 
                TRANSPORT_COMP_ID,
                TRANSPORT_DELIVER_ID,
                SHIP_METHOD_ID
            FROM 
                COMPANY_CREDIT 
            WHERE 
            <cfif add_logistic.member_type[1] eq 1>
                COMPANY_ID = #add_logistic.member_id[1]# AND
            <cfelse>
                CONSUMER_ID = #add_logistic.member_id[1]# AND
            </cfif>
                OUR_COMPANY_ID = #session.ep.company_id#
        </cfquery>
        <cfif get_company_sevk.recordcount>
            <cfset attributes.transport_comp_id = get_company_sevk.transport_comp_id>
            <cfset attributes.transport_deliver_id = get_company_sevk.transport_deliver_id>
            <cfif len(get_company_sevk.ship_method_id)>
                <cfquery name="GET_SHIP_METHOD_" datasource="#DSN#">
                    SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_company_sevk.ship_method_id#
                </cfquery>
                <cfif get_ship_method_.recordcount>
                    <cfset attributes.ship_method_id = get_company_sevk.ship_method_id>
                    <cfset attributes.ship_method_name = get_ship_method_.ship_method>
                </cfif>
            </cfif>
        </cfif>
    
        <cfset all_logistic = QueryNew("MEMBER_TYPE,MEMBER_ID,LINE","Integer,Integer,Integer")>
        <cfset TEMP_LINE = 0>
        <cfscript>
            for(i_index=1;i_index lte add_logistic.recordcount;i_index=i_index+1)
            {
                TEMP_LINE = TEMP_LINE + 1;
                QueryAddRow(all_logistic,1);
                QuerySetCell(all_logistic,"MEMBER_TYPE",add_logistic.MEMBER_TYPE[i_index],TEMP_LINE);
                QuerySetCell(all_logistic,"MEMBER_ID",add_logistic.MEMBER_ID[i_index],TEMP_LINE);
                QuerySetCell(all_logistic,"LINE",i_index,TEMP_LINE);	
            }
        </cfscript>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfsetting showdebugoutput="no">
    <cf_xml_page_edit fuseact="stock.detail_multi_packetship">
    <cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <!--- 
        Not : SHIP_RESULT tablosundaki IS_TYPE alani siparis detayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
            O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
        Not 2: Bu sayfada dogtas icin xml e bagli degisiklikler yapildi, bana danisilabilir FBS 20091101
     --->
    
    <cfquery name="GET_SHIP_RESULTS_ALL" datasource="#DSN2#">
        SELECT
            SR.*,
            SM.SHIP_METHOD,
            ASSET_P.ASSETP
        FROM
        	#dsn_alias#.SHIP_METHOD SM,
            SHIP_RESULT SR
            LEFT JOIN #DSN_ALIAS#.ASSET_P ON ASSET_P.ASSETP_ID = SR.ASSETP_ID
        WHERE
            SR.MAIN_SHIP_FIS_NO = '#attributes.main_ship_fis_no#' AND
            SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
        ORDER BY
            SR.SHIP_RESULT_ID
    </cfquery>
    <cfif not GET_SHIP_RESULTS_ALL.recordcount>
		<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
    	<cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfquery name="GET_SHIP_RESULT" dbtype="query" maxrows="1">
        SELECT * FROM GET_SHIP_RESULTS_ALL ORDER BY SHIP_RESULT_ID DESC
    </cfquery>
    <cfquery name="get_ship_control" datasource="#dsn2#"><!--- Irsaliyelenmis kayit var mi --->
        SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND SHIP_ID IS NOT NULL AND INVOICE_ID IS NOT NULL
    </cfquery>
    <cfif x_equipment_planning_info eq 0><!--- Planlama Bazinda Gelen Verilerde Bunlara Gerek Yok --->
        <cfinclude template="../stock/query/get_moneys.cfm">
        <cfinclude template="../stock/query/get_package_type.cfm">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY, RATE2, RATE1 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
        </cfquery>
        
        <cfquery name="SUM_SHIP_RESULT" dbtype="query">
            SELECT
                SUM(COST_VALUE) COST_VALUE,
                SUM(COST_VALUE2) COST_VALUE2
            FROM
                GET_SHIP_RESULTS_ALL
        </cfquery>
        <cfif listlen(valuelist(get_ship_results_all.company_id))>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN(#listsort(valuelist(get_ship_results_all.company_id),"numeric")#) 
            </cfquery>
        </cfif>
        <cfif listlen(valuelist(get_ship_results_all.consumer_id))>
            <cfquery name="GET_CONSUMER" datasource="#DSN#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN(#listsort(valuelist(get_ship_results_all.consumer_id),"numeric")#) 
            </cfquery>
        </cfif>
    
        <cfif not get_ship_result.recordcount or not len(get_ship_result.service_company_id)>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
            SELECT * FROM SHIP_METHOD_PRICE WHERE COMPANY_ID = #get_ship_result.service_company_id#
        </cfquery>
        <!--- Eger ilgili hesap yontemine ait kayit yoksa --->
        <cfif not get_ship_method_price.recordcount>
            <script type="text/javascript">
                alert('<cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#</cfoutput>'+'  Şirketine Ait Bir Taşıyıcı Kaydı Yok,Lütfen Kayıtlarınızı Kontrol Ediniz.' );
                window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_packetship"
            </script>
        </cfif>
    
        <!--- Tasiyici Bilgisi Degistirilirse,yeni tasiyici icin sevk fiyatı verilip verilmedigini kontrol etmek icin  --->
        <cfquery name="GET_SHIP_METHOD_PRICE_" datasource="#DSN#">
            SELECT * FROM SHIP_METHOD_PRICE
        </cfquery>
        <!--- Tasiyici Firma Sadece 1 kez secilsin. --->
        <cfset transport_selected = valueList(get_ship_method_price_.company_id,',')>
        <cfif len(get_ship_result.ship_method_type)>
            <cfquery name="GET_ROWS" datasource="#DSN2#">
                SELECT PACKAGE_PIECE, PACKAGE_DIMENTION, PACKAGE_WEIGHT FROM SHIP_RESULT_PACKAGE WHERE SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#)
            </cfquery>
            <cfset toplam_kg = 0>
            <cfset toplam_desi = 0>
        </cfif>
    <cfelse>
        <cfif get_ship_result.is_order_terms neq 1>
            <script type="text/javascript">
                alert('Planlama Bazında Kaydetmediğiniz İçin Bu Sevkiyat Detayını Görüntüleyemezsiniz !');
                window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_multi_packetship"
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfquery name="GET_ROW" datasource="#DSN2#">
        SELECT 
            SRW.*,
            ISNULL(SRW.ORDER_ROW_AMOUNT,0) ORDER_ROW_AMOUNT_,
            ISNULL(SRW.SHIP_RESULT_ROW_AMOUNT,0) SHIP_ROW_AMOUNT_,
            SR.SHIP_RESULT_ID,
            SR.COMPANY_ID,
            SR.PARTNER_ID,
            SR.CONSUMER_ID,
            SR.COST_VALUE,
            SR.COST_VALUE2,
            SR.SHIP_FIS_NO,
            SHIP.SHIP_NUMBER,
            C.FULLNAME,
            CR.CONSUMER_NAME + ' ' + CR.CONSUMER_SURNAME AS CONSUMER_NAME
        FROM
            SHIP_RESULT_ROW SRW
            LEFT JOIN #DSN2_ALIAS#.SHIP ON SHIP.SHIP_ID = SRW.SHIP_ID
            ,
            SHIP_RESULT SR
            LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = SR.COMPANY_ID
            LEFT JOIN #DSN_ALIAS#.CONSUMER CR ON CR.CONSUMER_ID = SR.CONSUMER_ID
        WHERE 
            SRW.SHIP_RESULT_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
            SRW.SHIP_RESULT_ID = SR.SHIP_RESULT_ID
        ORDER BY
            SRW.ORDER_ID,
            SR.SHIP_RESULT_ID
    </cfquery>
    <cfif x_equipment_planning_info eq 1 and not Get_Row.RecordCount>
        <br />&nbsp;&nbsp;&nbsp;
        <cfoutput>#attributes.main_ship_fis_no#</cfoutput> Nolu Sevkiyat Satırları İle İlgili Bir Sorun Bulunmaktadır. Lütfen Sistem Yöneticinize Başvurunuz !
        <cfexit>
    </cfif>
    <cfif x_equipment_planning_info eq 1>
        <cfquery name="get_planning_info" datasource="#dsn3#">
            SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_ship_result.out_date#">
        </cfquery>
    </cfif>
    <cfif x_equipment_planning_info eq 0>
        <cfquery name="GET_PACKAGE" datasource="#DSN2#">
            (SELECT
                SRP.*,
                '' PACK_NAME,
                SR.COMPANY_ID,
                SR.PARTNER_ID,
                SR.CONSUMER_ID	,
                C.FULLNAME,
           		 CR.CONSUMER_NAME + ' ' + CR.CONSUMER_SURNAME AS CONSUMER_NAME				
            FROM
                SHIP_RESULT_PACKAGE SRP,
                SHIP_RESULT SR
                LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = SR.COMPANY_ID
            	LEFT JOIN #DSN_ALIAS#.CONSUMER CR ON CR.CONSUMER_ID = SR.CONSUMER_ID
            WHERE 
                SRP.SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
                SRP.PACK_EMP_ID IS NULL AND
                SRP.SHIP_ID = SR.SHIP_RESULT_ID
            UNION ALL
            SELECT
                SRP.*,
                <cfif (database_type is 'MSSQL')>
                EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME,
                <cfelseif (database_type is 'DB2')>
                EMPLOYEES.EMPLOYEE_NAME ||' '|| EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME,
                </cfif>
                SR.COMPANY_ID,
                SR.PARTNER_ID,
                SR.CONSUMER_ID	,
                C.FULLNAME,
            	CR.CONSUMER_NAME + ' ' + CR.CONSUMER_SURNAME AS CONSUMER_NAME	
            FROM
                SHIP_RESULT_PACKAGE SRP,
                #dsn_alias#.EMPLOYEES EMPLOYEES,
                SHIP_RESULT SR
                LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = SR.COMPANY_ID
            	LEFT JOIN #DSN_ALIAS#.CONSUMER CR ON CR.CONSUMER_ID = SR.CONSUMER_ID
            WHERE 
                SRP.SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
                SRP.PACK_EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
                SRP.SHIP_ID = SR.SHIP_RESULT_ID
            )
            ORDER BY 
                SHIP_ID
        </cfquery>
        <!--- Cari ile iliskili irsaliye satirlari icin --->
        <cfset SHIP_RESULT_ID_CURRENTROW = QueryNew("SIRA,SHIP_RESULT_ID","Integer,Integer")>
        <cfscript>
            for(ii = 1; ii LTE get_row.recordcount; ii = ii + 1)
            {
                QueryAddRow(SHIP_RESULT_ID_CURRENTROW,1);
                QuerySetCell(SHIP_RESULT_ID_CURRENTROW,"SIRA",ii);
                QuerySetCell(SHIP_RESULT_ID_CURRENTROW,"SHIP_RESULT_ID",get_row.ship_result_id[ii]); 
            } 
        </cfscript>
        <!--- Cari ile iliskili paket satirlari icin --->
        <cfset PACKAGE_CURRENTROW = QueryNew("SIRA,SHIP_ID","Integer,Integer")><!--- ,COMPANY_ID,CONSUMER_ID --->
        <cfscript>
            for(ii = 1; ii LTE get_package.recordcount; ii = ii + 1)
            {
                QueryAddRow(PACKAGE_CURRENTROW,1);
                QuerySetCell(PACKAGE_CURRENTROW,"SIRA",ii);
                QuerySetCell(PACKAGE_CURRENTROW,"SHIP_ID",get_package.ship_id[ii]); 
            } 
        </cfscript>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	$(document).ready(function(){
		document.getElementById('keyword').focus();
		});
		function pencere_ac()
		{
			if((searchForm.city_id.value != "") && (searchForm.city.value != ""))
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=searchForm.county_id&field_name=searchForm.county&city_id=' + document.searchForm.city_id.value,'small');
			else
				alert("<cf_get_lang no='314.Lütfen İl Seçiniz'> !");
		}
		function kontrol()
			{
				if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!"))
					return false;
				else
					return true;	
			}
		function depot_date_change()
		{
			if(document.searchForm.planning_date.value != '')
			{
				var get_planning_info_js = wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.searchForm.planning_date.value));
				for(j=get_planning_info.recordcount;j>=0;j--)
					document.searchForm.team_code.options[j] = null;
				
				document.searchForm.team_code.options[0]= new Option('Ekip - Araç','');
				if(get_planning_info_js.recordcount)
					for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
						document.searchForm.team_code.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
			}
			return true;
		}
		
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>	
		$(document).ready(function() {
				calculate_type_deger = 1;
				row_count = 0;
				row_count2 = 0;
				kontrol_row_count = 0;
				money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
				rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
				rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
			});	
		
		function pencere_ac(no)
		{
			deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
			deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
			
			document.add_packet_ship.ship_id_list.value ='';
			if(deger_company_id != "")
			{
				for(r=1;r<=add_packet_ship.record_num.value;r++)
				{	
					deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+r).value;
					deger_ship_id = eval("document.add_packet_ship.ship_id"+r).value;
					deger_company_id2 = eval("document.add_packet_ship.company_id"+r).value;
					if(deger_row_kontrol == 1 && (deger_company_id2 == deger_company_id))
					{
						if(document.add_packet_ship.ship_id_list.value == '')
						{
							if(deger_ship_id != '')
								document.add_packet_ship.ship_id_list.value = deger_ship_id;
						}
						else
						{
							if(deger_ship_id != '')
								document.add_packet_ship.ship_id_list.value += ','+deger_ship_id;
						}	
					}
				}
				windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id,'project');
			}
			else if(deger_consumer_id != "")
			{
				for(r=1;r<=add_packet_ship.record_num.value;r++)
				{	
					deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+r).value;
					deger_ship_id = eval("document.add_packet_ship.ship_id"+r).value;
					deger_consumer_id2 = eval("document.add_packet_ship.consumer_id"+r).value;
					if(deger_row_kontrol == 1 && (deger_consumer_id2 == deger_consumer_id))
					{
						if(document.add_packet_ship.ship_id_list.value == '')
						{
							if(deger_ship_id != '')
								document.add_packet_ship.ship_id_list.value = deger_ship_id.value;
						}
						else
						{
							if(deger_ship_id != '')
								document.add_packet_ship.ship_id_list.value += ','+deger_ship_id.value;
						}	
					}
				}
				windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + ship_id_list.value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_consumer_id,'list');//&deliver_company_id='+add_packet_ship.service_company_id.value	
			}
			else
			{
				alert(no + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no='131.Cari Hesap Seçiniz'>");
				return false;
			}	
		}
		
		function pencere_ac_order(no)//order list
		{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=object.popup_list_orders_for_ship','list','popup_list_positions');
		}
		
		function pencere_ac2(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1','list','popup_list_positions');
		}
		
		function pencere_ac_cari(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_packet_ship.company_id'+ no +'&field_partner=add_packet_ship.partner_id'+ no +'&field_consumer=add_packet_ship.consumer_id'+ no +'&field_comp_name=add_packet_ship.member_name'+ no +'&field_name=add_packet_ship.member_name'+ no +'&call_function=cari_kontrol('+no+')&select_list=7,8','list','popup_list_all_pars');
		}
		
		function cari_kontrol(no)
		{
			deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
			deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
			if(deger_company_id !='')
				deger_cari = deger_company_id;
			else
				deger_cari = deger_consumer_id;
			for(ck=1;ck<=add_packet_ship.record_num.value;ck++)
			{
				deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+ck).value;
				if (deger_company_id != '')
					deger_cari_row = eval("document.add_packet_ship.company_id"+ck).value;
				else
					deger_cari_row = eval("document.add_packet_ship.consumer_id"+ck).value;
				//Satir silinmemis,ilgili satırla dongudeki satir farkli mi ve deger aynimi
				if(deger_row_kontrol == 1 && (ck != no) && (deger_cari == deger_cari_row)) 
					eval("document.add_packet_ship.cari_kontrol"+no).value = ck;
			}
		}
		
		function sil(sy)
		{
			for(r=1;r<=add_packet_ship.record_num_other.value;r++)
			{
				deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+r).value;
				deger_row_count_other = eval("document.add_packet_ship.row_count_other"+r).value;
				if(deger_row_kontrol_other == 1 && (deger_row_count_other == sy))//satir silinmemis ve irsaliye ile iliskili ise
				{
					alert("<cf_get_lang no ='481.İlgili İrsaliye ile İlişkili Paketler Mevcut Kontrol Ediniz'>!");
					return false;
				}
			}
		
			kontrol_row_count--;
			var my_element=eval("add_packet_ship.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		
			for(rr=1;rr<=add_packet_ship.record_num.value;rr++)
			{
				deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+rr).value;
				deger_related_row_kontrol = eval("document.add_packet_ship.related_row_kontrol"+rr).value;
				if(deger_row_kontrol == 1 && (deger_related_row_kontrol == sy))
				{
					kontrol_row_count--;
					var my_element=eval("add_packet_ship.row_kontrol"+rr);
					my_element.value=0;
					var my_element=eval("frm_row"+rr);
					my_element.style.display="none";	
				}
			}
		}
		
		function sil_other(sy)
		{
			//irsaliye ve paket satir iliskisi icin silinen satırda 
			temp_row_count_other = eval("document.add_packet_ship.row_count_other"+sy).value;
			temp_cari_ship_id_list = eval("document.add_packet_ship.cari_" +temp_row_count_other+ "_ship_id_list").value;
			
			var temp_ship_id_list = '';
			for(r=1;r<=list_len(temp_cari_ship_id_list);r++)
			{
				if(list_getat(temp_cari_ship_id_list,r) != sy)
				{
					if(temp_ship_id_list == '')
						temp_ship_id_list = list_getat(temp_cari_ship_id_list,r);
					else
						temp_ship_id_list += ','+list_getat(temp_cari_ship_id_list,r);
				}
			}
			
			eval("document.add_packet_ship.cari_" +temp_row_count_other+ "_ship_id_list").value = temp_ship_id_list;
		
			var my_element=eval("add_packet_ship.row_kontrol_other"+sy);
			my_element.value=0;
			var my_element=eval("frm_row_other"+sy);
			my_element.style.display="none";
			degistir(sy);
		}
		
		
		function degistir(id)
		{
			if(document.add_packet_ship.ship_method_id.value != "" && document.add_packet_ship.transport_comp_id.value != "")
			{
				//Coklu satir mantigi icin eklendi ship_id_list degerine ulasmak icin
				temp_row_count_other = eval("document.add_packet_ship.row_count_other"+id).value;
				var ship_id_list = eval("document.add_packet_ship.cari_"+temp_row_count_other+"_ship_id_list").value;
				
				price_sum = 0;
				if(document.add_packet_ship.calculate_type[1].checked)
				{
					for(ii=1;ii<=list_len(ship_id_list);ii++)
					{
						//hangi satırdaki paketler hesaplamaya dahil edilecek
						var ii_ = list_getat(ship_id_list,ii);
						if(eval("document.add_packet_ship.row_kontrol_other"+ii_).value == 1)
						{
							var temp_package_type = eval("document.add_packet_ship.package_type"+ii_);
							var temp_ship_ebat = eval("document.add_packet_ship.ship_ebat"+ii_);
							var temp_total_price = eval("document.add_packet_ship.total_price"+ii_);
							var temp_quantity = eval("document.add_packet_ship.quantity"+ii_);
							var temp_other_money = eval("document.add_packet_ship.other_money"+ii_);
							var temp_ship_agirlik = eval("document.add_packet_ship.ship_agirlik"+ii_);
							
							if(trim(eval("add_packet_ship.quantity"+ii_).value).length == 0)
								eval("add_packet_ship.quantity"+ii_).value = 1;
							
							temp_desi = list_getat(temp_package_type.value,2,',');
							temp_package_type_id = list_getat(temp_package_type.value,3,',');
							if(temp_package_type_id==1) //Desi
							{
								temp_ship_ebat.value = temp_desi;
								temp_ship_agirlik.value = '';
								desi_1 = list_getat(temp_desi,1,'*');
								desi_2 = list_getat(temp_desi,2,'*');
								desi_3 = list_getat(temp_desi,3,'*');
								desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
								if(desi_hesap<document.add_packet_ship.max_limit.value)
								{
		
									var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + desi_hesap;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
								else
								{
									var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
							}
							else if(temp_package_type_id==2) 
							{	
								temp_ship_ebat.value = '';
								if(trim(temp_ship_agirlik.value).length == 0)
									temp_ship_agirlik.value = 1;
								temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
								if(temp_ship_agirlik_>document.add_packet_ship.max_limit.value)
									temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
								if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
								{
									if(temp_ship_agirlik_<document.add_packet_ship.max_limit.value)
									{
										var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + temp_ship_agirlik_;
										var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
									}
									else
									{
										var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
										var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
									}
								}	
							}	
							else if(temp_package_type_id==3)  //Zarf ise
							{
								var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
							}
							
							if(GET_PRICE != undefined)
							{
								if(GET_PRICE.recordcount==0)
								{
									alert("<cf_get_lang no ='471.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
									temp_ship_ebat.value = "";
									temp_total_price.value = "";
									temp_other_money.value = "";
								}
								else
								{
									if(temp_package_type_id==1)//Desi ise
									{
										temp_ship_agirlik.value = "";
										if(desi_hesap<document.add_packet_ship.max_limit.value)
										{
											temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
											price_sum += parseFloat((GET_PRICE.PRICE*temp_quantity.value));
										}
										else
										{
											var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
											desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.add_packet_ship.max_limit.value</cfoutput>);
											temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
											price_sum += parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value);
											
										}
									}
									if(temp_package_type_id==2)//Kg ise
									{
										temp_ship_ebat.value = "";
										if(trim(temp_ship_agirlik.value).length == 0)
											temp_ship_agirlik.value = 1;							
										if(temp_ship_agirlik_<document.add_packet_ship.max_limit.value)
										{
											price_sum += parseFloat(GET_PRICE.PRICE);
										}
										else
										{
											var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
											kg_remain = parseFloat(temp_ship_agirlik_-document.add_packet_ship.max_limit.value);
											temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
											price_sum += parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain);
										}
									}				
									
									else if(temp_package_type_id==3)//Zarf ise
									{
										temp_ship_agirlik = '';
										temp_ship_ebat.value = '';
										temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
										price_sum += parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value);
									}
									temp_other_money.value = GET_PRICE.OTHER_MONEY;
								}
							}
							else
							{
								temp_total_price.value = "";
								temp_other_money.value = "";	
							}
						}
					}
					eval("add_packet_ship.total_cost_value"+temp_row_count_other).value = commaSplit(price_sum);
					var temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
					var temp2_rate1 = list_getat(rate1_list,temp2_sira);
					var temp2_rate2 = list_getat(rate2_list,temp2_sira);
					var total_cost2_value = price_sum * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
					eval("add_packet_ship.total_cost2_value"+temp_row_count_other).value = commaSplit(total_cost2_value);
				}
				else
				{
					count_desi = 0;
					count_kg = 0;
					count_envelope = 0;
					desi_sum = 0;
					kg_sum = 0;
					desi_price_sum = 0;
					kg_price_sum = 0;
					envelope_price_sum = 0;
					
					for(ii=1;ii<=list_len(ship_id_list);ii++)
					{
						//hangi satırdaki paketler hesaplamaya dahil edilecek
						var ii_ = list_getat(ship_id_list,ii);
						if(eval("document.add_packet_ship.row_kontrol_other"+ii_).value == 1)
						{
							var temp_quantity = document.getElementById('quantity'+ii_);
							var temp_package_type = document.getElementById('package_type'+ii_);
							var temp_ship_ebat = document.getElementById('ship_ebat'+ii_);
							var temp_ship_agirlik = document.getElementById('ship_agirlik'+ii_);
							
							if(trim(eval("add_packet_ship.quantity"+ii_).value).length == 0)
								eval("add_packet_ship.quantity"+ii_).value = 1;
			
							var temp_desi = list_getat(temp_package_type.value,2,',');
							var temp_package_type_id = list_getat(temp_package_type.value,3,',');
			
							if(temp_package_type_id==1) //Desi
							{
								count_desi += 1;
								temp_ship_ebat.value = temp_desi;
								temp_ship_agirlik.value = '';
								desi_1 = list_getat(temp_desi,1,'*');
								desi_2 = list_getat(temp_desi,2,'*');
								desi_3 = list_getat(temp_desi,3,'*');
								desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
								desi_sum +=desi_hesap;
							}
							else if(temp_package_type_id==2)//Kg
							{
								count_kg += 1;
								temp_ship_ebat.value = "";
								if(trim(eval("add_packet_ship.ship_agirlik"+ii_).value).length == 0)
									eval("add_packet_ship.ship_agirlik"+ii_).value = 1;
								temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
								if(temp_ship_agirlik.value != "" && temp_ship_agirlik.value !=0)
									kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
							}	
							else if(temp_package_type_id==3)//Zarf ise
							{
								count_envelope += 1;
								temp_ship_agirlik.value = '';
								temp_ship_ebat.value = '';
								var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value;
								var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
								if(GET_PRICE3 != undefined)
								{
									if(GET_PRICE3.recordcount==0)
										alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
									else
										envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
								}					
							}
						}
					}
					
					if(count_desi != 0)
					{
						
						if(desi_sum<document.add_packet_ship.max_limit.value)
						{
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + desi_sum;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						
						if(GET_PRICE1 != undefined)
						{
							if(GET_PRICE1.recordcount==0)
								alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
							{
								if(desi_sum<document.add_packet_ship.max_limit.value)
								{
									desi_price_sum = GET_PRICE1.PRICE;
								}
								else
								{					
									var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
									desi_remain2 = parseFloat(desi_sum-document.add_packet_ship.max_limit.value);
									desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
								}
							}
						}
					}
					
					if(count_kg != 0)
					{
			
						if(kg_sum<document.add_packet_ship.max_limit.value)
						{
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + kg_sum;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						
						if(GET_PRICE1 != undefined)
						{
							if(GET_PRICE1.recordcount==0)
								alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
							{
								if(kg_sum<document.add_packet_ship.max_limit.value)
									kg_price_sum = GET_PRICE1.PRICE;
								else
								{	
									var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.add_packet_ship.transport_comp_id.value);
									kg_remain2 = parseFloat(kg_sum-document.add_packet_ship.max_limit.value);
									kg_remain2 = Math.ceil(kg_remain2);
									kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
								}
							}
						}
					}
			
					eval("add_packet_ship.total_cost_value"+temp_row_count_other).value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
					//document.add_packet_ship.total_cost_value.value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));*/
				}
				return kur_hesapla();
			}
		}
		
		function control()
		{
			if(document.add_packet_ship.options_kontrol.value==0 || document.add_packet_ship.options_kontrol.value == "")
			{	
				alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
				return false;
			}
			
			if(add_packet_ship.ship_method_id.value == "")	
			{
				alert("<cf_get_lang no='305.Lütfen Sevk Yöntemi Seçiniz'>!");
				return false;
			}
			
			if(add_packet_ship.transport_comp_id.value == "")	
			{
				alert("<cf_get_lang no='318.Taşıyıcı Seçiniz'>!");
				return false;
			}
			
			if(kontrol_row_count == 0)
			{
				alert("<cf_get_lang no ='484.En Az Bir Satır İrsaliye Kaydı Giriniz'>!");
				return false;
			}	
			
			//Cari ve irsaliye kontrolleri
			temp_satir=0;	
			for(cr=1;cr<=add_packet_ship.record_num.value;cr++)
			{
				deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+cr).value;
				deger_company_id = eval("document.add_packet_ship.company_id"+cr).value;
				deger_consumer_id = eval("document.add_packet_ship.consumer_id"+cr).value;
				deger_ship_id = eval("document.add_packet_ship.ship_id"+cr).value;
				deger_cari_kontrol = eval("document.add_packet_ship.cari_kontrol"+cr).value;
				if(deger_row_kontrol == 1)
				{
					temp_satir++;
					if(deger_company_id=="" && deger_consumer_id=="")
					{
						alert(temp_satir + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no='131.Cari Hesap Seçiniz'>");
						return false;
					}
					if(deger_ship_id == "")
					{
						alert(temp_satir + "<cf_get_lang no ='480.Satır İçin'><cf_get_lang no ='306.İrsaliye Seçiniz'>!");
						return false;
					}
					if(deger_cari_kontrol != "")
					{
						alert(temp_satir + ".<cf_get_lang no ='485.Satır İçin Cari Değerini Kontrol Ediniz'>!");
						return false;
					}			
				}
			}
		
			// Paket kontrolleri
			for(r=1;r<=add_packet_ship.record_num_other.value;r++)
			{
				deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+r);
				deger_package_type = eval("document.add_packet_ship.package_type"+r);
				if(deger_row_kontrol_other.value == 1)
				{
					if(deger_package_type.value == "")
					{
						alert("<cf_get_lang no='307.Lütfen Paket Tipi Seçiniz'>!");
						return false;
					}
				}
			}
			unformat_fields();
			if(process_cat_control())
				return paper_control(add_packet_ship.transport_no1,'SHIP_FIS');
			else
				return false;	
		}
		
		function kur_hesapla()
		{
			total_cost_value = 0;
			if(document.add_packet_ship.calculate_type[1].checked)
			{		
				for(r=1;r<=add_packet_ship.record_num_other.value;r++)
				{	
					if(eval("document.add_packet_ship.row_kontrol_other"+r).value == 1)
					{
						var temp_other_money = eval("document.add_packet_ship.other_money"+r);
						var temp_total_price = eval("document.add_packet_ship.total_price"+r);
						
						if(temp_total_price.value != '')
						{
							temp_sira = list_find(money_list,temp_other_money.value);	
							temp_rate1 = list_getat(rate1_list,temp_sira);
							temp_rate2 = list_getat(rate2_list,temp_sira);
							temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / ((parseFloat(temp_rate1) / parseFloat(temp_rate2))));
							total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
						}
					}
				}
				temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
				temp2_rate1 = list_getat(rate1_list,temp2_sira);
				temp2_rate2 = list_getat(rate2_list,temp2_sira);
				total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
				document.add_packet_ship.total_cost_value.value = commaSplit(total_cost_value);
				document.add_packet_ship.total_cost2_value.value = commaSplit(total_cost2_value);
			}
			else
			{
				for(rk=1;rk<=add_packet_ship.record_num.value;rk++)
				{
					
					temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
					temp2_rate1 = list_getat(rate1_list,temp2_sira);
					temp2_rate2 = list_getat(rate2_list,temp2_sira);
					temp_total_cost_value = eval("add_packet_ship.total_cost_value"+rk).value;
					total_cost2_value = parseFloat(filterNum(temp_total_cost_value)) * ((parseFloat(temp2_rate1) / parseFloat(temp2_rate2)));
					eval("add_packet_ship.total_cost2_value"+rk).value = commaSplit(total_cost2_value);
					//document.add_packet_ship.total_cost2_value.value = commaSplit(total_cost2_value);
				}
			}
			
			sum_total_cost_value = 0;
			sum_total_cost2_value = 0;
			
			for(r=1;r<=add_packet_ship.record_num.value;r++)
			{
				if(eval("document.add_packet_ship.row_kontrol"+r).value == 1)
				{
					var temp =eval("add_packet_ship.total_cost_value"+r);
					var temp2 =eval("add_packet_ship.total_cost2_value"+r);
					temp_total_cost_value = filterNum(temp.value);
					temp_total_cost2_value = filterNum(temp2.value);
			
					sum_total_cost_value = sum_total_cost_value+temp_total_cost_value;
					sum_total_cost2_value = sum_total_cost2_value+temp_total_cost2_value;			
				}		
			}
			
			add_packet_ship.total_cost_value.value = commaSplit(sum_total_cost_value);
			add_packet_ship.total_cost2_value.value = commaSplit(sum_total_cost2_value);
		
			return true;
		}
		
		function unformat_fields()
		{
			for(r=1;r<=add_packet_ship.record_num_other.value;r++)
			{
				if(eval("document.add_packet_ship.row_kontrol_other"+r).value == 1)
				{
					eval("document.add_packet_ship.quantity"+r).value = filterNum(eval("document.add_packet_ship.quantity"+r).value);
					eval("document.add_packet_ship.ship_agirlik"+r).value = filterNum(eval("document.add_packet_ship.ship_agirlik"+r).value);
					eval("document.add_packet_ship.total_price"+r).value = filterNum(eval("document.add_packet_ship.total_price"+r).value);
				}
			}
			for(kr=1;kr<=add_packet_ship.record_num.value;kr++)
			{
				if(eval("document.add_packet_ship.row_kontrol"+kr).value == 1)
				{
					eval("document.add_packet_ship.total_cost_value"+kr).value = filterNum(eval("document.add_packet_ship.total_cost_value"+kr).value);
					eval("document.add_packet_ship.total_cost2_value"+kr).value = filterNum(eval("document.add_packet_ship.total_cost2_value"+kr).value);
		
				}
			}	
		}
		
		function kontrol_prerecord()
		{
			if(document.add_packet_ship.transport_comp_id.value != "")
			{
		
				var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.add_packet_ship.transport_comp_id.value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
				if(GET_MAX_LIMIT.recordcount > 0)
				{
					document.add_packet_ship.max_limit.value=GET_MAX_LIMIT.MAX_LIMIT;
					if(GET_MAX_LIMIT.CALCULATE_TYPE==1)
					{
						document.add_packet_ship.calculate_type[0].checked = true;
						document.add_packet_ship.options_kontrol.value=1;/*Form'u kontrol etmek için,*/
					}
					else if	(GET_MAX_LIMIT.CALCULATE_TYPE==2)
					{
						document.add_packet_ship.calculate_type[1].checked=true;
						document.add_packet_ship.options_kontrol.value=1;/*Form'u kontrol etmek için,*/
					}
					for(xx=1;xx<=add_packet_ship.record_num_other.value;xx++)
					{
						deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+xx);
						if(deger_row_kontrol_other.value == 1)
							degistir(xx);
					}			
				}
				else		
				{
					alert("<cf_get_lang no ='486.Lütfen Hesaplama için Tasıyıcı Firmayı Kontrol Ediniz (Fiyat Listesi)'>!");
					
					document.add_packet_ship.calculate_type[0].checked=false;
					document.add_packet_ship.calculate_type[1].checked=false;
					document.add_packet_ship.options_kontrol.value=0;
					document.add_packet_ship.max_limit.value=0;
					return false;	
				}
			}
		}
			// Emirler Ekranından Toplu Sevkiyat ile geliyorsa
			<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
				<cfoutput query="add_logistic">
				<cfif not (member_id[currentrow] neq member_id[currentrow-1])>
					<cfquery name="GET_LINE" dbtype="query" maxrows="1">
						SELECT LINE FROM ALL_LOGISTIC WHERE MEMBER_TYPE = #add_logistic.member_type# AND MEMBER_ID = #add_logistic.member_id# ORDER BY LINE
					</cfquery>
				
					deger_row_count_list = eval("document.add_packet_ship.row_count_" +#get_line.line#+ "_list");
				</cfif>
					row_count++;
					kontrol_row_count++;
						
					var newRow;
					var newCell;
					newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);		
					document.add_packet_ship.record_num.value=row_count;
				
					newCell = newRow.insertCell(newRow.cells.length);
				<cfif (member_id[currentrow] neq member_id[currentrow-1])>
					newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="">&nbsp;<a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="icon-ellipsis" title="<cf_get_lang no="146.İlişkili İrsaliye Ekle">"></i></a>&nbsp;<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');"><i class="icon-pluss"></i></a>&nbsp;<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"></i></a>';
				<cfelse>
					newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="#get_line.line#">';
					if(deger_row_count_list.value == '')
						deger_row_count_list.value = #currentrow#;
					else
						deger_row_count_list.value += ','+#currentrow#;			
				</cfif>
				<cfif len(add_logistic.company_id)>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="#add_logistic.company_id#"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="#add_logistic.partner_id#"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="#add_logistic.member_name#" readonly style="width:150px;"> <a href="javascript://" onClick="pencere_ac_cari('+ row_count +');"><i class="icon-ellipsis"></i></a>';
				<cfelse>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="#add_logistic.consumer_id#"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="#add_logistic.member_name#" readonly style="width:150px;"> <a href="javascript://" onClick="pencere_ac_cari('+ row_count +');"><i class="icon-ellipsis"></i></a>';
				</cfif>	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value="#add_logistic.ship_id#"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'"  value="#add_logistic.ship_number#" readonly style="width:110px;"> <a href="javascript://" onClick="pencere_ac('+ row_count +');"><i class="icon-ellipsis"></i></a>';
					
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#add_logistic.member_name2#"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(add_logistic.ship_date,"dd/mm/yyyy")#" readonly style="width:65px;">';
					
				<cfif len(add_logistic.ship_method)>
					<cfquery name="GET_SHIP_METHOD" datasource="#DSN#"> 
						SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #add_logistic.ship_method#
					</cfquery>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly style="width:150px;">';
				<cfelse>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
				</cfif>
					
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#replace(address,"#Chr(13)##chr(10)#"," ","all")#" readonly style="width:200px;">';
					
				<cfif (member_id[currentrow] neq member_id[currentrow-1])>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">&nbsp;#session.ep.money#<input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">&nbsp;#session.ep.money2#';
				<cfelse>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;"><input type="hidden" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">';
				</cfif>
				</cfoutput>
				<cfif get_control_.recordcount>
					alert('Daha Önce Sevk Edilmiş Kayıtlar : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
				</cfif>
			</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		$(document).ready(function(){
			row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
			<cfif x_equipment_planning_info eq 0>
				<cfoutput>
				calculate_type_deger=#get_ship_method_price.CALCULATE_TYPE#;
				<cfif isdefined("get_package")>
					row_count2=#get_package.recordcount#;
				</cfif>
				money_list = "#valuelist(moneys.money,',')#";
				rate1_list = "#valuelist(moneys.rate1,',')#";
				rate2_list = "#valuelist(moneys.rate2,',')#";
				</cfoutput>
			</cfif>
			kontrol_row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
			production_row_ = 0;
			production_row_alert_ = '';	
			order_amount_control = 0;
			is_add_sale_=1;
		});
		
		<cfif x_equipment_planning_info eq 1>
			
			function row_all_control(no_,ono_)
			{
				order_wrk_row_list_ = '';
				<cfif get_row.recordcount>
				<cfoutput query="get_row">
					<cfquery name="Get_Orders_Info" datasource="#dsn3#">
						SELECT
							O.ORDER_NUMBER,
							OW.PRODUCT_NAME,
							OW.SPECT_VAR_ID,
							OW.SPECT_VAR_NAME,
							OW.ORDER_ROW_CURRENCY,
							(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE
						FROM
							ORDERS O,
							ORDER_ROW OW
						WHERE
							O.ORDER_ID = OW.ORDER_ID AND
							OW.WRK_ROW_ID = '#Wrk_Row_Relation_Id#'
					</cfquery>
					<cfif Get_Orders_Info.RecordCount and Get_Orders_Info.ORDER_ROW_CURRENCY eq -5>
						if(document.getElementById("ship_row_amount_#currentrow#").value > 0)
						{
							production_row_ = 1;
							production_row_alert_ = production_row_alert_ + "\n #Get_Orders_Info.Order_Number# : #Get_Orders_Info.Product_Name# - #Get_Orders_Info.Spect_Var_Name#";
						}
					</cfif>
					if(no_ == 3)
					{
						<cfif get_row.is_problem neq 1>
							document.getElementById("ship_row_amount_#currentrow#").value = filterNum(document.getElementById("order_row_amount_#currentrow#").value,0);
						<cfelse>
							document.getElementById("ship_row_amount_#currentrow#").value = 0;
						</cfif>
						document.getElementById("spect_control_number").value = 0;
					}
					<cfif Get_Orders_Info.Control_Type eq 2 and Len(Get_Orders_Info.Spect_Var_Id)>
						<cfquery name="Get_Row_Component" datasource="#dsn2#">
							SELECT * FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = #Ship_Result_Id# AND SHIP_RESULT_ROW_ID = #Ship_Result_Row_Id#
						</cfquery>
						var bolum_ = 999999999999999;
						<cfif Get_Row_Component.RecordCount>
						<cfloop query="Get_Row_Component">
							if(no_ == 1 || no_ == 5)
							{
								var spect_amount_script_ = filterNum(document.getElementById("spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
								var spect_to_ship_amount_script_ = filterNum(document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
								if (spect_to_ship_amount_script_ != undefined)
								{
									if(bolum_ >= parseInt(spect_to_ship_amount_script_/#Get_Row_Component.Component_Amount#))
									{
										bolum_ = parseInt(spect_to_ship_amount_script_/#Get_Row_Component.Component_Amount#);
									}
								}
								<cfif not ListLen(Ship_Wrk_Row_List,';')>
									document.getElementById("spect_control_number").value = 1;
								</cfif>
						
							}
							if(no_ == 3)
							{
								if(document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#") != undefined)
								{
								<cfif get_row.is_problem neq 1>
									document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value = filterNum(document.getElementById("spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
								<cfelse>
									document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value = 0;
								</cfif>
								}
							}
							//4 no silme isleminde bilesenleri de satirlardan temizlemek icin kullaniliyor
							if(no_ == 4 && ono_ == #get_row.currentrow#)
							{
								var my_element2=eval("frm_rows"+#get_row.currentrow#+'_'+#Get_Row_Component.currentrow#);
								my_element2.style.display="none";
							}
						</cfloop>
						</cfif>
						if (no_ == 1 || no_ == 5)
						{
							<cfif get_row.is_problem neq 1>
								document.getElementById("ship_row_amount_#currentrow#").value = commaSplit(bolum_,0);
							<cfelse>
								document.getElementById("ship_row_amount_#currentrow#").value = 0;
							</cfif>
						}
					</cfif>
					if(no_ != 4)
					{
						var ship_row_amount_script_ = filterNum(document.getElementById("ship_row_amount_#currentrow#").value,0);
						<cfif get_row.is_problem neq 1>//Sorunlu Kayitlar Tekrar Eklenmeyecek
						if(document.getElementById("order_wrk_row_id#currentrow#").value != '' && ship_row_amount_script_ != '' && ship_row_amount_script_ > 0)
						{
							var order_wrk_row_list_ = order_wrk_row_list_  + '#get_row.Wrk_Row_Relation_Id#_' + filterNum(document.getElementById("ship_row_amount_#currentrow#").value,2,0) + ';';
							order_amount_control ++;
						}
						</cfif>
						<cfif not ListLen(Ship_Wrk_Row_List,';')>
							document.getElementById("order_wrk_row_list").value = order_wrk_row_list_;
						</cfif>
					}
				</cfoutput>
				</cfif>
				if(no_ == 5)
				{
					//En az Bir Satir Bulunmasi ile Ilgili Kontrol
					var satir_kontrol2_ = 0;
					for(kk=1; kk <= document.getElementById("record_num").value; kk++)
					{	
						if(document.getElementById("row_kontrol"+kk).value == 1)
							var satir_kontrol2_ = satir_kontrol2_ + 1;
					}
					
					if(satir_kontrol2_ == 0)
					{
						alert("Sevkiyatta En Az Bir Satır Bulunmalıdır !");
						return false;
					}
				}
				if(no_ == 1)
				{
					//Burada uretim asamasindaki siparisler icin kullaniciya bilgi veriyoruz, devam etmeyebilir.
					if(production_row_ == 1)
					{
						if(!(confirm("Üretim Aşamasında Ürünü Sevk Ediyorsunuz ! Devem Edecek Misiniz ? " + production_row_alert_)))
						{
							production_row_ = 0;
							production_row_alert_ = '';
							return false;
						}
						production_row_ = 0;
						production_row_alert_ = '';
					}
					if(order_amount_control <= 0)
					{
						alert("İrsaliye/Fatura Oluşturmak İçin En Az Bir Ürüne Miktar Girmelisiniz !");
						return false;
					}
					document.upd_packet_ship.action='<cfoutput>#request.self#?fuseaction=stock.emptypopup_add_multi_packetship_to_ship&x_ship_group_dept=#x_ship_group_dept#</cfoutput>';
					document.upd_packet_ship.submit();
					return false;
				}
			}
		
			
			function kontrol_sevk()
			{
				if(is_add_sale_ == 1)
				{
					is_add_sale_ = 0;
					
					//En az Bir Satir Bulunmasi ile Ilgili Kontrol
					var satir_kontrol_ = 0;
					for(kk=1; kk <= document.getElementById("record_num").value; kk++)
					{	
						if(document.getElementById("row_kontrol"+kk).value == 1)
							var satir_kontrol_ = satir_kontrol_ + 1;
					}
					
					if(satir_kontrol_ == 0)
					{
						alert("Sevkiyatta En Az Bir Satır Bulunmalıdır !");
						return false;
					}
					if(document.getElementById("process_type_ship").value == '')
					{
						alert("Lütfen İşlem Tipi Seçiniz ve/veya Tanımlanan İşlem Tipleri Üzerinde Yetkiniz Yok !");
						return false;
					}
					<cfif not Len(listfirst(location_info_,','))>
						alert("İrsaliye/Fatura Oluşturmak İçin Önce Depo Seçip İşlemi Güncellemelisiniz !");
						return false;
					</cfif>
					<cfif x_select_process_type eq 2>
						var get_paper_no = wrk_safe_query('obj_get_papers_no','dsn3',0,"<cfoutput>#session.ep.userid#</cfoutput>");
						if(get_paper_no.recordcount == 0 || get_paper_no.INVOICE_NO == '' || get_paper_no.INVOICE_NUMBER == '')
						{
							alert("Lütfen Kişisel Ayarlarınızdan Belge Numaralarınızı Tanımlayınız. Ayarlarım>Belge No sayfasını Kullanınız !");
							return false;
						}
					</cfif>
					var hata = '';
					var hatap = '';
					var hatas = '';
					var rowCount = kontrol_row_count;
					var popup_spec_type=1; //specli stok
					
					var dep_id = upd_packet_ship.department_id.value;
					var loc_id = upd_packet_ship.location_id.value;
					
					for(kk_indx=1;kk_indx<=list_len(document.getElementById("new_dept_list").value);kk_indx++)
					{
						var stock_id_list='0';
						var stock_amount_list='0';
						var spec_id_list='0';
						var spec_amount_list='0';
						var main_spec_id_list='0';
						var main_spec_amount_list='0';
						var no_send_stock_id_list_ = '0';
						for (var counter_=1; counter_ <= rowCount; counter_++)
						{
							if(parseFloat(filterNum(document.getElementById("ship_row_amount_"+counter_).value)) > 0)
							{
								var stock_field = document.getElementById("stock_id"+counter_).value;
								var amount_field = document.getElementById("ship_row_amount_"+counter_).value;
								var spec_field = document.getElementById("spect_var_id"+counter_).value;
								var dep_id_ = document.getElementById("dep_id"+counter_).value;
								var loc_id_ = document.getElementById("loc_id"+counter_).value;
								kontrol_dept_row = 0;
								<cfif isdefined("x_ship_group_dept") and x_ship_group_dept eq 1>//depo bazında gruplama
									if(dep_id_ != 0)
									{
										var dep_id = dep_id_;
										var loc_id = loc_id_;
									}
									new_dep_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),1,'_');
									new_loc_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),2,'_');
									kontrol_dept_row = 1;
								</cfif>
								
								if(kontrol_dept_row == 0 || (kontrol_dept_row == 1 && dep_id == new_dep_id && loc_id == new_loc_id))
								{
									if(spec_field != undefined && spec_field != '')
									{
										var yer=list_find(spec_id_list,spec_field,',');
										if(yer)
										{
											top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(amount_field));
											spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
										}
										else
										{
											spec_id_list=spec_id_list + ',' + spec_field;
											spec_amount_list=spec_amount_list+','+filterNum(amount_field);
										}
									}
							
									//artık uretilen urun icinde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
									var yer=list_find(stock_id_list,stock_field,',');
									if(yer)
									{
										top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(amount_field));
										stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
									}
									else
									{
										stock_id_list=stock_id_list+',' + stock_field;
										stock_amount_list=stock_amount_list+',' + filterNum(amount_field);
									}
								}
							}
						}
						<cfif isdefined("x_ship_group_dept") and x_ship_group_dept eq 1>
							dep_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),1,'_');
							loc_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),2,'_');
						</cfif>
						main_spec_id_list = spec_id_list;
						main_spec_amount_list = spec_amount_list;
						get_spect = '';	
						var stock_id_count=list_len(stock_id_list,',');
			
						//specli stok kontrolleri
						if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//specli stok bakılacaksa 
						{
							var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + loc_id + "*" + dep_id;
							if(dep_id == '' || dep_id == undefined || loc_id == '' || loc_id == undefined)
								var new_sql = 'stk_get_total_stock_16';
							else
							{
								var new_sql = 'stk_get_total_stock_17';
							}
							var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
							var query_spec_id_list = '0';
							if(get_total_stock.recordcount)
							{
								for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
								{
									query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
									var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
									if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
									{
										hatas = hatas + get_total_stock.MAIN_PRODUCT_NAME[cnt] + '-' + get_total_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: ' + get_total_stock.STOCK_CODE[cnt] + ' / Stok Miktarı: '+  parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) +')\n';
										no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_total_stock.STOCK_ID[cnt]; 
									}
								}
							}
							var diff_spec_id='0';
							for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
							{
								var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
								if(!list_find(query_spec_id_list,spc_id,','))
									diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
							}
							
							if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
							{
								var get_stock = wrk_safe_query('stk_get_stock_3','dsn3',0,diff_spec_id);
								for(var cnt=0; cnt < get_stock.recordcount; cnt++)
								{
									hatas = hatas + get_stock.MAIN_PRODUCT_NAME[cnt] + '-' + get_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: ' + get_stock.STOCK_CODE[cnt]+ ' / Stok Miktarı: 0)\n';
									no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_stock.STOCK_ID[cnt]; 
								}
							}
							get_total_stock='';
						}
						//stock kontrolleri
						if(stock_id_count >1)
						{
							var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + no_send_stock_id_list_ + "*" + loc_id + "*" + dep_id;
							if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
								var new_sql = 'stk_get_total_stock_18';			
							else
								var new_sql = 'stk_get_total_stock_19';
				
							var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);			
							if(get_total_stock.recordcount)
							{
								var query_stock_id_list='0';
								for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
								{
									query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
									var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
									if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
									{
										hatap = hatap + get_total_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]  + ' / Stok Miktarı: '+  parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) + ')\n';
										no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_total_stock.STOCK_ID[cnt]; 
									}
								}
							}
							var diff_stock_id='0';
							for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
							{
								var stk_id=list_getat(stock_id_list,lst_cnt,',')
								if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
									diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
							}
							if(list_len(diff_stock_id,',')>1)//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
							{
								var listParam = diff_stock_id + "*" + no_send_stock_id_list_;
								var get_stock = wrk_safe_query("stk_get_total_stock_20",'dsn3',0,listParam);
								for(var cnt=0; cnt < get_stock.recordcount; cnt++)
								{
									hatap = hatap + get_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: '+get_stock.STOCK_CODE[cnt] + ' / Stok Miktarı: 0)\n';
									no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_stock.STOCK_ID[cnt]; 
								}
							}
							get_total_stock='';
							hata = hatap + hatas;
						}
					}
					var sifir_stok_yapilsin_mi = list_getat(document.getElementById("process_type_ship").value,1,'_');
					if(sifir_stok_yapilsin_mi == 1)
					{
						if(hatap!='' || hatas!='')
						{
							alert(hata + "\n\nYukarıdaki Ürünlerde Stok Miktarı Yeterli Değildir. \nLütfen Miktarları Kontrol Ediniz !");
							is_add_sale_ = 1;
							return false;
						}
					}
					else
					{
						if(hatap!='' || hatas!='')
						{
							if(!confirm(hata + "\n\nYukarıdaki Ürünlerde Stok Miktarı Yeterli Değildir. \nLütfen Miktarları Kontrol Ediniz !"))
							{
								document.getElementById("no_send_stock_id_list").value = no_send_stock_id_list_; // irsaliye fonksiyonundaki kontrolleri duzenlemek icin eklendi
								is_add_sale_ = 1;
								return false;
							}
							
						}
					}
					hata='';
					hatap = '';
					hatas = '';
					return row_all_control(1);
				}
				else
					return false;
			}
			
		</cfif>
		<cfif x_equipment_planning_info eq 0>
			function pencere_ac(no)
			{
				deger_company_id = document.getElementById("company_id"+no).value;
				deger_consumer_id = document.getElementById("consumer_id"+no).value;
				
				document.getElementById("ship_id_list").value ='';
				if(deger_company_id != "")
				{
					for(r=1;r<=document.getElementById("record_num").value;r++)
					{	
						deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
						deger_ship_id = document.getElementById("ship_id"+r).value;
						deger_company_id2 = document.getElementById("company_id"+r).value;
						if(deger_row_kontrol == 1 && (deger_company_id2 == deger_company_id))
						{
							if(document.getElementById("ship_id_list").value == '')
							{
								if(deger_ship_id != '')
									document.getElementById("ship_id_list").value = deger_ship_id;
							}
							else
							{
								if(deger_ship_id != '')
									document.getElementById("ship_id_list").value += ','+deger_ship_id;
							}	
						}
					}
					<!---windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + upd_packet_ship.ship_id_list.value + '&ship_id=upd_packet_ship.ship_id'+no+'&ship_number=upd_packet_ship.ship_number'+no+'&ship_date=upd_packet_ship.ship_date'+no+'&ship_deliver=upd_packet_ship.ship_deliver'+no+'&ship_type=upd_packet_ship.ship_type'+no+'&ship_adress=upd_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id,'project');--->
					windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id,'project');
				}
				else if(deger_consumer_id != "")
				{
					for(r=1;r<=upd_packet_ship.record_num.value;r++)
					{	
						deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
						deger_ship_id = document.getElementById("ship_id"+r).value;
						deger_consumer_id2 = document.getElementById("consumer_id"+r).value;
						if(deger_row_kontrol == 1 && (deger_consumer_id2 == deger_consumer_id))
						{
							if(document.getElementById("ship_id_list").value == '')
							{
								if(deger_ship_id != '')
									document.getElementById("ship_id_list").value = deger_ship_id;
							}
							else
							{
								if(deger_ship_id != '')
									document.getElementById("ship_id_list").value += ','+deger_ship_id;
							}	
						}
					}
			
		<!---			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + upd_packet_ship.ship_id_list.value + '&ship_id=upd_packet_ship.ship_id'+no+'&ship_number=upd_packet_ship.ship_number'+no+'&ship_date=upd_packet_ship.ship_date'+no+'&ship_deliver=upd_packet_ship.ship_deliver'+no+'&ship_type=upd_packet_ship.ship_type'+no+'&ship_adress=upd_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_consumer_id,'list');--->
					windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + ship_id_list.value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_consumer_id,'list');//&deliver_company_id='+add_packet_ship.service_company_id.value	
				}
				else
				{
					alert(no + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no='131.Cari Hesap Seçiniz'>");
					return false;
				}
			}
		
			function pencere_ac2(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id'+ no +'&field_name=upd_packet_ship.pack_emp_name'+ no+'&select_list=1','list','popup_list_positions');
			}
			
			function pencere_ac_cari(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_packet_ship.company_id'+ no +'&field_partner=upd_packet_ship.partner_id'+ no +'&field_consumer=upd_packet_ship.consumer_id'+ no +'&field_comp_name=upd_packet_ship.member_name'+ no +'&field_name=upd_packet_ship.member_name'+ no +'&call_function=cari_kontrol('+no+')&select_list=7,8','list','popup_list_all_pars');
			}
			
			function cari_kontrol(no)
			{
				deger_company_id = document.getElementById("company_id"+no).value;
				deger_consumer_id = document.getElementById("consumer_id"+no).value;
				if(deger_company_id !='')
					deger_cari = deger_company_id;
				else
					deger_cari = deger_consumer_id;
				for(ck=1;ck<=upd_packet_ship.record_num.value;ck++)
				{
					deger_row_kontrol = document.getElementById("row_kontrol"+ck).value;
					if (deger_company_id != '')
		
						deger_cari_row = document.getElementById("company_id"+ck).value;
					else
						deger_cari_row = document.getElementById("consumer_id"+ck).value;
					//Satir silinmemis,ilgili satırla dongudeki satir farkli mi ve deger aynimi
					if(deger_row_kontrol == 1 && (ck != no) && (deger_cari == deger_cari_row)) 
						document.getElementById("cari_kontrol"+no).value = ck;
				}
			}
		</cfif>
		
		<cfif x_equipment_planning_info eq 0>
			function sil(sy)
			{
				for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
				{
					deger_row_kontrol_other = document.getElementById("row_kontrol_other"+r).value;
					deger_row_count_other = document.getElementById("row_count_other"+r).value;
					if(deger_row_kontrol_other == 1 && (deger_row_count_other == sy))//satir silinmemis ve irsaliye ile iliskili ise
					{
						alert("<cf_get_lang no ='481.İlgili İrsaliye ile İlişkili Paketler Mevcut Kontrol Ediniz'>!");
						return false;
					}
				}
			
				kontrol_row_count--;
				var my_element=document.getElementById("row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
			
				for(rr=1;rr<=upd_packet_ship.record_num.value;rr++)
				{
					deger_row_kontrol = document.getElementById("row_kontrol"+rr).value;
					deger_related_row_kontrol = document.getElementById("related_row_kontrol"+rr).value;
					if(deger_row_kontrol == 1 && (deger_related_row_kontrol == sy))
					{
						kontrol_row_count--;
						var my_element=document.getElementById("row_kontrol"+rr);
						my_element.value=0;
						var my_element=eval("frm_row"+rr);
						my_element.style.display="none";
					}
				}
			}	
		<cfelse>//siparislerin silinmesi
			function sil(sy)
			{
				kontrol_row_count--;
				var my_element=document.getElementById("row_kontrol"+sy);
				
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				return row_all_control(4,sy);
			}
		</cfif>
		
		<cfif x_equipment_planning_info eq 0>
			function sil_other(sy)
			{
				//irsaliye ve paket satir iliskisi icin silinen satırda 
				temp_row_count_other = document.getElementById("row_count_other"+sy).value;
				temp_cari_ship_id_list = document.getElementById("cari_" +temp_row_count_other+ "_ship_id_list").value;
				
				var temp_ship_id_list = '';
				for(r=1;r<=list_len(temp_cari_ship_id_list);r++)
				{
					if(list_getat(temp_cari_ship_id_list,r) != sy)
					{
						if(temp_ship_id_list == '')
							temp_ship_id_list = list_getat(temp_cari_ship_id_list,r);
						else
							temp_ship_id_list += ','+list_getat(temp_cari_ship_id_list,r);
					}
				}
				
				var my_element=document.getElementById("row_kontrol_other"+sy);
				my_element.value=0;
				var my_element=eval("frm_row_other"+sy);
				my_element.style.display="none";
				degistir(sy);
			}
		
			function degistir(id)
			{
				//Coklu satir mantigi icin eklendi ship_id_list degerine ulasmak icin
				temp_row_count_other = document.getElementById("row_count_other"+id).value;
				var ship_id_list = document.getElementById("cari_"+temp_row_count_other+"_ship_id_list").value;
			
				price_sum = 0;
				if(document.upd_packet_ship.calculate_type[1].checked)
				{
					
					for(ii=1;ii<=list_len(ship_id_list);ii++)
					{
						//hangi satırdaki paketler hesaplamaya dahil edilecek
						var ii_ = list_getat(ship_id_list,ii);
						if(document.getElementById("row_kontrol_other"+ii_).value == 1)
						{
							var temp_package_type = document.getElementById("package_type"+ii_);
							var temp_ship_ebat = document.getElementById("ship_ebat"+ii_);
							var temp_total_price = document.getElementById("total_price"+ii_);
							var temp_quantity = document.getElementById("quantity"+ii_);
							var temp_other_money = document.getElementById("other_money"+ii_);
							var temp_ship_agirlik = document.getElementById("ship_agirlik"+ii_);
							
							if(trim(document.getElementById("quantity"+ii_).value).length == 0)
								document.getElementById("quantity"+ii_).value = 1;
							
							temp_desi = list_getat(temp_package_type.value,2,',');
							temp_package_type_id = list_getat(temp_package_type.value,3,',');
							if(temp_package_type_id==1) //Desi
							{
								temp_ship_ebat.value = temp_desi;
								temp_ship_agirlik.value = '';
								desi_1 = list_getat(temp_desi,1,'*');
								desi_2 = list_getat(temp_desi,2,'*');
								desi_3 = list_getat(temp_desi,3,'*');
								desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
								if(desi_hesap < document.getElementById("max_limit").value)
								{
									var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_hesap;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
								else
								{
									var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("max_limit").value + "*" + document.getElementById("max_limit").value;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
							}
							else if(temp_package_type_id==2) 
							{	
								temp_ship_ebat.value = '';
								if(trim(temp_ship_agirlik.value).length == 0)
									temp_ship_agirlik.value = 1;
								temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
								if(temp_ship_agirlik_>document.getElementById("max_limit").value)
									temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
								if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
								{
									if(temp_ship_agirlik_<document.getElementById("max_limit").value)
									{
										var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + temp_ship_agirlik_;
										var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
									}
									else
									{
										var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
										var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
									}
								}	
							}	
							else if(temp_package_type_id==3)  //Zarf ise
							{
								var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
							}
							
							if(GET_PRICE != undefined)
							{
								if(GET_PRICE.recordcount==0)
								{
									alert("<cf_get_lang no ='471.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
									temp_ship_ebat.value = "";
									temp_total_price.value = "";
									temp_other_money.value = "";
								}
								else
								{
									if(temp_package_type_id==1)//Desi ise
									{
										temp_ship_agirlik.value = "";
										if(desi_hesap<document.getElementById("max_limit").value)
										{
											temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
											price_sum += parseFloat((GET_PRICE.PRICE*temp_quantity.value));
										}
										else
										{
											var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
											desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.getElementById("max_limit").value</cfoutput>);
											temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
											price_sum += parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value);
											
										}
									}
									if(temp_package_type_id==2)//Kg ise
									{
										temp_ship_ebat.value = "";
										if(trim(temp_ship_agirlik.value).length == 0)
											temp_ship_agirlik.value = 1;							
										if(temp_ship_agirlik_<document.getElementById("max_limit").value)
										{
											price_sum += parseFloat(GET_PRICE.PRICE);
										}
										else
										{
											var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
											kg_remain = parseFloat(temp_ship_agirlik_-document.getElementById("max_limit").value);
											temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
											price_sum += parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain);
										}
									}				
									
									else if(temp_package_type_id==3)//Zarf ise
									{
										temp_ship_agirlik = '';
										temp_ship_ebat.value = '';
										temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
										price_sum += parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value);
									}
									temp_other_money.value = GET_PRICE.OTHER_MONEY;
								}
							}
							else
							{
								temp_total_price.value = "";
								temp_other_money.value = "";	
							}
						}
					}
					document.getElementById("total_cost_value"+temp_row_count_other).value = commaSplit(price_sum);
					var temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
					var temp2_rate1 = list_getat(rate1_list,temp2_sira);
					var temp2_rate2 = list_getat(rate2_list,temp2_sira);
					var total_cost2_value = price_sum * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
					document.getElementById("total_cost2_value"+temp_row_count_other).value = commaSplit(total_cost2_value);
				}
				else
				{
					count_desi = 0;
					count_kg = 0;
					count_envelope = 0;
					desi_sum = 0;
					kg_sum = 0;
					desi_price_sum = 0;
					kg_price_sum = 0;
					envelope_price_sum = 0;
					
					for(ii=1;ii<=list_len(ship_id_list);ii++)
					{
						//hangi satırdaki paketler hesaplamaya dahil edilecek
						var ii_ = list_getat(ship_id_list,ii);
						if(document.getElementById("row_kontrol_other"+ii_).value == 1)
						{
							var temp_quantity = document.getElementById('quantity'+ii_);
							var temp_package_type = document.getElementById('package_type'+ii_);
							var temp_ship_ebat = document.getElementById('ship_ebat'+ii_);
							var temp_ship_agirlik = document.getElementById('ship_agirlik'+ii_);
							
							if(trim(document.getElementById("quantity"+ii_).value).length == 0)
								document.getElementById("quantity"+ii_).value = 1;
			
							var temp_desi = list_getat(temp_package_type.value,2,',');
							var temp_package_type_id = list_getat(temp_package_type.value,3,',');
			
							if(temp_package_type_id==1) //Desi
							{
								count_desi += 1;
								temp_ship_ebat.value = temp_desi;
								temp_ship_agirlik.value = '';
								desi_1 = list_getat(temp_desi,1,'*');
								desi_2 = list_getat(temp_desi,2,'*');
								desi_3 = list_getat(temp_desi,3,'*');
								desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
								desi_sum +=desi_hesap;
							}
							else if(temp_package_type_id==2)//Kg
							{
								count_kg += 1;
								temp_ship_ebat.value = "";
								if(trim(document.getElementById("ship_agirlik"+ii_).value).length == 0)
									document.getElementById("ship_agirlik"+ii_).value = 1;
								temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
								if(temp_ship_agirlik.value != "" && temp_ship_agirlik.value !=0)
									kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
							}	
							else if(temp_package_type_id==3)//Zarf ise
							{
								count_envelope += 1;
								temp_ship_agirlik.value = '';
								temp_ship_ebat.value = '';
								var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
								var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
								if(GET_PRICE3 != undefined)
								{
									if(GET_PRICE3.recordcount==0)
										alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
									else
										envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
								}					
							}
						}
					}
					
					if(count_desi != 0)
					{
						
						if(desi_sum<document.getElementById("max_limit").value)
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_sum;				
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						
						if(GET_PRICE1 != undefined)
						{
							if(GET_PRICE1.recordcount==0)
								alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
							{
								if(desi_sum<document.getElementById("max_limit").value)
								{
									desi_price_sum = GET_PRICE1.PRICE;
								}
								else
								{					
									var GET_PRICE_30 = wrk_safe_query("stk_GET_PRICE_3",'dsn',0,document.getElementById("transport_comp_id").value);
									desi_remain2 = parseFloat(desi_sum-document.getElementById("max_limit").value);
									desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
								}
							}
						}
					}
					
					if(count_kg != 0)
		
					{
			
						if(kg_sum<document.getElementById("max_limit").value)
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + kg_sum;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
							var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						
						if(GET_PRICE1 != undefined)
						{
							if(GET_PRICE1.recordcount==0)
								alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
							{
								if(kg_sum<document.getElementById("max_limit").value)
									kg_price_sum = GET_PRICE1.PRICE;
								else
								{	
									var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.getElementById("transport_comp_id").value);
									kg_remain2 = parseFloat(kg_sum-document.getElementById("max_limit").value);
									kg_remain2 = Math.ceil(kg_remain2);
									kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
								}
							}
						}
					}
			
					document.getElementById("total_cost_value"+temp_row_count_other).value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
				}
				return kur_hesapla();
			}
			function fiyat_hesapla(satir)
			{
				if(trim(document.getElementById("quantity"+satir).value).length == 0)
					document.getElementById("quantity"+satir).value = 1;
				
				if(document.getElementById("price"+satir).value.length != 0)
					document.getElementById("total_price"+satir).value = commaSplit(filterNum(document.getElementById("quantity"+satir).value) * filterNum(document.getElementById("price"+satir).value));
					
				return kur_hesapla();
			}
		</cfif>
		
		function control()
		{
			<cfif x_equipment_planning_info eq 1><!--- siparis bazli sevkiyat calisirsa --->
				if(document.getElementById("equipment_planning").value == '')
				{
					alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>: Ekip-Araç !");
					return false;
				}
				if(document.getElementById("department_name").value == '' || document.getElementById("department_id").value == '')
				{
					alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>: Depo!");
					return false;
				}
				//duzenlenecek sorun olabilir
				if(process_cat_control())
					return row_all_control(5);
				else
					return false;
			
			<cfelse>
				if(document.getElementById("options_kontrol").value==0 || document.getElementById("options_kontrol").value == "")
				{	
					alert("<cf_get_lang no ='482.Lütfen Tasıyıcı Firmayı Kontrol Ediniz Bu Cari İçin Fiyat Listesi Tanımlı Değil'>!");
					return false;
				}
				if(document.getElementById("ship_method_id").value == "")	
				{
					alert("<cf_get_lang no='305.Lütfen Sevk Yöntemi Seçiniz'> !");
					return false;
				}
				if(document.getElementById("transport_comp_id").value == "")	
				{
					alert("<cf_get_lang no='318.Taşıyıcı Seçiniz'>!");
					return false;
				}	
				if(kontrol_row_count == 0)
				{
					alert("<cf_get_lang no ='484.En Az Bir Satır İrsaliye Kaydı Giriniz'>!");
					return false;
				}	
			
				temp_satir=0;	
				for(cr=1;cr<=upd_packet_ship.record_num.value;cr++)
				{
					deger_row_kontrol = document.getElementById("row_kontrol"+cr).value;
					deger_company_id = document.getElementById("company_id"+cr).value;
					deger_consumer_id = document.getElementById("consumer_id"+cr).value;
					deger_ship_id = document.getElementById("ship_id"+cr).value;
					deger_cari_kontrol = document.getElementById("cari_kontrol"+cr).value;
					if(deger_row_kontrol == 1)
					{
						temp_satir++;
						if(deger_company_id=="" && deger_consumer_id=="")
						{
							alert(temp_satir + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no='131.Cari Hesap Seçiniz'>");
							return false;
						}
						if(deger_ship_id == "")
						{
							alert(temp_satir + ".<cf_get_lang no ='480.Satır İçin'> <cf_get_lang no ='306.İrsaliye Seçiniz'>!");
							return false;
						}
						if(deger_cari_kontrol != "")
						{
							alert(temp_satir + ".<cf_get_lang no ='485.Satır İçin Cari Değerini Kontrol Ediniz'>!");
							return false;
						}			
					}
				}
				
				// Paket kontrolleri
				for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
				{
					deger_row_kontrol_other = document.getElementById("row_kontrol_other"+r);
					deger_package_type = document.getElementById("package_type"+r);
					if(deger_row_kontrol_other.value == 1)
					{
						if(deger_package_type.value == "")
						{
							alert("<cf_get_lang no='307.Lütfen Paket Tipi Seçiniz'>!");
							return false;
						}
					}
				}
			</cfif>
			unformat_fields();
			return true;
		}
		
		<cfif x_equipment_planning_info eq 0>
			function kur_hesapla()
			{
				total_cost_value = 0;
				if(document.upd_packet_ship.calculate_type[1].checked)
				{		
					for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
					{				
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							var temp_other_money =document.getElementById("other_money"+r);
							var temp_total_price = document.getElementById("total_price"+r);
							
							if(temp_total_price.value != '')
							{
								temp_sira = list_find(money_list,temp_other_money.value);	
								temp_rate1 = list_getat(rate1_list,temp_sira);
								temp_rate2 = list_getat(rate2_list,temp_sira);
								temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / ((parseFloat(temp_rate1) / parseFloat(temp_rate2))));
								total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
							}
						}
					}
					temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
					temp2_rate1 = list_getat(rate1_list,temp2_sira);
					temp2_rate2 = list_getat(rate2_list,temp2_sira);
					total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
					document.getElementById("total_cost_value").value = commaSplit(total_cost_value);
					document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
				}
				else
				{
					for(rk=1;rk<=document.getElementById("record_num").value;rk++)
					{
						
						temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
						temp2_rate1 = list_getat(rate1_list,temp2_sira);
						temp2_rate2 = list_getat(rate2_list,temp2_sira);
						temp_total_cost_value = document.getElementById("total_cost_value"+rk).value;
						total_cost2_value = parseFloat(filterNum(temp_total_cost_value)) * ((parseFloat(temp2_rate1) / parseFloat(temp2_rate2)));
						document.getElementById("total_cost2_value"+rk).value = commaSplit(total_cost2_value);
					}
				}
				
				sum_total_cost_value = 0;
				sum_total_cost2_value = 0;
				
				for(r=1;r<=upd_packet_ship.record_num.value;r++)
				{
					if(document.getElementById("row_kontrol"+r).value == 1)
					{
						var temp =document.getElementById("total_cost_value"+r);
						var temp2 =document.getElementById("total_cost2_value"+r);
						temp_total_cost_value = filterNum(temp.value);
						temp_total_cost2_value = filterNum(temp2.value);
				
						sum_total_cost_value = sum_total_cost_value+temp_total_cost_value;
						sum_total_cost2_value = sum_total_cost2_value+temp_total_cost2_value;
					}		
				}
				
				upd_packet_ship.total_cost_value.value = commaSplit(sum_total_cost_value);
				upd_packet_ship.total_cost2_value.value = commaSplit(sum_total_cost2_value);
			
				return true;
			}
			
			function change_packet(calculate_type_value)
			{
				if(row_count2!=0)
				{
					if(calculate_type_deger!=calculate_type_value)
					{
						if(calculate_type_value == 2)/*Satır ise*/
						{
							for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
							{
								if(document.getElementById("row_kontrol_other"+r).value == 1)
								{
									document.getElementById("package_type"+r).value = '';
									document.getElementById("ship_ebat"+r).value = '';
									document.getElementById("ship_agirlik"+r).value = '';
									document.getElementById("total_price"+r).value = '';
									document.getElementById("other_money"+r).value = '';
								}
							}
							document.getElementById("total_cost_value").value = commaSplit(0);
							document.getElementById("total_cost2_value").value = commaSplit(0);				
						}
						else
						{
							degistir(1);
						}
					}
				}
				calculate_type_deger = calculate_type_value;
				return true;
			}
		</cfif>
		
		function unformat_fields()
		{
			<cfif x_equipment_planning_info eq 0>
				for(r=1;r<=document.getElementById("record_num_other").value;r++)
				{
					if(document.getElementById("row_kontrol_other"+r).value == 1)
					{
						document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
						document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
						document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
					}
				}
				for(kr=1;kr<=document.getElementById("record_num").value;kr++)
				{
					if(document.getElementById("row_kontrol"+kr).value == 1)
					{
						document.getElementById("total_cost_value"+kr).value = filterNum(document.getElementById("total_cost_value"+kr).value);
						document.getElementById("total_cost2_value"+kr).value = filterNum(document.getElementById("total_cost2_value"+kr).value);
					}
				}
			<cfelse>
				for(ow=1;ow<=document.getElementById("record_num").value;ow++)
				{
					if(document.getElementById("row_kontrol"+ow).value == 1)
						document.getElementById("order_row_amount_"+ow).value = filterNum(document.getElementById("order_row_amount_"+ow).value);
				}
			</cfif>	
		}
		function kontrol_prerecord()
		{
			<cfif x_equipment_planning_info eq 0>
			if(document.getElementById("transport_comp_id").value != "")
			{
				var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.getElementById("transport_comp_id").value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
				if(GET_MAX_LIMIT.recordcount > 0)
				{
					document.getElementById("max_limit").value=GET_MAX_LIMIT.MAX_LIMIT;
					if(GET_MAX_LIMIT.CALCULATE_TYPE==1)
					{
						document.upd_packet_ship.calculate_type[0].checked = true;
						document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
					}
					else if	(GET_MAX_LIMIT.CALCULATE_TYPE==2)
					{
						document.upd_packet_ship.calculate_type[1].checked=true;
						document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
					}
		
					for(xx=1;xx<=document.getElementById("record_num_other").value;xx++)
					{
						deger_row_kontrol_other = document.getElementById("row_kontrol_other"+xx);
						if(deger_row_kontrol_other.value == 1)
							degistir(xx);
					}
				}
				else		
				{
					alert("<cf_get_lang no ='486.Lütfen Hesaplama için Tasıyıcı Firmayı Kontrol Ediniz (Fiyat Listesi)'>!");
					document.upd_packet_ship.calculate_type[0].checked=false;
					document.upd_packet_ship.calculate_type[1].checked=false;
					document.getElementById("options_kontrol").value=0;
					document.getElementById("max_limit").value=0;
					return false;	
				}
			}
			</cfif>
		}
		<cfif x_equipment_planning_info eq 1>

			function depot_date_change()
			{
				var get_planning_info_js =  wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.getElementById("action_date").value));
				for(j=get_planning_info.recordcount;j>=0;j--)
					document.upd_packet_ship.equipment_planning.options[j] = null;
				
				document.upd_packet_ship.equipment_planning.options[0]= new Option('Ekip-Araç','');
				if(get_planning_info_js.recordcount)
					for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
						document.upd_packet_ship.equipment_planning.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
			}

		</cfif>
	</cfif>
	
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	function add_row()
		{
			if(document.getElementById('ship_method_id').value != "" && document.getElementById('transport_comp_id').value != "")
			{
				if(document.getElementById('options_kontrol').value == 0 || document.getElementById('options_kontrol').value == "")
				{	
					alert("<cf_get_lang no ='482.Lütfen Tasıyıcı Firmayı Kontrol Ediniz Bu Cari İçin Fiyat Listesi Tanımlı Değil'>!");
					return false;
				}
				
				row_count++;
				kontrol_row_count++;
					
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				document.getElementById('record_num').value=row_count;
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="">&nbsp;<a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="icon-plus-square" title="<cf_get_lang no="146.İlişkili İrsaliye Ekle">"> </i></a>&nbsp;<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');"><i class="icon-pluss" title="Paket Ekle"></i></a>&nbsp;<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"></i></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="" readonly style="width:150px;"><a href="javascript://" onClick="pencere_ac_cari('+ row_count +');"> <i class="icon-ellipsis"></i></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"> <a href="javascript://" onClick="pencere_ac('+ row_count +');"><i class="icon-ellipsis"></i></a>';
				
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value=""><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:200px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:74px;">&nbsp;<cfoutput>#session.ep.money#</cfoutput><input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:74px;">&nbsp;<cfoutput>#session.ep.money2#</cfoutput>';
			}
			else
			{
				alert("<cf_get_lang no ='483.Lütfen Tasıyıcı veya Sevk Yöntemi Seçiniz'> !");
				return false;	
			}
		}
		
		function add_row2(no)
		{
			deger_company_id = document.getElementById('company_id'+no).value;
			deger_partner_id = document.getElementById('partner_id'+no).value;
			deger_consumer_id = document.getElementById('consumer_id'+no).value;
			deger_member_name = document.getElementById('member_name'+no).value;
			deger_ship_id = document.getElementById('ship_id'+no).value;
			
			deger_cari_ship_id_list = document.getElementById('cari_' +no+ '_ship_id_list');
			
			deger_row_count_list = document.getElementById('row_count_' +no+ '_list');
			
			if(deger_company_id == "" && deger_consumer_id == "")
			{
				alert(no + ".<cf_get_lang no ='480.Satır İçin'> <cf_get_lang no='131.Cari Hesap Seçiniz'>");
				return false;
			}
			
			if(deger_ship_id == "")
			{
				alert(no + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no ='306.İrsaliye Seçiniz'>!");
				return false;
			}
			
			row_count++;
			kontrol_row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="'+no+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="'+deger_partner_id+'"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+deger_member_name+'" readonly style="width:150px;"> <a href="javascript://"><i class="icon-ellipsis"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"> <a href="javascript://" onClick="pencere_ac('+ row_count +');"><i class="icon-ellipsis"></i></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value=""><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" value="" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:200px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:74px;"><input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:74px;">';
			
			if(deger_row_count_list.value == '')
				deger_row_count_list.value = row_count;
			else
				deger_row_count_list.value += ','+row_count;
		}
		
		function add_row_other(no)
		{	
			deger_company_id = document.getElementById('company_id'+no).value;
			deger_partner_id = document.getElementById('partner_id'+no).value;
			deger_consumer_id = document.getElementById('consumer_id'+no).value;
			deger_member_name = document.getElementById('member_name'+no).value;
			deger_ship_id = document.getElementById('ship_id'+no).value;
			
			deger_cari_ship_id_list = document.getElementById('cari_' +no+ '_ship_id_list');
			
			if(deger_company_id == "" && deger_consumer_id == "")
			{
				alert(no + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no='131.Cari Hesap Seçiniz'>");
				return false;
			}
			
			if(deger_ship_id == "")
			{
				alert(no + ".<cf_get_lang no ='480.Satır İçin'><cf_get_lang no ='306.İrsaliye Seçiniz'>!");
				return false;
			}
		
			//transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
			row_count2++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
			newRow.setAttribute("name","frm_row_other" + row_count2);
			newRow.setAttribute("id","frm_row_other" + row_count2);		
			newRow.setAttribute("NAME","frm_row_other" + row_count2);
			newRow.setAttribute("ID","frm_row_other" + row_count2);		
			document.getElementById('record_num_other').value=row_count2;
		
			newCell = newRow.insertCell(newRow.cells.length)
			newCell.innerHTML = '<input type="hidden" name="row_count_other' + row_count2 +'" id="row_count_other' + row_count2 +'" value="'+no+'"><input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><i class="icon-trash-o"></i></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="consumer_id_other' + row_count2 +'" id="consumer_id_other' + row_count2 +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id_other' + row_count2 +'" id="company_id_other' + row_count2 +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id_other' + row_count2 +'" id="partner_id_other' + row_count2 +'" value="'+deger_partner_id+'"><input type="text" name="member_name_other' + row_count2 +'" id="member_name_other' + row_count2 +'" value="'+deger_member_name+'" readonly style="width:170px;">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:40px;">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');" style="width:130px;"><option value="">Seçiniz</option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select>'; //add_general_prom();
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat" value="" readonly style="width:90px;">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:75px;">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;"><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly style="width:50px;"><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" style="width:120px;">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" style="width:150px;"><a href="javascript://" onClick="pencere_ac2('+ row_count2 +');"> <i class="icon-ellipsis"></i></a>';
		
			if(deger_cari_ship_id_list.value == '')
				deger_cari_ship_id_list.value = row_count2;
			else
				deger_cari_ship_id_list.value += ','+row_count2;
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
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_multi_packetship';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'stock/display/list_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'stock.list_multi_packetship';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_multi_packetship';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] =  'stock/query/add_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_multi_packetship&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_multi_packetship';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] =  'stock/query/upd_multi_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_multi_packetship&event=upd';	
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'main_ship_fis_no=##main_ship_fis_no##';
	WOStruct['#attributes.fuseaction#']['upd']['identity'] = '##main_ship_fis_no##';	
	
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del') )      
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.list_multi_packetship';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_multi_packetship';

	}
	if(isdefined("attributes.event") and attributes.event is 'upd')      
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-24" module_id="13" action_section="SHIP_RESULT_ID" action_id="#get_ship_results_all.ship_result_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_multi_packetship&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&keyword=#attributes.main_ship_fis_no#&print_type=32','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockMultiPacketship';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP_RESULT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-ship_method_name','item-transport_comp_name','item-transport_no1','item-action_date']";
</cfscript>
