<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.list_creditcard_revenue">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.credit_payment_type" default="">
<cfparam name="attributes.cc_action_type" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.bank_account" default="">
<cfparam name="attributes.order_info" default="">
<cfparam name="attributes.bank_action_date" default="2">
<cfparam name="attributes.record_member_type" default="">
<cfparam name="attributes.record_member_id" default="">
<cfparam name="attributes.record_member_name" default="">
<cfparam name="attributes.revenue_collector_id" default="">
<cfparam name="attributes.revenue_collector" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST eq 1>
		<cfset attributes.start_date=''>
	<cfelse>
        <cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif  isdefined('attributes.finish_date') and len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
        <cfset attributes.finish_date = wrk_get_today()>
	</cfif>
</cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS=1
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_CREDIT_PAYMENTS" datasource="#dsn3#">
	SELECT CARD_NO, PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE ORDER BY CARD_NO
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT 
		ACCOUNT_ID, 
		ACCOUNT_NAME
	FROM 
		ACCOUNTS
	WHERE
	<cfif session.ep.period_year lt 2009>
		ACCOUNT_CURRENCY_ID = 'TL'<!--- tüm pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
	<cfelse>
		ACCOUNT_CURRENCY_ID = '#session.ep.money#'
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
	</cfif>
	ORDER BY 
		ACCOUNT_NAME
</cfquery>
<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfset control_branch_id = attributes.branch_id>
	<cfelse>
		<cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
	</cfif>
</cfif>
<!--- islem tipleri cekiliyor --->
<cfquery name="get_process_cat_process_type" datasource="#dsn3#">
	SELECT DISTINCT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (241,245,2410,52,69)
</cfquery>
<cfquery name="get_all_process_cat" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (241,245,2410,52,69) ORDER BY PROCESS_TYPE
</cfquery>

<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_CREDIT_MAIN" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
		WITH CTE1 AS(
        SELECT
			CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP,
			CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR,
			CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID,
			CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE,
			CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID,
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE,
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT,0) SALES_CREDIT,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID,
			CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID,
			CREDIT_CARD_BANK_PAYMENTS.FILE_IMPORT_ID,
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.WRK_ID_INVOICE,CREDIT_CARD_BANK_PAYMENTS.WRK_ID) WRK_ID,
			CREDIT_CARD_BANK_PAYMENTS.ORDER_ID,
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.COMMISSION_AMOUNT,0) COMMISSION_AMOUNT,
			CREDIT_CARD_BANK_PAYMENTS.OTHER_CASH_ACT_VALUE,
			CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY,
			CREDIT_CARD_BANK_PAYMENTS.PAPER_NO,
			CREDIT_CARD_BANK_PAYMENTS.REVENUE_COLLECTOR_ID,
			<cfif database_type is "MSSQL">
				SUBSTRING(CREDIT_CARD_BANK_PAYMENTS.ACTION_DETAIL,1,50) ACTION_DETAIL,
			<cfelseif database_type is "DB2">
				SUBSTR(CREDIT_CARD_BANK_PAYMENTS.ACTION_DETAIL,1,50) ACTION_DETAIL,
			</cfif>
			CREDITCARD_PAYMENT_TYPE.CARD_NO,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID AS ACCOUNT_ID,
            CREDIT_CARD_BANK_PAYMENTS.IS_ONLINE_POS,
            ISNULL(CREDIT_CARD_BANK_PAYMENTS.IS_VOID,0) IS_VOID,
            C.NICKNAME, 
            C.MEMBER_CODE AS COMPANY_MEMBER_CODE,
            CN.CONSUMER_NAME,
            CN.CONSUMER_SURNAME, 
            CN.MEMBER_CODE AS CONSUMER_MEMBER_CODE,
			O.ORDER_NUMBER
            <cfif xml_show_record_emp_info eq 1>
                ,E.EMPLOYEE_NAME
                ,E.EMPLOYEE_SURNAME
                ,CP.COMPANY_PARTNER_NAME
                ,CP.COMPANY_PARTNER_SURNAME
                ,CONS.CONSUMER_NAME AS CONS_CONSUMER_NAME
                ,CONS.CONSUMER_SURNAME AS CONS_CONSUMER_SURNAME
         	</cfif>
            ,AC.ACCOUNT_NAME,
            CREDIT_CARD_BANK_PAYMENTS.MULTI_ACTION_ID,
            SPC.PROCESS_CAT PROCESS_CAT_NAME,
            SPC.PROCESS_TYPE
        FROM
			CREDIT_CARD_BANK_PAYMENTS WITH (NOLOCK) 
                LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID
                LEFT JOIN #DSN_ALIAS#.CONSUMER CN ON CN.CONSUMER_ID = CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID 
                LEFT JOIN #DSN3_ALIAS#.ORDERS O ON O.ORDER_ID = CREDIT_CARD_BANK_PAYMENTS.ORDER_ID         
                <cfif xml_show_record_emp_info eq 1>
                    LEFT JOIN #DSN_ALIAS#.EMPLOYEES E ON E.EMPLOYEE_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP
                    LEFT JOIN #DSN_ALIAS#.COMPANY_PARTNER CP ON CP.PARTNER_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR
                    LEFT JOIN #DSN_ALIAS#.CONSUMER CONS ON CONS.CONSUMER_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS   
                </cfif>	
                LEFT JOIN #DSN3_ALIAS#.ACCOUNTS AC ON AC.ACCOUNT_ID = CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID
                LEFT JOIN #DSN3_ALIAS#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT
            ,CREDITCARD_PAYMENT_TYPE
		WHERE
			CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_ID IS NULL
			<cfif Len(attributes.record_member_name) and Len(attributes.record_member_id)>
				<cfif attributes.record_member_type is 'employee'>
					AND CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
				<cfelseif attributes.record_member_type is 'partner'>
					AND CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
				<cfelseif attributes.record_member_type is 'consumer'>
					AND CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
				</cfif>
			</cfif>
			<cfif len(attributes.keyword)>
				AND
				(
					CREDITCARD_PAYMENT_TYPE.CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR ISNULL(CREDIT_CARD_BANK_PAYMENTS.WRK_ID_INVOICE,CREDIT_CARD_BANK_PAYMENTS.WRK_ID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR CREDIT_CARD_BANK_PAYMENTS.ORDER_ID = (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS WHERE ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI)<!--- partner dan yapılan sipariş ödemeleri için --->
				)
			</cfif>
			<cfif len(attributes.start_date)>AND CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
			<cfif len(attributes.finish_date)>AND CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finish_date)#"></cfif>
			<cfif len(attributes.credit_payment_type)>AND CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_payment_type#"></cfif>
			<cfif len(attributes.bank_account)>AND CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_account#"></cfif>
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				AND CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif len(attributes.cons_id) and len(attributes.member_name)>
				AND CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
			</cfif>
			<cfif len(attributes.order_info) and attributes.order_info eq 1>
				AND CREDIT_CARD_BANK_PAYMENTS.ORDER_ID IS NOT NULL
			</cfif>
			<cfif len(attributes.order_info) and attributes.order_info eq 0>
				AND CREDIT_CARD_BANK_PAYMENTS.ORDER_ID IS NULL
			</cfif>
			<cfif len(attributes.order_info) and attributes.order_info eq 2>
				AND CREDIT_CARD_BANK_PAYMENTS.CAMPAIGN_ID IS NOT NULL
			</cfif>
			<cfif len(attributes.order_info) and attributes.order_info eq 3>
				AND CREDIT_CARD_BANK_PAYMENTS.CAMPAIGN_ID IS NULL
			</cfif>
			<cfif  (isdefined('attributes.branch_id') and len(attributes.branch_id))>
				AND CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#">
			<cfelseif (session.ep.isBranchAuthorization)>
				AND CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID IN (SELECT 
						BRANCH_ID
					FROM 
						#dsn#.BRANCH 
					WHERE
						BRANCH_STATUS=1
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					)
			</cfif>
            <cfif len(attributes.cc_action_type)>
				<cfif listlen(attributes.cc_action_type,'-') eq 1 or (listlen(attributes.cc_action_type,'-') gt 1 and listlast(attributes.cc_action_type,'-') eq 0)>
                    AND CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID = #listfirst(attributes.cc_action_type,'-')#
                <cfelse>
                    AND CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT = #listlast(attributes.cc_action_type,'-')#
                </cfif>
            </cfif>
			<cfif len(attributes.revenue_collector_id) and len(attributes.revenue_collector)>
				AND CREDIT_CARD_BANK_PAYMENTS.REVENUE_COLLECTOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.revenue_collector_id#">
			</cfif>
			<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
				AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
				AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
				AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
			</cfif>
		
         ),
         CTE2 AS (
				SELECT
					CTE1.*,
						ROW_NUMBER() OVER (ORDER BY
									<cfif attributes.bank_action_date eq 1>
                                        STORE_REPORT_DATE,
                                    <cfelseif attributes.bank_action_date eq 2>
                                        STORE_REPORT_DATE DESC,
                                    </cfif>
                                    CREDITCARD_PAYMENT_ID DESC
					) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
                ISNULL(( SELECT SUM(SALES_CREDIT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID IN(52,69,241,2410) ),0) SUM_SALES_CREDIT,
                ISNULL(( SELECT SUM(COMMISSION_AMOUNT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID IN(52,69,241,2410) ),0) SUM_COMMISSION_AMOUNT,
                ISNULL(( SELECT SUM(SALES_CREDIT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID = 245 ),0) SUM_SALES_CREDIT_IPTAL,
                ISNULL(( SELECT SUM(COMMISSION_AMOUNT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID = 245 ),0) SUM_COMMISSION_AMOUNT_IPTAL,
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
<cfelse>
  	<cfset GET_CREDIT_MAIN.recordcount = 0>
</cfif>

<cfif GET_CREDIT_MAIN.recordcount>
	<cfparam name="attributes.totalrecords" default='#GET_CREDIT_MAIN.QUERY_COUNT#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="search_form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getlang('main','Filtre',57460)#">
				</div>
				<div class="form-group large">
					<div class="input-group">
						<cfsavecontent variable="tarih"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#tarih#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>                
				<div class="form-group large">
					<div class="input-group">
						<cfsavecontent variable="tarih2"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#tarih2#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>                 
				<div class="form-group">
					<select name="bank_action_date" id="bank_action_date">
						<option value="1" <cfif attributes.bank_action_date eq 1>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="2" <cfif attributes.bank_action_date eq 2>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
					</select>
				</div>                  
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>  
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()' button_type="4">
				</div>  
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" onClick="window.open('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_creditcard_revenue&event=add');"><i class="fa fa-fax" title="<cf_get_lang dictionary_id='48934.POS Cihazı'>"></i></a>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_add_online_pos','medium');"><i class="icon-POS" title="<cf_get_lang dictionary_id='48865.Sanal Pos'>"></i></a>
				</div>  
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" onClick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_payment_credit_cards','_blank')"><i class="fa fa-calculator" title="<cf_get_lang dictionary_id='48731.Hesaba Geçiş'>"></i></a>
					<!--- <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_add_creditcard_revenue','medium');"><img src="/images/pos_credit.gif" alt="<cf_get_lang no ='273.POS Cihazı'>" title="<cf_get_lang no ='273.POS Cihazı'>"></a> 
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_add_online_pos','medium');"><img src="/images/pos_credit_sanal.gif" alt="<cf_get_lang no ='204.Sanal POS'>" title="<cf_get_lang no ='204.Sanal POS'>"></a> 
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_payment_credit_cards"><img src="images/pos_credit_plus.gif" alt="<cf_get_lang no ='70.Hesaba Geçiş'>" title="<cf_get_lang no ='70.Hesaba Geçiş'>"></a> --->						
				</div> 
			</cf_box_search>      
			<cfset colspan_ = 16 />
			<cfif xml_show_order_info eq 1><cfset colspan_ = colspan_ + 1></cfif>
			<cfif xml_show_record_emp_info eq 1><cfset colspan_ = colspan_ + 1></cfif>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-cc_action_type">	
						<label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
						<div class="col col-12">
							<select name="cc_action_type" id="cc_action_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_process_cat_process_type">
									<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.cc_action_type>selected</cfif>>#get_process_name(process_type)#</option>
									<cfquery name="get_pro_cat" dbtype="query">
										SELECT * FROM get_all_process_cat WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_cat_process_type.process_type#"> 
									</cfquery>
									<cfloop query="get_pro_cat">
										<option value="#get_pro_cat.process_type#-#get_pro_cat.process_cat_id#" <cfif attributes.cc_action_type is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_pro_cat.process_cat#</option>
									</cfloop>
								</cfoutput>
							</select>                          
						</div>
					</div>
					<div class="form-group" id="item-bank_account">	
						<label class="col col-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
						<div class="col col-12">
							<select name="bank_account" id="bank_account">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_accounts">
									<option value="#account_id#"<cfif attributes.bank_account eq ACCOUNT_ID>selected</cfif>>#account_name#</option>
								</cfoutput>
							</select>          
						</div>
					</div>
					<div class="form-group" id="item-member_name">	
						<label class="col col-12"><cf_get_lang dictionary_id='57519.cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="par_id" id="par_id" value="<cfoutput>#attributes.par_id#</cfoutput>">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
								<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>">
								<input name="member_name" type="text" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID','par_id,company_id,cons_id','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off" placeholder="<cfoutput>#getLang('main',107)#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_name=search_form.member_name&field_partner=search_form.par_id&field_consumer=search_form.cons_id&field_comp_id=search_form.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>','list');" title="<cf_get_lang dictionary_id='57519.cari Hesap'>"></span>
							</div>                            
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-branch_id">	
						<label class="col col-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_branch">
									<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>                          
						</div>
					</div>                
					<div class="form-group" id="item-order_info">	
						<label class="col col-12"><cf_get_lang dictionary_id='48889.Sipariş İlişkili'></label>
						<div class="col col-12">
							<select name="order_info" id="order_info">
								<option value="" <cfif attributes.order_info eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif attributes.order_info eq 1>selected</cfif>><cf_get_lang dictionary_id='48889.Sipariş İlişkili'></option>
								<option value="0" <cfif attributes.order_info eq 0>selected</cfif>><cf_get_lang dictionary_id='48890.Sipariş İlişkisiz'></option>
								<option value="2" <cfif attributes.order_info eq 2>selected</cfif>><cf_get_lang dictionary_id='48891.Kampanya İlişkili'></option>
								<option value="3" <cfif attributes.order_info eq 3>selected</cfif>><cf_get_lang dictionary_id='48892.Kampanya İlişkisiz'></option>
							</select>	                          
						</div>
					</div> 
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-special_definition_id">	
						<label class="col col-12"><cf_get_lang dictionary_id='57845.Tahsilat'> / <cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
						<div class="col col-12">
							<cf_wrk_special_definition width_info="150" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>                           
						</div>
					</div>                
					<div class="form-group" id="item-credit_payment_type">	
						<label class="col col-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
						<div class="col col-12">
							<select name="credit_payment_type" id="credit_payment_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_credit_payments">
									<option value="#payment_type_id#" <cfif attributes.credit_payment_type eq payment_type_id>selected</cfif>>#card_no#</option>
								</cfoutput>
							</select>                    
						</div>
					</div> 
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
					<div class="form-group" id="item-revenue_collector">	
						<label class="col col-12"><cf_get_lang dictionary_id='50233.Tahsil Eden'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfif len(attributes.revenue_collector)><cfoutput>#attributes.revenue_collector_id#</cfoutput></cfif>">
								<input type="text" name="revenue_collector" id="revenue_collector" value="<cfif len(attributes.revenue_collector)><cfoutput>#get_emp_info(attributes.revenue_collector_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('revenue_collector','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','revenue_collector_id','search_form','3','125')" placeholder="<cfoutput>#getLang('bank',5)#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.revenue_collector_id&field_name=search_form.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');" title="<cf_get_lang dictionary_id='50233.Tahsil Eden'>"></span>                            	 
							</div>                            
						</div>
					</div>                
					<div class="form-group" id="item-record_member_name">	
						<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="record_member_type" id="record_member_type" value="<cfif len(attributes.record_member_name)><cfoutput>#attributes.record_member_type#</cfoutput></cfif>">
								<input type="hidden" name="record_member_id" id="record_member_id"  value="<cfif len(attributes.record_member_name)><cfoutput>#attributes.record_member_id#</cfoutput></cfif>">
								<input type="text" name="record_member_name" id="record_member_name" onfocus="AutoComplete_Create('record_member_name','MEMBER_PARTNER_NAME3,MEMBER_NAME2','MEMBER_PARTNER_NAME3,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','MEMBER_TYPE,PARTNER_ID2','record_member_type,record_member_id','','3','250');" value="<cfif len(attributes.record_member_name)><cfoutput>#attributes.record_member_name#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang('main',487)#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=search_form.record_member_name&field_type=search_form.record_member_type&field_id=search_form.record_member_id&field_emp_id=search_form.record_member_id&field_consumer=search_form.record_member_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,7,8</cfoutput>','list')" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></span>
							</div>                            
						</div>
					</div> 
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('main','Kredi Kartı Tahsilatları',30101)#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_credicard_id', print_type : 152 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
					<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='48886.İşlem Kodu'></th>
					<cfif xml_show_order_info eq 1><th><cf_get_lang dictionary_id='58211.Sipariş No'></th></cfif>
					<cfif xml_show_record_emp_info eq 1><th><cf_get_lang dictionary_id='57899.Kaydeden'></th></cfif>
					<th><cf_get_lang dictionary_id='57558.Üye No'></th>
					<th><cf_get_lang dictionary_id='57519.cari Hesap'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
					<th><cf_get_lang dictionary_id='48904.Komisyon Tutarı'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></th>
					<!-- sil -->		 
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_creditcard_revenue&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'>" title="<cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'>"></i></a></th>
					<cfif  GET_CREDIT_MAIN.recordcount>
						<th width="20" nowrap="nowrap" class="text-center header_icn_none">
							<cfif GET_CREDIT_MAIN.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_credicard_id');">
						</th>
					</cfif>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfset alt_toplam = 0>
				<cfset alt_kom_toplam = 0>
				<cfset curr_row = (attributes.page-1)*attributes.maxrows + 1>
				<cfif GET_CREDIT_MAIN.recordcount>
					<cfoutput query="GET_CREDIT_MAIN">
						<tr>
							<td>#curr_row#</td>
							<td>#PAPER_NO#</td>
							<td><cfif len(account_id) and account_id neq 0 >#ACCOUNT_NAME#</cfif></td>
							<td><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 52>
									<a href="javascript://" onclick="control_update(#CREDITCARD_PAYMENT_ID#);">#card_no#</a>
								<cfelseif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 69>
									<a href="javascript://" onclick="control_update_4(#CREDITCARD_PAYMENT_ID#);">#card_no#</a>
								<cfelseif listfind('241,245',GET_CREDIT_MAIN.ACTION_TYPE_ID) and GET_CREDIT_MAIN.PROCESS_CAT eq 0>
									<a href="javascript://" onclick="control_update_2(#CREDITCARD_PAYMENT_ID#);">#card_no#</a>
								<cfelseif len(multi_action_id)>
									<a href="#request.self#?fuseaction=bank.list_creditcard_revenue&event=updMulti&multi_id=#multi_action_id#">#card_no#</a>
								<cfelse>
									<a href="javascript://" onclick="window.open('#request.self#?fuseaction=bank.list_creditcard_revenue&event=upd&id=#creditcard_payment_id#','_blank');">#card_no#</a>
								</cfif>
							</td>
							<td><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">#PROCESS_CAT_NAME#</font><cfelse>#PROCESS_CAT_NAME#</cfif></td>
							<td>#ACTION_DETAIL#</td>
							<td style="mso-number-format:\@;">#WRK_ID#</td>
							<cfif xml_show_order_info eq 1><td><cfif len(ORDER_ID)>#ORDER_NUMBER#</cfif></td></cfif>
							<cfif xml_show_record_emp_info eq 1>
								<td><cfif Len(record_emp)>
										#employee_name# #employee_surname#
									<cfelseif Len(record_par)>
										#company_partner_name# #company_partner_surname#
									<cfelseif Len(record_cons)>
										#CONS_CONSUMER_NAME# #CONS_CONSUMER_SURNAME#
									</cfif>
								</td>
							</cfif>
							<td><cfif len(COMPANY_MEMBER_CODE)>
									#COMPANY_MEMBER_CODE#
								<cfelseif len(consumer_id)>
									#CONSUMER_MEMBER_CODE#
								</cfif>
							</td>
							<td><cfif len(ACTION_FROM_COMPANY_ID)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ACTION_FROM_COMPANY_ID#','medium');">#NICKNAME#</a>
								<cfelseif len(CONSUMER_ID)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');" > #CONSUMER_NAME# #CONSUMER_SURNAME#</a>
								</cfif>
							</td>
							<td>#dateformat(STORE_REPORT_DATE,dateformat_style)#</td>
							<td class="moneybox">#TLFormat(OTHER_CASH_ACT_VALUE)#</td>
							<td>&nbsp;#OTHER_MONEY#</td>
							<td class="moneybox"><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">-#TLFormat(SALES_CREDIT)#</font><cfelse>#TLFormat(SALES_CREDIT)#</cfif></td>
							<cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><!--- İPTAL işlemler --->
								<cfset alt_toplam = alt_toplam - SALES_CREDIT>
								<cfset alt_kom_toplam = alt_kom_toplam - COMMISSION_AMOUNT>
							<cfelse>
								<cfset alt_toplam = alt_toplam + SALES_CREDIT>
								<cfset alt_kom_toplam = alt_kom_toplam + COMMISSION_AMOUNT>
							</cfif>
							<td class="moneybox"><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">-#TLFormat(COMMISSION_AMOUNT)#</font><cfelse>#TLFormat(COMMISSION_AMOUNT)#</cfif></td>
							<!-- sil -->
							<td>
								<cfif len(multi_action_id)>
									<a href="#request.self#?fuseaction=bank.list_creditcard_revenue&event=updMulti&multi_id=#multi_action_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								<cfelseif GET_CREDIT_MAIN.ACTION_TYPE_ID neq 69 and GET_CREDIT_MAIN.ACTION_TYPE_ID neq 52 and GET_CREDIT_MAIN.PROCESS_CAT neq 0>
									<a href="javascript://" onclick="window.open('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#creditcard_payment_id#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</cfif>								
							</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_list_payment_plans&id=#creditcard_payment_id#','medium');"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></td>
							<td width="20" align="center">
								<cfif GET_CREDIT_MAIN.ACTION_TYPE_ID neq 245 and is_void eq 0><!---is_online_pos eq 1 --->
									<a href="javascript://" onclick="window.open('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=add&payment_id=#creditcard_payment_id#','_blank');"><i class="fa fa-times-rectangle" title="<cf_get_lang dictionary_id='58506.İptal'>"></i></a>
								</cfif>
							</td>
							<td style="text-align:center"><input type="checkbox" name="print_credicard_id" id="print_credicard_id" data-action-type = "#attributes.cc_action_type#" value="#creditcard_payment_id#"></td>
							<!-- sil -->
						</tr>
						<cfset curr_row++>
					</cfoutput>
				</tbody>
				<tfoot>
					<cfoutput>
						<tr>
							<td colspan="<cfoutput>#colspan_-5#</cfoutput>">&nbsp;</td>
							<td class="bold"><cf_get_lang dictionary_id="57492.Toplam"></td>
							<td class="bold moneybox" nowrap="nowrap">#TLFormat(alt_toplam)# #session.ep.money#</td><!--- eskiden dövizli işlemde vardı ama kaldırıldı,oyüzdne ep deki eski kayıtlar saçma olabilir,bilginize.. --->
							<td class="bold moneybox" nowrap="nowrap">#TLFormat(alt_kom_toplam)# #session.ep.money#</td>
							<!-- sil --><td colspan="4"></td><!-- sil -->
						</tr>
						<tr>
							<td colspan="<cfoutput>#colspan_-5#</cfoutput>">&nbsp;</td>
							<td class="bold"><cf_get_lang dictionary_id="57492.Toplam"></td>
							<td class="bold moneybox" nowrap="nowrap">#TLFormat(GET_CREDIT_MAIN.SUM_SALES_CREDIT - GET_CREDIT_MAIN.SUM_SALES_CREDIT_IPTAL)# #session.ep.money#</td><!--- eskiden dövizli işlemde vardı ama kaldırıldı,oyüzdne ep deki eski kayıtlar saçma olabilir,bilginize.. --->
							<td class="bold moneybox" nowrap="nowrap">#TLFormat(GET_CREDIT_MAIN.SUM_COMMISSION_AMOUNT - GET_CREDIT_MAIN.SUM_COMMISSION_AMOUNT_IPTAL)# #session.ep.money#</td>
							<!-- sil --><td colspan="4"></td><!-- sil -->
						</tr>
					</cfoutput>
				</tfoot>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan_+1#</cfoutput>"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
		</cf_grid_list>
		<cfset url_str = "">
		<cfset url_str = "#url_str#&is_submitted=1">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.credit_payment_type)>
			<cfset url_str = "#url_str#&credit_payment_type=#attributes.credit_payment_type#">
		</cfif>
		<cfif len(attributes.bank_account)>
			<cfset url_str = "#url_str#&bank_account=#attributes.bank_account#">
		</cfif>
		<cfif len(attributes.cc_action_type)>
			<cfset url_str = "#url_str#&cc_action_type=#attributes.cc_action_type#">
		</cfif>
		<cfif len(attributes.par_id)>
			<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.cons_id)>
			<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
		</cfif>
		<cfif len(attributes.member_name)>
			<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
		</cfif>
		<cfif Len(attributes.record_member_id) and Len(attributes.record_member_name)>
			<cfset url_str = "#url_str#&record_member_id=#attributes.record_member_id#&record_member_name=#attributes.record_member_name#&record_member_type=#attributes.record_member_type#">
		</cfif>
		<cfif len(attributes.order_info)>
			<cfset url_str = "#url_str#&order_info=#attributes.order_info#">
		</cfif>
		<cfif len(attributes.bank_action_date)>
			<cfset url_str = "#url_str#&bank_action_date=#attributes.bank_action_date#">
		</cfif>
		<cfif len(attributes.revenue_collector_id)>
			<cfset url_str = "#url_str#&revenue_collector_id=#attributes.revenue_collector_id#">
		</cfif>
		<cfif len(attributes.revenue_collector)>
			<cfset url_str = "#url_str#&revenue_collector=#attributes.revenue_collector#">
		</cfif>
		<cfif len(attributes.special_definition_id)>
			<cfset url_str = "#url_str#&special_definition_id=#attributes.special_definition_id#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if ( (search_form.start_date.value.length != 0)&&(search_form.finish_date.value.length != 0) )
			return date_check(search_form.start_date,search_form.finish_date,"<cf_get_lang dictionary_id='48942.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
		return true;
	}
	function control_update(cc_paymnt_id)
	{
		var get_inv_number = wrk_safe_query("bnk_get_inv_number",'dsn2',0,cc_paymnt_id);
		alert("<cf_get_lang dictionary_id='49011.Bu İşlemi İlgili Olduğu'>" + get_inv_number.INVOICE_NUMBER +"<cf_get_lang dictionary_id='49015.Nolu Perakende Faturasından Güncelleyebilirsiniz'>!");
		return false;
	}
	function control_update_2(cc_paymnt_id)
	{
		var get_ord_number = wrk_safe_query('bnk_get_ord_number','dsn3',0,cc_paymnt_id);
		if(get_ord_number.recordcount >0)
			alert("<cf_get_lang dictionary_id='49011.Bu İşlemi İlgili Olduğu'>" + get_ord_number.ORDER_NUMBER +" <cf_get_lang dictionary_id='49014.Nolu Siparişin Ödeme Planından Güncelleyebilirsiniz'>!");
		else
		{
			var get_ord_number_1 = wrk_safe_query('bnk_get_ord_number_p','dsn3',0,cc_paymnt_id);
			alert("<cf_get_lang dictionary_id='49011.Bu İşlemi İlgili Olduğu'>" + get_ord_number_1.PAPER_NO +"<cf_get_lang dictionary_id='49013.Nolu Senet Tahsilat İşleminden Güncelleyebilirsiniz'> !");
		}
		return false;
	}
	function control_update_4(cc_paymnt_id)
	{
		var get_inv_number = wrk_safe_query("bnk_get_inv_number",'dsn2',0,cc_paymnt_id);
		alert("<cf_get_lang dictionary_id='49011.Bu İşlemi İlgili Olduğu'>" + get_inv_number.INVOICE_NUMBER +"<cf_get_lang dictionary_id='49012.Nolu Z Raporundan Güncelleyebilirsiniz'> !");
		return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
