<cfsilent>
<cfscript>
	ses_pathInfo = reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '');
	ses_i = 1;
	ses_lastKey = "";
	ses_value = "";
	if(len(ses_pathInfo)){
	   for(ses_i=1; ses_i lte listLen(ses_pathInfo, "/"); ses_i=ses_i+1) {
		ses_value = listGetAt(ses_pathInfo, ses_i, "/");
		if(ses_i mod 2 is 0) url[ses_lastKey] = ses_value; 
		else ses_lastKey = ses_value;
	   }
	   if((ses_i-1) mod 2 is 1) url[ses_lastKey] = ""; 
	}
</cfscript>
<cfset appName = "WORKCUBE">
<cftry>	
	<cfcatch>
		<cfcookie name="jsessionid" value="xxxx" expires="now">
		<cflocation url="http://#cgi.http_host#/" addtoken="No">
	</cfcatch>
</cftry>
<cfscript>
// direkt ulaşılabilir sayfalar listesi ve kontrolu
request.self='index.cfm';
directAccessFiles='#request.self#,wrk_grid_edit.cfc,stock_report.cfc,wrk_visit.cfm,get_wrk_component_as_xml.cfm,dao.cfc,fck_image.cfm,fck_link.cfm,upload.cfm,config.cfm,connector.cfm,menu_icerik.cfm,special_functions.cfm,notfound.cfm,notfound_file.cfm,chat.cfc,cfopenchat_ajax.cfc,cfopenchat.cfc,ajax.cfc,class.cfc,admin.cfm,fbx_workcube_maintenance.cfm,index2.cfm,echo.cfc,load_page.cfm,cost_action_2.cfm,get_workdata.cfm,iedit.cfc,web_services,captchaService.cfc,captchaServiceConfigBean.cfc,olapcube_grid.cfc,artservice.cfc,objects_process.cfc,get_prod_order_result_remainder.cfc';

isValidRequest = 0;
for (i = 1; i lte listlen(directAccessFiles); i = i+1)
	if (ListFindNoCase(cgi.script_name, listgetat(directAccessFiles, i, ','), '/'))
		isValidRequest = 1;

if(left(cgi.script_name,8) is '/wrk_cfc')
	isValidRequest = 1;

direct_list = '';
direct_list_action = '';
uf_page_address = cgi.SCRIPT_NAME;
</cfscript>
<cfif listfind(direct_list,uf_page_address)>
	<cfscript>
		uf_position = listFind(direct_list,uf_page_address,";");
		faction_url = listGetAt(direct_list_action,uf_position,";");
	</cfscript>
	<cfabort showerror="İzinsiz Sayfa">
</cfif>
<cfif not isValidRequest><!--- yanlis bir sayfa istegi --->
	<cfset session.error_text = 'You do not have access permission.<br />Request and user information were forwarded to system administrator.!'>
	<cflocation url="http://#cgi.http_host#/" addtoken="No">
</cfif>

</cfsilent>
