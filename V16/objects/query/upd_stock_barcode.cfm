<cfset FORM.BARCODE=TRIM(FORM.BARCODE)>
<cfquery name="CHECK_CODE" datasource="#dsn1#">
	SELECT 
		STOCK_ID
	FROM 
		GET_STOCK_BARCODES_ALL
	WHERE 
		STOCK_ID <> #FORM.STOCK_ID# AND
		BARCODE = '#FORM.BARCODE#'
</cfquery>
<cfif check_code.recordcount and attributes.is_barcode_control eq 0>
	<script type="text/javascript">
		alert('Girdiğiniz Barkod Başka Bir Stok Tarafından Kullanılmakta\r Lütfen Başka Bir Barkod Giriniz !');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<!--- eklemede urun ana barcod veya stok barcode kontrol edildigi icin guncellemede olmama ihtimali yok diye eklenmedi ancak sorun oldugu taktirde eklenmeli --->
	<cfquery name="UPD_STOCK_BARCODES" datasource="#DSN1#">
		UPDATE 
			STOCKS_BARCODES
		SET
			STOCK_ID = #FORM.STOCK_ID#,
			BARCODE = '#FORM.BARCODE#',
			UNIT_ID = #ATTRIBUTES.UNIT_ID#
		WHERE 
			STOCK_ID = #FORM.STOCK_ID# AND
			BARCODE = '#FORM.OLD_BARCODE#'
	</cfquery>

	<cfquery name="UPD_STOCK_CODE" datasource="#DSN1#">
		UPDATE 
			STOCKS 
		SET
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#REMOTE_ADDR#',
			UPDATE_DATE =  #now()# 
		WHERE 
			STOCK_ID = #FORM.STOCK_ID#
	</cfquery>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
<!--- <cflocation addtoken="no" url="#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#FORM.STOCK_ID#&is_terazi=#attributes.is_terazi#"> --->
