<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>
<cfdirectory action="list" name="get_ds" directory="#upload_folder#reserve_files">
<cfif get_ds.recordcount>
	<cfoutput query="get_ds">
		<cfif type is 'dir' and name is not drc_name_>
			<cftry>
				<cfset d_name_ = name>
				<cfdirectory action="list" name="get_ds_ic" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
					<cfif get_ds_ic.recordcount>
						<cfloop query="get_ds_ic">
							<cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##d_name_##dir_seperator##get_ds_ic.name#">
						</cfloop>
					</cfif>
				<cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
			<cfcatch></cfcatch>
			</cftry>
		</cfif>
	</cfoutput>
</cfif>

<cfquery name="GET_DET_FORM" datasource="#DSN#">
    SELECT 
        SPF.TEMPLATE_FILE,
        SPF.FORM_ID,
        SPF.IS_DEFAULT,
        SPF.NAME,
        SPF.PROCESS_TYPE,
        SPF.MODULE_ID,
        SPFC.PRINT_NAME
    FROM 
        #dsn3_alias#.SETUP_PRINT_FILES SPF,
        SETUP_PRINT_FILES_CATS SPFC,
        MODULES MOD
    WHERE
        SPF.FORM_ID = #attributes.form_type# AND
        SPF.ACTIVE = 1 AND
        SPF.MODULE_ID = MOD.MODULE_ID AND
        SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
        SPFC.PRINT_TYPE = 193
    ORDER BY
        SPF.NAME
</cfquery>

<cfif not isdefined("attributes.SELECT_STOCK") or not len(attributes.SELECT_STOCK)>
	<script>
		alert('Ürün Seçmediniz!');
		window.close();
	</script>
    <cfabort>
</cfif>

<cfset attributes.print_count_genel = attributes.print_count>
<cfset sayi_ = listlen(attributes.SELECT_STOCK)>
<cfset filename_ = CreateUUID() & '.pdf'> 
<cfif GET_DET_FORM.NAME contains 'PDF'>
	<cfif not len(attributes.printer_name)>
    	<script>
			alert('PDF Yazdırmak İçin Tanımlı Yazıcınız Yok!');
			window.close();
		</script>
        <cfabort>
    </cfif>
	   
    <cfinclude template="/documents/settings/#GET_DET_FORM.TEMPLATE_FILE#">


	<cfset aset=StructNew()> 
	<cfset aset["usePdfPageSize"] = "yes">
    <cfset aset["autoRotateAndCenter"] = "no">
    <cfset aset["quality"] = "high">
    <cfprint 
        source = "#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename_#" 
        color = "yes" 
        printer = "#attributes.printer_name#" 
        type = "PDF"
        attributeStruct="#aset#"
        >
<cfelse>
    <cfloop from="1" to="#sayi_#" index="ccc">
        <cfset attributes.stock_id = listgetat(attributes.SELECT_STOCK,ccc)>
        <cfset price = evaluate("attributes.new_price_#attributes.stock_id#")>
        <cfset old_price = evaluate("attributes.ss_price_#attributes.stock_id#")>
        <cfset rate = evaluate("attributes.change_rate_#attributes.stock_id#")>
        <cfset barcode = '#evaluate("attributes.barcode_#attributes.stock_id#")#'>
        <cfset date_info = '#evaluate("attributes.date_info_#attributes.stock_id#")#'>
        <cfset s_date_info = '#evaluate("attributes.s_date_info_#attributes.stock_id#")#'>
        <cfset stock_name = "Ürün Adı">
        
        <cfif isdefined("attributes.print_count_#attributes.stock_id#") and len(evaluate("attributes.print_count_#attributes.stock_id#")) and isnumeric(evaluate("attributes.print_count_#attributes.stock_id#"))>
            <cfset attributes.print_count = evaluate("attributes.print_count_#attributes.stock_id#")>
        <cfelse>
            <cfset attributes.print_count = attributes.print_count_genel>
        </cfif>
        
        <cfinclude template="/documents/settings/#GET_DET_FORM.TEMPLATE_FILE#">
    </cfloop>
</cfif>
<script>
	//window.close();
</script>