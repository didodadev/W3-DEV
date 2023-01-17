<!--- Sayfa, bireysel üye cari dönem kapama işleminde açılış fişlerine ortalama vadelerin yazdırılması için kullanılıyor --->
<cfset attributes.customer_type = 1>
<cfset company_type_list= 'borclu,alacakli'>
<cfloop list="#company_type_list#" index="ind_type">
	<cfif ind_type is 'alacakli'>
		<cfset attributes.customer_type = 1>
	<cfelse>
		<cfset attributes.customer_type = 2>
	</cfif>
	<cfquery name="GET_CONS_REMAINDER" datasource="#donem_eski#">
		SELECT	
			(SUM(ACTION_VALUE*DATEDIFF(dd,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)))/SUM(ACTION_VALUE)) AS AVG_DUE_DAY,
			<cfif attributes.customer_type eq 1>
			FROM_CONSUMER_ID AS CONSUMER_ID
			<cfelse>
			TO_CONSUMER_ID AS CONSUMER_ID
			</cfif>
		FROM	
			CARI_ROWS
		WHERE
			<cfif attributes.customer_type eq 1>
			FROM_CONSUMER_ID IS NOT NULL
			<cfelse>
			TO_CONSUMER_ID IS NOT NULL
			</cfif>
			AND DATEDIFF(dd,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) <> 0
			AND ACTION_VALUE <> 0
		GROUP BY 
			<cfif attributes.customer_type eq 1>
			FROM_CONSUMER_ID
			<cfelse>
			TO_CONSUMER_ID
			</cfif>
	</cfquery>
	<cfset avg_due_day = ''>
	<cfoutput query="GET_CONS_REMAINDER">
		<cfquery name="UPD_CARI_ROWS" datasource="#donem_db#">
			UPDATE
				CARI_ROWS
			SET 
				DUE_DATE = #DATEADD('d',AVG_DUE_DAY,islem_tarihi)#
			WHERE
				<cfif attributes.customer_type eq 1>
				FROM_CONSUMER_ID=#CONSUMER_ID#
				<cfelse>
				TO_CONSUMER_ID=#CONSUMER_ID#
				</cfif>
				AND ACTION_TYPE_ID = 40
				AND ACTION_ID = -1
		</cfquery>
	</cfoutput>
</cfloop>

