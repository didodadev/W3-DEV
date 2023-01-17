<!--- 
STOCKS_ROW dan toplamları alırken, sayım tarihinin sonuna kadarki kayıtlar alınır,oyüzden process_date +1 den küçük kayıtlara bakılır,
çünkü sayım bir gün sonu işlemidir AE20060104
sayım sıfırlanırken o depodaki sayımlarda gecen ürünlerin tüm spec raf ve son kullanma tarihli stoklarıda sıfırlanacaktır TolgaS20071223
 --->
<cf_date tarih = "attributes.process_date">
<cfquery name="get_stock" datasource="#dsn2#">
	SELECT 
		ISNULL(SUM(STOCK_IN - STOCK_OUT),0) TOTAL_STOCK,
		STOCK_ID,
		PRODUCT_ID,
		STORE,
		STORE_LOCATION,
		SPECT_VAR_ID,
		SHELF_NUMBER,
		DELIVER_DATE
	FROM 
		STOCKS_ROW
	WHERE 
		PROCESS_DATE < #DATEADD("d",1,attributes.process_date)#
		AND STORE = #attributes.store#
		AND STORE_LOCATION = #attributes.location_id#
		AND (CAST(STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SPECT_VAR_ID,0) AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SHELF_NUMBER,0) AS NVARCHAR(50))) NOT IN 
		(SELECT 
			(CAST(FILE_IMPORTS_TOTAL.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(FILE_IMPORTS_TOTAL.SPECT_MAIN_ID,0) AS NVARCHAR(50)) +'_'+ CAST(ISNULL(FILE_IMPORTS_TOTAL.SHELF_NUMBER,0) AS NVARCHAR(50)))
		FROM 
			FILE_IMPORTS_TOTAL,
			FILE_IMPORTS_TOTAL_SAYIMLAR
		WHERE
			FILE_IMPORTS_TOTAL.DEPARTMENT_ID = FILE_IMPORTS_TOTAL_SAYIMLAR.DEPARTMENT_ID
			AND FILE_IMPORTS_TOTAL.PROCESS_DATE =  FILE_IMPORTS_TOTAL_SAYIMLAR.PROCESS_DATE
			AND FILE_IMPORTS_TOTAL.DEPARTMENT_LOCATION = FILE_IMPORTS_TOTAL_SAYIMLAR.DEPARTMENT_LOCATION
			AND FILE_IMPORTS_TOTAL_SAYIMLAR.PROCESS_DATE = #attributes.process_date#
			AND FILE_IMPORTS_TOTAL_SAYIMLAR.DEPARTMENT_ID = #attributes.store#
			AND FILE_IMPORTS_TOTAL_SAYIMLAR.DEPARTMENT_LOCATION = #attributes.location_id#
			AND FILE_IMPORTS_TOTAL_SAYIMLAR.FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.file_imports_total_sayim_id#
		)
	GROUP BY 
		STOCK_ID,
		PRODUCT_ID,
		STORE,
		STORE_LOCATION,
		SPECT_VAR_ID,
		SHELF_NUMBER,
		DELIVER_DATE
</cfquery>
<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
	<cfoutput query="get_stock">
		<cfif TOTAL_STOCK neq 0>
			<cfquery name="add_stock" datasource="#dsn2#">
				INSERT INTO 
					STOCKS_ROW
					(
						UPD_ID,
						STOCK_ID,
						PRODUCT_ID,
						PROCESS_TYPE,
						<cfif TOTAL_STOCK gt 0>STOCK_OUT,<cfelse>STOCK_IN,</cfif>
						STORE,
						STORE_LOCATION,
						PROCESS_DATE,
						SPECT_VAR_ID,
						SHELF_NUMBER,
						DELIVER_DATE
					)
					VALUES
					(
						#attributes.file_imports_total_sayim_id#,
						#STOCK_ID#,
						#PRODUCT_ID#,				
						117,				
						#abs(TOTAL_STOCK)#,				
						#STORE#,
						#STORE_LOCATION#,
						#attributes.process_date#,
						<cfif len(SPECT_VAR_ID)>#SPECT_VAR_ID#<cfelse>NULL</cfif>,
						<cfif len(SHELF_NUMBER)>#SHELF_NUMBER#<cfelse>NULL</cfif>,
						<cfif len(DELIVER_DATE)>#createodbcdatetime(DELIVER_DATE)#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	</cfoutput>
	<cfquery name="sayim_sifirla" datasource="#dsn2#">
		UPDATE 
			FILE_IMPORTS_TOTAL_SAYIMLAR 
		SET 
			IS_INITIALIZED = 1,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#
		WHERE 
			FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.file_imports_total_sayim_id#
	</cfquery>
</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
