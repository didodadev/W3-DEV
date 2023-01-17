<!---select ifadeleri düzenlendi e.a 23.07.2012--->
<!--- otomatik ödeme import lardan gelen gelen havale kayıtları icin include sayfadir
transaction vs ön sayfadadır
Ayşenur 20070203 --->
<cfif isDefined("GET_SUBSCRIPTION_DETAIL.PROJECT_ID")>
	<cfset subscription_project_id = GET_SUBSCRIPTION_DETAIL.PROJECT_ID>
<cfelse>
	<cfset subscription_project_id = ''>
</cfif>
<cfif not (isDefined("acc_member_name") and len(acc_member_name))>
	<cfset acc_member_name = "">
</cfif>
<cfif isDefined("attributes.i_id")>
	<cfset detail_info = 'GELEN HAVALE (O.ÖDEME)'>
    <cfset paper_no = ''>
    <cfset paper_number = ''>
<cfelseif process_type eq 24>
	<cfset detail_info = 'GELEN HAVALE'>
    <cfquery name="get_paper_no" datasource="#dsn2#">
        SELECT
            INCOMING_TRANSFER_NO,
            INCOMING_TRANSFER_NUMBER+1 AS INV_NO
        FROM
            #dsn3_alias#.GENERAL_PAPERS
        WHERE 
            PAPER_TYPE IS NULL 
    </cfquery>
    <cfif get_paper_no.recordcount and len(get_paper_no.INCOMING_TRANSFER_NO) and len(get_paper_no.INV_NO)>
        <cfset paper_no = '#get_paper_no.INCOMING_TRANSFER_NO#-#get_paper_no.INV_NO#'>
        <cfset paper_number = '#get_paper_no.INV_NO#'>
    <cfelse>
        <cfset paper_no = ''>
        <cfset paper_number = ''>
    </cfif>
<cfelse>
	<cfset detail_info = 'GİDEN HAVALE'>
    <cfquery name="get_paper_no" datasource="#dsn2#">
        SELECT
            OUTGOING_TRANSFER_NO,
            OUTGOING_TRANSFER_NUMBER+1 AS INV_NO
        FROM
            #dsn3_alias#.GENERAL_PAPERS
        WHERE 
            PAPER_TYPE IS NULL 
    </cfquery>
    <cfif get_paper_no.recordcount and len(get_paper_no.OUTGOING_TRANSFER_NO) and len(get_paper_no.INV_NO)>
        <cfset paper_no = '#get_paper_no.OUTGOING_TRANSFER_NO#-#get_paper_no.INV_NO#'>
        <cfset paper_number = '#get_paper_no.INV_NO#'>
    <cfelse>
        <cfset paper_no = ''>
        <cfset paper_number = ''>
    </cfif>
</cfif>
<!--- eger sistem odeme plani yapildiysa gecerli olan degerleri korumak icin yeni degisken adlarina set edilir --->
<cfif not(isdefined("GET_IMPORT.IS_DBS") and GET_IMPORT.IS_DBS eq 1)>
	<cfset other_nettotal = wrk_round(val(nettotal)*(system_currency_multiplier/currency_multiplier_other))>
	<cfset nettotal = val(nettotal)>
	<cfset nettotal_system = val(wrk_round(nettotal * system_currency_multiplier))>
</cfif>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT
    	PROCESS_TYPE,
        IS_CARI,
        IS_ACCOUNT,
        IS_ACCOUNT_GROUP,
        ACTION_FILE_NAME,
        ACTION_FILE_FROM_TEMPLATE,
        MULTI_TYPE
	FROM
    	#dsn3#.SETUP_PROCESS_CAT
	WHERE
    	PROCESS_CAT_ID = #process_cat#
</cfquery>
<cfquery name="ADD_GELENH" datasource="#DSN2#" result="MAX_ID">
	INSERT INTO 
		BANK_ACTIONS
	(
		BANK_ORDER_ID,
		ACTION_TYPE,
		PROCESS_CAT,
		ACTION_TYPE_ID,
		PAPER_NO,
        ASSETP_ID,
        PROJECT_ID,
		<cfif process_type eq 24>ACTION_FROM_COMPANY_ID<cfelse>ACTION_TO_COMPANY_ID</cfif>,
		<cfif process_type eq 24>ACTION_FROM_CONSUMER_ID<cfelse>ACTION_TO_CONSUMER_ID</cfif>,
        <cfif process_type eq 24>ACTION_FROM_EMPLOYEE_ID<cfelse>ACTION_TO_EMPLOYEE_ID</cfif>,
        ACC_TYPE_ID,
		<cfif process_type eq 24>ACTION_TO_ACCOUNT_ID<cfelse>ACTION_FROM_ACCOUNT_ID</cfif>,
		ACTION_VALUE,
		ACTION_CURRENCY_ID,
		ACTION_DATE,
		OTHER_CASH_ACT_VALUE,
		OTHER_MONEY,
		IS_ACCOUNT,
		IS_ACCOUNT_TYPE,
		RECORD_EMP,
		RECORD_DATE,		
		RECORD_IP,
		FILE_IMPORT_ID,
		SPECIAL_DEFINITION_ID,
		ACTION_DETAIL,
		<cfif process_type eq 24>TO_BRANCH_ID<cfelse>FROM_BRANCH_ID</cfif>,
		SYSTEM_ACTION_VALUE,
		MASRAF,
		SYSTEM_CURRENCY_ID
		<cfif len(session.ep.money2)>
			,ACTION_VALUE_2
			,ACTION_CURRENCY_ID_2
		</cfif>
	)
	VALUES
	( 
		<cfif not isDefined("attributes.i_id")>#GET_SUBSCRIPTION_DETAIL.BANK_ORDER_ID#<cfelse>NULL</cfif>,
		'#detail_info#',
		#process_cat#,
		#process_type#,
		<cfif len(paper_no)>'#paper_no#'<cfelse>NULL</cfif>,
        <cfif isDefined("GET_SUBSCRIPTION_DETAIL.ASSETP_ID") and len(GET_SUBSCRIPTION_DETAIL.ASSETP_ID)>#GET_SUBSCRIPTION_DETAIL.ASSETP_ID#<cfelse>NULL</cfif>,
        <cfif len(subscription_project_id)>#subscription_project_id#<cfelse>NULL</cfif>,
		<cfif isDefined("GET_SUBSCRIPTION_DETAIL.COMPANY_ID") and len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>#GET_SUBSCRIPTION_DETAIL.COMPANY_ID#<cfelse>NULL</cfif>,
		<cfif isDefined("member_id")>#member_id#<cfelseif isDefined("GET_SUBSCRIPTION_DETAIL.CONSUMER_ID") and len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>#GET_SUBSCRIPTION_DETAIL.CONSUMER_ID#<cfelse>NULL</cfif>,
        <cfif isDefined("member_id")>#member_id#<cfelseif isDefined("GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID") and len(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID)>#GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID#<cfelse>NULL</cfif>,
        <cfif isDefined("GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID") and len(GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID)>#GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID#<cfelse>NULL</cfif>,
		#action_to_account_id#,
		#nettotal#,
		'#account_currency_id#',
		#attributes.process_date#,
		#other_nettotal#,
		'#process_money_info#',
		<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#',
		<cfif isDefined("attributes.i_id") and len(attributes.i_id)>#attributes.i_id#<cfelse>NULL</cfif>,
		<cfif isdefined("ozel_kod") and len(ozel_kod)><cfqueryparam cfsqltype="cf_sql_integer" value="#ozel_kod#"><cfelse>NULL</cfif>,
		<cfif isdefined("action_detail") and len(action_detail)><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#action_detail#"><cfelse>NULL</cfif>,
		<cfif process_type eq 24 and len(to_branch_id)>#to_branch_id#<cfelseif process_type eq 25 and len(from_branch_id)>#from_branch_id#<cfelse>NULL</cfif>,
		#nettotal_system#,
		0,
		'#session.ep.money#'
		<cfif len(session.ep.money2)>
			,#wrk_round(nettotal_system/currency_multiplier,4)#
			,'#session.ep.money2#'
		</cfif>
	)
</cfquery>
<cfscript>
	if(isDefined("GET_SUBSCRIPTION_DETAIL.COMPANY_ID") and len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID))
		comp_id_info = GET_SUBSCRIPTION_DETAIL.COMPANY_ID;
	else
		comp_id_info = "";
	if(isDefined("member_id") and len(member_id))//sistemlerden ve manuel kapamadan çalışanlara göre düzenlendi
		cons_id_info = member_id;
	else if(isDefined("GET_SUBSCRIPTION_DETAIL.CONSUMER_ID") and len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID))
		cons_id_info = GET_SUBSCRIPTION_DETAIL.CONSUMER_ID;
	else
		cons_id_info = "";
		
	if(isDefined("member_id") and len(member_id))//sistemlerden ve manuel kapamadan çalışanlara göre düzenlendi
		emp_id_info = member_id;
	else if(isDefined("GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID") and len(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID))
		emp_id_info = GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID;
	else
		emp_id_info = "";
	
	if(is_cari eq 1)
	{
		if(process_type eq 24)
		{
			carici
			(
				action_id : MAX_ID.IDENTITYCOL,
				islem_belge_no : paper_no,
				action_table : 'BANK_ACTIONS',
				workcube_process_type : process_type,		
				process_cat : process_cat,	
				islem_tarihi : attributes.process_date,
				to_account_id : action_to_account_id,
				to_branch_id : to_branch_id,
				from_branch_id : from_branch_id,
				islem_tutari : nettotal_system,
				action_currency : session.ep.money,
				acc_type_id :  iif(isDefined("GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID") and len(GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID),GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID,DE('')),
				other_money_value : other_nettotal,
				other_money : process_money_info,
				currency_multiplier : currency_multiplier,
				islem_detay : detail_info,
				account_card_type : 13,
				due_date: attributes.process_date,
				from_cmp_id : comp_id_info,
				from_consumer_id : cons_id_info,
				project_id : iif(len(subscription_project_id),de(subscription_project_id),de('')),
				from_employee_id : emp_id_info,
				rate2:currency_multiplier_other
			);
		}
		else
		{
			carici
			(
				action_id : MAX_ID.IDENTITYCOL,
				islem_belge_no : paper_no,
				action_table : 'BANK_ACTIONS',
				workcube_process_type : process_type,		
				process_cat : process_cat,	
				islem_tarihi : attributes.process_date,
				from_account_id : action_to_account_id,
				to_branch_id : to_branch_id,
				from_branch_id : from_branch_id,
				islem_tutari : nettotal_system,
				acc_type_id :  iif(isDefined("GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID") and len(GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID),GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID,DE('')),
				action_currency : session.ep.money,
				other_money_value : other_nettotal,
				other_money : process_money_info,
				currency_multiplier : currency_multiplier,
				islem_detay : detail_info,
				account_card_type : 13,
				due_date: attributes.process_date,
				to_cmp_id : comp_id_info,
				to_consumer_id : cons_id_info,
				project_id : iif(len(subscription_project_id),de(subscription_project_id),de('')),
				to_employee_id : emp_id_info,
				rate2:currency_multiplier_other
			);
		}
	}

	if (is_account eq 1)
	{
		GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #action_to_account_id#");
		if (isDefined("attributes.bank_order_type") and not isDefined("attributes.i_id"))
		{
			if(len(GET_ACC_CODE_INFO.ACCOUNT_ORDER_CODE) and (assign_order_account eq 1) and process_type eq 25)//Banka Talimatı Muhasebe Kodu
			{
				other_borc = nettotal_system;
				other_currecy_borc = session.ep.money;
			}
			else
			{
				other_borc = other_nettotal;
				other_currecy_borc = process_money_info;
			}
		}
		else
		{
				other_borc = other_nettotal;
				other_currecy_borc = process_money_info;
		}
		if(process_type eq 24)
		{
			other_amount_alacak = other_nettotal;
			other_currency_alacak = process_money_info;
			other_amount_borc = nettotal;
			other_currency_borc = account_currency_id;
		}
		else
		{
			other_amount_alacak = nettotal;
			other_currency_alacak = account_currency_id;
			other_amount_borc = other_nettotal;
			other_currency_borc = process_money_info;
		}
		muhasebeci 
		(
			action_id : MAX_ID.IDENTITYCOL,
			workcube_process_type: process_type,
			workcube_process_cat : process_cat,
			account_card_type: 13,
			company_id : comp_id_info,
			consumer_id : cons_id_info,
			employee_id : emp_id_info,
			belge_no : paper_no,
			islem_tarihi: attributes.process_date,
			fis_satir_detay: '#acc_member_name#-#detail_info#',
			borc_hesaplar: iif((process_type eq 24),de('#GET_ACC_CODE.ACCOUNT_ACC_CODE#'),de('#MY_ACC_RESULT#')),
			borc_tutarlar: nettotal_system,
			other_amount_borc : other_amount_borc,
			other_currency_borc : other_currency_borc,
			alacak_hesaplar: iif((process_type eq 24),de('#MY_ACC_RESULT#'),de('#GET_ACC_CODE.ACCOUNT_ACC_CODE#')),
			alacak_tutarlar: nettotal_system,
			other_amount_alacak : other_amount_alacak,
			other_currency_alacak : other_currency_alacak,
			currency_multiplier : currency_multiplier,
			to_branch_id : to_branch_id,
			from_branch_id : from_branch_id,
			acc_project_id : iif(len(subscription_project_id),de(subscription_project_id),de('')),
			fis_detay: iif((process_type eq 24),de('GELEN HAVALE İŞLEMI'),de('GİDEN HAVALE İŞLEMI'))
		);
	}
</cfscript>
<cfquery name="get_cari_rows" datasource="#dsn2#">
	SELECT CARI_ACTION_ID,ACTION_TYPE_ID,ACTION_ID,ACTION_TABLE FROM CARI_ROWS WHERE ACTION_ID = #MAX_ID.IDENTITYCOL# AND ACTION_TYPE_ID = #process_type#
</cfquery>
<cfif get_cari_rows.recordcount>
	<cfset cari_act_id_inf = get_cari_rows.cari_action_id>
<cfelse>
	<cfset cari_act_id_inf = ''>
</cfif>
<cfif isdefined("attributes.rd_money") and isDefined("attributes.kur_say")>
	<cfloop from="1" to="#attributes.kur_say#" index="r">
		<cfquery name="ADD_ACTION_MONEY" datasource="#dsn2#">
			INSERT INTO 
				BANK_ACTION_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					'#wrk_eval("attributes.hidden_rd_money_#r#")#',
					#evaluate("attributes.txt_rate2_#r#")#,
					#evaluate("attributes.txt_rate1_#r#")#,
					<cfif evaluate("attributes.hidden_rd_money_#r#") is process_money_info>1<cfelse>0</cfif>
				)
		</cfquery>
	</cfloop>
<cfelse>
	<cfif GET_MONEY_INFO.recordcount>
		<cfloop query="GET_MONEY_INFO">
			<cfquery name="INSERT_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO
					BANK_ACTION_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					'#GET_MONEY_INFO.MONEY#',
					#GET_MONEY_INFO.RATE2#,
					#GET_MONEY_INFO.RATE1#,
					<cfif GET_MONEY_INFO.MONEY eq process_money_info>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<cfif not isDefined("attributes.i_id")><!--- talimattan otomatik havale olusturdugunda --->
	<cfif assign_order_cari eq 1>
		<cfquery name="UPD_CARI" datasource="#DSN2#">
			UPDATE
				CARI_ROWS
			SET 
				IS_PROCESSED = 1
			WHERE 
				ACTION_ID = #GET_SUBSCRIPTION_DETAIL.BANK_ORDER_ID# AND
				ACTION_TYPE_ID = #assign_order_process_type#
		</cfquery>
	</cfif>
	<cfquery name="UPD_BANK_ORDERS" datasource="#DSN2#">
		UPDATE BANK_ORDERS SET IS_PAID = 1 WHERE BANK_ORDER_ID = #GET_SUBSCRIPTION_DETAIL.BANK_ORDER_ID#
	</cfquery>
	<cfquery name="GET_BANK_ORDERS" datasource="#DSN2#">
		SELECT CLOSED_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = #GET_SUBSCRIPTION_DETAIL.BANK_ORDER_ID#
	</cfquery>
	<cfif len(get_bank_orders.closed_id)>
        <cfquery name="GET_CLOSED" datasource="#DSN2#">
            SELECT ACTION_ID FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #GET_BANK_ORDERS.CLOSED_ID#
        </cfquery>
		<cfquery name="GET_CARI_INFO" datasource="#DSN2#">
			SELECT 
				CARI_ACTION_ID,
				ACTION_ID,
				ACTION_TABLE,
				PAPER_NO,
				ACTION_TYPE_ID,
				TO_CMP_ID,
				FROM_CMP_ID,
				TO_ACCOUNT_ID,
				FROM_ACCOUNT_ID,
                TO_CONSUMER_ID,
				FROM_CONSUMER_ID,
                TO_EMPLOYEE_ID,
                FROM_EMPLOYEE_ID,
				ACTION_VALUE,
				DUE_DATE,
				IS_ACCOUNT,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				PROCESS_CAT,
				FROM_BRANCH_ID,
				TO_BRANCH_ID,
				RATE2
			FROM 
				CARI_ROWS WHERE ACTION_ID = #MAX_ID.IDENTITYCOL# AND 
				ACTION_TYPE_ID = #process_type#
		</cfquery>
		<cfif len(GET_CLOSED.ACTION_ID) and GET_CLOSED.ACTION_ID neq 0 and len(GET_CARI_INFO.recordcount) and GET_CARI_INFO.recordcount>
			<cfquery name="UPD_CLOSED" datasource="#DSN2#">
				INSERT INTO
					CARI_CLOSED_ROW
				(
					CLOSED_ID,
					CARI_ACTION_ID,
					ACTION_ID,
					ACTION_TYPE_ID,
					ACTION_VALUE,
					CLOSED_AMOUNT,
					OTHER_CLOSED_AMOUNT,
					P_ORDER_VALUE,
					OTHER_P_ORDER_VALUE,							
					OTHER_MONEY,
					DUE_DATE
				)
				VALUES
				(
					#get_bank_orders.closed_id#,
					#GET_CARI_INFO.CARI_ACTION_ID#,
					#MAX_ID.IDENTITYCOL#,
					#process_type#,
					#GET_CARI_INFO.ACTION_VALUE#,
					#GET_CARI_INFO.ACTION_VALUE#,
					#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
					#GET_CARI_INFO.ACTION_VALUE#,
					#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
					'#GET_CARI_INFO.OTHER_MONEY#',
					#createodbcdatetime(GET_CARI_INFO.DUE_DATE)#
				)
			</cfquery>
			<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
				SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
			</cfquery>
			<cfquery name="GET_CLOSED" datasource="#DSN2#">
				SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #get_bank_orders.closed_id#
			</cfquery>
			<cfquery name="UPD_CLOSED" datasource="#DSN2#">
				UPDATE
					CARI_CLOSED
				SET
					IS_CLOSED = 1,
				<cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
					DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
					CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
				<cfelse>
					DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
					CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
				</cfif>
					DIFFERENCE_AMOUNT_VALUE = 0
				WHERE
					CLOSED_ID = #get_bank_orders.closed_id#
			</cfquery>
			<cfquery name="UPD_CLOSED" datasource="#DSN2#">
				UPDATE
					CARI_CLOSED_ROW
				SET
					RELATED_CLOSED_ROW_ID = #GET_MAX_C_ID.C_MAX_ID#,
					CLOSED_AMOUNT = P_ORDER_VALUE,
					OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
				WHERE
					CLOSED_ID = #get_bank_orders.closed_id#
			</cfquery>
        <cfelse>
            <cfquery name="GET_CLOSED" datasource="#dsn2#">
                SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #get_bank_orders.closed_id#
            </cfquery>
            <cfquery name="UPD_CLOSED" datasource="#dsn2#">
                UPDATE
                    CARI_CLOSED
                SET
                    IS_CLOSED = 1,
                    <cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
                        DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
                        CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
                    <cfelse>
                        DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
                        CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
                    </cfif>
                    DIFFERENCE_AMOUNT_VALUE = 0
                WHERE
                    CLOSED_ID = #get_bank_orders.closed_id#
            </cfquery>
            <cfquery name="UPD_CLOSED" datasource="#dsn2#">
                UPDATE
                    CARI_CLOSED_ROW
                SET
                    RELATED_CLOSED_ROW_ID = 0,
                    RELATED_CARI_ACTION_ID = #GET_CARI_INFO.CARI_ACTION_ID#,
                    CLOSED_AMOUNT = P_ORDER_VALUE,
                    OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
                WHERE
                    CLOSED_ID = #get_bank_orders.closed_id#
            </cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif len(paper_number)>
	<!--- Belge No update ediliyor --->
	<cfif process_type eq 24>
        <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
            UPDATE 
                #dsn3_alias#.GENERAL_PAPERS
            SET
                INCOMING_TRANSFER_NUMBER = #paper_number#
            WHERE
                INCOMING_TRANSFER_NUMBER IS NOT NULL
        </cfquery>
    <cfelseif process_type eq 25>
    	<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
            UPDATE 
                #dsn3_alias#.GENERAL_PAPERS
            SET
                OUTGOING_TRANSFER_NUMBER = #paper_number#
            WHERE
                OUTGOING_TRANSFER_NUMBER IS NOT NULL
        </cfquery>
    </cfif>
</cfif>
<!--- action file --->
<cf_workcube_process_cat 
		process_cat="#process_cat#"
		action_id = #MAX_ID.IDENTITYCOL#
		action_table = "BANK_ACTIONS"
		action_column="ACTION_ID"
		is_action_file = 1
		action_db_type = '#dsn2#'
		action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.list_assign_order'
		action_file_name='#get_process_type.action_file_name#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>



