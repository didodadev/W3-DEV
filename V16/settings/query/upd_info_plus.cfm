<!--- -5 ve -6  product ve product_tree icin --->
<cfif listfind('-1,-2,-3,-4,-10,-13,-19,-20,-15,-18,-21,-23,-25', attributes.owner_type_id,',')>
	<cfset DB_ADI ="#DSN#">
	<cfset TABLO_ADI ="SETUP_INFOPLUS_NAMES">
	<cfset TABLO_ADI_2 ="SETUP_INFOPLUS_VALUES">
	<cfset ALAN1 ="INFO_ID">
<cfelse>
	<cfset DB_ADI ="#DSN3#">
	<cfset TABLO_ADI ="SETUP_PRO_INFO_PLUS_NAMES">
	<cfset TABLO_ADI_2 ="SETUP_PRO_INFO_PLUS_VALUES">
	<cfset ALAN1 ="PRO_INFO_ID">
</cfif>

<cfloop from="1" to="40" index="j">
	<cfif isdefined("attributes.record_num_#j#")>
		<cfloop from="1" to="#Evaluate("attributes.record_num_#j#")#" index="i">
			<cfif len(Evaluate("attributes.value_#j#_#i#"))>
				<cfif isdefined("attributes.info_row_id_#j#_#i#") and len(Evaluate("attributes.info_row_id_#j#_#i#"))>
					<cfquery name="UPD_ROW" datasource="#DB_ADI#">
						UPDATE
							#TABLO_ADI_2#
						SET
							SELECT_VALUE = '#Evaluate("attributes.value_#j#_#i#")#'
						WHERE
							INFO_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.info_row_id_#j#_#i#")#">
					</cfquery>
				<cfelse>
					<cfquery name="add_row" datasource="#DB_ADI#">
						INSERT INTO 
							#TABLO_ADI_2#
						(
							#ALAN1#,
							SELECT_VALUE,
							PROPERTY_NO
						)
						VALUES
						(	
							'#Evaluate("attributes.info_id_#j#")#',
							'#Evaluate("attributes.value_#j#_#i#")#',
							'#Evaluate("attributes.row_no_#j#")#'
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>
<cfset str_column = "">
<cfloop from="1" to="40" index="i">
	<cfif len(evaluate("attributes.property#i#_name"))>
   		<cfset str_column = str_column & "property#i#_name ='"&evaluate("attributes.property#i#_name") & "',">
		<cfif isdefined("attributes.property#i#_req")>
			<cfset str_column = str_column & "property#i#_req = 1,">
		<cfelse>
			<cfset str_column = str_column & "property#i#_req = 0,">
		</cfif>
		<cfif len(evaluate("attributes.property#i#_type"))>
			<cfset str_column = str_column & "property#i#_type='" & evaluate("attributes.property#i#_type") & "',">
		<cfelse>
			<cfset str_column = str_column & "property#i#_type=NULL,">
		</cfif>
		<cfif len(evaluate("attributes.property#i#_range"))>
			<cfset str_column = str_column & "property#i#_range = '" & evaluate("attributes.property#i#_range") & "',">
		<cfelse>
			<cfset str_column = str_column & "property#i#_range=NULL,">
		</cfif>
		<cfif len(evaluate("attributes.property#i#_message"))>
			<cfset str_column = str_column & "property#i#_message = '" & evaluate("attributes.property#i#_message") & "',">
		<cfelse>
			<cfset str_column = str_column & "property#i#_message=NULL,">
		</cfif>
        <cfif len(evaluate("attributes.property#i#_no"))>
			<cfset STR_COLUMN = STR_COLUMN & "property#i#_no = '" & evaluate("attributes.property#i#_no") & "',">
		<cfelse>
			<cfset STR_COLUMN = STR_COLUMN & "property#i#_no=NULL,">
		</cfif>
		<cfif len(evaluate("attributes.property#i#_gdpr"))>
			<cfset STR_COLUMN = STR_COLUMN & "property#i#_gdpr = '" & evaluate("attributes.property#i#_gdpr") & "',">
		<cfelse>
			<cfset STR_COLUMN = STR_COLUMN & "property#i#_gdpr=NULL,">
		</cfif>
		<cfif isdefined("attributes.property#i#_mask")>
			<cfset str_column = str_column & "property#i#_mask = 1,">
		<cfelse>
			<cfset str_column = str_column & "property#i#_mask = 0,">
		</cfif>
	<cfelse>
		<cfset str_column = str_column & "property#i#_name=NULL,">
        <cfset str_column = str_column & "property#i#_req = NULL,">
        <cfset str_column = str_column & "property#i#_type=NULL,">
        <cfset str_column = str_column & "property#i#_range=NULL,">
        <cfset str_column = str_column & "property#i#_message=NULL,">
		<cfset STR_COLUMN = STR_COLUMN & "property#i#_no=NULL,">
		<cfset STR_COLUMN = STR_COLUMN & "property#i#_gdpr=NULL,">
		<cfset STR_COLUMN = STR_COLUMN & "property#i#_mask=NULL,">
	</cfif>
</cfloop>
<!--- Coklu secimdeki kategoriler istenen degere getiriliyor --->
<cfif attributes.owner_type_id eq -5>
	<cfset product_catid_ = ''>
	<cfif isdefined("attributes.product_catid")>
		<cfloop index="catid_position" from="1" to="#listlen(attributes.product_catid)#">
			<cfset product_catid_ = listappend(product_catid_,listfirst(listgetat(attributes.product_catid,catid_position),'-'))>
		</cfloop>
	</cfif>
<cfelseif attributes.owner_type_id eq -11>
	<cfset sub_catid_ = ''>
	<cfif isdefined("attributes.sub_catid")>
		<cfloop index="catid_position" from="1" to="#listlen(attributes.sub_catid)#">
			<cfset sub_catid_ = listappend(sub_catid_,listfirst(listgetat(attributes.sub_catid,catid_position),'-'))>
		</cfloop>
	</cfif>
<cfelseif listfind('-13,-19,-20',attributes.owner_type_id)>
	<cfset sub_assetid_ = ''>
	<cfif isdefined("attributes.sub_assetid")>
		<cfloop index="catid_position" from="1" to="#listlen(attributes.sub_assetid)#">
			<cfset sub_assetid_ = listappend(sub_assetid_,listfirst(listgetat(attributes.sub_assetid,catid_position),'-'))>
		</cfloop>
	</cfif>
<cfelseif attributes.owner_type_id eq -18>
	<cfset sub_workid_ = ''>
	<cfif isdefined("attributes.work_catid")>
		<cfloop index="catid_position" from="1" to="#listlen(attributes.work_catid)#">
			<cfset sub_workid_ = listappend(sub_workid_,listfirst(listgetat(attributes.work_catid,catid_position),';'))>
		</cfloop>
	</cfif>
</cfif>
<!--- Bu kullanıma veya urun ise bu kategoriye ait baska bir ek bilgi tanimi mevcut mu? --->
<cfquery name="GET_RECORD_VALID" datasource="#DB_ADI#">
	SELECT
		#ALAN1#
	FROM
		#TABLO_ADI#
	WHERE
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.owner_type_id#"> AND
		#ALAN1# <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		<cfif attributes.owner_type_id eq -5 and listlen(product_catid_)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(product_catid_)#">
                    MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(product_catid_,catid_position)#,%"> <cfif catid_position neq listlen(product_catid_)>OR</cfif>
                </cfloop>
            )
        <cfelseif attributes.owner_type_id eq -11 and listlen(sub_catid_)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(sub_catid_)#">
                    MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(attributes.sub_catid,catid_position)#,%"> <cfif catid_position neq listlen(attributes.sub_catid)>OR</cfif>
                </cfloop>
            )
        <cfelseif listfind('-13,-19,-20',attributes.owner_type_id) and listlen(sub_assetid_)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(sub_assetid_)#">
                    MULTI_ASSETP_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(attributes.sub_assetid,catid_position)#,%"> <cfif catid_position neq listlen(attributes.sub_assetid)>OR</cfif>
                </cfloop>
            )
        <cfelseif listfind('-18',attributes.owner_type_id) and listlen(attributes.work_catid)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(attributes.work_catid)#">
                    MULTI_WORK_CATID LIKE '%,#listgetat(attributes.work_catid,catid_position)#,%' <cfif catid_position neq listlen(attributes.work_catid)>OR</cfif>
                </cfloop>
            )
		<cfelseif attributes.owner_type_id eq -9>
            <cfif isDefined("attributes.sales_add_optionid") and listlen(attributes.sales_add_optionid)>
                AND
                (
                    <cfloop index="sales_addoptions" from="1" to="#listlen(attributes.sales_add_optionid)#">
                        SALES_ADD_OPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(attributes.sales_add_optionid,sales_addoptions)#,%"> <cfif sales_addoptions neq listlen(attributes.sales_add_optionid)>OR</cfif>
                    </cfloop>
                )
            <cfelse>
                AND SALES_ADD_OPTION IS NULL
            </cfif>
        </cfif>					
</cfquery>
<cfif get_record_valid.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='534.Özellik Sahibini Kontrol Ediniz !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif len(str_column)>
	<cfquery name="ADD_INFO" datasource="#DB_ADI#">
		UPDATE 
			#TABLO_ADI#
		SET
			#PreserveSingleQuotes(str_column)#
			OWNER_TYPE_ID = #attributes.owner_type_id#,
			<cfif attributes.owner_type_id eq -5>
				MULTI_PRODUCT_CATID = #sql_unicode()#',#product_catid_#,',
			<cfelseif attributes.owner_type_id eq -11>
				MULTI_SUB_CATID = #sql_unicode()#',#sub_catid_#,',
			<cfelseif listfind('-13,-19,-20',attributes.owner_type_id)>
				MULTI_ASSETP_CATID=#sql_unicode()#',#sub_assetid_#,',
			<cfelseif attributes.owner_type_id eq -18>
				MULTI_WORK_CATID=#sql_unicode()#',#sub_workid_#,',
			<cfelseif attributes.owner_type_id eq -9>
                <cfif isDefined("attributes.sales_add_optionid") and listlen(attributes.sales_add_optionid)>
                    SALES_ADD_OPTION=#sql_unicode()#',#attributes.sales_add_optionid#,',
                <cfelse>
                    SALES_ADD_OPTION = NULL,
                </cfif>
			</cfif>
			COLUMN_NUMBER = <cfif len(attributes.column_number)>#attributes.column_number#<cfelse>2</cfif>,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#	 
		WHERE
			#ALAN1# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.id#">
	</cfquery>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_info_plus&owner_type_id=#attributes.owner_type_id#&id=#attributes.id#">
