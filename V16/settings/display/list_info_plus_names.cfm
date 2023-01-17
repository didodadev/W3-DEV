<cfif fusebox.use_period>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
		SELECT
			PRODUCT_CATID,
			PRODUCT_CAT,
			HIERARCHY
		FROM
			PRODUCT_CAT
		WHERE
			IS_SUB_PRODUCT_CAT = 0
		ORDER BY
			HIERARCHY,
			PRODUCT_CAT		
	</cfquery>
	<cfquery name="GET_SUB_CAT" datasource="#DSN3#">
		SELECT
			SUBSCRIPTION_TYPE_ID,
			SUBSCRIPTION_TYPE
		FROM
			SETUP_SUBSCRIPTION_TYPE
		ORDER BY
			SUBSCRIPTION_TYPE	
	</cfquery>
	<cfquery name="GET_SALES_ADDOPTIONS" datasource="#DSN3#">
        SELECT
            SALES_ADD_OPTION_ID,
            SALES_ADD_OPTION_NAME
        FROM
            SETUP_SALES_ADD_OPTIONS
        ORDER BY
            SALES_ADD_OPTION_NAME    
    </cfquery>
	<cffunction name="getProductCat">
		<cfargument name="cat_id">
		<cfquery name="GET_PRODUCT_CAT_" dbtype="query">
			SELECT
				PRODUCT_CAT
			FROM
				GET_PRODUCT_CAT
			WHERE
				PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cat_id#">
		</cfquery>
		<cfreturn get_product_cat_.product_cat>
	</cffunction>
	<cffunction name="get_name_sub">
		<cfargument name="sub_cat_id">
		<cfquery name="GET_SUB_CAT_" dbtype="query">
			SELECT
				SUBSCRIPTION_TYPE
			FROM
				GET_SUB_CAT
			WHERE
				SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sub_cat_id#">
		</cfquery>
		<cfreturn GET_SUB_CAT_.SUBSCRIPTION_TYPE>
	</cffunction>
</cfif>
<cfquery name="GET_PHYSICAL_CAT" datasource="#DSN#">
	SELECT
		 ASSETP_CATID, 
		 ASSETP_CAT 
	FROM 
		ASSET_P_CAT  
	WHERE 
		MOTORIZED_VEHICLE = 0 AND 
		IT_ASSET = 0 
	UNION 
	SELECT
		 ASSETP_CATID, 
		 ASSETP_CAT 
	FROM 
		ASSET_P_CAT  
	WHERE 
		IT_ASSET = 1
	UNION
	SELECT
		 ASSETP_CATID, 
		 ASSETP_CAT 
	FROM 
		ASSET_P_CAT  
	WHERE 
		MOTORIZED_VEHICLE = 1 
	ORDER BY 
		ASSETP_CAT
</cfquery>
<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
</cfquery>
<cffunction name="get_p_sub">
	<cfargument name="sub_pcat_id">
	<cfquery name="GET_P_CAT_" dbtype="query">
		SELECT
			ASSETP_CAT
		FROM
			GET_PHYSICAL_CAT
		WHERE
			ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sub_pcat_id#">
	</cfquery>
	<cfreturn GET_P_CAT_.ASSETP_CAT>
</cffunction>
<cffunction name="get_p_work">
	<cfargument name="work_cat_id">
	<cfquery name="GET_P_CAT_" dbtype="query">
		SELECT
			WORK_CAT
		FROM
			get_work_cat
		WHERE
			WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_cat_id#">
	</cfquery>
	<cfreturn GET_P_CAT_.WORK_CAT>
</cffunction>
<cffunction name="get_sales_addoption">
    <cfargument name="sales_addoption_id">
    <cfquery name="GET_ADDOPTIONS" dbtype="query">
        SELECT
            SALES_ADD_OPTION_NAME
        FROM
            GET_SALES_ADDOPTIONS
        WHERE
            SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sales_addoption_id#">
    </cfquery>
    <cfreturn GET_ADDOPTIONS.SALES_ADD_OPTION_NAME>
</cffunction>
<cfinclude template="../query/get_info_plus_list.cfm">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <cfif infoplus_names.recordcount>
		<cfoutput query="infoplus_names">
			<tr>
				<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380">			   		
					<a href="#request.self#?fuseaction=settings.form_upd_info_plus&owner_type_id=#owner_type_id#&id=#id#" class="tableyazi">
                   	<cfswitch expression="#owner_type_id#">
                    	<cfcase value="-1"><cf_get_lang_main no='173.Kurumsal Üye'></cfcase>
						<cfcase value="-2"><cf_get_lang_main no='174.Bireysel Üye'></cfcase>
						<cfcase value="-3"><cf_get_lang_main no='1200.Üye Şirket Çalışanı'></cfcase>
						<cfcase value="-4"><cf_get_lang_main no='164.Çalışan'></cfcase>
						<cfcase value="-5"><cf_get_lang_main no='245.Ürün'></cfcase>
						<cfcase value="-6"><cf_get_lang no='120.Urun Agaci'></cfcase>
						<cfcase value="-7"><cf_get_lang_main no='795.Satış Siparişleri'></cfcase>
						<cfcase value="-8"><cf_get_lang_main dictionary_id='50922.Alış Faturaları'></cfcase>
						<cfcase value="-32"><cf_get_lang dictionary_id='50921.Satış Faturaları'></cfcase>
						<cfcase value="-9"><cf_get_lang_main no='2210.Satış Teklifleri'></cfcase>
						<cfcase value="-10"><cf_get_lang_main no='4.Proje'></cfcase>
						<cfcase value="-11"><cf_get_lang_main no='1420.Abone'></cfcase>
						<cfcase value="-12"><cf_get_lang no='439.Satınalma Siparişleri'></cfcase>
                        <cfcase value="-13"><cf_get_lang_main no='1421.Fiziki Varlık'></cfcase>
						<cfcase value="-19"><cf_get_lang no='806.IT Varlık'></cfcase>
						<cfcase value="-20"><cf_get_lang_main no='2.Araçlar'></cfcase>
						<cfcase value="-14"><cf_get_lang dictionary_id='39500.Alış İrsaliyeleri'></cfcase>
						<cfcase value="-31"><cf_get_lang dictionary_id="39502.Satış İrsaliyeleri"></cfcase>
                        <cfcase value="-15"><cf_get_lang_main no='244.Servis'></cfcase>
                        <cfcase value="-16"><cf_get_lang no='204.Satış Fırsatlar'></cfcase>
                        <cfcase value="-17"><cf_get_lang_main no='1591.Masraf ve gelir fişleri'></cfcase>
                        <cfcase value="-18"><cf_get_lang_main no='1033.İş'></cfcase>
                        <cfcase value="-21"><cf_get_lang_main no='1725.Sözleşme'></cfcase>
                        <cfcase value="-22"><cf_get_lang no='1231.Stok Fişleri'></cfcase>
                        <cfcase value="-23">CV</cfcase>
                        <cfcase value="-24"><cf_get_lang_main no="26.callcenter">-<cf_get_lang_main no="774.başvurular"></cfcase>
                        <cfcase value="-25"><cf_get_lang_main no="26.callcenter">-<cf_get_lang_main no="1317.Etkileşim"></cfcase>
						<cfcase value="-27"><cf_get_lang_main no="1277.Teminat"></cfcase>
						<cfcase value="-28"><cf_get_lang dictionary_id="49752.Satınalma Talebi"></cfcase>
						<cfcase value="-29"><cf_get_lang dictionary_id="30782.İç Talepler"></cfcase>
						<cfcase value="-30"><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></cfcase>
					</cfswitch>
					</a>
					<br/>
					<cfloop index="catid_position" from="1" to="#listlen(infoplus_names.multi_product_catid)#">
						<li>#getProductCat(listgetat(infoplus_names.multi_product_catid,catid_position))#</li>
					</cfloop>
					<cfloop index="sub_catid_position" from="1" to="#listlen(infoplus_names.multi_sub_catid)#">
						<li>#get_name_sub(listgetat(infoplus_names.multi_sub_catid,sub_catid_position))#</li>
					</cfloop>
					<cfloop index="sub_p_position" from="1" to="#listlen(infoplus_names.multi_assetp_catid)#">
						<li>#get_p_sub(listgetat(infoplus_names.multi_assetp_catid,sub_p_position))#</li>
					</cfloop>
					<cfloop index="sub_p_position" from="1" to="#listlen(infoplus_names.multi_work_catid)#">
						<li>#get_p_work(listgetat(infoplus_names.multi_work_catid,sub_p_position))#</li>
					</cfloop>
					<cfloop index="sales_addoption_id" from="1" to="#listlen(infoplus_names.sales_add_option)#">
                        <li>#get_sales_addoption(listgetat(infoplus_names.sales_add_option,sales_addoption_id))#</li>
                    </cfloop>
				<!---Buraya bak BK <cfif product_catid gt 0>(#get_name(product_catid)#)</cfif> --->
				</td>				
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</font></td>
		</tr>
	</cfif>
</table>
