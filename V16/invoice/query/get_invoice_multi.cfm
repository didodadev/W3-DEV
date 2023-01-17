<cfif isdefined('attributes.is_group') and attributes.is_group eq 1>
	<cfquery name="get_invoice" datasource="#dsn2#">
		SELECT
			I.INVOICE_ID,
			'0' MUSTERI_TYPE,
			C.COMPANY_ID MUSTERI_ID,
			C.MEMBER_CODE,
			C.FULLNAME MUSTERI_ADI,
			C.RESOURCE_ID,
			C.TAXOFFICE TAXOFFICE,
			C.TAXNO TAXNO,
			C.COMPANY_TELCODE TEL_CODE,
			C.COMPANY_TEL1 TEL,
			'' SUBSCRIPTION_HEAD,
			'' SUBSCRIPTION_NO,
			C.COMPANY_ADDRESS+' '+C.COMPANY_POSTCODE INVOICE_ADDRESS,
			C.SEMT INVOICE_SEMT,
            (CASE WHEN C.COUNTY IS NOT NULL 
                THEN (SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = C.COUNTY)
                ELSE NULL END
            ) AS INVOICE_COUNTY_NAME,
            (CASE WHEN C.CITY IS NOT NULL 
                THEN (SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = C.CITY)
                ELSE NULL END
            ) AS INVOICE_CITY_NAME,
			ISNULL((SELECT COUNT(SC.SUBSCRIPTION_ID) FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC  WHERE SC.REF_COMPANY_ID=I.COMPANY_ID AND SC.START_DATE >= #CREATEODBCDATE("01/01/2008")#),0) REF_SUBSCRIPTION_COUNT,
			I.INVOICE_NUMBER I_INVOICE_NUMBER,
			I.INVOICE_DATE I_INVOICE_DATE,
			I.OTHER_MONEY_VALUE I_OTHER_MONEY_VALUE,
			I.OTHER_MONEY I_OTHER_MONEY,
			I.GROSSTOTAL I_GROSSTOTAL,
			I.NETTOTAL I_NETTOTAL,
			I.TAXTOTAL I_TAXTOTAL,
			I.INVOICE_MULTI_ID,
            I.DUE_DATE AS I_DUE_DATE,
			(CASE WHEN I.PAY_METHOD IS NOT NULL 
				THEN (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = I.PAY_METHOD)
				ELSE NULL END
			) AS PAY_METHOD_NAME,
			(CASE WHEN I.CARD_PAYMETHOD_ID IS NOT NULL 
				THEN (SELECT CARD_NO PAYMETHOD FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID)
				ELSE NULL END
			) AS CARD_PAYMETHOD_NAME,
			IR.AMOUNT IR_AMOUNT,
			IR.PRICE IR_PRICE,
			IR.UNIT IR_UNIT,
			IR.DISCOUNTTOTAL IR_DISCOUNTTOTAL,
			IR.GROSSTOTAL IR_GROSSTOTAL,
			IR.NETTOTAL IR_NETTOTAL,
			IR.TAXTOTAL IR_TAXTOTAL,
			IR.NAME_PRODUCT IR_NAME_PRODUCT,
			IM.RATE1 IM_RATE1,
			IM.RATE2 IM_RATE2,
            CR.BAKIYE
		FROM 
			#dsn_alias#.COMPANY C,
            COMPANY_REMAINDER CR,
			INVOICE I,
			INVOICE_MONEY IM,
			INVOICE_ROW IR
		WHERE
			I.INVOICE_MULTI_ID=#attributes.invoice_multi_id# AND
			IM.MONEY_TYPE=I.OTHER_MONEY AND
			I.INVOICE_ID=IM.ACTION_ID AND
			I.COMPANY_ID>0 AND
			I.INVOICE_ID=IR.INVOICE_ID AND
			C.COMPANY_ID=I.COMPANY_ID AND
            C.COMPANY_ID = CR.COMPANY_ID
            <cfif session.ep.OUR_COMPANY_INFO.IS_EFATURA>AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE)</cfif>
	UNION ALL
		SELECT
			I.INVOICE_ID,
			'1' MUSTERI_TYPE,
			C.CONSUMER_ID MUSTERI_ID,
			C.MEMBER_CODE,
		<cfif database_type is "MSSQL">
			C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME  MUSTERI_ADI,
		<cfelseif database_type is "DB2">
			C.CONSUMER_NAME ||' '|| C.CONSUMER_SURNAME  MUSTERI_ADI,
		</cfif>
			C.RESOURCE_ID,
			C.TAX_OFFICE TAXOFFICE,
			C.TAX_NO TAXNO,
			C.CONSUMER_HOMETELCODE TEL_CODE,
			C.CONSUMER_HOMETEL TEL,
			'' SUBSCRIPTION_HEAD,
			'' SUBSCRIPTION_NO,
			C.TAX_ADRESS+' '+C.TAX_POSTCODE  INVOICE_ADDRESS,
			C.TAX_SEMT INVOICE_SEMT,
            (CASE WHEN C.TAX_COUNTY_ID IS NOT NULL 
                THEN (SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = C.TAX_COUNTY_ID)
                ELSE NULL END
            ) AS INVOICE_COUNTY_NAME,
            (CASE WHEN C.TAX_CITY_ID IS NOT NULL 
                THEN (SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = C.TAX_CITY_ID)
                ELSE NULL END
            ) AS INVOICE_CITY_NAME,
			ISNULL((SELECT COUNT(SC.SUBSCRIPTION_ID) FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC  WHERE SC.REF_CONSUMER_ID=I.CONSUMER_ID AND SC.START_DATE >= #CREATEODBCDATE("01/01/2008")#),0) REF_SUBSCRIPTION_COUNT,
			I.INVOICE_NUMBER,
			I.INVOICE_DATE,
			I.OTHER_MONEY_VALUE I_OTHER_MONEY_VALUE,
			I.OTHER_MONEY I_OTHER_MONEY,
			I.GROSSTOTAL I_GROSSTOTAL,
			I.NETTOTAL I_NETTOTAL,
			I.TAXTOTAL I_TAXTOTAL,
			I.INVOICE_MULTI_ID,
            I.DUE_DATE AS I_DUE_DATE,
            (CASE WHEN I.PAY_METHOD IS NOT NULL 
				THEN (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = I.PAY_METHOD)
				ELSE NULL END
			) AS PAY_METHOD_NAME,
			(CASE WHEN I.CARD_PAYMETHOD_ID IS NOT NULL 
				THEN (SELECT CARD_NO PAYMETHOD FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID)
				ELSE NULL END
			) AS CARD_PAYMETHOD_NAME,
			IR.AMOUNT IR_AMOUNT,
			IR.PRICE IR_PRICE,
			IR.UNIT IR_UNIT,
			IR.DISCOUNTTOTAL IR_DISCOUNTTOTAL,
			IR.GROSSTOTAL IR_GROSSTOTAL,
			IR.NETTOTAL IR_NETTOTAL,
			IR.TAXTOTAL IR_TAXTOTAL,
			IR.NAME_PRODUCT IR_NAME_PRODUCT,
			IM.RATE1 IM_RATE1,
			IM.RATE2 IM_RATE2,
            CR.BAKIYE
		FROM 			
			#dsn_alias#.CONSUMER C,
            CONSUMER_REMAINDER CR,
			INVOICE I,
			INVOICE_MONEY IM,
			INVOICE_ROW IR
		WHERE
			I.INVOICE_MULTI_ID=#attributes.invoice_multi_id# AND
			IM.MONEY_TYPE=I.OTHER_MONEY AND
			I.INVOICE_ID=IM.ACTION_ID AND
			I.CONSUMER_ID>0 AND
			I.INVOICE_ID=IR.INVOICE_ID AND
			C.CONSUMER_ID=I.CONSUMER_ID AND
            CR.CONSUMER_ID = C.CONSUMER_ID
            <cfif session.ep.OUR_COMPANY_INFO.IS_EFATURA>AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE)</cfif>
	</cfquery>
<cfelse><!--- grup degilse faturalama --->
	<cfquery name="get_invoice" datasource="#dsn3#">
		SELECT
			DISTINCT IR.INVOICE_ROW_ID,
			I.INVOICE_ID,
			'0' MUSTERI_TYPE,
			C.COMPANY_ID MUSTERI_ID,
			C.MEMBER_CODE,
			C.FULLNAME MUSTERI_ADI,
			C.RESOURCE_ID,
			C.TAXOFFICE TAXOFFICE,
			C.TAXNO TAXNO,
			C.COMPANY_TELCODE TEL_CODE,
			C.COMPANY_TEL1 TEL,
			<cfif attributes.from_report neq 1><!--- rapordan donusturulmediyse --->
				SC.SUBSCRIPTION_HEAD,
				SC.SUBSCRIPTION_NO,
				SC.INVOICE_ADDRESS+' '+SC.INVOICE_POSTCODE INVOICE_ADDRESS,
				SC.INVOICE_SEMT,
				(CASE WHEN SC.INVOICE_COUNTY_ID IS NOT NULL 
					THEN (SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = SC.INVOICE_COUNTY_ID)
					ELSE NULL END
				) AS INVOICE_COUNTY_NAME,
				(CASE WHEN SC.INVOICE_CITY_ID IS NOT NULL 
					THEN (SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = SC.INVOICE_CITY_ID)
					ELSE NULL END
				) AS INVOICE_CITY_NAME,
				ISNULL((SELECT COUNT(SC.SUBSCRIPTION_ID) FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC  WHERE SC.REF_COMPANY_ID=I.COMPANY_ID AND SC.START_DATE >= #CREATEODBCDATE("01/01/2008")#),0) REF_SUBSCRIPTION_COUNT,
			</cfif>
			I.INVOICE_NUMBER I_INVOICE_NUMBER,
			I.INVOICE_DATE I_INVOICE_DATE,
			I.OTHER_MONEY_VALUE I_OTHER_MONEY_VALUE,
			I.OTHER_MONEY I_OTHER_MONEY,
			I.GROSSTOTAL I_GROSSTOTAL,
			I.NETTOTAL I_NETTOTAL,
			I.TAXTOTAL I_TAXTOTAL,
			I.INVOICE_MULTI_ID,
            I.DUE_DATE AS I_DUE_DATE,
			(CASE WHEN I.PAY_METHOD IS NOT NULL 
				THEN (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = I.PAY_METHOD)
				ELSE NULL END
			) AS PAY_METHOD_NAME,
			(CASE WHEN I.CARD_PAYMETHOD_ID IS NOT NULL 
				THEN (SELECT CARD_NO PAYMETHOD FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID)
				ELSE NULL END
			) AS CARD_PAYMETHOD_NAME,
			IR.AMOUNT IR_AMOUNT,
			IR.PRICE IR_PRICE,
			IR.UNIT IR_UNIT,
			IR.DISCOUNTTOTAL IR_DISCOUNTTOTAL,
			IR.GROSSTOTAL IR_GROSSTOTAL,
			IR.NETTOTAL IR_NETTOTAL,
			IR.TAXTOTAL IR_TAXTOTAL,
			IR.NAME_PRODUCT IR_NAME_PRODUCT,
			IM.RATE1 IM_RATE1,
			IM.RATE2 IM_RATE2,
            CR.BAKIYE
		FROM 
			#dsn2_alias#.INVOICE I
                RIGHT JOIN #dsn2_alias#.INVOICE_MONEY IM ON IM.MONEY_TYPE=I.OTHER_MONEY AND I.INVOICE_ID=IM.ACTION_ID
                RIGHT JOIN #dsn2_alias#.INVOICE_ROW IR ON I.INVOICE_ID=IR.INVOICE_ID
                RIGHT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID=I.COMPANY_ID
                LEFT JOIN #dsn2_alias#.COMPANY_REMAINDER CR ON CR.COMPANY_ID = C.COMPANY_ID
            <cfif attributes.from_report neq 1><!--- rapordan donusturulmediyse --->
                RIGHT JOIN SUBSCRIPTION_PAYMENT_PLAN_ROW SPR ON SPR.INVOICE_ID=I.INVOICE_ID <!---AND SPR.PERIOD_ID = #session.ep.period_id#--->
                RIGHT JOIN SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID =SPR.SUBSCRIPTION_ID
            </cfif>
		WHERE
			I.INVOICE_MULTI_ID IN (#attributes.invoice_multi_id#) AND
			I.COMPANY_ID > 0
            <cfif session.ep.OUR_COMPANY_INFO.IS_EFATURA>AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE <= I.INVOICE_DATE)</cfif>
	UNION ALL
		SELECT
			DISTINCT IR.INVOICE_ROW_ID,
			I.INVOICE_ID,
			'1' MUSTERI_TYPE,
			C.CONSUMER_ID MUSTERI_ID,
			C.MEMBER_CODE,
		<cfif database_type is "MSSQL">
			C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME  MUSTERI_ADI,
		<cfelseif database_type is "DB2">
			C.CONSUMER_NAME ||' '|| C.CONSUMER_SURNAME  MUSTERI_ADI,
		</cfif>
			C.RESOURCE_ID,
			C.TAX_OFFICE TAXOFFICE,
			C.TAX_NO TAXNO,
			C.CONSUMER_HOMETELCODE TEL_CODE,
			C.CONSUMER_HOMETEL TEL,
			<cfif attributes.from_report neq 1><!--- rapordan donusturulmediyse --->
				SC.SUBSCRIPTION_HEAD,
				SC.SUBSCRIPTION_NO,
				SC.INVOICE_ADDRESS+' '+SC.INVOICE_POSTCODE INVOICE_ADDRESS,
				SC.INVOICE_SEMT,
				(CASE WHEN SC.INVOICE_COUNTY_ID IS NOT NULL 
					THEN (SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = SC.INVOICE_COUNTY_ID)
					ELSE NULL END
				) AS INVOICE_COUNTY_NAME,
				(CASE WHEN SC.INVOICE_CITY_ID IS NOT NULL 
					THEN (SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = SC.INVOICE_CITY_ID)
					ELSE NULL END
				) AS INVOICE_CITY_NAME,
				ISNULL((SELECT COUNT(SC.SUBSCRIPTION_ID) FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC  WHERE SC.REF_CONSUMER_ID=I.CONSUMER_ID AND SC.START_DATE >= #CREATEODBCDATE("01/01/2008")#),0) REF_SUBSCRIPTION_COUNT,
			</cfif>
			I.INVOICE_NUMBER,
			I.INVOICE_DATE,
			I.OTHER_MONEY_VALUE I_OTHER_MONEY_VALUE,
			I.OTHER_MONEY I_OTHER_MONEY,
			I.GROSSTOTAL I_GROSSTOTAL,
			I.NETTOTAL I_NETTOTAL,
			I.TAXTOTAL I_TAXTOTAL,
			I.INVOICE_MULTI_ID,
            I.DUE_DATE AS I_DUE_DATE,
			(CASE WHEN I.PAY_METHOD IS NOT NULL 
				THEN (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = I.PAY_METHOD)
				ELSE NULL END
			) AS PAY_METHOD_NAME,
			(CASE WHEN I.CARD_PAYMETHOD_ID IS NOT NULL 
				THEN (SELECT CARD_NO PAYMETHOD FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID)
				ELSE NULL END
			) AS CARD_PAYMETHOD_NAME,
			IR.AMOUNT IR_AMOUNT,
			IR.PRICE IR_PRICE,
			IR.UNIT IR_UNIT,
			IR.DISCOUNTTOTAL IR_DISCOUNTTOTAL,
			IR.GROSSTOTAL IR_GROSSTOTAL,
			IR.NETTOTAL IR_NETTOTAL,
			IR.TAXTOTAL IR_TAXTOTAL,
			IR.NAME_PRODUCT IR_NAME_PRODUCT,
			IM.RATE1 IM_RATE1,
			IM.RATE2 IM_RATE2,
            CR.BAKIYE
		FROM 
            #dsn2_alias#.INVOICE I
                RIGHT JOIN #dsn2_alias#.INVOICE_ROW IR ON I.INVOICE_ID=IR.INVOICE_ID
                RIGHT JOIN #dsn2_alias#.INVOICE_MONEY IM ON IM.MONEY_TYPE=I.OTHER_MONEY AND I.INVOICE_ID=IM.ACTION_ID
                RIGHT JOIN #dsn_alias#.CONSUMER C ON C.CONSUMER_ID=I.CONSUMER_ID  
                LEFT JOIN #dsn2_alias#.CONSUMER_REMAINDER CR ON CR.CONSUMER_ID = C.CONSUMER_ID
			<cfif attributes.from_report neq 1><!--- rapordan donusturulmediyse --->
                RIGHT JOIN SUBSCRIPTION_PAYMENT_PLAN_ROW SPR ON SPR.INVOICE_ID=I.INVOICE_ID <!---AND SPR.PERIOD_ID = #session.ep.period_id# --->
                RIGHT JOIN SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID =SPR.SUBSCRIPTION_ID
            </cfif>
		WHERE
			I.INVOICE_MULTI_ID IN (#attributes.invoice_multi_id#) AND
			I.CONSUMER_ID > 0
            <cfif session.ep.OUR_COMPANY_INFO.IS_EFATURA>AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE)</cfif>
		ORDER BY
			I.INVOICE_ID
	</cfquery>
</cfif>
