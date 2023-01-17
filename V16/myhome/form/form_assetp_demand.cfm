<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.demand_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="get_assetp_demand" datasource="#dsn#">
	SELECT * FROM ASSET_P_DEMAND WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
</cfquery>
<cfsavecontent variable="right_images_">
    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#get_assetp_demand.demand_id#&print_type=186</cfoutput>','page');"><img src="/images/print.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('main',115)#" right_images="#right_images_#">
	<table style="vertical-align:top;">
        <cfform name="upd_assetp_demand" action="#request.self#?fuseaction=myhome.emptypopup_assetp_demand" method="post">
				<cfif get_assetp_demand.recordcount>
				<cfoutput query="get_assetp_demand">
					<tr>
						<td>
							<input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>">
							<input type="hidden" name="result_id" id="result_id" value="">
						</td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang no='72.Talep Eden'></td>
						<td>#get_emp_info(employee_id,0,1)#</td>
					</tr>
					<tr height="20">
						<td class="txtbold" style="width:100px"><cf_get_lang_main no='160.Departman'></td>
						<td><cfset attributes.department_id = get_assetp_demand.department_id>
							<cfinclude template="../query/get_branchs_deps.cfm">
							#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#
						</td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
						<td><cfset attributes.cat_id = get_assetp_demand.assetp_catid>
							<cfinclude template="../query/get_assetp_cats.cfm">
							#get_assetp_cats.assetp_cat#
						</td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang no='263.Kullanım Amacı'></td>
						<td><cfset attributes.purpose_id=get_assetp_demand.usage_purpose_id>
							<cfinclude template="../query/get_usage_purpose.cfm">
							#get_usage_purpose.usage_purpose#
						</td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang no='266.Talep Tarihi'></td>
						<td>#dateformat(request_date,dateformat_style)# </td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
						<td>#get_assetp_demand.detail#</td>
					</tr>
					<tr height="20">
						<td class="txtbold" width="70" valign="top"><cf_get_lang_main no='344.Durum'></td>
						<td>
							<cfswitch expression="#result_id#">
								<cfcase value="1"><cf_get_lang no='217.Kabul'> (+)</cfcase>
								<cfcase value="0"><cf_get_lang_main no='1740.Red'> (-)</cfcase>
								<cfdefaultcase><cf_get_lang no='262.Değerlendirme Aşamasında'></cfdefaultcase>
							</cfswitch>
						</td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
						<td>#get_emp_info(get_assetp_demand.validator_pos_code,1,0)#</td>
					</tr>
					<tr height="20" valign="bottom">
						<td class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
						<td>
							<cfif get_assetp_demand.result_id eq 1>
								<cf_get_lang_main no='1287.Onaylandı'> !
								<cfoutput>#dateformat(get_assetp_demand.valid_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_assetp_demand.valid_date),timeformat_style)#</cfoutput>
							<cfelseif get_assetp_demand.result_id eq 0>
								<cf_get_lang_main no='205.Reddedildi'> !
								<cfoutput>#dateformat(get_assetp_demand.valid_date,dateformat_style)# #timeformat(get_assetp_demand.valid_date,timeformat_style)#</cfoutput>
							<cfelse>
								<cf_get_lang_main no='203.Onay Bekliyor'> !
								<cfsavecontent variable="onay_doc"><cf_get_lang no ='817.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
								<cfsavecontent variable="red_doc"><cf_get_lang no ='818.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Reddetmek istediğinizden emin misiniz'></cfsavecontent>
								<cfif session.ep.position_code eq get_assetp_demand.validator_pos_code>
									<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no='1063.'>" onClick="if (confirm('#onay_doc#')) {upd_assetp_demand.result_id.value='1'} else {return false}" border="0">
									<input type="Image" src="/images/refusal.gif" alt="<cf_get_lang_main no='1049.Reddet'>" onClick="if (confirm('#red_doc#')) {upd_assetp_demand.result_id.value='0'} else {return false}" border="0">
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</cfif>
		</cfform>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_assetp_demand">
	</cf_popup_box_footer>
</cf_popup_box>
