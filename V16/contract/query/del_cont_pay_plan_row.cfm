<cfset get_contract = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset contract_cmp= createObject("component","V16.contract.cfc.contract") />
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!---temizle butonuyla silincek faturalanmamıs,ödenmemiş,provzyon oluşmamış,referans seçilmemiş satırların toplu silinmesi içindir--->
		<cfif isDefined("attributes.del_all") and isDefined("attributes.contract_id")>
			<cfif not isDefined("cancel_subs_info")><cf_date tarih='attributes.start_date'></cfif><!--- sistem iptal sayfasndan yapulan silmeler için --->
			<cfset DEL_PAY_PLAN_ROW = contract_cmp.DEL_PAY_PLAN_ROW(start_date : attributes.start_date,contract_id : attributes.contract_id)>
	
		</cfif>
		<!---sadece silme ikonu gelen tek satir silmelerde çalışır--->
		<cfif isDefined("attributes.payment_row_id")>
			<cfset control_row = get_contract.control_row(payment_row_id :  attributes.payment_row_id)>
            <cfif control_row.IS_PAID eq 1 or control_row.IS_COLLECTED_PROVISION eq 1 or control_row.IS_BILLED eq 1>
				<script language="javascript">
					alert("Satır İşlem Gördüğü İçin Silemezsiniz !");
					opener.location.reload();
					window.close();
				</script>
			<cfelse>
				<cfset DEL_PAY_PLAN_ROW = contract_cmp.DEL_PAY_PLAN_ROW2(payment_row_id: attributes.payment_row_id)>
            </cfif>
		</cfif>
	</cftransaction>
</cflock>
<cfif not isDefined("cancel_subs_info")><!--- sistem iptal sayfasndan yapulan silmeler için --->
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
