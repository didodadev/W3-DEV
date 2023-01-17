<cfswitch expression="#attributes.str_code#">
	<!--- process --->
	<cfcase value="prdp_get_total_stock_12">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, SM.SPECT_MAIN_NAME AS PRODUCT_NAME,SM.SPECT_MAIN_ID,S.STOCK_CODE FROM STOCKS_ROW AS SR,#param_1#.SPECT_MAIN AS SM,#param_1#.STOCKS S WHERE S.STOCK_ID = SM.STOCK_ID AND S.IS_ZERO_STOCK = 0 AND SR.PROCESS_TYPE IS NOT NULL AND SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SM.SPECT_MAIN_ID IN (#param_2#) AND UPD_ID NOT IN (#param_3#) AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND SR.PROCESS_DATE <= #param_6# GROUP BY SM.SPECT_MAIN_NAME,SM.SPECT_MAIN_ID,S.STOCK_CODE">
	</cfcase>   
    	
	<!--- Harcama Talebi --->	
	<cfcase value="obj_expense_request_approve_control">
		<cfset form.str_sql="SELECT IS_APPROVE FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.ext_params#">
	</cfcase>  

	<!--- Vardiya Tarihleri --->
	<cfcase value="get_shift_date">
		<cfset form.str_sql="SELECT STARTDATE, FINISHDATE FROM SETUP_SHIFTS WHERE SHIFT_ID = #attributes.ext_params#">
	</cfcase>
	<!--- Vardiya Çakışan Tarih --->
	<cfcase value="get_shift_date_conflicting">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cf_date tarih="param_1">
		<cf_date tarih="param_2">
		<cfset form.str_sql="SELECT START_DATE, FINISH_DATE, SETUP_SHIFT_EMPLOYEE_ID, SHIFT_ID  FROM SETUP_SHIFT_EMPLOYEE WHERE EMPLOYEE_ID = #param_4# AND SETUP_SHIFT_EMPLOYEE_ID <> #param_3# AND ((START_DATE <= #param_1# AND FINISH_DATE >= #param_2#) OR (START_DATE >= #param_1# AND START_DATE <= #param_2# AND FINISH_DATE <= #param_2#) OR ( START_DATE <= #param_1# AND FINISH_DATE >= #param_1# AND FINISH_DATE <= #param_2#) OR ( START_DATE >= #param_1# AND FINISH_DATE <= #param_2#) OR ( START_DATE >= #param_1# AND FINISH_DATE >= #param_2# AND START_DATE <= #param_2# ) AND (START_DATE = #param_1# AND FINISH_DATE = #param_2#))">
	</cfcase>

	<!--- Vardiya Çakışan Tarih --->
	<cfcase value="get_shift_date_conflicting_same">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cf_date tarih="param_1">
		<cf_date tarih="param_2">
		<cfset form.str_sql="SELECT START_DATE, FINISH_DATE, SETUP_SHIFT_EMPLOYEE_ID, SHIFT_ID  FROM SETUP_SHIFT_EMPLOYEE WHERE EMPLOYEE_ID = #param_4# AND SETUP_SHIFT_EMPLOYEE_ID <> #param_3# AND (START_DATE = #param_1# AND FINISH_DATE = #param_2#)">
	</cfcase>

	<!--- derece / kademe puanı --->
	<cfcase value="get_grade_step">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT TOP 1 STEP_#param_2# FROM EMPLOYEES_GRADE_STEP_PARAMS WHERE GRADE =  #param_1# ORDER BY  START_DATE DESC, FINISH_DATE DESC">
	</cfcase>

	<cfcase value="get_setup_working_type">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql="SELECT COLOR_CODE, WORKING_ABBREVIATION FROM SETUP_WORKING_TYPE WHERE WORKING_TYPE =  #param_1#">
	</cfcase>

	<!--- derece / kademe puanı --->
	<cfcase value="get_param_pay">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql="SELECT COMMENT_PAY, ODKES_ID  FROM SETUP_PAYMENT_INTERRUPTION WHERE SSK_STATUE =  #param_1# AND STATUS = 1 AND IS_ODENEK = 1 AND ISNULL(IS_BES,0) = 0  ORDER BY  COMMENT_PAY">
	</cfcase>

	<!--- ÇAlışanın Gruba Giriş Tarihi --->
	<cfcase value="get_group_start">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT  GROUP_STARTDATE FROM EMPLOYEES WHERE EMPLOYEE_ID = #param_1#">
	</cfcase>

	<!--- Genel Tatil Zamanları ---->
	<cfcase value="get_general_offtimes">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cf_date tarih="param_1">
		<cfset form.str_sql="SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES WHERE START_DATE <= #param_1# AND FINISH_DATE >= #param_1#">
	</cfcase>

	<cfcase value="prc_get_company_risk">
		<cfset form.str_sql="SELECT BAKIYE, CEK_ODENMEDI, CEK_KARSILIKSIZ, SENET_ODENMEDI, SENET_KARSILIKSIZ, OPEN_ACCOUNT_RISK_LIMIT, TOTAL_RISK_LIMIT, COMPANY_ID FROM COMPANY_RISK WHERE COMPANY_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="prc_get_company_orders">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT SUM(NETTOTAL) NETTOTAL, COMPANY_ID FROM ORDERS WHERE IS_PAID<>1 AND IS_PROCESSED<>1 AND ( (ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1 ) ) AND COMPANY_ID=#param_1# AND ORDER_ID <> #param_2# GROUP BY COMPANY_ID">
	</cfcase>
	<cfcase value="prc_get_process">
		<cfset form.str_sql="SELECT DISTINCT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PRO_POSITION_ID IN (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#) AND ((WORKGROUP_ID IN (SELECT MAINWORKGROUP_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE MAINWORKGROUP_ID IS NOT NULL AND PROCESS_ROW_ID = #attributes.ext_params#)) OR (PROCESS_ROW_ID = #attributes.ext_params#))">
	</cfcase>
	<cfcase value="prc_process_all_employee">
		<cfset form.str_sql="SELECT IS_EMPLOYEE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.ext_params# AND IS_EMPLOYEE = 1">
	</cfcase>
	<cfcase value="prc_get_kontrol">
		<cfset form.str_sql="SELECT IS_CONTINUE FROM PROCESS_TYPE_ROWS WHERE IS_CONTINUE = 1 AND PROCESS_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_process_stages">
		<cfset form.str_sql="SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="get_remain_order_result1">
    	<cfset form.str_sql="SELECT P_ORDER_ID,(PO.QUANTITY - ISNULL((SELECT SUM(PORR.AMOUNT) AMOUNT FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND PORR.TYPE = 1),0)) REMAIN_AMOUNT FROM PRODUCTION_ORDERS PO WHERE (PO.QUANTITY - ISNULL((SELECT SUM(PORR.AMOUNT) AMOUNT FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND PORR.TYPE = 1),0)) > 0 AND PO.P_ORDER_ID =#attributes.ext_params#">
    </cfcase>
	<!--- project --->
<!--- add options --->
	
	<cfcase value="adop_get_prom_str">
		<cfset form.str_sql="SELECT PROM_HEAD FROM PROMOTIONS WHERE PROM_ID IN (#attributes.ext_params#)">
	</cfcase>
	<cfcase value="adop_doc_no_ctrl">
		<cfset form.str_sql="SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE PAPER_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="adop_consumer_control">
		<cfset form.str_sql="SELECT CONSUMER_ID,TERMINATE_DATE,CONSUMER_STATUS FROM CONSUMER WHERE TC_IDENTY_NO='#attributes.ext_params#'">
	</cfcase>				 
	<cfcase value="adop_consumer_control_2">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="adop_country_control">
		<cfset form.str_sql="SELECT COUNTRY_ID FROM SETUP_COUNTRY WHERE IS_DEFAULT=1">
	</cfcase>				 
	<cfcase value="adop_get_cons_pro">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_STATUS = 1 AND MEMBER_CODE = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="adop_get_prod_name">
		<cfset form.str_sql="SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #attributes.ext_params#">
	</cfcase>				 
	<cfcase value="adop_get_prom">
		<cfset form.str_sql="SELECT DISTINCT PC.PROMOTION_ID PROMOTION_ID FROM PROMOTION_CONDITIONS_PRODUCTS PCP,PROMOTION_CONDITIONS PC WHERE PCP.PROM_CONDITION_ID = PC.PROM_CONDITION_ID AND PCP.STOCK_ID = #attributes.ext_params# AND PCP.IS_SALE_WITH_PROM = 1">
	</cfcase>
	<cfcase value="adop_get_prom_name2">
		<cfset form.str_sql="SELECT PROM_HEAD FROM PROMOTIONS WHERE PROM_ID =#attributes.ext_params#">
	</cfcase>	
	<cfcase value="adop_get_stock">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND S.STOCK_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="adop_get_stock_id">
		<cfset form.str_sql="SELECT TOP 1 STOCK_ID FROM STOCKS WHERE PRODUCT_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="adop_get_strategy">
		<cfset form.str_sql="SELECT ISNULL(MAXIMUM_ORDER_STOCK_VALUE,0) AS MAX_VALUE FROM STOCK_STRATEGY WHERE STOCK_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="adop_otv_control">
		<cfset form.str_sql="SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = '#SESSION.EP.PERIOD_ID#' AND TAX IN (#attributes.ext_params#)">
	</cfcase>
   	<cfcase value="adop_get_total_stock">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID = #param_1# GROUP BY SR.STOCK_ID UNION	SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID = #param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID = #param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID = #param_1# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_PRODUCTION=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME ORDER BY S.STOCK_ID">
	</cfcase> 
   	<cfcase value="adop_getProductDetail">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 PRODUCT_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID IN (#param_1#) AND VARIATION_ID = #param_2#">
	</cfcase>     
    <!--- asset --->
    <cfcase value="ascr_get_emp_asset_group">
		<cfset form.str_sql="SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP WHERE CONTENT_PROPERTY_ID = '#attributes.ext_params#' OR CONTENT_PROPERTY_ID LIKE '#attributes.ext_params#,%' OR CONTENT_PROPERTY_ID LIKE '%,#attributes.ext_params#' OR CONTENT_PROPERTY_ID LIKE '%,#attributes.ext_params#,%'">
	</cfcase>
	
    <cfcase value="get_asset_live">
		<cfset form.str_sql="SELECT ASSET_ID FROM ASSET WHERE LIVE = 1 AND ASSET_NO = '#attributes.ext_params#'">
	</cfcase>
    <cfcase value="get_dpl_id">
		<cfset form.str_sql="SELECT DPL_ID FROM DRAWING_PART WHERE ASSET_ID = '#attributes.ext_params#'">
	</cfcase>
	 
	<cfcase value="get_content_property">
		<cfset form.str_sql="SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY ORDER BY NAME"> 
	</cfcase>
	<cfcase value="get_content_property2">
		<cfset form.str_sql="SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY ORDER BY NAME">
	</cfcase>
	<cfcase value="prj_get_comp">
		<cfset form.str_sql="SELECT BRANCH.COMPANY_ID AS COMPANY_ID,EMPLOYEE_POSITIONS.POSITION_CODE,EMPLOYEE_POSITIONS.EMPLOYEE_NAME,EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS,DEPARTMENT,BRANCH WHERE EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND EMPLOYEE_POSITIONS.IS_MASTER = 1 AND EMPLOYEE_POSITIONS.EMPLOYEE_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="get_temp_work_cat">
		<cfset form.str_sql="SELECT TF.TEMPLATE_ID FROM TEMPLATE_FORMS TF, PRO_WORK_CAT PWC WHERE TF.TEMPLATE_ID = PWC.TEMPLATE_ID AND PWC.WORK_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_pro_work_cat">
		<cfset form.str_sql="SELECT WORK_CAT_ID, #dsn#.Get_Dynamic_Language(PWC.WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,PWC.WORK_CAT) AS WORK_CAT FROM PRO_WORK_CAT PWC WHERE ','+OUR_COMPANY_ID+',' LIKE '%,#session.ep.company_id#,%' AND MAIN_PROCESS_ID IS NOT NULL AND ','+MAIN_PROCESS_ID+',' LIKE '%,#attributes.ext_params#,%'">
	</cfcase>
    <cfcase value="get_add_milestone">
		<cfset form.str_sql="SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE PROJECT_ID =  #attributes.ext_params# AND IS_MILESTONE = 1 ORDER BY WORK_HEAD">
	</cfcase>
	<cfcase value="get_upd_milestone">
	    <cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE PROJECT_ID = #param_1# AND IS_MILESTONE = 1 AND WORK_ID <> #param_2# ORDER BY WORK_HEAD">
	</cfcase>
	<cfcase value="get_relation_time_cost">
	    <cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT SUM(EXPENSED_MINUTE) AS TOTAL_TIME FROM TIME_COST WHERE EMPLOYEE_ID = #param_1# AND EVENT_DATE > #param_2# AND EVENT_DATE <= #param_3#">
	</cfcase>
	<!--- purchase --->

	<cfcase value="prch_get_credit_limit">
		<cfset form.str_sql="SELECT PRICE_CAT,PRICE_CAT_PURCHASE FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.ext_params# AND OUR_COMPANY_ID=#session.ep.company_id#">
	</cfcase>
	<cfcase value="prch_get_credit_limit_cons">
		<cfset form.str_sql="SELECT PRICE_CAT,PRICE_CAT_PURCHASE FROM COMPANY_CREDIT WHERE CONSUMER_ID = #attributes.ext_params# AND OUR_COMPANY_ID=#session.ep.company_id#">
	</cfcase>
	<cfcase value="prch_get_comp_cat">
		<cfset form.str_sql="SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="prch_get_cons_cat_2">
		<cfset form.str_sql="SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="prch_get_order">
		<cfset form.str_sql="SELECT ORDER_ID FROM ORDERS WHERE PURCHASE_SALES = 0 AND ORDER_ZONE = 0 AND ORDER_NUMBER='#attributes.ext_params#'">
	</cfcase>

	<cfcase value="prch_ctrl_pym_plan">
		<cfset form.str_sql="SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.ext_params#">
	</cfcase>

    <cfcase value="prdp_get_price_cat">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND COMPANY_CAT LIKE '%,#param_1#,%') ORDER BY PRICE_CAT">
	</cfcase>
    <cfcase value="prdp_get_price_cat_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND PRICE_CATID = #param_2#) OR (PRICE_CAT_STATUS = 1 AND COMPANY_CAT LIKE '%,#param_1#,%') ORDER BY PRICE_CAT">
	</cfcase>

	<!--- report & _2--->

	<cfcase value="rpr_get_branch">
		<cfif not session.ep.ehesap>
			<cfset query_extra = "AND BRANCH.BRANCH_ID IN (SELECT EBR.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES EBR WHERE EBR.POSITION_CODE = #session.ep.position_code#)">
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH,OUR_COMPANY WHERE OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND OUR_COMPANY.COMP_ID=#attributes.ext_params# #query_extra#">
	</cfcase>
	<cfcase value="rpr_get_dep">
		<cfset form.str_sql="SELECT D.DEPARTMENT_HEAD,D.DEPARTMENT_ID FROM DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID=B.BRANCH_ID AND D.BRANCH_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="rpr_get_dep_name">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID IN (#attributes.ext_params#) ORDER BY DEPARTMENT_HEAD">
	</cfcase>
	<cfcase value="rpr_get_branch_dep_name">
		<cfset form.str_sql="SELECT BRANCH.BRANCH_NAME,	BRANCH.BRANCH_ID FROM BRANCH WHERE BRANCH.COMPANY_ID IN (#attributes.ext_params#) ORDER BY BRANCH.BRANCH_NAME">
	</cfcase>
    <cfcase value="rpr_get_branch_name">
		<cfif not session.ep.ehesap>
			<cfset query_extra = "AND BRANCH_ID IN (SELECT EBR.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES EBR WHERE EBR.POSITION_CODE = #session.ep.position_code#)">
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH WHERE COMPANY_ID IN (#attributes.ext_params#) #query_extra# ORDER BY BRANCH_NAME">
	</cfcase>
	<cfcase value="rpr_get_branch_name2">
		<cfif not session.ep.ehesap>
			<cfset query_extra = "AND BRANCH.BRANCH_ID IN (SELECT EBR.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES EBR WHERE EBR.POSITION_CODE = #session.ep.position_code#)">
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH,OUR_COMPANY WHERE OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND OUR_COMPANY.COMP_ID IN (#param_1#) AND ZONE_ID = #param_2# #query_extra#">
	</cfcase>
	<!--- sales --->
	<cfcase value="sls_bsk_z_stk_stt">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE TITLE='zero_stock_status' AND BASKET_ID = #attributes.ext_params# AND B_TYPE=1">
	</cfcase>
	<cfcase value="sls_get_cnsmr_2">
		<cfset form.str_sql="SELECT * FROM CONSUMER_RISK WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_pay_control">
		<cfset form.str_sql="SELECT SP.DUE_START_DAY FROM SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_get_cmpny">
		<cfset form.str_sql="SELECT DISTINCT EP.EMPLOYEE_ID,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.EMPLOYEE_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_get_cnsmr_1">
		<cfset form.str_sql="SELECT TC_IDENTY_NO FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_get_cmpny_2">
		<cfset form.str_sql="SELECT EP.EMPLOYEE_ID,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.EMPLOYEE_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_control_payment_plan">
		<cfset form.str_sql="SELECT OTHER_MONEY_TOTAL,OTHER_MONEY FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="sls_get_order">
		<cfset form.str_sql="SELECT ORDER_ID FROM ORDERS WHERE ((ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)) AND ORDER_NUMBER='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="sls_get_offer_history">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT OFFER_ID FROM OFFER_HISTORY WHERE PURCHASE_SALES = 1 AND OFFER_STAGE = #param_1# AND OFFER_ID = #param_2#">
	</cfcase>
    <cfcase value="sls_get_department_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT COUNT(DEPARTMENT_ID) COUNT FROM PRO_PROJECTS WHERE PROJECT_ID = #param_1# AND DEPARTMENT_ID = #param_2# AND LOCATION_ID = #param_3#">
	</cfcase>
	<!--- salesplan --->

	<cfcase value="slsp_get_period_count_main">
		<cfset form.str_sql="SELECT PERIOD_COUNT FROM SALES_QUOTAS_ROW SQRR WHERE SQRR.SALES_QUOTA_ROW_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="slsp_get_period_count">
		<cfset form.str_sql="SELECT COUNT(SQRR.RELATION_ID) PERIOD_COUNT FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID =  #attributes.ext_params# AND TYPE = 1">
	</cfcase>
	<cfcase value="slsp_get_period_count_2">
		<cfset form.str_sql="SELECT COUNT(SQRR.RELATION_ID) PERIOD_COUNT FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID =  #attributes.ext_params# AND TYPE = 2">
	</cfcase>
	<cfcase value="slsp_get_compny">
		<cfset form.str_sql="SELECT EP.POSITION_CODE,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.POSITION_CODE=#attributes.ext_params#">
	</cfcase>
	<cfcase value="slsp_get_cmp_name">
		<cfset form.str_sql="SELECT COMPANY FROM CONSUMER WHERE CONSUMER_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="slsp_branch_control">
		<cfset form.str_sql="SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# AND BRANCH_STATUS=1 ORDER BY BRANCH_NAME">
	</cfcase>
	<cfcase value="slsp_brand_control_2">
		<cfset form.str_sql="SELECT  BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN(SELECT BRAND_ID FROM #attributes.ext_params#.PRODUCT_BRANDS_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#) AND IS_ACTIVE = 1 ORDER BY BRAND_NAME">
	</cfcase>
	<cfcase value="slsp_comp_cat_control">
		<cfset form.str_sql="SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT">
	</cfcase>
	<cfcase value="slsp_employee_control">
		<cfset form.str_sql="SELECT DISTINCT EP.EMPLOYEE_NAME,EP.EMPLOYEE_SURNAME,EP.EMPLOYEE_ID FROM SALES_ZONES_TEAM SZT,SALES_ZONES_TEAM_ROLES IMC,EMPLOYEE_POSITIONS EP WHERE SZT.TEAM_ID = IMC.TEAM_ID AND IMC.POSITION_CODE = EP.POSITION_CODE AND SZT.SALES_ZONES=#attributes.ext_params# ORDER BY EP.EMPLOYEE_NAME,EP.EMPLOYEE_SURNAME">
	</cfcase>
	<cfcase value="slsp_ims_control">
		<cfset form.str_sql="SELECT DISTINCT SC.IMS_CODE_ID,SC.IMS_CODE_NAME FROM SALES_ZONES_TEAM SZT,SALES_ZONES_TEAM_IMS_CODE IMC,SETUP_IMS_CODE SC WHERE SZT.TEAM_ID = IMC.TEAM_ID AND IMC.IMS_ID = SC.IMS_CODE_ID AND SZT.SALES_ZONES=#attributes.ext_params# ORDER BY SC.IMS_CODE_NAME">
	</cfcase>
	<cfcase value="slsp_team_control">
		<cfset form.str_sql="SELECT DISTINCT SZT.TEAM_ID,SZT.TEAM_NAME FROM SALES_ZONES_TEAM SZT WHERE SZT.SALES_ZONES=#attributes.ext_params# ORDER BY SZT.TEAM_NAME">
	</cfcase>
	<cfcase value="slsp_product_cat_control">
		<cfset form.str_sql="SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #attributes.ext_params#.PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#) AND HIERARCHY NOT LIKE \'%.%\' ORDER BY PRODUCT_CAT">
	</cfcase>
	<cfcase value="slsp_zone_control">
		<cfset form.str_sql="SELECT SZ_NAME,SZ_ID FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME">
	</cfcase>

    <cfcase value="slsp_company_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE SALES_COUNTY=#param_1# AND COMPANYCAT_ID=#param_2# AND COMPANY_STATUS=1 ORDER BY FULLNAME">
	</cfcase>

    <cfcase value="slsp_company_control_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE SALES_COUNTY=#param_1# AND COMPANY_STATUS=1 ORDER BY FULLNAME">
	</cfcase>

    <cfcase value="slsp_company_control_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANYCAT_ID=#param_1# AND COMPANY_STATUS=1 ORDER BY FULLNAME">
	</cfcase>

    <cfcase value="slsp_product_cat_control_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #attributes.ext_params#.PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#) AND HIERARCHY NOT LIKE '%.%' ORDER BY PRODUCT_CAT">
	</cfcase>

    <cfcase value="slsp_zone_control_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.SUB_ZONE_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.SUB_BRANCH_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.TEAM_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

	<!--- banka --->
	<cfcase value="get_acc_code">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT STOPPAGE_ACCOUNT_CODE FROM SETUP_STOPPAGE_RATES WHERE SETUP_BANK_TYPE_ID = #param_1# AND STOPPAGE_RATE = #param_2#">	
	</cfcase>
	
	<!--- service --->
	<cfcase value="srv_get_cmpny">
		<cfset form.str_sql="SELECT EP.EMPLOYEE_ID,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.EMPLOYEE_ID=#attributes.ext_params#">
	</cfcase>

    <cfcase value="srv_get_service_code">
		<cfset form.str_sql="SELECT SERVICE_CODE_ID FROM SETUP_SERVICE_CODE WHERE PRODUCT_CAT = #attributes.ext_params#">
	</cfcase>
    <cfcase value="srv_get_subscription">
    	<cfset form.str.sql="SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.ext_params#">
    </cfcase>    

    <cfcase value="srv_get_spare_part">
		<cfset form.str_sql="SELECT SPARE_PART_ID,SPARE_PART FROM SERVICE_SPARE_PART WHERE PRODUCT_CAT = #attributes.ext_params#">
	</cfcase>
    
    <cfcase value="sls_get_service">
		<cfset form.str_sql="SELECT SERVICE_ID FROM SERVICE WHERE SERVICE_NO = '#attributes.ext_params#'">
	</cfcase>

     <cfcase value="srv_get_subscription_price">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql = "SELECT TOP 1 S.PRICE_OTHER OTHER_MONEY_VALUE,S.OTHER_MONEY,SM.MONEY,SM.RATE1,SM.RATE2 FROM SUBSCRIPTION_CONTRACT_ROW S,#dsn_alias#.SETUP_MONEY SM WHERE S.SUBSCRIPTION_ID = #param_1# AND S.PRODUCT_ID = #param_2# AND S.OTHER_MONEY = SM.MONEY AND PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 ORDER BY S.SUBSCRIPTION_ROW_ID DESC">
    </cfcase>

    <cfcase value="slsp_control_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.IMS_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.EMPLOYEE_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_5">
  	  	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.CUSTOMER_COMP_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.PRODUCTCAT_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

	<!--- salesplan devamı --->
    <cfcase value="slsp_control_7">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.BRAND_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_8">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.COMPANYCAT_ID = #param_2# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_zone_control_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.SUB_ZONE_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_9">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.SUB_BRANCH_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_10">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.TEAM_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_11">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.IMS_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_12">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.EMPLOYEE_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_13">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.CUSTOMER_COMP_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_14">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.PRODUCTCAT_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_15">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.BRAND_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>

    <cfcase value="slsp_control_16">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = #param_1# AND SQR.COMPANYCAT_ID = #param_2# AND SQ.SALES_QUOTE_ID <> #param_3# AND SQ.IS_PLAN = 1">
	</cfcase>
    <!--- settings devamı --->
    <cfcase value="set_get_default_process">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE IN (51,54,55,59,60,61,63,591)">
	</cfcase>

    <cfcase value="set_get_default_process_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE IN (50,52,53,56,57,58,62,531)">
	</cfcase>

    <cfcase value="set_get_default_process_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE IN (73,74,75,76,77)">
	</cfcase>

    <cfcase value="set_get_default_process_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE IN (70,71,72,78,79)">
	</cfcase>

    <cfcase value="set_get_default_process_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE IN (140,141)">
	</cfcase>

    <cfcase value="set_get_default_process_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_MODULE=#param_1# AND PROCESS_TYPE = #param_2#">
	</cfcase>

    <cfcase value="set_get_inventory_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT HIERARCHY FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID <> #param_1# AND HIERARCHY = '#param_2#'">
	</cfcase>

    <cfcase value="set_get_inventory_7">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE IN (51,54,55,59,60,61,63,591)">
	</cfcase>

    <cfcase value="set_get_inventory_8">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE IN (50,52,53,56,57,58,62,531)">
	</cfcase>

    <cfcase value="set_get_inventory_9">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE IN (73,74,75,76,77)">
	</cfcase>

    <cfcase value="set_get_inventory_10">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE IN (70,71,72,78,79)">
	</cfcase>

    <cfcase value="set_get_inventory_11">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE IN (140,141)">
	</cfcase>

    <cfcase value="set_get_inventory_12">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE IS_DEFAULT=1 AND PROCESS_CAT_ID<> #param_1# AND PROCESS_MODULE=#param_2# AND PROCESS_TYPE = #param_3#">
	</cfcase>

    <cfcase value="set_get_tevkifat">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT STATEMENT_RATE FROM SETUP_TEVKIFAT WHERE TEVKIFAT_ID <> #param_1# AND STATEMENT_RATE IN  (#param_2#)">
	</cfcase>

    <!--- stock devamı --->

    <cfcase value="stk_get_inv_control">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM SHIP S WHERE S.SHIP_TYPE = 75 AND SHIP_ID <> #param_1# AND WRK_ROW_RELATION_ID = '#param_2#')">
	</cfcase>

	<cfcase value="stk_get_inv_control2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM SHIP S WHERE S.SHIP_TYPE = 74 AND SHIP_ID <> #param_1# AND WRK_ROW_RELATION_ID = '#param_2#')">
	</cfcase>

	<cfcase value="stk_get_location_status">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT STATUS FROM STOCKS_LOCATION  WHERE DEPARTMENT_ID = #param_1# AND STATUS=1">
	</cfcase>

	<cfcase value="stk_get_shelf_status">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PLACE_STATUS FROM PRODUCT_PLACE  WHERE STORE_ID = #param_1# AND LOCATION_ID = #param_2# AND PLACE_STATUS=1">
	</cfcase>

    <cfcase value="stk_get_inv_control_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID IN(SELECT I.INVOICE_ID FROM INVOICE I WHERE I.IS_IPTAL = 0) AND SHIP_ID <> #param_1# AND WRK_ROW_RELATION_ID = '#param_2#'">
	</cfcase>

    <cfcase value="stk_get_relation_multiship">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT S.EQUIPMENT_PLANNING_ID,O.COMPANY_ID COMPANY_ID,O.CONSUMER_ID CONSUMER_ID FROM SHIP_RESULT S, SHIP_RESULT_ROW SRR, #param_1#.ORDERS O,#param_1#.ORDER_ROW ORR WHERE S.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND O.ORDER_ID = ORR.ORDER_ID AND SRR.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND S.EQUIPMENT_PLANNING_ID = #param_2#">
	</cfcase>

    <cfcase value="stk_GET_PRICE">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SHIP_METHOD_PRICE_ROW.PRICE,SHIP_METHOD_PRICE_ROW.OTHER_MONEY FROM SHIP_METHOD_PRICE,SHIP_METHOD_PRICE_ROW WHERE SHIP_METHOD_PRICE.SHIP_METHOD_PRICE_ID = SHIP_METHOD_PRICE_ROW.SHIP_METHOD_PRICE_ID AND SHIP_METHOD_PRICE.COMPANY_ID = #param_1# AND SHIP_METHOD_PRICE_ROW.SHIP_METHOD_ID = #param_2# AND SHIP_METHOD_PRICE_ROW.START_VALUE<#param_3# AND SHIP_METHOD_PRICE_ROW.FINISH_VALUE>=#param_3#">
	</cfcase>

    <cfcase value="stk_GET_PRICE_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHIP_METHOD_PRICE_ROW.PRICE,SHIP_METHOD_PRICE_ROW.OTHER_MONEY FROM SHIP_METHOD_PRICE,SHIP_METHOD_PRICE_ROW WHERE SHIP_METHOD_PRICE.SHIP_METHOD_PRICE_ID = SHIP_METHOD_PRICE_ROW.SHIP_METHOD_PRICE_ID AND SHIP_METHOD_PRICE.COMPANY_ID = #param_1# AND SHIP_METHOD_PRICE_ROW.SHIP_METHOD_ID = #param_2# AND SHIP_METHOD_PRICE_ROW.PACKAGE_TYPE_ID=3">
	</cfcase>

    <cfcase value="stk_get_exit_shelf_sql">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PRODUCT_PLACE_ID IN (#param_1#) AND STORE_ID <> #param_2# AND LOCATION_ID<>#param_3#">
	</cfcase>

    <cfcase value="stk_get_total_stock_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE = #param_4# AND SR.PROCESS_DATE < #param_5# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
	</cfcase>
    <cfcase value="stk_get_total_stock_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE = #param_4# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
        </cfcase>

    <cfcase value="stk_get_total_stock_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND SR.PROCESS_DATE < #param_5# GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
        </cfcase>

    <cfcase value="stk_get_total_stock_7">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
        </cfcase>

    <cfcase value="stk_get_total_stock_8">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND SR.PROCESS_DATE < #param_5# AND SR.STOCKS_ROW_ID NOT IN ( SELECT S.STOCKS_ROW_ID FROM STOCKS_ROW S WHERE S.PROCESS_TYPE = 116 AND S.UPD_ID IN (#param_6#) ) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
    </cfcase>

    <cfcase value="stk_get_total_stock_9">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND UPD_ID NOT IN (#param_6#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
        </cfcase>

    <cfcase value="stk_get_total_stock_10">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE = #param_4# AND SR.PROCESS_DATE < #param_5# AND UPD_ID NOT IN (#param_6#) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
        </cfcase>

    <cfcase value="stk_get_total_stock_11">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE = #param_4# AND UPD_ID NOT IN (#param_6#) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
        </cfcase>

    <cfcase value="stk_get_total_stock_12">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND SR.PROCESS_DATE < #param_5# AND UPD_ID NOT IN (#param_6#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
    </cfcase>

    <cfcase value="stk_get_total_stock_13">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND UPD_ID NOT IN (#param_6#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
    </cfcase>

    <cfcase value="stk_get_total_stock_14">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND SR.PROCESS_DATE < #param_5# AND UPD_ID NOT IN (#param_6#) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
    </cfcase>

    <cfcase value="stk_get_total_stock_15">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND UPD_ID NOT IN (#param_6#) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID">
    </cfcase>

    <cfcase value="stk_get_total_stock_16">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK,S.PRODUCT_NAME MAIN_PRODUCT_NAME, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID,S.STOCK_CODE,S.STOCK_ID FROM STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) GROUP BY S.PRODUCT_NAME,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID,S.STOCK_CODE,S.STOCK_ID">
    </cfcase>

    <cfcase value="stk_get_total_stock_17">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.PRODUCT_NAME MAIN_PRODUCT_NAME, SM.SPECT_MAIN_NAME AS PRODUCT_NAME,SM.SPECT_MAIN_ID, S.STOCK_CODE,S.STOCK_ID FROM STOCKS_ROW AS SR,#param_1#.SPECT_MAIN AS SM,#param_1#.STOCKS S WHERE S.STOCK_ID = SM.STOCK_ID AND S.IS_ZERO_STOCK = 0 AND SR.PROCESS_TYPE IS NOT NULL AND SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# GROUP BY S.PRODUCT_NAME,SM.SPECT_MAIN_NAME,SM.SPECT_MAIN_ID,S.STOCK_CODE,S.STOCK_ID">
    </cfcase>

    <cfcase value="stk_get_total_stock_18">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME,S.STOCK_CODE FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.STOCK_ID NOT IN (#param_3#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
    </cfcase>

    <cfcase value="stk_get_total_stock_19">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME,S.STOCK_CODE FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.STOCK_ID NOT IN (#param_3#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
    </cfcase>

    <cfcase value="stk_get_total_stock_20">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT S.PRODUCT_NAME,S.STOCK_CODE,S.STOCK_ID FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND P.IS_INVENTORY=1 AND S.STOCK_ID IN (#param_1#)  AND S.STOCK_ID NOT IN (#param_2#)">
    </cfcase>

    <cfcase value="stk_kontrol_inv_type">
		<cfset form.str_sql= "SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 118 AND IS_DEFAULT = 1">
    </cfcase>

	<cfcase value="stk_kontrol_inv_type2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT INVENTORY_CAT_ID,INVENTORY_CODE,AMORTIZATION_METHOD_ID,AMORTIZATION_TYPE_ID,AMORTIZATION_EXP_CENTER_ID,AMORTIZATION_EXP_ITEM_ID,AMORTIZATION_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #param_1# AND PERIOD_ID = #param_2#">
    </cfcase>

    <cfcase value="stk_GET_PRICE_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE, OTHER_MONEY FROM SHIP_METHOD_PRICE WHERE SHIP_METHOD_PRICE.COMPANY_ID = #attributes.ext_params#">
	</cfcase>

    <cfcase value="stk_get_ship">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHIP_ID,PURCHASE_SALES,SHIP_TYPE FROM SHIP WHERE SHIP_NUMBER='#param_1#' AND (DEPARTMENT_IN IN (#param_2#) OR DELIVER_STORE_ID IN (#param_2#))">
    </cfcase>

    <cfcase value="stk_get_ship_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHIP_ID,PURCHASE_SALES,SHIP_TYPE FROM SHIP WHERE SHIP_NUMBER='#param_1#' AND PURCHASE_SALES = #param_2#">
    </cfcase>

	<cfcase value="get_inventory_amort_number">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT TOP 1 IAM.RECORD_DATE FROM INVENTORY_AMORTIZATION_MAIN IAM, INVENTORY_AMORTIZATON IA WHERE IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID AND IA.INVENTORY_ID = #param_1# ORDER BY RECORD_DATE DESC">
    </cfcase>

    <!--- workcube_pda --->
    <cfcase value="wpda_stock_control_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset form.str_sql= "SELECT GSL.SALEABLE_STOCK,SB.STOCK_ID,GSL.PRODUCT_ID FROM #param_1#.GET_STOCK_LAST GSL, STOCKS_BARCODES SB WHERE GSL.STOCK_ID = SB.STOCK_ID AND SB.BARCODE = '#param_2#'">
    </cfcase>

    <cfcase value="wpda_stock_reserve">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset form.str_sql= "INSERT INTO ORDER_ROW_RESERVED(STOCK_ID,PRODUCT_ID,PRE_ORDER_ID,RESERVE_STOCK_OUT) VALUES(#param_1#,#param_2#,'#param_3#',#param_4#)">
    </cfcase>

    <cfcase value="wpda_stock_reserve_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset form.str_sql= "INSERT INTO ORDER_ROW_RESERVED(STOCK_ID,PRODUCT_ID,PRE_ORDER_ID,RESERVE_STOCK_IN) VALUES(#param_1#,#param_2#,'#param_3#',#param_4#)">
    </cfcase>

     <cfcase value="wpda_get_total_stock">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME">
    </cfcase>

	<cfcase value="wpda_get_stock_id">
		<cfset form.str_sql = "SELECT SB.STOCK_ID FROM STOCKS_BARCODES SB INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID INNER JOIN PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID WHERE S.PRODUCT_STATUS = 1 AND S.STOCK_STATUS = 1 AND SB.BARCODE = '#attributes.ext_params#'">
	</cfcase>

	<cfcase value="wpda_stock_control">
		<cfset form.str_sql="SELECT SALEABLE_STOCK FROM GET_STOCK_LAST WHERE STOCK_ID = #attributes.ext_params#">
	</cfcase>

    <cfcase value="wpda_control_paper_no">
		<cfset form.str_sql="SELECT SHIP_NUMBER FROM SHIP WHERE PURCHASE_SALES = 1 AND SHIP_NUMBER = '#attributes.ext_params#'">
	</cfcase>
    <!--- workcube_pda --->

    <!--- workdata --->
	<cfcase value="wrkd_GET_COMPANY">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE OZEL_KOD = '#attributes.ext_params#'">
	</cfcase>

	<cfcase value="wrkd_GET_COMPANY_2">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#attributes.ext_params#'">
	</cfcase>

	<cfcase value="wrkd_get_product">
		<cfset form.str_sql="SELECT TOP 1 STOCK_ID FROM STOCKS_BARCODES WHERE BARCODE = '#attributes.ext_params#'">
	</cfcase>

    <!--- myhome --->
	<cfcase value="myh_GET_FAV_N">
		<cfset form.str_sql="SELECT * FROM FAVORITES WHERE FAVORITE_ID <> #attributes.ext_params# AND EMP_ID = #SESSION.EP.USERID# ORDER BY FAVORITE_NAME">
	</cfcase>


    <!--- contract --->
	<cfcase value="cnt_get_price_cat">
		<cfset form.str_sql="SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE IS_SALES = 1 AND PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT">
	</cfcase>

	<cfcase value="cnt_get_price_cat_2">
		<cfset form.str_sql="SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE IS_PURCHASE = 1 AND PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT">
	</cfcase>

    <!--- objects devamı --->
    <cfcase value="obj_get_product_detail_21">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#') AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_3#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #param_4#)">
	</cfcase> 
	<cfcase value="obj_get_product_detail_22">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#')">
	</cfcase>
	<cfcase value="obj_gt_stoc_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = #param_1# AND PROCESS_DATE <= #param_2# AND SPECT_VAR_ID= #param_3#">
	</cfcase>
	<cfcase value="obj_gt_stoc_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = #param_1# AND PROCESS_DATE <= #param_2#">
	</cfcase>

	<cfcase value="trn_get_class_name">
		<cfset form.str_sql="SELECT CLASS_NAME FROM TRAINING_CLASS TC WHERE TC.CLASS_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="trn_get_sec">
		<cfset form.str_sql="SELECT SECTION_NAME,TRAINING_SEC_ID FROM TRAINING_SEC WHERE TRAINING_CAT_ID =  #attributes.ext_params#">
	</cfcase>
    
	<!--- training management --->

	<cfcase value="trnm_get_subj">
		<cfset form.str_sql="SELECT TRAIN_HEAD,TRAIN_ID FROM TRAINING WHERE TRAINING_SEC_ID = #attributes.ext_params#">
	</cfcase>

	<!--- stock --->
	<cfcase value="stk_get_stock">
		<cfset form.str_sql="SELECT PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE IS_ZERO_STOCK=0 AND IS_INVENTORY=1 AND STOCK_ID IN (#attributes.ext_params#)">
	</cfcase>
    <cfcase value="get_units">
		<cfset form.str_sql="SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = '#attributes.ext_params#' AND PRODUCT_UNIT_STATUS = 1">
	</cfcase>
	<cfcase value="get_units_by_product_unit_id">
		<cfset form.str_sql="SELECT TOP(1) ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = '#attributes.ext_params#' AND PRODUCT_UNIT_STATUS = 1">
	</cfcase>
	<cfcase value="get_unit_by_stock_id">
		<cfset form.str_sql="SELECT CASE WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM ELSE ADD_UNIT END AS ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID AND SLI.COLUMN_NAME = 'UNIT' AND SLI.TABLE_NAME = 'SETUP_UNIT' AND SLI.LANGUAGE = '#session.ep.language#' WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID=#attributes.ext_params#)">
	</cfcase>
	<cfcase value="stk_get_stock_2">
		<cfset form.str_sql="SELECT P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID,S.STOCK_CODE FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN (#attributes.ext_params#) AND S.IS_ZERO_STOCK=0">
	</cfcase>
	<cfcase value="stk_get_stock_3">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME MAIN_PRODUCT_NAME, P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID,S.STOCK_ID,S.STOCK_CODE FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN (#attributes.ext_params#) AND S.IS_ZERO_STOCK=0">
	</cfcase>
	<cfcase value="stk_get_ship_control">
		<cfset form.str_sql="SELECT AMOUNT FROM SHIP_ROW WHERE WRK_ROW_ID = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="stk_get_row_spec">
		<cfset form.str_sql="SELECT SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,SPECT_MAIN.SPECT_TYPE,SPECT_MAIN_ROW.STOCK_ID,SPECT_MAIN_ROW.PRODUCT_ID,SPECT_MAIN_ROW.AMOUNT,SPECT_MAIN_ROW.IS_SEVK,STOCKS.STOCK_CODE,STOCKS.PRODUCT_NAME FROM SPECT_MAIN,SPECT_MAIN_ROW,STOCKS WHERE SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND SPECT_MAIN_ROW.STOCK_ID=STOCKS.STOCK_ID AND SPECT_MAIN.SPECT_MAIN_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_get_prodct">
		<cfset form.str_sql="SELECT STOCK_ID FROM STOCKS_BARCODES WHERE BARCODE = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="stk_get_process">
		<cfset form.str_sql="SELECT IS_ZERO_STOCK_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_get_planning_info">
		<cfset form.str_sql="SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_DATE = #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_dept_ctrl">
		<cfset form.str_sql="SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_CODE = '#attributes.ext_params#'">
	</cfcase>
    <cfcase value="stk_basket_zero_stock_status">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE TITLE='zero_stock_status' AND B_TYPE=1 AND BASKET_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_get_prc_30">
		<cfset form.str_sql="SELECT PRICE, OTHER_MONEY FROM SHIP_METHOD_PRICE WHERE SHIP_METHOD_PRICE.COMPANY_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_get_period">
		<cfset form.str_sql="SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="stk_get_prc_30_2">
		<cfset form.str_sql="SELECT PRICE, OTHER_MONEY FROM SHIP_METHOD_PRICE WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_get_max_limit">
		<cfset form.str_sql="SELECT MAX_LIMIT,CALCULATE_TYPE FROM SHIP_METHOD_PRICE WHERE COMPANY_ID =  #attributes.ext_params#">
	</cfcase>
	<cfcase value="stk_belge_no_control">
		<cfset form.str_sql="SELECT SHIP_NUMBER,PURCHASE_SALES FROM SHIP WHERE PURCHASE_SALES=1 AND SHIP_NUMBER= '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="stk_new_sql_ship">
		<cfset form.str_sql="SELECT IS_DELIVERED FROM SHIP WHERE SHIP_ID = #attributes.ext_params#">
	</cfcase>
    <!--- training --->
	<cfcase value="prod_control_barcode">
		<cfset form.str_sql="SELECT STOCK_ID FROM GET_STOCK_BARCODES_ALL WHERE BARCODE = '#attributes.ext_params#'">
	</cfcase>

	<!--- settings --->
	<cfcase value="set_is_production_branch">
		<cfset form.str_sql="SELECT BRANCH_NAME,IS_PRODUCTION FROM BRANCH WHERE BRANCH_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="set_get_inventory_">
		<cfset form.str_sql="SELECT HIERARCHY FROM SETUP_INVENTORY_CAT WHERE HIERARCHY = '#attributes.ext_params# '">
	</cfcase>
	<cfcase value="set_get_branches_rows_">
		<cfset form.str_sql="SELECT * FROM SETUP_APP_BRANCHES_ROWS WHERE BRANCHES_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="set_get_tevf">
		<cfset form.str_sql="SELECT STATEMENT_RATE FROM SETUP_TEVKIFAT WHERE STATEMENT_RATE IN  (#attributes.ext_params#)">
	</cfcase>
	<cfcase value="set_tbl_q">
		<cfset form.str_sql="SELECT syscolumns.NAME FROM syscolumns,sysobjects WHERE syscolumns.id = sysobjects.id AND sysobjects.XTYPE='U' AND sysobjects.NAME='#attributes.ext_params#' ORDER BY syscolumns.NAME">
	</cfcase>
	<cfcase value="set_tbl_q_2">
		<cfset form.str_sql="SELECT NAME,id FROM sysobjects WHERE XTYPE='U' AND NAME<>'dtproperties' AND SUBSTRING(NAME,1,1) <> '_' ORDER BY NAME">
	</cfcase>
	<cfcase value="control_gift_card_no">
		<cfset form.str_sql="SELECT ORDER_CREDIT_ID,MONEY_CREDIT FROM ORDER_MONEY_CREDITS WHERE GIFT_CARD_NO = '#attributes.ext_params#' AND USE_CREDIT = 0 AND VALID_DATE >= #now()# AND IS_TYPE=1">
	</cfcase>
	<cfcase value="is_added_gift_card_no">
		<cfset form.str_sql="SELECT PRODUCT_ID FROM ORDER_PRE_ROWS WHERE IS_DISCOUNT = 2 AND RECORD_CONS = #attributes.ext_params#">
	</cfcase>
	<cfcase value="control_disc_coup_no">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT ORDER_CREDIT_ID,MONEY_CREDIT FROM ORDER_MONEY_CREDITS WHERE GIFT_CARD_NO = '#param_1#' AND USE_CREDIT = 0 AND IS_TYPE=2 AND
		((IS_SPECIAL = 1 AND CONSUMER_ID = #session.ww.userid#) OR (IS_SPECIAL = 1 AND TARGET_MARKET_ID IN (#param_2#)) OR IS_SPECIAL = 0)">
	</cfcase>
	<cfcase value="get_ship_serial_quantity_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT COUNT(GUARANTY_ID) AS ROW_COUNT FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #param_2# AND PROCESS_CAT IN (70,71,72,83) AND PERIOD_ID = #param_1#">
	</cfcase>
	<cfcase value="get_ship_row_quantity_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfquery name="get_period_info" datasource="#dsn#">
			SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #param_1#
		</cfquery>
		<cfset form.str_sql="SELECT SUM(SHIP_ROW.AMOUNT) AS ROW_COUNT FROM #dsn#_#get_period_info.PERIOD_YEAR#_#get_period_info.OUR_COMPANY_ID#.SHIP_ROW AS SHIP_ROW,STOCKS WHERE SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND SHIP_ROW.SHIP_ID = #param_2# AND STOCKS.IS_SERIAL_NO = 1">
	</cfcase>

	<!--- birleştirilmiş fiş kontrolü tüm modüllerde kullanılıyor --->
     <cfcase value="acc_control_account_process">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT CARD_ID FROM ACCOUNT_CARD_SAVE WHERE ACTION_ID = #param_1# AND ACTION_TYPE = #param_2# AND ISNULL(IS_TEMPORARY_SOLVED,0)=0">
    </cfcase>

	<!--- Odeme Islemleri --->
	<cfcase value="get_blacklist">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT IS_BLACKLIST, COMPANY.NICKNAME FROM COMPANY_CREDIT LEFT JOIN COMPANY ON COMPANY_CREDIT.COMPANY_ID =COMPANY.COMPANY_ID WHERE COMPANY_CREDIT.COMPANY_ID = #param_1# AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id#">
	</cfcase>

	<!--- credit --->
	<cfcase value="get_stockbond_quantity">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT (SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0))) AS NET_QUANTITY FROM STOCKBONDS_INOUT WHERE STOCKBOND_ID = #param_1# AND STOCKBOND_ROW_ID <> #param_2#">
	</cfcase>

	<cfcase value="get_pro_works_currency">
		<cfset form.str_sql="SELECT PTR.STAGE,PTR.STAGE_CODE,PTR.PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS PTR,PROCESS_TYPE_OUR_COMPANY PTO,PROCESS_TYPE PT WHERE ','+(SELECT PROCESS_ID FROM PRO_WORK_CAT WHERE WORK_CAT_ID=#attributes.ext_params#)+',' LIKE '%,'+CAST(PTR.PROCESS_ROW_ID AS NVARCHAR)+',%' AND PT.IS_ACTIVE = 1 AND PT.PROCESS_ID = PTR.PROCESS_ID AND PT.PROCESS_ID = PTO.PROCESS_ID AND PTO.OUR_COMPANY_ID = #session.ep.company_id# AND PT.FACTION LIKE '%project.works%' ORDER BY PTR.LINE_NUMBER">
	</cfcase>

	<cfcase value="upd_messages">
    	<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="UPDATE WRK_MESSAGE SET IS_CLOSED = 1 WHERE WRK_MESSAGE_ID IN (#param_1#)">
	</cfcase>

	<cfcase value="get_paper_record">
		<cfset form.str_sql="SELECT PAPER_NO FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE WHERE PAPER_NO = '#attributes.ext_params#'">
	</cfcase>

    <!--- Grup ici Yonetim --->
	<cfcase value="get_group_action1">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT PTR.STAGE NAME,PTR.PROCESS_ROW_ID ID,PTO.OUR_COMPANY_ID FROM PROCESS_TYPE_ROWS PTR,PROCESS_TYPE_OUR_COMPANY PTO,PROCESS_TYPE PT WHERE PT.IS_ACTIVE = 1 AND PT.PROCESS_ID = PTR.PROCESS_ID AND PT.PROCESS_ID = PTO.PROCESS_ID AND PT.FACTION LIKE '%#param_1#%' AND PTO.OUR_COMPANY_ID = #param_2# ORDER BY PTR.LINE_NUMBER">
	</cfcase>

	<cfcase value="get_group_action2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT	PROCESS_CAT_ID ID,PROCESS_CAT NAME,#param_1# OUR_COMPANY_ID,PROCESS_TYPE FROM #dsn#_#param_1#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(#param_2#) ORDER BY PROCESS_CAT">
	</cfcase>

    <cfcase value="obj_get_note_emp">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT	ACTION_ID FROM NOTES WHERE ACTION_SECTION = 'EMPLOYEE_ID' AND IS_WARNING = 1 AND ACTION_ID = #param_1#">
	</cfcase>

    <cfcase value="get_action_page">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT	ACTION_PAGE FROM WRK_SESSION WHERE USERID = #param_1#">
	</cfcase>

	<!--- efatura kontroller --->
	<cfcase value="obj_get_company_efatura">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = #param_1#">
	</cfcase>
	 <cfcase value="obj_get_consumer_efatura">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = #param_1#">
	</cfcase>
	<cfcase value="obj_get_papers_no">
		<cfset param_1 = attributes.ext_params>
		<cfset form.str_sql="SELECT INVOICE_NUMBER,INVOICE_NO FROM PAPERS_NO WHERE EMPLOYEE_ID = #param_1#">
	</cfcase>
	<cfcase value="sls_get_employee">
		<cfset form.str_sql="SELECT EMPLOYEE_NO, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="hr_control_expense_puantaj">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT EXPENSE_PUANTAJ_ID FROM EMPLOYEES_EXPENSE_PUANTAJ WHERE IN_OUT_ID = #param_1# AND EXPENSE_PUANTAJ_ID<>#param_3# AND EXPENSE_DATE >= #param_2#">
	</cfcase>
	<cfcase value="hr_control_expense_puantaj_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT EXPENSE_PUANTAJ_ID FROM EMPLOYEES_EXPENSE_PUANTAJ WHERE EMPLOYEE_ID = #param_3# AND MONTH(EXPENSE_DATE) > #param_1# AND YEAR(EXPENSE_DATE) >= #param_2#">
	</cfcase>
	<cfcase value="hr_control_expense_puantaj_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT EXPENSE_PUANTAJ_ID FROM EMPLOYEES_EXPENSE_PUANTAJ WHERE BRANCH_ID = #param_3# AND MONTH(EXPENSE_DATE) > #param_1# AND YEAR(EXPENSE_DATE) >= #param_2#">
	</cfcase>

    <!--- fatura tipine bagli irsaliye islem kategori id'si belirlenir --->
    <cfcase value="get_ship_types">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql="SELECT PROCESS_CAT, PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = #param_1#">
	</cfcase>
    <cfcase value ="control_aksiyon">
        <cfset param_1 = attributes.ext_params>
       	<cfset form.str_sql="SELECT  CP.CATALOG_HEAD,CP.CATALOG_ID,CONVERT(nvarchar(50),CP.STARTDATE,103) AS STARTDATE,CONVERT(nvarchar(50),CP.FINISHDATE,103) AS FINISHDATE FROM CATALOG_PROMOTION CP,CATALOG_PROMOTION_PRODUCTS CPP WHERE CP.CATALOG_ID = CPP.CATALOG_ID AND  CPP.PRODUCT_ID = #param_1#">
    </cfcase>
	<!--- fatura --->
	<cfcase value="sls_get_fatura">
		<cfset form.str_sql="SELECT INVOICE_ID FROM INVOICE WHERE INVOICE_NUMBER = '#attributes.ext_params#'">
	</cfcase>
    <!--- satis faturalari --->
    <cfcase value="obj_control_basket_prod_acc_10"><!--- hurda --->
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND SCRAP_CODE_SALE IS NOT NULL AND len(SCRAP_CODE_SALE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">
    </cfcase>
    <cfcase value="obj_control_basket_prod_acc_11"><!--- hammaddde --->
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND MATERIAL_CODE_SALE IS NOT NULL AND len(MATERIAL_CODE_SALE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">
    </cfcase>
    <cfcase value="obj_control_basket_prod_acc_12"><!--- mamul --->
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND PRODUCTION_COST_SALE IS NOT NULL AND len(PRODUCTION_COST_SALE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">
    </cfcase>
    <!--- alis faturalari --->
    <cfcase value="obj_control_basket_prod_acc_13"><!--- hammaddde --->
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND MATERIAL_CODE IS NOT NULL AND len(MATERIAL_CODE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">
    </cfcase>
    <cfcase value="obj_control_basket_prod_acc_14"><!--- mamul --->
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND PRODUCTION_COST IS NOT NULL AND len(PRODUCTION_COST)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">
    </cfcase>
    <!--- depo kontrol --->
    <cfcase value="obj_control_department_location">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT LOCATION_TYPE, IS_SCRAP FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = #param_1# AND LOCATION_ID = #param_2#">
    </cfcase>
    <!--- Varyasyon Kontrol --->
    <cfcase value="variation control">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID=#param_1# ORDER BY PROPERTY_DETAIL">
    </cfcase>
    <cfcase value="obj_get_project_related_expense">
    	<cfset form.str_sql="SELECT EX.EXPENSE_ID, EX.EXPENSE FROM #dsn_alias#.PRO_PROJECTS PP LEFT JOIN EXPENSE_CENTER EX ON EX.EXPENSE_CODE = PP.EXPENSE_CODE WHERE PP.PROJECT_ID = #attributes.ext_params#">
    </cfcase>
    <!--- account --->
   	<cfcase value="acc_get_paper_no">
    	<cfif listlen(attributes.ext_params,"*") gt 2>
			<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
            <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
            <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
            <cfset form.str_sql= "SELECT PAPER_NO FROM ACCOUNT_CARD WHERE CARD_ID <> #param_1# AND PAPER_NO = '#param_2#' AND CARD_TYPE = '#param_3#'">
        <cfelse>
        	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
            <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
            <cfset form.str_sql= "SELECT PAPER_NO FROM ACCOUNT_CARD WHERE PAPER_NO = '#param_1#' AND CARD_TYPE = '#param_2#'">
        </cfif>
	</cfcase>
    <!--- cash --->
   	<cfcase value="csh_get_paper_no_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> <!--- ödeme veya tahsilat işlemi ile oluşturulacak bir belge numarası, daha önce tahsil ya da tediye fişi oluşturularak kaydedilmiş mi? --->
		<cfset form.str_sql= "SELECT CA.PAPER_NO FROM CASH_ACTIONS CA WHERE (CA.ACTION_ID <> #param_1# AND CA.PAPER_NO = '#param_2#' AND CA.ACTION_TYPE_ID = '#param_3#' )">
    </cfcase>
    <cfcase value="get_paper_no_from_acc">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset form.str_sql="SELECT PAPER_NO FROM ACCOUNT_CARD WHERE (ACTION_ID <> #param_1# OR ACTION_ID IS NULL) AND PAPER_NO = '#param_2#' AND CARD_TYPE = '#param_3#'">
    </cfcase>
    	<!--- production plan --->
	<cfcase value="prdp_user_control">
		<cfset form.str_sql="SELECT USERID FROM WRK_SESSION WHERE USERID = #session.ep.userid# AND USERNAME = '#session.ep.username#'">
	</cfcase>
	<cfcase value="prdp_get_ws">
		<cfset form.str_sql="SELECT W.STATION_ID,W.STATION_NAME FROM WORKSTATIONS_PRODUCTS WSP,WORKSTATIONS W WHERE W.STATION_ID=WSP.WS_ID AND WSP.STOCK_ID=#attributes.ext_params#">
	</cfcase>	
    <cfcase value="prdp_get_ws_all">
		<cfset form.str_sql="SELECT W.STATION_ID,W.STATION_NAME FROM WORKSTATIONS W WHERE W.ACTIVE = 1 AND W.DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM #attributes.ext_params#.DEPARTMENT,#attributes.ext_params#.EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#) ORDER BY W.STATION_NAME">
	</cfcase>
	<cfcase value="prdp_get_ws_all_by_department">
		<cfset form.str_sql="SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE ACTIVE = 1 AND DEPARTMENT = #attributes.ext_params# AND UP_STATION IS NULL ORDER BY STATION_NAME">
	</cfcase>
	<cfcase value="prdp_get_wss_all_by_department">
		<cfset form.str_sql="SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE ACTIVE = 1 AND DEPARTMENT = #listgetat(attributes.ext_params,1,'*')# AND UP_STATION = #listgetat(attributes.ext_params,2,'*')# ORDER BY STATION_NAME">
	</cfcase>
	<cfcase value="prdp_get_stock">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME,S.STOCK_CODE FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND P.IS_INVENTORY=1 AND S.STOCK_ID IN (#attributes.ext_params#)">        
	</cfcase>				 
	<cfcase value="prdp_getSpecName">
		<cfset form.str_sql="SELECT SPECT_MAIN_NAME  FROM SPECT_MAIN WHERE SPECT_MAIN_ID =#attributes.ext_params#">
	</cfcase>				 
	<cfcase value="prdp_get_note">
		<cfset form.str_sql="SELECT NOTE_ID FROM NOTES WHERE ACTION_SECTION = 'PRODUCT_TREE' AND IS_WARNING= 1 AND ACTION_ID = #attributes.ext_params#">
	</cfcase>				 
	<cfcase value="prdp_op_code">
		<cfset form.str_sql="SELECT OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_CODE = '#attributes.ext_params#'">
	</cfcase>		
	<cfcase value="prdp_get_route_name">
		<cfset form.str_sql="SELECT ROUTE FROM ROUTE WHERE ROUTE LIKE  '%#attributes.ext_params#%'">
	</cfcase>		
	<cfcase value="prdp_get_station">
		<cfset form.str_sql="SELECT * FROM WORKSTATIONS WHERE STATION_ID=#attributes.ext_params#">
	</cfcase>		
	<cfcase value="prdp_get_result">
		<cfset form.str_sql="SELECT RESULT_NO from PRODUCTION_ORDER_RESULTS WHERE RESULT_NO = '#attributes.ext_params#'">
	</cfcase>	
	<cfcase value="prdp_get_unit2_prod">
		<cfset form.str_sql="SELECT ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.ext_params# AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN = 0">
	</cfcase>	
	<cfcase value="prdp_get_unit2_all">
		<cfset form.str_sql="SELECT CASE WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM ELSE ADD_UNIT END AS CRR_UNIT, ADD_UNIT FROM PRODUCT_UNIT LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID AND SLI.COLUMN_NAME = 'UNIT' AND SLI.TABLE_NAME = 'SETUP_UNIT' AND SLI.LANGUAGE = '#session.ep.language#' WHERE PRODUCT_ID = #attributes.ext_params# AND PRODUCT_UNIT_STATUS = 1">
	</cfcase>	
	<cfcase value="prdp_get_demend_control">
		<cfset form.str_sql="SELECT TOP 1 DEMAND_NO FROM PRODUCTION_ORDERS WHERE DEMAND_NO ='#attributes.ext_params#'">
	</cfcase>	
	<cfcase value="prdp_get_dep">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID =#attributes.ext_params#">
	</cfcase>		
	<cfcase value="prdp_get_main_spec_id">
		<cfset form.str_sql="SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = #attributes.ext_params# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC">
	</cfcase>			     
	<cfcase value="prdp_get_product_station">
		<cfset form.str_sql="SELECT TOP 1 W.STATION_ID,W.STATION_NAME FROM WORKSTATIONS_PRODUCTS WP,WORKSTATIONS W  WHERE W.STATION_ID =WP.WS_ID AND STOCK_ID = #attributes.ext_params# ">
	</cfcase>				
	<cfcase value="prdp_get_no">
		<cfset form.str_sql="SELECT QUESTION_ID FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_NO= #attributes.ext_params# ">
	</cfcase>				 
	<cfcase value="prdp_get_order_control">
		<cfset form.str_sql="SELECT DISTINCT ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID),0),STOCK_ID FROM ORDER_ROW ORR WHERE ORDER_ROW_ID IN(#attributes.ext_params#)">
	</cfcase>				 
	<cfcase value="prdp_get_spect">
		<cfset form.str_sql="SELECT SPECTS.SPECT_MAIN_ID, SPECTS.SPECT_VAR_ID FROM PRODUCT,SPECTS WHERE SPECTS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND SPECTS.PRODUCT_ID IS NOT NULL AND SPECTS.STOCK_ID IS NOT NULL AND IS_ZERO_STOCK=0 AND SPECT_VAR_ID IN (#attributes.ext_params#)">
	</cfcase>	
	<cfcase value="prdp_get_station_deploc">
		<cfset form.str_sql="SELECT STATION_ID,ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID FROM WORKSTATIONS WHERE ACTIVE = 1 AND STATION_ID = #attributes.ext_params#">
	</cfcase>			
	<cfcase value="prdp_get_stock_2">
		<cfset form.str_sql="SELECT P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID,S.STOCK_CODE FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN (#attributes.ext_params#) AND S.IS_ZERO_STOCK=0">
	</cfcase>			
	<cfcase value="prdp_get_process">
		<cfset form.str_sql="SELECT IS_ZERO_STOCK_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID =#attributes.ext_params#">
	</cfcase>			
	
    <cfcase value="prdp_operation_code_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_CODE = '#param_1#' AND OPERATION_TYPE_ID <> #param_2#">   
	</cfcase>   
    
    <cfcase value="prdp_get_main_spec_id_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = #param_1# AND SM.SPECT_STATUS = 1 AND SM.STOCK_ID = #param_2# ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC">   
	</cfcase>        
    
    <cfcase value="prdp_get_main_spec_id_3">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = #attributes.ext_params# AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC">   
	</cfcase>          
    
    <cfcase value="prdp_GET_PRODUCT_COST">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 PRODUCT_COST_ID,PURCHASE_NET,PURCHASE_NET_MONEY,PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_2,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST,PURCHASE_EXTRA_COST_SYSTEM,PRODUCT_COST,MONEY FROM PRODUCT_COST WHERE PRODUCT_ID = #param_1# AND START_DATE <= #param_2# ORDER BY START_DATE DESC,RECORD_DATE DESC">      
	</cfcase> 
          
    <cfcase value="prdp_get_station_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT MIN_PRODUCT_AMOUNT,PRODUCTION_TYPE FROM WORKSTATIONS_PRODUCTS WHERE STOCK_ID = #param_1# AND WS_ID = #param_2#">   			
	</cfcase>        
    
    <cfcase value="prdp_paper_number">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_NO='#param_1#' AND  P_ORDER_ID <> #param_2#">
	</cfcase>           
    
    <cfcase value="prdp_doc_no_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT RESULT_NO FROM PRODUCTION_ORDER_RESULTS WHERE RESULT_NO = '#param_1#' AND PR_ORDER_ID <> #param_2#">
	</cfcase>      
    
    <cfcase value="prdp_get_total_stock">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND SR.PROCESS_DATE <= #param_4# AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND UPD_ID NOT IN (#param_3#) GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
	</cfcase>        
   <cfcase value="prdp_get_total_stock_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME,S.STOCK_CODE FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND SR.PROCESS_DATE <= #param_4# AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
	</cfcase>     
   <cfcase value="prdp_get_total_stock_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PRODUCT_NAME,S.STOCK_CODE FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID IN (#param_1#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_1#) AND ORDER_ID NOT IN (#param_4#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_1#) AND SR.PROCESS_DATE <= #param_5# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME,S.STOCK_CODE ORDER BY S.STOCK_ID">
	</cfcase>       
   <cfcase value="prdp_get_total_stock_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PRODUCT_NAME,S.STOCK_CODE FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE	SR.STOCK_ID IN (#param_1#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID  IN (#param_1#) AND SR.PROCESS_DATE <= #param_5# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME,S.STOCK_CODE ORDER BY S.STOCK_ID">
	</cfcase>      
   <cfcase value="prdp_get_total_stock_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME,S.STOCK_CODE FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND UPD_ID NOT IN (#param_5#) AND SR.PROCESS_DATE <= #param_6# GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
	</cfcase>       
   <cfcase value="prdp_get_total_stock_6">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME,S.STOCK_CODE FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_3# AND SR.STORE =#param_4# AND SR.PROCESS_DATE <= #param_6# GROUP BY S.STOCK_ID,S.PRODUCT_NAME,S.STOCK_CODE">
	</cfcase>           
   <cfcase value="prdp_get_total_stock_7">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_CODE FROM STOCKS_ROW AS SR,#param_1#.STOCKS, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.STOCK_ID = STOCKS.STOCK_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND UPD_ID NOT IN (#param_3#) AND SR.PROCESS_DATE <= #param_4# GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_CODE">
	</cfcase>        
   <cfcase value="prdp_get_total_stock_8">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_CODE FROM STOCKS_ROW AS SR,#param_1#.STOCKS, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID SR.STOCK_ID = STOCKS.STOCK_ID AND AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.PROCESS_DATE <= #param_4# GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_CODE">
	</cfcase>           
   <cfcase value="prdp_get_total_stock_9">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID,S.STOCK_CODE FROM (SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE SR.SPECT_VAR_ID IN (#param_1#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) AND ORDER_ID NOT IN (#param_4#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID SPECT_MAIN_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_1#) AND SR.PROCESS_DATE <= #param_5# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID,S.STOCK_CODE">
	</cfcase>      
   <cfcase value="prdp_get_total_stock_10">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID,S.STOCK_CODE FROM (SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID AS SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE SR.SPECT_VAR_ID IN (#param_1#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_1#) AND SR.PROCESS_DATE <= #param_5# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID,S.STOCK_CODE">
	</cfcase>         
   <cfcase value="prdp_get_total_stock_11">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, SM.SPECT_MAIN_NAME AS PRODUCT_NAME,SM.SPECT_MAIN_ID,S.STOCK_CODE FROM STOCKS_ROW AS SR,#param_1#.SPECT_MAIN AS SM,#param_1#.STOCKS S WHERE S.STOCK_ID = SM.STOCK_ID AND S.IS_ZERO_STOCK = 0 AND SR.PROCESS_TYPE IS NOT NULL AND SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SM.SPECT_MAIN_ID IN (#param_2#) AND UPD_ID NOT IN (#param_3#)  AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND SR.PROCESS_DATE <= #param_6# GROUP BY SM.SPECT_MAIN_NAME,SM.SPECT_MAIN_ID,S.STOCK_CODE">
	</cfcase>
	<cfcase value="get_employee_relatives">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "select NAME + ' ' + SURNAME FULLNAME, RELATIVE_ID from EMPLOYEES_RELATIVES WHERE EMPLOYEE_ID = #param_1# AND RELATIVE_LEVEL = #param_2# ORDER BY NAME">
	</cfcase>
	<cfcase value="get_employees_relatives">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "select NAME + ' ' + SURNAME FULLNAME, RELATIVE_ID,RELATIVE_LEVEL from EMPLOYEES_RELATIVES WHERE EMPLOYEE_ID = #param_1# ORDER BY NAME">
	</cfcase>
	<cfcase value="get_data_import_dsn">
		<cfset form.str_sql= "SELECT DATA_SOURCE_ID, DATA_SOURCE_NAME FROM WRK_DATA_SOURCE WHERE TYPE = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_employees_relatives_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT IS_COMMITMENT_NOT_ASSURANCE, IS_ASSURANCE_POLICY FROM EMPLOYEES_RELATIVES WHERE EMPLOYEE_ID = #param_1# AND RELATIVE_ID = #param_2#">
	</cfcase>
	<cfcase value="get_health_assurance_type_treatments">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT TREATMENT, TREATMENT_ID FROM  SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS WHERE ASSURANCE_ID = #param_1# ORDER BY TREATMENT" />
	</cfcase>
	<cfcase value="invoice_process_cat">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT IS_EXPORT_REGISTERED FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #param_1#">
	</cfcase>
	<cfcase value="get_department_employee">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT DISTINCT D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP,BRANCH B  WHERE D.BRANCH_ID = B.BRANCH_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND EP.POSITION_CODE=#param_1#">
	</cfcase>
	<cfcase value="get_position_cat">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT POSITION_CAT_ID,POSITION_ID,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #param_1# AND POSITION_CAT_ID IN (#param_2#)">
	</cfcase>
	<cfcase value="get_financial_table">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT SAVE_ID from SAVE_ACCOUNT_TABLES WHERE PERIOD_ID = #session.ep.period_id# AND TABLE_NAME = '#param_1#'">
	</cfcase>
	<cfcase value="travel_demand_unit">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT MANAGER2_VALID FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = #param_1# AND  MANAGER2_VALID = 1">
	</cfcase>
	<cfcase value="travel_demand_ik">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT MANAGER1_VALID FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = #param_1# AND  MANAGER1_VALID = 1">
	</cfcase>
	<cfcase value="get_product_cat_name">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql="SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#param_1#'">
	</cfcase>
	<cfcase value="get_amortization_info">
		<cfset form.str_sql="SELECT SIC.INVENTORY_CAT, EC.EXPENSE, EI.EXPENSE_ITEM_NAME, PP.INVENTORY_CAT_ID, PP.AMORTIZATION_METHOD_ID, PP.AMORTIZATION_TYPE_ID, PP.AMORTIZATION_EXP_CENTER_ID, PP.AMORTIZATION_EXP_ITEM_ID, PP.INVENTORY_CODE, PT.TAX FROM PRODUCT_PERIOD AS PP LEFT JOIN SETUP_INVENTORY_CAT AS SIC ON SIC.INVENTORY_CAT_ID = PP.INVENTORY_CAT_ID LEFT JOIN #dsn2_alias#.EXPENSE_CENTER AS EC ON EC.EXPENSE_ID = PP.AMORTIZATION_EXP_CENTER_ID LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS AS EI ON EI.EXPENSE_ITEM_ID = PP.AMORTIZATION_EXP_ITEM_ID LEFT JOIN PRODUCT_TAX AS PT ON PT.PRODUCT_ID = PP.PRODUCT_ID WHERE PERIOD_ID = #session.ep.period_id# AND OUR_COMPANY_ID = #session.ep.company_id# AND PP.PRODUCT_ID = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="get_virman_paper">
		<cfset form.str_sql="SELECT VIRMAN_NO FROM GENEL_VIRMAN WHERE VIRMAN_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfdefaultcase>
		<cfif FileExists(ExpandPath("V16/add_options/query/get_js_query.cfm"))>
			<cfinclude template="../../add_options/query/get_js_query.cfm">
		<cfelse>
			<cfset form.str_sql = "SELECT * FROM WRK_SESSION">
		</cfif>
	</cfdefaultcase>
</cfswitch>