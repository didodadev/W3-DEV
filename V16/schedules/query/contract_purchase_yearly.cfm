<cfscript>
if (DateFormat(now(),'dd/mm/') IS '01/01/')
	{
	yearnow = YEAR(NOW())-1;
	tarih1 = CreateDate( yearnow, 1, 1 );
	tarih2 = CreateDate( yearnow, 12, 31 );
	}
</cfscript>
<cfif (DateFormat(now(),'dd/mm/') IS '01/01/')>

	<!--- 
	,	#GET_TOTAL([COMPANY_ID/CONSUMER ID],TYPE(consumer ise 2 comp ise 1),tarih1,tarih2)#
	 --->
	<CFFUNCTION name="GET_TOTAL" >
		<cfargument name="get_id">
		<cfargument name="get_type">
		<cfargument name="date1">
		<cfargument name="date2">
		<cfquery datasource="#DSN2#" name="GET_TOTAL_OF"> 
			SELECT
				SUM(GROSSTOTAL) AS TOTAL
			FROM
				INVOICE
			WHERE
			<cfif get_type eq 1>
				COMPANY_ID=#get_id#
			<cfelse>	
				CONSUMER_ID=#get_id#
			</cfif>
			AND
				PURCHASE_SALES=0
			AND
			INVOICE_DATE >= #date1# 
			AND
			INVOICE_DATE <= #date2# 
		</cfquery>
		<cfreturn GET_TOTAL_OF.TOTAL>
	</CFFUNCTION>
	
	<cfquery datasource="#DSN3#" name="GET_CONTRACT_PURCHASE_GENERAL_PREMIUM">
	SELECT
		CONTRACT.COMPANY, CPGP.YEARLY, CPGP.YEARLY_PREMIUM, CPGP.YEARLY_MONEY, CPGP.CONTRACT_ID
	FROM
		CONTRACT,
		CONTRACT_PURCHASE_GENERAL_PREMIUM AS CPGP
	WHERE
		OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
		AND
		CONTRACT.CONTRACT_ID = CPGP.CONTRACT_ID
		AND
		CONTRACT.STATUS = 1 
	</cfquery>
	
	<cfoutput query="GET_CONTRACT_PURCHASE_GENERAL_PREMIUM">
		<cfset COMPANY_ID = ListFirst(ListSort(COMPANY,"numeric"))>
		<cfset total = GET_TOTAL(COMPANY_ID,1,tarih1,tarih2)>
		<cfif total IS "">
			<cfset total = 0>
		</cfif>
		<cfif IsNumeric(YEARLY) AND IsNumeric(YEARLY_PREMIUM) AND total GTE YEARLY>
			<cfset primmiktar = total*YEARLY_PREMIUM/100>
		<cfelse>
			<cfset primmiktar = 0>
		</cfif>
		<cfif primmiktar GT 0>
			<cfquery datasource="#DSN3#" name="INS_CONTRACT_PREMIUM">
			INSERT INTO
				CONTRACT_INVOICE_COMMANDS
				(
				CONTRACT_ID, COMPANY_ID, AMOUNT, IS_INVOICE, REASON
				)
			VALUES
				(
				#CONTRACT_ID#, #COMPANY_ID#, #primmiktar#, 0, 'Yıllık ciro primi'
				)
			</cfquery>
		</cfif>
	</cfoutput> 

</cfif>

