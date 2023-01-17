<cfset theAnnounce = createObject("component","V16.training_management.cfc.announce")/>
<cfset GET_ANNOUNCE_DETAIL = theAnnounce.SELECT(ANNOUNCE_ID:attributes.announce_id)/>
<cfset GET_EMP_REQ =  theAnnounce.COUNTEMPLOYEEID(ANNOUNCE_ID:GET_ANNOUNCE_DETAIL.ANNOUNCE_ID)/>
<cfset GET_TRAININGS =  theAnnounce.SELECTTRAININGS(ANNOUNCE_ID:GET_ANNOUNCE_DETAIL.ANNOUNCE_ID)/>

<cfset class_id = valuelist(get_trainings.class_id,',')>

<!--- Sayfa başlığı ve ikonlar
<table class="dph">
	<tr>
		<td class="dpht">
			<cf_get_lang no='462.Duyuru Güncelle'>
		</td>
		<td class="dphb">
		<cfoutput>
			<cfif not listfindnocase(denied_pages,'training_management.')>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_announce_emps&announce_id=#attributes.announce_id#','medium');"><img src="../../images/family.gif" border="0" title="Duyuru Eklenenler"></a>
			</cfif>
		 	<cfif not listfindnocase(denied_pages,'training_management.popup_upd_train_announce')>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_upd_train_announce&announce_id=#attributes.announce_id#','page');"><img src="../../images/refer.gif" border="0" title="<cf_get_lang_main no ='52.Güncelle'>"></a>
		 	</cfif>
		 	<cfsavecontent variable="mail_message"><cf_get_lang no ='509.Mail Göndermek İstediğinizden Eminmisiniz'></cfsavecontent>
		 	<a href="##" onClick="javascript:if(confirm('#mail_message#')) window.location.href='#request.self#?fuseaction=training_management.popup_send_mail&announce_id=#attributes.announce_id#','medium'; else return false;"><img src="../../images/mail.gif" border="0" title="<cf_get_lang no ='494.Duyuru Listesindekilere Mail Gönder'>"></a>
		 	<a href="#request.self#?fuseaction=training_management.form_add_train_announce"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></a>
		 </cfoutput>
		</td>
	</tr>
</table>
 --->
<!--- Sayfa ana kısım  --->

	<cf_catalystHeader>
<div class="row">
	<div class="col col-9 col-xs-12 uniqueRow">
		<div class="row formContent">
			<cf_form_box>
			<!---Geniş alan: içerik---> 
			<div class="col col-12 col-xs-12" type="column" index="1" sort="true">
			<cfoutput>				  
					<div class="col col-12 col-xs-12">
						<div class="form-group col col-5 col-xs-12">
						<label class="col col-6 col-xs-12" style="font-weight:bold;"><cf_get_lang no='463.Potansiyel Katılımcı Sayısı'></label>
						<div class="col col-6 col-xs-12">#get_emp_req.employee#</div>
						</div>
					</div>
					<div class="col col-12 col-xs-12">
						<div class="form-group col col-5 col-xs-12">
						<label class="col col-6 col-xs-12" style="font-weight:bold;"><cf_get_lang_main no='1408.Başlık'></label>
						<div class="col col-6 col-xs-12">#get_announce_detail.announce_head#</div>
						</div>
					</div>
					<div class="col col-12 col-xs-12">
						<div class="form-group col col-5 col-xs-12">
						<label class="col col-6 col-xs-12" style="font-weight:bold;"><cf_get_lang_main no='89.Başlama'>-<cf_get_lang_main no='90.Bitiş'></label>
						<div class="col col-6 col-xs-12">#dateformat(get_announce_detail.start_date,dateformat_style)# - #dateformat(get_announce_detail.finish_date,dateformat_style)#</div>
						</div>
					</div>
					<div class="col col-12 col-xs-12">
						<div class="form-group col col-5 col-xs-12">
						<label class="col col-6 col-xs-12" style="font-weight:bold;"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-6 col-xs-12">#get_announce_detail.detail#</div>
						</div>
					</div>
					&nbsp;
					<hr />
			</cfoutput> 
			</div>
			<div class="row">
				<div class="col col-12 col-xs-12 uniqueRow">
					<div class="row formContent">
						<cf_form_list>
									<br>
									<th width="2%"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_list_training_classes&announce_id=<cfoutput>#attributes.announce_id#</cfoutput>','list');"><img src="images/plus_list.gif"></a></th>
									<th width="90%"><cf_get_lang no='464.İlişkili Eğitimler'></th>
									<th width="8%"><cf_get_lang_main no='1983.Katılımcı'></th>
								
								<cfif get_trainings.recordcount>
								<cfoutput query="get_trainings">
									<cfquery name="GET_EMP_ADD" datasource="#DSN#">
										SELECT COUNT(EMP_ID) AS TOTAL_EMP,COUNT(CON_ID) AS TOTAL_PAR,COUNT(PAR_ID) AS TOTAL_CON FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #CLASS_ID#
									</cfquery>
									<cfset total = get_emp_add.total_emp + get_emp_add.total_par + get_emp_add.total_con>
									<tr>
										<td><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_class_from_group&announce_class_id=#announce_class_id#','date');"><img src="images/delete_list.gif" border="0"></a></td>
										<td>#CLASS_NAME# (#dateformat(start_date,dateformat_style)#-#dateformat(finish_date,dateformat_style)#)</td>
										<td style="text-align:right;">#total#</td>
									</tr>
								</cfoutput>
								<cfelse>
									<tr>
										<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
									</tr>
								</cfif>
						
						</cf_form_list>
					</div>
				</div>
			</div>
			
		</cf_form_box>
		</div>
	</div>
			<div class="col col-3 col-xs-12 uniqueRow">
				<div class="row formContent">
				<!--- Yan kısım--->
				<!--- Varlıklar --->
				<cf_get_workcube_asset asset_cat_id="-6" module_id='9' action_section='ANNOUNCE_ID' action_id='#attributes.announce_id#'>
				<!--- Notlar --->
				<cf_get_workcube_note  action_section='ANNOUNCE_ID' action_id='#attributes.announce_id#'>
				</div>
			</div>

</div>

