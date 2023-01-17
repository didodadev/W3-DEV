<!--- by 20060405 
satis siparisi surecleri icin risk kontrolu --->
<script type="text/javascript">
function process_cat_dsp_function()
	{
	if(form_basket.company_id!=undefined && form_basket.company_id.value!=''){
		var open_risk;var usable_risk;
		var get_company_risk = wrk_safe_query('prc_get_company_risk','dsn2',0,form_basket.company_id.value);
		<cfif isdefined("session.ep.username") and session.ep.username is 'admin'>
			try{general_prom_inputs.innerHTML += '<br/>'+risk_sql;}
			catch(e){}
		</cfif>
		if(get_company_risk.recordcount)
			{
			open_risk = get_company_risk.OPEN_ACCOUNT_RISK_LIMIT - get_company_risk.BAKIYE;
			<!--- open_risk: acik hesap risk limiti --->
			usable_risk =parseFloat(get_company_risk.TOTAL_RISK_LIMIT) - parseFloat(get_company_risk.BAKIYE)  - (parseFloat(get_company_risk.CEK_ODENMEDI) + parseFloat(get_company_risk.SENET_ODENMEDI) + parseFloat(get_company_risk.CEK_KARSILIKSIZ) + parseFloat(get_company_risk.SENET_KARSILIKSIZ));
			<!--- usable_risk: kullanilabilir risk limiti  --->
			if(open_risk>0)<!--- mevcut odenmemis, islem gormemis satis siparisleri acik riski daha da kucultur, risk zaten negatif ise buraya hic girmez --->
				{
				var get_company_orders = wrk_safe_query('prc_get_company_orders','dsn3',0,form_basket.company_id.value);
				if(get_company_orders.recordcount){
					open_risk -= get_company_orders.NETTOTAL;
					usable_risk -= get_company_orders.NETTOTAL;
					}
					<cfif isdefined("session.ep.username") and session.ep.username is 'admin'>
					try{general_prom_inputs.innerHTML += '<br/>'+risk_order;}
					catch(e){}
					</cfif>
				}
			if(open_risk<0 || usable_risk<0){
				alert('Bu cariye ait risk limitleri zaten doldurulmuş!!! \nSipariş Alamazsınız!'+'\nAçık Hesap:'+commaSplit(open_risk)+'\nKullanılabilir Risk:'+commaSplit(usable_risk));
				return false;
				}
			else if(open_risk>0 && open_risk<parseFloat(form_basket.basket_net_total.value) ){
				<cfif isdefined("session.ep.money")>
				alert('Bu cariye ait risk bu siparişle birlikte : '+commaSplit( Math.abs(open_risk-parseFloat(form_basket.basket_net_total.value)) )+' <cfoutput>#session.ep.money#</cfoutput> Aşılıyor\n! Siparişi Kaydedemezsiniz!' );
				<cfelseif isdefined("session_base.money")>
				alert('Bu cariye ait risk bu siparişle birlikte : '+commaSplit( Math.abs(open_risk-parseFloat(form_basket.basket_net_total.value)) )+' <cfoutput>#session_base.money#</cfoutput> Aşılıyor\n! Siparişi Kaydedemezsiniz!' );
				<cfelse>
				alert('Bu cariye ait risk bu siparişle birlikte Aşılıyor\n! Siparişi Kaydedemezsiniz!' );
				</cfif>
				return false;
				}
			else return true;<!--- risk satis yapmaya uygun --->
			}
		else
			return true;
		}
	else
		return true;
	}
</script>
