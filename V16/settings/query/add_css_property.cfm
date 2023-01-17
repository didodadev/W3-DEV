<cfquery name="get_menu_css_path" datasource="#dsn#">
	SELECT CSS_FILE FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
</cfquery>
<cffile action="write" output="#attributes.dosya#" addnewline="no" file="#index_folder##replace(get_menu_css_path.css_file,'/','\','all')#" charset="ISO-8859-9">

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
