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
<cfif getBudgetControl.recordcount gt 0>
    <cfloop query="getBudgetControl">
        <cfif (NETTOTAL) gt (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)>
            <cfset sayac = sayac + 1>
        </cfif>
    </cfloop> 
   <!--- <cfset updateStage = getComponent.UPD_ORDER_STAGE(action_id:attributes.action_id,stage_id : onay_surec)> --->
</cfif>   
<cfif sayac gt 0>    
   <!--- <cfset updateStage = getComponent.UPD_ORDER_STAGE(action_id:attributes.action_id,stage_id : kontrol_surec)> --->
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
