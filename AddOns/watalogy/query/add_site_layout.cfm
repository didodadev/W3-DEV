<cfif attributes.is_add eq 0>
	<cfquery name="get_layout" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	
	<cfif len(attributes.l_content)>
		<cfset data=deserializeJSON(attributes.l_content)>
		<cfloop from="1" to="#structCount(data)#" index="sira">
			<cfset aktif_satir = data[sira-1]>
		
			<cfquery name="ADD_ROW" datasource="#dsn#" result="GET_MAX_ORDER">
				INSERT INTO
				MAIN_SITE_LAYOUTS_ROWS
				(
					FACTION,
					MENU_ID,
					LAYOUT_ID,
					ROW_NUMBER
				)
				VALUES
				(
					'#attributes.faction#',
					#attributes.menu_id#,
					#get_layout.layout_id#,
					#sira#
				)
			</cfquery>
			
			<cfif structkeyexists(aktif_satir,"0")>
				<cfloop from="1" to="#structCount(aktif_satir)#" index="col_sira">
					<cfset aktif_kolon = aktif_satir[col_sira-1]>
					<cfset c_size = listgetat(aktif_kolon.size,2,'-')>
					<cfquery name="ADD_" datasource="#dsn#">
						INSERT INTO 
							MAIN_SITE_LAYOUTS_COLS
						(
							FACTION,
							MENU_ID,
							LAYOUT_ID,
							ROW_ID,
							COL_NUMBER,
							COL_SIZE
						) 
						VALUES 
						(
							'#attributes.faction#',
							#attributes.menu_id#,
							#get_layout.layout_id#,
							#get_max_order.identitycol#,
							#col_sira#,
							#c_size#
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
<cfelseif attributes.is_add eq 1>
	<cfquery name="get_" datasource="#dsn#">
		SELECT FACTION FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	 <cfif get_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2519.Bu sayfa için tasarım ayarları tanımlanmış! Tekrar Tanımlama Yapamazsınız'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS 
		(
			FACTION,
			MENU_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			HEADER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			'#attributes.header#'
		)
	</cfquery>
<cfelseif attributes.is_add eq 2>
	<cfquery name="get_old_rows" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_ROWS ORDER BY ROW_NUMBER DESC
	</cfquery>
	<cfif get_old_rows.recordcount>
		<cfset row_ = get_old_rows.row_number + 1>
	<cfelse>
		<cfset row_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_ROWS 
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_NUMBER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#row_#
		)
	</cfquery>
<cfelseif attributes.is_add eq 3>
	<cfquery name="get_cols" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = #attributes.row_id#
	</cfquery>
	<cfif get_cols.recordcount>
		<script>
			alert('Kolonları Olan Satırı Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE ROW_ID = #attributes.row_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 4>
	<cfquery name="get_old_cols" datasource="#dsn#">
		SELECT 
			(SELECT SUM(COL_SIZE) FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = MSLC.ROW_ID) AS TOTAL_SIZE,
			MSLC.* 
		FROM 
			MAIN_SITE_LAYOUTS_COLS MSLC
		WHERE 
			MSLC.LAYOUT_ID = #attributes.layout_id# AND 
			MSLC.ROW_ID = #attributes.row_id# 
		ORDER BY 
			MSLC.COL_NUMBER DESC
	</cfquery>
	<cfif get_old_cols.recordcount>
		<cfset col_ = get_old_cols.COL_NUMBER + 1>
		
		<cfif get_old_cols.TOTAL_SIZE + attributes.col_size gt 12>
			<script>
				alert('Kolon Genişliği Template Genişliğini Aşamaz!\nEkleyebileceğiniz Maksimum Kolon Genişliği : <cfoutput>#12-get_old_cols.TOTAL_SIZE#</cfoutput>');
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfset col_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_COLS
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_ID,
			COL_NUMBER,
			COL_SIZE
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#attributes.row_id#,
			#col_#,
			#attributes.col_size#
		)
	</cfquery>
<cfelseif attributes.is_add eq 5>
	<cfquery name="get_objects" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_SELECTS WHERE COL_ID = #attributes.col_id#
	</cfquery>
	<cfif get_objects.recordcount>
		<script>
			alert('Objeleri Olan Kolonu Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE COL_ID = #attributes.col_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 6>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE ROW_ID = #attributes.object_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #attributes.object_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_" datasource="#dsn#">
		UPDATE 
			MAIN_SITE_LAYOUTS
		SET
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			FACTION = '#attributes.faction#' AND 
            MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=protein.popup_select_site_objects&faction=#attributes.faction#&menu_id=#attributes.MENU_ID#" addtoken="no"><cfif attributes.is_add eq 0>
	<cfquery name="get_layout" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	
	<cfif len(attributes.l_content)>
		<cfset data=deserializeJSON(attributes.l_content)>
		<cfloop from="1" to="#structCount(data)#" index="sira">
			<cfset aktif_satir = data[sira-1]>
		
			<cfquery name="ADD_ROW" datasource="#dsn#" result="GET_MAX_ORDER">
				INSERT INTO
				MAIN_SITE_LAYOUTS_ROWS
				(
					FACTION,
					MENU_ID,
					LAYOUT_ID,
					ROW_NUMBER
				)
				VALUES
				(
					'#attributes.faction#',
					#attributes.menu_id#,
					#get_layout.layout_id#,
					#sira#
				)
			</cfquery>
			
			<cfif structkeyexists(aktif_satir,"0")>
				<cfloop from="1" to="#structCount(aktif_satir)#" index="col_sira">
					<cfset aktif_kolon = aktif_satir[col_sira-1]>
					<cfset c_size = listgetat(aktif_kolon.size,2,'-')>
					<cfquery name="ADD_" datasource="#dsn#">
						INSERT INTO 
							MAIN_SITE_LAYOUTS_COLS
						(
							FACTION,
							MENU_ID,
							LAYOUT_ID,
							ROW_ID,
							COL_NUMBER,
							COL_SIZE
						) 
						VALUES 
						(
							'#attributes.faction#',
							#attributes.menu_id#,
							#get_layout.layout_id#,
							#get_max_order.identitycol#,
							#col_sira#,
							#c_size#
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
<cfelseif attributes.is_add eq 1>
	<cfquery name="get_" datasource="#dsn#">
		SELECT FACTION FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	 <cfif get_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2519.Bu sayfa için tasarım ayarları tanımlanmış! Tekrar Tanımlama Yapamazsınız'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS 
		(
			FACTION,
			MENU_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			HEADER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			'#attributes.header#'
		)
	</cfquery>
<cfelseif attributes.is_add eq 2>
	<cfquery name="get_old_rows" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_ROWS ORDER BY ROW_NUMBER DESC
	</cfquery>
	<cfif get_old_rows.recordcount>
		<cfset row_ = get_old_rows.row_number + 1>
	<cfelse>
		<cfset row_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_ROWS 
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_NUMBER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#row_#
		)
	</cfquery>
<cfelseif attributes.is_add eq 3>
	<cfquery name="get_cols" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = #attributes.row_id#
	</cfquery>
	<cfif get_cols.recordcount>
		<script>
			alert('Kolonları Olan Satırı Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE ROW_ID = #attributes.row_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 4>
	<cfquery name="get_old_cols" datasource="#dsn#">
		SELECT 
			(SELECT SUM(COL_SIZE) FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = MSLC.ROW_ID) AS TOTAL_SIZE,
			MSLC.* 
		FROM 
			MAIN_SITE_LAYOUTS_COLS MSLC
		WHERE 
			MSLC.LAYOUT_ID = #attributes.layout_id# AND 
			MSLC.ROW_ID = #attributes.row_id# 
		ORDER BY 
			MSLC.COL_NUMBER DESC
	</cfquery>
	<cfif get_old_cols.recordcount>
		<cfset col_ = get_old_cols.COL_NUMBER + 1>
		
		<cfif get_old_cols.TOTAL_SIZE + attributes.col_size gt 12>
			<script>
				alert('Kolon Genişliği Template Genişliğini Aşamaz!\nEkleyebileceğiniz Maksimum Kolon Genişliği : <cfoutput>#12-get_old_cols.TOTAL_SIZE#</cfoutput>');
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfset col_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_COLS
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_ID,
			COL_NUMBER,
			COL_SIZE
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#attributes.row_id#,
			#col_#,
			#attributes.col_size#
		)
	</cfquery>
<cfelseif attributes.is_add eq 5>
	<cfquery name="get_objects" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_SELECTS WHERE COL_ID = #attributes.col_id#
	</cfquery>
	<cfif get_objects.recordcount>
		<script>
			alert('Objeleri Olan Kolonu Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE COL_ID = #attributes.col_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 6>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE ROW_ID = #attributes.object_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #attributes.object_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_" datasource="#dsn#">
		UPDATE 
			MAIN_SITE_LAYOUTS
		SET
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			FACTION = '#attributes.faction#' AND 
            MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=protein.popup_select_site_objects&faction=#attributes.faction#&menu_id=#attributes.MENU_ID#" addtoken="no"><cfif attributes.is_add eq 0>
	<cfquery name="get_layout" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE LAYOUT_ID = #get_layout.layout_id#
	</cfquery>
	
	<cfif len(attributes.l_content)>
		<cfset data=deserializeJSON(attributes.l_content)>
		<cfloop from="1" to="#structCount(data)#" index="sira">
			<cfset aktif_satir = data[sira-1]>
		
			<cfquery name="ADD_ROW" datasource="#dsn#" result="GET_MAX_ORDER">
				INSERT INTO
				MAIN_SITE_LAYOUTS_ROWS
				(
					FACTION,
					MENU_ID,
					LAYOUT_ID,
					ROW_NUMBER
				)
				VALUES
				(
					'#attributes.faction#',
					#attributes.menu_id#,
					#get_layout.layout_id#,
					#sira#
				)
			</cfquery>
			
			<cfif structkeyexists(aktif_satir,"0")>
				<cfloop from="1" to="#structCount(aktif_satir)#" index="col_sira">
					<cfset aktif_kolon = aktif_satir[col_sira-1]>
					<cfset c_size = listgetat(aktif_kolon.size,2,'-')>
					<cfquery name="ADD_" datasource="#dsn#">
						INSERT INTO 
							MAIN_SITE_LAYOUTS_COLS
						(
							FACTION,
							MENU_ID,
							LAYOUT_ID,
							ROW_ID,
							COL_NUMBER,
							COL_SIZE
						) 
						VALUES 
						(
							'#attributes.faction#',
							#attributes.menu_id#,
							#get_layout.layout_id#,
							#get_max_order.identitycol#,
							#col_sira#,
							#c_size#
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
<cfelseif attributes.is_add eq 1>
	<cfquery name="get_" datasource="#dsn#">
		SELECT FACTION FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.MENU_ID#
	</cfquery>
	 <cfif get_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2519.Bu sayfa için tasarım ayarları tanımlanmış! Tekrar Tanımlama Yapamazsınız'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS 
		(
			FACTION,
			MENU_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			HEADER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			'#attributes.header#'
		)
	</cfquery>
<cfelseif attributes.is_add eq 2>
	<cfquery name="get_old_rows" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_ROWS ORDER BY ROW_NUMBER DESC
	</cfquery>
	<cfif get_old_rows.recordcount>
		<cfset row_ = get_old_rows.row_number + 1>
	<cfelse>
		<cfset row_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_ROWS 
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_NUMBER
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#row_#
		)
	</cfquery>
<cfelseif attributes.is_add eq 3>
	<cfquery name="get_cols" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = #attributes.row_id#
	</cfquery>
	<cfif get_cols.recordcount>
		<script>
			alert('Kolonları Olan Satırı Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_ROWS WHERE ROW_ID = #attributes.row_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 4>
	<cfquery name="get_old_cols" datasource="#dsn#">
		SELECT 
			(SELECT SUM(COL_SIZE) FROM MAIN_SITE_LAYOUTS_COLS WHERE ROW_ID = MSLC.ROW_ID) AS TOTAL_SIZE,
			MSLC.* 
		FROM 
			MAIN_SITE_LAYOUTS_COLS MSLC
		WHERE 
			MSLC.LAYOUT_ID = #attributes.layout_id# AND 
			MSLC.ROW_ID = #attributes.row_id# 
		ORDER BY 
			MSLC.COL_NUMBER DESC
	</cfquery>
	<cfif get_old_cols.recordcount>
		<cfset col_ = get_old_cols.COL_NUMBER + 1>
		
		<cfif get_old_cols.TOTAL_SIZE + attributes.col_size gt 12>
			<script>
				alert('Kolon Genişliği Template Genişliğini Aşamaz!\nEkleyebileceğiniz Maksimum Kolon Genişliği : <cfoutput>#12-get_old_cols.TOTAL_SIZE#</cfoutput>');
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfset col_ = 1>
	</cfif>
	<cfquery name="ADD_" datasource="#dsn#">
		INSERT INTO 
        	MAIN_SITE_LAYOUTS_COLS
		(
			FACTION,
			MENU_ID,
			LAYOUT_ID,
			ROW_ID,
			COL_NUMBER,
			COL_SIZE
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			#attributes.layout_id#,
			#attributes.row_id#,
			#col_#,
			#attributes.col_size#
		)
	</cfquery>
<cfelseif attributes.is_add eq 5>
	<cfquery name="get_objects" datasource="#dsn#">
		SELECT * FROM MAIN_SITE_LAYOUTS_SELECTS WHERE COL_ID = #attributes.col_id#
	</cfquery>
	<cfif get_objects.recordcount>
		<script>
			alert('Objeleri Olan Kolonu Silemezsiniz!');
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="del_cols" datasource="#dsn#">
			DELETE FROM MAIN_SITE_LAYOUTS_COLS WHERE COL_ID = #attributes.col_id#
		</cfquery>
	</cfif>
<cfelseif attributes.is_add eq 6>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE ROW_ID = #attributes.object_id#
	</cfquery>
	<cfquery name="del_cols" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #attributes.object_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_" datasource="#dsn#">
		UPDATE 
			MAIN_SITE_LAYOUTS
		SET
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			FACTION = '#attributes.faction#' AND 
            MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=protein.popup_select_site_objects&faction=#attributes.faction#&menu_id=#attributes.MENU_ID#" addtoken="no">