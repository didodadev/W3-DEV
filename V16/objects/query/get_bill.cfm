<cfquery name="get_bill" datasource="#dsn2#">
	WITH CTE AS
    (
		<cfif not (isdefined('attributes.cons_id') and len(attributes.cons_id))>
				SELECT 
					INVOICE.INVOICE_ID,
					INVOICE.PURCHASE_SALES,
					INVOICE.INVOICE_NUMBER,
					INVOICE.GROSSTOTAL,
					INVOICE.TAXTOTAL,
					INVOICE.NETTOTAL,
					INVOICE.INVOICE_DATE,
					INVOICE.RECORD_DATE,
					COMPANY.COMPANY_ID,
					INVOICE.DEPARTMENT_ID,
					COMPANY.FULLNAME
				FROM 
					INVOICE, 
					#dsn_alias#.COMPANY AS COMPANY
				WHERE
					INVOICE.COMPANY_ID = COMPANY.COMPANY_ID
					<cfif isDefined("attributes.CAT") and attributes.CAT gt 1>
						AND INVOICE.INVOICE_CAT=#attributes.CAT#
					<cfelseif isDefined("attributes.CAT") and attributes.CAT lte 1>
						AND INVOICE.PURCHASE_SALES=#attributes.CAT#
					</cfif>
					<cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
						AND INVOICE.INVOICE_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
					</cfif>
				<cfif not isdefined("attributes.invoice_is_cash") or (isdefined("attributes.invoice_is_cash") and attributes.invoice_is_cash eq 1)>
				AND
				(
					INVOICE.IS_CASH IS NULL
					OR 
					INVOICE.IS_CASH =0
				)
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND INVOICE_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND INVOICE_DATE <= #attributes.finish_date#
				</cfif>
				<cfif (isdefined('attributes.department_txt') and len(attributes.department_txt) and isdefined('attributes.department_id') and len(attributes.department_id))>
					AND INVOICE.DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
				</cfif>
				<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
					AND INVOICE.COMPANY_ID IN (#attributes.comp_id#)<!--- sistem ödeme planından birden çok üye için bakılanlar için IN li bakıldı. --->
				</cfif>
		</cfif>
		<cfif not (isdefined('attributes.comp_id') and len(attributes.comp_id)) and not (isdefined('attributes.cons_id') and len(attributes.cons_id))>
			UNION
		</cfif>
		<cfif not (isdefined('attributes.comp_id') and len(attributes.comp_id))>		
				SELECT
					INVOICE.INVOICE_ID,
					INVOICE.PURCHASE_SALES,
					INVOICE.INVOICE_NUMBER,
					INVOICE.GROSSTOTAL,
					INVOICE.TAXTOTAL,
					INVOICE.NETTOTAL,
					INVOICE.INVOICE_DATE,
					INVOICE.RECORD_DATE,
					CONSUMER.CONSUMER_ID COMPANY_ID,
					INVOICE.DEPARTMENT_ID,
					CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME FULLNAME
				FROM 
					INVOICE, 
					#dsn_alias#.CONSUMER AS CONSUMER
				WHERE
					INVOICE.CONSUMER_ID = CONSUMER.CONSUMER_ID
					<cfif isDefined("attributes.CAT") and attributes.CAT gt 1>
						AND INVOICE.INVOICE_CAT = #attributes.CAT#
					<cfelseif isDefined("attributes.CAT") and attributes.CAT lte 1>
						AND INVOICE.PURCHASE_SALES = #attributes.CAT#
					</cfif>
					<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
						AND INVOICE.INVOICE_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
					</cfif>
				AND
				(
					INVOICE.IS_CASH IS NULL
					OR 
					INVOICE.IS_CASH =0
				)
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND INVOICE_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND INVOICE_DATE <= #attributes.finish_date#
				</cfif>
				<cfif (isdefined('attributes.department_txt') and len(attributes.department_txt) and isdefined('attributes.department_id') and len(attributes.department_id))>
					AND INVOICE.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
				</cfif>
				<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>
					AND INVOICE.CONSUMER_ID IN (#attributes.cons_id#)
				</cfif>
		</cfif>
		<cfif isDefined("attributes.CAT") and attributes.cat eq -1>
			UNION
			SELECT 
				INVOICE.EXPENSE_ID AS INVOICE_ID
				,-1 AS PURCHASE_SALES
				,INVOICE.PAPER_NO AS INVOICE_NUMBER
				,INVOICE.TOTAL_AMOUNT_KDVLI AS GROSSTOTAL
				,INVOICE.KDV_TOTAL AS TAXTOTAL
				,INVOICE.TOTAL_AMOUNT AS NETTOTAL
				,INVOICE.EXPENSE_DATE AS INVOICE_DATE
				,INVOICE.RECORD_DATE
				,CASE WHEN INVOICE.CH_CONSUMER_ID IS NOT NULL THEN CONSUMER.CONSUMER_ID ELSE INVOICE.CH_COMPANY_ID END AS COMPANY_ID
				,INVOICE.DEPARTMENT_ID
				,CASE WHEN INVOICE.CH_CONSUMER_ID IS NOT NULL THEN CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME ELSE COMPANY.FULLNAME END AS FULLNAME
			FROM 
				EXPENSE_ITEM_PLANS AS INVOICE
				LEFT JOIN #dsn_alias#.CONSUMER AS CONSUMER ON INVOICE.CH_CONSUMER_ID = CONSUMER.CONSUMER_ID
				LEFT JOIN #dsn_alias#.COMPANY AS COMPANY ON INVOICE.CH_COMPANY_ID = COMPANY.COMPANY_ID
			WHERE 
				INVOICE.ACTION_TYPE = 120 
				AND (INVOICE.CH_CONSUMER_ID IS NOT NULL OR INVOICE.CH_COMPANY_ID IS NOT NULL)
				AND (
					INVOICE.IS_CASH IS NULL
					OR INVOICE.IS_CASH = 0
					)
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
						AND INVOICE.PAPER_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
					</cfif>
				<cfif (isdefined('attributes.department_txt') and len(attributes.department_txt) and isdefined('attributes.department_id') and len(attributes.department_id))>
					AND INVOICE.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND EXPENSE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND EXPENSE_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND EXPENSE_DATE <= #attributes.finish_date#
				</cfif>
				<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>
					AND INVOICE.CH_CONSUMER_ID IN (#attributes.cons_id#)
				</cfif>
				<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
					AND INVOICE.CH_COMPANY_ID IN (#attributes.comp_id#)
				</cfif>
		</cfif>
    )
   SELECT * FROM CTE 
   ORDER BY
        INVOICE_DATE DESC,
        RECORD_DATE DESC
</cfquery>
