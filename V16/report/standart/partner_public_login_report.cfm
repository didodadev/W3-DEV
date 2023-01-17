<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.in_out" default="">
<cfparam name="attributes.domain_name" default="">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih ="attributes.start_date">
<cfelse>
	<cfset attributes.start_date= date_add('d',-1,now())>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih ="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date= now()>
</cfif>
<cfif isdefined("attributes.submitted")>
	<cfquery name="get_wrk_login" datasource="#dsn#">
		<cfif isdefined("attributes.is_partner")>
			SELECT 
				CP.PARTNER_ID P_ID,
				CP.COMPANY_PARTNER_NAME P_NAME,
				CP.COMPANY_PARTNER_SURNAME P_SURNAME,
				WL.PARTNER_ID W_ID,
				WL.DOMAIN_NAME DOMAIN,
				WL.IN_OUT_TIME IN_OUT_TIME,
				WL.IN_OUT IN_OUT,
                C.FULLNAME
			FROM
				COMPANY_PARTNER CP
                	LEFT JOIN COMPANY C ON C.COMPANY_ID=CP.COMPANY_ID,
				WRK_LOGIN WL
			WHERE
				WL.PARTNER_ID = CP.PARTNER_ID AND
				<cfif isdate(attributes.start_date)>WL.IN_OUT_TIME >= #attributes.start_date# AND</cfif>
				<cfif isdate(attributes.finish_date)>WL.IN_OUT_TIME < #date_add('d',1,attributes.finish_date)# AND</cfif>
				<cfif len(attributes.domain_name)>WL.DOMAIN_NAME = '#attributes.domain_name#' AND</cfif>
				<cfif len(attributes.in_out)>WL.IN_OUT = #attributes.in_out# AND</cfif>
				WL.DOMAIN_NAME IS NOT NULL
		</cfif>
		<cfif isdefined("attributes.is_partner") and isdefined("attributes.is_public")>
		UNION
		</cfif>
		<cfif isdefined("attributes.is_public")>
			SELECT
				C.CONSUMER_ID P_ID,
				C.CONSUMER_NAME P_NAME,
				C.CONSUMER_SURNAME P_SURNAME,
				WL.CONSUMER_ID W_ID,
				WL.DOMAIN_NAME DOMAIN,
				WL.IN_OUT_TIME IN_OUT_TIME,
				WL.IN_OUT IN_OUT,
                '' FULLNAME
			FROM
				CONSUMER C,
				WRK_LOGIN WL
			WHERE
				WL.CONSUMER_ID = C.CONSUMER_ID AND
				<cfif isdate(attributes.start_date)>WL.IN_OUT_TIME >= #attributes.start_date# AND</cfif>
				<cfif isdate(attributes.finish_date)>WL.IN_OUT_TIME < #date_add('d',1,attributes.finish_date)# AND</cfif>
				<cfif len(attributes.domain_name)>WL.DOMAIN_NAME = '#attributes.domain_name#' AND</cfif>
				<cfif len(attributes.in_out)>WL.IN_OUT = #attributes.in_out# AND</cfif>
				WL.DOMAIN_NAME IS NOT NULL
		</cfif>
			ORDER BY
				IN_OUT_TIME DESC
	</cfquery>
<cfelse>
	<cfset get_wrk_login.recordcount = 0>
</cfif>
<cfquery name="get_domain" datasource="#dsn#">
	SELECT DISTINCT DOMAIN_NAME FROM WRK_LOGIN WHERE DOMAIN_NAME IS NOT NULL AND DOMAIN_NAME<>''
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_wrk_login.recordcount#">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfform name="pp_rapor" action="#request.self#?fuseaction=report.partner_public_login_report" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39563.Partner Public Giriş Çıkış Raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<input name="submitted" id="submitted" type="hidden" value="1" >   
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz!'></cfsavecontent>
													<cfinput name="start_date" maxlength="10" type="text" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="start_date">
													</span> 
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput name="finish_date" maxlength="10" type="text" value="#dateformat(attributes.finish_date,dateformat_style)#" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
												<span class="input-group-addon">
												<cf_wrk_date_image date_field="finish_date">
												</span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60781.Domain İsimleri'></label>
										<div class="col col-12">
											<select name="domain_name" id="domain_name" style="width:110px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_domain">
													<option value="#domain_name#" <cfif domain_name is attributes.domain_name>selected</cfif>>#domain_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53181.Giriş-Çıkış'></label>
											<div class="col col-12">
												<select name="in_out" id="in_out" style="width:70px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif attributes.in_out eq 1>selected</cfif>><cf_get_lang dictionary_id='57554.Giriş'></option>
													<option value="0" <cfif attributes.in_out eq 0>selected</cfif>><cf_get_lang dictionary_id='57431.Çıkış'></option>
												</select>
											</div>
									</div>
									<div class="form-group">										
										<div class="col col-12">
											<label>
												<input type="checkbox" name="is_partner" id="is_partner" value="" <cfif isdefined("attributes.is_partner")>checked</cfif>>
												<cf_get_lang dictionary_id='58885.Partner'>												
											</label>
											<label>
												<input type="checkbox" name="is_public" id="is_public" value="" <cfif isdefined("attributes.is_public")>checked</cfif>><cf_get_lang dictionary_id='39565.Public'>		
											</label>	
										</div>
									</div>
								</div>
							</div>														
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">						  
							<cf_wrk_report_search_button search_function='control()' insert_info='#message#' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>		
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_wrk_login.recordcount>
</cfif>

<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
</cfif>
<cfif isDefined("attributes.submitted")>	
   <cf_report_list>    
			<thead>
				<tr>
					<th>
						<cfif isdefined("attributes.is_public") and not isdefined("attributes.is_partner")><cf_get_lang dictionary_id='39565.Public'>
						<cfelseif isdefined("attributes.is_partner") and not isdefined("attributes.is_public")><cf_get_lang dictionary_id='58885.Partner'>
						<cfelse><cf_get_lang dictionary_id='58885.Partner'> - <cf_get_lang dictionary_id='39565.Public'></cfif>
					</th>
					<cfif isdefined("attributes.is_partner")>
						<th width="500"><cf_get_lang dictionary_id='39292.Üye Adı'></th>
					</cfif>
					<th width="100"><cf_get_lang dictionary_id='57892.Domain'></th>
					<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th width="90"><cf_get_lang dictionary_id='38933.Giriş - Çıkış'></th>
				</tr>
		   </thead>
				<tbody>
					<cfif get_wrk_login.recordcount>
						<cfoutput query="get_wrk_login" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
							<cfset attributes.startrow=1>
							<cfset attributes.maxrows=get_wrk_login.recordcount>
						</cfif>
						<tr>
							<td>#p_name# #p_surname#</td>
							<cfif isdefined("attributes.is_partner")>
								<td>#FULLNAME#</td>
							</cfif>
							<td width="100">#domain#</td>
							<td width="100">#dateformat(in_out_time,dateformat_style)# #timeformat(date_add('h',2,in_out_time),timeformat_style)#</td>
							<td width="90"><cfif in_out eq 1><cf_get_lang dictionary_id='57554.Giriş'><cfelse><cf_get_lang dictionary_id='57431.Çıkış'></cfif></td>
						</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="<cfif isdefined("attributes.is_partner")>7<cfelse>6</cfif>">
								<cfif isdefined("attributes.submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif>
							</td>
						</tr>
					</cfif>
				</tbody>  
   </cf_report_list>
</cfif>
	
   <cfset adres = "report.partner_public_login_report">	
		<cfif attributes.totalrecords gt attributes.maxrows>	
						<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
							<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
						</cfif>
						<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
							<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
						</cfif>
						<cfif isdefined("attributes.is_partner")>
							<cfset adres = "#adres#&is_partner=#attributes.is_partner#">
						</cfif>
						<cfif isdefined("attributes.is_public")>
							<cfset adres = "#adres#&is_public=#attributes.is_public#">
						</cfif>
						<cfif len(attributes.domain_name)>
							<cfset adres = "#adres#&domain_name=#attributes.domain_name#">
						</cfif>
						<cfif len(attributes.in_out)>
							<cfset adres = "#adres#&in_out=#attributes.in_out#">
						</cfif>
						<cfif isdefined("attributes.submitted")>
							<cfset adres = "#adres#&submitted=#attributes.submitted#" >
						</cfif>
						<cf_paging 
						    page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#adres#">
				
		</cfif>

<script>
	function control()
		{
			if(!date_check(pp_rapor.start_date,pp_rapor.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
							return false;
						}
			if(document.pp_rapor.is_public.checked!=true && document.pp_rapor.is_partner.checked!=true)
			{
				alert("<cf_get_lang dictionary_id='39566.Partner ve Public Seçeneklerinden En Az Birini Seçmelisiniz'>!");
				return false;
			}
			

			if(document.pp_rapor.is_excel.checked==false)
					{
						document.pp_rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
						return true;
					}
					else
						document.pp_rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_partner_public_login_report</cfoutput>"
					
		}
</script>

