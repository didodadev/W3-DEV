<cfloop from="1" to="#attributes.row_count#" index="i">
      <cfif evaluate("attributes.row_kontrol_#i#") eq 1>
            <cfquery name="add_row" datasource="#dsn#">
                  INSERT INTO WODIBA_RULE_SET_DEFINITIONS
                        (BANK_ID
                        ,MONEY_TYPE
                        ,MAIN_ACCOUNT_ID
                        ,RULE_SET_ID
                        ,POS_ACCOUNT_ID,
						REC_USER,
                        REC_IP,
                        REC_DATE)
                  VALUES
                        (<cfif isDefined('attributes.bank#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.bank#i#')#"><cfelse>NULL</cfif>
                        ,<cfif isDefined('attributes.money_type#i#')><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.money_type#i#')#"><cfelse>NULL</cfif>
                        ,<cfif isDefined('attributes.bank_account#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.bank_account#i#')#"><cfelse>NULL</cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                        ,<cfif isDefined('attributes.pos_bloke#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_bloke#i#')#"><cfelse>NULL</cfif>,
						#session.ep.userid#,
                        '#cgi.remote_addr#',
                        #now()#)
            </cfquery>
      </cfif>
</cfloop>
<cfloop from="1" to="#attributes.row_count_sabit#" index="i">
      <cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
            <cfquery name="add_row" datasource="#dsn#">
                  UPDATE 
                        WODIBA_RULE_SET_DEFINITIONS
			SET
                         BANK_ID = <cfif isDefined('attributes.sabit_bank#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_bank#i#')#"><cfelse>NULL</cfif>
                        ,MONEY_TYPE = <cfif isDefined('attributes.sabit_money_type#i#')><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.sabit_money_type#i#')#"><cfelse>NULL</cfif>
                        ,MAIN_ACCOUNT_ID = <cfif isDefined('attributes.sabit_bank_account#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_bank_account#i#')#"><cfelse>NULL</cfif>
                        ,POS_ACCOUNT_ID = <cfif isDefined('attributes.sabit_pos_bloke#i#')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_pos_bloke#i#')#"><cfelse>NULL</cfif>,
						UPD_USER = #session.ep.userid#,
						UPD_IP = '#cgi.remote_addr#',
						UPD_DATE = #now()#
                  WHERE DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_definition#i#')#">
            </cfquery>
      <cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM WODIBA_RULE_SET_DEFINITIONS WHERE DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_definition#i#')#">
		</cfquery>
      </cfif>
</cfloop>