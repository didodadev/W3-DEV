<cfsetting showdebugoutput="no">
<!---TolgaS 20061205 cost_action fonksiyonu içinden çağrılıyor ve maliyet işleminin yapılması için cost_action_2 ye cfhttp ile yönleniyor
fusebox.server_machine_list url de kullanılıyor buyüzden paramda doğru ve erişebilir bir adres tanımlanmalı
 timeout olma ihtimali için try kullandık eger zaman aşımı olursa bir daha cagiracak en azından anında yapılmamı maliyet işlemlerini minumuma indirmiş olacak --->
<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
<cfif (isdefined('session.ep') or isdefined('session.pda')) or (isdefined('attributes.is_schedules') and attributes.is_schedules eq '127.0.0.1')>
	<cfif not isdefined('attributes.is_print')><cf_get_lang no='1878.Yapmış Olduğunuz İşlem Maliyet İşlemi Çalıştırmıştır'>.</cfif>
	<cfif isdefined('attributes.period_dsn_type')>
		<cfset _period_year_ = ListGetAt(attributes.period_dsn_type,3,'_')><!--- YTL ve TL ile ilgili sorun çıkmaması için eklendi.. --->
    </cfif>
	<cfif isdefined('attributes.action_type')>
		<cftry>
			<cflock timeout="90">
				<cfhttp url="#listgetat(fusebox.server_machine_list,fusebox.server_machine,';')#/V16/objects/query/cost_action_2.cfm" method="post" redirect="no">
					<cfhttpparam type="formfield" name="action_type" value="#attributes.action_type#">
					<cfhttpparam type="formfield" name="action_id" value="#attributes.action_id#">
					<cfhttpparam type="formfield" name="dsn_type" value="#attributes.dsn_type#">
					<cfhttpparam type="formfield" name="query_type" value="#attributes.query_type#">
					<cfhttpparam type="formfield" name="period_dsn_type" value="#attributes.period_dsn_type#">
					<cfhttpparam type="formfield" name="session_userid" value="#attributes.user_id#">
					<cfhttpparam type="formfield" name="session_period_id" value="#attributes.period_id#">
					<cfhttpparam type="formfield" name="session_company_id" value="#attributes.company_id#">
					<cfhttpparam type="formfield" name="dsn" value="#dsn#">
					<cfhttpparam type="formfield" name="dsn_alias" value="#dsn_alias#">
					<cfhttpparam type="formfield" name="dsn1" value="#dsn1#">
					<cfhttpparam type="formfield" name="dsn1_alias" value="#dsn1_alias#">
					<cfhttpparam type="formfield" name="dsn3" value="#dsn3#">
					<cfhttpparam type="formfield" name="dsn3_alias" value="#dsn3_alias#">
					<cfhttpparam type="formfield" name="server_detail" value="#server_detail#"><!--- server_detail --->
					<cfhttpparam type="formfield" name="action_ip" value="#cgi.REMOTE_ADDR#"><!--- action_ip --->
					<cfhttpparam type="CGI" 	  name="http_referer"  value="#cgi.http_referer#">
					<cfif isdefined('attributes.is_schedules') and attributes.is_schedules eq '127.0.0.1'>
						<cfif isdefined('_period_year_') and len(_period_year_) and _period_year_ gt 2008><cfset _cost_money_system_ = 'TL'><cfelse><cfset _cost_money_system_ = 'YTL'></cfif>
                        <cfhttpparam type="formfield" name="s_id" value=""><!--- session_id --->
						<cfhttpparam type="formfield" name="cost_money_system" value="#_cost_money_system_#"><!--- session.ep.money --->
						<cfhttpparam type="formfield" name="cost_money_system_2" value="USD"><!--- session.ep.money2 sistem 2 para birimi --->
						<cfhttpparam type="formfield" name="is_sch" value="1"><!--- SCHEDULEDEN GELDİGİNİ BELLİ EDEN DEGER --->
					<cfelse>
						<cfif isDefined("session.pda")>
							<cfhttpparam type="formfield" name="s_id" value="#session.pda.workcube_id#"><!--- session_id --->
							<cfhttpparam type="formfield" name="cost_money_system" value="#session.pda.money#"><!--- session.ep.money --->
							<cfhttpparam type="formfield" name="cost_money_system_2" value="#session.pda.money2#"><!--- session.ep.money2 sistem 2 para birimi --->
						<cfelse>
							<cfhttpparam type="formfield" name="s_id" value="#session.ep.workcube_id#"><!--- session_id --->
							<cfhttpparam type="formfield" name="cost_money_system" value="#session.ep.money#"><!--- session.ep.money --->
							<cfhttpparam type="formfield" name="cost_money_system_2" value="#session.ep.money2#"><!--- session.ep.money2 sistem 2 para birimi --->
						</cfif>
					</cfif>
					<cfif isdefined("attributes.control_type")>
						<cfhttpparam type="formfield" name="control_type" value="#attributes.control_type#">
					<cfelse>
						<cfhttpparam type="formfield" name="control_type" value="0">
					</cfif>
					<cfif isdefined("attributes.extra_action_row_id")>
						<cfhttpparam type="formfield" name="action_row_id" value="#attributes.extra_action_row_id#">
					<cfelse>
						<cfhttpparam type="formfield" name="action_row_id" value="0">
					</cfif>
					<cfif isdefined("attributes.aktarim_product_id")>
						<cfhttpparam type="formfield" name="aktarim_product_id" value="#attributes.aktarim_product_id#">
					<cfelse>
						<cfhttpparam type="formfield" name="aktarim_product_id" value="">
					</cfif>
					<cfhttpparam type="formfield" name="server_machine_list" value="#fusebox.server_machine_list#">
					<cfhttpparam type="formfield" name="server_machine" value="#fusebox.server_machine#">
					<cfif isDefined("session.pda")>
						<cfhttpparam type="formfield" name="is_prod_cost_type" value="#session.pda.our_company_info.is_prod_cost_type#">
					<cfelse>
						<cfhttpparam type="formfield" name="is_prod_cost_type" value="#session.ep.our_company_info.is_prod_cost_type#">
					</cfif>
					<cfif isDefined("session.pda")>
						<cfhttpparam type="formfield" name="is_stock_based_cost" value="#session.pda.our_company_info.is_stock_based_cost#">
					<cfelse>
						<cfhttpparam type="formfield" name="is_stock_based_cost" value="#session.ep.our_company_info.is_stock_based_cost#">
					</cfif>
					<cfif isdefined('attributes.aktarim_is_date_kontrol')>
						<cfhttpparam type="formfield" name="aktarim_is_date_kontrol" value="#attributes.aktarim_is_date_kontrol#">
					</cfif>
					<cfif isdefined('attributes.aktarim_date2')>
						<cfhttpparam type="formfield" name="aktarim_date2" value="#attributes.aktarim_date2#">
					</cfif>
				</cfhttp>
			</cflock>
			<cfcatch>
				<cflock timeout="90">
				<cfhttp url="#listgetat(fusebox.server_machine_list,fusebox.server_machine,';')#V16/objects/query/cost_action_2.cfm" method="post"  redirect="no">
					<cfhttpparam type="formfield" name="action_type" value="#attributes.action_type#">
					<cfhttpparam type="formfield" name="action_id" value="#attributes.action_id#">
					<cfhttpparam type="formfield" name="dsn_type" value="#attributes.dsn_type#">
					<cfhttpparam type="formfield" name="query_type" value="#attributes.query_type#">
					<cfhttpparam type="formfield" name="period_dsn_type" value="#attributes.period_dsn_type#">
					<cfhttpparam type="formfield" name="session_userid" value="#attributes.user_id#">
					<cfhttpparam type="formfield" name="session_period_id" value="#attributes.period_id#">
					<cfhttpparam type="formfield" name="session_company_id" value="#attributes.company_id#">
					<cfhttpparam type="formfield" name="dsn" value="#dsn#">
					<cfhttpparam type="formfield" name="dsn_alias" value="#dsn_alias#">
					<cfhttpparam type="formfield" name="dsn1" value="#dsn1#">
					<cfhttpparam type="formfield" name="dsn1_alias" value="#dsn1_alias#">
					<cfhttpparam type="formfield" name="dsn3" value="#dsn3#">
					<cfhttpparam type="formfield" name="dsn3_alias" value="#dsn3_alias#">
					<cfhttpparam type="formfield" name="server_detail" value="#server_detail#"><!--- server_detail --->
					<cfhttpparam type="formfield" name="action_ip" value="#cgi.REMOTE_ADDR#"><!--- action_ip --->
					<cfhttpparam type="CGI" 	  name="http_referer"  value="#cgi.http_referer#">
					<cfif isdefined('attributes.is_schedules') and attributes.is_schedules eq '127.0.0.1'>
						<cfhttpparam type="formfield" name="s_id" value=""><!--- session_id --->
						<cfhttpparam type="formfield" name="cost_money_system" value="YTL"><!--- session.ep.money --->
						<cfhttpparam type="formfield" name="cost_money_system_2" value="USD"><!--- session.ep.money2 sistem 2 para birimi --->
						<cfhttpparam type="formfield" name="is_sch" value="1"><!--- SCHEDULEDEN GELDİGİNİ BELLİ EDEN DEGER --->
					<cfelse>
						<cfif isDefined("session.pda")>
							<cfhttpparam type="formfield" name="s_id" value="#session.pda.workcube_id#"><!--- session_id --->
							<cfhttpparam type="formfield" name="cost_money_system" value="#session.pda.money#"><!--- session.ep.money --->
							<cfhttpparam type="formfield" name="cost_money_system_2" value="#session.pda.money2#"><!--- session.ep.money2 sistem 2 para birimi --->
						<cfelse>
							<cfhttpparam type="formfield" name="s_id" value="#session.ep.workcube_id#"><!--- session_id --->
							<cfhttpparam type="formfield" name="cost_money_system" value="#session.ep.money#"><!--- session.ep.money --->
							<cfhttpparam type="formfield" name="cost_money_system_2" value="#session.ep.money2#"><!--- session.ep.money2 sistem 2 para birimi --->
						</cfif>
					</cfif>
					<cfif isdefined("attributes.extra_action_row_id")>
						<cfhttpparam type="formfield" name="action_row_id" value="#attributes.extra_action_row_id#">
					<cfelse>
						<cfhttpparam type="formfield" name="action_row_id" value="0">
					</cfif>
					<cfif isdefined('attributes.aktarim_is_date_kontrol')>
						<cfhttpparam type="formfield" name="aktarim_is_date_kontrol" value="#attributes.aktarim_is_date_kontrol#">
					</cfif>
					<cfif isdefined("attributes.control_type")>
						<cfhttpparam type="formfield" name="control_type" value="#attributes.control_type#">
					<cfelse>
						<cfhttpparam type="formfield" name="control_type" value="0">
					</cfif>
					<cfif isdefined("attributes.aktarim_product_id")>
						<cfhttpparam type="formfield" name="aktarim_product_id" value="#attributes.aktarim_product_id#">
					<cfelse>
						<cfhttpparam type="formfield" name="aktarim_product_id" value="">
					</cfif>
					<cfhttpparam type="formfield" name="server_machine_list" value="#fusebox.server_machine_list#">
					<cfhttpparam type="formfield" name="server_machine" value="#fusebox.server_machine#">
					<cfif isDefined("session.pda")>
						<cfhttpparam type="formfield" name="is_prod_cost_type" value="#session.pda.our_company_info.is_prod_cost_type#">
					<cfelse>
						<cfhttpparam type="formfield" name="is_prod_cost_type" value="#session.ep.our_company_info.is_prod_cost_type#">
					</cfif>
					<cfif isDefined("session.pda")>
						<cfhttpparam type="formfield" name="is_stock_based_cost" value="#session.pda.our_company_info.is_stock_based_cost#">
					<cfelse>
						<cfhttpparam type="formfield" name="is_stock_based_cost" value="#session.ep.our_company_info.is_stock_based_cost#">
					</cfif>
					<cfif isdefined('attributes.aktarim_date2')>
						<cfhttpparam type="formfield" name="aktarim_date2" value="#attributes.aktarim_date2#">
					</cfif>
				</cfhttp>
				</cflock>
			</cfcatch>
		</cftry>
	</cfif>
<cfelse>
	<cf_get_lang no='1879.Islem Yapmaya Yetkiniz Yok'>
</cfif>
<cfif not isdefined('attributes.not_close_page')><!--- rapordan maliyet eklerken bu calismasın diye --->
	<script type="text/javascript">
		function waitfor(){
			window.close();
		}
		setTimeout("waitfor()",3000);
	</script>
</cfif>
<cfif isdefined('attributes.is_print')>
	<cfif cfhttp.statusCode neq '200 OK'>
        <font color="red">Maliyet İşlemi Sırasında Hata Oluştu Lütfen Belgeyi Kontrol Ediniz!</font><br />
    </cfif>
</cfif>
<cfoutput>#cfhttp.FileContent#</cfoutput>
<!--- hata gormek icin veya ekrana basılan degerleri görmekiçin bu kodun yazılması gereklidir  <cfoutput>#cfhttp.FileContent#</cfoutput>--->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
