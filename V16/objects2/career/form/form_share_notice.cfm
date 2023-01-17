<cfquery name="GET_NOTICE" datasource="#dsn#">
	SELECT
		NOTICE_HEAD,
		NOTICE_CITY,
		COMPANY_ID,
		POSITION_NAME
	FROM
		NOTICES
	WHERE 
		NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>

<table width="100%">
	<cfform name="notice_share" action="#request.self#?fuseaction=objects2.add_message_send">
		<cfoutput>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_notice.company_id#</cfoutput>">
		<input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.notice_id#</cfoutput>">
 		<tr>
			<td colspan="2" class="txtbold">Bu ilanı arkadaşınla paylaş</td>
		</tr>
		<tr>
			<td colspan="2"><hr style="width:90%"></td>
		</tr>
		<tr>
			<td class="headbold">Şirket : </td>
			<td><cfinput type="text" name="company_name" id="company_name" value="#get_par_info(get_notice.company_id,1,0,0)#" style="border-width:0px;width:200px;" readonly="yes"></td>
		</tr>
		<tr>
			<td class="headbold">Konu :</td>
			<td><cfinput type="text" name="detail" id="detail" value="#get_notice.notice_head#" style="border-width:0px;width:200px;" readonly="yes"></td>
		</tr>
		<tr>
			<td class="headbold">Pozisyon :</td>
			<td><cfinput type="text" name="position" id="position" value="#get_notice.position_name#" style="border-width:0px;width:200px;" readonly="yes"></td>
		</tr>
		<tr>
			<td class="headbold">Şehir :</td>
			<td>
				<cfif listlen(get_notice.notice_city)>
					<cfset row_count = 0>
					<cfloop list="#get_notice.notice_city#" index="i">
						<cfset row_count = row_count + 1>
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
						</cfquery>
						<cfinput type="text" name="city_name" id="city_name" value="#get_city.city_name#" style="border-width:0px;width:200px;" readonly="yes"> <cfif row_count lt listlen(get_notice.notice_city,',')>-</cfif>
					</cfloop>
				</cfif>
			</td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="2">
				<font style="width:90%; border-top-style:dotted; border-width:1px;"></font>
			</td>
		</tr>
		<input type="hidden" name="share_not" id="share_not" value="1">
		<tr>
			<td class="headbold">Gönderenin adı soyadı</td>
			<td><cfsavecontent variable="message">Lütfen gönderen adı ve soyadını giriniz</cfsavecontent>
				<cfinput type="text" name="sender_name" id="sender_name" required="yes" message="#message#" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td class="headbold">Gönderenin e-posta adresi</td>
			<td><cfsavecontent variable="message2">Lütfen gönderen e-posta adresini giriniz</cfsavecontent>
				<cfinput type="text" name="sender_email" id="sender_email" validate="email" required="yes" message="#message2#" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td class="headbold">1. Alıcının e-posta adresi</td>
			<td><cfsavecontent variable="message3">Lütfen alıcı e-posta adresini giriniz</cfsavecontent>
				<cfinput type="text" name="receive_email" id="receive_email" validate="email" required="yes" message="#message3#" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td class="headbold">2. Alıcının e-posta adresi</td>
			<td><cfinput type="text" name="receive_email2" id="receive_email2" validate="email" message="#message3#" style="width:200px;"></td>
		</tr>
		<tr>
			<td class="headbold">3. Alıcının e-posta adresi</td>
			<td><cfinput type="text" name="receive_email3" id="receive_email3" validate="email" message="#message3#" style="width:200px;"></td>
		</tr>
		<tr>
			<td valign="top" class="headbold">Eklemek istediğiniz notlar</td>
			<td><textarea name="receive_notes" id="receive_notes" style="width:200px; height:60px;"></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td style="text-align:left"><input type="image" src="<cfoutput>#file_web_path#</cfoutput>templates/kariyer/resimler/mavi_gonder.jpg"></td>
		</tr>
	</cfform>
</table>
