<cfparam name="attributes.city" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.mem_code" default="">
<cfparam name="attributes.search_potential" default="">
<cfparam name="attributes.search_status" default=1>
<!--- <cfif fusebox.use_period eq true>
	<cfset dsn=dsn2>
<cfelse>
	<cfset dsn=dsn>
</cfif> --->
<cfquery name="GET_CITY" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_COMPANY_STAGE" datasource="#DSN#">
		SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_supplier%">
</cfquery>

<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_sales_branches.cfm">
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_company.cfm">
<cfelse>
	<cfset get_company.recordcount =0>
</cfif>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=0>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset attributes.totalrecords = get_company.recordcount>

<cf_box>
	<cfform name="form_list_company" action="#request.self#?fuseaction=crm.list_supplier" method="post">
	    <input type="hidden" name="form_submit" id="form_submit" value="1">
        <cf_box_search>
            <div class="form-group">
                <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','',62273)#">
            </div>
            <div class="form-group">
                <cfinput type="text" name="mem_code" value="#attributes.mem_code#" size="5" placeholder="#getLang('','',30707)#">
            </div>
            <div class="form-group">
                <select name="comp_cat" id="comp_cat">
                    <option value=""><cf_get_lang_main no='1739.Tüm Kategoriler'>
                    <cfoutput query="get_companycat">
                        <option value="#companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat is companycat_id> selected</cfif>>#companycat#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select name="search_potential" id="search_potential">
                    <option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                    <option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang_main no='165.Potansiyel'></option>
                    <option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang no='364.Potansiyel Değil'></option>                
                </select>
            </div>
            <div class="form-group">
                <select name="search_status" id="search_status">
                    <option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                    <option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                    <option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                </select>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
            <div class="form-group">
                <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
            </div>
        </cf_box_search>
        <cf_box_search_detail>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='59088.Tip'></label>
                    <select name="search_type" id="search_type">
                        <option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang_main no='1734.Şirketler'></option>
                        <option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang_main no='41.Şube'></label>
                    <select name="responsible_branch_id" id="responsible_branch_id">
                        <option value=""><cf_get_lang_main no='41.Şube'></option>
                        <cfoutput query="get_branchs"> 
                            <option value="#branch_id#" <cfif isdefined("attributes.responsible_branch_id") and len(attributes.responsible_branch_id) and attributes.responsible_branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                        </cfoutput> 
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang_main no='1196.Şehir'></label>
                    <select name="city" id="city">
                        <option value=""><cf_get_lang_main no='1196.Şehir'></option>
                        <cfoutput query="get_city">
                            <option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
                        </cfoutput>
                    </select>
                </div> 
            </div> 
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                <div class="form-group">
                    <label><cf_get_lang_main no='247.Satış Bölgesi'></label>
                    <select name="sales_zones" id="sales_zones">
                        <option value=""><cf_get_lang_main no='247.Satış Bölgesi'></option>
                        <cfoutput query="get_sales_zones">
                            <option value="#sz_id#" <cfif sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang_main no='496.Temsilci'></label>
                    <div class="input-group">
                        <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                        <input type="text" name="pos_code_text" id="pos_code_text" tabindex="29" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" style="width:150px;">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_list_company.pos_code&field_name=form_list_company.pos_code_text&select_list=1','list');return false"></span>
                    </div>
                </div>
                <div class="form-group">
                    <label><cf_get_lang_main no='70.Aşama'></label>
                    <select name="process_stage_type" id="process_stage_type">
                        <option value="" selected><cf_get_lang_main no='70.Aşama'></option>
                        <cfoutput query="get_company_stage">
                            <option value="#process_row_id#" <cfif isDefined("attributes.process_stage_type") and attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </cf_box_search_detail>
	</cfform>
</cf_box>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='29528.Suppliers'></cfsavecontent>
<cf_box title="#title#" uidrop="1" hide_table_column="1">
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang_main no='146.Üye No'></th>
                <th><cf_get_lang no='668.Hedef kodu'></th>
                <th><cf_get_lang no='226.Cari Hesap Kodu'></th>
                <th><cf_get_lang_main no='340.Vergi No'></th>			
                <th><cf_get_lang_main no='162.Şirket'></th>
                <th width="125"><cf_get_lang_main no='74.Kategori'></th>
                <th width="150"><cf_get_lang_main no='1714.Yönetici'></th>
                <th  nowrap="nowrap"><cf_get_lang_main no='496.Temsilci'></th>
                <th><cf_get_lang_main no='165.Potansiyel'></th>
                <th class="header_icn_text"><cf_get_lang_main no='731.İletişim'></th>
                <th width="20" class="header_icn_text"><a href="javascript://"><i class="fa fa-bank" title="<cf_get_lang_main no='41.Şube'>"></i></a></th>
                <th width="20" class="header_icn_text"><a href="javascript://"><i class="fa fa-user-circle" title="<cf_get_lang_main no='2034.Kişi'>"></i></a></th>
                <!--- finans module kullanılıyorsa ve kullanıcının finance modulunde yetkisi varsa cari hesap görülebilir--->
                <th><cf_get_lang_main no='177.Bakiye'></th>

            </tr>
        </thead>
        <tbody>
            <cfset partner_id_list =''>
            <cfset company_id_list =''>
            <cfset company_cat_id_list =''>
            <cfset pos_code_list=''>
            <cfif get_company.recordcount>
                <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(manager_partner_id) and manager_partner_id neq 0 and not listfind(partner_id_list,manager_partner_id)>
                        <cfset partner_id_list = listappend(partner_id_list,manager_partner_id)>
                    </cfif>
                    <cfif not listfind(company_id_list,company_id)>
                        <cfset company_id_list = listappend(company_id_list,company_id)>
                    </cfif>
                    <cfif not listfind(company_cat_id_list,companycat_id)>
                        <cfset company_cat_id_list = listappend(company_cat_id_list,companycat_id)>
                    </cfif>
                    <cfif len(pos_code) and not listfind(pos_code_list,pos_code)>
                        <cfset pos_code_list = listappend(pos_code_list,pos_code)>
                    </cfif>
                </cfoutput>
                <cfif len(partner_id_list)>
                    <cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_PARTNER" datasource="#DSN#">
                        SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_id_list#) ORDER BY PARTNER_ID
                    </cfquery>
                </cfif>
                <cfif get_module_user(16) and len(company_id_list) and fusebox.use_period>
                    <cfquery name="GET_BAKIYE" datasource="#DSN2#">
                        SELECT BAKIYE, COMPANY_ID FROM COMPANY_REMAINDER WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                    </cfquery>
                    <cfset company_id_list=listsort(valuelist(get_bakiye.company_id,','),"numeric","ASC",",")>
                </cfif>
                <cfif len(pos_code_list)>
                    <cfquery name="GET_POS_CODE" datasource="#DSN#">
                        SELECT
                            POSITION_CODE,
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            EMPLOYEE_ID
                        FROM
                            EMPLOYEE_POSITIONS
                        WHERE
                            POSITION_STATUS = 1 AND
                            POSITION_CODE IN (#pos_code_list#)
                    </cfquery>
                    <cfset pos_code_list=listsort(valuelist(get_pos_code.position_code,','),"numeric","ASC",",")>
                </cfif>
                <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
                    SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#company_cat_id_list#) ORDER BY COMPANYCAT_ID
                </cfquery>
                <cfset company_cat_id_list=listsort(valuelist(get_company_cat.companycat_id,','),"numeric","ASC",",")>
                <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td width="50">#member_code#</td>
                        <td>#company_id#</td>
                        <td>#ozel_kod#</td>
                        <td>#taxno#</td>
                        <td><a href="#request.self#?fuseaction=crm.form_upd_supplier&cpid=#company_id#&type=crm&iframe=1" class="tableyazi">#fullname#</a></td>
                        <td>#get_company_cat.companycat[listfind(company_cat_id_list,companycat_id,',')]# </td>
                        <td><cfif len(manager_partner_id) and manager_partner_id neq 0><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#manager_partner_id#" class="tableyazi">#get_partner.company_partner_name[listfind(partner_id_list,manager_partner_id,',')]#  #get_partner.company_partner_surname[listfind(partner_id_list,manager_partner_id,',')]#</a><cfelse><cf_get_lang no='363.Tanımlı Değil'></cfif></td>
                        <td><cfif len(pos_code)><cfset pos_list_sira=listfind(pos_code_list,pos_code,',')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_pos_code.employee_id[pos_list_sira]#','medium')" class="tableyazi">#get_pos_code.employee_name[pos_list_sira]#  #get_pos_code.employee_surname[pos_list_sira]#</a><cfelse><cf_get_lang no='363.Tanımlı Değil'></cfif></td>
                        <td><cfif ispotantial eq 1><cf_get_lang_main no='165.Potansiyel'><cfelse><cf_get_lang no='364.Potansiyel Değil'></cfif></td>
                        <td>
                            <ul class="ui-icon-list">
                                <cfif len(company_email)><li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#company_email#','list')"><i class="fa fa-envelope-o" title="Mail Olarak Yolla" border="0"></i></a></li></cfif>
                                <cfif len(company_tel1)><li><a href="javascript://"><i class="fa fa-phone" title="<cf_get_lang_main no='87.Telefon'>:#company_telcode# - #company_tel1#"></i></a></li></cfif>
                                <cfif len(company_fax)><li><a href="javascript://"><i class="fa fa-fax" title="<cf_get_lang_main no='76.Fax'>:#company_telcode# - #company_fax#" border="0"></i></a></li></cfif>
                            </ul>
                        </td>
                        <td><a href="#request.self#?fuseaction=member.form_list_company&event=addBranch&cpid=#company_id#"><i class="fa fa-bank" title="<cf_get_lang no='318.Şube Ekle'>"></i></a></td>
                        <td><a href="#request.self#?fuseaction=member.list_contact&event=add&comp_cat=#companycat_id#&compid=#company_id#"><i class="fa fa-user-circle"title="<cf_get_lang no='368.Kişi Ekle'>"></i></a></td>
                        <td  style="text-align:right;">
                            <cfif get_module_user(16) and len(company_id_list) and fusebox.use_period>
                                <cfset bakiye=get_bakiye.bakiye[listfind(company_id_list,company_id,',')]>
                                <cfif not len(bakiye)><cfset bakiye=0></cfif>#TLFormat(Abs(bakiye))# #session.ep.money#<cfif bakiye lte 0>(A)<cfelse>(B)</cfif>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            
            <cfelse>
                <tr>
                    <td colspan="13"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif attributes.totalrecords gt attributes.maxrows> 
        <cfset adres = attributes.fuseaction&"&form_submit=1">
        <cfset adres = adres&"&search_status="&attributes.search_status>
        <cfset adres = adres&"&search_potential="&attributes.search_potential>
		<cfif len(attributes.keyword)>
			<cfset adres = adres&"&keyword="&attributes.keyword>
		</cfif>
		<cfif isDefined('attributes.comp_cat') and len(attributes.comp_cat)>
			<cfset adres = adres&"&comp_cat="&attributes.comp_cat>
		</cfif>
		<cfif len(attributes.city)>
			<cfset adres = adres&"&city="&attributes.city>
		</cfif>
		<cfif len(attributes.sales_zones)>
			<cfset adres = adres&"&sales_zones="&attributes.sales_zones>
		</cfif>
		<cfif isDefined('attributes.pos_code') and len(attributes.pos_code)>
			<cfset adres = adres&"&pos_code="&attributes.pos_code>
		</cfif>
		<cfif len(attributes.pos_code_text)>
			<cfset adres = adres&"&pos_code_text="&attributes.pos_code_text>
		</cfif>
		<cfif len(attributes.mem_code)>
			<cfset adres = adres&"&mem_code="&attributes.mem_code>
		</cfif>
		<cfif isDefined('attributes.search_type') and len(attributes.search_type)>
			<cfset adres = adres&"&search_type="&attributes.search_type>
		</cfif>
		<cfif isDefined('attributes.responsible_branch_id') and len(attributes.responsible_branch_id)>
			<cfset adres = adres&"&responsible_branch_id="&attributes.responsible_branch_id>
		</cfif>
		<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
		  	<cfset adres = adres&"&process_stage_type="&attributes.process_stage_type>
        </cfif>
	    <cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
    </cfif>
</cf_box>
<script type="text/javascript">
	document.form_list_company.keyword.focus();
</script>
