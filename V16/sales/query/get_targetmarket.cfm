<cfquery name="TMARKET" datasource="#DSN3#">
    SELECT
        TM.CAMP_ID,
        TM.TMARKET_ID,
        TM.TMARKET_NO,
        TM.TMARKET_NAME,
        TM.CONS_IS_POTANTIAL,
        TM.TMARKET_SEX,
        TM.AGE_LOWER,
        TM.AGE_UPPER,
        TM.TMARKET_MARITAL_STATUS,
        TM.CHILD_LOWER,
        TM.CHILD_UPPER,
        TM.TMARKET_BIRTH_PLACE,
        TM.TMARKET_MEMBERSHIP_STARTDATE,
        TM.TMARKET_MEMBERSHIP_FINISHDATE,
        TM.CONSUMER_COMPANY,
        TM.CONSUMER_TITLE,
        TM.CONS_SECTOR_CATS,
        TM.CONS_SIZE_CATS,
        TM.CONS_SALES_TOTAL_START,
        TM.CONS_SALES_TOTAL_END,
        TM.SHOPPING_STARTDATE,
        TM.SHOPPING_FINISHDATE,
        TM.PRODUCT_CATID,
        TM.STOCK_ID,
        TM.SHOP_AMOUNT_LOWER,
        TM.SHOP_AMOUNT_UPPER,
        TM.SHOP_MONEY_LOWER,
        TM.SHOP_MONEY_UPPER,
        TM.CONSCAT_IDS,
        TM.PARTNER_TMARKET_SEX,
        TM.COMPANY_COUNTRY_ID,
        TM.COMPANY_CITY_ID,
        TM.COMPANY_COUNTY_ID,
        TM.COUNTRY_ID,
        TM.CITY_ID,
        TM.PARTNER_TITLE,
        TM.PARTNER_MISSION,
        TM.PARTNER_DEPARTMENT,
        TM.SECTOR_CATS,
        TM.COMPANY_SIZE_CATS,
        TM.COMPANYCATS,
        TM.PARTNER_STATUS,
        TM.IS_POTANTIAL,
        TM.IS_BUYER,
        TM.IS_SELLER,
        TM.TARGET_ALTS,
        TM.SOCIETY_ID,
        TM.CUSTOMER_POSITION,
        TM.FULLNAME,
        TM.IMS_CODE_ID,
        TM.INSURANCE_COMPANY,
        TM.OTHER_WORKS,
        TM.GSM_CODE,
        TM.TEL_CODE,
        TM.POST_CODE,
        TM.COMPTETITOR_DEPOT,
        TM.SOFTWARES,
        TM.SEMT,
        TM.COUNTY_ID,
        TM.BIRTHPLACE,
        TM.HOBBY,
        TM.ZONE_DIRECTOR,
        TM.MARIAL_STATUS,
        TM.FACULTY,
        TM.GRADUATE_YEAR,
        TM.OPEN_DATE,
        TM.CLOSE_DATE,
        TM.COMPANY_PARTNER_NAME,
        TM.COMPANY_PARTNER_SURNAME,
        TM.COMPANY_DEPOTS,
        TM.DISTRICT,
        TM.COUNTRY,
        TM.BIRTHDATE_START,
        TM.BIRTHDATE_FINISH,
        TM.NET_CONNECTION,
        TM.PC_NUMBER,
        TM.CONSUMER_VALUE,
        TM.COMPANY_VALUE,
        TM.CONSUMER_IMS_CODE,
        TM.COMPANY_IMS_CODE,
        TM.CONSUMER_HOBBY,
        TM.COMPANY_PARTNER_HOBBY,
        TM.CONSUMER_RESOURCE,
        TM.COMPANY_RESOURCE,
        TM.CONSUMER_OZEL_KOD1,
        TM.COMPANY_OZEL_KOD1,
        TM.COMPANY_OZEL_KOD2,
        TM.COMPANY_OZEL_KOD3,
        TM.CONSUMER_SALES_ZONE,
        TM.COMPANY_SALES_ZONE,
        TM.CONS_EDUCATION,
        TM.CONS_VOCATION_TYPE,
        TM.CONS_SOCIETY,
        TM.CONS_INCOME_LEVEL,
        TM.COMPANY_REL_TYPE_ID,
        TM.COMPANY_REL_ID,
        TM.TARGET_MARKET_TYPE,
        TM.CONS_STATUS,
        TM.REQ_COMP,
        TM.REQ_CONS,
        TM.COMP_AGENT_POS_CODE,
        TM.CONS_AGENT_POS_CODE,
        TM.COMP_REL_BRANCH,
        TM.CONS_REL_BRANCH,
        TM.COMP_REL_COMP,
        TM.CONS_REL_COMP,
        TM.IS_MAILLIST,
        TM.ORDER_START_DATE,
        TM.ORDER_FINISH_DATE,
        TM.LAST_DAY_COUNT,
        TM.LAST_DAY_TYPE,
        TM.IS_GIVEN_ORDER,
        TM.ORDER_PRODUCT_ID,
        TM.ORDER_PRODUCT_STATUS,
        TM.ORDER_PRODUCTCAT_ID,
        TM.ORDER_PRODUCTCAT_STATUS,
        TM.ORDER_AMOUNT,
        TM.ORDER_AMOUNT_TYPE,
        TM.ORDER_COUNT,
        TM.ORDER_COUNT_TYPE,
        TM.PRODUCT_COUNT,
        TM.PRODUCT_COUNT_TYPE,
        TM.ORDER_COMMETHOD_ID,
        TM.ORDER_PAYMETHOD_ID,
        TM.ORDER_CARDPAYMETHOD_ID,
        TM.PROMOTION_ID,
        TM.PROMOTION_STATUS,
        TM.PROMOTION_COUNT,
        TM.CONSUMER_STAGE,
        TM.PARTNER_STAGE,
        TM.CONSUMER_BIRTHDATE,
        TM.PROMOTION_OFFER_STATUS,
        TM.IS_CONS_CEPTEL,
        TM.IS_CONS_EMAIL,
        TM.IS_CONS_TAX,
        TM.IS_CONS_DEBT,
        TM.IS_CONS_BLOKE,
        TM.IS_CONS_OPEN_ORDER,
        TM.IS_CONS_BLACK_LIST,
        TM.CONS_PASSWORD_DAY,
        TM.TRAINING_ID,
        TM.TRAINING_STATUS,
        TM.RECORD_DATE,
       	TM.RECORD_EMP,
        TM.RECORD_IP,
        TM.UPDATE_DATE,
        TM.UPDATE_EMP,
        TM.UPDATE_IP,
        TM.CONS_WANT_EMAIL,
        TM.COMP_WANT_EMAIL,
        TM.COMP_ID_LIST,
        TM.CONS_ID_LIST,
        TM.PARTNER_ID_LIST,
        TM.COUNTRY_LIST,
        TM.COMP_PRODUCTCAT_LIST,
        TM.COMP_FIRM_LIST,
        TM.COMP_CONMEMBER,
        TM.ONLY_FIRMMEMBER,
        OMC.ORDER_CREDIT_ID,
        OMC.IS_TYPE,
        OMC.VALID_DATE
    FROM
        TARGET_MARKETS TM,
        ORDER_MONEY_CREDITS OMC
    WHERE
        TM.TMARKET_ID = OMC.TARGET_MARKET_ID
       	<cfif isDefined('attributes.target_market_id') and len(attributes.target_market_id)>
        	AND TM.TMARKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_market_id#">
    	<cfelseif isDefined('tmarket_list') and len(tmarket_list)>
        	AND TM.TMARKET_ID IN (#tmarket_list#)        
        </cfif>
    ORDER BY
        TM.RECORD_DATE DESC
</cfquery>
