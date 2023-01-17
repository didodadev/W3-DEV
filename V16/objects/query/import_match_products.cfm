<cfset start_time = now()>

<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT INVOICE_ID,SOURCE_SYSTEM,DEPARTMENT_LOCATION,DEPARTMENT_ID FROM FILE_IMPORTS WHERE I_ID = #attributes.i_id#
</cfquery>

<cfquery name="GET_INVOICE" datasource="#DSN2#">
	SELECT INVOICE_ID,INVOICE_DATE FROM INVOICE WHERE INVOICE_ID = #get_import.invoice_id#
</cfquery>

<cfquery name="GET_INVOICE_PROBLEMS" datasource="#DSN2#">
	SELECT
		INVOICE_ROW_ID,
		BRANCH_FIS_NO,
		BRANCH_CON_ID,
		AMOUNT,
		PRICE,
		DISCOUNTTOTAL,
		GROSSTOTAL,
		CREDITCARD_NO,
		ROW_TYPE,
		IS_PROM
	FROM
		INVOICE_ROW_POS_PROBLEM
	WHERE
		INVOICE_ID = #get_import.invoice_id#
</cfquery>

<cfif not isDefined('GET_STOCK_ALL')><!--- surekli cagrilmasin diye kondu --->
	<cfquery name="GET_STOCK_ALL" datasource="#DSN1#">
		SELECT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			SB.BARCODE AS BARCOD,
			PRODUCT.TAX,
			PRODUCT.IS_KARMA,
			PRODUCT_UNIT.MULTIPLIER,
			PRODUCT_UNIT.ADD_UNIT
		FROM
			STOCKS,
			STOCKS_BARCODES SB,
			PRODUCT_UNIT,
			PRODUCT
		WHERE
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			SB.STOCK_ID = STOCKS.STOCK_ID
	</cfquery>
</cfif>

<!--- f_add_invoice_row fonksiyonundaki ROW_TYPE argumanı 0 --> Iade, 1 --> Iptal anlamı tasır 
	  IS_PROM parametresi sadece hediye urunlerde 1,diger durumlarda 0 olmali
--->
<cffunction name="f_add_invoice_row" output="false" returntype="boolean">
	<cfargument name="DB_SOURCE" type="string" default="#dsn2#">
	<cfargument name="ROW_BLOCK" type="numeric" default="500">	
	<cfargument name="STOCK_ID" type="string" required="true">
	<cfargument name="BARCODE" type="string" required="true">
	<cfargument name="PRODUCT_ID" type="string" required="true">
	<cfargument name="INVOICE_ID" type="string" required="true">
	<cfargument name="INVOICE_DATE" type="string" required="true">
	<cfargument name="ROW_TYPE" type="string" required="true">
	<cfargument name="BILL_NO" type="string" required="true">
	<cfargument name="ADD_UNIT" type="string" required="true">
	<cfargument name="AMOUNT" type="string" required="true">
	<cfargument name="PRICE" type="string" required="true">
	<cfargument name="DISCOUNTTOTAL" type="string" required="true">
	<cfargument name="GROSSTOTAL" type="string" required="true">
	<cfargument name="TAXTOTAL" type="string" required="true">
	<cfargument name="NETTOTAL" type="string" required="true">
	<cfargument name="TAX" type="string" required="true">
	<cfargument name="MULTIPLIER" type="string" required="true">
	<cfargument name="CUSTOMER_NO" type="string" required="true">
	<cfargument name="CREDITCARD_NO" type="string" required="true">
	<cfargument name="TERMINAL_TYPE" type="string">
	<cfargument name="IS_PROM" type="string" required="yes">	
	<cfparam name="attributes.is_karma" default="NULL">
	
	<cfquery name="CNT_KARMA_PRODUCT" dbtype="query"><!--- 20041028 bu fonksiyonun cagrildigi yerlerde bu query var --->
		SELECT PRODUCT_ID FROM GET_STOCK_ALL WHERE PRODUCT_ID = #arguments.PRODUCT_ID# AND IS_KARMA = 1
	</cfquery>
	<cfscript>
		if(arguments.row_type is "0" or arguments.row_type is "1") //iade yada iptal ise tutar eksi yazılır
		{
			arguments.amount = (arguments.amount)*(-1);
			arguments.price = (arguments.price)*(-1);
			arguments.discounttotal = (arguments.discounttotal)*(-1);
			arguments.grosstotal = (arguments.grosstotal)*(-1);
			arguments.nettotal = (arguments.nettotal)*(-1);
			arguments.taxtotal = (arguments.taxtotal)*(-1);
		}
		if(not len(arguments.creditcard_no)) arguments.creditcard_no = 'NULL';
		if(not len(arguments.bill_no)) arguments.bill_no = 'NULL';
		if(not len(arguments.customer_no)) arguments.customer_no = 'NULL';
		if(not len(arguments.row_type)) arguments.row_type = 'NULL';
		if(cnt_karma_product.recordcount) karma = 1; else karma = 'NULL';
	</cfscript>
	<cfquery name="ADD_INVOICE_ROW" datasource="#DSN2#">
		INSERT INTO
			INVOICE_ROW_POS
		(
			INVOICE_ID,
			STOCK_ID,
			INVOICE_DATE,
			UNIT,
			AMOUNT,
			PRICE,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			TAXTOTAL,
			MULTIPLIER,
			PRODUCT_ID,
			TAX,
			CREDITCARD_NO,
			BRANCH_FIS_NO,
			BRANCH_CON_ID,
			BARCODE,
			IS_KARMA,
			ROW_TYPE,
			IS_PROM			
		)
		VALUES
		(
			#arguments.invoice_id#,
			#arguments.stock_id#,
			#arguments.invoice_date#,
			'#arguments.add_unit#',
			#arguments.amount#,
			#arguments.price#,
			#arguments.discounttotal#,
			#arguments.grosstotal#,
			#arguments.nettotal#,
			#arguments.taxtotal#,
			#arguments.multiplier#,
			#arguments.product_id#,
			#arguments.tax#,
			'#arguments.creditcard_no#',
			'#arguments.bill_no#',
			'#arguments.customer_no#',
			'#arguments.barcode#',
			#karma#,			
			#arguments.row_type#,
			#arguments.is_prom#
		)
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="f_get_stock" output="false" returntype="query">
	<cfargument name="STOCK_ID" type="string">
	<cfif isdefined("arguments.stock_id") and not isnumeric(arguments.stock_id)>
		<cfset arguments.stock_id = 0>
	</cfif>
		<cfquery name="Q_GET_STOCK" dbtype="query">
			SELECT
				STOCK_ID,
				TAX,
				MULTIPLIER,
				PRODUCT_ID,
				ADD_UNIT,
				BARCOD
			FROM
				GET_STOCK_ALL
			WHERE
				STOCK_ID = #arguments.stock_id#
		</cfquery>
	<cfreturn Q_GET_STOCK>
</cffunction>



<cffunction name="f_del_stock" output="false" returntype="numeric">
	<cfargument name="row_id" type="string" required="true">
		<cfquery name="Q_DEL_PROBLEM_ROW" datasource="#DSN2#">
			DELETE FROM INVOICE_ROW_POS_PROBLEM WHERE INVOICE_ROW_ID = #arguments.row_id#
		</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="f_add_stocks_row" output="false" returntype="numeric">
	<cfargument name="STOCK_ID" type="string" required="true">
	<cfargument name="PRODUCT_ID" type="string" required="true">
	<cfargument name="STORE" type="string" required="true">
	<cfargument name="STORE_LOCATION" type="string" required="true">
	<cfargument name="PROCESS_DATE" type="string" required="true">
	<cfargument name="INVOICE_ID" type="string" required="true">
	<cfargument name="STOCK_IN" type="string" required="true">	
	<cfargument name="STOCK_OUT" type="string" required="true">

	<cfquery name="ADD_STOCKS_ROW" datasource="#DSN2#">
		INSERT INTO
			STOCKS_ROW
		(
			STOCK_ID,
			PRODUCT_ID,			
			STORE,
			STORE_LOCATION,			
			PROCESS_TYPE,			
			STOCK_IN,			
			STOCK_OUT,
			PROCESS_DATE,
			UPD_ID
		)
		VALUES
		(
			#arguments.stock_id#,
			#arguments.product_id#,			
			#arguments.store#,
			#arguments.store_location#,		
			67,			
			#arguments.stock_in#,
			#arguments.stock_out#,
			#CreateOdbcDateTime(arguments.process_date)#,
			#arguments.invoice_id#
		)
	</cfquery>
	<cfreturn 1>
</cffunction>

<cfif not isDefined('GET_KARMA_PRODUCTS')>
	<cfquery name="GET_KARMA_PRODUCTS" datasource="#DSN1#">
		SELECT 
			S.STOCK_ID,
			KP.PRODUCT_ID,
			KP.PRODUCT_AMOUNT,
			KP.KARMA_PRODUCT_ID
		FROM 
			KARMA_PRODUCTS KP,
			PRODUCT P,
			STOCKS S
		WHERE  
			P.PRODUCT_ID = KP.PRODUCT_ID AND 
			S.PRODUCT_ID = KP.PRODUCT_ID AND
			S.STOCK_ID = KP.STOCK_ID
	</cfquery>
</cfif>

<cfscript>
	GROSSTOTAL = 0;
	NETTOTAL = 0;
	TAXTOTAL = 0;
	UPTADED = 0;
</cfscript>
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
	<cfscript>
		for (i=1; i lte line_count;i=i+1)
		{
			if (isdefined("form.stock_id_#i#") and len(evaluate("form.stock_id_#i#")))
			{
				stock_id = evaluate("attributes.stock_id_#i#");
				product_id = evaluate("attributes.product_id_#i#");
				product_name = evaluate("attributes.product_name_#i#");
				get_stock = f_get_stock(STOCK_ID : stock_id);
				tax_row = get_stock.tax;
				nettotal_row = get_invoice_problems.grosstotal[i]/((tax_row+100)/100);
				taxtotal_row = get_invoice_problems.grosstotal[i]-nettotal_row;
				
				UPTADED = UPTADED + 1;
	
				sonuc = f_add_invoice_row(
					STOCK_ID : stock_id,
					PRODUCT_ID : val(product_id),
					BARCODE : get_stock.barcod,
					ADD_UNIT : get_stock.add_unit,
					MULTIPLIER : get_stock.multiplier,
					INVOICE_ID : get_invoice.invoice_id,
					INVOICE_DATE : CreateOdbcDate(get_invoice.invoice_date),
					BILL_NO : get_invoice_problems.branch_fis_no[i],
					AMOUNT : get_invoice_problems.amount[i],						
					PRICE : get_invoice_problems.price[i],
					DISCOUNTTOTAL : get_invoice_problems.discounttotal[i],
					GROSSTOTAL : get_invoice_problems.grosstotal[i],
					TAXTOTAL : taxtotal_row,
					NETTOTAL : nettotal_row,
					TAX : tax_row,
					CUSTOMER_NO : get_invoice_problems.branch_con_id[i],
					CREDITCARD_NO : get_invoice_problems.creditcard_no[i],
					TERMINAL_TYPE : get_import.source_system,
					ROW_TYPE : get_invoice_problems.row_type[i],
					IS_PROM : get_invoice_problems.is_prom[i]
				);
			
				GET_KARMA_PRODUCT = cfquery(datasource : "yok",dbtype="query", sqlstring : "SELECT  STOCK_ID, PRODUCT_ID, PRODUCT_AMOUNT FROM GET_KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #product_id#");										
			
				if(get_karma_product.recordcount)
				{
					if(isdefined("get_import.department_location") and len(get_import.department_location))
						attributes.karma_department_location = get_import.department_location;
					else
						attributes.karma_department_location = "NULL";
					
					for(i=1; i lte get_karma_product.recordcount;i=i+1)
					{							
						
						if(get_invoice_problems.row_type[i] eq 'NULL')
						{						
							stock_out_row = 0;
							stock_in_row = get_invoice_problems.amount[i]*get_karma_product.product_amount[i];
						}
						else
						{
							stock_out_row = get_invoice_problems.amount[i]*get_karma_product.product_amount[i];
							stock_in_row = 0;
						}
						
						//dsn2 : stocks_row işlemler eklenir
						sonuc = f_add_stocks_row(
							STOCK_ID : get_karma_product.stock_id[i],
							PRODUCT_ID : get_karma_product.product_id[i],
							STORE : get_import.department_id,
							STORE_LOCATION : get_import.department_location,
							PROCESS_DATE : get_invoice.invoice_date,
							INVOICE_ID : get_import.invoice_id,						
							STOCK_OUT : stock_out_row,
							STOCK_IN : stock_in_row
						);
					}				
				}
				else
				{
					if(get_invoice_problems.row_type[i] eq 'NULL')
					{						
						stock_out_row = 0;
						stock_in_row = get_invoice_problems.amount[i];
					}
					else
					{
						stock_out_row = get_invoice_problems.amount[i];
						stock_in_row = 0;						
					}
				
					//dsn2 : stocks_row işlemler eklenir
					sonuc = f_add_stocks_row(
						STOCK_ID : stock_id,
						PRODUCT_ID : product_id,
						STORE : get_import.department_id,
						STORE_LOCATION : get_import.department_location,
						PROCESS_DATE : get_invoice.invoice_date,
						INVOICE_ID : get_import.invoice_id,
						STOCK_OUT :stock_out_row,
						STOCK_IN : stock_in_row
					);		
				}			
						
				// kurtarılan satır silinir
				sonuc = f_del_stock(row_id : get_invoice_problems.invoice_row_id[i]);
				
				// satır_1 toplamlarından son toplama git
				if(not len(get_invoice_problems.row_type[i]))
				{
					GROSSTOTAL = GROSSTOTAL + get_invoice_problems.grosstotal[i];
					NETTOTAL = NETTOTAL + nettotal_row;
					TAXTOTAL = TAXTOTAL + taxtotal_row;
				}
				else
				{
					GROSSTOTAL = GROSSTOTAL - get_invoice_problems.grosstotal[i];
					NETTOTAL = NETTOTAL - nettotal_row;
					TAXTOTAL = TAXTOTAL - taxtotal_row;				
				}
			}
			else
			{		
				writeoutput("<br/><br/>Satır Boş !<br/>Satır : #i#<br/><br/><hr>");
			}
		}
	</cfscript>
	<!--- Genius disindaki invoice toplamları guncellenir --->
	<cfif get_import.source_system neq -1>
		<cfquery name="UPD_INVOICE" datasource="#DSN2#">
			UPDATE 
				INVOICE
			SET
				GROSSTOTAL = GROSSTOTAL + #GROSSTOTAL#,
				NETTOTAL = NETTOTAL + #NETTOTAL#,
				TAXTOTAL = TAXTOTAL + #TAXTOTAL#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#			
			WHERE
				INVOICE_ID = #get_invoice.invoice_id#
		</cfquery>
	</cfif>
	
	<!--- dosya güncellenir --->
	<cfquery name="UPD_FILE" datasource="#DSN2#">
		UPDATE
			FILE_IMPORTS
		SET
			PROBLEMS_COUNT = PROBLEMS_COUNT - #UPTADED#,
			PRODUCT_COUNT = PRODUCT_COUNT + #UPTADED#
		WHERE
			I_ID = #attributes.i_id#
	</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
</script>

<cfoutput>
<hr>
	Hatalı Satır Sayısı : #line_count#<br/>
	Import Edilen Satır sayısı : #uptaded#<br/>
	Toplam Süre : #timeformat(now()-start_time,'mm:ss')#<br/>
<hr>
</cfoutput>
