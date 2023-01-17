<cfsetting showdebugoutput="no">
<cf_box title='Klasör Oluştur' id='add_file_box' collapsable="0" style="width:100%;">
<cfquery name="get_folders" datasource="#dsn#">
	SELECT 
		'd' AS TYPE,
		'folder_d_' + CAST(FOLDER_ID AS nvarchar) AS IMAJ_ID,
		FOLDER_ID,
		FOLDER_NAME,
		UPPER_FOLDER_ID
	FROM
		CUBE_MAIL_FOLDER 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>

<cfscript>
	rc = get_folders.recordcount;
	
	rc = rc + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_4',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-4',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Gelen Kutusu',rc);
	
	rc = rc + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_3',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-3',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Giden Kutusu',rc);
	
	rc = get_folders.recordcount + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_2',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-2',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Silinmiş Öğeler',rc);
	
	rc = get_folders.recordcount + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_1',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-1',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Taslaklar',rc);
</cfscript>

<cfquery name="get_upper_folders" dbtype="query">
	SELECT 
		* 
	FROM 
		get_folders 
	WHERE 
		UPPER_FOLDER_ID IS NULL 
		<cfif len(attributes.type) and len(attributes.id)>
			AND FOLDER_ID = #attributes.id#
		</cfif> 
	ORDER BY 
		FOLDER_ID ASC
</cfquery>

	<table cellspacing="0" cellpadding="1">
		<cfform name="send_" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_add_folder">
		<tr><td>
			<cfif len(attributes.type) and len(attributes.id)>
				<input type="hidden" value="<cfoutput>#id#</cfoutput>" name="upper_folder_id" id="upper_folder_id">
				<cfoutput><b><cfoutput>#get_upper_folders.folder_name#</cfoutput></b></cfoutput>
			<cfelse>
				<select name="upper_folder_id" id="upper_folder_id" style="width:165px;">
					<option value="">Seçiniz</option>
					<cfoutput query="get_upper_folders">
						<option value="#folder_id#">#folder_name#</option>
					</cfoutput>
				</select>
			</cfif>
		</td>
		</tr>
		<tr><td><input type="text" name="file_name" id="filename_id" style="width:165px;"><br/></td></tr>
		<tr><td style="text-align:right;" style="text-align:right;"><input type="button" name="add_file" value="Kaydet" onclick="add_file_close();"></td></tr>
		</cfform>
	</table>
</cf_box>

<script type="text/javascript">
function add_file_close()
{
	AjaxFormSubmit("send_","add_file_box",0,"Klasör Oluşturuluyor!","Klasör Oluşturuldu!","<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_leftmenu_cubemail","left_menu_div");
}
</script>
