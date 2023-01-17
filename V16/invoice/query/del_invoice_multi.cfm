<cfquery name="GET_NUMBER" datasource="#dsn2#"><!--- query ve değişkenler böyle kalacak çünkü faturalarla ortak sayfalar kullanılyor --->
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,WRK_ID,INVOICE_CAT,PROCESS_CAT,UPD_STATUS,(SELECT IM.IS_FROM_REPORT FROM INVOICE_MULTI IM WHERE IM.INVOICE_MULTI_ID=INVOICE.INVOICE_MULTI_ID) AS IS_FROM_REPORT FROM INVOICE WHERE INVOICE_MULTI_ID = #attributes.invoice_multi_id# ORDER BY UPD_STATUS<!---silme kontrolu için eklendi --->
</cfquery>
<cfset xml_import = 1><!--- fatura silme sayfası ortak kullanıldgı için bu değişkene gerek oldu --->
<cfif GET_NUMBER.UPD_STATUS eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='386.Muhasebe Fiş Birleştirme İşlemi Yapıldığı İçin Faturaları Silemezsiniz!'>");
		window.close();
	</script>
	<cfabort>
<cfelse>
	<cftransaction isolation="repeatable_read" action="begin">
		<cftry>
			<cfoutput query="GET_NUMBER">
				<cfset form.invoice_id = GET_NUMBER.INVOICE_ID>
				<cfset form.old_process_type = GET_NUMBER.INVOICE_CAT>
				<cfset form.process_cat = GET_NUMBER.PROCESS_CAT>
				<cfif IS_FROM_REPORT neq 1><!--- rapordan gelirse, faturalar silinmesin --->
					<cfinclude template="upd_invoice_8.cfm">
				</cfif>
			</cfoutput>
			<cfquery name="del_invoice_multi" datasource="#dsn2#"><!--- ilişkili faturaların silmesi tamamlanırsa enson bağlantı kopsun diye ensonda. --->
				DELETE FROM INVOICE_MULTI WHERE INVOICE_MULTI_ID = #attributes.invoice_multi_id#
			</cfquery>
			<cfquery name="upd_invoice_multi_id" datasource="#dsn2#"><!--- ilişkili faturaların silmesi tamamlanırsa enson bağlantı kopsun diye ensonda. --->
				UPDATE INVOICE SET INVOICE_MULTI_ID = NULL WHERE INVOICE_MULTI_ID = #attributes.invoice_multi_id#
			</cfquery>
			<cf_add_log  log_type="-1" action_id="#attributes.invoice_multi_id#" action_name="#get_number.invoice_number# Silindi" paper_no="#get_number.invoice_number#" process_type = "#GET_NUMBER.INVOICE_CAT#" process_stage="#get_number.process_cat#" data_source="#dsn2#">
			<cfcatch type="database">
				<cftransaction action="rollback">
			</cfcatch>
		</cftry>
	</cftransaction>
	<script type="text/javascript">
		alert("Silme İşleminiz Tamamlanmıştır!");
		window.close();
		wrk_opener_reload();
	</script>
</cfif>
