<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfinclude template="../ehesap/query/get_ssk_employees.cfm">
<cfparam name="attributes.totalrecords" default='#GET_SSK_EMPLOYEES.recordcount#'>
<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon, 1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
	aydaki_gun_sayisi = daysinmonth(last_month_1);
</cfscript>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
			{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			}
	</cfscript>
</cfoutput>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='61272.Gün Bilgisi Düzenle'></cfsavecontent>
<cf_box title="#head#" id="shift_div" unload_body="0" style="width:250px;position:absolute;display:none;"></cf_box>
<cfsavecontent variable="msg"><cfoutput>#listgetat(ay_list(),attributes.sal_mon)# #session.ep.period_year#</cfoutput></cfsavecontent>
<!--- <cf_medium_list_search title="#msg#"></cf_medium_list_search>  --->
<cfset colspan_=aydaki_gun_sayisi+ 3>
<cf_flat_list>
    <thead>
        <cfoutput><tr><th colspan="#colspan_#">#listgetat(ay_list(),attributes.sal_mon)# #session.ep.period_year#</th></tr></cfoutput>
        <tr>
            <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
            <th><cf_get_lang dictionary_id='33084.SSK No'></th>
            <th><cf_get_lang dictionary_id="59088.Tip"></th>
            <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                <th width="25"><cfoutput>#ccc#</cfoutput></th>
            </cfloop>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="GET_SSK_EMPLOYEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfset in_out_id_ = in_out_id>
            <cfquery name="get_rows" datasource="#dsn#">
                SELECT * FROM EMPLOYEE_DAILY_IN_OUT_SHIFT WHERE IN_OUT_ID = #in_out_id_# AND SAL_YEAR = #session.ep.period_year# AND SAL_MON = #attributes.sal_mon#
            </cfquery>
            <cfquery name="get_days" dbtype="query">
                SELECT SUM(ROW_MINUTE) AS CALISMA_DAKIKA,SAL_DAY,DAY_TYPE FROM get_rows WHERE DAY_OR_EXTRA_TIME = 0 GROUP BY SAL_DAY,DAY_TYPE
            </cfquery>
            <cfif get_days.recordcount>
                <cfloop query="get_days">
                    <cfset 'day_#get_days.SAL_DAY#_#in_out_id_#_#DAY_TYPE#' = CALISMA_DAKIKA>
                </cfloop>
            </cfif>
            <cfquery name="get_fms" dbtype="query">
                SELECT SUM(ROW_MINUTE) AS CALISMA_DAKIKA,SAL_DAY,DAY_TYPE FROM get_rows WHERE DAY_OR_EXTRA_TIME = 1 GROUP BY SAL_DAY,DAY_TYPE
            </cfquery>
            <cfif get_fms.recordcount>
                <cfloop query="get_fms">
                    <cfset 'fm_#get_fms.SAL_DAY#_#in_out_id_#_#DAY_TYPE#' = CALISMA_DAKIKA>
                </cfloop>
            </cfif>
            <tr>
                <td>#employee_name# #employee_surname#</td>
                <td>#SOCIALSECURITY_NO#</td>
                <td><cf_get_lang dictionary_id="37003.Gün Bilgisi"></td>
                <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                    <td id="ng_#in_out_id_#_#ccc#">
                    <cfset today_ = dateformat(CreateDate(session.ep.period_year,attributes.sal_mon,ccc),dateformat_style)>
                    <a href="javascript://"  onclick="get_shift_info('#in_out_id_#','#ccc#','#attributes.sal_mon#','#attributes.sal_year#','ng','0');">
                        <cfif isdefined("day_#ccc#_#in_out_id_#_")>
                            <cfset deger_ = evaluate("day_#ccc#_#in_out_id_#_")>
                            <cfset dk_ = deger_ mod 60>
                            <cfif len(dk_) eq 1>
                                <cfset dk_ = '0#dk_#'>
                            </cfif>
                            #int(deger_/60)#:#dk_#
                        <cfelseif isdefined("day_#ccc#_#in_out_id_#_0")>
                            HT
                        <cfelseif isdefined("day_#ccc#_#in_out_id_#_1")>
                            GT
                        <cfelseif isdefined("day_#ccc#_#in_out_id_#_2")>
                            GT HT
                        <cfelse>
                            -
                        </cfif>
                    </a>
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><cf_get_lang dictionary_id="36973.Normal Fazla Mesai"></td>
                <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                    <td id="ngfm_#in_out_id_#_#ccc#">
                    <a href="javascript://" onclick="get_shift_info('#in_out_id_#','#ccc#','#attributes.sal_mon#','#attributes.sal_year#','ngfm','0');">
                        <cfif isdefined("fm_#ccc#_#in_out_id_#_")>
                            <cfset deger_ = evaluate("fm_#ccc#_#in_out_id_#_")>
                            <cfset dk_ = deger_ mod 60>
                            <cfif len(dk_) eq 1>
                                <cfset dk_ = '0#dk_#'>
                            </cfif>
                            #int(deger_/60)#:#dk_#
                        <cfelse>
                            -
                        </cfif>
                    </a>
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><cf_get_lang dictionary_id="36971.Hafta Tatili Fazla Mesai"></td>
                <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                    <td id="htfm_#in_out_id_#_#ccc#">
                        <a href="javascript://" onclick="get_shift_info('#in_out_id_#','#ccc#','#attributes.sal_mon#','#attributes.sal_year#','htfm','0');">
                        <cfif isdefined("fm_#ccc#_#in_out_id_#_0")>
                            <cfset deger_ = evaluate("fm_#ccc#_#in_out_id_#_0")>
                            <cfset dk_ = deger_ mod 60>
                            <cfif len(dk_) eq 1>
                                <cfset dk_ = '0#dk_#'>
                            </cfif>
                            #int(deger_/60)#:#dk_#
                        <cfelse>
                            -
                        </cfif>
                        </a>
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><cf_get_lang dictionary_id="36970.Genel Tatil Fazla Mesai"></td>
                <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                    <td id="gtfm_#in_out_id_#_#ccc#">
                    <a href="javascript://"  onclick="get_shift_info('#in_out_id_#','#ccc#','#attributes.sal_mon#','#attributes.sal_year#','gtfm','0');">
                        <cfset dk_ = 0>
                        <cfif isdefined("fm_#ccc#_#in_out_id_#_1")>
                            <cfset dk_ = dk_ + evaluate("fm_#ccc#_#in_out_id_#_1")>
                        </cfif>
                        <cfif isdefined("fm_#ccc#_#in_out_id_#_2")>
                            <cfset dk_ = dk_ + evaluate("fm_#ccc#_#in_out_id_#_2")>
                        </cfif>
                        <cfif dk_ gt 0>
                            <cfset deger_ = dk_>
                            <cfset dk_ = deger_ mod 60>
                            <cfif len(dk_) eq 1>
                                <cfset dk_ = '0#dk_#'>
                            </cfif>
                            #int(deger_/60)#:#dk_#
                        <cfelse>
                            -
                        </cfif>
                    </a>
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><cf_get_lang dictionary_id="36990.Gece Çalışması Fazla Mesai"></td>
                <cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
                    <td id="gcfm_#in_out_id_#_#ccc#">
                        <a href="javascript://"  onclick="get_shift_info('#in_out_id_#','#ccc#','#attributes.sal_mon#','#attributes.sal_year#','gcfm','0');">
                        <cfset dk_ = 0>
                        <cfif isdefined("gcfm_#ccc#_#in_out_id_#_1")>
                            <cfset dk_ = dk_ + evaluate("gcfm_#ccc#_#in_out_id_#_1")>
                        </cfif>
                        <cfif isdefined("gcfm_#ccc#_#in_out_id_#_2")>
                            <cfset dk_ = dk_ + evaluate("gcfm_#ccc#_#in_out_id_#_2")>
                        </cfif>
                        <cfif dk_ gt 0>
                            <cfset deger_ = dk_>
                            <cfset dk_ = deger_ mod 60>
                            <cfif len(dk_) eq 1>
                                <cfset dk_ = '0#dk_#'>
                            </cfif>
                            #int(deger_/60)#:#dk_#
                        <cfelse>
                            -
                        </cfif>
                    </a>
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td style="height:1px;" colspan="#3 + aydaki_gun_sayisi#">&nbsp;</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_flat_list>
<cfset adres='hr.shift_hesapla'>
<cfif isdefined("attributes.sal_year")>
    <cfset adres = "#adres#&sal_year=#attributes.sal_year#">
</cfif>
<cfif isdefined("attributes.sal_mon")>
    <cfset adres = "#adres#&sal_mon=#attributes.sal_mon#">
</cfif>
<cfif isdefined("attributes.ssk_office")>
    <cfset adres = "#adres#&ssk_office=#attributes.ssk_office#">
</cfif>
<cfif isdefined("attributes.is_submitted")>
    <cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
</cfif>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#">
<script>
	function get_shift_info(in_out_id,gun,ay,yil,tip,upd_status)
	{
		goster(shift_div);
		adress_ = '<cfoutput>#request.self#?fuseaction=hr.get_shift_info</cfoutput>';
		adress_ += '&in_out_id=';
		adress_ += in_out_id;
		
		adress_ += '&gun=';
		adress_ += gun;
		
		adress_ += '&ay=';
		adress_ += ay;
		
		adress_ += '&yil=';
		adress_ += yil;
		
		adress_ += '&tip=';
		adress_ += tip;
		
		adress_ += '&upd_status=';
		adress_ += upd_status;
		
		td_id_ = tip + '_' + in_out_id + '_' + gun;
		
		
		left_ = document.getElementById(td_id_).offsetLeft + 30;
		top_ = document.getElementById(td_id_).offsetTop + 35;
		
		document.getElementById('shift_div').style.left = left_ + "px";
		document.getElementById('shift_div').style.top = top_ + "px";
		
		AjaxPageLoad(adress_,'body_shift_div',1);
	}
</script>
