<cfsetting showdebugoutput="no">
<cf_date tarih = 'attributes.search_date1'>
<cf_date tarih = 'attributes.search_date2'>
<cfquery name="add_temp_report_expense" datasource="#dsn#"><!--- burada normalde dsn4 yazıyordu ancak abuk sabuk bir hata vermeye başladı,dsn4'ün içinde EXPENSE_MONTH tablosunu bulamıyordu var oldğu halde,bu şekilde yedi o sebebble böyle yazdım aşağıda da #dsn4# diye yazdım...--->
	INSERT INTO #dsn_report#.EXPENSE_MONTH
	(
            PERIOD_YEAR,
            PERIOD_MONTH,
            OUR_COMPANY_ID,
            EXPENSE,
            EXPENSE_ID,
            EXPENSE_ITEM_NAME,
            EXPENSE_ITEM_ID,
            MEMBER_TYPE,
            MEMBER_NAME,
            EMPLOYEE_ID,
            PARTNER_ID,
            CONSUMER_ID,
            ACTIVITY_TYPE,
            ACTIVITY_NAME,
            EXPENSE_CAT_ID,
            EXPENSE_CAT_NAME,
            ASSETP,
            ASSETP_ID,
            PRODUCT_ID,
            PRODUCT_NAME,
            OTHER_MONEY_GROSS_TOTAL,
            MONEY_CURRENCY_ID,
            AMOUNT,
            AMOUNT_KDV,
            AMOUNT_OTV,
            TOTAL_AMOUNT,
            MONEY
	)
     VALUES
    (
    	#attributes.period_year#,
        #attributes.period_month#,
    	#attributes.period_our_company_id#,
		<cfif len(EXPENSE)>'#expense#'<cfelse>NULL</cfif>,
        <cfif len(EXPENSE)>#EXPENSE_ID#<cfelse>NULL</cfif>,
        <cfif len(expense_item_name)>'#expense_item_name#'<cfelse>NULL</cfif>,
        <cfif len(expense_item_name)>#EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,
        <cfif len(MEMBER_TYPE)>'#MEMBER_TYPE#'<cfelse>NULL</cfif>,
		<cfif len(MEMBER_TYPE) and MEMBER_TYPE eq 'partner'>
        	'#get_par_info(company_partner_id,0,-1,0)# - #get_par_info(company_partner_id,0,1,0)#'
		<cfelseif MEMBER_TYPE eq 'consumer'>
        	'#get_cons_info(company_partner_id,0,0)# - #get_cons_info(company_id,2,0)#'
		<cfelseif MEMBER_TYPE eq 'employee'>
        	'#get_emp_info(company_partner_id,0,0)#'
		<cfelse>
        	'#get_emp_info(company_partner_id,0,0)#'
		</cfif>,
        <cfif len(MEMBER_TYPE) and MEMBER_TYPE eq 'employee'>#company_partner_id#<cfelse>NULL</cfif>,
        <cfif len(MEMBER_TYPE) and MEMBER_TYPE eq 'partner'>#company_partner_id#<cfelse>NULL</cfif>,
        <cfif len(MEMBER_TYPE) and MEMBER_TYPE eq 'consumer'>#company_partner_id#<cfelse>NULL</cfif>,
        <cfif len(ACTIVITY_TYPE)>#ACTIVITY_TYPE#<cfelse>NULL</cfif>,
        <cfif len(ACTIVITY_TYPE)>'#GET_ACTIVITY_TYPES_1.ACTIVITY_NAME[listfind(activity_type_ids,ACTIVITY_TYPE,',')]#'<cfelse>NULL</cfif>,
        <cfif len(expense_category_id)>#expense_category_id#<cfelse>NULL</cfif>,
        <cfif len(expense_category_id)>'#get_expense_cat_1.expense_cat_name[listfind(expense_cat_ids,expense_category_id,',')]#'<cfelse>NULL</cfif>,
        <cfif len(pyschical_asset_id)>'#get_asset.assetp[listfind(asset_id_list,pyschical_asset_id,',')]#'<cfelse>NULL</cfif>,
        <cfif len(pyschical_asset_id)>#pyschical_asset_id#<cfelse>NULL</cfif>,
        <cfif len(product_id)>#product_id#<cfelse>NULL</cfif>,
        <cfif len(product_id) and len(stock_id_2) and len(stock_id_list)>'#get_stock.product_name[listfind(stock_id_list,stock_id_2,',')]#'<cfelse>NULL</cfif>,
		<cfif len(other_money_gross_total)>#other_money_gross_total#<cfelse>NULL</cfif>,
		<cfif len(money_currency_id)>'#money_currency_id#'<cfelse>NULL</cfif>,
        <cfif len(amount)>#amount#<cfelse>NULL</cfif>,
		<cfif len(amount_kdv)>#amount_kdv#<cfelse>NULL</cfif>,
		<cfif len(amount_otv)>#amount_otv#<cfelse>NULL</cfif>,
        <cfif len(total_amount)>#total_amount#<cfelse>NULL</cfif>,
		'#session.ep.money#'
	)		
</cfquery>
