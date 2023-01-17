<cfsetting showdebugoutput="no">
<cf_box title='Klasörü Güncelle' collapsable="0" id='upd_file' style="width:100%;">
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


<cfquery name="EMP_MAIL_LIST" datasource="#DSN#" maxrows="10">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>

<cfquery name="get_mail" datasource="#dsn#">
	SELECT TOP 1 MAIL_ID FROM MAILS WHERE MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#) AND FOLDER_ID = #attributes.id#
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
<cfquery name="get_folder_name_" dbtype="query">
	SELECT 
		* 
	FROM 
		get_folders 
	WHERE 
		FOLDER_ID = #attributes.id# 
	ORDER BY 
		FOLDER_NAME ASC
</cfquery>

<cfquery name="get_upper_folders" dbtype="query">
	SELECT 
		* 
	FROM 
		get_folders 
	WHERE 
		UPPER_FOLDER_ID IS NULL AND FOLDER_ID <> #attributes.id#
	ORDER BY 
		FOLDER_ID ASC
</cfquery>

<cfquery name="get_alts_" dbtype="query" maxrows="1">
	SELECT 
		* 
	FROM 
		get_folders 
	WHERE 
		UPPER_FOLDER_ID = #attributes.id# 
</cfquery>
	<table cellspacing="0" cellpadding="1" width="100%" height="100%">
		<cfform name="send_" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_upd_folder">
		
		<tr>
		<td>
			<select name="upper_folder_id" id="upper_folder_id" style="width:165px;">
				<option value="">Seçiniz</option>
				<cfoutput query="get_upper_folders">
					<option value="#folder_id#" <cfif get_folder_name_.upper_folder_id eq folder_id>selected</cfif>>#folder_name#</option>
				</cfoutput>
			</select>
		</td>
		</tr>
		<input type="hidden" name="operation" id="operation" value="" />
		<input type="hidden" value="<cfoutput>#id#</cfoutput>" name="folder_id" id="folder_id">
		<tr><td><input type="text" name="folder_name" id="folder_name" value="<cfoutput>#get_folder_name_.folder_name#</cfoutput>" style="width:165px;"><br/></td></tr>
		<tr>
			<td style="text-align:right;"><input type="button" value="Güncelle" onClick="rule_delete(1)"><cfif get_mail.recordcount eq 0 and get_alts_.recordcount eq 0><input type="button" value="Sil" onClick="rule_delete(2)"></cfif></td>
		</tr>
		</cfform>
	</table>
</cf_box>
<script type="text/javascript">
function rule_delete(type_)
		{
		if(type_==1)
		document.send_.operation.value='upd';
		else
		document.send_.operation.value='del';
		AjaxFormSubmit("send_","upd_file",0,"İşlem yapılıyor","İşlem yapıldı!","<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_leftmenu_cubemail","left_menu_div");
		}
</script>


