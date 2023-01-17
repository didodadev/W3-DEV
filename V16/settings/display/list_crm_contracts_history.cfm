<!---  
	FBs 20080319 CRM Anlasma Kategorilerinin tarihcelerini goruntuler, farkli sekilde de duzenlenebilir
	tablolar ayrı ayri history kaydediyor ama dosya sadeligi acisindan kayitlari tek bir sayfadan cektim
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&customer_type=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
 --->
	
<cfif isdefined("customer_type") and len(customer_type)><!--- Musteri Tipi --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			CUSTOMER_TYPE TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_CUSTOMER_TYPE_HISTORY
		WHERE
			CUSTOMER_TYPE_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("main_location_cat") and len(main_location_cat)><!--- Ana Konum Kategorisi --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			MAIN_LOCATION_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_MAIN_LOCATION_CAT_HISTORY
		WHERE
			MAIN_LOCATION_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("endorsement_cat") and len(endorsement_cat)><!--- Ciro Kategorileri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			ENDORSEMENT_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_ENDORSEMENT_CAT_HISTORY
		WHERE
			ENDORSEMENT_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("profitability_cat") and len(profitability_cat)><!--- Karlilik Kategorileri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			PROFITABILITY_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_PROFITABILITY_CAT_HISTORY
		WHERE
			PROFITABILITY_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("risk_cat") and len(risk_cat)><!--- Risk Kategorileri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			RISK_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_RISK_CAT_HISTORY
		WHERE
			RISK_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("special_state_cat") and len(special_state_cat)><!--- Ozel Durum Kategorileri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			SPECIAL_STATE_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_SPECIAL_STATE_CAT_HISTORY
		WHERE
			SPECIAL_STATE_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("duty_unit_cat") and len(duty_unit_cat)><!--- Hizmet Birim Kategorileri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			DUTY_UNIT_CAT TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_DUTY_UNIT_CAT_HISTORY
		WHERE
			DUTY_UNIT_CAT_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined("duty_type") and len(duty_type)><!--- Hizmet Tipleri --->
	<!--- Hizmet Tipleri digerlerinden farkli alanlar iceriyor --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			DUTY_TYPE TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			IS_ACTIVE,
			IS_TARGET,
			IS_CATEGORY,
			IS_VALUE,
			COST_ID,
			COST_AMOUNT,
			CALCULATE_METHOD,
			CALCULATE_AMOUNT,
			COST_CALCULATE_ID,
			CUSTOMER_TYPE_ID,
			DUTY_AMOUNT,
			(SELECT DUTY_UNIT_CAT FROM SETUP_DUTY_UNIT_CAT WHERE DUTY_UNIT_CAT_ID = SETUP_DUTY_TYPE_HISTORY.DUTY_UNIT_CAT_ID) HIZMET_BIRIMI,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_DUTY_TYPE_HISTORY
		WHERE
			DUTY_TYPE_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
	<cfquery name="get_customer_type" datasource="#dsn#">
		SELECT 
			CUSTOMER_TYPE
		FROM 
			SETUP_CUSTOMER_TYPE
		<cfif len(get_histories.customer_type_id)>
			WHERE
			<cfloop from="1" to="#listlen(get_histories.customer_type_id)#" index="k">		
				CUSTOMER_TYPE_ID = #listgetat(get_histories.customer_type_id,k)# <cfif k neq listlen(get_histories.customer_type_id)>OR</cfif>
			</cfloop>
		</cfif>
	</cfquery>
	<!--- //Hizmet Tipleri digerlerinden farkli alanlar iceriyor --->
<cfelseif isdefined("target_period") and len(target_period)><!--- Hedef Donemleri --->
	<cfquery name="get_histories" datasource="#dsn#">
		SELECT
			TARGET_PERIOD TABLE_HEAD,
			DETAIL TABLE_DETAIL,
			RECORD_DATE TABLE_DATE,
			RECORD_EMP TABLE_EMP
		FROM
			SETUP_TARGET_PERIOD_HISTORY
		WHERE
			TARGET_PERIOD_ID = #url.id#
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
</cfif>
<table width="100%" height="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang_main no='61.Tarihçe'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
			<table width="100%">
			  <cfif isdefined("get_histories") and get_histories.recordcount>
				<cfoutput query="get_histories">
					<tr>
						<td class="txtboldblue" width="140">
							<cfif isdefined("customer_type") and len(customer_type)>
								<cf_get_lang_main no='218.Tip'>
							<cfelseif isdefined("main_location_cat") and len(main_location_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("endorsement_cat") and len(endorsement_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("profitability_cat") and len(profitability_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("risk_cat") and len(risk_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("special_state_cat") and len(special_state_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("duty_unit_cat") and len(duty_unit_cat)>
								<cf_get_lang_main no='74.Kategori'>
							<cfelseif isdefined("duty_type") and len(duty_type)>
								<cf_get_lang no ='1685.Hizmet Adı'>
							<cfelseif isdefined("target_period") and len(target_period)>
								<cf_get_lang_main no='1060.Dönem'>
							</cfif>
						</td>
						<td width="660">#table_head#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
						<td>#table_detail#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang no='1180.Güncelleme Tarihi'></td>
						<td>#Dateformat(table_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,table_date),timeformat_style)#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no='479.Güncelleyen'></td>
						<td>#get_emp_info(table_emp,0,0)#</td>
					</tr>
					<cfif isdefined("duty_type") and len(duty_type)><!--- Hizmet Tipleri digerlerinden farkli alanlar iceriyor!! --->
						<tr>
							<td class="txtboldblue" width="180"><cf_get_lang_main no='344.Durum'></td>
							<td width="620"><cfif is_active eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
						</tr>
						<tr>
							<td class="txtboldblue" width="180"><cf_get_lang no ='1687.Hizmet Birimi'></td>
							<td width="620">#hizmet_birimi#</td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang_main no='45.Musteri'><cf_get_lang no='1627.Tipi'></td>
							<td><cfquery name="get_customer_type" datasource="#dsn#">
									SELECT 
										CUSTOMER_TYPE
									FROM 
										SETUP_CUSTOMER_TYPE
									<cfif len(get_histories.customer_type_id)>
										WHERE
										<cfloop from="1" to="#listlen(get_histories.customer_type_id)#" index="k">		
											CUSTOMER_TYPE_ID = #listgetat(get_histories.customer_type_id,k)# <cfif k neq listlen(get_histories.customer_type_id)>OR</cfif>
										</cfloop>
									</cfif>
								</cfquery>
								<cfloop from="1" to="#get_customer_type.recordcount#" index="f">
									#get_customer_type.customer_type[f]#
								</cfloop>
							</td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang_main no='846.Maliyet'></td>
							<td><cfif cost_id eq 1>
									<cf_get_lang_main no='1586.Hesapla'> - <cfif calculate_method eq 1> <cf_get_lang no ='1689.Tutar Belli '><cfelseif calculate_method eq 2>4.5.<cf_get_lang no ='1864.Kademe Hariç'> <cfelseif calculate_method eq 3><cf_get_lang no ='1696.Diğer Tutar'>  (#TLFormat(calculate_amount)#)</cfif>
								<cfelse>
									<cf_get_lang no ='1689.Tutar Belli '>(#TLFormat(cost_amount)#)
								</cfif>
							</td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang no ='1691.Hizmet İçin Hedef Tanımı'></td>
							<td><cfif is_target eq 1><cf_get_lang_main no='1152.Var'><cfelse><cf_get_lang_main no='1134.Yok'></cfif></td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang no ='1865.Hizmet İçin Değer Girişi'></td>
							<td><cfif is_value eq 1><cf_get_lang_main no='1152.Var'><cfelse><cf_get_lang_main no='1134.Yok'></cfif></td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang no ='1624.Kategorisi'></td>
							<td><cfif is_category eq 1><cf_get_lang no ='1693.Ek Hizmet'><cfelse><cf_get_lang no ='1694.Standart'></cfif></td>
						</tr>
					</cfif>
					<tr>
						<td colspan="2" width="800"><hr></td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr height="20">
						<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
					</tr>
			  </cfif>
			</table>
		</td>
	</tr>
</table>
