<cfset dsn_adi = dsn>
<cfif isdefined ("attributes.type_id") and ListFind("-1,-2,-3,-4,-13,-15,-19,-21,-24",attributes.type_id)>
	<cfset tablo_adi = "INFO_PLUS_HISTORY">
	<cfset kolon_adi = "OWNER_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -5)>
	<cfset tablo_adi = "PRODUCT_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "PRODUCT_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -6)>
	<cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "STOCK_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ListFind("-7,-12",attributes.type_id)><!--- Satis ve satinalma siparisleri --->
	<cfset tablo_adi = "ORDER_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "ORDER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -8)or (attributes.type_id eq -32))>
	<cfset tablo_adi = "INVOICE_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "INVOICE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -9) or (attributes.type_id eq -30))><!--- Satis ve satinalma teklifleri --->
	<cfset tablo_adi = "OFFER_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "OFFER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined("attributes.type_id") and ((attributes.type_id) eq -16)>
	<cfset tablo_adi = "OPPORTUNITIES_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "OPP_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -10))>
	<cfset tablo_adi = "PROJECT_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "PROJECT_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))>
	<cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "SUBSCRIPTION_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -14) or (attributes.type_id eq -31))>
	<cfset tablo_adi = "SHIP_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "SHIP_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -17))>
	<cfset tablo_adi = "EXPENSE_ITEM_PLANS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "EXPENSE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -22))>
	<cfset tablo_adi = "STOCK_FIS_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "FIS_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -28) or (attributes.type_id eq -29))><!--- İç Talepler ve satinalma talepleri --->
	<cfset tablo_adi = "INTERNALDEMAND_INFO_PLUS_HISTORY">
	<cfset kolon_adi = "INTERNAL_ID">
	<cfset dsn_adi = dsn3>
</cfif>
<cfif isdefined ("attributes.type_id") and ListFind("-1,-2,-3,-4,-10,-13,-15,-21",attributes.type_id)>
	<cfquery name="GET_LABELS" datasource="#DSN#">
		SELECT
			*
		FROM
			SETUP_INFOPLUS_NAMES
		WHERE	
			OWNER_TYPE_ID = #attributes.type_id#
	</cfquery>
   	<cfif GET_LABELS.recordcount>
		<cfquery name="GET_SELECT_VALUES" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_INFOPLUS_VALUES
			WHERE	
				INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.INFO_ID#">
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_LABELS" datasource="#DSN3#">
		SELECT
			*
		FROM
			SETUP_PRO_INFO_PLUS_NAMES
		WHERE	
			OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
			<cfif isdefined("attributes.product_catid")>
				AND MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.product_catid#,%">
			</cfif>
			<cfif isdefined("attributes.sub_catid")>
				AND MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_catid#,%">
			</cfif>
	</cfquery>
  	<cfif GET_LABELS.recordcount>
		<cfquery name="GET_SELECT_VALUES" datasource="#DSN3#">
			SELECT
				*
			FROM
				SETUP_PRO_INFO_PLUS_VALUES
			WHERE	
				PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.PRO_INFO_ID#">
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_VALUES" datasource="#dsn_adi#">
	SELECT
		PROPERTY1,
		PROPERTY2,
		PROPERTY3,
		PROPERTY4,
		PROPERTY5,
		PROPERTY6,
		PROPERTY7,
		PROPERTY8,
		PROPERTY9,
		PROPERTY10,
		PROPERTY11,
		PROPERTY12,
		PROPERTY13,
		PROPERTY14,
		PROPERTY15,
		PROPERTY16,
		PROPERTY17,
		PROPERTY18,
		PROPERTY19,
		PROPERTY20,
        ISNULL(UPDATE_DATE,RECORD_DATE) DATE,
        ISNULL(UPDATE_EMP,RECORD_EMP) EMP
	FROM
		#tablo_adi#
	WHERE
		#kolon_adi# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_id#">
 		<cfif isdefined("attributes.type_id") and ListFind("-1,-2,-3,-4,-10,-13,-15,-19,-21",attributes.type_id)>
			AND INFO_OWNER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
		<cfelseif (isdefined("get_labels.pro_info_id") and len(get_labels.pro_info_id)) and (isdefined("attributes.type_id") and attributes.type_id eq -5)>
			AND PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_labels.pro_info_id#">
		</cfif> 
   ORDER BY
   		INFO_ID_HIST DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57810.Ek Bilgi'> <cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif get_values.recordcount neq 0>	
         <cf_grid_list>       
			<thead>
				<tr>
					<th width="20" class="text-center"><cf_get_lang dictionary_id ='57487.No'></th>
					<cfloop from="1" to="20" index="i">
						<cfset "property_#i#"=''>
						<cfloop from="1" to="#get_values.recordcount#" index="x">
							<cfset "temp_col_#i#" = evaluate("get_values.PROPERTY#i#[#x#]")>
							<cfif len(evaluate("temp_col_#i#"))>
								<cfset "property_#i#"=listappend(evaluate("property_#i#"),evaluate("temp_col_#i#"),',')>
							</cfif>
						</cfloop>
						<cfif listlen(evaluate("property_#i#")) and len(evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
							<th><cfoutput>#evaluate("GET_LABELS.PROPERTY#i#_NAME")#</cfoutput></th>
						</cfif>
					</cfloop>
					<th class="text-center"><cf_get_lang dictionary_id ='57891.Güncelleyen'></th>
					<th class="text-center"><cf_get_lang dictionary_id ='32449.Güncelleme Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_values">
					<tr>
						<td>#currentrow#</td>
						<cfloop from="1" to="20" index="i">
							<cfif listlen(evaluate("property_#i#")) and len(evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
								<td>#evaluate("PROPERTY#i#")#</td>
								</cfif>
						</cfloop>
						<td class="text-center">#get_emp_info(emp,0,0)#</td>
						<cfif len(date)>
							<cfset temp_update = date_add('h',session.ep.time_zone,date)>
						<cfelse>
							<cfset temp_update ="">
						</cfif>
						<td class="text-center">#dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)</td>
					</tr>
				</cfoutput>
			</tbody>
     	</cf_grid_list>
     <cfelse>
         <table>
            <tr><td><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td></tr>
         </table>
     </cfif> 
</cf_box>