<div style="width:900px;">
	<cfif isdefined('attributes.subs_warning') and attributes.subs_warning eq 1>
		<div style="width: 100%;">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cf_get_lang_main no='129.HATA'></h1></div>
			</div>
			<div style="width: 100%;padding-top:140px; background: url(/documents/templates/worknet/tasarim/icon_iptal.jpg) no-repeat center top;">
				<span style="width: 100%;text-align: center;font-size: 20px;color: #333;">
					Kredi kartı ödeme işleminiz gerçekleşti fakat abonelik kaydınız oluşturulamadı. <br/>
					Lütfen sistem yöneticinize başvurunuz. <br/><br/>
					<a href="mailto:info@styleturkish.com" style="font-size:12px;color: #333; text-align:center; float:none !important; text-decoration:underline;">info@styleturkish.com</a>
				</span>
			</div>
		</div>
	<cfelseif isdefined('attributes.order_warning') and attributes.order_warning eq 1>
		<div style="width: 100%;">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cf_get_lang_main no='129.HATA'></h1></div>
			</div>
			<div style="width: 100%;padding-top:140px; background: url(/documents/templates/worknet/tasarim/icon_iptal.jpg) no-repeat center top;">
				<span style="width: 100%;text-align: center;font-size: 20px;color: #333;">
					Eğitim satınalma işlemi yapılırken hata ile karşılaşıldı. <br/>
					Lütfen sistem yöneticinize başvurunuz. <br/><br/>
					<a href="mailto:info@styleturkish.com" style="font-size:12px;color: #333; text-align:center; float:none !important; text-decoration:underline;">info@styleturkish.com</a>
				</span>
			</div>
		</div>
	<cfelse>
		<div style="width: 100%;">
			<div style="width: 100%;padding-top:120px; background: url(/documents/templates/worknet/tasarim/icon_onay.jpg) no-repeat center top;">
				<span style="width: 100%;text-align: center;font-size: 20px;color: #333;">
					İşleminiz onay almıştır. <br/>
					<cfif isdefined('attributes.order_warning') and attributes.order_warning eq 0>
						<script language="javascript">
							setTimeout("history.back();",3000)
						</script>
					<cfelse>
						<a href="/" style="display: inline;width: 75px;height: 13px;padding: 10px 0px 10px 45px;margin: 20px 0px 0px 400px;font-size: 12px;color: #333;background: url(/documents/templates/worknet/tasarim/geri_ap.png) no-repeat;">
							<cf_get_lang no='227.Anasayfa'>
						</a>
					</cfif>
				</span>
			</div>
		</div>
	</cfif>
</div>
