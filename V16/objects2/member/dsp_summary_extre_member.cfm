<cfif not isdefined('attributes.consumer_id') and not isdefined("attributes.company_id")>
	<cfif isDefined("session.pp")>
		<cfset attributes.company_id = session.pp.company_id>
	<cfelseif isDefined("session.ww")>
		<cfset attributes.consumer_id = session.ww.company_id>
	</cfif>
</cfif>
<cfif isdefined("session_base.userid")>
	<cfquery name="GET_OPEN_ACCOUNT_RISK_LIMIT" datasource="#DSN#">
		SELECT 
			OPEN_ACCOUNT_RISK_LIMIT 
		FROM 
			COMPANY_CREDIT 
		WHERE  
		<cfif isdefined('attributes.consumer_id')>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelseif isDefined("attributes.company_id")>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
	</cfquery>
	<cfquery name="GET_ALL_BAKIYE" datasource="#dsn2#">
		SELECT
			BAKIYE		
		FROM
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				COMPANY_RISK
			<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				CONSUMER_RISK
			</cfif>
		WHERE
		 		1 = 1 
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
	</cfquery>
	<h6 class="header-color float-left"><cf_get_lang dictionary_id='40359.Üye Hesap Bakiyesi'></h6>
	<div class="table-responsive-lg">
		<table width="100%" class="table">
			<cfoutput>
				<thead class="main-bg-color">
					<tr>
						<td><cf_get_lang dictionary_id="34449.Bakiye Toplam">#session_base.money#</td>
						<td><cf_get_lang dictionary_id="57875.Açık Hesap Limiti"></td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<cfif get_all_bakiye.recordcount>#TLFormat(get_all_bakiye.bakiye)#<cfelse>O</cfif> #session_base.money#
						</td>
						<td>
							<cfif get_open_account_risk_limit.recordcount>#TLFormat(get_open_account_risk_limit.open_account_risk_limit)#<cfelse>O</cfif> #session_base.money#
						</td>
					</tr>
				</tbody>
			</cfoutput>
		</table>
	</div>
</cfif>