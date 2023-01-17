<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
		<!--- Bireysel Uye ise --->
		<cfif isdefined("attributes.cid")>
			<cfquery name="UPD_BANK" datasource="#DSN#">
				UPDATE 
					CONSUMER_BANK
				SET 
					CONSUMER_BANK = '#attributes.bank_name#', 
					MONEY = '#attributes.money#', 
					CONSUMER_BANK_BRANCH ='#attributes.branch_name#', 
					CONSUMER_BANK_BRANCH_CODE = '#attributes.branch_code#',
					CONSUMER_BANK_CODE = '#attributes.bank_code#',
					CONSUMER_IBAN_CODE = '#attributes.iban_code#',
					CONSUMER_ACCOUNT_DEFAULT = <cfif isDefined("attributes.default_account")>1<cfelse>0</cfif>,
					CONSUMER_ACCOUNT_NO = '#attributes.account_no#',
					UPDATE_DATE = #now()#,
					<cfif isdefined("session.ep.userid")>
					UPDATE_CONS = NULL,
					UPDATE_EMP = #session.ep.userid#,
					</cfif>
					<cfif isdefined("session.ww.userid")>
					UPDATE_CONS = #session.ww.userid#,
					UPDATE_EMP = NULL,
					</cfif>
					UPDATE_IP = '#cgi.remote_addr#'
				WHERE 
					CONSUMER_BANK_ID = #attributes.bid#
			</cfquery>
			<cfif isdefined("attributes.default_account")>
				<cfquery name="UPD_DEFAULT_OTHER" datasource="#DSN#">
					UPDATE 
						CONSUMER_BANK 
					SET
						CONSUMER_ACCOUNT_DEFAULT = 0
					WHERE
						CONSUMER_ID = #attributes.cid# AND
						CONSUMER_BANK_ID <> #attributes.bid#
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
 
	

