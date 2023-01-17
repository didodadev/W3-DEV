<cfif not (isdefined("attributes.company_ship") and len(attributes.company_ship))>
	<script type="text/javascript">
		alert("İrsaliye Seçmelisiniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset ship_list = "">
<cfset add_stock_list = "">
<!--- farklı şirket kontrol --->
<cfif isdefined("company_ship") and len(company_ship)>
	<cfloop from="1" to="#listlen(company_ship)#" index="i">
		<cfif listlast(listgetat(company_ship,1),';') neq listlast(listgetat(company_ship,i),';')>
			<script type="text/javascript">
				alert("Yanlış Seçim !");
				history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfset ship_list = listappend(ship_list,listfirst(listgetat(company_ship,i),';'))>
		</cfif>
	</cfloop>
</cfif>
<!--- // farklı şirket kontrol --->
<cfquery name="GET_ALL_DEPT_LOCATION" datasource="#dsn#">
	SELECT 
		SL.COMMENT,
		SL.DEPARTMENT_LOCATION,
		SL.LOCATION_ID,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID
	FROM
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE 
		SL.DEPARTMENT_ID =D.DEPARTMENT_ID
</cfquery>		

<!--- // İşlem Tipi Kontrol --->
<cfif isdefined("attributes.process_cat")>
	<cfquery name="get_pro_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
	</cfquery>
	<cfif get_pro_type.process_type eq 78>
		<cfset process_type = '76'>
	<cfelseif get_pro_type.process_type eq 74>
		<cfset process_type = '71'>
	</cfif>
</cfif>

<cfset ship_period = listfirst(attributes.ship_period,';')>
<cfset dsn2_ship = '#dsn#_#listlast(attributes.ship_period,';')#_#session.ep.company_id#'>
<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
	SELECT 
		SHIP.SHIP_NUMBER,
		SHIP.SHIP_DATE,
		SHIP.DELIVER_EMP,
		SHIP.LOCATION,
		SHIP.DELIVER_STORE_ID,
		SHIP.DEPARTMENT_IN,
		SHIP.LOCATION_IN,
		SHIP.REF_NO,
		SHIP.SHIP_METHOD,
		SHIP.PAYMETHOD_ID,
		SHIP.ADDRESS,
        SHIP.SHIP_ADDRESS_ID,
		SHIP.CARD_PAYMETHOD_ID,
		SHIP.CARD_PAYMETHOD_RATE,
		SHIP.SALE_EMP,
		SHIP.PROJECT_ID,
		SHIP.COMMETHOD_ID,
		SHIP.DUE_DATE,
		SHIP.SHIP_DETAIL NOTE,
		SHIP_ROW.DUE_DATE AS ROW_DUE_DATE,
		ISNULL(SHIP.PROJECT_ID,0) MAIN_PROJECT_ID,
		SHIP_ROW.*,
		ISNULL(SHIP_ROW.ROW_PROJECT_ID,ISNULL(SHIP.PROJECT_ID,0)) MAIN_ROW_PROJECT_ID,
        (SELECT WORK_HEAD FROM #dsn_alias#.PRO_WORKS PW WHERE PW.WORK_ID = SHIP_ROW.ROW_WORK_ID) ROW_WORK_HEAD,
		ISNULL((SELECT TOP 1 SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0) SPECT_VAR_ID_,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.MANUFACT_CODE,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.IS_SERIAL_NO,
		STOCKS.STOCK_CODE_2,
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME,
		(SELECT TOP 1 O.ORDER_DATE FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SHIP_ROW.WRK_ROW_RELATION_ID) ORDER_DATE
	FROM
		#dsn2_ship#.SHIP SHIP,
		#dsn2_ship#.SHIP_ROW SHIP_ROW
		LEFT JOIN #dsn2_ship#.EXPENSE_CENTER AS EXC ON SHIP_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		LEFT JOIN #dsn2_ship#.EXPENSE_ITEMS AS EXI ON SHIP_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
		STOCKS
	WHERE
		SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
		<cfif isdefined('attributes.ship_list_type') and attributes.ship_list_type eq 1>
			SHIP_ROW.SHIP_ROW_ID IN (#ship_list#) AND
		<cfelse>
			SHIP_ROW.SHIP_ID IN (#ship_list#) AND
		</cfif>
		SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID
	ORDER BY
		SHIP.SHIP_ID,
		SHIP_ROW.SHIP_ROW_ID
		<cfif attributes.ship_list_type eq 1>
        	,SHIP_ROW.WRK_ROW_ID
		</cfif>
</cfquery>
<!--- Belge ve satir bazinda faturalanmis irsaliyeleri kontrol etmiyordu, eklendi --->
<cfquery name="get_period_dsns" datasource="#dsn2#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_all_ship_amount" datasource="#dsn#">
	SELECT
		SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
		SUM(A1.INVOICE_AMOUNT) AS INVOICE_AMOUNT,
		A1.STOCK_ID,
		A1.SPECT_VAR_ID,
		A1.SHIP_WRK_ROW_ID
	FROM
	(
	<cfloop query="get_period_dsns">
		SELECT
			SHIP_AMOUNT,
			INVOICE_AMOUNT,
			STOCK_ID,
			ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = GSRR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
			ISNULL(SHIP_WRK_ROW_ID,0) AS SHIP_WRK_ROW_ID
		FROM
			#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.GET_SHIP_ROW_RELATION GSRR
		WHERE
			SHIP_ID IN (#ValueList(GET_SHIP_ROW.SHIP_ID,',')#)
			AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period_dsns.period_id#">
			<!--- AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_period#"> --->
		<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
	</cfloop> ) AS A1
		GROUP BY
			A1.STOCK_ID,
			A1.SPECT_VAR_ID,
			A1.SHIP_WRK_ROW_ID
		ORDER BY STOCK_ID
</cfquery>
<cfscript>
	for(inv_k=1; inv_k lte get_all_ship_amount.recordcount; inv_k=inv_k+1)
	{
		'used_ship_amount_#get_all_ship_amount.STOCK_ID[inv_k]#_#get_all_ship_amount.SPECT_VAR_ID[inv_k]#_#get_all_ship_amount.SHIP_WRK_ROW_ID[inv_k]#' = get_all_ship_amount.SHIP_AMOUNT[inv_k];
		'used_invoice_amount_#get_all_ship_amount.STOCK_ID[inv_k]#_#get_all_ship_amount.SPECT_VAR_ID[inv_k]#_#get_all_ship_amount.SHIP_WRK_ROW_ID[inv_k]#' = get_all_ship_amount.INVOICE_AMOUNT[inv_k];
	}
</cfscript>
<!--- ship_list belge bazında listeleme yapıldıgında yani attributes.ship_list_type eq 1 oldugunda SHIP_ID degerlerini, urun bazında listelemede ise ROW_SHIP_ID degerlerini tutar --->
<cfset attributes.list_ship_ids = ListDeleteDuplicates(valueList(GET_SHIP_ROW.SHIP_ID))>
<cfset attributes.list_project_ids = ListDeleteDuplicates(valueList(GET_SHIP_ROW.MAIN_PROJECT_ID))>
<cfset attributes.list_ship_dates = ListDeleteDuplicates(valueList(GET_SHIP_ROW.SHIP_DATE))>
<cfset attributes.ship_date_liste = ListDeleteDuplicates(valueList(GET_SHIP_ROW.SHIP_DATE))>
<cfset ship_number_list = ListSort(ListDeleteDuplicates(valueList(GET_SHIP_ROW.SHIP_NUMBER)),"Text")>
<cfif isdefined("xml_multiple_ref_no") and xml_multiple_ref_no eq 1>
	<cfset ref_no_list = ListSort(ListDeleteDuplicates(valueList(GET_SHIP_ROW.REF_NO)),"Text")>
</cfif>
<cfset ship_date_list = ListDeleteDuplicates(valuelist(GET_SHIP_ROW.SHIP_DATE,','))>
<cfset list_row_project_ids = listsort(ListDeleteDuplicates(valueList(GET_SHIP_ROW.MAIN_ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif not isdefined('attributes.from_ship')><!--- irsaliyeye konsinye irsaliye iliskilendirmeden cagrılmıssa urunlerin muhasebe kodları alınmaz --->
	<cfset acc_product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.PRODUCT_ID)),'numeric','asc',',')>
	<cfquery name="get_product_accounts" datasource="#dsn3#">
		SELECT
			ACCOUNT_CODE,
			ACCOUNT_CODE_PUR,
			PRODUCT_ID
		FROM
			PRODUCT_PERIOD
		WHERE
			PRODUCT_ID IN (#acc_product_id_list#) AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		ORDER BY
			PRODUCT_ID
	</cfquery>
	<cfset acc_product_id_list=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
</cfif>
<cfif len(list_row_project_ids)>
	<cfquery name="get_row_projects" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#list_row_project_ids#)
	</cfquery>
	<cfset list_row_project_ids=listsort(ListDeleteDuplicates(valuelist(get_row_projects.PROJECT_ID)),'numeric','asc',',')>
</cfif>
<cfif len(attributes.invoice_date)>
	<cf_date tarih='attributes.invoice_date'>
	<cfoutput>
	<cfloop list="#ship_date_list#" index="i">
		<cfif datediff('d',i,attributes.invoice_date) gt 7>
		<script type="text/javascript">
			alert('7 Günden Daha Fazla İrsaliye Tarihi Var !: ' + ' #dateformat(createodbcdatetime(i),dateformat_style)#');
		</script>
		</cfif>
	</cfloop>
	</cfoutput>
</cfif>

<!--- Kur Onceki Belgeden Slinacaksa Belgenin Para Birimleri Cekilir --->
<cfquery name="control_comp_rate_type" datasource="#dsn#">
	SELECT IS_RATE_FROM_PRE_PAPER FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif Len(control_comp_rate_type.is_rate_from_pre_paper) and control_comp_rate_type.is_rate_from_pre_paper eq 1>
	<cfquery name="get_ship_money" datasource="#dsn2#">
		SELECT MONEY_TYPE,RATE1,RATE2,IS_SELECTED FROM SHIP_MONEY WHERE ACTION_ID IN (#ValueList(GET_SHIP_ROW.SHIP_ID,',')#) ORDER BY MONEY_TYPE
	</cfquery>
</cfif>

<!--- son irsaliyenin depo ve lokasyon bilgisi fatura sayfasındaki depo bilgilerine aktarılmak üzere alınıyor --->
<cfif len(GET_SHIP_ROW.DELIVER_STORE_ID[GET_SHIP_ROW.recordcount])>
	<cfset invoice_dept_id = GET_SHIP_ROW.DELIVER_STORE_ID[GET_SHIP_ROW.recordcount]>
	<cfset invoice_location = GET_SHIP_ROW.LOCATION[GET_SHIP_ROW.recordcount]>
<cfelseif len(GET_SHIP_ROW.DEPARTMENT_IN[GET_SHIP_ROW.recordcount])>
	<cfset invoice_dept_id = GET_SHIP_ROW.DEPARTMENT_IN[GET_SHIP_ROW.recordcount]>
	<cfset invoice_location = GET_SHIP_ROW.LOCATION_IN[GET_SHIP_ROW.recordcount]>
<cfelse>
	<cfset invoice_dept_id = ''>
	<cfset invoice_location = ''>
</cfif>
<cfif len(GET_SHIP_ROW.COMMETHOD_ID[GET_SHIP_ROW.recordcount])>
	<cfset invoice_commethod_id = GET_SHIP_ROW.COMMETHOD_ID[GET_SHIP_ROW.recordcount]>
<cfelse>
	<cfset invoice_commethod_id = ''>
</cfif>

<!--- en son siparisin vade tarihiyle siparis tarihi arasındaki fark irsaliyedeki basket_due_date alanına tasınır. --->
<cfif len(GET_SHIP_ROW.DUE_DATE[GET_SHIP_ROW.recordcount])>
	<cfset last_due_date = GET_SHIP_ROW.DUE_DATE[GET_SHIP_ROW.recordcount]>
</cfif>
<cfif len(GET_SHIP_ROW.SHIP_DATE[GET_SHIP_ROW.recordcount])>
	<cfset last_ship_date = GET_SHIP_ROW.SHIP_DATE[GET_SHIP_ROW.recordcount]>
</cfif>
<cfif isdefined('last_due_date') and len(last_due_date) and isdefined('last_ship_date') and len(last_ship_date)>
	<cfset temp_basket_due_day= datediff('d',last_ship_date,last_due_date)>
<cfelse>
	<cfset temp_basket_due_day=''>
</cfif>
<cfif len(invoice_dept_id) and len(invoice_location)>
	<cfquery name="GET_INV_LOCATION" dbtype="query">
		SELECT 
			COMMENT,
			DEPARTMENT_HEAD,
			BRANCH_ID,
			LOCATION_ID,
			DEPARTMENT_ID
		FROM
			GET_ALL_DEPT_LOCATION
		WHERE 
			LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_location#"> AND 
			DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_dept_id#">
	</cfquery>		
	<cfset invoice_dep_name = '#GET_INV_LOCATION.DEPARTMENT_HEAD#-#GET_INV_LOCATION.COMMENT#'>
	<cfset invoice_branch_id = GET_INV_LOCATION.BRANCH_ID>
<cfelse>
	<cfset invoice_dep_name = "">
	<cfset invoice_branch_id = "">
</cfif>
<cfquery name="get_period_dsns" datasource="#dsn#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> <!--- AND PERIOD_YEAR IN (#listlast(attributes.ship_period_,';')#,#listlast(attributes.ship_period_,';')+1#) konsinye irsaliyeleri daha sonraki tüm dönemlere cekilebiliyor, konsinye devir olmadıgından --->
</cfquery>
<cfset Ship_Detail_ = "">
<cfscript>
	adres_info_ = replacelist(GET_SHIP_ROW.ADDRESS,"#chr(10)#"," ");
	adres_info_ = replacelist(adres_info_,"#chr(13)#"," ");
</cfscript>
<script type="text/javascript">
try{ /*komisyon satırı hesaplamalarında oncelikle belgedeki komisyon oranı vs degerlerini kontrol ettiginden bu bolum satır eklemeden onceye taşındı*/
<cfoutput>
	selected_index = 1;
	<cfif Len(control_comp_rate_type.is_rate_from_pre_paper) and control_comp_rate_type.is_rate_from_pre_paper eq 1>
		<cfif get_ship_money.recordcount>
			<cfloop query="get_ship_money">
				for(shm=1; shm <= "#get_ship_money.recordcount#"; shm=shm+1)
				{
					if(opener.document.getElementById("hidden_rd_money_#get_ship_money.currentrow#") != undefined && "#get_ship_money.money_type#" == opener.document.getElementById("hidden_rd_money_"+shm).value)
					{
						if(opener.document.getElementsByName("rd_money")[shm-1] != undefined && "#get_ship_money.is_selected#" == 1)
						{
							selected_index = shm; // İrsaliye Seçilirken seçili olarak gelen döviz kuru üzerinden kur_degistir fonksiyonunda çalışması için eklendi. EY20140509
							opener.document.getElementsByName("rd_money")[shm-1].checked = true;
						}
						if(opener.document.getElementById("txt_rate1_"+shm) != undefined)
							opener.document.getElementById("txt_rate1_"+shm).value = "#get_ship_money.rate1#";
						if(opener.document.getElementById("txt_rate2_"+shm) != undefined)
							opener.document.getElementById("txt_rate2_"+shm).value = "#TLFormat(get_ship_money.rate2,4)#";
					}
				}
			</cfloop>
		</cfif>
	</cfif>
	<cfif len(GET_SHIP_ROW.PAYMETHOD_ID)>
		<cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
			SELECT PAYMETHOD_ID,PAYMETHOD,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #GET_SHIP_ROW.PAYMETHOD_ID#
		</cfquery>			
		if(opener.form_basket.paymethod_id != undefined)
			opener.form_basket.paymethod_id.value = '#GET_PAYMENT_METHOD.PAYMETHOD_ID#';
		if(opener.form_basket.paymethod != undefined)
			opener.form_basket.paymethod.value = '#GET_PAYMENT_METHOD.PAYMETHOD#';
		if(opener.form_basket.card_paymethod_id != undefined)
			opener.form_basket.card_paymethod_id.value  ='';
		if(opener.form_basket.commission_rate != undefined)
			opener.form_basket.card_paymethod_id.value  ='';
	<cfelseif len(GET_SHIP_ROW.CARD_PAYMETHOD_ID)>
		<cfquery name="GET_PAYMENT_METHOD" datasource="#dsn3#">
			SELECT 
				CARD_NO
				<cfif GET_SHIP_ROW.COMMETHOD_ID eq 6> <!--- WW den gelen--->
				,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
				<cfelse>  <!--- EP VE PP den gelen--->
				,COMMISSION_MULTIPLIER 
				</cfif>
			FROM 
				CREDITCARD_PAYMENT_TYPE 
			WHERE 
				PAYMENT_TYPE_ID=#GET_SHIP_ROW.CARD_PAYMETHOD_ID#
		</cfquery>
		if(opener.form_basket.card_paymethod_id != undefined)
			opener.form_basket.card_paymethod_id.value  = '#GET_SHIP_ROW.CARD_PAYMETHOD_ID#';
		if(opener.form_basket.commission_rate != undefined)
			opener.form_basket.commission_rate.value = '<cfif len(GET_SHIP_ROW.CARD_PAYMETHOD_RATE)>#GET_SHIP_ROW.CARD_PAYMETHOD_RATE#</cfif>';
		if(opener.form_basket.paymethod_id != undefined)
			opener.form_basket.paymethod_id.value = '';
		if(opener.form_basket.paymethod != undefined)
			opener.form_basket.paymethod.value = '#GET_PAYMENT_METHOD.CARD_NO#';
	</cfif>
	
	<cfif Len(get_ship_row.ship_method)>
		<cfquery name="get_ship_method" datasource="#dsn#">
			SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_ship_row.ship_method#
		</cfquery>
		if(opener.form_basket.ship_method_name != undefined)
			opener.form_basket.ship_method_name.value = '#get_ship_method.ship_method#';
			
		if(opener.form_basket.ship_method != undefined)
			opener.form_basket.ship_method.value = '#get_ship_row.ship_method#';
			
	</cfif>
	<cfif Len(get_ship_row.ref_no) and ((isdefined("xml_multiple_ref_no") and xml_multiple_ref_no eq 0) or not isdefined("xml_multiple_ref_no"))>
		if(opener.form_basket.ref_no != undefined)
			opener.form_basket.ref_no.value = '#get_ship_row.ref_no#';
	</cfif>
	
	<cfif len(temp_basket_due_day)>
		if(opener.form_basket.basket_due_value != undefined)
		{
			opener.form_basket.basket_due_value.value = '#temp_basket_due_day#';
			if('#temp_basket_due_day#' != "")//fbs 20120328
				opener.form_basket.basket_due_value_date_.value  = date_add('d',#temp_basket_due_day#,opener.form_basket.invoice_date.value);
		}
	</cfif>	
	<cfif len(GET_SHIP_ROW.SALE_EMP)>
		<cfquery name="GET_SALE_EMP" datasource="#dsn#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #GET_SHIP_ROW.SALE_EMP#
		</cfquery>
		if(opener.form_basket.EMPO_ID != undefined)
			opener.form_basket.EMPO_ID.value  = '#GET_SHIP_ROW.SALE_EMP#';
		if(opener.form_basket.PARTNER_NAMEO != undefined)
			opener.form_basket.PARTNER_NAMEO.value  = '#GET_SALE_EMP.EMPLOYEE_NAME# #GET_SALE_EMP.EMPLOYEE_SURNAME#';
	</cfif>
	<cfif Len(get_ship_row.note) and ListLen(ListDeleteDuplicates(ValueList(get_ship_row.ship_id))) eq 1>
		<cfset Replace_List = "',#Chr(10)#,#Chr(13)#"><!--- Satir kirma vb sorun oldugundan kaldirmak icin eklendi degistirmeyin FBS --->
		<cfset Replace_List_New = ",,">
		<cfset Ship_Detail = ReplaceList(get_ship_row.note,Replace_List,Replace_List_New)>
		<cfset Ship_Detail_ = Listappend(Ship_Detail_,Ship_Detail,',')>
		if(opener.form_basket.note != undefined)
			opener.form_basket.note.value = '#Ship_Detail_#';
	</cfif>
	<cfif Len(GET_SHIP_ROW.WRK_ROW_RELATION_ID)>
		//Satis Ortagi bilgisini, iliskili siparişten alir, FBS 20110218
		<cfquery name="get_related_orders" datasource="#dsn3#">
			SELECT
				SALES_CONSUMER_ID,
				SALES_PARTNER_ID
			FROM
				ORDERS O,
				ORDER_ROW OW
			WHERE
				O.ORDER_ID = OW.ORDER_ID AND
				OW.WRK_ROW_ID = '#GET_SHIP_ROW.WRK_ROW_RELATION_ID#'
		</cfquery>
		<cfif Len(get_related_orders.sales_partner_id)>
			if(opener.form_basket.sales_member_id != undefined)
			{
				opener.form_basket.sales_member_type.value  = 'partner';
				opener.form_basket.sales_member_id.value  = '#get_related_orders.sales_partner_id#';
				opener.form_basket.sales_member.value  = '#get_par_info(get_related_orders.sales_partner_id,0,-1,0)#';
			}
		<cfelseif Len(get_related_orders.sales_consumer_id)>
			if(opener.form_basket.sales_member_id != undefined)
			{
				opener.form_basket.sales_member_type.value  = 'consumer';
				opener.form_basket.sales_member_id.value  = '#get_related_orders.sales_consumer_id#';
				opener.form_basket.sales_member.value  = '#get_cons_info(get_related_orders.sales_consumer_id,0,0)#';
			}
		</cfif>
	</cfif>
	var temp_inv_cat = opener.form_basket.process_cat.options[opener.form_basket.process_cat.selectedIndex].value;
	if(temp_inv_cat.length)
		var inv_process_type = eval("opener.form_basket.ct_process_type_" + temp_inv_cat + '.value');
</cfoutput>
}catch(e){
}
<cfoutput query="GET_SHIP_ROW">
	/*satırlardaki depo-location bilgileri add_basket_rowda kullanmak icin alınıyor*/
	<cfif len(DELIVER_LOC)>
		<cfquery name="GET_DEPT_NAME" dbtype="query">
			SELECT 
				COMMENT,
				DEPARTMENT_HEAD,
				BRANCH_ID
			FROM
				GET_ALL_DEPT_LOCATION
			WHERE 
				LOCATION_ID=#DELIVER_LOC# 
				AND DEPARTMENT_ID = #DELIVER_DEPT#
		</cfquery>		
	<cfelseif len(DELIVER_DEPT)>
		<cfquery name="GET_DEPT_NAME" datasource="#DSN#">
			SELECT DISTINCT	DEPARTMENT_HEAD, BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = #DELIVER_DEPT#
		</cfquery>
	</cfif>
	<cfset BASKET_EMPLOYEE=''>
	<cfif len(BASKET_EMPLOYEE_ID)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BASKET_EMPLOYEE_ID#"> 
	</cfquery>
	<cfset BASKET_EMPLOYEE = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE> 
	</cfif>
	<cfscript>
		row_paymethod_id = GET_SHIP_ROW.row_paymethod_id;
		
		ship_amount_ = GET_SHIP_ROW.AMOUNT;
		if(not isdefined("from_ship")){//Faturalanmış ise girmesin
			if (isdefined('used_invoice_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#') and Evaluate('used_invoice_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#') gt 0)
				ship_amount_ = ship_amount_ - Evaluate('used_invoice_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#');
		}
		
		if (isdefined('used_ship_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#') and Evaluate('used_ship_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#') gt 0)
			ship_amount_ = ship_amount_ - Evaluate('used_ship_amount_#GET_SHIP_ROW.STOCK_ID#_#GET_SHIP_ROW.SPECT_VAR_ID_#_#GET_SHIP_ROW.WRK_ROW_ID#');
		
		
		//Formdan Eklenen Deger, Irsaliyenin Kalan Degerlerinden Buyukse Eklenmez, Kucukse Eklenir
		if(isdefined('attributes.ship_add_amount_#GET_SHIP_ROW.SHIP_ID#_#GET_SHIP_ROW.SHIP_ROW_ID#') and evaluate('attributes.ship_add_amount_#GET_SHIP_ROW.SHIP_ID#_#GET_SHIP_ROW.SHIP_ROW_ID#') gt 0)
		{
			if(ship_amount_ gte evaluate('attributes.ship_add_amount_#GET_SHIP_ROW.SHIP_ID#_#GET_SHIP_ROW.SHIP_ROW_ID#'))
				ship_amount_ = evaluate('attributes.ship_add_amount_#GET_SHIP_ROW.SHIP_ID#_#GET_SHIP_ROW.SHIP_ROW_ID#');
		}
		if(isdefined('attributes.kalan') and len(attributes.kalan) and (attributes.kalan != 'undefined'))
		{
			ship_kalan = listgetat(attributes.kalan,currentrow,';');
			if(ship_amount_ gte ship_kalan)
			{ 
				ship_amount_ = listgetat(attributes.kalan,currentrow,';');
			}
		}
		
		if(len(DISCOUNT)) d1 = DISCOUNT; else d1=0;
		if(len(DISCOUNT2)) d2 = DISCOUNT2; else d2=0;
		if(len(DISCOUNT3)) d3 = DISCOUNT3; else d3=0;
		if(len(DISCOUNT4)) d4 = DISCOUNT4; else d4=0;
		if(len(DISCOUNT5)) d5 = DISCOUNT5; else d5=0;
		if(len(DISCOUNT6)) d6 = DISCOUNT6; else d6=0;
		if(len(DISCOUNT7)) d7 = DISCOUNT7; else d7=0;
		if(len(DISCOUNT8)) d8 = DISCOUNT8; else d8=0;
		if(len(DISCOUNT9)) d9 = DISCOUNT9; else d9=0;
		if(len(DISCOUNT10)) d10 = DISCOUNT10; else d10=0;
		if(len(DELIVER_DATE)) d_date = dateformat(DELIVER_DATE,dateformat_style); else d_date="";
		if(len(DELIVER_LOC)) 
			{
				d_dept_id = DELIVER_DEPT & "-" & DELIVER_LOC;
				d_dept_name = GET_DEPT_NAME.COMMENT & "-" & GET_DEPT_NAME.DEPARTMENT_HEAD;
			}
		else if(len(DELIVER_DEPT))
			{
				d_dept_id = DELIVER_DEPT;
				d_dept_name = GET_DEPT_NAME.DEPARTMENT_HEAD;
			}
		else
			{
				d_dept_id = "";
				d_dept_name = "";
			}
		if (isdefined('attributes.from_ship')){
			SQLStr = "SELECT
				PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
				PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
			FROM
				PRODUCT_COST PC,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE 
				SM.MONEY = PC.PURCHASE_NET_MONEY AND
				PC.PRODUCT_COST IS NOT NULL AND
				PC.START_DATE < #DATEADD('d',1,SHIP_DATE)# AND 
				PC.PRODUCT_ID = #product_id#
			ORDER BY 
				PC.START_DATE DESC,PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			if(len(query1.PURCHASE_NET))
				net_maliyet = query1.PURCHASE_NET; 
			else
				net_maliyet = 0;
			
			if(len(query1.PURCHASE_EXTRA_COST))
				temp_extra_cost = query1.PURCHASE_EXTRA_COST; 	
			else temp_extra_cost = 0;
		}
		else{
			if(len(COST_PRICE) and COST_PRICE neq 0) 
				net_maliyet = COST_PRICE; 
			else 
				net_maliyet = 0;
			if(len(EXTRA_COST) and EXTRA_COST neq 0) 
				temp_extra_cost = EXTRA_COST; 
			else temp_extra_cost = 0;
		}
		if(len(MARGIN)) marj = TLFormat(MARGIN,4); else marj = 0;
		
		if(len(PROM_COST)) temp_prom_cost = PROM_COST; else temp_prom_cost = 0;
		if(len(UNIQUE_RELATION_ID)) temp_unique_relation_id= UNIQUE_RELATION_ID; else temp_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) temp_prom_relation_id= PROM_RELATION_ID; else temp_prom_relation_id = "";
		if(len(PRODUCT_NAME2))
		{
			temp_product_name2 = replace(PRODUCT_NAME2,"'","","all");
			temp_product_name2 = replace(temp_product_name2,'"','','all');
			temp_product_name2 = replace(temp_product_name2,';','','all');
		}
		else
			temp_product_name2 = "";
			
		if(len(spect_var_name))
			{
			temp_spect_var_name = replace(spect_var_name,"'","","all");
			temp_spect_var_name = replace(temp_spect_var_name,'"','','all');
			temp_spect_var_name = replace(temp_spect_var_name,';','','all');	
			}
		else
			temp_spect_var_name = "";
		if(len(WIDTH_VALUE)) row_width_value = WIDTH_VALUE; else row_width_value = '';
		if(len(DEPTH_VALUE)) row_depth_value = DEPTH_VALUE; else row_depth_value = '';
		if(len(HEIGHT_VALUE)) row_height_value = HEIGHT_VALUE; else row_height_value = '';
		if(len(AMOUNT2)) temp_amount2 = AMOUNT2; else temp_amount2 = "";
		if(len(UNIT2))temp_unit2 = UNIT2; else temp_unit2 = "";
		if(len(EXTRA_PRICE))temp_ek_tutar = EXTRA_PRICE; else temp_ek_tutar = 0;
		if(len(OTV_ORAN)) temp_otv_oran =OTV_ORAN; else temp_otv_oran = 0;
		if(len(SHELF_NUMBER)) temp_shelf_number = SHELF_NUMBER; else temp_shelf_number = "";
		if(len(ROW_DUE_DATE)) temp_due_date = ROW_DUE_DATE; else temp_due_date=0;
		if(len(KARMA_PRODUCT_ID)) temp_karma_product_id =KARMA_PRODUCT_ID; else temp_karma_product_id = '';
		if(len(CATALOG_ID)) row_catalog_id=CATALOG_ID; else row_catalog_id='';
		/*Masraf Merkezi*/
		if( len(EXPENSE_CENTER_ID) )
		{
			row_exp_center_id = EXPENSE_CENTER_ID;
			row_exp_center_name = EXPENSE;
		}
		else
		{
			row_exp_center_id = '';
			row_exp_center_name = '';
		}

		//Aktivite Tipi
		row_activity_id = ACTIVITY_TYPE_ID;

		//Bütçe Kalemi
		if( len(EXPENSE_ITEM_ID) )
		{
			row_exp_item_id = EXPENSE_ITEM_ID;
			row_exp_item_name = EXPENSE_ITEM_NAME;
		}
		else 
			{
				row_exp_item_id = '';
				row_exp_item_name = '';
			}
		row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
		row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : '';
		row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
		row_bsmv_amount = ( len( BSMV_AMOUNT ) ) ? BSMV_AMOUNT : '';
		row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
		row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
		row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';	
		row_reason_code = ( len( REASON_CODE ) ) ? REASON_CODE & '--' & REASON_NAME : '';

		temp_wrk_row_relation_id=WRK_ROW_ID;
		temp_name_product=Replace(name_product,"'","","all");
		temp_name_product=Replace(temp_name_product,'"','','all');
		temp_name_product = replace(temp_name_product,';','','all');
		if(len(STOCK_CODE_2)) special_code = STOCK_CODE_2; else special_code = '';
	</cfscript>

	<cfif not isdefined('attributes.from_ship')>
		if(window.opener.basket.hidden_values.SALE_PRODUCT == 1)
			account_code = '#get_product_accounts.ACCOUNT_CODE[listfind(acc_product_id_list,PRODUCT_ID,',')]#';
		else 
			account_code = '#get_product_accounts.ACCOUNT_CODE_PUR[listfind(acc_product_id_list,PRODUCT_ID,',')]#';
	<cfelse>
		account_code = '';
	</cfif>
	if(inv_process_type != undefined && list_find('591,531',inv_process_type)) //ihracat ve ithalat faturalarına irsaliye ekleniyorsa kdvler sıfırlanır.
		temp_tax =0;
	else
		temp_tax = #GET_SHIP_ROW.TAX#;
		
	toplam_hesap=0;
	<cfif len(list_row_project_ids)>
		row_project_name = '#Replace(get_row_projects.PROJECT_HEAD[listfind(list_row_project_ids,MAIN_ROW_PROJECT_ID,',')],"'","","all")#';
	<cfelse>
		row_project_name = '';
	</cfif>
	<cfif Len(GET_SHIP_ROW.DETAIL_INFO_EXTRA)>
		row_detail_info_extra = '#Replace(GET_SHIP_ROW.DETAIL_INFO_EXTRA,"'","","all")#';
	<cfelse>
		row_detail_info_extra = '';
	</cfif>
	gtip_number = '#GET_SHIP_ROW.GTIP_NUMBER#';
	<cfif (ship_amount_ gt 0 and isdefined("attributes.from_ship")) or not isdefined("attributes.from_ship")> 
		opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#product_manufact_code#', '#temp_name_product#', '#unit_id#', '#unit#', '#spect_var_id#', '#temp_spect_var_name#', '#wrk_round(price,4)#', '#price_other#', temp_tax, '#temp_due_date#', '#d1#', '#d2#', '#d3#', '#d4#', '#d5#', '#d6#', '#d7#', '#d8#', '#d9#', '#d10#', '#d_date#', '#d_dept_id#', '#d_dept_name#', '#LOT_NO#', '#OTHER_MONEY#', '#get_ship_row.ship_id#;#ship_period#', '#ship_amount_#', account_code, '#IS_INVENTORY#','#IS_PRODUCTION#','#net_maliyet#','#marj#','#temp_extra_cost#','#PROM_ID#','#PROM_COMISSION#','#temp_prom_cost#','#DISCOUNT_COST#','#IS_PROMOTION#','#PROM_STOCK_ID#','#temp_otv_oran#','#temp_product_name2#','#temp_amount2#','#temp_unit2#','#temp_ek_tutar#','#temp_shelf_number#','#temp_unique_relation_id#','#row_catalog_id#',toplam_hesap,'#IS_COMMISSION#','#BASKET_EXTRA_INFO_ID#','#temp_prom_relation_id#','','','#number_of_installment#','#price_cat#','#temp_karma_product_id#','','','#temp_wrk_row_relation_id#','','','#row_width_value#','#row_depth_value#','#row_height_value#','','#main_row_project_id#' ,row_project_name,'','','#row_paymethod_id#','#special_code#','#BASKET_EMPLOYEE_ID#','#BASKET_EMPLOYEE#','#row_work_id#','#row_work_head#','#row_exp_center_id#','#row_exp_center_name#','#row_exp_item_id#','#row_exp_item_name#','','#SELECT_INFO_EXTRA#','row_detail_info_extra','#gtip_number#','#row_activity_id#','','','','','#row_bsmv_rate#','#row_bsmv_amount#','#row_bsmv_currency#','#row_oiv_rate#','#row_oiv_amount#','#row_tevkifat_rate#','#row_tevkifat_amount#','#row_reason_code#', <cfif GET_SHIP_ROW.recordcount eq GET_SHIP_ROW.currentRow>0<cfelse>1</cfif>);
	</cfif>
</cfoutput>
opener.kur_degistir(selected_index); //faturadaki kur irslaiyedekinden farklıysa sorun olmaması icin satırlar eklendikten sonra kur_degistir calıstırılıyor
try{
<cfoutput>
	if(opener.form_basket.irsaliye.value.length == 0)
		opener.form_basket.irsaliye.value = "#ship_number_list#";
	else
		opener.form_basket.irsaliye.value = opener.form_basket.irsaliye.value +",#ship_number_list#";
	<cfif isdefined("xml_multiple_ref_no") and xml_multiple_ref_no eq 1>
	if(opener.form_basket.ref_no.value.length == 0)
	{
		if(opener.form_basket.ref_no != undefined)
			opener.form_basket.ref_no.value = "#ref_no_list#";
	}
	else
	{
		if(opener.form_basket.ref_no != undefined)
			opener.form_basket.ref_no.value = opener.form_basket.ref_no.value +",#ref_no_list#";
	}
	</cfif>
	if(opener.form_basket.irsaliye_id_listesi.value != undefined)
	{
	<cfloop list="#attributes.list_ship_ids#" index="ship_index">
		if(opener.form_basket.irsaliye_id_listesi.value == '')
			opener.form_basket.irsaliye_id_listesi.value = '#ship_index#;#ship_period#';
		else
			opener.form_basket.irsaliye_id_listesi.value += ',#ship_index#;#ship_period#';
	</cfloop>
	}
	if(opener.form_basket.irsaliye_project_id_listesi.value != undefined)
	{
	<cfloop list="#attributes.list_project_ids#" index="ship_index1">
		if(opener.form_basket.irsaliye_project_id_listesi.value == '')
			opener.form_basket.irsaliye_project_id_listesi.value = '#ship_index1#';
		else
			opener.form_basket.irsaliye_project_id_listesi.value += ',#ship_index1#';
	</cfloop>
	}
	<cfif isdefined("attributes.ship_date_liste")>
		<cfloop list="#attributes.list_ship_dates#" index="ship_index">
			if(opener.form_basket.irsaliye_date_listesi.value == '')
				opener.form_basket.irsaliye_date_listesi.value = '#dateformat(ship_index,dateformat_style)#';
			else
				opener.form_basket.irsaliye_date_listesi.value += ',#dateformat(ship_index,dateformat_style)#';
		</cfloop>
		if(opener.form_basket.siparis_date_listesi!= undefined)
		{
			if(opener.form_basket.siparis_date_listesi.value == '')
				opener.form_basket.siparis_date_listesi.value = '<cfoutput>#dateformat(GET_SHIP_ROW.order_date,dateformat_style)#</cfoutput>';
			else
				opener.form_basket.siparis_date_listesi.value += ',<cfoutput>#dateformat(GET_SHIP_ROW.order_date,dateformat_style)#</cfoutput>';
		}
	</cfif>
	<cfif isdefined("attributes.ship_project_liste")>
		<cfloop list="#attributes.list_project_ids#" index="ship_index">
			if(opener.form_basket.irsaliye_project_id_listesi.value == '')
				opener.form_basket.irsaliye_project_id_listesi.value = '#ship_index#';
			else
				opener.form_basket.irsaliye_project_id_listesi.value += ',#ship_index#';
		</cfloop>
	</cfif>
	
	
	/*depo-lokasyon-teslim eden, vs bilgileri fatura sayfasına gonderiliyor*/
	opener.form_basket.department_name.value = '#invoice_dep_name#';
	opener.form_basket.department_id.value = '#invoice_dept_id#';	
	opener.form_basket.location_id.value = '#invoice_location#';	
	opener.form_basket.branch_id.value = '#invoice_branch_id#';
	if(opener.form_basket.commethod_id != undefined)
		opener.form_basket.commethod_id.value = '#invoice_commethod_id#';
		
	<cfif len(GET_SHIP_ROW.PROJECT_ID)>
		<cfquery name="GET_PROJECT" datasource="#dsn#">
			SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #GET_SHIP_ROW.PROJECT_ID#
		</cfquery>		
		if(opener.form_basket.project_id != undefined)
			opener.form_basket.project_id.value = '#GET_PROJECT.PROJECT_ID#';


		if(opener.form_basket.project_head != undefined)
			opener.form_basket.project_head.value = '#Replace(GET_PROJECT.PROJECT_HEAD,"'","")#';
	</cfif>	
	<cfif isdefined('url.sale_product') and (url.sale_product eq 1) and not isdefined('attributes.from_ship')>
		opener.form_basket.adres.value = "#adres_info_#";
		opener.form_basket.ship_address_id.value = "#GET_SHIP_ROW.SHIP_ADDRESS_ID#";
	</cfif>
</cfoutput>
}catch(e){
	}
<cfif isdefined('attributes.ship_list_type')>
	<cfset new_url_str ='ship_list_type=0'>/*sayfaya yeniden yönlendirildiginde belge bazında acılıyor*/
	<cfif isdefined('attributes.ship_period')>
		<cfset new_url_str = "ship_period=#attributes.ship_period#">
	</cfif>
	<cfif isdefined("attributes.ship_date_liste")>
		<cfset new_url_str = "#new_url_str#&ship_date_liste=#attributes.ship_date_liste#">
	</cfif>
	<cfif isdefined("attributes.ship_project_liste")>
		<cfset new_url_str = "#new_url_str#&ship_project_liste=#attributes.ship_project_liste#">
	</cfif>
	<!---<cfif isdefined('attributes.ship_date_liste')>
		<cfset new_url_str = "ship_date_liste=#attributes.ship_date_liste#">
	</cfif>
	<cfif isdefined('attributes.ship_project_liste')>
		<cfset new_url_str = "ship_project_liste=#attributes.ship_project_liste#">
	</cfif>--->
	<cfif isdefined('attributes.cat')>
		<cfset new_url_str = "#new_url_str#&cat=#attributes.cat#">
	</cfif>
	<cfif isdefined('attributes.stock_id')>
		<cfset new_url_str = "#new_url_str#&stock_id = #attributes.stock_id#">
	</cfif>
	<cfif isdefined('attributes.product_name')>
		<cfset new_url_str = "#new_url_str#&product_name=#attributes.product_name#">
	</cfif>
	<cfif isdefined('attributes.is_kesilmis')>
		<cfset new_url_str = "#new_url_str#&is_kesilmis=#attributes.is_kesilmis#">
	</cfif>
	<cfif isdefined('attributes.department_id')>
		<cfset new_url_str = "#new_url_str#&department_id=#attributes.department_id#">
	</cfif>
	<cfif isdefined('attributes.keyword')>
		<cfset new_url_str = "#new_url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined('attributes.process_cat')>
		<cfset new_url_str = "#new_url_str#&process_cat=#attributes.process_cat#">
	</cfif>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
		<cfset new_url_str = "#new_url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
		<cfset new_url_str = "#new_url_str#&consumer_id=#attributes.consumer_id#">
	</cfif>
	<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
		<cfset new_url_str = "#new_url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif isdefined('attributes.sale_product')>
		<cfset new_url_str = "#new_url_str#&sale_product=#attributes.sale_product#">
	</cfif>
	<cfif isdefined('attributes.start_date')>
		<cfset new_url_str = "#new_url_str#&start_date=#attributes.start_date#">
	</cfif>
	<cfif isdefined('attributes.finish_date')>
		<cfset new_url_str = "#new_url_str#&finish_date=#attributes.finish_date#">
	</cfif>
	<cfif isdefined('attributes.id')>
		<cfset new_url_str = "#new_url_str#&id=#attributes.id#">
	</cfif>
	<cfif isdefined('attributes.from_ship')>
		<cfset new_url_str = "#new_url_str#&from_ship=1">
	</cfif>
	<cfif isdefined("attributes.is_store")>
		<cfset action_url_str = "#new_url_str#&is_store=#attributes.is_store#">
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=objects.popup_list_choice_ship&is_form_submitted=1&#new_url_str#</cfoutput>';
<cfelse>
	window.close();
</cfif>
</script>