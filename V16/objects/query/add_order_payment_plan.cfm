<cf_date tarih ='attributes.revenue_start_date'>
<cf_date tarih ='attributes.ACTION_DATE'>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_PAYMENT_PLAN" datasource="#dsn3#">
			DELETE FROM ORDER_PAYMENT_PLAN_ROWS WHERE PAYMENT_PLAN_ID = (SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE  ACTION_ID=#attributes.paper_action_id#)
		</cfquery>
		<cfquery name="DEL_PAYMENT_PLAN_ROWS" datasource="#dsn3#">
			DELETE FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.paper_action_id#
		</cfquery>
    	<cfquery name="GET_PAYMENT_PLAN" datasource="#dsn3#">
        	INSERT INTO
            	ORDER_PAYMENT_PLAN
            (
                ACTION_ID,
                PAYMETHOD_ID,
                DUE_DATE,
                ACTION_DATE,
                NETTOTAL,
                OTHER_MONEY_TOTAL,
                OTHER_MONEY,
                DUE_MONTH,
                CASH_PAYMENT,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
            )
            VALUES
            (
            	<cfif len(attributes.paper_action_id)>#attributes.paper_action_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
                #attributes.revenue_start_date#,              
                #attributes.paper_action_date#,
                <cfif len(attributes.net_total_system)>#attributes.net_total_system#<cfelse>NULL</cfif>,                
                <cfif len(attributes.net_total)>#attributes.net_total#<cfelse>NULL</cfif>,                
                <cfif len(paper_money)>'#paper_money#'<cfelse>NULL</cfif>,                
                <cfif len(attributes.due_month)>#attributes.due_month#<cfelse>NULL</cfif>,                
                <cfif len(attributes.cash_payment)>#attributes.cash_payment#<cfelse>NULL</cfif>,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#
            )          
        </cfquery>
        <cfquery name="GET_ACTION_ID" datasource="#dsn3#">
        	SELECT MAX(PAYMENT_PLAN_ID) AS MAX_PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN
        </cfquery>
        <cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
				<cf_date tarih='attributes.due_date#i#'>
                <cfquery name="GET_PAYMENT_PLAN_ROWS" datasource="#dsn3#">
                    INSERT INTO
                        ORDER_PAYMENT_PLAN_ROWS
                    (
                        PAYMENT_PLAN_ID,
                        DETAIL,
                        DUEDATE,
                        PAYMENT_AMOUNT,
                        OTHER_MONEY_VALUE,
                        OTHER_MONEY,
                        IS_CASH_PAYMENT,
						ROW_DETAIL
                    )
                    VALUES
                    (
                        #GET_ACTION_ID.MAX_PAYMENT_PLAN_ID#,
                        <cfif isdefined('attributes.voucher_name#i#') and len(evaluate('attributes.voucher_name#i#'))>'#wrk_eval("attributes.voucher_name#i#")#'</cfif>,
                        <cfif isdefined('attributes.due_date#i#') and len(evaluate('attributes.due_date#i#'))>#evaluate('attributes.due_date#i#')#</cfif>,
                        <cfif isdefined('attributes.voucher_system_value#i#') and len(evaluate('attributes.voucher_system_value#i#'))>#evaluate('attributes.voucher_system_value#i#')#</cfif>,
                        <cfif isdefined('attributes.voucher_value#i#') and len(evaluate('attributes.voucher_value#i#'))>#evaluate('attributes.voucher_value#i#')#</cfif>,
                        <cfif isdefined('attributes.money_type#i#') and len(evaluate('attributes.money_type#i#'))>'#wrk_eval("attributes.money_type#i#")#'</cfif>,
                        <cfif isdefined('attributes.is_cash_row#i#') and len(evaluate('attributes.is_cash_row#i#'))>#evaluate('attributes.is_cash_row#i#')#</cfif>,
						<cfif isdefined('attributes.row_detail#i#') and len(evaluate('attributes.row_detail#i#'))>'#evaluate('attributes.row_detail#i#')#'<cfelse>NULL</cfif>
                    )
                </cfquery>
			</cfif>
        </cfloop>
    </cftransaction>
</cflock>
