<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = '#dsn#_product'>
	<cfset dsn1_alias= '#dsn1#'>
	<cfset dsn_alias= '#dsn#'>
	<cfset request.self = '../../../index.cfm'>
	<cfscript>
		if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
		else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
		else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
		else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
		else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
	</cfscript>
	
	<!--- ADD DEMAND --->
	<cffunction name="addDemand" access="remote" returntype="any">
		<cfargument name="company_id" type="numeric" required="yes">
		<cfargument name="partner_id" type="numeric" required="yes">
		<cfargument name="company_name" type="string" required="no">
		<cfargument name="product_category" type="string" required="no">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="demand_head" type="string" required="yes">
		<cfargument name="demand_keyword" type="string" required="no">
		<cfargument name="demand_type" type="numeric" required="no">
		<cfargument name="is_status" type="numeric" required="no" default="1">
		<cfargument name="is_online" type="numeric" required="no" default="0">
		<cfargument name="order_member_type" type="numeric" required="no">
		<cfargument name="demand_detail" type="string" required="no">
		<cfargument name="start_date" type="date" required="no">
		<cfargument name="finish_date" type="date" required="no">
		<cfargument name="sector_cat_id" type="numeric" required="no">
		<cfargument name="total_amount" type="string" required="no">
		<cfargument name="money" type="string" required="no">
		<cfargument name="deliver_date" type="string" required="no">
		<cfargument name="deliver_addres" type="string" required="no">
		<cfargument name="paymethod" type="string" required="no">
		<cfargument name="ship_method" type="string" required="no">
        <cfargument name="quantity" type="any" required="no" default="">
        <cfargument name="colour" type="string" required="no" default="">
        <cfargument name="demand_kind" type="string" required="no" default="">
        <cfargument name="project_id" type="string" required="no" default="">

		<cfif isdefined("arguments.start_date") and len(arguments.start_date)>
			<cf_date tarih="arguments.start_date">
		</cfif>
		<cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
			<cf_date tarih="arguments.finish_date">
		</cfif>
		<cfif isdefined("arguments.deliver_date") and len(arguments.deliver_date)>
			<cf_date tarih="arguments.deliver_date">
		</cfif>

		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfif isdefined('arguments.is_status')><cfset arguments.is_status = 1><cfelse><cfset arguments.is_status = 0></cfif>
				
		<cfquery name="add_demand" datasource="#dsn#">
			INSERT INTO
				WORKNET_DEMAND
				(
					DEMAND_HEAD,
					DEMAND_KEYWORD,
					STAGE_ID,
					IS_STATUS,
					COMPANY_ID,
					PARTNER_ID,
					MEMBER_NAME,
					SECTOR_CAT_ID,
					DEMAND_TYPE,
					SHIP_METHOD,
					DELIVER_ADDRES,
					PAYMETHOD,
					DETAIL,
					DELIVER_DATE,
					START_DATE,
					FINISH_DATE,
					TOTAL_AMOUNT,
					MONEY,
					ORDER_MEMBER_TYPE,
					IS_ONLINE,
					RECORD_DATE,
					RECORD_MEMBER,
					RECORD_MEMBER_TYPE,
                    QUANTITY,
                    COLOUR,
                    TYPE,
                    RECORD_IP,
                    PROJECT_ID
				)
				VALUES
				(
					'#trim(arguments.demand_head)#',
					'#trim(arguments.demand_keyword)#',
					#arguments.process_stage#,
					#arguments.is_status#,
					#arguments.company_id#,
					#arguments.partner_id#,
					'#left(arguments.company_name,250)#',
					#arguments.sector_cat_id#,
					#arguments.demand_type#,
					<cfif len(arguments.ship_method)>'#trim(arguments.ship_method)#',<cfelse>NULL,</cfif>
					<cfif len(arguments.deliver_addres)>'#trim(arguments.deliver_addres)#',<cfelse>NULL,</cfif>
					<cfif len(arguments.paymethod)>'#trip(arguments.paymethod)#',<cfelse>NULL,</cfif>
					'#arguments.demand_detail#',
					<cfif len(arguments.deliver_date)>#arguments.deliver_date#,<cfelse>NULL,</cfif>
					<cfif len(arguments.start_date)>#arguments.start_date#,<cfelse>NULL,</cfif>
					<cfif len(arguments.finish_date)>#arguments.finish_date#,<cfelse>NULL,</cfif>
					<cfif len(arguments.total_amount)>#arguments.total_amount#,<cfelse>NULL,</cfif>
					<cfif len(arguments.money)>'#arguments.money#',<cfelse>NULL,</cfif>
					<cfif len(arguments.order_member_type)>#arguments.order_member_type#,<cfelse>NULL,</cfif>
					#arguments.is_online#,
					#now()#,
					<cfif isdefined('session.ep')>
					#session.ep.userid#,
					'EMPLOYEE',
					<cfelseif isdefined('session.pp')>
					#session.pp.userid#,
					'COMPANY',
					</cfif>
                   <cfif len(arguments.quantity)>#arguments.quantity#,<cfelse>NULL,</cfif>
                   <cfif len(arguments.colour)>'#arguments.colour#',<cfelse>NULL,</cfif>
                   <cfif len(arguments.demand_kind)>'#arguments.demand_kind#',<cfelse>NULL,</cfif>
                   '#cgi.remote_addr#',
                   <cfif len(arguments.project_id)>'#arguments.project_id#'<cfelse>NULL</cfif>
				)
		</cfquery>
		
		<cfquery name="GET_MAX_DEMAND" datasource="#DSN#">
			SELECT MAX(DEMAND_ID) AS DEMAND_ID FROM WORKNET_DEMAND
		</cfquery>
		<cfif len(arguments.product_category)>
			<cfloop list="#arguments.product_category#" index="i">
				<cfquery name="ADD_PRODUTCT_CAT" datasource="#DSN#">
					INSERT INTO 
						WORKNET_RELATION_PRODUCT_CAT
					(
						PRODUCT_CATID,
						DEMAND_ID
					)
					VALUES
					(
						#i#,
						#GET_MAX_DEMAND.DEMAND_ID#
					)
				</cfquery>
			</cfloop>
		</cfif>
		
			</cftransaction>
		</cflock>		

<cfif isdefined('session.ep')>
	<cfset process_user_id = session.ep.userid>
<cfelseif  isdefined('session.pp')>
	<cfset process_user_id = session.pp.userid>
</cfif>
<script>
	window.location.href = "<cfoutput>#request.self#?fuseaction=worknet.list_demand&event=upd&demand_id=#get_max_demand.demand_id#</cfoutput>";
</script>	
	</cffunction>
	<!--- UPD DEMAND --->
	<cffunction name="updDemand" access="remote" returntype="any">
		<cfargument name="demand_id" type="numeric" required="yes">
		<cfargument name="company_id" type="numeric" required="yes">
		<cfargument name="partner_id" type="numeric" required="yes">
		<cfargument name="company_name" type="string" required="no">
		<cfargument name="product_category" type="string" required="no">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="demand_head" type="string" required="yes">
		<cfargument name="demand_keyword" type="string" required="no">
		<cfargument name="demand_type" type="numeric" required="no">
		<cfargument name="is_status" type="numeric" required="no" default="1">
		<cfargument name="order_member_type" type="numeric" required="no">
		<cfargument name="demand_detail" type="string" required="no">
		<cfargument name="start_date" type="date" required="no">
		<cfargument name="finish_date" type="date" required="no">
		<cfargument name="sector_cat_id" type="numeric" required="no">
		<cfargument name="total_amount" type="string" required="no">
		<cfargument name="money" type="string" required="no">
		<cfargument name="deliver_date" type="string" required="no">
		<cfargument name="deliver_addres" type="string" required="no">
		<cfargument name="paymethod" type="string" required="no">
		<cfargument name="ship_method" type="string" required="no">
        <cfargument name="quantity" type="any" required="no" default="">
        <cfargument name="colour" type="string" required="no" default="">
        <cfargument name="demand_kind" type="string" required="no" default="">
		<cfargument name="project_id" type="string" required="no" default="">
		
		
		<cfif isdefined("arguments.start_date") and len(arguments.start_date)>
			<cf_date tarih="arguments.start_date">
		</cfif>
		<cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
			<cf_date tarih="arguments.finish_date">
		</cfif>
		<cfif isdefined("arguments.deliver_date") and len(arguments.deliver_date)>
			<cf_date tarih="arguments.deliver_date">
		</cfif>
		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfif isdefined('arguments.is_status')><cfset arguments.is_status = 1><cfelse><cfset arguments.is_status = 0></cfif>
						

		
		<!--- history --->
		<cfquery name="hist_cont" datasource="#dsn#">
			SELECT
				WD.*
			FROM
				WORKNET_DEMAND WD
			WHERE
				WD.DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">
		</cfquery> 
		
		<cfif 	arguments.company_id neq hist_cont.company_id or
				arguments.partner_id neq hist_cont.partner_id or 
				arguments.company_name neq hist_cont.member_name or
				arguments.process_stage neq hist_cont.stage_id or 
				arguments.demand_head neq hist_cont.demand_head or
				arguments.demand_keyword neq hist_cont.demand_keyword or 
				arguments.demand_type neq hist_cont.demand_type or
				arguments.order_member_type neq hist_cont.order_member_type or 
				arguments.demand_detail neq hist_cont.detail or
				arguments.start_date neq hist_cont.start_date or 
				arguments.finish_date neq hist_cont.finish_date or
				arguments.sector_cat_id neq hist_cont.sector_cat_id oR
				arguments.total_amount neq hist_cont.total_amount or 
				arguments.money neq hist_cont.money or
				arguments.deliver_date neq hist_cont.deliver_date or
				arguments.deliver_addres neq hist_cont.deliver_addres or
				arguments.paymethod neq hist_cont.paymethod or 
				arguments.ship_method neq hist_cont.ship_method or
				arguments.project_id neq hist_cont.project_id
				>
				<cfoutput query="hist_cont">
					
					<cfquery name="ADD_DEMAND_HISTORY" datasource="#DSN#">
						INSERT INTO
							WORKNET_DEMAND_HISTORY
						(
							DEMAND_ID,
							DEMAND_HEAD,
							STAGE_ID,
							COMPANY_ID,
							PARTNER_ID,
							MEMBER_NAME,
							SECTOR_CAT_ID,
							IS_STATUS,
							DEMAND_TYPE,
							SHIP_METHOD,
							DELIVER_ADDRES,
							PAYMETHOD,
							DELIVER_DATE,
							START_DATE,
							FINISH_DATE,
							DETAIL,
							TOTAL_AMOUNT,
							MONEY,
							ORDER_MEMBER_TYPE,
							IS_ONLINE,
							DEMAND_KEYWORD,
							RECORD_DATE,
							RECORD_MEMBER,
							RECORD_MEMBER_TYPE,
							RECORD_IP,
							PROJECT_ID
						)
						VALUES
						(
							#arguments.demand_id#,
							<cfif len(hist_cont.demand_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.demand_head#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.stage_id)>#hist_cont.stage_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.company_id)>#hist_cont.company_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.partner_id)>#hist_cont.partner_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.member_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.member_name#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.sector_cat_id)>#hist_cont.sector_cat_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.is_status)>#hist_cont.is_status#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.demand_type)>#hist_cont.demand_type#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.ship_method)>'#hist_cont.ship_method#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.deliver_addres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.deliver_addres#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.paymethod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.paymethod#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.deliver_date)><cfqueryparam cfsqltype="cf_sql_date" value="#hist_cont.deliver_date#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#hist_cont.start_date#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.finish_date)><cfqueryparam cfsqltype="cf_sql_date" value="#hist_cont.finish_date#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.detail#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.total_amount)>#hist_cont.total_amount#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.money#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.order_member_type)>#hist_cont.order_member_type#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.is_online)>#hist_cont.is_online#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.demand_keyword)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hist_cont.demand_keyword#"><cfelse>NULL</cfif>,
							<cfif len(hist_cont.update_date)>'#hist_cont.update_date#'<cfelse>'#hist_cont.record_date#'</cfif>,
							<cfif len(hist_cont.update_member)>#hist_cont.update_member#<cfelse>#hist_cont.record_member#</cfif>,
							<cfif len(hist_cont.update_member_type)>'#hist_cont.update_member_type#'<cfelse>'#hist_cont.record_member_type#'</cfif>,
							<cfif len(hist_cont.update_ip)>'#hist_cont.update_ip#'<cfelse>'#hist_cont.record_ip#'</cfif>,
                            <cfif len(hist_cont.project_id)>'#hist_cont.project_id#'<cfelse>'#hist_cont.project_id#'</cfif>
						)
					</cfquery>
				</cfoutput>
		</cfif>

		<cfquery name="upd_demand" datasource="#dsn#">
			UPDATE
				WORKNET_DEMAND
			SET
				DEMAND_HEAD = '#arguments.demand_head#',
				DEMAND_KEYWORD = '#arguments.demand_keyword#',
				STAGE_ID = #arguments.process_stage#,
				IS_STATUS = #arguments.is_status#,
				COMPANY_ID = #arguments.company_id#,
				PARTNER_ID = #arguments.partner_id#,
				MEMBER_NAME = '#left(arguments.company_name,250)#',
				SECTOR_CAT_ID = #arguments.sector_cat_id#,
				DEMAND_TYPE = #arguments.demand_type#,
				SHIP_METHOD = <cfif len(arguments.ship_method)>'#arguments.ship_method#',<cfelse>NULL,</cfif>
				DELIVER_ADDRES = <cfif len(arguments.deliver_addres)>'#arguments.deliver_addres#',<cfelse>NULL,</cfif>
				PAYMETHOD = <cfif len(arguments.paymethod)>'#arguments.paymethod#',<cfelse>NULL,</cfif>
				DETAIL = '#arguments.demand_detail#',
				DELIVER_DATE = <cfif len(arguments.deliver_date)>#arguments.deliver_date#,<cfelse>NULL,</cfif>
				START_DATE = <cfif len(arguments.start_date)>#arguments.start_date#,<cfelse>NULL,</cfif>
				FINISH_DATE = <cfif len(arguments.finish_date)>#arguments.finish_date#,<cfelse>NULL,</cfif>
				TOTAL_AMOUNT = <cfif len(arguments.total_amount)>#arguments.total_amount#,<cfelse>NULL,</cfif>
				MONEY = <cfif len(arguments.money)>'#arguments.money#',<cfelse>NULL,</cfif>
				ORDER_MEMBER_TYPE = #arguments.order_member_type#,
				UPDATE_DATE = #now()#,
				UPDATE_MEMBER = <cfif isdefined('session.ep')>#session.ep.userid#<cfelseif isdefined('session.pp')>#session.pp.userid#</cfif> ,
				UPDATE_MEMBER_TYPE = <cfif isdefined('session.ep')>'EMPLOYEE'<cfelseif isdefined('session.pp')>'COMPANY'</cfif>,
                QUANTITY = <cfif len(arguments.quantity)>#arguments.quantity#,<cfelse>NULL,</cfif>
                COLOUR = <cfif len(arguments.colour)>'#arguments.colour#',<cfelse>NULL,</cfif>
                TYPE = <cfif len(arguments.demand_kind)>'#arguments.demand_kind#',<cfelse>NULL,</cfif>
                UPDATE_IP = '#cgi.remote_addr#',
                PROJECT_ID=<cfif len(arguments.project_id)>'#arguments.project_id#'<cfelse>NULL</cfif> 
			WHERE
				DEMAND_ID = #arguments.demand_id#
		</cfquery>
		
		<!--- demand of product categories --->
		<cfif len(arguments.product_category)>
			<cfquery name="del_member_product_cat" datasource="#dsn#"> 
				DELETE FROM WORKNET_RELATION_PRODUCT_CAT WHERE DEMAND_ID = #arguments.demand_id#
			</cfquery>
			<cfloop list="#arguments.product_category#" index="i">
				<cfquery name="ADD_PRODUTCT_CAT" datasource="#DSN#">
					INSERT INTO 
						WORKNET_RELATION_PRODUCT_CAT
					(
						PRODUCT_CATID,
						DEMAND_ID
					)
					VALUES
					(
						#i#,
						#arguments.demand_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
		
			</cftransaction>
		</cflock>
		<cfif isdefined('session.ep')>
			<cfset process_user_id = session.ep.userid>
		<cfelseif  isdefined('session.pp')>
			<cfset process_user_id = session.pp.userid>
		</cfif>
		<script>
			window.location.href = "<cfoutput>#request.self#?fuseaction=worknet.list_demand&event=upd&demand_id=#arguments.demand_id#</cfoutput>";
		</script>	
	</cffunction>
	<!--- GET DEMAND --->
	<cffunction name="getDemand" access="public" returntype="query">
		<cfargument name="demand_id" type="numeric" default="0">
		<cfargument name="demand_id_list" type="string" required="no" default="">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="product_catid" type="string" default="">
		<cfargument name="product_cat" type="string" default="">
		<cfargument name="sector" type="string" default="">
		<cfargument name="demand_type" type="string" default="">
		<cfargument name="demand_stage" type="string" default="">
		<cfargument name="company_name" type="string" default="">
		<cfargument name="company_id" type="string" default="">
		<cfargument name="is_status" type="string" required="no" default="">
		<cfargument name="is_online" type="string" required="no" default="">
		<cfargument name="my_demand" type="numeric" required="no" default="0">
		<cfargument name="sortdir" type="string" default="desc">
		<cfargument name="sortfield" type="string" default="RECORD_DATE">
		<cfargument name="start_date" type="string" required="no" default="">
		<cfargument name="finish_date" type="string" required="no" default="">
		<cfargument name="recordCount" type="string" required="no" default="">
        <cfargument name="country" type="string" required="no" default="">
        <cfargument name="city" type="string" required="no" default="">
        <cfargument name="county" type="string" required="no" default="">
        <cfargument name="project_id" type="string" required="no" default="">
        <cfargument name="project_head" type="string" required="no" default="">
             				
		<cfif arguments.demand_id gt 0>
			<cfquery name="get_demand" datasource="#dsn#">
				SELECT 
					WD.*,
					C.ASSET_FILE_NAME1,
					C.ASSET_FILE_NAME1_SERVER_ID,
					C.FULLNAME,
					CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
					#dsn_alias#.Get_Dynamic_Language(PROCESS_ROW_ID,'#lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
					PRJ.PROJECT_HEAD
				FROM 
					WORKNET_DEMAND WD
					LEFT JOIN COMPANY C ON C.COMPANY_ID = WD.COMPANY_ID
					LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = WD.PARTNER_ID
					LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WD.STAGE_ID
					LEFT JOIN PRO_PROJECTS PRJ ON PRJ.PROJECT_ID=WD.PROJECT_ID
				WHERE 
					DEMAND_ID = #arguments.demand_id#
					<cfif isdefined('session.pp.userid') and arguments.my_demand eq 0>
						<!---AND WD.IS_STATUS = 1
						AND WD.IS_ONLINE = 1
						AND (
							WD.ORDER_MEMBER_TYPE = 1 OR
							WD.COMPANY_ID = #session.pp.company_id# OR
							WD.COMPANY_ID IN (SELECT 
												CP.COMPANY_ID
											FROM 
												MEMBER_FOLLOW MF,
												COMPANY_PARTNER CP
											WHERE 
												CP.PARTNER_ID = MF.FOLLOW_MEMBER_ID AND
												MF.FOLLOW_TYPE = 1 AND 
												MF.MY_MEMBER_ID = #session.pp.userid# AND
												MF.FOLLOW_MEMBER_TYPE = 'PARTNER'
											)
							)--->
					<cfelseif isdefined('session.wp')>
						AND WD.IS_STATUS = 1
						AND WD.IS_ONLINE = 1
						AND WD.ORDER_MEMBER_TYPE = 1
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="get_demand" datasource="#dsn#">
				SELECT 
					<cfif len(arguments.recordCount)>
						TOP #arguments.recordCount#
					</cfif>
					WD.*,
					C.ASSET_FILE_NAME1,
					C.ASSET_FILE_NAME1_SERVER_ID,
					C.FULLNAME,
                    C.COUNTRY,
                    C.CITY,
                    C.COUNTY,
					CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
					#dsn_alias#.Get_Dynamic_Language(PROCESS_ROW_ID,'#lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE
				FROM 
					WORKNET_DEMAND WD
					LEFT JOIN COMPANY C ON C.COMPANY_ID = WD.COMPANY_ID
					LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = WD.PARTNER_ID
					LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WD.STAGE_ID
				WHERE 
					1 = 1
					<cfif len(arguments.demand_id_list)>
						AND WD.DEMAND_ID IN (#arguments.demand_id_list#)
					</cfif>
					<cfif len(arguments.is_status)>
						AND WD.IS_STATUS = #arguments.is_status#
					</cfif>
					<cfif len(arguments.is_online)>
						AND WD.IS_ONLINE = #arguments.is_online# 
					</cfif>
					<cfif isdefined('session.pp.userid') and arguments.my_demand eq 0>
						AND (
							WD.ORDER_MEMBER_TYPE = 1 OR
							WD.COMPANY_ID = #session.pp.company_id# OR
							WD.COMPANY_ID IN (SELECT 
												CP.COMPANY_ID
											FROM 
												MEMBER_FOLLOW MF,
												COMPANY_PARTNER CP
											WHERE 
												CP.PARTNER_ID = MF.MY_MEMBER_ID AND
												MF.FOLLOW_TYPE = 1 AND 
												MF.FOLLOW_MEMBER_ID =  #session.pp.userid# AND
												MF.FOLLOW_MEMBER_TYPE = 'PARTNER'
											)
							)
						AND WD.FINISH_DATE >= #now()#
					<cfelseif isdefined('session.wp')>
						AND WD.ORDER_MEMBER_TYPE = 1
						AND WD.FINISH_DATE >= #now()#
					</cfif>
					<cfif len(arguments.keyword)>
						AND (
							WD.DEMAND_HEAD LIKE '%#arguments.keyword#%' OR
							WD.DEMAND_KEYWORD LIKE '%#arguments.keyword#%' OR
							WD.DETAIL LIKE '%#arguments.keyword#%'
							)
					</cfif>
					<cfif len(arguments.demand_type)>AND WD.DEMAND_TYPE = #arguments.demand_type#</cfif>
					<cfif len(arguments.sector)>AND WD.SECTOR_CAT_ID = #arguments.sector#</cfif>
					<cfif len(arguments.company_name) and len(arguments.company_id)>AND WD.COMPANY_ID = #arguments.company_id#</cfif>
					<cfif len(arguments.demand_stage)>AND WD.STAGE_ID =  #arguments.demand_stage# </cfif>
					<cfif len(arguments.start_date)>AND WD.START_DATE >= #arguments.start_date# </cfif>
					<cfif len(arguments.finish_date)>AND WD.FINISH_DATE <= #arguments.finish_date# </cfif> 
					<cfif len(arguments.product_catid) and len(arguments.product_cat)>AND WD.DEMAND_ID IN (SELECT DEMAND_ID FROM WORKNET_RELATION_PRODUCT_CAT WHERE PRODUCT_CATID IN (#arguments.product_catid#))</cfif>
					<cfif len(arguments.country)>AND C.COUNTRY = #arguments.country#</cfif>
                    <cfif len(arguments.city)>AND C.CITY = #arguments.city#</cfif>
                    <cfif len(arguments.county)>AND C.COUNTY=#arguments.county#</cfif> 		
					<cfif len(arguments.project_id) and len(arguments.project_head)>
						AND WD.PROJECT_ID = #arguments.project_id# 
					</cfif>					
                ORDER BY
					#arguments.sortfield# #arguments.sortdir#
			</cfquery>
		</cfif>
		<cfreturn get_demand>
	</cffunction>
	<!--- GET DEMAND OFFER --->
	<cffunction name="getDemandOffer" access="public" returntype="query">
		<cfargument name="demand_offer_id" type="numeric" default="0">
		<cfargument name="demand_offer_id_list" type="string" required="no" default="">
		<cfargument name="demand_id" type="numeric" default="0">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="offer_type" type="string" default="1">
		<cfargument name="is_status" type="string" required="no" default="">
		<cfargument name="sortdir" type="string" default="desc">
		<cfargument name="sortfield" type="string" default="WDO.RECORD_DATE">
		
		<cfquery name="get_demand_offer" datasource="#dsn#">
			SELECT 
				WD.DEMAND_HEAD,
				WD.DEMAND_ID,
				WD.DEMAND_TYPE,
				WDO.DETAIL,
				WDO.RECORD_DATE,
				WDO.RECORD_MEMBER,
				WDO.RECORD_MEMBER_TYPE,
				WDO.DEMAND_OFFER_ID,
				WDO.OFFER_STATUS,
				<cfif arguments.offer_type eq 1>
					WDO.COMPANY_ID,
					WDO.PARTNER_ID,
				<cfelse>
					WD.COMPANY_ID,
					WD.PARTNER_ID,
				</cfif>
				C.FULLNAME,
				CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME
			FROM 
				WORKNET_DEMAND_OFFER WDO
				LEFT JOIN WORKNET_DEMAND WD ON WDO.DEMAND_ID = WD.DEMAND_ID
				<cfif arguments.offer_type eq 1>
					LEFT JOIN COMPANY C ON C.COMPANY_ID = WDO.COMPANY_ID
					LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = WDO.PARTNER_ID
				<cfelse>
					LEFT JOIN COMPANY C ON C.COMPANY_ID = WD.COMPANY_ID
					LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = WD.PARTNER_ID
				</cfif>
			WHERE 
				1 = 1
				<cfif arguments.offer_type is 1>
					<cfif isdefined('session.pp')>
						AND WD.COMPANY_ID = #session.pp.company_id#
					<cfelseif isdefined('session.ww.userid')>
						AND WD.CONSUMER_ID = #session.ww.userid#
					</cfif>
				<cfelseif arguments.offer_type is 0>
					<cfif isdefined('session.pp')>
						AND WDO.COMPANY_ID = #session.pp.company_id#
					<cfelseif isdefined('session.ww.userid')>
						AND WDO.CONSUMER_ID = #session.ww.userid#
					</cfif>
				</cfif> 
				<cfif len(arguments.demand_offer_id_list)>
					AND WDO.DEMAND_OFFER_ID IN (#arguments.demand_offer_id_list#)
				</cfif>
				<cfif len(arguments.is_status)>
					AND WDO.OFFER_STATUS = #arguments.is_status#
				</cfif>
				<cfif arguments.demand_offer_id gt 0>
					AND WDO.DEMAND_OFFER_ID = #arguments.demand_offer_id# 
				</cfif>
				<cfif arguments.demand_id gt 0>
					AND WDO.DEMAND_ID = #arguments.demand_id#
				</cfif>
				<cfif len(arguments.keyword)>
					AND (
					WD.DEMAND_HEAD LIKE '%#arguments.keyword#%' OR
					WDO.DETAIL LIKE '%#arguments.keyword#%'
					)
				</cfif>
				ORDER BY
					#arguments.sortfield# #arguments.sortdir#
			</cfquery>
		<cfreturn get_demand_offer>
	</cffunction>
	
	<!--- GET DEMAND PRODUCT CAT --->
	<cffunction name="getProductCat" access="public" returntype="query">
		<cfargument name="demand_id" type="numeric" default="0">
		<cfquery name="GET_PRODUCT_CAT" datasource="#DSN#">
			SELECT 
				PC.HIERARCHY,
				PC.PRODUCT_CAT ,
				MRP.PRODUCT_CATID
			FROM 
				WORKNET_RELATION_PRODUCT_CAT MRP,
				#dsn1_alias#.PRODUCT_CAT PC
			WHERE
				PC.PRODUCT_CATID = MRP.PRODUCT_CATID AND
				MRP.DEMAND_ID = #arguments.demand_id#
		</cfquery>
		<cfreturn GET_PRODUCT_CAT>
	</cffunction>
	<!--- GET DEMAND HISTORY --->
	<cffunction name="getDemandHistory" access="public" returntype="query">
		<cfargument name="demand_id" type="numeric" default="0">
		<cfquery name="GET_DEMAND_HISTORY" datasource="#DSN#">
			 SELECT
				WDH.*,
				C.FULLNAME COMPANY_NAME,
				C.NICKNAME,
				CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
				PTR.STAGE PROCESS_STAGE,
				(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = WDH.RECORD_MEMBER) AS RECORD_NAME
			FROM
				WORKNET_DEMAND_HISTORY WDH
				LEFT JOIN COMPANY C ON C.COMPANY_ID = WDH.COMPANY_ID
				LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = WDH.PARTNER_ID
				LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WDH.STAGE_ID
			WHERE
				DEMAND_ID = #arguments.demand_id#
			ORDER BY 
				RECORD_DATE DESC
		</cfquery>
		<cfreturn GET_DEMAND_HISTORY>
        <!--- DEL DEMAND --->
	</cffunction>
    <cffunction name="delDemand" access="public">
    	<cfargument name="demand_id" required="yes">
        <cfquery name="delDemandHistory" datasource="#dsn#">
        	DELETE FROM WORKNET_DEMAND_HISTORY WHERE DEMAND_ID = #arguments.demand_id# 
        </cfquery>
        <cfquery name="delDemandOffer" datasource="#dsn#">
        	DELETE FROM WORKNET_DEMAND_OFFER WHERE DEMAND_ID = #arguments.demand_id# 
        </cfquery>
        <cfquery name="delDemandOffer" datasource="#dsn#">
        	DELETE FROM WORKNET_DEMAND WHERE DEMAND_ID = #arguments.demand_id# 
        </cfquery>
		<script>
			window.location.href = "<cfoutput>#request.self#?fuseaction=worknet.list_demand</cfoutput>";
		</script>
    </cffunction>
</cfcomponent>
