<!---
 Burada seçilen gruplar  süreçler ile ilişkileniyor. MAINWORKGROUP_ID ilişkiyi tutuyor.
PROCESS_TYPE_ROWS_WORKGRUOP tablosu hem grup isimlerini tutar hemde grupların ilişkilendirildiği süreçlerleri tutar.
--->
<cfloop list="#attributes.workgroup_id#" index="i">
	<cfquery name="ADD_ROWS" datasource="#DSN#">
		INSERT INTO
			PROCESS_TYPE_ROWS_WORKGRUOP
		(
			PROCESS_ROW_ID,
			MAINWORKGROUP_ID
		)
		VALUES
		(
			#attributes.process_row_id#,
			#i#
		)
	</cfquery>
</cfloop>
<!---Burada süreç satılarına kayıt atıyordu kaldırıldı.3 Aya Silinsin. M.ER 2007-06-21
<cfquery name="GET_MAX" datasource="#dsn#">
	SELECT MAX(WORKGROUP_ID) AS MAX_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP
</cfquery>
<cfquery name="GET_CAU" datasource="#dsn#" >
	SELECT * FROM PROCESS_TYPE_ROWS_CAUID WHERE WORKGROUP_ID = #i#
</cfquery>
<cfquery name="GET_INF" datasource="#dsn#" >
	SELECT * FROM PROCESS_TYPE_ROWS_INFID WHERE WORKGROUP_ID = #i#
</cfquery>
<cfquery name="GET_POS" datasource="#dsn#" >
	SELECT * FROM PROCESS_TYPE_ROWS_POSID WHERE WORKGROUP_ID = #i#
</cfquery>
<cfoutput query="get_cau">
	<cfquery name="ADD_ROW1" datasource="#dsn#">
		INSERT
		INTO
			PROCESS_TYPE_ROWS_CAUID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				<cfif len(CAU_POSITION_ID)>CAU_POSITION_ID<cfelseif len(CAU_PARTNER_ID)>CAU_PARTNER_ID</cfif>
			)
			VALUES
			(
				#attributes.process_row_id#,
				#GET_MAX.MAX_ID#,
				<cfif len(CAU_POSITION_ID)>#GET_CAU.CAU_POSITION_ID#<cfelseif len(CAU_PARTNER_ID)>#GET_CAU.CAU_PARTNER_ID#</cfif>
			)
	</cfquery>
</cfoutput>
<cfoutput query="get_inf">
	<cfquery name="ADD_ROW2" datasource="#dsn#">
		INSERT
		INTO
			PROCESS_TYPE_ROWS_INFID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				<cfif len(INF_POSITION_ID)>INF_POSITION_ID<cfelseif len(INF_PARTNER_ID)>INF_PARTNER_ID</cfif>
			)
			VALUES
			(
				#attributes.process_row_id#,
				#GET_MAX.MAX_ID#,
				<cfif len(INF_POSITION_ID)>#GET_INF.INF_POSITION_ID#<cfelseif len(INF_PARTNER_ID)>#GET_INF.INF_PARTNER_ID#</cfif>
			)
	</cfquery>
</cfoutput>
<cfoutput query="get_pos">
	<cfquery name="ADD_ROW3" datasource="#dsn#">
		INSERT
		INTO
			PROCESS_TYPE_ROWS_POSID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				<cfif len(PRO_POSITION_ID)>PRO_POSITION_ID<cfelseif len(PRO_PARTNER_ID)>PRO_PARTNER_ID</cfif>
			)
			VALUES
			(
				#attributes.process_row_id#,
				#GET_MAX.MAX_ID#,
				<cfif len(PRO_POSITION_ID)>#GET_POS.PRO_POSITION_ID#<cfelseif len(PRO_PARTNER_ID)>#GET_POS.PRO_PARTNER_ID#</cfif>
			)
	</cfquery>
</cfoutput> --->
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
