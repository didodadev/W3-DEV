<cf_get_lang_set module_name="finance">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.pos_cash_id" default=''>
<cfif isdefined("attributes.search_date") and isdate(attributes.search_date)>
	<cf_date tarih=attributes.search_date>
<cfelse>
	<cfset attributes.search_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')) >
</cfif>
<cfif isdefined("attributes.search_date_1") and isdate(attributes.search_date_1)>
	<cf_date tarih=attributes.search_date_1>
<cfelse>
	<cfset attributes.search_date_1 = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>
<cfquery name="GET_CASH" datasource="#dsn3#">
	SELECT
		POS_ID,
		EQUIPMENT
	FROM
		POS_EQUIPMENT
		<cfif session.ep.isBranchAuthorization>
			WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		</cfif>
	ORDER BY 
		EQUIPMENT	
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_zreport" datasource="#dsn2#">
		SELECT 
			*
		FROM 
			INVOICE
		WHERE 
			INVOICE_CAT = 69 AND
			INVOICE_DATE BETWEEN #attributes.search_date# AND #attributes.search_date_1#
		<cfif len(attributes.keyword)>
			AND INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif len(attributes.pos_cash_id)>
			AND POS_CASH_ID = #attributes.pos_cash_id#
		<cfelseif session.ep.isBranchAuthorization>
			AND POS_CASH_ID IN(SELECT POS_ID FROM #dsn3_alias#.POS_EQUIPMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)			
		</cfif>
		ORDER BY 
			INVOICE_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_zreport.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_zreport.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_daily_zreport" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" maxlength="50" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
                </div>
                <div class="form-group">
                    <select name="pos_cash_id" id="pos_cash_id" style="width:120px;">
                        <option value=""><cf_get_lang dictionary_id='57520.Kasa'></option>
                        <cfoutput query="get_cash">
                            <option value="#pos_id#" <cfif attributes.pos_cash_id eq pos_id>selected</cfif>>#equipment#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
                        <cfinput type="text" name="search_date" value="#dateformat(attributes.search_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
                    </div>
                </div>    
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="search_date_1" value="#dateformat(attributes.search_date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date_1"></span>
                    </div>
                </div>    
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='58438.Z Raporu'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='57643.KDV Toplam'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.</cfoutput>list_daily_zreport&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='170.57582'>" title="<cf_get_lang dictionary_id ='170.Ekle'>"></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.is_submitted") and get_zreport.recordcount>
                    <cfset dept_id_list=''>
                    <cfoutput query="get_zreport" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif not listfind(dept_id_list,department_id)>
                            <cfset dept_id_list=listappend(dept_id_list,department_id)>
                        </cfif>
                    </cfoutput>
                    <cfset dept_id_list=listsort(dept_id_list,"numeric")>
                    <cfif len(dept_id_list)>
                        <cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
                            SELECT 
                                BRANCH_NAME 
                            FROM 
                                BRANCH B,
                                DEPARTMENT D
                            WHERE
                                D.DEPARTMENT_ID IN (#dept_id_list#) AND
                                B.BRANCH_ID = D.BRANCH_ID
                            ORDER BY
                                DEPARTMENT_ID
                        </cfquery>
                    <cfelse>
                        <cfset get_branch_name.recordcount=0>
                    </cfif>
                <cfoutput query="get_zreport" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=#fusebox.circuit#.list_daily_zreport&event=upd&iid=#invoice_id#" class="tableyazi">#invoice_number#</a></td>
                        <td>#dateformat(invoice_date,dateformat_style)#</td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <td><cfif len(department_id) and get_branch_name.recordcount>#get_branch_name.branch_name[listfind(dept_id_list,department_id,',')]#</cfif></td>
                        <td style="text-align:right;">#TLFormat(grosstotal)# #session.ep.money#</td>
                        <td style="text-align:right;">#TLFormat(taxtotal)# #session.ep.money#</td>
                        <td style="text-align:right;">#TLFormat(nettotal)# #session.ep.money#</td>
                        <!-- sil --><td style="text-align:center;"><a href="#request.self#?fuseaction=#fusebox.circuit#.list_daily_zreport&event=upd&iid=#invoice_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td><!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_daily_zreport">
        <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
            <cfset adres = '#adres#&keyword=#attributes.keyword#'>
        </cfif>
        <cfif isDefined('attributes.search_date') and len(attributes.search_date)>
            <cfset adres = '#adres#&search_date=#dateformat(attributes.search_date,dateformat_style)#'>
        </cfif>
        <cfif isDefined('attributes.search_date_1') and len(attributes.search_date_1)>
            <cfset adres = '#adres#&search_date_1=#dateformat(attributes.search_date_1,dateformat_style)#'>
        </cfif>
        <cfif isDefined('attributes.is_submitted') and len(attributes.is_submitted)>
            <cfset adres = '#adres#&is_submitted=#attributes.is_submitted#'>
        </cfif>
        <cfif isDefined('attributes.pos_cash_id') and len(attributes.pos_cash_id)>
            <cfset adres = '#adres#&pos_cash_id=#attributes.pos_cash_id#'>
        </cfif>
        <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
    </cf_box>
</div>
	
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if ( !date_check (document.getElementById('search_date'),document.getElementById('search_date_1'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;	
		}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
