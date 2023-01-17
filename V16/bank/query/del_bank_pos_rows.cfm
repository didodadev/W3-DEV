<cfif isDefined("attributes.i_id")><!--- belge import işlemini geri alma, o belgenin satırlarını siler --->
	<cfquery name="GET_IMPORT_INFO" datasource="#DSN3#"><!--- kayıtlı bir tahsilat kaydı varmı kontrolu --->
		SELECT FILE_IMPORT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE FILE_IMPORT_ID = #attributes.i_id# AND ACTION_PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfif GET_IMPORT_INFO.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='410.Bu Belge İçin Kredi Kartı Tahsilat Kaydı Vardır'>!");
			wrk_opener_reload();
			window.close();
		</script>
		<cfabort>
	<cfelse>
		<cflock name="#createUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="DEL_BANK_POS_ROWS" datasource="#dsn2#">
					DELETE FROM FILE_IMPORT_BANK_POS_ROWS WHERE FILE_IMPORT_ID = #attributes.i_id#
				</cfquery>
				<cfquery name="DEL_BANK_POS_ROWS" datasource="#dsn2#">
					UPDATE FILE_IMPORTS SET IMPORTED = 0 WHERE I_ID = #attributes.i_id#
				</cfquery>				
			</cftransaction>
		</cflock>
	</cfif>
<cfelse><!--- belge satırlarının listelendiği yerde tekli satır silme --->
	<cflock name="#createUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="DEL_BANK_POS_ROWS" datasource="#dsn2#">
				DELETE FROM FILE_IMPORT_BANK_POS_ROWS WHERE FILE_IMPORT_BANK_POS_ROW_ID = #attributes.f_row_id#
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
