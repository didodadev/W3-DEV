<cfset attributes.temp_item_value=evaluate("item_name_TR")>
<!--- Kelimenin TR tablosunda modulde ? kelime varmi kontrolu BK 20111125 --->
<!--- Bu kontrolu lutfen kaldirmayin! Dil setinde çoklayan kayit olmamasi adina onemlidir!! --->
<!---
<cfquery name="GET_LANG_CONTROL_ITEM" datasource="#DSN#">
	SELECT 
		ITEM_ID 
	FROM 
		SETUP_LANGUAGE_TR
	WHERE 
		MODULE_ID = '#attributes.module_name#' AND
		ITEM = '?'
</cfquery>
--->
<!---<cfquery name="GET_MAX_S" datasource="#DSN#">
    SELECT ISNULL(max(DICTIONARY_ID),0)+1 AS D_ID FROM SETUP_LANG_SPECIAL
</cfquery>--->
<cfquery name="GET_MAX_S" datasource="#DSN#">
    SELECT ISNULL(max(DICTIONARY_ID),0)+1 AS D_ID FROM SETUP_LANGUAGE_TR
</cfquery>
<!---
<cfif get_lang_control_item.recordcount>
	<script type="text/javascript">
		alert("Modülde Bulunan Boş Kelimeleri Kullanınız.");
		history.back();
	</script>
	<cfabort>
</cfif>
--->
<cfif isdefined('attributes.IS_CORPORATE') and len(attributes.IS_CORPORATE)>
	<cfquery name="GET_MAX_CORP" datasource="#DSN#">
		SELECT max(DICTIONARY_ID)+1 AS  DICTIONARY_ID FROM SETUP_LANGUAGE_TR WHERE DICTIONARY_ID < 29000
	</cfquery>
</cfif>
<!--- Kelimenin TR tablosunda ayni modulde kontrolu BK 20111125 --->
<!--- Bu kontrolu lutfen kaldirmayin! Dil setinde çoklayan kayit olmamasi adina onemlidir!! --->
<cfquery name="GET_LANG_CONTROL" datasource="#DSN#">
	SELECT 
		ITEM_ID 
	FROM 
		SETUP_LANGUAGE_TR 
	WHERE 
		<!---MODULE_ID = '#attributes.module_name#' AND--->
		ITEM = '#trim(attributes.temp_item_value)#'
</cfquery>
<cfif get_lang_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='62045.Girdiğiniz Kelime Mevcut. Lütfen Kontrol Ediniz!'>");
		<cfif isdefined("attributes.draggable")>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_dictionary' );
		<cfelse>
			history.back();
		</cfif>
	</script>
	<cfabort>
</cfif>
<!---Sözlükte ? varsa ilk olarak o satırı güncellemesi için bu kontrol koyulmuştur.----->
<cfquery name="GET_LANG_QUESTION_MARK" datasource="#DSN#">
	SELECT
		TOP 1 
		ITEM_ID,
		MODULE_ID,
		DICTIONARY_ID
	FROM 
		SETUP_LANGUAGE_TR
	WHERE 
		ITEM = '?' 
		<cfif isdefined('attributes.kolon_isimleri') and len(attributes.kolon_isimleri)>
			<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
				<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
				AND ITEM_#my_lang# = '?'
			</cfloop>
		</cfif>
	ORDER BY 
		ITEM_ID
</cfquery>

<!--- main disinda bir modulden guncelleme geliyorsa --->

<!--- Ömer beyin talebi ile main dil kontrolü kaldırıldı.
<cfif attributes.module_name neq 'main'>
	<cfquery name="GET_LANG_CONTROL2" datasource="#DSN#">
		SELECT 
			ITEM_ID 
		FROM 
			SETUP_LANGUAGE_TR 
		WHERE 
			MODULE_ID = 'main' AND
			ITEM = '#trim(attributes.temp_item_value)#'
	</cfquery>
	<cfif get_lang_control2.recordcount>
		<script type="text/javascript">
			alert("Girdiğiniz Kelime Main Modülünde Mevcut. Lütfen Kontrol Ediniz.");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery name="GET_LANG_CONTROL3" datasource="#DSN#">
		SELECT 
			MODULE_ID 
		FROM 
			SETUP_LANGUAGE_TR 
		WHERE
			MODULE_ID <> 'main' AND		
			ITEM = '#trim(attributes.temp_item_value)#' AND
			ITEM <> '?'	
	</cfquery>
	<cfif get_lang_control3.recordcount>
		<cfset list_module_name = valuelist(get_lang_control3.module_id)>
		<script type="text/javascript">
			alert("Girdiğiniz Kelime "+"<cfoutput>#list_module_name#</cfoutput>"+ " Modüllerinde Mevcut. Lütfen Kontrol Ediniz.");
		</script>
	</cfif>
</cfif>
--->

<cfquery name="get_max_no" datasource="#DSN#">
	SELECT
		MAX(ITEM_ID) AS MAX_ITEM_ID
	FROM
		SETUP_LANGUAGE_TR
	<!---WHERE--->
		<!---MODULE_ID ='#attributes.module_name#'--->
</cfquery>
<cfif len(geT_max_no.max_item_id)>
	<cfset item_max_no=geT_max_no.max_item_id + 1>
	<cfset max_no=geT_max_no.max_item_id >
<cfelse>
	<cfset item_max_no=1>
	<cfset max_no=0>
</cfif>
<cflock name="#createUUID()#"  timeout="500">
	<cftransaction>
		<cfif len(attributes.kolon_isimleri)>
			<cfif GET_LANG_QUESTION_MARK.recordcount AND NOT  isDefined('attributes.is_special') AND NOT isdefined('attributes.IS_CORPORATE')>
				<cfquery name="UPD_ROW" datasource="#DSN#">
					UPDATE	
						SETUP_LANGUAGE_TR 
					SET
						ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.temp_item_value)#">,
						<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
							<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
							ITEM_#my_lang# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.item_name_#my_lang#')#">,
						</cfloop>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						RECORD_DATE  =		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,			
						RECORD_IP  =<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE 
						DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_LANG_QUESTION_MARK.DICTIONARY_ID#">
					<!---	ITEM_ID  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LANG_QUESTION_MARK.ITEM_ID#"> AND 
						MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_LANG_QUESTION_MARK.MODULE_ID#">--->
				</cfquery>
			<cfelseif isdefined('attributes.IS_CORPORATE') and len(attributes.IS_CORPORATE)>
				<cfquery name="add_ext_row" datasource="#DSN#">
					INSERT INTO	
						SETUP_LANGUAGE_TR 
					(
						DICTIONARY_ID,
						ITEM_ID,
						ITEM,
						<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
							<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
							ITEM_#my_lang#,
						</cfloop>
						MODULE_ID,
						IS_SPECIAL,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					) 
					VALUES 
					(
						#GET_MAX_CORP.DICTIONARY_ID#,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#item_max_no#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.temp_item_value)#">,
						<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
							<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.item_name_#my_lang#')#">,
						</cfloop>
						NULL,
						<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">,--->
						<cfif isDefined("attributes.is_special")>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
				<cfif isDefined("attributes.is_special")>
					<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
						<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
						<cfquery name="add_spec_row" datasource="#DSN#">
							INSERT INTO	
								SETUP_LANG_SPECIAL 
							(
								ITEM_ID,
								MODULE_ID,
								ITEM,
								LANG_NAME,
								DICTIONARY_ID
							) 
							VALUES 
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#item_max_no#">,
								NULL,
								<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">,---> 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.item_name_#my_lang#')#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_lang#">,
								#GET_MAX_S.D_ID#
							)
						</cfquery>
					</cfloop>
				</cfif>
			<cfelse>
				<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
					<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
					<!--- eksik sayilar varsa bulundu ve kontrol edildi. --->
					<cfif my_lang neq "TR">
						<cfquery name="get_kontrol" datasource="#DSN#">
							SELECT
								MAX(ITEM_ID) AS MAX_ITEM_ID
							FROM
								SETUP_LANGUAGE_TR
							<!---WHERE--->
								<!---MODULE_ID ='#attributes.module_name#'--->
						</cfquery>
						<cfif (len(get_kontrol.max_item_id) and get_kontrol.max_item_id lt max_no)>
							<cfset basla=get_kontrol.max_item_id+1>
						<cfelseif not len(get_kontrol.max_item_id)>
							<cfset basla=1>
						<cfelse>
							<cfset basla=max_no>
						</cfif>
						<cfif basla lt max_no>
							<cfloop from="#basla#" to="#max_no#" index="k">
								<cfquery name="add_ext_row" datasource="#DSN#">
									INSERT INTO	
										SETUP_LANGUAGE_TR
									(
										ITEM_ID,
										MODULE_ID
									)
									VALUES 
									(
										<cfqueryparam cfsqltype="cf_sql_integer" value="#k#">,
										NULL
										<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">--->
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
					<!--- eksik sayilar varsa bulundu ve kontrol edildi. --->
					<cfif isDefined("attributes.is_special")>
						<cfquery name="add_spec_row" datasource="#DSN#">
							INSERT INTO	
								SETUP_LANG_SPECIAL 
							(
								ITEM_ID,
								MODULE_ID,
								ITEM,
								LANG_NAME,
								DICTIONARY_ID
							) 
							VALUES 
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#item_max_no#">,
								NULL,
								<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">, --->
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.item_name_#my_lang#')#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_lang#">,
								#GET_MAX_S.D_ID#
							)
						</cfquery>
					</cfif>
				</cfloop>
				<cfquery name="GET_MAX_D" datasource="#DSN#">
					SELECT MAX(DICTIONARY_ID)+1 AS DICTIONARY_ID FROM SETUP_LANGUAGE_TR
				</cfquery>
				<cfquery name="add_ext_row" datasource="#DSN#">
					INSERT INTO	
						SETUP_LANGUAGE_TR 
					(
						DICTIONARY_ID,
						ITEM_ID,
						ITEM,
						<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
							<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
							ITEM_#my_lang#,
						</cfloop>
						MODULE_ID,
						IS_SPECIAL,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					) 
					VALUES 
					(
						<cfif isDefined("attributes.is_special")>
							#GET_MAX_S.D_ID#,
						<cfelse>
							#GET_MAX_D.DICTIONARY_ID#,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#item_max_no#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.temp_item_value)#">,
						<cfloop from="1" to="#ListLen(attributes.kolon_isimleri)#" index="i">
							<cfset my_lang=ListGetAt(attributes.kolon_isimleri,i)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.item_name_#my_lang#')#">,
						</cfloop>
						NULL,
						<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">,--->
						<cfif isDefined("attributes.is_special")>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>		
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_dictionary' );
	<cfelse>
		window.close();
		wrk_opener_reload();
	</cfif>
</script>
