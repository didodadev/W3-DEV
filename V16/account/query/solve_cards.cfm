<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.card_id")>
			<!--- birlestirilmis fis siliniyor --->
			<cfquery name="get_fis_info" datasource="#DSN2#">
				SELECT BILL_NO,CARD_TYPE_NO,CARD_DETAIL FROM ACCOUNT_CARD WHERE CARD_ID = #attributes.CARD_ID#
			</cfquery>
			<cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1>
			 <!---birleştirilmiş fiş gecici olarak açılırken history kaydı ekleniyor --->
             	<cfquery name="GET_CARD_HISTORY" datasource="#dsn2#">
                     SELECT
                        *
                     FROM
                        ACCOUNT_CARD
                     WHERE
                        CARD_ID =#attributes.CARD_ID#
                </cfquery>
				<cfinclude template="add_bill_history.cfm">
			</cfif>
			<cfquery name="DEL_ACC_CARD_" datasource="#DSN2#">
				DELETE FROM ACCOUNT_CARD WHERE CARD_ID = #attributes.CARD_ID#
			</cfquery>
			<cfquery name="DEL_ACC_CARD_ROW_" datasource="#DSN2#">
				DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #attributes.CARD_ID#
			</cfquery>
			<cfquery name="DEL_ACC_CARD_ROW_" datasource="#DSN2#">
				DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID = #attributes.CARD_ID#
			</cfquery>
			<!--- birlestirilmis fisi olusturan islemler yeniden ACCOUNT_CARD ve ACCOUNT_CARD_ROWS'a taşınıyor --->
			<cfquery name="GET_CARD" datasource="#DSN2#">
				SELECT 
                	CARD_ID, 
                    NEW_CARD_ID, 
                    ACTION_ID, 
                    CARD_DETAIL, 
                    ACTION_DATE, 
                    CARD_TYPE, 
                    ACTION_TYPE, 
                    BILL_NO, 
                    IS_ACCOUNT, 
                    CARD_TYPE_NO, 
                    PAPER_NO, 
                    IS_COMPOUND, 
                    IS_OTHER_CURRENCY, 
                    RECORD_PAR_OLD, 
                    PROCESS_DATE, 
                    IS_RATE_DIFF, 
                    ACTION_TABLE, 
                    NEW_BILL_NO, 
                    NEW_CARD_TYPE_NO, 
                    ACTION_CAT_ID, 
                    CARD_CAT_ID, 
                    IS_TEMPORARY_SOLVED, 
                    NEW_CARD_DETAIL, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    RECORD_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    UPDATE_DATE, 
                    RECORD_EMP_OLD, 
                    RECORD_IP_OLD, 
                    RECORD_DATE_OLD,
                    CARD_DOCUMENT_TYPE,
					CARD_PAYMENT_METHOD
                FROM 
                	ACCOUNT_CARD_SAVE 
                WHERE 
                	NEW_CARD_ID = #attributes.CARD_ID#
			</cfquery>
		<cfelse>
			<cfquery name="GET_CARD" datasource="#DSN2#">
				SELECT 
                	CARD_ID, 
                    NEW_CARD_ID, 
                    ACTION_ID, 
                    CARD_DETAIL, 
                    ACTION_DATE, 
                    CARD_TYPE, 
                    ACTION_TYPE, 
                    BILL_NO, 
                    IS_ACCOUNT, 
                    CARD_TYPE_NO, 
                    PAPER_NO, 
                    IS_COMPOUND, 
                    IS_OTHER_CURRENCY, 
                    RECORD_PAR_OLD, 
                    PROCESS_DATE, 
                    IS_RATE_DIFF, 
                    ACTION_TABLE, 
                    NEW_BILL_NO, 
                    NEW_CARD_TYPE_NO, 
                    ACTION_CAT_ID, 
                    CARD_CAT_ID, 
                    IS_TEMPORARY_SOLVED, 
                    NEW_CARD_DETAIL, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    RECORD_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    UPDATE_DATE, 
                    RECORD_EMP_OLD, 
                    RECORD_IP_OLD, 
                    RECORD_DATE_OLD,
                    CARD_DOCUMENT_TYPE,
					CARD_PAYMENT_METHOD
                FROM 
                	ACCOUNT_CARD_SAVE 
                WHERE 
                	CARD_ID = #attributes.old_card_id#
			</cfquery>	
			<cfquery name="DEL_ACC_CARD_ROW_" datasource="#DSN2#">
				DELETE FROM ACCOUNT_CARD_ROWS WHERE ROW_ACTION_ID = #GET_CARD.ACTION_ID# AND ROW_ACTION_TYPE_ID = #GET_CARD.ACTION_TYPE#
			</cfquery>
			<cfquery name="DEL_ACC_CARD_ROW_" datasource="#DSN2#">
				DELETE FROM ACCOUNT_ROWS_IFRS WHERE ROW_ACTION_ID = #GET_CARD.ACTION_ID# AND ROW_ACTION_TYPE_ID = #GET_CARD.ACTION_TYPE#
			</cfquery>
		</cfif>
		<cfquery name="GET_CARD_ROW" datasource="#DSN2#">
			SELECT 
            	CARD_ID, 
                ACCOUNT_ID, 
                BA, 
                AMOUNT, 
                AMOUNT_CURRENCY, 
                DETAIL, 
                AMOUNT_2, 
                AMOUNT_CURRENCY_2, 
                OTHER_CURRENCY, 
                OTHER_AMOUNT, 
                IFRS_CODE, 
                ACCOUNT_CODE2, 
                IS_RATE_DIFF_ROW, 
                ACC_DEPARTMENT_ID, 
                ACC_BRANCH_ID, 
                ACC_PROJECT_ID,
				QUANTITY
            FROM 
            	ACCOUNT_CARD_SAVE_ROWS 
            WHERE 
            	CARD_ID IN (#ValueList(GET_CARD.CARD_ID)#)
		</cfquery>
		<cfset cardlist = "" >
		<cfloop query="GET_CARD">
			<cfset attributes.imp_date = CreateODBCDateTime(ACTION_DATE)>
			<cfset attributes.rec_date = CreateODBCDateTime(RECORD_DATE_OLD)>
			<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
			<cfquery name="add_card" datasource="#dsn2#">
				INSERT INTO
					ACCOUNT_CARD
					(
						WRK_ID,
						ACTION_ID,
						CARD_DETAIL,
						ACTION_DATE,
						CARD_TYPE,
						CARD_CAT_ID,
						ACTION_TYPE,
						ACTION_CAT_ID,
						BILL_NO,
						IS_ACCOUNT,
						CARD_TYPE_NO,
						PAPER_NO,
						IS_COMPOUND,
						IS_OTHER_CURRENCY,
						IS_RATE_DIFF,
						ACTION_TABLE,
						<cfif len(RECORD_EMP_OLD)>RECORD_EMP,<cfelseif len(RECORD_PAR_OLD)>RECORD_PAR,</cfif>
						RECORD_IP,
						RECORD_DATE,
                        CARD_DOCUMENT_TYPE,
                        CARD_PAYMENT_METHOD
					)
					VALUES
					(
						'#wrk_id#',
						<cfif len(ACTION_ID)>#ACTION_ID#<cfelse>NULL</cfif>,
						'#CARD_DETAIL#',
						#attributes.imp_date#,
						#CARD_TYPE#,
						#CARD_CAT_ID#,
						<cfif len(ACTION_TYPE)>#ACTION_TYPE#<cfelse>NULL</cfif>,
						<cfif len(ACTION_CAT_ID)>#ACTION_CAT_ID#<cfelse>NULL</cfif>,
						#BILL_NO#,
						#IS_ACCOUNT#,
						#CARD_TYPE_NO#,
						'#PAPER_NO#',
						<cfif len(IS_COMPOUND)>#IS_COMPOUND#<cfelse>NULL</cfif>,
						<cfif len(IS_OTHER_CURRENCY)>#IS_OTHER_CURRENCY#<cfelse>NULL</cfif>,
						<cfif len(IS_RATE_DIFF)>#IS_RATE_DIFF#<cfelse>0</cfif>,
						<cfif len(ACTION_TABLE)>'#ACTION_TABLE#'<cfelse>NULL</cfif>,
						<cfif len(RECORD_EMP_OLD)>#RECORD_EMP_OLD#,<cfelseif len(RECORD_PAR_OLD)>#RECORD_PAR_OLD#,</cfif>
						<cfif len(RECORD_IP_OLD)>'#RECORD_IP_OLD#',<cfelse>'#CGI.REMOTE_ADDR#',</cfif>
						<cfif len(RECORD_DATE_OLD)>#attributes.rec_date#<cfelse>#now()#</cfif>,
                        <cfif len(CARD_DOCUMENT_TYPE)>#CARD_DOCUMENT_TYPE#<cfelse>NULL</cfif>,
                        <cfif len(CARD_PAYMENT_METHOD)>#CARD_PAYMENT_METHOD#<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfquery name="GET_MAX" datasource="#dsn2#">
				SELECT MAX(CARD_ID) AS MAX_CARD_ID FROM ACCOUNT_CARD WHERE WRK_ID = '#wrk_id#'
			</cfquery>
			<cfquery name="get_rows" dbtype="query">
				SELECT * FROM GET_CARD_ROW WHERE CARD_ID = #CARD_ID#
			</cfquery>
			<cfset cardlist = ListAppend(cardlist,GET_MAX.MAX_CARD_ID,",") >
			<cfoutput query="get_rows">
				<cfquery name="add_r_s" datasource="#dsn2#">
				INSERT INTO 
					ACCOUNT_CARD_ROWS
				(
					CARD_ID,
					ACCOUNT_ID,
					BA,
					AMOUNT,
					AMOUNT_CURRENCY,
					AMOUNT_2,
					AMOUNT_CURRENCY_2,
					IS_RATE_DIFF_ROW,
					ACCOUNT_CODE2,
					IFRS_CODE,
					OTHER_AMOUNT,
					OTHER_CURRENCY,
					DETAIL,
					ACC_DEPARTMENT_ID,
					ACC_BRANCH_ID,
					ACC_PROJECT_ID,
					QUANTITY
				)
				VALUES
				(
					#GET_MAX.MAX_CARD_ID#,
					'#ACCOUNT_ID#',
					#BA#,
					#AMOUNT#,
					'#AMOUNT_CURRENCY#',
					<cfif len(AMOUNT_2)>#AMOUNT_2#<cfelse>NULL</cfif>,
					<cfif len(AMOUNT_CURRENCY_2)>'#AMOUNT_CURRENCY_2#'<cfelse>NULL</cfif>,
					<cfif len(IS_RATE_DIFF_ROW)>#IS_RATE_DIFF_ROW#<cfelse>0</cfif>,
					<cfif len(ACCOUNT_CODE2)>'#ACCOUNT_CODE2#'<cfelse>NULL</cfif>,
					<cfif len(IFRS_CODE)>'#IFRS_CODE#'<cfelse>NULL</cfif>,
					<cfif len(OTHER_AMOUNT)>#OTHER_AMOUNT#<cfelse>NULL</cfif>,
					<cfif len(OTHER_CURRENCY)>'#OTHER_CURRENCY#'<cfelse>NULL</cfif>,
					<cfif len(DETAIL)>'#DETAIL#'<cfelse>NULL</cfif>,
					<cfif len(ACC_DEPARTMENT_ID)>#ACC_DEPARTMENT_ID#<cfelse>NULL</cfif>,
					<cfif len(ACC_BRANCH_ID)>#ACC_BRANCH_ID#<cfelse>NULL</cfif>,
					<cfif len(ACC_PROJECT_ID)>#ACC_PROJECT_ID#<cfelse>NULL</cfif>,
					<cfif len(QUANTITY)>#QUANTITY#<cfelse>NULL</cfif>
				)
				</cfquery>
			</cfoutput>
			<cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1>
				<!---Birleştirilmiş fiş geçiçi olarak çözülüyorsa, tekrar aynı işlemlerden olusturulabilmesi için ACCOUNT_CARD_SAVE ve ACCOUNT_CARD_SAVE_ROWS'dakikayıtlar silinmez. --->
				<cfquery name="UPD_ACC_CARD_SAVE" datasource="#DSN2#">
					UPDATE ACCOUNT_CARD_SAVE SET NEW_BILL_NO =#get_fis_info.BILL_NO# ,NEW_CARD_TYPE_NO=#get_fis_info.CARD_TYPE_NO#,NEW_CARD_DETAIL='#get_fis_info.CARD_DETAIL#',IS_TEMPORARY_SOLVED=1 WHERE NEW_CARD_ID = #attributes.CARD_ID#
				</cfquery>
			<cfelse>
				<cfif isdefined("attributes.card_id")>
					<cfquery name="DEL_CARD" datasource="#DSN2#">
						DELETE FROM ACCOUNT_CARD_SAVE WHERE NEW_CARD_ID = #attributes.CARD_ID#
					</cfquery>
					<cfquery name="DEL_CARD_ROW" datasource="#DSN2#">
						DELETE FROM ACCOUNT_CARD_SAVE_ROWS WHERE CARD_ID IN (#ValueList(GET_CARD.CARD_ID)#)
					</cfquery>
				<cfelse>
					<cfquery name="DEL_CARD" datasource="#DSN2#">
						DELETE FROM ACCOUNT_CARD_SAVE WHERE CARD_ID = #attributes.old_card_id#
					</cfquery>
					<cfquery name="DEL_CARD_ROW" datasource="#DSN2#">
						DELETE FROM ACCOUNT_CARD_SAVE_ROWS WHERE CARD_ID IN (#ValueList(GET_CARD.CARD_ID)#)
					</cfquery>	
				</cfif>
			</cfif>
		</cfloop>
	<cfinclude template="solve_process_records.cfm">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.close();
	wrk_opener_reload();
</script>
