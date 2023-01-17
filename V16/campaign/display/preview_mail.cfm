<cfquery name="CAMP_EMAIL_CONTS" datasource="#DSN3#">
    SELECT 
        C.CONT_HEAD EMAIL_SUBJECT,
        C.CONT_BODY EMAIL_BODY,
        ' ' SENDED_TARGET_MASS 
    FROM 
        #dsn_alias#.CONTENT_RELATION CR, 
        #dsn_alias#.CONTENT C
    WHERE 
        CR.CONTENT_ID = C.CONTENT_ID AND
        CR.ACTION_TYPE = 'CAMPAIGN_ID'AND 
        CR.ACTION_TYPE_ID = #attributes.CAMP_ID# AND
        CR.CONTENT_ID = #attributes.email_cont_id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Direkt Mail İçeriği',49531)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfoutput>
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='49698.Kimden'> :</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							#session.ep.company#
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'> :</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							#dateformat(now(),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#
						</div>
					</div>
					<div class="form-group" id="item-yetkili">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57924.Kime'>:</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_get_lang dictionary_id ='49699.Sayın Yetkili'>
						</div>
					</div>
					<div class="form-group" id="item-subject">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57480.Konu">:</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							#CAMP_EMAIL_CONTS.EMAIL_SUBJECT#
						</div>
					</div>
					<div class="form-group" id="item-now">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='49699.Sayın Yetkili'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							#dateformat(now(),dateformat_style)#
						</div>
					</div>
					
				</div>
			</cf_box_elements>
			<!--- <cf_box_footer> --->
				<div class="form-group col col-12" id="item-email-body">
					#CAMP_EMAIL_CONTS.EMAIL_BODY#
				</div>
			<!--- </cf_box_footer> --->
		</cfoutput>
	</cf_box>
</div>
