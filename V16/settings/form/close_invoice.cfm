<!--- 
	Fatura esleme ve kapatmalarin manuel olarak veya otomatik olarak kaydedilmesi islemi. ISBAK
	[ENV 2012-07-10]
 --->
<cf_get_lang_set module_name="settings">
<cfflush interval="100">
<cfparam name="attributes.date1" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.date2" default="31/12/#session.ep.period_year#">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.up_step" default="2">
<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR DESC
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_company_cat" datasource="#dsn#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		HIERARCHY		
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif not isdefined("attributes.step")>
		<cfsavecontent variable="head"><cf_get_lang dictionary_id='42454.Fatura Kapama İşlemi'></cfsavecontent>
		<cf_box title="#head#">
			<cfform name="form1_" id="form1_" method="post" action="">
				<cf_box_elements>
					<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
						<div class="form-group" id="item-is_project">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="is_project" id="is_project" value="1" <cfif isdefined('attributes.is_project')>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-is_branch">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Sube'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="is_branch" id="is_branch" value="1" <cfif isdefined('attributes.is_branch')>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-date1">	
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date1" id="date1" value="#attributes.date1#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-date2">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date2" id="date2" value="#attributes.date2#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-company_id">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
									<input type="text" name="member_name" id="member_name"  style="width:175px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'0\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,','company_id,consumer_id,employee_id','','3','250');" value="<cfif isdefined("member_name") and len(member_name)><cfoutput>#member_name#</cfoutput></cfif>" autocomplete="off">
									<cfset str_linke_ait="field_consumer=form1_.consumer_id&field_comp_id=form1_.company_id&field_member_name=form1_.member_name&field_name=form1_.member_name&field_emp_id=form1_.employee_id&select_list=1,2,3">
									<span class="input-group-addon icon-ellipsis"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&#str_linke_ait#&&keyword='+encodeURIComponent(form1_.member_name.value)</cfoutput>,'list');"><img src="/images/plus_thin.gif" border="0" align="top"></a></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-member_cat_type">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Uye Kategorisi'></label>
							<div class="col col-8 col-xs-12">
								<select name="member_cat_type" id="member_cat_type" multiple style="width:175px;height:75px;">
									<option value="1-0" <cfif listfind(attributes.member_cat_type,'1-0',',')>selected</cfif>><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></option>
									<cfoutput query="get_company_cat">
										<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
									<option value="2-0" <cfif listfind(attributes.member_cat_type,'2-0',',')>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
									<cfoutput query="get_consumer_cat">
										<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
									</cfoutput>
									<option value="3-0" <cfif listfind(attributes.member_cat_type,'3-0',',')>selected</cfif>><cf_get_lang dictionary_id='58875.Çalisanlar'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-money_type">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para birimi'></label>
							<div class="col col-8 col-xs-12">
								<select name="money_type" id="money_type" style="width:175px;">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
									<cfoutput query="get_money_rate">
										<option value="#money#"<cfif isdefined('attributes.money_type') and attributes.money_type eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>	
						<div class="form-group" id="item-source_period">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43767.Kaynak Dönem'> *</label>
							<div class="col col-8 col-xs-12">
								<select name="source_period" id="source_period" style="width:175px">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
									<cfoutput query="get_periods">
										<option value="#period_id#" <cfif isdefined("attributes.source_period") and attributes.source_period eq period_id>selected</cfif>>#period# - (#period_year#)</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-process_cat">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='175' is_detail='0'>
							</div>
						</div>
						<div class="form-group" id="item-up_step">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57692.Islem'></label>
							<div class="col col-8 col-xs-12">
								<select name="up_step" id="up_step" style="width:175px">
									<option value="1" <cfif isdefined('attributes.up_step') and attributes.up_step eq 1>selected</cfif>><cf_get_lang dictionary_id ='44108.Silme İşlemi'></option>
									<option value="2" <cfif isdefined('attributes.up_step') and attributes.up_step eq 2>selected</cfif>><cf_get_lang dictionary_id ='42495.Ekleme İşlemi'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-bank_name">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='61211.Talep veya emir varsa silinmesin'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="is_del_condition" id="is_del_condition" value="1" <cfif isdefined('attributes.is_del_condition')>checked</cfif>>
							</div>
						</div>
				</cf_box_elements>
				<div class="row formContentFooter">
					<div class="col col-9 col-xs-12 text-left">
						<label><cfoutput>#getLang(1777,'Bu İşlem Kaynak Yıla Ait Dönemde Bulunan Açık Faturaları Eşleme ve Kapama İşlemi Yapacaktır. Lütfen Sayfayı Yenilemeyiniz.',43760)#</cfoutput></label>
					</div>
					<div class="col col-3 col-xs-12 text-right">
						<label><input type="button" value="<cf_get_lang dictionary_id ='58676.Aktar'>" onClick="basamak_1();"></label>
					</div>
				</div>
			</cfform>
		</cf_box>
	</cfif>
	<cfif isdefined("attributes.source_period")>
		<cfquery name="get_source_period" datasource="#dsn#">
			SELECT PERIOD_ID,PERIOD,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.source_period#">
		</cfquery>
		<form name="form2_" id="form2_" action="<cfoutput>#request.self#?fuseaction=settings.popupflush_close_invoice</cfoutput>" method="post">
			<input type="hidden" name="step" id="step" value="<cfif isdefined('attributes.up_step')><cfoutput>#attributes.up_step#</cfoutput><cfelse>1</cfif>">
			<input type="hidden" name="aktarim_company_id" id="aktarim_company_id" value="<cfif not len(attributes.employee_id) and len(attributes.member_name)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_consumer_id" id="aktarim_consumer_id" value="<cfif len(attributes.member_name)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_employee_id" id="aktarim_employee_id" value="<cfif len(attributes.member_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_member_name" id="aktarim_member_name" value="<cfoutput>#attributes.member_name#</cfoutput>">
			<input type="hidden" name="aktarim_member_cat" id="aktarim_member_cat" value="<cfoutput>#attributes.member_cat_type#</cfoutput>">
			<input type="hidden" name="aktarim_process_stage" id="aktarim_process_stage" value="<cfoutput>#attributes.process_stage#</cfoutput>">
			<cfif isdefined('attributes.money_type') and len(attributes.money_type)><input type="hidden" name="aktarim_money_type" id="aktarim_money_type" value="<cfoutput>#attributes.money_type#</cfoutput>"></cfif>
			<cfif isdefined('attributes.is_project') and len(attributes.is_project)><input type="hidden" name="aktarim_is_project" id="aktarim_is_project" value="<cfoutput>#attributes.is_project#</cfoutput>"></cfif>
			<cfif isdefined('attributes.is_del_condition') and len(attributes.is_del_condition)><input type="hidden" name="aktarim_is_del_condition" id="aktarim_is_del_condition" value="<cfoutput>#attributes.is_del_condition#</cfoutput>"></cfif>
			<cfif isdefined('attributes.is_branch') and len(attributes.is_branch)><input type="hidden" name="aktarim_is_branch" id="aktarim_is_branch" value="<cfoutput>#attributes.is_branch#</cfoutput>"></cfif>
			<input type="hidden" name="aktarim_source_period" id="aktarim_source_period" value="<cfoutput>#get_source_period.period_id#</cfoutput>">
			<input type="hidden" name="aktarim_source_year" id="aktarim_source_year" value="<cfoutput>#get_source_period.period_year#</cfoutput>">
			<input type="hidden" name="aktarim_source_company" id="aktarim_source_company" value="<cfoutput>#get_source_period.our_company_id#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfoutput>#attributes.date1#</cfoutput>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfoutput>#attributes.date2#</cfoutput>">
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#session.ep.userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#session.ep.money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#session.ep.money2#</cfoutput>">
			<br />
			<table align="left" style="margin-left:14px;">
				<tr>
					<td>
						<cf_get_lang dictionary_id ='44011.Kaynak Veri Tabanı'>: <cfoutput>#get_source_period.period# (#get_source_period.period_year#)</cfoutput><br/>
						<cfsavecontent variable="valuemessage"><cf_get_lang dictionary_id='60155.Başlat'></cfsavecontent>
						<input type="button" value="<cfoutput>#valuemessage#</cfoutput>" onClick="basamak_2();">
					</td>
				</tr>
			</table>
		</form>
	</cfif>

	<cfif isdefined("attributes.aktarim_source_period")>
		<cfset dsn3 = '#dsn#_#attributes.aktarim_source_company#'>
		<cfset dsn2 = '#dsn#_#attributes.aktarim_source_year#_#attributes.aktarim_source_company#'>
		<cfset dsn3_alias = '#dsn#_#attributes.aktarim_source_company#'>
		<cfset dsn2_alias = '#dsn#_#attributes.aktarim_source_year#_#attributes.aktarim_source_company#'>
		<cfif isdefined('attributes.aktarim_date1') or not len(attributes.aktarim_date1)>
			<cf_date tarih='attributes.aktarim_date1'>
		</cfif>
		<cfif isdefined('attributes.aktarim_date2') or not len(attributes.aktarim_date2)>
			<cf_date tarih='attributes.aktarim_date2'>
			<cfset attributes.aktarim_date2 = dateAdd('d',1,attributes.aktarim_date2)>
		</cfif>
		
		<!--- uye kategorileri secimi yapildiysa, company ve consumer listeleri olusturulur --->
		<cfif isdefined("attributes.aktarim_member_cat") and len(attributes.aktarim_member_cat)>
			<cfset list_company = "">
			<cfset list_consumer = "">
			<cfset list_employee = "">
			<cfloop from="1" to="#listlen(attributes.aktarim_member_cat,',')#" index="ix">
				<cfset list_getir = listgetat(attributes.aktarim_member_cat,ix,',')>
				<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
					<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
				<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
					<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
				<cfelse>
					<cfset list_employee = listappend(list_employee,listlast(list_getir,'-'),'-')>
				</cfif>
				<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
				<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
				<cfset list_employee = listsort(listdeleteduplicates(replace(list_employee,"-",",","all"),','),'numeric','ASC',',')>
			</cfloop>	
		</cfif>	
		<!--- silme islemi - not:ekleme islemi yapilinca; once silme sonra ekleme yapacagindan silme islemi ortak olarak yapilir  --->
		<br/><b><cf_get_lang dictionary_id='61194.Birinci Belirlenen Tarih Aralığındaki Kapanmış Belgelerin Silinmesi'></b><br/>
		<cfquery name="get_closed_documents" datasource="#dsn2#">
			SELECT 
				CLOSED_ID 
			FROM
				CARI_CLOSED
			WHERE
				IS_CLOSED = 1
				AND PAPER_ACTION_DATE >= #attributes.aktarim_date1#
				AND PAPER_ACTION_DATE <= #attributes.aktarim_date2#
				<cfif isdefined('attributes.aktarim_company_id') and len(attributes.aktarim_company_id)>
					AND COMPANY_ID = #attributes.aktarim_company_id#
				<cfelseif isdefined('attributes.aktarim_consumer_id') and len(attributes.aktarim_consumer_id)>
					AND CONSUMER_ID = #attributes.aktarim_consumer_id#
				<cfelseif isdefined('attributes.aktarim_employee_id') and len(attributes.aktarim_employee_id)>
					AND EMPLOYEE_ID = #attributes.aktarim_employee_id#
				</cfif>
				<cfif isdefined("list_company") and len(list_company)>
					AND COMPANY_ID IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#list_company#))
				</cfif>
				<cfif isdefined("list_consumer") and len(list_consumer)>
					AND CONSUMER_ID IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#list_consumer#))
				</cfif>
				<cfif isdefined("list_employee") and len(list_employee) and list_employee neq 0>
					AND EMPLOYEE_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.aktarim_is_del_condition")>
					AND  ((IS_DEMAND <> 1 OR IS_DEMAND IS NULL) AND (IS_ORDER <> 1 OR IS_ORDER IS NULL))
				</cfif>
		</cfquery>
		<cfquery name="delete_closed_row" datasource="#dsn2#">
			DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID NOT IN(SELECT CLOSED_ID FROM CARI_CLOSED)
		</cfquery>
		<cfif get_closed_documents.recordcount>
			<cfoutput query="get_closed_documents">
				<cfquery name="delete_closed" datasource="#dsn2#">
					DELETE FROM CARI_CLOSED WHERE CLOSED_ID = #closed_id#
				</cfquery>
				<cfquery name="delete_closed_row" datasource="#dsn2#">
					DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #closed_id#
				</cfquery>
			</cfoutput>
			<cfoutput>#dateformat(attributes.aktarim_date1,'dd:mm:yyyy')#-#dateformat(attributes.aktarim_date2,'dd:mm:yyyy')# tarihleri aralığındaki kapanmış belgeler silindi.<br /></cfoutput>
		<cfelse>
			<cfoutput>
				<cfif attributes.step eq 2>
					<cf_get_lang dictionary_id='44108.Silme İşlemi'> -> <cf_get_lang dictionary_id='42495.Ekleme İşlemi'>
				<cfelse>
					<cf_get_lang dictionary_id='39337.Seçilen Kriterlere Ait Kayıt Bulunamamktadır.'>
				</cfif>		
			</cfoutput>
		</cfif>
			
		<br />
		<!--- ekleme islemi --->
		<cfif attributes.step eq 2>
			<br/><b>2.<cf_get_lang dictionary_id='42454.Fatura Kapama İşlemi'></b><br />
			<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#dsn2#">
				SELECT
					COMPANY_ID,
					CONSUMER_ID,
					EMPLOYEE_ID,
					FULLNAME,
					MEMBER_CODE,
					BAKIYE,
					OTHER_MONEY
					<cfif isDefined("attributes.aktarim_is_project")>
						,PROJECT_ID
					</cfif>
					<cfif isDefined("attributes.aktarim_is_branch")>
						,BRANCH_ID
					</cfif>
				FROM
				(
					SELECT
						C.COMPANY_ID,
						'' CONSUMER_ID,
						'' EMPLOYEE_ID,
						C.FULLNAME,
						MEMBER_CODE,
						CRM.BAKIYE,
						CRM.OTHER_MONEY
						<cfif isDefined("attributes.aktarim_is_project")>
							,CRM.PROJECT_ID
						</cfif>
						<cfif isDefined("attributes.aktarim_is_branch")>
							,CRM.BRANCH_ID
						</cfif>
					FROM 
						<cfif isDefined("attributes.aktarim_is_project")>
							<cfif isDefined("attributes.aktarim_is_branch")>
								COMPANY_REMAINDER_MONEY_PROJECT_BRANCH CRM,	
							<cfelse>
								COMPANY_REMAINDER_MONEY_PROJECT CRM,
							</cfif>
						<cfelse> 
							<cfif isDefined("attributes.aktarim_is_branch")>
								COMPANY_REMAINDER_MONEY_BRANCH CRM,	
							<cfelse>
								COMPANY_REMAINDER_MONEY CRM,
							</cfif>
						</cfif>
						#dsn_alias#.COMPANY C 
					WHERE 
						C.COMPANY_ID = CRM.COMPANY_ID 
						<cfif isdefined('attributes.aktarim_company_id') and len(attributes.aktarim_company_id)>
							AND C.COMPANY_ID = #attributes.aktarim_company_id#
						</cfif>
						<cfif isdefined("list_company") and len(list_company)>
							AND C.COMPANYCAT_ID IN (#list_company#)
						</cfif>
						<cfif not(isdefined('attributes.aktarim_company_id') and len(attributes.aktarim_company_id)) and not (isdefined("list_company") and len(list_company)) and
						(
						(isdefined('attributes.aktarim_consumer_id') and len(attributes.aktarim_consumer_id)) or (isdefined("list_consumer") and len(list_consumer)) or
						(isdefined('attributes.aktarim_employee_id') and len(attributes.aktarim_employee_id)) or (isdefined("list_employee") and len(list_employee))
						)>
							AND 1 = 0
						</cfif>
						<cfif isdefined("aktarim_money_type") and len(aktarim_money_type)>
							AND CRM.OTHER_MONEY = '#attributes.aktarim_money_type#'
						</cfif>
				UNION ALL
					SELECT
						'' COMPANY_ID,
						C.CONSUMER_ID,
						'' EMPLOYEE_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
						MEMBER_CODE,
						CRM.BAKIYE,
						CRM.OTHER_MONEY
						<cfif isDefined("attributes.aktarim_is_project")>
							,CRM.PROJECT_ID
						</cfif>
						<cfif isDefined("attributes.aktarim_is_branch")>
							,CRM.BRANCH_ID
						</cfif>
					FROM 
						<cfif isDefined("attributes.aktarim_is_project")>
							<cfif isDefined("attributes.aktarim_is_branch")>
								CONSUMER_REMAINDER_MONEY_PROJECT_BRANCH CRM,	
							<cfelse>
								CONSUMER_REMAINDER_MONEY_PROJECT CRM,
							</cfif>
						<cfelse> 
							<cfif isDefined("attributes.aktarim_is_branch")>
								CONSUMER_REMAINDER_MONEY_BRANCH CRM,	
							<cfelse>
								CONSUMER_REMAINDER_MONEY CRM,
							</cfif>
						</cfif>
						#dsn_alias#.CONSUMER C
					WHERE 
						C.CONSUMER_ID = CRM.CONSUMER_ID 
						<cfif isdefined('attributes.aktarim_consumer_id') and len(attributes.aktarim_consumer_id)>
							AND C.CONSUMER_ID = #attributes.aktarim_consumer_id#
						</cfif>
						<cfif isdefined("list_consumer") and len(list_consumer)>
							AND C.CONSUMER_CAT_ID IN (#list_consumer#)
						</cfif>
						<cfif not(isdefined('attributes.aktarim_consumer_id') and len(attributes.aktarim_consumer_id)) and not (isdefined("list_consumer") and len(list_consumer))and
						(
						(isdefined('attributes.aktarim_company_id') and len(attributes.aktarim_company_id)) or (isdefined("list_company") and len(list_company)) or
						(isdefined('attributes.aktarim_employee_id') and len(attributes.aktarim_employee_id)) or (isdefined("list_employee") and len(list_employee))
						)>
							AND 1 = 0
						</cfif>
						<cfif isdefined("aktarim_money_type") and len(aktarim_money_type)>
							AND CRM.OTHER_MONEY = '#attributes.aktarim_money_type#'
						</cfif>
				UNION ALL
					SELECT
						'' COMPANY_ID,
						'' CONSUMER_ID,
						E.EMPLOYEE_ID,
						E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME FULLNAME,
						MEMBER_CODE,
						CRM.BAKIYE,
						CRM.OTHER_MONEY
						<cfif isDefined("attributes.aktarim_is_project")>
							,CRM.PROJECT_ID
						</cfif>
						<cfif isDefined("attributes.aktarim_is_branch")>
							,CRM.BRANCH_ID
						</cfif>
					FROM 
						<cfif isDefined("attributes.aktarim_is_project")>
							<cfif isDefined("attributes.aktarim_is_branch")>
								EMPLOYEE_REMAINDER_MONEY_PROJECT_BRANCH CRM,	
							<cfelse>
								EMPLOYEE_REMAINDER_MONEY_PROJECT CRM,
							</cfif>
						<cfelse> 
							<cfif isDefined("attributes.aktarim_is_branch")>
								EMPLOYEE_REMAINDER_MONEY_BRANCH CRM,	
							<cfelse>
								EMPLOYEE_REMAINDER_MONEY CRM,
							</cfif>
						</cfif>
						#dsn_alias#.EMPLOYEES E
					WHERE 
						E.EMPLOYEE_ID = CRM.EMPLOYEE_ID 
						<cfif isdefined('attributes.aktarim_employee_id') and len(attributes.aktarim_employee_id)>
							AND E.EMPLOYEE_ID = #attributes.aktarim_employee_id#
						</cfif>
						<cfif isdefined("aktarim_money_type") and len(aktarim_money_type)>
							AND CRM.OTHER_MONEY = '#attributes.aktarim_money_type#'
						</cfif>
						<cfif not(isdefined('attributes.aktarim_employee_id') and len(attributes.aktarim_employee_id)) and not (isdefined("list_employee") and len(list_employee))and
						(
						(isdefined('attributes.aktarim_company_id') and len(attributes.aktarim_company_id)) or (isdefined("list_company") and len(list_company)) or
						(isdefined('attributes.aktarim_consumer_id') and len(attributes.aktarim_consumer_id)) or (isdefined("list_consumer") and len(list_consumer))
						)>
							AND 1 = 0
						</cfif>
				)T1
				ORDER BY
					FULLNAME
			</cfquery>
			<cfoutput query="GET_COMP_REMAINDER_MAIN">
				<cfset attributes.company_id = company_id>
				<cfset attributes.consumer_id = consumer_id>
				<cfset attributes.employee_id = employee_id>
				<cfset bakiye_kontrol = bakiye >
				<cfif isDefined("attributes.aktarim_is_project")>
					<cfset project_id_info = project_id>
				</cfif>
				<cfif isDefined("attributes.aktarim_is_branch")>
					<cfset branch_id_info = branch_id>
				</cfif>
				<!--- acik islemler hesaplaniyor --->
				<cfquery name="get_open_actions" datasource="#dsn2#">
					SELECT
						*
					FROM 
					(
						SELECT
							CR.ACTION_DETAIL,
							COALESCE(CR.DUE_DATE,CR.ACTION_DATE) NEW_DATE,
							CR.ACTION_DATE,
							CR.ACTION_TABLE,
							CR.ACTION_ID,
							CR.ACTION_TYPE_ID,
							CR.ACTION_CURRENCY_ID,
							CR.PAPER_NO,
							CR.TO_CMP_ID,
							CR.FROM_CMP_ID,
							CR.TO_CONSUMER_ID,
							CR.FROM_CONSUMER_ID,
							CR.TO_EMPLOYEE_ID,
							CR.FROM_EMPLOYEE_ID,
							CR.PROJECT_ID,
							ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID) BRANCH_ID,
							CR.ACTION_VALUE CR_ACTION_VALUE,
							CR.ACTION_VALUE NEW_VALUE,
							CR.ACTION_VALUE_2 NEW_VALUE_2,
							CR.OTHER_CASH_ACT_VALUE NEW_OTHER_VALUE,
							CR.ACTION_CURRENCY_2,
							CR.OTHER_MONEY,		
							0 TOTAL_CLOSED_AMOUNT,
							CR.CARI_ACTION_ID
						FROM 
							CARI_ROWS CR
						WHERE
							CR.OTHER_MONEY = '#OTHER_MONEY#' AND
							<cfif len(company_id) and company_id neq 0>
								ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id# AND
							<cfelseif len(consumer_id) and consumer_id neq 0>
								ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id# AND
							<cfelse>
								ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id# AND
							</cfif>
							CR.ACTION_TYPE_ID NOT IN (45,46) AND
							CR.ACTION_ID NOT IN (
													SELECT 
														ICR.ACTION_ID 
													FROM 
														CARI_CLOSED_ROW ICR,
														CARI_CLOSED IC
													WHERE 
														ICR.CLOSED_ID = IC.CLOSED_ID 
														AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID <!--- PY --->
														AND ICR.CLOSED_AMOUNT IS NOT NULL
														AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
														AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
														AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
														AND CR.OTHER_MONEY = ICR.OTHER_MONEY
														<cfif len(company_id) and company_id neq 0>
															AND IC.COMPANY_ID =  ISNULL(CR.TO_CMP_ID,CR.FROM_CMP_ID)
														<cfelseif len(consumer_id) and consumer_id neq 0>
															AND IC.CONSUMER_ID =  ISNULL(CR.TO_CONSUMER_ID,CR.FROM_CONSUMER_ID)
														<cfelse>
															AND IC.EMPLOYEE_ID =  ISNULL(CR.TO_EMPLOYEE_ID,CR.FROM_EMPLOYEE_ID)
														</cfif>							
												)
							<cfif isDefined("attributes.aktarim_is_project")>
								<cfif len(project_id_info)>
									AND PROJECT_ID = #project_id_info#
								<cfelse>
									AND PROJECT_ID IS NULL	
								</cfif>
							</cfif>
							<cfif isDefined("attributes.aktarim_is_branch")>
								<cfif len(branch_id_info)>
									AND ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) = #branch_id_info#
								<cfelse>
									AND ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) IS NULL	
								</cfif>
							</cfif>
						UNION ALL
							SELECT
								CR.ACTION_DETAIL,
								COALESCE(CR.DUE_DATE,CR.ACTION_DATE) NEW_DATE,
								CR.ACTION_DATE,
								CR.ACTION_TABLE,
								CR.ACTION_ID,
								CR.ACTION_TYPE_ID,
								CR.ACTION_CURRENCY_ID,
								CR.PAPER_NO,
								CR.TO_CMP_ID,
								CR.FROM_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.FROM_CONSUMER_ID,
								CR.TO_EMPLOYEE_ID,
								CR.FROM_EMPLOYEE_ID,
								CR.PROJECT_ID,
								ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID) BRANCH_ID,
								CR.ACTION_VALUE CR_ACTION_VALUE,
								CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2) NEW_VALUE,
								CR.ACTION_VALUE_2*((CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/CR.ACTION_VALUE) NEW_VALUE_2,
								CR.OTHER_CASH_ACT_VALUE-ROUND(SUM(ICR.OTHER_CLOSED_AMOUNT),2) NEW_OTHER_VALUE,
								CR.ACTION_CURRENCY_2,
								CR.OTHER_MONEY,		
								ROUND(SUM(ICR.CLOSED_AMOUNT),2) TOTAL_CLOSED_AMOUNT,
								CR.CARI_ACTION_ID
							FROM 
								CARI_ROWS CR,
								CARI_CLOSED_ROW ICR,
								CARI_CLOSED
							WHERE		
								CR.OTHER_MONEY = '#OTHER_MONEY#' AND
								<cfif len(company_id) and company_id neq 0>
									ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id# AND
									CARI_CLOSED.COMPANY_ID = ISNULL(CR.TO_CMP_ID,CR.FROM_CMP_ID) AND 
								<cfelseif len(consumer_id) and consumer_id neq 0>
									ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id# AND
									CARI_CLOSED.CONSUMER_ID = ISNULL(CR.TO_CONSUMER_ID,CR.FROM_CONSUMER_ID) AND
								<cfelse>
									ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id# AND
									CARI_CLOSED.EMPLOYEE_ID = ISNULL(CR.TO_EMPLOYEE_ID,CR.FROM_EMPLOYEE_ID) AND
								</cfif>
								CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
								CR.ACTION_TYPE_ID NOT IN (45,46) AND
								CR.ACTION_ID = ICR.ACTION_ID AND
								CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND 
								ICR.CLOSED_AMOUNT IS NOT NULL AND
								((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
								(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
								CR.OTHER_MONEY = ICR.OTHER_MONEY
								AND CR.CARI_aCTION_ID = ICR.CARI_ACTION_ID  <!--- PY --->
								<cfif isDefined("attributes.aktarim_is_project")>
									<cfif len(project_id_info)>
										--AND CR.CARI_aCTION_ID = ICR.CARI_ACTION_ID <!--- PY --->
										AND CR.PROJECT_ID = #project_id_info#
									<cfelse>
										AND CR.PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.aktarim_is_branch")>
									<cfif len(branch_id_info)>
										AND ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) = #branch_id_info#
									<cfelse>
										AND ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) IS NULL	
									</cfif>
								</cfif>
							GROUP BY
								CR.ACTION_DETAIL,
								CR.ACTION_DATE,
								CR.ACTION_TABLE,
								CR.ACTION_ID,
								CR.ACTION_TYPE_ID,
								CR.ACTION_CURRENCY_ID,
								CR.PAPER_NO,
								CR.TO_CMP_ID,
								CR.FROM_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.FROM_CONSUMER_ID,
								CR.TO_EMPLOYEE_ID,
								CR.FROM_EMPLOYEE_ID,
								CR.PROJECT_ID,
								ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID),
								CR.ACTION_VALUE,
								CR.DUE_DATE,
								CR.OTHER_CASH_ACT_VALUE,
								CR.OTHER_MONEY,
								CR.ACTION_VALUE_2,
								CR.ACTION_CURRENCY_2,
								CR.CARI_ACTION_ID
					)T1
					WHERE
						ROUND(TOTAL_CLOSED_AMOUNT,2) <> ROUND(CR_ACTION_VALUE,2)
						AND (ROUND(CR_ACTION_VALUE,2) - ROUND(TOTAL_CLOSED_AMOUNT,2)) > 0.001
					ORDER BY
					NEW_DATE
				</cfquery>
				<cfquery name="GET_REVENUE" dbtype="query">
					SELECT 
						*
					FROM
						get_open_actions
					WHERE
						NEW_OTHER_VALUE > 0
						<cfif bakiye_kontrol gt 0>
							<cfif len(company_id) and company_id neq 0>
								AND FROM_CMP_ID = #attributes.company_id#  
							<cfelseif len(consumer_id) and consumer_id neq 0>
								AND FROM_CONSUMER_ID = #attributes.consumer_id#  
							<cfelse>
								AND FROM_EMPLOYEE_ID = #attributes.employee_id#  
							</cfif>
						<cfelse>
							<cfif len(company_id) and company_id neq 0>
								AND TO_CMP_ID = #attributes.company_id#  
							<cfelseif len(consumer_id) and consumer_id neq 0>
								AND TO_CONSUMER_ID = #attributes.consumer_id#  
							<cfelse>
								AND TO_EMPLOYEE_ID = #attributes.employee_id#  
							</cfif>
						</cfif>
						AND ACTION_DATE >= #attributes.aktarim_date1#
						AND ACTION_DATE <= #attributes.aktarim_date2#
					ORDER BY
						NEW_DATE,
						OTHER_MONEY		
				</cfquery>
				<cfquery name="GET_EXPENSE" dbtype="query">
					SELECT 
						*
					FROM
						get_open_actions
					WHERE
						NEW_OTHER_VALUE > 0
						<cfif bakiye_kontrol gt 0>
							<cfif len(company_id) and company_id neq 0>
								AND TO_CMP_ID = #attributes.company_id#  
							<cfelseif len(consumer_id) and consumer_id neq 0>
								AND TO_CONSUMER_ID = #attributes.consumer_id#  
							<cfelse>
								AND TO_EMPLOYEE_ID = #attributes.employee_id#  
							</cfif>
						<cfelse>
							<cfif len(company_id) and company_id neq 0>
								AND FROM_CMP_ID = #attributes.company_id#  
							<cfelseif len(consumer_id) and consumer_id neq 0>
								AND FROM_CONSUMER_ID = #attributes.consumer_id#  
							<cfelse>
								AND FROM_EMPLOYEE_ID = #attributes.employee_id#  
							</cfif>
						</cfif>
						AND ACTION_DATE >= #attributes.aktarim_date1#
						AND ACTION_DATE <= #attributes.aktarim_date2#
					ORDER BY
						NEW_DATE,
						OTHER_MONEY
				</cfquery>
				<cfset i_index = 0>
				<cfloop condition="i_index lt GET_EXPENSE.recordcount">
					<cfset i_index = i_index + 1>
					<cfset 'kalan_gider_#i_index#' = ''>
					<cfset 'kalan_gider_other_#i_index#' = ''>
				</cfloop>
				<cfset last_money = ''>
				<cfset toplam = 0>
				<cfset gelir_row = 0>
				<cfif get_revenue.recordcount and get_expense.recordcount> <!--- gelir ve giderlerin ikisinde birden kayit olursa kapama islemi yapacak --->
					<cfloop query="GET_REVENUE">
						<cfset gelir_row = gelir_row + 1>
						<cfif not len(last_money) or not last_money is GET_REVENUE.OTHER_MONEY> 
							<cfquery name="ADD_CARI_CLOSED" datasource="#DSN2#" result="get_cari_closed">
								INSERT INTO 
									CARI_CLOSED
								(	
									PROCESS_STAGE,
									COMPANY_ID,
									CONSUMER_ID,
									EMPLOYEE_ID,
									PROJECT_ID,
									OTHER_MONEY,
									IS_CLOSED,							
									DEBT_AMOUNT_VALUE,
									CLAIM_AMOUNT_VALUE,
									DIFFERENCE_AMOUNT_VALUE,
									ACTION_DETAIL,
									PAPER_ACTION_DATE,
									PAPER_DUE_DATE,
									PAYMETHOD_ID,
									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP
								)
								VALUES
								(
									#attributes.aktarim_process_stage#,
									<cfif len(GET_REVENUE.TO_CMP_ID)>#GET_REVENUE.TO_CMP_ID#<cfelseif len(GET_REVENUE.FROM_CMP_ID)>#GET_REVENUE.FROM_CMP_ID#<cfelse>NULL</cfif>,
									<cfif len(GET_REVENUE.TO_CONSUMER_ID)>#GET_REVENUE.TO_CONSUMER_ID#<cfelseif len(GET_REVENUE.FROM_CONSUMER_ID)>#GET_REVENUE.FROM_CONSUMER_ID#<cfelse>NULL</cfif>,
									<cfif len(GET_REVENUE.TO_EMPLOYEE_ID)>#GET_REVENUE.TO_EMPLOYEE_ID#<cfelseif len(GET_REVENUE.FROM_EMPLOYEE_ID)>#GET_REVENUE.FROM_EMPLOYEE_ID#<cfelse>NULL</cfif>,
									<cfif len(GET_REVENUE.PROJECT_ID)>#GET_REVENUE.PROJECT_ID#<cfelse>NULL</cfif>,
									'#GET_REVENUE.OTHER_MONEY#',
									1,
									0,
									0,
									0,
									'TOPLU FATURA KAPAMA ISLEMI',
									#now()#, <!--- action_date ve due_date alanlarina su anki tarih atiliyor --->
									#now()#,
									NULL,
									#session.ep.userid#,
									#now()#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
								)
							</cfquery>
							<cfset last_closed_id = get_cari_closed.IDENTITYCOL>
							<cfset last_money = GET_REVENUE.OTHER_MONEY[gelir_row]>
						</cfif>
						<cfset i_index=0>
						<cfset deger_gelir = 0>
						<cfset deger_gider = 0>
						<cfset deger_gelir_other = 0>
						<cfset deger_gider_other = 0>
						<cfset kalan_gelir = GET_REVENUE.NEW_VALUE>
						<cfset kalan_gelir_other = GET_REVENUE.NEW_OTHER_VALUE>
						<cfloop condition="i_index lt GET_EXPENSE.recordcount">
							<cfset i_index = i_index+1>
							<cfset money_gelir_other = GET_REVENUE.other_money[gelir_row]>
							<cfset money_gider_other = GET_EXPENSE.other_money[i_index]>
							<cfset tutar_gelir = GET_REVENUE.NEW_VALUE[gelir_row]>
							<cfset tutar_gelir_other = GET_REVENUE.NEW_OTHER_VALUE[gelir_row]>
							<cfif not (isdefined("kalan_gider_#i_index#") and len(evaluate("kalan_gider_#i_index#")))>
								<cfset 'kalan_gider_#i_index#' = GET_EXPENSE.NEW_VALUE[i_index]>
							</cfif>
							<cfif not (isdefined("kalan_gider_other_#i_index#") and len(evaluate("kalan_gider_other_#i_index#")))>
								<cfset 'kalan_gider_other_#i_index#' = GET_EXPENSE.NEW_OTHER_VALUE[i_index]>
							</cfif>
							<cfif kalan_gelir_other gt 0>
								<cfset fark = wrk_round(kalan_gelir_other - evaluate('kalan_gider_other_#i_index#'))>
								<cfif fark lte 0>
									<cfset deger_gelir = kalan_gelir>
									<cfset deger_gider = kalan_gelir>
									<cfset 'kalan_gider_#i_index#' = wrk_round(evaluate('kalan_gider_#i_index#') - kalan_gelir)>
									<cfset kalan_gelir = 0>
									<cfset deger_gelir_other = kalan_gelir_other>
									<cfset deger_gider_other = kalan_gelir_other>
									<cfset 'kalan_gider_other_#i_index#' = evaluate('kalan_gider_other_#i_index#') - kalan_gelir_other>
									<cfset kalan_gelir_other = 0>
								<cfelse>
									<cfset deger_gelir = evaluate('kalan_gider_#i_index#')>
									<cfset deger_gider = evaluate('kalan_gider_#i_index#')>
									<cfset kalan_gelir = kalan_gelir - evaluate('kalan_gider_#i_index#')>
									<cfset 'kalan_gider_#i_index#' = 0>
									<cfset deger_gelir_other = evaluate('kalan_gider_other_#i_index#')>
									<cfset deger_gider_other = evaluate('kalan_gider_other_#i_index#')>
									<cfset kalan_gelir_other = kalan_gelir_other - evaluate('kalan_gider_other_#i_index#')>
									<cfset 'kalan_gider_other_#i_index#' = 0>
								</cfif>
								<!--- deger_gelir_other değeri kontrol ediliyor. kur farkı sebebi ile işlem dövizi bazında borç alacağı eşit ancak TL bazında değerlermeler hesaba katılmadığı için eşit gelmiyor. SÇ id: 116992 --->
								<cfif deger_gelir lt 0><cfset deger_gelir = deger_gelir*-1></cfif>
								<cfif deger_gelir_other gt 0>
									<cfset toplam = toplam + deger_gelir>
									<cfquery name="ADD_CARI_CLOSED_ROW" datasource="#DSN2#"><!---revenue icin--->
										INSERT INTO
											CARI_CLOSED_ROW
										(
											CLOSED_ID,
											CARI_ACTION_ID,
											ACTION_ID,
											ACTION_TYPE_ID,
											ACTION_VALUE,
											CLOSED_AMOUNT,
											OTHER_CLOSED_AMOUNT,
											OTHER_MONEY,
											DUE_DATE
										)
										VALUES
										(
											#last_closed_id#,
											#GET_REVENUE.CARI_ACTION_ID[gelir_row]#,
											#GET_REVENUE.ACTION_ID[gelir_row]#,
											#GET_REVENUE.ACTION_TYPE_ID[gelir_row]#,
											#GET_REVENUE.NEW_VALUE[gelir_row]#,
											#deger_gelir#,
											#deger_gelir_other#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_gelir_other#">,
											#createOdbcDateTime(GET_REVENUE.NEW_DATE[gelir_row])# 
										)
									</cfquery>
									<cfquery name="ADD_CARI_CLOSED_ROW" datasource="#DSN2#"><!---expense icin--->
										INSERT INTO
											CARI_CLOSED_ROW
										(
											CLOSED_ID,
											CARI_ACTION_ID,
											ACTION_ID,
											ACTION_TYPE_ID,
											ACTION_VALUE,
											CLOSED_AMOUNT,
											OTHER_CLOSED_AMOUNT,
											OTHER_MONEY,
											DUE_DATE
										)
										VALUES
										(
											#last_closed_id#,
											#GET_EXPENSE.CARI_ACTION_ID[i_index]#,
											#GET_EXPENSE.ACTION_ID[i_index]#,
											#GET_EXPENSE.ACTION_TYPE_ID[i_index]#,
											#GET_EXPENSE.NEW_VALUE[i_index]#,
											#deger_gelir#,
											#deger_gelir_other#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_gider_other#">,
											#createOdbcDateTime(GET_EXPENSE.NEW_DATE[i_index])# 
										)
									</cfquery>
								</cfif>
							</cfif>
						</cfloop>
						<cf_get_lang dictionary_id='58616.Belge Numarasi'>: #GET_REVENUE.paper_no[gelir_row]#	<br>
						<cf_get_lang dictionary_id='57519.Cari Hesap'>: #GET_COMP_REMAINDER_MAIN.FULLNAME# <br>
						--------------------------------------------------------------------------- <br>
					</cfloop>
					<cfif toplam gt 0>
						<cfquery name="upd_" datasource="#dsn2#">
							UPDATE
								CARI_CLOSED
							SET
								DEBT_AMOUNT_VALUE = #toplam#,
								CLAIM_AMOUNT_VALUE = #toplam#
							WHERE
								CLOSED_ID = #last_closed_id#
						</cfquery>
					<cfelse>
						<cfquery name="upd_" datasource="#dsn2#">
							DELETE FROM
								CARI_CLOSED
							WHERE
								CLOSED_ID = #last_closed_id#
						</cfquery>
					</cfif>
				</cfif>
			</cfoutput>
			Gerçekleştirildi.
		</cfif>
	</cfif>
<script type="text/javascript">
	function basamak_1()
	{
		if(document.getElementById("date1").value =='')
		{
			alert("<cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("date2").value =='')
		{
			alert("<cf_get_lang dictionary_id ='57739.Bitis Tarihi Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("date1").value != '' && document.getElementById("date2").value != '')
			if(!date_check(document.getElementById("date1"), document.getElementById("date2"), "<cf_get_lang dictionary_id ='58862.Başlangıç Tarihi Bitis Tarihinden Buyuk Olamaz'>!"))
				return false;
		
		if(document.getElementById("source_period").value == '')
		{
			alert("<cf_get_lang dictionary_id ='44047.Kaynak Dönem Secmelisiniz'>!");
			return false;
		}
		if(document.getElementById("process_stage").value == '')
		{
			alert("<cf_get_lang dictionary_id ='58842.Lutfen Surec Seciniz'>!");
			return false;
		}
		if(confirm("<cf_get_lang dictionary_id='61195.Fatura Kapama İşlemini Çalıştıracaksınız. Emin misiniz'>?"))
			document.getElementById("form1_").submit();
		else 
			return false;
	}
	function basamak_2()
	{
		if(confirm("<cf_get_lang dictionary_id='61195.Fatura Kapama İşlemini Çalıştıracaksınız. Emin misiniz'>?"))
			document.getElementById("form2_").submit();
		else
			return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">