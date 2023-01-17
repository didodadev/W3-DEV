<cfif attributes.image_type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
	<cfset table = "PRODUCT_BRANDS_IMAGES">
    <cfset identity_column = "BRAND_ID">
<cfelseif attributes.image_type eq "product"><!--- Ürün den eklenmişse --->
	<cfset table = "PRODUCT_IMAGES">
    <cfset identity_column = "PRODUCT_ID">
</cfif>
<cftry>
	<cfset file_name = createUUID()>
	<cffile 
		action ="upload" 
		filefield ="image_file" 
		destination ="#upload_folder#product#dir_seperator#"  
		nameconflict ="MakeUnique"> <!--- accept ="image/*" --->
<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
<cfset session.imFile = #file_name#&"."&#cffile.serverfileext#>
<cfcatch type="any">
	<script type="text/javascript">
		alert("Lütfen imaj dosyası giriniz!");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfimage 
	Source="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#"
	action="resize" 
	width="#attributes.small_width#" 
	height="#attributes.small_height#" 
	destination="#upload_folder#product#dir_seperator##file_name#_k.jpg" 
	overwrite="yes">
<cfimage 
	Source="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#"
	action="resize" 
	width="#attributes.medium_width#" 
	height="#attributes.medium_height#" 
	destination="#upload_folder#product#dir_seperator##file_name#_o.jpg" 
	overwrite="yes">
<cfimage 
	Source="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#"
	action="resize" 
	width="#attributes.large_width#"
	height="#attributes.large_height#" 
	destination="#upload_folder#product#dir_seperator##file_name#_b.jpg" 
	overwrite="yes">
<cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">

<cfquery name="ADD_MULTI_IMAGE" datasource="#DSN1#">
	INSERT INTO 
		#table#
	(
		IS_INTERNET,
		#identity_column#,
		PATH,
		PATH_SERVER_ID,
		DETAIL,
		IMAGE_SIZE,
		STOCK_ID,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP		
	)
	VALUES
	(
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		#attributes.image_action_id#,
		'#file_name#_k.jpg',
		'#fusebox.server_machine#',
		'#attributes.detail#',
		0,
		<cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,		
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cfquery name="ADD_MULTI_IMAGE" datasource="#DSN1#">
	INSERT INTO 
		#table#
	(
		IS_INTERNET,
		#identity_column#,
		PATH,
		PATH_SERVER_ID,
		DETAIL,
		IMAGE_SIZE,
		STOCK_ID,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP		
	)
	VALUES
	(
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		#attributes.image_action_id#,
		'#file_name#_o.jpg',
		'#fusebox.server_machine#',
		'#attributes.detail#',
		1,
		<cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cfquery name="ADD_MULTI_IMAGE" datasource="#DSN1#">
	INSERT INTO 
		#table#
	(
		IS_INTERNET,
		#identity_column#,
		PATH,
		PATH_SERVER_ID,
		DETAIL,
		IMAGE_SIZE,
		STOCK_ID,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP		
	)
	VALUES
	(
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		#attributes.image_action_id#,
		'#file_name#_b.jpg',
		'#fusebox.server_machine#',
		'#attributes.detail#',
		2,
		<cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
	 location.href = document.referrer;
	window.close();
</script>
