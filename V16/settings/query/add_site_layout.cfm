<cfif attributes.is_add eq 1>
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
			LEFT_WIDTH,
			RIGHT_WIDTH,
			CENTER_WIDTH,
			MARGIN,
			LEFT_DESIGN_ID,
			RIGHT_DESIGN_ID, 
			CENTER_DESIGN_ID, 
			LEFT_OBJECT_NAME, 
			RIGHT_OBJECT_NAME, 
			CENTER_OBJECT_NAME, 
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
		VALUES 
		(
			'#attributes.faction#',
			#attributes.menu_id#,
			<cfif len(attributes.LEFT_WIDTH)>#attributes.LEFT_WIDTH#<cfelse>0</cfif>,
			<cfif len(attributes.RIGHT_WIDTH)>#attributes.RIGHT_WIDTH#<cfelse>0</cfif>,
			<cfif len(attributes.CENTER_WIDTH)>#attributes.CENTER_WIDTH#<cfelse>0</cfif>,
			<cfif len(attributes.MARGIN)>#attributes.MARGIN#<cfelse>0</cfif>,
			<cfif len(attributes.LEFT_DESIGN_ID)>#attributes.LEFT_DESIGN_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.RIGHT_DESIGN_ID)>#attributes.RIGHT_DESIGN_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.CENTER_DESIGN_ID)>#attributes.CENTER_DESIGN_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.LEFT_OBJECT_NAME)>'#attributes.LEFT_OBJECT_NAME#'<cfelse>NULL</cfif>,
			<cfif len(attributes.RIGHT_OBJECT_NAME)>'#attributes.RIGHT_OBJECT_NAME#'<cfelse>NULL</cfif>,
			<cfif len(attributes.CENTER_OBJECT_NAME)>'#attributes.CENTER_OBJECT_NAME#'<cfelse>NULL</cfif>,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
<cfelse>
	<cfquery name="UPD_" datasource="#dsn#">
		UPDATE 
			MAIN_SITE_LAYOUTS
		SET
			LEFT_WIDTH = <cfif len(attributes.LEFT_WIDTH)>#attributes.LEFT_WIDTH#<cfelse>0</cfif>,
			RIGHT_WIDTH = <cfif len(attributes.RIGHT_WIDTH)>#attributes.RIGHT_WIDTH#<cfelse>0</cfif>,
			CENTER_WIDTH = <cfif len(attributes.CENTER_WIDTH)>#attributes.CENTER_WIDTH#<cfelse>0</cfif>,
			MARGIN = <cfif len(attributes.MARGIN)>#attributes.MARGIN#<cfelse>0</cfif>,
			LEFT_DESIGN_ID = <cfif len(attributes.LEFT_DESIGN_ID)>#attributes.LEFT_DESIGN_ID#<cfelse>NULL</cfif>,
			RIGHT_DESIGN_ID = <cfif len(attributes.RIGHT_DESIGN_ID)>#attributes.RIGHT_DESIGN_ID#<cfelse>NULL</cfif>,
			CENTER_DESIGN_ID = <cfif len(attributes.CENTER_DESIGN_ID)>#attributes.CENTER_DESIGN_ID#<cfelse>NULL</cfif>,
			LEFT_OBJECT_NAME = <cfif len(attributes.LEFT_OBJECT_NAME)>'#attributes.LEFT_OBJECT_NAME#'<cfelse>NULL</cfif>,
			RIGHT_OBJECT_NAME = <cfif len(attributes.RIGHT_OBJECT_NAME)>'#attributes.RIGHT_OBJECT_NAME#'<cfelse>NULL</cfif>,
			CENTER_OBJECT_NAME = <cfif len(attributes.CENTER_OBJECT_NAME)>'#attributes.CENTER_OBJECT_NAME#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			FACTION = '#attributes.faction#' AND 
            MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.popup_select_site_objects&faction=#attributes.faction#&menu_id=#attributes.MENU_ID#" addtoken="no">
