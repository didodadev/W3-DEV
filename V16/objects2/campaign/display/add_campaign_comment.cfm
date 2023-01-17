<cfif isDefined('session.pp.userid')>
	<cfset attributes.member_type = 1>
    <cfset attributes.member_id = session.pp.userid>
<cfelse>
	<cfset attributes.member_type = 2>
    <cfset attributes.member_id = session.ww.userid>
</cfif>

<cfif isdefined('attributes.member_type') and attributes.member_type eq 1>
	<cfquery name="GET_MEMBER_CAMPAIGN" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER_SURNAME AS SURNAME,
			COMPANY_PARTNER_EMAIL AS EMAIL
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
	</cfquery>
<cfelseif isdefined('attributes.member_type') and attributes.member_type eq 2>
	<cfquery name="GET_MEMBER_CAMPAIGN" datasource="#DSN#">
		SELECT 
			CONSUMER_NAME AS NAME,
			CONSUMER_SURNAME AS SURNAME,
			CONSUMER_EMAIL AS EMAIL
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
	</cfquery>
<cfelse>
	<cfset get_member_campaign.recordcount = 0>
</cfif>

<cfform name="add_camp_com" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_campaign_comment"><br/>
	<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#attributes.camp_id#</cfoutput>">
	<cfif isdefined('attributes.member_type') and len(attributes.member_type)>
        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
	</cfif>
	
	<table align="left" cellpadding="0" cellspacing="0" style="margin-left:10px;width:67%;height:100%;">
		<tr>
			<td style="width:20%;"><cf_get_lang_main no='219.Ad'> *</td>
			<td>
            	<cfsavecontent variable="message"><cf_get_lang_main no='1527.Ad Girmelisiniz'></cfsavecontent>
				<cfif get_member_campaign.recordcount>
					<cfinput type="text" name="name" id="name" value="#get_member_campaign.name#" message="#message#" maxlength="50" required="yes" style="width:200px;">
				<cfelse>
					<cfinput type="text" name="name" id="name" value="" maxlength="50" message="#message#" required="yes" style="width:200px;">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1314.Soyad'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='1706.Soyad Girmelisiniz'></cfsavecontent>
				<cfif get_member_campaign.recordcount>
					<cfinput type="text" name="surname" id="surname" value="#get_member_campaign.surname#" message="#message#" maxlength="50" required="yes" style="width:200px;">
				<cfelse>
					<cfinput type="text" name="surname" id="surname" value="" message="#message#" maxlength="50" required="yes" style="width:200px;">
				</cfif>	
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='16.E-posta'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='1072.Lütfen Geçerli Bir E-posta Adresi Giriniz'></cfsavecontent>
				<cfif get_member_campaign.recordcount>
					<cfinput type="text" name="mail_address" id="mail_address" value="#get_member_campaign.email#" validate="email" message="#message#" maxlength="100" style="width:200px;">
				<cfelse>
					<cfinput type="text" name="mail_address" id="mail_address" value="" validate="email" maxlength="100" message="#message#" style="width:200px;">
				</cfif>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:top;"><cf_get_lang_main no='2008.Yorum'></td>
			<td><textarea name="camp_comment" id="camp_comment" style="width:200px; height:100px;"></textarea></td>
		</tr>
		<tr style="height:30px;">
        	<td></td>
			<td style="text-align:right;"><input type="submit" name="submit" id="submit" value="<cf_get_lang_main no='1331.Gönder'>"></td>
		</tr>
	</table>
</cfform>
