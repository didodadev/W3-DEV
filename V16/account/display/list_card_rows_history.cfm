<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="account">
<cf_xml_page_edit  fuseact="account.popup_list_card_rows">
<cfquery name="GET_CARD_ROWS" datasource="#dsn2#">
	SELECT
		ACR.BA,
		AC.CARD_HISTORY_ID,
		ACR.DETAIL,
		ACR.ACCOUNT_ID,
		ACR.IFRS_CODE,
		ACR.AMOUNT,
		ACR.AMOUNT_CURRENCY,
		ACR.AMOUNT_2,
		ACR.AMOUNT_CURRENCY_2,
		ACR.OTHER_AMOUNT,
		ACR.OTHER_CURRENCY,
		AC.ACTION_DATE,
		AC.BILL_NO,
		AC.CARD_DETAIL,
		AC.CARD_TYPE,
		AC.CARD_TYPE_NO,
		AC.IS_COMPOUND,
		AC.CARD_ID,
		AC.ACTION_TYPE,
		AC.ACTION_ID,
		AC.IS_OTHER_CURRENCY,
		AP.ACCOUNT_NAME,
		AC.RECORD_EMP,
        ACR.ACC_BRANCH_ID,
        ACR.ACC_DEPARTMENT_ID,
		ACR.ACC_PROJECT_ID,
		AC.RECORD_DATE
        <cfif session.ep.our_company_info.is_edefter eq 1>,
        CASE
            WHEN ACDP.DOCUMENT_TYPE_ID < 0 THEN ACDP.DETAIL
            ELSE ACDP.DOCUMENT_TYPE
        END AS DOCUMENT_TYPE,
        ACP.PAYMENT_TYPE
        </cfif>
	FROM
		ACCOUNT_CARD_ROWS_HISTORY ACR,
		ACCOUNT_CARD_HISTORY AC
        <cfif session.ep.our_company_info.is_edefter eq 1>
            LEFT JOIN #dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDP ON ACDP.DOCUMENT_TYPE_ID = AC.CARD_DOCUMENT_TYPE
            LEFT JOIN #dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACP ON ACP.PAYMENT_TYPE_ID = AC.CARD_PAYMENT_METHOD
        </cfif>,
		ACCOUNT_PLAN AP
	WHERE
	<cfif isDefined('attributes.action_id') and len(attributes.action_id) and attributes.action_id neq 0 and isdefined('attributes.action_type') and len(attributes.action_type)>
		ACTION_TYPE=#attributes.action_type#
		AND ACTION_ID=#attributes.action_id#
	<cfelseif isdefined('attributes.card_id') and len(attributes.card_id)>
		AC.CARD_ID=#attributes.card_id#
	</cfif>
		AND ACR.CARD_HISTORY_ID=AC.CARD_HISTORY_ID
		AND ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
	ORDER BY
		AC.CARD_HISTORY_ID DESC
</cfquery>
<cfset total_a=0>
<cfset total_b=0>
<cfset dep_id_list=''>
<cfset branch_id_list=''>
	<cfoutput query="get_card_rows">
		<cfif isdefined("ACC_DEPARTMENT_ID") and len(ACC_DEPARTMENT_ID) and not listfind(dep_id_list,ACC_DEPARTMENT_ID)>
		  <cfset dep_id_list=listappend(dep_id_list,ACC_DEPARTMENT_ID)>
		</cfif>
		<cfif isdefined("ACC_BRANCH_ID") and len(ACC_BRANCH_ID) and not listfind(branch_id_list,ACC_BRANCH_ID)>
			<cfset branch_id_list=listappend(branch_id_list,ACC_BRANCH_ID)>
		</cfif>
	</cfoutput>
	<cfif listlen(dep_id_list)>
		<cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
		<cfquery name="get_dep_detail" datasource="#dsn#">
			SELECT
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME
			FROM
				DEPARTMENT D,
				BRANCH B
			WHERE
				D.BRANCH_ID=B.BRANCH_ID
				AND D.DEPARTMENT_ID IN (#dep_id_list#)
			ORDER BY
				D.DEPARTMENT_ID
		</cfquery>
	</cfif>
	<cfif listlen(branch_id_list)>
		<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
		<cfquery name="GET_BRANCH" datasource="#dsn#">
			SELECT
				BRANCH_ID,
				BRANCH_NAME
			FROM
				BRANCH               
			WHERE
				BRANCH_ID IN (#branch_id_list#)
			ORDER BY 
				BRANCH_ID
		</cfquery>
	</cfif>
<cfsavecontent variable="head_">
	<cfif get_card_rows.currentrow eq 1 or get_card_rows.CARD_HISTORY_ID neq get_card_rows.CARD_HISTORY_ID[currentrow-1]>
		<cfoutput>
					<cfif get_card_rows.card_type eq 10>
					<cf_get_lang_main no='1344.Açılış Fişi'> 
					<cfelseif get_card_rows.card_type eq 11>
					<cf_get_lang_main no='1432.Tahsil Fişi'> 
					<cfelseif get_card_rows.card_type eq 12>
					<cf_get_lang_main no='1542.Tediye Fişi'> 
					<cfelseif get_card_rows.card_type eq 13>
					<cf_get_lang_main no='1040.Mahsup Fişi'> 
					<cfelseif get_card_rows.card_type eq 14>
					<cf_get_lang_main no='1638.Özel Fiş'> 
					</cfif>
					<cf_get_lang dictionary_id='57473.Tarihçe'>
					<cf_get_lang_main no='75.No'>:
					<cfif len(get_card_rows.card_type_no)>#get_card_rows.card_type_no#</cfif>
					- <cf_get_lang no='96.Yevmiye No'>: #get_card_rows.bill_no# - #dateformat(get_card_rows.action_date,dateformat_style)# 
                    </td>
		</cfoutput>
	</cfif>
</cfsavecontent>
<cf_box title="#head_#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif get_card_rows.recordcount>
		<cfoutput query="get_card_rows" group="CARD_HISTORY_ID">
			<div class="ui-info-text">
				<p class="bold">
					<cfif session.ep.our_company_info.is_edefter eq 1><cfif len(GET_CARD_ROWS.document_type)><cf_get_lang_main no ='1121.Belge Tipi'> : #GET_CARD_ROWS.document_type#</cfif><cfif len(GET_CARD_ROWS.payment_type)> - <cf_get_lang_main no ='2260.Ödeme Şekli'> : #GET_CARD_ROWS.payment_type#</cfif></cfif>
				</p>
			</div>
			<cf_flat_list>				
				<cfoutput>
					<cfif get_card_rows.currentrow eq 1 or get_card_rows.CARD_HISTORY_ID neq get_card_rows.CARD_HISTORY_ID[currentrow-1]>
						<cfset total_a=0><!--- her yeni guncelleme kaydında toplamlar sıfırlanıyor --->
						<cfset total_b=0>
						<thead>
							<tr>
								<th width="75"><cf_get_lang no='37.Hesap Kodu'></th>
								<th width="125"><cf_get_lang no='38.Hesap Adı'></th>
								<cfif session.ep.our_company_info.is_ifrs eq 1>
									<th width="75"><cf_get_lang_main no='718.UFRS Kod'></th>
								</cfif>
								<cfif isdefined('is_dsp_branch') and is_dsp_branch eq 1>
									<th><cf_get_lang_main no='41.Şube'></th>
								</cfif>
								<cfif isdefined('xml_acc_project_info') and xml_acc_project_info eq 1>
									<th><cf_get_lang_main no='4.Proje'></th>
								</cfif>
								<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><th><cf_get_lang_main no='160.Departman'></th></cfif>
								<th><cf_get_lang_main no='217.Açıklama'></th>
								<th width="90" style="text-align:right;"><cf_get_lang_main no='175.Borç'></th>
								<th width="90" style="text-align:right;"><cf_get_lang_main no='176.Alacak'></th>
								<th width="90" style="text-align:right;"><cf_get_lang no='123.Sistem 2Döviz'></th>
								<th width="90" style="text-align:right;"><cf_get_lang_main no='709.Islem Dovizi'></th>
								<th width="45"><cf_get_lang_main no='77.Para Br'></th>
							</tr>
						</thead>
					</cfif>
					<tbody>
						<tr>
							<td>
								<cfif ListLen(get_card_rows.account_id,'.') gt 0>
									<cfloop index="i" from="1" to="#ListLen(get_card_rows.account_id,'.')#">&nbsp;</cfloop>
								</cfif>
							#get_card_rows.account_id#
							</td>
							<td>#get_card_rows.account_name#</td>
							<cfif session.ep.our_company_info.is_ifrs eq 1>
							<td>#get_card_rows.ifrs_code#</td>
							</cfif>
							<cfif isdefined('is_dsp_branch') and is_dsp_branch eq 1>
								<td>
									<cfif len(get_card_rows.ACC_BRANCH_ID)>
										#get_branch.branch_name[listfind(branch_id_list,get_card_rows.ACC_BRANCH_ID,',')]#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined('xml_acc_project_info') and xml_acc_project_info eq 1>
								<td>
									<cfif len(get_card_rows.ACC_PROJECT_ID)>
										#get_project_name(get_card_rows.ACC_PROJECT_ID)#
									</cfif>
								</td>
							</cfif>
							<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
								<td>
									<cfif isdefined("ACC_DEPARTMENT_ID") and len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>
								</td>
							</cfif>
							<td>#get_card_rows.detail#</td>
							<td style="text-align:right;">&nbsp;<cfif get_card_rows.BA eq 0>#TLFormat(get_card_rows.amount)#<cfset total_a=total_a+amount></cfif></td>
							<td style="text-align:right;">&nbsp;<cfif get_card_rows.ba neq 0>#TLFormat(get_card_rows.amount)#<cfset total_b=total_b+amount></cfif></td>
							<cfif get_card_rows.is_other_currency eq 1>
								<td style="text-align:right;">&nbsp;#TLFormat(get_card_rows.AMOUNT_2)# #get_card_rows.amount_currency_2#</td>
								<td style="text-align:right;">&nbsp;#TLFormat(get_card_rows.other_amount)#</td>
								<td>&nbsp;#get_card_rows.other_currency#</td>
							<cfelse>
								<td style="text-align:right;">&nbsp;</td>
								<td style="text-align:right;">&nbsp;</td>
								<td style="text-align:right;">&nbsp;</td>
							</cfif>
						</tr>					
						<cfif get_card_rows.CARD_HISTORY_ID neq get_card_rows.CARD_HISTORY_ID[currentrow+1]>
							<tr>
								<cfset colspan_info = 3>
								<cfif session.ep.our_company_info.is_ifrs eq 1><cfset colspan_info = colspan_info + 1></cfif>
								<cfif isdefined('is_dsp_branch') and is_dsp_branch eq 1><cfset colspan_info = colspan_info + 1></cfif>
								<cfif isdefined('xml_acc_project_info') and xml_acc_project_info eq 1><cfset colspan_info = colspan_info + 1></cfif>
								<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><cfset colspan_info = colspan_info + 1></cfif>
								<td colspan="<cfoutput>#colspan_info#</cfoutput>" class="bold" ><cf_get_lang_main no='80.Toplam'></td>
								<td class="bold" style="text-align:right;"><cfoutput>#TLFormat(total_a)#</cfoutput></td>
								<td class="bold" style="text-align:right;"><cfoutput>#TLFormat(total_b)#</cfoutput></td>
								<cfif get_card_rows.is_other_currency eq 1>
									
									<cfquery name="GET_OTHER_MONEY_TOTALS" dbtype="query">
										SELECT
											SUM(OTHER_AMOUNT) OTHER_AMOUNT_TOPLAM,
											OTHER_CURRENCY,
											BA
										FROM
											GET_CARD_ROWS
										WHERE
											CARD_HISTORY_ID=#get_card_rows.CARD_HISTORY_ID#
										GROUP BY
											BA,
											OTHER_CURRENCY
									</cfquery>
									<cfloop query="GET_OTHER_MONEY_TOTALS">
										<td class="bold" style="text-align:right;">#TLFormat(other_amount_toplam)# #other_currency#<cfif ba eq 1>(A)<cfelse>(B)</cfif></td>
									</cfloop>
								<cfelse>
									<td colspan="3" class="bold">&nbsp;</td>
								</cfif>
							</tr>
						</cfif>
					</tbody>
				</cfoutput>
			</cf_flat_list>
			<cfoutput>
				<cfif get_card_rows.CARD_HISTORY_ID neq get_card_rows.CARD_HISTORY_ID[currentrow+1]>
					<div class="col col-12 ui-info-bottom">
						<cf_record_info query_name="get_card_rows">
					</div>
				</cfif>
			</cfoutput>
		</cfoutput>
	<cfelse>
		<table width="99%" border="0" cellspacing="1" cellpadding="2" align="center">
			<tr>
				<td height="25"><cf_get_lang_main no ='72.Kayıt Yok'>!</td>
			</tr>
		</table>
	</cfif>
</cf_box>

