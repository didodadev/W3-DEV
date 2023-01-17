<!--- Borc Alacak Dokumu Ozel Listeleme Printi --->
<cfif not isdefined("attributes.money_type_info") or not len(attributes.money_type_info)>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='33291.Şablonu Görüntüleyebilmek İçin İşlem Dövizi ve Para Birimi Seçmelisiniz'>!");
	</script>
	<cfabort>
</cfif>
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.money_info" default="">
<cfparam name="attributes.due_info" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.vade_dev" default="">
<cfparam name="attributes.comp_status" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.vade_borc_ara_toplam" default="0">
<cfparam name="attributes.vade_alacak_ara_toplam" default="0">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.is_pay_cheques" default="1">
<cfset print_order_money_info = 1>
<cfinclude template="/V16/ch/query/get_member.cfm">
<cfset company_list = "">
<cfset consumer_list = "">
<cfif get_member.recordcount>
	<cfoutput query="get_member">
		<cfif kontrol eq 0 and Len(member_id) and not ListFind(company_list,member_id,',')>
			<cfset company_list = ListAppend(company_list,member_id,',')>
		</cfif>
		<cfif kontrol eq 1 and Len(member_id) and not ListFind(consumer_list,member_id,',')>
			<cfset consumer_list = ListAppend(consumer_list,member_id,',')>
		</cfif>
	</cfoutput>
	<cfif Len(company_list)>
		<cfquery name="get_member_info_COMP" datasource="#dsn#">
			SELECT
				COMPANY_ID MEMBER_ID,
				FULLNAME MEMBER_NAME,
				(SELECT POSITION_CODE FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID = COMPANY.COMPANY_ID AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id#) TEMSILCI_POS_CODE
			FROM
				COMPANY
			WHERE 
				COMPANY_ID IN (#company_list#)
			ORDER BY
				MEMBER_ID
		</cfquery>
		<cfset company_list = ListSort(ListDeleteDuplicates(ValueList(get_member_info_COMP.member_id,',')),"numeric","asc",",")>
	</cfif>
	<cfif Len(consumer_list)>
		<cfquery name="get_member_info_CONS" datasource="#dsn#">
			SELECT
				CONSUMER_ID MEMBER_ID,
				(SELECT POSITION_CODE FROM WORKGROUP_EMP_PAR WHERE CONSUMER_ID = CONSUMER.CONSUMER_ID AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id#) TEMSILCI_POS_CODE
			FROM
				CONSUMER
			WHERE 
				CONSUMER_ID IN (#consumer_list#)
			ORDER BY
				MEMBER_ID
		</cfquery>
		<cfset consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_member_info_CONS.member_id,',')),"numeric","asc",",")>
	</cfif>
</cfif> 

<cfquery name="get_our_company_info" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id# 
</cfquery>

<cfset start_row = 1>
<cfset end_row = 45>
<cfset page_count = ceiling(get_member.recordcount / 45)>
<cfif page_count eq 0>
	<cfset page_count = 1>
</cfif>

<cfset devreden_bakiye3_ = 0>
<cfset devreden_cheque_voucher_value3_ = 0>
<cfset devreden_toplam_bakiye3_ = 0>
<cfset money_ = "">
<style>table,td{font-size:10px;font-family:Arial, Helvetica, sans-serif;}</style>
<cfset project_id_list = ''>
<cfoutput query="get_member">
	<cfif not listfind(project_id_list,project_id)>
		<cfset project_id_list = listappend(project_id_list,project_id)>
	</cfif>	
</cfoutput>
<cfif len(project_id_list)>
	<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
	<cfquery name="get_pro_name" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
</cfif>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" style="width:200mm;height:293mm;"><!--- height:177mm; --->
	<tr valign="top" align="left">
		<td style="width:1mm;" rowspan="60">&nbsp;<!--- Soldan bosluk (def:7mm) ---></td>
		<td style="height:5mm;">&nbsp;<!--- Üstten Bosluk (def:7mm) ---></td>
	</tr>
	<tr valign="top">
		<td align="left">
		<table border="0" cellpadding="0" cellspacing="0" width="99%">
			<tr>
				<td valign="top" align="left">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td style="width:10mm;">&nbsp;</td>
						<!-- sil --><td style="width:60mm;"><cfif len(get_our_company_info.asset_file_name3)><img src="#file_web_path#settings/#get_our_company_info.asset_file_name3#"></cfif></td><!-- sil -->
						<td><strong><big><cf_get_lang no="902.BORÇ ALACAK DÖKÜMÜ"></big></strong></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
				<table border="0">
					<tr style="height:10mm;">
						<td>&nbsp;</td>
						<td colspan="2"><cf_get_lang_main no="330.Tarih">: #DateFormat(now(),dateformat_style)#</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr class="txtbold" height="30">
						<td align="center"><cf_get_lang_main no="75.NO"></td>
						<td><cf_get_lang_main no="107.CARİ HESAP"></td>
						<td><cf_get_lang_main no="1383.MÜŞTERİ TEMSİLCİSİ"></td>
						<cfif isdefined("attributes.is_project_group")>
							<td><cf_get_lang_main no="4.PROJE"></td>
						</cfif>
						<td style="text-align:right;"><cf_get_lang_main no="177.BAKİYE"></td>
						<td style="text-align:right;"><cf_get_lang no="903.ÖDENMEMİŞ MÜŞTERİ"> <br /><cf_get_lang_main no="110.ÇEK/SENET"></td>
						<td style="text-align:right;"><cf_get_lang no="904.ÖDENMEMİŞ  CARİ"> <br /><cf_get_lang_main no="110.ÇEK/SENET"></td>
						<td style="text-align:right;"><cf_get_lang no="905.TOPLAM BAKİYE"></td>
					</tr>
					<cfset a_ = 0>
					<cfset a_bakiye = 0>
					<cfset a_cheque_bakiye = 0>
					<cfset a_cheque_bakiye2 = 0>
					<cfset a_total_bakiye = 0>
					<cfset b_ = 0>
					<cfset b_bakiye = 0>
					<cfset b_cheque_bakiye = 0>
					<cfset b_cheque_bakiye2 = 0>
					<cfset b_total_bakiye = 0>
					<cfloop query="get_member">
						<tr valign="top">
							<td style="width:10mm;" align="center">#currentrow#</td>
							<td style="width:40mm;">#left(fullname,22)#</td>
							<td style="width:30mm;">
								<cfif Len(member_id) and get_member.kontrol eq 0>#get_emp_info(get_member_info_COMP.temsilci_pos_code[ListFind(company_list,member_id,',')],1,0)#</cfif>
								<cfif Len(member_id) and get_member.kontrol eq 1>#get_emp_info(get_member_info_CONS.temsilci_pos_code[ListFind(consumer_list,member_id,',')],1,0)#</cfif>
							</td>
							<cfif isdefined("attributes.is_project_group")>
								<td style="width:30mm;">
									<cfif len(project_id_list) and project_id gt 0>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif>
								</td>
							</cfif>
							<td style="width:35mm;" style="text-align:right;">#TLFormat(Abs(bakiye3))# #other_money# <cfif bakiye3 lt 0>(A)<cfelse>(B)</cfif></td>
							<td style="width:35mm;" style="text-align:right;">#TLFormat(Abs(cheque_voucher_value_other3))# #other_money# <cfif cheque_voucher_value_other3 lt 0>(A)<cfelse>(B)</cfif></td>
							<td style="width:35mm;" style="text-align:right;">#TLFormat(Abs(cheque_voucher_value_ch3))# #other_money# <cfif cheque_voucher_value_ch3 lt 0>(A)<cfelse>(B)</cfif></td>
							<td style="width:35mm;" style="text-align:right;">#TLFormat(Abs(bakiye3+cheque_voucher_value3))# #other_money# <cfif bakiye3+cheque_voucher_value3 lt 0>(A)<cfelse>(B)</cfif></td>
						</tr>
						<cfif bakiye3 lt 0>
							<cfset a_bakiye = a_bakiye + bakiye3>
							<cfset a_cheque_bakiye = a_cheque_bakiye + cheque_voucher_value_ch3>
							<cfset a_cheque_bakiye2 = a_cheque_bakiye2 + cheque_voucher_value_other3>
							<cfset a_total_bakiye = a_total_bakiye + bakiye3+cheque_voucher_value3>
						<cfelse>
							<cfset b_bakiye = b_bakiye + bakiye3>
							<cfset b_cheque_bakiye = b_cheque_bakiye + cheque_voucher_value_ch3>
							<cfset b_cheque_bakiye2 = b_cheque_bakiye2 + cheque_voucher_value_other3>
							<cfset b_total_bakiye = b_total_bakiye + bakiye3+cheque_voucher_value3>
						</cfif>
						<cfif ((bakiye3[currentrow] gt 0 and bakiye3[currentrow+1] lte 0) or (currentrow eq recordcount))>
						<tr>
							<cfif isdefined("attributes.is_project_group")>
								<td colspan="8"><hr></td>
							<cfelse>
								<td colspan="7"><hr></td>
							</cfif>
						</tr>
						<tr class="formbold" valign="top" style="height:6mm;">
							<cfif isdefined("attributes.is_project_group")>
								<td colspan="3">&nbsp;</td>
							<cfelse>
								<td colspan="2">&nbsp;</td>
							</cfif>
							<td>TOPLAM</td>
							<cfif (bakiye3[currentrow] gt 0 and bakiye3[currentrow+1] lte 0)>
								<td style="text-align:right;">#TLFormat(Abs(b_bakiye))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(b_cheque_bakiye2))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(b_cheque_bakiye))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(b_total_bakiye))# #money_#</td>
							<cfelse>
								<td style="text-align:right;">#TLFormat(Abs(a_bakiye))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(a_cheque_bakiye2))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(a_cheque_bakiye))# #money_#</td>
								<td style="text-align:right;">#TLFormat(Abs(a_total_bakiye))# #money_#</td>
							</cfif>
						</tr>
						</cfif>
						
						<cfset devreden_bakiye3_ = devreden_bakiye3_ + bakiye3>
						<cfset devreden_cheque_voucher_value3_ = devreden_cheque_voucher_value3_ + cheque_voucher_value3>
						<cfset devreden_toplam_bakiye3_ = devreden_toplam_bakiye3_ + (bakiye3+cheque_voucher_value3)>
						<cfset money_ = other_money>
					</cfloop>
					
					<!--- <tr class="formbold">
						<td colspan="2">&nbsp;</td>
						<td>TOPLAM</td>
						<td style="text-align:right;">#TLFormat(devreden_bakiye3_)# #money_#<cfif devreden_bakiye3_ lt 0>(A)<cfelse>(B)</cfif></td>
						<td style="text-align:right;">#TLFormat(devreden_cheque_voucher_value3_)# #money_#<cfif devreden_cheque_voucher_value3_ lt 0>(A)<cfelse>(B)</cfif></td>
						<td style="text-align:right;">#TLFormat(devreden_toplam_bakiye3_)# #money_#<cfif devreden_toplam_bakiye3_ lt 0>(A)<cfelse>(B)</cfif></td>
					</tr> --->
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</cfoutput>
