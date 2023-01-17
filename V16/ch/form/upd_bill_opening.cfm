<cf_get_lang_set module_name="ch"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../../objects/query/get_acc_types.cfm">
	<cfif isdefined("attributes.employee_id")>
		<cfscript>
			attributes.acc_type_id = '';
			if(listlen(attributes.employee_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.employee_id,'_');
				attributes.emp_id = listfirst(attributes.employee_id,'_');
			}
			else
				attributes.emp_id = attributes.employee_id;
		</cfscript>
	</cfif>
	<cfquery name="GET_CARI_OPEN" datasource="#DSN#">
		SELECT  DISTINCT
				CR.ACTION_CURRENCY_ID,
				CR.CARI_ACTION_ID,
				CR.ACTION_NAME,
				CR.PROCESS_CAT, 
				CR.TO_CMP_ID, 
				CR.FROM_CMP_ID, 
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACTION_VALUE,
				CR.ACTION_NAME,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,
				CR.ACTION_VALUE_2,
				CR.ACTION_CURRENCY_2,
				C.FULLNAME,
				C.MEMBER_CODE,
				C.OZEL_KOD,
				CR.ACC_TYPE_ID,
				CR.PAPER_NO
			FROM 
				#dsn2_alias#.CARI_ROWS CR,
				COMPANY C
			WHERE
				CR.ACTION_TYPE_ID=40 AND
				(CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID) 
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
					AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
				</cfif>
				<cfif len (attributes.keyword)>
					AND  ACTION_NAME LIKE '#attributes.keyword#%'  
				</cfif>
		UNION ALL
			SELECT DISTINCT
				CR.ACTION_CURRENCY_ID,
				CR.CARI_ACTION_ID,
				CR.ACTION_NAME,
				CR.PROCESS_CAT, 
				CR.TO_CMP_ID, 
				CR.FROM_CMP_ID, 
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACTION_VALUE,
				CR.ACTION_NAME,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,
				CR.ACTION_VALUE_2,
				CR.ACTION_CURRENCY_2,
				<cfif database_type is "MSSQL">
					(CONS.CONSUMER_NAME + ' ' + CONSUMER_SURNAME) AS FULLNAME
				<cfelseif database_type is "DB2">
					(CONS.CONSUMER_NAME || ' ' || CONSUMER_SURNAME) AS FULLNAME
				</cfif>,
				CONS.MEMBER_CODE,
				CONS.OZEL_KOD,
				CR.ACC_TYPE_ID,
				CR.PAPER_NO
			FROM 
				#dsn2_alias#.CARI_ROWS CR,
				CONSUMER CONS
			WHERE
				CR.ACTION_TYPE_ID=40 AND
				(CR.FROM_CONSUMER_ID = CONS.CONSUMER_ID OR CR.TO_CONSUMER_ID = CONS.CONSUMER_ID)
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
				</cfif>
				<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
					AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
				</cfif>
				<cfif isdefined("attributes.keyword")and len (attributes.keyword)>
					AND  ACTION_NAME LIKE '#attributes.keyword#%' 
				</cfif>
				<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
					AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
				</cfif>
		UNION ALL
				SELECT DISTINCT
					CR.ACTION_CURRENCY_ID,
					CR.CARI_ACTION_ID,
					CR.ACTION_NAME,
					CR.PROCESS_CAT, 
					CR.TO_CMP_ID, 
					CR.FROM_CMP_ID, 
					CR.TO_CONSUMER_ID,
					CR.FROM_CONSUMER_ID,
					CR.TO_EMPLOYEE_ID,
					CR.FROM_EMPLOYEE_ID,
					CR.ACTION_VALUE,
					CR.ACTION_NAME,
					CR.OTHER_CASH_ACT_VALUE,
					CR.OTHER_MONEY,
					CR.ACTION_VALUE_2,
					CR.ACTION_CURRENCY_2,
					<cfif database_type is "MSSQL">
						(EMP.EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME) AS FULLNAME
					<cfelseif database_type is "DB2">
						(EMP.EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME) AS FULLNAME
					</cfif>,
					EMP.EMPLOYEE_NO MEMBER_CODE,
					EMP.OZEL_KOD,
					CR.ACC_TYPE_ID,
					CR.PAPER_NO
				FROM 
					#dsn2_alias#.CARI_ROWS CR,
					EMPLOYEES EMP
				WHERE
					CR.ACTION_TYPE_ID=40 AND
					(CR.FROM_EMPLOYEE_ID = EMP.EMPLOYEE_ID OR CR.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID)
					<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
						AND #control_acc_type_list#
					</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
						AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
						AND ( TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
					</cfif>
					<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
						AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
					</cfif>
					<cfif len (attributes.keyword)>
						AND  ACTION_NAME LIKE '#attributes.keyword#%'  
					</cfif>
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
					</cfif>
		ORDER BY
			FULLNAME
	</cfquery>
<cfelse>
	<cfset get_cari_open.recordcount=0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfparam name="attributes.totalrecords" default="#get_cari_open.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_bill" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_account_open">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search more="0"> 
				<div class ="form-group">
					<cfinput type="text" name="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class ="form-group">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
						<input name="company_name" type="text" id="company_name" placeholder=<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput> style="width:120px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');"  value="<cfif ((isDefined("attributes.company_name") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) and len(attributes.company_name))><cfoutput>#attributes.company_name#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=add_bill.company_name&field_comp_name=add_bill.company_name&field_consumer=add_bill.consumer_id&field_comp_id=add_bill.company_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list');"></span>				
					</div>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee_name" id="employee_name" placeholder=<cfoutput>#getLang(164,'Çalışan',57576)#</cfoutput> value="<cfif isDefined("attributes.employee_name") and len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>"  onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','EMPLOYEE_ID','employee_id','','3','225');"style="width:110px;">
						<span class="input-group-addon icon-ellipsis btnPointer"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_cari_action=1&field_emp_id=add_bill.employee_id&field_name=add_bill.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.add_bill.employee_name.value),'list');return false"></span>
					</div>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4"> 
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

	<cf_box title="#getLang(1344,'Açılış Fişi',58756)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57652.Hesap'></th>
					<th><cf_get_lang dictionary_id='50167.Cari Kod'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57587.Borç'></th>
					<th><cf_get_lang dictionary_id='57588.Alacak'></th>
					<th><cf_get_lang dictionary_id='50166.İşlem Dovizi'></th>
					<th><cf_get_lang dictionary_id="33780.2."><cf_get_lang dictionary_id='57677.Döviz'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ch.form_upd_account_open&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
					<cfset borc_toplam = 0>
					<cfset alacak_toplam = 0>
					<cfif isdefined("attributes.is_submitted") and get_cari_open.recordcount>
					<cfset acc_type_id_list = ''>
					<cfoutput query="get_cari_open" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif not listfind(acc_type_id_list,acc_type_id) and acc_type_id neq 0>
							<cfset acc_type_id_list = listappend(acc_type_id_list,acc_type_id)>
						</cfif>	
					</cfoutput>	
					<cfif len(acc_type_id_list)>
						<cfset acc_type_id_list=listsort(acc_type_id_list,"numeric","ASC",",")>
						<cfquery name="get_ch_type" datasource="#dsn#">
							SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID IN (#acc_type_id_list#) ORDER BY ACC_TYPE_ID
						</cfquery>
						<cfset acc_type_id_list = listsort(listdeleteduplicates(valuelist(get_ch_type.ACC_TYPE_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_cari_open" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(to_cmp_id)>
						<cfset my_company_id = to_cmp_id>
					<cfelseif len(from_cmp_id)>
						<cfset my_company_id = from_cmp_id>
					<cfelse>
						<cfset my_company_id = "">
					</cfif>
					<cfif len(to_consumer_id)>
						<cfset my_consumer_id = to_consumer_id>
					<cfelseif len(from_consumer_id)>	
						<cfset my_consumer_id = from_consumer_id>
					<cfelse>
						<cfset my_consumer_id = "">
					</cfif>
					<cfif len(to_employee_id)>
						<cfset my_employee_id = to_employee_id>
					<cfelseif len(from_employee_id)>	
						<cfset my_employee_id = from_employee_id>
					<cfelse>
						<cfset my_employee_id = "">
					</cfif>
					<tr>
						<td width="20">#currentrow#</td>
						<td><cfif len(my_company_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#my_company_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#FULLNAME#</a> 
							<cfelseif len(my_consumer_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#my_consumer_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#FULLNAME#</a>
							<cfelseif len(my_employee_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#my_employee_id#','medium');">#FULLNAME#</a>
							</cfif>
							<cfif len(acc_type_id) and acc_type_id neq 0 and len(my_employee_id)>-#get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#</cfif>
						</td>
						<td>#MEMBER_CODE#</td>
						<td>#OZEL_KOD#</td>
						<td>#PAPER_NO#</td>
						<td>#ACTION_NAME#</td>
						<td style="text-align:right;"><cfif len(to_cmp_id) or len(to_consumer_id) or len(to_employee_id)>#TLFormat(action_value,2)#<cfset borc_toplam = borc_toplam + action_value><cfelse>#TLFormat(0,2)#</cfif></td>
						<td style="text-align:right;"><cfif len(from_cmp_id) or len(from_consumer_id) or len(from_employee_id)>#TLFormat(action_value,2)#<cfset alacak_toplam = alacak_toplam + action_value><cfelse>#TLFormat(0,2)#</cfif></td>
						<td style="text-align:right;"><cfif len(OTHER_CASH_ACT_VALUE) and OTHER_CASH_ACT_VALUE neq 0>#TLFormat(OTHER_CASH_ACT_VALUE,2)# #OTHER_MONEY#<cfelse>#TLFormat(0,2)#</cfif></td>
						<td style="text-align:right;"><cfif len(action_value_2) and action_value_2 neq 0>#TLFormat(action_value_2)# #action_currency_2#</cfif></td>
						<!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ch.form_upd_account_open&event=upd&cari_act_id=#CARI_ACTION_ID#&comp_id=#my_company_id#&cons_id=#my_consumer_id#&emp_id=#my_employee_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
					</tr>
					</cfoutput>
			</tbody>
			<tfoot>
				<cfoutput>
					<tr>
						<td class="txtbold" colspan="6"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td class="txtbold" style="text-align:right;">#TLFormat(borc_toplam)#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(alacak_toplam)#</td>
						<td class="txtbold" colspan="2" style="text-align:right;">
							<cf_get_lang dictionary_id='57589.Bakiye'> : <cfset son_toplam = borc_toplam - alacak_toplam>#TLFormat(abs(son_toplam))# <cfif son_toplam gt 0>(B)<cfelse>(A)</cfif> 
						</td>
						<td></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</tfoot></cfif>
			
		</cf_grid_list>

		<cfset url_str = "&is_submitted=1">
		<cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
			<cfset url_str = '#url_str#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
			<cfset url_str = '#url_str#&employee_name=#attributes.employee_name#'>
		</cfif>
		<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
			<cfset url_str = '#url_str#&company_id=#attributes.company_id#'>
		</cfif>
		<cfif isDefined('attributes.company_name') and len(attributes.company_name)>
			<cfset url_str = '#url_str#&company_name=#attributes.company_name#'>
		</cfif>
		<cfif isDefined('attributes.keyword') and len (attributes.keyword)>
			<cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#listgetat(attributes.fuseaction,1,'.')#.form_upd_account_open#url_str#">
	</cf_box>
</div>

	<script type="text/javascript">
		document.getElementById('keyword').focus();
	</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
