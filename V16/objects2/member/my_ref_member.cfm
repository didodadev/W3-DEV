<!--- <cfinclude template="../login/send_login.cfm"> --->
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfif isdefined("session.ww")>
	<cfparam name="attributes.my_ref_keyword" default="">
	<cfparam name="attributes.conscat" default="">
		
	<cfquery name="GET_CONS_CAT" datasource="#DSN#">
		SELECT DISTINCT 
			CC.CONSCAT,
			CC.CONSCAT_ID 
		FROM 
			CONSUMER_CAT CC,
			CATEGORY_SITE_DOMAIN CSD 
		WHERE 
			CC.CONSCAT_ID = CSD.CATEGORY_ID
	</cfquery>

	<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>	
		<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
			SELECT 
				CONSUMER_REFERENCE_CODE, 
				CONSUMER_CAT_ID 
			FROM 
				CONSUMER 
				<cfif isDefined('session.ww.userid')>
					WHERE 
						CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				</cfif>
		</cfquery>
		
		<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
			SELECT 
				CAMP_ID,
				CAMP_HEAD
			FROM 
				CAMPAIGNS 
			WHERE 
				CAMP_STARTDATE <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> AND
				CAMP_FINISHDATE >= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfquery>
		<cfif get_camp_id.recordcount>
			<cfquery name="get_level" datasource="#DSN3#">
				SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
			</cfquery>
			<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
		<cfelse>
			<cfset ref_count = 0>
		</cfif>
		
		<cfquery name="GET_REF_MEMBER" datasource="#DSN#">
			SELECT 
				C.CONSUMER_ID,
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,
				C.MEMBER_CODE,
				C.REF_POS_CODE,
				CC.CONSCAT
			FROM 
				CONSUMER C,
				CONSUMER_CAT CC,
				CATEGORY_SITE_DOMAIN CSD
			WHERE
				(
					<cfif isDefined('session.ww.userid')>
						C.REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR 
					</cfif>
					(
						C.CONSUMER_REFERENCE_CODE IS NOT NULL AND
						<cfif isDefined('session.ww.userid')>
							'.'+C.CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#session.ww.userid#.%"> AND
						</cfif>
						(LEN(REPLACE(C.CONSUMER_REFERENCE_CODE,'.','..'))-LEN(C.CONSUMER_REFERENCE_CODE)+1) < = #ref_count#
					)
				) AND
				C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
				CC.CONSCAT_ID = CSD.CATEGORY_ID AND
				<cfif isDefined('session.pp.menu_id')>
					CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
				<cfelseif isDefined('session.ww.userid')>
					CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
				</cfif>
				CSD.MEMBER_TYPE = 'CONSUMER' AND
				C.CONSUMER_STATUS = 1 
				<cfif isdefined("attributes.conscat") and len(attributes.conscat)>
					AND CC.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.conscat#">
				</cfif>
				<cfif isdefined("attributes.my_ref_keyword") and len(attributes.my_ref_keyword)>
					<cfif len(attributes.my_ref_keyword) eq 1>
						AND (C.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%"> OR C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%"> OR C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%">)
					<cfelse>
						AND (C.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%"> OR C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%"> OR C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%">)
					</cfif>
				</cfif>
			ORDER BY
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME
		</cfquery>
	<cfelse>
		<cfset get_ref_member.recordcount = 0>
	</cfif>

	<cfif isdefined("session.ww.maxrows")>
		<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
	<cfelse>
		<cfparam name="attributes.maxrows" default='20'>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_ref_member.recordcount#">
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

	<cfform name="my_ref" action="" method="post">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<div class="form-row">
			<div class="form-group mb-3 col-md-2">
				<input class="form-control" type="text" name="my_ref_keyword" id="my_ref_keyword" value="<cfoutput>#attributes.my_ref_keyword#</cfoutput>" maxlength="255" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
			</div>
			<div class="form-group mb-3 col-md-2">
				<select class="form-control" name="conscat" id="conscat">
					<option value=""><cf_get_lang dictionary_id='35254.Seviye'></option>
					<cfoutput query="get_cons_cat">
						<option value="#conscat_id#" <cfif attributes.conscat eq conscat_id>selected="selected"</cfif>>#conscat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group mb-3 col-md-2">
				<cf_wrk_search_button>
			</div>
		</div>
	</cfform>

	<div class="table-responsive-lg">
        <table class="table">
            <thead class="main-bg-color">
				<tr>
					<td><cf_get_lang dictionary_id='57487.No'></td>
					<td><cf_get_lang dictionary_id='57558.Uye No'></td>
					<td><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
					<td><cf_get_lang dictionary_id='58636.Referans Uye'></td>
					<td><cf_get_lang dictionary_id='35254.Seviye'></td>
					<cfif isdefined("attributes.xml_risc_info") and attributes.xml_risc_info eq 1>
						<td><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></td>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_ref_member.recordcount>
					<cfset consumer_id_list=''>
					<cfset pos_code_list=''>
					<cfoutput query="get_ref_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset consumer_id_list = Listappend(consumer_id_list,consumer_id)>
						<cfif len(ref_pos_code) and not listfind(pos_code_list,ref_pos_code)>
							<cfset pos_code_list = Listappend(pos_code_list,ref_pos_code)>
						</cfif>
					</cfoutput>
					<cfif len(pos_code_list)>
						<cfset pos_code_list=listsort(pos_code_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#pos_code_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif isdefined("attributes.xml_risc_info") and attributes.xml_risc_info eq 1>
						<cfquery name="GET_CREDIT" datasource="#DSN#">
							SELECT OPEN_ACCOUNT_RISK_LIMIT,CONSUMER_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID IN (#consumer_id_list#)
						</cfquery>
					</cfif>
					<cfoutput query="get_ref_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
							<td align="center">#currentrow#</td>
							<td style="text-align:right;" style="padding-right:10px;">#member_code#</td>
							<td><a href="#request.self#?fuseaction=objects2.reference_detail&cid=#consumer_id#" class="tableyazi" title="Temsilci Detay">#consumer_name#&nbsp;#consumer_surname#</a></td>
							<td><cfif len(ref_pos_code)>#get_consumer.consumer_name[listfind(pos_code_list,get_ref_member.ref_pos_code,',')]# #get_consumer.consumer_surname[listfind(pos_code_list,get_ref_member.ref_pos_code,',')]#</cfif><!--- #consumer_name2#&nbsp;#consumer_surname2# ---></td>
							<td>#conscat#</td>
							<cfif isdefined("attributes.xml_risc_info") and attributes.xml_risc_info eq 1>
								<td style="text-align:right;">
									<cfquery name="GET_CREDIT_ROW" dbtype="query">
										SELECT * FROM GET_CREDIT WHERE CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ref_member.consumer_id#">
									</cfquery>
									<cfif get_credit_row.recordcount>
										#tlformat(get_credit.open_account_risk_limit)#
									</cfif>                    
								</td>
							</cfif>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr class="color-row" style="height:20px;"> 
						<td colspan="6"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang dictionary_id="57484.Kayit Yok"> !<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz"> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</table>
	</div>

	<cfif attributes.maxrows lt attributes.totalrecords> 
		<cfset url_str = "">
		<cfif isdefined("attributes.my_ref_keyword") and len(attributes.my_ref_keyword)>
			<cfset url_str = "#url_str#&my_ref_keyword=#attributes.my_ref_keyword#">
		</cfif>
		<cfif isdefined("attributes.conscat") and len(attributes.conscat)>
			<cfset url_str = "#url_str#&conscat=#attributes.conscat#">
		</cfif>
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=1">
		</cfif>
		<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:35px;">
			<tr> 
				<td> 
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="objects2.my_ref_member#url_str#"> 
				</td>
				<td  style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id="57540.Toplam Kayit">:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id="57581.Sayfa">:#attributes.page#/#lastpage#</cfoutput></td>
			</tr>
		</table>
	</cfif>
	<script type="text/javascript">
		document.getElementById('my_ref_keyword').focus();
	</script>
</cfif>