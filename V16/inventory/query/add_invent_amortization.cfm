<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_cat = form.PROCESS_CAT;
	is_account = get_process_type.IS_ACCOUNT;
	is_budget = get_process_type.IS_BUDGET;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	process_type = get_process_type.PROCESS_TYPE;
	borc_hesaplar_list="";
	alacak_hesaplar_list="";
	borc_tutarlar_list="";
	alacak_tutarlar_list="";
	acc_project_list_borc = '';
	acc_project_list_alacak = '';
	acc_project_id = "";
	
	if(isDefined('attributes.accounting_target') and listfind('1,2',attributes.accounting_target)) {
		go_ifrs = 1;
	} else {
		go_ifrs = 0;
	}
</cfscript>
<cfif len(session.ep.money2)>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT 
            MONEY, 
            RATE1, 
            RATE2, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP
        FROM 
	        SETUP_MONEY 
        WHERE 
        	MONEY = '#session.ep.money2#'
	</cfquery>
	<cfset currency_multiplier = get_money.rate2/get_money.rate1>
<cfelse>
	<cfset currency_multiplier = ''>
</cfif>
<cfset kontrol_inv = 0>
<cfif not isdefined("attributes.all_records")><!--- Eğer ekleme ekranında listeleme yapılmadıysa demirbaşlar burda çekiliyor --->
	<cfset kontrol_inv = 1>
	<cfquery name="GET_INVENT" datasource="#dsn3#">
		SELECT DISTINCT
			<cfif len(attributes.last_amortization_year)>
				INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
			</cfif>
			(SELECT SUM(ISNULL(INVENTORY_ROW3.STOCK_IN,0)-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID) AS MIKTAR,
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.PROCESS_CAT,
			I.QUANTITY,
			ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE) AMORTIZATON_ESTIMATE,
			I.AMORTIZATON_METHOD,
			I.AMOUNT,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.COMP_PARTNER_ID,
			<cfif go_ifrs eq 0>I.LAST_INVENTORY_VALUE<cfelse>I.LAST_INVENTORY_VALUE_IFRS LAST_INVENTORY_VALUE</cfif>,
			ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) ACCOUNT_ID,
			ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID) CLAIM_ACCOUNT_ID,
			ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID) DEBT_ACCOUNT_ID,
			<cfif go_ifrs eq 0>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION) INVENTORY_DURATION,
			<cfelse>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION_IFRS,I.INVENTORY_DURATION_IFRS) INVENTORY_DURATION,
			</cfif>
			I.ACCOUNT_PERIOD,
			ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID) EXPENSE_ITEM_ID,
			ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID) EXPENSE_CENTER_ID,
			<cfif go_ifrs eq 0>I.AMORTIZATION_COUNT<cfelse>I.AMORTIZATION_COUNT_IFRS AMORTIZATION_COUNT</cfif>,
			<cfif go_ifrs eq 0>I.AMORT_LAST_VALUE<cfelse>I.AMORT_LAST_VALUE_IFRS AMORT_LAST_VALUE</cfif>,
			I.AMORTIZATION_TYPE,
			(SELECT 
				COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
			FROM 
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA,
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA,
				</cfif>
				INVENTORY_AMORTIZATION_MAIN IAM
			WHERE 
				I.INVENTORY_ID = IA.INVENTORY_ID
				AND IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
				AND YEAR(IAM.ACTION_DATE) = #year(attributes.process_date)#) INV_COUNT,
            (SELECT TOP 1
				ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
			FROM 
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA2
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA2
				</cfif>
			WHERE 
				I.INVENTORY_ID = IA2.INVENTORY_ID
			ORDER BY 
            	AMORTIZATION_ID DESC) PARTIAL_AMORTIZATION_VALUE,
            (SELECT TOP 1
				ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
			FROM 
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA2
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA2
				</cfif>
			WHERE 
				I.INVENTORY_ID = IA2.INVENTORY_ID AND
              	IA2.AMORTIZATON_YEAR = YEAR(I.ENTRY_DATE)
			ORDER BY 
            	AMORTIZATION_ID DESC) FIRST_PARTIAL_AMORTIZATION_VALUE
		FROM
			INVENTORY I
			LEFT JOIN INVENTORY_HISTORY ON INVENTORY_HISTORY.INVENTORY_ID=I.INVENTORY_ID AND INVENTORY_HISTORY.ACTION_DATE<=#attributes.process_date# AND INVENTORY_HISTORY_ID=(SELECT TOP 1 IH.INVENTORY_HISTORY_ID FROM INVENTORY_HISTORY IH WHERE IH.INVENTORY_ID = I.INVENTORY_ID AND IH.ACTION_DATE<=#attributes.process_date# ORDER BY IH.ACTION_DATE DESC),
			INVENTORY_ROW,
			INVENTORY_ROW INVENTORY_ROW_2
			<cfif len(attributes.last_amortization_year)>
				<cfif go_ifrs eq 0>
					,INVENTORY_AMORTIZATON INVENTORY_AMORTIZATON
				<cfelse>
					,INVENTORY_AMORTIZATON_IFRS INVENTORY_AMORTIZATON
				</cfif>
			</cfif>
		WHERE
			INVENTORY_ROW.INVENTORY_ID = I.INVENTORY_ID AND
			INVENTORY_ROW_2.INVENTORY_ID = I.INVENTORY_ID AND
			INVENTORY_ROW.STOCK_IN >= 0 AND 
			I.ENTRY_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND 
			I.ENTRY_DATE <= #attributes.process_date# AND 
			INVENTORY_ROW_2.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
			<cfif isDefined("attributes.invent_acc_id") and len(attributes.invent_acc_id) and len(attributes.invent_acc_name)>
				AND ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) = '#attributes.invent_acc_id#'
			</cfif>
			<cfif len(attributes.last_amortization_year)>
				AND I.INVENTORY_ID = INVENTORY_AMORTIZATON.INVENTORY_ID
				AND INVENTORY_AMORTIZATON.AMORTIZATION_ID = (SELECT TOP 1 INVV.AMORTIZATION_ID FROM INVENTORY_AMORTIZATON INVV,INVENTORY_AMORTIZATION_MAIN INVV_MAIN WHERE INVV.INVENTORY_ID = I.INVENTORY_ID AND INVV.INV_AMORT_MAIN_ID = INVV_MAIN.INV_AMORT_MAIN_ID ORDER BY INVV_MAIN.RECORD_DATE DESC)
				AND INVENTORY_AMORTIZATON.AMORTIZATON_YEAR = #Year(attributes.last_amortization_year)#
			</cfif>
			<cfif isDefined("attributes.amor_method") and len(attributes.amor_method)>
				AND I.AMORTIZATON_METHOD = #attributes.amor_method#
			</cfif>
			<cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
				AND I.INVENTORY_TYPE IN(#attributes.inventory_type#)
			</cfif>
			<cfif isDefined("attributes.account_period_list") and len(attributes.account_period_list)>
				AND I.ACCOUNT_PERIOD = #attributes.account_period_list#
			</cfif>
			AND I.LAST_INVENTORY_VALUE > 0
			AND I.AMORTIZATON_ESTIMATE > 0
		GROUP BY
			<cfif len(attributes.last_amortization_year)>
				INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
			</cfif>
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.PROCESS_CAT,
			I.QUANTITY,
			ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE),
			I.AMORTIZATON_METHOD,
			I.AMOUNT,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.COMP_PARTNER_ID,
			I.LAST_INVENTORY_VALUE,
			ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID),
			ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID),
			ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID),
			<cfif go_ifrs eq 0>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION),
			<cfelse>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION_IFRS,I.INVENTORY_DURATION_IFRS),
			</cfif>
			I.ACCOUNT_PERIOD,
			ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID),
			ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID),
			I.AMORTIZATION_COUNT,
			I.AMORT_LAST_VALUE,
			I.AMORTIZATION_TYPE
		HAVING
			SUM(ISNULL(INVENTORY_ROW_2.STOCK_IN,0)-ISNULL(INVENTORY_ROW_2.STOCK_OUT,0)) > 0
	</cfquery>
	<cfset attributes.all_records = GET_INVENT.recordcount>
	<cfoutput query="GET_INVENT">
		<cfset new_value = 0>	
		<cfset diff_value = 0>	
		<cfif miktar gt 0>
			<cfset "attributes.invent_row#currentrow#" = INVENTORY_ID>
			<cfset "attributes.inventory_id#currentrow#" = INVENTORY_ID>
			<cfset "attributes.amortization_method#currentrow#" = AMORTIZATON_METHOD>
			<cfset "attributes.amortization_rate#currentrow#" = AMORTIZATON_ESTIMATE>
			<cfset "attributes.account_id#currentrow#" = ACCOUNT_ID>
			<cfquery name="get_inv_count" datasource="#dsn3#">
				SELECT INVENTORY_ID FROM <cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif> WHERE INVENTORY_ID = #INVENTORY_ID#
			</cfquery>
			<cfquery name="get_inv_control" datasource="#dsn3#">
				SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE INVENTORY_ID = #INVENTORY_ID# AND PROCESS_TYPE = 1181
			</cfquery>
			<cfif len(amortization_count) and amortization_count gt 0 and amortization_count lt get_invent.account_period>
				<cfset "attributes.amortization_count#currentrow#" = amortization_count>
			<cfelse>
				<cfset "attributes.amortization_count#currentrow#" = 0>
			</cfif>
			<cfset "attributes.invent_name#currentrow#" = INVENTORY_NAME>
			<cfset "attributes.quantity#currentrow#" = miktar>
			<cfset "attributes.debt_acc_id#currentrow#" = debt_account_id>
			<cfset "attributes.debt_acc#currentrow#" = debt_account_id>
			<cfset "attributes.claim_acc_id#currentrow#" = claim_account_id>
			<cfset "attributes.claim_acc#currentrow#" = claim_account_id>
			<cfset "attributes.expense_center_id#currentrow#" = EXPENSE_CENTER_ID>
			<cfset "attributes.expense_item_id#currentrow#" = EXPENSE_ITEM_ID>
			<cfif not len(LAST_INVENTORY_VALUE)>
				<cfset "attributes.last_value#currentrow#" = AMOUNT>
			<cfelse>
				<cfset "attributes.last_value#currentrow#" = LAST_INVENTORY_VALUE>
			</cfif>
			<cfset amort_last_value_ = ''>
			<cfif inv_count eq 0>
				<cfquery name="UPD_INVENTORY" datasource="#dsn3#">
					UPDATE
						INVENTORY
					SET
						<cfif go_ifrs eq 0>AMORT_LAST_VALUE<cfelse>AMORT_LAST_VALUE_IFRS</cfif> = #last_inventory_value#
					WHERE
						INVENTORY_ID = #inventory_id#
				</cfquery>
				<cfset amort_last_value_ = last_inventory_value>
			</cfif>
			<cfset last_inv_year = year(entry_date)+inventory_duration-1>
            <cfif kist_method eq 1 and amortization_type eq 1>
                <cfif year(attributes.process_date)-year(entry_date) eq 1 and inv_count eq 0>
                    <cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE - PARTIAL_AMORTIZATION_VALUE>			
                </cfif>
                <cfif last_inv_year eq year(attributes.process_date) and inv_count eq 0>
                    <cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE + FIRST_PARTIAL_AMORTIZATION_VALUE>	
                </cfif>
            </cfif>
            <!--- devirden geliyorsa ve bir sonraki yilin ilk degerlemesi ise --->
			<cfif attributes.inventory_type eq 1 and kist_method eq 1 and year(attributes.process_date)-year(entry_date) eq 1 and inv_count eq 0>
                <cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE - FIRST_PARTIAL_AMORTIZATION_VALUE>	
            </cfif>
		<!---	<cfif (listfind("0,2",AMORTIZATON_METHOD) and kist_method eq 1 and attributes.inventory_type eq 1) and year(attributes.process_date) is last_inv_year>--->
            <cfif (listfind("0,2",AMORTIZATON_METHOD) or kist_method eq 1) and year(attributes.process_date) is last_inv_year>
				<cfif len(amort_last_value_)>
                    <cfset diff_value = amort_last_value_>
                <cfelse>
                    <cfset diff_value = AMORT_LAST_VALUE>
                </cfif>
                <cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
			<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(amort_last_value_)>
				<cfset diff_value = (amort_last_value_*AMORTIZATON_ESTIMATE)/100>
				<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
			<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMORT_LAST_VALUE)>
				<cfset diff_value = (AMORT_LAST_VALUE*AMORTIZATON_ESTIMATE)/100>
				<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
			<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
				<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
				<cfset new_value = AMOUNT - diff_value/account_period>
			<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
				<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
				<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
			<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
				<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
				<cfset new_value = AMOUNT - diff_value/account_period>
			</cfif>
			<cfset period_value=diff_value/get_invent.account_period>
            <!--- TODO --->
			<cfif kist_method eq 1 or (amortization_type eq 1 and get_inv_count.recordcount eq 0 and get_inv_control.recordcount eq 0)>
				<cfset period_value_month = diff_value/12>
            <cfelse>
                <cfset period_value_month = diff_value/get_invent.account_period>     
            </cfif>
			<cfif amortization_type eq 2 and get_inv_count.recordcount eq 0 and get_inv_control.recordcount eq 0><!--- ilk değerlemeyse ve Kıst amortismana tabi değilse önceki aylarında değerlemesi eklenecek --->
				<cfset month_value_ = 12/get_invent.account_period>
				<cfset month_value = (month(attributes.process_date)-month(session.ep.period_start_date)+1)/month_value_>
                <cfif month_value lt 0><cfset month_value = 0></cfif>
                <cfset old_month_value = period_value_month *  month_value>
                <cfset period_value = 0>
				<cfif listfind("0,2",AMORTIZATON_METHOD)and len(AMORT_LAST_VALUE)>
					<cfset new_value = LAST_INVENTORY_VALUE >
				<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
					<cfset new_value = AMOUNT >
				<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
					<cfset new_value = LAST_INVENTORY_VALUE >
				<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
					<cfset new_value = AMOUNT>
				</cfif>
			<cfelseif amortization_type eq 1 and get_inv_count.recordcount eq 0 and get_inv_control.recordcount eq 0 ><!--- ilk değerlemeyse ve Kıst amortismana tabi ise alındığı aydan sonraki aylar için de değerleme yapılacak --->
				<cfset month_value = month(attributes.process_date) - month(entry_date) + 1>
				<cfif month_value lt 0><cfset month_value = 0></cfif>
                <cfset period_value = 0>
                <cfset old_month_value = period_value_month *  month_value>
				<cfif listfind("0,2",AMORTIZATON_METHOD)and len(AMORT_LAST_VALUE)>
					<cfset new_value = LAST_INVENTORY_VALUE >
				<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
					<cfset new_value = AMOUNT >
				<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
					<cfset new_value = LAST_INVENTORY_VALUE >
				<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
					<cfset new_value = AMOUNT>
				</cfif>
			<cfelse>
				<cfset old_month_value = 0>
				<cfset month_value = 0>
			</cfif>
			<cfif amortization_type eq 2>
				<cfif len(inventory_duration)>
					<cfset last_inv_date = '31/12/#year(entry_date)+inventory_duration-1#'>
				<cfelse>
					<cfset last_inv_date = '31/12/#year(entry_date)#'>
				</cfif>
			<cfelse>
				<cfset month_value = DaysInMonth(entry_date)>
				<cfset zero = ''>
				<cfloop from="1" to="#2-len(month(entry_date))#" index="kk">
					<cfset zero = '0#zero#'>
				</cfloop>
				<cfif len(inventory_duration)>
					<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#inventory_duration+year(entry_date)#'>
				<cfelse>
					<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#year(entry_date)#'>
				</cfif>
			</cfif>
			<cfset period_value = period_value + old_month_value>
			<cfset new_value = new_value - old_month_value>
			<cfif month(entry_date) eq 2>
				<cftry>
					<cfset last_inv_date = createodbcdate(last_inv_date)>
					<cfcatch type="any">
						<cfset month_value= month_value - 1>
						<cfif len(inventory_duration)>
							<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#inventory_duration+year(entry_date)#'>
						<cfelse>
							<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#year(entry_date)#'>
						</cfif>
						<cfset last_inv_date = createodbcdate(last_inv_date)>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset last_inv_date = createodbcdate(last_inv_date)>	
			</cfif>
			<cfif amortization_type eq 2 and attributes.process_date gte last_inv_date>
			<!--- Kıst amotrismana tabi değilse Giriş Yılı+ Faydalı Ömür toplamını alacağız. Çıkan sonucun 31.12 tarihi ömrünün bitişi tarihidir. 1 Mayıs 2012 de adıysam ve faydalı ömür 5 yıl ise 31/12/2016 da bitecektir. --->
				<cfset period_value = last_inventory_value>
				<cfset new_value = 0>
			<cfelseif amortization_type eq 1 and attributes.process_date gte last_inv_date>
			<!--- Kıst amortismana tabi isede 1 Mayıs 2012 de aldıysam 31/Mayıs/2017 de ömrü biter --->
				<cfset period_value = last_inventory_value>
				<cfset new_value = 0>
			</cfif>
            <cfif listfind("0,2",AMORTIZATON_METHOD) and year(attributes.process_date) is last_inv_year>
				<cfset period_value = diff_value/account_period>
            </cfif>
			<cfset total_amortization = period_value*miktar>
			<cfset "attributes.diff_value#currentrow#" = diff_value>
			<cfset "attributes.hd_period#currentrow#" = account_period>
			<cfset "attributes.period#currentrow#" = account_period>
			<cfset "attributes.new_inventory_value#currentrow#" = new_value>
			<cfset "attributes.period_diff_value#currentrow#" = period_value>
			<cfset "attributes.total_amortization#currentrow#" = total_amortization>
			<cfset "attributes.new_value#currentrow#" = new_value>
            <cfif len(partial_amortization_value)>
				<cfset "attributes.partial_amortization_value#currentrow#" = partial_amortization_value-period_value>
            <cfelse>
            	<cfset "attributes.partial_amortization_value#currentrow#" = diff_value-period_value>
            </cfif>
		</cfif>
	</cfoutput>
</cfif>
<cfif isdefined("attributes.all_records") and attributes.all_records gt 0>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="ADD_INVENT_MAIN" datasource="#DSN2#" result="MAX_ID">
				INSERT INTO
					#dsn3_alias#.INVENTORY_AMORTIZATION_MAIN
					(
						PROCESS_TYPE,
						PROCESS_CAT,
						ACTION_DATE,
						DETAIL,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						ACCOUNTING_TYPE
					  )
					VALUES
					(
						#process_type#,
						#process_cat#,
						#attributes.process_date#,
						<cfif isdefined("attributes.detail") and len(attributes.detail)>'#left(attributes.detail,500)#',<cfelse>NULL,</cfif>
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#go_ifrs#
					)
			</cfquery>
			<cfloop from="1" to="#attributes.all_records#" index="i">
				<cfif isdefined("attributes.invent_row#i#")>
					<cfif kontrol_inv eq 0>
						<cfscript>
							"attributes.new_inventory_value#i#" = filterNum(evaluate("attributes.new_inventory_value#i#"));
							"attributes.diff_value#i#" = filterNum(evaluate("attributes.diff_value#i#"));
							"attributes.period_diff_value#i#" = filterNum(evaluate("attributes.period_diff_value#i#"));
							"attributes.new_value#i#" = filterNum(evaluate("attributes.new_value#i#"));
							"attributes.total_amortization#i#" = filterNum(evaluate("attributes.total_amortization#i#"));
							"attributes.partial_amortization_value#i#" = filterNum(evaluate("attributes.partial_amortization_value#i#"));
						</cfscript>
					</cfif>
					<cfquery name="get_INVENTORY" datasource="#dsn2#">
						SELECT AMORTIZATON_METHOD FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.inventory_id#i#")#">
					</cfquery>
					<cfquery name="UPD_INVENTORY" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.INVENTORY
						SET
							<cfif go_ifrs eq 0>LAST_INVENTORY_VALUE<cfelse>LAST_INVENTORY_VALUE_IFRS</cfif> = #evaluate("attributes.new_value#i#")#,
							<cfif go_ifrs eq 0>LAST_INVENTORY_VALUE_2<cfelse>LAST_INVENTORY_VALUE_2_IFRS</cfif> = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.new_value#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
							<cfif go_ifrs eq 0>AMORTIZATION_COUNT<cfelse>AMORTIZATION_COUNT_IFRS</cfif> = #evaluate("attributes.amortization_count#i#")+1#
							<cfif get_INVENTORY.AMORTIZATON_METHOD neq 0> <!--- azalan bakiyeyse güncellenmesin  --->
							<cfif isdefined("attributes.amort_value#i#")>
								,<cfif go_ifrs eq 0>AMORT_LAST_VALUE<cfelse>AMORT_LAST_VALUE_IFRS</cfif> = #evaluate("attributes.amort_value#i#")#
							</cfif>
							</cfif>
						WHERE
							INVENTORY_ID = #evaluate("attributes.inventory_id#i#")#
					</cfquery>
					<cfquery name="ADD_AMORTIZATION" datasource="#dsn2#">
						INSERT INTO
							#dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif>
							(
								INVENTORY_ID,
								INV_AMORT_MAIN_ID,
								AMORTIZATON_VALUE,
								PERIODIC_AMORT_VALUE,
								AMORTIZATON_METHOD,
								AMORTIZATON_YEAR,
								AMORTIZATON_ESTIMATE,
								AMORTIZATON_INV_VALUE,
								DEBT_ACCOUNT_ID,
								CLAIM_ACCOUNT_ID,
								ACCOUNT_PERIOD,
								INV_QUANTITY,
                                PARTIAL_AMORTIZATION_VALUE <!--- TODO --->
							)
							VALUES
							(
								#evaluate("attributes.inventory_id#i#")#,
								#MAX_ID.IDENTITYCOL#,
								#evaluate("attributes.new_value#i#")#,
								#evaluate("attributes.period_diff_value#i#")#,
								#evaluate("attributes.amortization_method#i#")#,
								#Year(attributes.process_date)#,
								#evaluate("attributes.amortization_rate#i#")#,
								#evaluate("attributes.diff_value#i#")#,
								<cfif len(evaluate("attributes.debt_acc_id#i#"))>'#wrk_eval("attributes.debt_acc_id#i#")#'<cfelse>'#attributes.amort_debt_acc_id#'</cfif>,
								<cfif len(evaluate("attributes.claim_acc_id#i#"))>'#wrk_eval("attributes.claim_acc_id#i#")#'<cfelse>'#attributes.amort_claim_acc_id#'</cfif>,
								<cfif len(evaluate("attributes.period#i#"))>'#wrk_eval("attributes.period#i#")#'<cfelse>'#attributes.period#'</cfif>,
								#evaluate("attributes.quantity#i#")#,
                                #evaluate("attributes.partial_amortization_value#i#")# <!--- TODO --->
 							)
					</cfquery>
					<cfscript>
						if(len(evaluate("attributes.debt_acc_id#i#")))
							borc_hesaplar_list = ListAppend(borc_hesaplar_list,evaluate("attributes.debt_acc_id#i#"));
						else
							borc_hesaplar_list =ListAppend(borc_hesaplar_list,'#attributes.amort_debt_acc_id#');
						if(len(evaluate("attributes.claim_acc_id#i#")))	
							alacak_hesaplar_list=ListAppend(alacak_hesaplar_list,evaluate("attributes.claim_acc_id#i#"));
						else
							alacak_hesaplar_list=ListAppend(alacak_hesaplar_list,'#attributes.amort_claim_acc_id#');
						borc_tutarlar_list=ListAppend(borc_tutarlar_list,evaluate("attributes.total_amortization#i#"));
						alacak_tutarlar_list=ListAppend(alacak_tutarlar_list,evaluate("attributes.total_amortization#i#"));
						if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")))
						{
							acc_project_id = listappend(acc_project_id,evaluate("attributes.project_id#i#"),',');
							acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),',');
							acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#i#"),',');
						}
						else
						{
							acc_project_id = listappend(acc_project_id,'0',',');
							acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
							acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
						}
					</cfscript>
				</cfif>
			</cfloop>
			<cfscript>
			if(is_account eq 1)
			{
				FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
				//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
				str_fark_gelir =FARK_HESAP.FARK_GELIR;
				str_fark_gider =FARK_HESAP.FARK_GIDER;
				str_max_round = 0.09;
				str_round_detail = UCase(getLang('main',2747));//AMORTİSMAN YENİDEN DEĞERLEME
				card_id = muhasebeci (
					action_id:MAX_ID.IDENTITYCOL,
					workcube_process_type : process_type,
					account_card_type : 13,
					islem_tarihi : attributes.process_date,
					borc_hesaplar : borc_hesaplar_list,
					borc_tutarlar : borc_tutarlar_list,
					alacak_hesaplar : alacak_hesaplar_list,
					alacak_tutarlar : alacak_tutarlar_list,
					is_account_group : is_account_group,
					to_branch_id:listgetat(session.ep.user_location,2,'-'),
					fis_satir_detay: UCase(getLang('main',2747)),
					fis_detay : UCase(getLang('main',2747)),
					currency_multiplier : currency_multiplier,
					workcube_process_cat : form.process_cat,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
					dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
					round_row_detail:str_round_detail//,
					//acc_project_id : acc_project_id Proje liste olarak yollanıyor bu şekilde yollanmasına gerek yok
				);
			}
			 if(is_budget eq 1)
				{
					for(j=1;j lte attributes.all_records;j=j+1)
					{
						if (isdefined("attributes.invent_row#j#"))
						{
							net_total=evaluate("attributes.total_amortization#j#");
							if (len(evaluate("attributes.expense_item_id#j#")) and len(evaluate("attributes.expense_center_id#j#")))
							butceci(
								action_id : MAX_ID.IDENTITYCOL,
								muhasebe_db : dsn2,
								is_income_expense : false,
								process_type : process_type,
								nettotal : wrk_round(net_total),
								action_currency : session.ep.money,
								other_money_value : wrk_round(net_total/currency_multiplier),
								currency_multiplier : currency_multiplier,
								expense_date : attributes.process_date,
								expense_center_id : evaluate("attributes.expense_center_id#j#"),
								expense_item_id : evaluate("attributes.expense_item_id#j#"),
								detail : '#evaluate("attributes.invent_name#j#")#',
								branch_id : ListGetAt(session.ep.user_location,2,"-"),
								insert_type :1,
								project_id:'#evaluate("attributes.project_id#j#")#'
								);
							}
					}
				}
			</cfscript>
		<!---	<cfif go_ifrs eq 0>
				<cfquery name = "del_acc_card_rows" datasource = "#dsn2#">
					DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID = #card_id#
				</cfquery>
			<cfelseif attributes.accounting_target eq 1>
				<cfquery name = "del_acc_card_rows" datasource = "#dsn2#">
					DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #card_id#
				</cfquery>
			</cfif> --->
			<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
				<cf_workcube_process_cat 
					process_cat="#form.process_cat#"
					action_id = #MAX_ID.IDENTITYCOL#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>
		</cftransaction>
	</cflock>	
</cfif>

<cfset attributes.actionId=MAX_ID.IDENTITYCOL />
<script type="text/javascript">
	window.location.href = "#request.self#?fuseaction=invent.list_invent_amortization&event=upd&inv_id=#MAX_ID.IDENTITYCOL#";
</script>
