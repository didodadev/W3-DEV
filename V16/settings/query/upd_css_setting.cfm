<cfscript>
	if(isdefined("to_emp_ids")) CC_EMPS = ListSort(to_emp_ids,"Numeric", "Desc"); else CC_EMPS ='';	
</cfscript>

<cfquery name="UPD_CSS_SETTING" datasource="#dsn#">
	UPDATE 
	  CSS_SETTINGS 
	SET	
	 <!---  CSS_NAME = #ATTRIBUTES.CSS_NAME#, --->
	  UPDATE_DATE = #NOW()#,
	  UPDATE_EMP = #SESSION.EP.USERID#,
	  UPDATE_IP = '#cgi.remote_addr#',
	  IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
	  LINK_SIZE = #ATTRIBUTES.LINK_SIZE#,
	  LINK_FONT = '#ATTRIBUTES.LINK_FONT#',
	  LINK_COLOR = '#ATTRIBUTES.LINK_COLOR#',
	  TO_EMPS = ',#CC_EMPS#,',
	  TABLE_SIZE = #ATTRIBUTES.TABLE_SIZE#,
	  TABLE_FONT = '#ATTRIBUTES.TABLE_FONT#',
	  TABLE_COLOR = '#ATTRIBUTES.TABLE_COLOR#',
	  HEAD_SIZE = #ATTRIBUTES.HEAD_SIZE#,
	  HEAD_FONT = '#ATTRIBUTES.HEAD_FONT#',
	  HEAD_COLOR = '#ATTRIBUTES.HEAD_COLOR#',
	  TABLE_LINE_COLOR = '#ATTRIBUTES.TABLE_LINE_COLOR#',
	  TABLE_HEAD_COLOR = '#ATTRIBUTES.TABLE_HEAD_COLOR#',
	  TABLE_LIST_COLOR = '#ATTRIBUTES.TABLE_LIST_COLOR#',
	  TABLE_ROW_COLOR = '#ATTRIBUTES.TABLE_ROW_COLOR#'
	WHERE 
	  CSS_ID = #ATTRIBUTES.CSS_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.list_css_settings" addtoken="no">
