<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="butceci" returntype="boolean" output="false">
<!---
notes : Butçe fişi keser...
		!!! TRANSACTION icinde kullanilmalidir !!!, ancak bu durumda transaction icindeki diger queryler de
		bu fonksiyon gibi dsn2 den calismalidir. Fonksiyon dagilim yaptigi taktirde (true) degilse false dondurur.
		****dongu icinde hersatirda sil calismamasi icin butceci icinde sil yok ayrı olarak cagrilmali 
usage :
butceci (
		action_id: invoice_id,
		muhasebe_db:dsn2,
		muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
		stock_id: stock_id,
		product_tax:attributes.tax,
		product_otv:attributes.otv,
		invoice_row_id: invoice_row_id,
		is_income_expense: 'false', <!---true:gelir , false:gider--->
		process_type:INVOICE_CAT, 
		nettotal: row_nettotal,
		other_money_gross_total:other_money_value, 
		action_currency:other_money,  islem para cinsi
		expense_date:attributes.INVOICE_DATE
		expense_member_type: , harcama veya satışı yapan tipi employee,partner,consumer
		expense_member_id :  harcama veya satışı yapanın idsi
		expense_date: islem tarihi,
		departmen_id: faturadaki department_id,
		project_id: projeye gore dagilim yapacaksa yollanmali
	);		
: TolgaS20060206; TolgaS20060605; Aysenur20080325
--->
<cfargument name="action_id" required="yes" type="numeric"><!---işlem idsi--->
<cfargument name="muhasebe_db" type="string" default="#dsn2#">
<cfargument name="muhasebe_db_alias" type="string" default="">
<cfargument name="stock_id" type="numeric">
<cfargument name="branch_id" default="">
<cfargument name="product_id" type="numeric">
<cfargument name="product_tax" type="numeric" default="0"><!--- kdv orani --->
<cfargument name="product_otv" type="numeric" default="0"><!--- ötv orani --->
<cfargument name="invoice_row_id" type="numeric"><!--- fatura satır idsi --->
<cfargument name="is_income_expense" required="yes" type="boolean" default="false"><!---true:gelir , false:gider --->
<cfargument name="process_type" required="yes" type="numeric"><!---INVOICE_CAT--->
<cfargument name="nettotal" required="yes" type="numeric" default="0"><!--- kdvsiz tutar --->
<cfargument name="other_money_value" type="numeric" default="0"><!--- kdvsiz satır dövizli toplam --->
<cfargument name="action_currency" type="string" default=""><!--- işlme para birimi--->
<cfargument name="action_currency_2" type="string" default="#session.ep.money2#"><!--- sistem 2. dövizi --->
<cfargument name="expense_member_type" type="string" default=""><!--- harcama yapam --->
<cfargument name="expense_member_id" type="numeric">
<cfargument name="company_id" type="string" default="">
<cfargument name="consumer_id" type="string" default="">
<cfargument name="employee_id" type="string" default=""><!---20070219 TolgaS bu parametrelerin isini yapması için expense_member_id ve expense_member_type var ken niye eklenmis --->
<cfargument name="expense_date" type="date" default="#now()#"><!--- işlem tarihi --->
<cfargument name="department_id" type="numeric" default="0">
<cfargument name="project_id" type="string" default="">
<cfargument name="insert_type" type="string" default=""><!---banka vs den gelen işlemler için ayraç --->
<cfargument name="expense_center_id" type="numeric"><!--- masraf/gelir merkezi --->
<cfargument name="expense_item_id" type="numeric"><!--- bütçe kalemi --->
<cfargument name="expense_account_code" type="string"><!--- muhasebe kodu --->
<cfargument name="detail" type="string" default=""><!--- açıklama --->
<cfargument name="currency_multiplier" type="string" default=""><!--- sistem 2.döviz kuru --->
<cfargument name="paper_no" type="string" default="">
<cfargument name="activity_type" type="string" default="">
<cfargument name="action_table" type="string" default="">
<cfargument name="subscription_id">
<cfargument name="period_id">
<cfargument name="muhasebe_db_dsn3">
<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelse>
	<cfset session_base = evaluate('session.ww')>
</cfif>
<cfif not (isdefined("arguments.period_id") and len(arguments.period_id))>
	<cfset new_period_id = session_base.period_id>
<cfelse>
	<cfset new_period_id = arguments.period_id>
</cfif>
<cfif not (isdefined("arguments.muhasebe_db_dsn3") and len(arguments.muhasebe_db_dsn3))>
	<cfset new_db_dsn3 = dsn3_alias>
<cfelse>
	<cfset new_db_dsn3 = "#arguments.muhasebe_db_dsn3#">
</cfif>
<cfscript>//sistem 2.dövizine göre hesaplama yapılır
	if(arguments.muhasebe_db is not '#dsn2#')
	{
		if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')		
			arguments.muhasebe_db_alias = '#dsn2_alias#.';
		else 
			arguments.muhasebe_db_alias = '#muhasebe_db#.';
	}
	else
		arguments.muhasebe_db_alias = '';
	if(not len(arguments.currency_multiplier))
	{
		get_currency_rate = cfquery(datasource : "#arguments.muhasebe_db#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#session_base.money2#'");
		if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
	}
</cfscript>
<cfif len(insert_type)><!--- banka vs den gelen işlemler için --->
	<cfset kdv_toplam = (arguments.nettotal*arguments.product_tax)/100>
	<cfset otv_toplam = (arguments.nettotal*arguments.product_otv)/100>
	<cfset kdvli_toplam = wrk_round(arguments.nettotal + kdv_toplam + otv_toplam)>
	<cfset other_kdvli_toplam = wrk_round(arguments.other_money_value + ((arguments.other_money_value*arguments.product_tax)/100) + ((arguments.other_money_value*arguments.product_otv)/100))>
	<cfquery name="ADD_EXPENSE" datasource="#arguments.muhasebe_db#">
		INSERT INTO
			#arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS
				(
					EXPENSE_ID,
					EXPENSE_DATE,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					EXPENSE_ACCOUNT_CODE,
					EXPENSE_COST_TYPE,
					DETAIL,
					IS_INCOME,
					ACTION_ID,
					COMPANY_ID,
					COMPANY_PARTNER_ID,
					MEMBER_TYPE,
					AMOUNT,<!--- kdvsiz tutar --->
					KDV_RATE,<!--- kdv oranı --->
					OTV_RATE,<!--- otv oranı --->
					AMOUNT_KDV,<!--- kdv tutaı --->
					AMOUNT_OTV,<!--- otv tutarı --->
					TOTAL_AMOUNT,<!--- kdvlitoplam --->
					OTHER_MONEY_VALUE,<!--- kdvsiz döviz toplam --->
					OTHER_MONEY_GROSS_TOTAL,<!--- kdvli döviz toplam --->
					OTHER_MONEY_VALUE_2,<!--- sistem 2. döviz kdvli toplam --->
					MONEY_CURRENCY_ID,<!--- işlem dövizi - other_money --->
					MONEY_CURRENCY_ID_2,<!--- sistem 2. dövizi --->
					ROW_PAPER_NO,
					QUANTITY,
					PROJECT_ID,
					RECORD_IP,
					RECORD_EMP,
					RECORD_CONS,
					RECORD_DATE,
					BRANCH_ID,
					ACTIVITY_TYPE,
					ACTION_TABLE
				)
			VALUES
				(
					0,
					#arguments.expense_date#,
					#arguments.expense_center_id#,
					#arguments.expense_item_id#,
					<cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
					#arguments.process_type#,
					#sql_unicode()#'#arguments.detail#',
					<cfif arguments.is_income_expense>1<cfelse>0</cfif>,
					#arguments.action_id#,
					<cfif len(arguments.company_id)>
						#arguments.company_id#,
						<cfif isDefined("arguments.expense_member_id") and len(arguments.expense_member_id) and arguments.expense_member_id neq 0>#arguments.expense_member_id#<cfelse>0</cfif>,
						'partner',
					<cfelseif len(arguments.consumer_id)>
						#arguments.consumer_id#,
                        <cfif isDefined("arguments.expense_member_id") and len(arguments.expense_member_id) and arguments.expense_member_id neq 0>#arguments.expense_member_id#<cfelse>0</cfif>,
						'consumer',
					<cfelseif len(arguments.employee_id)>
						#arguments.employee_id#,
                        <cfif isDefined("arguments.expense_member_id") and len(arguments.expense_member_id) and arguments.expense_member_id neq 0>#arguments.expense_member_id#<cfelse>0</cfif>,
						'employee',
					<cfelse>
						<!---
						FA neden calisana atiyoruz !!
						NULL,
						#session.ep.userid#,
						'employee',--->
                        NULL,
                        NULL,
                        NULL,
					</cfif>
					#arguments.nettotal#,
					#arguments.product_tax#,
					#arguments.product_otv#,
					#kdv_toplam#,
					#otv_toplam#,
					#kdvli_toplam#,
					#arguments.other_money_value#,
					#other_kdvli_toplam#,
					<cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round(arguments.nettotal/arguments.currency_multiplier)#<cfelse>NULL</cfif>,
					<cfif len(arguments.action_currency)>'#arguments.action_currency#'<cfelse>NULL</cfif>,
					'#session_base.money2#',
					<cfif isDefined("arguments.paper_no") and  len(arguments.paper_no)>'#arguments.paper_no#'<cfelse>NULL</cfif>,
					1,
					<cfif isDefined("arguments.project_id") and  len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
					'#CGI.REMOTE_ADDR#',
					<cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
					<cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
					#NOW()#,
					<cfif len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.activity_type)>#arguments.activity_type#<cfelse>NULL</cfif>,
					<cfif len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>
				)
		</cfquery>
	<cfreturn true>
<cfelse><!--- faturadan bütçeci --->
	<cfif len(project_id)>
		<cfquery name="GET_PROJECT_EXP_INFO" datasource="#arguments.muhasebe_db#"><!--- proje muhasebe kod ekranından sadece masraf merkzini alıp,kalemi üründen alsın diye yapıldı.. --->
			SELECT
			<cfif is_income_expense>
				INCOME_ITEM_ID EXP_ITEM_INFO,
				EXPENSE_CENTER_ID EXP_CENTER_INFO
			<cfelse>
				EXPENSE_ITEM_ID EXP_ITEM_INFO,
				COST_EXPENSE_CENTER_ID EXP_CENTER_INFO
			</cfif>
			FROM
				#new_db_dsn3#.PROJECT_PERIOD PP
			WHERE
				PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
		</cfquery>
		<cfquery name="GET_EXPENSE_ROW" datasource="#arguments.muhasebe_db#">
			<cfif GET_PROJECT_EXP_INFO.recordcount and GET_PROJECT_EXP_INFO.EXP_ITEM_INFO eq '-1'><!--- Üründen İşlem Yapılsın parametresi --->
				SELECT
					#GET_PROJECT_EXP_INFO.EXP_CENTER_INFO# EXPENSE_CENTER_ID,
					<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
					<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
					<cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
					100 AS RATE,
					0 AS COMPANY_PARTNER_ID,
					'' AS MEMBER_TYPE,
					0 AS IS_DEPARTMENT,
					0 AS TEMP_DEP_ID,
					0 AS EXPENSE_COST_TYPE
				FROM
					#new_db_dsn3#.PRODUCT_PERIOD PP
				WHERE
					PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
					PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
					<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
					<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
			<cfelse>
				SELECT
					<cfif is_income_expense>EXPENSE_CENTER_ID<cfelse>PP.COST_EXPENSE_CENTER_ID</cfif> AS EXPENSE_CENTER_ID,<!--- PP.EXPENSE_CENTER_ID, --->
					<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
					<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
					<cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
					100 AS RATE,<!--- masraf*gelir şablonu oran --->
					0 AS COMPANY_PARTNER_ID,
					'' AS MEMBER_TYPE,
					0 AS IS_DEPARTMENT,
					0 AS TEMP_DEP_ID,
					0 AS EXPENSE_COST_TYPE
				FROM
					#new_db_dsn3#.PROJECT_PERIOD PP
				WHERE
					PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
					PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
					<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
					<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
					<cfif is_income_expense>AND PP.EXPENSE_CENTER_ID IS NOT NULL<cfelse>AND PP.COST_EXPENSE_CENTER_ID IS NOT NULL</cfif>
			</cfif>
		UNION
			SELECT
				EPTR.EXPENSE_CENTER_ID,
				EPTR.EXPENSE_ITEM_ID,
				EPT.TEMPLATE_ID,
				EPTR.PROMOTION_ID,
				EPTR.RATE,<!--- masraf*gelir şablonu oran --->
				EPTR.COMPANY_PARTNER_ID,
				EPTR.MEMBER_TYPE,
				EPT.IS_DEPARTMENT,
				EPTR.DEPARTMENT_ID AS TEMP_DEP_ID,
				1 AS EXPENSE_COST_TYPE
			FROM
				#new_db_dsn3#.PROJECT_PERIOD PP,
				#arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES EPT,
				#arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES_ROWS EPTR
			WHERE
				PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
				PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
				<cfif is_income_expense>PP.INCOME_TEMPLATE_ID=EPT.TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID=EPT.TEMPLATE_ID</cfif> AND
				EPTR.TEMPLATE_ID=EPT.TEMPLATE_ID AND
				PP.EXPENSE_TEMPLATE_ID IS NOT NULL
				<cfif is_income_expense>AND EPT.IS_INCOME=1</cfif>
				AND (EPT.IS_DEPARTMENT=0 OR (EPT.IS_DEPARTMENT=1 AND EPTR.DEPARTMENT_ID=#department_id#))
		</cfquery>
	</cfif>
	<cfif not len(project_id) or not GET_EXPENSE_ROW.RECORDCOUNT>
		<cfquery name="GET_EXPENSE_ROW" datasource="#arguments.muhasebe_db#">
			SELECT
				PP.PRODUCT_ID,
				<cfif is_income_expense>EXPENSE_CENTER_ID<cfelse>PP.COST_EXPENSE_CENTER_ID</cfif> AS EXPENSE_CENTER_ID,<!--- PP.EXPENSE_CENTER_ID, --->
				<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
				<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
				<cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
				100 AS RATE,<!--- masraf*gelir şablonu oran --->
				<!--- <cfif is_income_expense>S.TAX<cfelse>S.TAX_PURCHASE</cfif> AS TAX, --->
				0 AS COMPANY_PARTNER_ID,
				'' AS MEMBER_TYPE,
				0 AS IS_DEPARTMENT,
				0 AS TEMP_DEP_ID,
				0 AS EXPENSE_COST_TYPE
			FROM
				#new_db_dsn3#.PRODUCT_PERIOD PP
				<!--- #dsn3_alias#.STOCKS S --->
			WHERE
				<!--- S.PRODUCT_ID=PP.PRODUCT_ID AND
				S.STOCK_ID = #arguments.stock_id# AND --->
				PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
				PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
				<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
				<cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
				<cfif is_income_expense>AND PP.EXPENSE_CENTER_ID IS NOT NULL<cfelse>AND PP.COST_EXPENSE_CENTER_ID IS NOT NULL</cfif>
		UNION
			SELECT
				PP.PRODUCT_ID,
				EPTR.EXPENSE_CENTER_ID,
				EPTR.EXPENSE_ITEM_ID,
				EPT.TEMPLATE_ID,
				EPTR.PROMOTION_ID,
				EPTR.RATE,<!--- masraf*gelir şablonu oran --->
				<!--- <cfif is_income_expense>S.TAX<cfelse>S.TAX_PURCHASE</cfif> AS TAX, --->
				EPTR.COMPANY_PARTNER_ID,
				EPTR.MEMBER_TYPE,
				EPT.IS_DEPARTMENT,
				EPTR.DEPARTMENT_ID AS TEMP_DEP_ID,
				1 AS EXPENSE_COST_TYPE
			FROM
				#new_db_dsn3#.PRODUCT_PERIOD PP,
			<!--- 	#dsn3_alias#.STOCKS S, --->
				#arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES EPT,
				#arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES_ROWS EPTR
			WHERE
				<!--- S.PRODUCT_ID=PP.PRODUCT_ID AND
				S.STOCK_ID = #arguments.stock_id# AND --->
				PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
				PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
				<cfif is_income_expense>PP.INCOME_TEMPLATE_ID=EPT.TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID=EPT.TEMPLATE_ID</cfif> AND
				EPTR.TEMPLATE_ID=EPT.TEMPLATE_ID AND
				<cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NOT NULL
				<cfif is_income_expense>AND EPT.IS_INCOME=1</cfif>
				AND (EPT.IS_DEPARTMENT=0 OR (EPT.IS_DEPARTMENT=1 AND EPTR.DEPARTMENT_ID=#department_id#))
		</cfquery>
	</cfif>
	<cfif GET_EXPENSE_ROW.recordcount>
		<cfscript>	
			if (not isdefined("arguments.expense_member_id") or not isdefined("arguments.expense_member_type"))
			{
				arguments.expense_member_id=session.ep.userid;
				arguments.expense_member_type='employee';
			}
		</cfscript>
		<cfoutput query="GET_EXPENSE_ROW">
			<!--- satır oranlarına gore tutar hesabı --->
			<cfif not isdefined("total_rate") or total_rate eq 0>
				<cfset total_rate=0>
				<cfoutput><cfset total_rate=total_rate+rate></cfoutput><!--- oranları 100 e tamamlıyor,output lu kalıcakmışş --->
			</cfif>
			<cfscript>
				ort_rate=(100*GET_EXPENSE_ROW.RATE);
				if(total_rate neq 0) ort_rate=ort_rate/total_rate;
				//satır dağılım oranına göre other_money_gross_total lar hesaplanıyor
				expense_amount=(ort_rate*arguments.nettotal)/100;
				expense_amount_kdv=(expense_amount*arguments.product_tax)/100;
				expense_amount_otv=(expense_amount*arguments.product_otv)/100;
				expense_amount_total=expense_amount+expense_amount_kdv+expense_amount_otv;
				expense_other_money_value=(ort_rate*arguments.other_money_value)/100;
				expense_other_money_gross= wrk_round(expense_other_money_value + ((expense_other_money_value*arguments.product_tax)/100) + ((arguments.other_money_value*arguments.product_otv)/100));
			</cfscript>			
			<cfif GET_EXPENSE_ROW.EXPENSE_COST_TYPE eq 1 and len(GET_EXPENSE_ROW.MEMBER_TYPE)>
				<cfif len(GET_EXPENSE_ROW.COMPANY_PARTNER_ID) and GET_EXPENSE_ROW.MEMBER_TYPE eq 'employee'>
					<!--- harcama yapan employee_id kaydedilecegi icin--->
					<cfquery name="GET_EMPS" datasource="#muhasebe_db#">
						SELECT EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EXPENSE_ROW.COMPANY_PARTNER_ID#">
					</cfquery>
					<cfset arguments.expense_member_id=GET_EMPS.EMPLOYEE_ID>
					<cfset arguments.expense_member_type='employee'>
				<cfelseif len(GET_EXPENSE_ROW.COMPANY_PARTNER_ID) and len(GET_EXPENSE_ROW.MEMBER_TYPE)>
					<cfset arguments.expense_member_id=GET_EXPENSE_ROW.COMPANY_PARTNER_ID>
					<cfset arguments.expense_member_type=GET_EXPENSE_ROW.MEMBER_TYPE>
				</cfif>
			</cfif>
			<cfquery name="ADD_EXPENSE" datasource="#muhasebe_db#">
				INSERT INTO
					#arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS
						(
							EXPENSE_COST_TYPE,
							ACTION_ID,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							EXPENSE_ACCOUNT_CODE,
							ACTIVITY_TYPE,
							DETAIL,
							STOCK_ID,
							EXPENSE_DATE,
							AMOUNT_KDV,<!--- kdv oran --->
							AMOUNT_OTV,<!--- ötv oran --->
							AMOUNT,<!--- kdvsiz toplam --->
							TOTAL_AMOUNT,<!--- kdvli toplam --->
							KDV_RATE,<!--- kdv toplam --->
							OTV_RATE,<!--- otv oplam --->
							EXPENSE_ID,
							INVOICE_ID,
							SALE_PURCHASE,
							MEMBER_TYPE,
							COMPANY_PARTNER_ID,
							MONEY_CURRENCY_ID,<!--- işlem dövizi-other_money --->
							OTHER_MONEY_VALUE,<!--- kdvsiz döviz toplam --->
							OTHER_MONEY_GROSS_TOTAL,<!--- kdvli döviz toplam --->
							OTHER_MONEY_VALUE_2,<!--- sistem 2. döviz tutar --->
							MONEY_CURRENCY_ID_2,<!--- sistem 2. dövizi --->
							IS_INCOME,
							RATE,
							IS_DETAILED,
							PROJECT_ID,
							QUANTITY,
							RECORD_IP,
							RECORD_EMP,
							RECORD_CONS,
							RECORD_DATE,
							BRANCH_ID,
							SUBSCRIPTION_ID
						)
					VALUES
						(
							#arguments.process_type#,
							<cfif len(arguments.invoice_row_id)>#arguments.invoice_row_id#<cfelse>NULL</cfif>,
							<cfif len(GET_EXPENSE_ROW.EXPENSE_CENTER_ID)>#GET_EXPENSE_ROW.EXPENSE_CENTER_ID#,<cfelse>NULL,</cfif>
							<cfif len(GET_EXPENSE_ROW.EXPENSE_ITEM_ID)>#GET_EXPENSE_ROW.EXPENSE_ITEM_ID#,<cfelse>NULL,</cfif>
							<cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
							<cfif len(GET_EXPENSE_ROW.ACTIVITY_TYPE_ID)>#GET_EXPENSE_ROW.ACTIVITY_TYPE_ID#,<cfelse>NULL,</cfif>
							<cfif len(arguments.detail)>#sql_unicode()#'#arguments.detail#',<cfelse>NULL,</cfif>
							#arguments.stock_id#,
							#arguments.expense_date#,
							#expense_amount_kdv#,
							#expense_amount_otv#,
							#expense_amount#,
							#expense_amount_total#,
							#arguments.product_tax#,
							#arguments.product_otv#,
							0,
							#arguments.action_id#,
							1,<!--- neden hep 1 ??? --->
							'#arguments.expense_member_type#',
							#arguments.expense_member_id#,
							<cfif len(arguments.action_currency)>'#arguments.action_currency#'<cfelse>NULL</cfif>,
							#expense_other_money_value#,
							#expense_other_money_gross#,
							<cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round(expense_amount_total/arguments.currency_multiplier)#<cfelse>NULL</cfif>,
							'#session_base.money2#',
							<cfif arguments.is_income_expense>1<cfelse>0</cfif>,
							<cfif len(ort_rate)>#ort_rate#<cfelse>NULL</cfif>,
							<cfif len(GET_EXPENSE_ROW.EXPENSE_COST_TYPE)>1<cfelse>0</cfif>,
							<cfif len(project_id)>#project_id#<cfelse>NULL</cfif>,
							1,
							'#CGI.REMOTE_ADDR#',
							<cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
							<cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
							#NOW()#,
							<cfif len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
							<cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>
					  )
				</cfquery>
			</cfoutput>
			<cfset total_rate=0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cfif><cfabort>
</cffunction>
<cffunction name="butce_sil" output="false">
	<!---
	by :  20060125
	notes : Butce fişi siler...
			!!! TRANSACTION icinde kullanılmalıdır !!!, ancak bu durumda transaction icindeki diger queryler de
			bu fonksiyon gibi dsn2 den calismalidir. Fonksiyon sorunsuz calistiginda true döndürür.
	usage :
		butce_sil (action_id:attributes.id,muhasebe_db:dsn2,process_type:process_type(fatura icin bos olmalı),is_stock_fis:1(stok fis ise true));
	revisions :TolgaS 20070211
	--->
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="process_type" type="string" default="">
	<cfargument name="muhasebe_db" type="string" default="#dsn2#">
	<cfargument name="muhasebe_db_alias" type="string" default="">
	<cfargument name="is_stock_fis" type="boolean" default="0">
		<cfif arguments.muhasebe_db is not '#dsn2#'>
			<cfset arguments.muhasebe_db_alias = '#dsn2_alias#'&'.'>
		<cfelse>
			<cfset arguments.muhasebe_db_alias =''>
		</cfif>
		<cfif len(arguments.process_type)><!--- banka vs tipi yerlerden gelen işlemler için --->
			<cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
				DELETE FROM #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #arguments.action_id# AND EXPENSE_COST_TYPE = #arguments.process_type# AND (ACTION_TABLE IS NULL OR ACTION_TABLE <> 'EMPLOYEES_PUANTAJ')
			</cfquery>
		<cfelse><!--- fatura dağılımları --->
			<cfif arguments.is_stock_fis eq 0>
				<cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
					DELETE FROM #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS WHERE INVOICE_ID = #arguments.action_id#
				</cfquery>
			<cfelse>
				<cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
					DELETE FROM #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS WHERE STOCK_FIS_ID = #arguments.action_id#
				</cfquery>
			</cfif>
		</cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
