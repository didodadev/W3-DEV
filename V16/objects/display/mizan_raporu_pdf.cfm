<cfset row_count = 55>
<cfset satir_say = 0>
<cfset page_count = 0>
<cfdocument format="pdf" orientation="portrait" localUrl="yes" backgroundvisible="false" pagetype="a4" marginleft="0" marginright="0">
<cfset filename1 = "#createuuid()#">
<cfheader name="Content-Disposition" value="attachment; filename=#filename1#.pdf">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
	<table cellSpacing="1" cellpadding="2" border="0" width="98%" align="center" class="color-border">
        <cfset colspan_ = 2>
        <cfif isdefined('attributes.is_acc_department_based')><cfset colspan_ = colspan_+1></cfif>
		<cfif isdefined('attributes.is_cost_profit_center_based')><cfset colspan_ = colspan_+1></cfif>
		<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1><cfset colspan_ = colspan_+4></cfif>
        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1><cfset colspan_ = colspan_+4></cfif>
		<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1><cfset colspan_ = colspan_+4></cfif>
		<tr valign="top">
			<td colspan="<cfoutput>#colspan_#</cfoutput>" style="text-align:center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
		</tr>
		<tr class="color-row">
			<cfset satir_say = satir_say + 1>
			<cfset page_count = page_count + 1>
			<td colspan="<cfoutput>#colspan_-1#</cfoutput>" class="txtboldblue"><cfoutput>#session.ep.company#-#session.ep.period_year#&nbsp;&nbsp;&nbsp;#attributes.date1# - #attributes.date2#</cfoutput> Dönemi <cfoutput>#attributes.money#</cfoutput> <cf_get_lang no='165.Mizan Planı'></td>
            <td><cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput></td>
		</tr>
        <!---
		<tr class="color-row">
			<cfset satir_say = satir_say + 1>
			<td colspan="14" class="txtboldblue"><cfoutput>#attributes.date1# - #attributes.date2#</cfoutput> Dönemi <cfoutput>#attributes.money#</cfoutput> <cf_get_lang no='165.Mizan Planı'></td>
		</tr>
		--->
		<tr class="color-header" height="20">
			<cfset satir_say = satir_say + 1>
			<td class="form-title" nowrap="nowrap"><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
			<td class="form-title"><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
			<cfif isdefined('attributes.is_acc_department_based')>
				<td class="form-title"><cf_get_lang dictionary_id="57453.Sube">-<cf_get_lang dictionary_id="57572.Departman"></td>
			</cfif>
			<cfif isdefined('attributes.is_cost_profit_center_based')><!--- gelir merkezi --->
				<td class="form-title"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></td>
			</cfif>
			<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1>
				<td class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
				<td class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
				<td class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
				<td class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
			</cfif>
			<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
				<cfoutput>
					<td class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></td>
					<td class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></td>
					<td class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
					<td class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
				</cfoutput>
			</cfif>
			<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
				<td nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57587.Borç'></td>
				<td nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57588.Alacak'></td>
				<td nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
				<td nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
			</cfif>
		</tr>
		<cfif isdefined("attributes.form_varmi") and get_acc_remainder.recordcount >
			<cfscript>
				sayfa_total_borc_all = 0;
				sayfa_total_alacak_all = 0;
				sayfa_total_bakiye_all = 0;
				sayfa_borc_bakiye_tpl = 0;
				sayfa_alacak_bakiye_tpl = 0;
				
				total_borc_all = 0;
				total_alacak_all = 0;
				total_bakiye_all = 0;
				borc_bakiye_tpl = 0;
				alacak_bakiye_tpl = 0;
	
				sayfa_total_borc_all_2 = 0;
				sayfa_total_alacak_all_2 = 0;
				sayfa_total_bakiye_all_2 = 0;
				sayfa_borc_bakiye_tpl_2 = 0;
				sayfa_alacak_bakiye_tpl_2 = 0;
				
				total_borc_all_2 = 0;
				total_alacak_all_2 = 0;
				total_bakiye_all_2 = 0;
				borc_bakiye_tpl_2 = 0;
				alacak_bakiye_tpl_2 = 0;
				acc_dept_id_list='';
				cost_profit_center_list='';
				row_colspan_number_=2;
				if(isdefined('attributes.is_acc_department_based'))
					row_colspan_number_=row_colspan_number_+1;
				if(isdefined('attributes.is_cost_profit_center_based'))
					row_colspan_number_=row_colspan_number_+1;
			</cfscript>
			<cfif isdefined('attributes.is_acc_department_based')>
				<cfset acc_dept_id_list=listdeleteduplicates(listsort(valuelist(get_acc_remainder.DEPARTMENT_ID),'numeric','asc'))>
				<cfif len(acc_dept_id_list)>
					<cfquery name="get_acc_dept" datasource="#dsn#">
						SELECT
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							B.BRANCH_NAME
						FROM
							DEPARTMENT D,
							BRANCH B
						WHERE
							D.BRANCH_ID=B.BRANCH_ID
							AND D.DEPARTMENT_ID IN (#acc_dept_id_list#)
					</cfquery>
					<cfset acc_dept_id_list=listsort(valuelist(get_acc_dept.DEPARTMENT_ID),'numeric','asc')>
				</cfif>
			</cfif>
			<cfif isdefined('attributes.is_cost_profit_center_based')>
				<cfset cost_profit_center_list=listdeleteduplicates(listsort(valuelist(get_acc_remainder.cost_profit_center),'numeric','asc'))>
				<cfif len(cost_profit_center_list)>
					<cfquery name="get_all_expense_center" datasource="#dsn2#">
						SELECT
							EXPENSE_ID,
							(EXPENSE_CODE+' - '+EXPENSE) AS EXPENSE_NAME
						FROM
							EXPENSE_CENTER
						WHERE	
							EXPENSE_ID IN (#cost_profit_center_list#)					
					</cfquery>
					<cfset cost_profit_center_list=listsort(valuelist(get_all_expense_center.EXPENSE_ID),'numeric','asc')>
				</cfif>
			</cfif>
			<cfoutput query="get_acc_remainder">
			  <cfset satir_say = satir_say + 1>
			  <cfset "is_exist_#replace(account_code,'.','_','all')#" = 1>
			  <cfif not Find(".",account_code) or listlen(account_code,".") eq 2 ><cfset str_line = "class='boldtext'"><cfelse><cfset str_line = "" ></cfif>
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" valign="top">
				<td #str_line# nowrap="nowrap">
				<cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>
				#account_code#
				</td>
				<td #str_line#>#left(account_name,50)#</td>
				<cfif isdefined('attributes.is_acc_department_based')>
				<td #str_line#>
					<cfif len(acc_dept_id_list) and len(department_id)>
						#get_acc_dept.BRANCH_NAME[listfind(acc_dept_id_list,department_id)]#-#get_acc_dept.DEPARTMENT_HEAD[listfind(acc_dept_id_list,department_id)]#
					</cfif>
				</td>
				</cfif>
				<cfif isdefined('attributes.is_cost_profit_center_based')><!--- gelir merkezi --->
					<td #str_line#>
						<cfif len(cost_profit_center_list) and len(cost_profit_center)>
							#get_all_expense_center.EXPENSE_NAME[listfind(cost_profit_center_list,cost_profit_center)]#
						</cfif>
					</td>
				</cfif>
				<cfset BORC_ = BORC / attributes.rate>
				<cfset ALACAK_ = ALACAK / attributes.rate>
				<cfset BAKIYE_ = BAKIYE / attributes.rate>
				<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1>

					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(BORC_)#</td>
					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(ALACAK_)#</td>
					<cfif BORC GT ALACAK>
						<td  nowrap style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_))#
							<cfif listlen(ACCOUNT_CODE,'.') eq 1>
								<cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE_)>
								<cfset sayfa_borc_bakiye_tpl=sayfa_borc_bakiye_tpl+abs(BAKIYE_)>
							</cfif>
						</td>
						<td  nowrap style="text-align:right;" #str_line#>#TLFormat(0)#</td>
					<cfelse>
						<td  nowrap style="text-align:right;" #str_line#>#TLFormat(0)#</td>				
						<td  nowrap style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_))#
						<cfif listlen(ACCOUNT_CODE,'.') eq 1>
							<cfset alacak_bakiye_tpl=alacak_bakiye_tpl+abs(BAKIYE_)>
							<cfset sayfa_alacak_bakiye_tpl=sayfa_alacak_bakiye_tpl+abs(BAKIYE_)>
						</cfif>
						</td>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(BORC_2)# #session.ep.money2#</td>				
					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(ALACAK_2)# #session.ep.money2#</td>
					<cfif BORC_2 GT ALACAK_2>
						<td  style="text-align:right;" #str_line#>#TLFormat(abs(BAKIYE_2))#
							<cfif listlen(ACCOUNT_CODE,'.') eq 1>
								<cfset borc_bakiye_tpl_2=borc_bakiye_tpl_2+abs(BAKIYE_2)>
								<cfset sayfa_borc_bakiye_tpl_2=sayfa_borc_bakiye_tpl_2+abs(BAKIYE_2)>
							</cfif>
						</td>
						<td  style="text-align:right;" #str_line#>#TLFormat(0)#</td>
					<cfelse>
						<td  style="text-align:right;" #str_line# >#TLFormat(0)#</td>				
						<td  style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_2))#
						<cfif listlen(ACCOUNT_CODE,'.') eq 1>
							<cfset alacak_bakiye_tpl_2=alacak_bakiye_tpl_2+abs(BAKIYE_2)>
							<cfset sayfa_alacak_bakiye_tpl_2=sayfa_alacak_bakiye_tpl_2+abs(BAKIYE_2)>
						</cfif>
						</td>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_BORC)# #OTHER_CURRENCY#</td>				
					<td  nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_ALACAK)# #OTHER_CURRENCY#</td>
					<cfif OTHER_BORC GT OTHER_ALACAK>
						<td  style="text-align:right;" #str_line#> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
						<td  style="text-align:right;" #str_line#>#TLFormat(0)#</td>
					<cfelse>
						<td  style="text-align:right;" #str_line# >#TLFormat(0)#</td>				
						<td  style="text-align:right;" #str_line#><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
					</cfif>
				</cfif>
				<cfset new_acc_code = replace(replace(account_code,'.#listlast(account_code,'.')#','',''),'.','_','all')>
				<cfif not isdefined("is_exist_#new_acc_code#") or listlen(ACCOUNT_CODE,'.') eq 1>
					<cfset total_borc_all=total_borc_all+BORC_>
					<cfset total_alacak_all=total_alacak_all+ALACAK_>
					<cfset total_bakiye_all=total_bakiye_all+BAKIYE_>
					<cfset sayfa_total_borc_all=total_borc_all+BORC_>
					<cfset sayfa_total_alacak_all=total_alacak_all+ALACAK_>
					<cfset sayfa_total_bakiye_all=total_bakiye_all+BAKIYE_>
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>	
						<cfset total_borc_all_2 = total_borc_all_2 + BORC_2>
						<cfset total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
						<cfset total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
						<cfset sayfa_total_borc_all_2 = total_borc_all_2 + BORC_2>
						<cfset sayfa_total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
						<cfset sayfa_total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
					</cfif>
				</cfif>
				</tr>
				<cfif (satir_say neq 1 and (satir_say mod row_count) eq 1 ) or (page_count eq 1 and satir_say eq 45)>
					<cfset satir_say = 0>
					<tr class="color-row">
						<td colspan="<cfif isdefined('attributes.is_acc_department_based')>3<cfelse>2</cfif>"  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
						<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl)))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl)))#</td>
						</cfif>
						<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all_2))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all_2))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl_2)))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl_2)))#</td>
						</cfif>
						<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
							<td colspan="4"  class="txtbold" style="text-align:right;">&nbsp;</td>
						</cfif>
					</tr> 
					</table>
						<cfdocumentitem type="pagebreak"/>
						<cfset page_count = page_count + 1>
					<table cellpadding="2" cellspacing="1" border="0" width="98%">
					<tr class="color-header" height="20">
						<cfset satir_say = satir_say+1>
					  <td class="form-title" nowrap><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
					  <td class="form-title"><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
					<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1>
					  <td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
					  <td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
					  <td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
					  <td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
					</cfif>
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
						<td  class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></td>
						<td  class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></td>
						<td  class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
						<td  class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
					</cfif>
					<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
						<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57587.Borç'></td>
						<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57588.Alacak'></td>
						<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
						<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
					</cfif>
					</tr>
					<tr class="color-row">
						<cfset satir_say = satir_say+1>
						<td colspan="2"  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='38876.Önceki Sayfa'>:</td>
						<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all))#</td>
						<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all))#</td>
						<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl)))#</td>
						<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl)))#</td>
						<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all_2))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all_2))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl_2)))#</td>
							<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl_2)))#</td>
						</cfif>
						<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
							<td colspan="4"  class="txtbold" style="text-align:right;">&nbsp;</td>
						</cfif>
					</tr> 
				</cfif>
			</cfoutput>
			<tr class="color-row">
				<cfset satir_say = satir_say+1>
				<cfoutput>
				<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
				<cfif isdefined('attributes.is_system_money') and attributes.is_system_money eq 1>
					<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_borc_all))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_alacak_all))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(borc_bakiye_tpl)))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(alacak_bakiye_tpl)))#</td>
				</cfif>
				<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
					<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_borc_all_2))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_alacak_all_2))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(borc_bakiye_tpl_2)))#</td>
					<td  class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(alacak_bakiye_tpl_2)))#</td>
				</cfif>
				</cfoutput>
				<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
					<td colspan="4"  class="txtbold" style="text-align:right;">&nbsp;</td>
				</cfif>
			</tr> 
		</cfif>
	</table>
</cfdocument>
