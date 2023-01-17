<cfset borc_toplam = 0>
<cfset alacak_toplam = 0>
<cfset card_row_id=get_account_rows_main.card_row_id>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_account_rows_main.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_account_rows_main.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfform name="form_excel" action="#request.self#?fuseaction=#attributes.fuseaction#&card_id=#attributes.card_id#" method="post">
	<cf_box>
			<cf_box_footer>
				<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
				<cf_workcube_buttons is_upd='0' is_cancel='0' type_format='1'>
			</cf_box_footer>
	</cf_box>
</cfform>
<cfsavecontent  variable="fisler"><cf_get_lang dictionary_id='47304.Fişler'></cfsavecontent>
<cf_box title="#fisler#" uidrop="1" hide_table_column="1" scroll="1">
	<cf_grid_list>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset type_ = 1>
		<cfelse>
			<cfset type_ = 0>
		</cfif>
		<thead >
			<tr>
				<th width="100"><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
				<cfif session.ep.our_company_info.is_ifrs eq 1>
					<th width="70"><cf_get_lang dictionary_id='58130.UFRS Kod'></th>
					<th width="70"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
				</cfif>
				<th width="150"><cf_get_lang dictionary_id='57897.Adı'></th>
				<th width="200"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<cfif xml_acc_branch_info eq 1>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
				</cfif>
				<cfif xml_acc_department_info eq 1>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
				</cfif>
				<cfif xml_acc_project_info eq 1>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
				</cfif>
				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
				<th width="125" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='47429.Diğer Tutar'></th>
				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
				<!-- sil -->
				<cfif type_ neq 1>
					<th width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_add_account_open_row&card_id=#attributes.card_id#</cfoutput>');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='57582.Ekle'>" title="<cf_get_lang dictionary_id ='57582.Ekle'>" align="absbottom" border="0"></a></th>
				</cfif>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif isdefined('get_account_rows_main') and get_account_rows_main.recordcount neq 0>
				<cfset branch_id_list=''>
				<cfset dep_id_list=''>
				<cfset project_id_list = ''>
				<cfoutput query="get_account_rows_main">
					<cfif len(ACC_BRANCH_ID) and not listfind(branch_id_list,ACC_BRANCH_ID)>
						<cfset branch_id_list=listappend(branch_id_list,ACC_BRANCH_ID)>
					</cfif>
					<cfif len(ACC_DEPARTMENT_ID) and not listfind(dep_id_list,ACC_DEPARTMENT_ID)>
						<cfset dep_id_list=listappend(dep_id_list,ACC_DEPARTMENT_ID)>
					</cfif>
					<cfif len(ACC_PROJECT_ID) and not listfind(project_id_list,ACC_PROJECT_ID)>
						<cfset project_id_list=listappend(project_id_list,ACC_PROJECT_ID)>
					</cfif>
				</cfoutput>
				<cfif xml_acc_branch_info eq 1>
					<cfif len(branch_id_list)>
						<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
						<cfquery name="GET_BRANCH" datasource="#dsn#">
							SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
						</cfquery>
					</cfif>
				</cfif>
				<cfif xml_acc_department_info eq 1>
					<cfif len(dep_id_list)>
						<cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
						<cfquery name="get_dep_detail" datasource="#dsn#">
							SELECT D.DEPARTMENT_HEAD, B.BRANCH_NAME FROM DEPARTMENT D, BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND D.DEPARTMENT_ID IN (#dep_id_list#) ORDER BY D.DEPARTMENT_ID
						</cfquery>
					</cfif>
				</cfif>
				<cfif xml_acc_project_info eq 1>
					<cfif len(project_id_list)>
						<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
						<cfquery name="get_pro_detail" datasource="#dsn#">
							SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
						</cfquery>
					</cfif>
				</cfif>
				<cfoutput query="get_account_rows_main" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr> 
						<td style="text-align:right;">#ACCOUNT_ID#</td>
						<cfif session.ep.our_company_info.is_ifrs eq 1>
						<td>#IFRS_CODE#</td>
						<td>#ACCOUNT_CODE2#</td>
						</cfif>
						<td>#ACCOUNT_NAME#</td>
						<td>#DETAIL#</td>
						<cfif xml_acc_branch_info eq 1>
							<td><cfif len(ACC_BRANCH_ID)>#get_branch.branch_name[listfind(branch_id_list,acc_branch_id,',')]#</cfif></td>
						</cfif>
						<cfif xml_acc_department_info eq 1>
							<td><cfif len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif></td>
						</cfif>
						<cfif xml_acc_project_info eq 1>
							<td><cfif len(ACC_PROJECT_ID)>#get_pro_detail.PROJECT_HEAD[listfind(project_id_list,ACC_PROJECT_ID,',')]#</cfif></td>
						</cfif>
						<td style="text-align:right;">#TLFormat(quantity)#</td>
						<td style="text-align:right;"><cfif BA eq 0>#TLFormat(AMOUNT)#<cfset borc_toplam = borc_toplam + AMOUNT></cfif></td>
						<td style="text-align:right;"><cfif BA eq 1>#TLFormat(AMOUNT)#<cfset alacak_toplam = alacak_toplam + AMOUNT></cfif></td>
						<td style="text-align:right;">#TLFormat(OTHER_AMOUNT)# #OTHER_CURRENCY#</td>
						<td style="text-align:right;">#TLFormat(AMOUNT_2)# #AMOUNT_CURRENCY_2#</td>
						<!-- sil -->
						<cfif type_ neq 1>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=account.popup_upd_account_open_row&acc_code=#ACCOUNT_ID#&card_id=#attributes.card_id#&card_row_id=#card_row_id#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" align="absbottom" border="0"></a></td>
						</cfif>
						<!-- sil -->
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
		<tfoot>
			<cfoutput>
				<cfif session.ep.our_company_info.is_ifrs eq 1><cfset colspan_info = 6><cfelse><cfset colspan_info = 4></cfif>
				<cfif xml_acc_branch_info eq 1>
					<cfset colspan_info = colspan_info+1>
				</cfif>
				<cfif xml_acc_department_info eq 1>
					<cfset colspan_info = colspan_info+1>
				</cfif>
				<cfif xml_acc_project_info eq 1>
					<cfset colspan_info = colspan_info+1>
				</cfif>
				<tr> 
					<td colspan="#colspan_info#" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
					<td style="text-align:right;">#TLFormat(borc_toplam)#</td>
					<td style="text-align:right;">#TLFormat(alacak_toplam)#</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					
				</tr>
				<tr> 
					<td colspan="#colspan_info#" style="text-align:right;"><cf_get_lang dictionary_id ='57644.Son Toplam'></td>
					<td nowrap="nowrap" style="text-align:right;">
						<cfset son_toplam = borc_toplam - alacak_toplam>
						#TLFormat(abs(son_toplam))# <cfif son_toplam gt 0>(B)<cfelse>(A)</cfif> 
					</td>
					<td style="text-align:right;"></td>
					<td>&nbsp;</td>
					
					<!-- sil -->
					<cfif type_ neq 1>
						<td>&nbsp;</td>
					</cfif>
					<!-- sil -->
				</tr>
			</cfoutput>
		</tfoot>
	</cf_grid_list>
	<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="account.form_upd_bill_opening&var_=opening_card&CARD_ID=#attributes.card_id#">
</cf_box>
	

