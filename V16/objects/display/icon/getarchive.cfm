<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<!--- <a href="##" onclick="sendImage('#asset_file_name#','#ReplaceList(file_path,'\','\\')#','#desc#')" class="tableyazi">--->
<cfset ext_formats = '.png,.jpg,.gif,.png'>
<cfif isDefined("attributes.filepath")>
    <cfif attributes.module eq 'product'>
	    <cfif attributes.filepath does not contain 'product\'>
			<cffile action="copy" source="#attributes.filepath#" destination="#upload_folder#product#dir_seperator#">
		</cfif>			
		<cfquery name="ADD_IMAGE" datasource="#DSN1#">
			INSERT INTO 
				PRODUCT_IMAGES 
			(
				PRODUCT_ID, 
				PATH, 
				PATH_SERVER_ID,
				DETAIL, 
				IMAGE_SIZE
			)
			VALUES 
			(
				#attributes.id#, 
				'#attributes.filename#',
				#fusebox.server_machine#,
				'#attributes.description#'
				,<cfif isDefined("form.size")>1<cfelse>0</cfif>
			)
		</cfquery>
	<cfelseif attributes.module eq 'campaign'>
	    <cfif attributes.filepath does not contain 'campaign\'>
			<cffile 
			action="copy"
			source="#attributes.filepath#" 
			destination="#upload_folder#campaign#dir_seperator#">
		</cfif>			
		<cfquery name="ADD_IMAGE" datasource="#DSN3#">
			INSERT INTO 
				CAMPAIGN_IMAGES 
			(
				CAMP_ID, 
				PATH, 
				IMAGE_SERVER_ID,
				DETAIL, 
				IMAGE_SIZE
			)
			VALUES 
			(
				#attributes.id#,
				'#attributes.filename#',
				#fusebox.server_machine#,
				'#attributes.description#'
				,<cfif isDefined("form.size")>1<cfelse>0</cfif>
			)
		</cfquery>
	<cfelseif attributes.module eq 'content'>
        <cfif attributes.filepath does not contain 'content\'>
			<cffile 
			action="copy"
			source="#attributes.filepath#" 
			destination="#upload_folder#content#dir_seperator#">
		</cfif>			
		<cfquery name="ADD_IMAGE" datasource="#DSN#">
			INSERT INTO 
				CONTENT_IMAGE 
			(
				CONTENT_ID,
				CNT_IMG_NAME,
				CONTIMAGE_SMALL,
				IMAGE_SERVER_ID,
				DETAIL
			)
			VALUES 
			(
				#attributes.id#,	
				#sql_unicode()#'#attributes.description#', 						
				'#attributes.filename#',
				#fusebox.server_machine#,
				#sql_unicode()#'imaj'
			)
		</cfquery>
	<cfelseif attributes.module eq 'content2'>
        <cfif attributes.filepath does not contain 'content\'>
			<cffile 
				action="copy"
				source="#attributes.filepath#" 
				destination="#upload_folder#content#dir_seperator#">
		</cfif>
		<script type="text/javascript">
		     window.opener.Image_Put('<cfoutput>#attributes.filename#</cfoutput>','','','<cfif not isdefined("session.cid")>1<cfelse>0</cfif>');    
		     window.opener.close(); 
		     window.close(); 
		</script>			
        <cfabort>
	<cfelse>
	    <cfif attributes.module eq 'content3'><cfset attributes.module = 'content'></cfif>
		<cfif attributes.filepath does not contain 'content\'>
		<cffile 
			action="copy"
			source="#attributes.filepath#" 
			destination="#upload_folder##attributes.module##dir_seperator#">
		</cfif>	
		<script type="text/javascript">
		     window.opener.take_image('<cfoutput>#user_domain#documents/#attributes.module#/</cfoutput>','<cfoutput>#attributes.filename#</cfoutput>');    
		     window.close(); 
		</script>			
        <cfabort>		  
 	</cfif>
	<script type="text/javascript">
		//wrk_opener_reload();
		window.opener.location.reload();
		window.close();
	</script>	
	<cfabort>
</cfif>
<cfset url_str = "">
<cfif isdefined("attributes.module")>
	<cfset url_str = "#url_str#&module=#attributes.module#">
</cfif>
<cfif isdefined("attributes.id")>
	<cfset url_str = "#url_str#&id=#attributes.id#">
</cfif>
<cfset url_str = "#url_str#&thumbnail=1">

<form name="image_Copy" method="post">
	<input type="hidden" name="filename" id="filename" value="">
	<input type="hidden" name="filepath" id="filepath" value="">
	<input type="hidden" name="id" id="id" value="">
	<input type="hidden" name="description" id="description" value="">
	<input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>">
</form>

<cfparam name="attributes.thumbnail" default="1">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfinclude template="../../../asset/query/get_assets.cfm">
<script type="text/javascript">
	function sendImage(file,path,this_id,desc)
	{       
		document.image_Copy.filename.value = file;
		document.image_Copy.filepath.value = path;
		document.image_Copy.id.value = this_id;
		document.image_Copy.description.value = desc;		
		document.image_Copy.submit();			
	}
</script>


<cfparam name="attributes.totalrecords" default="#get_assets.recordcount#">
<cfsavecontent variable="header_"><cf_get_lang_main no="150.Dijital Varlıklar"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#header_#">
		<cfform name="search_asset" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post"> 
			<cf_box_search more="0">
				<!--- Arama --->
				<input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>">
				<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
				<input type="hidden" name="thumbnail" id="thumbnail" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
						SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
					</cfquery>							
					<select name="property_id" id="property_id">
						<option value=""><cf_get_lang no ='1273.Döküman Tipleri'>
						<cfoutput query="get_content_property">
							<option value="#content_property_id#"<cfif isDefined("attributes.property_id") and (content_property_id eq attributes.property_id)> selected</cfif>>#name#
						</cfoutput>
					</select>	
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
	
		</cfform>
		<cfinclude template="thumbnail.cfm">
	</cf_box>
</div>
