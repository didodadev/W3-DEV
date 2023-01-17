<!---BU POPUP İÇERİSİNDEN Mahsup Fişi No POPUPI DA ÇAĞRILMAKTADIR. BU NEDENLE POPUP İÇERİSİN DE BAŞKA BİR POPUP ÇAĞRILMAKTADIR.--->
<cfif isdefined("attributes.order_id")>
	<cfquery name="get_order_acts" datasource="#dsn3#">
		SELECT
			*
		FROM
		(
			SELECT
				CASH_ID ACTION_ID,
				31 AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = CASH_ID
				AND AC.ACTION_TYPE = 31
				AND CASH_ID IS NOT NULL
				AND KASA_PERIOD_ID = #session.ep.period_id#
				AND (ORDER_CASH_POS.IS_CANCEL = 0  OR ORDER_CASH_POS.IS_CANCEL IS NULL)
				AND AC.IS_CANCEL = 0
			UNION ALL
			
			SELECT
				POS_ACTION_ID ACTION_ID,
				241 AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = POS_ACTION_ID
				AND AC.ACTION_TYPE = 241
				AND POS_ACTION_ID IS NOT NULL
				AND (ORDER_CASH_POS.IS_CANCEL = 0  OR ORDER_CASH_POS.IS_CANCEL IS NULL)
				AND AC.IS_CANCEL = 0
			UNION ALL
			
			SELECT
				CASH_ID ACTION_ID,
				32 AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = CASH_ID
				AND AC.ACTION_TYPE = 32
				AND CASH_ID IS NOT NULL
				AND KASA_PERIOD_ID = #session.ep.period_id#
				AND ORDER_CASH_POS.IS_CANCEL = 1
				
			UNION ALL
			
			SELECT
				POS_ACTION_ID ACTION_ID,
				245 AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = POS_ACTION_ID
				AND AC.ACTION_TYPE = 245
				AND POS_ACTION_ID IS NOT NULL
				AND ORDER_CASH_POS.IS_CANCEL = 1
				
			UNION ALL
			
			SELECT
				P.ACTION_ID,
				PAYROLL_TYPE AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				#dsn2_alias#.VOUCHER_PAYROLL P,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				PAYMENT_ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = P.ACTION_ID
				AND AC.ACTION_TYPE = PAYROLL_TYPE
				
			UNION ALL
			
			SELECT
				P.ACTION_ID,
				PAYROLL_TYPE AS PROCESS_TYPE,
                AC.CARD_ID,
				BILL_NO,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG
			FROM
				#dsn2_alias#.PAYROLL P,
				#dsn2_alias#.ACCOUNT_CARD AC
			WHERE
				PAYMENT_ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = P.ACTION_ID
				AND AC.ACTION_TYPE = PAYROLL_TYPE
                
            UNION ALL
           <!--- Birleştirilmiş fişler ---> 
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = CASH_ID
				AND AC.ACTION_TYPE = 31
				AND CASH_ID IS NOT NULL
				AND KASA_PERIOD_ID = #session.ep.period_id#
				AND IS_CANCEL = 0
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = POS_ACTION_ID
				AND AC.ACTION_TYPE = 241
				AND POS_ACTION_ID IS NOT NULL
				AND IS_CANCEL = 0
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = CASH_ID
				AND AC.ACTION_TYPE = 32
				AND CASH_ID IS NOT NULL
				AND KASA_PERIOD_ID = #session.ep.period_id#
				AND IS_CANCEL = 1
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				ORDER_CASH_POS,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = POS_ACTION_ID
				AND AC.ACTION_TYPE = 245
				AND POS_ACTION_ID IS NOT NULL
				AND IS_CANCEL = 1
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				#dsn2_alias#.VOUCHER_PAYROLL P,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				PAYMENT_ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = P.ACTION_ID
				AND AC.ACTION_TYPE = PAYROLL_TYPE
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			SELECT
            	AC.ACTION_ID,
				AC.ACTION_TYPE,
                AC.CARD_ID,
				AC.BILL_NO,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG
			FROM
				#dsn2_alias#.PAYROLL P,
				#dsn2_alias#.ACCOUNT_CARD_SAVE AC
			WHERE
				PAYMENT_ORDER_ID = #attributes.order_id#
				AND AC.ACTION_ID = P.ACTION_ID
				AND AC.ACTION_TYPE = PAYROLL_TYPE
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
		)T1
		ORDER BY
			CARD_ID
	</cfquery>
<cfelseif isdefined("attributes.invoice_id")>
	<cfquery name="get_credit" datasource="#dsn2#">
        SELECT
            AC.ACTION_ID,
            242 AS PROCESS_TYPE,
            BILL_NO
        FROM
            ACCOUNT_CARD AC,
            #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE
        WHERE
            INVOICE_ID =  #attributes.invoice_id#
            AND AC.ACTION_TYPE = 242
			AND AC.ACTION_ID = CCBE.CREDITCARD_EXPENSE_ID
	</cfquery>
	<cfif get_credit.recordcount>
		<cfquery name="get_order_acts" datasource="#dsn2#">
            SELECT
                AC.ACTION_ID,
                242 AS PROCESS_TYPE,
                BILL_NO,
                0 FLAG
            FROM
                ACCOUNT_CARD AC,
                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE
            WHERE
                INVOICE_ID =  #attributes.invoice_id#
                AND AC.ACTION_TYPE = 242
                AND AC.ACTION_ID = CCBE.CREDITCARD_EXPENSE_ID
            UNION ALL
            
            <!--- Alis ve Satis Faturalari --->
            SELECT
                ACTION_ID,
                AC.ACTION_TYPE AS PROCESS_TYPE,
                BILL_NO,
                0 FLAG
            FROM		
                ACCOUNT_CARD AC
            WHERE
                AC.ACTION_TYPE IN (48,49,50,51,53,54,55,56,561,57,58,59,60,601,61,62,63,64,640,680,690,691,65,66,68,531,532,591,533,242,5311,661,651,5312)
                AND AC.ACTION_ID = #attributes.invoice_id#	
		</cfquery>
    <cfelse>
        <cfquery name="get_order_acts" datasource="#dsn2#">
            SELECT
                *
            FROM
            (
                <!--- Kredi Kartı Tahsilat --->
                SELECT
                    POS_ACTION_ID ACTION_ID,     
                    241 AS PROCESS_TYPE,
                    BILL_NO,
                    ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
                    AC.CARD_ID,
                    0 NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    0 FLAG
                FROM
                    INVOICE_CASH_POS,
                    ACCOUNT_CARD AC
                WHERE
                    INVOICE_ID = #attributes.invoice_id#
                    AND AC.ACTION_ID = POS_ACTION_ID
                    AND AC.ACTION_TYPE = 241
                    AND POS_PERIOD_ID = #session.ep.period_id#
                
                UNION ALL	

				<!---  Banka ---> 
				SELECT
					AC.ACTION_ID,
					<cfif isDefined("attributes.is_income")>24 AS PROCESS_TYPE,<cfelse>25 AS PROCESS_TYPE,</cfif>
					BILL_NO,
					ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
					AC.CARD_ID,
					0 NEW_CARD_ID,
					AC.CARD_TYPE_NO,
					0 FLAG
				FROM
					ACCOUNT_CARD AC,
					BANK_ACTIONS
				WHERE
					BILL_ID = #attributes.invoice_id#
					<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 24<cfelse>AND AC.ACTION_TYPE = 25</cfif>
					AND AC.ACTION_ID = BANK_ACTIONS.ACTION_ID

				UNION ALL
                
                   
                <!--- Tahsilat (Kasa) --->
                SELECT
                    CASH_ID ACTION_ID,
                    35 AS PROCESS_TYPE,
                    BILL_NO,
                    ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
                    AC.CARD_ID,
                    0 NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    0 FLAG
                FROM
                    INVOICE_CASH_POS,
                    ACCOUNT_CARD AC
                WHERE
                    INVOICE_ID = #attributes.invoice_id#
                    AND AC.ACTION_ID = CASH_ID
                    AND AC.ACTION_TYPE = 35
                    
                UNION ALL
                
                <!--- Perakende Satış Faturası --->
                SELECT
                    ACTION_ID,
                    52 AS PROCESS_TYPE,
                    BILL_NO,
                    ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
                    AC.CARD_ID,
                    0 NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    0 FLAG
                FROM		
                    ACCOUNT_CARD AC
                WHERE
                    AC.ACTION_TYPE = 52
                    AND AC.ACTION_ID = #attributes.invoice_id#	
                
                UNION ALL
                
                <!--- Alis ve Satis Faturalari --->
                SELECT
                    ACTION_ID,
                    AC.ACTION_TYPE AS PROCESS_TYPE,
                    BILL_NO,
                    ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
                    AC.CARD_ID,
                    0 NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    0 FLAG
                FROM		
                    ACCOUNT_CARD AC
                WHERE
                    AC.ACTION_TYPE IN (48,49,50,51,53,54,55,56,561,57,58,59,60,601,61,62,63,64,640,680,690,691,65,66,68,531,532,591,533,5311,661,651,5312)
                    AND AC.ACTION_ID = #attributes.invoice_id#	
            
                UNION ALL
                
                <!--- Nakit İşlem  --->
                SELECT
                    AC.ACTION_ID,
                    CA.ACTION_TYPE_ID AS PROCESS_TYPE,
                    AC.BILL_NO,
                    ISNULL(AC.IS_CANCEL,0) IS_CANCEL,
                    AC.CARD_ID,
                    0 NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    0 FLAG
                FROM
                    INVOICE I,
                    CASH_ACTIONS CA,
                    ACCOUNT_CARD AC
                WHERE
                    I.INVOICE_ID = #attributes.invoice_id#
                    AND I.CASH_ID = CA.ACTION_ID
                    AND I.CASH_ID = AC.ACTION_ID
                    AND AC.ACTION_TYPE IN (34,35)
                    
                UNION ALL
                <!--- Birleştirilmiş fişler --->
                <!--- Kredi Kartı Tahsilat --->
                SELECT
                    0 ACTION_ID,
                    0 PROCESS_TYPE,
                    0 BILL_NO,
                    0 IS_CANCEL,
                    AC.CARD_ID,
                    AC.NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    1 FLAG
                FROM
                    INVOICE_CASH_POS,
                    ACCOUNT_CARD_SAVE AC
                WHERE
                    INVOICE_ID = #attributes.invoice_id#
                    AND AC.ACTION_ID = POS_ACTION_ID
                    AND AC.ACTION_TYPE = 241
                    AND POS_PERIOD_ID = #session.ep.period_id#
                    AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
                    
                UNION ALL
                
                <!--- Tahsilat (Kasa) --->
                SELECT
                    0 ACTION_ID,
                    0 PROCESS_TYPE,
                    0 BILL_NO,
                    0 IS_CANCEL,
                    AC.CARD_ID,
                    AC.NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    1 FLAG
                FROM
                    INVOICE_CASH_POS,
                    ACCOUNT_CARD_SAVE AC
                WHERE
                    INVOICE_ID = #attributes.invoice_id#
                    AND AC.ACTION_ID = CASH_ID
                    AND AC.ACTION_TYPE = 35
                    AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
                    
                UNION ALL
                
                <!--- Perakende Satış Faturası --->
                SELECT
                    0 ACTION_ID,
                    0 PROCESS_TYPE,
                    0 BILL_NO,
                    0 IS_CANCEL,
                    AC.CARD_ID,
                    AC.NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    1 FLAG
                FROM		
                    ACCOUNT_CARD_SAVE AC
                WHERE
                    AC.ACTION_TYPE = 52
                    AND AC.ACTION_ID = #attributes.invoice_id#
                    AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1	
                
                UNION ALL
                
                <!--- Alis ve Satis Faturalari --->
                SELECT
                    0 ACTION_ID,
                    0 PROCESS_TYPE,
                    0 BILL_NO,
                    0 IS_CANCEL,
                    AC.CARD_ID,
                    AC.NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    1 FLAG
                FROM		
                    ACCOUNT_CARD_SAVE AC
                WHERE
                    AC.ACTION_TYPE IN (48,49,50,51,53,54,55,56,561,57,58,59,60,601,61,62,63,64,690,691,65,66,68,531,532,591,5311,661,651,5312)
                    AND AC.ACTION_ID = #attributes.invoice_id#
                    AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1	
            
                UNION ALL
                
                <!--- Nakit İşlem  --->
                SELECT
                    0 ACTION_ID,
                    0 PROCESS_TYPE,
                    0 BILL_NO,
                    0 IS_CANCEL,
                    AC.CARD_ID,
                    AC.NEW_CARD_ID,
                    AC.CARD_TYPE_NO,
                    1 FLAG
                FROM
                    INVOICE I,
                    CASH_ACTIONS CA,
                    ACCOUNT_CARD_SAVE AC
                WHERE
                    I.INVOICE_ID = #attributes.invoice_id#
                    AND I.CASH_ID = CA.ACTION_ID
                    AND I.CASH_ID = AC.ACTION_ID
                    AND AC.ACTION_TYPE IN (34,35)
                    AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
            )T1
            ORDER BY
                CARD_ID
		</cfquery>
    </cfif>
<cfelseif isdefined("attributes.expense_id")>
	 <cfquery name="get_order_acts" datasource="#dsn2#">
		SELECT
			*
		FROM
		(
			<!--- Kredi Kartı  --->
			SELECT
				AC.ACTION_ID,
				242 AS PROCESS_TYPE,
				BILL_NO,
				AC.CARD_ID,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG,
                ISNULL(AC.IS_CANCEL,0) IS_CANCEL
			FROM
				ACCOUNT_CARD AC,
				#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				AND AC.ACTION_TYPE = 242
				AND AC.ACTION_ID = CCBE.CREDITCARD_EXPENSE_ID
				
			UNION ALL
			
			<!--- Nakit İşlem  --->
			SELECT
				AC.ACTION_ID,
				<cfif isDefined("attributes.is_income")>31 AS PROCESS_TYPE,<cfelse>32 AS PROCESS_TYPE,</cfif>
				BILL_NO,
                AC.CARD_ID,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG,
                ISNULL(AC.IS_CANCEL,0) IS_CANCEL
			FROM
				ACCOUNT_CARD AC,
				CASH_ACTIONS
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 31<cfelse>AND AC.ACTION_TYPE = 32</cfif>
				AND AC.ACTION_ID = CASH_ACTIONS.ACTION_ID
	
		 	UNION ALL
			
			<!---  Banka ---> 
			SELECT
				AC.ACTION_ID,
				<cfif isDefined("attributes.is_income")>24 AS PROCESS_TYPE,<cfelse>25 AS PROCESS_TYPE,</cfif>
				BILL_NO,
                AC.CARD_ID,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG,
                ISNULL(AC.IS_CANCEL,0) IS_CANCEL
			FROM
				ACCOUNT_CARD AC,
				BANK_ACTIONS
			WHERE
				EXPENSE_ID = #attributes.expense_id#
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 24<cfelse>AND AC.ACTION_TYPE = 25</cfif>
				AND AC.ACTION_ID = BANK_ACTIONS.ACTION_ID
			
			UNION ALL	
				 
			<!--- Masraf Fisi / Gelir Fisi  --->
			SELECT
				EXPENSE_ID ACTION_ID,
				<cfif isDefined("attributes.is_income")>121 AS PROCESS_TYPE,<cfelseif isDefined("attributes.is_asset")>122 AS PROCESS_TYPE,<cfelseif isDefined("attributes.is_health")>1201 as PROCESS_TYPE, <cfelse>120 AS PROCESS_TYPE,</cfif>
				BILL_NO,
                AC.CARD_ID,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG,
                ISNULL(AC.IS_CANCEL,0) IS_CANCEL
			FROM
				ACCOUNT_CARD AC,
				EXPENSE_ITEM_PLANS
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				<cfif not (isDefined("attributes.is_income") or isDefined("attributes.is_asset") or isDefined("attributes.is_health"))> AND (AC.ACTION_TABLE != 'INVOICE_COST' OR AC.ACTION_TABLE IS NULL) </cfif>
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 121<cfelseif isDefined("attributes.is_asset")>AND AC.ACTION_TYPE = 122 <cfelseif isDefined("attributes.is_health")>AND  AC.ACTION_TYPE = 1201<cfelse>AND AC.ACTION_TYPE = 120</cfif>
				AND AC.ACTION_ID = EXPENSE_ID
                
            UNION ALL
            <!--- Birleştirilmiş fişler --->
			<!--- Kredi Kartı  --->
			SELECT
				0 ACTION_ID,
				0 PROCESS_TYPE,
				0 BILL_NO,
				AC.CARD_ID,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG,
                0 IS_CANCEL
			FROM
				ACCOUNT_CARD_SAVE AC,
				#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				AND AC.ACTION_TYPE = 242
				AND AC.ACTION_ID = CCBE.CREDITCARD_EXPENSE_ID
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
				
			UNION ALL
			
			<!--- Nakit İşlem  --->
			SELECT
            	0 ACTION_ID,
				0 PROCESS_TYPE,
				0 BILL_NO,
				AC.CARD_ID,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG,
                0 IS_CANCEL
			FROM
				ACCOUNT_CARD_SAVE AC,
				CASH_ACTIONS
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 31<cfelse>AND AC.ACTION_TYPE = 32</cfif>
				AND AC.ACTION_ID = CASH_ACTIONS.ACTION_ID
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
	
			UNION ALL
			
			<!---  Banka ---> 
			SELECT
            	0 ACTION_ID,
				0 PROCESS_TYPE,
				0 BILL_NO,
				AC.CARD_ID,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG,
                0 IS_CANCEL
			FROM
				ACCOUNT_CARD_SAVE AC,
				BANK_ACTIONS
			WHERE
				EXPENSE_ID = #attributes.expense_id#
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 24<cfelse>AND AC.ACTION_TYPE = 25</cfif>
				AND AC.ACTION_ID = BANK_ACTIONS.ACTION_ID
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
			
			UNION ALL	
				 
			<!--- Masraf Fisi / Gelir Fisi  --->
			SELECT
            	0 ACTION_ID,
				0 PROCESS_TYPE,
				0 BILL_NO,
				AC.CARD_ID,
				AC.NEW_CARD_ID,
				AC.CARD_TYPE_NO,
                1 FLAG,
                0 IS_CANCEL
			FROM
				ACCOUNT_CARD_SAVE AC,
				EXPENSE_ITEM_PLANS
			WHERE
				EXPENSE_ID =  #attributes.expense_id#
				<cfif isDefined("attributes.is_income")>AND AC.ACTION_TYPE = 121<cfelseif isDefined("attributes.is_asset")>AND AC.ACTION_TYPE = 122<cfelseif isDefined("attributes.is_health")>AND  AC.ACTION_TYPE = 1201<cfelse>AND AC.ACTION_TYPE = 120</cfif>
				AND AC.ACTION_ID = EXPENSE_ID
				AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
		)T1
		ORDER BY
			CARD_ID
	</cfquery>
<cfelseif isdefined("attributes.payroll_id")>
	 <cfquery name="get_order_acts" datasource="#dsn2#">
        <!--- Cekler --->
        SELECT
        	*
        FROM
        (
            SELECT
            	0 NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                0 FLAG
            FROM
                ACCOUNT_CARD AC,
                PAYROLL P
            WHERE
                P.ACTION_ID =  #attributes.payroll_id#
                AND AC.ACTION_TABLE = 'PAYROLL'
                AND AC.ACTION_ID = P.ACTION_ID
    
            UNION
            
            SELECT
                AC.NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                1 FLAG
            FROM
                ACCOUNT_CARD_SAVE AC,
                PAYROLL P
            WHERE
                P.ACTION_ID =  #attributes.payroll_id#
                AND AC.ACTION_TABLE = 'PAYROLL'
                AND AC.ACTION_ID = P.ACTION_ID
                AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
         ) T1
         	ORDER BY
            	CARD_ID
	</cfquery>
<cfelseif isdefined("attributes.voucher_payroll_id")>
	 <cfquery name="get_order_acts" datasource="#dsn2#">
		<!--- Senetler --->
        SELECT
        	*
        FROM
        (
            SELECT
                0 NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                0 FLAG
            FROM
                ACCOUNT_CARD AC,
                VOUCHER_PAYROLL P
            WHERE
                P.ACTION_ID =  #attributes.voucher_payroll_id#
                AND AC.ACTION_TABLE = 'VOUCHER_PAYROLL'
                AND AC.ACTION_ID = P.ACTION_ID
                
            UNION
            
            SELECT
                AC.NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                1 FLAG
            FROM
                ACCOUNT_CARD_SAVE AC,
                VOUCHER_PAYROLL P
            WHERE
                P.ACTION_ID =  #attributes.voucher_payroll_id#
                AND AC.ACTION_TABLE = 'VOUCHER_PAYROLL'
                AND AC.ACTION_ID = P.ACTION_ID
                AND ISNULL(AC.IS_TEMPORARY_SOLVED,0) <> 1
			UNION ALL
			
			<!--- Nakit İşlem  --->
			SELECT
				0 NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                0 FLAG
			FROM
				ACCOUNT_CARD AC,
				CASH_ACTIONS
			WHERE
				CASH_ACTIONS.VOUCHER_ID =  #attributes.voucher_payroll_id#
				AND AC.ACTION_TABLE = 'CASH_ACTIONS'
				AND AC.ACTION_TYPE = 31
				AND AC.ACTION_ID = CASH_ACTIONS.ACTION_ID
			UNION ALL
				<!---  Banka ---> 
			SELECT
				0 NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                0 FLAG
			FROM
				ACCOUNT_CARD AC,
				BANK_ACTIONS
			WHERE
				BANK_ACTIONS.VOUCHER_PAYROLL_ID = #attributes.voucher_payroll_id#
				AND AC.ACTION_TYPE = 24
				AND AC.ACTION_ID = BANK_ACTIONS.ACTION_ID
			UNION ALL
			<!---  Kredi Kartı ---> 
			SELECT
				0 NEW_CARD_ID,
                AC.ACTION_ID,
                AC.CARD_ID,
                BILL_NO,
                0 FLAG
			FROM
				ACCOUNT_CARD AC,
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCP
			WHERE
				CCP.VOUCHER_PAYROLL_ID = #attributes.voucher_payroll_id#
				AND AC.ACTION_TABLE = 'CREDIT_CARD_BANK_PAYMENTS'
				AND AC.ACTION_TYPE = 241
				AND AC.ACTION_ID = CCP.CREDITCARD_PAYMENT_ID
        ) T1
            ORDER BY
                CARD_ID
	</cfquery>    
<cfelseif isdefined("attributes.health_id")>
	 <cfquery name="get_order_acts" datasource="#dsn2#">
		<!--- Senetler --->
        SELECT
        	*
        FROM
        (
            SELECT
            	AC.ACTION_ID,
				2503 AS PROCESS_TYPE,
				BILL_NO,
                AC.CARD_ID,
				0 NEW_CARD_ID,
				AC.CARD_TYPE_NO,
				0 FLAG,
                ISNULL(AC.IS_CANCEL,0) IS_CANCEL
			FROM
				ACCOUNT_CARD AC,
				EXPENSE_ITEM_PLAN_REQUESTS
			WHERE
				EXPENSE_ID =  #attributes.health_id#
				AND AC.ACTION_TYPE = 2503
				AND AC.ACTION_ID = EXPENSE_ID
        ) T1
            ORDER BY
                CARD_ID
	</cfquery>  
</cfif>
<cf_box title="#getLang('','Muhasebe Fişleri',32890)#" popup_box="1" resize="0">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">		
        <cfif get_order_acts.recordcount>
            <cfoutput query="get_order_acts">
            	<cfif isdefined("get_order_acts.is_cancel")><cfset is_cancel = get_order_acts.is_cancel><cfelse><cfset is_cancel = 0></cfif>
                <tr id="card_detail_#currentrow#" valign="top">
                    <td colspan="6">
                        <div id="card_detail_#currentrow#_"></div>
                    </td>
                </tr>
                <tr height="10">
                	<td><cfif flag eq 0>
							<script type="text/javascript">
                                <cfif isdefined('attributes.payroll_id') or isdefined('attributes.voucher_payroll_id') or isdefined("attributes.order_id")>
                                    AjaxPageLoad('#request.self#?fuseaction=account.popup_list_card_rows&is_fast_sale=1&action_id=#get_order_acts.action_id#&card_id=#get_order_acts.card_id#&form_crntrow=#currentrow#&is_cancel=#is_cancel#','card_detail_#currentrow#_',1);	
                                <cfelse>
                                    AjaxPageLoad('#request.self#?fuseaction=account.popup_list_card_rows&is_temporary_solve=1&is_fast_sale=1&action_id=#get_order_acts.action_id#&process_cat=#get_order_acts.process_type#&form_crntrow=#currentrow#&is_cancel=#is_cancel#','card_detail_#currentrow#_',1);	
                                </cfif>
                            </script>
                        <cfelse>
                        	<br><font class="txtbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='60104.Muhasebe Modülünde Hareket Birleştirme İşlemi Yapılmıştır'>!</font>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#NEW_CARD_ID#','page');" class="tableyazi">
                            <cfquery name="get_bill_no" datasource="#dsn2#">
                                SELECT BILL_NO FROM ACCOUNT_CARD WHERE CARD_ID = #NEW_CARD_ID#
                            </cfquery>	
                            <b>#get_bill_no.BILL_NO#</b>
                            </a>
                        </cfif>
                	</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td>
                    <font class="txtbold"><cf_get_lang dictionary_id='47482.Seçtiğiniz İşlem İçin Muhasebe İşlemi Yapılmamaktadır'>!</font>
                </td>
            </tr>	
        </cfif>
    </table>
</cf_box>
