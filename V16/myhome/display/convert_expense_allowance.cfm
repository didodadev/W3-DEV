<!---
    File: convert_expense_allowance.cfc
    Controller: hr = hrAllowenceExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 13/12/2019 
    Description:
        Harcama Taleplerinin harcırah bordrosuna dönüştürüldüğü sayfadır.
--->
<cf_date tarih="attributes.expense_date">
<cfset expense_rules_cmp = createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek 20122019ERU--->
<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.EXPENSE_EMPLOYEE_ID)><!--- In out Id --->
<cfif get_in_out_id.recordcount gt 0 and len(get_in_out_id.IN_OUT_ID)>
<cfset attributes.sal_mon = month(attributes.expense_date)>
<cfset delete_salaryparam = allowance_expense_cmp.DELETE_SALARYPARAM_PAY(expense_puantaj_id : attributes.request_id)><!--- Daha önce harcırahıı oluştuluşmuşsa siler--->
<cfset attributes.sal_year = year(attributes.expense_date)>
	<cfif len(attributes.record_num) and attributes.record_num neq "">
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>
					<cf_date tarih="attributes.expense_date#i#">
				</cfif>
				<cfscript>
					form_row_detail = evaluate("attributes.row_detail#i#");
					form_expense_item_id = evaluate("attributes.expense_item_id#i#");
					form_expense_center_id = evaluate("attributes.expense_center_id#i#");
					if(isdefined("attributes.activity_type#i#"))
						form_activity_type = evaluate("attributes.activity_type#i#");
					else
						form_activity_type = '';
					if(isdefined("attributes.member_id#i#"))
					{
						form_member_id = evaluate("attributes.member_id#i#");
						form_company_id = evaluate("attributes.company_id#i#");
						form_company = evaluate("attributes.company#i#");
						form_authorized = evaluate("attributes.authorized#i#");
						form_member_type = evaluate("attributes.member_type#i#");
					}
					else
					{
						form_member_id = '';
						form_company_id = '';
						form_company = '';
						form_authorized = '';
						form_member_type = '';
					}
					if(isdefined("attributes.asset_id#i#"))
					{
						form_asset = evaluate("attributes.asset#i#");
						form_asset_id = evaluate("attributes.asset_id#i#");
					}
					else
					{
						form_asset = '';
						form_asset_id = '';
					}
					if(isdefined("attributes.project_id#i#"))
					{
						form_project_id = evaluate("attributes.project_id#i#");
						form_project = evaluate("attributes.project#i#");
					}
					else
					{
						form_project_id = '';
						form_project = '';
					}
					form_total = evaluate("attributes.total#i#");
					if(isdefined("attributes.money_id#i#"))
						form_money_id = evaluate("attributes.money_id#i#");
					else
						form_money_id = session.ep.money;
					form_kdv_total = evaluate("attributes.kdv_total#i#");
					form_net_total = evaluate("attributes.net_total#i#");
					form_money_1 = listgetat(form_money_id, 1, ',');
					form_money_2 = listgetat(form_money_id, 2, ',');
					form_money_3 = listgetat(form_money_id, 3, ',');
					form_tax_rate = evaluate("attributes.tax_rate#i#");
					if(isdefined("attributes.other_net_total#i#"))
						form_other_net_total = evaluate("attributes.other_net_total#i#");
					else
						form_other_net_total = form_net_total;
					if(isdefined("attributes.product_id#i#"))
					{
						form_product_id = evaluate("attributes.product_id#i#");
						form_stock_id = evaluate("attributes.stock_id#i#");
						form_product_name = evaluate("attributes.product_name#i#");
						form_stock_unit = evaluate("attributes.stock_unit#i#");
						form_stock_unit_id = evaluate("attributes.stock_unit_id#i#");
					}
					else
					{
						form_product_id = '';
						form_stock_id = '';
						form_product_name = '';
						form_stock_unit = '';
						form_stock_unit_id = '';
					}
					form_quantity = evaluate("attributes.quantity#i#");
					if(isdefined("attributes.expense_type#i#"))
					{
						allowance_expense_type = evaluate("attributes.expense_type#i#");
					}
					else
					{
						allowance_expense_type = '';
					}
					if(isdefined("attributes.day#i#"))
					{
						allowance_day = evaluate("attributes.day#i#");
					}
					else
					{
						allowance_day = '';
					}
					//Ek Ödenek Tablosu için ERU
					if(isdefined("attributes.expense_type_name#i#"))//Ödenek ismi- Talep ismi
					{
						expense_type_name = evaluate("attributes.expense_type_name#i#");
					}
					else
					{
						expense_type_name = '';
					}
					if(isdefined("attributes.expense_type#i#"))//Ek ödenek Id
					{
						expense_type_id = evaluate("attributes.expense_type#i#");
					}
					else
					{
						expense_type_id = '';
					}
					if(isdefined("attributes.exp_item_rows_id#i#"))//Ek ödenek Id
					{
						exp_item_rows_id = evaluate("attributes.exp_item_rows_id#i#");
					}
					else
					{
						exp_item_rows_id = '';
					}
				</cfscript>
				<!--- Harcırah Bordrosunu harcırah kurallarından gelen verilere göre Ek ödenek olarak ekler 20122019ERU--->
				<cfset get_expense_rules = expense_rules_cmp.GET_EXPENSE_RULES(expense_hr_rules_id : expense_type_id) /><!--- Harcırah kuralları--->
				<cfif get_expense_rules.recordcount>
					<cfset total_amount = get_expense_rules.TAX_EXCEPTION_AMOUNT * form_quantity><!--- istisna tutarı * gün --->
					<cfset tax_exemption_value = form_net_total - total_amount><!--- (ödeneğin vergi matrahı = (günlük harcama * gün) - (istisna tutarı * gün)) --->
					<cfset get_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
						comment_pay :  expense_type_name,<!--- Ödenek İsmi --->
						comment_pay_id : expense_type_id,<!---Ödenek Id --->
						amount_pay : form_net_total,<!--- Ödenek --->
						ssk : 1,<!--- ssk 1 : muaf, 2: muaf değil ---> 
						tax :2,<!--- vergi 1 : muaf, 2: muaf değil---> 
						is_damga : get_expense_rules.is_stamp_tax,<!--- damga vergisi --->
						is_issizlik : 0,<!--- işsizlik ---> 
						show : 1,<!--- bordroda görünsün ---> 
						method_pay : 1,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
						period_pay : 1,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
						start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
						end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
						employee_id : attributes.EXPENSE_EMPLOYEE_ID,<!--- çalışan id --->
						term : attributes.sal_year,<!--- yıl --->
						calc_days : 0,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
						is_kidem : 0,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
						in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
						from_salary : 0, <!--- 0 :net,1 : brüt --->
						is_ehesap : 0,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
						is_ayni_yardim : 0,<!--- ayni yardım --->
						tax_exemption_value : tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı (ödeneğin vergi matrahı = (günlük harcama * gün) - (istisna tutarı * gün)) --->
						tax_exemption_rate : total_amount,<!--- Gelir Vergisi Muafiyet Oranı--->
						money : get_expense_rules.MONEY_TYPE,<!--- Para birimi--->
						is_income : 0,<!--- kazançlara dahil--->
						is_not_execution : 1,<!--- İcraya Dahil Değil --->
						comment_type : 1,<!--- 1: ek ödenek, 2: kazanc --->
						expense_puantaj_id : attributes.request_id,<!--- Ek ödeneğin bağlı olduğu harcırah id ---> 
						detail : form_row_detail
						) />
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=hr.allowance_expense&event=upd&request_id=#attributes.request_id#</cfoutput>";
</script>