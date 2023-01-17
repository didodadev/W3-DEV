<!--- form_add_company_info.cfm --->

<cfif isdefined("form.company_name")>
	<cfquery name="CHECK" datasource="#DSN#">
		SELECT * FROM OUR_COMPANY
	</cfquery>
	
<cfif check.recordcount eq 0>
<cfquery name="ADD_OUR_COMPANY" datasource="#DSN#">
			INSERT 
		INTO
			OUR_COMPANY
			(
			IS_ORGANIZATION,
			COMPANY_NAME,
			NICK_NAME,
			MANAGER,
			TAX_OFFICE,
			TAX_NO,
			TEL_CODE,
			TEL,
			FAX,
			WEB,
			EMAIL,
			ADDRESS,
			ADMIN_MAIL,
			TEL2,
			TEL3,
			TEL4,
			FAX2,
			T_NO,
			SERMAYE,
			CHAMBER,
			CHAMBER_NO,
			CHAMBER2,
			CHAMBER2_NO
			)
			VALUES
			(
			<cfif isdefined(attributes.is_organization)>1<cfelse>0</cfif>,
			'#COMPANY_NAME#',
			'#NICK_NAME#',
			<cfif len(MANAGER)>'#MANAGER#',<cfelse>NULL,</cfif>
			<cfif LEN(TAX_OFFICE)>'#TAX_OFFICE#',<cfelse>NULL,</cfif>
			<cfif LEN(TAX_NO)>'#TAX_NO#',<cfelse>NULL,</cfif>
			<cfif LEN(TEL_CODE)>'#TEL_CODE#',<cfelse>NULL,</cfif>
			<cfif LEN(TEL)>'#TEL#',<cfelse>NULL,</cfif>
			<cfif LEN(FAX)>'#FAX#',<cfelse>NULL,</cfif>
			<cfif LEN(WEB)>'#WEB#',<cfelse>NULL,</cfif>
			<cfif LEN(EMAIL)>'#EMAIL#',<cfelse>NULL,</cfif>
			<cfif LEN(ADDRESS)>'#ADDRESS#',<cfelse>NULL,</cfif>
			<cfif LEN(ADMIN_MAIL)>'#ADMIN_MAIL#',<cfelse>NULL,</cfif>
			<cfif LEN(TEL2)>'#TEL2#',<cfelse>NULL,</cfif>
			<cfif LEN(TEL3)>'#TEL3#',<cfelse>NULL,</cfif>
			<cfif LEN(TEL4)>'#TEL4#',<cfelse>NULL,</cfif>
			<cfif LEN(FAX2)>'#FAX2#',<cfelse>NULL,</cfif>
			<cfif LEN(T_NO)>'#T_NO#',<cfelse>NULL,</cfif>
			<cfif LEN(SERMAYE)>'#SERMAYE#',<cfelse>NULL,</cfif>
			<cfif LEN(CHAMBER)>'#CHAMBER#',<cfelse>NULL,</cfif>
			<cfif LEN(CHAMBER_NO)>'#CHAMBER_NO#',<cfelse>NULL,</cfif>
			<cfif LEN(CHAMBER2)>'#CHAMBER2#',<cfelse>NULL,</cfif>
			<cfif LEN(CHAMBER2_NO)>'#CHAMBER2_NO#'<cfelse>NULL</cfif>
		)
	</cfquery>
<!--- 1.asset baş--->
<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">		
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset1" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME1='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME1_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 1.asset son --->

<!--- 2.asset --->
	<cfif isdefined("attributes.asset2") and len(attributes.asset2)>

		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset2" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME2='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME2_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 2.asset son --->
<!--- 3.asset --->
	<cfif isdefined("attributes.asset3") and len(attributes.asset3)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">	
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset3" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME3='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME3_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 3.asset son --->

<cfelse>
<cfquery name="UPD" datasource="#DSN#">
	UPDATE OUR_COMPANY
	SET
	IS_ORGANIZATION = <cfif isdefined(attributes.is_organization)>1<cfelse>0</cfif>,
	COMPANY_NAME='#COMPANY_NAME#',
	NICK_NAME='#NICK_NAME#',
	MANAGER='#MANAGER#',
	TAX_OFFICE='#TAX_OFFICE#',
	TAX_NO=<cfif isdefined("TAX_NO") and len(TAX_NO)>'#TAX_NO#',<cfelse>NULL,</cfif>
	TEL_CODE=<cfif isdefined("TEL_CODE") and len(TEL_CODE)>'#TEL_CODE#',<cfelse>NULL,</cfif>
	<cfif isdefined("TEL") and len(TEL)>
	TEL='#TEL#',
	<cfelse>
	TEL=NULL,
	</cfif>
	<cfif isdefined("FAX") and len(FAX)>
	FAX='#FAX#',
	<cfelse>
	FAX=null,
	</cfif>
	WEB='#WEB#',
	EMAIL='#EMAIL#',
	ADDRESS='#ADDRESS#',
	ADMIN_MAIL='#ADMIN_MAIL#',
	<cfif isdefined("TEL2") and len(TEL2)>
	TEL2='#TEL2#',
	<cfelse>
	TEL2=null,
	</cfif>
	<cfif isdefined("TEL3") and len(TEL3)>
	TEL3='#TEL3#',
	<cfelse>
	TEL3=null,
	</cfif>
	<cfif isdefined("TEL4") and len(TEL4)>
	TEL4='#TEL4#',
	<cfelse>
	TEL4=null,
	</cfif>
	<cfif isdefined("FAX2") and len(FAX2)>
	FAX2='#FAX2#',
	<cfelse>
	FAX2=null,
	</cfif>
	T_NO='#T_NO#',
	<cfif isdefined("SERMAYE") and len(SERMAYE)>
	SERMAYE='#SERMAYE#',
	<cfelse>
	SERMAYE=null,
	</cfif>
	CHAMBER = <cfif LEN(CHAMBER)>'#CHAMBER#',<cfelse>NULL,</cfif>
	CHAMBER_NO =  <cfif LEN(CHAMBER_NO)>'#CHAMBER_NO#',<cfelse>NULL,</cfif>
	CHAMBER2 = <cfif LEN(CHAMBER2)>'#CHAMBER2#',<cfelse>NULL,</cfif>
	CHAMBER2_NO = <cfif LEN(CHAMBER2_NO)>'#CHAMBER2_NO#'<cfelse>NULL</cfif>
	WHERE
	COMP_ID=#COMP_ID#
	</cfquery>
	
<!--- 1.asset baş--->
	<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		<cfquery name="GET_ASSET" datasource="#DSN#">
			SELECT 
				ASSET_FILE_NAME1,
				ASSET_FILE_NAME1_SERVER_ID
			FROM 
				our_company 
		</cfquery>
		<cfif len(get_asset.ASSET_FILE_NAME1)>
		<cf_del_server_file output_file="settings/#get_asset.asset_file_name1#" output_server="#get_asset.asset_file_name1_server_id#">
		</cfif>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset1" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME1='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME1_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 1.asset son --->

<!--- 2.asset --->
	<cfif isdefined("attributes.asset2") and len(attributes.asset2)>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		<cfquery name="GET_ASSET" datasource="#DSN#">
			SELECT 
				ASSET_FILE_NAME2 ,
				ASSET_FILE_NAME2_SERVER_ID
			FROM 
				our_company 
		</cfquery>
		<cfif len(get_asset.ASSET_FILE_NAME2)>
		<cf_del_server_file output_file="settings/#get_asset.asset_file_name2#" output_server="#get_asset.asset_file_name2_server_id#">
		</cfif>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset2" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME2='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME2_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 2.asset son --->
<!--- 3.asset --->
	<cfif isdefined("attributes.asset3") and len(attributes.asset3)>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		<cfquery name="GET_ASSET" datasource="#DSN#">
			SELECT 
				ASSET_FILE_NAME3 ,
				ASSET_FILE_NAME3_SERVER_ID
			FROM 
				our_company 
		</cfquery>
		<cfif len(get_asset.ASSET_FILE_NAME3)>
		<cf_del_server_file output_file="settings/#get_asset.asset_file_name3#" output_server="#get_asset.asset_file_name3_server_id#">
		</cfif>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		
	<CFTRY>
		<CFFILE action = "upload" 
		  filefield = "asset3" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<CFCATCH type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			update 
				OUR_COMPANY
				set
					ASSET_FILE_NAME3='#file_name#.#cffile.serverfileext#',
					ASSET_FILE_NAME3_SERVER_ID=#fusebox.server_machine#
		</cfquery>
		</cfif>
	</cfif>
<!--- 3.asset son --->
</cfif>
</cfif>
