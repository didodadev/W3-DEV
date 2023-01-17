<cfset FORM.BARCODE=TRIM(FORM.BARCODE)>
<cfquery name="CHECK_CODE" datasource="#DSN1#">
	SELECT 
		STOCK_ID
	FROM 
		GET_STOCK_BARCODES_ALL
	WHERE 
		BARCODE='#FORM.BARCODE#'
</cfquery>
<cfif check_code.recordcount and attributes.is_barcode_control eq 0>
	<script type="text/javascript">
		alert("Girdiğiniz Barkod Başka Bir Stok Tarafından Kullanılmakta Lütfen Başka Bir Barkod Giriniz!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="GET_PROD_BARCOD" datasource="#DSN3#">
		SELECT PRODUCT_ID,BARCOD FROM STOCKS WHERE STOCK_ID=#FORM.STOCK_ID#
	</cfquery><!--- product main barcode yoksa oncelikli olarak yazılan barcode ona atanır tabi barcod girilen stok ana stoksa--->
	<cfif not len(GET_PROD_BARCOD.BARCOD)>
		<cfquery name="GET_PROD_BARCOD_STOCK" datasource="#DSN3#">
			SELECT MIN(STOCK_ID) MIN_STOCK_ID FROM STOCKS WHERE PRODUCT_ID=#GET_PROD_BARCOD.PRODUCT_ID#
		</cfquery><!--- product id ile tum stok idleri alınıyor en ufak olan formdan gelene esitse bu stok ana cesittir ve product tablosundada barcode yazılır --->
		<cfif GET_PROD_BARCOD_STOCK.MIN_STOCK_ID eq FORM.STOCK_ID>
			<cfquery name="UPD_PRODUCT" datasource="#DSN1#">
				UPDATE PRODUCT SET 
					BARCOD= '#FORM.BARCODE#',
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = '#REMOTE_ADDR#',
					UPDATE_DATE =  #now()#
				WHERE
					PRODUCT_ID = #GET_PROD_BARCOD.PRODUCT_ID#
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="GET_STOCK_BARCOD" datasource="#DSN3#">
		SELECT BARCOD FROM STOCKS WHERE STOCK_ID=#FORM.STOCK_ID#
	</cfquery><!--- stokda barcode yoksa onada yazar --->
	<cfquery name="UPD_STOCK_CODE" datasource="#DSN1#">
		UPDATE 
			STOCKS 
		SET 
			<cfif not len(GET_STOCK_BARCOD.BARCOD)>BARCOD = '#FORM.BARCODE#',</cfif>
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#REMOTE_ADDR#',
			UPDATE_DATE =  #now()# 
		WHERE 
			STOCK_ID = #FORM.STOCK_ID#
	</cfquery>

	<cfquery name="GET_BARCODE_NULL" datasource="#DSN1#">
		SELECT STOCK_ID,UNIT_ID FROM STOCKS_BARCODES WHERE STOCK_ID=#FORM.STOCK_ID# AND BARCODE=''
	</cfquery>
	<cfif GET_BARCODE_NULL.RECORDCOUNT>
		<cfquery name="UPD_STOCK_BARCODES" datasource="#DSN1#">
			UPDATE 
				STOCKS_BARCODES
			SET
				STOCK_ID=#FORM.STOCK_ID#,
				BARCODE='#FORM.BARCODE#',
				UNIT_ID=#ATTRIBUTES.UNIT_ID#
			WHERE 
				STOCK_ID=#FORM.STOCK_ID# AND
				BARCODE='' AND
				UNIT_ID=#GET_BARCODE_NULL.UNIT_ID#
		</cfquery>
	<cfelse>
		<cfquery name="ADD_STOCK_CODE" datasource="#DSN1#">
			INSERT INTO 
				STOCKS_BARCODES
			(
				STOCK_ID,
				BARCODE,
				UNIT_ID
			)
			VALUES 
			(
				#FORM.STOCK_ID#,
				'#FORM.BARCODE#',
				#ATTRIBUTES.UNIT_ID#
			)
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>


