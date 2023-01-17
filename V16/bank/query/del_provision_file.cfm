<!--- toplu provizyon + otomatik ödeme işlemi silme sayfasıdır,sadece db dekini siler cunku artık documents da tutulmuyor --->
<cfquery name="CONTROL_IMPORT" datasource="#DSN2#">
	SELECT IMPORTED FROM FILE_IMPORTS WHERE I_ID = #attributes.i_id#
</cfquery>
<cfif control_import.imported neq 1><!--- import edilmişmi kontrolu,bazen eski sayfadadaki link üzerinden silmeyi tıkladklarnda belgeleri geri almadan silmiş oluyordu onu önlemek için --->
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="DEL_IMPORT" datasource="#DSN2#">
				DELETE FROM FILE_IMPORTS WHERE I_ID = #attributes.i_id#
			</cfquery>
		</cftransaction>
	</cflock>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='413.Bu Belge İçin Önce İmport İşlemini Geri Almalısınız'>!");
	</script>
</cfif>
<script type="text/javascript">
	<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();
	window.close();</cfif>
</script>	
