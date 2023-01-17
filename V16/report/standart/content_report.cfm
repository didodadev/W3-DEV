<!--- içerik takip raporu --->
<cfparam name="attributes.module_id_control" default="2">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.search_type" default="0">
<cfform name="form" action="#request.self#?fuseaction=report.content_report" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39595.İçerik Raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-xs-12">						
                                <div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40132.Calisan Sec'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id" style="width:150px;" value="<cfif isDefined('attributes.employee_id') and isDefined('attributes.employee')><cfoutput>#attributes.employee_id#</cfoutput></cfif>" >
											<input type="text" name="employee" id="employee" style="width:150px;" value="<cfif isDefined('attributes.employee')><cfoutput>#attributes.employee#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee&select_list=1&is_form_submitted=1','list');"></span>
										</div>
									</div>
								</div>
                        		<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40133.İcerik Sec'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="content_id" id="content_id" style="width:150px;" value="<cfif isDefined('attributes.content_head') and isDefined('attributes.content_id')><cfoutput>#attributes.content_id#</cfoutput></cfif>" >
											<input type="text" name="content_head" id="content_head" style="width:150px;" value="<cfif isDefined('attributes.content_head')><cfoutput>#attributes.content_head#</cfoutput></cfif>" >
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_content_relation&content=form.content_id&content_name=form.content_head&select_list=1&is_form_submitted=1','list');"></span>
                    					</div>									
									</div>
								</div>
							</div>
               			</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<input type="hidden" name="form_submit" id="form_submit" value="1">
							<label><cf_get_lang dictionary_id='39622.Detaylı Dök'>
								<input type="checkbox" name="detayli_dok" id="detayli_dok" value="1" <cfif isdefined("attributes.detayli_dok")>checked</cfif>>
							</label>
							<cf_wrk_report_search_button button_type='1' is_excel="1">  
						</div>
					</div>
				</div>
			</div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_read_list" datasource="#dsn#">
		SELECT 
		DISTINCT
			<cfif not isdefined("attributes.detayli_dok")>
				MAX(READ_DATE) AS MAX_READ,
				COUNT(C.CONTENT_ID) AS KAC_KEZ,
			<cfelse>
				CF.READ_DATE,
			</cfif>
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			CCH.CHAPTER,
			CC.CONTENTCAT,
			C.CONTENT_ID,
			C.CONT_HEAD
		FROM
			CONTENT_FOLLOWS CF,
			CONTENT C,
			EMPLOYEES E,
			CONTENT_CHAPTER CCH,
			CONTENT_CAT CC
		WHERE
			E.EMPLOYEE_ID = CF.EMPLOYEE_ID AND
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				E.EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif len(attributes.content_id) and len(attributes.content_head)>
				C.CONTENT_ID = #attributes.content_id# AND
			</cfif>
			C.CHAPTER_ID = CCH.CHAPTER_ID AND
			CF.CONTENT_ID = C.CONTENT_ID AND
			CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID
		<cfif not isdefined("attributes.detayli_dok")>
		GROUP BY 
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			CCH.CHAPTER,
			CC.CONTENTCAT,
			C.CONTENT_ID,			
			C.CONT_HEAD
		</cfif>
		ORDER BY
			<cfif not isdefined("attributes.detayli_dok")>C.CONT_HEAD,E.EMPLOYEE_NAME<cfelse>READ_DATE DESC</cfif>		
	</cfquery>
	
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfparam name="attributes.totalrecords" default=#get_read_list.recordcount#>
	
	<cfset url_str = 'report.content_report&employee_id=#attributes.employee_id#&employee=#attributes.employee#&search_type=#attributes.search_type#'>
	<cfif isDefined('attributes.content_id')>
		<cfset url_str = url_str&'&content_id=#attributes.content_id#&content_head=#attributes.content_head#'>
	</cfif>
	<cfif isDefined('attributes.crid') and len(attributes.crid)>
		<cfset url_str = url_str&'&crid='&attributes.crid>
	</cfif>
	
	<cfif isDefined('attributes.detayli_dok')>
		<cfset url_str = url_str&'&detayli_dok=1'>
	</cfif>
	<cf_report_list>
    	<thead>
			<tr>
				<th></th>
				<th><cf_get_lang dictionary_id ='57480.Konu'></th>
				<th width="150"><cf_get_lang dictionary_id ='40134.Okuyucu'></th>
				<th width="100"><cf_get_lang dictionary_id ='57486.Kategori'></th>
				<th width="100"><cf_get_lang dictionary_id ='57995.Bölüm'></th>
				<th width="85"><cf_get_lang dictionary_id ='40135.Okuma T'>.</th>
				<cfif not isdefined("attributes.detayli_dok")><th width="50"><cf_get_lang dictionary_id ='40136.Okuma'></th></cfif>
			</tr>
        </thead>
        <tbody>
		<cfif get_read_list.recordcount>
			<cfoutput query="get_read_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td height="20"><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#" class="tableyazi">#CONT_HEAD#</a></td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#CONTENTCAT#</td>
					<td>#CHAPTER#</td>					
					<td>
					<cfif not isdefined("attributes.detayli_dok")>
						<cfset D_DATE=date_add('h',session.ep.time_zone,MAX_READ)>
						#dateformat(D_DATE,dateformat_style)# #timeformat(D_DATE,timeformat_style)#
					<cfelse>
						<cfset D_DATE=date_add('h',session.ep.time_zone,READ_DATE)>
						#dateformat(D_DATE,dateformat_style)# #timeformat(D_DATE,timeformat_style)#
					</cfif>
					</td>
					<cfif not isdefined("attributes.detayli_dok")><td>#KAC_KEZ#</td></cfif>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="<cfif not isdefined("attributes.detayli_dok")>7<cfelse>6</cfif>"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
			</tr>
		</cfif>
        </tbody>
	</cf_report_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#&is_submit=1">
	</cfif>
</cfif>