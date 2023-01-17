<cfif isdefined("attributes.type")>
	<cfif not DirectoryExists("#upload_folder#olcutablo#dir_seperator#")>
		<cfdirectory action="create" directory="#upload_folder#olcutablo#dir_seperator#">
	</cfif>
	<cfset upload_folder_ = "#upload_folder#olcutablo#dir_seperator#">
		<cfif attributes.type eq "add">
			<cftry>
				<cffile action = "upload" 
						filefield = "olcu_tablo" 
						destination = "#upload_folder_#"
						nameconflict = "MakeUnique"  
						mode="777" charset="utf-8">
				<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
				<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
				<cfset file_size = cffile.filesize>
				<cfquery name="add_images" datasource="#dsn3#">
					INSERT INTO TEXTILE_SAMPLE_REQUEST_IMAGE(REQ_ID,MEASURE_FILENAME) VALUES (#attributes.req_id#, '#file_name#')
				</cfquery>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  	
			</cftry>
		<cfelseif attributes.type eq "del">
			<cfquery name="get_images" datasource="#dsn3#">
				SELECT MEASURE_FILENAME 
				FROM TEXTILE_SAMPLE_REQUEST_IMAGE 
				WHERE IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_id#">
			</cfquery>
			<cftry>
				<cffile action = "delete" file = "#upload_folder_##get_images.MEASURE_FILENAME#">
				<cfquery name="add_images" datasource="#dsn3#">
					DELETE FROM TEXTILE_SAMPLE_REQUEST_IMAGE WHERE IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_id#"> 
				</cfquery>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("Dosyanız silinemedi!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  	
			</cftry>
		</cfif>
		<script type="text/javascript">
			window.location.href = '<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.req_id#</cfoutput>';
		</script>
	<cfelse>
		<script>alert('Eksik parametre gönderdiniz');</script>
	</cfif>