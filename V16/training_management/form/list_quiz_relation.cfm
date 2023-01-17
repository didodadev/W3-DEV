<cfparam name="attributes.keyword" default="">
<cfquery name="get_quizs" datasource="#DSN#">
	SELECT 
		QUIZ_ID, 
		TRAINING_ID, 
		QUIZ_HEAD,
		CLASS_ID
	FROM 
		QUIZ
	WHERE
		QUIZ_ID IS NOT NULL 
		<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
		AND QUIZ_ID NOT IN(SELECT QUIZ_ID FROM QUIZ_RELATION WHERE CLASS_ID = #attributes.class_id#)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			QUIZ_HEAD LIKE '%#attributes.keyword#%' OR
			QUIZ_OBJECTIVE LIKE '%#attributes.keyword#%'
		)
		</cfif>
</cfquery>
<cfif isdefined("attributes.qid")>
	<cfquery name="get_control" datasource="#dsn#">
		SELECT QR.QUIZ_ID FROM QUIZ Q,QUIZ_RELATION QR WHERE Q.QUIZ_ID = QR.QUIZ_ID AND QR.CLASS_ID = #attributes.class_id# 
	</cfquery>
	<cfif isdefined('attributes.xml_is_quiz_add') and attributes.xml_is_quiz_add eq 1 and get_control.recordcount><!--- eğitimden geliyorsa ve eğitim detayındaki xml de sadece 1 adet eklenebilsin seçili ise bu kontrole girer SG20120717--->
		<script type="text/javascript">
			{
				alert("<cf_get_lang no='508.Eğitime Bağlı 1 tane test ekleyebilirsiniz'>");
				history.go(-1);
			}
		</script>	
	<cfelse>	
		<cfinclude template="../query/add_quiz_relation.cfm">
		<script type="text/javascript">
			opener.location.reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset sayac=0>
<cfset adres="">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isDefined("attributes.train_id") and len(attributes.train_id)>
	<cfset adres = adres&"&train_id="&attributes.train_id>
</cfif>
<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
	<cfset adres = adres&"&class_id="&attributes.class_id>
</cfif>
<cfif isDefined("attributes.xml_is_quiz_add") and len(attributes.xml_is_quiz_add)>
	<cfset adres = adres&"&xml_is_quiz_add="&attributes.xml_is_quiz_add>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform method="post" action="">
<input type="hidden" name="xml_is_quiz_add" id="xml_is_quiz_add" value="<cfif isdefined("attributes.xml_is_quiz_add")><cfoutput>#attributes.xml_is_quiz_add#</cfoutput></cfif>">
	<cf_big_list_search title="#getLang('main',639)#">
		<cf_big_list_search_area>
			<div class="row form-inline">
				<div class="form-group" id="item-keyword">
					<div class="input-group x-12">	
						<!--- eğitim detayından geliyorsa ve xmldeki kayıt sayısı kontrolü için eklendi SG20120717--->
						<cfinput type="text" name="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="255">
					</div>
				</div>	
				<div class="form-group x-3_5"> 
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button>
				</div>
			</div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th>
				<cf_get_lang_main no='639.testler'>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfif get_quizs.recordcount>
			<cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>
					<!---<cfif isdefined("attributes.training_id")>
						<a href="#request.self#?fuseaction=training_management.popup_list_quiz_relation&training_id=#url.training_id#&QUIZ_HEAD=#QUIZ_HEAD#&qid=#QUIZ_ID##adres#" class="tableyazi">#QUIZ_HEAD#</a>
					<cfelseif isdefined("attributes.class_id")>--->
						<a href="#request.self#?fuseaction=training_management.popup_list_quiz_relation&QUIZ_HEAD=#QUIZ_HEAD#&qid=#QUIZ_ID##adres#" class="tableyazi">#QUIZ_HEAD#</a>
					<!---</cfif>--->
				</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif get_quizs.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center">
		<tr>
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_list_quiz_relation#adres#"> </td>
			<!-- sil --><td height="35" style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
		</tr>
	</table>
</cfif>
