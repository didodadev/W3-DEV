<cfparam name="attributes.upd_widget_record_count" default="50">
<cfparam name="attributes.menu_position_id" default="0"><cfparam name="attributes.upd_widget_show_image" default="0"><body bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0" style="overflow: hidden">
<font style="font-size:9pt">Güncellendi</font>
</body>
<cfquery name="updIndex" datasource="#DSN#">
	UPDATE 
		MY_SETTINGS_POSITIONS
	SET
		WIDGET_HEAD  = '#attributes.upd_widget_head#',
		WIDGET_SHOW_IMAGE  = #attributes.upd_widget_show_image#,
		WIDGET_RECORD_COUNT  = #attributes.upd_widget_record_count#
	WHERE
		MENU_POSITION_ID = #attributes.menu_position_id#
</cfquery>
