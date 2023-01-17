<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_punishment.cfm">
	<cf_grid_list class="detail_basket_list">
	<thead>
		<tr>
			<th><cf_get_lang no='415.Makbuz No'></th>
			<th><cf_get_lang no='446.Kaza İlişkisi'></th>
			<th width="75"><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th><cf_get_lang no='424.Ödeme Yapan'></th>
			<th width="70"><cf_get_lang no='416.Ceza Tarih'></th>
			<th><cf_get_lang no='414.Ceza Tipi'></th>
			<th style="text-align:right;"><cf_get_lang no='418.Ödenen Tutar'></th>
			<th style="text-align:right;"><cf_get_lang no='417.Ceza Tutar'></th>
			<th width="90"><cf_get_lang no='185.Son Ödeme Tar'></th>
			<th width="90"><cf_get_lang_main no='1439.Ödeme Tarihi'></th>
			<th width="15"><a href="javascript://" onClick="AjaxPageLoad('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_punishment&punishment_id=#get_punishment.punishment_id#&assetp_id=#attributes.assetp_id#</cfoutput>','frame_punishment',1);"><i class="fa fa-plus" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfset accident_id_list = ''>
		<cfif get_punishment.recordcount>
		<cfoutput query="get_punishment">
			<cfif len(accident_id) and not listFind(accident_id_list,accident_id,',')>
				<cfset accident_id_list = listAppend(accident_id_list,accident_id)>
			</cfif>
		</cfoutput>
		</cfif>
		<cfif len(accident_id_list)>
		<cfquery name="get_accident" datasource="#dsn#">
			SELECT
				ASSET_P.ASSETP,
				ASSET_P_ACCIDENT.ACCIDENT_DATE,
				ASSET_P_ACCIDENT.ACCIDENT_ID
			FROM 
				ASSET_P_ACCIDENT,
				ASSET_P,
				BRANCH
			WHERE
			<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			ASSET_P_ACCIDENT.ACCIDENT_ID IN (#accident_id_list#) AND
			ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
		</cfquery>
		</cfif>
		<cfif get_punishment.recordcount>
			<cfoutput query="get_punishment">		 
				<tr>
					<td>#receipt_num#</td>
					<td>
						<cfif len(accident_id)>
							<cfquery name="get_accident_record" dbtype="query">
								SELECT * FROM get_accident WHERE ACCIDENT_ID = #accident_id#
							</cfquery>
							<cfquery name="get_total_punishment" dbtype="query">
								SELECT SUM(PUNISHMENT_AMOUNT) AS TOTAL_PUNISHMENT FROM get_punishment WHERE ACCIDENT_ID = #accident_id#
							</cfquery>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_accident_detail&accident_id=#get_accident_record.accident_id#','medium');">#get_accident_record.accident_id# Nolu #dateformat(get_accident_record.accident_date,dateformat_style)# <cf_get_lang no='450.tarihli kaza'></a>
							<cfelse>&nbsp;
						</cfif>
					</td>
					<td>#assetp#</td>
					<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a></td>
					<td><cfif payer_id eq 1>Şirket<cfelse>Kişi</cfif></td>
					<td>#dateformat(punishment_date,dateformat_style)#</td>
					<td>#punishment_type_name#</td>
					<td style="text-align:right;">#TLFormat(paid_amount)# #paid_amount_currency#</td>
					<td style="text-align:right;"><cfif len(punishment_amount)>#tlformat(punishment_amount)# #punishment_amount_currency#</cfif></td>
					<td>#dateformat(last_payment_date,dateformat_style)#</td>
					<td>#dateformat(paid_date,dateformat_style)#</td>
		
					<td width="15"><a href="javascript://" onClick="load_list_punishment('#punishment_id#');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a></td>
			</cfoutput>
		<cfelse>
			<tr>
			<td colspan="12"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
		</tbody>
	</cf_grid_list>
<script>
	function load_list_punishment(deger) {
			var punishment_id = deger;
			AjaxPageLoad("<cfoutput>#request.self#?fuseaction=assetcare.popup_upd_punishment&assetp_id=#attributes.assetp_id#</cfoutput>&punishment_id="+punishment_id,'frame_punishment',1);
	}
</script>
