<cfif listfind('-1,-2,-3,-4,-10,-13,-19,-20,-15,-18,-21,-23,-25', attributes.owner_type_id,',')>
	<cfset DB_ADI ="#DSN#">
	<cfset TABLO_ADI ="SETUP_INFOPLUS_NAMES">
	<cfset ALAN1 ="INFO_ID">
<cfelse>
	<cfset DB_ADI ="#DSN3#">
	<cfset TABLO_ADI ="SETUP_PRO_INFO_PLUS_NAMES">
	<cfset ALAN1 ="PRO_INFO_ID">
</cfif>
<cfif attributes.owner_type_id eq -13>
	<cfset attributes.assetp_catid = attributes.assetp_catid>
<cfelseif attributes.owner_type_id eq -19>
	<cfset attributes.assetp_catid = attributes.assetp_catid_it>
<cfelseif attributes.owner_type_id eq -20>
	<cfset attributes.assetp_catid = attributes.assetp_catid_vehicles>
</cfif>
<!--- Bu kullanıma veya urun ise bu kategoriye ait baska bir ek bilgi tanimi mevcut mu? --->
<cfquery name="GET_RECORD_VALID" datasource="#DB_ADI#">
	SELECT
		#ALAN1#
	FROM
		#TABLO_ADI#
	WHERE
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.owner_type_id#">
		<cfif attributes.owner_type_id eq -5 and listlen(attributes.product_catid)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(attributes.product_catid)#">
                    MULTI_PRODUCT_CATID LIKE '%,#listgetat(attributes.product_catid,catid_position)#,%' <cfif catid_position neq listlen(attributes.product_catid)>OR</cfif>
                </cfloop>
            )
        <cfelseif attributes.owner_type_id eq -11 and listlen(attributes.sub_catid)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(attributes.sub_catid)#">
                    MULTI_SUB_CATID LIKE '%,#listgetat(attributes.sub_catid,catid_position)#,%' <cfif catid_position neq listlen(attributes.sub_catid)>OR</cfif>
                </cfloop>
            )
        <cfelseif listfind('-13,-19,-20',attributes.owner_type_id) and listlen(attributes.assetp_catid)>
            AND
            (
                <cfloop index="catid_position" from="1" to="#listlen(attributes.assetp_catid)#">
                    MULTI_ASSETP_CATID LIKE '%,#listgetat(attributes.assetp_catid,catid_position)#,%' <cfif catid_position neq listlen(attributes.assetp_catid)>OR</cfif>
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

<cfset str_column = "">
<cfset str_value = "">
<cfloop from="1" to="40" index="i">
	<cfif isdefined("attributes.property#i#_name")>
		<cfset str_column = str_column & " property#i#_name,">
		<cfset str_value = str_value & "'"&   evaluate("attributes.property#i#_name")& "',">
	</cfif>
</cfloop> 

<cfif len(str_column)>
	<cfquery name="ADD_INFO" datasource="#DB_ADI#" result="MAX_ID">
		INSERT INTO 
			#TABLO_ADI#
		(
			#PreserveSingleQuotes(STR_COLUMN)#
			OWNER_TYPE_ID,
			<cfif attributes.owner_type_id eq -5>MULTI_PRODUCT_CATID,</cfif>
			<cfif attributes.owner_type_id eq -11>MULTI_SUB_CATID,</cfif>
			<cfif listfind('-13,-19,-20',attributes.owner_type_id)>MULTI_ASSETP_CATID,</cfif>
			<cfif attributes.owner_type_id eq -18>MULTI_WORK_CATID,</cfif>
            <cfif attributes.owner_type_id eq -9 and (isdefined("attributes.sales_add_optionid") and ListLen(attributes.sales_add_optionid))>SALES_ADD_OPTION,</cfif>
			COLUMN_NUMBER,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP,
            PROPERTY1_RANGE,
            PROPERTY2_RANGE,
            PROPERTY3_RANGE,
            PROPERTY4_RANGE,
            PROPERTY5_RANGE,
            PROPERTY6_RANGE,
            PROPERTY7_RANGE,
            PROPERTY8_RANGE,
            PROPERTY9_RANGE,
            PROPERTY10_RANGE,
            PROPERTY11_RANGE,
            PROPERTY12_RANGE,
            PROPERTY13_RANGE,
            PROPERTY14_RANGE,
            PROPERTY15_RANGE,
            PROPERTY16_RANGE,
            PROPERTY17_RANGE,
            PROPERTY18_RANGE,
            PROPERTY19_RANGE,
            PROPERTY20_RANGE           
		)
		VALUES
		(
			#PreserveSingleQuotes(STR_VALUE)#
			#OWNER_TYPE_ID#,
			<cfif attributes.owner_type_id eq -5 and (isdefined("attributes.product_catid") and len(attributes.product_catid))><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.product_catid#,">,</cfif>
			<cfif attributes.owner_type_id eq -11 and (isdefined("attributes.sub_catid") and len(attributes.sub_catid))><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.sub_catid#,">,</cfif>
			<cfif listfind('-13,-19,-20',attributes.owner_type_id) and (isdefined("attributes.assetp_catid") and len(attributes.assetp_catid))><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.assetp_catid#,">,</cfif>
			<cfif attributes.owner_type_id eq -18 and (isdefined("attributes.work_catid") and len(attributes.work_catid))><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.work_catid#,">,</cfif>
            <cfif attributes.owner_type_id eq -9 and (isdefined("attributes.sales_add_optionid") and ListLen(attributes.sales_add_optionid))><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.sales_add_optionid#,">,</cfif>
            <cfif isdefined("attributes.column_number")>#attributes.column_number#<cfelse>1</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#,
			#session.ep.userid#,
            100,
            100,
            100,
            100,
            100,
            100,
            100,
            100,
            100,
            100,
            250,
            250,
            250,
            250,
            250,
            250,
            250,
            250,
            250,
            250
		)
	</cfquery>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_info_plus&owner_type_id=#attributes.owner_type_id#&id=#MAX_ID.IDENTITYCOL#">
