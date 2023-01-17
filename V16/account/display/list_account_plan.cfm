<cf_xml_page_edit fuseact="account.list_account_plan">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined("attributes.is_form_exist")>
	<!---
    <cfstoredproc procedure="get_account_plan" datasource="#dsn2#">
        <cfif isdefined("is_xml_remainder")>
            <cfif is_show_remainder eq 1 >
                <cfprocparam cfsqltype="cf_sql_bit" value="1">
            <cfelse>
                <cfprocparam cfsqltype="cf_sql_bit" value="0">
            </cfif>
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_bit" value="1">
        </cfif>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
        <cfelseif isdefined("attributes.code") and len(attributes.code)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.code#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="">
        </cfif>
        <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.startrow#">
        <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.maxrows#">
        <cfprocresult name="get_acc_remainder">
    </cfstoredproc>
	--->
	<cfquery name="get_acc_remainder" datasource="#dsn2#" result="abc">
		<cfif isdefined("is_xml_remainder")>
			<cfif is_show_remainder eq 1>
				WITH CTE1 AS (
					SELECT
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_CODE2, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID,
						ACCOUNT_PLAN.SUB_ACCOUNT,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME
					FROM
						ACCOUNT_PLAN
						LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
						(
							(ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%')
							OR
							(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
						)
					WHERE
						ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
						<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
							AND ACCOUNT_PLAN.ACCOUNT_CODE   LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
							OR ACCOUNT_PLAN.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						<cfelseif isdefined("attributes.code") and len(attributes.code)>
							<cfif isNumeric(attributes.code)>
								AND ACCOUNT_PLAN.ACCOUNT_CODE  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code#%">
							<cfelse>
								AND ACCOUNT_PLAN.ACCOUNT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.code#%">
							</cfif>
						</cfif>
					GROUP BY
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_CODE2, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.SUB_ACCOUNT,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID
					),
				CTE2 AS (
						SELECT
							CTE1.*,
							ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
						FROM
							CTE1
					)
					SELECT
						CTE2.*
					FROM
						CTE2
					WHERE
						RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
			<cfelse>
				WITH CTE1 AS (
					SELECT
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_CODE2, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID,
						ACCOUNT_PLAN.SUB_ACCOUNT,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME
					FROM
						ACCOUNT_PLAN
					WHERE
						ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
						<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
							AND ACCOUNT_PLAN.ACCOUNT_CODE   LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
							OR ACCOUNT_PLAN.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						<cfelseif isdefined("attributes.code") and len(attributes.code)>
							<cfif isNumeric(attributes.code)>
								AND ACCOUNT_PLAN.ACCOUNT_CODE  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code#%">
							<cfelse>
								AND ACCOUNT_PLAN.ACCOUNT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.code#%">
							</cfif>
						</cfif>
					GROUP BY
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_CODE2, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.SUB_ACCOUNT,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID
					),
				CTE2 AS (
						SELECT
							CTE1.*,
							ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
						FROM
							CTE1
					)
					SELECT
						CTE2.*
					FROM
						CTE2
					WHERE
						RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
			</cfif>
		<cfelse>
			WITH CTE1 AS (
				SELECT
					SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
					ACCOUNT_PLAN.ACCOUNT_CODE, 
					ACCOUNT_PLAN.ACCOUNT_CODE2, 
					ACCOUNT_PLAN.ACCOUNT_NAME,
					ACCOUNT_PLAN.ACCOUNT_ID,
					ACCOUNT_PLAN.SUB_ACCOUNT,
					ACCOUNT_PLAN.IFRS_CODE, 
					ACCOUNT_PLAN.IFRS_NAME
				FROM
					ACCOUNT_PLAN
					LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
					(
						(ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%')
						OR
						(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
					)
				WHERE
					ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
					<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
						AND ACCOUNT_PLAN.ACCOUNT_CODE   LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
						OR ACCOUNT_PLAN.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					<cfelseif isdefined("attributes.code") and len(attributes.code)>
						<cfif isNumeric(attributes.code)>
							AND ACCOUNT_PLAN.ACCOUNT_CODE  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code#%">
						<cfelse>
							AND ACCOUNT_PLAN.ACCOUNT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.code#%">
						</cfif>
					</cfif>
				GROUP BY
					ACCOUNT_PLAN.ACCOUNT_CODE, 
					ACCOUNT_PLAN.ACCOUNT_CODE2, 
					ACCOUNT_PLAN.ACCOUNT_NAME,
					ACCOUNT_PLAN.SUB_ACCOUNT,
					ACCOUNT_PLAN.IFRS_CODE, 
					ACCOUNT_PLAN.IFRS_NAME,
					ACCOUNT_PLAN.ACCOUNT_ID
				),
			CTE2 AS (
					SELECT
						CTE1.*,
						ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
					FROM
						CTE1
				)
				SELECT
					CTE2.*
				FROM
					CTE2
				WHERE
					RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#get_acc_remainder.query_count#'>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=account.list_account_plan" method="post">
			<input type="hidden" name="is_form_exist" id="is_form_exist" value="1">
			<cf_box_search more="0">
				<cfif isdefined('attributes.code')>
					<cfinput type="hidden" name="code" maxlength="50" value="#attributes.code#">
				</cfif>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getlang(48,'Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a href="javascript://" class="ui-btn ui-btn-gray" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.list_account_plan&event=add</cfoutput>','medium');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>" title="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1406,'Hesaplar',58818)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<ul class="link-list">
				<cfoutput>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">0</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=1&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">1</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=2&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">2</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=3&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">3</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=4&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">4</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=5&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">5</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=6&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">6</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=7&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">7</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=8&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">8</a></li>
					<li><a href="#request.self#?fuseaction=account.list_account_plan&code=9&is_form_exist=1&maxrows=#attributes.maxrows#" class="tableyazi">9</a></li>
				</cfoutput>
			</ul>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id ='47299.Hesap Kodu'></th>
					<th><cf_get_lang dictionary_id ='47300.Hesap Adı'></th>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
					<th><cf_get_lang dictionary_id="58130.UFRS Kod"></th>
					<th><cf_get_lang dictionary_id="47551.UFRS Açıklama"></th>
					</cfif>
					<cfif is_show_remainder eq 1 >
						<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
					</cfif>
					<!-- sil -->
					<th width="20" class="text-center"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57919.Hareketler'>" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.list_account_plan&event=add</cfoutput>','medium');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>" title="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>"></i></a></th>
					<th width="20" class="text-center"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57115.Muhasebe Hareketleri'>" title="<cf_get_lang dictionary_id='57115.Muhasebe Hareketleri'>"></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_form_exist") and get_acc_remainder.recordcount >
					<cfoutput query="get_acc_remainder">
						<tr>
							<td style="mso-number-format:'\@'">
								<cfif ListLen(account_code,".") neq 1>
									<cfloop from="1" to="#ListLen(account_code,".")#" index="i"></cfloop>
								</cfif> 
								#account_code#
							</td>
							<td>#account_name#</td>
							<cfif session.ep.our_company_info.is_ifrs eq 1>
								<td>#ifrs_code#</td>
								<td>#ifrs_name#</td>
							</cfif>
							<cfif is_show_remainder eq 1>
							<td style="text-align:right;"><cfif bakiye lt 0 and len(bakiye)><font color="red">#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='29684.A'>)</font><cfelseif bakiye gt 0 and len(bakiye)>#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='58591.B'>)<cfelse>#TLFormat(0)#</cfif></td>
							</cfif>
							<!-- sil -->
							<td class="text-center">
								<cfif sub_account eq 0 or not len(sub_account)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_account_plan_rows&code=#URLEncodedFormat(get_acc_remainder.account_code)#','longpage');"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57919.Hareketler'>" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></a>
								</cfif>
							</td>
							<td class="text-center">
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.list_account_plan&event=upd&account_id=#account_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
							</td> 
							<td class="text-center">
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.list_account_plan&event=sub&account_id=#account_id#&nereden_geldi=3','medium');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>" title="<cf_get_lang dictionary_id ='47315.Alt Hesap Ekle'>"></i></a>
							</td> 
							<td class="text-center">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_account_monthly&code=#account_code#','longpage','popup_list_account_monthly');"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57115.Muhasebe Hareketler'>" title="<cf_get_lang dictionary_id='57115.Muhasebe Hareketler'>"></a>
							</td> 
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9"><cfif not isdefined("is_form_exist")><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined("is_form_exist")>
			<cfset adres = 'account.list_account_plan'>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				<cfset adres = adres&'&keyword=#attributes.keyword#'>
			</cfif>
			<cfif isdefined('attributes.code')>
				<cfset adres = adres&'&code=#attributes.code#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&is_form_exist=1">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
