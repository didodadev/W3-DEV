<!---  
	FBS 20080608 CRM Eczanelerde Anlasmalarin tarihcelerini goruntuler
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_branch_contracts_history&contract_id=#attributes.contract_id#</cfoutput>','list','popup_branch_contracts_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
 --->
<cfquery name="get_contract_history" datasource="#dsn#"><!--- anlasmalar --->
	SELECT 
		CONTRACT_HISTORY_ID, 
		CONTRACT_ID, 
		IS_ACTIVE, 
		COMPANY_ID, 
		BRANCH_ID, 
		RELATED_ID, 
		CUSTOMER_TYPE_ID, 
		PROCESS_CAT, 
		CONTRACT_DATE, 
		START_DATE, 
		FINISH_DATE, 
		RESTRICT_RATE, 
		CONTROL_METHOD_ID,
		MONTHLY_CAPACITY, 
		MONTHLY_ENDORSEMENT,
		CUSTOMER_TYPE_DETAIL, 
		DETAIL, 
		RECORD_DATE,
		RECORD_EMP, 
		RECORD_IP 
	FROM 
		COMPANY_BRANCH_CONTRACT_HISTORY 
	WHERE 
		CONTRACT_ID = #contract_id# 
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
<cfquery name="get_contract_row_history_main" datasource="#dsn#"><!--- anlasma satirlari (hizmetler) --->
	SELECT 
		CONTRACT_HISTORY_ID, 
		CONTRACT_ID, 
		DUTY_TYPE_ID, 
		IS_VALUE, 
		COST_AMOUNT, 
		IS_TARGET, 
		TARGET_PERIOD_ID, 
		TARGET_AMOUNT, 
		IS_CATEGORY 
	FROM 
		COMPANY_BRANCH_CONTRACT_ROW_HISTORY 
	WHERE 
		CONTRACT_HISTORY_ID IN (SELECT CONTRACT_HISTORY_ID FROM COMPANY_BRANCH_CONTRACT_HISTORY CBCH WHERE CONTRACT_ID = #contract_id#)
</cfquery>

<cfset duty_type_list = "">
<cfquery name="get_duty_type" datasource="#dsn#"><!--- hizmet tipleri --->
	SELECT 
		DUTY_TYPE_ID, 
		DUTY_TYPE, 
		IS_ACTIVE, 
		IS_TARGET, 
		IS_CATEGORY, 
		COST_AMOUNT, 
		CUSTOMER_TYPE_ID, 
		DETAIL, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP, 
		IS_VALUE 
	FROM 
		SETUP_DUTY_TYPE 
	ORDER BY 
		DUTY_TYPE_ID
</cfquery>
<cfset duty_type_list = listsort(listdeleteduplicates(valuelist(get_duty_type.duty_type_id,',')),"numeric","ASC",",")>

<table width="100%" height="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang_main no='61.Tarihçe'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
			<table width="100%" align="left" border="0">
				<cfif get_contract_history.recordcount>
					<tr class="txtboldblue">
						<td><cf_get_lang no='269.Hizmetler'></td>
						<td><cf_get_lang_main no='344.Durum'></td>
						<td><cf_get_lang_main no='1447.Süreç'></td>
						<td><cf_get_lang no='302.Anl Tar'></td>
						<td align="center"><cf_get_lang no='274.Baş - Bit Tar'></td>
						<td><cf_get_lang no='308.M A M O'></td>
						<td><cf_get_lang no='311.Ciro Kont Yönt'></td>
						<td  style="text-align:right;"><cf_get_lang no='312.Aylık A K '></td>
						<td  style="text-align:right;"><cf_get_lang no='313.H A  Ciro'></td>
						<td><cf_get_lang_main no='217.Açıklama'></td>
						<td><cf_get_lang no='71.Kayıt'></td>
					</tr>
					<cfset process_stage_list = "">
					<cfset customer_type_list = "">
					<cfset contract_histrow_list = "">
					<cfoutput query="get_contract_history">
						<cfif len(process_cat) and not listfind(process_stage_list,process_cat)>
							<cfset process_stage_list=listappend(process_stage_list,process_cat)>
						</cfif>
					</cfoutput>
					<cfif len(process_stage_list)>
						<cfset process_stage_list = listsort(process_stage_list,'numeric','ASC',',')>
						<cfquery name="get_process_stage" datasource="#dsn#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset process_stage_list = listsort(listdeleteduplicates(valuelist(get_process_stage.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_contract_history">
						<tr>
							<td><a href="javascript:gizle_goster(customer_types#currentrow#);"><u><i>Hizmetler</i></u></a></td>
							<td><cfif is_active eq 1>Aktif<cfelse>Pasif</cfif></td>
							<td>#get_process_stage.stage[listfind(process_stage_list,process_cat,',')]#</td>
							<td>#DateFormat(contract_date,dateformat_style)#</td>
							<td align="center">#DateFormat(start_date,dateformat_style)# - #Dateformat(finish_date,dateformat_style)#</td>
							<td align="center">#restrict_rate#</td>
							<td><cfif control_method_id eq 1>KDV Beyannamesi<cfelse>Reçete Tutarı</cfif></td>
							<td  style="text-align:right;">#monthly_capacity#&nbsp;&nbsp;</td>
							<td  style="text-align:right;">#monthly_endorsement#&nbsp;&nbsp;</td>
							<td>#detail#</td>
							<td>#get_emp_info(record_emp,0,0)#- #DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
						</tr>
						<cfquery dbtype="query" name="get_contract_row_history">
							SELECT * FROM get_contract_row_history_main WHERE CONTRACT_HISTORY_ID = #contract_history_id#
						</cfquery>
						<tr id="customer_types#currentrow#" style="display:none;">
							<td>&nbsp;</td>
							<td colspan="9">
								<table align="left" border="0">
									<tr>
										<td colspan="3" class="formbold" align="center"><u><cf_get_lang no='330.Standart Hizmetler'></u></td>
										<td>&nbsp;</td>
									</tr>
									<tr class="txtboldblue">
										<td width="90"><cf_get_lang no='381.Hizmet Tipi'></td>
										<td width="90"  style="text-align:right;"><cf_get_lang no='437.Değer'></td>
										<td width="95"  style="text-align:right;"><cf_get_lang no='388.Hedef Tutarı'></td>
										<td width="95">&nbsp;</td>
									</tr>
									<cfloop query="get_contract_row_history">
										<cfif is_category eq 0>
										<tr valign="top">
											<td>#get_duty_type.duty_type[listfind(duty_type_list,duty_type_id,',')]#</td>
											<td  style="text-align:right;"><cfif is_value eq 1>#TLFormat(cost_amount)#<cfelseif is_value eq 0 and is_category eq 0>#TLFormat(cost_amount)#<cfelse>&nbsp;</cfif></td>
											<td  style="text-align:right;">#TLFormat(target_amount)#</td>
											<td>&nbsp;</td>
										</tr>
										</cfif>
									</cfloop>
								</table>
								<table align="left" border="0">
									<tr>
										<td colspan="4" class="formbold" align="center"><u><cf_get_lang no='435.Ek Hizmetler'></u></td>
									</tr>
									<tr class="txtboldblue">
										<td width="95"><cf_get_lang no='381.Hizmet Tipi'></td>
										<td width="95"  style="text-align:right;"><cf_get_lang no='437.Değer'></td>
										<td width="95"  style="text-align:right;"><cf_get_lang no='388.Hedef Tutarı'></td>
									</tr>
									<cfloop query="get_contract_row_history">
										<cfif is_category eq 1>
										<tr valign="top">
											<td>#get_duty_type.duty_type[listfind(duty_type_list,duty_type_id,',')]#</td>
											<td  style="text-align:right;"><cfif is_value eq 1>#TLFormat(cost_amount)#<cfelseif is_value eq 0 and is_category eq 0>#TLFormat(cost_amount)#<cfelse>&nbsp;</cfif></td>
											<td  style="text-align:right;">#TLFormat(target_amount)#</td>
										</tr>
										</cfif>
									</cfloop>
								</table>
							</td>
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
