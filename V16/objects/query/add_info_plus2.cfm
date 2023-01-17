<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfif not isdefined("new_dsn2_group_alias")><cfset new_dsn2_group_alias = dsn2_alias></cfif>
<cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27) or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
	<cfset tablo_adi = "INFO_PLUS">
	<cfset kolon_adi = "OWNER_ID">
    <cfset tablo_adi_hist="INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
	<cfset tablo_adi = "PRODUCT_INFO_PLUS">
	<cfset kolon_adi = "PRODUCT_ID">
    <cfset tablo_adi_hist="PRODUCT_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>
<cfelseif isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -6)>
	<cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS">
	<cfset kolon_adi = "STOCK_ID">
    <cfset tablo_adi_hist="PRODUCT_TREE_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -7) or (attributes.info_type_id eq -12))><!--- Satis ve satinalma siparisleri --->
	<cfset tablo_adi = "ORDER_INFO_PLUS">
	<cfset kolon_adi = "ORDER_ID">
    <cfset tablo_adi_hist="ORDER_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -8) or (attributes.info_type_id eq -32))>
	<cfset tablo_adi = "INVOICE_INFO_PLUS">
	<cfset kolon_adi = "INVOICE_ID">
    <cfset tablo_adi_hist="INVOICE_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn2_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -9) or (attributes.info_type_id eq -30))>
	<cfset tablo_adi = "OFFER_INFO_PLUS">
	<cfset kolon_adi = "OFFER_ID">
    <cfset tablo_adi_hist="OFFER_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -16))>
	<cfset tablo_adi = "OPPORTUNITIES_INFO_PLUS">
	<cfset kolon_adi = "OPP_ID">
    <cfset tablo_adi_hist="OPPORTUNITIES_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -10))>
	<cfset tablo_adi = "PROJECT_INFO_PLUS">
	<cfset kolon_adi = "PROJECT_ID">
    <cfset tablo_adi_hist="PROJECT_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11))>
	<cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS">
	<cfset kolon_adi = "SUBSCRIPTION_ID">
    <cfset tablo_adi_hist="SUBSCRIPTION_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn3_group>	
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -14) or (attributes.info_type_id eq -31))>
	<cfset tablo_adi = "SHIP_INFO_PLUS">
	<cfset kolon_adi = "SHIP_ID">
    <cfset tablo_adi_hist="SHIP_INFO_PLUS_HISTORY">
	<cfset dsn_adi = new_dsn2_group>	
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -17))>
	<cfset tablo_adi = "EXPENSE_ITEM_PLANS_INFO_PLUS">
	<cfset tablo_adi_hist = "EXPENSE_ITEM_PLANS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "EXPENSE_ID">
	<cfset dsn_adi = new_dsn2_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -22))>
	<cfset tablo_adi = "STOCK_FIS_INFO_PLUS">
	<cfset tablo_adi_hist = "STOCK_FIS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "FIS_ID">
	<cfset dsn_adi = new_dsn2_group>
<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -28) or (attributes.info_type_id eq -29))><!--- İç Talepler ve satinalma talepleri --->
	<cfset tablo_adi = "INTERNALDEMAND_INFO_PLUS">
	<cfset kolon_adi = "INTERNAL_ID">
	<cfset tablo_adi_hist="INTERNALDEMAND_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
</cfif>
<cfquery name="get_info_plus" datasource="#dsn_adi#">
    SELECT 
    	* 
    FROM 
    	#tablo_adi# 
    WHERE 
    	#kolon_adi#  = #attributes.info_id#
		<cfif isdefined("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4 ) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21) )>
        	AND INFO_OWNER_TYPE = #attributes.info_type_id#
        <cfelseif (isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)) and (isdefined("attributes.info_type_id") and attributes.info_type_id eq -5)>
             AND PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_info_id#">
        </cfif>
</cfquery>

<cfif get_info_plus.recordcount>
	<cfset attributes.is_upd = 1>
<cfelse>
	<cfset attributes.is_upd = 0>
</cfif>

<cfquery name="get_our_company_info" datasource="#dsn_adi#">
	SELECT 
    	IS_ADD_INFORMATIONS 
    FROM 
    	#dsn_alias#.OUR_COMPANY_INFO 
    WHERE
	<cfif isDefined('session.ep.userid')> 	
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    <cfelseif isDefined('session.pp.userid')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">        
    <cfelseif isDefined('session.ww.userid')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">   
    <cfelseif isDefined('session.cp.userid')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">        
    </cfif>
</cfquery>
	<!---Select Box Kaydı var ise tarihçeye id ye bağlı olan bilgiyi atma--->
	<cfif listfind('-1,-2,-3,-4,-10,-13,-19,-20,-15,-17,-21,-23,-27', attributes.info_type_id,',')>
		<cfset SELECT_TABLO_ADI ="#dsn_alias#.SETUP_INFOPLUS_VALUES">
		<cfset PRO_TABLO_ADI="#dsn_alias#.SETUP_INFOPLUS_NAMES">
		<cfset ALAN1 ="INFO_ID">
	<cfelse>
		<cfset SELECT_TABLO_ADI ="#dsn3_alias#.SETUP_PRO_INFO_PLUS_VALUES">
		<cfset PRO_TABLO_ADI="#dsn3_alias#.SETUP_PRO_INFO_PLUS_NAMES">
		<cfset ALAN1 ="PRO_INFO_ID">
	</cfif>
	
	<cfquery name="get_property_type" datasource="#dsn_adi#">
		SELECT 
			<cfloop from="1" to="40" index="X">
				PROPERTY#X#_TYPE,
				PROPERTY#X#_MASK,
				PROPERTY#X#_GDPR <cfif x neq 40>,</cfif>
			</cfloop>
		FROM
			#PRO_TABLO_ADI#
		WHERE
			OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_type_id#"> 
			<cfif isdefined("attributes.product_catid1") and len(attributes.product_catid1)>
				AND MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.product_catid1#,%">
			</cfif>
			<cfif isdefined("attributes.sub_catid") and len(attributes.sub_catid)>
				AND MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_catid#,%">
			</cfif>
			<cfif isdefined("attributes.sub_assetid") and len(attributes.sub_assetid)>
				AND MULTI_ASSETP_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_assetid#,%">
			</cfif>
	</cfquery>
<cfif attributes.is_upd eq 0 and get_our_company_info.IS_ADD_INFORMATIONS eq 1>
    <cfquery name="add_info_plus" datasource="#dsn_adi#" result="xx">
        INSERT INTO 
            #tablo_adi#
        (
            <cfloop from="1" to="40" index="kk_info">
				<cfif isdefined("attributes.property#kk_info#") and len(evaluate("attributes.property#kk_info#"))>
						PROPERTY#kk_info#,
                </cfif>
            </cfloop>
            <cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4)  or (attributes.info_type_id eq -10)  or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15)  or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
                INFO_OWNER_TYPE,
                <cfif ((attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20)) and (isdefined("attributes.pro_info_id") and len(attributes.pro_info_id))>
                    ASSETP_INFO_ID,
                </cfif>	
            <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -5)) and (isdefined("attributes.pro_info_id") and len(attributes.pro_info_id))><!---  or (attributes.info_type_id eq -6) --->
                PRO_INFO_ID,
            <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
                SUB_INFO_ID,
            <cfelse>
                RECORD_IP,
            </cfif>
			<cfif isDefined('session.ep.userid')>
                RECORD_EMP,
            </cfif>
            RECORD_DATE,
            #kolon_adi#
        )
        VALUES
        (
            <cfloop from="1" to="40" index="kk_info">
                <cfif isdefined("attributes.property#kk_info#") and len(evaluate("attributes.property#kk_info#"))>
					<cfset deger_ = evaluate("attributes.property#kk_info#")>
					<cfif evaluate("get_property_type.PROPERTY#kk_info#_MASK") eq 1>
						<cfset deger_ = contentEncryptingandDecodingAES(isEncode:1,content:deger_,accountKey:'wrk')>
					<cfelse>
						<cfset deger_ = deger_>
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#">,
                </cfif>
            </cfloop>
            <cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4)  or (attributes.info_type_id eq -10)  or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
                #attributes.info_type_id#,
                <cfif ((attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20)) and (isdefined("attributes.pro_info_id") and len(attributes.pro_info_id))>
                    #attributes.pro_info_id#,
                </cfif>
            <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -5)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
                #attributes.pro_info_id#,
            <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
                #attributes.pro_info_id#,
            <cfelse>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            </cfif>
           	<cfif isDefined('session.ep.userid')>
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            </cfif>
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            #attributes.info_id#


        )
    </cfquery>
<cfelse>
	<cfif get_our_company_info.IS_ADD_INFORMATIONS eq 1>
		<!---Tarihçe Kaydı Custom tag--->
		<cf_wrk_get_history datasource= "#dsn_adi#" source_table= "#tablo_adi#" target_table= "#tablo_adi_hist#" record_id="#attributes.info_id#" record_name="#kolon_adi#">
		<!--- en son kaydedilen id si alınır--->
		<cfquery name="get_max_id" datasource="#dsn_adi#">
			SELECT MAX(INFO_ID_HIST) MAX_ID FROM #tablo_adi_hist#
		</cfquery>
		<cfquery name="get_property" datasource="#dsn_adi#">
			SELECT 
				<cfloop from="1" to="40" index="X">
					PROPERTY#X# <cfif x neq 40>,</cfif>
				</cfloop>
			FROM
				#tablo_adi#
			WHERE
				<cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
					INFO_OWNER_TYPE = #attributes.info_type_id# AND
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -5)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)>
					PRO_INFO_ID = #attributes.pro_info_id# AND
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)>
					SUB_INFO_ID = #attributes.pro_info_id# AND
				</cfif>
				 #kolon_adi# = #attributes.info_id#  
		</cfquery>					
		<cfoutput query="get_property_type">
			<cfloop from="1" to="40" index="X">
				<cfif evaluate("PROPERTY#X#_TYPE") eq 'select' and len(evaluate("get_property.PROPERTY#X#")) and isnumeric(evaluate("get_property.PROPERTY#X#"))><!---  and isnumeric(evaluate("get_property.PROPERTY#X#")) ifadesi yeni eklendi. --->
					<cfquery name="get_type_value" datasource="#dsn_adi#">
						SELECT SELECT_VALUE FROM #SELECT_TABLO_ADI# WHERE INFO_ROW_ID = #evaluate("get_property.PROPERTY#X#")#
					</cfquery>
					<cfquery name="update_history" datasource="#dsn_adi#">
						UPDATE #tablo_adi_hist# SET PROPERTY#X# = '#get_type_value.select_value#'  WHERE INFO_ID_HIST = #get_max_id.max_id#
					</cfquery>
				 </cfif>
			</cfloop>
		</cfoutput>
		<!---/Select Box Kaydı var ise tarihçeye id ye bağlı olan bilgiyi atma--->
	
		<cfquery name="UPD_INFO_PLUS" datasource="#dsn_adi#" result="xxx">
			UPDATE
				#tablo_adi#
			SET	
				<cfloop from="1" to="40" index="kk_info">
					<cfif isdefined("attributes.property#kk_info#") and len(evaluate("attributes.property#kk_info#"))>
						<cfset deger_ = evaluate("attributes.property#kk_info#")>
						<cfset gdpr_ = evaluate("get_property_type.PROPERTY#kk_info#_GDPR")>
						<cfif not len(gdpr_) or listFind(session.ep.dockphone,gdpr_,',')>
							<cfif evaluate("get_property_type.PROPERTY#kk_info#_MASK") eq 1>
								<cfset deger_ = contentEncryptingandDecodingAES(isEncode:1,content:deger_,accountKey:'wrk')>
							</cfif>
							PROPERTY#kk_info# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#">,
						</cfif>
					<cfelse>
						PROPERTY#kk_info#=NULL,
					</cfif>
				</cfloop>
				UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#" >,
                <cfif isDefined('session.ep.userid')>
					UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				</cfif>
				UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">       
				<cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
					,INFO_OWNER_TYPE = #attributes.info_type_id#
					<cfif ((attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20)) and (isdefined("attributes.pro_info_id") and len(attributes.pro_info_id))>
						,ASSETP_INFO_ID=#attributes.pro_info_id#
					</cfif>
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -5))  and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
					,PRO_INFO_ID = #attributes.pro_info_id#
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
					,SUB_INFO_ID = #attributes.pro_info_id#
				<cfelse>
					,RECORD_IP =<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				</cfif>
			WHERE
				<cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
					INFO_OWNER_TYPE = #attributes.info_type_id# AND
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -5)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
					PRO_INFO_ID = #attributes.pro_info_id# AND
				<cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11)) and isdefined("attributes.pro_info_id") and len(attributes.pro_info_id)><!---  or (attributes.info_type_id eq -6) --->
					SUB_INFO_ID = #attributes.pro_info_id# AND
				</cfif>
				 #kolon_adi# = #attributes.info_id# 
		</cfquery>
	</cfif>
</cfif>
