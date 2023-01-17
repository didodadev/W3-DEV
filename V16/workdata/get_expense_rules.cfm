<!--- 
	amac            : gelen expense_rules_detail parametresine göre EXPENSE_CENTER_ID,EXPENSE_TYPE_ID,EXPENSE_ITEM_ID bilgisini getirmek
	parametre adi   : expense_rules_detail
	kullanim        : get_expense_rules('yol') 
	Yazan           : G.İnan
	Tarih           : 11022021
 --->
 <cffunction name="GET_EXPENSE_RULES" access="public" returnType="query" output="no">
  <cfargument name="expense_rules_detail" required="yes" type="string">
  <cfargument name="pos_cat_id_" required="no" type="integer">
  <cfargument name="pos_cat_id" required="no" type="integer">

  <cfquery name="GET_EXPENSE_RULES" datasource="#dsn#">
      SELECT 
          EHR.EXPENSE_HR_RULES_ID,
          EHR.EXPENSE_HR_RULES_TYPE,
          EHR.EXPENSE_HR_RULES_DESCRIPTION,
          EHR.EXPENSE_HR_RULES_DETAIL,
          EHR.DAILY_PAY_MAX,
          EHR.MONEY_TYPE,
          EHR.FIRST_LEVEL_DAY_MAX,
          EHR.FIRST_LEVEL_PAY_RATE,
          EHR.SECOND_LEVEL_DAY_MAX,
          EHR.SECOND_LEVEL_PAY_RATE,
          EHR.RULE_START_DATE,
          EHR.TAX_EXCEPTION_AMOUNT,
          EHR.TAX_EXCEPTION_MONEY_TYPE,
          EHR.IS_INCOME_TAX_INCLUDE,
          EHR.IS_STAMP_TAX,
          EHR.TAX_RANK_FACTOR,
          EHR.EXPENSE_CENTER,
          EHR.EXPENSE_ITEM_ID,
          EC.EXPENSE,
          EI.EXPENSE_ITEM_NAME,
          EHR.UPDATE_DATE,
          EHR.UPDATE_EMP,
          EHR.UPDATE_IP,
          EHR.RECORD_DATE,
          EHR.RECORD_EMP,
          EHR.RECORD_IP,               
          EHR.IS_COUNTRY_OUT,
          EHR.IS_ACTIVE,
          EHR.ADDITIONAL_ALLOWANCE_ID
      FROM 
          EXPENSE_HR_RULES EHR
          LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EHR.EXPENSE_CENTER=EC.EXPENSE_ID
          LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EHR.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
      WHERE 
          EHR.IS_ACTIVE = 1
          <cfif isdefined("arguments.expense_rules_detail") and len(arguments.expense_rules_detail)>
              AND EHR.EXPENSE_HR_RULES_DETAIL LIKE '%#arguments.expense_rules_detail#%'
          </cfif>
          <cfif isDefined("arguments.pos_cat_id") and len(arguments.pos_cat_id)>
              AND EHR.EXPENSE_HR_RULES_ID IN (SELECT EXPENSE_HR_RULES_ID FROM MARCHING_MONEY_POSITION_CATS WHERE POSITION_CAT_ID = #arguments.pos_cat_id#)
          </cfif>
  </cfquery>
  <cfreturn GET_EXPENSE_RULES>
</cffunction> 

