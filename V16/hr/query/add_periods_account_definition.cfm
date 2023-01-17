<cfquery name="del_rows" datasource="#dsn#">
    DELETE FROM 
    	SETUP_ACCOUNT_CODE_DEFINITION 
    WHERE 
    	BRANCH_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND 
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
		<cfif isdefined('attributes.department_id') and len(attributes.department_id)> 
        	AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
        <cfelse>
        	AND DEPARTMENT_ID IS NULL
        </cfif>
</cfquery>
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
            <cfquery name="control_" datasource="#dsn#">
                SELECT
                    ID
                FROM
                    SETUP_ACCOUNT_DEFINITION
                WHERE
                    BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
                    <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
						AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    </cfif>
            </cfquery>	
            <cfif control_.recordcount>	
            <cfquery name="del_code_row" datasource="#dsn#">
				DELETE FROM SETUP_ACCOUNT_DEFINITION_CODE_ROW WHERE SETUP_ACCOUNT_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_.id#">
            </cfquery>
            <cfquery name="upd_" datasource="#dsn#">
                UPDATE
                    SETUP_ACCOUNT_DEFINITION
                SET
                    ACCOUNT_BILL_TYPE = <cfif isdefined('attributes.period_code_cat') and len(attributes.period_code_cat) and attributes.is_multi_period_code_cat eq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_code_cat#">,<cfelse>NULL,</cfif>
                    ACCOUNT_CODE = <cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE#"><cfelse>NULL</cfif>,
                    ACCOUNT_NAME = <cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.account_name,'-')#"><cfelse>NULL</cfif>,
                    EXPENSE_ITEM_ID = <cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"><cfelse>NULL</cfif>,
                    EXPENSE_ITEM_NAME = <cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_name#"><cfelse>NULL</cfif>,
                    EXPENSE_CENTER_ID = <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                    EXPENSE_CODE = <cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXPENSE_CODE#"><cfelse>NULL</cfif>,
                    EXPENSE_CODE_NAME = <cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXPENSE_CODE_NAME#"><cfelse>NULL</cfif>,
                    PERIOD_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                    PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                WHERE
                    BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
                    <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
                        AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    <cfelse>
                        AND DEPARTMENT_ID IS NULL
                    </cfif>
            </cfquery>
            <cfif isdefined('attributes.period_code_cat') and listlen(attributes.period_code_cat,',') gt 0 and is_multi_period_code_cat eq 1><!--- muhasebe kod grupları çoklu seçildi ise--->
                <cfloop list="#attributes.period_code_cat#" delimiters="," index="ind">
                    <cfquery name="add_code_row" datasource="#dsn#">
                        INSERT INTO
                            SETUP_ACCOUNT_DEFINITION_CODE_ROW
                            (
                                SETUP_ACCOUNT_DEFINITION_ID,
                                ACCOUNT_BILL_TYPE
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#control_.id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ind#">
                            )
                    </cfquery>
                </cfloop>
            </cfif>
		<cfelse> 
			<cfquery name="add_" datasource="#dsn#" result="max_id">
				INSERT INTO
					SETUP_ACCOUNT_DEFINITION
					(
					ACCOUNT_BILL_TYPE,
					ACCOUNT_CODE,
					ACCOUNT_NAME,
					EXPENSE_ITEM_ID,
					EXPENSE_ITEM_NAME,
					EXPENSE_CENTER_ID,
					EXPENSE_CODE,
					EXPENSE_CODE_NAME,
					PERIOD_COMPANY_ID,
					PERIOD_YEAR,
					BRANCH_ID,
                    <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
						DEPARTMENT_ID,
                    </cfif>
					PERIOD_ID,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
					)
				VALUES
					(
					<cfif isdefined('attributes.period_code_cat') and len(attributes.period_code_cat) and attributes.is_multi_period_code_cat eq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_code_cat#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.account_name,'-')#"><cfelse>NULL</cfif>,
					<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_name#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXPENSE_CODE#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXPENSE_CODE_NAME#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
                    <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
                    </cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
					)
			</cfquery>
            <cfif isdefined('attributes.period_code_cat') and listlen(attributes.period_code_cat,',') and attributes.is_multi_period_code_cat eq 1><!--- muhasebe kod grupları çoklu seçildi ise--->
				<cfloop list="#attributes.period_code_cat#" delimiters="," index="ind">
					<cfquery name="add_code_row" datasource="#dsn#">
						INSERT INTO
                        	SETUP_ACCOUNT_DEFINITION_CODE_ROW
                           	(
                            	SETUP_ACCOUNT_DEFINITION_ID,
                                ACCOUNT_BILL_TYPE
                            )
                            VALUES
                            (
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.identitycol#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ind#">
                            )
                    </cfquery>
                </cfloop>
            </cfif>
		</cfif>
		<!--- ilişkili hesaplar ekleniyor --->
		<cfif isdefined("attributes.record_num")>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
					<cfif Evaluate("attributes.acc_type_id_#i#") eq -1>
						<cfquery name="upd_" datasource="#dsn#">
							UPDATE
								SETUP_ACCOUNT_CODE_DEFINITION
							SET
								ACCOUNT_CODE = <cfif isdefined("attributes.account_code_#i#") and len(Evaluate("attributes.account_code_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('attributes.account_code_#i#')#"><cfelse>NULL</cfif>
							WHERE
								BRANCH_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
								PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
                                <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
									AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                                <cfelse>
                                	AND DEPARTMENT_ID IS NULL
                                </cfif>
						</cfquery>
					</cfif>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO SETUP_ACCOUNT_CODE_DEFINITION 
						(
							ACC_TYPE_ID,
							ACCOUNT_CODE,
							PERIOD_ID,
							BRANCH_ID
							<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
							,DEPARTMENT_ID
                            </cfif>
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.acc_type_id_#i#')#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('attributes.account_code_#i#')#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
							<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                            </cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- ilişkili masraf merkezleri ekleniyor --->
        <cfquery name="del_rows" datasource="#dsn#">
			DELETE 
            	FROM 
            	SETUP_ACCOUNT_EXPENSE 
            WHERE 
            	BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND 
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> 
				<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
                	AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                <cfelse>
                	AND DEPARTMENT_ID IS NULL
                </cfif>
		</cfquery>
		<cfif isdefined("attributes.record_num_2")>
			<cfloop from="1" to="#attributes.record_num_2#" index="i">
				<cfif isdefined("attributes.row_kontrol_2_#i#") and evaluate("attributes.row_kontrol_2_#i#") eq 1>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO SETUP_ACCOUNT_EXPENSE 
						(
							PERIOD_ID,
							BRANCH_ID,
                            <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
							DEPARTMENT_ID,
                            </cfif>
							EXPENSE_CENTER_ID,
							RATE
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
                            <cfif isdefined('attributes.department_id') and len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.expense_center_id#i#')#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(Evaluate('attributes.rate#i#'))#">
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
</script>