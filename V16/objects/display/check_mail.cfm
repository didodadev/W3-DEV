<cf_get_lang_set module_name="objects">
	<cfparam name="attributes.keywords" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.modal_id" default="">
	<cfparam name="attributes.mail_type" default="0">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<script type="text/javascript">
	var n  = '';
	var no = '';
	var old_names = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.names#</cfoutput>.value;
	var old_ids = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.mail_id#</cfoutput>.value;
	if(old_names != '')
		n = old_names;
	if(old_ids != '')
		no = old_ids;	
	function don(names,nos,kep)
	{
		if (extra_values.receivers.value != '')
			n = extra_values.receivers.value;
	
		if (extra_values.receivers_no.value != '')
			no = extra_values.receivers_no.value;						 
							 
		if (nos == ''){
			alert(n + " <cf_get_lang dictionary_id='32780.Kullanıcının Mail Adresi Olmadığından Listeye Eklenmedi !'>");
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.names#</cfoutput>.value  = '';
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.mail_id#</cfoutput>.value = '';
			return false;			 
		}
		if ((nos.indexOf("@") == -1) || (nos.indexOf(".") == -1) || (nos.length < 6)){
			alert("<cf_get_lang dictionary_id='32757.Girdiğiniz Mail Geçerli Değil !'>");
			return false;			
		}
							 
		if (n == '') 
			 n = nos;
		else	 
			 n  = n + ',' + nos;
		if (no == '')	 
			 no = nos;
		else	 
			 no = no + ',' + nos;		 
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.names#</cfoutput>.value  = n;
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.mail_id#</cfoutput>.value = no;
		extra_values.receivers.value = n;
		extra_values.receivers_no.value = no;
		<cfif isDefined("attributes.draggable")>loadPopupBox('extra_values' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>document.getElementById("extra_values").submit();</cfif>
		//extra_values.submit();
	}
	</script>
	<cfset url_str = "">
	<cfif isdefined("attributes.names")>
		<cfset url_str = "#url_str#&names=#attributes.names#">
	</cfif>
	<cfif isdefined("attributes.mail_id")>
		<cfset url_str = "#url_str#&mail_id=#attributes.mail_id#">
	</cfif>
	<cfif isDefined("attributes.receivers")>
		<cfset extra = "&receivers2=#attributes.receivers#&receivers2_no=#attributes.receivers_no#">
	<cfelseif isDefined("attributes.receivers2")>
		<cfset extra = "&receivers2=#attributes.receivers2#&receivers2_no=#attributes.receivers2_no#">			 
	<cfelse>
		<cfset extra = "">
	</cfif>
	
	<cfquery name="QE1" datasource="#dsn#">
		<cfif (len(attributes.keyword) gt 1) and (attributes.keywords is not 'group')>
			SELECT 
				AB_NAME,
				AB_SURNAME,
				AB_EMAIL,
				AB_COMPANY,
				AB_KEP_ADRESS
			FROM 
				ADDRESSBOOK 
			WHERE 
				(
					AB_NAME+' '+AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					<cfif attributes.mail_type eq 0>
						AB_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					<cfelse>
						AB_KEP_ADRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					</cfif>
					AB_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
				AND AB_EMAIL <> '' 
				AND IS_ACTIVE=1
			ORDER BY AB_NAME
		<cfelseif len(attributes.keywords) eq 1>
			SELECT 
				AB_NAME,
				AB_SURNAME,
				AB_EMAIL,
				AB_COMPANY,
				AB_KEP_ADRESS
			FROM 
				ADDRESSBOOK 
			WHERE 
				AB_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				
				<cfif attributes.mail_type eq 0>
					AND AB_EMAIL <> ''
				<cfelse>
					AND AB_KEP_ADRESS <> ''
				</cfif>
				AND IS_ACTIVE=1 
			ORDER BY 
				AB_NAME
		<cfelseif attributes.keywords is 'group'>
		(
			SELECT		    		     
				GROUP_ID , 
				'aaasss' AS WORKGROUP_NAME
			FROM
				USERS
			WHERE
			<cfif isdefined("SESSION.EP.USERID")>
				RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
			<cfelse>
				RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.USERID#">
			</cfif>
				OR 
				TO_ALL = 1
		)
		UNION ALL
		(
		   SELECT 
				WORKGROUP_ID AS GROUP_ID , 
				WORKGROUP_NAME		
		   FROM 
				WORK_GROUP
		)		
		<cfelse>
			SELECT 
				AB_NAME,
				AB_SURNAME,
				AB_EMAIL,
				AB_COMPANY,
				AB_KEP_ADRESS
			FROM 
				ADDRESSBOOK
			WHERE 
				AB_NAME<>'' 
				<cfif attributes.mail_type eq 0>
					AND AB_EMAIL <> ''
				<cfelse>
					AND AB_KEP_ADRESS <> ''
				</cfif>
			AND 
				IS_ACTIVE=1
			<cfif len(attributes.keyword)>
			AND
				(
					AB_NAME+' '+AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 1,DE("%"),DE(""))##attributes.keyword#%"> OR
					AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 1,DE("%"),DE(""))##attributes.keyword#%"> OR
					<cfif attributes.mail_type eq 0>
						AB_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 1,DE("%"),DE(""))##attributes.keyword#%"> OR
					<cfelse>
						AB_KEP_ADRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 1,DE("%"),DE(""))##attributes.keyword#%"> OR
					</cfif>
					AB_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 1,DE("%"),DE(""))##attributes.keyword#%">
				)
			</cfif>	
			ORDER BY 
				AB_NAME
		</cfif>
	</cfquery>
	<cfif not isNumeric(attributes.maxrows)>
		<cfset attributes.maxrows = session.ep.maxrows>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#qe1.RecordCount#">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.modal_id" default="">
	<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32440.Mail Listesi'></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_wrk_alphabet keyword ="url_str,extra"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
			<cfform name="search" method="post" action="#request.self#?fuseaction=objects.popup_check_mail&names=#attributes.names#&mail_id=#attributes.mail_id##extra#">
				<cf_box_search more="0">
					<div class="form-group">
						<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<select name = "mail_type">
							<option value = "0" <cfif attributes.mail_type eq 0>selected</cfif>><cf_get_lang dictionary_id='31109.Mail Adresi'></option>
							<option value = "1" <cfif attributes.mail_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59876.Kep Adresi'></option>
						</select>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
					</div>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://"  onclick="self.close();" title="<cf_get_lang dictionary_id='32445.Seçme İşlemi Bitti'>" alt="<cf_get_lang dictionary_id='32445.Seçme İşlemi Bitti'>"><i class="fa fa-close"></i></a>
					</div>
				</cf_box_search>
			</cfform>
			<script type="text/javascript">
				document.getElementById('searchKey').focus();
			</script>
			<cf_flat_list>
				<cfif attributes.keywords is 'group'>
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id='32441.Group'></th>
							<th width="35"><cf_get_lang dictionary_id='57509.Liste'></th>
						</tr>
					</thead>
					<tbody>
						<cfif qe1.RecordCount>
							<cfoutput query="qe1" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif workgroup_name eq 'aaasss'>
									<cfset attributes.group_id = group_id> 
									<cfinclude template="../../settings/query/get_users.cfm">
									<tr>
										<cfset nnn = "">
										<cfset mmm = "">			
										<cfif len(get_users.positions)>
											<cfset attributes.position_codes = get_users.positions>
											<cfinclude template="../../settings/query/get_users_pos.cfm">
											<cfloop query="get_users_pos">
												<cfif len(employee_email)> 
													<cfset nnn = ListAppend(nnn, "#employee_name# #employee_surname#")>
													<cfset mmm = ListAppend(mmm, "#employee_email#")>
												</cfif>
											</cfloop>
										</cfif>
										<cfif len(get_users.partners)>
											<cfset attributes.partner_ids = get_users.partners>
											<cfinclude template="../../settings/query/get_users_pars.cfm">
											<cfloop query="get_users_pars">
												<cfif len(company_partner_email)> 
													<cfset nnn = ListAppend(nnn, "#company_partner_name# #company_partner_surname#")>
													<cfset mmm = ListAppend(mmm, "#company_partner_email#")>
												</cfif>					
											</cfloop>
										</cfif>
										<cfif len(get_users.consumers)>
											<cfset attributes.consumer_ids = get_users.consumers>
											<cfinclude template="../../settings/query/get_users_cons.cfm">
											<cfloop query="get_users_cons">
												<cfif len(CONSUMER_EMAIL)> 
													<cfset nnn = ListAppend(nnn, "#consumer_name# #consumer_surname#")>
													<cfset mmm = ListAppend(mmm, "#CONSUMER_EMAIL#")>
												</cfif>					
											</cfloop>
										</cfif>		  
										<td><cfif Len(nnn)><a href="javascript://" onclick="don('#nnn#','#mmm#');">#get_users.group_name#&nbsp;</a><cfelse>#get_users.group_name#&nbsp;</cfif></td>
										<td><cfif Len(nnn)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_mail&mails=#mmm#&names=#nnn#','small')"><img src="images/report_square2.gif" border="0"></a></cfif></td>
									</tr>
								<cfelse>
									<cfset attributes.workgroup_ID = GROUP_ID> 
									<cfquery name="get_empS" datasource="#DSN#">
										SELECT 
											EMPLOYEE_POSITIONS.EMPLOYEE_ID,
											EMPLOYEE_POSITIONS.POSITION_CODE,
											EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
											EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
											EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL
										FROM 
											EMPLOYEE_POSITIONS,
											WORKGROUP_EMP_PAR
										WHERE 
											EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
											EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
											WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.workgroup_ID#
									</cfquery> 
									<cfquery name="get_PARS" datasource="#DSN#">
										SELECT 
											COMPANY_PARTNER.COMPANY_PARTNER_NAME,
											COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
											COMPANY_PARTNER.COMPANY_ID,
											COMPANY_PARTNER.PARTNER_ID,
											COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
											COMPANY.FULLNAME
										FROM 
											COMPANY_PARTNER,
											COMPANY,
											WORKGROUP_EMP_PAR
										WHERE 
											COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
											COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
											WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.workgroup_ID#
									</cfquery>
									<tr>
										<cfset nnn = "">
										<cfset mmm = "">			
										<cfloop query="get_empS">
											<cfif len(employee_email)> 
												<cfset nnn = ListAppend(nnn, "#employee_name# #employee_surname#")>
												<cfset mmm = ListAppend(mmm, "#employee_email#")>
											</cfif>
										</cfloop>
										<cfloop query="get_PARS">
											<cfif len(company_partner_email)> 
												<cfset nnn = ListAppend(nnn, "#company_partner_name# #company_partner_surname#")>
												<cfset mmm = ListAppend(mmm, "#company_partner_email#")>
											</cfif>					
										</cfloop>
										<td><cfif Len(nnn)><a href="javascript://" onclick="don('#nnn#','#mmm#');">#workgroup_name#&nbsp;</a><cfelse>#workgroup_name#&nbsp;</cfif></td>
											<td><cfif Len(nnn)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_mail&mails=#mmm#&names=#nnn#','small')"><img src="images/report_square2.gif" border="0"></a></cfif></td>
									</tr>	  
								</cfif>		
							</cfoutput>	    
						<cfelse>
							<tr>
								<td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
							</tr>
						</cfif>
					</tbody>
				<cfelse>
					<thead>
						<tr>
							<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
							<th width="125"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th><cf_get_lang dictionary_id='57574.Şirket'></th>
							<th width="200"><cf_get_lang dictionary_id='57428.E-Mail'></th>
							<th width="200"><cf_get_lang dictionary_id='59876.Kep Adresi'></th>
						</tr>
					</thead>
					<tbody>
						<cfif qe1.RecordCount>
							<cfoutput query="qe1" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
								<tr>
									<td width="35">#qe1.CurrentRow#</td>
									<td><a href="javascript://" onclick="don('#ab_name# #ab_surname#','#attributes.mail_type eq 0 ? Trim(ab_email) : Trim(AB_KEP_ADRESS)#');">#ab_name# #ab_surname#&nbsp;</a></td>
									<td>#ab_company#</td>
									<td>#ab_email#&nbsp;</td>
									<td>#AB_KEP_ADRESS#&nbsp;</td>
								</tr> 
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
							</tr>
						</cfif>
					</tbody>
				</cfif>	
			</cf_flat_list>
			<cfset rc = ''>
			<cfset rcno = ''>
			<cfif isDefined("attributes.receivers")>
				<cfset rc = attributes.receivers>
			</cfif>
			<cfif isDefined("attributes.receivers2")>   
				<cfif rc EQ ''>
					<cfset rc = attributes.receivers2>
				</cfif>
			</cfif>
			<cfif isDefined("attributes.receivers_no")>
				<cfset rcno = attributes.receivers_no>
			</cfif>
			<cfif isDefined("attributes.receivers2_no")>   
				<cfif rcno EQ ''>
					<cfset rcno = attributes.receivers2_no>
				</cfif>
			</cfif>
			<table>
				<cfform name="extra_values" id="extra_values" method="post" >
					<tr>
						<td>
							<input type="hidden" name="receivers" id="receivers" value="<cfoutput>#rc#</cfoutput>">
							<input type="hidden" name="receivers_no" id="receivers_no" value="<cfoutput>#rcno#</cfoutput>">
						</td>
					</tr>
				</cfform>
			</table>
			<cfif attributes.maxrows lt attributes.totalrecords>
				<cfif isdefined("attributes.keyword")>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
					<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
				</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_check_mail&keywords=#attributes.keywords##url_str##extra#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
	
			</cfif>
		</cf_box>
	</div>
	