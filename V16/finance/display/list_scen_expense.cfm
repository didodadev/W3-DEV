<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.period_type" default="">
<cfparam name="attributes.recorder" default="">
<cfparam name="attributes.is_type" default="">
<cfparam name="attributes.start_date" default="">
<!---<cfparam name="attributes.form_submitted" default="">
---><cfparam name="attributes.finish_date" default="">
<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_scen_expense.cfm">
<cfelse>
	<cfset get_scen_expense.recordcount=0 >
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_scen_expense.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows) + 1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" id="form" action="#request.self#?fuseaction=finance.list_scen_expense" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;"  placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="period_type" id="period_type" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='54515.Tekrar Tipi'></option>
                        <option value="1" <cfif attributes.period_type eq 1>selected</cfif>><cf_get_lang dictionary_id='54552.Her Hafta'></option>
                        <option value="2" <cfif attributes.period_type eq 2>selected</cfif>><cf_get_lang dictionary_id='54553.Her Ay'></option>
                        <option value="6" <cfif attributes.period_type eq 6>selected</cfif>><cf_get_lang dictionary_id='54958.Her 2 Ayda Bir'></option>
                        <option value="3" <cfif attributes.period_type eq 3>selected</cfif>><cf_get_lang dictionary_id='54554.Her 3 Ayda Bir'></option>
                        <option value="4" <cfif attributes.period_type eq 4>selected</cfif>><cf_get_lang dictionary_id='54555.Her 6 Ayda Bir'></option>
                        <option value="5" <cfif attributes.period_type eq 5>selected</cfif>><cf_get_lang dictionary_id='54550.Her Sene'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="is_type" id="is_type">
                        <option value=""><cf_get_lang dictionary_id ='54932.Harcama Tipi'></option> 
                        <option value="0" <cfif attributes.is_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58678.Gider'></option> 
                        <option value="1" <cfif attributes.is_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58677.Gelir'></option> 
                    </select>
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option> 
                        <option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option> 
                        <option value="3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option> 
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" id="start_date" placeholder="#getLang(641,'Başlangıç tarihi',58053)#" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" id="finish_date" placeholder="#getLang(288,'Bitiş Tarihi',57700)#" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows"  value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>

            </cf_box_search>
        </cfform>
    </cf_box> 
    <cf_box title="#getLang(2,'Gelir-Giderler',54388)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57655.Başlangıç T'></th>
                    <th><cf_get_lang dictionary_id='54515.Tekrar Tipi'></th>
                    <th><cf_get_lang dictionary_id='54932.Harcama Tipi'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=finance.list_scen_expense&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_scen_expense.recordcount>
                    <cfset employee_list =''>
                    <cfoutput query="get_scen_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(record_member) and not listfind(employee_list,record_member)>
                            <cfset employee_list = Listappend(employee_list,record_member)>
                        </cfif>
                    </cfoutput>
                    <cfif len (employee_list)>
                        <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
                        <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#employee_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                        <cfset employee_list = listsort(listdeleteduplicates(valuelist(get_emp_name.employee_id,',')),"numeric","ASC",",")>
                    </cfif>
                    <cfoutput query="get_scen_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="50">#get_scen_expense.currentrow#</td>
                        <td><a class="tableyazi" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=finance.list_scen_expense&event=upd&id=#period_id#');">#PERIOD_DETAIL#</a></td>
                        <td> #dateformat(START_DATE,dateformat_style)#</td>
                        <td>
                            <cfswitch expression="#get_scen_expense.PERIOD_TYPE#">
                            <cfcase value="1">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="54552.Her hafta"></cfsavecontent>
                                <cfset ptype='#message#'>
                            </cfcase>
                            <cfcase value="2">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id="54553.Her Ay"></cfsavecontent>
                                <cfset ptype='#message1#'>
                            </cfcase>
                            <cfcase value="6">
                                <cfsavecontent variable="message2"><cf_get_lang dictionary_id="54958.Her 2 Ayda Bir"></cfsavecontent>
                                <cfset ptype='#message2#'>
                            </cfcase>
                            <cfcase value="3">
                                <cfsavecontent variable="message3"><cf_get_lang dictionary_id="54554.Her 3 Ayda Bir"></cfsavecontent>
                                <cfset ptype='#message3#'>
                            </cfcase>
                            <cfcase value="4">
                                <cfsavecontent variable="message4"><cf_get_lang dictionary_id="54555.Her 6 Ayda Bir"></cfsavecontent>
                                <cfset ptype='#message4#'>
                            </cfcase>
                            <cfcase value="5">
                            <cfsavecontent variable="message5"><cf_get_lang dictionary_id="51634.Her Yıl"></cfsavecontent>
                            <cfset ptype='#message5#'>
                            </cfcase>
                            </cfswitch>
                            #ptype#(#PERIOD_REPITITION#)
                        </td>
                        <td><cfif type eq 0><cf_get_lang dictionary_id='58678.Gider'><cfelseif type eq 1><cf_get_lang dictionary_id='58677.Gelir'></cfif></td>
                        <td><cfif len(record_member)>#get_emp_name.employee_name[listfind(employee_list,get_scen_expense.record_member,',')]# #get_emp_name.employee_surname[listfind(employee_list,get_scen_expense.record_member,',')]#</cfif></td>
                        <td style="text-align:right;"><cfif len(PERIOD_VALUE)><cfset value=PERIOD_VALUE*RATE2/RATE1>#TLFormat(value)# </cfif></td>
                        <td>&nbsp;<cfif len(PERIOD_VALUE)>#session.ep.money#</cfif></td>
                        <!-- sil -->
                        <td width="15"><a onclick="openBoxDraggable('#request.self#?fuseaction=finance.list_scen_expense&event=upd&id=#period_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        <!-- sil -->
                    </tr>
                    </cfoutput>
                <cfelse>
                <tr>
                    <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif>!</td>
                </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str = "">
        <cfif isdefined("attributes.form_submitted") and len (attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.period_type)>
            <cfset url_str = "#url_str#&period_type=#attributes.period_type#">
        </cfif>
        <cfif len(attributes.is_type)>
            <cfset url_str = "#url_str#&is_type=#attributes.is_type#">
        </cfif>
        <cfif len(attributes.is_active)>
            <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
        </cfif>
        <!---<cfif len(attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        ---><cfif isdate(attributes.start_date)>
            <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
        </cfif>
        <cfif isdate(attributes.finish_date)>
            <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="finance.list_scen_expense#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
</script>
