<cfquery name="get_folders" datasource="#dsn#">
	SELECT 
		'd' AS TYPE,
		'folder.jpg' AS MAIL_IMAGE,
		'folder_d_' + CAST(FOLDER_ID AS nvarchar) AS IMAJ_ID,
		FOLDER_ID,
		FOLDER_NAME,
		UPPER_FOLDER_ID
	FROM
		CUBE_MAIL_FOLDER 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
	ORDER BY 
		FOLDER_NAME
</cfquery>

<cfscript>
	rc = get_folders.recordcount;
	
	rc = rc + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"MAIL_IMAGE",'inbox.jpg',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_4',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-4',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Gelen Kutusu',rc);
	
	rc = rc + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"MAIL_IMAGE",'sendbox.jpg',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_3',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-3',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Giden Kutusu',rc);
	
	rc = get_folders.recordcount + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"MAIL_IMAGE",'deletebox.jpg',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_2',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-2',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Silinmiş Öğeler',rc);
	
	rc = get_folders.recordcount + 1;
	QueryAddRow(get_folders,1);
	QuerySetCell(get_folders,"TYPE",'s',rc);
	QuerySetCell(get_folders,"MAIL_IMAGE",'draft.jpg',rc);
	QuerySetCell(get_folders,"IMAJ_ID",'folder_s_1',rc);
	QuerySetCell(get_folders,"FOLDER_ID",'-1',rc);
	QuerySetCell(get_folders,"FOLDER_NAME",'Taslaklar',rc);
</cfscript>

