<!---Select ifadeleri düzenlendi.24082012 e.a --->
<cfquery name="get_campaign_comment" datasource="#dsn3#">
	SELECT 
    		CAMPAIGN_ID,
            CAMPAIGN_COMMENT,
            CAMPAIGN_COMMENT_POINT,
            NAME,
            SURNAME,
            MAIL_ADDRESS
    FROM 
    	CAMPAIGN_COMMENT 
   	WHERE 
    	CAMPAIGN_ID = #attributes.camp_id#
</cfquery>

<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_campaign_comment.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_campaign_name" datasource="#dsn3#">
	SELECT 
		CAMP_HEAD
	FROM 
		CAMPAIGNS
	WHERE 
		CAMP_ID = #attributes.camp_id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Yorumlar',58185)# : #get_campaign_name.camp_head#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<cfif get_campaign_comment.recordcount>
				<cfoutput query="get_campaign_comment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'><cf_get_lang dictionary_id="58726.Soyad">:</label>
							<div class="col col-8 col-xs-12">
								#name# #surname#
							</div>
						</div>
						<div class="form-group" id="item-mail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'>:</label>
							<div class="col col-8 col-xs-12">
								<a href="mailto:#mail_address#" class="tableyazi">#mail_address#</a>
							</div>
						</div>
						<div class="form-group" id="item-comment_point">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58984.Puan">:</label>
							<div class="col col-8 col-xs-12">
								#campaign_comment_point#
							</div>
						</div>
						<div class="form-group" id="item-campaign_comment">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29805.Yorum">:</label>
							<div class="col col-8 col-xs-12">
								#campaign_comment#
							</div>
						</div>
					</div>
				</cfoutput>
			<cfelse>
				<tr>
					<td class="labelwhite" colspan="4"><cf_get_lang dictionary_id="62285.Kampanyaya Yorum Eklenmemiş"></td>
				</tr>
			</cfif>
		</cf_box_elements>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset adres = "campaign.popup_view_campaign_comment&camp_id=#attributes.camp_id#">
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
