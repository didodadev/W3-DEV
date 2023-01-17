<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="use">
    	<cfargument name="other_parameters2" default="">
		<cfargument name="other_parameter" default="">
        <cfargument name="START_DATE" default="">
        <cfargument name="FINISH_DATE" default="">
        <cfparam name="session.ep.company_id" default="1">
        <cfset dsn_1 = '#dsn#_#session.ep.company_id#'> 
        <cftry>
        <cfset A=0>
		<cfif len(arguments.other_parameters2)>
          <cfloop list="#arguments.other_parameters2#" delimiters="█" index="opind">
          <cfset A = A + 1>
          <cfif A eq 3 >
				<cfset 'other_parmater_name3' = ListGetAt(opind,1,'§')>
                <cfset 'other_parmater_value3' = ListGetAt(opind,2,'§')>
		  </cfif>
          </cfloop>
          <cfset A = 2>
        </cfif>
        <cfcatch>
			<cfset A=-1>
        </cfcatch>
        </cftry>
        
        <cfquery name="reservs" datasource="#dsn#">
           SELECT  
                DISTINCT(WORKSTATION_RESERVATION.WS_RESERVATION_ID),
                START_DATE,
                FINISH_DATE,
                WORKSTATION_ID,
                PSYCALASSET_ID,
                COMPANY_ID,
                CONSUMER_ID,
                PARTNER_ID,
                DEPARTMENT_ID,
                STATION_ID,
                (SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = WORKSTATION_RESERVATION.PSYCALASSET_ID) AS ASSETP,
                (SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = WORKSTATION_RESERVATION.COMPANY_ID) AS FULLNAME,
                (SELECT CONSUMER_NAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_NAME,
                (SELECT CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_SURNAME,
                (SELECT COMPANY_PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_NAME,
                (SELECT COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_SURNAME,
                (SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = WORKSTATION_RESERVATION.DEPARTMENT_ID) AS DEPARTMENT,
                (SELECT STATION_NAME FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS STATION_NAME,
                (SELECT WIDTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS WIDTH,
                (SELECT LENGTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS LENGTH,
                (SELECT HEIGHT FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS HEIGHT
           FROM
                WORKSTATION_RESERVATION,
                #dsn_1#.WORKSTATIONS AS WORKSTATIONS
           WHERE
	           	WORKSTATION_RESERVATION.WORKSTATION_ID = WORKSTATIONS.STATION_ID
                 <cfif len(arguments.START_DATE) AND len(arguments.FINISH_DATE)>
				 AND (START_DATE BETWEEN #START_DATE# AND #FINISH_DATE#
                 OR FINISH_DATE BETWEEN #START_DATE# AND #FINISH_DATE#)
				 </cfif>
           ORDER BY WORKSTATION_RESERVATION.START_DATE DESC;
         </cfquery>
       <cfreturn use>
    </cffunction>
    
    <cffunction name="getReservs">
    	<cfargument name="other_parameters2" default="">
        <cfargument name="COMPANY_ID" default="">
        <cfargument name="CONSUMER_ID" default="">
        <cfargument name="START_DATE" default="">
        <cfargument name="FINISH_DATE" default="">
        <cfargument name="STATION_ID" default="">
        <cfargument name="DEPARTMENT_ID" default="">
        <cfparam name="session.ep.company_id" default="1">
        <cfset dsn_1 = '#dsn#_#session.ep.company_id#'> 
        <cftry>
        <cfset A=0>
		<cfif len(arguments.other_parameters2)>
          <cfloop list="#arguments.other_parameters2#" delimiters="█" index="opind">
           <cfset A = A + 1>
          <cfif A eq 3 >
				<cfset 'other_parmater_name3' = ListGetAt(opind,1,'§')>
                <cfset 'other_parmater_value3' = ListGetAt(opind,2,'§')>
		  </cfif>
          </cfloop>
          <cfset A = 2>
        </cfif>
        <cfcatch><cfset A=-1></cfcatch></cftry>
        
        <cfquery name="reservs" datasource="#dsn#">
           SELECT  
                DISTINCT(WORKSTATION_RESERVATION.WS_RESERVATION_ID),
                START_DATE,
                FINISH_DATE,
                WORKSTATION_ID,
                PSYCALASSET_ID,
                COMPANY_ID,
                CONSUMER_ID,
                PARTNER_ID,
                DEPARTMENT_ID,
                STATION_ID,
                (SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = WORKSTATION_RESERVATION.PSYCALASSET_ID) AS ASSETP,
                (SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = WORKSTATION_RESERVATION.COMPANY_ID) AS FULLNAME,
                (SELECT CONSUMER_NAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_NAME,
                (SELECT CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_SURNAME,
                (SELECT COMPANY_PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_NAME,
                (SELECT COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_SURNAME,
                (SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = WORKSTATION_RESERVATION.DEPARTMENT_ID) AS DEPARTMENT,
                (SELECT STATION_NAME FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS STATION_NAME,
                (SELECT WIDTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS WIDTH,
                (SELECT LENGTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS LENGTH,
                (SELECT HEIGHT FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS HEIGHT
           FROM
                WORKSTATION_RESERVATION,
                #dsn_1#.WORKSTATIONS AS WORKSTATIONS
           WHERE
	           	WORKSTATION_RESERVATION.WORKSTATION_ID = WORKSTATIONS.STATION_ID
                <cfif A eq 2 >AND WORKSTATION_RESERVATION.DEPARTMENT_ID = #other_parmater_value3#</cfif>
                <cfif len(arguments.STATION_ID)>AND STATION_ID=#arguments.STATION_ID#</cfif>
                <cfif len(arguments.COMPANY_ID)>AND COMPANY_ID=#arguments.COMPANY_ID#</cfif>
                <cfif len(arguments.CONSUMER_ID)>AND CONSUMER_ID=#arguments.CONSUMER_ID#</cfif>
                <cfif len(arguments.DEPARTMENT_ID)>AND DEPARTMENT_ID=#arguments.DEPARTMENT_ID#</cfif>
                 <cfif len(arguments.START_DATE) AND len(arguments.FINISH_DATE)>
				 AND (START_DATE BETWEEN #START_DATE# AND #FINISH_DATE#
                 OR FINISH_DATE BETWEEN #START_DATE# AND #FINISH_DATE#)
				 </cfif>
           ORDER BY WORKSTATION_RESERVATION.START_DATE DESC;
         </cfquery>
       <cfreturn reservs>
    </cffunction>

    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfargument name="other_parameters" default="">
        <cfparam name="session.ep.company_id" default="1">
       	<cfset dsn_1 = '#dsn#_#session.ep.company_id#'>  
        	<cfquery name="get_workstation_reservation_r" datasource="#dsn#">
               SELECT  
                    DISTINCT(WORKSTATION_RESERVATION.WS_RESERVATION_ID),
                    START_DATE,
                    FINISH_DATE,
                    WORKSTATION_ID,
                    PSYCALASSET_ID,
                    COMPANY_ID,
                    CONSUMER_ID,
                    PARTNER_ID,
                    BRANCH_ID,
                    STATION_ID,
                    (SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = WORKSTATION_RESERVATION.PSYCALASSET_ID) AS ASSETP,
                    (SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = WORKSTATION_RESERVATION.COMPANY_ID) AS FULLNAME,
                    (SELECT CONSUMER_NAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_NAME,
                    (SELECT CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = WORKSTATION_RESERVATION.CONSUMER_ID) AS CONSUMER_SURNAME,
                    (SELECT COMPANY_PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_NAME,
                    (SELECT COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = WORKSTATION_RESERVATION.PARTNER_ID) AS COMPANY_PARTNER_SURNAME,
                    (SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = WORKSTATION_RESERVATION.BRANCH_ID) AS BRANCH,
                    (SELECT STATION_NAME FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS STATION_NAME,
                    (SELECT WIDTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS WIDTH,
                    (SELECT LENGTH FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS LENGTH,
                    (SELECT HEIGHT FROM #dsn_1#.WORKSTATIONS WHERE STATION_ID = WORKSTATION_RESERVATION.WORKSTATION_ID) AS HEIGHT
               FROM
               		WORKSTATION_RESERVATION,
                    #dsn_1#.WORKSTATIONS AS WORKSTATIONS
               WHERE
                    WORKSTATION_RESERVATION.WORKSTATION_ID = WORKSTATIONS.STATION_ID
                    <cftry>
                <cfif len(arguments.other_parameters)>
	              <cfset x=0>
                  <cfloop list="#arguments.other_parameters#" delimiters="█" index="opind">
                  	<cfset x = x + 1>
                    	<cfif x eq 1>
							<cfset 'other_parmater_name1' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value1'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 2>
                        	<cfset 'other_parmater_name2' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value2'= ListGetAt(opind,2,'§')> 
                        <cfelseif x eq 3>
                        	<cfset 'other_parmater_name3' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value3'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 4>
                        	<cfset 'other_parmater_name4' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value4'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 5>
                        	<cfset 'other_parmater_name5' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value5'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 6>
                        	<cfset 'other_parmater_name6' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value6'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 7>
                        	<cfset 'other_parmater_name7' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value7'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 8>
                        	<cfset 'other_parmater_name8' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value8'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 9>
                        	<cfset 'other_parmater_name9' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value9'= ListGetAt(opind,2,'§')>
                        <cfelseif x eq 10>
                        	<cfset 'other_parmater_name10' = ListGetAt(opind,1,'§')>
                        	<cfset 'other_parmater_value10'= ListGetAt(opind,2,'§')>
						</cfif>
                  </cfloop>
                  AND WORKSTATIONS.BRANCH = #other_parmater_value3# 
				  AND WORKSTATIONS.ACTIVE = 1
       			  AND (#other_parmater_name1# BETWEEN <cf_date tarih='other_parmater_value1'> #DATEADD('h',other_parmater_value4,DATEADD('n',other_parmater_value5,other_parmater_value1))# AND <cf_date tarih='other_parmater_value2'>#DATEADD('h',other_parmater_value6,DATEADD('n',other_parmater_value7,other_parmater_value2))# 
                  OR #other_parmater_name2# BETWEEN #DATEADD('h',other_parmater_value4,DATEADD('n',other_parmater_value5,other_parmater_value1))# AND #DATEADD('h',other_parmater_value6,DATEADD('n',other_parmater_value7,other_parmater_value2))#)
               </cfif>
            <cfcatch></cfcatch>
			</cftry>  
			</cfquery>
            <cfquery name="get_workstation_reservation" datasource="#dsn_1#">
               SELECT  
                    CASE WHEN (WS.UP_STATION IS NOT NULL) 
					  THEN
						(SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = WS.UP_STATION) +' - '+ WS.STATION_NAME
					  ELSE
						WS.STATION_NAME
					  END AS STATION_NAME,
					WS.STATION_ID,
					WS.WIDTH,
					WS.HEIGHT,
					WS.LENGTH,
					WS.UP_STATION
               FROM
               		WORKSTATIONS WS
               WHERE
                    WS.BRANCH IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				   <cfif len(arguments.keyword)>
                        AND STATION_NAME LIKE '%#arguments.keyword#%'
                   </cfif> 
                   AND WS.ACTIVE = 1
				   <cftry>     
					<cfif isdefined('other_parmater_value8') and len(other_parmater_value8)>AND WS.WIDTH >= #other_parmater_value8#</cfif>
                    <cfif isdefined('other_parmater_value10') and len(other_parmater_value10)>AND WS.HEIGHT >= #other_parmater_value10#</cfif>
                    <cfif isdefined('other_parmater_value9') and len(other_parmater_value9)>AND WS.LENGTH >= #other_parmater_value9#</cfif>
				   <cfif len(arguments.other_parameters)>
                        AND WS.BRANCH = #other_parmater_value3# 
                   <cfloop query="get_workstation_reservation_r">
                        AND WS.STATION_ID != #WORKSTATION_ID#
                   </cfloop>
					</cfif><cfcatch>' '</cfcatch> </cftry>  
               ORDER BY STATION_NAME ASC
			</cfquery>
          <cfreturn get_workstation_reservation>
    </cffunction>
</cfcomponent>


