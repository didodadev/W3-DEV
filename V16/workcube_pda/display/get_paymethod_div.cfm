<cf_get_lang_set module_name="objects">
<cfsetting showdebugoutput="no">
<cfset attributes.name = 1>
<cfset attributes.paymentdate_value = ''>
<cfif not isdefined("attributes.is_paymethods")>
	<cfquery name="CARD_PAYMENT_TYPES" datasource="#DSN3#">
		SELECT  
			PAYMENT_TYPE_ID, 
			CARD_NO,
			NUMBER_OF_INSTALMENT, 
			COMMISSION_STOCK_ID,
			COMMISSION_PRODUCT_ID,
			COMMISSION_MULTIPLIER,
			POS_TYPE
		FROM  
			CREDITCARD_PAYMENT_TYPE 
		WHERE 
			IS_ACTIVE = 1
			<cfif len(attributes.keyword)>
				AND CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
		ORDER BY 
			CARD_NO
	</cfquery>
<cfelse>
	<cfset card_payment_types.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfquery name="PAYMETHODS" datasource="#DSN#">
	SELECT
		<cfif isDefined("attributes.names")>
			SP.PAYMETHOD_ID,
			SP.PAYMETHOD
		<cfelse>
			SP.*
		</cfif>
	FROM
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
		<cfif len(attributes.keyword)>
			AND SP.PAYMETHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
	ORDER BY
		SP.PAYMENT_VEHICLE,
		SP.DUE_DAY
</cfquery>
<cfsavecontent variable="message"><cf_get_lang no='338.Ödeme Yöntemleri'></cfsavecontent>

<cf_box title="<cfoutput>#message#</cfoutput>" body_style="overflow-y:scroll;height:100px;">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
		<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%; height:35px;">
					<tr>
						<td class="headbold">Standart <cf_get_lang no='338.Ödeme Yöntemleri'></td>
					</tr>
				</table>
				<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
					<tr class="color-border">
						<td>
							<table cellpadding="2" cellspacing="1" border="0" style="width:100%">
								<tr class="color-header" style="height:22px;">
									<td class="form-title"><cf_get_lang no='312.Metod'></td>
									<td class="form-title" style="width:40px;"><cf_get_lang no='339.Vade Gün Toplam'></td>
									<td class="form-title" style="width:40px;"><cf_get_lang no='340.Vade Aylık(Taksit)'></td>
									<td class="form-title" style="width:40px;"><cf_get_lang no='341.Peşinat Oranı'>%</td>
								</tr>
								<cfif len(attributes.paymentdate_value)>
									<cf_date tarih="attributes.paymentdate_value">
								</cfif>
								<cfoutput query="paymethods">
									<tr class="color-row" style="height:20px;">
										<cfif len(due_day)>
											<cfif len(attributes.paymentdate_value)>
												<cfset new_due_date = dateformat(date_add("d",due_day,attributes.paymentdate_value),"dd/mm/yyyy")>
											<cfelse>
												<cfset new_due_date = "">
											</cfif>
										<cfelse>
											<cfset new_due_date = dateformat(attributes.paymentdate_value,"dd/mm/yyyy") >
										</cfif>
										<td><a href="javascript://" onclick="add_paymethod_st('#paymethod_id#','#paymethod#','#new_due_date#','#due_day#','#payment_vehicle#','#TlFormat(due_date_rate)#','#due_month#');" class="tableyazi">#paymethod#</a>
											<cfswitch expression="#payment_vehicle#">
												<cfcase value="1">-<cf_get_lang no='344.Çek'></cfcase>
												<cfcase value="2">-<cf_get_lang no='345.Senet'></cfcase>
												<cfcase value="3">-<cf_get_lang no='346.Havale'></cfcase>
												<cfcase value="4">-<cf_get_lang no='347.Açık Hesap'></cfcase>
												<cfcase value="5">-<cf_get_lang no='348.Kredi Kart'></cfcase>
												<cfcase value="6">-<cf_get_lang no='349.Nakit'></cfcase>
											</cfswitch>
										</td>
										<td align="right">#due_day# <cfif len(due_day)> <cf_get_lang_main no='78.Gün'> </cfif></td>
										<td align="right">#in_advance#</td>
										<td align="right">#due_date_rate#</td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</tr>
				</table>
				<cfif card_payment_types.recordcount>
					<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
						<tr style="height:35px;">
							<td class="headbold">Kredi Kartı Ödeme Yöntemi</td>
						</tr>
						<tr class="color-border">
							<td>
								<table cellpadding="2" cellspacing="1" border="0" style="width:100%">
									<tr class="color-header" style="height:22px;">
										<td class="form-title"><cf_get_lang no='312.Metod'></td>
										<td class="form-title" style="width:40px;">Taksit Sayısı</td>
										<td class="form-title" nowrap style="width:40px;">Hizmet Komisyon Oranı</td>
										<td class="form-title" nowrap style="width:40px;">Sanal POS</td>
									</tr>
									<cfoutput query="card_payment_types">
										<tr class="color-row" style="height:20px;">
											<td><a href="javascript:add_paymethod_cc('#payment_type_id#','#card_no#','<cfif len(commission_stock_id)>#commission_stock_id#</cfif>','<cfif len(commission_product_id)>#commission_product_id#</cfif>','<cfif len(commission_multiplier)>#commission_multiplier#</cfif>')" class="tableyazi">#card_no#</a></td>
											<td align="right"><cfif len(number_of_instalment)>#number_of_instalment#<cfelse>Peşin</cfif></td>
											<td align="right"><cfif len(commission_multiplier)>%#commission_multiplier#</cfif></td>
											<td align="center"><cfif len(pos_type)>*</cfif></td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
					</table>
				</cfif>
			</td>
		</tr>
	</table>
</cf_box>
<cf_get_lang_set module_name="objects">
<!--- sayfanin en ustunde acilisi var --->
