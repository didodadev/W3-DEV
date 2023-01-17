<font color="FF0000"><cf_get_lang dictionary_id='62747.Stok Hareketleri Aktarılıyor Lütfen Sayfayı Yenilemeyiniz'> !!</font><br/><br/>
<cfquery name="get_all_main" datasource="#dsn#">
	SELECT 
		sysobjects.name table_name,
		syscolumns.name col_name
	FROM 
	INFORMATION_SCHEMA.COLUMNS ISC,
		syscolumns ,
		sysobjects		
	WHERE 
		syscolumns.name = ISC.COLUMN_NAME AND
		sysobjects.name = ISC.TABLE_NAME and
		ISC.TABLE_SCHEMA = '#dsn#' AND
		(syscolumns.name = 'STOCK_ID') AND
		sysobjects.id = syscolumns.id AND
		syscolumns.status <> 128 AND
		syscolumns.id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name<>'dtproperties' AND SUBSTRING(name,1,1) <> '_')
</cfquery>
<cfquery name="get_all_company" datasource="#dsn3#">
	SELECT 
		sysobjects.name table_name,
		syscolumns.name col_name
	FROM 
		INFORMATION_SCHEMA.COLUMNS ISC,
		syscolumns ,
		sysobjects		
	WHERE 
		syscolumns.name = ISC.COLUMN_NAME AND
		sysobjects.name = ISC.TABLE_NAME and
		ISC.TABLE_SCHEMA = '#dsn3#' AND
		(syscolumns.name = 'STOCK_ID') AND
		sysobjects.id = syscolumns.id AND
		syscolumns.status <> 128 AND
		syscolumns.id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name<>'dtproperties' AND SUBSTRING(name,1,1) <> '_')
</cfquery>
<cfquery name="get_all_period" datasource="#dsn2#">
	SELECT 
		sysobjects.name table_name,
		syscolumns.name col_name
	FROM 
		INFORMATION_SCHEMA.COLUMNS ISC,
		syscolumns,
		sysobjects		
	WHERE 
		syscolumns.name = ISC.COLUMN_NAME AND
		sysobjects.name = ISC.TABLE_NAME and
		ISC.TABLE_SCHEMA = '#dsn2#' AND
		(syscolumns.name = 'STOCK_ID') AND
		sysobjects.id = syscolumns.id AND
		syscolumns.status <> 128 AND
		syscolumns.id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name<>'dtproperties' AND SUBSTRING(name,1,1) <> '_')
</cfquery>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_old_category_code" datasource="#dsn1#">
			SELECT 
				PC.HIERARCHY,
				S.STOCK_CODE,
                S.PRODUCT_ID
			FROM 
				STOCKS S,
				PRODUCT P ,
				PRODUCT_CAT PC
			WHERE 
				S.STOCK_ID = #attributes.from_stock_id#
				AND P.PRODUCT_ID = S.PRODUCT_ID
				AND P.PRODUCT_CATID = PC.PRODUCT_CATID
		</cfquery>
		<cfquery name="get_new_category_code" datasource="#dsn1#">
			SELECT 
				PC.HIERARCHY,
				P.PRODUCT_CODE,
				P.PRODUCT_NAME
			FROM 
				PRODUCT P ,
				PRODUCT_CAT PC
			WHERE 
				P.PRODUCT_ID = #attributes.to_product_id#
				AND P.PRODUCT_CATID = PC.PRODUCT_CATID
		</cfquery>
		<cfset new_stock_code = "#get_new_category_code.HIERARCHY##replace(get_old_category_code.stock_code,get_old_category_code.HIERARCHY,'')#">

		<!--- Tüm tablolar çin hareket aktarımları --->
		<!--- main --->
		<cfoutput query="get_all_main">
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn_alias#.#table_name# SET PRODUCT_ID = #attributes.to_product_id# WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn_alias#.#table_name# SET PRODUCT_NAME = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn_alias#.#table_name# SET NAME_PRODUCT = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
		</cfoutput>
		<!--- şirket --->
		<cfoutput query="get_all_company">
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn3_alias#.#table_name# SET PRODUCT_ID = #attributes.to_product_id# WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn3_alias#.#table_name# SET PRODUCT_NAME = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
			<cftry>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE #dsn3_alias#.#table_name# SET NAME_PRODUCT = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
				</cfquery>
				<cfcatch></cfcatch>
			</cftry>
		</cfoutput>
		<!--- dönem --->
		<cfquery name="get_period" datasource="#dsn1#">
			SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfloop query="get_period">
			<cfset new_dsn2 = "#dsn#_#get_period.period_year#_#session.ep.company_id#.dbo">
			<cfoutput query="get_all_period">
				<cftry>
					<cfquery name="upd_product" datasource="#dsn1#">
						UPDATE #new_dsn2#.#table_name# SET PRODUCT_ID = #attributes.to_product_id# WHERE STOCK_ID = #attributes.from_stock_id#
					</cfquery>
					<cfcatch></cfcatch>
				</cftry>
				<cftry>
					<cfquery name="upd_product" datasource="#dsn1#">
						UPDATE #new_dsn2#.#table_name# SET PRODUCT_NAME = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
					</cfquery>
					<cfcatch></cfcatch>
				</cftry>
				<cftry>
					<cfquery name="upd_product" datasource="#dsn1#">
						UPDATE #new_dsn2#.#table_name# SET NAME_PRODUCT = '#get_new_category_code.product_name#' WHERE STOCK_ID = #attributes.from_stock_id#
					</cfquery>
					<cfcatch></cfcatch>
				</cftry>
			</cfoutput>
		</cfloop>
        <cfif isdefined("dsn_dev_alias") and len(dsn_dev_alias)>
			<cfquery name="upd_" datasource="#dsn1#">
				UPDATE
					#dsn_dev_alias#.PRICE_TABLE
				SET
					PRODUCT_ID = #attributes.to_product_id#
				WHERE
					STOCK_ID = #attributes.from_stock_id#
			</cfquery>  
			
			<cfquery name="upd_" datasource="#dsn1#">
				UPDATE
					#dsn_dev_alias#.PRODUCT_ACTIONS
				SET
					PRODUCT_ID = #attributes.to_product_id#
				WHERE
					STOCK_ID = #attributes.from_stock_id#
			</cfquery>
			
			<cfquery name="upd_" datasource="#dsn1#">
				UPDATE
					#dsn_dev_alias#.SEARCH_LISTS_POINTS
				SET
					PRODUCT_ID = #attributes.to_product_id#
				WHERE
					STOCK_ID = #attributes.from_stock_id#
			</cfquery>
        </cfif>
        <cfquery name="upd_" datasource="#dsn1#">
        	UPDATE
            	STOCKS
            SET
            	STOCK_CODE = '#new_stock_code#',
                PRODUCT_ID = #attributes.to_product_id#
            WHERE
            	STOCK_ID = #attributes.from_stock_id#
        </cfquery>
        
        <cfquery name="upd_" datasource="#dsn1#">
        	UPDATE
            	PRODUCT
            SET
            	PRODUCT_STATUS = 1
            WHERE
            	PRODUCT_ID = #attributes.to_product_id#
        </cfquery>
        
        <cfquery name="upd_" datasource="#dsn1#">
        	UPDATE
            	PRODUCT
            SET
            	PRODUCT_STATUS = 1
            WHERE
            	PRODUCT_ID = #attributes.to_product_id#
        </cfquery>
        
        <cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
        <cfquery name="upd_ps" datasource="#dsn1#">
        	UPDATE
            	PRICE_STANDART
            SET
            	START_DATE = #bugun_#
            WHERE
            	PRODUCT_ID = #attributes.to_product_id#
        </cfquery>
        
        <cfquery name="get_old_p_stocks" datasource="#dsn1#">
        	SELECT * FROM STOCKS WHERE PRODUCT_ID = #get_old_category_code.PRODUCT_ID# AND STOCK_ID <> #attributes.from_stock_id#
        </cfquery>
        <cfif not get_old_p_stocks.recordcount>
        	<cfquery name="upd_" datasource="#dsn1#">
                UPDATE
                    PRODUCT
                SET
                    PRODUCT_STATUS = 0,
                    PRODUCT_NAME = 'XXX ' + PRODUCT_NAME + ' XXX',
                    PRODUCT_CODE = NULL
                WHERE
                    PRODUCT_ID = #get_old_category_code.PRODUCT_ID#
            </cfquery>
        </cfif>
        <cftry>
        <cfquery name="upd_" datasource="#dsn1#">
        	UPDATE
                STOCKS_BARCODES
            SET
                UNIT_ID = (SELECT TOP 1 PU.PRODUCT_UNIT_ID FROM PRODUCT_UNIT PU,STOCKS S WHERE S.PRODUCT_ID = PU.PRODUCT_ID AND S.STOCK_ID = STOCKS_BARCODES.STOCK_ID AND PU.MULTIPLIER = 1)
        	WHERE
            	STOCK_ID = #attributes.from_stock_id#
        </cfquery>
        <cfquery name="upd2_" datasource="#dsn1#">
            UPDATE
                STOCKS
            SET
                PRODUCT_UNIT_ID = (SELECT TOP 1 PU.PRODUCT_UNIT_ID FROM PRODUCT_UNIT PU,STOCKS S WHERE S.PRODUCT_ID = PU.PRODUCT_ID AND S.STOCK_ID = STOCKS.STOCK_ID AND PU.MULTIPLIER = 1)
        	WHERE
            	STOCK_ID = #attributes.from_stock_id#
        </cfquery>
        <cfcatch type="any"></cfcatch>
        </cftry>
	</cftransaction>
</cflock>