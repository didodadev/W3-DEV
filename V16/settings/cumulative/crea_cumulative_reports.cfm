<cfsetting showdebugoutput="no">
<cfset new_donem_data_source = "#dsn#_#attributes.period_year#_#attributes.period_our_company_id#">
<cfset new_sirket_data_source = "#dsn#_#attributes.period_our_company_id#">
<cfset aydaki_gun_sayisi = DaysInMonth(CreateDate(attributes.period_year,attributes.period_month,1))>
<cfset _report_start_date_ = '01/#attributes.period_month#/#attributes.period_year#'>
<cfset _report_finish_date_ = '#aydaki_gun_sayisi#/#attributes.period_month#/#attributes.period_year#'>
<cfset report_url_string = '&new_sirket_data_source=#new_sirket_data_source#&new_donem_data_source=#new_donem_data_source#&period_month=#attributes.period_month#&table_name=#attributes.table_name#&DATE=#_report_start_date_#&DATE2=#_report_finish_date_#&PERIOD_OUR_COMPANY_ID=#attributes.period_our_company_id#&period_year=#attributes.period_year#'>
<cfswitch expression = "#attributes.table_name#">
	<cfcase value="STOCK_MONTH,STOCK_LOCATION_MONTH"><!--- stok analizi ajax ile çağırıldığı için default olarak url stringlerini gönderiyoruz... --->
		<cfset report_adress = '#request.self#?fuseaction=report.emptypopup_ajax_stock_analyse'>
			<cfif attributes.table_name is 'STOCK_LOCATION_MONTH'>
				<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
					SELECT
						D.DEPARTMENT_HEAD,
						D.DEPARTMENT_ID,
						SL.LOCATION_ID,
						SL.COMMENT
					FROM
						BRANCH B,
						DEPARTMENT D,
						STOCKS_LOCATION SL
					WHERE
						SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
						B.COMPANY_ID = #attributes.period_our_company_id# AND
						B.BRANCH_ID = D.BRANCH_ID AND
						D.IS_STORE <> 2 AND
						D.DEPARTMENT_STATUS = 1
				</cfquery>
			</cfif>		
		<cfset report_url_string ='#report_url_string#&cost_money=#session.ep.money#&display_cost=1&PROCESS_TYPE_DETAIL=2,3,4,4-110-176,4-110-22,5,5-111-175,5-111-23,5-112-174,5-112-24,6,7,19,20,8,9,10,11,12,13,14,14-119-31,15,16,17,18&IS_FORM_SUBMITTED=1&REPORT_TYPE=1'>
    </cfcase>
    <cfcase value="SALES_PRODUCT_MONTH,SALES_CUSTOMER_MONTH"><!--- Stok Bazında Satışlar ise Satış Analiz Faturadaki İşlem Tiplerini Stok bazında çalıştırırmış gibi burda tanımlıycaz... --->
	   <cfset report_adress = '#request.self#?fuseaction=report.emptypopup_sale_analyse_report'>
       <cfif attributes.table_name is 'SALES_CUSTOMER_MONTH'>
			<cfset report_type=4>   <!--- Müşteri Bazında --->    	
	   <cfelse>
			<cfset report_type=3><!--- Stok Bazında --->
	   </cfif>
	   <cfset report_url_string ='#report_url_string#&report_type=#report_type#&form_submitted=1&process_type=157,115,70,59,62,203,60,64,191,185,205,153,61,65,122,67,204,66,114,57&report_sort=1&date1=#_report_start_date_#&is_kdv=0&is_prom=0&is_other_money=0&is_money2=1&is_discount=0&is_profit=1'>
    </cfcase>
    <cfcase value="EXPENSE_MONTH"><!--- HARCAMALAR --->
		<cfset report_adress = '#request.self#?fuseaction=report.emptypopup_cost_analyse_report'>
    	<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#"><!--- aktivite tipleri --->
            SELECT ACTIVITY_ID FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
        </cfquery>
        <cfquery name="GET_EXPENSE_CAT" datasource="#new_donem_data_source#">
            SELECT EXPENSE_CAT_ID FROM EXPENSE_CATEGORY ORDER BY EXPENSE_CAT_NAME
        </cfquery>
        <cfquery name="GET_EXPENSE_CENTER" datasource="#new_donem_data_source#">
            SELECT EXPENSE_ID FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE
        </cfquery>
        <cfquery name="GET_EXPENSE_ITEM" datasource="#new_donem_data_source#">
            SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
        </cfquery>
        <cfquery name="GET_PROCESS_CAT" datasource="#new_sirket_data_source#">
            SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (120,122) ORDER BY PROCESS_CAT
        </cfquery>
		<cfset activity_type_list = ''>
        <cfset expense_cat_id_list = ''>
		<cfset expense_center_id_list = ''>
		<cfset expense_item_id_list = ''>
		<cfset process_type_id_list = ''>
        <cfif GET_ACTIVITY_TYPES.recordcount><cfset activity_type_list = ValueList(GET_ACTIVITY_TYPES.ACTIVITY_ID,',')></cfif>
        <cfif GET_EXPENSE_CAT.recordcount><cfset expense_cat_id_list = ValueList(GET_EXPENSE_CAT.EXPENSE_CAT_ID,',')></cfif>
        <cfif GET_EXPENSE_CENTER.recordcount><cfset expense_center_id_list = ValueList(GET_EXPENSE_CENTER.EXPENSE_ID,',')></cfif>
        <cfif GET_EXPENSE_ITEM.recordcount><cfset expense_item_id_list = ValueList(GET_EXPENSE_ITEM.EXPENSE_ITEM_ID,',')></cfif>
        <cfif GET_PROCESS_CAT.recordcount><cfset process_type_id_list = ValueList(GET_PROCESS_CAT.PROCESS_CAT_ID,',')></cfif>
    	<cfset report_adress = '#request.self#?fuseaction=report.emptypopup_cost_analyse_report'>
        <cfset report_url_string ='#report_url_string#&ACTIVITY_TYPE=#activity_type_list#&EXPENSE_CAT=#expense_cat_id_list#&EXPENSE_CENTER_ID=#expense_center_id_list#&EXPENSE_ITEM_ID=#expense_item_id_list#&PROCESS_TYPE=#process_type_id_list#&FORM_EXIST=1&IS_ACTIVITY=1&IS_ASSET=1&IS_DATE=1&IS_EXPENCE=1&IS_EXPENCE_CAT=1&IS_EXPENCE_ITEM=1&IS_EXPENCE_MEMBER=1&IS_OTHER_MONEY=1&IS_STOCK=1&REPORT_SORT=0&SEARCH_DATE1=#_report_start_date_#&SEARCH_DATE2=#_report_finish_date_#'>
    </cfcase>
    <cfcase value="CARI_MONTH">
    	<cfset report_adress = '#request.self#?fuseaction=settings.emptypopup_ajax_cumulative_cre_cari_rows'>
    </cfcase>
	<cfcase value="SALES_PURCHASE_PRODUCT_MONTH,SALES_PURCHASE_CUSTOMER_MONTH">
		<cfset report_adress = '#request.self#?fuseaction=settings.emptypopup_ajax_crea_all_sales_purchase_rows'>
    </cfcase>
    <cfcase value="PRODUCTION_MONTH">
		<cfset report_adress = '#request.self#?fuseaction=report.emptypopup_production_analyse'>
        <cfset report_url_string ='#report_url_string#&START_DATE=#_report_start_date_#&REPORT_TYPE=6&ORDER_TYPE=1&IS_VIEW=0,1&FINISH_DATE=#_report_finish_date_#'>
    </cfcase>
</cfswitch>
<cfif attributes.table_status is 'Var'><!---  and attributes.table_name neq 'SALES_INVOICE_TO_RATE_COST' --->
	<cfquery name="DELETED_TABLE_VALUE" datasource="#DSN_REPORT#"><!--- Tablo Oluşturulmuş ise yeniden oluşturulacağı için öncelikle belirtilen aydaki kayıtları siliyoruz! --->
	   DELETE FROM #attributes.table_name# WHERE PERIOD_YEAR = #attributes.period_year# AND OUR_COMPANY_ID = #attributes.period_our_company_id# AND PERIOD_MONTH = #attributes.period_month#
    </cfquery>
    <cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
        UPDATE 
            REPORT_SYSTEM 
        SET 
        	PROCESS_START_DATE = #now()#,
            PROCESS_FINISH_DATE = NULL,
        	RECORD_IP = '#CGI.REMOTE_ADDR#',
            RECORD_EMP_ID = #SESSION.EP.USERID#
        WHERE 
            REPORT_TABLE = '#attributes.table_name#' AND 
            PERIOD_YEAR = #attributes.period_year# AND 
            PERIOD_MONTH = #attributes.period_month# AND 
            OUR_COMPANY_ID = #attributes.period_our_company_id#
    </cfquery>
<cfelse>
    <cfquery name="ADD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- Belirtilen ay için kayıdın oluşturulduğunu REPORT_SYSTEM tablosuna kayıt atarak tutuyoruz.. --->
        INSERT INTO 
            REPORT_SYSTEM
            (
                REPORT_TABLE,
                OUR_COMPANY_ID,
                PERIOD_YEAR,
                PERIOD_MONTH,
                PROCESS_START_DATE,
                PROCESS_FINISH_DATE,
                PROCESS_ROW_COUNT,
                RECORD_IP,
                RECORD_EMP_ID
            )
        VALUES
            (
                '#attributes.table_name#',
                #attributes.period_our_company_id#,
                #attributes.period_year#,
                #attributes.period_month#,
                #now()#,
                NULL,
                0,
               '#CGI.REMOTE_ADDR#',
                #SESSION.EP.USERID#
            )    
    </cfquery>
</cfif>
<table cellpadding="2" cellspacing="1" align="center" width="100%"> 
<tr class="color-header">
	<td width="30%" class="form-title"><cf_get_lang_main no='1278.Tarih Aralığı'></td>
    <td width="69%" class="form-title"> Tamamlanma %</td>
    <td width="1%"><input type="button" value="Raporu Oluştur" onClick="getAjaxReport()"></td>
</tr>
<cfif attributes.table_name is 'STOCK_LOCATION_MONTH'>
	<cfoutput query="GET_DEPARTMENT">
        <tr>
            <td nowrap>
                <B>#currentrow#[#COMMENT#]-#_report_start_date_#-#_report_finish_date_#</B>
            </td>
            <td colspan="2" id="report_complete_rate" nowrap><div id="report_progres_bar_#DEPARTMENT_ID#_#LOCATION_ID#">% 0</div></td>
        </tr>
        <tr>
            <td colspan="3">
            <div id="show_report_stock_analy_incl_#DEPARTMENT_ID#_#LOCATION_ID#"></div>
            <div id="show_report_stock_analy_incl_2_info_#DEPARTMENT_ID#_#LOCATION_ID#"></div>
            </td>
        </tr>
    </cfoutput>
<cfelse>
	<tr>
        <td nowrap>
            <cfoutput><B>#_report_start_date_#-#_report_finish_date_#</B><!--- #message# ---></cfoutput>
        </td>
        <td colspan="2" id="report_complete_rate" nowrap><div id="report_progres_bar">% 0</div></td>
    </tr>
    <tr>
        <td colspan="3">
        <div id="show_report_stock_analy_incl"></div>
        <div id="show_report_stock_analy_incl_2_info"></div>
        </td>
    </tr>
</cfif>
</table> 
<input type="hidden" name="report_url_string" id="report_url_string" value="<cfoutput>#report_url_string#</cfoutput>">
<script type="text/javascript">
	var is_pos_process_flas = 0;//Stok Bazında Satışlar Çalışırken önce normal satış tipleri daha sonrada yazar kasa ve z raporu için rapor çalıştırılıcak,ilk işlemleri bittikten sonra process type'in değiştirilerek yeniden başlaması lazım bu değişken pos işlemlerine başlayıp başlamadığının kontrol etmek amacı ile kullanılır.
	var dep_and_loc_id = ''; //genel değişken olarak boş atıyoruz önce!
	<cfif attributes.table_name is 'STOCK_LOCATION_MONTH'>
		<cfoutput query="GET_DEPARTMENT">
		function user_info_show_div_#DEPARTMENT_ID#_#LOCATION_ID#(page_,comp_rate,is_complete){
			document.getElementById("show_report_stock_analy_incl_2_info_#DEPARTMENT_ID#_#LOCATION_ID#").innerHTML = (is_complete)?'<font color="F66633"><b> <cf_get_lang_main no="1374.Tamamlandı">!</b></font>':'<b><font color="F66633"> Devam Ediliyor.Bekleyiniz!</font></b>'; 
			document.getElementById("show_report_stock_analy_incl_2_info_#DEPARTMENT_ID#_#LOCATION_ID#").style.padding ='3px';
			document.getElementById("show_report_stock_analy_incl_2_info_#DEPARTMENT_ID#_#LOCATION_ID#").style.backgroundRepeat ='no-repeat';
			document.getElementById("show_report_stock_analy_incl_2_info_#DEPARTMENT_ID#_#LOCATION_ID#").style.backgroundImage = (is_complete)?"":"url(/images/loading.gif)";
			document.getElementById('report_progres_bar_#DEPARTMENT_ID#_#LOCATION_ID#').style.background='F66633';
			document.getElementById('report_progres_bar_#DEPARTMENT_ID#_#LOCATION_ID#').style.width=(is_complete)?'100%':comp_rate+'%';
			document.getElementById('report_progres_bar_#DEPARTMENT_ID#_#LOCATION_ID#').innerHTML = (is_complete)?'<font color="white"><b>%100</b></font>':'<font color="white">%'+commaSplit(comp_rate)+'</font>';
			if(is_complete == undefined)
				AjaxPageLoad('<cfoutput>#report_adress#&department_id=#DEPARTMENT_ID#-#LOCATION_ID#&page='+page_+'&maxrows=250'+document.getElementById('report_url_string').value+'</cfoutput>','show_report_stock_analy_incl_#DEPARTMENT_ID#_#LOCATION_ID#',1,'RAPOR OLUŞTURULUYOR');
		}
		</cfoutput>
	<cfelse>
		function user_info_show_div(page_,comp_rate,is_complete){
			document.getElementById("show_report_stock_analy_incl_2_info").innerHTML = (is_complete)?'<font color="F66633"><b><cf_get_lang_main no="1374.Tamamlandı">!</b></font>':'<b><font color="F66633"> Devam Ediliyor.Bekleyiniz!</font></b>'; 
			document.getElementById("show_report_stock_analy_incl_2_info").style.padding ='3px';
			document.getElementById("show_report_stock_analy_incl_2_info").style.backgroundRepeat ='no-repeat';
			document.getElementById("show_report_stock_analy_incl_2_info").style.backgroundImage = (is_complete)?"":"url(/images/loading.gif)";
			document.getElementById('report_progres_bar').style.background='F66633';
			document.getElementById('report_progres_bar').style.width=(is_complete)?'100%':comp_rate+'%';
			document.getElementById('report_progres_bar').innerHTML = (is_complete)?'<font color="white"><b>%100</b></font>':'<font color="white">%'+commaSplit(comp_rate)+'</font>';
			if(is_complete == undefined)
				AjaxPageLoad('<cfoutput>#report_adress#&page='+page_+'&maxrows=250'+document.getElementById('report_url_string').value+'</cfoutput>','show_report_stock_analy_incl',1,'RAPOR OLUŞTURULUYOR');
			<cfif attributes.table_name is 'SALES_PRODUCT_MONTH' or attributes.table_name is 'SALES_CUSTOMER_MONTH'><!--- Stok Bazında Satışlar ise pos ve işlemleri yani Z Raporu ve Yazar Kasa İşlemleride Ayrıca Yapılabilir! --->
				if(is_pos_process_flas != 1){//pos işlemleri başlamadıysa!
					<cfoutput>
					document.getElementById('report_url_string').value = '&new_sirket_data_source=#new_sirket_data_source#&new_donem_data_source=#new_donem_data_source#&period_month=#attributes.period_month#&table_name=#attributes.table_name#&DATE1=#_report_start_date_#&DATE2=#_report_finish_date_#&PERIOD_OUR_COMPANY_ID=#attributes.period_our_company_id#&period_year=#attributes.period_year#&form_submitted=1&process_type=670,690&report_sort=1&report_type=#report_type#&is_kdv=0&is_prom=0&is_other_money=0&is_discount=0&is_profit=1';
					AjaxPageLoad('#report_adress#&page=1&maxrows=250'+document.getElementById('report_url_string').value+'','show_report_stock_analy_incl',1,'POS İŞLEMLERİ YAPILIYOR!');
					is_pos_process_flas = 1;
					document.getElementById("show_report_stock_analy_incl_2_info").innerHTML = '<b><font color="F66633"> Pos İşlemlerine Devam Ediliyor.Bekleyiniz!</font></b>'; 
					</cfoutput>
				}	
			</cfif>	
		}
	</cfif>
	function getAjaxReport(){
		alert("burda");
		<cfif attributes.table_name is 'STOCK_MONTH' or attributes.table_name is 'STOCK_LOCATION_MONTH'>
			alert("burda1");
			<cfif attributes.table_name is 'STOCK_LOCATION_MONTH'>
				alert("burda2");
				<cfoutput query="GET_DEPARTMENT">
					AjaxPageLoad('#report_adress#&department_id=#DEPARTMENT_ID#-#LOCATION_ID#&page=1&maxrows=250#report_url_string#','show_report_stock_analy_incl_#DEPARTMENT_ID#_#LOCATION_ID#',1,'RAPOR OLUŞTURULUYOR');
				</cfoutput>
			<cfelse>
			alert("burda3");
			alert('<cfoutput>#report_adress#&page=1&maxrows=250#report_url_string#</cfoutput>');
				AjaxPageLoad('<cfoutput>#report_adress#&page=1&maxrows=250#report_url_string#</cfoutput>','show_report_stock_analy_incl',1,'RAPOR OLUŞTURULUYOR');
			</cfif>
		<cfelse>
			alert("burda4");
			AjaxPageLoad('<cfoutput>#report_adress#&#report_url_string#&page=1&maxrows=250</cfoutput>','show_report_stock_analy_incl',1,'RAPOR OLUŞTURULUYOR');
		</cfif>
	}
</script>

