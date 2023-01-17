<!--- Çek ve Senet tanımlamaları kaldırıldı. Banka hesapları ve kasa tanımlamarı altına taşındı. --->
<!--- <cfquery name="get_cheque_acc" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		SETUP_CHEQUES
</cfquery>
<cfif not get_cheque_acc.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='14.Çek Tanımlarınızı Yapmadan Hiçbir İşlem Çek İşlemi Yapamazsiniz !'>");
		history.back();
	</script>
	<cfabort>
</cfif> --->
<cfif session.ep.period_is_integrated>
	<cfquery name="kontrol" datasource="#DSN2#">
		SELECT
			*
		FROM
			BILLS
	</cfquery>
	<cfif not kontrol.recordcount>
		<font color="##FF0000">
			<cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'>
		</font>
		<cfabort>
	</cfif>
</cfif>
