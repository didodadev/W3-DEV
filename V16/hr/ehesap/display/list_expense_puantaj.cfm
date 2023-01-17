<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.form_submitted")>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfquery name="get_puantaj" datasource="#dsn#">
		SELECT
			EPR.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.TC_IDENTY_NO,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI,
			EMPLOYEES_EXPENSE_PUANTAJ EPR
		WHERE
			EPR.EMPLOYEE_ID = E.EMPLOYEE_ID
			AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif database_type is "MSSQL">
					AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EI.TC_IDENTY_NO = '#attributes.keyword#' OR E.EMPLOYEE_NO LIKE '%#attributes.keyword#%')
				<cfelse>
					AND ((E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EI.TC_IDENTY_NO = '#attributes.keyword#' OR E.EMPLOYEE_NO LIKE '%#attributes.keyword#%')
				</cfif>
			</cfif>
			<cfif len(attributes.startdate)>
				AND EPR.EXPENSE_DATE >= #attributes.startdate# 
			</cfif>
			<cfif len(attributes.finishdate)>
				AND EPR.EXPENSE_DATE <= #attributes.finishdate# 
			</cfif>
		ORDER BY
			EPR.EXPENSE_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_puantaj.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_puantaj.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="ListExpense" action="#request.self#?fuseaction=ehesap.list_expense_puantaj" method="post">
	<cfinput type="hidden" name="form_submitted" value="1">
	<cf_big_list_search title="Harcırah Bordrosu">
		<cf_big_list_search_area>
        	<div class="row">
        		<div class="col col-12 form-inline">
                	<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        	<cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
                        </div>
		            </div>
                    <div class="form-group">
                    	<div class="input-group x-11">
                        	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
							<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
								<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
							</cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
		            </div>
                    <div class="form-group x-11">
                    	<div class="input-group">
                        	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
							<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
								<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
							</cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
		            </div>
                    <div class="form-group">
		                <div class="input-group x-3_5">
		                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		                </div>
		            </div>
                    <div class="form-group">
		            	<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
						<cf_wrk_search_button search_function="date_check(ListExpense.startdate,ListExpense.finishdate,'#message_date#')">
		            </div>
		            <div class="form-group">
		            	<cfif isdefined("x_is_import_file") and x_is_import_file eq 1>
							<cf_workcube_file_action pdf='0' mail='0' doc='1' print='0'>
						</cfif>
		            </div>
            	</div>
            </div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th>&nbsp;</th>
			<th width="40"><cf_get_lang dictionary_id='58577.Sıra'></td>
			<th width="150"><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th width="85"><cf_get_lang dictionary_id ='58025.TC Kimlik'></th>
			<th width="85"><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th width="85"><cf_get_lang dictionary_id="36455.Katsayı"></th>
			<th width="85"><cf_get_lang dictionary_id="57490.Gün"></th>
			<th width="85"><cf_get_lang dictionary_id="56257.Brüt"></th>
			<th width="85"><cf_get_lang dictionary_id="40452.Gelir Vergisi"></th>
			<th width="85"><cf_get_lang dictionary_id="41439.Damga Vergisi"></th>
			<th width="85"><cf_get_lang dictionary_id="58083.Net"></th>
			<!-- sil -->
			<th class="header_icn_none">
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_expense_puantaj&event=add" target="_blank"><img src="/images/plus_list.gif" title="Ekle"></a>
			</th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_puantaj.recordcount>
			<cfoutput query="get_puantaj" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<!-- sil -->
					<td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#expense_puantaj_id#&print_type=178','print_page','workcube_print');"><img src="/images/print2.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a></td>
					<!-- sil -->
					<td>#CURRENTROW#</td>
					<td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#IN_OUT_ID#&empName=#UrlEncodedFormat('#EMPLOYEE#')#" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#tc_identy_no#</td>
					<td>#dateformat(expense_date,dateformat_style)#</td>
					<td style="text-align:right;">#tlformat(exp_amount,6)#</td>
					<td style="text-align:right;">#expense_day#</td>
					<td style="text-align:right;">#tlformat(brut_amount)#</td>
					<td style="text-align:right;">#tlformat(gelir_vergisi)#</td>
					<td style="text-align:right;">#tlformat(damga_vergisi)#</td>
					<td style="text-align:right;">#tlformat(net_amount)#</td>
					<!-- sil -->
					<td align="center" nowrap="nowrap">
						<a href="#request.self#?fuseaction=ehesap.list_expense_puantaj&event=upd&expense_puantaj_id=#expense_puantaj_id#" target="_blank"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
					</td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="12"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres=attributes.fuseaction>
<cfset adres = "#adres#&keyword=#attributes.keyword#&form_submitted=1">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#"> 
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
