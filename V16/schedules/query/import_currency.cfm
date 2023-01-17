<!--- 
	Merkez Bankasından günlük kurları alıp sistemdeki aktif kurları değiştirir,currency_code üzerinden karşılaştırarak getirir
	Ayşenur20080403
 --->
<cfset curr_code = "">
<cfset curr_sale = "">
<cfset curr_pur = "">
<cfquery name="GET_SCHEDULE" datasource="#dsn#">
	SELECT ISNULL(RELATED_COMPANY_INFO,0) RELATED_COMPANY_INFO FROM SCHEDULE_SETTINGS WHERE SCHEDULE_ID = #attributes.schedule_id#
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE RATE1 <> RATE2 AND COMPANY_ID IN (#valuelist(get_schedule.related_company_info)#) AND PERIOD_ID IN(SELECT SP.PERIOD_ID FROM SETUP_PERIOD SP WHERE SP.PERIOD_YEAR = #year(now())#)
</cfquery>
<cfif isdefined("is_purchase_act")><cfset attributes.is_purchase_act = is_purchase_act></cfif>
<cftry>
	<cfset urlAddress="https://www.tcmb.gov.tr/kurlar/today.xml">
	<cfhttp url="#urladdress#" method="GET" resolveurl="Yes" throwOnError="Yes"/>
	<cfset xmlDoc = XmlParse(CFHTTP.FileContent)>
	<cfset resources=xmlDoc.xmlroot.xmlChildren>
	<cfset numresources=ArrayLen(resources)>
	<cfoutput query="GET_MONEY">
		<cfset money_info = GET_MONEY.MONEY>
		<cfset comp_info = GET_MONEY.COMPANY_ID>
		<cfset period_info = GET_MONEY.PERIOD_ID>
		<cfloop from="1" to="#numresources#" index="i">
			<cfif ArrayLen(resources[i].xmlChildren) eq 9 and (resources[i].XmlAttributes.CurrencyCode eq CURRENCY_CODE or (CURRENCY_CODE is 'POUND' and resources[i].XmlAttributes.CurrencyCode is 'GBP'))>
				
				<cfset curr_code = resources[i].XmlAttributes.CurrencyCode>
				<cfset curr_sale = resources[i].ForexSelling.XmlText>
				<cfset curr_pur = resources[i].ForexBuying.XmlText>
				<cfif len(resources[i].BanknoteSelling.XmlText)>
					<cfset eff_sale = resources[i].BanknoteSelling.XmlText>
				<cfelse>
					<cfset eff_sale = resources[i].ForexSelling.XmlText>
				</cfif>
				<cfif len(resources[i].BanknoteBuying.XmlText)>
					<cfset eff_pur = resources[i].BanknoteBuying.XmlText>
				<cfelse>
					<cfset eff_pur = resources[i].ForexBuying.XmlText>
				</cfif>
				
				<cfquery name="UPD_SETUP_MONEY" datasource="#dsn#">
					UPDATE
						SETUP_MONEY
					SET<!--- is_purchase_act  değişkeni gelirse, tüm sistem alış kurlarndan çalışsn denip,bizdeki alanlara tersten yazılmktadr. --->
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATE3<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>EFFECTIVE_SALE<cfelse>RATE2</cfif> = '#resources[i].ForexSelling.XmlText#',
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATE2<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>EFFECTIVE_PUR<cfelse>RATE3</cfif> = '#resources[i].ForexBuying.XmlText#',
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>
							RATEPP2 = '#resources[i].BanknoteSelling.XmlText#',
						<cfelse>
							<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEPP3<cfelse>RATEPP2</cfif> = '#resources[i].ForexSelling.XmlText#',
						</cfif>
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEPP2<cfelse>RATEPP3</cfif> = '#resources[i].ForexBuying.XmlText#',
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEWW3<cfelse>RATEWW2</cfif> = '#resources[i].ForexSelling.XmlText#',
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEWW2<cfelse>RATEWW3</cfif> = '#resources[i].ForexBuying.XmlText#',
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>EFFECTIVE_PUR<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>RATE2<cfelse>EFFECTIVE_SALE</cfif> = #eff_sale#,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>EFFECTIVE_SALE<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>RATE3<cfelse>EFFECTIVE_PUR</cfif> = #eff_pur#,
						UPDATE_DATE = #now()#,
						UPDATE_EMP = 1
					WHERE
						MONEY = '#money_info#' AND
						COMPANY_ID = #comp_info# AND
						PERIOD_ID = #period_info#
				</cfquery>
				
				<cfquery name="INSMONEY" datasource="#dsn#">
					INSERT INTO 
						MONEY_HISTORY
					(
						MONEY,
						COMPANY_ID,
						PERIOD_ID,
						RATE1,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATE3<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>EFFECTIVE_SALE<cfelse>RATE2</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATE2<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>EFFECTIVE_PUR<cfelse>RATE3</cfif>,
						VALIDATE_DATE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEPP3<cfelse>RATEPP2</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEPP2<cfelse>RATEPP3</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEWW3<cfelse>RATEWW2</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>RATEWW2<cfelse>RATEWW3</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>EFFECTIVE_PUR<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>RATE2<cfelse>EFFECTIVE_SALE</cfif>,
						<cfif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 1>EFFECTIVE_SALE<cfelseif isdefined("attributes.is_purchase_act") and attributes.is_purchase_act eq 2>RATE3<cfelse>EFFECTIVE_PUR</cfif>
					) 
					VALUES 
					(
						'#money_info#',
						#comp_info#,
						#period_info#,
						<cfif money_info is 'JPY' or money_info is 'IRR'>100<cfelse>1</cfif>,
						#curr_sale#,
						#curr_pur#,
						#CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')#,
						#now()#,
						1,
						'#CGI.REMOTE_ADDR#',
						#curr_sale#,
						#curr_pur#,
						#curr_sale#,
						#curr_pur#,
						<cfif len(eff_sale)>#eff_sale#<cfelse>NULL</cfif>,
						<cfif len(eff_pur)>#eff_pur#<cfelse>NULL</cfif>
					)
				</cfquery>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfoutput>
	<cfcatch type="any">
 	</cfcatch>
</cftry>
<cfabort>

