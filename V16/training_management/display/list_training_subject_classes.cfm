<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>
<cfif isdefined("attributes.train_id")>
	<cfset url_str = "#url_str#&train_id=#attributes.train_id#">
</cfif>
<cfinclude template="../query/get_class.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_class.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form1" method="post" action="">
<cf_medium_list_search title="#getLang('training_management',181)#">
	<cf_medium_list_search_area>
		<table>
			<tr> 
				<td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
				<td>
					<select name="online" id="online">
						<option value=""<cfif attributes.online is ""> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="1"<cfif attributes.online is "1"> selected</cfif>><cf_get_lang_main no='2218.Online'></option>
						<option value="0"<cfif attributes.online is "0"> selected</cfif>><cf_get_lang no='159.Online Değil'></option>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
			</tr>
		</table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr> 
			<th width="20"></th>
			<th width="150"><cf_get_lang_main no='7.Eğitim'></th>
			<th width="100"><cf_get_lang no='187.Eğitim Yeri'></th>
			<th width="100"><cf_get_lang_main no='1655.Varlık'></th>
			<th width="130"><cf_get_lang no='23.Eğitimci'></th>
			<th width="200"><cf_get_lang_main no='330.Tarih'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_class.recordcount>
			<cfoutput query="get_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr>
			<td width="20" align="center">
			  <cfif len(start_date) and len(finish_date)>
				<cfif ((datediff('n',now(),start_date) lte 15) and (datediff('n',now(),finish_date) gte 0)) and (online eq 1)>
					<a href="javascript://" onClick="windowopen('/COM_MX/onlineclass.swf?class_id=#class_id#&username=#session.ep.username#&server=#employee_domain#&appDirectory=#dsn#','project');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang no='25.Derse Katıl'>"></a>
				</cfif>
			  </cfif>	
			  </td>
			  <td>
			  <!---<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#';self.close();" class="tableyazi">
			 #class_name#</a>
			 --->
			 #class_name#
			 </td>
			  <td>#CLASS_PLACE#</td>
			  <cfquery name="get_class_place" datasource="#dsn#" maxrows="1">
				SELECT
					ASSET_P.ASSETP
				FROM
					ASSET_P_RESERVE,
					ASSET_P
				WHERE
					ASSET_P_RESERVE.CLASS_ID = #CLASS_ID#
					AND
					ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID
			  </cfquery>
			  <td><cfif get_class_place.recordcount>#get_class_place.assetp#</cfif></td>
			  <td>
				<!--- <cfset attributes.class_id = class_id>
				<cfinclude template="../query/get_class_trainer.cfm">
				  <cfloop query="get_class_trainer_emp">
					#employee_name# #employee_surname#,
				  </cfloop>
				  <cfloop query="get_class_trainer_par">
					#nickname# - #company_partner_name# #company_partner_surname#, 
				  </cfloop> --->
				  <!---<cfloop query="get_class_trainer_grps">
					#group_name#, 
				  </cfloop> ---><!--- get_class_trainer action sayfasında get_class_trainer_grps query si kapatilmis Senay 20060325 --->
			  </td>
			<td>
			<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
				#dateformat(start_date,dateformat_style)# (#timeformat(start_date,timeformat_style)#) - #dateformat(finish_date,dateformat_style)# (#timeformat(finish_date,timeformat_style)#) 
			</td>
			</tr>
			</cfoutput> 
		<cfelse>
		<tr> 
		<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif get_class.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center">
		<tr> 
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_training_subject_classes#url_str#"> 
			</td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
 
