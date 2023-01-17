<!--- TolgaS 20080523 ba-bs raporları
	uyarı:  belge toplamlardında otvlerde total otv yok yapıldığında düzenlenmeli ayrıca işlem tiplerine demirbaş eklenecek
	FBS xml eklendi,alis ve satisin ikisinin birden secilmesi icin duzenlemeler yapildi, xml duzenlendi, s.sonu toplamlar eklendi

	23052019 ilkerAltındal -- aynı vergi noya sahip carilerin tek bir satırda gruplanmış halde getirilmesi sağlandı, ana query' de düzenlemeler yapıldı.

	12022020 EmineYavaş -- XML'den Cariler Gruplanarak Getirilsin seçeneği kaldırıldı bunun yerine rapora checkbox olarak eklendi. Gruplanan Carilerden Sadece Birini Getir seçeneği ile satırda gruplanan carilerden sadece ilkinin getirilmesi sağlandı.(Sadece Türkiye'deki cariler için geçerlidir.)
--->
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="report.report_ba_bs">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_knt" default="">
<cfparam name="attributes.is_xml" default="">
<cfparam name="attributes.is_relation" default="">
<cfparam name="attributes.relation_type" default="">
<cfparam name="attributes.process_type_ba" default="">
<cfparam name="attributes.process_type_bs" default="">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#DateAdd('d',-1,attributes.finishdate)#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset kurumsal = ''>
<cfset bireysel = ''>
<cfif len(attributes.relation_type)>
	<cfif len(attributes.relation_type) and listfirst(attributes.relation_type,'-') eq 1>
		<cfset kurumsal = listappend(kurumsal,listlast(attributes.relation_type,'-'))>
	<cfelseif len(attributes.relation_type) and listfirst(attributes.relation_type,'-') eq 2>
		<cfset bireysel = listappend(bireysel,listlast(attributes.relation_type,'-'))>
	</cfif>
</cfif>
<cfset bs_process_types = "6,48,50,52,53,56,57,58,62,66,531,532,561,121,533,5311">
<cfset ba_process_types = "12,49,51,54,55,59,60,61,63,64,65,68,591,592,601,690,691,120,1201">
<cfquery name="get_process_cat_bs" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#bs_process_types#) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="get_process_cat_ba" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#ba_process_types#) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="GET_REL_SETUP_COMP" datasource="#dsn#">
	SELECT PARTNER_RELATION_ID SETUP_REL_ID,PARTNER_RELATION SETUP_REL_NAME FROM SETUP_PARTNER_RELATION ORDER BY PARTNER_RELATION
</cfquery>
<cfquery name="GET_REL_SETUP_CONS" datasource="#dsn#">
	SELECT CONSUMER_RELATION_ID SETUP_REL_ID,CONSUMER_RELATION SETUP_REL_NAME FROM SETUP_CONSUMER_RELATION ORDER BY CONSUMER_RELATION
</cfquery>
<cfif isdefined("attributes.form_varmi")>

	<cfif len(attributes.process_type_ba) and len(attributes.process_type_bs)>
		<cfset attributes.process_type = attributes.process_type_ba&','&attributes.process_type_bs>
	<cfelseif len(attributes.process_type_ba)>
		<cfset attributes.process_type=attributes.process_type_ba>
	<cfelseif len(attributes.process_type_bs)>
		<cfset attributes.process_type=attributes.process_type_bs>
	</cfif>
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	
	<cfif isdefined("attributes.is_carigrup")>
		<cfquery name="XML_BA_BS" datasource="#DSN2#">
			SELECT
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
				FAX,
				FAX_CODE,
				MAIL,
				ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
				CITY_NAME,
				COUNTRY_NAME,
				SUM(PAPER_COUNT_BA) BA_PAPER_COUNT,
				SUM(PAPER_COUNT_BS) BS_PAPER_COUNT,
				<cfif x_add_otv_to_total eq 1>
					SUM(BA_TOTAL+BA_OTVTOTAL) BA_TOTAL
				<cfelse>
					SUM(BA_TOTAL) BA_TOTAL
				</cfif>,
				<cfif x_add_otv_to_total eq 1>
					SUM(BS_TOTAL+BS_OTVTOTAL) BS_TOTAL
				<cfelse>
					SUM(BS_TOTAL) BS_TOTAL
				</cfif>,
				SUM(TAX_TOTAL) TAX_TOTAL,
				SUM(OTV_TOTAL) OTV_TOTAL,
				SUM(OIV_TOTAL) OIV_TOTAL
			FROM
			(
				SELECT
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					FAX,
					FAX_CODE,
					MAIL,
					ADDRESS,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID,
					CITY_NAME,
					COUNTRY_NAME,
					COUNT(BA_COUNT) PAPER_COUNT_BA,
					COUNT(BS_COUNT) PAPER_COUNT_BS,
					SUM(BA_NETTOTAL-BA_DISCOUNT) BA_TOTAL,
					SUM(BS_NETTOTAL-BS_DISCOUNT) BS_TOTAL,
					SUM(TAX_TOTAL) TAX_TOTAL,
					SUM(BS_OTVTOTAL) BS_OTVTOTAL,
					SUM(BA_OTVTOTAL) BA_OTVTOTAL,
					SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
					SUM(BS_OIVTOTAL) BS_OIVTOTAL,
					SUM(BA_OIVTOTAL) BA_OIVTOTAL,
					SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				FROM
				(
					SELECT
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
						I.COMPANY_ID,
						NULL CONSUMER_ID,
						C.FULLNAME,
						C.MEMBER_CODE,
						C.TAXOFFICE,
						C.TAXNO,
						C.COMPANY_FAX FAX,
						C.COMPANY_TELCODE FAX_CODE,
						C.COMPANY_EMAIL MAIL,
						C.COMPANY_ADDRESS ADDRESS,
						(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
						C.CITY CITY_ID,
						C.COUNTRY COUNTRY_ID,
						SETUP_CITY.CITY_NAME,
						SETUP_COUNTRY.COUNTRY_NAME,
						SUM(I.TAXTOTAL)/COUNT(IR.INVOICE_ID) TAX_TOTAL,
						<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					FROM
						#dsn_alias#.COMPANY C 
						LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
						LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
						INVOICE_ROW IR,
						INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
					WHERE
						I.COMPANY_ID = C.COMPANY_ID AND
						IR.INVOICE_ID = I.INVOICE_ID AND
						I.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND 1=0
							</cfif>
						</cfif>
						<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND I.COMPANY_ID IN (#attributes.row_company#)
						<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND 1=0
						</cfif>
						<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
							AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
						</cfif>
							<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.COMPANY_ID IN
							(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ERA.ACTION_ID IS NULL
							AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
							AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ER.ACTION_ID  IS NULL
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND COUNTRY_NAME <> 'Türkiye'

						AND I.PROCESS_CAT IN (#attributes.process_type#)
					GROUP BY
						I.INVOICE_CAT,
						I.INVOICE_ID,
						I.COMPANY_ID,
						C.FULLNAME,
						C.MEMBER_CODE,
						C.TAXOFFICE,
						C.TAXNO,
						C.COMPANY_FAX,
						C.COMPANY_TELCODE,
						C.COMPANY_EMAIL,
						C.COMPANY_ADDRESS,
						C.MANAGER_PARTNER_ID,
						C.CITY,
						C.COUNTRY,
						SETUP_CITY.CITY_NAME,
						SETUP_COUNTRY.COUNTRY_NAME,
						I.SA_DISCOUNT
				UNION ALL
					SELECT
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
						NULL,
						I.CONSUMER_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						C.MEMBER_CODE,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						C.CONSUMER_FAX FAX,
						C.CONSUMER_FAXCODE FAX_CODE,
						C.CONSUMER_EMAIL MAIL,
						C.TAX_ADRESS ADDRESS,
						C.TC_IDENTY_NO,
						C.HOME_CITY_ID CITY_ID,
						C.HOME_COUNTRY_ID COUNTRY_ID,
						SETUP_CITY.CITY_NAME,
						SETUP_COUNTRY.COUNTRY_NAME,
						SUM(I.TAXTOTAL)/COUNT(I.INVOICE_ID) TAX_TOTAL,
						<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					FROM
						#dsn_alias#.CONSUMER C
						LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
						LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
						INVOICE_ROW IR,
						INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
					WHERE
						I.CONSUMER_ID = C.CONSUMER_ID AND
						IR.INVOICE_ID = I.INVOICE_ID AND
						I.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND 1=0
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							</cfif>
						</cfif>
						<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
							AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
						</cfif>
						<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
						</cfif>
						<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND I.CONSUMER_ID IN (#attributes.row_consumer#)
						<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND 1=0
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ERA.ACTION_ID IS NULL
							AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
							AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ER.ACTION_ID  IS NULL
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND I.PROCESS_CAT IN (#attributes.process_type#)
						AND COUNTRY_NAME <> 'Türkiye'
					GROUP BY
						I.INVOICE_CAT,
						I.INVOICE_ID,
						I.CONSUMER_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
						C.MEMBER_CODE,
						C.TAX_OFFICE,
						C.TAX_NO,
						C.CONSUMER_FAX,
						C.CONSUMER_FAXCODE,
						C.CONSUMER_EMAIL,
						C.TAX_ADRESS,
						C.TC_IDENTY_NO,
						C.HOME_CITY_ID,
						C.HOME_COUNTRY_ID,
						SETUP_CITY.CITY_NAME,
						SETUP_COUNTRY.COUNTRY_NAME,
						I.SA_DISCOUNT
				) T1
				GROUP BY
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					FAX,
					FAX_CODE,
					MAIL,
					ADDRESS,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID,
					CITY_NAME,
					COUNTRY_NAME
			UNION ALL
				SELECT
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					FAX,
					FAX_CODE,
					MAIL,
					ADDRESS,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID,
					CITY_NAME,
					COUNTRY_NAME,
					COUNT(BA_COUNT) PAPER_COUNT_BA,
					COUNT(BS_COUNT) PAPER_COUNT_BS,
					SUM(BA_NETTOTAL) BA_TOTAL,
					SUM(BS_NETTOTAL) BS_TOTAL,
					SUM(TAX_TOTAL) TAX_TOTAL,
					SUM(BS_OTVTOTAL) BS_OTVTOTAL,
					SUM(BA_OTVTOTAL) BA_OTVTOTAL,
					SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
					SUM(BS_OIVTOTAL) BS_OIVTOTAL,
					SUM(BA_OIVTOTAL) BA_OIVTOTAL,
					SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				FROM
					(
						SELECT
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
							E.CH_COMPANY_ID COMPANY_ID,
							NULL CONSUMER_ID,
							FULLNAME,
							C.MEMBER_CODE,
							C.TAXOFFICE TAXOFFICE,
							C.TAXNO TAXNO,
							C.COMPANY_FAX FAX,
							C.COMPANY_TELCODE FAX_CODE,
							C.COMPANY_EMAIL MAIL,
							C.COMPANY_ADDRESS ADDRESS,
							(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
							C.CITY CITY_ID,
							C.COUNTRY COUNTRY_ID,
							SETUP_CITY.CITY_NAME,
							SETUP_COUNTRY.COUNTRY_NAME,
							SUM(E.KDV_TOTAL) TAX_TOTAL,
							<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						FROM
							
							#dsn_alias#.COMPANY C
							LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
							LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
							EXPENSE_ITEM_PLANS E
							<cfif session.ep.our_company_info.is_efatura>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
							</cfif>
							<cfif session.ep.our_company_info.is_earchive>
								LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							</cfif> 
						WHERE
							E.CH_COMPANY_ID = C.COMPANY_ID
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
								AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							</cfif>
							<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>
							<cfif isdefined('attributes.company') and len(attributes.company)>
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND 1 = 0
								</cfif>
							</cfif>
							<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
								AND E.CH_COMPANY_ID IN (#attributes.row_company#)
							<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
								AND 1=0
							</cfif>
							<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
								AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
							</cfif>
								<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.COMPANY_ID IN
							(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
							AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0 
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND COUNTRY_NAME <> 'Türkiye'
							

							AND E.PROCESS_CAT IN (#attributes.process_type#)
						GROUP BY
							E.ACTION_TYPE,
							E.EXPENSE_ID,
							E.CH_COMPANY_ID,
							CH_CONSUMER_ID,
							FULLNAME,
							C.MEMBER_CODE,
							C.TAXOFFICE,
							C.TAXNO,
							C.COMPANY_FAX,
							C.COMPANY_TELCODE,
							C.COMPANY_EMAIL,
							C.COMPANY_ADDRESS,
							C.MANAGER_PARTNER_ID,
							C.CITY,
							C.COUNTRY,
							SETUP_CITY.CITY_NAME,
							SETUP_COUNTRY.COUNTRY_NAME
					UNION ALL
						SELECT
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
							NULL CH_COMPANY_ID,
							E.CH_CONSUMER_ID CONSUMER_ID,
							C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
							C.MEMBER_CODE,
							C.TAX_OFFICE TAXOFFICE,
							C.TAX_NO TAXNO,
							C.CONSUMER_FAX FAX,
							C.CONSUMER_FAXCODE FAX_CODE,
							C.CONSUMER_EMAIL MAIL,
							C.TAX_ADRESS ADDRESS,
							C.TC_IDENTY_NO,
							C.HOME_CITY_ID CITY_ID,
							C.HOME_COUNTRY_ID COUNTRY_ID,
							SETUP_CITY.CITY_NAME,
							SETUP_COUNTRY.COUNTRY_NAME,
							SUM(E.KDV_TOTAL) TAX_TOTAL,
							<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						FROM
							
							#dsn_alias#.CONSUMER C
							LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
							LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
							EXPENSE_ITEM_PLANS E
							<cfif session.ep.our_company_info.is_earchive>
								LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							</cfif> 
							<cfif session.ep.our_company_info.is_efatura>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
							</cfif>
						WHERE
							E.CH_CONSUMER_ID = C.CONSUMER_ID
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
								AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							</cfif>
							<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>
							<cfif isdefined('attributes.company') and len(attributes.company)>
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND 1=0
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
							</cfif>
							<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
								AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
							</cfif>
						<cfif isDefined("attributes.tckn")and len(attributes.tckn)>
							AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
						</cfif>
							<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
								AND E.CH_CONSUMER_ID IN (#attributes.row_consumer#)
							<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
								AND 1=0
							</cfif>
							<cfif not isDefined("attributes.is_earchive")>
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
								AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
							</cfif>
							<cfif not isDefined("attributes.is_efatura")>
								AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0 
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
								AND ERD.IS_APPROVE IS NULL
							</cfif>
							AND E.PROCESS_CAT IN (#attributes.process_type#)
							AND COUNTRY_NAME <> 'Türkiye'
						GROUP BY
							E.ACTION_TYPE,
							E.EXPENSE_ID,
							E.CH_CONSUMER_ID,
							C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
							C.MEMBER_CODE,
							C.TAX_OFFICE,
							C.TAX_NO,
							C.CONSUMER_FAX,
							C.CONSUMER_FAXCODE,
							C.CONSUMER_EMAIL,
							C.TAX_ADRESS,
							C.TC_IDENTY_NO,
							C.HOME_CITY_ID,
							C.HOME_COUNTRY_ID,
							SETUP_CITY.CITY_NAME,
							SETUP_COUNTRY.COUNTRY_NAME
					)EXP1
				GROUP BY
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					FAX,
					FAX_CODE,
					MAIL,
					ADDRESS,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID,
					CITY_NAME,
					COUNTRY_NAME
			) BA_BS
			GROUP BY
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
				FAX,
				FAX_CODE,
				MAIL,
				ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
				CITY_NAME,
				COUNTRY_NAME
				
			<cfif isDefined("attributes.total") and len(attributes.total)>
				HAVING
					SUM(BA_TOTAL+BA_OTVTOTAL)> = #attributes.total# OR
					SUM(BS_TOTAL+BS_OTVTOTAL) > = #attributes.total#
			</cfif> 
			ORDER BY
				BA_TOTAL DESC,
				BS_TOTAL DESC,
				FULLNAME
		</cfquery>
		<cfquery name="GET_BA_BS" datasource="#DSN2#">
			SELECT
				TAXOFFICE,
				TAXNO,
				SUM(PAPER_COUNT_BA) BA_PAPER_COUNT,
				SUM(PAPER_COUNT_BS) BS_PAPER_COUNT,
				<cfif x_add_otv_to_total eq 1>
					SUM(BA_TOTAL+BA_OTVTOTAL) BA_TOTAL
				<cfelse>
					SUM(BA_TOTAL) BA_TOTAL
				</cfif>,
				<cfif x_add_otv_to_total eq 1>
					SUM(BS_TOTAL+BS_OTVTOTAL) BS_TOTAL
				<cfelse>
					SUM(BS_TOTAL) BS_TOTAL
				</cfif>,
				SUM(TAX_TOTAL) TAX_TOTAL,
				SUM(OTV_TOTAL) OTV_TOTAL,
				SUM(OIV_TOTAL) OIV_TOTAL
			FROM
			(
				SELECT
					TAXOFFICE,
					TAXNO,
					COUNT(BA_COUNT) PAPER_COUNT_BA,
					COUNT(BS_COUNT) PAPER_COUNT_BS,
					SUM(BA_NETTOTAL-BA_DISCOUNT) BA_TOTAL,
					SUM(BS_NETTOTAL-BS_DISCOUNT) BS_TOTAL,
					SUM(TAX_TOTAL) TAX_TOTAL,
					SUM(BS_OTVTOTAL) BS_OTVTOTAL,
					SUM(BA_OTVTOTAL) BA_OTVTOTAL,
					SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
					SUM(BS_OIVTOTAL) BS_OIVTOTAL,
					SUM(BA_OIVTOTAL) BA_OIVTOTAL,
					SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				FROM
				(
					SELECT
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
						C.TAXOFFICE,
						CASE WHEN IS_PERSON = 1 THEN (SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID)
						ELSE C.TAXNO
						END AS TAXNO,
						SUM(I.TAXTOTAL)/COUNT(IR.INVOICE_ID) TAX_TOTAL,
						<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					FROM
						#dsn_alias#.COMPANY C 
						LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
						LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
						INVOICE_ROW IR,
						INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
					WHERE
						I.COMPANY_ID = C.COMPANY_ID AND
						IR.INVOICE_ID = I.INVOICE_ID AND
						I.IS_IPTAL = 0 AND
						(
							( IS_PERSON = 1 AND ( SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) IS NOT NULL )
							OR
							( IS_PERSON <> 1 AND C.TAXNO IS NOT NULL)
						)
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND 1=0
							</cfif>
						</cfif>
						<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND I.COMPANY_ID IN (#attributes.row_company#)
						<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND 1=0
						</cfif>
						<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
							AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
						</cfif>
							<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.COMPANY_ID IN
							(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ERA.ACTION_ID IS NULL
							AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
							AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ER.ACTION_ID  IS NULL
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND I.PROCESS_CAT IN (#attributes.process_type#)
						AND COUNTRY_NAME = 'Türkiye'
					GROUP BY
						I.INVOICE_CAT,
						I.INVOICE_ID,
						C.TAXOFFICE,
						C.TAXNO,
						IS_PERSON,
						C.MANAGER_PARTNER_ID,
						I.SA_DISCOUNT
				UNION ALL
					SELECT
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						SUM(I.TAXTOTAL)/COUNT(I.INVOICE_ID) TAX_TOTAL,
						<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					FROM
						#dsn_alias#.CONSUMER C
						LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
						LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
						INVOICE_ROW IR,
						INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
					WHERE
						I.CONSUMER_ID = C.CONSUMER_ID AND
						IR.INVOICE_ID = I.INVOICE_ID AND
						I.IS_IPTAL = 0 AND
						C.TAX_NO IS NOT NULL
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND 1=0
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							</cfif>
						</cfif>
						<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
							AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
						</cfif>
						<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
						</cfif>
						<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND I.CONSUMER_ID IN (#attributes.row_consumer#)
						<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND 1=0
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ERA.ACTION_ID IS NULL
							AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
							AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ER.ACTION_ID  IS NULL
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND I.PROCESS_CAT IN (#attributes.process_type#)
						AND COUNTRY_NAME = 'Türkiye'
					GROUP BY
						I.INVOICE_CAT,
						I.INVOICE_ID,
						C.TAX_OFFICE,
						C.TAX_NO,
						I.SA_DISCOUNT
				) T1
				GROUP BY
					TAXOFFICE,
					TAXNO
			UNION ALL
				SELECT
					TAXOFFICE,
					TAXNO,
					COUNT(BA_COUNT) PAPER_COUNT_BA,
					COUNT(BS_COUNT) PAPER_COUNT_BS,
					SUM(BA_NETTOTAL) BA_TOTAL,
					SUM(BS_NETTOTAL) BS_TOTAL,
					SUM(TAX_TOTAL) TAX_TOTAL,
					SUM(BS_OTVTOTAL) BS_OTVTOTAL,
					SUM(BA_OTVTOTAL) BA_OTVTOTAL,
					SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
					SUM(BS_OIVTOTAL) BS_OIVTOTAL,
					SUM(BA_OIVTOTAL) BA_OIVTOTAL,
					SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				FROM
					(
						SELECT
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
							C.TAXOFFICE TAXOFFICE,
							CASE WHEN IS_PERSON = 1 THEN (SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID)
							ELSE C.TAXNO
							END AS TAXNO,
							SUM(E.KDV_TOTAL) TAX_TOTAL,
							<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						FROM
							
							#dsn_alias#.COMPANY C
							LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
							LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
							EXPENSE_ITEM_PLANS E
							<cfif session.ep.our_company_info.is_earchive>
								LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							</cfif> 
							<cfif session.ep.our_company_info.is_efatura>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
							</cfif>
						WHERE
							E.CH_COMPANY_ID = C.COMPANY_ID AND
							(
								( IS_PERSON = 1 AND ( SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) IS NOT NULL )
								OR
								( IS_PERSON <> 1 AND C.TAXNO IS NOT NULL)
							)
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
								AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							</cfif>
							<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>
							<cfif isdefined('attributes.company') and len(attributes.company)>
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND 1 = 0
								</cfif>
							</cfif>
							<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
								AND E.CH_COMPANY_ID IN (#attributes.row_company#)
							<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
								AND 1=0
							</cfif>
							<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
								AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
							</cfif>
								<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
							AND C.COMPANY_ID IN
							(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
							AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0 
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						AND COUNTRY_NAME = 'Türkiye'
							

							AND E.PROCESS_CAT IN (#attributes.process_type#)
						GROUP BY
							E.ACTION_TYPE,
							E.EXPENSE_ID,
							C.TAXOFFICE,
							C.TAXNO,
							IS_PERSON,
							C.MANAGER_PARTNER_ID
					UNION ALL
						SELECT
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
							C.TAX_OFFICE TAXOFFICE,
							C.TAX_NO TAXNO,
							SUM(E.KDV_TOTAL) TAX_TOTAL,
							<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
							CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						FROM
							#dsn_alias#.CONSUMER C
							LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
							LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
							EXPENSE_ITEM_PLANS E
							<cfif session.ep.our_company_info.is_earchive>
								LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							</cfif> 
							<cfif session.ep.our_company_info.is_efatura>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
							</cfif>
						WHERE
							E.CH_CONSUMER_ID = C.CONSUMER_ID
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
								AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							</cfif>
							<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>
							<cfif isdefined('attributes.company') and len(attributes.company)>
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND 1=0
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
							</cfif>
							<cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
								AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
							</cfif>
						<cfif isDefined("attributes.tckn")and len(attributes.tckn)>
							AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
						</cfif>
							<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
								AND E.CH_CONSUMER_ID IN (#attributes.row_consumer#)
							<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
								AND 1=0
							</cfif>
							<cfif not isDefined("attributes.is_earchive")>
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
								AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
							</cfif>
							<cfif not isDefined("attributes.is_efatura")>
								AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0 
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
								AND ERD.IS_APPROVE IS NULL
							</cfif>
							AND E.PROCESS_CAT IN (#attributes.process_type#)
							AND COUNTRY_NAME = 'Türkiye'
						GROUP BY
							E.ACTION_TYPE,
							E.EXPENSE_ID,
							C.TAX_OFFICE,
							C.TAX_NO
					)EXP1
				GROUP BY
					TAXOFFICE,
					TAXNO
			) BA_BS
			GROUP BY
				TAXOFFICE,
				TAXNO
			<cfif isDefined("attributes.total") and len(attributes.total)>
				HAVING
					SUM(BA_TOTAL+BA_OTVTOTAL)> = #attributes.total# OR
					SUM(BS_TOTAL+BS_OTVTOTAL) > = #attributes.total#
			</cfif>
			ORDER BY
				BA_TOTAL DESC,
				BS_TOTAL DESC
		</cfquery>
	<cfelse>
		<cfquery name="GET_BA_BS" datasource="#DSN2#">
		SELECT
			COMPANY_ID,
			CONSUMER_ID,
			FULLNAME,
			MEMBER_CODE,
			TAXOFFICE,
			TAXNO,
            FAX,
            FAX_CODE,
            MAIL,
            ADDRESS,
			TC_IDENTY_NO,
			CITY_ID,
			COUNTRY_ID,
            CITY_NAME,
			COUNTRY_NAME,
			SUM(PAPER_COUNT_BA) BA_PAPER_COUNT,
			SUM(PAPER_COUNT_BS) BS_PAPER_COUNT,
			<cfif x_add_otv_to_total eq 1>
				SUM(BA_TOTAL+BA_OTVTOTAL) BA_TOTAL
			<cfelse>
				SUM(BA_TOTAL) BA_TOTAL
			</cfif>,
			<cfif x_add_otv_to_total eq 1>
				SUM(BS_TOTAL+BS_OTVTOTAL) BS_TOTAL
			<cfelse>
				SUM(BS_TOTAL) BS_TOTAL
			</cfif>,
			SUM(TAX_TOTAL) TAX_TOTAL,
			SUM(OTV_TOTAL) OTV_TOTAL,
			SUM(OIV_TOTAL) OIV_TOTAL
			<cfif isdefined("attributes.is_notification")>
			,SUM(BA_PAPER_TOTAL) BA_PAPER_TOTAL
			,SUM(BA_PAPER_OTV) BA_PAPER_OTV
			,SUM(BS_PAPER_TOTAL) BS_PAPER_TOTAL
			,SUM(BS_PAPER_OTV) BS_PAPER_OTV
			</cfif>
		FROM
		(
			SELECT
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
				FAX,
				FAX_CODE,
				MAIL,
                ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
                CITY_NAME,
                COUNTRY_NAME,
				COUNT(BA_COUNT) PAPER_COUNT_BA,
				COUNT(BS_COUNT) PAPER_COUNT_BS,
				SUM(BA_NETTOTAL-BA_DISCOUNT) BA_TOTAL,
				SUM(BS_NETTOTAL-BS_DISCOUNT) BS_TOTAL,
				SUM(TAX_TOTAL) TAX_TOTAL,
				SUM(BS_OTVTOTAL) BS_OTVTOTAL,
				SUM(BA_OTVTOTAL) BA_OTVTOTAL,
				SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
				SUM(BS_OIVTOTAL) BS_OIVTOTAL,
				SUM(BA_OIVTOTAL) BA_OIVTOTAL,
				SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				<cfif isdefined("attributes.is_notification")>
				,SUM(BA_PAPER_TOTAL-BA_PAPER_DISCOUNT) BA_PAPER_TOTAL
				,SUM(BA_PAPER_OTV) BA_PAPER_OTV
				,SUM(BS_PAPER_TOTAL-BS_PAPER_DISCOUNT) BS_PAPER_TOTAL
				,SUM(BS_PAPER_OTV) BS_PAPER_OTV
				</cfif>
			FROM
			(
				SELECT
					<cfif not isdefined("attributes.is_notification")>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
					<cfelse>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_PAPER_PAPER_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_PAPER_PAPER_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_PAPER_TOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_PAPER_TOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_PAPER_DISCOUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_PAPER_DISCOUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BA_NETTOTAL,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BA_COUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BA_DISCOUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
					</cfif>
					I.COMPANY_ID,
					NULL CONSUMER_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
					C.TAXOFFICE,
					C.TAXNO,
                    C.COMPANY_FAX FAX,
                    C.COMPANY_TELCODE FAX_CODE,
                    C.COMPANY_EMAIL MAIL,
                    C.COMPANY_ADDRESS ADDRESS,
					(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
					C.CITY CITY_ID,
					C.COUNTRY COUNTRY_ID,
                    SETUP_CITY.CITY_NAME,
                    SETUP_COUNTRY.COUNTRY_NAME,
					SUM(I.TAXTOTAL)/COUNT(IR.INVOICE_ID) TAX_TOTAL,
					<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
					<cfif not isdefined("attributes.is_notification")>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					<cfelse>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_PAPER_OTV,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_PAPER_OTV,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
				   ,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BA_OTVTOTAL
				   ,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL
					</cfif>
				FROM
					#dsn_alias#.COMPANY C 
					LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
                    LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
					INVOICE_ROW IR,
					INVOICE I
					<cfif session.ep.our_company_info.is_earchive>
                        LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
                        LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
                    </cfif>
					<cfif session.ep.our_company_info.is_efatura>
                        LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
                        LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
                    </cfif>
				WHERE
					I.COMPANY_ID = C.COMPANY_ID AND
					IR.INVOICE_ID = I.INVOICE_ID AND
					I.IS_IPTAL = 0
					<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
						AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
					</cfif>
					<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
						AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					</cfif>
					<cfif isdefined('attributes.company') and len(attributes.company)>
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							AND 1=0
						</cfif>
					</cfif>
					<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
						AND I.COMPANY_ID IN (#attributes.row_company#)
					<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
						AND 1=0
					</cfif>
                    <cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
						AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
					</cfif>
                    	<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
						AND C.COMPANY_ID IN
						(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
					</cfif>
					<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ERA.ACTION_ID IS NULL
							AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
							AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND ER.ACTION_ID  IS NULL
							AND ERD.IS_APPROVE IS NULL
						</cfif>
					AND I.PROCESS_CAT IN (#attributes.process_type#)
				GROUP BY
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.COMPANY_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
					C.TAXOFFICE,
					C.TAXNO,
                    C.COMPANY_FAX,
                    C.COMPANY_TELCODE,
                    C.COMPANY_EMAIL,
                    C.COMPANY_ADDRESS,
					C.MANAGER_PARTNER_ID,
					C.CITY,
					C.COUNTRY,
                    SETUP_CITY.CITY_NAME,
                    SETUP_COUNTRY.COUNTRY_NAME,
					I.SA_DISCOUNT
					<cfif isdefined("attributes.is_notification")>
					,ERA.ACTION_ID
					,I.INVOICE_NUMBER
					,I.IS_EARCHIVE
					,ER.ACTION_ID
					,ERD.IS_APPROVE
					</cfif>
			UNION ALL
				SELECT
					<cfif not isdefined("attributes.is_notification")>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,
					<cfelse>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_PAPER_PAPER_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_PAPER_PAPER_COUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_PAPER_TOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_PAPER_TOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_PAPER_DISCOUNT,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_PAPER_DISCOUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BA_NETTOTAL,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BA_COUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BA_DISCOUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
					CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
					</cfif>
					NULL,
					I.CONSUMER_ID,
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
					C.MEMBER_CODE,
					C.TAX_OFFICE TAXOFFICE,
					C.TAX_NO TAXNO,
                    C.CONSUMER_FAX FAX,
                    C.CONSUMER_FAXCODE FAX_CODE,
                    C.CONSUMER_EMAIL MAIL,
                    C.TAX_ADRESS ADDRESS,
					C.TC_IDENTY_NO,
					C.HOME_CITY_ID CITY_ID,
					C.HOME_COUNTRY_ID COUNTRY_ID,
                    SETUP_CITY.CITY_NAME,
                    SETUP_COUNTRY.COUNTRY_NAME,
					SUM(I.TAXTOTAL)/COUNT(I.INVOICE_ID) TAX_TOTAL,
					<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
					<cfif not isdefined("attributes.is_notification")>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
					<cfelse>
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_PAPER_OTV,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_PAPER_OTV,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OIVTOTAL,
					CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OIV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OIVTOTAL
				   ,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT NOT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BA_OTVTOTAL
				   ,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 AND ERA.ACTION_ID IS NULL AND I.INVOICE_NUMBER NOT LIKE 'GIB%' AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0  AND ER.ACTION_ID  IS NULL AND ERD.IS_APPROVE IS NULL) AND I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL
					</cfif>
				FROM
					#dsn_alias#.CONSUMER C
                    LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
                    LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
					INVOICE_ROW IR,
					INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
				WHERE
					I.CONSUMER_ID = C.CONSUMER_ID AND
					IR.INVOICE_ID = I.INVOICE_ID AND
					I.IS_IPTAL = 0
					<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
						AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
					</cfif>
					<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
						AND ISNULL(I.REALIZATION_DATE,I.INVOICE_DATE)  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					</cfif>
					<cfif isdefined('attributes.company') and len(attributes.company)>
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							AND 1=0
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						</cfif>
					</cfif>
                     <cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
						AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
					</cfif>
                    <cfif isDefined("attributes.tckn") and len(attributes.tckn)>
						AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
					</cfif>
					<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
						AND I.CONSUMER_ID IN (#attributes.row_consumer#)
					<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
						AND 1=0
					</cfif>
					<cfif not isDefined("attributes.is_earchive")>
						AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
						AND ERA.ACTION_ID IS NULL
						AND I.INVOICE_NUMBER NOT LIKE 'GIB%'
						AND (I.IS_EARCHIVE = 0 OR I.IS_EARCHIVE IS NULL)
					</cfif>
					<cfif not isDefined("attributes.is_efatura")>
						AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
						AND ER.ACTION_ID  IS NULL
						AND ERD.IS_APPROVE IS NULL
					</cfif>
					AND I.PROCESS_CAT IN (#attributes.process_type#)
				GROUP BY
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.CONSUMER_ID,
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
					C.MEMBER_CODE,
					C.TAX_OFFICE,
					C.TAX_NO,
                    C.CONSUMER_FAX,
                    C.CONSUMER_FAXCODE,
					C.CONSUMER_EMAIL,
                    C.TAX_ADRESS,
					C.TC_IDENTY_NO,
					C.HOME_CITY_ID,
					C.HOME_COUNTRY_ID,
                    SETUP_CITY.CITY_NAME,
                    SETUP_COUNTRY.COUNTRY_NAME,
					I.SA_DISCOUNT
					<cfif isdefined("attributes.is_notification")>
					,ERA.ACTION_ID
					,I.INVOICE_NUMBER
					,I.IS_EARCHIVE
					,ER.ACTION_ID
					,ERD.IS_APPROVE
					</cfif>
			) T1
			GROUP BY
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
                FAX,
                FAX_CODE,
                MAIL,
                ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
                CITY_NAME,
                COUNTRY_NAME
		UNION ALL
			SELECT
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
                FAX,
                FAX_CODE,
                MAIL,
                ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
                CITY_NAME,
                COUNTRY_NAME,
				COUNT(BA_COUNT) PAPER_COUNT_BA,
				COUNT(BS_COUNT) PAPER_COUNT_BS,
				SUM(BA_NETTOTAL) BA_TOTAL,
				SUM(BS_NETTOTAL) BS_TOTAL,
				SUM(TAX_TOTAL) TAX_TOTAL,
				SUM(BS_OTVTOTAL) BS_OTVTOTAL,
				SUM(BA_OTVTOTAL) BA_OTVTOTAL,
				SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL,
				SUM(BS_OIVTOTAL) BS_OIVTOTAL,
				SUM(BA_OIVTOTAL) BA_OIVTOTAL,
				SUM(BS_OIVTOTAL+BA_OIVTOTAL) OIV_TOTAL
				<cfif isdefined("attributes.is_notification")>
				,SUM(BA_PAPER_TOTAL) BA_PAPER_TOTAL
				,SUM(BA_PAPER_OTV) BA_PAPER_OTV
				,SUM(BS_PAPER_TOTAL) BS_PAPER_TOTAL
				,SUM(BS_PAPER_OTV) BS_PAPER_OTV
				</cfif>
			FROM
				(
					SELECT
						<cfif not isdefined("attributes.is_notification")>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
						<cfelse>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_PAPER_PAPER_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_PAPER_PAPER_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_PAPER_TOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_PAPER_TOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL) AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BA_NETTOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL) AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BA_COUNT,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
						</cfif>
						E.CH_COMPANY_ID COMPANY_ID,
						NULL CONSUMER_ID,
						FULLNAME,
						C.MEMBER_CODE,
						C.TAXOFFICE TAXOFFICE,
						C.TAXNO TAXNO,
						C.COMPANY_FAX FAX,
                        C.COMPANY_TELCODE FAX_CODE,
                        C.COMPANY_EMAIL MAIL,
                        C.COMPANY_ADDRESS ADDRESS,
						(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
						C.CITY CITY_ID,
						C.COUNTRY COUNTRY_ID,
                        SETUP_CITY.CITY_NAME,
                    	SETUP_COUNTRY.COUNTRY_NAME,
						SUM(E.KDV_TOTAL) TAX_TOTAL,
						<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
						<cfif not isdefined("attributes.is_notification")>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						<cfelse>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_PAPER_OTV,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_PAPER_OTV,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BA_OTVTOTAL
						,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL
						</cfif>
					FROM
						#dsn_alias#.COMPANY C
                        LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.CITY
                        LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.COUNTRY,
						EXPENSE_ITEM_PLANS E
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
						</cfif> 
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
						</cfif>
					WHERE
						E.CH_COMPANY_ID = C.COMPANY_ID
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND 1 = 0
							</cfif>
						</cfif>
						<cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND E.CH_COMPANY_ID IN (#attributes.row_company#)
						<cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND 1=0
						</cfif>
                        <cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
                            AND C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
                        </cfif>
                        	<cfif isDefined("attributes.tckn") and len(attributes.tckn)>
						 AND C.COMPANY_ID IN
						(SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.TC_IDENTITY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">)
					</cfif>
					<cfif not isDefined("attributes.is_earchive")>
						AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
						AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
					</cfif>
					<cfif not isDefined("attributes.is_efatura")>
						AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  
						AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
						AND ERD.IS_APPROVE IS NULL
					</cfif>

						AND E.PROCESS_CAT IN (#attributes.process_type#)
					GROUP BY
						E.ACTION_TYPE,
						E.EXPENSE_ID,
						E.CH_COMPANY_ID,
						CH_CONSUMER_ID,
						FULLNAME,
						C.MEMBER_CODE,
						C.TAXOFFICE,
						C.TAXNO,
                        C.COMPANY_FAX,
                        C.COMPANY_TELCODE,
                        C.COMPANY_EMAIL,
                        C.COMPANY_ADDRESS,
						C.MANAGER_PARTNER_ID,
						C.CITY,
						C.COUNTRY,
                        SETUP_CITY.CITY_NAME,
                    	SETUP_COUNTRY.COUNTRY_NAME
						<cfif isdefined("attributes.is_notification")>
						,E.IS_EARCHIVE
						,ERD.IS_APPROVE
						</cfif>
				UNION ALL
					SELECT
						<cfif not isdefined("attributes.is_notification")>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
						<cfelse>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_PAPER_PAPER_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_PAPER_PAPER_COUNT,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_PAPER_TOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_PAPER_TOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL) AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BA_NETTOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL) AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BA_COUNT,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
						CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
						</cfif>
						NULL CH_COMPANY_ID,
						E.CH_CONSUMER_ID CONSUMER_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						C.MEMBER_CODE,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
                        C.CONSUMER_FAX FAX,
                        C.CONSUMER_FAXCODE FAX_CODE,
                        C.CONSUMER_EMAIL MAIL,
                        C.TAX_ADRESS ADDRESS,
						C.TC_IDENTY_NO,
						C.HOME_CITY_ID CITY_ID,
						C.HOME_COUNTRY_ID COUNTRY_ID,
                        SETUP_CITY.CITY_NAME,
                    	SETUP_COUNTRY.COUNTRY_NAME,
						SUM(E.KDV_TOTAL) TAX_TOTAL,
						<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
						<cfif not isdefined("attributes.is_notification")>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						<cfelse>
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_PAPER_OTV,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_PAPER_OTV,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) ELSE 0 END AS BS_OIVTOTAL,
						CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(CAST(OIV_TOTAL AS DECIMAL(10,2))) END AS BA_OIVTOTAL
						,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE NOT IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BA_OTVTOTAL
						,CASE WHEN ((SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)) AND ((SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0 AND ERD.IS_APPROVE IS NULL)  AND E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL
						</cfif>
					FROM
						#dsn_alias#.CONSUMER C
                        LEFT JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = C.HOME_CITY_ID
                        LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID,
						EXPENSE_ITEM_PLANS E
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = E.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
						</cfif> 
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
						</cfif>
					WHERE
						E.CH_CONSUMER_ID = C.CONSUMER_ID
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
							AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif isdefined('attributes.company') and len(attributes.company)>
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND 1=0
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							</cfif>
						</cfif>
                        <cfif isDefined("attributes.tax_no") and len(attributes.tax_no)>
                            AND C.TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#">
                        </cfif>
                       <cfif isDefined("attributes.tckn")and len(attributes.tckn)>
						AND C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tckn#">
					</cfif>
						<cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
							AND E.CH_CONSUMER_ID IN (#attributes.row_consumer#)
						<cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
							AND 1=0
						</cfif>
						<cfif not isDefined("attributes.is_earchive")>
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
							AND (E.IS_EARCHIVE = 0 OR E.IS_EARCHIVE IS NULL)
						</cfif>
						<cfif not isDefined("attributes.is_efatura")>
							AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD1 WHERE ESD1.EXPENSE_ID = E.EXPENSE_ID ) = 0  
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE=1) = 0
							AND ERD.IS_APPROVE IS NULL
						</cfif>
						
						AND E.PROCESS_CAT IN (#attributes.process_type#)
					GROUP BY
						E.ACTION_TYPE,
						E.EXPENSE_ID,
						E.CH_CONSUMER_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
						C.MEMBER_CODE,
						C.TAX_OFFICE,
						C.TAX_NO,
						C.CONSUMER_FAX,
                        C.CONSUMER_FAXCODE,
                        C.CONSUMER_EMAIL,
                        C.TAX_ADRESS,
                        C.TC_IDENTY_NO,
						C.HOME_CITY_ID,
						C.HOME_COUNTRY_ID,
                        SETUP_CITY.CITY_NAME,
                    	SETUP_COUNTRY.COUNTRY_NAME
						<cfif isdefined("attributes.is_notification")>
						,E.IS_EARCHIVE
						,ERD.IS_APPROVE
						</cfif>
				)EXP1
			GROUP BY
				COMPANY_ID,
				CONSUMER_ID,
				FULLNAME,
				MEMBER_CODE,
				TAXOFFICE,
				TAXNO,
                FAX,
                FAX_CODE,
                MAIL,
                ADDRESS,
				TC_IDENTY_NO,
				CITY_ID,
				COUNTRY_ID,
                CITY_NAME,
                COUNTRY_NAME
		) BA_BS
		GROUP BY
			COMPANY_ID,
			CONSUMER_ID,
			FULLNAME,
			MEMBER_CODE,
			TAXOFFICE,
			TAXNO,
            FAX,
			FAX_CODE,
			MAIL,
            ADDRESS,
			TC_IDENTY_NO,
			CITY_ID,
			COUNTRY_ID,
            CITY_NAME,
            COUNTRY_NAME
		<cfif isDefined("attributes.total") and len(attributes.total)>
			HAVING
			<cfif not isdefined("attributes.is_notification")>
				SUM(BA_TOTAL+BA_OTVTOTAL)> = #attributes.total# OR
				SUM(BS_TOTAL+BS_OTVTOTAL) > = #attributes.total#
			<cfelse>
				SUM(BA_PAPER_TOTAL+BA_PAPER_OTV)> = #attributes.total# OR
				SUM(BS_PAPER_TOTAL+BS_PAPER_OTV) > = #attributes.total#
			</cfif>
        </cfif>
		ORDER BY
			BA_TOTAL DESC,
			BS_TOTAL DESC,
			FULLNAME
		</cfquery>
	</cfif>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.totalrecords" default="#GET_BA_BS.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfform name="ba_bs_form" action="" method="post">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='40372.BA - BS Raporları'></cfsavecontent>
		<cf_report_list_search title="#title#" id="gizli">
			<cf_report_list_search_area>
				<input type="hidden" value="1" name="form_varmi" id="form_varmi">
				<cfoutput>
					<div class="row">
						<div class="col col-12 col-xs-12">
							<div class="row formContent">
								<div class="row" type="row">													
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
												<div class="col col-12">
													<select name="process_type_bs" id="process_type_bs" multiple>
														<cfloop query="get_process_cat_bs">
															<option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type_bs,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
														</cfloop>
													</select>
												</div>
											</div>	
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58176.Alış '><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
												<div class="col col-12">
													<select name="process_type_ba" id="process_type_ba" multiple>
														<cfloop query="get_process_cat_ba">
															<option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type_ba,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
														</cfloop>
													</select>
												</div>
											</div>	
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
													<div class="col col-12 col-xs-12">
														<div class="input-group">
															<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.company)>#attributes.consumer_id#</cfif>">
															<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company') and len(attributes.company)>#attributes.company_id#</cfif>">
															<input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" value="<cfif isdefined('attributes.company') and len(attributes.company)>#attributes.company#</cfif>" autocomplete="off">
															<a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=ba_bs_form.company&field_comp_id=ba_bs_form.company_id&field_consumer=ba_bs_form.consumer_id&field_member_name=ba_bs_form.company&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></a>					
														</div>
													</div>
												</div>
											<div class="form-group">																					
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57673.Tutar"></label>
													<div class="col col-12 col-xs-12">
														<input type="text" name="total" id="total" value="<cfif isdefined("attributes.total") and len(attributes.total)>#TLFormat(attributes.total)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event));">											
													</div>
													<!---  ana queryde cariler gruplanıp tek satırda getirildiği için, ilişkili üye bazında grupla kısmını kapatıyoruz (114898 id'li iş kapsamında)
													<td width="200" colspan="2">
														<input type="checkbox" name="is_relation" id="is_relation" value="1" onclick="display_();" <cfif attributes.is_relation eq 1>checked</cfif>><cf_get_lang no="999.İlişkili Üye Bazında Grupla">
													</td> --->
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="56085.Vergi Numarası"></label>
													<div class="col col-12 col-xs-12">
														<input type="text" name="tax_no" id="tax_no" value="<cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>#attributes.tax_no#</cfif>">
													</div>
											</div>
											<div class="form-group">		
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58025.TC Kimlik No"></label>
													<div class="col col-12 col-xs-12">
														<input type="text" name="tckn" id="tckn" value="<cfif isdefined("attributes.tckn") and len(attributes.tckn)>#attributes.tckn#</cfif>">
													</div>												
											</div>	
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12 ">
											<div class="form-group">
												<div class="col col-6">
													<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarih'></label>
													<div class="col col-12 col-xs-12">
														<div class="input-group">
															<cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarih'></cfsavecontent>
															<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">													
															<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
														</div>	
													</div>
												</div>
												<div class="col col-6">
													<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarih'></label>
													<div class="col col-12 col-xs-12">
														<div class="input-group">
															<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarih'></cfsavecontent>
															<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">														
															<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
														</div>											
													</div>
												</div>																						
											</div>
											<div class="form-group">
												<div class="col col-12 col-xs-12">
													<div class="col col-3 col-xs-12">
														<input type="checkbox" name="is_otv" id="is_otv" value="1" <cfif isdefined('attributes.is_otv') and attributes.is_otv eq 1>checked</cfif>><cf_get_lang dictionary_id='58021.OTV'><cf_get_lang dictionary_id='58596.Göster'>
													</div>
													<div class="col col-3 col-xs-12">
														<input type="checkbox" name="is_oiv" id="is_oiv" value="1" <cfif isdefined('attributes.is_oiv') and attributes.is_oiv eq 1>checked</cfif>><cf_get_lang dictionary_id='65180.Öiv Göster'>
													</div>
													<div class="col col-3 col-xs-12">
														<input type="checkbox" name="is_tax" id="is_tax" value="1" <cfif isdefined('attributes.is_tax') and attributes.is_tax eq 1>checked</cfif>><cf_get_lang dictionary_id='57639.Kdv'><cf_get_lang dictionary_id='58596.Göster'>
													</div>
													<div class="col col-3 col-xs-12">
														<input type="checkbox" name="is_xml" id="is_xml" value="1"><cf_get_lang dictionary_id='40647.XML Getir'> &nbsp;&nbsp;
															<cfif x_add_otv_to_total eq 1>
															<input type="hidden" name="is_knt" id="is_knt" value="1">
															<cfelse>
															<input type="hidden" name="is_knt" id="is_knt" value="0">
															</cfif>
													</div>
												</div>											
											</div>
											<div class="form-group">
												<div class="col col-12 col-xs-12">
													<div class="col col-12 col-xs-12">
														<input type="checkbox" name="is_carigrup" id="is_carigrup" value="1" <cfif isdefined('attributes.is_carigrup') and attributes.is_carigrup eq 1>checked</cfif>><cf_get_lang dictionary_id='60802.Cariler Gruplanarak Getirilsin'>
													</div>
												</div>											
											</div>
											<div class="form-group">
												<div class="col col-12 col-xs-12">
													<div class="col col-12 col-xs-12">
														<input type="checkbox" name="is_cari" id="is_cari" value="1" <cfif isdefined('attributes.is_cari') and attributes.is_cari eq 1>checked</cfif>><cf_get_lang dictionary_id='60803.Gruplanan Carilerden Sadece Birini Getir'>
													</div>
												</div>											
											</div>
											<div class="form-group">
												<div class="col col-12 col-xs-12">
													<div class="col col-12 col-xs-12">
														<input type="checkbox" name="is_notification" id="is_notification" onclick="hide_check()" value="1" <cfif isdefined('attributes.is_notification') and attributes.is_notification eq 1>checked</cfif>><cf_get_lang dictionary_id='65308.Bildirim Yapılacaklar'>
													</div>
												</div>											
											</div>	
											<div class="form-group" id="hide_efatura">
												<div class="col col-12 col-xs-12">
													<div class="col col-12 col-xs-12">
														<input type="checkbox" name="is_efatura" id="is_efatura" value="1" <cfif isdefined('attributes.is_efatura') and attributes.is_efatura eq 1>checked</cfif>><cf_get_lang dictionary_id='29872.E-Fatura'><cf_get_lang dictionary_id='32924.Dahil'>
													</div>
												</div>											
											</div>
											<div class="form-group"  id="hide_earchive">
												<div class="col col-12 col-xs-12">
													<div class="col col-12 col-xs-12">
														<input type="checkbox" name="is_earchive" id="is_earchive" value="1" <cfif isdefined('attributes.is_earchive') and attributes.is_earchive eq 1>checked</cfif>><cf_get_lang dictionary_id='57145.E-Arşiv'><cf_get_lang dictionary_id='32924.Dahil'>
													</div>
												</div>											
											</div>							
										</div>
								</div>
							</div>
							<div class="row ReportContentBorder">
								<div class="ReportContentFooter">
									<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
										<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
										<cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1'>   
								</div>
							</div>
						</div>
					</div>
				</cfoutput>				
			</cf_report_list_search_area>	
		</cf_report_list_search>
</cfform>
<cfset ba_belge_toplam = 0>
<cfset bs_belge_toplam = 0>
<cfset ba_net_toplam = 0>
<cfset bs_net_toplam = 0>
<cfset kdv_toplam = 0>
<cfset otv_toplam = 0>
<cfset oiv_toplam = 0>
<cfset type_ = 0>
<cfset bs_paper_count_ = 0>
<cfset ba_paper_count_ = 0>
<cfset ba_total_ = 0>
<cfset bs_total_ = 0>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="report_ba_bs#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=GET_BA_BS.recordcount>
	<cfset type_ = 1>
<cfelseif isdefined('attributes.is_xml') and attributes.is_xml eq 1>
	<cfinclude template="../query/report_ba_bs_xml.cfm">
<cfelse>
	<cfset type_ = 0>
</cfif>

<cfif isdefined("attributes.form_varmi")>
	<cf_report_list>		
		<thead>
			<tr>
				<th colspan="18" class="formbold"><cfoutput>#dateformat(attributes.startdate,dateformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# <cf_get_lang dictionary_id="39363.Dönemi"> BA-BS <cf_get_lang dictionary_id="39485.Raporu"></cfoutput></th>
			</tr>
			<tr>
				<th><cf_get_lang dictionary_id='57519.Cari Hesap'><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				<th><cf_get_lang dictionary_id ='58025.TC Kimlik No'></th>
				<th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th>
				<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
				<cfif x_show_fax eq 1><th><cf_get_lang dictionary_id='57488.Fax'></th></cfif>
				<cfif x_show_mail eq 1><th><cf_get_lang dictionary_id='57428.E-Mail'></th></cfif>
				<cfif x_show_detail_address eq 1><th><cf_get_lang dictionary_id='58723.Adres'></th></cfif>
				<th><cf_get_lang dictionary_id='57971.Şehir'></th>
				<th><cf_get_lang dictionary_id='58219.Ülke'></th>
				<cfif len(attributes.process_type_ba)>
					<th>BA <cf_get_lang dictionary_id='39684.Belge Adedi'></th>
					<th>BA <cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='57673.Tutar'></th>
				</cfif>
				<cfif len(attributes.process_type_bs)>
					<th>BS <cf_get_lang dictionary_id='39684.Belge Adedi'></th>
					<th>BS <cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='57673.Tutar'></th>
				</cfif>
				<cfif isdefined('attributes.is_tax') and attributes.is_tax>
					<th><cf_get_lang dictionary_id='57639.Kdv'><cf_get_lang dictionary_id='57673.Tutar'></th>
				</cfif>
				<cfif isdefined('attributes.is_otv') and attributes.is_otv>
					<th><cf_get_lang dictionary_id='58021.OTV'><cf_get_lang dictionary_id='57673.Tutar'></th>
				</cfif>
				<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
					<th><cf_get_lang dictionary_id='50982.Öiv'><cf_get_lang dictionary_id='57673.Tutar'></th>
				</cfif>
				<cfif type_ neq 1>
				<!-- sil --><th><a href="javascript://" onclick="open_window('','');"><span class="icn-md icon-print" border="0" title="<cf_get_lang dictionary_id='57474.Yazdır'>" align="absmiddle"></a></th><!-- sil -->
				</cfif>
			</tr>
		</thead>
			<cfset currentrow_ = 0>
			<cfset currentrow__ = 0>
			<cfif isdefined("attributes.is_carigrup")> <!---<cfif attributes.x_company_group eq 1>--->
				<cfif get_ba_bs.recordcount or xml_ba_bs.recordcount>
		<tbody>
					<cfif get_ba_bs.recordcount>
					<cfoutput query="GET_BA_BS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfquery name="get_cmp_cns" datasource="#dsn#">
								SELECT <cfif isDefined("attributes.is_cari")>TOP 1</cfif>
									COMPANY.FULLNAME FULLNAME,
									COMPANY.MEMBER_CODE MEMBER_CODE,
									COMPANY.COMPANY_TELCODE FAX_CODE,
									COMPANY.COMPANY_FAX FAX,
									COMPANY.COMPANY_EMAIL EMAIL,
									COMPANY.COMPANY_ADDRESS ADDRESS,
									SC.CITY_NAME CITY,
									SCT.COUNTRY_NAME COUNTRY,
									ISNULL(COMPANY.IS_PERSON,0) IS_PERSON,
									COMPANY.COMPANY_ID COMPANY_ID,
									NULL CONSUMER_ID
								FROM
									COMPANY
									RIGHT JOIN COMPANY_PERIOD CP ON COMPANY.COMPANY_ID = CP.COMPANY_ID
									LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = COMPANY.CITY
									LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = COMPANY.COUNTRY
								WHERE
									COMPANY.TAXNO = '#TAXNO#'
									AND COMPANY_STATUS = 1
									AND CP.PERIOD_ID = #session.ep.PERIOD_ID#
								UNION ALL
									SELECT 
										COMPANY.FULLNAME FULLNAME,
										COMPANY.MEMBER_CODE MEMBER_CODE,
										COMPANY.COMPANY_TELCODE FAX_CODE,
										COMPANY.COMPANY_FAX FAX,
										COMPANY.COMPANY_EMAIL EMAIL,
										COMPANY.COMPANY_ADDRESS ADDRESS,
										SC.CITY_NAME CITY,
										SCT.COUNTRY_NAME COUNTRY,
										ISNULL(COMPANY.IS_PERSON,0) IS_PERSON,
										COMPANY.COMPANY_ID COMPANY_ID,
										NULL CONSUMER_ID
									FROM
										COMPANY_PARTNER CP
										RIGHT JOIN COMPANY ON CP.COMPANY_ID = COMPANY.COMPANY_ID
										RIGHT JOIN COMPANY_PERIOD CPP ON COMPANY.COMPANY_ID = CPP.COMPANY_ID
										LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = COMPANY.CITY
										LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = COMPANY.COUNTRY
									WHERE
										CP.TC_IDENTITY = '#TAXNO#'
										AND COMPANY_STATUS = 1
										AND CPP.PERIOD_ID = #session.ep.PERIOD_ID#
								UNION ALL 
									SELECT
										C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
										C.MEMBER_CODE MEMBER_CODE,
										C.CONSUMER_FAXCODE FAX_CODE,
										C.CONSUMER_FAX FAX,
										C.CONSUMER_EMAIL EMAIL,
										C.TAX_ADRESS ADDRESS,
										SC.CITY_NAME CITY,
										SCT.COUNTRY_NAME COUNTRY,
										NULL IS_PERSON,
										NULL COMPANY_ID,
										C.CONSUMER_ID
									FROM
										CONSUMER C
										RIGHT JOIN CONSUMER_PERIOD CP ON C.CONSUMER_ID = CP.CONSUMER_ID
										LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = C.HOME_CITY_ID
										LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = C.HOME_COUNTRY_ID
									WHERE
										C.TAX_NO = '#TAXNO#'
										AND CONSUMER_STATUS = 1
										AND CP.PERIOD_ID = #session.ep.PERIOD_ID#
									ORDER BY 
										MEMBER_CODE
							</cfquery>
							
							<tr>
							<td>
								<cfif isDefined("attributes.is_cari")>
									<cfset mem_code = "">
									<cfloop query="get_cmp_cns">
										<cfset mem_code = get_cmp_cns.member_code>
									</cfloop>
									<cfif len(mem_code)>
										#left(mem_code,len(mem_code)-0)#
									<cfelse>
										#mem_code#
									</cfif>
								<cfelse>
									<cfset mem_code = "">
									<cfloop query="get_cmp_cns">
										<cfset mem_code &= get_cmp_cns.member_code & ", ">
									</cfloop>
									<cfif len(mem_code)>
										#left(mem_code,len(mem_code)-0)#
									<cfelse>
										#mem_code#
									</cfif>
								</cfif>
							</td>
							<td>
								<cfif isDefined("attributes.is_cari")>
									<cfset fll_name = "">
									<cfloop query="get_cmp_cns">
										<cfset fll_name = get_cmp_cns.fullname>
									</cfloop>
									<cfif len(fll_name)>
										#left(fll_name,len(fll_name)-2)#
									<cfelse>
										#fll_name#
									</cfif>
								<cfelse>
									<cfset fll_name = "">
									<cfloop query="get_cmp_cns">
										<cfset fll_name &= get_cmp_cns.fullname & ",">
									</cfloop>
									<cfif len(fll_name)>
										#left(fll_name,len(fll_name)-2)#
									<cfelse>
										#fll_name#
									</cfif>
								</cfif>
							</td>
							<td>
							<cfif not len(taxno)></cfif>
							<cfif get_cmp_cns.is_person eq 1>#taxno#</cfif></td>
							<td>#taxoffice#</td>
							<td style="mso-number-format:\@;"><cfif get_cmp_cns.is_person eq 0>#taxno#</cfif></td>
							<cfif x_show_fax eq 1><td style="mso-number-format:\@;">#get_cmp_cns.fax_code# #get_cmp_cns.fax#</td></cfif>
							<cfif x_show_mail eq 1><td style="mso-number-format:\@;">#get_cmp_cns.email#</td></cfif>
							<cfif x_show_detail_address eq 1>
								<td style="mso-number-format:\@;">#get_cmp_cns.ADDRESS#</td>
							</cfif>
							<td>#get_cmp_cns.city#</td>
							<td>#get_cmp_cns.country#</td>
							<cfif len(attributes.process_type_ba)>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('ba_paper_count_#get_cmp_cns.company_id#') and len(evaluate('ba_paper_count_#get_cmp_cns.company_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_><!--- ilişkili üyenin hareketi tekrar toplama eklenmesin diye --->
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_paper_count_#consumer_id#') and len(evaluate('ba_paper_count_#consumer_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#consumer_id#')#>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif> 
									</cfif>
										#ba_paper_count + ba_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('ba_total_#get_cmp_cns.company_id#') and len(evaluate('ba_total_#get_cmp_cns.company_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_total_#consumer_id#') and len(evaluate('ba_total_#consumer_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#consumer_id#')#>
											<cfset ba_net_toplam = ba_net_toplam + ba_total+ ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									</cfif>
										#TLFormat(ba_total + ba_total_)#
								</td>
							</cfif>
							<cfif len(attributes.process_type_bs)>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('bs_paper_count_#get_cmp_cns.company_id#') and len(evaluate('bs_paper_count_#get_cmp_cns.company_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('bs_paper_count_#consumer_id#') and len(evaluate('bs_paper_count_#consumer_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#consumer_id#')#>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									</cfif>
									#bs_paper_count + bs_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('bs_total_#get_cmp_cns.company_id#') and len(evaluate('bs_total_#get_cmp_cns.company_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									<cfelseif Len(get_cmp_cns.consumer_id)>
										<cfif isdefined('bs_total_#get_cmp_cns.consumer_id#') and len(evaluate('bs_total_#get_cmp_cns.consumer_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#get_cmp_cns.consumer_id#')#>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									</cfif>
									#TLFormat(bs_total + bs_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_tax') and attributes.is_tax>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('tax_total_#get_cmp_cns.company_id#') and len(evaluate('tax_total_#get_cmp_cns.company_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('tax_total_#consumer_id#') and len(evaluate('tax_total_#consumer_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#consumer_id#')#>
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									</cfif>
									#TLFormat(tax_total + tax_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_otv') and attributes.is_otv>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('otv_total_#get_cmp_cns.company_id#') and len(evaluate('otv_total_#get_cmp_cns.company_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('otv_total_#consumer_id#') and len(evaluate('otv_total_#consumer_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#consumer_id#')#>
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									</cfif>
									#TLFormat(otv_total + otv_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
								<td  format="numeric">
									<cfif Len(get_cmp_cns.company_id)>
										<cfif isdefined('oiv_total_#get_cmp_cns.company_id#') and len(evaluate('oiv_total_#get_cmp_cns.company_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#get_cmp_cns.company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('oiv_total_#consumer_id#') and len(evaluate('oiv_total_#consumer_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#consumer_id#')#>
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									</cfif>
									#TLFormat(oiv_total + oiv_total_)#
								</td>
							</cfif>
							<cfif type_ neq 1>
								<!-- sil --><td style="text-align:center" nodraw="1">
								<a href="javascript://" onclick="open_window('#listdeleteduplicates(valuelist(get_cmp_cns.company_id))#','#listdeleteduplicates(valuelist(get_cmp_cns.consumer_id))#');"><img src="/images/print2.gif" border="0" title="<cf_get_lang dictionary_id='57474.Yazdır'>" align="absmiddle"></a></td><!-- sil -->
							</cfif>
						</tr>
						<cfset currentrow_ = currentrow>
					</cfoutput>
					</cfif>
					<cfif xml_ba_bs.recordcount>
					<cfoutput query="XML_BA_BS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
							<td>#member_code#</td>
							<td>#fullname#</td>
							<td><cfif not len(taxno)>#tc_identy_no#</cfif></td>
							<td>#taxoffice#</td>
							<td style="mso-number-format:\@;">#taxno#</td>
							<cfif x_show_fax eq 1><td style="mso-number-format:\@;">#fax_code# #fax#</td></cfif>
							<cfif x_show_mail eq 1><td style="mso-number-format:\@;">#mail#</td></cfif>
							<cfif x_show_detail_address eq 1>
								<td style="mso-number-format:\@;">#ADDRESS#</td>
							</cfif>
							<td>#city_name#</td>
							<td>#country_name#</td>
							<cfif len(attributes.process_type_ba)>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('ba_paper_count_#company_id#') and len(evaluate('ba_paper_count_#company_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_><!--- ilişkili üyenin hareketi tekrar toplama eklenmesin diye --->
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_paper_count_#consumer_id#') and len(evaluate('ba_paper_count_#consumer_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#consumer_id#')#>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif>
									</cfif>
									#ba_paper_count + ba_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('ba_total_#company_id#') and len(evaluate('ba_total_#company_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_total_#consumer_id#') and len(evaluate('ba_total_#consumer_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#consumer_id#')#>
											<cfset ba_net_toplam = ba_net_toplam + ba_total+ ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									</cfif>
									#TLFormat(ba_total + ba_total_)#
								</td>
							</cfif>
							<cfif len(attributes.process_type_bs)>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('bs_paper_count_#company_id#') and len(evaluate('bs_paper_count_#company_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('bs_paper_count_#consumer_id#') and len(evaluate('bs_paper_count_#consumer_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#consumer_id#')#>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									</cfif>
									#bs_paper_count + bs_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('bs_total_#company_id#') and len(evaluate('bs_total_#company_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('bs_total_#consumer_id#') and len(evaluate('bs_total_#consumer_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#consumer_id#')#>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									</cfif>
									#TLFormat(bs_total + bs_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_tax') and attributes.is_tax>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('tax_total_#company_id#') and len(evaluate('tax_total_#company_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('tax_total_#consumer_id#') and len(evaluate('tax_total_#consumer_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#consumer_id#')#>
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									</cfif>
									#TLFormat(tax_total + tax_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_otv') and attributes.is_otv>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('otv_total_#company_id#') and len(evaluate('otv_total_#company_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('otv_total_#consumer_id#') and len(evaluate('otv_total_#consumer_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#consumer_id#')#>
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									</cfif>
									#TLFormat(otv_total + otv_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('oiv_total_#company_id#') and len(evaluate('oiv_total_#company_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('oiv_total_#consumer_id#') and len(evaluate('oiv_total_#consumer_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#consumer_id#')#>
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									</cfif>
									#TLFormat(oiv_total + oiv_total_)#
								</td>
							</cfif>
							<cfif type_ neq 1>
								<!-- sil --><td style="text-align:center" nodraw="1"><a href="javascript://" onclick="open_window('#XML_BA_BS.company_id#','#XML_BA_BS.consumer_id#');"><img src="/images/print2.gif" border="0" title="<cf_get_lang dictionary_id='57474.Yazdır'>" align="absmiddle"></a></td><!-- sil -->
							</cfif>
						</tr>
						<cfset currentrow__ = currentrow>
					</cfoutput>
					</cfif>
					</tbody>
					<cfif (currentrow_ eq get_ba_bs.recordcount) or (currentrow__ eq xml_ba_bs.recordcount)>
					<tfoot>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<cfoutput>
							<cfset colspan_info = 6>							
							<cfif x_show_fax eq 1><cfset colspan_info = colspan_info+1></cfif>
							<cfif x_show_mail eq 1><cfset colspan_info = colspan_info+1></cfif>
							<cfif x_show_detail_address eq 1><cfset colspan_info = colspan_info+1></cfif>
							<td colspan="#colspan_info#"></td>
							<cfif len(attributes.process_type_ba)>
								<td class="txtbold">#ba_belge_toplam#</td>
								<td class="txtbold" format="numeric">#TLFormat(ba_net_toplam)#</td>
							</cfif>
							<cfif len(attributes.process_type_bs)>
								<td class="txtbold">#bs_belge_toplam#</td>
								<td class="txtbold" format="numeric">#TLFormat(bs_net_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_tax') and attributes.is_tax>
								<td class="txtbold" format="numeric">#TLFormat(kdv_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_otv') and attributes.is_otv>
								<td class="txtbold" format="numeric">#TLFormat(otv_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
								<td class="txtbold" format="numeric">#TLFormat(oiv_toplam)#</td>
							</cfif>
							</cfoutput>
						</tr>
					</tfoot>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="18"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			<cfelse>
					<cfif get_ba_bs.recordcount>
					<tbody>
					<cfoutput query="GET_BA_BS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
							<td>#member_code#</td>
							<td>#fullname#</td>
							<td><cfif not len(taxno)>#tc_identy_no#</cfif></td>
							<td>#taxoffice#</td>
							<td style="mso-number-format:\@;">#taxno#</td>
							<cfif x_show_fax eq 1><td style="mso-number-format:\@;">#fax_code# #fax#</td></cfif>
							<cfif x_show_mail eq 1><td style="mso-number-format:\@;">#mail#</td></cfif>
							<cfif x_show_detail_address eq 1>
								<td style="mso-number-format:\@;">#ADDRESS#</td>
							</cfif>
							<td>#city_name#</td>
							<td>#country_name#</td>
							<cfif len(attributes.process_type_ba)>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('ba_paper_count_#company_id#') and len(evaluate('ba_paper_count_#company_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_><!--- ilişkili üyenin hareketi tekrar toplama eklenmesin diye --->
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_paper_count_#consumer_id#') and len(evaluate('ba_paper_count_#consumer_id#'))>
											<cfset ba_paper_count_ = #evaluate('ba_paper_count_#consumer_id#')#>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										<cfelse>
											<cfset ba_paper_count_ = 0>
											<cfset ba_belge_toplam = ba_belge_toplam + ba_paper_count + ba_paper_count_>
										</cfif>
									</cfif>
									#ba_paper_count + ba_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('ba_total_#company_id#') and len(evaluate('ba_total_#company_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('ba_total_#consumer_id#') and len(evaluate('ba_total_#consumer_id#'))>
											<cfset ba_total_ = #evaluate('ba_total_#consumer_id#')#>
											<cfset ba_net_toplam = ba_net_toplam + ba_total+ ba_total_>
										<cfelse>
											<cfset ba_total_ = 0>
											<cfset ba_net_toplam = ba_net_toplam + ba_total + ba_total_>
										</cfif>
									</cfif>
									#TLFormat(ba_total + ba_total_)#
								</td>
							</cfif>
							<cfif len(attributes.process_type_bs)>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('bs_paper_count_#company_id#') and len(evaluate('bs_paper_count_#company_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('bs_paper_count_#consumer_id#') and len(evaluate('bs_paper_count_#consumer_id#'))>
											<cfset bs_paper_count_ = #evaluate('bs_paper_count_#consumer_id#')#>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										<cfelse>
											<cfset bs_paper_count_ = 0>
											<cfset bs_belge_toplam = bs_belge_toplam + bs_paper_count + bs_paper_count_>
										</cfif>
									</cfif>
									#bs_paper_count + bs_paper_count_#
								</td>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('bs_total_#company_id#') and len(evaluate('bs_total_#company_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('bs_total_#consumer_id#') and len(evaluate('bs_total_#consumer_id#'))>
											<cfset bs_total_ = #evaluate('bs_total_#consumer_id#')#>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										<cfelse>
											<cfset bs_total_ = 0>
											<cfset bs_net_toplam = bs_net_toplam + bs_total + bs_total_>
										</cfif>
									</cfif>
									#TLFormat(bs_total + bs_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_tax') and attributes.is_tax>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('tax_total_#company_id#') and len(evaluate('tax_total_#company_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('tax_total_#consumer_id#') and len(evaluate('tax_total_#consumer_id#'))>
											<cfset tax_total_ = #evaluate('tax_total_#consumer_id#')#>
											<cfset kdv_toplam = kdv_toplam + tax_total>
										<cfelse>
											<cfset tax_total_ = 0>
											<cfset kdv_toplam = kdv_toplam + tax_total + tax_total_>
										</cfif>
									</cfif>
									#TLFormat(tax_total + tax_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_otv') and attributes.is_otv>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('otv_total_#company_id#') and len(evaluate('otv_total_#company_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('otv_total_#consumer_id#') and len(evaluate('otv_total_#consumer_id#'))>
											<cfset otv_total_ = #evaluate('otv_total_#consumer_id#')#>
											<cfset otv_toplam = otv_toplam + otv_total>
										<cfelse>
											<cfset otv_total_ = 0>
											<cfset otv_toplam = otv_toplam + otv_total + otv_total_>
										</cfif>
									</cfif>
									#TLFormat(otv_total + otv_total_)#
								</td>
							</cfif>
							<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
								<td  format="numeric">
									<cfif Len(company_id)>
										<cfif isdefined('oiv_total_#company_id#') and len(evaluate('oiv_total_#company_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#company_id#')#><!--- ilişkili üyenin bilgisi --->
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									<cfelseif Len(consumer_id)>
										<cfif isdefined('oiv_total_#consumer_id#') and len(evaluate('oiv_total_#consumer_id#'))>
											<cfset oiv_total_ = #evaluate('oiv_total_#consumer_id#')#>
											<cfset oiv_toplam = oiv_toplam + oiv_total>
										<cfelse>
											<cfset oiv_total_ = 0>
											<cfset oiv_toplam = oiv_toplam + oiv_total + oiv_total_>
										</cfif>
									</cfif>
									#TLFormat(oiv_total + oiv_total_)#
								</td>
							</cfif>
							<cfif type_ neq 1>
								<!-- sil --><td style="text-align:center" nodraw="1"><a href="javascript://" onclick="open_window('#company_id#','#consumer_id#');"><img src="/images/print2.gif" border="0" title="<cf_get_lang dictionary_id='57474.Yazdır'>" align="absmiddle"></a></td><!-- sil -->
							</cfif>
						</tr>
						<cfset currentrow_ = currentrow>
					</cfoutput>
					</tbody>
					<cfif currentrow_ eq get_ba_bs.recordcount>
					<tfoot>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>							
							<cfoutput>
							<cfset colspan_info = 6>
							<cfif x_show_fax eq 1><cfset colspan_info = colspan_info+1></cfif>
							<cfif x_show_mail eq 1><cfset colspan_info = colspan_info+1></cfif>
							<cfif x_show_detail_address eq 1><cfset colspan_info = colspan_info+1></cfif>
							<td colspan="#colspan_info#"></td>
							<cfif len(attributes.process_type_ba)>							
								<td class="txtbold">#ba_belge_toplam#</td>
								<td class="txtbold" format="numeric">#TLFormat(ba_net_toplam)#</td>
							</cfif>
							<cfif len(attributes.process_type_bs)>
								<td class="txtbold">#bs_belge_toplam#</td>
								<td class="txtbold" format="numeric">#TLFormat(bs_net_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_tax') and attributes.is_tax>
								<td class="txtbold" format="numeric">#TLFormat(kdv_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_otv') and attributes.is_otv>
								<td class="txtbold" format="numeric">#TLFormat(otv_toplam)#</td>
							</cfif>
							<cfif isdefined('attributes.is_oiv') and attributes.is_oiv>
								<td class="txtbold" format="numeric">#TLFormat(oiv_toplam)#</td>
							</cfif>
							</cfoutput>
						</tr>
					</tfoot>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="18"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</cfif>		
	</cf_report_list>
	
	<cfset adres = "">
	<cfif get_ba_bs.recordcount and (attributes.maxrows lt attributes.totalrecords)>
		<cfset adres = "#attributes.fuseaction#&form_varmi=1">
		<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
			<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
			<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.process_type_ba") and len(attributes.process_type_ba)>
			<cfset adres = "#adres#&process_type_ba=#attributes.process_type_ba#">
		</cfif>
		<cfif isDefined("attributes.process_type_bs") and len(attributes.process_type_bs)>
			<cfset adres = "#adres#&process_type_bs=#attributes.process_type_bs#">
		</cfif>
		<cfif isDefined("attributes.is_tax")>
			<cfset adres = "#adres#&is_tax=#attributes.is_tax#">
		</cfif>
		<cfif isDefined("attributes.is_otv")>
			<cfset adres = "#adres#&is_otv=#attributes.is_otv#">
		</cfif>
		<cfif isDefined("attributes.is_oiv")>
			<cfset adres = "#adres#&is_oiv=#attributes.is_oiv#">
		</cfif>
		<cfif isDefined("attributes.total")>
			<cfset adres = "#adres#&total=#attributes.total#">
		</cfif>
		<!---
		<cfif isDefined("attributes.is_carigrup")>
			<cfset adres = "#adres#&is_carigrup=#attributes.is_carigrup#">
		</cfif>--->
		<cfif isDefined("attributes.company_id")>
			<cfset adres = "#adres#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isDefined("attributes.consumer_id")>
			<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isDefined("attributes.company")>
			<cfset adres = '#adres#&company=#attributes.company#'>
		</cfif>
		<!---
		<cfif isDefined("attributes.is_relation")>
			<cfset adres = "#adres#&is_relation=#attributes.is_relation#">
		</cfif>--->
		<cfif isDefined("attributes.relation_type")>
			<cfset adres = "#adres#&relation_type=#attributes.relation_type#">
		</cfif>
		<cfif isDefined("attributes.is_knt")>
			<cfset adres = "#adres#&is_knt=#attributes.is_knt#">
		</cfif>
		<cfif isDefined("attributes.is_earchive")>
			<cfset adres = "#adres#&is_earchive=#attributes.is_earchive#">
		</cfif>
		<cfif isDefined("attributes.is_efatura")>
			<cfset adres = "#adres#&is_efatura=#attributes.is_efatura#">
		</cfif>
		<tbody>
			<tr>
				<td><cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres#">
				</td>
				
			</tr>
		</tbody>
	</cfif>	
</cfif>
		

<script type="text/javascript">
	/*
	function display_()
	{
		if(document.ba_bs_form.is_relation.checked == true)
			relation_.style.display = '';
		else
		{
			relation_.style.display = 'none';
			document.ba_bs_form.relation_type.value = '';
		}
	} */
	function open_window(cmp,cns)
	{
		<cfif not isdefined("attributes.form_varmi")>
			alert("<cf_get_lang dictionary_id='60804.Lütfen Print Etmek İçin Önce Verileri Dökünüz'>!");
			return false;
		<cfelse>
			var add_url = "";
			if(cmp != undefined && cmp != "")
				add_url = add_url + "&row_company=" + cmp;
			if(cns != undefined && cns != "")
				add_url = add_url + "&row_consumer=" + cns;
			windowopen('<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_report_ba_bs_print#page_code#</cfoutput>'+add_url,'project');
//			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=216&action_id=#URLEncodedFormat(page_code)#</cfoutput>'+add_url,'page','popup_print_files');
		</cfif>
	}
	function control()
	{
		if(ba_bs_form.is_xml.checked == true && ba_bs_form.process_type_ba.value!='' && ba_bs_form.process_type_bs.value!='')
		{
			alert("<cf_get_lang dictionary_id='40649.Xml İçin Alış veya Satış Tiplerinden Sadece Birini Seçmelisiniz'>!");
			return false;
		}
		if(ba_bs_form.process_type_ba.value=='' && ba_bs_form.process_type_bs.value=='')
		{
			alert("<cf_get_lang dictionary_id='40373.Alış Yada Satış Tiplerinden Birini Seçiniz'>!");
			return false;
		}
		else
		{
			document.ba_bs_form.total.value = filterNum(document.ba_bs_form.total.value);
		}

		if(document.ba_bs_form.is_excel.checked==false)
			{
				document.ba_bs_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.report_ba_bs"
				return true;
			}
			else{
				document.ba_bs_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_report_ba_bs</cfoutput>"
			}
		
	}
	hide();
	function hide(){
		if(is_notification.checked){
		$("#is_efatura").prop("checked",true);
			$("#is_earchive").prop("checked",true);
			$("#hide_efatura").hide();
			$("#hide_earchive").hide();
		}
	}
	function hide_check(){
		hide();
		if(is_notification.checked ==false){
			$("#is_efatura").prop("checked",false);
			$("#is_earchive").prop("checked",false);
			$("#hide_efatura").show();
			$("#hide_earchive").show();
		}
	}
</script>
