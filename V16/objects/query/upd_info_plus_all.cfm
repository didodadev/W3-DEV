<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -18) or (attributes.type_id eq -21) or (attributes.type_id eq -23) or (attributes.type_id eq -24))>
	<cfset tablo_adi = "INFO_PLUS">
	<cfset kolon_adi = "OWNER_ID">
    <cfset tablo_adi_hist="INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -5)>
	<cfset tablo_adi = "PRODUCT_INFO_PLUS">
	<cfset kolon_adi = "PRODUCT_ID">
    <cfset tablo_adi_hist="PRODUCT_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -6)>
	<cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS">
	<cfset kolon_adi = "STOCK_ID">
    <cfset tablo_adi_hist="PRODUCT_TREE_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -7) or (attributes.type_id eq -12))><!--- Satis ve satinalma siparisleri --->
	<cfset tablo_adi = "ORDER_INFO_PLUS">
	<cfset kolon_adi = "ORDER_ID">
    <cfset tablo_adi_hist="ORDER_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -8) or (attributes.type_id eq -32))>
	<cfset tablo_adi = "INVOICE_INFO_PLUS">
	<cfset kolon_adi = "INVOICE_ID">
    <cfset tablo_adi_hist="INVOICE_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -9) or (attributes.type_id eq -30))><!--- Satis ve satinalma teklifleri --->
	<cfset tablo_adi = "OFFER_INFO_PLUS">
	<cfset kolon_adi = "OFFER_ID">
    <cfset tablo_adi_hist="OFFER_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -16))>
	<cfset tablo_adi = "OPPORTUNITIES_INFO_PLUS">
	<cfset kolon_adi = "OPP_ID">
    <cfset tablo_adi_hist="OPPORTUNITIES_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -10))>
	<cfset tablo_adi = "PROJECT_INFO_PLUS">
	<cfset kolon_adi = "PROJECT_ID">
    <cfset tablo_adi_hist="PROJECT_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))>
	<cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS">
	<cfset kolon_adi = "SUBSCRIPTION_ID">
    <cfset tablo_adi_hist="SUBSCRIPTION_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>	
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -14) or (attributes.type_id eq -31))>
	<cfset tablo_adi = "SHIP_INFO_PLUS">
	<cfset kolon_adi = "SHIP_ID">
    <cfset tablo_adi_hist="SHIP_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn2>	
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -17))>
	<cfset tablo_adi = "EXPENSE_ITEM_PLANS_INFO_PLUS">
	<cfset tablo_adi_hist = "EXPENSE_ITEM_PLANS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "EXPENSE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -22))>
	<cfset tablo_adi = "STOCK_FIS_INFO_PLUS">
	<cfset tablo_adi_hist = "STOCK_FIS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "FIS_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -28) or (attributes.type_id eq -29))><!--- İç Talepler ve satinalma talepleri --->
	<cfset tablo_adi = "INTERNALDEMAND_INFO_PLUS">
	<cfset kolon_adi = "INTERNAL_ID">
	<cfset tablo_adi_hist = "INTERNALDEMAND_INFO_PLUS_HISTORY">
	<cfset dsn_adi = dsn3>
</cfif>
<!---Tarihçe Kaydı Custom tag--->
<cf_wrk_get_history datasource= "#dsn_adi#" source_table= "#tablo_adi#" target_table= "#tablo_adi_hist#" record_id="#attributes.info_id#" record_name="#kolon_adi#">
<!--- en son kaydedilen id si alınır--->
<cfquery name="get_max_id" datasource="#dsn_adi#">
	SELECT MAX(INFO_ID_HIST) MAX_ID FROM #tablo_adi_hist#
</cfquery>
<!---Select Box Kaydı var ise tarihçeye id ye bağlı olan bilgiyi atma--->
<cfif listfind('-1,-2,-3,-4,-10,-13,-19,-20,-15,-18,-17,-21,-23', attributes.type_id,',')>
	<cfset DB_ADI ="#DSN#">
	<cfset SELECT_TABLO_ADI ="SETUP_INFOPLUS_VALUES">
    <cfset PRO_TABLO_ADI="SETUP_INFOPLUS_NAMES">
    <cfset ALAN1 ="INFO_ID">
<cfelse>
	<cfset DB_ADI ="#DSN3#">
	<cfset SELECT_TABLO_ADI ="SETUP_PRO_INFO_PLUS_VALUES">
    <cfset PRO_TABLO_ADI="SETUP_PRO_INFO_PLUS_NAMES">
    <cfset ALAN1 ="PRO_INFO_ID">
</cfif>
<cfquery name="get_property" datasource="#dsn_adi#">
	SELECT 
		<cfloop from="1" to="40" index="X">
        	PROPERTY#X# <cfif x neq 40>,</cfif>
		</cfloop>
   	FROM
    	#tablo_adi#
    WHERE
		<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -10) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -18) or (attributes.type_id eq -21) or (attributes.type_id eq -23))>
			INFO_OWNER_TYPE = #attributes.type_id# AND
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -5))>
			PRO_INFO_ID = #attributes.pro_info_id# AND
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))>
			SUB_INFO_ID = #attributes.pro_info_id# AND
		</cfif>
		 #kolon_adi# = #attributes.info_id#  
</cfquery>
<cfquery name="get_property_type" datasource="#DB_ADI#">
	SELECT 
	<cfloop from="1" to="40" index="X">
		PROPERTY#X#_TYPE,
		PROPERTY#X#_MASK,
		PROPERTY#X#_GDPR <cfif x neq 40>,</cfif>
	</cfloop>
   	FROM
    	#PRO_TABLO_ADI#
    WHERE
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#"> 
		<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
            AND MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.product_catid#,%">
        </cfif>
        <cfif isdefined("attributes.sub_catid") and len(attributes.sub_catid)>
            AND MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_catid#,%">
        </cfif>
        <cfif isdefined("attributes.sub_assetid") and len(attributes.sub_assetid)>
            AND MULTI_ASSETP_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_assetid#,%">
        </cfif>
</cfquery>
<cfoutput query="get_property_type">
	<cfloop from="1" to="40" index="X">
    	<cfif evaluate("PROPERTY#X#_TYPE") eq 'select' and len(evaluate("get_property.PROPERTY#X#")) and isnumeric(evaluate("get_property.PROPERTY#X#"))><!---  and isnumeric(evaluate("get_property.PROPERTY#X#")) ifadesi yeni eklendi. --->
			<cfquery name="get_type_value" datasource="#DB_ADI#">
            	SELECT SELECT_VALUE FROM #SELECT_TABLO_ADI# WHERE INFO_ROW_ID=#evaluate("get_property.PROPERTY#X#")#
            </cfquery>
            <cfquery name="update_history" datasource="#dsn_adi#">
            	UPDATE #tablo_adi_hist# SET PROPERTY#X#='#get_type_value.select_value#'  WHERE INFO_ID_HIST=#get_max_id.max_id#
            </cfquery>
         </cfif>
    </cfloop>
</cfoutput>
<!---/Select Box Kaydı var ise tarihçeye id ye bağlı olan bilgiyi atma--->
<cfquery name="UPD_INFO_PLUS" datasource="#dsn_adi#">
	UPDATE
		#tablo_adi#
	SET	
	<cfloop from="1" to="40" index="kk_info">
		<cfif isdefined("attributes.property#kk_info#")>
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
        UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">       
		<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -10) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -18) or (attributes.type_id eq -21) or (attributes.type_id eq -23))>
			,INFO_OWNER_TYPE = #attributes.type_id#
			<cfif attributes.type_id eq -13 or (attributes.type_id eq -19) or (attributes.type_id eq -20)>
				,ASSETP_INFO_ID=#attributes.pro_info_id#
			</cfif>
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -5))><!---  or (attributes.type_id eq -6) --->
			,PRO_INFO_ID = #attributes.pro_info_id#
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))><!---  or (attributes.type_id eq -6) --->
			,SUB_INFO_ID = #attributes.pro_info_id#
		<cfelse>
			,RECORD_IP =<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		</cfif>
	WHERE
		<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -18) or (attributes.type_id eq -10) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) <!---or (attributes.type_id eq -18)---> or (attributes.type_id eq -21) or (attributes.type_id eq -23))>
			INFO_OWNER_TYPE = #attributes.type_id# AND
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -5))><!---  or (attributes.type_id eq -6) --->
			PRO_INFO_ID = #attributes.pro_info_id# AND
		<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))><!---  or (attributes.type_id eq -6) --->
			SUB_INFO_ID = #attributes.pro_info_id# AND
		</cfif>
		 #kolon_adi# = #attributes.info_id# 
</cfquery>
<cfif not isdefined("attributes.draggable")>
	<cfif isdefined("attributes.is_nonpopup")>
		<cflocation url="#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.info_id#&type_id=#attributes.type_id#&is_nonpopup=#attributes.is_nonpopup#" addtoken="no">
	<cfelse>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>
