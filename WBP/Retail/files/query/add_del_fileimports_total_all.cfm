<cf_date tarih = "attributes.start_date">
<cfquery name="get_file_amount" datasource="#DSN2#">
	SELECT 
		SUM(FIR.FILE_AMOUNT) SAYIM_TOPLAM,
		FIR.STOCK_ID,
		FIR.PRODUCT_ID,
		FIR.SPECT_MAIN_ID,
		FIR.SHELF_NUMBER,
		FIR.DELIVER_DATE,
		FIR.DEPARTMENT_ID,
		FIR.DEPARTMENT_LOCATION,
		FIR.PROCESS_DATE STARTDATE
	FROM 
		FILE_IMPORTS_TOTAL FIR
	WHERE 
		FIR.DEPARTMENT_ID = #attributes.department_id# AND
		FIR.DEPARTMENT_LOCATION = #attributes.location_id# AND
		FIR.PROCESS_DATE =  #attributes.start_date# AND
		FIR.FILE_TYPE = 3 AND
		ISNULL(FIR.IS_ALL,0)=0
		<cfif len(attributes.product_catid)>
			AND FIR.PRODUCT_CATID = #attributes.product_catid#
		<cfelse>
			AND FIR.PRODUCT_CATID IS NULL
		</cfif>
	GROUP BY 
		FIR.STOCK_ID,
		FIR.PRODUCT_ID,
		FIR.SPECT_MAIN_ID,
		FIR.SHELF_NUMBER,
		FIR.DELIVER_DATE,
		FIR.DEPARTMENT_ID,
		FIR.DEPARTMENT_LOCATION,
		FIR.PROCESS_DATE
	UNION ALL
	SELECT
		SUM(FILE_AMOUNT) FILE_AMOUNT,
		STOCK_ID,
		PRODUCT_ID,
		SPECT_MAIN_ID,
		SHELF_NUMBER,
		DELIVER_DATE,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		STARTDATE
	FROM
	(
		SELECT DISTINCT
			FIR.FILE_AMOUNT,
			FIR.STOCK_ID,
			FIR.PRODUCT_ID,
			FIR.SPECT_MAIN_ID,
			FIR.SHELF_NUMBER,
			FIR.DELIVER_DATE,
			FIR.DEPARTMENT_ID,
			FIR.DEPARTMENT_LOCATION,
			FIR.PROCESS_DATE STARTDATE
		FROM 
			FILE_IMPORTS_TOTAL FIR
		WHERE 
			FIR.DEPARTMENT_ID = #attributes.department_id# AND
			FIR.DEPARTMENT_LOCATION = #attributes.location_id# AND
			FIR.PROCESS_DATE =  #attributes.start_date# AND
			FIR.FILE_TYPE IN(1,2) AND
			FIR.STOCK_ID NOT IN(
									SELECT 
										FIR_.STOCK_ID
									FROM 
										FILE_IMPORTS_TOTAL FIR_
									WHERE 
										FIR_.DEPARTMENT_ID = #attributes.department_id# AND
										FIR_.DEPARTMENT_LOCATION = #attributes.location_id# AND
										FIR_.PROCESS_DATE =  #attributes.start_date# AND
										FIR_.FILE_TYPE = 3
										<cfif len(attributes.product_catid)>
											AND FIR_.PRODUCT_CATID = #attributes.product_catid#
										</cfif>
								) AND
			ISNULL(FIR.IS_ALL,0)=0
			<cfif len(attributes.product_catid)>
				AND FIR.PRODUCT_CATID = #attributes.product_catid#
			<cfelse>
				AND FIR.PRODUCT_CATID IS NULL
			</cfif>
	)T1
	GROUP BY
		STOCK_ID,
		PRODUCT_ID,
		SPECT_MAIN_ID,
		SHELF_NUMBER,
		DELIVER_DATE,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		STARTDATE
</cfquery>
<cfif not get_file_amount.recordcount>
	<script type="text/javascript">
		alert("Bu tarih ve depoda henuz bir sayım yapılmamıştır!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="kontrol_file_import_total" datasource="#dsn2#">
	SELECT
		PRODUCT_ID
	FROM 
		FILE_IMPORTS_TOTAL
	WHERE
		DEPARTMENT_ID = #attributes.department_id# AND
		DEPARTMENT_LOCATION = #attributes.location_id# AND
		PROCESS_DATE =  #attributes.start_date# AND
		ISNULL(IS_ALL,0)=1
		<cfif len(attributes.product_catid)>
			AND PRODUCT_CATID = #attributes.product_catid#
		</cfif>
</cfquery>
<cfif kontrol_file_import_total.recordcount> 
	<script type="text/javascript">
		alert("Bu tarih,kategori ve depoda daha önce sayımlar birleştirilmiştir");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif not kontrol_file_import_total.recordcount> 
	<cfquery name="get_stock_amount" datasource="#DSN2#">
		SELECT 
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.STOCK_IN,
			SR.STOCK_OUT,
			SR.SPECT_VAR_ID,
			SR.SHELF_NUMBER
		FROM 
			STOCKS_ROW SR
		WHERE 
			SR.STOCK_ID IN (SELECT DISTINCT FIR.STOCK_ID FROM FILE_IMPORTS_TOTAL FIR WHERE FIR.DEPARTMENT_ID = #attributes.department_id# AND FIR.PROCESS_DATE =  #attributes.start_date#)
			AND SR.STORE = #attributes.department_id#
			AND SR.STORE_LOCATION = #attributes.location_id#
			AND SR.PROCESS_DATE < #DATEADD("d",1,attributes.start_date)#
	</cfquery>
	<cftransaction>
	<cfoutput query="get_file_amount">
		<cfquery name="stock_amount" dbtype="query">
			SELECT 
				SUM(STOCK_IN - STOCK_OUT) STOCK_TOPLAM 
			FROM 
				get_stock_amount 
			WHERE 
				STOCK_ID = #STOCK_ID# 
				<cfif len(SPECT_MAIN_ID)>
				AND	SPECT_VAR_ID = #SPECT_MAIN_ID#
				</cfif>
				<cfif len(SHELF_NUMBER)>
				AND SHELF_NUMBER=#SHELF_NUMBER#
				</cfif>
		</cfquery>
		<cfif not len(stock_amount.STOCK_TOPLAM)>
			<cfset miktar = 0 >
		<cfelse>
			<cfset miktar = stock_amount.STOCK_TOPLAM>
		</cfif>
		 <cfquery name="add_file_import_total" datasource="#DSN2#">
			INSERT INTO 
				FILE_IMPORTS_TOTAL
				(
					DEPARTMENT_ID,
					DEPARTMENT_LOCATION,
					PROCESS_DATE,
					STOCK_AMOUNT,
					FILE_AMOUNT,
					STOCK_ID,
					PRODUCT_ID,
					SPECT_MAIN_ID,
					SHELF_NUMBER,
					DELIVER_DATE,
					PRODUCT_CATID,
					IS_ALL,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
			VALUES
				(
					#DEPARTMENT_ID#,
					#DEPARTMENT_LOCATION#,
					#attributes.start_date#,
					#miktar#,
					#SAYIM_TOPLAM#,
					#STOCK_ID#,
					#PRODUCT_ID#,
					<cfif len(SPECT_MAIN_ID)>#SPECT_MAIN_ID#<cfelse>NULL</cfif>,
					<cfif len(SHELF_NUMBER)>#SHELF_NUMBER#<cfelse>NULL</cfif>,
					<cfif len(DELIVER_DATE)>#createodbcdatetime(DELIVER_DATE)#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>'#attributes.product_catid#'<cfelse>NULL</cfif>,
                    1,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery> 
	</cfoutput> 
	<cfquery name="add_sayim" datasource="#dsn2#">
		INSERT INTO
			FILE_IMPORTS_TOTAL_SAYIMLAR
			(
				DEPARTMENT_ID,
				DEPARTMENT_LOCATION,
				PROCESS_DATE,
				PRODUCT_CATID,
				IS_ALL,
				IS_INITIALIZED,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
		VALUES
			(
				#attributes.department_id#,
				#attributes.location_id#,
				#attributes.start_date#,
				<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>'#attributes.product_catid#'<cfelse>NULL</cfif>,
				1,
				0,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
			)
	</cfquery>
	</cftransaction>
 </cfif> 
<script type="text/javascript">
	alert("Dosyalar Birleştirildi!");
	window.close();
</script>