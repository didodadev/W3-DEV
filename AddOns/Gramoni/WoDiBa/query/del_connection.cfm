<!---
    File: del_connection.cfm
	Folder: AddOns\Gramoni\WoDiBa\query
    Author: Mahmut Çifçi <mahmut.cifci@gramoni.com>
    Date: 30.06.2021
    Description:
        WoDiBa banka işlemleri sayfasında kaynak belge silinmiş olan kayıtların bağlantısını siler
--->

<cfquery name="get_action" datasource="#dsn#">
    SELECT PERIOD_ID FROM WODIBA_BANK_ACTIONS WHERE WDB_ACTION_ID = #attributes.id#
</cfquery>

<cfif get_action.recordCount And get_action.PERIOD_ID Eq session.ep.period_id>
    <cfquery datasource="#dsn#">
		UPDATE WODIBA_BANK_ACTIONS SET BANK_ACTION_ID = NULL, DOCUMENT_ID = NULL WHERE WDB_ACTION_ID = #attributes.id#
	</cfquery>
	<script type="text/javascript">
		window.opener.location.reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45701.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.reload();
		window.close();
	</script>
</cfif>