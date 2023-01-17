<!---dosya, manuel fis guncelleme sayfalarının actionlarında ve birleştirilmiş fişi gecici acma işleminde (solve_card.cfm) history kaydı tutmak için kullanılır.  --->
<cfif GET_CARD_HISTORY.RECORDCOUNT>
	<cfquery name="ADD_ACCOUNT_CARD_HISTORY" datasource="#dsn2#">
		INSERT INTO
			ACCOUNT_CARD_HISTORY
			(
				CARD_ID,
				WRK_ID,
				ACTION_ID,
				IS_ACCOUNT,
				BILL_NO,
				CARD_DETAIL,
				CARD_TYPE,
				CARD_CAT_ID,
                CARD_DOCUMENT_TYPE,
                CARD_PAYMENT_METHOD,
				CARD_TYPE_NO,
				ACTION_TYPE,
				ACTION_CAT_ID,
				ACTION_DATE,
				ACTION_TABLE,
				PAPER_NO,
				ACC_COMPANY_ID,
				ACC_CONSUMER_ID,
				IS_OTHER_CURRENCY,
				RECORD_EMP_OLD,
				RECORD_PAR_OLD,
				RECORD_CONS_OLD,
				RECORD_IP_OLD,
				RECORD_DATE_OLD,
			<cfif isDefined("session.ep.userid")>
				RECORD_EMP,
			<cfelseif isDefined("session.pp.userid")>
				RECORD_PAR,
			<cfelseif isDefined("session.ww.userid")>
				RECORD_CONS,
			</cfif>
				RECORD_IP,
				RECORD_DATE
			)
		VALUES
			(
			#GET_CARD_HISTORY.CARD_ID#,
			<cfif len(GET_CARD_HISTORY.WRK_ID)>'#GET_CARD_HISTORY.WRK_ID#'<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACTION_ID)>#GET_CARD_HISTORY.ACTION_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.IS_ACCOUNT)>#GET_CARD_HISTORY.IS_ACCOUNT#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.BILL_NO)>#GET_CARD_HISTORY.BILL_NO#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.CARD_DETAIL)>'#GET_CARD_HISTORY.CARD_DETAIL#'<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.CARD_TYPE)>#GET_CARD_HISTORY.CARD_TYPE#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.CARD_CAT_ID)>#GET_CARD_HISTORY.CARD_CAT_ID#<cfelse>NULL</cfif>,
            <cfif len(GET_CARD_HISTORY.CARD_DOCUMENT_TYPE)>#GET_CARD_HISTORY.CARD_DOCUMENT_TYPE#<cfelse>NULL</cfif>,
            <cfif len(GET_CARD_HISTORY.CARD_PAYMENT_METHOD)>#GET_CARD_HISTORY.CARD_PAYMENT_METHOD#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.CARD_TYPE_NO)>#GET_CARD_HISTORY.CARD_TYPE_NO#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACTION_TYPE)>#GET_CARD_HISTORY.ACTION_TYPE#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACTION_CAT_ID)>#GET_CARD_HISTORY.ACTION_CAT_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACTION_DATE)>#CreateODBCDateTime(GET_CARD_HISTORY.ACTION_DATE)#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACTION_TABLE)>'#GET_CARD_HISTORY.ACTION_TABLE#'<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.PAPER_NO)>'#GET_CARD_HISTORY.PAPER_NO#'<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACC_COMPANY_ID)>#GET_CARD_HISTORY.ACC_COMPANY_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.ACC_CONSUMER_ID)>#GET_CARD_HISTORY.ACC_CONSUMER_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.IS_OTHER_CURRENCY)>#GET_CARD_HISTORY.IS_OTHER_CURRENCY#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.RECORD_EMP)>#GET_CARD_HISTORY.RECORD_EMP#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.RECORD_PAR)>#GET_CARD_HISTORY.RECORD_PAR#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.RECORD_CONS)>#GET_CARD_HISTORY.RECORD_CONS#<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.RECORD_IP)>'#GET_CARD_HISTORY.RECORD_IP#'<cfelse>NULL</cfif>,
			<cfif len(GET_CARD_HISTORY.RECORD_DATE)>#CreateODBCDateTime(GET_CARD_HISTORY.RECORD_DATE)#<cfelse>NULL</cfif>,
			<cfif isDefined("session.ep.userid")>
				#SESSION.EP.USERID#,
			<cfelseif isDefined("session.pp.userid")>
				#SESSION.PP.USERID#,
			<cfelseif isDefined("session.ww.userid")>
				#SESSION.WW.USERID#,
			</cfif>
			'#CGI.REMOTE_ADDR#',
			#NOW()#
			)
	</cfquery>
	<cfquery name="GET_MAX_ACC_HISTORY" datasource="#dsn2#">
		SELECT
			MAX(CARD_HISTORY_ID) AS MAX_HISTORY_ID
		FROM
			ACCOUNT_CARD_HISTORY
	</cfquery>
	<cfquery name="GET_ACC_ROW_INFO" datasource="#dsn2#">
		SELECT 
			* 
		FROM 
			ACCOUNT_CARD_ROWS 
		WHERE 
			CARD_ID=#GET_CARD_HISTORY.CARD_ID#
			<cfif isdefined('attributes.CARD_ROW_ID') and len(attributes.CARD_ROW_ID)><!--- açılış fişi satırlarından biri guncellenmisse sadece guncellenen satırın histoy kaydı yapılır --->
			AND CARD_ROW_ID = #CARD_ROW_ID#
			</cfif>
	</cfquery>
	<cfloop query="GET_ACC_ROW_INFO">
		<cfquery name="ADD_ACC_ROW_HISTORY" datasource="#dsn2#">
			INSERT INTO
				ACCOUNT_CARD_ROWS_HISTORY
				(
					CARD_HISTORY_ID,
					CARD_ID,
					CARD_ROW_ID,
					ACCOUNT_ID,
					IFRS_CODE,
					ACCOUNT_CODE2,
					DETAIL,
					BA,
					AMOUNT,
					AMOUNT_CURRENCY,
					AMOUNT_2,
					AMOUNT_CURRENCY_2,
					OTHER_CURRENCY,
					OTHER_AMOUNT,
					QUANTITY,
					PRICE,
					ACC_DEPARTMENT_ID,
					ACC_BRANCH_ID,
					BILL_CONTROL_NO
				)
			VALUES
				(
					#GET_MAX_ACC_HISTORY.MAX_HISTORY_ID#,
					#GET_ACC_ROW_INFO.CARD_ID#,
					#GET_ACC_ROW_INFO.CARD_ROW_ID#, <!--- acılıs fisi satırları guncellendiginde  CARD_ROW_ID bazında takip edilebilir--->
					'#GET_ACC_ROW_INFO.ACCOUNT_ID#',
					<cfif len(GET_ACC_ROW_INFO.IFRS_CODE)>'#GET_ACC_ROW_INFO.IFRS_CODE#',<cfelse>NULL,</cfif>
					<cfif len(GET_ACC_ROW_INFO.ACCOUNT_CODE2)>'#GET_ACC_ROW_INFO.ACCOUNT_CODE2#',<cfelse>NULL,</cfif>
					<cfif len(GET_ACC_ROW_INFO.DETAIL)>'#GET_ACC_ROW_INFO.DETAIL#',<cfelse>NULL,</cfif>
					#GET_ACC_ROW_INFO.BA#,
					#GET_ACC_ROW_INFO.AMOUNT#,
					'#GET_ACC_ROW_INFO.AMOUNT_CURRENCY#',
					<cfif len(GET_ACC_ROW_INFO.AMOUNT_2)>#GET_ACC_ROW_INFO.AMOUNT_2#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2)>'#GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2#'<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.OTHER_CURRENCY)>'#GET_ACC_ROW_INFO.OTHER_CURRENCY#'<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.OTHER_AMOUNT)>#GET_ACC_ROW_INFO.OTHER_AMOUNT#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.QUANTITY)>#GET_ACC_ROW_INFO.QUANTITY#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.PRICE)>#GET_ACC_ROW_INFO.PRICE#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID)>#GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.ACC_BRANCH_ID)>#GET_ACC_ROW_INFO.ACC_BRANCH_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_ACC_ROW_INFO.BILL_CONTROL_NO)>#GET_ACC_ROW_INFO.BILL_CONTROL_NO#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfloop>
</cfif>
