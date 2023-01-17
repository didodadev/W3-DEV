<cfparam name="attributes.odkes" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.aylar" default="#month(now())#">
<cfparam name="attributes.end_mon" default="#month(now())#">
<cfparam name="attributes.yil" default="#year(now())#">
<cfset toplam_tutar=0>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfquery name="get_related_branches" datasource="#DSN#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL AND
		RELATED_COMPANY IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY
</cfquery>
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_tax_exceptions.cfm">
<cfelse>
	<cfset get_tax_exceptions.recordcount = 0>
</cfif>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT TAX_EXCEPTION FROM TAX_EXCEPTION
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_tax_except" method="post" name="filter_list_tax_exception">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <cfparam name="attributes.page" default="1">
                <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
                <cfparam name="attributes.totalrecords" default="#get_tax_exceptions.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57761.Hiyerarşi'></cfsavecontent>
                    <cfinput type="text" name="hierarchy" id="hierarchy" style="width:100px;" value="#attributes.hierarchy#" maxlength="50" placeholder="#message#">
                </div>
                <div class="form-group">
                    <select name="ODKES" id="ODKES" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='53615.İstisna Türü'></option>
                        <cfoutput query="get_odeneks">
                            <option value="#TAX_EXCEPTION#"<cfif attributes.odkes eq TAX_EXCEPTION> Selected</cfif>>#TAX_EXCEPTION#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="aylar" id="aylar" onchange="change_mon(this.value);">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif isdefined("attributes.aylar") and attributes.aylar eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="end_mon" id="end_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif isdefined("attributes.end_mon") and attributes.end_mon eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="yil" id="yil">
                        <cfloop from="#year(now())-1#" to="#year(now())+2#" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.yil eq i> selected</cfif>>#i#</option>
                        </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-related_company">
                        <label class="col col-12"><cf_get_lang dictionary_id="53701.İlgili Şirket"></label>
                        <div class="col col-12">
                            <select name="related_company" id="related_company">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_related_branches">
                                    <option value="#related_company#" <cfif isdefined("attributes.related_company") and attributes.related_company is '#related_company#'>selected</cfif>>#related_company#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                <option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="GET_SSK_OFFICES">
                                    <cfif len(SSK_OFFICE) and len(SSK_NO)>
                                        <option value="#GET_SSK_OFFICES.BRANCH_ID#"<cfif attributes.BRANCH_ID eq GET_SSK_OFFICES.BRANCH_ID> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-departments">
                        <label class="col col-12"><cf_get_lang dictionary_id="53549.Departmanlar"></label>
                        <div class="col col-12" id="DEPARTMENT_PLACE">
                            <select name="department_id" id="department_id" style="width:150px">
                                <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                <cfquery name="get_departmant" datasource="#dsn#">
                                    SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id# AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
                                </cfquery>
                                <cfoutput query="get_departmant">
                                    <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-collar_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='54054.Yaka Tipi'></label>
                        <div class="col col-12">
                            <select name="collar_type" id="collar_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
                                <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-position_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-12">
                            <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="GET_POSITION_CATS_">
                                    <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53085.Vergi İstisnaları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr> 
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='54265.TC No'></td>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
                    <th><cf_get_lang dictionary_id='54054.Yaka tipi'></th>
                    <th><cf_get_lang dictionary_id='53615.İstisna Türü'></th>
                    <th><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
                    <th><cf_get_lang dictionary_id="53133.bitiş ay"></th>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_tax_except&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <cfif get_tax_exceptions.recordcount>
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfset department_list = "">
                <cfset position_cat_list = "">
                <cfoutput query="get_tax_exceptions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(department_id) and not listfind(department_list,department_id)>
                        <cfset department_list=listappend(department_list,department_id)>
                    </cfif>
                    <cfif len(position_cat_id) and not listfind(position_cat_list,position_cat_id)>
                        <cfset position_cat_list=listappend(position_cat_list,position_cat_id)>
                    </cfif>
                </cfoutput>
                <cfif len(department_list)>
                    <cfset department_list=listsort(department_list,"numeric","ASC",",")>
                    <cfquery name="get_department_name" datasource="#dsn#">
                        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_list#) ORDER BY DEPARTMENT_ID
                    </cfquery>
                    <cfset department_list = listsort(listdeleteduplicates(valuelist(get_department_name.department_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(position_cat_list)>
                    <cfquery name="get_position_categories" datasource="#dsn#">
                        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#) ORDER BY POSITION_CAT_ID 
                    </cfquery>
                    <cfset position_cat_list = listsort(listdeleteduplicates(valuelist(get_position_categories.position_cat_id,',')),'numeric','ASC',',')>
                </cfif>
                <tbody>
                    <cfoutput query="get_tax_exceptions"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td align="center">#currentrow#</td>
                            <td><cf_duxi type="label" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"></td>
                            <td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#IN_OUT_ID#&empName=#UrlEncodedFormat('#EMPLOYEE#')#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#branch_name#</td>
                            <td><cfif len(department_id)>#get_department_name.department_head[listfind(department_list,department_id,',')]#</cfif></td>
                            <td><cfif len(position_cat_list)>#get_position_categories.position_cat[listfind(position_cat_list,position_cat_id,',')]#</cfif></td>
                            <td><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td>
                            <td>#tax_exception#</td>
                            <td>#listgetat(ay_list(),START_MONTH)#</td>
                            <td>#listgetat(ay_list(),FINISH_MONTH)#</td>
                            <td style="text-align:right;"><cf_duxi name='tutar' class="tableyazi" type="label" value="#TLFormat(AMOUNT)#" gdpr="7"></td>
                            <cfset toplam_tutar=toplam_tutar+AMOUNT>
                            <!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_upd_payments&id=#tax_exception_id#&is_tax_except=1','small');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></td><!-- sil -->
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td class="formbold" colspan="1"><cf_get_lang dictionary_id='57492.Toplam'></td>
                        <td colspan="10" style="text-align:right;"><cfoutput>#TLFormat(toplam_tutar)#</cfoutput></td>
                        <!-- sil --><td>&nbsp;</td><!-- sil -->
                    </tr>
                </tfoot>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="12"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </tbody>
            </cfif>
        </cf_grid_list> 
        <cfset url_str = "&keyword=#attributes.keyword#">
        <cfif len(attributes.BRANCH_ID)>
            <cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
        </cfif>
        <cfif len(attributes.hierarchy)>
            <cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
        </cfif>
        <cfif len(attributes.department_id)>
        <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
        </cfif>
        <cfif len(attributes.ODKES)>
            <cfset url_str = "#url_str#&ODKES=#attributes.ODKES#">
        </cfif>
        <cfif len(attributes.yil)>
            <cfset url_str = "#url_str#&yil=#attributes.yil#">
        </cfif>
        <cfif len(attributes.aylar)>
            <cfset url_str = "#url_str#&aylar=#attributes.aylar#">
        </cfif>
        <cfif len(attributes.end_mon)>
            <cfset url_str = "#url_str#&end_mon=#attributes.end_mon#">
        </cfif>
        <cfif isdefined('attributes.form_submit')>
            <cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif isdefined('attributes.related_company')>
            <cfset url_str = "#url_str#&related_company=#attributes.related_company#">
        </cfif>
        <cfif len(attributes.collar_type)>
            <cfset url_str = "#url_str#&collar_type=#attributes.collar_type#">
        </cfif>
        <cfif len(attributes.position_cat_id)>
            <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
        </cfif>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_tax_except#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang dictionary_id='54322.İlişkili Departmanlar'>");
		}
	}
	function kontrol()
		{
			if(document.getElementById('aylar').value <= document.getElementById('end_mon').value)
				return true;
			else
			{
				alert("<cf_get_lang dictionary_id='54323.Ay Değerlerini Kontrol Ediniz'>!");
				return false;
			}
		}
	function change_mon(i)
	{
		$('#end_mon').val(i);
	}	
</script>
