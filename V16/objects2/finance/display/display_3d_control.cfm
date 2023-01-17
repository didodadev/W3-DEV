<cfsetting showdebugoutput="no">
<cfif attributes.okParam eq 1>
	<cfif isdefined('attributes.amount')>
		<cfset amount = attributes.amount>
	<cfelseif isdefined('attributes.TXNAMOUNT')>
		<cfset amount = attributes.TXNAMOUNT>
	</cfif>
	<cfif isdefined('attributes.taksit')>
		<cfset taksit = attributes.taksit>
	<cfelseif isdefined('attributes.TXNINSTALLMENTCOUNT')>
		<cfset taksit = attributes.TXNINSTALLMENTCOUNT>
	</cfif>
	<script language="javascript">
		<cfif attributes.mdstatus eq 1>
			<cfif not isdefined('is_order_')>
				alert('3D İşleminiz Onay Almıştır. Çekim işleminin gerçekleşmesi için lütfen TAMAM dedikten sonra "Tahsilat işleminiz gerçekleşmiştir" yazısını bekleyiniz.');
			<cfelse>
				alert('3D işleminiz Onay almıştır! Lütfen Siparişinizi Tamamlayınız.');
			</cfif>
		<cfelseif listfind('2,3,4',attributes.mdstatus)>
			alert('Kart sahibi veya bankası sisteme kayıtlı değil. Lütfen kart bilgilerinizi kontrol ediniz.');
			window.opener.document.getElementById('mdstatus').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
			window.opener.document.getElementById('error_code').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
			window.opener.historyBack();
			window.close();
		<cfelse>
			alert('3D Secure işleminiz onay almamıştır. Lütfen kart bilgilerinizi kontrol ediniz.');
			window.opener.document.getElementById('mdstatus').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
			window.opener.document.getElementById('error_code').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
			window.opener.historyBack();
			window.close();
		</cfif>
		window.opener.document.getElementById('md').value = '<cfoutput>#attributes.md#</cfoutput>';
		window.opener.document.getElementById('oid').value = '<cfoutput>#attributes.oid#</cfoutput>';
		window.opener.document.getElementById('amount').value = '<cfoutput>#amount#</cfoutput>';
		window.opener.document.getElementById('taksit').value = '<cfoutput>#taksit#</cfoutput>';
		window.opener.document.getElementById('xid').value = '<cfoutput>#attributes.xid#</cfoutput>';
		window.opener.document.getElementById('eci').value = '<cfoutput>#attributes.eci#</cfoutput>';
		window.opener.document.getElementById('cavv').value = '<cfoutput>#attributes.cavv#</cfoutput>';
		window.opener.document.getElementById('mdstatus').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
		<cfif not isdefined('is_order_')>
			window.opener.document.getElementById('add_online_pos').submit();
		<cfelse>
			window.opener.butonActive();
		</cfif>
		window.close();
	</script>
	<cfabort>
<cfelseif attributes.okParam eq 0>
	<cfif isdefined('attributes.ERRMSG') and len(attributes.ERRMSG)>
    	<cfset errMsg_ = attributes.ERRMSG>
    <cfelseif isdefined('attributes.MDERRORMSG') and len(attributes.MDERRORMSG)>
    	<cfset errMsg_ = attributes.MDERRORMSG>
    <cfelse>
    	<cfset errMsg_ = "">
	</cfif>
	<script>
		alert('<cfoutput>#errMsg_#</cfoutput> ! Kart bilgilerinizi kontrol ederek tekrar deneyiniz !');
		<cfif isdefined('is_order_')>
			window.opener.document.getElementById('mdstatus').value = '<cfoutput>#attributes.mdstatus#</cfoutput>';
			window.opener.document.getElementById('error_code').value = '<cfoutput>#attributes.PROCRETURNCODE#</cfoutput>';
			window.opener.historyBack();
		<cfelse>
			window.close();
		</cfif>
	</script>
	<cfabort>
</cfif>