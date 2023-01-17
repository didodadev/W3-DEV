<!---ayarlar > cari hesap kapama işleminde ortalama vadeleri cari hesap > ödeme oluştur ekranındaki hesaplamalara göre bulup, yazdırmak için kullanılıyor...  --->
<cfset attributes.customer_type = 1>
<cfset company_type_list= 'borclu,alacakli'>
<cfloop list="#company_type_list#" index="ind_type">
	<cfif ind_type is 'alacakli'>
		<cfset attributes.customer_type = 1>
	<cfelse>
		<cfset attributes.customer_type = 2>
	</cfif>
	<cfquery name="GET_COMP_REMAINDER" datasource="#donem_eski#">
		SELECT 
			C.COMPANY_ID COMPANY_ID,
			ROUND(CRM.BAKIYE,3) BAKIYE,
			CR.ACTION_VALUE,
			CR.ACTION_DATE ACTION_DATE,
			CR.DUE_DATE
		FROM 
			COMPANY_REMAINDER CRM,
			#dsn_alias#.COMPANY C,
			CARI_ROWS CR,
			INVOICE INV
		WHERE 
			CRM.COMPANY_ID = C.COMPANY_ID AND 
		<cfif attributes.customer_type eq 1>
			CR.FROM_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID IN (51,54,55,59,60,63,64,68,690,691,591,592) AND
			ROUND(CRM.BAKIYE,3) < 0 AND
		<cfelse>
			CR.TO_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID IN (50,53,56,58,62,531) AND
			ROUND(CRM.BAKIYE,3) > 0 AND
		</cfif>	
			INV.INVOICE_ID = CR.ACTION_ID AND
			INV.CASH_ID IS NULL AND
			CR.ACTION_DATE < #DATEADD('d',1,now())#
	UNION
		SELECT 
			C.COMPANY_ID COMPANY_ID,
			ROUND(CRM.BAKIYE,3) BAKIYE,
			CR.ACTION_VALUE,
			CR.ACTION_DATE ACTION_DATE,
			CR.DUE_DATE
		FROM 
			COMPANY_REMAINDER CRM,
			#dsn_alias#.COMPANY C,
			CARI_ROWS CR
		WHERE 
			CRM.COMPANY_ID = C.COMPANY_ID AND 
		<cfif attributes.customer_type eq 1>
			CR.FROM_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID = 40 AND
			ROUND(CRM.BAKIYE,3) < 0 AND
		<cfelse>
			CR.TO_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID = 40 AND
			ROUND(CRM.BAKIYE,3) > 0 AND
		</cfif>	
			CR.ACTION_DATE < #DATEADD('d',1,now())#
		ORDER BY
			COMPANY_ID,ACTION_DATE DESC
	</cfquery>
	<cfset avg_due_day = ''>
	<cfoutput query="GET_COMP_REMAINDER" group="COMPANY_ID">
		<cfif GET_COMP_REMAINDER.COMPANY_ID neq GET_COMP_REMAINDER.COMPANY_ID[currentrow-1] and len(avg_due_day)>
			<cfquery name="UPD_CARI_ROWS" datasource="#donem_db#">
				UPDATE
					CARI_ROWS
				SET 
					DUE_DATE = #createodbcdate(DATEADD('d',(-1*avg_due_day),now()))#
				WHERE
					<cfif attributes.customer_type eq 1>
					FROM_CMP_ID=#GET_COMP_REMAINDER.COMPANY_ID[currentrow-1]#
					<cfelse>
					TO_CMP_ID=#GET_COMP_REMAINDER.COMPANY_ID[currentrow-1]#
					</cfif>
					AND ACTION_TYPE_ID = 40
					AND ACTION_ID = -1
			</cfquery> 
			<cfset avg_due_day = 0>
		</cfif>
		<cfset vade_toplam_hesap = 0>
		<cfset toplam_hesap = 0>
		<cfset temp_borc_tutar = abs(BAKIYE)>
		<cfoutput>
			<cfif temp_borc_tutar gte ACTION_VALUE>
				<cfset temp_borc_tutar = temp_borc_tutar - ACTION_VALUE>
				<cfset belge_tutar = ACTION_VALUE>
			<cfelse>
				<cfset belge_tutar = temp_borc_tutar><!--- kalan kismin hepsi --->
				<cfset temp_borc_tutar = temp_borc_tutar - ACTION_VALUE>
			</cfif>
			<cfif belge_tutar gt 0>
				<cfif len(DUE_DATE)><cfset gun_farki = datediff('d',DUE_DATE,now())><cfelse><cfset gun_farki = datediff('d',ACTION_DATE,now())></cfif>
				<cfset vade_toplam_hesap = vade_toplam_hesap + (gun_farki * belge_tutar)>
				<cfset toplam_hesap = toplam_hesap + belge_tutar>
			</cfif>
		</cfoutput>
		<cfif toplam_hesap>
			<cfset avg_due_day = round(vade_toplam_hesap/toplam_hesap)>
		<cfelse>
			<cfset avg_due_day = ''>
		</cfif>	
		<cfif GET_COMP_REMAINDER.COMPANY_ID eq GET_COMP_REMAINDER.COMPANY_ID[GET_COMP_REMAINDER.recordcount]>
			<cfquery name="UPD_CARI_ROWS" datasource="#donem_db#">
				UPDATE
					CARI_ROWS
				SET 
					DUE_DATE = #createodbcdate(DATEADD('d',(-1*avg_due_day),now()))#
				WHERE
					<cfif attributes.customer_type eq 1>
					FROM_CMP_ID=#GET_COMP_REMAINDER.COMPANY_ID#
					<cfelse>
					TO_CMP_ID=#GET_COMP_REMAINDER.COMPANY_ID#
					</cfif>
					AND ACTION_TYPE_ID = 40
					AND ACTION_ID = -1
			</cfquery>
		</cfif>
	</cfoutput>
</cfloop>

