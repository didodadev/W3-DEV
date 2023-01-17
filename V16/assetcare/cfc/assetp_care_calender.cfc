<cfcomponent>
         <!---  Bakım Takvimi Listeleme --->
      <cffunction name="GET_ASSETP_CARE_FNC" returntype="query"> 
            <cfargument name="temp_tarih" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="branch" default="">
            <cfargument name="assetpcatid" default="">
            <cfargument name="department" default="">
            <cfargument name="department_id" default="">
            <cfargument name="official_emp_id" default="">
            <cfargument name="official_emp" default="">
            <cfargument name="asset_id" default="">
            <cfargument name="asset_name" default="">
            <cfargument name="asset_cat" default="">
            <cfargument name="startdate" default="">
            <cfargument name="finishdate" default="">
            <cfargument name="xml_single_asset_care" default=""> 
            <cfargument name="yearly_report_parameters" default="">                       
  <cfquery name="GET_ASSET_CARES_ALL" datasource="#this.DSN#">
	SELECT
		CARE_STATES.CARE_ID,
	  	CARE_STATES.ASSET_ID,
	  	CARE_STATES.PERIOD_ID,
	  	CARE_STATES.PERIOD_TIME, 
	  	CARE_STATES.CARE_STATE_ID,
	  	CARE_STATES.OFFICIAL_EMP_ID,
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_CATID,
		ASSET_P_CAT.IT_ASSET,
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		(SELECT ASSET_CARE FROM ASSET_CARE_CAT WHERE ASSET_CARE_ID = CARE_STATES.CARE_STATE_ID) ASSET_CARE,
		(SELECT EMPLOYEE_NAME +' ' +EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CARE_STATES.OFFICIAL_EMP_ID) EMPLOYEE_NAME
      <cfif arguments.xml_single_asset_care eq 1>   
        	,ASSET_CARE_REPORT.CARE_REPORT_ID
            ,ASSET_CARE_REPORT.CALENDER_DATE
      </cfif>
	FROM
	  	CARE_STATES
		<cfif arguments.xml_single_asset_care eq 1>
        	LEFT JOIN ASSET_CARE_REPORT ON ASSET_CARE_REPORT.CARE_ID = CARE_STATES.CARE_ID  <cfif isdefined("temp_tarih")>AND ASSET_CARE_REPORT.CALENDER_DATE = #arguments.temp_tarih#</cfif>
    </cfif>
		,ASSET_P,
		ASSET_P_CAT,
		BRANCH,
		DEPARTMENT
        
	WHERE
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		ASSET_P.ASSETP_ID = CARE_STATES.ASSET_ID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID
		<cfif isdefined("arguments.branch_id") and len(arguments.branch) and len(arguments.branch_id)>AND BRANCH.BRANCH_ID =#arguments.branch_id#</cfif>
		<cfif isdefined("arguments.assetpcatid") and len(arguments.assetpcatid)>AND ASSET_P.ASSETP_CATID = #arguments.assetpcatid#</cfif> 
		<cfif isdefined("arguments.department") and len(arguments.department) and  isdefined("arguments.department_id") and len(arguments.department_id)>AND ASSET_P.DEPARTMENT_ID = #arguments.department_id#</cfif>
		<cfif isdefined("arguments.official_emp_id") and  len(arguments.official_emp_id) and isdefined("arguments.official_emp") and len(arguments.official_emp)>AND CARE_STATES.OFFICIAL_EMP_ID=#arguments.official_emp_id#</cfif>
		<cfif isdefined("arguments.asset_id") and len(arguments.asset_id)and isdefined("arguments.asset_name") and len(arguments.asset_name)>AND CARE_STATES.ASSET_ID =#arguments.asset_id#</cfif>
		<cfif isdefined("arguments.asset_cat") and len(arguments.asset_cat)>AND CARE_STATES.CARE_STATE_ID = #arguments.asset_cat#</cfif>
		<cfif isdefined("yearly_report_parameters") and len(yearly_report_parameters)>
			AND CARE_STATES.PERIOD_TIME >= #arguments.startdate# 
			AND CARE_STATES.PERIOD_TIME <= #arguments.finishdate#
		</cfif>
</cfquery>
            <cfreturn GET_ASSET_CARES_ALL>
          </cffunction> 
   <!---  Bakım Sonucu Ekleme   --->
    <cffunction name="addAssetpCareFnc" access="public" returntype="any">    				
					<cfargument name="care_number" default="">
                    <cfargument name="process_stage" default="">
        			<cfargument name="asset_id">
        			<cfargument name="service_company_id" default=""> 
                     <cfargument name="authorized_id"  default="">
                     <cfargument name="station_id"  default="">
                     <cfargument name="station_company_id" default="">
        			<cfargument name="employee_id" default=""> 
                    <cfargument name="employee_id2" default="">
                    <cfargument name="support_finish_date" default="">
        			<cfargument name="care_start_date" default="">  
       				 <cfargument name="care_finish_date" default="">
        			<cfargument name="care_type_id" default="">                     
                    <cfargument name="is_yasal_islem">
        			<cfargument name="policy_num" default=""> 
                     <cfargument name="motorized_vehicle"  default="">
                     <cfargument name="care_km"  default="">
                     <cfargument name="care_detail" default="">
        			<cfargument name="care_detail2" default=""> 
                    <cfargument name="bill_id" default="">
        			<cfargument name="document_type_id" default="">  
       				 <cfargument name="expense" default="">
        			<cfargument name="is_guaranty" default="">                     
                    <cfargument name="project_id" default="">
        			<cfargument name="failure_id" default=""> 
                    <cfargument name="care_id" default="">
        			<cfargument name="calender_date" default="">  
       				<cfargument name="expense_net" default="">
                    <cfargument name="money_currency" default="">
        			<cfargument name="exp_item_name" default="">  
                    <cfargument name="expense_center_id" default="">  
                   <cfargument name="PAPER_TYPE" default=""> 
        	<cfquery name="ADD_ASSET_CARE" datasource="#this.DSN#">
      		INSERT INTO
				ASSET_CARE_REPORT
			(
				CARE_REPORT_NUMBER,
				PROCESS_STAGE,
				ASSET_ID,
				ASSET_TYPE,
				COMPANY_ID,
				COMPANY_PARTNER_ID,
				STATION_ID,
				OUR_COMPANY_ID,
				C_EMPLOYEE1_ID,
				C_EMPLOYEE2_ID,
				CARE_DATE,
				CARE_FINISH_DATE,
				CARE_TYPE,						
				POLICY_NUM,
				CARE_KM,
				DETAIL,
				DETAIL2,
				BILL_ID,
                EXPENSE_ITEM_ROW_ID,
				DOCUMENT_TYPE_ID,
				EXPENSE_AMOUNT,
				AMOUNT_CURRENCY,
				IS_YASAL_ISLEM,
				IS_GUARANTY,
                PROJECT_ID,
                FAILURE_ID,
                CARE_ID,
                CALENDER_DATE,
                EXPENSE_AMOUNT_NET,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(arguments.care_number)>'#arguments.care_number#'<cfelse>NULL</cfif>,
                <cfif len(#arguments.process_stage#)>'#arguments.process_stage#'<cfelse>NULL</cfif>,				
				#arguments.asset_id#,
				'P',
				<cfif isDefined("arguments.service_company_id") and len(arguments.service_company_id)>#arguments.service_company_id#<cfelse>NULL</cfif>,
				<cfif isDefined("arguments.authorized_id") and len(arguments.authorized_id)>#arguments.authorized_id#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.station_id") and  len(arguments.station_id)>#arguments.station_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.station_company_id') and len(arguments.station_company_id)>#arguments.station_company_id#<cfelse>NULL</cfif>,
				<cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
				<cfif isDefined("arguments.employee_id2") and len(arguments.employee_id2)>#arguments.employee_id2#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.care_start_date") and len(arguments.care_start_date)>#arguments.care_start_date#<cfelseif isdefined("arguments.support_finish_date") and len(arguments.support_finish_date)>#arguments.support_finish_date#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.care_finish_date") and len(arguments.care_finish_date)>#arguments.care_finish_date#<cfelse>NULL</cfif>,
				<cfif len(arguments.care_type_id)>#arguments.care_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.is_yasal_islem") and arguments.is_yasal_islem eq 1>'#arguments.policy_num#'<cfelse>NULL</cfif>,
				<cfif arguments.motorized_vehicle eq 1>#arguments.care_km#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.care_detail") and len(arguments.care_detail)>'#arguments.care_detail#'<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.care_detail2") and len(arguments.care_detail2)>'#arguments.care_detail2#'<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.bill_id") and len(arguments.bill_id)>'#arguments.bill_id#'<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.exp_item_name") and len(arguments.exp_item_name)>'#arguments.exp_item_name#'<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.document_type_id") and len(arguments.document_type_id)>#arguments.document_type_id#<cfelse>NULL</cfif>,
                <cfif len(arguments.expense)>#arguments.expense#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.expense") and len(arguments.expense) and len(arguments.money_currency)>'#arguments.money_currency#'<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.is_yasal_islem") and len(arguments.is_yasal_islem)>#arguments.is_yasal_islem#<cfelse>0</cfif>,
				<cfif isdefined("arguments.is_guaranty") and len(is_guaranty)>#arguments.is_guaranty#<cfelse>0</cfif>,
				<cfif isdefined("arguments.project_id") and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.failure_id") and len(arguments.failure_id)>#arguments.failure_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.care_id") and len(arguments.care_id)>#arguments.care_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.calender_date") and len(arguments.calender_date)>#arguments.calender_date#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.expense_net") and  len(arguments.expense_net)>#arguments.expense_net#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'					
			)
		</cfquery>
        <!---Fiziki varlıklar Bakım kayıt sayfasında ekleme yaparken Masraf Merkezi ile ilişki kurması için eklendi. --->
        <cfif isdefined("expense_center_id") and len(expense_center_id)>
        <cfquery name="ADD_EXPENSE_CENTER_ID" datasource="#this.DSN#">
            INSERT 
            	EXPENSE_ITEMS_ROWS
            (
                 PYSCHICAL_ASSET_ID,
                 EXPENSE_ID,
                 EXPENSE_CENTER_ID,
                 EXPENSE_COST_TYPE  ,
                 PAPER_TYPE      
             ) 
             VALUES
             (
                 <cfif isdefined("arguments.asset_id") and len(arguments.asset_id)>#arguments.asset_id#<cfelse>NULL</cfif>,
                 <cfif isdefined("arguments.exp_item_name") and len(arguments.exp_item_name)>'#arguments.exp_item_name#'<cfelse>NULL</cfif>,
                 <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                  2,
                 <cfif isdefined("arguments.PAPER_TYPE") and len(arguments.PAPER_TYPE)>'#arguments.PAPER_TYPE#'<cfelse>NULL</cfif>
             ) 
        </cfquery>
        </cfif>
            <cfreturn true>      
     </cffunction>  
       <!---  Bakım Sonucu Güncelle   --->
    <cffunction name="updAssetpCareFnc" access="public" returntype="any">    				
            <cfargument name="care_number" default="">
              <cfargument name="support_finish_date" default="">
            <cfargument name="process_stage" default="">
            <cfargument name="asset_id">
            <cfargument name="service_company_id" default=""> 
            <cfargument name="authorized_id"  default="">
            <cfargument name="station_id"  default="">
            <cfargument name="station_company_id" default="">
            <cfargument name="employee_id" default=""> 
            <cfargument name="employee_id2" default="">
            <cfargument name="care_start_date" default="">  
            <cfargument name="care_finish_date" default="">
            <cfargument name="care_type_id" default="">                     
            <cfargument name="is_yasal_islem">
            <cfargument name="policy_num" default=""> 
            <cfargument name="motorized_vehicle"  default="">
            <cfargument name="care_km"  default="">
            <cfargument name="care_detail" default="">
            <cfargument name="care_detail2" default=""> 
            <cfargument name="bill_id" default="">
            <cfargument name="document_type_id" default="">  
            <cfargument name="expense" default="">
            <cfargument name="is_guaranty" default="">                     
            <cfargument name="project_id" default="">
            <cfargument name="failure_id" default=""> 
            <cfargument name="care_id" default="">
            <cfargument name="calender_date" default="">  
            <cfargument name="expense_net" default="">
            <cfargument name="money_currency" default="">
            <cfargument name="care_report_id" default="">
        	<cfargument name="exp_item_name" default=""> 
            <cfargument name="expense_center_id" default=""> 
            <cfargument name="PAPER_TYPE" default="">  	               
			<cfquery name="UPD_ASSET_CARE" datasource="#this.DSN#">
			UPDATE
				ASSET_CARE_REPORT
			SET
				CARE_REPORT_NUMBER = <cfif Len(arguments.care_number)>'#arguments.care_number#'<cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
				ASSET_ID = #arguments.asset_id#,
				ASSET_TYPE = 'P',
                EXPENSE_ITEM_ROW_ID = <cfif isDefined("arguments.exp_item_name") and len(arguments.exp_item_name)>#arguments.exp_item_name#<cfelse>NULL</cfif>,
				COMPANY_ID = <cfif isDefined("arguments.service_company_id") and len(arguments.service_company_id)>#arguments.service_company_id#<cfelse>NULL</cfif>,
				COMPANY_PARTNER_ID = <cfif isDefined("arguments.authorized_id") and len(arguments.authorized_id)>#arguments.authorized_id#<cfelse>NULL</cfif>,
				STATION_ID=<cfif isDefined("arguments.station_id") and len(arguments.station_id) and len(station_name)>#arguments.station_id#<cfelse>NULL</cfif>,
				OUR_COMPANY_ID = <cfif isdefined("arguments.station_company_id") and len(arguments.station_company_id)>#arguments.station_company_id#<cfelse>NULL</cfif>,
				C_EMPLOYEE1_ID = <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
				C_EMPLOYEE2_ID = <cfif isDefined("arguments.employee_id2") and len(arguments.employee_id2)>#arguments.employee_id2#<cfelse>NULL</cfif>,
				CARE_DATE =<cfif isDefined("arguments.care_start_date") and len(arguments.care_start_date)> #arguments.care_start_date#<cfelseif isdefined("arguments.support_finish_date") and len(arguments.support_finish_date)>#arguments.support_finish_date#<cfelse>NULL</cfif>,
				CARE_FINISH_DATE = <cfif isDefined("arguments.care_finish_date") and len(arguments.care_finish_date)>#arguments.care_finish_date#<cfelse>NULL</cfif>,
				CARE_TYPE =<cfif isDefined("arguments.care_type_id") and len(arguments.care_type_id)> #arguments.care_type_id#<cfelse>NULL</cfif>,
				CARE_KM = <cfif isDefined("arguments.motorized_vehicle") and arguments.motorized_vehicle eq 1>#arguments.care_km#<cfelse>NULL</cfif>,
			<cfif isDefined("arguments.is_yasal_islem") and len(arguments.is_yasal_islem) and arguments.is_yasal_islem eq 1>
				POLICY_NUM = <cfif isDefined("arguments.policy_num") and Len(arguments.policy_num)>'#arguments.policy_num#'<cfelse>NULL</cfif>,
				BILL_ID = NULL,
			<cfelse>
				POLICY_NUM = NULL,
				BILL_ID = <cfif isDefined("arguments.bill_id") and len(arguments.bill_id)>'#arguments.bill_id#'<cfelse>NULL</cfif>,
			</cfif>
				DETAIL = <cfif isDefined("arguments.care_detail") and len(arguments.care_detail)>'#arguments.care_detail#'<cfelse>NULL</cfif>,
				DETAIL2 = <cfif isDefined("arguments.care_detail2") and len(arguments.care_detail2)>'#arguments.care_detail2#'<cfelse>NULL</cfif>,
				DOCUMENT_TYPE_ID = <cfif isDefined("arguments.document_type_id") and len(arguments.document_type_id)>#arguments.document_type_id#<cfelse>NULL</cfif>,
				EXPENSE_AMOUNT = <cfif isDefined("arguments.expense") and  len(arguments.expense)>#arguments.expense#<cfelse>NULL</cfif>,
				AMOUNT_CURRENCY = <cfif isDefined("arguments.money_currency") and len(arguments.expense) and len(arguments.money_currency)>'#arguments.money_currency#'<cfelse>NULL</cfif>,
				IS_YASAL_ISLEM = <cfif isDefined("arguments.is_yasal_islem") and len(arguments.is_yasal_islem)>#arguments.is_yasal_islem#<cfelse>0</cfif>,
				IS_GUARANTY = <cfif isDefined("arguments.is_guaranty") and len(arguments.is_guaranty)>#arguments.is_guaranty#<cfelse>0</cfif>,
				PROJECT_ID = <cfif isDefined("arguments.project_id") and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
				EXPENSE_AMOUNT_NET = <cfif isDefined("arguments.expense_net") and  len(arguments.expense_net)>#arguments.expense_net#<cfelse>NULL</cfif>,
                CALENDER_DATE = <cfif isdefined("arguments.calender_date") and len(arguments.calender_date)>#arguments.calender_date#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				CARE_REPORT_ID = #arguments.care_report_id#
		</cfquery>
         <!---Fiziki varlıklar Bakım kayıt sayfasında ekleme yaparken Masraf Merkezi ile ilişki kurması için eklendi. --->
        <cfif isdefined("expense_center_id") and len(expense_center_id)>
            <cfquery name="GET_EXPENSE_CENTER_ID" datasource="#this.DSN#">
                SELECT 
                    * 
                FROM 
                    EXPENSE_ITEMS_ROWS  
                WHERE 
                     PYSCHICAL_ASSET_ID = <cfif isdefined("arguments.asset_id") and len(arguments.asset_id)>#arguments.asset_id#<cfelse>NULL</cfif>
            </cfquery>
        <cfif GET_EXPENSE_CENTER_ID.recordcount>
            <cfquery name="ADD_EXPENSE_CENTER_ID" datasource="#this.DSN#">
                UPDATE 
                    EXPENSE_ITEMS_ROWS
               SET
                     PYSCHICAL_ASSET_ID = <cfif isdefined("arguments.asset_id") and len(arguments.asset_id)>#arguments.asset_id#<cfelse>NULL</cfif>,
                     EXPENSE_ID = <cfif isdefined("arguments.exp_item_name") and len(arguments.exp_item_name)>'#arguments.exp_item_name#'<cfelse>NULL</cfif>,
                     EXPENSE_CENTER_ID = <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                     EXPENSE_COST_TYPE = 2 ,
                     PAPER_TYPE =  '#arguments.paper_type#'
               WHERE 
                     PYSCHICAL_ASSET_ID = <cfif isdefined("arguments.asset_id") and len(arguments.asset_id)>#arguments.asset_id#<cfelse>NULL</cfif>
                
            </cfquery>
        <cfelse>
            <cfquery name="ADD_EXPENSE_CENTER_ID" datasource="#this.DSN#">
                INSERT 
                    EXPENSE_ITEMS_ROWS
                (
                     PYSCHICAL_ASSET_ID,
                     EXPENSE_ID,
                     EXPENSE_CENTER_ID,
                     EXPENSE_COST_TYPE  ,
                     PAPER_TYPE      
                 ) 
                 VALUES
                 (
                     <cfif isdefined("arguments.asset_id") and len(arguments.asset_id)>#arguments.asset_id#<cfelse>NULL</cfif>,
                     <cfif isdefined("arguments.exp_item_name") and len(arguments.exp_item_name)>'#arguments.exp_item_name#'<cfelse>NULL</cfif>,
                     <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                      2,
                     <cfif isdefined("arguments.PAPER_TYPE") and len(arguments.PAPER_TYPE)>'#arguments.PAPER_TYPE#'<cfelse>NULL</cfif>
                 ) 
            </cfquery>
        </cfif>
        </cfif>
            <cfreturn true>      
     </cffunction>       
          <!--- Bakım Sonucu Listele --->
 <cffunction name="GET_ASSETP_CARE_RESULT_FNC" returntype="query"> 
 
            <cfargument name="station_id" default="">
            <cfargument name="station_name" default="">
            <cfargument name="asset_id" default="">
            <cfargument name="asset_name" default="">
            <cfargument name="assetpcatid" default="">
            <cfargument name="branch" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="keyword" default="">
            <cfargument name="start_date" default="">
            <cfargument name="finish_date" default="">
            <cfargument name="asset_cat" default="">
            <cfargument name="startdate" default="">
            <cfargument name="finishdate" default="">
            <cfargument name="date_format" default=""> 
                                   
 <cfquery name="GET_ASSETCARE_REPORT" datasource="#this.DSN#">
	SELECT
		ASSET_CARE_REPORT.*,
        ASSET_P.*,
		ASSET_P.ASSETP,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P.ASSETP_CATID,
		ASSET_P.DEPARTMENT_ID,
		ZONE.ZONE_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME
	FROM
		ASSET_CARE_REPORT,
		ASSET_P,
		ASSET_P_CAT,
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE
		ASSET_CARE_REPORT.CARE_REPORT_ID IS NOT NULL AND		
		(ASSET_P.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)) AND
		ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID) = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID AND
		ASSET_P.ASSETP_ID = ASSET_CARE_REPORT.ASSET_ID AND 
		ASSET_CARE_REPORT.ASSET_TYPE = 'P'
	  <cfif len(arguments.station_id) and len(arguments.station_name)>AND ASSET_CARE_REPORT.STATION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#"></cfif>
	  <cfif len(arguments.asset_id) and len(arguments.asset_name)>AND ASSET_CARE_REPORT.ASSET_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#"></cfif>
	  <cfif len(arguments.assetpcatid)>
	  	AND ASSET_P.ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetpcatid#">
	  </cfif>  
	  <cfif len(arguments.branch) and len(arguments.branch_id)>
	  	AND ISNULL(ASSET_P.BRANCH_ID,BRANCH.BRANCH_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
	  </cfif>
	  <cfif len(arguments.keyword)>
	  	AND (ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR ASSET_CARE_REPORT.BILL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
	  </cfif>
	  <cfif len(arguments.start_date)>
		AND ASSET_CARE_REPORT.CARE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
	  </cfif>
	  <cfif len(arguments.finish_date)>
		AND ASSET_CARE_REPORT.CARE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',1,arguments.finish_date)#">
	  </cfif>
	  <cfif len(arguments.date_format)>
	  	ORDER BY
			<cfif arguments.date_format eq 1>
				ASSET_CARE_REPORT.CARE_DATE
			<cfelseif arguments.date_format eq 2>
				ASSET_CARE_REPORT.CARE_DATE DESC
			<cfelseif arguments.date_format eq 3>
				DATEDIFF(hh,GETDATE(),CARE_FINISH_DATE)/24
			<cfelseif arguments.date_format eq 4>
				DATEDIFF(hh,GETDATE(),CARE_FINISH_DATE)/24 DESC
			</cfif>
	  </cfif>
</cfquery>
 <cfreturn GET_ASSETCARE_REPORT>
 </cffunction>
           <!--- Alış Satış Listele --->
 <cffunction name="GET_SELL_BUY_FNC" returntype="query"> 
 
            <cfargument name="keyword" default="">
            <cfargument name="asset_cat" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="branch" default="">                     
 <cfquery name="GET_SOLDS" datasource="#this.DSN#">
	SELECT 
		ASSET_P.ASSETP,
		ASSET_P_SOLD.ASSETP_ID, 
		ASSET_P_SOLD.NAME_BUYER,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P_SOLD.TAX_NUM,
		ASSET_P_SOLD.MIN_PRICE,
		ASSET_P_SOLD.MAX_PRICE,
		ASSET_P_SOLD.MIN_MONEY,
		ASSET_P_SOLD.MAX_MONEY,
		ASSET_P_SOLD.RECORD_DATE,
		ASSET_P_SOLD.ASSET_P_SOLD_ID,
		ASSET_P_SOLD.IS_TRANSFERED,
		ASSET_P_SOLD.SALE_CURRENCY,
		ASSET_P_SOLD.SALE_CURRENCY_MONEY,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM 
		ASSET_P_SOLD, 
		ASSET_P,
		ASSET_P_CAT,
		BRANCH,
		DEPARTMENT
	WHERE 
		ASSET_P_SOLD.ASSETP_ID = ASSET_P.ASSETP_ID AND 
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND 
		<!--- Sadece yetkili olunan şubeler gözüksün. --->
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
		ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		<cfif len(arguments.keyword)>AND ASSET_P.ASSETP LIKE '%#arguments.keyword#%'</cfif> 
		<cfif len(arguments.asset_cat)>AND ASSET_P.ASSETP_CATID = #arguments.asset_cat#</cfif>
		<cfif len(arguments.branch_id) and len(arguments.branch)>AND BRANCH.BRANCH_ID = #arguments.branch_id#</cfif>
	ORDER BY 
		ASSET_P.ASSETP 
</cfquery>
 <cfreturn GET_SOLDS>
 </cffunction>
 <!--- Alış Satış Güncelle. --->
 <cffunction name="UPD_SELL_BUY_FNC"> 
            <cfargument name="position_name" default="">
            <cfargument name="position_code" default="">
            <cfargument name="tel_num1" default="">
            <cfargument name="tel_num2" default="">
            <cfargument name="gsm_num1" default="">
            <cfargument name="adress_buyer" default="">
            <cfargument name="gsm_num2" default="">
            <cfargument name="tax_num" default="">
            <cfargument name="detail" default="">
            <cfargument name="transfer_date" default="">
            <cfargument name="is_paid" default="">
            <cfargument name="is_transfered" default="">
            <cfargument name="sale_currency" default="">
            <cfargument name="sale_currency_money" default=""> 
            <cfargument name="driving_licence" default=""> 
            <cfargument name="sold_id" default="">  
            <cfquery name="UPD_SOLD" datasource="#this.DSN#">
			UPDATE 
				ASSET_P_SOLD
			SET
				NAME_BUYER = '#arguments.position_name#',
				COMPANY_ID_BUYER = <cfif isDefined('arguments.position_code') and len(arguments.position_code)>#arguments.position_code#<cfelse>NULL</cfif>,
				TEL_AREA_CODE = <cfif len(arguments.tel_num1)>#arguments.tel_num1#<cfelse>NULL</cfif>,
				TEL_NUM_BUYER = <cfif len(arguments.tel_num2)>'#arguments.tel_num2#'<cfelse>NULL</cfif>,
				GSM_CODE = <cfif len(arguments.gsm_num1)>#arguments.gsm_num1#<cfelse>NULL</cfif>,
				ADRESS_BUYER = <cfif len(arguments.adress_buyer)>'#arguments.adress_buyer#'<cfelse>NULL</cfif>,
				GSM_NUM_BUYER = <cfif len(arguments.gsm_num2)>'#arguments.gsm_num2#'<cfelse>NULL</cfif>,
				TAX_NUM = <cfif len(arguments.tax_num)>'#arguments.tax_num#'<cfelse>NULL</cfif>,
				DESCRIPTION = <cfif len(arguments.detail)>'#form.detail#'<cfelse>NULL</cfif>,		
				TRANSFER_DATE = <cfif len(arguments.transfer_date)>#arguments.transfer_date#<cfelse>NULL</cfif>,		
				IS_PAID = <cfif isDefined("arguments.is_paid")>1<cfelse>0</cfif>,
				<cfif isDefined("arguments.is_transfered")>IS_TRANSFERED = 1,</cfif>
				SALE_CURRENCY = <cfif len(arguments.sale_currency)>#arguments.sale_currency#<cfelse>NULL</cfif>,
				SALE_CURRENCY_MONEY = <cfif len(arguments.sale_currency_money) and len(arguments.sale_currency)>'#arguments.sale_currency_money#'<cfelse>NULL</cfif>,
				DRIVING_LICENCE = <cfif len(arguments.driving_licence)>'#arguments.driving_licence#'<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#'		
			WHERE
				ASSET_P_SOLD_ID = #arguments.sold_id#
		</cfquery>		
            <cfreturn true>
          </cffunction> 
</cfcomponent> 
