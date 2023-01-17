<cfquery name="DOSYA" datasource="#dsn3#">
	SELECT ICON,ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID=#ICON_ID#
</cfquery>

<cftry>
	<cf_del_server_file output_file="sales/#DOSYA.ICON#" output_server="#DOSYA.ICON_SERVER_ID#">
	<CFCATCH TYPE="ANY">
		<script type="text/javascript">
			alert("<cf_get_lang no='637.Dosya Klasörde Bulunamadı Ama Veritabanından Silindi !'>");
		</script>
	</CFCATCH>  
</cftry>

<cfquery name="DELICON" datasource="#dsn3#">
	DELETE FROM SETUP_PROMO_ICON WHERE ICON_ID=#ICON_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_icon" addtoken="no">
