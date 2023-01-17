
<cfsetting showdebugoutput="no">
		<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
		<cftry>
			<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777"  charset="utf-8">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">
			<cfset file_size = cffile.filesize>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='57455.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<cftry>
			<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
			<cffile action="delete" file="#upload_folder_##file_name#">
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='59615.Dosya Okunamadı'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
		</cftry>
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satir atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			liste = "";
		</cfscript>
		<cfset error_flag = 0>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cftry>
				<cfscript>
					//ünvan
                    if(listlen(dosya[i],';') gte j)
                        unvan = trim(Listgetat(dosya[i],j,";"));
                    else
                        unvan = '';
                    j=j+1;
					//açıklama
					if(listlen(dosya[i],';') gte j)
						aciklama = trim(Listgetat(dosya[i],j,";"));
					else
                        aciklama = '';
					j=j+1;
					//hiyerarşi
					if(listlen(dosya[i],';') gte j)
                        hierarchy = trim(Listgetat(dosya[i],j,";"));
					else
                        hierarchy = '';
					j=j+1;
					//alanlar bitti
				</cfscript>
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
					<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.title_import"</script>
				</cfcatch>
			</cftry>
			<cfif error_flag eq 0>
              
				<cfif not len(unvan)>
					<cfoutput>
						<script>
							alert("#i#.<cf_get_lang dictionary_id='59216.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'>!");
							history.back();
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
					<cftry>
						<cfquery name="control" datasource="#dsn#">
							SELECT
                                TITLE_ID
                            FROM
                                SETUP_TITLE
							WHERE
								TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unvan#">
						</cfquery>
						<cfif control.recordcount>
							<cfquery name="upd_sb" datasource="#dsn#">
								UPDATE
                                    SETUP_TITLE
								SET
                                    TITLE_DETAIL = <cfif len(aciklama)><cfqueryparam cfsqltype="cf_sql_varchar" value="#aciklama#"><cfelse>NULL</cfif>,
                                    HIERARCHY = <cfif len(hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#"><cfelse>NULL</cfif>,
									UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
								WHERE
                                    TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unvan#">
							</cfquery>
						<cfelse>
							<cfquery name="addd_sb" datasource="#dsn#">
								INSERT INTO
                                    SETUP_TITLE
									(
										TITLE
										<cfif len(aciklama)>,TITLE_DETAIL</cfif>
										<cfif len(hierarchy)>,HIERARCHY</cfif>
										,RECORD_EMP
										,RECORD_DATE
										,RECORD_IP
                                        ,IS_ACTIVE
									)
									VALUES
									(
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#unvan#">
										<cfif len(aciklama)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#aciklama#"></cfif>
										<cfif len(hierarchy)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#"></cfif>
										,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
										,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
									)
							</cfquery>
						</cfif>
						<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
						</cfcatch>
					</cftry>
			</cfif>
		</cfloop>
		<cfoutput>#liste#</cfoutput>
		<cfif error_flag neq 1>
			<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>
			<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_titles"</script>
		</cfif>