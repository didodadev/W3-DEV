<cf_date tarih = "attributes.start_date">
<cfquery name="get_file_amount" datasource="#DSN2#">
	SELECT 
		SUM(FIR.AMOUNT) SAYIM_TOPLAM,
		FIR.STOCK_ID,
		FIR.PRODUCT_ID,
		FIR.SPECT_MAIN_ID,
		FIR.SHELF_NUMBER,
		FIR.DELIVER_DATE,
        FIR.LOT_NO,
		FI.DEPARTMENT_ID,
		FI.DEPARTMENT_LOCATION,
		FI.STARTDATE
	FROM 
		FILE_IMPORTS FI,
		FILE_IMPORTS_ROW FIR
	WHERE 
		FI.I_ID = FIR.FILE_IMPORT_ID AND
		FI.DEPARTMENT_ID = #attributes.department_id# AND
		FI.DEPARTMENT_LOCATION = #attributes.location_id# AND
		FI.STARTDATE =  #attributes.start_date#
	GROUP BY 
		FIR.STOCK_ID,
		FIR.PRODUCT_ID,
		FIR.SPECT_MAIN_ID,
		FIR.SHELF_NUMBER,
		FIR.DELIVER_DATE,
        FIR.LOT_NO,
		FI.DEPARTMENT_ID,
		FI.DEPARTMENT_LOCATION,
		FI.STARTDATE
</cfquery>
<cfif not get_file_amount.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='122.Bu tarih ve depoda henuz bir sayım yapılmamıştır'>!");
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
		PROCESS_DATE =  #attributes.start_date#
</cfquery>
<cfif kontrol_file_import_total.recordcount> 
	<script type="text/javascript">
		alert("<cf_get_lang no ='123.Bu tarih ve depoda daha önce sayımlar birleştirilmiştir'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- 
STOCKS_ROW dan toplamları alırken, sayım tarihinin sonuna kadarki kayıtlar alınır,oyüzden startdate +1 den küçük kayıtlara bakılır,
çünkü sayım bir gün sonu işlemidir AE20060104
 ---> 
<cfif not kontrol_file_import_total.recordcount> 
	<cfquery name="get_stock_amount" datasource="#DSN2#">
		SELECT 
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.STOCK_IN,
            SR.LOT_NO,
			SR.STOCK_OUT,
			SR.SPECT_VAR_ID,
			SR.SHELF_NUMBER
		FROM 
			STOCKS_ROW SR
		WHERE
			SR.STOCK_ID IN (SELECT DISTINCT FIR.STOCK_ID FROM FILE_IMPORTS FI,FILE_IMPORTS_ROW FIR WHERE FI.I_ID = FIR.FILE_IMPORT_ID AND FI.DEPARTMENT_ID = #attributes.department_id# AND FI.STARTDATE =  #attributes.start_date#)
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
                <cfif len(LOT_NO)>
                    AND LOT_NO='#LOT_NO#'
				<cfelse><!--- sayım işlemi aynı üründe hem lot numaralı hem de lot numarası olmadan aktarıldığında stok miktarları karışığı --->
					AND LOT_NO IS NULL
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
                    LOT_NO,
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
                    <cfif len(LOT_NO)>'#LOT_NO#'<cfelse>NULL</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery> 
	</cfoutput> 
	<cfquery name="kontrol_sayim_belgeleri" datasource="#dsn2#">
		UPDATE 
			FILE_IMPORTS  
		SET 
			IMPORTED=1 
		WHERE 
			DEPARTMENT_ID = #attributes.department_id# AND
			DEPARTMENT_LOCATION = #attributes.location_id# AND
			STARTDATE =  #attributes.start_date# AND
			PROCESS_TYPE = -5
	</cfquery>
	<cfquery name="add_sayim" datasource="#dsn2#">
		INSERT INTO
			FILE_IMPORTS_TOTAL_SAYIMLAR
			(
				DEPARTMENT_ID,
				DEPARTMENT_LOCATION,
				PROCESS_DATE,
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
				0,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
			)
	</cfquery>
	</cftransaction>
 </cfif> 
<script type="text/javascript">
	alert("<cf_get_lang no ='124.Dosyalar Birleştirildi'>!");
	window.close();
</script>
