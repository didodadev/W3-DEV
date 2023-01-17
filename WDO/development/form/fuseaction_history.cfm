<!--- <cfquery name="GET_FUSEACTION_RELATION" datasource="#DSN#">
	SELECT
		MODUL,
		FUSEACTION,
		TYPE,
		WRK_RELATION_ID
	FROM
	 	WRK_OBJECTS_RELATION
	WHERE
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery> --->

<cfquery name="GET_WRK_HISTORY" datasource="#DSN#">
	 SELECT 
	 	IS_ACTIVE,
		BASE,
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		HEAD,
		FRIENDLY_URL,
		FOLDER,
		FILE_NAME,
		STAGE,
		TYPE,
		WINDOW,
		SECURITY,
		STATUS,
		VERSION,
		AUTHOR,
		DETAIL,
		WRK_OBJECTS_HISTORY.RECORD_IP,
		WRK_OBJECTS_HISTORY.RECORD_EMP,
		WRK_OBJECTS_HISTORY.RECORD_DATE,
        EMPLOYEES.EMPLOYEE_NAME +' '+EMPLOYEES.EMPLOYEE_SURNAME NAME
	FROM
		WRK_OBJECTS_HISTORY,
        EMPLOYEES
	WHERE
    	EMPLOYEES.EMPLOYEE_ID = WRK_OBJECTS_HISTORY.RECORD_EMP and
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery>


<table width="98%" align="center">
	<tr>
    	<td height="30" class="headbold">Fuseaction Tarihçe</td>
	</tr>
</table>

<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<cfform name="upd_faction" method="post" action="#request.self#?fuseaction=dev.emptypopup_upd_fuseaction&woid=#attributes.woid#">
			<td valign="top">
				<cfif get_wrk_history.recordcount>
					<cfoutput query="get_wrk_history">
		
					<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border">
						<tr class="color-row">
							<td valign="top">
								<table border="0">
								<input type="hidden" value="0" name="to_row_count" id="to_row_count">
									<tr>
										<td width="90" class="txtboldblue">Active</td>
										<td width="200">: <cfif is_active eq 1>Active<cfelse>Passive</cfif></td>
										<td width="50"></td>
										<td align="left" class="txtboldblue"></td>
										<td width="200"></td>
										<td width="20"></td>
									</tr>
									<tr valign="top">
										<td width="90" class="txtboldblue">Base</td>
										<td width="200">: #base#</td>
										<td width="50"></td>
										<td width="20"></td>
									</tr>
									<tr>
										<td class="txtboldblue">Head</td>
										<td>: #head#</td>
										<td></td>
										<td align="left" class="txtboldblue">Type</td>
										<td>: #type#</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td class="txtboldblue">Modul</td>
										<td>: #modul#</td>
										<td></td>
										<td align="left" class="txtboldblue">Window</td>
										<td>: #window#</td>
									</tr>
									<tr>
										<td class="txtboldblue">Fuseaction</td>
										<td>: #fuseaction#</td>
										<td></td>
										<td align="left" class="txtboldblue">Security</td>
										<td>: #security#</td>
									</tr>
									<tr>
										<td class="txtboldblue">Folder</td>
										<td>: #folder#</td>
										<td></td>
										
										<td align="left" class="txtboldblue">Status</td>
										<td>: </td>
									</tr>	
									<tr>
										<td class="txtboldblue">Friendly URL </td>
										<td>: #friendly_url#</td>
										<td></td>
										<td align="left" class="txtboldblue">Version</td>
										<td>: #version#</td>
									</tr>
									<tr>
										<td class="txtboldblue">File</td>
										<td>: #file_name#</td>
										<td></td>
										<td align="left" class="txtboldblue">Author</td>
										<td>: #NAME#<td> 	
									</tr>
									<tr>
										<td class="txtboldblue">Güncelleyen</td>
										<td>: #name#</td>
										<td><cfset record_date_ = date_add('h',session.ep.time_zone,record_date)> </td>
										<td align="left" class="txtboldblue">Güncelleme Tarihi</td>
										<td>: #dateformat(record_date_,'dd/mm/yyyy')# #timeformat(record_date_,'HH:MM:SS')#<td> 	
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<br />
					</cfoutput>
				<cfelse>
					<table>
						<tr>
							<td>
								Kayıt Bulunamadı !
							</td>
						</tr>
					</table>
				</cfif>
			</td>
		</cfform>
	</tr>
</table>
		

