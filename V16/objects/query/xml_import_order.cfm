<cfif not isdefined('attributes.xml_data_input')>
	Gönderdiğiniz input hatalı.
	<cfabort>
<cfelse>
	<cfset attributes.xml_data_input = urldecode(attributes.xml_data_input)> 	
</cfif>
<cfinclude template="../functions/get_basket_money_js.cfm">
<cfscript>	
	wrk_xml_read(xml_data:'#attributes.xml_data_input#');
	//wrk_xml_read(xml_file:'#upload_folder#pos#dir_seperator##IMPORT_FILE.FILE_NAME#');//,xml_charset:'ISO-8859-9'
	//form.active_company=session.ep.company_id;
	
	for(paper_count=1;paper_count lte 4;paper_count=paper_count+1)//xmlde hangi tagdan itibaren paper blokları basliyor
	{
		if(isdefined('order_info_#paper_count#'))
			break;
	}
	GET_SETUP_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);//kurlar alınıyor
</cfscript>
<cfloop condition="isdefined('order_info_#paper_count#')">

	<cfscript>	
		xml_basket_net_total=0;
		xml_basket_gross_total=0;
		xml_basket_tax_total=0;
		error_flag=0;
		row_ind=1;//hangi satırda oldugu

	attributes.record_emp = evaluate('order_info_'&paper_count&'_record_emp_'&row_ind);
	attributes.sales_emp = evaluate('order_info_'&paper_count&'_sales_emp_'&row_ind);
	
	if (attributes.record_emp) 
		emp_id = attributes.record_emp;
	else 
		emp_id = attributes.sales_emp;
	</cfscript>	
	<cfif not isdefined('session.ep.period_id')>
		<cfquery datasource="#dsn#" name="LOGIN">
		SELECT 
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_USERNAME,
			EMPLOYEES.EMPLOYEE_PASSWORD,
			EMPLOYEES.IP_ADDRESS,
			EMPLOYEES.IS_IP_CONTROL,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_ID,		
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.USER_GROUP_ID,
			EMPLOYEE_POSITIONS.DISCOUNT_VALID,
			EMPLOYEE_POSITIONS.PRICE_VALID,
			EMPLOYEE_POSITIONS.PRICE_DISPLAY_VALID,
			EMPLOYEE_POSITIONS.CONSUMER_PRIORITY,
			EMPLOYEE_POSITIONS.LEVEL_ID,
			EMPLOYEE_POSITIONS.DEPARTMENT_ID,
			EMPLOYEE_POSITIONS.EHESAP,
			EMPLOYEE_POSITIONS.PERIOD_ID,
			EMPLOYEE_POSITIONS.ADMIN_STATUS,
			<!---EMPLOYEE_POSITIONS.POWER_USER,--->
            U.POWERUSER AS POWER_USER_LEVEL_ID,
			MY_SETTINGS.INTERFACE_ID,
			MY_SETTINGS.OZEL_MENU_ID,
			MY_SETTINGS.INTERFACE_COLOR,
			MY_SETTINGS.LANGUAGE_ID,
			MY_SETTINGS.LOGIN_TIME,
			MY_SETTINGS.TIME_ZONE,
			MY_SETTINGS.MAXROWS,
			MY_SETTINGS.TIMEOUT_LIMIT,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.NICK_NAME,
			OUR_COMPANY_INFO.WORKCUBE_SECTOR,
			OUR_COMPANY_INFO.IS_GUARANTY_FOLLOWUP,
			OUR_COMPANY_INFO.IS_PROJECT_FOLLOWUP,
			OUR_COMPANY_INFO.IS_SALES_ZONE_FOLLOWUP,
			OUR_COMPANY_INFO.IS_SMS,
			OUR_COMPANY_INFO.IS_UNCONDITIONAL_LIST,
			OUR_COMPANY_INFO.IS_SUBSCRIPTION_CONTRACT,
			OUR_COMPANY_INFO.SPECT_TYPE,
			OUR_COMPANY_INFO.IS_COST,
			OUR_COMPANY_INFO.IS_PAPER_CLOSER,
			OUR_COMPANY_INFO.RATE_ROUND_NUM,
			OUR_COMPANY_INFO.IS_MAXROWS_CONTROL_OFF,
			BRANCH.BRANCH_ID,
			SETUP_PERIOD.OUR_COMPANY_ID,
			SETUP_PERIOD.OTHER_MONEY,
			SETUP_MONEY.MONEY
		FROM 
			EMPLOYEES,
			EMPLOYEE_POSITIONS
            LEFT JOIN USER_GROUP AS U ON EMPLOYEE_POSITIONS.USER_GROUP_ID = U.USER_GROUP_ID,
			DEPARTMENT,
			BRANCH,
			MY_SETTINGS, 
			OUR_COMPANY,
			OUR_COMPANY_INFO,
			SETUP_PERIOD,
			SETUP_MONEY
		WHERE 
			MY_SETTINGS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			EMPLOYEES.EMPLOYEE_ID='#emp_id#' AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEES.EMPLOYEE_STATUS = 1 AND
			EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND

			EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
			SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITIONS.PERIOD_ID AND
			EMPLOYEE_POSITIONS.PERIOD_ID IS NOT NULL AND 
			OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID AND
			SETUP_MONEY.RATE1 = SETUP_MONEY.RATE2 AND
			SETUP_MONEY.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
			OUR_COMPANY.COMP_ID = OUR_COMPANY_INFO.COMP_ID
		</cfquery>
		<cfif login.recordcount eq 1>
			<cfquery name="GET_EMP_AUTHORITY_CODES" datasource="#DSN#">
				SELECT * FROM EMPLOYEES_AUTHORITY_CODES WHERE POSITION_ID = #LOGIN.POSITION_ID#
			</cfquery>
			<cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_1">
				SELECT AUTHORITY_CODE FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 3
			</cfquery>
		</cfif>
		<cfif login.recordcount eq 1>	
			<cfscript>
				// partner ve public icin de bu ayarlamalar gereklidir. Değişiklikler oralara da uygulanmalı
				session.ep = StructNew();
				session.ep.userid = login.employee_ID;
				session.ep.position_code = login.position_code;
				session.ep.money = login.money;
				session.ep.money2 = login.other_money;
				session.ep.time_zone = login.time_zone;
				session.ep.name = login.employee_name;
				session.ep.surname = login.employee_surname;
				session.ep.position_name = login.position_name;
				session.ep.consumer_priority = login.consumer_priority;
				session.ep.discount_valid = login.discount_valid;
				session.ep.price_valid = login.price_valid;
				session.ep.price_display_valid = login.price_display_valid;
				session.ep.language = '#login.language_id#';
				session.ep.design_id = login.interface_id;
				session.ep.menu_id = login.ozel_menu_id;
				session.ep.design_color = login.interface_color;
				session.ep.username = login.employee_username;
				session.ep.userkey = 'e-#login.employee_id#';
				session.ep.company_id = login.OUR_COMPANY_ID;
				session.ep.company = login.COMPANY_NAME;
				session.ep.company_nick = login.NICK_NAME;
				session.ep.period_id = login.PERIOD_ID;
				session.ep.ehesap = login.EHESAP;
				session.ep.maxrows = login.MAXROWS;
				session.ep.server_machine = fusebox.server_machine;
				if(isDefined("session.SESSIONID"))
					session.ep.workcube_id = session.SESSIONID;
				else
					session.ep.workcube_id = cookie.JSESSIONID;
				session.ep.our_company_info = StructNew();
				session.ep.our_company_info.workcube_sector = login.workcube_sector;
				session.ep.our_company_info.is_paper_closer =login.is_paper_closer;
				session.ep.our_company_info.is_cost =login.is_cost;
				session.ep.our_company_info.guaranty_followup = login.IS_GUARANTY_FOLLOWUP;
				session.ep.our_company_info.project_followup = login.IS_PROJECT_FOLLOWUP;
				session.ep.our_company_info.sales_zone_followup = login.IS_SALES_ZONE_FOLLOWUP;
				session.ep.our_company_info.subscription_contract=login.IS_SUBSCRIPTION_CONTRACT;
				session.ep.our_company_info.sms = login.IS_SMS;
				session.ep.our_company_info.unconditional_list = login.IS_UNCONDITIONAL_LIST;
				session.ep.our_company_info.spect_type = login.SPECT_TYPE;
				session.ep.our_company_info.rate_round_num = login.RATE_ROUND_NUM;
				session.ep.our_company_info.is_maxrows_control_off = login.IS_MAXROWS_CONTROL_OFF;
				session.ep.authority_code_hr = "#get_emp_authority_codes_1.authority_code#";
				if(not len(login.admin_status)) session.ep.admin = 0;
				else session.ep.admin = login.admin_status;
				if(not len(login.power_user_level_id))
					session.ep.power_user = 0;
				else
					session.ep.power_user = 1;
				session.ep.timeout_min = login.TIMEOUT_LIMIT;
				
				// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020
				get_priority_branch_dept = cfquery(datasource : "#dsn#", sqlstring : "SELECT BRANCH_ID,DEPARTMENT_ID,LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #login.position_code# AND OUR_COMPANY_ID = #login.our_company_id#");
				if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID) and len(get_priority_branch_dept.LOCATION_ID))
					session.ep.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID&'-'&get_priority_branch_dept.LOCATION_ID;
				else if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID))
					session.ep.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID;
				else
					session.ep.user_location = login.DEPARTMENT_ID&'-'&login.BRANCH_ID;
				// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020
				
				// period date of login user
				GET_PERIOD_YEAR = cfquery(datasource : "#dsn#", sqlstring : "SELECT PERIOD_YEAR,IS_INTEGRATED,PERIOD_DATE FROM SETUP_PERIOD WHERE PERIOD_ID=#LOGIN.PERIOD_ID#");
				GET_PERIOD_DATE = cfquery(datasource : "#dsn#", sqlstring : "SELECT PERIOD_DATE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID=#LOGIN.POSITION_ID# AND PERIOD_ID=#LOGIN.PERIOD_ID#");
				session.ep.period_year=get_period_year.PERIOD_YEAR;
				session.ep.period_is_integrated=get_period_year.IS_INTEGRATED;
				if (len(GET_PERIOD_DATE.PERIOD_DATE)) session.ep.period_date = dateformat(GET_PERIOD_DATE.PERIOD_DATE,'yyyy-mm-dd');
				else if (len(GET_PERIOD_YEAR.PERIOD_DATE)) session.ep.period_date =dateformat(GET_PERIOD_YEAR.PERIOD_DATE,'yyyy-mm-dd');
				else session.ep.period_date = "#get_period_year.PERIOD_YEAR#-01-01";
				// period date of login user
				
				// grup uyesi
				if (len(LOGIN.USER_GROUP_ID))
				{
				GET_USER_GROUPS = cfquery(datasource : "#dsn#", sqlstring : "SELECT USER_GROUP_PERMISSIONS FROM USER_GROUP WHERE USER_GROUP_ID = #LOGIN.USER_GROUP_ID#");
				session.ep.user_level = get_user_groups.USER_GROUP_PERMISSIONS;				
				}
				else session.ep.user_level = login.LEVEL_ID;  //ozel izin seviyesi
				structDelete(session, "error_text");
			</cfscript>	
		</cfif>	
	</cfif>	
	<cfscript>	
		form.active_company=session.ep.company_id;

		attributes.company_id = evaluate('order_info_'&paper_count&'_company_id_'&row_ind);
		attributes.partner_id = evaluate('order_info_'&paper_count&'_partner_id_'&row_ind);
		attributes.consumer_id = '';
		
		attributes.deliverdate = evaluate('order_info_'&paper_count&'_deliver_date_'&row_ind);
		attributes.ship_date = attributes.deliverdate;
		
		if(len(evaluate('order_info_'&paper_count&'_order_date_'&row_ind)) and isdate(evaluate('order_info_'&paper_count&'_order_date_'&row_ind)))
		{
			attributes.order_date = evaluate('order_info_'&paper_count&'_order_date_'&row_ind);
			attributes.basket_due_value_date_ = evaluate('order_info_'&paper_count&'_order_date_'&row_ind);
		}
		else
		{
			writeoutput('Tarih hatalı!<br/>');
			error_flag = 1;
		}
		if(not isdefined('order_products_'&paper_count&'_product_id_'&row_ind))
		{
			writeoutput('Belgede Ürün Yok!<br/>');
			error_flag = 1;
		}
		if(error_flag eq 0)
		{
			//kurlar ile ilgili değişkenler oluşuyor		
			for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.order_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
				if(GET_MONEY_HISTORY.RECORDCOUNT)
					'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
				else
					'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
				'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');				
				if(GET_SETUP_MONEY.MONEY_TYPE[stp_mny] eq evaluate('order_products_#paper_count#_other_money_#row_ind#'))
					'attributes.txt_rate2_#stp_mny#' = evaluate('order_products_#paper_count#_exchange_rate_#row_ind#');
				else
					'attributes.txt_rate2_#stp_mny#'=listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
			}
			if(isdefined('order_info_'&paper_count&'_paper_money_'&row_ind)){
				  attributes.paper_money = evaluate('order_info_'&paper_count&'_paper_money_'&row_ind);
			}
			if(isdefined('attributes.paper_money') and len(trim(attributes.paper_money)))
		    {
						   form.basket_money=attributes.paper_money;
						   attributes.basket_money=attributes.paper_money;
		    }
		    else if(isdefined('session.ep.money2') and len(trim(session.ep.money2)))
			{
				form.basket_money=session.ep.money2;
				attributes.basket_money=session.ep.money2;
			}
			else
			{
				form.basket_money=session.ep.money;
				attributes.basket_money=session.ep.money;
			}
			form.basket_rate1=listfirst(evaluate('#form.basket_money#_rate'),';');
			form.basket_rate2=listlast(evaluate('#form.basket_money#_rate'),';');
			attributes.currency_multiplier = '';
			attributes.kur_say=GET_SETUP_MONEY.RECORDCOUNT;
			attributes.basket_id=4;//tipe göre yazılmalı
			attributes.subscription_id = evaluate('order_info_'&paper_count&'_subs_id_'&row_ind);
			attributes.deliver_dept_id = evaluate('order_info_'&paper_count&'_department_id_'&row_ind);
			attributes.deliver_loc_id = evaluate('order_info_'&paper_count&'_location_id_'&row_ind);
			attributes.deliver_dept_name = evaluate('order_info_'&paper_count&'_department_id_'&row_ind);//len kontrolune takılmasn diye,zaten tutulmuyor
			attributes.process_stage = evaluate('order_info_'&paper_count&'_order_stage_'&row_ind);
			attributes.record_emp = evaluate('order_info_'&paper_count&'_record_emp_'&row_ind);

			if (len(attributes.subscription_id))
			{
				get_subscription=cfquery(SQLString:"SELECT SUBSCRIPTION_NO,REF_PARTNER_ID,REF_COMPANY_ID,REF_CONSUMER_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#",Datasource:dsn3,is_select:1);
			}
			else
			{
				get_subscription.recordcount = 0;
			}
			if (get_subscription.recordcount and len(get_subscription.ref_partner_id))
			{
				attributes.ref_company_id = get_subscription.ref_company_id;
				attributes.ref_member_type = "partner";
				attributes.ref_member_id = get_subscription.ref_partner_id;
				attributes.ref_company = get_par_info(get_subscription.ref_company_id,1,0,0);
			}
			else if(get_subscription.recordcount and len(get_subscription.ref_consumer_id))
			{
				attributes.ref_company_id = get_subscription.ref_company_id;
				attributes.ref_member_type = "consumer";
				attributes.ref_member_id = get_subscription.ref_consumer_id;
				attributes.ref_company = get_cons_info(get_subscription.ref_consumer_id,2,0);
			}
			else
			{
				attributes.ref_company_id = "";
				attributes.ref_member_type = "";
				attributes.ref_member_id = "";
				attributes.ref_company = "";
			}
			attributes.paymethod_id = "";
			attributes.order_employee_id = evaluate('order_info_'&paper_count&'_sales_emp_'&row_ind);
			attributes.order_employee = get_emp_info(attributes.order_employee_id,0,0);
			attributes.detail = evaluate('order_info_'&paper_count&'_order_detail_'&row_ind);
			attributes.reserved = evaluate('order_info_'&paper_count&'_stock_reserve_info_'&row_ind);
			if ( (len(attributes.reserved) and attributes.reserved is 0) or (not len(trim(attributes.reserved))) )
				StructDelete(attributes, 'reserved');
			attributes.project_id = evaluate('order_info_'&paper_count&'_project_id_'&row_ind);
			attributes.ref_no = evaluate('order_info_'&paper_count&'_reference_no_'&row_ind);
			attributes.sales_add_option = evaluate('order_info_'&paper_count&'_sale_description_id_'&row_ind);
			attributes.order_head = evaluate('order_info_'&paper_count&'_order_head_'&row_ind);
			form.genel_indirim = evaluate('order_info_'&paper_count&'_general_discount_'&row_ind);
			if (not len(form.genel_indirim)) form.genel_indirim=0;
			
			attributes.general_prom_limit=0;
			attributes.general_prom_discount=0;
			attributes.general_prom_amount=0;
			attributes.free_prom_limit=0;
			attributes.free_prom_amount=0;
			attributes.free_prom_cost=0;
			/*if(len(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)) and isdate(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)))
				attributes.basket_due_value=datediff('d',evaluate('paper_header_'&paper_count&'_due_date_'&row_ind),attributes.invoice_date);
			else
				attributes.basket_due_value='';
			if(isdate(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)))
				attributes.basket_due_value_date_=evaluate('paper_header_'&paper_count&'_due_date_'&row_ind);
			else
				attributes.basket_due_value_date_= attributes.invoice_date;*/

			//satırlar
			while(isdefined('order_products_#paper_count#_product_id_#row_ind#'))
			{
				product_sql_str='SELECT
									S.BARCOD BARCODE,
									S.STOCK_ID,
									S.PRODUCT_ID,
									S.STOCK_CODE,
									S.PRODUCT_NAME,
									S.PROPERTY,
									S.IS_INVENTORY,
									S.MANUFACT_CODE,
									S.TAX,
									S.IS_PRODUCTION,
									PU.ADD_UNIT,
									PU.PRODUCT_UNIT_ID,
									PU.MULTIPLIER/*,
									PP.ACCOUNT_CODE,
									PP.ACCOUNT_CODE_PUR,
									PP.ACCOUNT_IADE*/
								FROM
									STOCKS AS S,
									PRODUCT_UNIT AS PU/*,
									PRODUCT_PERIOD PP*/
								WHERE
									S.PRODUCT_STATUS = 1 AND
									S.STOCK_STATUS = 1 AND
									S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
									S.PRODUCT_ID = PU.PRODUCT_ID AND
									/*PP.PRODUCT_ID=S.PRODUCT_ID AND
									PP.PERIOD_ID = #session.ep.period_id# AND*/
									PU.MAIN_UNIT = PU.ADD_UNIT
								';
				
				//stock_unit='Adet';
				GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND S.PRODUCT_ID = #evaluate('order_products_#paper_count#_product_id_#row_ind#')#",Datasource:dsn3,is_select:1);// AND PU.ADD_UNIT='#stock_unit#'
				if(GET_PRODUCT_ID.RECORDCOUNT eq 1)
				{
					/*GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.order_date)# AND MONEY ='#evaluate('order_products_#paper_count#_other_money_#row_ind#')#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
					if(GET_MONEY_HISTORY.RECORDCOUNT)
						row_rate_info=GET_MONEY_HISTORY.RATE2/GET_MONEY_HISTORY.RATE1;
					else
					{
						GET_S_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM SETUP_MONEY WHERE MONEY ='#evaluate('order_products_#paper_count#_other_money_#row_ind#')#'",Datasource:dsn2,is_select:1);
						row_rate_info=GET_S_MONEY.RATE2/GET_S_MONEY.RATE1;
					}*/row_rate_info = evaluate('order_products_#paper_count#_exchange_rate_#row_ind#');
					other_money_info = wrk_round((evaluate('order_products_#paper_count#_product_price_#row_ind#')/row_rate_info)*evaluate('order_products_#paper_count#_quantity_#row_ind#'));
					'attributes.product_id#row_ind#'=GET_PRODUCT_ID.PRODUCT_ID;
					'attributes.stock_id#row_ind#'=GET_PRODUCT_ID.STOCK_ID;
					'attributes.amount#row_ind#' = evaluate('order_products_#paper_count#_quantity_#row_ind#');
					'attributes.unit#row_ind#'= GET_PRODUCT_ID.ADD_UNIT;
					'attributes.unit_id#row_ind#'= GET_PRODUCT_ID.PRODUCT_UNIT_ID;
					'attributes.price#row_ind#' = evaluate('order_products_#paper_count#_product_price_#row_ind#');
					'attributes.price_other#row_ind#'= wrk_round(other_money_info/evaluate('order_products_#paper_count#_quantity_#row_ind#'));
					'attributes.tax#row_ind#'=GET_PRODUCT_ID.TAX;					
					'attributes.row_nettotal#row_ind#' = evaluate('order_products_#paper_count#_product_price_#row_ind#')*evaluate('order_products_#paper_count#_quantity_#row_ind#');
					'attributes.product_name#row_ind#' = GET_PRODUCT_ID.PRODUCT_NAME;
					'attributes.other_money_#row_ind#' = evaluate('order_products_#paper_count#_other_money_#row_ind#');// session.ep.money;
					'attributes.other_money_gross_total#row_ind#' = other_money_info;
					'attributes.other_money_value_#row_ind#' = other_money_info;
					'attributes.order_currency#row_ind#' = evaluate('order_products_#paper_count#_order_row_stage_#row_ind#');
					'attributes.reserve_type#row_ind#' = evaluate('order_products_#paper_count#_reserve_type_#row_ind#');
					'attributes.spect_id#row_ind#' = "";
					'attributes.is_production#row_ind#' = GET_PRODUCT_ID.IS_PRODUCTION;
					'attributes.is_inventory#row_ind#' = GET_PRODUCT_ID.IS_INVENTORY;
					
					xml_basket_net_total = wrk_round(xml_basket_net_total+(evaluate('order_products_#paper_count#_product_price_#row_ind#')*evaluate('order_products_#paper_count#_quantity_#row_ind#')));
					xml_basket_gross_total = xml_basket_gross_total+(evaluate('order_products_#paper_count#_product_price_#row_ind#')*evaluate('order_products_#paper_count#_quantity_#row_ind#'));
					xml_basket_tax_total = 0;
				
					'attributes.indirim1#row_ind#'=0;
					'attributes.indirim2#row_ind#'=0;
					'attributes.indirim3#row_ind#'=0;
					'attributes.indirim4#row_ind#'=0;
					'attributes.indirim5#row_ind#'=0;
					'attributes.indirim6#row_ind#'=0;
					'attributes.indirim7#row_ind#'=0;
					'attributes.indirim8#row_ind#'=0;
					'attributes.indirim9#row_ind#'=0;
					'attributes.indirim10#row_ind#'=0;
					'attributes.iskonto_tutar#row_ind#'=0;
					'attributes.ek_tutar_price#row_ind#'=0;
					'attributes.ek_tutar#row_ind#'=0;
					'attributes.ek_tutar_other_total#row_ind#'=0;
					'attributes.ek_tutar_total#row_ind#'=0;
					'attributes.extra_cost#row_ind#'=0;
					'attributes.otv_oran#row_ind#'=0;
					'attributes.row_otvtotal#row_ind#'=0;
					
				}
				else
				{
					writeoutput('#GET_PRODUCT_ID.RECORDCOUNT#---#session.ep.period_id#---#evaluate('order_products_#paper_count#_product_id_#row_ind#')#<br/>');
					writeoutput('Belgede Ürün Bulunamadı Veya Birden fazla Ürün ile Eşleşti<br/>');
					error_flag=1;
				}
				row_ind=row_ind+1;
			}
			if(error_flag neq 1)
			{
				//form.genel_indirim = 0; //yukarida tanimlaniyor
				row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
				attributes.rows_ = row_ind;
				form.basket_discount_total = form.genel_indirim;
				form.basket_gross_total = xml_basket_gross_total;
				form.basket_net_total = xml_basket_net_total-form.genel_indirim;
				form.basket_tax_total = 0;
			}
		}
		paper_count=paper_count+1;
	</cfscript>
	<!--- <cfcatch>
		<cfif isdefined('paper_header_#paper_count#_paper_no_1')>
			<cfoutput>#evaluate('paper_header_#paper_count#_paper_no_1')#</cfoutput> Nolu Faturada Okuma İşleminde Sorun Oluştu Dosyayı Kontrol Ediniz!<br/><br/>
		<cfelse>
			Belge No Bilinmiyor Okuma İşleminde Sorun Oluştu XML i Kontrol Ediniz!<br/><br/>
		</cfif>
		<cfset paper_count=paper_count+1><!--- okumada hata verdiğinden bir artırmayacak biz burda artırdık o nedenle--->
		<cfset error_flag = 1>
	</cfcatch>
</cftry> --->
	<cfif error_flag eq 0>
		<cfset xml_import=1><!--- bu değşiken fatura ve diğer dosyaların takıldığında abort veya history back ile geri dönmelerini engellemektedir --->
		<!--- <cfquery name="get_proc" datasource="#dsn3#">
			SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE=#process_id#
		</cfquery> --->
		<cfoutput>#attributes.order_head#</cfoutput> Başlıklı Sipariş Kayıt İşlemi<br/>
		<!--- <cfif isdefined("attributes.basket_due_value_date_") and isdate(attributes.basket_due_value_date_)>
			<cf_date tarih="attributes.basket_due_value_date_">
			<cfset invoice_due_date = '#attributes.basket_due_value_date_#'>
		</cfif>
		<cfif not (isDefined("attributes.department_id") and len(attributes.department_id))>
			<cfset attributes.department_id = "NULL">
		</cfif>
		<cfif not (isDefined("attributes.location_id") and len(attributes.location_id))>
			<cfset attributes.location_id = "NULL">
		</cfif>
		<cfif not (isDefined("attributes.ship_method") and len(attributes.ship_method))>
			<cfset attributes.ship_method = "NULL">
		</cfif>
		<cfif not (isDefined("attributes.paymethod_id") and len(attributes.paymethod_id))>
			<cfset attributes.paymethod_id = "NULL">
		</cfif> --->
		<cfset attributes.currency_multiplier = ''>
		<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
			<cfloop from="1" to="#attributes.kur_say#" index="mon">
				<cfif evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2>
					<cfset attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
				</cfif>
			</cfloop>	
		</cfif>
		<cftry>
			<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#emp_id#_'&round(rand()*100)>
			<cfinclude template="../../sales/query/add_order.cfm">
			<cfoutput>Siparis_id=#GET_MAX_ORDER.MAX_ID#X</cfoutput>
		<cfcatch>
			 <!--- <cfoutput>#attributes.order_head#</cfoutput> Başlıklı Sipariş Kayıt İşleminde Hata oluştu Dosyayı kontrol ediniz!<br/><br/> --->
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>
