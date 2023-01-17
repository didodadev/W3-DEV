<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.organization_cat_id" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.start_date" default="#dateformat(dateadd('m',-1,now()),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.is_active" default="1">
<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_ORGANIZATION" datasource="#dsn#">
		SELECT 
			ORGANIZATION_ID,
			ORGANIZATION_HEAD,
			ORGANIZATION_CAT_ID,
            (SELECT ORGANIZATION_CAT_NAME FROM ORGANIZATION_CAT WHERE ORGANIZATION_CAT_ID = ORGANIZATION.ORGANIZATION_CAT_ID) ORGANIZATION_CAT_NAME,
            CASE 
                WHEN ORGANIZATION.ORGANIZER_PAR IS NOT NULL THEN 
                    (SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = ORGANIZATION.ORGANIZER_PAR)
                WHEN ORGANIZATION.ORGANIZER_EMP IS NOT NULL THEN 
                    (SELECT EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = ORGANIZATION.ORGANIZER_EMP) 
                WHEN ORGANIZATION.ORGANIZER_CON IS NOT NULL THEN
                    (SELECT CONSUMER.CONSUMER_NAME +' '+ CONSUMER.CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER.CONSUMER_ID = ORGANIZATION.ORGANIZER_CON)
            END AS ORGANIZER,
            CASE 
            	WHEN IS_ACTIVE = 1 THEN 'Aktif'
            	WHEN IS_ACTIVE = 0 THEN 'Pasif'
            END AS ACTIVE,
			ORGANIZER_PAR,
			START_DATE,
			FINISH_DATE,
			MAX_PARTICIPANT,
			ADDITIONAL_PARTICIPANT,
			ORGANIZATION_PLACE,
			ORGANIZATION.CAMPAIGN_ID,
			ORGANIZATION.PROJECT_ID,
			INT_OR_EXT,
			IS_INTERNET,
			TOTAL_DATE,
			TOTAL_HOUR,
			ORGANIZATION.RECORD_DATE,
            (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = ORGANIZATION.RECORD_EMP) NAME,
			PTR.STAGE,
			MAX_PARTICIPANT AS EXPECTED_ATTENDERS,
			(SELECT COUNT(*) FROM ORGANIZATION_ATTENDER OA WHERE OA.ORGANIZATION_ID = ORGANIZATION.ORGANIZATION_ID AND ISNULL(OA.PARTICIPATION_RATE,0) > 0) AS TOTAL_ATTENDERS,
			PP.PROJECT_HEAD
		FROM
			ORGANIZATION
				LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ORGANIZATION.ORG_STAGE
				LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = ORGANIZATION.PROJECT_ID
		WHERE
			1=1 
        <cfif attributes.is_active eq 1>
			AND IS_ACTIVE = 1
		<cfelseif  attributes.is_active eq 0>
			AND IS_ACTIVE = 0
		</cfif>
		<cfif len(attributes.keyword)>
			AND 
			(
                ORGANIZATION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                ORGANIZATION_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif len(attributes.member_name)>
			<cfif len(attributes.emp_id)>AND ORGANIZER_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"></cfif> 
			<cfif len(attributes.par_id)>AND ORGANIZER_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#"></cfif>
			<cfif len(attributes.cons_id)>AND ORGANIZER_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"></cfif>
		</cfif>
		<cfif len(attributes.organization_cat_id)>
			AND ORGANIZATION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_cat_id#">
		</cfif>
		<cfif len(attributes.process_stage_type)>
			AND ORG_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			AND ORGANIZATION.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif len(attributes.start_date)>
			AND FINISH_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
			AND START_DATE <= #dateAdd('d', 1, attributes.finish_date)#
		</cfif>
		ORDER BY START_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_organization.recordcount = 0>	
</cfif>
<cfquery name="GET_ORGANIZATION_CAT" datasource="#DSN#">
	SELECT ORGANIZATION_CAT_ID,ORGANIZATION_CAT_NAME FROM ORGANIZATION_CAT
</cfquery>
<cfquery name = "get_org_stage" datasource = "#dsn#">
	SELECT
      	PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%campaign.list_organization%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default="#get_organization.recordcount#">
<cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="organization_form" action="#request.self#?fuseaction=campaign.list_organization" method="post">
			<cf_box_search>
				<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getlang('main','Filtre',57460)#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfoutput>
							<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
							<input type="hidden" name="par_id" id="par_id" value="#attributes.par_id#">
							<input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
							<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
							<input type="text" name="member_name" id="member_name" value="#attributes.member_name#" placeholder="#getlang('main','Yetkili',57578)#" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','par_id,cons_id,emp_id,member_type','','3','225');" autocomplete="off" />
						</cfoutput>
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=organization_form.emp_id&field_name=organization_form.member_name&field_type=organization_form.member_type&field_partner=organization_form.par_id&field_consumer=organization_form.cons_id&select_list=1,7,8');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span> 
					</div>
				</div>	
				<div class="form-group">
					<select name="is_active" id="is_active" >
						<option value="2"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<option value="1" <cfif attributes.is_active eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
						<option value="0" <cfif attributes.is_active eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
					</select>
				</div>     
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1," maxlength="3" required="yes">
				</div>
				<div class="form-group"> 
					<cf_wrk_search_button button_type="4">
				</div>                        		
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-12">
							<select name="organization_cat_id" id="organization_cat_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query = "GET_ORGANIZATION_CAT">
									<option value="#organization_cat_id#" <cfif attributes.organization_cat_id eq organization_cat_id>selected</cfif>>#organization_cat_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="form_ul_project_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-12">
							<div class="input-group">
							<cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfset attributes.project_id=url.pro_id></cfif>
							<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif>
							<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<input type="text" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=organization_form.project_id&project_head=organization_form.project_head&allproject=1');"></span>
						</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="form_ul_process_stage_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='57482.Aşama'></label>
						<div class="col col-12">
							<select name="process_stage_type" id="process_stage_type">
							<option value=""><cf_get_lang dictionary_id ='57482.Aşama'></option>
								<cfoutput query="get_org_stage">
										<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="form_ul_start_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="start_date" value="" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi','58053')#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="finish_date" value="" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi','57700')#">			
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang("","",46909)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='29465.Etkinlik'></th>
					<th><cf_get_lang dictionary_id='57578.Yetkili'></th>
					<th><cf_get_lang dictionary_id='49712.Etkinlik Yeri'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='58053.Baslangic Tarihi'></th>
					<th><cf_get_lang dictionary_id='57700.Bitis Tarihi'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th> 
					<th><cf_get_lang dictionary_id='61164.Planlanan Katılımcı'></th>
					<th><cf_get_lang dictionary_id='61165.Gerçekleşen Katılımcı'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayit Tarihi'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>list_organization&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_organization.recordcount>
					<cfoutput query="get_organization" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td> 
							<td><a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#organization_id#" class="tableyazi">#organization_head#</a></td>
							<td>#organizer#</td>
							<td>#organization_place#</td>
							<td>#organization_cat_name#</td>
							<td>#stage#</td>
							<td>#dateformat(date_add('h',session.ep.time_zone,start_date),dateformat_style)#</td>
							<td>#dateformat(date_add('h',session.ep.time_zone,finish_date),dateformat_style)#</td>
							<td nowrap="nowrap">#active#</td>
							<td>#expected_attenders#</td>
							<td>#total_attenders#</td>
							<td>#project_head#</td>
							<td nowrap="nowrap">#name#</td>
							<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#</td> 
							<td><!-- sil --><a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#organization_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i><!-- sil --></a></td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="15"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td>
						</tr>
				</cfif>
				</table>
			</tbody>
		</cf_grid_list>
			<cfset adres = "">
			<cfset adres = "#adres#&is_submitted=1">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#"> 
			</cfif>
			<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
				<cfset adres = "#adres#&emp_id=#attributes.emp_id#">
			</cfif>
			<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
				<cfset adres = "#adres#&par_id=#attributes.par_id#">
			</cfif>
			<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
				<cfset adres = "#adres#&cons_id=#attributes.cons_id#">
			</cfif>
			<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)>
				<cfset adres = "#adres#&emp_par_name=#attributes.emp_par_name#">
			</cfif> 
			<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
				<cfset adres = "#adres#&member_type=#attributes.member_type#">
			</cfif>
			<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
				<cfset adres = "#adres#&member_name=#attributes.member_name#">
			</cfif>
			<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
				<cfset adres = "#adres#&is_active=#attributes.is_active#">
			</cfif>	
			<cfif isdefined("attributes.organization_cat_id") and len(attributes.organization_cat_id)>
				<cfset adres = "#adres#&organization_cat_id=#attributes.organization_cat_id#">
			</cfif>
			<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
				<cfset adres = "#adres#&process_stage_type=#attributes.process_stage_type#">
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
				<cfset adres = "#adres#&project_id=#attributes.project_id#">
			</cfif>
			<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
				<cfset adres = "#adres#&project_head=#attributes.project_head#">
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="campaign.list_organization&#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();	
</script>