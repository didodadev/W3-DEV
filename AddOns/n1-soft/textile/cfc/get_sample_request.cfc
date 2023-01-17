<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getOppSupplier">
		<cfif listlen(arguments.req_id) gt 1><cfset arguments.req_id = listfirst(arguments.req_id)></cfif>
		<cfquery name="get_opp_supplier" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM SampleRequestSuppliers WHERE REQ_ID = #arguments.req_id# and ISNULL(REQUEST_TYPE,0)=#arguments.req_type#
		</cfquery>
		<cfreturn get_opp_supplier>
	</cffunction>
	<cffunction name="getReqProcess">
		<cfif listlen(arguments.req_id) gt 1><cfset arguments.req_id = listfirst(arguments.req_id)></cfif>
		<cfquery name="get_process" datasource="#dsn#_#session.ep.company_id#">
			SELECT 
				*,
				ISNULL(P.PROCESS_ID,0) SEC,
				P.PRICE AS REQ_PRICE
			FROM 
				TEXTILE_SR_PROCESSTYPE PT
				LEFT JOIN TEXTILE_SR_PROCESS P ON P.PROCESS_ID=PT.PROCESS_ID AND P.REQUEST_ID = #arguments.req_id#
			
		</cfquery>
		<cfreturn get_process>
	</cffunction>
	<cffunction name="updRequest" access="public" returntype="any">
		<cfargument name="req_id" type="any">
		<cfargument name="is_fabric_plan" type="any">
		<cfargument name="is_accessory_plan" type="any">
		<cfargument name="measuretable_filename" type="any">
		<cfquery name="upd_request" datasource="#dsn#_#session.ep.company_id#" result="upd_req">
			UPDATE
				TEXTILE_SAMPLE_REQUEST		
			SET	
			<cfif isDefined("arguments.is_fabric_plan") and len(arguments.is_fabric_plan)>
				IS_FABRIC_PLAN=#arguments.is_fabric_plan#
			</cfif>
			<cfif isDefined("arguments.is_accessory_plan") and len(arguments.is_accessory_plan)>
				IS_ACCESSORY_PLAN=#arguments.is_accessory_plan#
			</cfif>
			<cfif isDefined("arguments.measuretable_filename") and len(arguments.measuretable_filename)>
				MEASURE_FILENAME='#arguments.measuretable_filename#'
			</cfif>
			where 
				REQ_ID=#arguments.req_id#
		
		</cfquery>
		<cfreturn upd_req>
	</cffunction>
	<cffunction name="getRequest" access="public" returntype="any">
		<cfargument name="req_id" type="any">
		<cfquery name="get_request" datasource="#dsn#_#session.ep.company_id#" result="get_req">
				Select 
					*from 
					TEXTILE_SAMPLE_REQUEST
				WHERE
					REQ_ID=#arguments.req_id#
			
		</cfquery>
		<cfreturn get_request>
	</cffunction>
	<cffunction name="getSize">
		<cfquery name="get_property_detail" datasource="#dsn#_#session.ep.company_id#">
			select 
				PPD.PROPERTY_DETAIL_ID,
				PPD.PROPERTY_DETAIL,
				PP.PROPERTY,
				PP.PROPERTY_ID
			from 
				#dsn#_product.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn#_product.PRODUCT_PROPERTY PP
			WHERE 
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PP.PROPERTY_SIZE=1
				<cfif isdefined("arguments.prop_id") and len(arguments.prop_id)>
					AND PPD.PRPT_ID=#arguments.prop_id#
				</cfif>
			ORDER BY PPD.PROPERTY_DETAIL
			
		</cfquery>
		<cfreturn get_property_detail>
	</cffunction>
	<cffunction name="getAssetRequest">
		<cfargument name="action_id" type="any">
		<cfargument name="action_section" type="any">
		<cfquery name="get_asset" datasource="#dsn#">
						select
							*
						FROM
							ASSET
						WHERE 
							ACTION_ID=#arguments.action_id#
							and ACTION_SECTION='#arguments.action_section#'
						ORDER BY ASSET_ID DESC
		</cfquery>
			<cfreturn get_asset>
	</cffunction>
	<cffunction name="getColor">
		<cfquery name="get_property_detail" datasource="#dsn#_#session.ep.company_id#">
			select 
				PPD.PROPERTY_DETAIL_ID,
				PPD.PROPERTY_DETAIL,
				PP.PROPERTY,
				PP.PROPERTY_ID
			from 
				#dsn#_product.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn#_product.PRODUCT_PROPERTY PP
			WHERE 
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PP.PROPERTY_COLOR=1
				<cfif isdefined("arguments.prop_id") and len(arguments.prop_id)>
					AND PPD.PRPT_ID=#arguments.prop_id#
				</cfif>
			
			
		</cfquery>
		<cfreturn get_property_detail>
	</cffunction>
	
	 <cffunction name="getOppRival">
	 	<cfif listlen(arguments.req_id) gt 1><cfset arguments.req_id = listfirst(arguments.req_id)></cfif>
		<cfquery name="get_opp_rival" datasource="#dsn#_#session.ep.company_id#">
				SELECT * FROM SampleRequestRivals WHERE REQ_ID = #arguments.req_id#
		</cfquery>
		<cfreturn get_opp_rival>
	</cffunction>
	<cffunction name="getWorkstation">
        <cfquery name="GET_STATION" datasource="#dsn#_#session.ep.company_id#">
            select * from WORKSTATIONS
        </cfquery>
		<cfreturn GET_STATION>
    </cffunction>
	 <cffunction name="getMoney">
		<cfquery name="GET_MONEY" datasource="#dsn#">
			SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
		</cfquery>
		<cfreturn GET_MONEY>
	</cffunction>
	
	 <cffunction name="getRivalPreferenceReasons">
		<cfquery name="GET_RIVAL_PREFERENCE_REASONS" datasource="#DSN#">
			SELECT
				PREFERENCE_REASON_ID,
				PREFERENCE_REASON
			FROM
				SETUP_RIVAL_PREFERENCE_REASONS
			ORDER BY
				PREFERENCE_REASON
		</cfquery>
		<cfreturn GET_RIVAL_PREFERENCE_REASONS>
	</cffunction>
	<cffunction name="getOffRival">
	 	<cfif listlen(arguments.offer_id) gt 1><cfset arguments.offer_id = listfirst(arguments.offer_id)></cfif>
		<cfquery name="get_off_rival" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM OFFER_RIVALS WHERE OFFER_ID = #arguments.offer_id#
		</cfquery>
		<cfreturn get_off_rival>   
	</cffunction>
	 <cffunction name="basket_kur_ekle_textile">
        <cfargument name="action_id" required="true">
        <cfargument name="table_type_id" required="true">
        <cfargument name="process_type" required="true">
        <cfargument name="basket_money_db" type="string" default="">
        <cfargument name="transaction_dsn">
        <!---
            by : Arzu BT 20031211
            notes : Basket_money tablosuna islemlere gore kur bilgilerini kaydeder.
            process_type:1 upd 0 add
            transaction_dsn : kullanılan sayfa içinde table dan farklı dsn tanımı olduğu durumlarda kullanılan dsn gönderilir.
            usage :
                invoice:1
                ship:2
                order:3
                offer:4
                servis:5
                stock_fis:6
                internmal_demand:7
                prroduct_catalog 8
                sale_quote:9
                subscription:13
            revisions : javascript version ergün koçak 20040209
            kullanim:
            <cfscript>
                basket_kur_ekle(action_id:MY_ID,table_type_id:1,process_type:0);
            </cfscript>		
        --->
        <cfscript>
            switch (arguments.table_type_id){
                case 1: fnc_table_name="TEXTILE_SAMPLE_REQUEST_MONEY"; fnc_dsn_name="#this.dsn3#";break;
               
            }
            if(len(arguments.basket_money_db))fnc_dsn_name = "#arguments.basket_money_db#";
        </cfscript>
        <cfif not (isdefined('arguments.transaction_dsn') and len(arguments.transaction_dsn))>
            <cfset arguments.transaction_dsn = fnc_dsn_name>
            <cfset arguments.action_table_dsn_alias = ''>
        <cfelse>
            <cfset arguments.action_table_dsn_alias = '#fnc_dsn_name#.'>
        </cfif>
        <cfif arguments.process_type eq 1>
            <cfquery name="del_money_obj_bskt" datasource="#arguments.transaction_dsn#">
                DELETE FROM 
                    #arguments.action_table_dsn_alias##fnc_table_name#
                WHERE 
                    ACTION_ID=#arguments.action_id#
            </cfquery>
        </cfif>
        <cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
            <cfquery name="add_money_obj_bskt" datasource="#arguments.transaction_dsn#">
                INSERT INTO #arguments.action_table_dsn_alias##fnc_table_name# 
                (
                    ACTION_ID,
                    MONEY_TYPE,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                    #arguments.action_id#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#fnc_i#')#">,
                    #evaluate("attributes.txt_rate2_#fnc_i#")#,
                    #evaluate("attributes.txt_rate1_#fnc_i#")#,
                    <cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.BASKET_MONEY>
                        1
                    <cfelse>
                        0
                    </cfif>					
                )
            </cfquery>
        </cfloop>
	</cffunction>
	<cffunction name="insert_stock_profile">
		<cfargument name="head" type="string">
		<cfargument name="sizes" type="string">
		<cfargument name="lens" type="string">

		<cfquery name="common_query" datasource="#dsn#">
			INSERT INTO TEXTILE_SIZE_PROFILE (
				HEAD, WEIGHTS, LENGTHS
			) VALUES (
				<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.head#'>,
				<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.sizes#'>,
				<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.lens#'>
			)
		</cfquery>
	</cffunction>

	<cffunction name="update_stock_profile">
		<cfargument name="profileid" type="string">
		<cfargument name="head" type="string">
		<cfargument name="sizes" type="string">
		<cfargument name="lens" type="string">
		<cfquery name="common_query" datasource="#dsn#">
			UPDATE TEXTILE_SIZE_PROFILE SET
				HEAD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.head#'>, 
				WEIGHTS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.sizes#'>, 
				LENGTHS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.lens#'>
			WHERE PROFILEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.profileid#'>
		</cfquery>
	</cffunction>

	<cffunction name="get_stock_profiles">
		<cfargument name="profileid">
		<cfquery name="common_query" datasource="#dsn#">
		SELECT * FROM TEXTILE_SIZE_PROFILE
		<cfif isDefined("arguments.profileid") and len(arguments.profileid)>
			WHERE PROFILEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.profileid#'>
		</cfif>
		</cfquery>
		<cfreturn common_query>
	</cffunction>

	<cffunction name="delete_stock_profile">
		<cfargument name="profileid">
		<cfquery name="common_query" datasource="#dsn#">
			DELETE FROM TEXTILE_SIZE_PROFILE WHERE PROFILEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.profileid#'>
		</cfquery>
	</cffunction>
	
</cfcomponent>

