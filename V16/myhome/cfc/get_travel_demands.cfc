<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
	</cfscript>
    <cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="travel_demands" access="public" returntype="query">
    	<cfargument name="employee_id" required="no" type="numeric"/>
        <cfargument name="travel_demand_id" required="no" type="numeric">
        <cfargument name="is_valid_control" required="no" type="numeric">
        <cfargument name="keyword" required="no" type="string">
        <cfargument name="branch_id" required="no" type="string">
        <cfargument name="comp_id" required="no" type="string">
        <cfargument name="department_id" required="no" type="string">
        <cfargument name="process_stage" type="string">
		<cfquery name="get_travel_demands" datasource="#dsn#">
			SELECT      
                TD.TRAVEL_DEMAND_ID,       
                TD.PAPER_NO,
                TD.EMP_POSITION_ID,
                TD.EMPLOYEE_ID,
                TD.EMP_DEPARTMENT_ID,
                TD.PLACE,
                TD.CITY,
                TD.IS_COUNTRY,
                TD.TRAVEL_TYPE,
                TD.PROJECT_ID,
                TD.IS_TOP_TITLE_LIMIT,
                TD.TOP_TITLE_ID,
                TD.TASK_CAUSES,
                E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS EMPNAME_SURNAME,
                D.DEPARTMENT_HEAD,
                B.BRANCH_NAME,
                OC.NICK_NAME,
                PTR.STAGE,
                TD.DEPARTURE_DATE,
                TD.DEPARTURE_OF_DATE,
                TD.FARE,
                TD.FARE_TYPE,
                TD.TASK_DETAIL,
                TD.ACTIVITY_START_DATE,
                TD.ACTIVITY_FINISH_DATE,
                TD.ACTIVITY_FARE,
                TD.ACTIVITY_FARE_MONEY_TYPE,
                TD.ACTIVITY_DETAIL,
                TD.FLIGHT_DEPARTURE_DATE,
                TD.FLIGHT_DEPARTURE_OF_DATE,
                TD.AIRFARE,
                TD.AIRFARE_MONEY_TYPE,
                TD.FLIGHT_DETAIL,
                TD.TRAVEL_VEHICLE,
                TD.ACTIVITY_ADDRESS,
                TD.ACTIVITY_WEBSITE,
                TD.IS_VEHICLE_DEMAND,
                TD.IS_HOTEL_DEMAND,
                TD.HOTEL_PAYMENT,
                TD.IS_VISA_REQUIREMENT,
                TD.FLIGHT_CLASS_DEMAND,
                TD.DEMAND_CAUSE,
                TD.HOTEL_NAME,
                TD.NIGHT_FARE,
                TD.NIGHT_FARE_MONEY_TYPE,
                TD.VISA_FARE,
                TD.VISA_FARE_MONEY_TYPE,
                TD.IS_TRAVEL_ADVANCE_DEMAND,
                TD.TRAVEL_ADVANCE_DEMAND_FARE,
                TD.TRAVEL_ADVANCE_DEMAND_TYPE,
                TD.IS_HOTEL_ADVANCE_DEMAND,
                TD.HOTEL_ADVANCE_DEMAND_FARE,
                TD.HOTEL_ADVANCE_DEMAND_TYPE,
                TD.IS_DEPARTURE_FEE,
                TD.DEMAND_STAGE,
                TD.MANAGER1_POS_CODE,
                TD.VALID_DETAIL,
                TD.RECORD_DATE,
                TD.RECORD_EMP,
                TD.RECORD_IP,
                TD.UPDATE_EMP,
                TD.UPDATE_DATE,
               	TD.MANAGER1_VALID_DATE,
                TD.MANAGER1_VALID,
                TD.MANAGER1_EMP_ID,
                TD.MANAGER2_VALID_DATE,
                TD.MANAGER2_VALID,
                TD.MANAGER2_EMP_ID,
                TD.MANAGER1_POS_CODE,
                (SELECT   
                    CASE 
                        WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                            THEN '/documents/hr/'+E.PHOTO 
                        WHEN E.PHOTO IS NULL AND ED.SEX = 0
                            THEN  '/images/female.jpg'
                    ELSE '/images/male.jpg' END AS AA
                FROM 
                    EMPLOYEES E,
                    EMPLOYEES_DETAIL ED
                WHERE  
                    E.EMPLOYEE_ID =  TD.EMPLOYEE_ID
                    AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                ) AS PHOTO
            FROM
            	EMPLOYEES_TRAVEL_DEMAND TD INNER JOIN EMPLOYEES E
                ON TD.EMPLOYEE_ID = E.EMPLOYEE_ID
                INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = TD.EMP_DEPARTMENT_ID
                INNER JOIN BRANCH B  ON B.BRANCH_ID = D.BRANCH_ID
                INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                INNER JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = TD.DEMAND_STAGE
            WHERE
            	TD.EMPLOYEE_ID IS NOT NULL
               	<cfif isdefined('arguments.employee_id')>
					AND TD.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif isdefined('arguments.travel_demand_id')>
                	AND TD.TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.travel_demand_id#">
                </cfif>
                <cfif isdefined('arguments.is_valid_control') and arguments.is_valid_control eq 1><!--- onay bekleyen --->
               		AND
                    	(
                        	TD.MANAGER1_POS_CODE = <cfif isDefined("session.ep.position_code")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"></cfif>
                            AND TD.MANAGER1_VALID IS NULL
                            AND TD.MANAGER1_VALID_DATE IS NULL
                        )
                </cfif>
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
					AND 
                    	(
                        	E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                            OR TD.PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                        )
                </cfif>
                <cfif isdefined('arguments.comp_id') and len(arguments.comp_id)>
                	AND OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
                </cfif>
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                	AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
                	AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list="yes">)
                </cfif>
                <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
					AND TD.DEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
                <cfif isdefined('arguments.startdate') and len(arguments.startdate) and isdefined('arguments.finishdate') and len(arguments.finishdate)>
				AND 
                (
					(
						TD.DEPARTURE_DATE <= #arguments.startdate# AND
						TD.DEPARTURE_OF_DATE >= #arguments.finishdate#
					)
					OR
					(
                        TD.DEPARTURE_DATE >= #arguments.startdate# AND
                        TD.DEPARTURE_DATE <= #arguments.finishdate#
					)
					OR
					(
                        TD.DEPARTURE_OF_DATE >= #arguments.startdate# AND
                        TD.DEPARTURE_OF_DATE <= #arguments.finishdate#
					)
                )   
                </cfif>   
            ORDER BY
            	TD.RECORD_DATE DESC          
        </cfquery>
  <cfreturn get_travel_demands>
</cffunction>
<cffunction name="add_travel_demand" access="public" returntype="struct">
    <cfargument name="paper_number" default="">
    <cfargument name="emp_position_id" default="">
    <cfargument name="employee_id" default="">
    <cfargument name="emp_department_id" default="">
    <cfargument name="place" default="">
    <cfargument name="city" default="">
    <cfargument name="is_country" default="">
    <cfargument name="travel_type" default="">
    <cfargument name="project_id" default="">
    <cfargument name="is_top_title_limit" default="">
    <cfargument name="top_title_id" default="">
    <cfargument name="task_causes" default="">
    <cfargument name="departure_date" default="">
    <cfargument name="departure_of_date" default="">
    <cfargument name="fare" default="">
    <cfargument name="fare_type" default="">
    <cfargument name="task_detail" default="">
    <cfargument name="activity_start_date" default="">
    <cfargument name="activity_finish_date" default="">
    <cfargument name="activity_fare" default="">
    <cfargument name="activity_fare_money_type" default="">
    <cfargument name="activity_detail" default="">
    <cfargument name="flight_departure_date" default="">
    <cfargument name="flight_departure_of_date" default="">
    <cfargument name="airfare" default="">
    <cfargument name="airfare_money_type" default="">
    <cfargument name="flight_detail" default="">
    <cfargument name="travel_vehicle" default="">
    <cfargument name="activity_address" default="">
    <cfargument name="activity_website" default="">
    <cfargument name="is_vehicle_demand" default="">
    <cfargument name="is_hotel_demand" default="">
    <cfargument name="hotel_payment" default="">
    <cfargument name="is_visa_requirement" default="">
    <cfargument name="flight_class_demand" default="">
    <cfargument name="demand_cause" default="">
    <cfargument name="hotel_name" default="">
    <cfargument name="night_fare" default="">
    <cfargument name="night_fare_money_type" default="">
    <cfargument name="visa_fare" default="">
    <cfargument name="visa_fare_money_type" default="">
    <cfargument name="is_travel_advance_demand" default="">
    <cfargument name="travel_advance_demand_fare" default="">
    <cfargument name="travel_advance_demand_type" default="">
    <cfargument name="is_hotel_advance_demand" default="">
    <cfargument name="hotel_advance_demand_fare" default="">
    <cfargument name="hotel_advance_demand_type" default="">
    <cfargument name="is_departure_fee" default="">
    <cfargument name="process_stage" default="">
    <cfquery name="add_travel_demand" datasource="#dsn#" result="MAX_ID">
        INSERT INTO
            EMPLOYEES_TRAVEL_DEMAND
            (
                 PAPER_NO
                ,EMP_POSITION_ID
                ,EMPLOYEE_ID
                ,EMP_DEPARTMENT_ID
                ,PLACE
                ,CITY
                ,IS_COUNTRY
                ,TRAVEL_TYPE
                ,PROJECT_ID
                ,IS_TOP_TITLE_LIMIT
                ,TOP_TITLE_ID
                ,TASK_CAUSES
                ,DEPARTURE_DATE
                ,DEPARTURE_OF_DATE
                ,FARE
                ,FARE_TYPE
                ,TASK_DETAIL
                ,ACTIVITY_START_DATE
                ,ACTIVITY_FINISH_DATE
                ,ACTIVITY_FARE
                ,ACTIVITY_FARE_MONEY_TYPE
                ,ACTIVITY_DETAIL
                ,FLIGHT_DEPARTURE_DATE
                ,FLIGHT_DEPARTURE_OF_DATE
                ,AIRFARE
                ,AIRFARE_MONEY_TYPE
                ,FLIGHT_DETAIL
                ,TRAVEL_VEHICLE
                ,ACTIVITY_ADDRESS
                ,ACTIVITY_WEBSITE
                ,IS_VEHICLE_DEMAND
                ,IS_HOTEL_DEMAND
                ,HOTEL_PAYMENT
                ,IS_VISA_REQUIREMENT
                ,FLIGHT_CLASS_DEMAND
                ,DEMAND_CAUSE
                ,HOTEL_NAME
                ,NIGHT_FARE
                ,NIGHT_FARE_MONEY_TYPE
                ,VISA_FARE
                ,VISA_FARE_MONEY_TYPE
                ,IS_TRAVEL_ADVANCE_DEMAND
                ,TRAVEL_ADVANCE_DEMAND_FARE
                ,TRAVEL_ADVANCE_DEMAND_TYPE
                ,IS_HOTEL_ADVANCE_DEMAND
                ,HOTEL_ADVANCE_DEMAND_FARE
                ,HOTEL_ADVANCE_DEMAND_TYPE
                ,IS_DEPARTURE_FEE
                ,DEMAND_STAGE
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
            )
            VALUES
            (
                <cfif len(arguments.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_number#"><cfelse>NULL</cfif>,
                <cfif len(arguments.emp_position_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_position_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                <cfif len(arguments.emp_department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_department_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place#"><cfelse>NULL</cfif>,
                <cfif len(arguments.city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_country)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_country#"><cfelse>0</cfif>,
                <cfif len(arguments.travel_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.travel_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_top_title_limit)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_top_title_limit#"><cfelse>0</cfif>,
                <cfif len(arguments.top_title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.top_title_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.task_causes)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task_causes#"><cfelse>NULL</cfif>,
                <cfif len(arguments.departure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.departure_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.departure_of_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.fare_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fare_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.task_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task_detail#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activity_start_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activity_finish_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.activity_fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_fare_money_type#"><cfelse>NULL</cfif>,               
                <cfif len(arguments.activity_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_detail#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flight_departure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flight_departure_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flight_departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flight_departure_of_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.airfare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.airfare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.airfare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.airfare_money_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flight_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.flight_detail#"><cfelse>NULL</cfif>,
                <cfif len(arguments.travel_vehicle)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.travel_vehicle#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_address#"><cfelse>NULL</cfif>,
                <cfif len(arguments.activity_website)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_website#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_vehicle_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_vehicle_demand#"><cfelse>0</cfif>,
                <cfif len(arguments.is_hotel_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_hotel_demand#"><cfelse>0</cfif>,
                <cfif len(arguments.hotel_payment)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hotel_payment#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_visa_requirement)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_visa_requirement#"><cfelse>0</cfif>,
                <cfif len(arguments.flight_class_demand)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flight_class_demand#"><cfelse>NULL</cfif>,
                <cfif len(arguments.demand_cause)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.demand_cause#"><cfelse>NULL</cfif>,
                <cfif len(arguments.hotel_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hotel_name#"><cfelse>NULL</cfif>,
                <cfif len(arguments.night_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.night_fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.night_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.night_fare_money_type#"><cfelse>NULL</cfif>,  
                <cfif len(arguments.visa_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.visa_fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.visa_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.visa_fare_money_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_travel_advance_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_travel_advance_demand#"><cfelse>0</cfif>,
                <cfif len(arguments.travel_advance_demand_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.travel_advance_demand_fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.travel_advance_demand_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.travel_advance_demand_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_hotel_advance_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_hotel_advance_demand#"><cfelse>0</cfif>,
                <cfif len(arguments.hotel_advance_demand_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.hotel_advance_demand_fare#"><cfelse>NULL</cfif>,
                <cfif len(arguments.hotel_advance_demand_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hotel_advance_demand_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_departure_fee)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_departure_fee#"><cfelse>0</cfif>,
                <cfif len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
            )	
    </cfquery>
    <cfreturn MAX_ID>
</cffunction>
<cffunction name="upd_travel_demand" access="public" returntype="any">
    <cfargument name="travel_demand_id" default="">
    <cfargument name="employee_id" default="">
    <cfargument name="place" default="">
    <cfargument name="emp_position_id" default="">
    <cfargument name="emp_department_id" default="">
    <cfargument name="city" default="">
    <cfargument name="is_country" default="">
    <cfargument name="travel_type" default="">
    <cfargument name="project_id" default="">
    <cfargument name="is_top_title_limit" default="">
    <cfargument name="top_title_id" default="">
    <cfargument name="task_causes" default="">
    <cfargument name="departure_date" default="">
    <cfargument name="departure_of_date" default="">
    <cfargument name="fare" default="">
    <cfargument name="fare_type" default="">
    <cfargument name="task_detail" default="">
    <cfargument name="activity_start_date" default="">
    <cfargument name="activity_finish_date" default="">
    <cfargument name="activity_fare" default="">
    <cfargument name="activity_fare_money_type" default="">
    <cfargument name="activity_detail" default="">
    <cfargument name="flight_departure_date" default="">
    <cfargument name="flight_departure_of_date" default="">
    <cfargument name="airfare" default="">
    <cfargument name="airfare_money_type" default="">
    <cfargument name="flight_detail" default="">
    <cfargument name="travel_vehicle" default="">
    <cfargument name="activity_address" default="">
    <cfargument name="activity_website" default="">
    <cfargument name="is_vehicle_demand" default="">
    <cfargument name="is_hotel_demand" default="">
    <cfargument name="hotel_payment" default="">
    <cfargument name="is_visa_requirement" default="">
    <cfargument name="flight_class_demand" default="">
    <cfargument name="demand_cause" default="">
    <cfargument name="hotel_name" default="">
    <cfargument name="night_fare" default="">
    <cfargument name="night_fare_money_type" default="">
    <cfargument name="visa_fare" default="">
    <cfargument name="visa_fare_money_type" default="">
    <cfargument name="is_travel_advance_demand" default="">
    <cfargument name="travel_advance_demand_fare" default="">
    <cfargument name="travel_advance_demand_type" default="">
    <cfargument name="is_hotel_advance_demand" default="">
    <cfargument name="hotel_advance_demand_fare" default="">
    <cfargument name="hotel_advance_demand_type" default="">
    <cfargument name="is_departure_fee" default="">
    <cfargument name="process_stage" default="">
    <cfquery name="upd_travel_demand" datasource="#dsn#">
      	UPDATE
    	    EMPLOYEES_TRAVEL_DEMAND
        SET	 
        EMPLOYEE_ID = <cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
            PLACE = <cfif len(arguments.place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place#"><cfelse>NULL</cfif>,   
            EMP_DEPARTMENT_ID=<cfif len(arguments.emp_department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_department_id#"><cfelse>NULL</cfif>,
            EMP_POSITION_ID =<cfif len(arguments.emp_position_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_position_id#"><cfelse>NULL</cfif>,               
            CITY = <cfif len(arguments.city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#"><cfelse>NULL</cfif>,
            IS_COUNTRY =   <cfif len(arguments.is_country)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_country#"><cfelse>0</cfif>,
            TRAVEL_TYPE = <cfif len(arguments.travel_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.travel_type#"><cfelse>NULL</cfif>,
            PROJECT_ID = <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
            IS_TOP_TITLE_LIMIT =<cfif len(arguments.is_top_title_limit)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_top_title_limit#"><cfelse>0</cfif>,
            TOP_TITLE_ID = <cfif len(arguments.top_title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.top_title_id#"><cfelse>NULL</cfif>,
            TASK_CAUSES = <cfif len(arguments.task_causes)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task_causes#"><cfelse>NULL</cfif>,
            DEPARTURE_DATE = <cfif len(arguments.departure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.departure_date#"><cfelse>NULL</cfif>,
            DEPARTURE_OF_DATE = <cfif len(arguments.departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.departure_of_date#"><cfelse>NULL</cfif>,
            FARE = <cfif len(arguments.fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.fare#"><cfelse>NULL</cfif>,
            FARE_TYPE = <cfif len(arguments.fare_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fare_type#"><cfelse>NULL</cfif>,
            TASK_DETAIL = <cfif len(arguments.task_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task_detail#"><cfelse>NULL</cfif>,
            ACTIVITY_START_DATE = <cfif len(arguments.activity_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activity_start_date#"><cfelse>NULL</cfif>,
            ACTIVITY_FINISH_DATE = <cfif len(arguments.activity_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activity_finish_date#"><cfelse>NULL</cfif>,
            ACTIVITY_FARE = <cfif len(arguments.activity_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.activity_fare#"><cfelse>NULL</cfif>,
            ACTIVITY_FARE_MONEY_TYPE = <cfif len(arguments.activity_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_fare_money_type#"><cfelse>NULL</cfif>,               
            ACTIVITY_DETAIL = <cfif len(arguments.activity_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_detail#"><cfelse>NULL</cfif>,
            FLIGHT_DEPARTURE_DATE = <cfif len(arguments.flight_departure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flight_departure_date#"><cfelse>NULL</cfif>,
            FLIGHT_DEPARTURE_OF_DATE = <cfif len(arguments.flight_departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flight_departure_of_date#"><cfelse>NULL</cfif>,
            AIRFARE = <cfif len(arguments.airfare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.airfare#"><cfelse>NULL</cfif>,
            AIRFARE_MONEY_TYPE = <cfif len(arguments.airfare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.airfare_money_type#"><cfelse>NULL</cfif>,
            FLIGHT_DETAIL = <cfif len(arguments.flight_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.flight_detail#"><cfelse>NULL</cfif>,
            TRAVEL_VEHICLE = <cfif len(arguments.travel_vehicle)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.travel_vehicle#"><cfelse>NULL</cfif>,
            ACTIVITY_ADDRESS = <cfif len(arguments.activity_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_address#"><cfelse>NULL</cfif>,
            ACTIVITY_WEBSITE = <cfif len(arguments.activity_website)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity_website#"><cfelse>NULL</cfif>,
            IS_VEHICLE_DEMAND = <cfif len(arguments.is_vehicle_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_vehicle_demand#"><cfelse>0</cfif>,
            IS_HOTEL_DEMAND =<cfif len(arguments.is_hotel_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_hotel_demand#"><cfelse>0</cfif>,
            HOTEL_PAYMENT = <cfif len(arguments.hotel_payment)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hotel_payment#"><cfelse>NULL</cfif>,
            IS_VISA_REQUIREMENT = <cfif len(arguments.is_visa_requirement)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_visa_requirement#"><cfelse>0</cfif>,
            FLIGHT_CLASS_DEMAND = <cfif len(arguments.flight_class_demand)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flight_class_demand#"><cfelse>NULL</cfif>,
            DEMAND_CAUSE = <cfif len(arguments.demand_cause)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.demand_cause#"><cfelse>NULL</cfif>,
            HOTEL_NAME = <cfif len(arguments.hotel_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hotel_name#"><cfelse>NULL</cfif>,
            NIGHT_FARE =  <cfif len(arguments.night_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.night_fare#"><cfelse>NULL</cfif>,
            NIGHT_FARE_MONEY_TYPE = <cfif len(arguments.night_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.night_fare_money_type#"><cfelse>NULL</cfif>,  
            VISA_FARE = <cfif len(arguments.visa_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.visa_fare#"><cfelse>NULL</cfif>,
            VISA_FARE_MONEY_TYPE = <cfif len(arguments.visa_fare_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.visa_fare_money_type#"><cfelse>NULL</cfif>,
            IS_TRAVEL_ADVANCE_DEMAND =<cfif len(arguments.is_travel_advance_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_travel_advance_demand#"><cfelse>0</cfif>,
            TRAVEL_ADVANCE_DEMAND_FARE = <cfif len(arguments.travel_advance_demand_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.travel_advance_demand_fare#"><cfelse>NULL</cfif>,
            TRAVEL_ADVANCE_DEMAND_TYPE = <cfif len(arguments.travel_advance_demand_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.travel_advance_demand_type#"><cfelse>NULL</cfif>,
            IS_HOTEL_ADVANCE_DEMAND = <cfif len(arguments.is_hotel_advance_demand)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_hotel_advance_demand#"><cfelse>0</cfif>,
            HOTEL_ADVANCE_DEMAND_FARE = <cfif len(arguments.hotel_advance_demand_fare)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.hotel_advance_demand_fare#"><cfelse>NULL</cfif>,
            HOTEL_ADVANCE_DEMAND_TYPE = <cfif len(arguments.hotel_advance_demand_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hotel_advance_demand_type#"><cfelse>NULL</cfif>,
            IS_DEPARTURE_FEE = <cfif len(arguments.is_departure_fee)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_departure_fee#"><cfelse>0</cfif>,
            DEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        WHERE
    	    TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAVEL_DEMAND_ID#">
    </cfquery>
</cffunction>
<cffunction name="upd_travel_demand_valid" access="public" returntype="any">
    <cfargument name="travel_demand_id" default="">
    <cfargument name="process_stage" default="">
    <cfquery name="upd_travel_demand_valid" datasource="#dsn#">
      	UPDATE
    	    EMPLOYEES_TRAVEL_DEMAND
        SET	 
            DEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
        WHERE
    	    TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAVEL_DEMAND_ID#">
    </cfquery>
</cffunction>
<cffunction name="get_department" access="public" returntype="query">
    <cfargument name="position_code" default="">
    <cfquery name="get_department" datasource="#dsn#">
        SELECT
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            OC.NICK_NAME
        FROM 
            EMPLOYEE_POSITIONS EP INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
            INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
        WHERE
            EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
    </cfquery>
    <cfreturn get_department>
</cffunction>
<cffunction name="GET_COUNTRY" access="public" returntype="query">
    <cfquery name="GET_COUNTRY" datasource="#DSN#">
        SELECT
            COUNTRY_ID,
            COUNTRY_NAME,
            COUNTRY_PHONE_CODE,
            IS_DEFAULT
        FROM
            SETUP_COUNTRY
        ORDER BY
            COUNTRY_NAME
    </cfquery>
    <cfreturn GET_COUNTRY>
</cffunction>
<cffunction name="GET_CITY" access="public" returntype="query">
    <cfquery name="GET_CITY" datasource="#DSN#">
        SELECT
            CITY_ID,
            CITY_NAME,
            COUNTRY_ID,
            PHONE_CODE
        FROM
            SETUP_CITY
            WHERE  COUNTRY_ID = 1
        ORDER BY
            CITY_NAME
    </cfquery>
    <cfreturn GET_CITY>
</cffunction>
<cffunction name="get_position_detail" access="public" returntype="query">
    <cfquery name="get_position_detail" datasource="#dsn#">
        SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1
    </cfquery>
    <cfreturn get_position_detail>
</cffunction>
<cffunction name="GET_MONEY" access="public" returntype="query">
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT MONEY_ID, RATE1, RATE2, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
    </cfquery>
    <cfreturn GET_MONEY>
</cffunction>
<cffunction name="get_emp_pos" access="public" returntype="query">
    <cfargument name="position_id" default="">
    <cfquery name="get_emp_pos" datasource="#dsn#">
        SELECT POSITION_CODE,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
    </cfquery>
    <cfreturn get_emp_pos>
</cffunction>
<cffunction name="get_payment_request" access="public" returntype="query">
    <cfargument name="travel_demand_id" default="">
    <cfquery name="get_payment_request" datasource="#dsn#">
        SELECT
            EMPLOYEES_TRAVEL_DEMAND.*,
            PTR.STAGE
        FROM
            EMPLOYEES_TRAVEL_DEMAND	
            LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EMPLOYEES_TRAVEL_DEMAND.DEMAND_STAGE
          WHERE
            TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.travel_demand_id#">
    </cfquery>
    <cfreturn get_payment_request>
</cffunction>
<cffunction name="get_stage_name" access="public" returntype="query">
    <cfargument name="process_id" default="">
    <cfquery name="get_stage_name" datasource="#dsn#">
         SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#">
    </cfquery>
    <cfreturn get_stage_name>
</cffunction>
<cffunction name="get_employee_position">
    <cfargument name="employee_id">
    <cfquery name="query_employee_position" datasource="#dsn#">
      SELECT POSITION_CAT_ID
      FROM 
      EMPLOYEE_POSITIONS
      WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.employee_id#">
    </cfquery>
    <cfif query_employee_position.recordcount gt 0>
      <cfreturn query_employee_position.POSITION_CAT_ID>
    <cfelse>
      <cfreturn "">
    </cfif>
  </cffunction> 
</cfcomponent>
