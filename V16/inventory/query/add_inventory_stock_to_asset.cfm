<cf_date tarih="attributes.start_date">
<cfif isdefined("attributes.row_number")>
	<cfset attributes.quantity = attributes.row_number>
</cfif>
<!--- Girilen kategori arac ise --->
<cfif attributes.select_list eq 2>
	<cfset assetp_list=''>
	<cfloop from="1" to="#attributes.quantity#" index="i">
		<cfset 'attributes.assetp#i#' = UCase(Replace(evaluate('attributes.assetp#i#')," ","","all"))>
		<cfset assetp_list=listappend(assetp_list,evaluate('attributes.assetp#i#'))>
	</cfloop>
	<cfquery name="GET_ASSETP_CONTROL1" datasource="#dsn#">
		SELECT
			ASSETP,
			SUP_COMPANY_DATE,
			EXIT_DATE
		FROM
			ASSET_P
		WHERE
			(
			<cfloop from="1" to="#attributes.quantity#" index="i">
			ASSETP = '#listgetat(assetp_list,i,',')#' <cfif i lt attributes.quantity>OR</cfif>
			</cfloop>
			)
			AND STATUS = 1
	</cfquery>
	<cfif get_assetp_control1.recordcount>
		<script type="text/javascript">
			alert('Aynı Plakalı Aktif Araç Bulundu, Lütfen Plakayı Kontrol Ediniz !\n Araçlar:<cfoutput>#get_assetp_control1.assetp#</cfoutput>');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif attributes.is_barcode_control eq 0>
	<cfset warn_ = 0>
	<cfset barcode_list=''>
	<cfloop from="1" to="#attributes.quantity#" index="i">
    	<cfif isdefined("attributes.barcode#i#")>
			<cfset 'attributes.barcode#i#'=UCase(Replace(evaluate('attributes.barcode#i#')," ","","all"))>
            <cfset barcode_list=listappend(barcode_list,evaluate('attributes.barcode#i#'))>
        </cfif>
	</cfloop>
    <cfset barcode_list2 = ListDeleteDuplicates(barcode_list)>
    <cfif listlen(barcode_list) neq listlen(barcode_list2)>
    	<cfset warn_ = 1>
    </cfif>    
	<cfif len(barcode_list)>
        <cfquery name="get_barcode_control" datasource="#dsn#">
            SELECT 	
                ASSETP,
                BARCODE
            FROM 
                ASSET_P
            WHERE 
            (
            <cfloop from="1" to="#attributes.quantity#" index="i">
                BARCODE = '#listgetat(barcode_list,i,',')#' <cfif i lt attributes.quantity>OR</cfif>
            </cfloop>
            )
            AND INVENTORY_ID <> #attributes.inventory_id#
        </cfquery>
        <cfif get_barcode_control.recordcount>
            <script type="text/javascript">
                alert('Girdiğiniz Barkod Başka Bir Fiziki Varlık Tarafından Kullanılmakta. Lütfen Başka Bir Barkod Giriniz. !\n Araçlar:<cfoutput>#get_barcode_control.assetp#</cfoutput>');
                history.back();
            </script>
            <cfabort>
        </cfif>
		<cfif warn_ eq 1>
            <script type="text/javascript">
                alert('Farklı Satırlar İçin Aynı Barkod Numarası Kullandınız!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfquery name="get_records" datasource="#dsn#">
	SELECT * FROM ASSET_P WHERE INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cfquery name="DEL_REC" datasource="#DSN#">
    DELETE FROM ASSET_P WHERE INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cflock name="#CREATEUUID()#" timeout="60">
  <cftransaction>
	<cfloop from="1" to="#attributes.quantity#" index="i">
	  <cfscript>
		form_assetp = evaluate("attributes.assetp#i#");
		form_serial_number = evaluate("attributes.serial_number#i#");
		form_assetp_group = evaluate("attributes.assetp_group#i#");
		form_usage_purpose = evaluate("attributes.usage_purpose#i#");
		form_position_code = evaluate("attributes.position_code#i#");
		form_emp_id = evaluate("attributes.emp_id#i#");
		form_department_id = evaluate("attributes.department_id#i#");				
		form_department_id_2 = evaluate("attributes.department_id_2_#i#");
		form_status = evaluate("attributes.status#i#");
		form_barcode = evaluate("attributes.barcode#i#");
	  </cfscript>	
		<cfquery name="ADD_ASSETP" datasource="#DSN#" result="MAX_ID">
		INSERT INTO 
			ASSET_P
		(
			PROPERTY,
            BARCODE,
            INVENTORY_NUMBER,
            INVENTORY_ID,
            ASSETP,
            SUP_COMPANY_ID,
            SUP_PARTNER_ID,
            SUP_CONSUMER_ID,				
            ASSETP_CATID,
            DEPARTMENT_ID,
            DEPARTMENT_ID2,
            POSITION_CODE,
            EMPLOYEE_ID,
            POSITION_CODE2,
            SUP_COMPANY_DATE,
            SERIAL_NO,
            PRIMARY_CODE,
            SERVICE_EMPLOYEE_ID,
            ASSETP_STATUS,
            USAGE_PURPOSE_ID,
            ASSETP_GROUP,
            BRAND_ID,
            BRAND_TYPE_ID,
            BRAND_TYPE_CAT_ID,				
            MAKE_YEAR,
            ASSETP_DETAIL,
            STATUS,
            IS_SALES,
            PROCESS_STAGE,
            RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			ASSETP_SUB_CATID
		)
		VALUES
		(
			1,
			<cfif len(form_barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_barcode#"><cfelse>NULL</cfif>,
			'#trim(attributes.inventory_number)#',
			#attributes.inventory_id#,
			'#form_assetp#',
			<cfif len(attributes.company_id)>
				#attributes.company_id#,
				#attributes.partner_id#,
				NULL,
			<cfelse>
				NULL,
				NULL,
				#attributes.consumer_id#,
			</cfif>				
			#listfirst(attributes.assetp_catid,';')#,<!--- attributes.assetp_catid  --->
			#form_department_id#,
			<cfif len(form_department_id_2)>#form_department_id_2#<cfelse>NULL</cfif>,
			#form_position_code#,
            #form_emp_id#,
			NULL,
			#attributes.start_date#,
			'#form_serial_number#',
			NULL,
			NULL,
			<cfif len(form_status)>#form_status#<cfelse>NULL</cfif>,
			<cfif len(form_usage_purpose)>#form_usage_purpose#<cfelse>NULL</cfif>,
			<cfif len(form_assetp_group)>#form_assetp_group#<cfelse>NULL</cfif>,				
			<cfif len(attributes.brand_id)>#attributes.brand_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.brand_type_id)>#attributes.brand_type_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.brand_type_cat_id)>#attributes.brand_type_cat_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.make_year)>#attributes.make_year#<cfelse>NULL</cfif>,
			NULL,
			1,
			0,
            #attributes.process_stage#,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'
			<cfif isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid)>,#listfirst(attributes.assetp_sub_catid,';')#<cfelse>,0</cfif><!--- attributes.assetp_sub_catid  --->
		)
	  </cfquery>
	  <cfquery name="ADD_HISTORY" datasource="#DSN#">
		INSERT INTO
			ASSET_P_HISTORY
		(
			ASSETP_ID,
			ASSETP,
			PROPERTY,
			DEPARTMENT_ID,
			DEPARTMENT_ID2,
			POSITION_CODE,
			STATUS,
            USAGE_PURPOSE_ID,
            ASSETP_STATUS,
			IS_SALES,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			#MAX_ID.IDENTITYCOL#,
			'#form_assetp#',
			1,
			#form_department_id#,
			<cfif len(form_department_id_2)>#form_department_id_2#<cfelse>NULL</cfif>,
			<cfif len(form_position_code)>#form_position_code#<cfelse>NULL</cfif>,
			1,
            <cfif len(form_usage_purpose)>#form_usage_purpose#<cfelse>NULL</cfif>,
            <cfif len(form_status)>#form_status#<cfelse>NULL</cfif>,
			0,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'
		)
		</cfquery>
		<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='ASSET_P'
		action_column='ASSETP_ID'
		action_id='#MAX_ID.IDENTITYCOL#'
		action_page='#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#MAX_ID.IDENTITYCOL#'
		warning_description='Varlık : #form_assetp#'>
	</cfloop>
	<cfquery name="UPD_INVENTORY" datasource="#DSN#">
		UPDATE
			#dsn3_alias#.INVENTORY
		SET
			TO_ASSET = 1,
            INVENTORY_NUMBER = '#attributes.inventory_number#'
		WHERE
			INVENTORY_ID = #attributes.inventory_id#
	</cfquery>

  </cftransaction>
</cflock>
<script type="text/javascript">
		location.href = document.referrer;
</script>
