
<cfparam name="attributes.id" default="#round(rand()*10000000)#">
<cfif isdefined("session.ep.userid") and FileExists("#upload_folder##dir_seperator#widget#dir_seperator#widget.xml")>
	<cfscript>
		myXmlDoc= XmlParse("#upload_folder##dir_seperator#widget#dir_seperator#widget.xml");
		selectedElements = XmlSearch(myXmlDoc, "/widget_table/Widget/");
		for (i = 1; i LTE ArrayLen(selectedElements); i = i + 1)
		{		
			if(selectedElements[i].XmlChildren[1].XmlText == attributes.wid)
			{	
			
				widget_head = selectedElements[i].XmlChildren[2].XmlText;	
				widget_url = selectedElements[i].XmlChildren[3].XmlText;
				widget_script = selectedElements[i].XmlChildren[4].XmlText;	
				widget_show_image = selectedElements[i].XmlChildren[5].XmlText;
				widget_record_count = selectedElements[i].XmlChildren[6].XmlText;	
			}
		}
	</cfscript>
</cfif><cfset Randomize(round(rand()*1000000))/><body bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0" style="overflow: hidden">
<font style="font-size:9pt">Kaydedildi</font>
</body>
<cfsetting showdebugoutput="no"><cfquery name="get_widget_pos" datasource="#DSN#">
	SELECT 
		COLUMN_INDEX,SEQUENCE_INDEX
	FROM
		MY_SETTINGS_POSITIONS
	WHERE
		PANEL_NAME = 'homebox_widget' AND
		EMP_ID = #session.ep.userid#
</cfquery>

<cfquery name="updIndex" datasource="#DSN#">
	UPDATE MY_SETTINGS_POSITIONS
	SET
		SEQUENCE_INDEX = (SEQUENCE_INDEX + 1)
	WHERE
		COLUMN_INDEX = #get_widget_pos.column_index# AND
		SEQUENCE_INDEX >= #get_widget_pos.sequence_index# AND
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
	)
	VALUES
	(
		'homebox_#attributes.id#',
		#get_widget_pos.column_index#,
		#get_widget_pos.sequence_index#,
		#session.ep.userid#,
		1,
		'#widget_url#',
		'#widget_script#',
		'#widget_head#',
		'#widget_show_image#',
		'#widget_record_count#'
	)
</cfquery>


