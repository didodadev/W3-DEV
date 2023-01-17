<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'><!--- Mail Listelemerinde Her Zaman 20 olucak! --->
<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.folder_id")>
	<cfquery name="EMP_MAIL_LIST" datasource="#DSN#" maxrows="10">
		SELECT 
			MAILBOX_ID
		FROM 
			CUBE_MAIL WITH(NOLOCK)
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfif attributes.folder_id eq -10>	
        <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            <cf_date tarih='attributes.startdate'>
        </cfif>
        <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            <cf_date tarih='attributes.finishdate'>
        </cfif>
    </cfif>
	<cfquery name="get_mails" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			MAILS WITH (NOLOCK)
		WHERE 
			MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#) AND 
			<cfif attributes.folder_id eq -10>
				FOLDER_ID <> 0
				<cfif isdefined("attributes.mail_from") and len(attributes.mail_from)>
					AND MAIL_FROM LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.mail_from#%">
				</cfif>
				<cfif isdefined("attributes.mail_to") and len(attributes.mail_to)>
					AND 
					(MAIL_TO LIKE '%#attributes.mail_to#%' OR MAIL_CC LIKE '%#attributes.mail_to#%')
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				<cfif isdefined("attributes.mail_subject") and len(attributes.mail_subject)>
					AND SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.mail_subject#%">
				</cfif>
				<cfif isdefined("attributes.mail_file") and len(attributes.mail_file) and attributes.mail_file eq 1>
					AND MAIL_ID IN (SELECT MAIL_ID FROM MAILS_ATTACHMENT)
				</cfif>
			<cfelse>
				FOLDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.folder_id#">
			</cfif>	
		ORDER BY
			<cfif isdefined("attributes.order_type") and attributes.order_type eq 1>
				SUBJECT ASC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 2>
				SUBJECT DESC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 3>
				MAIL_TO ASC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 4>
				MAIL_TO DESC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 5>
				MAIL_FROM ASC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 6>
				MAIL_FROM DESC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 7>
				IS_READ ASC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 8>
				IS_READ DESC
			<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 9>
				RECORD_DATE	ASC,
				REAL_DATE ASC
			<cfelse>
				REAL_DATE DESC,
				RECORD_DATE	DESC
                <!---MAIL_ID DESC--->
			</cfif>
	</cfquery>
	<cfif attributes.folder_id gt 0>
		<cfquery name="get_folder" datasource="#dsn#">
			SELECT * FROM CUBE_MAIL_FOLDER WHERE FOLDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.folder_id#">
		</cfquery>
		<cfset folder_name_ = get_folder.folder_name>
	<cfelse>
		<cfif attributes.folder_id eq -1>
			<cfset folder_name_ = 'Taslaklar'>
		<cfelseif attributes.folder_id eq -2>
			<cfset folder_name_ = 'Silinmiş Öğeler'>
		<cfelseif attributes.folder_id eq -3>
			<cfset folder_name_ = 'Giden Kutusu'>
		<cfelseif attributes.folder_id eq -4>
			<cfset folder_name_ = 'Gelen Kutusu'>
		<cfelseif attributes.folder_id eq -10>
			<cfset folder_name_ = 'Arama Sonuçları'>
		</cfif>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default='#GET_MAILS.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelse>
	<cfquery name="get_mails" datasource="#dsn#">
		SELECT
			M.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			MAILS M,
			MAILS_RELATION MR,
			CUBE_MAIL CM,
			EMPLOYEES E
		WHERE
			MR.MAIL_ID = M.MAIL_ID AND
			CM.MAILBOX_ID = M.MAILBOX_ID AND
			CM.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			MR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.relation_type#"> AND
			MR.RELATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_type_id#">
	</cfquery>
	<cfset folder_name_ = ''>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default='#GET_MAILS.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<!--- <cf_box title="#folder_name_#" id="mail_list" closable="0" collapsable="0"> --->
	<cf_grid_list>
		<thead>
		  	<tr>
				<cfif isdefined("attributes.folder_id")>
					<cfif attributes.folder_id neq -10>
						<th width="20" align="center"><a href="javascript://" onClick="select_all();"><i class="fa fa-check-square-o" alt="<cf_get_lang dictionary_id='33746.Hepsini Seç'>" title="<cf_get_lang dictionary_id='33746.Hepsini Seç'>!" ></i></a></th>
					</cfif>	
				</cfif>
				<th width="15" <cfif not isdefined("attributes.relation_type") and attributes.folder_id neq -10>onclick="list_mail('<cfoutput>#attributes.folder_id#</cfoutput>','<cfif attributes.order_type eq 7>8<cfelse>7</cfif>');" <cfelseif not isdefined("attributes.relation_type") and attributes.folder_id eq -10>onClick="<cfoutput>list_mail('#attributes.folder_id#','<cfif attributes.order_type eq 7>8<cfelse>7</cfif>','1','#attributes.mail_from#','#attributes.mail_to#','#attributes.startdate#','#attributes.finishdate#','#attributes.mail_subject#','#attributes.mail_body#','#attributes.mail_file#');</cfoutput>"</cfif>><cfif not isdefined("attributes.relation_type")><cfif attributes.order_type eq 7><i class="fa fa-chevron-down"></i><cfelse><i class="fa fa-chevron-right"></i></cfif></cfif></a></th>
				<th width="15"></td>
				<cfif isdefined("attributes.relation_type")><th width="15"><a href="javascript://" ></a><cf_get_lang dictionary_id='58680.İlişki'></th></cfif>
				<th><a href="javascript://"  <cfif not isdefined("attributes.relation_type") and attributes.folder_id neq -10>onclick="list_mail('<cfoutput>#attributes.folder_id#</cfoutput>','<cfif attributes.order_type eq 1>2<cfelse>1</cfif>');" <cfelseif not isdefined("attributes.relation_type") and attributes.folder_id eq -10>onClick="<cfoutput>list_mail('#attributes.folder_id#','<cfif attributes.order_type eq 1>2<cfelse>1</cfif>','1','#attributes.mail_from#','#attributes.mail_to#','#attributes.startdate#','#attributes.finishdate#','#attributes.mail_subject#','#attributes.mail_body#','#attributes.mail_file#');</cfoutput>"</cfif>><cfif not isdefined("attributes.relation_type")><cfif attributes.order_type eq 1><i class="fa fa-chevron-down"></i><cfelse><i class="fa fa-chevron-right"></i></cfif></cfif></a><cf_get_lang dictionary_id='57480.Konu'></th>
				<th width="160"><a href="javascript://"  <cfif not isdefined("attributes.relation_type") and attributes.folder_id neq -10>onclick="list_mail('<cfoutput>#attributes.folder_id#</cfoutput>','<cfif attributes.order_type eq 3>4<cfelse>3</cfif>');"<cfelseif not isdefined("attributes.relation_type") and attributes.folder_id eq -10>onClick="<cfoutput>list_mail('#attributes.folder_id#','<cfif attributes.order_type eq 3>4<cfelse>3</cfif>','1','#attributes.mail_from#','#attributes.mail_to#','#attributes.startdate#','#attributes.finishdate#','#attributes.mail_subject#','#attributes.mail_body#','#attributes.mail_file#');</cfoutput>"</cfif>><cfif not isdefined("attributes.relation_type")><cfif attributes.order_type eq 3><i class="fa fa-chevron-down"></i><cfelse><i class="fa fa-chevron-right"></i></cfif></cfif></a><cf_get_lang dictionary_id='57924.Kime'></th>
				<th width="160"><a href="javascript://"  <cfif not isdefined("attributes.relation_type") and attributes.folder_id neq -10>onclick="list_mail('<cfoutput>#attributes.folder_id#</cfoutput>','<cfif attributes.order_type eq 5>6<cfelse>5</cfif>');"<cfelseif not isdefined("attributes.relation_type") and attributes.folder_id eq -10>onClick="<cfoutput>list_mail('#attributes.folder_id#','<cfif attributes.order_type eq 5>6<cfelse>5</cfif>','1','#attributes.mail_from#','#attributes.mail_to#','#attributes.startdate#','#attributes.finishdate#','#attributes.mail_subject#','#attributes.mail_body#','#attributes.mail_file#');</cfoutput>"</cfif>><cfif not isdefined("attributes.relation_type")><cfif attributes.order_type eq 5><i class="fa fa-chevron-down"></i><cfelse><i class="fa fa-chevron-right"></i></cfif></cfif></a><cf_get_lang dictionary_id='51087.Kimden'></th>
				<th width="90"><a href="javascript://" <cfif not isdefined("attributes.relation_type") and attributes.folder_id neq -10>onclick="list_mail('<cfoutput>#attributes.folder_id#</cfoutput>','<cfif attributes.order_type eq 9>10<cfelse>9</cfif>');"<cfelseif not isdefined("attributes.relation_type") and attributes.folder_id eq -10>onClick="<cfoutput>list_mail('#attributes.folder_id#','<cfif attributes.order_type eq 9>10<cfelse>9</cfif>','1','#attributes.mail_from#','#attributes.mail_to#','#attributes.startdate#','#attributes.finishdate#','#attributes.mail_subject#','#attributes.mail_body#','#attributes.mail_file#');</cfoutput>"</cfif>><cfif not isdefined("attributes.relation_type")><cfif attributes.order_type eq 9><i class="fa fa-chevron-down"></i><cfelse><i class="fa fa-chevron-right"></i></cfif></cfif></a><cf_get_lang dictionary_id='57742.Tarih'></th>
			</tr>
		</thead>
		<tbody>
		  	<cfif get_mails.RecordCount>
				<cfquery name="get_attaches" datasource="#dsn#">
					SELECT MAIL_ID FROM MAILS_ATTACHMENT WHERE (SPECIAL_CODE IS NULL OR SPECIAL_CODE = '' OR SPECIAL_CODE = 'null') AND  MAIL_ID IN (#valuelist(GET_MAILS.mail_id)#)
				</cfquery>
				<cfoutput query="GET_MAILS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="20" onMouseOver="this.className='color-light';" <cfif IS_READ eq 1>onMouseOut="this.className='color-row';" class="color-row"<cfelse>onMouseOut="this.className='color-list';" class="color-list"</cfif>>
						<cfif isdefined("attributes.folder_id")>
							<cfif attributes.folder_id neq -10>
								<td align="center" width="20"><input type="checkbox" name="mail_id_list" id="mail_id_list" value="#mail_id#"></td>
							</cfif>
						</cfif>
						<td align="center"><cfif IS_READ eq 0><img src="/images/menu_com.gif" alt=""><cfelse><img src="/images/menu_cms.gif" alt=""></cfif></td>
						<td align="center"><cfif get_attaches.recordcount and listfindnocase(valuelist(get_attaches.mail_id),mail_id)><img src="images/attach.gif" border="0" alt=""></cfif></td>
						<cfif isdefined("attributes.relation_type")><td align="center" valign="top"><a href="javascript://" onclick="delete_mail(#mail_id#,'#attributes.relation_type#',#attributes.relation_type_id#);"><img border="0" title="İlişkiyi Kaldır" align="absmiddle" src="images/mail/delete1.gif"/></a></td></cfif>
						<td>
							<cfif folder_id eq -1>
								<a href="javascript://" onClick="create_mail('#mail_id#','template','3');" class="tableyazi"><cfif len(SUBJECT)>#htmleditformat(SUBJECT)#<cfelse><cf_get_lang dictionary_id="38560.Başlık Girilmemiş"></cfif></a>
							<cfelse>
								<a href="javascript://" onClick="get_mail(#mail_id#,#folder_id#);" class="tableyazi"><cfif len(SUBJECT)>#htmleditformat(SUBJECT)#<cfelse><cf_get_lang dictionary_id="38560.Başlık Girilmemiş"></cfif></a>
							</cfif>
						</td>			
						<td>#listfirst(replace(replace(mail_to,"<","","all"),">","","all"),',')#</td>
						<td>#listfirst(replace(replace(MAIL_FROM,"<","","all"),">","","all"),',')#</td>
						<td>
						<cfif FOLDER_ID eq -3>
							<cfif len(REAL_DATE)>
								#dateformat(dateadd("h",session.ep.time_zone,REAL_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,REAL_DATE),timeformat_style)#
							<cfelse>
								#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
							</cfif>
						<cfelseif FOLDER_ID eq -4>
							<cfif len(REAL_DATE)>
								#dateformat(REAL_DATE,dateformat_style)# #TimeFormat(REAL_DATE,timeformat_style)#
							<cfelse>
								#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
							</cfif>
						<cfelse>
							<cfif len(REAL_DATE)>
								#dateformat(REAL_DATE,dateformat_style)# #TimeFormat(REAL_DATE,timeformat_style)#
							<cfelse>
								#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
							</cfif>
						</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfif isdefined("attributes.folder_id")>
					<tr>
						<td colspan="<cfif isdefined("attributes.folder_id") and attributes.folder_id neq -10>5<cfelse>4</cfif>" height="30">
							<cfinclude template="../query/get_folders.cfm">
							<cfif attributes.folder_id neq -10>
								<select name="new_folder" id="new_folder">
									<option value="">Taşınacak Klasör</option>
									<cfoutput query="get_folders">
										<cfif attributes.folder_id neq folder_id><option value="#folder_id#">#folder_name#</option></cfif>
									</cfoutput>
								</select>
								<input type="button" value="<cf_get_lang no ='255.Mailleri Taşı'>" onClick="move_all(<cfoutput>#attributes.folder_id#</cfoutput>);">
								<cfif not listfindnocase(denied_pages,'correspondence.emptypopup_delete_cubemail')>
									<input type="button" value="<cf_get_lang no ='256.Mailleri Sil'>" onClick="delete_all(<cfoutput>#attributes.folder_id#</cfoutput>);">
									<input type="button" value="Klasörü Boşalt" onClick="delete_all_folder(<cfoutput>#attributes.folder_id#</cfoutput>);">
								</cfif>
								<input type="button" value="Okundu Say" onClick="read_all_folder(<cfoutput>#attributes.folder_id#</cfoutput>,1);">
								<input type="button" value="Okunmadı Say" onClick="read_all_folder(<cfoutput>#attributes.folder_id#</cfoutput>,0);">
							</cfif>
						</td>
						<td colspan="2" style="text-align:right;">
							<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
							<cfset _last_page_ = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
							<cfoutput>
							<cfset url_str = "">
							<cfset url_str = "'#attributes.folder_id#'">
							<cfset url_str = "#url_str#,'#attributes.order_type#'">
							<cfif attributes.folder_id eq -10>
								<cfif attributes.order_type neq 0>
									<!---<cfset url_str = "#url_str#,'#attributes.order_type#'">
									<cfset url_str = "#url_str#,'#attributes.folder_id#'">--->
									<cfset url_str = "#url_str#,'#attributes.order_type#'">
									<cfset url_str = "#url_str#,'#attributes.folder_id#'">
								<cfelse>
									<cfset url_str = "#url_str#,'#attributes.mail_from#'">
									<cfset url_str = "#url_str#,'#attributes.mail_to#'">
									<cfset url_str = "#url_str#,'#dateformat(attributes.startdate,dateformat_style)#'">
									<cfset url_str = "#url_str#,'#dateformat(attributes.finishdate,dateformat_style)#'">
									<cfset url_str = "#url_str#,'#attributes.mail_subject#'">
									<cfset url_str = "#url_str#,'#attributes.mail_body#'">
									<cfset url_str = "#url_str#,'#attributes.mail_file#'">
								</cfif>
							</cfif>                    
							<input type="hidden" name="my_page" id="my_page" value="#attributes.page#" /> 
								<cfif attributes.page neq 1>
									<a href="javascript://" onclick="inc_page(0)"><img src="../images/previous20.gif" border="0" align="absbottom"></a>
								<cfelse>
									<img src="../images/previous20.gif" border="0" align="absbottom">
								</cfif>
								<cfif _last_page_ neq attributes.page>
									<a href="javascript://" onclick="inc_page(1);"><img src="../images/next20.gif" border="0" align="absbottom"></a>
								<cfelse>
									<img src="../images/next20.gif" border="0" align="absbottom">
								</cfif>
							Toplam Kayıt :#attributes.totalrecords# -  Sayfa : #attributes.page#/#_last_page_#
							<!---<select name="select_pages" id="select_pages" onChange="ajaxpaging(this.value,#url_str#);" style="width:40px;">
								<cfloop from="1" to="#_last_page_#" index="pp">
									<option value="#pp#"<cfif attributes.page eq pp >selected</cfif> >#pp#</option>
								</cfloop>	
							</select>
							/
							<input type="text" value="#_last_page_#" style="width:40px;" readonly>--->
							</cfoutput>
						</td>
					</tr>	
				</cfif>			
			<cfelse>
				<tr class="color-row">
				<td colspan="7" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
		</cf_grid_list>
		<!--- liste --->
<!--- </cf_box> --->
<script type="text/javascript">
	function inc_page(page)
	{
		if(page != 1)
		{	
			document.getElementById('my_page').value = parseFloat(document.getElementById('my_page').value) - 1;
		}
		else
		{
			//if(document.getElementById('my_page').value != 1)
				document.getElementById('my_page').value = parseFloat(document.getElementById('my_page').value) + 1;
		}
		<cfif isdefined("url_str")>
		ajaxpaging(document.getElementById('my_page').value,<cfoutput>#url_str#</cfoutput>);
		</cfif>
	}
</script>
