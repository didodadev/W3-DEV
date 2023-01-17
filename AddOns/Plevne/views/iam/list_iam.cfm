<cfparam name="attributes.page" default=1>
<cfscript>
    list_iam = CreateObject("component","AddOns.Plevne.Domains.iam");
    list_iam.dsn = dsn;
</cfscript>
<cfparam name="attributes.user_comp_name" default="">
<cfif isDefined('url.subs_no') and len(url.subs_no)>
    <cfset get_subs_id_ = list_iam.get_subscription(subscription_no : url.subs_no)>
    <cfparam name="attributes.subscription_no" default="#url.subs_no#">
    <cfparam name="attributes.subscription_id" default="#get_subs_id_.subscription_id#">
<cfelse>
    <cfparam name="attributes.subscription_no" default="">
    <cfparam name="attributes.subscription_id" default="">
</cfif>
<cfparam name="attributes.domain" default="">
<cfparam name="attributes.username" default="">
<cfparam name="attributes.name_sname" default="">
<cfparam name="attributes.mobile" default="">
<cfparam name="attributes.mail" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
    url_string = '';
    if (isdefined('attributes.subscription_no')) url_string = '#url_string#&subscription_no=#attributes.subscription_no#';
    if (isdefined('attributes.user_comp_name')) url_string = '#url_string#&user_comp_name=#attributes.user_comp_name#';
    if (isdefined('attributes.domain')) url_string = '#url_string#&domain=#attributes.domain#';
    if (isdefined('attributes.username')) url_string = '#url_string#&username=#attributes.username#';
    if (isdefined('attributes.name_sname')) url_string = '#url_string#&name_sname=#attributes.name_sname#';
    if (isdefined('attributes.mobile')) url_string = '#url_string#&mobile=#attributes.mobile#';
    if (isdefined('attributes.mail')) url_string = '#url_string#&mail=#attributes.mail#';
    if (isdefined('attributes.subscription_id')) url_string = '#url_string#&subscription_id=#attributes.subscription_id#';
    if (isdefined('attributes.startdate')) url_string = '#url_string#&startdate=#attributes.startdate#';
    if (isdefined('attributes.finishdate')) url_string = '#url_string#&finishdate=#attributes.finishdate#';
    if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';
</cfscript>
<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
        
     
        get_iam = list_iam.list_iam(
            subscription_no : '#iif(isdefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#' ,
            subscription_id : '#iif(isdefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#' ,
            user_comp_name : '#iif(isdefined("attributes.user_comp_name"),"attributes.user_comp_name",DE(""))#' ,
            domain : '#iif(isdefined("attributes.domain"),"attributes.domain",DE(""))#' ,
            username : '#iif(isdefined("attributes.username"),"attributes.username",DE(""))#' ,
            name_sname : '#iif(isdefined("attributes.name_sname"),"attributes.name_sname",DE(""))#' ,
            mobile : '#iif(isdefined("attributes.mobile"),"attributes.mobile",DE(""))#' ,
            mail : '#iif(isdefined("attributes.mail"),"attributes.mail",DE(""))#',
            status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
            finishdate: '#iif(isdefined("attributes.finishdate"),"attributes.finishdate",DE(""))#',
            startdate: '#iif(isdefined("attributes.startdate"),"attributes.startdate",DE(""))#'
        );
	</cfscript>
<cfelse>
	<cfset get_iam.recordcount = 0>
</cfif>
<cfif get_iam.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_iam.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_iam.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_list" action="#request.self#?fuseaction=plevne.iam" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-subscription">
                    <div class="input-group">
                        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
                        <input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#attributes.subscription_no#</cfoutput>" placeholder="<cfoutput>#getLang('','Abone No',29502)#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=search_list.subscription_id&field_no=search_list.subscription_no');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cfinput type="text" name="user_comp_name" value="#attributes.user_comp_name#" placeholder="#getLang('','Kullanıcı İşletme','63642')#">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="domain" value="#attributes.domain#" placeholder="#getLang('','Domain','57892')#">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="username" value="#attributes.username#" placeholder="#getLang('','Kullanıcı Adı','57551')#">
                </div>
               
                <div class="form-group">
                    <select name="status" id="status">
                        <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label><cfoutput>#getLang('','Ad Soyad','57570')#</cfoutput></label>
                        <cfinput type="text" name="name_sname" value="#attributes.name_sname#" placeholder="#getLang('','Ad Soyad','57570')#">
                    </div>
                   
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label><cfoutput>#getLang('','Mobil Tel','58482')#</cfoutput></label>
                        <cfinput type="text" name="mobile" value="#attributes.mobile#" placeholder="#getLang('','Mobil Tel','58482')#">
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label><cfoutput>#getLang('','Mail','29463')#</cfoutput></label>
                        <cfinput type="text" name="mail" value="#attributes.mail#" placeholder="#getLang('','Mail','29463')#">
                    </div>
				</div>	
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-dates">
						<label><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfsavecontent>
							<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							<span class="input-group-addon no-bg"></span>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfsavecontent>
							<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','IAM','63639')#"> 
        <cf_grid_list>
            <thead>		
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='29502.Abone No'></th>
                    <th><cf_get_lang dictionary_id='63642.Kullanıcı İşletme'></th>
                    <th><cf_get_lang dictionary_id='57892.Domain'></th>
                    <th><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='58482.Mobil Tel'></th>
                    <th><cf_get_lang dictionary_id='29463.Mail'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th class="text_center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=plevne.iam&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>

                </tr>
            </thead>
            <tbody>
                <cfif get_iam.recordcount>
				    <cfoutput query="get_iam" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#SUBSCRIPTION_NO#</td>
                            <td>#IAM_USER_COMPANY_NAME#</td>
                            <td>#REFERRAL_DOMAIN#</td>
                            <td>#IAM_USER_NAME#</td>
                            <td>#IAM_NAME# #IAM_SURNAME#</td>
                            <td>(#IAM_MOBILE_CODE#) #IAM_MOBILE_NUMBER#</td>
                            <td>
                                <cfif isDefined('IAM_EMAIL_FIRST')>
                                    #IAM_EMAIL_FIRST#
                                <cfelseif isDefined('IAM_EMAİL_SECOND')>
                                    #IAM_EMAİL_SECOND#
                                </cfif>
                            </td>
                            <td>
                                <cfif IAM_ACTIVE eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelseif IAM_ACTIVE eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse></cfif>
                            </td>
                            <td>
                               #dateFormat(RECORD_DATE,dateformat_style)#
                            </td>
                            <td class="text_center"><a href="#request.self#?fuseaction=plevne.iam&event=upd&iam_id=#IAM_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>	
        <cfif get_iam.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif isDefined('is_form_submitted') and is_form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="plevne.iam#url_string#">
		</cfif>
    </cf_box>
</div>