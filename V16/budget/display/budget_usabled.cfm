<!--- 20102020 / Melek KOCABEY
      Bütçe Aktarım Talebi - masraf merkezine ,bütçe kalameine ve projeye göre kullanılabilir serbest bütçe gelmesini sağlar.
--->
<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfif len(attributes.expense_item_id) and (not len(attributes.project_id))>
    <cfset get_exp_detail = demand.get_exp_detail(expense_item_id:attributes.expense_item_id)>
</cfif>
<cfset GET_EXPENSE_BUDGET = demand.GET_EXPENSE_BUDGET(
                                                        project_id:attributes.project_id,
                                                        expense_id:attributes.expense_id,
                                                        expense_cat: isDefined("get_exp_detail") ? get_exp_detail.expense_cat_id : '')>
                                                        
<cfif GET_EXPENSE_BUDGET.RecordCount>
    <cfset attributes.usabled_money = TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE - GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC - (GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_ALACAK - GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_BORC))>
<cfelse>
    <cfset attributes.usabled_money = 0>
</cfif>
<script>
    $( document ).ready(function() {
        $("#serbest_<cfoutput>#attributes.rowNum#</cfoutput>_<cfoutput>#attributes.i#</cfoutput>" ).val(commaSplit(<cfoutput>#(filternum(attributes.usabled_money))#</cfoutput>)); 
    });
</script>