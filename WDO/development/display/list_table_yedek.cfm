<cfquery name="get_database_name" datasource="#dsn#">
	SELECT DISTINCT (DB_NAME) AS DB_NAME FROM WRK_OBJECT_INFORMATION 
</cfquery>
<cfif isdefined("attributes.form_submit")>
	<cfif attributes.search_type eq 1> 
		<cfquery datasource="#dsn#" name="get_table_name">
			SELECT 
				OBJECT_ID,
				OBJECT_NAME,
				DB_NAME,
				TYPE,
				STATUS,
				RECORD_EMP
			FROM 
				WRK_OBJECT_INFORMATION
			WHERE
				<cfif isdefined("attributes.database_name") and len(attributes.database_name)>DB_NAME='#attributes.database_name#' and</cfif>
				<cfif isdefined("attributes.table_name") and len(attributes.table_name)>OBJECT_NAME like '%#attributes.table_name#%' and</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>STATUS='#attributes.status#' and</cfif>
				<cfif isdefined("attributes.type") and len(attributes.type)>TYPE=#attributes.type# and</cfif>
				1=1	
			ORDER BY 
				OBJECT_NAME 	
		</cfquery>
	<cfelse>
		<cfquery datasource="#dsn#" name="get_table_name">
			SELECT 
				OI.OBJECT_ID AS OBJECT_ID,
				OI.OBJECT_NAME AS OBJECT_NAME,
				OI.DB_NAME AS DB_NAME,
				OI.TYPE AS TYPE,
				OI.STATUS AS STATUS,
				OI.RECORD_EMP AS RECORD_EMP,
				CI.COLUMN_NAME AS COLUMN_NAME
			FROM 
				WRK_COLUMN_INFORMATION CI,WRK_OBJECT_INFORMATION OI 
			WHERE
				OI.OBJECT_ID=CI.TABLE_ID and
				<cfif isdefined("attributes.database_name") and len(attributes.database_name)>OI.DB_NAME='#attributes.database_name#' and</cfif>
				<cfif isdefined("attributes.table_name") and len(attributes.table_name)>CI.COLUMN_NAME like '%#attributes.table_name#%' and</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>OI.STATUS='#attributes.status#' and</cfif>
				<cfif isdefined("attributes.type") and len(attributes.type)>OI.TYPE=#attributes.type# and</cfif>
				1=1	
			ORDER BY 
				OBJECT_NAME 	
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_table_name.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_table_name.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%"  height="35" cellspacing="0" cellpadding="0" border="0" align="center">
	<tr>
		<td class="headbold">Workcube Database</td>
		<td>
			<cfform name="post_table_search" method="post" action="http://ep.workcube/index.cfm?fuseaction=dev.list_table">
			<table border="0" style="text-align:right;">
				<tr>
					
					<td>Filtre</td>
					<td><input type="text" name="table_name" id="table_name" <cfif isdefined("attributes.table_name") and len(attributes.table_name)>value="<cfoutput>#attributes.table_name#</cfoutput>"</cfif>/></td>
					<td>
						<select name="status" id="status">
							<option value="">Status</option>
							<option value="Development" <cfif isdefined("attributes.status") and attributes.status is 'Development'>selected</cfif>>Development</option>
							<option value="Deployment" <cfif isdefined("attributes.status") and attributes.status is 'Deployment'>selected</cfif>>Deployment</option>
						</select>
					</td>
					<td><input type="hidden" name="form_submit" id="form_submit" value="1">
						<select name="database_name" id="database_name">
							<option value="">Database</option>
							<cfoutput query="get_database_name">
								<option value="#DB_NAME#" <cfif isdefined("attributes.database_name") and attributes.database_name is #DB_NAME#>SELECTED</cfif>>
									<cfif DB_NAME is 'workcube_cf'>
										Workcube_Main_Db
									<cfelseif DB_NAME is 'workcube_cf_product'>
										Workcube_Product_Db	
									<cfelseif DB_NAME is 'workcube_cf_1'>
										Workcube_Company_Db
									<cfelseif DB_NAME is 'workcube_cf_2012_1'>
										Workcube_Period_Db		
									</cfif>
								</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<select name="type" id="type">
							<option value="">All</option>
							<option value="1" <cfif isdefined("attributes.type") and attributes.type eq 1>selected</cfif>>Active</option>
							<option value="0" <cfif isdefined("attributes.type") and attributes.type eq 0>selected</cfif>>Passive</option>
						</select>
					</td>
					<td>
						<select name="search_type" id="search_type">
							<option value="1">Tablo Bazında</option>
							<option value="0" <cfif isdefined("attributes.search_type") and attributes.search_type eq 0 >selected</cfif>>Kolon Bazında</option>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
					<td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table cellpadding="2" cellspacing="1" border="0" width="100%" class="color-border">
				<tr class="color-header" height="22">
					<td class="form-title">No</td>
					<td class="form-title">Database Name</td>
					<td class="form-title">Table Name</td>
					<cfif isdefined("attributes.search_type") and attributes.search_type neq 1><td class="form-title">Column Name</td></cfif>
					<td class="form-title">Status</td>
					<td class="form-title">Author</td>
					<td class="form-title"></td>
					<td class="form-title" style="width:15px;"><a href="<cfoutput>#request.self#?</cfoutput>fuseaction=dev.add_table"><img src="../../images/plus_square.gif" /></a></td>
				</tr>
				<cfif isdefined("attributes.form_submit")>		
				<cfoutput startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" query="get_table_name">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>#currentrow#</td>
					<td>
						<cfif DB_NAME is 'workcube_cf'>
							Workcube_Main_Db
						<cfelseif DB_NAME is 'workcube_cf_product'>
							Workcube_Product_Db	
						<cfelseif DB_NAME is 'workcube_cf_1'>
							Workcube_Company_Db
						<cfelseif DB_NAME is 'workcube_cf_2012_1'>
							Workcube_Period_Db		
						</cfif>
					</td>
					<td><a class="tableyazi" href="http://ep.workcube/index.cfm?fuseaction=dev.form_upd_table&TABLE_ID=#OBJECT_ID#">#OBJECT_NAME#</a></td>
					<cfif isdefined("attributes.search_type") and attributes.search_type neq 1><td>#COLUMN_NAME#</td></cfif>
					<td>#STATUS#</td>
					<td>#get_emp_info(RECORD_EMP,0,1)#</td>
					<td><cfif #TYPE# eq 1>Aktive<cfelse>Pasive</cfif></td>
					<td><a href="http://ep.workcube/index.cfm?fuseaction=dev.form_upd_table&TABLE_ID=#OBJECT_ID#"><img src="../../images/update_list.gif" /></a></td>
				</tr>
				</cfoutput>
					<cfif not get_table_name.recordcount>
					<tr class="color-row" height="20">
						<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
					</tr>
					</cfif>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="8"><cf_get_lang_main no='289.Filtre ediniz'> !</td>
					</tr>
				</cfif>
			</table>
			<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
				<cfset url_string = ''>
				<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
					<cfset url_string = '#url_string#&form_submit=1'>
				</cfif>
				<cfif isdefined("attributes.table_name") and len(attributes.table_name)>
					<cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
				</cfif>
				<cfif isdefined("attributes.database_name") and len(attributes.database_name)>
					<cfset url_string = '#url_string#&database_name=#attributes.database_name#'>
				</cfif>
				<cfif isdefined("attributes.type") and len(attributes.type)>
					<cfset url_string = '#url_string#&type=#attributes.type#'>
				</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>
					<cfset url_string = '#url_string#&status=#attributes.status#'>
				</cfif>
				<cfif isdefined("attributes.search_type") and len(attributes.search_type)>
					<cfset url_string = '#url_string#&search_type=#attributes.search_type#'>
				</cfif>
			
					<cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="dev.list_table&#url_string#">
				
			</cfif>
		</td>
	</tr>
</table>

