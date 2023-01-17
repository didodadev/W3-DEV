<!--- toplu provizyon için oluşturulmuş olan dosyayı açma sayfasıdır, formda gelen şifreye göre kodu açar
Şifre bilinmiyosa dosya açılamaz! Ayşenur 20060605
-otomatik ödeme için de kullanılıyor artık
şifreleme parametresi xml den seçilmemişse, şifresiz direkt açar--->
<cf_xml_page_edit fuseact ="bank.popup_open_multi_prov_file">
<cfsetting showdebugoutput="no">
<cfif isDefined("is_import")><!--- importlar --->
	<cfquery name="GET_FILE" datasource="#DSN2#">
		SELECT FILE_NAME,FILE_CONTENT FROM FILE_IMPORTS WHERE I_ID = #attributes.export_import_id#
	</cfquery>
<cfelse><!--- exportlar --->
	<cfquery name="GET_FILE" datasource="#DSN2#">
		SELECT FILE_NAME,FILE_CONTENT FROM FILE_EXPORTS WHERE E_ID = #attributes.export_import_id#
	</cfquery>
</cfif>
<cfif len(get_file.file_content)>
	<cfif attributes.is_encrypt_file eq 1 and isdefined('attributes.key_type') and len(attributes.key_type)>
		<cfset file_content = Decrypt(get_file.file_content,attributes.key_type,"CFMX_COMPAT","Hex")>
	<cfelse>
		<cfset file_content = get_file.file_content>
	</cfif>
	<cfloop from="127" to="400" index="chr_1">
		<cfset file_content = replace(file_content,'&###chr_1#;','#chr(chr_1)#','all')>
	</cfloop>
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="text/vnd.plain;charset=iso-8859-9">
	<cfheader name="Content-Disposition" value="attachment; filename=#get_file.file_name#">
	<cfoutput>#file_content#</cfoutput>
	<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='389.Şifrenizi Kontrol Ediniz'>!");
			<cfif  isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
	</script>
	<cfabort>
</cfif>

