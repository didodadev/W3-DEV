<!--- 
	Merkez Bankasından günlük kurları alıp sistemde gündemde piyasalar bölümünde gözükmesini sağlar,currency_code üzerinden karşılaştırarak getirir
	Ayşenur20080403
 --->
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cftry>
	<cfset urlAddress="https://www.tcmb.gov.tr/kurlar/today.xml">
	<cfhttp url="#urladdress#" method="GET" resolveurl="Yes" throwOnError="Yes"/>
	<cfset xmlDoc = XmlParse(CFHTTP.FileContent)>
	<cfset resources=xmlDoc.xmlroot.xmlChildren>
	<cfset numresources=ArrayLen(resources)>
	<cfoutput query="GET_MONEY">
		<cfset money_info = GET_MONEY.MONEY>
		<cfloop from="1" to="#numresources#" index="i">
			<cfif ArrayLen(resources[i].xmlChildren) eq 9 and resources[i].XmlAttributes.CurrencyCode eq CURRENCY_CODE>
				<cfquery name="UPD_DSP_RATE_INFO" datasource="#dsn#">
					UPDATE
						SETUP_MONEY
					SET<!--- sadece piyasalar için gösterimlik alanlardır --->
						DSP_RATE_SALE = '#resources[i].ForexSelling.XmlText#',
						DSP_RATE_PUR = '#resources[i].ForexBuying.XmlText#',
						DSP_UPDATE_DATE = #now()#,
						DSP_EFFECTIVE_SALE = '#resources[i].BanknoteSelling.XmlText#',
						DSP_EFFECTIVE_PUR = '#resources[i].BanknoteBuying.XmlText#'
					WHERE
						MONEY = '#money_info#'
				</cfquery>
			</cfif>
		</cfloop>
	</cfoutput>
	<cfcatch>
 	</cfcatch>
</cftry>
