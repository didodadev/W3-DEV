<!--- konsinye raporunu çalıştırıldığında şirket db de "consigment_report_table" tablosunu oluşturup, rapor sonuçlarını bu tabloya aktarır OZDEN20090907--->
<!--- Tablo Adını İngilizceye cevirdim e.a 20131008--->
<cfif not isdefined('is_export_table')>
	<cfquery name="check_table" datasource="#dsn3#">
		SELECT 
        	NAME
        FROM 
    	    sysobjects 
        WHERE 
	        TYPE='U' AND 
        	NAME = 'CONSIGMENT_REPORT_TABLE'
	</cfquery>
	<cfif check_table.recordcount>
		<cfquery name="check_table" datasource="#dsn3#">
			DROP TABLE CONSIGMENT_REPORT_TABLE
		</cfquery>
	</cfif>
	<cfquery name="CREATE_CONSIGMENT_REPORT_TABLE" datasource="#dsn3#">
		CREATE TABLE [CONSIGMENT_REPORT_TABLE] (
			[REPORT_TABLE_ID] [int] IDENTITY(1,1) NOT NULL,
			[DATE] [datetime] NULL,
			[SHIP_NO] [nvarchar] (100) NULL,
			[DOCUMENT_TYPE] [nvarchar] (250) NULL,
			[PROJECT] [nvarchar] (300) NULL,
			[CURRENT_ACCOUNT] [nvarchar] (300) NULL,
			[CATEGORY] [nvarchar] (300) NULL,
			[STOCK_CODE] [nvarchar] (150) NULL,
			[PARODUCT_NAME] [nvarchar] (250) NULL,
			[DEPO_ID][nvarchar] (250) NULL,
			[DEPO_OUT][nvarchar] (250) NULL,
			[IN] [float] NULL,
			[OUT] [float] NULL,
			[DOCUMENT_COST] [float] NULL,
			[DOCUMENT_COST_P_Br] [nvarchar] (20) NULL,
			[RETURN_SHIP_AMOUNT] [float] NULL,
			[RETURN_SHIP_COST] [float] NULL,
			[RETURN_SHIP_COST_P_Br] [nvarchar] (20) NULL,
			[RETURN_SHIP_NO] [nvarchar] (250) NULL,
			[INVOICE_AMOUNT] [float] NULL,
			[INVOICE_COST] [float] NULL,
			[INVOICE_COST_P_Br] [nvarchar] (20) NULL,
			[INVOICE_NO]  [nvarchar] (250) NULL,
			<cfif attributes.is_month_based_ eq 1> <!--- faturalama bilgileri aylık gosterilecekse --->
				<cfset month_count_ = datediff('m',attributes.date1,attributes.date2)>
				<cfset start_date=dateformat(attributes.date1,'mm_yyyy')>
				<cfoutput>
				<cfloop from="0" to="#month_count_#" index="month_ii">
					<cfset start_date=dateformat(date_add('m',month_ii,attributes.date1),'mm_yyyy')>
					[INV_AMOUNT_#start_date#] [float] NULL,
					[INV_COST_#start_date#] [float] NULL,
					[INV_No_#start_date#]  [nvarchar] (250) NULL,
				</cfloop>
				</cfoutput>
			</cfif>
			[REMAINING_AMOUNT] [float] NULL,
			[COST] [float] NULL,
			[COST_P_Br] [nvarchar] (20) NULL
			 CONSTRAINT [PK_CONSIGMENT_REPORT_TABLE] PRIMARY KEY CLUSTERED 
			(
				[REPORT_TABLE_ID] ASC
			) ON [PRIMARY]
  )
	</cfquery>
<cfelse>
	<cfset get_paper_cost_total_=''>
	<cfif isdefined("GET_ALL_PRODUCT_COST") and GET_ALL_PRODUCT_COST.recordcount>
		<cfquery name="get_paper_cost_" dbtype="query" maxrows="1">
			SELECT 
				PRODUCT_ID, PURCHASE_NET_SYSTEM,
				PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST_SYSTEM
			FROM 
				GET_ALL_PRODUCT_COST
			WHERE 
				PRODUCT_ID =#GET_ALL_SHIP.PRODUCT_ID#
			ORDER BY START_DATE DESC, RECORD_DATE DESC,PRODUCT_COST_ID DESC
		</cfquery>
		<cfif get_paper_cost_.recordcount>
			<cfset get_paper_cost_total_= (get_paper_cost_.PURCHASE_NET_SYSTEM+get_paper_cost_.PURCHASE_EXTRA_COST_SYSTEM)>
		</cfif>
	</cfif>
	<cfquery name="EXPORT_TO_CONSIGMENT_TABLE" datasource="#dsn3#">
		INSERT INTO CONSIGMENT_REPORT_TABLE
		(
			[DATE],
			[SHIP_NO],
			[DOCUMENT_TYPE],
			[PROJECT],
			[CURRENT_ACCOUNT],
			[CATEGORY],
			[STOCK_CODE],
			[PARODUCT_NAME],
			[DEPO_ID],
			[DEPO_OUT],
			[IN],
			[OUT],
			[DOCUMENT_COST],
			[DOCUMENT_COST_P_BR],
			[RETURN_SHIP_AMOUNT],
			[RETURN_SHIP_COST],
			[RETURN_SHIP_COST_P_BR],
			[RETURN_SHIP_NO],
			[INVOICE_AMOUNT],
			[INVOICE_COST],
			[INVOICE_COST_P_BR],
			[INVOICE_NO],
			<cfif attributes.is_month_based_ eq 1> <!--- faturalama bilgileri aylık gosterilecekse --->
				<cfset month_count_ = datediff('m',attributes.date1,attributes.date2)>
				<cfset start_date=dateformat(attributes.date1,'mm_yyyy')>
				<cfoutput>
				<cfloop from="0" to="#month_count_#" index="month_ii">
					<cfset start_date=dateformat(date_add('m',month_ii,attributes.date1),'mm_yyyy')>
					[INV_AMOUNT_#start_date#],
					[INV_COST_#start_date#],
					[INV_No_#start_date#],
				</cfloop>
				</cfoutput>
			</cfif>
			[REMAINING_AMOUNT],
			[COST],
			[COST_P_BR]
		)
		VALUES
		(
			<cfif len(ISLEM_TARIHI)>#CreateODBCDate(ISLEM_TARIHI)#<cfelse>NULL</cfif>,
			<cfif len(BELGE_NO)>'#BELGE_NO#'<cfelse>NULL</cfif>,
			<cfif len(BELGE_TURU)>'#BELGE_TURU#'<cfelse>NULL</cfif>,
			<cfif len(PROJECT_ID) and listfind(project_id_list,PROJECT_ID)>'#get_project_info.PROJECT_HEAD[listfind(project_id_list,PROJECT_ID)]#'<cfelse>NULL</cfif>,
			<cfif len(COMPANY_ID)>
				'#get_company_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#'
			<cfelseif len(CONSUMER_ID)>
				'#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#'
			<cfelseif len(DELIVER_EMP) and isnumeric(DELIVER_EMP)>
				'#get_deliver_emp_detail.EMPLOYEE_NAME[listfind(deliver_emp_list,DELIVER_EMP,',')]# #get_deliver_emp_detail.EMPLOYEE_SURNAME[listfind(deliver_emp_list,DELIVER_EMP,',')]#'
			<cfelse>
				NULL
			</cfif>,
			<cfif len(company_id)>
				'#get_company_detail.COMPANYCAT[listfind(company_id_list,COMPANY_ID,',')]#'
			<cfelseif len(consumer_id)>
				'#get_consumer_detail.CONSCAT[listfind(consumer_id_list,CONSUMER_ID,',')]#'
			<cfelse>
				NULL
			</cfif>,
			<cfif len(stock_code)>'#stock_code#'<cfelse>NULL</cfif>,		
			<cfif len(product_name)>'#product_name#'<cfelse>NULL</cfif>,
			<cfif len(DEPARTMENT_ID) and (DEPARTMENT_ID neq 0)>'#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID,',')]#'<cfelse>NULL</cfif>,
			<cfif len(DEPARTMENT_ID_2) and (DEPARTMENT_ID_2 neq 0)>'#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID_2,',')]#'<cfelse>NULL</cfif>,
			<cfif listfind('75,77',SHIP_TYPE)><!--- kons. cıkıs iade,kons. giris --->
				#wrk_round(PAPER_AMOUNT)#
			<cfelse>
				NULL
			</cfif>,
			<cfif listfind('72,79',SHIP_TYPE)> <!--- kons. cıkıs, kons. giris iade iade --->
				#wrk_round(PAPER_AMOUNT)#
			<cfelse>
				NULL
			</cfif>,
			<cfif len(TOTAL_COST)> #wrk_round(TOTAL_COST)# <cfset page_totals[1][11] = page_totals[1][11] + TOTAL_COST><cfelse>NULL</cfif>,
			'#session.ep.money#',
			<cfif isdefined('used_ship_amount_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_amount_#SHIP_ID#_#STOCK_ID#'))>
				#wrk_round(evaluate('used_ship_amount_#SHIP_ID#_#STOCK_ID#'))#
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('used_ship_cost_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
				#wrk_round(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))# 
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('used_ship_cost_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
				'#session.ep.money#'
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('to_ship_number_list_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#'))>
				'#evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#')#'
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				#wrk_round(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))#
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				#wrk_round(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))# 
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				'#session.ep.money#'
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				'#evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#')#'
			<cfelse>
				NULL
			</cfif>,
            <cfif attributes.is_month_based_ eq 1>
                <cfloop from="0" to="#month_count_#" index="month_hh">
                    <cfset start_date=dateformat(date_add('m',month_hh,attributes.date1),'mm/yyyy')>
                    <cfset temp_month_=month(start_date)>
                    <cfset temp_year_=year(start_date)>
                    <cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
                        #wrk_round(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))#
                    <cfelse>
                        NULL
                    </cfif>,
                    <cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
                        #wrk_round(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))# 
                    <cfelse>
                        NULL
                    </cfif>,
                    <cfif isdefined('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
                        '#evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#')#'
                    <cfelse>
                        NULL
                    </cfif>,
                </cfloop>
            </cfif>
			<cfif len(consigment_dept_amount_)>
				#wrk_round(consigment_dept_amount_)#
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined("GET_ALL_PRODUCT_COST") and GET_ALL_PRODUCT_COST.recordcount>
				<cfif len(get_paper_cost_total_) and len(consigment_dept_amount_)>
					#wrk_round(consigment_dept_amount_*get_paper_cost_total_)# 
				<cfelse>
					NULL
				</cfif>
			<cfelse>
				NULL
			</cfif>,
			<cfif isdefined("GET_ALL_PRODUCT_COST") and GET_ALL_PRODUCT_COST.recordcount>
				'#session.ep.money#'
			<cfelse>
				NULL
			</cfif>			
		)
	</cfquery>
	<cfquery name="UPD_WRK_SESSION" datasource="#dsn#"><!--- kumulatif raporlamada session ın devam etmesi için --->
		UPDATE 
			WRK_SESSION 
		SET 
			ACTION_DATE = #now()#
		WHERE			
			USERID = #session.ep.userid#
	</cfquery>
</cfif>
