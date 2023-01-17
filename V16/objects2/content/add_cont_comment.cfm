<cfif isdefined('attributes.member_id') and len(attributes.member_id) and isdefined('attributes._type_') and len(attributes._type_)>
	<cfset cont_key = 'wrk'>
	<cfset attributes.member_id = Decrypt('#attributes.memberId#',cont_key,"CFMX_COMPAT","Hex")>
	<cfset attributes.member_email = Decrypt('#attributes.mEmail#',cont_key,"CFMX_COMPAT","Hex")>
	<cfset attributes.member_type = attributes._type_>
</cfif>
<cfif isdefined('attributes.member_type') and attributes.member_type eq 2>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER_SURNAME AS SURNAME,
			COMPANY_PARTNER_EMAIL AS EMAIL
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
	</cfquery>
<cfelseif isdefined('attributes.member_type') and attributes.member_type eq 1>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
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
	<cfset get_member.recordcount = 0>
</cfif>
<cfform name="add_cont_com" method="post"  enctype="multipart/form-data"><br/>
	<input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.cntid#</cfoutput>">
	<input type="hidden" name="user_friendly_url" id="user_friendly_url" value="<cfoutput>#attributes.param_1#</cfoutput>">
	<cfif isdefined('attributes.member_type') and len(attributes.member_type)>
		<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
	</cfif>
	<div class="row">
		<div class="form-group col-md-12 ">
			<textarea name="content_comment" id="content_comment" placeholder="Max. 250 karakter"></textarea>
		</div>
		<div class="form-row col-md-12">
			<div class="form-group col-md-3">
				<cfif isdefined("session.ww.name")>
					<input type="text" name="name" id="name" value="<cfoutput>#session.ww.name#</cfoutput>" maxlength="50">
				<cfelseif isdefined("session.pp.name")>
					<input type="text" name="name" id="name" value="<cfoutput>#session.pp.name#</cfoutput>" maxlength="50">
				<cfelse>
					<input type="text" name="name" id="name" maxlength="50" required="Yes" placeholder="<cf_get_lang dictionary_id='63785.Adınız'>">
				</cfif>
			</div>
			<div class="form-group col-md-3">
				<cfif isdefined("session.ww.surname")>
					<input type="text" name="surname" id="surname" maxlength="50" value="<cfoutput>#session.ww.surname#</cfoutput>">
				<cfelseif isdefined("session.pp.name")>
					<input type="text" name="surname" id="surname" maxlength="50" value="<cfoutput>#session.pp.surname#</cfoutput>">
				<cfelse>
					<input type="text" name="surname" id="surname" maxlength="50" required="Yes" placeholder="<cf_get_lang dictionary_id='35630.Soyadınız'>">
				</cfif>
			</div>
			<cfif isdefined('attributes.is_email') and attributes.is_email eq 1>
				<div class="form-group">
					<cfif get_member.recordcount>
						<input type="text" name="mail_address" id="mail_address" required="yes" value="<cfoutput>#get_member.email#</cfoutput>">
					<cfelse>
						<input type="text" name="mail_address" id="mail_address" required="yes" value="" placeholder="<cf_get_lang dictionary_id='35813.E-posta adresiniz'>">
					</cfif>
				</div>
			</cfif>
			<div class="form-group">
				<cf_workcube_buttons is_insert="1" data_action="/V16/objects2/cfc/widget/add_cont_comment:add_comment" next_page="/#attributes.param_1#" >
			</div>
		</div>		
	</div>
</cfform>

<script language="javascript">
    function kontrol()
	{
		if(document.getElementById('name').value == '')
		{
			alert("<cf_get_lang dictionary_id='63785.Adınız'>");
			return false;
		}
		if(document.getElementById('surname').value == '')
		{
			alert("<cf_get_lang dictionary_id='35630.Soyadınız'>");
			return false;
		}
		<cfif isdefined('attributes.is_email') and attributes.is_email eq 1>
			var aaa = document.getElementById('mail_address').value;
			if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang dictionary_id='35813.E-posta adresiniz'>");
				return false;
			}
		</cfif>
		if(document.getElementById('content_comment').value == '')
		{
			alert("<cf_get_lang no ='1306.Lütfen yorumunuzu yazınız'>");
			return false;
		}
		
	}
</script>
