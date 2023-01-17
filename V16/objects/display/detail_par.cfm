<cfinclude template="../query/get_par_det.cfm">
<cfset attributes.company_id = detail_par.company_id>
<cfinclude template="../query/get_comp_name.cfm">
<cfinclude template="../query/get_representative.cfm">
<cfif len(detail_par.imcat_id)>
  <cfset attributes.imcat_id = detail_par.imcat_id>
  <cfinclude template="../query/get_imcat.cfm">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="right">
	<cfif isdefined("session.ep.userid")>
	<cfif not isdefined("attributes.start_date_par")>
		<cfset attributes.start_date_par = "">
	</cfif>
	<cfif not isdefined("attributes.finishdate")>
		<cfset attributes.finishdate = "">
	</cfif>
	<cfform name="get_events" method="post" action="#request.self#?fuseaction=objects.popup_par_events">
		<input type="Hidden" name="par_id" id="par_id" value="<cfoutput>#par_id#</cfoutput>">
		<input type="Hidden" name="maxrows" id="maxrows" value="<cfoutput>#session.ep.maxrows#</cfoutput>">
			<div class="row">
				<div class="col col-12 form-inline">
					<div class="form-group pl-1">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="start_date_par" style="width:65px;" required="Yes" message="#message#" validate="#validate_style#" value="#attributes.start_date_par#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_par"></span>
						</div>
					</div>	
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="finishdate" style="width:65px;"   required="Yes" message="#message2#" validate="#validate_style#" value="#attributes.finishdate#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
					<!--- <div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
					</div> --->
					<div class="form-group">
						<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('get_events' , #attributes.modal_id#)"),DE(""))#">
						<!--- <cf_wrk_search_button button_type="4" > --->
					</div>	
				</div>
			</div>
	</cfform>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<!--- <cf_box title="#detail_par.member_code#  - #detail_par.company_partner_name# #detail_par.company_partner_surname#" right_images="#iif(isdefined('attributes.draggable'),DE(''),DE('##right##'))#" popup_box="#iif(isdefined('attributes.draggable'),1,0)#"> --->
	<cf_box title="#detail_par.member_code# #detail_par.company_partner_name# #detail_par.company_partner_surname#" right_images="#right#"  popup_box="#iif(isdefined('attributes.draggable'),1,0)#">
		<cf_box_elements>
			<cfoutput>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57487.No'></label>
						<label class="col col-8 col-xs-4">#detail_par.member_code#</label>
						<label rowspan="9"  valign="top" style="text-align:right;">
						<cfif len(detail_par.photo)>
							<cf_get_server_file output_file="member/#detail_par.photo#" output_server="#detail_par.photo_server_id#" image_width="125" imageheight="150" output_type="0">
						</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57631.Ad'></label>
						<label class="col col-8 col-xs-4">#detail_par.company_partner_name#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57428.e mail'></label>
						<label class="col col-8 col-xs-4"><a href="mailto:#detail_par.company_partner_email#" class="tableyazi">#detail_par.company_partner_email#</a></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58726.Soyad'></label>
						<label class="col col-8 col-xs-4">#detail_par.company_partner_surname#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='32486.Ins Mesaj'></label>
						<label class="col col-8 col-xs-4"><cfif len(detail_par.imcat_id)>#get_imcat.imcat#</cfif>-#detail_par.im#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<label class="col col-8 col-xs-4">#detail_par.title#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57499.Telefon'></label>
						<label class="col col-8 col-xs-4"><cfif Len(detail_par.country)><cfquery name="get_country" datasource="#dsn#">SELECT COUNTRY_NAME,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID =#detail_par.country#</cfquery><cfif len(get_country.country_phone_code)>(#get_country.country_phone_code#) </cfif></cfif>#detail_par.company_partner_telcode#  #detail_par.company_partner_tel#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57573.Görev'></label>
						<label class="col col-8 col-xs-4"><cfif len(detail_par.mission)><cfquery name="GET_MISSION" datasource="#dsn#">SELECT PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID =  #detail_par.mission#</cfquery>#get_mission.partner_position#</cfif></label>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="2" sort="true">
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='32489.Dahili'></label>
						<label class="col col-8 col-xs-4">#detail_par.company_partner_tel_ext# </label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<label class="col col-8 col-xs-4"><a href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#detail_par.company_id#');" > #get_comp_name.fullname# </a> </label>
					</div>
					<div class="form-group">	
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57488.Fax'></label>
						<label class="col col-8 col-xs-4">#detail_par.company_partner_fax#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='57908.Temsilci'></label>
						<label class="col col-8 col-xs-4">#get_representative.employee_name#&nbsp;#get_representative.employee_surname#</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
						<label class="col col-8 col-xs-4">#detail_par.mobil_code# - #detail_par.mobiltel#<cfif isdefined("session.ep.userid")><cfif (len(detail_par.MOBIL_CODE) is 3) and (len(detail_par.mobiltel) is 7) and  (session.ep.our_company_info.sms eq 1)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#detail_par.PARTNER_ID#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" border="0" title="<cf_get_lang dictionary_id ='58590.SMS Gönder'>"></a></cfif></cfif></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58132.Semt'></label>
						<label class="col col-8 col-xs-4"><cfif len(detail_par.semt)>#detail_par.semt#</cfif></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<label class="col col-8 col-xs-4"><cfif len(detail_par.county)><cfquery name="get_county_name" datasource="#dsn#">SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #detail_par.county#</cfquery><cfif get_county_name.recordcount>#get_county_name.county_name#</cfif></cfif></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58608.İl'></label>
						<label class="col col-8 col-xs-4"><cfif len(DETAIL_PAR.CITY)><cfquery name="get_city_name" datasource="#dsn#">SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #DETAIL_PAR.CITY#</cfquery><cfif get_city_name.recordcount>#get_city_name.city_name#</cfif></cfif></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-4 txtbold"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<label class="col col-8 col-xs-4"><cfif len(DETAIL_PAR.COUNTRY)><cfquery name="get_country_name" datasource="#dsn#">SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #DETAIL_PAR.COUNTRY#</cfquery><cfif get_country_name.recordcount>#get_country_name.country_name#</cfif></cfif></label>
					</div>
				</div>	
			</cfoutput>
		</cf_box_elements>	
	</cf_box>
</div>
