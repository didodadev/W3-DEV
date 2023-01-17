<!--- bu sayfanın benzere myhome dada var yapılan değişiklikler ordada yapılsın--->
<cfparam name="is_filtered" default="0">
<cfparam name="attributes.keyword" default="">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">

<cfif is_filtered>
    <cf_date tarih="attributes.finishdate">
    <cf_date tarih="attributes.startdate">
    <cfscript>
        get_form_ = CreateObject("component","V16.hr.cfc.personal_rotation");
        get_form_.dsn = dsn;
        get_form = get_form_.list_per_form(
            finishdate : '#iif(isdefined("attributes.finishdate"),"attributes.finishdate",DE(""))#' ,
            startdate : '#iif(isdefined("attributes.startdate"),"attributes.startdate",DE(""))#' ,
            keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
            form_type : '#iif(isdefined("attributes.form_type"),"attributes.form_type",DE(""))#' 
        );
    </cfscript>
<cfelse>
	<cfset get_form.recordcount = 0>
</cfif>	

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_form.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" action="#request.self#?fuseaction=hr.list_personel_rotation_form" method="post">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">
            <cf_box_search>
                <div class="form-group">
                    <input type="text" name="keyword" placeholder="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>" maxlength="50" id="keyword" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">    
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(search_form.startdate,search_form.finishdate,'#message_date#')">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56000.Form Tipi'></label>
                        <div class="col col-12">
                            <select name="form_type" id="form_type" style="width:30mm;">
                                <option value="0"<cfif isdefined("attributes.form_type") and attributes.form_type eq 0 >selected</cfif>><cf_get_lang dictionary_id='56000.Form Tipi'></option>
                                <option value="1"<cfif isdefined("attributes.form_type") and attributes.form_type eq 1 >selected</cfif>><cf_get_lang dictionary_id='58567.Terfi'></option>
                                <option value="2"<cfif isdefined("attributes.form_type") and attributes.form_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58568.Transfer'></option>
                                <option value="3"<cfif isdefined("attributes.form_type") and attributes.form_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58569.Rotasyon'></option>
                                <option value="4"<cfif isdefined("attributes.form_type") and attributes.form_type eq 4>selected</cfif>><cf_get_lang dictionary_id='58570.Ücret Değişikliği'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-date">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.başlama girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="startdate" id="startdate" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:67px;" message="#message#" required="yes">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.bitiş girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="finishdate" id="finishdate" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:67px;" message="#message#" required="yes">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56533.Terfi-Transfer-Rotasyon Talep Formu"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1"   woc_setting = "#{ checkbox_name : 'print_form_choice', print_type : 256 }#">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='58820.Başlık'></th>
                    <th><cf_get_lang dictionary_id ='56000.Form Tipi'></th>
                    <th><cf_get_lang dictionary_id ='56534.Mevcut Kadro'></th>
                    <th><cf_get_lang dictionary_id ='56535.Talep Edilen'></th>
                    <th><cf_get_lang dictionary_id='31023.Talep Tarihi'></th>
                    <th><cf_get_lang dictionary_id ='57482.Aşama'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_personel_rotation_form&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <th class="header_icn_none text-center" nowrap="nowrap"><a href="javascript://" onClick="send_print_choice();">
                        <input type="checkbox" name="all_choice" id="all_choice" value="1" onclick="send_check_all();">
                    </th>                     
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_form.recordcount>				
                    <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#get_form.rotation_form_head#</td>
                            <td><cfif IS_RISE eq 1 ><cf_get_lang dictionary_id ='58567.Terfi'>&nbsp;</cfif>
                                <cfif IS_TRANSFER eq 1><cf_get_lang dictionary_id ='58568.Transfer'>&nbsp;</cfif>
                                <cfif IS_ROTATION eq 1><cf_get_lang dictionary_id ='58569.Rotasyon'>&nbsp;</cfif>
                                <cfif IS_SALARY_CHANGE eq 1><cf_get_lang dictionary_id ='58570.Ücret Değişikliği'></cfif></td>
                            <td>#exist_name# - #exist_pos_name#</td>
                            <td>#request_name# - #request_pos_name#</td>
                            <td>#dateFormat(record_date,dateformat_style)#</td>
                            <td>#stage#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=hr.list_personel_rotation_form&event=upd&per_rot_id=#get_form.rotation_form_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <td width="20" style="text-align:center;"><input type="checkbox" name="print_form_choice" id="print_form_choice" value="#rotation_form_id#"></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfif get_form.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif is_filtered eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>
        <cfset url_str = "">
        <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif is_filtered>
            <cfset url_str = "#url_str#&is_filtered=#attributes.is_filtered#">
        </cfif>
        <cfif isdate(attributes.startdate)>
            <cfset url_str = url_str & "&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif isdefined('attributes.form_type')>
            <cfset url_str = url_str & "&form_type=#(attributes.form_type)#">
        </cfif>
        <cfif isdate(attributes.finishdate)>
            <cfset url_str = url_str & "&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_personel_rotation_form#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
    function send_print_choice()
	{
		print_form_list = "";
		for (i=0; i < document.getElementsByName('print_form_choice').length; i++)
		{
			if(document.form_print_all.print_form_choice[i].checked == true)
			{
				print_form_list = print_form_list + document.form_print_all.print_form_choice[i].value + ',';
			}	
		}
		if(print_form_list.length == 0)
		{
			alert("<cf_get_lang dictionary_id='35384.En Az Bir Seçim Yapmalısınız'>!");
			return false;
		}
		else
		{
			return false;
		}
	}
	function send_check_all()
	{
		all_count = "<cfoutput><cfif get_form.recordcount lte attributes.maxrows>#get_form.recordcount#<cfelse>#attributes.maxrows#</cfif></cfoutput>";
		if(all_count > 1)
			for(cc=0;cc<all_count;cc++)
				document.form_print_all.print_form_choice[cc].checked = document.getElementById("all_choice").checked;
		else if(all_count == 1)
			document.getElementById('print_form_choice').checked = document.getElementById("all_choice").checked;
	}
</script>
