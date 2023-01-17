<cfsetting showdebugoutput="no">
<cfquery name="GET_MSG_TEMP" datasource="#DSN#">
	SELECT
		IS_CHANGE,
		IS_EDIT_SEND_DATE,
		SMS_TEMPLATE_ID,
		SMS_TEMPLATE_NAME,
		SMS_TEMPLATE_BODY 
	FROM 
		SMS_TEMPLATE
	WHERE
		IS_ACTIVE = 1 AND
		SMS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sms_template_id#">  
</cfquery>
<!--- üye bilgileri alınıyor --->
<cfif attributes.member_type eq 'company'>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER.PARTNER_ID,
			<cfif database_type is 'DB2'>
				COMPANY_PARTNER.COMPANY_PARTNER_NAME||' '||COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
				COMPANY_PARTNER.MOBIL_CODE||COMPANY_PARTNER.MOBILTEL AS P_MOBILPHONE,
			<cfelse>
				COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
				COMPANY_PARTNER.MOBIL_CODE+COMPANY_PARTNER.MOBILTEL AS MOBILPHONE,
			</cfif>
			COMPANY.COMPANY_ID,
			COMPANY.NICKNAME
		FROM 
			COMPANY_PARTNER,	
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
			COMPANY_PARTNER.PARTNER_ID= COMPANY.MANAGER_PARTNER_ID
		<cfif database_type is 'DB2'>
            AND LEN(COMPANY_PARTNER.MOBIL_CODE||COMPANY_PARTNER.MOBILTEL) = 10
        <cfelse>
            AND LEN(COMPANY_PARTNER.MOBIL_CODE+COMPANY_PARTNER.MOBILTEL) = 10
        </cfif>
	</cfquery>
<cfelseif attributes.member_type eq 'partner'>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER.PARTNER_ID,
			<cfif database_type is 'DB2'>
				COMPANY_PARTNER.COMPANY_PARTNER_NAME||' '||COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
				COMPANY_PARTNER.MOBIL_CODE||COMPANY_PARTNER.MOBILTEL AS P_MOBILPHONE,
			<cfelse>
				COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
				COMPANY_PARTNER.MOBIL_CODE+COMPANY_PARTNER.MOBILTEL AS MOBILPHONE,
			</cfif>
			COMPANY.COMPANY_ID,
			COMPANY.NICKNAME
		FROM 
			COMPANY_PARTNER,	
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID AND
			COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfif database_type is 'DB2'>
            AND LEN(COMPANY_PARTNER.MOBIL_CODE||COMPANY_PARTNER.MOBILTEL)=10
        <cfelse>
            AND LEN(COMPANY_PARTNER.MOBIL_CODE+COMPANY_PARTNER.MOBILTEL)=10
        </cfif>
	</cfquery>
<cfelseif attributes.member_type eq 'consumer'>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_NAME+' '+CONSUMER_SURNAME AS MEMBER_NAME,
			MOBIL_CODE+MOBILTEL AS MOBILPHONE,
			'' NICKNAME
		FROM
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfif database_type is 'DB2'>
            AND LEN(MOBIL_CODE||MOBILTEL)=10
        <cfelse>
            AND LEN(MOBIL_CODE+MOBILTEL)=10
        </cfif>
	</cfquery>
<cfelseif attributes.member_type eq 'employee'>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS MEMBER_NAME,
		<cfif isDefined("attributes.is_spc") and Len(attributes.is_spc)>
            ED.MOBILCODE_SPC+ED.MOBILTEL_SPC AS MOBILPHONE,
        <cfelse>
            E.MOBILCODE+E.MOBILTEL AS MOBILPHONE,
        </cfif>
			'' NICKNAME
		FROM
			<cfif isDefined("attributes.is_spc") and Len(attributes.is_spc)>
				EMPLOYEES_DETAIL ED,
			</cfif>
			EMPLOYEES E
		WHERE 
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfif isDefined("attributes.is_spc") and Len(attributes.is_spc)>
            AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
            AND LEN(ED.MOBILCODE_SPC <cfif database_type is 'DB2'>||<cfelse>+</cfif> ED.MOBILTEL_SPC) = 10
        <cfelse>
            AND LEN(E.MOBILCODE <cfif database_type is 'DB2'>||<cfelse>+</cfif> E.MOBILTEL) = 10
        </cfif>
	</cfquery>
</cfif>
<cfform name="add_sms" method="post" action="#request.self#?fuseaction=objects.emptypopup_send_sms">
	<input type="hidden" name="sms_template_id" id="sms_template_id" value="<cfoutput>#attributes.sms_template_id#</cfoutput>">
	<input type="hidden" name="mobil_phone" id="mobil_phone" value="<cfoutput>#get_member.mobilphone#</cfoutput>">
	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
	<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
	<input type="hidden" name="paper_id" id="paper_id" value="<cfoutput>#attributes.paper_id#</cfoutput>">
	<input type="hidden" name="paper_type" id="paper_type" value="<cfoutput>#attributes.paper_type#</cfoutput>">
	<cfif attributes.member_type eq 'company'>
		<input type="hidden" name="member_id_2" id="member_id_2" value="<cfoutput>#get_member.partner_id#</cfoutput>">
	<cfelseif attributes.member_type eq 'partner'>
		<input type="hidden" name="member_id_2" id="member_id_2" value="<cfoutput>#get_member.company_id#</cfoutput>">
	</cfif>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<table>
			<cfif get_msg_temp.is_edit_send_date>
				<tr>
					<td><cf_get_lang dictionary_id ='33800.Gönderim Tarihi'></td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<td><cfinput type="text" name="send_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
						<cf_wrk_date_image date_field="send_date">
						<select name="send_hour" id="send_hour" style="width:50px;">
							<option value="0" selected><cf_get_lang dictionary_id='57491.Saat'></option>
							<cfloop from="0" to="23" index="i">
								<cfoutput><option value="#i#" <cfif datepart('H',date_add('h',session.ep.time_zone, now())) eq i>selected</cfif>>#NumberFormat(i,00)#</option></cfoutput>
							</cfloop>
						</select>
						<cfset now_minute=datepart('n',now())>
						<select name="send_minute" id="send_minute" style="width:40px;">
							<cfloop from="0" to="55" index="j" step="5">
								<cfoutput><option value="#j#" <cfif  now_minute gte j and now_minute lt (j+5)>selected</cfif>>#NumberFormat(j,00)#</option></cfoutput>
							</cfloop>
						</select>
					</td>
				</tr>
			</cfif>
			<div class="form-group col col-12" id="item-temp">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57543.Mesaj'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfset sms_text=wrk_sms_body_replace(sms_body:GET_MSG_TEMP.SMS_TEMPLATE_BODY,member_type:attributes.member_type,member_id:attributes.member_id,paper_type:attributes.paper_type,paper_id:attributes.paper_id)>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='33847.SMS İçeriği Olarak En Fazla 462 Karakter Girebilirsiniz'></cfsavecontent>
					<textarea name="sms_body" id="sms_body" style="width:250px;height:100px;" cols="40" rows="6" maxlength="462" onkeyup="count_char();ismaxlength(this);" onBlur="count_char();ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" <cfif GET_MSG_TEMP.IS_CHANGE eq 0>readonly</cfif>><cfoutput>#sms_text#</cfoutput></textarea>
				</div>
			</div>
			<div class="form-group col col-12" id="item-temp">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp;</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_get_lang dictionary_id ='33845.Karakter Sayısı'>&nbsp;<div id='count_char_td'><cfoutput>#len(sms_text)#</cfoutput></div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_get_lang dictionary_id ='33846.SMS Sayısı'>
						<div id='count_sms_td'><cfoutput>#Ceiling(len(sms_text)/154)#</cfoutput>/3</div>
					</div>
				</div>
			</div>
		</table>
		<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='control()'></cf_box_footer>
	</div>
</cfform>
<script type="text/javascript">
function count_char()
{
	$(document).ready(function(){			
		$('textarea[name="sms_body"]').on('keydown',function(){
		var chrLen = 	$(this).val().length;
		var smsCount = 0;
		$('#count_char_td').text( chrLen  )
		console.log(chrLen)
			if(chrLen <= 160) {
				$('td#count_sms_td').empty();
				$('#count_sms_td').append( Math.ceil( chrLen / 154 ));
				$('#count_sms_td').append("/3");
				}
		});
	})
}

function control()
{
	count_char();
	if(document.getElementById('sms_body').value.length>462)
	{
		alert("<cf_get_lang dictionary_id ='33847.SMS İçeriği Olarak En Fazla 462 Karakter Girebilirsiniz'>!");
		return false;
	}
	
	if(document.getElementById('mobil_phone').value.length != 10)
	{
		alert("<cf_get_lang dictionary_id='35481.Lütfen geçerli bir mobil telefon numarası giriniz'>!");
		return false;
	}
}
</script>
