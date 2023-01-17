<cfif isDefined("attributes.training_sec_id") and len(attributes.training_sec_id)>
	<cfquery name="get_class_ids" datasource="#dsn#">
		SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfquery>
	<cfif get_class_ids.recordcount>
		<cfset class_ids = valuelist(get_class_ids.CLASS_ID)>
	</cfif>
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.action_id") and len(attributes.action_id)>
		AND CLASS_ID = #attributes.action_id#
	</cfif>
	<cfif isDefined("attributes.online") and len(attributes.online)>
		AND ONLINE = #attributes.ONLINE#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%')
	</cfif>
	<!---<cfif isdefined("attributes.TRAIN_ID")> AND TRAINING_ID = #attributes.TRAIN_ID# </cfif>--->
	<cfif isdefined("attributes.training_sec_id") and get_class_ids.recordcount>
	    AND	CLASS_ID IN (#class_ids#)
	</cfif> 	
	<cfif isDefined("attributes.date1") and len(attributes.date1)>
		<cf_date tarih='attributes.date1'>
		AND	START_DATE >= #attributes.date1#
	</cfif>
	<cfif isdefined("attributes.training_sec_id")>
	   AND TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
</cfquery>

<cfquery name="get_training_poscats_departments" datasource="#dsn#">
		SELECT 
			TRAIN_POSITION_CATS, 
			TRAIN_DEPARTMENTS
		FROM 
			TRAINING WHERE TRAIN_ID
		IN 
			(
				SELECT 
					TRAIN_ID
				FROM 
					TRAINING_CLASS_SECTIONS 
				WHERE 
					CLASS_ID = #attributes.action_id#
			)
</cfquery>
	
<cfset attributes.training_id = get_class.training_id>
<cfif len(get_class.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>
<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td class="headbold"><cf_get_lang dictionary_id='46624.Eğitmen Görev Bildirim Yazısı'></td>
	</tr>
</table>
<br/>
<table width="650" border="0" align="center">
	<cfoutput>
	<tr>
		<td width="180" height="22" class="txtbold"><cf_get_lang dictionary_id='31090.Eğitimin Adı'></td>
		<td>: #get_class.class_name#</td>
	</tr>
	<tr>
		<td height="22" class="txtbold"><cf_get_lang_main no='243.Başlangıç Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td> :
		<cfif len(get_class.start_date)>
			#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#
		</cfif>
		</td>
	</tr>
	<tr>
		<td height="22" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td>:
		<cfif len(get_class.finish_date)>
			 #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#
		</cfif>
		</td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang dictionary_id='46237.Eğitim Yeri Adresi'>/ <cf_get_lang_main no='87.Telefon'></td>
		<td valign="top">: <strong>#get_class.CLASS_PLACE#</strong> - #get_class.CLASS_PLACE_ADDRESS# - #get_class.CLASS_PLACE_TEL#</td>
	</tr>
	<tr>
		<td height="22" class="txtbold"><cf_get_lang dictionary_id='46180.Eğitim Yeri Sorumlusu'></td>
		<td>: #get_class.CLASS_PLACE_MANAGER#</td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang dictionary_id='46634.Ders İçeriği'></td>
		<td>: #ParagraphFormat(get_class.class_objective)#</td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang dictionary_id='46408.Açıklamalar'></td>
		<td>:<cf_get_lang dictionary_id='46372.Katılımcıların Eğitimden En Az 15 dk Öncesinde Eğitim Yerinde Bulunmaları Gerekmektedir Eğitimlerde Kıyafet Serbesttir'></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" valign="top" class="txtbold"> 
		<cf_get_lang dictionary_id='46409.Yukarıda Belirtilen Bilgiler Doğrultusunda İlgili Tarih ve Saatlerde Eğitim Yerinde Bulunmanızı Rica Ederiz'>
		  
		</td>
	</tr>
	</cfoutput>
</table>

