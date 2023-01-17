<!--- Kelimenin TR tablosunda ayni modulde kontrolu ve mainde olma durumu kontrolu BK 20111125 --->
<!--- Bu kontrolu lutfen kaldirmayin! Dil setinde çoklayan kayit olmamasi adina onemlidir!! --->
<cfparam name="attributes.is_page" default="1">
<cfset attributes.temp_item_value=evaluate("item_name_1")>
<cfquery name="GET_LANG_CONTROL" datasource="#DSN#">
	SELECT 
		ITEM_ID 
	FROM 
		SETUP_LANGUAGE_TR 
	WHERE 
		<!---MODULE_ID = '#attributes.module_name#' AND--->
		ITEM_ID <> #attributes.item_id# AND 
		ITEM = '#trim(attributes.temp_item_value)#'
</cfquery>

<!---  	
	Sözlükte kelimeden birden fazla var ise bu uyarıyı veriyor, 
	kelimenin ingilizce veya almanca kolonu ? işareti iken değiştirildiğinde de veriyor. 
	Bu nedenle yoruma aldım. Sadece uyarıyı yeni kelime eklerken vermesi daha makul.
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
--->

<!--- main disinda bir modulden guncelleme geliyorsa --->
<!--- Bu kontrolu lutfen kaldirmayin! Dil setinde çoklayan kayit olmamasi adina onemlidir!! --->

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
<cfquery name="GET_MAX_S" datasource="#DSN#">
	SELECT ISNULL(max(DICTIONARY_ID),0)+1 AS D_ID FROM SETUP_LANG_SPECIAL
</cfquery>

<cfloop from="1" to="#attributes.sayi#" index="i">
    <cfset attributes.NEW_COLUMN_NAME="ITEM_#evaluate("kolon_isimleri#i#")#">
	<cfset attributes.item_value=evaluate("item_name_#i#")>
    <cfquery name="upd_lang" datasource="#DSN#"> 
        UPDATE
            SETUP_LANGUAGE_TR
        SET
            ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.temp_item_value)#">,
			#attributes.NEW_COLUMN_NAME# = N'#trim(attributes.item_value)#',
			<cfif isdefined("attributes.is_special")>IS_SPECIAL = 1<CFELSE>IS_SPECIAL = 0</cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        WHERE
			DICTIONARY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#">
            <!---MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#"> AND
            ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#">--->
    </cfquery>  
	<cfif isdefined("attributes.is_special")>
		<cfquery name="get_rec_spe" datasource="#DSN#">
			SELECT 
				ITEM_ID 
			FROM 
				SETUP_LANG_SPECIAL 
			WHERE 
				<!---MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#"> AND --->
				DICTIONARY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> AND
				ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#"> AND 
				LANG_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('kolon_isimleri#i#')#">
		</cfquery>
		<cfquery name="get_d_id" datasource="#DSN#">
			SELECT 
				DICTIONARY_ID 
			FROM 
				SETUP_LANGUAGE_TR
			WHERE 
				<!---MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#"> AND --->
				DICTIONARY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> AND
				ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#"> AND 
				ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.temp_item_value)#">
		</cfquery>
        <cfif get_rec_spe.recordcount>
			<cfquery name="upd_lang" datasource="#DSN#"> 
                UPDATE 
                    SETUP_LANG_SPECIAL 
                SET 
                    ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.item_value)#">
                WHERE 
                    <!---MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#"> AND --->
                    DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> AND 
					ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#"> AND 
                    LANG_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('kolon_isimleri#i#')#">
            </cfquery> 
		<cfelse>
			<cfquery name="add_lang" datasource="#DSN#"> 
				INSERT INTO
					SETUP_LANG_SPECIAL
				(				
					ITEM,
					MODULE_ID,
					ITEM_ID,
					LANG_NAME,
                    DICTIONARY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.item_value)#">,
					NULL,
					<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">,--->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('kolon_isimleri#i#')#">,
                    <cfif get_d_id.recordcount and len(get_d_id.DICTIONARY_ID)>#get_d_id.DICTIONARY_ID#<cfelse>#GET_MAX_S.D_ID#</cfif>
				)
			</cfquery> 
		</cfif>
	<cfelse>
		<cfquery name="del_rec_spe" datasource="#DSN#">
			DELETE FROM SETUP_LANG_SPECIAL WHERE 
			<!---MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#"> AND --->
			DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> AND 
			ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#">
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_dictionary' );
	<cfelse>
		window.close();
		wrk_opener_reload();
	</cfif>
</script> 
