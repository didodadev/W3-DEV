<cfif not isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfif arama_yapilmali eq 1>
	<cfset GET_IN_OUTS.recordcount = 0>
<cfelse>
	<cfinclude template="../ehesap/query/get_in_outs.cfm">
</cfif>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.inout_statue" default="">
<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_in_outs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" action="#request.self#?fuseaction=hr.list_fire" method="post">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="hierarchy" id="hierarchy" placeholder="#getlang(377,'Özel Kod',57789)#" style="width:100px;" value="#attributes.hierarchy#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="inout_statue" id="inout_statue">
                        <option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
                        <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                        <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                    </select>                    
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">                    
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button search_function="date_check(startdate,finishdate,'#message_date#')" button_type="4"> 
                    <cf_workcube_file_action pdf='0' mail='0' doc='1' print='0'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="get_our_comp_and_branchs">
                                    <option value="#BRANCH_ID#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id ='58053.başlangıç tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>
                                <cfif isdefined('attributes.startdate') and isdate(attributes.STARTDATE)>
                                    <cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
                                <cfelse>
                                    <cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57700.bitiş tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                                <cfif isdefined("attributes.finishdate") and isdate(attributes.FINISHDATE)>
                                    <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                <cfelse>
                                    <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>                    
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(1315,'İşe Giriş Çıkışlar',56400)#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='55550.Gerekçe'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
                    <th><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
                    <th><cf_get_lang dictionary_id='55751.Kıdem Tazminatı'></th>
                    <th><cf_get_lang dictionary_id='55752.İhbar Tazminatı'></th>
                    <th>5084</th>
                    <th class="header_icn_none text-center"><i class="fa fa-calendar" title="<cf_get_lang dictionary_id='57627.Kayıt Tarihi'>" alt="<cf_get_lang dictionary_id='57627.Kayıt Tarihi'>"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_in_outs.recordcount>
                    <cfoutput query="get_in_outs" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <tr<cfif len(FINISH_DATE)>style="color:red;"</cfif>>
                            <td width="35">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#get_explanation_name(explanation_id)#</td>
                            <td>#branch_name#</td>
                            <td>#dateformat(START_DATE,dateformat_style)#</td>
                            <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(KIDEM_AMOUNT)#"></td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(IHBAR_AMOUNT)#"></td>
                            <td align="center"><cfif is_5084 is "1">+<cfelse>-</cfif></td>
                            <td>
                            <cfif len(update_date)>
                                #dateformat(update_date,dateformat_style)#
                            <cfelse>
                                #dateformat(record_date,dateformat_style)#
                            </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
                <cfif not get_in_outs.recordcount>
                    <tr>
                        <td colspan="10"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfset adres=attributes.fuseaction>
        <cfset adres = "#adres#&keyword=#attributes.keyword#">
        <cfset adres = "#adres#&hierarchy=#attributes.hierarchy#">
        <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
        <cfset adres = "#adres#&inout_statue=#attributes.inout_statue#">
        <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
            <cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
            <cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
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
  </script>
