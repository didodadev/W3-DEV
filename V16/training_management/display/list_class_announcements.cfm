<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset ga = createObject("component","V16.training_management.cfc.announce")/>
<cfif isDefined('attributes.form_submitted')>
    <cfset get_announce= ga.Select(keyword:attributes.keyword)/>
<cfelse>
	<cfset get_announce.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="announcument_search_area">
			<cfinput type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="Filtre"/>
				</div>
				<div class="form-group small" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(459,'Eğitim Duyuruları',46666)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th><cf_get_lang dictionary_id='58820.Başlık'></th>
					<th><cf_get_lang dictionary_id='46667.Yayın Tarihi'></th>				
					<th><cf_get_lang dictionary_id='46531.Eğitim Sayısı'></th>								
					<!-- sil --> <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_class_announcements&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil --> 

				</tr>
			</thead>
			<tbody
				<cfif get_announce.recordCount>
					<cfset attributes.totalrecords = get_announce.recordcount>
					<cfoutput query="get_announce" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td width="35">#currentrow#</td>
							<td><a  class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_announcements&event=upd&announce_id=#ANNOUNCE_ID#">#ANNOUNCE_HEAD#</a></td>
							<td>#dateformat(START_DATE,dateformat_style)# - #dateformat(FINISH_DATE,dateformat_style)#</td>
							<td>
								<cfset get_class_num= ga.SELECTCOUNT(ANNOUNCE_ID:get_announce.ANNOUNCE_ID)/>
								#get_class_num.TOT#
							</td>
							<!-- sil -->
							<td align="center"><a href="#request.self#?fuseaction=training_management.list_class_announcements&event=upd&announce_id=#ANNOUNCE_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="5"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "">
    <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
        <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction#&#url_str#"> 
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
