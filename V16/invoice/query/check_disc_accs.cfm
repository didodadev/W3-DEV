<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif is_account>
	<cfinclude template="check_bill_start.cfm">	
	<cfquery name="GET_NO_" datasource="#new_dsn2_group#">
		SELECT 
			* 
		FROM
		<cfif form.sale_product eq 1>
			#new_dsn3_group#.SETUP_INVOICE SETUP_INVOICE
		<cfelseif form.sale_product eq 0>
			#new_dsn3_group#.SETUP_INVOICE_PURCHASE SETUP_INVOICE_PURCHASE
		</cfif> 
	</cfquery>
	<cfif not len(GET_NO_.A_DISC) and (isDefined("form.basket_discount_total") and form.basket_discount_total gt 0)>
		<cfset HATA=2>
	</cfif>
	<cfif not get_no_.recordcount>
		<cfset HATA=1>
	</cfif>
	<cfif isDefined("HATA")>
		<cfif HATA EQ 1>
			<cfif not isdefined('xml_import')>
				<cfif form.sale_product eq 1>
					<script type="text/javascript">
						alert("<cf_get_lang no='53.Satis Tanimlari Ayarlarini Yapmalisiniz !'>");
						window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
						//history.back();
					</script>
				<cfelseif form.sale_product eq 0>
					<script type="text/javascript">
						alert("<cf_get_lang no='146.Lutfen Alis Tanimlari Ayarlarini Yapiniz'>");
						window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
						//history.back();
					</script>
				</cfif>
			<cfelse>
				<cfif form.sale_product eq 1>
					<cf_get_lang no='53.Satis Tanimlari Ayarlarini Yapmalisiniz !'><br/>
				<cfelseif form.sale_product eq 0>
					<cf_get_lang no='146.Lutfen Alis Tanimlari Ayarlarini Yapiniz'><br/>		
				</cfif>
				<cfset error_flag =1>
			</cfif>
		<cfelse>
			<cfif not isdefined('xml_import')>
				<script type="text/javascript">
					alert("<cf_get_lang no='52.Indirim Ayarlarini Yapmadan Indirim Uygulayamazsiniz !'>");
					window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
					//history.back();
				</script>
			<cfelse>
				<cf_get_lang no='52.Indirim Ayarlarini Yapmadan Indirim Uygulayamazsiniz !'><br/>
				<cfset error_flag =1>
			</cfif>
		</cfif>
		<cfabort>
	</cfif>
	<cfinclude template="check_comp_cons_account.cfm">
	<cfif isDefined('attributes.yuvarlama') and len(attributes.yuvarlama) and  form.sale_product eq 0>
		<!--- sadece alis faturada calisiyor ve yukaridaki GET_NO_ query si SETUP_INVOICE_PURCHASE e girmis olmali (yani sadece alis faturalari icin calisir)--->
		<cfif attributes.yuvarlama lt 0 >
			<cfset hesap_yuvarlama = GET_NO_.YUVARLAMA_GELIR >
		<cfelse>
			<cfset hesap_yuvarlama = GET_NO_.YUVARLAMA_GIDER >	
		</cfif>
	</cfif>
</cfif>
<cfinclude template="get_inv_cats.cfm">