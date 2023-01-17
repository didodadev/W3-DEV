<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
		<!--- Bireysel Uye ise --->
		<cfif isdefined("attributes.cpid")>
			<cfquery name="ADD_BANK" datasource="#DSN#" result="MAX_ID">
				INSERT INTO 
					CONSUMER_BANK 
				( 
					CONSUMER_ID, 
					CONSUMER_BANK,
					CONSUMER_BANK_CODE, 
					CONSUMER_IBAN_CODE, 
					MONEY,
					CONSUMER_BANK_BRANCH,
					CONSUMER_BANK_BRANCH_CODE, 
					CONSUMER_ACCOUNT_DEFAULT,
					CONSUMER_ACCOUNT_NO,
					RECORD_DATE,
					<cfif isdefined("session.ep.userid")>
					RECORD_EMP,
					</cfif>
					<cfif isdefined("session.ww.userid")>
					RECORD_CONS,
					</cfif>
					RECORD_IP
				) 
				VALUES 
				( 
					#attributes.cpid#, 
					'#attributes.bank_name#',
					'#attributes.bank_code#', 
					'#attributes.iban_code#', 
					'#attributes.money#',
					'#attributes.branch_name#', 
					'#attributes.branch_code#', 
					<cfif isdefined("attributes.default_account")>1<cfelse>0</cfif>,
					'#attributes.account_no#',
					#now()#,
					<cfif isdefined("session.ep.userid")>
					 #session.ep.userid#,
					</cfif>
			 		<cfif isdefined("session.ww.userid")>
					#session.ww.userid#,
					</cfif>
					'#cgi.remote_addr#'
				)
			</cfquery>
			<cfif isdefined("attributes.default_account")>
				<cfquery name="UPD_DEFAULT_OTHER" datasource="#DSN#">
					UPDATE 
						CONSUMER_BANK 
					SET
						CONSUMER_ACCOUNT_DEFAULT = 0
					WHERE
						CONSUMER_ID = #attributes.cpid# AND
						CONSUMER_BANK_ID <> #MAX_ID.IDENTITYCOL#
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
		wrk_opener_reload();
		window.close();
</script>
