<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.type" default="">
<cfparam name="attributes.is_submit" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.start_date" default="#now()#">
<cfparam name="attributes.finish_date" default="#dateadd('m',+1,now())#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<cfset upgrades_cmp = createObject("component","WDO.development.cfc.subs_upgrade")/>

<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfset getData = upgrades_cmp.getData() />
<cfelse>
    <cfset getData.recordcount = 0 />
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search plus="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" id="start_date" placeholder="#getLang("",'Başlangıç Tarihi',58053)#" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" id="finish_date" placeholder="#getLang("",'Bitiş Tarihi',57700)#" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
                <div class="form-group">
                    <cfinput type="text" name="subs_no" placeholder="Subs No">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="domain" placeholder="Domain">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="Patch, Pull, Upgrade">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"></th>
                    <th>Subs No</th>
                    <th>Domain</th>
                    <th>Release</th>
                    <th>Branch</th>
                    <th>Upgrade Date</th>
                    <th>Type</th>
                    <th>Employee ID</th>
                    <th>User</th>
                    <th>User E-Mail</th>
                </tr>
            </thead>
            <tbody>
                <cfif getData.recordcount>
                    <cfoutput query="getData" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#SUBSCRIPTION_NO#</td>
                            <td>#DOMAIN#</td>
                            <td>#RELEASE#</td>
                            <td>#BRANCH#</td>
                            <td>#UPGRADE_DATE#</td>
                            <td>#UPGRADE_TYPE#</td>
                            <td>#UPGRADE_EMP_ID#</td>
                            <td>#UPGRADE_USER_NAME_SURNAME#</td>
                            <td>#UPGRADE_USER_EMAIL#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8">
                            <cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
                                <cf_get_lang dictionary_id ="57484.Kayıt Yok">!
                            <cfelse>
                                <cf_get_lang dictionary_id ="57701.Filtre Ediniz">!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>