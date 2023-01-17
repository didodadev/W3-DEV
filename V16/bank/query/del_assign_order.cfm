<cfquery name="CONTROL_BANK_ORDER" datasource="#dsn2#">
	SELECT
		BANK_ORDER_ID,
		IS_PAID
	FROM
		BANK_ORDERS
	WHERE
		BANK_ORDER_ID=#attributes.bank_order_id#
		AND BANK_ORDER_TYPE=#attributes.old_process_type#
</cfquery>
<cfif not control_bank_order.recordcount>
	<br/><font class="txtbold">Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı !</font>
	<cfexit method="exittemplate">
<cfelseif (CONTROL_BANK_ORDER.IS_PAID eq 1)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='408.Silmek İstediğiniz Banka Talimatı İçin Oluşturulmuş Giden Havale Kaydı Bulunmaktadır'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<!--- Action file larda sorun oluyordu bloklara ayırmak zorunda kaldık Özden-Sevda --->
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="del_assign_order_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="del_assign_order_ic.cfm">
</cfif>

<cfif not isDefined("is_from_makeage")>
	<script type="text/javascript">
		window.location.href = "<cfoutput>#request.self#?fuseaction=bank.list_assign_order</cfoutput>";
	</script>
</cfif>
