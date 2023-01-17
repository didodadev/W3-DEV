<cfif isdefined('session.ww.userid')>
	<table border="0" style="width:100%;">
		<cfquery name="GET_BAKIYE" datasource="#DSN2#">
			SELECT 
				BAKIYE, 
				BORC, 
				ALACAK 
			FROM 
				CONSUMER_REMAINDER 
			WHERE  
				<cfif isdefined('attributes.consumer_id')> 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
                <cfelse> 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                </cfif>
		</cfquery>
		<cfquery name="GET_RISK_LIMIT" datasource="#DSN#">
			SELECT 
				OPEN_ACCOUNT_RISK_LIMIT 
			FROM 
				COMPANY_CREDIT 
			WHERE 
				<cfif isdefined('attributes.consumer_id')> 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                </cfif>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
		</cfquery>
		<cfquery name="GET_CONS" datasource="#DSN#">
			SELECT MEMBER_CODE, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE <cfif isdefined('attributes.consumer_id')> CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> <cfelse> CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"></cfif>
		</cfquery>
		<cfif get_bakiye.recordcount>
		  <cfset borc = get_bakiye.borc>
		  <cfset alacak = get_bakiye.alacak>
		  <cfset bakiye = get_bakiye.bakiye>
		<cfelse>
		  <cfset borc = 0>
		  <cfset alacak = 0>
		  <cfset bakiye = 0>
		</cfif>
		<cfoutput>
			<tr>
				<td class="formbold">Üye Adı:</td>
				<td>#get_cons.consumer_name# #get_cons.consumer_surname# (#get_cons.member_code#)</td>
			</tr>
			<tr>
				<td  class="formbold">Bakiye Toplam : </td>
				<td>#TLFormat(ABS(bakiye))#&nbsp;#session_base.money#<cfif borc gte alacak>(B)<cfelse>(A)</cfif></td>
			</tr>
			<tr>
				<td  class="formbold">Açık Hesap Limiti :</td>
				<td><cfif len(get_risk_limit.open_account_risk_limit)>#TLFormat(get_risk_limit.open_account_risk_limit)#<cfelse>O</cfif>&nbsp;#session_base.money#</td>
			</tr>
		</cfoutput>
	</table>		
</cfif>
