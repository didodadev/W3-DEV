<cfif isdefined("session_base.userid")>
	<cfquery name="GET_BAKIYE" datasource="#DSN2#">
		SELECT
			BORC,
			ALACAK,
			BAKIYE,
			BORC2,
			ALACAK2,
			BAKIYE2,
			BORC3,
			ALACAK3,
			BAKIYE3,
			OTHER_MONEY
		FROM
			<cfif isdefined("session.pp")>
				COMPANY_REMAINDER_MONEY
			<cfelse>
				CONSUMER_REMAINDER_MONEY	
			</cfif>
		WHERE
			<cfif isdefined("session.pp")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
	</cfquery>
	<cfquery name="GET_ALL_BAKIYE" datasource="#DSN2#">
		SELECT
			BAKIYE,
			TOTAL_RISK_LIMIT,
			CEK_ODENMEDI,
			SENET_ODENMEDI,
			CEK_KARSILIKSIZ,
			SENET_KARSILIKSIZ		
		FROM
			<cfif isdefined("session.pp")>
				COMPANY_RISK
			<cfelse>
				CONSUMER_RISK
			</cfif>
		WHERE
			<cfif isdefined("session.pp")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
	</cfquery>
	<table style="width:100%;">
		<tr>
			<td align="center">
			<b><cf_get_lang no="128.Bakiye Toplam"> <cfoutput>#session_base.money#</b> <br/><cfif get_all_bakiye.recordcount>#TLFormat(get_all_bakiye.bakiye)#</cfif></cfoutput><br/>
			<cfoutput query="get_bakiye">
				<b>#other_money# <cf_get_lang_main no="177.Bakiye"><br/></b> #TLFormat(bakiye3)#<br/>
			</cfoutput>
			<b><cf_get_lang_main no ='466.Kullanılabilir Limit'> <cfoutput>#session_base.money#</b> <br/><cfif get_all_bakiye.recordcount>#TLFormat(get_all_bakiye.total_risk_limit - (get_all_bakiye.bakiye  + (get_all_bakiye.cek_odenmedi + get_all_bakiye.senet_odenmedi + get_all_bakiye.cek_karsiliksiz + get_all_bakiye.senet_karsiliksiz)))#</cfif></cfoutput><br/>
			<cfoutput>
				<cfif isdefined("session.pp.company_id") and len(session.pp.company_id)>
					<b><a href="index.cfm?fuseaction=objects2.list_extre&is_doviz_group=1&company_id=#session.pp.company_id#&company=#session.pp.company#&member_type=partner">>> <cf_get_lang no="129.Detaylı Extre">.</a></b>
				<cfelseif isdefined("session.ww.userid") and len(session.ww.userid)> 	
					<b><a href="index.cfm?fuseaction=objects2.list_extre&is_doviz_group=1&consumer_id=#session.ww.userid#">>> <cf_get_lang no="129.Detaylı Extre">.</a></b>
				</cfif>
			</cfoutput>
			</td>
		</tr>   
	</table>
</cfif>
		

