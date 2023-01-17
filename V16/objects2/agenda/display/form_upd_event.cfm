<!--- <cfdump  var="#session#" abort> --->
<!--- <cfset url.event_id = Decrypt(url.event_id,session.pp.userid,"CFMX_COMPAT","Hex")>
<cfset attributes.event_id = Decrypt(attributes.event_id,session.pp.userid,"CFMX_COMPAT","Hex")> --->
<cfinclude template="../query/get_event_cats.cfm">
<cfinclude template="../query/get_event.cfm">
<cfset action_cmp_id = session.pp.COMPANY_ID>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset get_cons.recordcount = 0>
<cfif GET_EVENT_RELATED.action_section eq "OPPORTUNITY_ID">
    <cfset opportunity = createObject('component','V16.objects2.protein.data.opportunities_data').GET_OPPORTUNITY(opp_id : GET_EVENT_RELATED.action_id)>
    <cfset action_cmp_id = (len(opportunity.company_id))?action_cmp_id&","&opportunity.company_id:action_cmp_id>
    <cfset action_cmp_id = (len(opportunity.ref_company_id))?action_cmp_id&","&opportunity.ref_company_id:action_cmp_id>
    <cfif len(opportunity.consumer_id)>
        <cfset get_cons = company_cmp.get_cons(consumer_id:opportunity.consumer_id)>
    </cfif>		
</cfif>
<cfset GET_PARTNER = company_cmp.GET_PARTS_EMPS(cpid: action_cmp_id)>
<cfquery name="get_emps"  dbtype="query">
    SELECT * FROM GET_PARTNER WHERE TYPE=2
</cfquery>
<cfquery name="get_parts"  dbtype="query">
    SELECT * FROM GET_PARTNER WHERE TYPE=1
</cfquery>
<cfset xfa.del = "objects2.emptypopup_del_event&event_id=#url.event_id#&link_id=#get_event.link_id#">

<cfif len(get_event.startdate)>
	<cfset startdate = date_add('h', session.pp.time_zone, get_event.startdate)>
<cfelse>
	<cfset startdate = "">
</cfif>
<cfif len(get_event.finishdate)>	
	<cfset finishdate = date_add('h', session.pp.time_zone, get_event.finishdate)>
<cfelse>
	<cfset finishdate = "">
</cfif>
<cfif not isdefined("session.agenda.event#url.event_id#.joins")>
  	<cfset "session.agenda.event#url.event_id#.joins" = "">
  	<cfif len(get_event.event_to_pos)>
		<cfloop list="#get_event.event_to_pos#" index="i">
			<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"emp-#i#")>
		</cfloop>
	</cfif>
	  
	<cfif len(get_event.event_to_par)>
		<cfloop list="#get_event.event_to_par#" index="i">
			<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"par-#i#")>
		</cfloop>
	</cfif>
	  
	<cfif len(get_event.event_to_con)>
		<cfloop list="#get_event.event_to_con#" index="i">
			<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"con-#i#")>
		</cfloop>
	</cfif>
	  
	<cfif len(get_event.event_to_grp)>
		<cfloop list="#get_event.event_to_grp#" index="i">
			<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"grp-#i#")>
		</cfloop>
	</cfif>
	
	<cfif len(get_event.event_to_wrkgroup)>
		<cfloop list="#get_event.event_to_wrkgroup#" index="i">
			<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"wrk-#i#")>
		</cfloop>
	</cfif>
</cfif>

<cfif not isdefined("session.agenda.event#url.event_id#.specs")>
	<cfset "session.agenda.event#url.event_id#.specs"= "">
	<cfif len(get_event.event_cc_par)>
		<cfloop list="#get_event.event_cc_par#" index="i">
			<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"par-#i#")>
		</cfloop>
	</cfif>
	<cfif len(get_event.event_cc_con)>
		<cfloop list="#get_event.event_cc_con#" index="i">
			<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"con-#i#")>
		</cfloop>
	</cfif>
	<cfif len(get_event.event_cc_grp)>
		<cfloop list="#get_event.event_cc_grp#" index="i">
			<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"grp-#i#")>
		</cfloop>
	</cfif>
	<cfif len(get_event.event_cc_pos)>
		<cfloop list="#get_event.event_cc_pos#" index="i">
			<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"emp-#i#")>
		</cfloop>
	</cfif>
	<cfif len(get_event.event_cc_wrkgroup)>
		 <cfloop list="#get_event.event_cc_wrkgroup#" index="i">
			<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"wrk-#i#")>
		</cfloop>
	</cfif>
</cfif>
<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
    SELECT
        PTR.STAGE,
        PTR.PROCESS_ROW_ID 
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.form_add_event%">
    ORDER BY 
        PTR.LINE_NUMBER
</cfquery>
<style>
    #time_zone{
        display: block;
        width: 100%;
        height: calc(1.5em + 0.75rem + 2px);
        padding: 0.375rem 0.75rem;
        font-size: 1rem;
        font-weight: 400;
        line-height: 1.5;
        color: #495057;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #ced4da;
        border-radius: 0.25rem;
        transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
    }
    .checkmark{
        background-color:#ccc;
    }
</style>
<cfquery name="CONTROL" datasource="#DSN#">
	SELECT 
		EVENT_ID
	FROM 
		EVENT_RESULT 
	WHERE	
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.event_id#">
</cfquery>
<cfform name="upd_event" method="post" <!--- action="#request.self#?fuseaction=objects2.emptypopup_upd_event" --->>
    <cfoutput>
    	<input type="hidden" name="event_id" id="event_id" value="#get_event.event_id#">
    	<input type="hidden" name="link_id" id="link_id" value="#get_event.link_id#">
  	</cfoutput>
    <div class="container">
        <div class="row">
            <div class="col-lg-12 col-xl-6">
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <select id="process_stage" name="process_stage" class="form-control">
                            <option value="0" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfoutput query="get_request_stage">
                                <option value="#process_row_id#" <cfif isdefined("get_event.event_stage") and (get_event.event_stage eq process_row_id)>selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57497.Zaman Dilimi'> *</label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <cf_wrkTimeZone>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'> *</label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <select name="eventcat_id" id="eventcat_id" class="form-control">
                            <option value="0" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfoutput query="get_event_cats">
                                <option value="#eventcat_id#" <cfif get_event.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <cfif isDefined("get_event.startdate")>
                    <div class="form-row mb-3">
                        <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label></div>
                        <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                            <cfinput type="date" name="startdate" id="startdate" class="form-control" value="#dateformat(get_event.startdate,'yyyy-mm-dd')#">
                        </div>
                        <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                            <input type="time" name="event_start_clock" class="form-control">
                        </div>
                    </div>
                <cfelse>
                    <div class="form-row mb-3">
                        <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label></div>
                        <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                            <cfinput type="date" name="startdate" id="startdate" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
                        </div>
                        <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                            <input type="time" name="event_start_clock" class="form-control">
                        </div>
                    </div>
                </cfif>
                <cfif isDefined("get_event.finishdate")>
                    <div class="form-row mb-3">
                        <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label></div>
                        <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                            <cfinput type="date" name="finishdate" id="finishdate" class="form-control" value="#dateformat(get_event.finishdate,'yyyy-mm-dd')#">
                        </div>
                        <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                            <input type="time" name="event_finish_clock" class="form-control">
                        </div>
                    </div>
                <cfelse>
                    <div class="form-row mb-3">
                        <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label></div>
                        <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                            <cfinput type="date" name="finishdate" id="finishdate" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
                        </div>
                        <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                            <input type="time" name="event_finish_clock" class="form-control">
                        </div>
                    </div>
                </cfif>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57480.Konu'> *</label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" class="form-control" name="event_head" id="event_head" value="#get_event.event_head#" required="Yes" message="#message#!">
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='36199.Açıklama'></label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <textarea name="event_detail" id="event_detail" class="form-control"><cfoutput>#get_event.event_detail#</cfoutput></textarea>
                    </div>
                </div>
                <div class="form-row mb-3" id="item-to">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cfoutput>#getLang('','',57590)#</cfoutput></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfinput name="to_emp_ids" id="to_emp_ids" value="" type="hidden">
						<cfinput name="to_par_ids" id="to_par_ids" value="" type="hidden">
						<cfinput name="to_cons_ids" id="to_cons_ids" value="" type="hidden">
						<select class="form-control" id="participants" name="participants" multiple="yes">
							<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
							<optgroup label="<cf_get_lang dictionary_id='58885.Partner'>">
								<cfoutput query="get_parts">
									<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_TO_PAR)>selected</cfif>>#name_surname#</option>
								</cfoutput>
							</optgroup>
  							<optgroup label="<cf_get_lang dictionary_id='57576.Çalışan'>">
							  	<cfoutput query="get_emps">
									<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_TO_POS)>selected</cfif>>#name_surname#</option>
								</cfoutput>
							</optgroup>
							<cfif get_cons.recordcount>
								<optgroup label="<cf_get_lang dictionary_id='57457.Müşteri'>">
									<cfoutput query="get_cons">
										<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_TO_CON)>selected</cfif>>#name_surname#</option>
									</cfoutput>
								</optgroup>
							</cfif>  
						</select>
					</div>
				</div>
                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('get_event.company_id')><cfoutput>#get_event.company_id#</cfoutput><cfelse><cfoutput>#session_base.company_id#</cfoutput></cfif>">
            </div>

            <div class="col-lg-12 col-xl-6">
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33149.Uyarı Başlat'></label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <cfif isDefined("get_event.warning_start") and len(get_event.warning_start)>
                            <cfinput type="date" name="warning_start" id="warning_start" class="form-control" value="#dateformat(get_event.warning_start,'yyyy-mm-dd')#">
                        <cfelse>
                            <cfinput type="date" name="warning_start" id="warning_start" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
                        </cfif>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='35012.E-posta Uyarı'>(<cf_get_lang dictionary_id='57490.Gün'> / <cf_get_lang dictionary_id='33151.Saat Önce'>)</label></div>
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">
                        <cfinput type="text" name="email_alert_day" id="email_alert_day" class="form-control" value="0" onKeyUp="isNumber(this);" range="0,90">
                    </div>
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">
                        <cfinput type="text" name="email_alert_hour" id="email_alert_hour" class="form-control" value="0" onKeyUp="isNumber(this);" range="0,18">
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33163.Olay Tekrar'></label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <select name="warning" id="warning" onchange="show_warn(this.selectedIndex);" class="form-control">
                            <option value="0" selected><cf_get_lang dictionary_id='58546.Yok'></option>
                            <option value="1"><cf_get_lang dictionary_id='33153.Periyodik'></option>
                        </select>
                    </div>
                </div>
                <div class="form-row mb-3" id="warn_multiple">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33154.Tekrar'></label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <input type="radio" name="warning_type" id="warning_type" value="7"> <cf_get_lang dictionary_id='33155.Haftada Bir'>
                        <input type="radio" name="warning_type" id="warning_type" value="30"> <cf_get_lang dictionary_id='33156.Ayda Bir'>
                    </div>
                </div>
                <div class="form-row mb-3" id="warn_multiple2">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33157.Tekrar Sayısı'></label></div>
                    <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='47606.Tekrar Sayısı Tam Sayı Olmalıdır'></cfsavecontent>
                        <cfinput type="text" class="form-control" name="warning_count" id="warning_count" value="" onKeyUp="isNumber(this);" maxlength="5" message="#message#!">
                    </div>
                    <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                        <cf_get_lang dictionary_id='33159.kez'>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='33164.Bu Olayı Herkes Görsün'></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <label class="checkbox-container font-weight-bold">
                            <input type="checkbox" name="view_to_all" id="view_to_all" value="1" <cfif get_event.view_to_all eq 1>checked</cfif>>
                            <span class="checkmark"></span>
                        </label>    
                    </div>
                </div>
                <div class="form-row mb-3" id="item-online">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='30015.Online'></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <label class="checkbox-container font-weight-bold">
                            <input type="checkbox" name="online" id="online" value="1" <cfif get_event.is_google_cal eq 1>checked</cfif> onclick="online_check(1)">
                            <span class="checkmark"></span>
                        </label>    
                    </div>
                </div>
                <div class="form-row mb-3" id="item-online_link">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='42371.Link'></label></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <cfif get_event.online_meet_link contains 'meet'>
                            <cfset online_link = get_event.online_meet_link>
                        <cfelse>
                            <cfset online_link = 'https://meet.google.com/' & get_event.online_meet_link>
                        </cfif>
                        <cfinput type="text" class="form-control" name="place_online" id="place_online" value="#online_link#" disabled>
                        <a href="<cfoutput>#online_link#</cfoutput>" target="_blank"><i class="fa fa-link"></i></a>
                    </div>
                </div>
                <div class="form-row mb-3" id="item-google_cal">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <label class="checkbox-container font-weight-bold">
                            <input type="checkbox" name="google_cal" id="google_cal" value="1" <cfif get_event.is_google_cal eq 1>checked</cfif> onclick="online_check(2)">
                            <span class="checkmark"></span><div id="meet_warning_text"></div>
                        </label>    
                    </div>
                </div>
                <div class="form-row mb-3" id="item-cc">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cfoutput>#getLang('','',58773)#</cfoutput></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfinput name="cc_emp_ids" id="cc_emp_ids" value="" type="hidden">
						<cfinput name="cc_par_ids" id="cc_par_ids" value="" type="hidden">
						<cfinput name="cc_cons_ids" id="cc_cons_ids" value="" type="hidden">
						<select class="form-control" id="cc" name="cc" multiple="yes">
							<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
							<optgroup label="<cf_get_lang dictionary_id='58885.Partner'>">
								<cfoutput query="get_parts">
									<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_CC_PAR)>selected</cfif>>#name_surname#</option>
								</cfoutput>
							</optgroup>
  							<optgroup label="<cf_get_lang dictionary_id='57576.Çalışan'>">
							  	<cfoutput query="get_emps">
									<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_CC_POS)>selected</cfif>>#name_surname#</option>
								</cfoutput>
							</optgroup>
							<cfif get_cons.recordcount>
								<optgroup label="<cf_get_lang dictionary_id='57457.Müşteri'>">
									<cfoutput query="get_cons">
										<option value="#ID_CE#_#TYPE#" <cfif FindNoCase(ID_CE,get_event.EVENT_CC_CON)>selected</cfif>>#name_surname#</option>
									</cfoutput>
								</optgroup>
							</cfif>  
						</select>
					</div>
				</div>
            </div>
            <!--- <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <cfset database_type="MSSQL">
                <cf_workcube_to_cc 
                    is_update="1" 
                    to_dsp_name="#getLang('','',57590)#" 
                    str_list_param="8,7,1" 
                    action_dsn="#DSN#"
                    str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                    action_table="EVENT"
                    action_id_name="EVENT_ID"
                    action_id="#attributes.EVENT_ID#"
                    data_type="1"
                    str_alias_names="">
            </div>
            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <cf_workcube_to_cc 
                is_update="1" 
                cc_dsp_name="#getLang('','',58773)#" 
                form_name="upd_event" 
                str_list_param="1,7,8" 
                action_dsn="#DSN#"
                str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                action_table="EVENT"
                action_id_name="EVENT_ID"
                action_id="#attributes.EVENT_ID#"
                data_type="1"
                str_alias_names="">
            </div> --->
            <div class="col-lg-12 col-xl-12">
                <cf_workcube_buttons
                    is_upd = "1"
                    add_function='check()'
                    data_action = "/V16/objects2/protein/data/event_data:upd_event"
                    next_page = "eventDetail?event_id="
                    del_action = '/V16/objects2/protein/data/event_data:del_event:#get_event.event_id#'
                    del_next_page = "/advisorCalendar?#iif(isdefined('attributes.emp_id') and len(attributes.emp_id),DE('emp_id=##url.emp_id##'),DE(''))#">
            </div>
        </div>
    </div>
</cfform>

<script type="text/javascript">
	function check()
	{
        if($('#participants').val().length>0){
            parts = $('#participants').val();
            var to_pars=[];
            var to_emps=[];
            var to_cons=[];
            $.each(parts, function(index, value){
                if(value.includes("_1"))
                    to_pars.push(value.split("_")[0]);
                else if(value.includes("_2"))
                    to_emps.push(value.split("_")[0]);
                else
                    to_cons.push(value.split("_")[0]);
            });
            $('#to_par_ids').val(to_pars);
            $('#to_emp_ids').val(to_emps);
            $('#to_cons_ids').val(to_cons);
        }
        if($('#cc').val().length>0){
            ccs = $('#cc').val();
            var cc_pars=[];
            var cc_emps=[];
            var cc_cons=[];
            $.each(ccs, function(index, value){
                if(value.includes("_1"))
                    cc_pars.push(value.split("_")[0]);
                else if(value.includes("_2"))   
                    cc_emps.push(value.split("_")[0]);
                else
                    cc_cons.push(value.split("_")[0]);
            });
            $('#cc_par_ids').val(cc_pars);
            $('#cc_emp_ids').val(cc_emps);
            $('#cc_cons_ids').val(cc_cons);
        }
		if(startDateString.getTime() > finishDateString.getTime()){
            alert("<cf_get_lang dictionary_id='33715.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>");
            return false;
        }
        if (document.getElementById('eventcat_id').value == 0)
        { 
            alert("<cf_get_lang dictionary_id='33714.Olay Kategorisi Seçiniz'>");
            document.getElementById('eventcat_id').focus();
            return false;
        }
        if (document.getElementById('event_head').value == 0)
        { 
            alert("<cf_get_lang dictionary_id='63209.Eksik Veri : Konu'>");
            document.getElementById('event_head').focus();
            return false;
        }
        if (document.getElementById('startdate').value == 0)
        { 
            alert("<cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'>");
            document.getElementById('startdate').focus();
            return false;
        }
        if (document.getElementById('finishdate').value == 0)
        { 
            alert("<cf_get_lang dictionary_id='36494.Lütfen Bitiş Tarihi Giriniz'>");
            document.getElementById('finishdate').focus();
            return false;
        }
        if (document.getElementById('record_par_mail').value == '')
        { 
            alert("<cf_get_lang dictionary_id='31877.Sistemde mail adresiniz kayıtlı değil. Mail adresinizi kaydedip tekrar deneyin!'>");
            return false;
        }
        if (document.getElementById('advisor_mail').value == '')
        { 
            alert("<cf_get_lang dictionary_id='32175.Sistemde danışmanın mail adresi kayıtlı değil. Toplantı talebi oluşturulamıyor!'>");
            return false;
        }
	}
	
	function show_warn(i)
	{
		/* uyarı var*/
		if(i == 0)
		{
			/*tek uyarı açık*/
			warn_multiple.style.display = 'none';
			warn_multiple2.style.display = 'none';
		}
		if(i == 1)
		{
			/*çoklu uyarı açık*/
			warn_multiple.style.display = '';
			warn_multiple2.style.display = '';
		}
	}
	
	<cfif len(get_event.link_id)>
	<cfoutput>
		warning_type=#fark#;
		warning_count=#get_event_count.event_count#;
		</cfoutput>
	</cfif>
	
	<cfif get_event.link_id is "">
		show_warn(0);
	<cfelse>
		show_warn(1);
	</cfif>
</script>

