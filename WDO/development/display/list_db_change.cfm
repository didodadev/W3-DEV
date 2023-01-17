<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif not isdefined("form_varmi")>
	<cfset attributes.start_date = date_add('d',-1,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif not isdefined("form_varmi")>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_db_objects" datasource="#dsn#">
              SELECT 
              		ANA.TIME,
                    ANA.OBJECTNAME,
                    ANA.HOSTNAME,
                    ANA.DATABASENAME,
                    ANA.OBJECTTYPE,
                    ANA.WRK_DEVELOPMENT_REPORT_ID,
                    BABA.TOTAL
              FROM  
               ( 
                SELECT 
                    TIME,
                    OBJECTNAME,
                    HOSTNAME,
                    DATABASENAME,
                    OBJECTTYPE,
                    WRK_DEVELOPMENT_REPORT_ID
                FROM 
                    WRK_DEVELOPMENT_REPORT   	
                WHERE
                    TIME in
                    (
                        SELECT 
                            MAX(TIME)
                        FROM 
                            WRK_DEVELOPMENT_REPORT 
                        WHERE 
                            COMMANDTEXT NOT LIKE '%Tmp%'
                        <cfif isdefined("db_name") and len(db_name)>
                        AND
                            DATABASENAME = '#attributes.db_name#'     	
                        </cfif>
                        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                        AND	
                            OBJECTNAME LIKE '%attributes.keyword%'
                        </cfif>
                        AND
                            TIME  between  #attributes.start_date# and #attributes.finish_date# 
                        GROUP BY OBJECTNAME
                    ) 
            
            	) AS ANA 
                
                LEFT JOIN 
                	(
                		SELECT 
                        COUNT(WRK_DEVELOPMENT_REPORT_ID) AS TOTAL,
                        OBJECTNAME,
                        DATABASENAME
                    FROM 
                        WRK_DEVELOPMENT_REPORT
                    WHERE 
                        COMMANDTEXT NOT LIKE '%Tmp%'  
                    GROUP BY 
                        OBJECTNAME,
                        DATABASENAME
              		) AS BABA  
                 ON    ANA.OBJECTNAME=BABA.OBJECTNAME AND ANA.DATABASENAME=BABA.DATABASENAME 
                             
	</cfquery>	
<cfelse>
	<cfset get_db_objects.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_db_objects.recordcount#'>
<cfquery name="get_db_name" datasource="#dsn#">
	SELECT NAME FROM SYS.DATABASES
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_file" method="post" action="#request.self#?fuseaction=dev.list_db_change">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent  variable="head"><cf_get_lang dictionary_id='59086.Tablo'></cfsavecontent>
					<cfsavecontent  variable="mess"><cf_get_lang dictionary_id='29800.Dosya Adı'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="50" message="#mess#" placeholder="#head#">
				</div>
				<div class="form-group">
					<select name="db_name" id="db_name">
						<option value=""><cf_get_lang dictionary_id='59092.Veritabanı'></option>
						<cfoutput query="GET_DB_NAME">
							<option value="#NAME#">#NAME#</option> 
						</cfoutput>                       
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, 'dd/mm/yyyy')#"  validate="eurodate" required="yes" maxlength="10" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" required="yes" message="#message#">			
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent  variable="title"><cf_get_lang dictionary_id='64375.DB Değişimleri'></cfsavecontent>
	<cf_box title="#title#" hide_table_column="1" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='59063.Tablo Adı'></th>
					<th><cf_get_lang dictionary_id='59063.Tablo Adı'></th>
					<th><cf_get_lang dictionary_id='59092.Veritabanı'></th>
					<th><cf_get_lang dictionary_id='64376.Değişiklik Sayısı'></th>
					<th><cf_get_lang dictionary_id='52744.Son Değişiklik'></th>
					<th><cf_get_lang dictionary_id='41644.İşlemi Yapan'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_db_objects.recordcount> 
					<cfoutput query="get_db_objects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr> 
							<td align="center"  id="file_row#currentrow#" class="iconL" onClick="gizle_goster(file_row_detail#currentrow#);connectAjax('#currentrow#','#URLEncodedFormat(OBJECTNAME)#');">
								#currentrow#
								<i id="file_goster#currentrow#" class="fa fa-caret-right"></i>
							</td>
							<td>#OBJECTNAME#</td>
							<td>#OBJECTTYPE#</td>
							<td>#DATABASENAME#</td>
							<td>#TOTAL#</td>
							<td>#dateformat(dateadd('h',session.ep.time_zone,TIME),'DD/MM/YYYY')# #Timeformat(dateadd('h',session.ep.time_zone,TIME),'HH:MM')#</td>
							<td>#HOSTNAME#</td>
						</tr>
						<!-- sil -->
						<tr id="file_row_detail#currentrow#" style="display:none" class="nohover">
							<td colspan="7">
								<div align="left" id="file_row_div#currentrow#"></div>
							</td>
						</tr>
						<!-- sil -->
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="7" height="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = 'dev.list_file_change'>
			<cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
			<cfif isdate(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&is_form_submitted=1">		
		</cfif>
	</cf_box>
</div>
<script language="javascript">
	function connectAjax(crtrow,objectname)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=dev.emptypopup_ajax_list_db_change_row</cfoutput>&object_name='+ objectname;
		AjaxPageLoad(bb,'file_row_div'+crtrow,1);
	}
</script>
