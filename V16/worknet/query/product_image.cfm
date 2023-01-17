<cfif isdefined('session.ep.userid')>
	<cfset our_comp_id = session.ep.company_id>
<cfelseif isdefined('session.pp.userid')>
	<cfset our_comp_id = session.pp.our_company_id>
</cfif>
<cfquery name="get_file_size_comp" datasource="#dsn#">
	SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
</cfquery>

<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
<cfif isdefined('attributes.main_image')><cfset image_type = 1 /><cfelse><cfset image_type = 0 /></cfif>

<cfif (isdefined('attributes.is_del') and attributes.is_del eq 1) and (isdefined('attributes.product_image_id') and len(attributes.product_image_id))>
	<cfset getProductImage = cmp.getProductImage(product_image_id:attributes.product_image_id)>
	<cfif getProductImage.recordcount>
		<cfif FileExists("#upload_folder#product#dir_seperator##getProductImage.path#")>
			<cf_del_server_file output_file="product/#getProductImage.path#" output_server="#getProductImage.path_server_id#">
		</cfif>
		<cfset delProductImage = cmp.delProductImage(product_image_id:attributes.product_image_id)>
	</cfif>
<cfelseif isdefined('attributes.product_image_id') and len(attributes.product_image_id)>
	<cfif isDefined("attributes.product_image") and len(attributes.product_image)>
		<cffile action="UPLOAD" destination="#upload_folder#product#dir_seperator#" filefield="product_image" nameconflict="MAKEUNIQUE" accept="image/*">
		
		<cfset product_image_file_name = createUUID()>
		<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##product_image_file_name#.#cffile.serverfileext#">
		<cfset product_image = '#product_image_file_name#.#cffile.serverfileext#'>		
		
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<!--- dosya boyutu kontrol --->
		<cfif get_file_size_comp.is_file_size>
			<cfquery name="get_file_size" datasource="#dsn#">
				SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
			</cfquery>
			<cfif get_file_size.recordcount and len(get_file_size.format_size)>
				<cfset dt_size=get_file_size.format_size * 1048576>
				<cfif INT(dt_size) lte INT(filesize)>
					<cfif FileExists("#upload_folder##product_image#")>
						<cffile action="delete" file="#upload_folder##product_image#">
					</cfif>
					 <script type="text/javascript">
						alert('Ürün imajı ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<cf_del_server_file output_file="product/#attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
	<cfelse>
		<cfset product_image = ''>
	</cfif>
	<cfset cmp.updProductImage(
			product_image_id:attributes.product_image_id,
			product_id:attributes.product_id,
			path:product_image,
			image_type:image_type,
			detail:attributes.detail
		) />
<cfelse>
	<cfset upload_folder = "#upload_folder#product#dir_seperator#">
	<cffile action="UPLOAD" filefield="product_image" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
	<cfset product_image_file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##product_image_file_name#.#cffile.serverfileext#">
	<cfset product_image = '#product_image_file_name#.#cffile.serverfileext#'>
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<!--- dosya boyutu kontrol --->
	<cfif get_file_size_comp.is_file_size>
		<cfquery name="get_file_size" datasource="#dsn#">
			SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
		</cfquery>
		<cfif get_file_size.recordcount and len(get_file_size.format_size)>
			<cfset dt_size=get_file_size.format_size * 1048576>
			<cfif INT(dt_size) lte INT(filesize)>
				<cfif FileExists("#upload_folder##product_image#")>
					<cffile action="delete" file="#upload_folder##product_image#">
				</cfif>
				 <script type="text/javascript">
					alert('Ürün imajı ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
	<!--- dosya boyutu kontrol --->
	<cfset cmp.addProductImage(
			product_id:attributes.product_id,
			path:product_image,
			image_type:image_type,
			detail:attributes.detail
		) />	
</cfif>

<cfif isdefined('session.pp')>
	<cfquery name="updProduct" datasource="#dsn1#">
		UPDATE WORKNET_PRODUCT SET UPDATE_MEMBER = #session.pp.userid#, UPDATE_MEMBER_TYPE = 'COMPANY' WHERE PRODUCT_ID = #attributes.product_id#
	</cfquery>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.pp.userid#' 
		record_date='#now()#' 
		action_table='WORKNET_PRODUCT'
		action_column='PRODUCT_ID'
		action_id='#attributes.product_id#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_product&pid=#attributes.product_id#' 
		warning_description = 'Worknet Ürün : #attributes.product_name#'>
</cfif>

<script type="text/javascript">
	window.top.reload_this_page();
</script>

