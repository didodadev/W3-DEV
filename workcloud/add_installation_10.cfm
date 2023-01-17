<cfquery name="GET_COMPANY_PERIODS" datasource="#dsn#">
    SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #company_id#
</cfquery>
<cftransaction action="begin">
    <cftry>
        <cfquery name="drop_view" datasource="#company_dsn#">
            IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_ALL_INVOICE_ROW]'))
                DROP VIEW [GET_ALL_INVOICE_ROW]
        </cfquery>
        <cfif get_company_periods.recordcount>
            <cfquery name="cr_view" datasource="#company_dsn#">
                CREATE VIEW [GET_ALL_INVOICE_ROW] AS
                <cfloop query="GET_COMPANY_PERIODS">
                    SELECT
                        INVOICE_ID,
                        SHIP_ID,
                        WRK_ROW_RELATION_ID,
                        AMOUNT,
                        WRK_ROW_ID
                    FROM
                        [#dsn#_#get_company_periods.period_year#_#company_id#].INVOICE_ROW
                    WHERE
                        INVOICE_ID IN(SELECT S.INVOICE_ID FROM [#dsn#_#get_company_periods.period_year#_#company_id#].INVOICE S WHERE ISNULL(S.IS_IPTAL,0) = 0)
                    <cfif currentrow neq get_company_periods.recordcount> UNION</cfif>
                </cfloop>				
            </cfquery>
        </cfif>
        <cfquery name="drop_view" datasource="#company_dsn#">
            IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_ALL_SHIP_ROW]'))
                DROP VIEW [GET_ALL_SHIP_ROW]
        </cfquery>
        <cfif get_company_periods.recordcount>
            <cfquery name="cr_view" datasource="#company_dsn#">
                CREATE VIEW [GET_ALL_SHIP_ROW] AS
                    <cfloop query="GET_COMPANY_PERIODS">
                        SELECT
                            SHIP_ID,
                            WRK_ROW_RELATION_ID,
                            WRK_ROW_ID,
                            AMOUNT
                        FROM
                            [#dsn#_#get_company_periods.period_year#_#company_id#].SHIP_ROW
                        WHERE
                            SHIP_ID IN(SELECT S.SHIP_ID FROM [#dsn#_#get_company_periods.period_year#_#company_id#].SHIP S WHERE ISNULL(S.IS_SHIP_IPTAL,0) = 0)
                        <cfif currentrow neq get_company_periods.recordcount> UNION</cfif>
                    </cfloop>
            </cfquery>		
        </cfif>
             <cftransaction action="commit">
        <cfcatch>
            <cftransaction action="rollback">
        </cfcatch>
    </cftry>
</cftransaction>
<!---İlgili firmanın E-Faturayı kullanıp kullanmadığı kontrol ediliyor.--->
<cfquery name="get_einvoice_info" datasource="#dsn_period#">
		SELECT 
			IS_EFATURA 
		FROM 
			[#dsn#].OUR_COMPANY_INFO 
		WHERE 
			IS_EFATURA = 1 AND 
			COMP_ID = #company_id#
</cfquery>
<cfif get_einvoice_info.recordcount><!---E-Fatura kullanıyorsa tablo create ediliyor.--->
	<cfquery name="set_einvoice_number" datasource="#dsn_period#">	
			CREATE TABLE EINVOICE_NUMBER(
					[ID] [int] IDENTITY(1,1) NOT NULL,
					[EINVOICE_PREFIX] [varchar](50) NOT NULL,
					[EINVOICE_NUMBER] [varchar](50) ,
			CONSTRAINT [PK_EINVOICE_NUMBER] PRIMARY KEY CLUSTERED 
				(
					[ID] ASC
				)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
				) ON [PRIMARY]
	</cfquery><!---İlgili firmanın bir önceki dönem kaydı olup olmadığı kontrol ediliyor.--->
	<cfquery name="get_company_period_last_year" datasource="#dsn#">
			SELECT 
				PERIOD_YEAR 
			FROM 
				SETUP_PERIOD
			WHERE
				PERIOD_YEAR IN (#get_period.period_year-1#) AND 
				OUR_COMPANY_ID = #company_id#
	</cfquery>
    <cfif get_company_period_last_year.recordcount> <!---İlgili tabloda kayıt varmı--->
		<cfquery name="is_get_company_period_records" datasource="#dsn#_#get_company_period_last_year.period_year#_#company_id#">
			IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE'  AND TABLE_NAME='EINVOICE_NUMBER' AND TABLE_SCHEMA = '#dsn#_#get_company_period_last_year.period_year#_#company_id#')
			SELECT 1 AS res ELSE SELECT 0 AS res;
		</cfquery>
		<cfif is_get_company_period_records.res>
		<cfquery name="get_company_period_records" datasource="#dsn#_#get_company_period_last_year.period_year#_#company_id#">
			SELECT EINVOICE_PREFIX FROM EINVOICE_NUMBER
		</cfquery>
		<cfif get_company_period_records.recordcount><!---Kayıt varsa aktarım işlemi yapılıyor.--->
		<cfquery name="transfer_einvoice_number" datasource="#dsn_period#">
			INSERT INTO [EINVOICE_NUMBER]
				([EINVOICE_PREFIX],
				 [EINVOICE_NUMBER])
			 (SELECT [EINVOICE_PREFIX],'000000001' FROM [#dsn#_#get_company_period_last_year.period_year#_#company_id#].[EINVOICE_NUMBER])
		</cfquery>
		</cfif>
		</cfif>
	</cfif>
</cfif>