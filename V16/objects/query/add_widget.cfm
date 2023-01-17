
<cfset Randomize(round(rand()*1000000))/>

<cfparam name="attributes.id" default="#round(rand()*10000000)#">
<cfsetting showdebugoutput="no"><cfparam name="attributes.widget_show_image" default="0"><cfparam name="attributes.widget_record_count" default="50"><body bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0" style="overflow: hidden">
<font style="font-size:9pt">Kaydedildi</font>
</body>

<cfquery name="updIndex" datasource="#DSN#">
	UPDATE 
		MY_SETTINGS_POSITIONS
	SET
		SEQUENCE_INDEX = (SEQUENCE_INDEX + 1)
	WHERE
		COLUMN_INDEX = #attributes.column# AND
		SEQUENCE_INDEX >= #attributes.sequence# AND
		EMP_ID = #session.ep.userid#
</cfquery>
	
<cfquery name="ADD_WIDGET" datasource="#DSN#">
	INSERT INTO 
		MY_SETTINGS_POSITIONS
	(
		PANEL_NAME,
		COLUMN_INDEX,
		SEQUENCE_INDEX,
		EMP_ID,
		IS_WIDGET,
		URL,
		WIDGET_SCRIPT,
		WIDGET_HEAD,
		WIDGET_SHOW_IMAGE,
		WIDGET_RECORD_COUNT
	)VALUES
	(
		'homebox_#attributes.id#',
		#attributes.column#,
		#attributes.sequence#,
		#session.ep.userid#,
		1,
		'#attributes.widget_url#',
		'#attributes.widget_script#',
		'#attributes.widget_head#',
		#attributes.widget_show_image#,
		#attributes.widget_record_count#
	)
</cfquery>



