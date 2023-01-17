<cfinclude template="../../config.cfm">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('session.ep.userid')>
			<cfset our_comp_id = session.ep.company_id>
		<cfelseif isdefined('session.pp.userid')>
			<cfset our_comp_id = session.pp.our_company_id>
		</cfif>
		<cfquery name="get_file_size_comp" datasource="#dsn1#">
			SELECT FILE_SIZE,IS_FILE_SIZE FROM #dsn_alias#.OUR_COMPANY_INFO WHERE COMP_ID = #our_comp_id#
		</cfquery>
		<cfset upload_folder = "#upload_folder#product#dir_seperator#">
        <!--- image --->
        <cfobject name="fileHelper" component="#addonNS#.components.common.filehelper">
		<cfif isDefined("attributes.product_image") and len(attributes.product_image)>
            <cftry>
                <cfset attributes.product_image = fileHelper.save_uploaded_file('product_image', '#upload_folder#')>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz'> !");
					</script>
				</cfcatch>  
			</cftry>
			<!--- dosya boyutu kontrol --->
			<cfif get_file_size_comp.is_file_size>
				<cfquery name="get_file_size" datasource="#dsn1#">
					SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM #dsn_alias#.SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
				</cfquery>
                <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                    <cfif fileHelper.remove_exceed_file(get_file_size.format_size, "#upload_folder##attributes.product_image#") eq "1">
                        <script type="text/javascript">
                            alert('Ürün resmi ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
                        </script>
                        <cfabort>
                    </cfif>
				</cfif>
			</cfif>
			<!--- dosya boyutu kontrol --->
		<cfelse>
			<cfset attributes.product_image = ''>
		</cfif>
		<!--- asset --->
		<cfif isDefined("attributes.product_asset") and len(attributes.product_asset) and attributes.is_catalog eq 1>
			<cfif isdefined("attributes.old_file_name") and len(attributes.old_file_name)>
				<cf_del_server_file output_file="#upload_folder##attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
				<cfset delAsset = objectResolver.resolveByRequest("#addonNS#.components.common.asset").delAsset(asset_id:attributes.asset_id)>
            </cfif>
            <cftry>
                <cfset attributes.product_asset = fileHelper.save_uploaded_file('product_asset', '#upload_folder#')>
                <cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz'> !");
					</script>
				</cfcatch>
            </cftry>
			
			<!--- dosya boyutu kontrol --->
			<cfif get_file_size_comp.is_file_size>
				<cfquery name="get_file_size" datasource="#dsn1#">
					SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM #dsn_alias#.SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
				</cfquery>
                <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                    <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                        <cfif fileHelper.remove_exceed_file(get_file_size.format_size, "#upload_folder##attributes.product_asset#") eq "1">
                            <script type="text/javascript">
                                alert('Katalog belgesi ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
				</cfif>
			</cfif>
			<!--- dosya boyutu kontrol --->
		<cfelse>
			<cfset attributes.product_asset = ''>
			<cfset product_asset_real_name =  ''>
		</cfif>
		<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.products.product") />
		<cfset cmp.addProduct(
				company_id:attributes.company_id,
				partner_id:attributes.partner_id,
				product_catid:attributes.product_catid,
				product_stage:attributes.process_stage,
				product_name:trim(attributes.product_name),
				productKeyword:trim(attributes.product_keyword),
				product_brand:iif(isdefined("attributes.product_brand"),"trim(attributes.product_brand)",DE("")),
				product_code:iif(isdefined("attributes.product_code"),"trim(attributes.product_code)",DE("")),
				product_image:attributes.product_image,
				description:trim(attributes.description),
				product_detail:attributes.product_detail,
				is_catalog:attributes.is_catalog
			) />
		<cfquery name="maxProduct" datasource="#dsn1#">
			SELECT MAX(PRODUCT_ID) AS MAX_ID FROM WORKNET_PRODUCT
		</cfquery>
    </cftransaction>
</cflock>	
<cfif attributes.is_catalog eq 1>
	<cfif len(attributes.product_asset)>
		<cfset objectResolver.resolveByRequest("#addonNS#.components.common.asset").addAsset(
			action_id:maxProduct.max_id,
			action_section:'WORKNET_PRODUCT_ID',
			asset_cat_id:-25,
			file_name:attributes.product_asset,
			file_real_name:product_asset_real_name,
			asset_name:attributes.product_name
		) />
	</cfif>	
</cfif>

<cfif isdefined('session.ep')>
	<cfset process_user_id = session.ep.userid>
<cfelseif  isdefined('session.pp')>
	<cfset process_user_id = session.pp.userid>
</cfif>
<cfif isdefined("attributes.process_stage")>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#process_user_id#' 
	record_date='#now()#' 
	action_table='WORKNET_PRODUCT'
	action_column='PRODUCT_ID'
	action_id='#maxProduct.MAX_ID#'
	action_page='#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det']['fuseaction']#&pid=#maxProduct.MAX_ID#' 
	warning_description = 'Urun : #attributes.product_name#'>
</cfif>

<cfif attributes.is_catalog eq 0><!--- Urun Guncelleme --->
    <script type="text/javascript">
        window.location.href = "<cfoutput>#WOStruct['#attributes.fuseaction#']['add']['nextEvent']##maxProduct.MAX_ID#</cfoutput>";
    </script>
<cfelse> <!--- Katalog Guncelleme --->
    <script type="text/javascript">
        window.location.href = "<cfoutput>#WOStruct['#attributes.fuseaction#']['add-catalog']['nextEvent']##maxProduct.MAX_ID#</cfoutput>";
    </script>
</cfif>
