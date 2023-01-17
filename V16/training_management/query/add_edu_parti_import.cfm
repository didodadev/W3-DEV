<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset identity_no = trim(listgetat(dosya[i],1,';'))>
		<cfif (listlen(dosya[i],';') gte 2)>
			<cfset class_id = trim(listgetat(dosya[i],2,';'))>
		<cfelse>
			<cfset class_id = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>
	</cftry>
	<cfif len(class_id)>
		<cfquery name="get_class" datasource="#dsn#">
			SELECT CLASS_ID FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
		</cfquery>
	<cfelse>
		<cfset get_class.class_id = ''>
	</cfif>
	<cfif len(identity_no)>
		<cfquery name="geT_id" datasource="#dsn#">
			SELECT DISTINCT
				TYPE,
				ID,
				IDENTITY_NO
			FROM
				(SELECT 
					1 TYPE,
					EI.EMPLOYEE_ID ID,
					EI.TC_IDENTY_NO IDENTITY_NO
				FROM 
					EMPLOYEES_IDENTY EI
				UNION ALL
				SELECT 
					2 TYPE,
					C.CONSUMER_ID ID,
					C.TC_IDENTY_NO IDENTITY_NO
				FROM
					CONSUMER C
				UNION ALL
				SELECT 
					3 TYPE,
					CP.PARTNER_ID ID, 
					CP.TC_IDENTITY IDENTITY_NO
				FROM
					COMPANY_PARTNER CP
				)T1
				WHERE
					IDENTITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#identity_no#">
		</cfquery>
	<cfelse>
		<cfset get_id.type = ''>
		<cfset get_id.id = ''>
	</cfif>
	<cfif len(get_class.class_id) and len(get_id.id)>
		<cfquery name="get_trainer" datasource="#dsn#">
			SELECT 
            	CLASS_ID, 
                EMP_ID, 
                PAR_ID, 
                CON_ID, 
                IS_SELFSERVICE 
            FROM 
            	TRAINING_CLASS_ATTENDER 
            WHERE 
            	CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#"> AND (EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#"> OR CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#"> OR PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#">)
		</cfquery>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="add_trainers" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
					(
						CLASS_ID,
						<cfif get_id.type eq 1>EMP_ID<cfelseif get_id.type eq 2>CON_ID<cfelseif get_id.type eq 3>PAR_ID</cfif>,
						IS_SELFSERVICE
					)
					VALUES
					( 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#">,
						<cfif not get_trainer.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#"></cfif>,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="0">
					)
				</cfquery>
				<cfcatch type="any">
					<cfoutput>
						#i#. Satırda ;  <br/>
						<cfif not len(get_class.class_id)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Import Yapılamadı. Eğitim ID sini Kontrol Ediniz.<br/>
						</cfif> 
						<cfif not len(get_id.id) or get_trainer.recordcount>
							&nbsp;&nbsp;&nbsp;&nbsp;*Import Yapılamadı. Katılımcı Mevcut veya TC Kimlik Numarası Eksik.<br/>
						</cfif>
						<br/>
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
