<cfif isdefined('session.pp.userid')>
<cfset cmp = createObject("component","worknet.objects.messages") />
<cfset getMessage = cmp.getMessage(msg_id:attributes.msg_id) />
	<cfif getMessage.recordcount>
		<cfset updMessage = cmp.updMessage(msg_id:attributes.msg_id,is_read:1) />
		<cfoutput>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cf_get_lang no='99.MESAJLARIM'></h1></div>
			</div>
			<div class="mesaj">
				<div class="mesaj_1">
					<cfform name="search_" action="#request.self#?fuseaction=worknet.inbox" method="post">
						<div class="mesaj_11">
							<input class="mesaj_11_txt" type="text" name="keyword" id="keyword" value="" style="border:0;"/>
							<input class="mesaj_11_btn" type="submit" name="" value="" style=" border:none;">
						</div>
					</cfform>
				   <div class="mesaj_12">
				   		<a class="m_12_ym" href="sent_message"><cf_get_lang no='188.Yeni Mesaj'></a>
						<a class="m_12_gm" href="inbox"><cf_get_lang_main no='1562.Gelen'></a>
						<a class="m_12_gg" href="sentbox"><cf_get_lang no='30.Gönderilmis'></a>	
						<a class="m_12_gg" href="trash"><cf_get_lang no='34.Silinmis'></a>	
					</div>
				</div>
				<div class="mesaj_2">
					<div class="mesaj_21">
						<div class="mesaj_212"><cfif getMessage.message_type eq 1 and getMessage.sender_id eq session.pp.userid><cf_get_lang_main no='512.Kime'><cfelse><cf_get_lang no='41.Kimden'></cfif></div>
						<div class="mesaj_212"><cf_get_lang_main no='330.Tarih'></div>
						<div class="mesaj_213"><cf_get_lang_main no='68.Konu'></div>
						<div class="mesaj_211"><cf_get_lang_main no='131.Mesaj'></div>
					</div>
					<div class="mesaj_23">
						<div class="mesaj_231"><cfif getMessage.message_type eq 1 and getMessage.sender_id eq session.pp.userid>#getMessage.receiver_name#<cfelse>#getMessage.sender_name#</cfif></div>
						<div class="mesaj_231">#dateformat(date_add('h',session_base.time_zone,getMessage.sent_date),dateformat_style)#&nbsp; #timeformat(date_add('h',session_base.time_zone,getMessage.sent_date),timeformat_style)#</div>
						<div class="mesaj_232">#getMessage.subject#</div>
						<div class="mesaj_233"><pre>#getMessage.body#</pre></div>
						<cfif getMessage.sender_id neq session.pp.userid>
							<div class="mesaj_234"><a href="#request.self#?fuseaction=worknet.sent_message&member_id=#getMessage.sender_id#&msg_id=#getMessage.msg_id#"><cf_get_lang_main no='1744.Cevapla'></a></div>
						</cfif>
					</div>
				</div>
			</div>
		</div>
		</cfoutput>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<cfelseif isdefined("session.ww.userid")>

	<script>

		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');

		history.back();

	</script>

	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
