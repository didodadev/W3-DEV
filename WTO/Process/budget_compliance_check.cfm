<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 10.11.2020
    Description:
      Bütçe UYGUNLUK KONTROLU süreci (action file) eklenmelidir.
--->

<cfset getComponent = createObject("component","V16.budget.cfc.GetBudgetComplianceCheck") />
<cfset attributes.control_type = 20>
<cfset OrderProjectKontrol = getComponent.GetOrderProject(order_id:attributes.action_id)>
 <cfif OrderProjectKontrol.recordcount and len(OrderProjectKontrol.PROJECT_HEAD)>
     <cfif listfind('Lisans,Donanım,Donanım+Lisans,Bina,İştirak,Demirbaş',OrderProjectKontrol.PROJECT_HEAD)>
        <cfset attributes.control_type = 21>
     </cfif>
 </cfif>
<cfset getBudgetControl = getComponent.GetBudgetControl(order_id:attributes.action_id,control_type:attributes.control_type)>
<cfset kontrol_surec = 335>
<cfset onay_surec = 336>
<cfset sayac = 0>
<cfset emp_kontrol =0>
<cfif getBudgetControl.recordcount gt 0>
    <cfset emp_id_list = "">
    <cfloop query="getBudgetControl">
        <cfif (NETTOTAL) gt (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)>
            <cfset sayac = sayac + 1>
            <cfif EXPENSE_DEPARTMENT_ID eq -1>
                <cfset net_total = NETTOTAL-(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC))>
                <cfset usb_money = ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC)>
                <cfset emp_id_list = listAppend(emp_id_list, '#RESPONSIBLE1#_#RESPONSIBLE2#_#RESPONSIBLE3#;#EXPENSE#;#EXPENSE_CAT_ID#;#net_total#;#EXPENSE_ID#;#usb_money#')>
            <cfelse>
                <cfset emp_kontrol = emp_kontrol + 1>
            </cfif>
        </cfif>
    </cfloop> 
   
   <!--- <cfset updateStage = getComponent.UPD_ORDER_STAGE(action_id:attributes.action_id,stage_id : onay_surec)> --->
</cfif>  
<cfquery name="Get_Main_Query" datasource="#attributes.data_source#">
    SELECT TOP 1
        I.INTERNAL_ID,
        I.INTERNAL_NUMBER,
        I.RECORD_EMP,
        I.FROM_POSITION_CODE,
        I.SUBJECT,
        O.ORDER_NUMBER
    FROM
        INTERNALDEMAND I,
        ORDERS O
    WHERE
    O.ORDER_ID = #attributes.action_id# and
    (O.REF_NO = I.INTERNAL_NUMBER or O.REF_NO like ('%' + I.INTERNAL_NUMBER + ',%') )
</cfquery>
<cfif sayac gt 0> 
    <cfloop list="#emp_id_list#" index="j">
        <cfset emp_id_ = listgetat(j,1,';')>
        <cfset expense = listgetat(j,2,';')>
        <cfset expense_cat_id = listgetat(j,3,';')>
        <cfset net_total = listgetat(j,4,';')>
        <cfset expense_id = listgetat(j,5,';')>
        <cfset usb_money = listgetat(j,6,';')>
        <cfquery name="get_exp_detail" datasource="#caller.dsn3#">
            SELECT DISTINCT EI.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM #caller.dsn2#.EXPENSE_ITEMS EI LEFT JOIN ORDER_ROW ORW ON ORW.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID WHERE EXPENSE_CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_cat_id#"> AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
        </cfquery>
        <cfquery name="get_employee_mail" datasource="#caller.dsn3#">
            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM #caller.dsn#.EMPLOYEES WHERE EMPLOYEE_ID IN (#REPLACE(emp_id_,'_',',','all')#)
        </cfquery> 
        <cfset result=arrayNew(1)> 
        <cfset Budgetinformations = StructNew() />
                                            <cfset Budgetinformations.expense_item_id = get_exp_detail.EXPENSE_ITEM_ID>
                                            <cfset Budgetinformations.expense_item_name = get_exp_detail.EXPENSE_ITEM_NAME>
                                            <cfset Budgetinformations.expense_id = expense_id>
                                            <cfset Budgetinformations.expense_name = expense>
                                            <cfset Budgetinformations.AMOUNT = #caller.TLFormat(net_total)#>
                                            <cfset Budgetinformations.MONEY_CURRENCY = session.ep.money>
                                            <cfset Budgetinformations.reference_no = Get_Main_Query.INTERNAL_NUMBER>
                                            <cfset Budgetinformations.USABLE_MONEY = #caller.TLFormat(usb_money)#>
                                            <cfset Budgetinformations.project_id = isdefined("project_id") ? project_id : ''>
                                            <cfset ArrayAppend(result, Budgetinformations)>
                                            <cfset attributes.budget_info = LCase(Replace(SerializeJson(result),"//","")) />
            <cfloop query="get_employee_mail">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='61325.Bütçe Aktarım Talebi'></cfsavecontent>
                <cfif len(get_employee_mail.EMPLOYEE_EMAIL)>
                    <cfmail 
                        from="#session.ep.company#<#session.ep.company_email#>"
                        to="#get_employee_mail.EMPLOYEE_EMAIL#"
                        subject="#message#" type="HTML">
                        <cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
                        <br/><br/>
                        yeterli bütçenin sağlanması için ilgili masraf merkezi ve bütçe kalemine göre bütçe aktarım talebinde bulunuz.<br/><br/>
                        Masraf Merkezi : #expense# <br/><br/>
                        Bütçe Kalemi : #get_exp_detail.EXPENSE_ITEM_NAME# <br/><br/>
                        Tutar : #caller.TLFormat(net_total)# <br/><br/>
                        <a href='#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=add&budget_info=#attributes.budget_info#' target="_blank">#message#</a> <br/><br/>
                        <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                        <br/><br/>
                        <cf_get_lang dictionary_id='32345.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
                    </cfmail>
                </cfif>
            </cfloop>                     
    </cfloop> 
   <cfif emp_kontrol gt 0>
        <cfset get_internaldemandEmp = getComponent.get_internaldemandEmp(action_id:attributes.action_id)>
        <cfif Get_Main_Query.recordcount and len(Get_Main_Query.FROM_POSITION_CODE)>
            <cfquery name="get_employee_mail" datasource="#caller.dsn3#">
                SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM #caller.dsn#.EMPLOYEES WHERE EMPLOYEE_ID IN (#Get_Main_Query.FROM_POSITION_CODE#)
            </cfquery>
            <cfloop query="get_employee_mail">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='61325.Bütçe Aktarım Talebi'></cfsavecontent>
                <cfif len(get_employee_mail.EMPLOYEE_EMAIL)>
                    <cfmail 
                        from="#session.ep.company#<#session.ep.company_email#>"
                        to="#get_employee_mail.EMPLOYEE_EMAIL#"
                        subject="#message#" type="HTML">
                        <cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
                        <br/><br/>
                        yeterli bütçenin sağlanması için ilgili talebin bütçe uygunluğunu kontrol ediniz<br/><br/>
                        <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=purchase.list_purchasedemand&event=det&id=#Get_Main_Query.INTERNAL_ID#" target="_blank"><cf_get_lang dictionary_id='49752.Satınalma Talebi'>Detay Sayfası</a> <br/><br/>
                        
                        <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                        <br/><br/>
                        <cf_get_lang dictionary_id='32345.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
                    </cfmail>
                </cfif>
            </cfloop>
        </cfif>
    </cfif>
</cfif>